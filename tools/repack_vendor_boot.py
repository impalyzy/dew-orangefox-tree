#!/usr/bin/env python3
"""Swap ONLY the recovery ramdisk fragment inside a stock vendor_boot (header v4).

usage: repack_vendor_boot.py stock_vendor_boot.img new_recovery_ramdisk out.img

new_recovery_ramdisk may be a raw cpio (gets gzip'd), an already compressed ramdisk,
or a whole vendor_boot.img built by OrangeFox (its recovery fragment is taken).
The platform fragment (kernel modules + fstab), dtb, cmdline and header fields are kept as-is.
"""
import struct, sys, gzip

def up(x, ps): return (x + ps - 1) // ps * ps

def parse(d):
    assert d[:8] == b'VNDRBOOT', 'not a vendor_boot image'
    ver, ps = struct.unpack('<II', d[8:16])
    assert ver == 4, f'header v{ver} not supported (need v4)'
    vrs = struct.unpack('<I', d[24:28])[0]
    hs, dts = struct.unpack('<II', d[2096:2104])
    tsz, tn, esz, bcs = struct.unpack('<IIII', d[2112:2128])
    rd = up(hs, ps); dtb = rd + up(vrs, ps); tbl = dtb + up(dts, ps); bc = tbl + up(tsz, ps)
    ents = []
    for i in range(tn):
        o = tbl + i * esz
        sz, off, typ = struct.unpack('<III', d[o:o+12])
        ents.append(dict(raw=bytearray(d[o:o+esz]), size=sz, off=off, type=typ))
    return dict(ps=ps, hs=hs, dts=dts, tsz=tsz, esz=esz, bcs=bcs, rd=rd, dtb=dtb, tbl=tbl, bc=bc, vrs=vrs, ents=ents)

def main(stock, newrd, out):
    d = open(stock, 'rb').read()
    p = parse(d)
    frags = [d[p['rd'] + e['off']: p['rd'] + e['off'] + e['size']] for e in p['ents']]
    rec = [i for i, e in enumerate(p['ents']) if e['type'] == 2]
    assert len(rec) == 1, 'expected exactly one recovery fragment'
    new = open(newrd, 'rb').read()
    if new[:8] == b'VNDRBOOT':  # a whole vendor_boot built by OrangeFox: take its recovery fragment
        q = parse(new)
        r = [e for e in q['ents'] if e['type'] == 2]
        assert len(r) == 1, 'built vendor_boot has no single recovery fragment'
        new = new[q['rd'] + r[0]['off']: q['rd'] + r[0]['off'] + r[0]['size']]
    if new[:6] == b'070701':
        new = gzip.compress(new, 9)
    frags[rec[0]] = new
    ps = p['ps']
    off = 0
    for e, f in zip(p['ents'], frags):
        e['off'], e['size'] = off, len(f); off += len(f)
    ramdisk = b''.join(frags)
    hdr = bytearray(d[:p['hs']])
    hdr[24:28] = struct.pack('<I', len(ramdisk))
    pad = lambda b: b + b'\0' * (up(len(b), ps) - len(b))
    table = b''
    for e in p['ents']:
        raw = bytearray(e['raw']); raw[0:8] = struct.pack('<II', e['size'], e['off']); table += bytes(raw)
    img = (pad(bytes(hdr)) + pad(ramdisk) + pad(d[p['dtb']:p['dtb'] + p['dts']]) + pad(table)
           + pad(d[p['bc']:p['bc'] + p['bcs']] if p['bcs'] else b''))
    open(out, 'wb').write(img)
    print(f'wrote {out}: {len(img)} bytes; recovery fragment {len(new)} bytes; total ramdisk {len(ramdisk)}')

if __name__ == '__main__':
    if len(sys.argv) != 4: sys.exit(__doc__)
    main(*sys.argv[1:])
