"""Give a TTF a new family name, so lime registers it under that name.

lime names an embedded font by its family name (name ID 1), so a bold face such as Windows'
arialbd.ttf registers as "Arial" and replaces the regular face. This rewrites name IDs 1 and 4
to the new family, sets ID 2 (subfamily) to "Regular", drops ID 16/17 (typographic family and
subfamily, which would still say "Arial"/"Bold"), and fixes the checksums.

Usage: python -I tools/rename_font_family.py <in.ttf> <out.ttf> "<New Family>"
"""
import struct
import sys


def checksum(data):
    data = data + b"\0" * (-len(data) % 4)
    return sum(struct.unpack(">%dI" % (len(data) // 4), data)) & 0xFFFFFFFF


def build_name_table(old, family):
    fmt, count, string_offset = struct.unpack(">HHH", old[:6])
    records = []
    for i in range(count):
        pid, eid, lid, nid, length, offset = struct.unpack(">6H", old[6 + 12 * i:18 + 12 * i])
        raw = old[string_offset + offset:string_offset + offset + length]
        if nid in (16, 17):
            continue
        wide = pid == 0 or pid == 3
        replacement = {1: family, 2: "Regular", 4: family}.get(nid)
        if replacement is not None:
            raw = replacement.encode("utf-16-be" if wide else "latin-1")
        records.append((pid, eid, lid, nid, raw))
    records.sort(key=lambda r: r[:4])
    header = struct.pack(">HHH", 0, len(records), 6 + 12 * len(records))
    body = b""
    strings = b""
    for pid, eid, lid, nid, raw in records:
        body += struct.pack(">6H", pid, eid, lid, nid, len(raw), len(strings))
        strings += raw
    return header + body + strings


def main(src, dst, family):
    font = bytearray(open(src, "rb").read())
    num_tables = struct.unpack(">H", font[4:6])[0]
    entries = {}
    for i in range(num_tables):
        pos = 12 + 16 * i
        tag, _, offset, length = struct.unpack(">4sIII", font[pos:pos + 16])
        entries[tag] = (pos, offset, length)

    pos, offset, length = entries[b"name"]
    table = build_name_table(bytes(font[offset:offset + length]), family)
    font += b"\0" * (-len(font) % 4)
    new_offset = len(font)
    font += table
    font[pos + 4:pos + 16] = struct.pack(">III", checksum(table), new_offset, len(table))

    # head.checkSumAdjustment: zero it, sum the whole file, store 0xB1B0AFBA - sum.
    head_offset = entries[b"head"][1]
    font[head_offset + 8:head_offset + 12] = b"\0\0\0\0"
    _, _, head_len = entries[b"head"]
    head_pos = entries[b"head"][0]
    font[head_pos + 4:head_pos + 8] = struct.pack(">I", checksum(bytes(font[head_offset:head_offset + head_len])))
    adjust = (0xB1B0AFBA - checksum(bytes(font))) & 0xFFFFFFFF
    font[head_offset + 8:head_offset + 12] = struct.pack(">I", adjust)
    open(dst, "wb").write(bytes(font))


if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2], sys.argv[3])
