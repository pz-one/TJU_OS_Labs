
user/_nettests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <decode_qname>:

// Decode a DNS name
static void
decode_qname(char *qn, int max)
{
  char *qnMax = qn + max;
       0:	95aa                	add	a1,a1,a0
      break;
    for(int i = 0; i < l; i++) {
      *qn = *(qn+1);
      qn++;
    }
    *qn++ = '.';
       2:	02e00813          	li	a6,46
    if(qn >= qnMax){
       6:	02b56a63          	bltu	a0,a1,3a <decode_qname+0x3a>
{
       a:	1141                	addi	sp,sp,-16
       c:	e406                	sd	ra,8(sp)
       e:	e022                	sd	s0,0(sp)
      10:	0800                	addi	s0,sp,16
      printf("invalid DNS reply\n");
      12:	00001517          	auipc	a0,0x1
      16:	04e50513          	addi	a0,a0,78 # 1060 <malloc+0xe8>
      1a:	00001097          	auipc	ra,0x1
      1e:	ea6080e7          	jalr	-346(ra) # ec0 <printf>
      exit(1);
      22:	4505                	li	a0,1
      24:	00001097          	auipc	ra,0x1
      28:	b12080e7          	jalr	-1262(ra) # b36 <exit>
    *qn++ = '.';
      2c:	00160793          	addi	a5,a2,1
      30:	953e                	add	a0,a0,a5
      32:	01068023          	sb	a6,0(a3)
    if(qn >= qnMax){
      36:	fcb57ae3          	bgeu	a0,a1,a <decode_qname+0xa>
    int l = *qn;
      3a:	00054683          	lbu	a3,0(a0)
    if(l == 0)
      3e:	ce89                	beqz	a3,58 <decode_qname+0x58>
    for(int i = 0; i < l; i++) {
      40:	0006861b          	sext.w	a2,a3
      44:	96aa                	add	a3,a3,a0
    if(l == 0)
      46:	87aa                	mv	a5,a0
      *qn = *(qn+1);
      48:	0017c703          	lbu	a4,1(a5)
      4c:	00e78023          	sb	a4,0(a5)
      qn++;
      50:	0785                	addi	a5,a5,1
    for(int i = 0; i < l; i++) {
      52:	fed79be3          	bne	a5,a3,48 <decode_qname+0x48>
      56:	bfd9                	j	2c <decode_qname+0x2c>
      58:	8082                	ret

000000000000005a <ping>:
{
      5a:	7171                	addi	sp,sp,-176
      5c:	f506                	sd	ra,168(sp)
      5e:	f122                	sd	s0,160(sp)
      60:	ed26                	sd	s1,152(sp)
      62:	e94a                	sd	s2,144(sp)
      64:	e54e                	sd	s3,136(sp)
      66:	e152                	sd	s4,128(sp)
      68:	1900                	addi	s0,sp,176
      6a:	8a32                	mv	s4,a2
  if((fd = connect(dst, sport, dport)) < 0){
      6c:	862e                	mv	a2,a1
      6e:	85aa                	mv	a1,a0
      70:	0a000537          	lui	a0,0xa000
      74:	20250513          	addi	a0,a0,514 # a000202 <__global_pointer$+0x9ffe669>
      78:	00001097          	auipc	ra,0x1
      7c:	b5e080e7          	jalr	-1186(ra) # bd6 <connect>
      80:	08054663          	bltz	a0,10c <ping+0xb2>
      84:	89aa                	mv	s3,a0
  for(int i = 0; i < attempts; i++) {
      86:	4481                	li	s1,0
    if(write(fd, obuf, strlen(obuf)) < 0){
      88:	00001917          	auipc	s2,0x1
      8c:	00890913          	addi	s2,s2,8 # 1090 <malloc+0x118>
  for(int i = 0; i < attempts; i++) {
      90:	03405463          	blez	s4,b8 <ping+0x5e>
    if(write(fd, obuf, strlen(obuf)) < 0){
      94:	854a                	mv	a0,s2
      96:	00001097          	auipc	ra,0x1
      9a:	87c080e7          	jalr	-1924(ra) # 912 <strlen>
      9e:	0005061b          	sext.w	a2,a0
      a2:	85ca                	mv	a1,s2
      a4:	854e                	mv	a0,s3
      a6:	00001097          	auipc	ra,0x1
      aa:	ab0080e7          	jalr	-1360(ra) # b56 <write>
      ae:	06054d63          	bltz	a0,128 <ping+0xce>
  for(int i = 0; i < attempts; i++) {
      b2:	2485                	addiw	s1,s1,1
      b4:	fe9a10e3          	bne	s4,s1,94 <ping+0x3a>
  int cc = read(fd, ibuf, sizeof(ibuf)-1);
      b8:	07f00613          	li	a2,127
      bc:	f5040593          	addi	a1,s0,-176
      c0:	854e                	mv	a0,s3
      c2:	00001097          	auipc	ra,0x1
      c6:	a8c080e7          	jalr	-1396(ra) # b4e <read>
      ca:	84aa                	mv	s1,a0
  if(cc < 0){
      cc:	06054c63          	bltz	a0,144 <ping+0xea>
  close(fd);
      d0:	854e                	mv	a0,s3
      d2:	00001097          	auipc	ra,0x1
      d6:	a8c080e7          	jalr	-1396(ra) # b5e <close>
  ibuf[cc] = '\0';
      da:	fd048793          	addi	a5,s1,-48
      de:	008784b3          	add	s1,a5,s0
      e2:	f8048023          	sb	zero,-128(s1)
  if(strcmp(ibuf, "this is the host!") != 0){
      e6:	00001597          	auipc	a1,0x1
      ea:	ff258593          	addi	a1,a1,-14 # 10d8 <malloc+0x160>
      ee:	f5040513          	addi	a0,s0,-176
      f2:	00000097          	auipc	ra,0x0
      f6:	7f4080e7          	jalr	2036(ra) # 8e6 <strcmp>
      fa:	e13d                	bnez	a0,160 <ping+0x106>
}
      fc:	70aa                	ld	ra,168(sp)
      fe:	740a                	ld	s0,160(sp)
     100:	64ea                	ld	s1,152(sp)
     102:	694a                	ld	s2,144(sp)
     104:	69aa                	ld	s3,136(sp)
     106:	6a0a                	ld	s4,128(sp)
     108:	614d                	addi	sp,sp,176
     10a:	8082                	ret
    fprintf(2, "ping: connect() failed\n");
     10c:	00001597          	auipc	a1,0x1
     110:	f6c58593          	addi	a1,a1,-148 # 1078 <malloc+0x100>
     114:	4509                	li	a0,2
     116:	00001097          	auipc	ra,0x1
     11a:	d7c080e7          	jalr	-644(ra) # e92 <fprintf>
    exit(1);
     11e:	4505                	li	a0,1
     120:	00001097          	auipc	ra,0x1
     124:	a16080e7          	jalr	-1514(ra) # b36 <exit>
      fprintf(2, "ping: send() failed\n");
     128:	00001597          	auipc	a1,0x1
     12c:	f8058593          	addi	a1,a1,-128 # 10a8 <malloc+0x130>
     130:	4509                	li	a0,2
     132:	00001097          	auipc	ra,0x1
     136:	d60080e7          	jalr	-672(ra) # e92 <fprintf>
      exit(1);
     13a:	4505                	li	a0,1
     13c:	00001097          	auipc	ra,0x1
     140:	9fa080e7          	jalr	-1542(ra) # b36 <exit>
    fprintf(2, "ping: recv() failed\n");
     144:	00001597          	auipc	a1,0x1
     148:	f7c58593          	addi	a1,a1,-132 # 10c0 <malloc+0x148>
     14c:	4509                	li	a0,2
     14e:	00001097          	auipc	ra,0x1
     152:	d44080e7          	jalr	-700(ra) # e92 <fprintf>
    exit(1);
     156:	4505                	li	a0,1
     158:	00001097          	auipc	ra,0x1
     15c:	9de080e7          	jalr	-1570(ra) # b36 <exit>
    fprintf(2, "ping didn't receive correct payload\n");
     160:	00001597          	auipc	a1,0x1
     164:	f9058593          	addi	a1,a1,-112 # 10f0 <malloc+0x178>
     168:	4509                	li	a0,2
     16a:	00001097          	auipc	ra,0x1
     16e:	d28080e7          	jalr	-728(ra) # e92 <fprintf>
    exit(1);
     172:	4505                	li	a0,1
     174:	00001097          	auipc	ra,0x1
     178:	9c2080e7          	jalr	-1598(ra) # b36 <exit>

000000000000017c <dns>:
  }
}

static void
dns()
{
     17c:	7119                	addi	sp,sp,-128
     17e:	fc86                	sd	ra,120(sp)
     180:	f8a2                	sd	s0,112(sp)
     182:	f4a6                	sd	s1,104(sp)
     184:	f0ca                	sd	s2,96(sp)
     186:	ecce                	sd	s3,88(sp)
     188:	e8d2                	sd	s4,80(sp)
     18a:	e4d6                	sd	s5,72(sp)
     18c:	e0da                	sd	s6,64(sp)
     18e:	fc5e                	sd	s7,56(sp)
     190:	f862                	sd	s8,48(sp)
     192:	f466                	sd	s9,40(sp)
     194:	f06a                	sd	s10,32(sp)
     196:	ec6e                	sd	s11,24(sp)
     198:	0100                	addi	s0,sp,128
     19a:	82010113          	addi	sp,sp,-2016
  uint8 ibuf[N];
  uint32 dst;
  int fd;
  int len;

  memset(obuf, 0, N);
     19e:	3e800613          	li	a2,1000
     1a2:	4581                	li	a1,0
     1a4:	ba840513          	addi	a0,s0,-1112
     1a8:	00000097          	auipc	ra,0x0
     1ac:	794080e7          	jalr	1940(ra) # 93c <memset>
  memset(ibuf, 0, N);
     1b0:	3e800613          	li	a2,1000
     1b4:	4581                	li	a1,0
     1b6:	77fd                	lui	a5,0xfffff
     1b8:	7c078793          	addi	a5,a5,1984 # fffffffffffff7c0 <__global_pointer$+0xffffffffffffdc27>
     1bc:	00f40533          	add	a0,s0,a5
     1c0:	00000097          	auipc	ra,0x0
     1c4:	77c080e7          	jalr	1916(ra) # 93c <memset>
  
  // 8.8.8.8: google's name server
  dst = (8 << 24) | (8 << 16) | (8 << 8) | (8 << 0);

  if((fd = connect(dst, 10000, 53)) < 0){
     1c8:	03500613          	li	a2,53
     1cc:	6589                	lui	a1,0x2
     1ce:	71058593          	addi	a1,a1,1808 # 2710 <__global_pointer$+0xb77>
     1d2:	08081537          	lui	a0,0x8081
     1d6:	80850513          	addi	a0,a0,-2040 # 8080808 <__global_pointer$+0x807ec6f>
     1da:	00001097          	auipc	ra,0x1
     1de:	9fc080e7          	jalr	-1540(ra) # bd6 <connect>
     1e2:	777d                	lui	a4,0xfffff
     1e4:	7a870713          	addi	a4,a4,1960 # fffffffffffff7a8 <__global_pointer$+0xffffffffffffdc0f>
     1e8:	9722                	add	a4,a4,s0
     1ea:	e308                	sd	a0,0(a4)
     1ec:	02054c63          	bltz	a0,224 <dns+0xa8>
  hdr->id = htons(6828);
     1f0:	77ed                	lui	a5,0xffffb
     1f2:	c1a78793          	addi	a5,a5,-998 # ffffffffffffac1a <__global_pointer$+0xffffffffffff9081>
     1f6:	baf41423          	sh	a5,-1112(s0)
  hdr->rd = 1;
     1fa:	baa45783          	lhu	a5,-1110(s0)
     1fe:	0017e793          	ori	a5,a5,1
     202:	baf41523          	sh	a5,-1110(s0)
  hdr->qdcount = htons(1);
     206:	10000793          	li	a5,256
     20a:	baf41623          	sh	a5,-1108(s0)
  for(char *c = host; c < host+strlen(host)+1; c++) {
     20e:	00001497          	auipc	s1,0x1
     212:	f0a48493          	addi	s1,s1,-246 # 1118 <malloc+0x1a0>
  char *l = host; 
     216:	8a26                	mv	s4,s1
  for(char *c = host; c < host+strlen(host)+1; c++) {
     218:	bb440a93          	addi	s5,s0,-1100
     21c:	8926                	mv	s2,s1
    if(*c == '.') {
     21e:	02e00993          	li	s3,46
  for(char *c = host; c < host+strlen(host)+1; c++) {
     222:	a82d                	j	25c <dns+0xe0>
    fprintf(2, "ping: connect() failed\n");
     224:	00001597          	auipc	a1,0x1
     228:	e5458593          	addi	a1,a1,-428 # 1078 <malloc+0x100>
     22c:	4509                	li	a0,2
     22e:	00001097          	auipc	ra,0x1
     232:	c64080e7          	jalr	-924(ra) # e92 <fprintf>
    exit(1);
     236:	4505                	li	a0,1
     238:	00001097          	auipc	ra,0x1
     23c:	8fe080e7          	jalr	-1794(ra) # b36 <exit>
        *qn++ = *d;
     240:	0705                	addi	a4,a4,1
     242:	0007c683          	lbu	a3,0(a5)
     246:	fed70fa3          	sb	a3,-1(a4)
      for(char *d = l; d < c; d++) {
     24a:	0785                	addi	a5,a5,1
     24c:	fef49ae3          	bne	s1,a5,240 <dns+0xc4>
        *qn++ = *d;
     250:	41448ab3          	sub	s5,s1,s4
     254:	9ab2                	add	s5,s5,a2
      l = c+1; // skip .
     256:	00148a13          	addi	s4,s1,1
  for(char *c = host; c < host+strlen(host)+1; c++) {
     25a:	0485                	addi	s1,s1,1
     25c:	854a                	mv	a0,s2
     25e:	00000097          	auipc	ra,0x0
     262:	6b4080e7          	jalr	1716(ra) # 912 <strlen>
     266:	02051793          	slli	a5,a0,0x20
     26a:	9381                	srli	a5,a5,0x20
     26c:	0785                	addi	a5,a5,1
     26e:	97ca                	add	a5,a5,s2
     270:	02f4f363          	bgeu	s1,a5,296 <dns+0x11a>
    if(*c == '.') {
     274:	0004c783          	lbu	a5,0(s1)
     278:	ff3791e3          	bne	a5,s3,25a <dns+0xde>
      *qn++ = (char) (c-l);
     27c:	001a8613          	addi	a2,s5,1
     280:	414487b3          	sub	a5,s1,s4
     284:	00fa8023          	sb	a5,0(s5)
      for(char *d = l; d < c; d++) {
     288:	009a7563          	bgeu	s4,s1,292 <dns+0x116>
     28c:	87d2                	mv	a5,s4
      *qn++ = (char) (c-l);
     28e:	8732                	mv	a4,a2
     290:	bf45                	j	240 <dns+0xc4>
     292:	8ab2                	mv	s5,a2
     294:	b7c9                	j	256 <dns+0xda>
  *qn = '\0';
     296:	000a8023          	sb	zero,0(s5)
  len += strlen(qname) + 1;
     29a:	bb440513          	addi	a0,s0,-1100
     29e:	00000097          	auipc	ra,0x0
     2a2:	674080e7          	jalr	1652(ra) # 912 <strlen>
     2a6:	0005049b          	sext.w	s1,a0
  struct dns_question *h = (struct dns_question *) (qname+strlen(qname)+1);
     2aa:	bb440513          	addi	a0,s0,-1100
     2ae:	00000097          	auipc	ra,0x0
     2b2:	664080e7          	jalr	1636(ra) # 912 <strlen>
     2b6:	02051793          	slli	a5,a0,0x20
     2ba:	9381                	srli	a5,a5,0x20
     2bc:	0785                	addi	a5,a5,1
     2be:	bb440713          	addi	a4,s0,-1100
     2c2:	97ba                	add	a5,a5,a4
  h->qtype = htons(0x1);
     2c4:	00078023          	sb	zero,0(a5)
     2c8:	4705                	li	a4,1
     2ca:	00e780a3          	sb	a4,1(a5)
  h->qclass = htons(0x1);
     2ce:	00078123          	sb	zero,2(a5)
     2d2:	00e781a3          	sb	a4,3(a5)
  }

  len = dns_req(obuf);
  
  if(write(fd, obuf, len) < 0){
     2d6:	0114861b          	addiw	a2,s1,17
     2da:	ba840593          	addi	a1,s0,-1112
     2de:	77fd                	lui	a5,0xfffff
     2e0:	7a878793          	addi	a5,a5,1960 # fffffffffffff7a8 <__global_pointer$+0xffffffffffffdc0f>
     2e4:	97a2                	add	a5,a5,s0
     2e6:	6388                	ld	a0,0(a5)
     2e8:	00001097          	auipc	ra,0x1
     2ec:	86e080e7          	jalr	-1938(ra) # b56 <write>
     2f0:	12054c63          	bltz	a0,428 <dns+0x2ac>
    fprintf(2, "dns: send() failed\n");
    exit(1);
  }
  int cc = read(fd, ibuf, sizeof(ibuf));
     2f4:	3e800613          	li	a2,1000
     2f8:	77fd                	lui	a5,0xfffff
     2fa:	7c078793          	addi	a5,a5,1984 # fffffffffffff7c0 <__global_pointer$+0xffffffffffffdc27>
     2fe:	00f405b3          	add	a1,s0,a5
     302:	77fd                	lui	a5,0xfffff
     304:	7a878793          	addi	a5,a5,1960 # fffffffffffff7a8 <__global_pointer$+0xffffffffffffdc0f>
     308:	97a2                	add	a5,a5,s0
     30a:	6388                	ld	a0,0(a5)
     30c:	00001097          	auipc	ra,0x1
     310:	842080e7          	jalr	-1982(ra) # b4e <read>
     314:	8a2a                	mv	s4,a0
  if(cc < 0){
     316:	12054763          	bltz	a0,444 <dns+0x2c8>
  if(cc < sizeof(struct dns)){
     31a:	0005079b          	sext.w	a5,a0
     31e:	472d                	li	a4,11
     320:	14f77063          	bgeu	a4,a5,460 <dns+0x2e4>
  if(!hdr->qr) {
     324:	77fd                	lui	a5,0xfffff
     326:	7c278793          	addi	a5,a5,1986 # fffffffffffff7c2 <__global_pointer$+0xffffffffffffdc29>
     32a:	97a2                	add	a5,a5,s0
     32c:	00078783          	lb	a5,0(a5)
     330:	1407d563          	bgez	a5,47a <dns+0x2fe>
  if(hdr->id != htons(6828)){
     334:	77fd                	lui	a5,0xfffff
     336:	7c078793          	addi	a5,a5,1984 # fffffffffffff7c0 <__global_pointer$+0xffffffffffffdc27>
     33a:	97a2                	add	a5,a5,s0
     33c:	0007d703          	lhu	a4,0(a5)
     340:	0007069b          	sext.w	a3,a4
     344:	67ad                	lui	a5,0xb
     346:	c1a78793          	addi	a5,a5,-998 # ac1a <__global_pointer$+0x9081>
     34a:	16f69263          	bne	a3,a5,4ae <dns+0x332>
  if(hdr->rcode != 0) {
     34e:	777d                	lui	a4,0xfffff
     350:	7c370793          	addi	a5,a4,1987 # fffffffffffff7c3 <__global_pointer$+0xffffffffffffdc2a>
     354:	97a2                	add	a5,a5,s0
     356:	0007c783          	lbu	a5,0(a5)
     35a:	8bbd                	andi	a5,a5,15
     35c:	16079d63          	bnez	a5,4d6 <dns+0x35a>
// endianness support
//

static inline uint16 bswaps(uint16 val)
{
  return (((val & 0x00ffU) << 8) |
     360:	7c470793          	addi	a5,a4,1988
     364:	97a2                	add	a5,a5,s0
     366:	0007d783          	lhu	a5,0(a5)
     36a:	0087971b          	slliw	a4,a5,0x8
     36e:	83a1                	srli	a5,a5,0x8
     370:	8fd9                	or	a5,a5,a4
  for(int i =0; i < ntohs(hdr->qdcount); i++) {
     372:	17c2                	slli	a5,a5,0x30
     374:	93c1                	srli	a5,a5,0x30
     376:	4981                	li	s3,0
  len = sizeof(struct dns);
     378:	44b1                	li	s1,12
  char *qname = 0;
     37a:	4901                	li	s2,0
  for(int i =0; i < ntohs(hdr->qdcount); i++) {
     37c:	c3b9                	beqz	a5,3c2 <dns+0x246>
    char *qn = (char *) (ibuf+len);
     37e:	7afd                	lui	s5,0xfffff
     380:	7c0a8793          	addi	a5,s5,1984 # fffffffffffff7c0 <__global_pointer$+0xffffffffffffdc27>
     384:	97a2                	add	a5,a5,s0
     386:	00978933          	add	s2,a5,s1
    decode_qname(qn, cc - len);
     38a:	409a05bb          	subw	a1,s4,s1
     38e:	854a                	mv	a0,s2
     390:	00000097          	auipc	ra,0x0
     394:	c70080e7          	jalr	-912(ra) # 0 <decode_qname>
    len += strlen(qn)+1;
     398:	854a                	mv	a0,s2
     39a:	00000097          	auipc	ra,0x0
     39e:	578080e7          	jalr	1400(ra) # 912 <strlen>
    len += sizeof(struct dns_question);
     3a2:	2515                	addiw	a0,a0,5
     3a4:	9ca9                	addw	s1,s1,a0
  for(int i =0; i < ntohs(hdr->qdcount); i++) {
     3a6:	2985                	addiw	s3,s3,1
     3a8:	7c4a8793          	addi	a5,s5,1988
     3ac:	97a2                	add	a5,a5,s0
     3ae:	0007d783          	lhu	a5,0(a5)
     3b2:	0087971b          	slliw	a4,a5,0x8
     3b6:	83a1                	srli	a5,a5,0x8
     3b8:	8fd9                	or	a5,a5,a4
     3ba:	17c2                	slli	a5,a5,0x30
     3bc:	93c1                	srli	a5,a5,0x30
     3be:	fcf9c0e3          	blt	s3,a5,37e <dns+0x202>
     3c2:	77fd                	lui	a5,0xfffff
     3c4:	7c678793          	addi	a5,a5,1990 # fffffffffffff7c6 <__global_pointer$+0xffffffffffffdc2d>
     3c8:	97a2                	add	a5,a5,s0
     3ca:	0007d783          	lhu	a5,0(a5)
     3ce:	0087971b          	slliw	a4,a5,0x8
     3d2:	83a1                	srli	a5,a5,0x8
     3d4:	8fd9                	or	a5,a5,a4
  for(int i = 0; i < ntohs(hdr->ancount); i++) {
     3d6:	17c2                	slli	a5,a5,0x30
     3d8:	93c1                	srli	a5,a5,0x30
     3da:	26078563          	beqz	a5,644 <dns+0x4c8>
    if(len >= cc){
     3de:	1344d063          	bge	s1,s4,4fe <dns+0x382>
     3e2:	00001797          	auipc	a5,0x1
     3e6:	e7678793          	addi	a5,a5,-394 # 1258 <malloc+0x2e0>
     3ea:	00090363          	beqz	s2,3f0 <dns+0x274>
     3ee:	87ca                	mv	a5,s2
     3f0:	76fd                	lui	a3,0xfffff
     3f2:	7b068713          	addi	a4,a3,1968 # fffffffffffff7b0 <__global_pointer$+0xffffffffffffdc17>
     3f6:	9722                	add	a4,a4,s0
     3f8:	e31c                	sd	a5,0(a4)
  int record = 0;
     3fa:	7b868793          	addi	a5,a3,1976
     3fe:	97a2                	add	a5,a5,s0
     400:	0007b023          	sd	zero,0(a5)
  for(int i = 0; i < ntohs(hdr->ancount); i++) {
     404:	4901                	li	s2,0
    if((int) qn[0] > 63) {  // compression?
     406:	03f00b13          	li	s6,63
    if(ntohs(d->type) == ARECORD && ntohs(d->len) == 4) {
     40a:	4a85                	li	s5,1
     40c:	4b91                	li	s7,4
      printf("DNS arecord for %s is ", qname ? qname : "" );
     40e:	00001d97          	auipc	s11,0x1
     412:	db2d8d93          	addi	s11,s11,-590 # 11c0 <malloc+0x248>
      printf("%d.%d.%d.%d\n", ip[0], ip[1], ip[2], ip[3]);
     416:	00001c17          	auipc	s8,0x1
     41a:	dc2c0c13          	addi	s8,s8,-574 # 11d8 <malloc+0x260>
      if(ip[0] != 128 || ip[1] != 52 || ip[2] != 129 || ip[3] != 126) {
     41e:	08000d13          	li	s10,128
     422:	03400c93          	li	s9,52
     426:	a2b1                	j	572 <dns+0x3f6>
    fprintf(2, "dns: send() failed\n");
     428:	00001597          	auipc	a1,0x1
     42c:	d0858593          	addi	a1,a1,-760 # 1130 <malloc+0x1b8>
     430:	4509                	li	a0,2
     432:	00001097          	auipc	ra,0x1
     436:	a60080e7          	jalr	-1440(ra) # e92 <fprintf>
    exit(1);
     43a:	4505                	li	a0,1
     43c:	00000097          	auipc	ra,0x0
     440:	6fa080e7          	jalr	1786(ra) # b36 <exit>
    fprintf(2, "dns: recv() failed\n");
     444:	00001597          	auipc	a1,0x1
     448:	d0458593          	addi	a1,a1,-764 # 1148 <malloc+0x1d0>
     44c:	4509                	li	a0,2
     44e:	00001097          	auipc	ra,0x1
     452:	a44080e7          	jalr	-1468(ra) # e92 <fprintf>
    exit(1);
     456:	4505                	li	a0,1
     458:	00000097          	auipc	ra,0x0
     45c:	6de080e7          	jalr	1758(ra) # b36 <exit>
    printf("DNS reply too short\n");
     460:	00001517          	auipc	a0,0x1
     464:	d0050513          	addi	a0,a0,-768 # 1160 <malloc+0x1e8>
     468:	00001097          	auipc	ra,0x1
     46c:	a58080e7          	jalr	-1448(ra) # ec0 <printf>
    exit(1);
     470:	4505                	li	a0,1
     472:	00000097          	auipc	ra,0x0
     476:	6c4080e7          	jalr	1732(ra) # b36 <exit>
     47a:	77fd                	lui	a5,0xfffff
     47c:	7c078793          	addi	a5,a5,1984 # fffffffffffff7c0 <__global_pointer$+0xffffffffffffdc27>
     480:	97a2                	add	a5,a5,s0
     482:	0007d783          	lhu	a5,0(a5)
     486:	0087971b          	slliw	a4,a5,0x8
     48a:	83a1                	srli	a5,a5,0x8
     48c:	00e7e5b3          	or	a1,a5,a4
    printf("Not a DNS reply for %d\n", ntohs(hdr->id));
     490:	15c2                	slli	a1,a1,0x30
     492:	91c1                	srli	a1,a1,0x30
     494:	00001517          	auipc	a0,0x1
     498:	ce450513          	addi	a0,a0,-796 # 1178 <malloc+0x200>
     49c:	00001097          	auipc	ra,0x1
     4a0:	a24080e7          	jalr	-1500(ra) # ec0 <printf>
    exit(1);
     4a4:	4505                	li	a0,1
     4a6:	00000097          	auipc	ra,0x0
     4aa:	690080e7          	jalr	1680(ra) # b36 <exit>
     4ae:	0087159b          	slliw	a1,a4,0x8
     4b2:	0087571b          	srliw	a4,a4,0x8
     4b6:	8dd9                	or	a1,a1,a4
    printf("DNS wrong id: %d\n", ntohs(hdr->id));
     4b8:	15c2                	slli	a1,a1,0x30
     4ba:	91c1                	srli	a1,a1,0x30
     4bc:	00001517          	auipc	a0,0x1
     4c0:	cd450513          	addi	a0,a0,-812 # 1190 <malloc+0x218>
     4c4:	00001097          	auipc	ra,0x1
     4c8:	9fc080e7          	jalr	-1540(ra) # ec0 <printf>
    exit(1);
     4cc:	4505                	li	a0,1
     4ce:	00000097          	auipc	ra,0x0
     4d2:	668080e7          	jalr	1640(ra) # b36 <exit>
    printf("DNS rcode error: %x\n", hdr->rcode);
     4d6:	77fd                	lui	a5,0xfffff
     4d8:	7c378793          	addi	a5,a5,1987 # fffffffffffff7c3 <__global_pointer$+0xffffffffffffdc2a>
     4dc:	97a2                	add	a5,a5,s0
     4de:	0007c583          	lbu	a1,0(a5)
     4e2:	89bd                	andi	a1,a1,15
     4e4:	00001517          	auipc	a0,0x1
     4e8:	cc450513          	addi	a0,a0,-828 # 11a8 <malloc+0x230>
     4ec:	00001097          	auipc	ra,0x1
     4f0:	9d4080e7          	jalr	-1580(ra) # ec0 <printf>
    exit(1);
     4f4:	4505                	li	a0,1
     4f6:	00000097          	auipc	ra,0x0
     4fa:	640080e7          	jalr	1600(ra) # b36 <exit>
      printf("invalid DNS reply\n");
     4fe:	00001517          	auipc	a0,0x1
     502:	b6250513          	addi	a0,a0,-1182 # 1060 <malloc+0xe8>
     506:	00001097          	auipc	ra,0x1
     50a:	9ba080e7          	jalr	-1606(ra) # ec0 <printf>
      exit(1);
     50e:	4505                	li	a0,1
     510:	00000097          	auipc	ra,0x0
     514:	626080e7          	jalr	1574(ra) # b36 <exit>
      decode_qname(qn, cc - len);
     518:	409a05bb          	subw	a1,s4,s1
     51c:	854e                	mv	a0,s3
     51e:	00000097          	auipc	ra,0x0
     522:	ae2080e7          	jalr	-1310(ra) # 0 <decode_qname>
      len += strlen(qn)+1;
     526:	854e                	mv	a0,s3
     528:	00000097          	auipc	ra,0x0
     52c:	3ea080e7          	jalr	1002(ra) # 912 <strlen>
     530:	2485                	addiw	s1,s1,1
     532:	9ca9                	addw	s1,s1,a0
     534:	a891                	j	588 <dns+0x40c>
        printf("wrong ip address");
     536:	00001517          	auipc	a0,0x1
     53a:	cb250513          	addi	a0,a0,-846 # 11e8 <malloc+0x270>
     53e:	00001097          	auipc	ra,0x1
     542:	982080e7          	jalr	-1662(ra) # ec0 <printf>
        exit(1);
     546:	4505                	li	a0,1
     548:	00000097          	auipc	ra,0x0
     54c:	5ee080e7          	jalr	1518(ra) # b36 <exit>
  for(int i = 0; i < ntohs(hdr->ancount); i++) {
     550:	2905                	addiw	s2,s2,1
     552:	77fd                	lui	a5,0xfffff
     554:	7c678793          	addi	a5,a5,1990 # fffffffffffff7c6 <__global_pointer$+0xffffffffffffdc2d>
     558:	97a2                	add	a5,a5,s0
     55a:	0007d783          	lhu	a5,0(a5)
     55e:	0087971b          	slliw	a4,a5,0x8
     562:	83a1                	srli	a5,a5,0x8
     564:	8fd9                	or	a5,a5,a4
     566:	17c2                	slli	a5,a5,0x30
     568:	93c1                	srli	a5,a5,0x30
     56a:	0ef95363          	bge	s2,a5,650 <dns+0x4d4>
    if(len >= cc){
     56e:	f944d8e3          	bge	s1,s4,4fe <dns+0x382>
    char *qn = (char *) (ibuf+len);
     572:	77fd                	lui	a5,0xfffff
     574:	7c078793          	addi	a5,a5,1984 # fffffffffffff7c0 <__global_pointer$+0xffffffffffffdc27>
     578:	97a2                	add	a5,a5,s0
     57a:	009789b3          	add	s3,a5,s1
    if((int) qn[0] > 63) {  // compression?
     57e:	0009c783          	lbu	a5,0(s3)
     582:	f8fb7be3          	bgeu	s6,a5,518 <dns+0x39c>
      len += 2;
     586:	2489                	addiw	s1,s1,2
    struct dns_data *d = (struct dns_data *) (ibuf+len);
     588:	77fd                	lui	a5,0xfffff
     58a:	7c078793          	addi	a5,a5,1984 # fffffffffffff7c0 <__global_pointer$+0xffffffffffffdc27>
     58e:	97a2                	add	a5,a5,s0
     590:	00978733          	add	a4,a5,s1
    len += sizeof(struct dns_data);
     594:	0004899b          	sext.w	s3,s1
     598:	24a9                	addiw	s1,s1,10
    if(ntohs(d->type) == ARECORD && ntohs(d->len) == 4) {
     59a:	00074683          	lbu	a3,0(a4)
     59e:	00174783          	lbu	a5,1(a4)
     5a2:	07a2                	slli	a5,a5,0x8
     5a4:	8fd5                	or	a5,a5,a3
     5a6:	0087969b          	slliw	a3,a5,0x8
     5aa:	83a1                	srli	a5,a5,0x8
     5ac:	8fd5                	or	a5,a5,a3
     5ae:	17c2                	slli	a5,a5,0x30
     5b0:	93c1                	srli	a5,a5,0x30
     5b2:	f9579fe3          	bne	a5,s5,550 <dns+0x3d4>
     5b6:	00874683          	lbu	a3,8(a4)
     5ba:	00974783          	lbu	a5,9(a4)
     5be:	07a2                	slli	a5,a5,0x8
     5c0:	8fd5                	or	a5,a5,a3
     5c2:	0087971b          	slliw	a4,a5,0x8
     5c6:	83a1                	srli	a5,a5,0x8
     5c8:	8fd9                	or	a5,a5,a4
     5ca:	17c2                	slli	a5,a5,0x30
     5cc:	93c1                	srli	a5,a5,0x30
     5ce:	f97791e3          	bne	a5,s7,550 <dns+0x3d4>
      printf("DNS arecord for %s is ", qname ? qname : "" );
     5d2:	77fd                	lui	a5,0xfffff
     5d4:	7b078793          	addi	a5,a5,1968 # fffffffffffff7b0 <__global_pointer$+0xffffffffffffdc17>
     5d8:	97a2                	add	a5,a5,s0
     5da:	638c                	ld	a1,0(a5)
     5dc:	856e                	mv	a0,s11
     5de:	00001097          	auipc	ra,0x1
     5e2:	8e2080e7          	jalr	-1822(ra) # ec0 <printf>
      uint8 *ip = (ibuf+len);
     5e6:	77fd                	lui	a5,0xfffff
     5e8:	7c078793          	addi	a5,a5,1984 # fffffffffffff7c0 <__global_pointer$+0xffffffffffffdc27>
     5ec:	97a2                	add	a5,a5,s0
     5ee:	94be                	add	s1,s1,a5
      printf("%d.%d.%d.%d\n", ip[0], ip[1], ip[2], ip[3]);
     5f0:	0034c703          	lbu	a4,3(s1)
     5f4:	0024c683          	lbu	a3,2(s1)
     5f8:	0014c603          	lbu	a2,1(s1)
     5fc:	0004c583          	lbu	a1,0(s1)
     600:	8562                	mv	a0,s8
     602:	00001097          	auipc	ra,0x1
     606:	8be080e7          	jalr	-1858(ra) # ec0 <printf>
      if(ip[0] != 128 || ip[1] != 52 || ip[2] != 129 || ip[3] != 126) {
     60a:	0004c783          	lbu	a5,0(s1)
     60e:	f3a794e3          	bne	a5,s10,536 <dns+0x3ba>
     612:	0014c783          	lbu	a5,1(s1)
     616:	f39790e3          	bne	a5,s9,536 <dns+0x3ba>
     61a:	0024c703          	lbu	a4,2(s1)
     61e:	08100793          	li	a5,129
     622:	f0f71ae3          	bne	a4,a5,536 <dns+0x3ba>
     626:	0034c703          	lbu	a4,3(s1)
     62a:	07e00793          	li	a5,126
     62e:	f0f714e3          	bne	a4,a5,536 <dns+0x3ba>
      len += 4;
     632:	00e9849b          	addiw	s1,s3,14
      record = 1;
     636:	77fd                	lui	a5,0xfffff
     638:	7b878793          	addi	a5,a5,1976 # fffffffffffff7b8 <__global_pointer$+0xffffffffffffdc1f>
     63c:	97a2                	add	a5,a5,s0
     63e:	0157b023          	sd	s5,0(a5)
     642:	b739                	j	550 <dns+0x3d4>
  int record = 0;
     644:	77fd                	lui	a5,0xfffff
     646:	7b878793          	addi	a5,a5,1976 # fffffffffffff7b8 <__global_pointer$+0xffffffffffffdc1f>
     64a:	97a2                	add	a5,a5,s0
     64c:	0007b023          	sd	zero,0(a5)
     650:	77fd                	lui	a5,0xfffff
     652:	7ca78793          	addi	a5,a5,1994 # fffffffffffff7ca <__global_pointer$+0xffffffffffffdc31>
     656:	97a2                	add	a5,a5,s0
     658:	0007d783          	lhu	a5,0(a5)
     65c:	0087971b          	slliw	a4,a5,0x8
     660:	0087d593          	srli	a1,a5,0x8
     664:	8dd9                	or	a1,a1,a4
  for(int i = 0; i < ntohs(hdr->arcount); i++) {
     666:	15c2                	slli	a1,a1,0x30
     668:	91c1                	srli	a1,a1,0x30
     66a:	06b05363          	blez	a1,6d0 <dns+0x554>
     66e:	4681                	li	a3,0
    if(ntohs(d->type) != 41) {
     670:	02900513          	li	a0,41
    if(*qn != 0) {
     674:	f9048793          	addi	a5,s1,-112
     678:	97a2                	add	a5,a5,s0
     67a:	8307c783          	lbu	a5,-2000(a5)
     67e:	ebd9                	bnez	a5,714 <dns+0x598>
    struct dns_data *d = (struct dns_data *) (ibuf+len);
     680:	0014871b          	addiw	a4,s1,1
     684:	77fd                	lui	a5,0xfffff
     686:	7c078793          	addi	a5,a5,1984 # fffffffffffff7c0 <__global_pointer$+0xffffffffffffdc27>
     68a:	97a2                	add	a5,a5,s0
     68c:	973e                	add	a4,a4,a5
    len += sizeof(struct dns_data);
     68e:	24ad                	addiw	s1,s1,11
    if(ntohs(d->type) != 41) {
     690:	00074603          	lbu	a2,0(a4)
     694:	00174783          	lbu	a5,1(a4)
     698:	07a2                	slli	a5,a5,0x8
     69a:	8fd1                	or	a5,a5,a2
     69c:	0087961b          	slliw	a2,a5,0x8
     6a0:	83a1                	srli	a5,a5,0x8
     6a2:	8fd1                	or	a5,a5,a2
     6a4:	17c2                	slli	a5,a5,0x30
     6a6:	93c1                	srli	a5,a5,0x30
     6a8:	08a79363          	bne	a5,a0,72e <dns+0x5b2>
    len += ntohs(d->len);
     6ac:	00874603          	lbu	a2,8(a4)
     6b0:	00974783          	lbu	a5,9(a4)
     6b4:	07a2                	slli	a5,a5,0x8
     6b6:	8fd1                	or	a5,a5,a2
     6b8:	0087971b          	slliw	a4,a5,0x8
     6bc:	83a1                	srli	a5,a5,0x8
     6be:	8fd9                	or	a5,a5,a4
     6c0:	0107979b          	slliw	a5,a5,0x10
     6c4:	0107d79b          	srliw	a5,a5,0x10
     6c8:	9cbd                	addw	s1,s1,a5
  for(int i = 0; i < ntohs(hdr->arcount); i++) {
     6ca:	2685                	addiw	a3,a3,1
     6cc:	fad594e3          	bne	a1,a3,674 <dns+0x4f8>
  if(len != cc) {
     6d0:	069a1c63          	bne	s4,s1,748 <dns+0x5cc>
  if(!record) {
     6d4:	77fd                	lui	a5,0xfffff
     6d6:	7b878793          	addi	a5,a5,1976 # fffffffffffff7b8 <__global_pointer$+0xffffffffffffdc1f>
     6da:	97a2                	add	a5,a5,s0
     6dc:	639c                	ld	a5,0(a5)
     6de:	c7c1                	beqz	a5,766 <dns+0x5ea>
  }
  dns_rep(ibuf, cc);

  close(fd);
     6e0:	77fd                	lui	a5,0xfffff
     6e2:	7a878793          	addi	a5,a5,1960 # fffffffffffff7a8 <__global_pointer$+0xffffffffffffdc0f>
     6e6:	97a2                	add	a5,a5,s0
     6e8:	6388                	ld	a0,0(a5)
     6ea:	00000097          	auipc	ra,0x0
     6ee:	474080e7          	jalr	1140(ra) # b5e <close>
}  
     6f2:	7e010113          	addi	sp,sp,2016
     6f6:	70e6                	ld	ra,120(sp)
     6f8:	7446                	ld	s0,112(sp)
     6fa:	74a6                	ld	s1,104(sp)
     6fc:	7906                	ld	s2,96(sp)
     6fe:	69e6                	ld	s3,88(sp)
     700:	6a46                	ld	s4,80(sp)
     702:	6aa6                	ld	s5,72(sp)
     704:	6b06                	ld	s6,64(sp)
     706:	7be2                	ld	s7,56(sp)
     708:	7c42                	ld	s8,48(sp)
     70a:	7ca2                	ld	s9,40(sp)
     70c:	7d02                	ld	s10,32(sp)
     70e:	6de2                	ld	s11,24(sp)
     710:	6109                	addi	sp,sp,128
     712:	8082                	ret
      printf("invalid name for EDNS\n");
     714:	00001517          	auipc	a0,0x1
     718:	aec50513          	addi	a0,a0,-1300 # 1200 <malloc+0x288>
     71c:	00000097          	auipc	ra,0x0
     720:	7a4080e7          	jalr	1956(ra) # ec0 <printf>
      exit(1);
     724:	4505                	li	a0,1
     726:	00000097          	auipc	ra,0x0
     72a:	410080e7          	jalr	1040(ra) # b36 <exit>
      printf("invalid type for EDNS\n");
     72e:	00001517          	auipc	a0,0x1
     732:	aea50513          	addi	a0,a0,-1302 # 1218 <malloc+0x2a0>
     736:	00000097          	auipc	ra,0x0
     73a:	78a080e7          	jalr	1930(ra) # ec0 <printf>
      exit(1);
     73e:	4505                	li	a0,1
     740:	00000097          	auipc	ra,0x0
     744:	3f6080e7          	jalr	1014(ra) # b36 <exit>
    printf("Processed %d data bytes but received %d\n", len, cc);
     748:	8652                	mv	a2,s4
     74a:	85a6                	mv	a1,s1
     74c:	00001517          	auipc	a0,0x1
     750:	ae450513          	addi	a0,a0,-1308 # 1230 <malloc+0x2b8>
     754:	00000097          	auipc	ra,0x0
     758:	76c080e7          	jalr	1900(ra) # ec0 <printf>
    exit(1);
     75c:	4505                	li	a0,1
     75e:	00000097          	auipc	ra,0x0
     762:	3d8080e7          	jalr	984(ra) # b36 <exit>
    printf("Didn't receive an arecord\n");
     766:	00001517          	auipc	a0,0x1
     76a:	afa50513          	addi	a0,a0,-1286 # 1260 <malloc+0x2e8>
     76e:	00000097          	auipc	ra,0x0
     772:	752080e7          	jalr	1874(ra) # ec0 <printf>
    exit(1);
     776:	4505                	li	a0,1
     778:	00000097          	auipc	ra,0x0
     77c:	3be080e7          	jalr	958(ra) # b36 <exit>

0000000000000780 <main>:

int
main(int argc, char *argv[])
{
     780:	7179                	addi	sp,sp,-48
     782:	f406                	sd	ra,40(sp)
     784:	f022                	sd	s0,32(sp)
     786:	ec26                	sd	s1,24(sp)
     788:	e84a                	sd	s2,16(sp)
     78a:	1800                	addi	s0,sp,48
  int i, ret;
  uint16 dport = NET_TESTS_PORT;

  printf("nettests running on port %d\n", dport);
     78c:	6499                	lui	s1,0x6
     78e:	5f348593          	addi	a1,s1,1523 # 65f3 <__global_pointer$+0x4a5a>
     792:	00001517          	auipc	a0,0x1
     796:	aee50513          	addi	a0,a0,-1298 # 1280 <malloc+0x308>
     79a:	00000097          	auipc	ra,0x0
     79e:	726080e7          	jalr	1830(ra) # ec0 <printf>
  
  printf("testing ping: ");
     7a2:	00001517          	auipc	a0,0x1
     7a6:	afe50513          	addi	a0,a0,-1282 # 12a0 <malloc+0x328>
     7aa:	00000097          	auipc	ra,0x0
     7ae:	716080e7          	jalr	1814(ra) # ec0 <printf>
  ping(2000, dport, 1);
     7b2:	4605                	li	a2,1
     7b4:	5f348593          	addi	a1,s1,1523
     7b8:	7d000513          	li	a0,2000
     7bc:	00000097          	auipc	ra,0x0
     7c0:	89e080e7          	jalr	-1890(ra) # 5a <ping>
  printf("OK\n");
     7c4:	00001517          	auipc	a0,0x1
     7c8:	aec50513          	addi	a0,a0,-1300 # 12b0 <malloc+0x338>
     7cc:	00000097          	auipc	ra,0x0
     7d0:	6f4080e7          	jalr	1780(ra) # ec0 <printf>
  
  printf("testing single-process pings: ");
     7d4:	00001517          	auipc	a0,0x1
     7d8:	ae450513          	addi	a0,a0,-1308 # 12b8 <malloc+0x340>
     7dc:	00000097          	auipc	ra,0x0
     7e0:	6e4080e7          	jalr	1764(ra) # ec0 <printf>
     7e4:	06400493          	li	s1,100
  for (i = 0; i < 100; i++)
    ping(2000, dport, 1);
     7e8:	6919                	lui	s2,0x6
     7ea:	5f390913          	addi	s2,s2,1523 # 65f3 <__global_pointer$+0x4a5a>
     7ee:	4605                	li	a2,1
     7f0:	85ca                	mv	a1,s2
     7f2:	7d000513          	li	a0,2000
     7f6:	00000097          	auipc	ra,0x0
     7fa:	864080e7          	jalr	-1948(ra) # 5a <ping>
  for (i = 0; i < 100; i++)
     7fe:	34fd                	addiw	s1,s1,-1
     800:	f4fd                	bnez	s1,7ee <main+0x6e>
  printf("OK\n");
     802:	00001517          	auipc	a0,0x1
     806:	aae50513          	addi	a0,a0,-1362 # 12b0 <malloc+0x338>
     80a:	00000097          	auipc	ra,0x0
     80e:	6b6080e7          	jalr	1718(ra) # ec0 <printf>
  
  printf("testing multi-process pings: ");
     812:	00001517          	auipc	a0,0x1
     816:	ac650513          	addi	a0,a0,-1338 # 12d8 <malloc+0x360>
     81a:	00000097          	auipc	ra,0x0
     81e:	6a6080e7          	jalr	1702(ra) # ec0 <printf>
  for (i = 0; i < 10; i++){
     822:	4929                	li	s2,10
    int pid = fork();
     824:	00000097          	auipc	ra,0x0
     828:	30a080e7          	jalr	778(ra) # b2e <fork>
    if (pid == 0){
     82c:	c92d                	beqz	a0,89e <main+0x11e>
  for (i = 0; i < 10; i++){
     82e:	2485                	addiw	s1,s1,1
     830:	ff249ae3          	bne	s1,s2,824 <main+0xa4>
     834:	44a9                	li	s1,10
      ping(2000 + i + 1, dport, 1);
      exit(0);
    }
  }
  for (i = 0; i < 10; i++){
    wait(&ret);
     836:	fdc40513          	addi	a0,s0,-36
     83a:	00000097          	auipc	ra,0x0
     83e:	304080e7          	jalr	772(ra) # b3e <wait>
    if (ret != 0)
     842:	fdc42783          	lw	a5,-36(s0)
     846:	efad                	bnez	a5,8c0 <main+0x140>
  for (i = 0; i < 10; i++){
     848:	34fd                	addiw	s1,s1,-1
     84a:	f4f5                	bnez	s1,836 <main+0xb6>
      exit(1);
  }
  printf("OK\n");
     84c:	00001517          	auipc	a0,0x1
     850:	a6450513          	addi	a0,a0,-1436 # 12b0 <malloc+0x338>
     854:	00000097          	auipc	ra,0x0
     858:	66c080e7          	jalr	1644(ra) # ec0 <printf>
  
  printf("testing DNS\n");
     85c:	00001517          	auipc	a0,0x1
     860:	a9c50513          	addi	a0,a0,-1380 # 12f8 <malloc+0x380>
     864:	00000097          	auipc	ra,0x0
     868:	65c080e7          	jalr	1628(ra) # ec0 <printf>
  dns();
     86c:	00000097          	auipc	ra,0x0
     870:	910080e7          	jalr	-1776(ra) # 17c <dns>
  printf("DNS OK\n");
     874:	00001517          	auipc	a0,0x1
     878:	a9450513          	addi	a0,a0,-1388 # 1308 <malloc+0x390>
     87c:	00000097          	auipc	ra,0x0
     880:	644080e7          	jalr	1604(ra) # ec0 <printf>
  
  printf("all tests passed.\n");
     884:	00001517          	auipc	a0,0x1
     888:	a8c50513          	addi	a0,a0,-1396 # 1310 <malloc+0x398>
     88c:	00000097          	auipc	ra,0x0
     890:	634080e7          	jalr	1588(ra) # ec0 <printf>
  exit(0);
     894:	4501                	li	a0,0
     896:	00000097          	auipc	ra,0x0
     89a:	2a0080e7          	jalr	672(ra) # b36 <exit>
      ping(2000 + i + 1, dport, 1);
     89e:	7d14851b          	addiw	a0,s1,2001
     8a2:	4605                	li	a2,1
     8a4:	6599                	lui	a1,0x6
     8a6:	5f358593          	addi	a1,a1,1523 # 65f3 <__global_pointer$+0x4a5a>
     8aa:	1542                	slli	a0,a0,0x30
     8ac:	9141                	srli	a0,a0,0x30
     8ae:	fffff097          	auipc	ra,0xfffff
     8b2:	7ac080e7          	jalr	1964(ra) # 5a <ping>
      exit(0);
     8b6:	4501                	li	a0,0
     8b8:	00000097          	auipc	ra,0x0
     8bc:	27e080e7          	jalr	638(ra) # b36 <exit>
      exit(1);
     8c0:	4505                	li	a0,1
     8c2:	00000097          	auipc	ra,0x0
     8c6:	274080e7          	jalr	628(ra) # b36 <exit>

00000000000008ca <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
     8ca:	1141                	addi	sp,sp,-16
     8cc:	e422                	sd	s0,8(sp)
     8ce:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     8d0:	87aa                	mv	a5,a0
     8d2:	0585                	addi	a1,a1,1
     8d4:	0785                	addi	a5,a5,1
     8d6:	fff5c703          	lbu	a4,-1(a1)
     8da:	fee78fa3          	sb	a4,-1(a5)
     8de:	fb75                	bnez	a4,8d2 <strcpy+0x8>
    ;
  return os;
}
     8e0:	6422                	ld	s0,8(sp)
     8e2:	0141                	addi	sp,sp,16
     8e4:	8082                	ret

00000000000008e6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     8e6:	1141                	addi	sp,sp,-16
     8e8:	e422                	sd	s0,8(sp)
     8ea:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     8ec:	00054783          	lbu	a5,0(a0)
     8f0:	cb91                	beqz	a5,904 <strcmp+0x1e>
     8f2:	0005c703          	lbu	a4,0(a1)
     8f6:	00f71763          	bne	a4,a5,904 <strcmp+0x1e>
    p++, q++;
     8fa:	0505                	addi	a0,a0,1
     8fc:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     8fe:	00054783          	lbu	a5,0(a0)
     902:	fbe5                	bnez	a5,8f2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     904:	0005c503          	lbu	a0,0(a1)
}
     908:	40a7853b          	subw	a0,a5,a0
     90c:	6422                	ld	s0,8(sp)
     90e:	0141                	addi	sp,sp,16
     910:	8082                	ret

0000000000000912 <strlen>:

uint
strlen(const char *s)
{
     912:	1141                	addi	sp,sp,-16
     914:	e422                	sd	s0,8(sp)
     916:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     918:	00054783          	lbu	a5,0(a0)
     91c:	cf91                	beqz	a5,938 <strlen+0x26>
     91e:	0505                	addi	a0,a0,1
     920:	87aa                	mv	a5,a0
     922:	4685                	li	a3,1
     924:	9e89                	subw	a3,a3,a0
     926:	00f6853b          	addw	a0,a3,a5
     92a:	0785                	addi	a5,a5,1
     92c:	fff7c703          	lbu	a4,-1(a5)
     930:	fb7d                	bnez	a4,926 <strlen+0x14>
    ;
  return n;
}
     932:	6422                	ld	s0,8(sp)
     934:	0141                	addi	sp,sp,16
     936:	8082                	ret
  for(n = 0; s[n]; n++)
     938:	4501                	li	a0,0
     93a:	bfe5                	j	932 <strlen+0x20>

000000000000093c <memset>:

void*
memset(void *dst, int c, uint n)
{
     93c:	1141                	addi	sp,sp,-16
     93e:	e422                	sd	s0,8(sp)
     940:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     942:	ca19                	beqz	a2,958 <memset+0x1c>
     944:	87aa                	mv	a5,a0
     946:	1602                	slli	a2,a2,0x20
     948:	9201                	srli	a2,a2,0x20
     94a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     94e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     952:	0785                	addi	a5,a5,1
     954:	fee79de3          	bne	a5,a4,94e <memset+0x12>
  }
  return dst;
}
     958:	6422                	ld	s0,8(sp)
     95a:	0141                	addi	sp,sp,16
     95c:	8082                	ret

000000000000095e <strchr>:

char*
strchr(const char *s, char c)
{
     95e:	1141                	addi	sp,sp,-16
     960:	e422                	sd	s0,8(sp)
     962:	0800                	addi	s0,sp,16
  for(; *s; s++)
     964:	00054783          	lbu	a5,0(a0)
     968:	cb99                	beqz	a5,97e <strchr+0x20>
    if(*s == c)
     96a:	00f58763          	beq	a1,a5,978 <strchr+0x1a>
  for(; *s; s++)
     96e:	0505                	addi	a0,a0,1
     970:	00054783          	lbu	a5,0(a0)
     974:	fbfd                	bnez	a5,96a <strchr+0xc>
      return (char*)s;
  return 0;
     976:	4501                	li	a0,0
}
     978:	6422                	ld	s0,8(sp)
     97a:	0141                	addi	sp,sp,16
     97c:	8082                	ret
  return 0;
     97e:	4501                	li	a0,0
     980:	bfe5                	j	978 <strchr+0x1a>

0000000000000982 <gets>:

char*
gets(char *buf, int max)
{
     982:	711d                	addi	sp,sp,-96
     984:	ec86                	sd	ra,88(sp)
     986:	e8a2                	sd	s0,80(sp)
     988:	e4a6                	sd	s1,72(sp)
     98a:	e0ca                	sd	s2,64(sp)
     98c:	fc4e                	sd	s3,56(sp)
     98e:	f852                	sd	s4,48(sp)
     990:	f456                	sd	s5,40(sp)
     992:	f05a                	sd	s6,32(sp)
     994:	ec5e                	sd	s7,24(sp)
     996:	1080                	addi	s0,sp,96
     998:	8baa                	mv	s7,a0
     99a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     99c:	892a                	mv	s2,a0
     99e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     9a0:	4aa9                	li	s5,10
     9a2:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     9a4:	89a6                	mv	s3,s1
     9a6:	2485                	addiw	s1,s1,1
     9a8:	0344d863          	bge	s1,s4,9d8 <gets+0x56>
    cc = read(0, &c, 1);
     9ac:	4605                	li	a2,1
     9ae:	faf40593          	addi	a1,s0,-81
     9b2:	4501                	li	a0,0
     9b4:	00000097          	auipc	ra,0x0
     9b8:	19a080e7          	jalr	410(ra) # b4e <read>
    if(cc < 1)
     9bc:	00a05e63          	blez	a0,9d8 <gets+0x56>
    buf[i++] = c;
     9c0:	faf44783          	lbu	a5,-81(s0)
     9c4:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     9c8:	01578763          	beq	a5,s5,9d6 <gets+0x54>
     9cc:	0905                	addi	s2,s2,1
     9ce:	fd679be3          	bne	a5,s6,9a4 <gets+0x22>
  for(i=0; i+1 < max; ){
     9d2:	89a6                	mv	s3,s1
     9d4:	a011                	j	9d8 <gets+0x56>
     9d6:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     9d8:	99de                	add	s3,s3,s7
     9da:	00098023          	sb	zero,0(s3)
  return buf;
}
     9de:	855e                	mv	a0,s7
     9e0:	60e6                	ld	ra,88(sp)
     9e2:	6446                	ld	s0,80(sp)
     9e4:	64a6                	ld	s1,72(sp)
     9e6:	6906                	ld	s2,64(sp)
     9e8:	79e2                	ld	s3,56(sp)
     9ea:	7a42                	ld	s4,48(sp)
     9ec:	7aa2                	ld	s5,40(sp)
     9ee:	7b02                	ld	s6,32(sp)
     9f0:	6be2                	ld	s7,24(sp)
     9f2:	6125                	addi	sp,sp,96
     9f4:	8082                	ret

00000000000009f6 <stat>:

int
stat(const char *n, struct stat *st)
{
     9f6:	1101                	addi	sp,sp,-32
     9f8:	ec06                	sd	ra,24(sp)
     9fa:	e822                	sd	s0,16(sp)
     9fc:	e426                	sd	s1,8(sp)
     9fe:	e04a                	sd	s2,0(sp)
     a00:	1000                	addi	s0,sp,32
     a02:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     a04:	4581                	li	a1,0
     a06:	00000097          	auipc	ra,0x0
     a0a:	170080e7          	jalr	368(ra) # b76 <open>
  if(fd < 0)
     a0e:	02054563          	bltz	a0,a38 <stat+0x42>
     a12:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     a14:	85ca                	mv	a1,s2
     a16:	00000097          	auipc	ra,0x0
     a1a:	178080e7          	jalr	376(ra) # b8e <fstat>
     a1e:	892a                	mv	s2,a0
  close(fd);
     a20:	8526                	mv	a0,s1
     a22:	00000097          	auipc	ra,0x0
     a26:	13c080e7          	jalr	316(ra) # b5e <close>
  return r;
}
     a2a:	854a                	mv	a0,s2
     a2c:	60e2                	ld	ra,24(sp)
     a2e:	6442                	ld	s0,16(sp)
     a30:	64a2                	ld	s1,8(sp)
     a32:	6902                	ld	s2,0(sp)
     a34:	6105                	addi	sp,sp,32
     a36:	8082                	ret
    return -1;
     a38:	597d                	li	s2,-1
     a3a:	bfc5                	j	a2a <stat+0x34>

0000000000000a3c <atoi>:

int
atoi(const char *s)
{
     a3c:	1141                	addi	sp,sp,-16
     a3e:	e422                	sd	s0,8(sp)
     a40:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     a42:	00054683          	lbu	a3,0(a0)
     a46:	fd06879b          	addiw	a5,a3,-48
     a4a:	0ff7f793          	zext.b	a5,a5
     a4e:	4625                	li	a2,9
     a50:	02f66863          	bltu	a2,a5,a80 <atoi+0x44>
     a54:	872a                	mv	a4,a0
  n = 0;
     a56:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     a58:	0705                	addi	a4,a4,1
     a5a:	0025179b          	slliw	a5,a0,0x2
     a5e:	9fa9                	addw	a5,a5,a0
     a60:	0017979b          	slliw	a5,a5,0x1
     a64:	9fb5                	addw	a5,a5,a3
     a66:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     a6a:	00074683          	lbu	a3,0(a4)
     a6e:	fd06879b          	addiw	a5,a3,-48
     a72:	0ff7f793          	zext.b	a5,a5
     a76:	fef671e3          	bgeu	a2,a5,a58 <atoi+0x1c>
  return n;
}
     a7a:	6422                	ld	s0,8(sp)
     a7c:	0141                	addi	sp,sp,16
     a7e:	8082                	ret
  n = 0;
     a80:	4501                	li	a0,0
     a82:	bfe5                	j	a7a <atoi+0x3e>

0000000000000a84 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     a84:	1141                	addi	sp,sp,-16
     a86:	e422                	sd	s0,8(sp)
     a88:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     a8a:	02b57463          	bgeu	a0,a1,ab2 <memmove+0x2e>
    while(n-- > 0)
     a8e:	00c05f63          	blez	a2,aac <memmove+0x28>
     a92:	1602                	slli	a2,a2,0x20
     a94:	9201                	srli	a2,a2,0x20
     a96:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     a9a:	872a                	mv	a4,a0
      *dst++ = *src++;
     a9c:	0585                	addi	a1,a1,1
     a9e:	0705                	addi	a4,a4,1
     aa0:	fff5c683          	lbu	a3,-1(a1)
     aa4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     aa8:	fee79ae3          	bne	a5,a4,a9c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     aac:	6422                	ld	s0,8(sp)
     aae:	0141                	addi	sp,sp,16
     ab0:	8082                	ret
    dst += n;
     ab2:	00c50733          	add	a4,a0,a2
    src += n;
     ab6:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     ab8:	fec05ae3          	blez	a2,aac <memmove+0x28>
     abc:	fff6079b          	addiw	a5,a2,-1
     ac0:	1782                	slli	a5,a5,0x20
     ac2:	9381                	srli	a5,a5,0x20
     ac4:	fff7c793          	not	a5,a5
     ac8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     aca:	15fd                	addi	a1,a1,-1
     acc:	177d                	addi	a4,a4,-1
     ace:	0005c683          	lbu	a3,0(a1)
     ad2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     ad6:	fee79ae3          	bne	a5,a4,aca <memmove+0x46>
     ada:	bfc9                	j	aac <memmove+0x28>

0000000000000adc <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     adc:	1141                	addi	sp,sp,-16
     ade:	e422                	sd	s0,8(sp)
     ae0:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     ae2:	ca05                	beqz	a2,b12 <memcmp+0x36>
     ae4:	fff6069b          	addiw	a3,a2,-1
     ae8:	1682                	slli	a3,a3,0x20
     aea:	9281                	srli	a3,a3,0x20
     aec:	0685                	addi	a3,a3,1
     aee:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     af0:	00054783          	lbu	a5,0(a0)
     af4:	0005c703          	lbu	a4,0(a1)
     af8:	00e79863          	bne	a5,a4,b08 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     afc:	0505                	addi	a0,a0,1
    p2++;
     afe:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     b00:	fed518e3          	bne	a0,a3,af0 <memcmp+0x14>
  }
  return 0;
     b04:	4501                	li	a0,0
     b06:	a019                	j	b0c <memcmp+0x30>
      return *p1 - *p2;
     b08:	40e7853b          	subw	a0,a5,a4
}
     b0c:	6422                	ld	s0,8(sp)
     b0e:	0141                	addi	sp,sp,16
     b10:	8082                	ret
  return 0;
     b12:	4501                	li	a0,0
     b14:	bfe5                	j	b0c <memcmp+0x30>

0000000000000b16 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     b16:	1141                	addi	sp,sp,-16
     b18:	e406                	sd	ra,8(sp)
     b1a:	e022                	sd	s0,0(sp)
     b1c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     b1e:	00000097          	auipc	ra,0x0
     b22:	f66080e7          	jalr	-154(ra) # a84 <memmove>
}
     b26:	60a2                	ld	ra,8(sp)
     b28:	6402                	ld	s0,0(sp)
     b2a:	0141                	addi	sp,sp,16
     b2c:	8082                	ret

0000000000000b2e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     b2e:	4885                	li	a7,1
 ecall
     b30:	00000073          	ecall
 ret
     b34:	8082                	ret

0000000000000b36 <exit>:
.global exit
exit:
 li a7, SYS_exit
     b36:	4889                	li	a7,2
 ecall
     b38:	00000073          	ecall
 ret
     b3c:	8082                	ret

0000000000000b3e <wait>:
.global wait
wait:
 li a7, SYS_wait
     b3e:	488d                	li	a7,3
 ecall
     b40:	00000073          	ecall
 ret
     b44:	8082                	ret

0000000000000b46 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     b46:	4891                	li	a7,4
 ecall
     b48:	00000073          	ecall
 ret
     b4c:	8082                	ret

0000000000000b4e <read>:
.global read
read:
 li a7, SYS_read
     b4e:	4895                	li	a7,5
 ecall
     b50:	00000073          	ecall
 ret
     b54:	8082                	ret

0000000000000b56 <write>:
.global write
write:
 li a7, SYS_write
     b56:	48c1                	li	a7,16
 ecall
     b58:	00000073          	ecall
 ret
     b5c:	8082                	ret

0000000000000b5e <close>:
.global close
close:
 li a7, SYS_close
     b5e:	48d5                	li	a7,21
 ecall
     b60:	00000073          	ecall
 ret
     b64:	8082                	ret

0000000000000b66 <kill>:
.global kill
kill:
 li a7, SYS_kill
     b66:	4899                	li	a7,6
 ecall
     b68:	00000073          	ecall
 ret
     b6c:	8082                	ret

0000000000000b6e <exec>:
.global exec
exec:
 li a7, SYS_exec
     b6e:	489d                	li	a7,7
 ecall
     b70:	00000073          	ecall
 ret
     b74:	8082                	ret

0000000000000b76 <open>:
.global open
open:
 li a7, SYS_open
     b76:	48bd                	li	a7,15
 ecall
     b78:	00000073          	ecall
 ret
     b7c:	8082                	ret

0000000000000b7e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     b7e:	48c5                	li	a7,17
 ecall
     b80:	00000073          	ecall
 ret
     b84:	8082                	ret

0000000000000b86 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     b86:	48c9                	li	a7,18
 ecall
     b88:	00000073          	ecall
 ret
     b8c:	8082                	ret

0000000000000b8e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     b8e:	48a1                	li	a7,8
 ecall
     b90:	00000073          	ecall
 ret
     b94:	8082                	ret

0000000000000b96 <link>:
.global link
link:
 li a7, SYS_link
     b96:	48cd                	li	a7,19
 ecall
     b98:	00000073          	ecall
 ret
     b9c:	8082                	ret

0000000000000b9e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     b9e:	48d1                	li	a7,20
 ecall
     ba0:	00000073          	ecall
 ret
     ba4:	8082                	ret

0000000000000ba6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     ba6:	48a5                	li	a7,9
 ecall
     ba8:	00000073          	ecall
 ret
     bac:	8082                	ret

0000000000000bae <dup>:
.global dup
dup:
 li a7, SYS_dup
     bae:	48a9                	li	a7,10
 ecall
     bb0:	00000073          	ecall
 ret
     bb4:	8082                	ret

0000000000000bb6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     bb6:	48ad                	li	a7,11
 ecall
     bb8:	00000073          	ecall
 ret
     bbc:	8082                	ret

0000000000000bbe <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     bbe:	48b1                	li	a7,12
 ecall
     bc0:	00000073          	ecall
 ret
     bc4:	8082                	ret

0000000000000bc6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     bc6:	48b5                	li	a7,13
 ecall
     bc8:	00000073          	ecall
 ret
     bcc:	8082                	ret

0000000000000bce <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     bce:	48b9                	li	a7,14
 ecall
     bd0:	00000073          	ecall
 ret
     bd4:	8082                	ret

0000000000000bd6 <connect>:
.global connect
connect:
 li a7, SYS_connect
     bd6:	48f5                	li	a7,29
 ecall
     bd8:	00000073          	ecall
 ret
     bdc:	8082                	ret

0000000000000bde <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
     bde:	48f9                	li	a7,30
 ecall
     be0:	00000073          	ecall
 ret
     be4:	8082                	ret

0000000000000be6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     be6:	1101                	addi	sp,sp,-32
     be8:	ec06                	sd	ra,24(sp)
     bea:	e822                	sd	s0,16(sp)
     bec:	1000                	addi	s0,sp,32
     bee:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     bf2:	4605                	li	a2,1
     bf4:	fef40593          	addi	a1,s0,-17
     bf8:	00000097          	auipc	ra,0x0
     bfc:	f5e080e7          	jalr	-162(ra) # b56 <write>
}
     c00:	60e2                	ld	ra,24(sp)
     c02:	6442                	ld	s0,16(sp)
     c04:	6105                	addi	sp,sp,32
     c06:	8082                	ret

0000000000000c08 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     c08:	7139                	addi	sp,sp,-64
     c0a:	fc06                	sd	ra,56(sp)
     c0c:	f822                	sd	s0,48(sp)
     c0e:	f426                	sd	s1,40(sp)
     c10:	f04a                	sd	s2,32(sp)
     c12:	ec4e                	sd	s3,24(sp)
     c14:	0080                	addi	s0,sp,64
     c16:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     c18:	c299                	beqz	a3,c1e <printint+0x16>
     c1a:	0805c963          	bltz	a1,cac <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     c1e:	2581                	sext.w	a1,a1
  neg = 0;
     c20:	4881                	li	a7,0
     c22:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     c26:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     c28:	2601                	sext.w	a2,a2
     c2a:	00000517          	auipc	a0,0x0
     c2e:	75e50513          	addi	a0,a0,1886 # 1388 <digits>
     c32:	883a                	mv	a6,a4
     c34:	2705                	addiw	a4,a4,1
     c36:	02c5f7bb          	remuw	a5,a1,a2
     c3a:	1782                	slli	a5,a5,0x20
     c3c:	9381                	srli	a5,a5,0x20
     c3e:	97aa                	add	a5,a5,a0
     c40:	0007c783          	lbu	a5,0(a5)
     c44:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     c48:	0005879b          	sext.w	a5,a1
     c4c:	02c5d5bb          	divuw	a1,a1,a2
     c50:	0685                	addi	a3,a3,1
     c52:	fec7f0e3          	bgeu	a5,a2,c32 <printint+0x2a>
  if(neg)
     c56:	00088c63          	beqz	a7,c6e <printint+0x66>
    buf[i++] = '-';
     c5a:	fd070793          	addi	a5,a4,-48
     c5e:	00878733          	add	a4,a5,s0
     c62:	02d00793          	li	a5,45
     c66:	fef70823          	sb	a5,-16(a4)
     c6a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     c6e:	02e05863          	blez	a4,c9e <printint+0x96>
     c72:	fc040793          	addi	a5,s0,-64
     c76:	00e78933          	add	s2,a5,a4
     c7a:	fff78993          	addi	s3,a5,-1
     c7e:	99ba                	add	s3,s3,a4
     c80:	377d                	addiw	a4,a4,-1
     c82:	1702                	slli	a4,a4,0x20
     c84:	9301                	srli	a4,a4,0x20
     c86:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     c8a:	fff94583          	lbu	a1,-1(s2)
     c8e:	8526                	mv	a0,s1
     c90:	00000097          	auipc	ra,0x0
     c94:	f56080e7          	jalr	-170(ra) # be6 <putc>
  while(--i >= 0)
     c98:	197d                	addi	s2,s2,-1
     c9a:	ff3918e3          	bne	s2,s3,c8a <printint+0x82>
}
     c9e:	70e2                	ld	ra,56(sp)
     ca0:	7442                	ld	s0,48(sp)
     ca2:	74a2                	ld	s1,40(sp)
     ca4:	7902                	ld	s2,32(sp)
     ca6:	69e2                	ld	s3,24(sp)
     ca8:	6121                	addi	sp,sp,64
     caa:	8082                	ret
    x = -xx;
     cac:	40b005bb          	negw	a1,a1
    neg = 1;
     cb0:	4885                	li	a7,1
    x = -xx;
     cb2:	bf85                	j	c22 <printint+0x1a>

0000000000000cb4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     cb4:	7119                	addi	sp,sp,-128
     cb6:	fc86                	sd	ra,120(sp)
     cb8:	f8a2                	sd	s0,112(sp)
     cba:	f4a6                	sd	s1,104(sp)
     cbc:	f0ca                	sd	s2,96(sp)
     cbe:	ecce                	sd	s3,88(sp)
     cc0:	e8d2                	sd	s4,80(sp)
     cc2:	e4d6                	sd	s5,72(sp)
     cc4:	e0da                	sd	s6,64(sp)
     cc6:	fc5e                	sd	s7,56(sp)
     cc8:	f862                	sd	s8,48(sp)
     cca:	f466                	sd	s9,40(sp)
     ccc:	f06a                	sd	s10,32(sp)
     cce:	ec6e                	sd	s11,24(sp)
     cd0:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     cd2:	0005c903          	lbu	s2,0(a1)
     cd6:	18090f63          	beqz	s2,e74 <vprintf+0x1c0>
     cda:	8aaa                	mv	s5,a0
     cdc:	8b32                	mv	s6,a2
     cde:	00158493          	addi	s1,a1,1
  state = 0;
     ce2:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     ce4:	02500a13          	li	s4,37
     ce8:	4c55                	li	s8,21
     cea:	00000c97          	auipc	s9,0x0
     cee:	646c8c93          	addi	s9,s9,1606 # 1330 <malloc+0x3b8>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
     cf2:	02800d93          	li	s11,40
  putc(fd, 'x');
     cf6:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     cf8:	00000b97          	auipc	s7,0x0
     cfc:	690b8b93          	addi	s7,s7,1680 # 1388 <digits>
     d00:	a839                	j	d1e <vprintf+0x6a>
        putc(fd, c);
     d02:	85ca                	mv	a1,s2
     d04:	8556                	mv	a0,s5
     d06:	00000097          	auipc	ra,0x0
     d0a:	ee0080e7          	jalr	-288(ra) # be6 <putc>
     d0e:	a019                	j	d14 <vprintf+0x60>
    } else if(state == '%'){
     d10:	01498d63          	beq	s3,s4,d2a <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
     d14:	0485                	addi	s1,s1,1
     d16:	fff4c903          	lbu	s2,-1(s1)
     d1a:	14090d63          	beqz	s2,e74 <vprintf+0x1c0>
    if(state == 0){
     d1e:	fe0999e3          	bnez	s3,d10 <vprintf+0x5c>
      if(c == '%'){
     d22:	ff4910e3          	bne	s2,s4,d02 <vprintf+0x4e>
        state = '%';
     d26:	89d2                	mv	s3,s4
     d28:	b7f5                	j	d14 <vprintf+0x60>
      if(c == 'd'){
     d2a:	11490c63          	beq	s2,s4,e42 <vprintf+0x18e>
     d2e:	f9d9079b          	addiw	a5,s2,-99
     d32:	0ff7f793          	zext.b	a5,a5
     d36:	10fc6e63          	bltu	s8,a5,e52 <vprintf+0x19e>
     d3a:	f9d9079b          	addiw	a5,s2,-99
     d3e:	0ff7f713          	zext.b	a4,a5
     d42:	10ec6863          	bltu	s8,a4,e52 <vprintf+0x19e>
     d46:	00271793          	slli	a5,a4,0x2
     d4a:	97e6                	add	a5,a5,s9
     d4c:	439c                	lw	a5,0(a5)
     d4e:	97e6                	add	a5,a5,s9
     d50:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
     d52:	008b0913          	addi	s2,s6,8
     d56:	4685                	li	a3,1
     d58:	4629                	li	a2,10
     d5a:	000b2583          	lw	a1,0(s6)
     d5e:	8556                	mv	a0,s5
     d60:	00000097          	auipc	ra,0x0
     d64:	ea8080e7          	jalr	-344(ra) # c08 <printint>
     d68:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
     d6a:	4981                	li	s3,0
     d6c:	b765                	j	d14 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
     d6e:	008b0913          	addi	s2,s6,8
     d72:	4681                	li	a3,0
     d74:	4629                	li	a2,10
     d76:	000b2583          	lw	a1,0(s6)
     d7a:	8556                	mv	a0,s5
     d7c:	00000097          	auipc	ra,0x0
     d80:	e8c080e7          	jalr	-372(ra) # c08 <printint>
     d84:	8b4a                	mv	s6,s2
      state = 0;
     d86:	4981                	li	s3,0
     d88:	b771                	j	d14 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
     d8a:	008b0913          	addi	s2,s6,8
     d8e:	4681                	li	a3,0
     d90:	866a                	mv	a2,s10
     d92:	000b2583          	lw	a1,0(s6)
     d96:	8556                	mv	a0,s5
     d98:	00000097          	auipc	ra,0x0
     d9c:	e70080e7          	jalr	-400(ra) # c08 <printint>
     da0:	8b4a                	mv	s6,s2
      state = 0;
     da2:	4981                	li	s3,0
     da4:	bf85                	j	d14 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
     da6:	008b0793          	addi	a5,s6,8
     daa:	f8f43423          	sd	a5,-120(s0)
     dae:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
     db2:	03000593          	li	a1,48
     db6:	8556                	mv	a0,s5
     db8:	00000097          	auipc	ra,0x0
     dbc:	e2e080e7          	jalr	-466(ra) # be6 <putc>
  putc(fd, 'x');
     dc0:	07800593          	li	a1,120
     dc4:	8556                	mv	a0,s5
     dc6:	00000097          	auipc	ra,0x0
     dca:	e20080e7          	jalr	-480(ra) # be6 <putc>
     dce:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     dd0:	03c9d793          	srli	a5,s3,0x3c
     dd4:	97de                	add	a5,a5,s7
     dd6:	0007c583          	lbu	a1,0(a5)
     dda:	8556                	mv	a0,s5
     ddc:	00000097          	auipc	ra,0x0
     de0:	e0a080e7          	jalr	-502(ra) # be6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     de4:	0992                	slli	s3,s3,0x4
     de6:	397d                	addiw	s2,s2,-1
     de8:	fe0914e3          	bnez	s2,dd0 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
     dec:	f8843b03          	ld	s6,-120(s0)
      state = 0;
     df0:	4981                	li	s3,0
     df2:	b70d                	j	d14 <vprintf+0x60>
        s = va_arg(ap, char*);
     df4:	008b0913          	addi	s2,s6,8
     df8:	000b3983          	ld	s3,0(s6)
        if(s == 0)
     dfc:	02098163          	beqz	s3,e1e <vprintf+0x16a>
        while(*s != 0){
     e00:	0009c583          	lbu	a1,0(s3)
     e04:	c5ad                	beqz	a1,e6e <vprintf+0x1ba>
          putc(fd, *s);
     e06:	8556                	mv	a0,s5
     e08:	00000097          	auipc	ra,0x0
     e0c:	dde080e7          	jalr	-546(ra) # be6 <putc>
          s++;
     e10:	0985                	addi	s3,s3,1
        while(*s != 0){
     e12:	0009c583          	lbu	a1,0(s3)
     e16:	f9e5                	bnez	a1,e06 <vprintf+0x152>
        s = va_arg(ap, char*);
     e18:	8b4a                	mv	s6,s2
      state = 0;
     e1a:	4981                	li	s3,0
     e1c:	bde5                	j	d14 <vprintf+0x60>
          s = "(null)";
     e1e:	00000997          	auipc	s3,0x0
     e22:	50a98993          	addi	s3,s3,1290 # 1328 <malloc+0x3b0>
        while(*s != 0){
     e26:	85ee                	mv	a1,s11
     e28:	bff9                	j	e06 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
     e2a:	008b0913          	addi	s2,s6,8
     e2e:	000b4583          	lbu	a1,0(s6)
     e32:	8556                	mv	a0,s5
     e34:	00000097          	auipc	ra,0x0
     e38:	db2080e7          	jalr	-590(ra) # be6 <putc>
     e3c:	8b4a                	mv	s6,s2
      state = 0;
     e3e:	4981                	li	s3,0
     e40:	bdd1                	j	d14 <vprintf+0x60>
        putc(fd, c);
     e42:	85d2                	mv	a1,s4
     e44:	8556                	mv	a0,s5
     e46:	00000097          	auipc	ra,0x0
     e4a:	da0080e7          	jalr	-608(ra) # be6 <putc>
      state = 0;
     e4e:	4981                	li	s3,0
     e50:	b5d1                	j	d14 <vprintf+0x60>
        putc(fd, '%');
     e52:	85d2                	mv	a1,s4
     e54:	8556                	mv	a0,s5
     e56:	00000097          	auipc	ra,0x0
     e5a:	d90080e7          	jalr	-624(ra) # be6 <putc>
        putc(fd, c);
     e5e:	85ca                	mv	a1,s2
     e60:	8556                	mv	a0,s5
     e62:	00000097          	auipc	ra,0x0
     e66:	d84080e7          	jalr	-636(ra) # be6 <putc>
      state = 0;
     e6a:	4981                	li	s3,0
     e6c:	b565                	j	d14 <vprintf+0x60>
        s = va_arg(ap, char*);
     e6e:	8b4a                	mv	s6,s2
      state = 0;
     e70:	4981                	li	s3,0
     e72:	b54d                	j	d14 <vprintf+0x60>
    }
  }
}
     e74:	70e6                	ld	ra,120(sp)
     e76:	7446                	ld	s0,112(sp)
     e78:	74a6                	ld	s1,104(sp)
     e7a:	7906                	ld	s2,96(sp)
     e7c:	69e6                	ld	s3,88(sp)
     e7e:	6a46                	ld	s4,80(sp)
     e80:	6aa6                	ld	s5,72(sp)
     e82:	6b06                	ld	s6,64(sp)
     e84:	7be2                	ld	s7,56(sp)
     e86:	7c42                	ld	s8,48(sp)
     e88:	7ca2                	ld	s9,40(sp)
     e8a:	7d02                	ld	s10,32(sp)
     e8c:	6de2                	ld	s11,24(sp)
     e8e:	6109                	addi	sp,sp,128
     e90:	8082                	ret

0000000000000e92 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     e92:	715d                	addi	sp,sp,-80
     e94:	ec06                	sd	ra,24(sp)
     e96:	e822                	sd	s0,16(sp)
     e98:	1000                	addi	s0,sp,32
     e9a:	e010                	sd	a2,0(s0)
     e9c:	e414                	sd	a3,8(s0)
     e9e:	e818                	sd	a4,16(s0)
     ea0:	ec1c                	sd	a5,24(s0)
     ea2:	03043023          	sd	a6,32(s0)
     ea6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
     eaa:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
     eae:	8622                	mv	a2,s0
     eb0:	00000097          	auipc	ra,0x0
     eb4:	e04080e7          	jalr	-508(ra) # cb4 <vprintf>
}
     eb8:	60e2                	ld	ra,24(sp)
     eba:	6442                	ld	s0,16(sp)
     ebc:	6161                	addi	sp,sp,80
     ebe:	8082                	ret

0000000000000ec0 <printf>:

void
printf(const char *fmt, ...)
{
     ec0:	711d                	addi	sp,sp,-96
     ec2:	ec06                	sd	ra,24(sp)
     ec4:	e822                	sd	s0,16(sp)
     ec6:	1000                	addi	s0,sp,32
     ec8:	e40c                	sd	a1,8(s0)
     eca:	e810                	sd	a2,16(s0)
     ecc:	ec14                	sd	a3,24(s0)
     ece:	f018                	sd	a4,32(s0)
     ed0:	f41c                	sd	a5,40(s0)
     ed2:	03043823          	sd	a6,48(s0)
     ed6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
     eda:	00840613          	addi	a2,s0,8
     ede:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
     ee2:	85aa                	mv	a1,a0
     ee4:	4505                	li	a0,1
     ee6:	00000097          	auipc	ra,0x0
     eea:	dce080e7          	jalr	-562(ra) # cb4 <vprintf>
}
     eee:	60e2                	ld	ra,24(sp)
     ef0:	6442                	ld	s0,16(sp)
     ef2:	6125                	addi	sp,sp,96
     ef4:	8082                	ret

0000000000000ef6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     ef6:	1141                	addi	sp,sp,-16
     ef8:	e422                	sd	s0,8(sp)
     efa:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
     efc:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     f00:	00000797          	auipc	a5,0x0
     f04:	4a07b783          	ld	a5,1184(a5) # 13a0 <freep>
     f08:	a02d                	j	f32 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
     f0a:	4618                	lw	a4,8(a2)
     f0c:	9f2d                	addw	a4,a4,a1
     f0e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
     f12:	6398                	ld	a4,0(a5)
     f14:	6310                	ld	a2,0(a4)
     f16:	a83d                	j	f54 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
     f18:	ff852703          	lw	a4,-8(a0)
     f1c:	9f31                	addw	a4,a4,a2
     f1e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
     f20:	ff053683          	ld	a3,-16(a0)
     f24:	a091                	j	f68 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     f26:	6398                	ld	a4,0(a5)
     f28:	00e7e463          	bltu	a5,a4,f30 <free+0x3a>
     f2c:	00e6ea63          	bltu	a3,a4,f40 <free+0x4a>
{
     f30:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     f32:	fed7fae3          	bgeu	a5,a3,f26 <free+0x30>
     f36:	6398                	ld	a4,0(a5)
     f38:	00e6e463          	bltu	a3,a4,f40 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     f3c:	fee7eae3          	bltu	a5,a4,f30 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
     f40:	ff852583          	lw	a1,-8(a0)
     f44:	6390                	ld	a2,0(a5)
     f46:	02059813          	slli	a6,a1,0x20
     f4a:	01c85713          	srli	a4,a6,0x1c
     f4e:	9736                	add	a4,a4,a3
     f50:	fae60de3          	beq	a2,a4,f0a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
     f54:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
     f58:	4790                	lw	a2,8(a5)
     f5a:	02061593          	slli	a1,a2,0x20
     f5e:	01c5d713          	srli	a4,a1,0x1c
     f62:	973e                	add	a4,a4,a5
     f64:	fae68ae3          	beq	a3,a4,f18 <free+0x22>
    p->s.ptr = bp->s.ptr;
     f68:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
     f6a:	00000717          	auipc	a4,0x0
     f6e:	42f73b23          	sd	a5,1078(a4) # 13a0 <freep>
}
     f72:	6422                	ld	s0,8(sp)
     f74:	0141                	addi	sp,sp,16
     f76:	8082                	ret

0000000000000f78 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
     f78:	7139                	addi	sp,sp,-64
     f7a:	fc06                	sd	ra,56(sp)
     f7c:	f822                	sd	s0,48(sp)
     f7e:	f426                	sd	s1,40(sp)
     f80:	f04a                	sd	s2,32(sp)
     f82:	ec4e                	sd	s3,24(sp)
     f84:	e852                	sd	s4,16(sp)
     f86:	e456                	sd	s5,8(sp)
     f88:	e05a                	sd	s6,0(sp)
     f8a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     f8c:	02051493          	slli	s1,a0,0x20
     f90:	9081                	srli	s1,s1,0x20
     f92:	04bd                	addi	s1,s1,15
     f94:	8091                	srli	s1,s1,0x4
     f96:	0014899b          	addiw	s3,s1,1
     f9a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
     f9c:	00000517          	auipc	a0,0x0
     fa0:	40453503          	ld	a0,1028(a0) # 13a0 <freep>
     fa4:	c515                	beqz	a0,fd0 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     fa6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
     fa8:	4798                	lw	a4,8(a5)
     faa:	02977f63          	bgeu	a4,s1,fe8 <malloc+0x70>
     fae:	8a4e                	mv	s4,s3
     fb0:	0009871b          	sext.w	a4,s3
     fb4:	6685                	lui	a3,0x1
     fb6:	00d77363          	bgeu	a4,a3,fbc <malloc+0x44>
     fba:	6a05                	lui	s4,0x1
     fbc:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
     fc0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
     fc4:	00000917          	auipc	s2,0x0
     fc8:	3dc90913          	addi	s2,s2,988 # 13a0 <freep>
  if(p == (char*)-1)
     fcc:	5afd                	li	s5,-1
     fce:	a895                	j	1042 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
     fd0:	00000797          	auipc	a5,0x0
     fd4:	3d878793          	addi	a5,a5,984 # 13a8 <base>
     fd8:	00000717          	auipc	a4,0x0
     fdc:	3cf73423          	sd	a5,968(a4) # 13a0 <freep>
     fe0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
     fe2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
     fe6:	b7e1                	j	fae <malloc+0x36>
      if(p->s.size == nunits)
     fe8:	02e48c63          	beq	s1,a4,1020 <malloc+0xa8>
        p->s.size -= nunits;
     fec:	4137073b          	subw	a4,a4,s3
     ff0:	c798                	sw	a4,8(a5)
        p += p->s.size;
     ff2:	02071693          	slli	a3,a4,0x20
     ff6:	01c6d713          	srli	a4,a3,0x1c
     ffa:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
     ffc:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1000:	00000717          	auipc	a4,0x0
    1004:	3aa73023          	sd	a0,928(a4) # 13a0 <freep>
      return (void*)(p + 1);
    1008:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    100c:	70e2                	ld	ra,56(sp)
    100e:	7442                	ld	s0,48(sp)
    1010:	74a2                	ld	s1,40(sp)
    1012:	7902                	ld	s2,32(sp)
    1014:	69e2                	ld	s3,24(sp)
    1016:	6a42                	ld	s4,16(sp)
    1018:	6aa2                	ld	s5,8(sp)
    101a:	6b02                	ld	s6,0(sp)
    101c:	6121                	addi	sp,sp,64
    101e:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    1020:	6398                	ld	a4,0(a5)
    1022:	e118                	sd	a4,0(a0)
    1024:	bff1                	j	1000 <malloc+0x88>
  hp->s.size = nu;
    1026:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    102a:	0541                	addi	a0,a0,16
    102c:	00000097          	auipc	ra,0x0
    1030:	eca080e7          	jalr	-310(ra) # ef6 <free>
  return freep;
    1034:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    1038:	d971                	beqz	a0,100c <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    103a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    103c:	4798                	lw	a4,8(a5)
    103e:	fa9775e3          	bgeu	a4,s1,fe8 <malloc+0x70>
    if(p == freep)
    1042:	00093703          	ld	a4,0(s2)
    1046:	853e                	mv	a0,a5
    1048:	fef719e3          	bne	a4,a5,103a <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
    104c:	8552                	mv	a0,s4
    104e:	00000097          	auipc	ra,0x0
    1052:	b70080e7          	jalr	-1168(ra) # bbe <sbrk>
  if(p == (char*)-1)
    1056:	fd5518e3          	bne	a0,s5,1026 <malloc+0xae>
        return 0;
    105a:	4501                	li	a0,0
    105c:	bf45                	j	100c <malloc+0x94>
