"""Pulls the five VP6-alpha fog videos out of mapGraphics.swf as .flv files.
Usage: extract_fog.py <mapGraphics.swf> <out_dir>  -> prints area,cid,tx,ty per video"""
import zlib,struct,sys,os
swf,out=sys.argv[1],sys.argv[2]
b=open(swf,'rb').read(); data=b[:8]+zlib.decompress(b[8:])
nbits=data[8]>>3; pos=8+(5+4*nbits+7)//8+4
def tags(d,p,end):
    while p<end:
        h=struct.unpack('<H',d[p:p+2])[0]; p+=2; t=h>>6; l=h&0x3f
        if l==0x3f: l=struct.unpack('<I',d[p:p+4])[0]; p+=4
        yield t,d[p:p+l]; p+=l
        if t==0: return
SPRITE_TO_AREA={41:'area3MC',43:'area6MC',45:'area2MC',47:'area4MC',49:'area5MC'}
def flv(frames,w,h):
    o=bytearray(b'FLV\x01\x01\x00\x00\x00\x09\x00\x00\x00\x00')
    for n,vd in enumerate(frames):
        # SWF VP6 alpha packet = OffsetToAlpha(UI24)+data+alpha; FLV adds the adjustment byte.
        key = (vd[3] & 0x80) == 0
        body=bytes([(0x10 if key else 0x20)|5, 0])+vd
        ts=n*1000//12
        o+=bytes([9])+len(body).to_bytes(3,'big')+(ts&0xffffff).to_bytes(3,'big')+bytes([ts>>24])+b'\0\0\0'+body
        o+=(11+len(body)).to_bytes(4,'big')
    return bytes(o)
for t,body in tags(data,pos,len(data)):
    if t!=39: continue
    cid=struct.unpack('<H',body[:2])[0]
    if cid not in SPRITE_TO_AREA: continue
    vids=[sb[4:] for st,sb in tags(body,4,len(body)) if st==61]
    name=SPRITE_TO_AREA[cid]
    open(os.path.join(out,name+'.flv'),'wb').write(flv(vids,0,0))
    print(name,cid,len(vids))
