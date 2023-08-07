
user/_grep:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <matchstar>:
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  10:	892a                	mv	s2,a0
  12:	89ae                	mv	s3,a1
  14:	84b2                	mv	s1,a2
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  16:	02e00a13          	li	s4,46
    if(matchhere(re, text))
  1a:	85a6                	mv	a1,s1
  1c:	854e                	mv	a0,s3
  1e:	00000097          	auipc	ra,0x0
  22:	030080e7          	jalr	48(ra) # 4e <matchhere>
  26:	e919                	bnez	a0,3c <matchstar+0x3c>
  }while(*text!='\0' && (*text++==c || c=='.'));
  28:	0004c783          	lbu	a5,0(s1)
  2c:	cb89                	beqz	a5,3e <matchstar+0x3e>
  2e:	0485                	addi	s1,s1,1
  30:	2781                	sext.w	a5,a5
  32:	ff2784e3          	beq	a5,s2,1a <matchstar+0x1a>
  36:	ff4902e3          	beq	s2,s4,1a <matchstar+0x1a>
  3a:	a011                	j	3e <matchstar+0x3e>
      return 1;
  3c:	4505                	li	a0,1
  return 0;
}
  3e:	70a2                	ld	ra,40(sp)
  40:	7402                	ld	s0,32(sp)
  42:	64e2                	ld	s1,24(sp)
  44:	6942                	ld	s2,16(sp)
  46:	69a2                	ld	s3,8(sp)
  48:	6a02                	ld	s4,0(sp)
  4a:	6145                	addi	sp,sp,48
  4c:	8082                	ret

000000000000004e <matchhere>:
  if(re[0] == '\0')
  4e:	00054703          	lbu	a4,0(a0)
  52:	cb3d                	beqz	a4,c8 <matchhere+0x7a>
{
  54:	1141                	addi	sp,sp,-16
  56:	e406                	sd	ra,8(sp)
  58:	e022                	sd	s0,0(sp)
  5a:	0800                	addi	s0,sp,16
  5c:	87aa                	mv	a5,a0
  if(re[1] == '*')
  5e:	00154683          	lbu	a3,1(a0)
  62:	02a00613          	li	a2,42
  66:	02c68563          	beq	a3,a2,90 <matchhere+0x42>
  if(re[0] == '$' && re[1] == '\0')
  6a:	02400613          	li	a2,36
  6e:	02c70a63          	beq	a4,a2,a2 <matchhere+0x54>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  72:	0005c683          	lbu	a3,0(a1)
  return 0;
  76:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  78:	ca81                	beqz	a3,88 <matchhere+0x3a>
  7a:	02e00613          	li	a2,46
  7e:	02c70d63          	beq	a4,a2,b8 <matchhere+0x6a>
  return 0;
  82:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  84:	02d70a63          	beq	a4,a3,b8 <matchhere+0x6a>
}
  88:	60a2                	ld	ra,8(sp)
  8a:	6402                	ld	s0,0(sp)
  8c:	0141                	addi	sp,sp,16
  8e:	8082                	ret
    return matchstar(re[0], re+2, text);
  90:	862e                	mv	a2,a1
  92:	00250593          	addi	a1,a0,2
  96:	853a                	mv	a0,a4
  98:	00000097          	auipc	ra,0x0
  9c:	f68080e7          	jalr	-152(ra) # 0 <matchstar>
  a0:	b7e5                	j	88 <matchhere+0x3a>
  if(re[0] == '$' && re[1] == '\0')
  a2:	c691                	beqz	a3,ae <matchhere+0x60>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  a4:	0005c683          	lbu	a3,0(a1)
  a8:	fee9                	bnez	a3,82 <matchhere+0x34>
  return 0;
  aa:	4501                	li	a0,0
  ac:	bff1                	j	88 <matchhere+0x3a>
    return *text == '\0';
  ae:	0005c503          	lbu	a0,0(a1)
  b2:	00153513          	seqz	a0,a0
  b6:	bfc9                	j	88 <matchhere+0x3a>
    return matchhere(re+1, text+1);
  b8:	0585                	addi	a1,a1,1
  ba:	00178513          	addi	a0,a5,1
  be:	00000097          	auipc	ra,0x0
  c2:	f90080e7          	jalr	-112(ra) # 4e <matchhere>
  c6:	b7c9                	j	88 <matchhere+0x3a>
    return 1;
  c8:	4505                	li	a0,1
}
  ca:	8082                	ret

00000000000000cc <match>:
{
  cc:	1101                	addi	sp,sp,-32
  ce:	ec06                	sd	ra,24(sp)
  d0:	e822                	sd	s0,16(sp)
  d2:	e426                	sd	s1,8(sp)
  d4:	e04a                	sd	s2,0(sp)
  d6:	1000                	addi	s0,sp,32
  d8:	892a                	mv	s2,a0
  da:	84ae                	mv	s1,a1
  if(re[0] == '^')
  dc:	00054703          	lbu	a4,0(a0)
  e0:	05e00793          	li	a5,94
  e4:	00f70e63          	beq	a4,a5,100 <match+0x34>
    if(matchhere(re, text))
  e8:	85a6                	mv	a1,s1
  ea:	854a                	mv	a0,s2
  ec:	00000097          	auipc	ra,0x0
  f0:	f62080e7          	jalr	-158(ra) # 4e <matchhere>
  f4:	ed01                	bnez	a0,10c <match+0x40>
  }while(*text++ != '\0');
  f6:	0485                	addi	s1,s1,1
  f8:	fff4c783          	lbu	a5,-1(s1)
  fc:	f7f5                	bnez	a5,e8 <match+0x1c>
  fe:	a801                	j	10e <match+0x42>
    return matchhere(re+1, text);
 100:	0505                	addi	a0,a0,1
 102:	00000097          	auipc	ra,0x0
 106:	f4c080e7          	jalr	-180(ra) # 4e <matchhere>
 10a:	a011                	j	10e <match+0x42>
      return 1;
 10c:	4505                	li	a0,1
}
 10e:	60e2                	ld	ra,24(sp)
 110:	6442                	ld	s0,16(sp)
 112:	64a2                	ld	s1,8(sp)
 114:	6902                	ld	s2,0(sp)
 116:	6105                	addi	sp,sp,32
 118:	8082                	ret

000000000000011a <grep>:
{
 11a:	715d                	addi	sp,sp,-80
 11c:	e486                	sd	ra,72(sp)
 11e:	e0a2                	sd	s0,64(sp)
 120:	fc26                	sd	s1,56(sp)
 122:	f84a                	sd	s2,48(sp)
 124:	f44e                	sd	s3,40(sp)
 126:	f052                	sd	s4,32(sp)
 128:	ec56                	sd	s5,24(sp)
 12a:	e85a                	sd	s6,16(sp)
 12c:	e45e                	sd	s7,8(sp)
 12e:	0880                	addi	s0,sp,80
 130:	89aa                	mv	s3,a0
 132:	8b2e                	mv	s6,a1
  m = 0;
 134:	4a01                	li	s4,0
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 136:	3ff00b93          	li	s7,1023
 13a:	00001a97          	auipc	s5,0x1
 13e:	9aea8a93          	addi	s5,s5,-1618 # ae8 <buf>
 142:	a0a1                	j	18a <grep+0x70>
      p = q+1;
 144:	00148913          	addi	s2,s1,1
    while((q = strchr(p, '\n')) != 0){
 148:	45a9                	li	a1,10
 14a:	854a                	mv	a0,s2
 14c:	00000097          	auipc	ra,0x0
 150:	1e6080e7          	jalr	486(ra) # 332 <strchr>
 154:	84aa                	mv	s1,a0
 156:	c905                	beqz	a0,186 <grep+0x6c>
      *q = 0;
 158:	00048023          	sb	zero,0(s1)
      if(match(pattern, p)){
 15c:	85ca                	mv	a1,s2
 15e:	854e                	mv	a0,s3
 160:	00000097          	auipc	ra,0x0
 164:	f6c080e7          	jalr	-148(ra) # cc <match>
 168:	dd71                	beqz	a0,144 <grep+0x2a>
        *q = '\n';
 16a:	47a9                	li	a5,10
 16c:	00f48023          	sb	a5,0(s1)
        write(1, p, q+1 - p);
 170:	00148613          	addi	a2,s1,1
 174:	4126063b          	subw	a2,a2,s2
 178:	85ca                	mv	a1,s2
 17a:	4505                	li	a0,1
 17c:	00000097          	auipc	ra,0x0
 180:	3ae080e7          	jalr	942(ra) # 52a <write>
 184:	b7c1                	j	144 <grep+0x2a>
    if(m > 0){
 186:	03404563          	bgtz	s4,1b0 <grep+0x96>
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 18a:	414b863b          	subw	a2,s7,s4
 18e:	014a85b3          	add	a1,s5,s4
 192:	855a                	mv	a0,s6
 194:	00000097          	auipc	ra,0x0
 198:	38e080e7          	jalr	910(ra) # 522 <read>
 19c:	02a05663          	blez	a0,1c8 <grep+0xae>
    m += n;
 1a0:	00aa0a3b          	addw	s4,s4,a0
    buf[m] = '\0';
 1a4:	014a87b3          	add	a5,s5,s4
 1a8:	00078023          	sb	zero,0(a5)
    p = buf;
 1ac:	8956                	mv	s2,s5
    while((q = strchr(p, '\n')) != 0){
 1ae:	bf69                	j	148 <grep+0x2e>
      m -= p - buf;
 1b0:	415907b3          	sub	a5,s2,s5
 1b4:	40fa0a3b          	subw	s4,s4,a5
      memmove(buf, p, m);
 1b8:	8652                	mv	a2,s4
 1ba:	85ca                	mv	a1,s2
 1bc:	8556                	mv	a0,s5
 1be:	00000097          	auipc	ra,0x0
 1c2:	29a080e7          	jalr	666(ra) # 458 <memmove>
 1c6:	b7d1                	j	18a <grep+0x70>
}
 1c8:	60a6                	ld	ra,72(sp)
 1ca:	6406                	ld	s0,64(sp)
 1cc:	74e2                	ld	s1,56(sp)
 1ce:	7942                	ld	s2,48(sp)
 1d0:	79a2                	ld	s3,40(sp)
 1d2:	7a02                	ld	s4,32(sp)
 1d4:	6ae2                	ld	s5,24(sp)
 1d6:	6b42                	ld	s6,16(sp)
 1d8:	6ba2                	ld	s7,8(sp)
 1da:	6161                	addi	sp,sp,80
 1dc:	8082                	ret

00000000000001de <main>:
{
 1de:	7139                	addi	sp,sp,-64
 1e0:	fc06                	sd	ra,56(sp)
 1e2:	f822                	sd	s0,48(sp)
 1e4:	f426                	sd	s1,40(sp)
 1e6:	f04a                	sd	s2,32(sp)
 1e8:	ec4e                	sd	s3,24(sp)
 1ea:	e852                	sd	s4,16(sp)
 1ec:	e456                	sd	s5,8(sp)
 1ee:	0080                	addi	s0,sp,64
  if(argc <= 1){
 1f0:	4785                	li	a5,1
 1f2:	04a7de63          	bge	a5,a0,24e <main+0x70>
  pattern = argv[1];
 1f6:	0085ba03          	ld	s4,8(a1)
  if(argc <= 2){
 1fa:	4789                	li	a5,2
 1fc:	06a7d763          	bge	a5,a0,26a <main+0x8c>
 200:	01058913          	addi	s2,a1,16
 204:	ffd5099b          	addiw	s3,a0,-3
 208:	02099793          	slli	a5,s3,0x20
 20c:	01d7d993          	srli	s3,a5,0x1d
 210:	05e1                	addi	a1,a1,24
 212:	99ae                	add	s3,s3,a1
    if((fd = open(argv[i], 0)) < 0){
 214:	4581                	li	a1,0
 216:	00093503          	ld	a0,0(s2)
 21a:	00000097          	auipc	ra,0x0
 21e:	330080e7          	jalr	816(ra) # 54a <open>
 222:	84aa                	mv	s1,a0
 224:	04054e63          	bltz	a0,280 <main+0xa2>
    grep(pattern, fd);
 228:	85aa                	mv	a1,a0
 22a:	8552                	mv	a0,s4
 22c:	00000097          	auipc	ra,0x0
 230:	eee080e7          	jalr	-274(ra) # 11a <grep>
    close(fd);
 234:	8526                	mv	a0,s1
 236:	00000097          	auipc	ra,0x0
 23a:	2fc080e7          	jalr	764(ra) # 532 <close>
  for(i = 2; i < argc; i++){
 23e:	0921                	addi	s2,s2,8
 240:	fd391ae3          	bne	s2,s3,214 <main+0x36>
  exit(0);
 244:	4501                	li	a0,0
 246:	00000097          	auipc	ra,0x0
 24a:	2c4080e7          	jalr	708(ra) # 50a <exit>
    fprintf(2, "usage: grep pattern [file ...]\n");
 24e:	00000597          	auipc	a1,0x0
 252:	7e258593          	addi	a1,a1,2018 # a30 <malloc+0xec>
 256:	4509                	li	a0,2
 258:	00000097          	auipc	ra,0x0
 25c:	606080e7          	jalr	1542(ra) # 85e <fprintf>
    exit(1);
 260:	4505                	li	a0,1
 262:	00000097          	auipc	ra,0x0
 266:	2a8080e7          	jalr	680(ra) # 50a <exit>
    grep(pattern, 0);
 26a:	4581                	li	a1,0
 26c:	8552                	mv	a0,s4
 26e:	00000097          	auipc	ra,0x0
 272:	eac080e7          	jalr	-340(ra) # 11a <grep>
    exit(0);
 276:	4501                	li	a0,0
 278:	00000097          	auipc	ra,0x0
 27c:	292080e7          	jalr	658(ra) # 50a <exit>
      printf("grep: cannot open %s\n", argv[i]);
 280:	00093583          	ld	a1,0(s2)
 284:	00000517          	auipc	a0,0x0
 288:	7cc50513          	addi	a0,a0,1996 # a50 <malloc+0x10c>
 28c:	00000097          	auipc	ra,0x0
 290:	600080e7          	jalr	1536(ra) # 88c <printf>
      exit(1);
 294:	4505                	li	a0,1
 296:	00000097          	auipc	ra,0x0
 29a:	274080e7          	jalr	628(ra) # 50a <exit>

000000000000029e <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 29e:	1141                	addi	sp,sp,-16
 2a0:	e422                	sd	s0,8(sp)
 2a2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2a4:	87aa                	mv	a5,a0
 2a6:	0585                	addi	a1,a1,1
 2a8:	0785                	addi	a5,a5,1
 2aa:	fff5c703          	lbu	a4,-1(a1)
 2ae:	fee78fa3          	sb	a4,-1(a5)
 2b2:	fb75                	bnez	a4,2a6 <strcpy+0x8>
    ;
  return os;
}
 2b4:	6422                	ld	s0,8(sp)
 2b6:	0141                	addi	sp,sp,16
 2b8:	8082                	ret

00000000000002ba <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2ba:	1141                	addi	sp,sp,-16
 2bc:	e422                	sd	s0,8(sp)
 2be:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2c0:	00054783          	lbu	a5,0(a0)
 2c4:	cb91                	beqz	a5,2d8 <strcmp+0x1e>
 2c6:	0005c703          	lbu	a4,0(a1)
 2ca:	00f71763          	bne	a4,a5,2d8 <strcmp+0x1e>
    p++, q++;
 2ce:	0505                	addi	a0,a0,1
 2d0:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2d2:	00054783          	lbu	a5,0(a0)
 2d6:	fbe5                	bnez	a5,2c6 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2d8:	0005c503          	lbu	a0,0(a1)
}
 2dc:	40a7853b          	subw	a0,a5,a0
 2e0:	6422                	ld	s0,8(sp)
 2e2:	0141                	addi	sp,sp,16
 2e4:	8082                	ret

00000000000002e6 <strlen>:

uint
strlen(const char *s)
{
 2e6:	1141                	addi	sp,sp,-16
 2e8:	e422                	sd	s0,8(sp)
 2ea:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2ec:	00054783          	lbu	a5,0(a0)
 2f0:	cf91                	beqz	a5,30c <strlen+0x26>
 2f2:	0505                	addi	a0,a0,1
 2f4:	87aa                	mv	a5,a0
 2f6:	4685                	li	a3,1
 2f8:	9e89                	subw	a3,a3,a0
 2fa:	00f6853b          	addw	a0,a3,a5
 2fe:	0785                	addi	a5,a5,1
 300:	fff7c703          	lbu	a4,-1(a5)
 304:	fb7d                	bnez	a4,2fa <strlen+0x14>
    ;
  return n;
}
 306:	6422                	ld	s0,8(sp)
 308:	0141                	addi	sp,sp,16
 30a:	8082                	ret
  for(n = 0; s[n]; n++)
 30c:	4501                	li	a0,0
 30e:	bfe5                	j	306 <strlen+0x20>

0000000000000310 <memset>:

void*
memset(void *dst, int c, uint n)
{
 310:	1141                	addi	sp,sp,-16
 312:	e422                	sd	s0,8(sp)
 314:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 316:	ca19                	beqz	a2,32c <memset+0x1c>
 318:	87aa                	mv	a5,a0
 31a:	1602                	slli	a2,a2,0x20
 31c:	9201                	srli	a2,a2,0x20
 31e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 322:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 326:	0785                	addi	a5,a5,1
 328:	fee79de3          	bne	a5,a4,322 <memset+0x12>
  }
  return dst;
}
 32c:	6422                	ld	s0,8(sp)
 32e:	0141                	addi	sp,sp,16
 330:	8082                	ret

0000000000000332 <strchr>:

char*
strchr(const char *s, char c)
{
 332:	1141                	addi	sp,sp,-16
 334:	e422                	sd	s0,8(sp)
 336:	0800                	addi	s0,sp,16
  for(; *s; s++)
 338:	00054783          	lbu	a5,0(a0)
 33c:	cb99                	beqz	a5,352 <strchr+0x20>
    if(*s == c)
 33e:	00f58763          	beq	a1,a5,34c <strchr+0x1a>
  for(; *s; s++)
 342:	0505                	addi	a0,a0,1
 344:	00054783          	lbu	a5,0(a0)
 348:	fbfd                	bnez	a5,33e <strchr+0xc>
      return (char*)s;
  return 0;
 34a:	4501                	li	a0,0
}
 34c:	6422                	ld	s0,8(sp)
 34e:	0141                	addi	sp,sp,16
 350:	8082                	ret
  return 0;
 352:	4501                	li	a0,0
 354:	bfe5                	j	34c <strchr+0x1a>

0000000000000356 <gets>:

char*
gets(char *buf, int max)
{
 356:	711d                	addi	sp,sp,-96
 358:	ec86                	sd	ra,88(sp)
 35a:	e8a2                	sd	s0,80(sp)
 35c:	e4a6                	sd	s1,72(sp)
 35e:	e0ca                	sd	s2,64(sp)
 360:	fc4e                	sd	s3,56(sp)
 362:	f852                	sd	s4,48(sp)
 364:	f456                	sd	s5,40(sp)
 366:	f05a                	sd	s6,32(sp)
 368:	ec5e                	sd	s7,24(sp)
 36a:	1080                	addi	s0,sp,96
 36c:	8baa                	mv	s7,a0
 36e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 370:	892a                	mv	s2,a0
 372:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 374:	4aa9                	li	s5,10
 376:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 378:	89a6                	mv	s3,s1
 37a:	2485                	addiw	s1,s1,1
 37c:	0344d863          	bge	s1,s4,3ac <gets+0x56>
    cc = read(0, &c, 1);
 380:	4605                	li	a2,1
 382:	faf40593          	addi	a1,s0,-81
 386:	4501                	li	a0,0
 388:	00000097          	auipc	ra,0x0
 38c:	19a080e7          	jalr	410(ra) # 522 <read>
    if(cc < 1)
 390:	00a05e63          	blez	a0,3ac <gets+0x56>
    buf[i++] = c;
 394:	faf44783          	lbu	a5,-81(s0)
 398:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 39c:	01578763          	beq	a5,s5,3aa <gets+0x54>
 3a0:	0905                	addi	s2,s2,1
 3a2:	fd679be3          	bne	a5,s6,378 <gets+0x22>
  for(i=0; i+1 < max; ){
 3a6:	89a6                	mv	s3,s1
 3a8:	a011                	j	3ac <gets+0x56>
 3aa:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3ac:	99de                	add	s3,s3,s7
 3ae:	00098023          	sb	zero,0(s3)
  return buf;
}
 3b2:	855e                	mv	a0,s7
 3b4:	60e6                	ld	ra,88(sp)
 3b6:	6446                	ld	s0,80(sp)
 3b8:	64a6                	ld	s1,72(sp)
 3ba:	6906                	ld	s2,64(sp)
 3bc:	79e2                	ld	s3,56(sp)
 3be:	7a42                	ld	s4,48(sp)
 3c0:	7aa2                	ld	s5,40(sp)
 3c2:	7b02                	ld	s6,32(sp)
 3c4:	6be2                	ld	s7,24(sp)
 3c6:	6125                	addi	sp,sp,96
 3c8:	8082                	ret

00000000000003ca <stat>:

int
stat(const char *n, struct stat *st)
{
 3ca:	1101                	addi	sp,sp,-32
 3cc:	ec06                	sd	ra,24(sp)
 3ce:	e822                	sd	s0,16(sp)
 3d0:	e426                	sd	s1,8(sp)
 3d2:	e04a                	sd	s2,0(sp)
 3d4:	1000                	addi	s0,sp,32
 3d6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3d8:	4581                	li	a1,0
 3da:	00000097          	auipc	ra,0x0
 3de:	170080e7          	jalr	368(ra) # 54a <open>
  if(fd < 0)
 3e2:	02054563          	bltz	a0,40c <stat+0x42>
 3e6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3e8:	85ca                	mv	a1,s2
 3ea:	00000097          	auipc	ra,0x0
 3ee:	178080e7          	jalr	376(ra) # 562 <fstat>
 3f2:	892a                	mv	s2,a0
  close(fd);
 3f4:	8526                	mv	a0,s1
 3f6:	00000097          	auipc	ra,0x0
 3fa:	13c080e7          	jalr	316(ra) # 532 <close>
  return r;
}
 3fe:	854a                	mv	a0,s2
 400:	60e2                	ld	ra,24(sp)
 402:	6442                	ld	s0,16(sp)
 404:	64a2                	ld	s1,8(sp)
 406:	6902                	ld	s2,0(sp)
 408:	6105                	addi	sp,sp,32
 40a:	8082                	ret
    return -1;
 40c:	597d                	li	s2,-1
 40e:	bfc5                	j	3fe <stat+0x34>

0000000000000410 <atoi>:

int
atoi(const char *s)
{
 410:	1141                	addi	sp,sp,-16
 412:	e422                	sd	s0,8(sp)
 414:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 416:	00054683          	lbu	a3,0(a0)
 41a:	fd06879b          	addiw	a5,a3,-48
 41e:	0ff7f793          	zext.b	a5,a5
 422:	4625                	li	a2,9
 424:	02f66863          	bltu	a2,a5,454 <atoi+0x44>
 428:	872a                	mv	a4,a0
  n = 0;
 42a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 42c:	0705                	addi	a4,a4,1
 42e:	0025179b          	slliw	a5,a0,0x2
 432:	9fa9                	addw	a5,a5,a0
 434:	0017979b          	slliw	a5,a5,0x1
 438:	9fb5                	addw	a5,a5,a3
 43a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 43e:	00074683          	lbu	a3,0(a4)
 442:	fd06879b          	addiw	a5,a3,-48
 446:	0ff7f793          	zext.b	a5,a5
 44a:	fef671e3          	bgeu	a2,a5,42c <atoi+0x1c>
  return n;
}
 44e:	6422                	ld	s0,8(sp)
 450:	0141                	addi	sp,sp,16
 452:	8082                	ret
  n = 0;
 454:	4501                	li	a0,0
 456:	bfe5                	j	44e <atoi+0x3e>

0000000000000458 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 458:	1141                	addi	sp,sp,-16
 45a:	e422                	sd	s0,8(sp)
 45c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 45e:	02b57463          	bgeu	a0,a1,486 <memmove+0x2e>
    while(n-- > 0)
 462:	00c05f63          	blez	a2,480 <memmove+0x28>
 466:	1602                	slli	a2,a2,0x20
 468:	9201                	srli	a2,a2,0x20
 46a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 46e:	872a                	mv	a4,a0
      *dst++ = *src++;
 470:	0585                	addi	a1,a1,1
 472:	0705                	addi	a4,a4,1
 474:	fff5c683          	lbu	a3,-1(a1)
 478:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 47c:	fee79ae3          	bne	a5,a4,470 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 480:	6422                	ld	s0,8(sp)
 482:	0141                	addi	sp,sp,16
 484:	8082                	ret
    dst += n;
 486:	00c50733          	add	a4,a0,a2
    src += n;
 48a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 48c:	fec05ae3          	blez	a2,480 <memmove+0x28>
 490:	fff6079b          	addiw	a5,a2,-1
 494:	1782                	slli	a5,a5,0x20
 496:	9381                	srli	a5,a5,0x20
 498:	fff7c793          	not	a5,a5
 49c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 49e:	15fd                	addi	a1,a1,-1
 4a0:	177d                	addi	a4,a4,-1
 4a2:	0005c683          	lbu	a3,0(a1)
 4a6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4aa:	fee79ae3          	bne	a5,a4,49e <memmove+0x46>
 4ae:	bfc9                	j	480 <memmove+0x28>

00000000000004b0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4b0:	1141                	addi	sp,sp,-16
 4b2:	e422                	sd	s0,8(sp)
 4b4:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4b6:	ca05                	beqz	a2,4e6 <memcmp+0x36>
 4b8:	fff6069b          	addiw	a3,a2,-1
 4bc:	1682                	slli	a3,a3,0x20
 4be:	9281                	srli	a3,a3,0x20
 4c0:	0685                	addi	a3,a3,1
 4c2:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 4c4:	00054783          	lbu	a5,0(a0)
 4c8:	0005c703          	lbu	a4,0(a1)
 4cc:	00e79863          	bne	a5,a4,4dc <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 4d0:	0505                	addi	a0,a0,1
    p2++;
 4d2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4d4:	fed518e3          	bne	a0,a3,4c4 <memcmp+0x14>
  }
  return 0;
 4d8:	4501                	li	a0,0
 4da:	a019                	j	4e0 <memcmp+0x30>
      return *p1 - *p2;
 4dc:	40e7853b          	subw	a0,a5,a4
}
 4e0:	6422                	ld	s0,8(sp)
 4e2:	0141                	addi	sp,sp,16
 4e4:	8082                	ret
  return 0;
 4e6:	4501                	li	a0,0
 4e8:	bfe5                	j	4e0 <memcmp+0x30>

00000000000004ea <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4ea:	1141                	addi	sp,sp,-16
 4ec:	e406                	sd	ra,8(sp)
 4ee:	e022                	sd	s0,0(sp)
 4f0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4f2:	00000097          	auipc	ra,0x0
 4f6:	f66080e7          	jalr	-154(ra) # 458 <memmove>
}
 4fa:	60a2                	ld	ra,8(sp)
 4fc:	6402                	ld	s0,0(sp)
 4fe:	0141                	addi	sp,sp,16
 500:	8082                	ret

0000000000000502 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 502:	4885                	li	a7,1
 ecall
 504:	00000073          	ecall
 ret
 508:	8082                	ret

000000000000050a <exit>:
.global exit
exit:
 li a7, SYS_exit
 50a:	4889                	li	a7,2
 ecall
 50c:	00000073          	ecall
 ret
 510:	8082                	ret

0000000000000512 <wait>:
.global wait
wait:
 li a7, SYS_wait
 512:	488d                	li	a7,3
 ecall
 514:	00000073          	ecall
 ret
 518:	8082                	ret

000000000000051a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 51a:	4891                	li	a7,4
 ecall
 51c:	00000073          	ecall
 ret
 520:	8082                	ret

0000000000000522 <read>:
.global read
read:
 li a7, SYS_read
 522:	4895                	li	a7,5
 ecall
 524:	00000073          	ecall
 ret
 528:	8082                	ret

000000000000052a <write>:
.global write
write:
 li a7, SYS_write
 52a:	48c1                	li	a7,16
 ecall
 52c:	00000073          	ecall
 ret
 530:	8082                	ret

0000000000000532 <close>:
.global close
close:
 li a7, SYS_close
 532:	48d5                	li	a7,21
 ecall
 534:	00000073          	ecall
 ret
 538:	8082                	ret

000000000000053a <kill>:
.global kill
kill:
 li a7, SYS_kill
 53a:	4899                	li	a7,6
 ecall
 53c:	00000073          	ecall
 ret
 540:	8082                	ret

0000000000000542 <exec>:
.global exec
exec:
 li a7, SYS_exec
 542:	489d                	li	a7,7
 ecall
 544:	00000073          	ecall
 ret
 548:	8082                	ret

000000000000054a <open>:
.global open
open:
 li a7, SYS_open
 54a:	48bd                	li	a7,15
 ecall
 54c:	00000073          	ecall
 ret
 550:	8082                	ret

0000000000000552 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 552:	48c5                	li	a7,17
 ecall
 554:	00000073          	ecall
 ret
 558:	8082                	ret

000000000000055a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 55a:	48c9                	li	a7,18
 ecall
 55c:	00000073          	ecall
 ret
 560:	8082                	ret

0000000000000562 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 562:	48a1                	li	a7,8
 ecall
 564:	00000073          	ecall
 ret
 568:	8082                	ret

000000000000056a <link>:
.global link
link:
 li a7, SYS_link
 56a:	48cd                	li	a7,19
 ecall
 56c:	00000073          	ecall
 ret
 570:	8082                	ret

0000000000000572 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 572:	48d1                	li	a7,20
 ecall
 574:	00000073          	ecall
 ret
 578:	8082                	ret

000000000000057a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 57a:	48a5                	li	a7,9
 ecall
 57c:	00000073          	ecall
 ret
 580:	8082                	ret

0000000000000582 <dup>:
.global dup
dup:
 li a7, SYS_dup
 582:	48a9                	li	a7,10
 ecall
 584:	00000073          	ecall
 ret
 588:	8082                	ret

000000000000058a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 58a:	48ad                	li	a7,11
 ecall
 58c:	00000073          	ecall
 ret
 590:	8082                	ret

0000000000000592 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 592:	48b1                	li	a7,12
 ecall
 594:	00000073          	ecall
 ret
 598:	8082                	ret

000000000000059a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 59a:	48b5                	li	a7,13
 ecall
 59c:	00000073          	ecall
 ret
 5a0:	8082                	ret

00000000000005a2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5a2:	48b9                	li	a7,14
 ecall
 5a4:	00000073          	ecall
 ret
 5a8:	8082                	ret

00000000000005aa <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
 5aa:	48d9                	li	a7,22
 ecall
 5ac:	00000073          	ecall
 ret
 5b0:	8082                	ret

00000000000005b2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5b2:	1101                	addi	sp,sp,-32
 5b4:	ec06                	sd	ra,24(sp)
 5b6:	e822                	sd	s0,16(sp)
 5b8:	1000                	addi	s0,sp,32
 5ba:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5be:	4605                	li	a2,1
 5c0:	fef40593          	addi	a1,s0,-17
 5c4:	00000097          	auipc	ra,0x0
 5c8:	f66080e7          	jalr	-154(ra) # 52a <write>
}
 5cc:	60e2                	ld	ra,24(sp)
 5ce:	6442                	ld	s0,16(sp)
 5d0:	6105                	addi	sp,sp,32
 5d2:	8082                	ret

00000000000005d4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5d4:	7139                	addi	sp,sp,-64
 5d6:	fc06                	sd	ra,56(sp)
 5d8:	f822                	sd	s0,48(sp)
 5da:	f426                	sd	s1,40(sp)
 5dc:	f04a                	sd	s2,32(sp)
 5de:	ec4e                	sd	s3,24(sp)
 5e0:	0080                	addi	s0,sp,64
 5e2:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5e4:	c299                	beqz	a3,5ea <printint+0x16>
 5e6:	0805c963          	bltz	a1,678 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5ea:	2581                	sext.w	a1,a1
  neg = 0;
 5ec:	4881                	li	a7,0
 5ee:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5f2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5f4:	2601                	sext.w	a2,a2
 5f6:	00000517          	auipc	a0,0x0
 5fa:	4d250513          	addi	a0,a0,1234 # ac8 <digits>
 5fe:	883a                	mv	a6,a4
 600:	2705                	addiw	a4,a4,1
 602:	02c5f7bb          	remuw	a5,a1,a2
 606:	1782                	slli	a5,a5,0x20
 608:	9381                	srli	a5,a5,0x20
 60a:	97aa                	add	a5,a5,a0
 60c:	0007c783          	lbu	a5,0(a5)
 610:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 614:	0005879b          	sext.w	a5,a1
 618:	02c5d5bb          	divuw	a1,a1,a2
 61c:	0685                	addi	a3,a3,1
 61e:	fec7f0e3          	bgeu	a5,a2,5fe <printint+0x2a>
  if(neg)
 622:	00088c63          	beqz	a7,63a <printint+0x66>
    buf[i++] = '-';
 626:	fd070793          	addi	a5,a4,-48
 62a:	00878733          	add	a4,a5,s0
 62e:	02d00793          	li	a5,45
 632:	fef70823          	sb	a5,-16(a4)
 636:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 63a:	02e05863          	blez	a4,66a <printint+0x96>
 63e:	fc040793          	addi	a5,s0,-64
 642:	00e78933          	add	s2,a5,a4
 646:	fff78993          	addi	s3,a5,-1
 64a:	99ba                	add	s3,s3,a4
 64c:	377d                	addiw	a4,a4,-1
 64e:	1702                	slli	a4,a4,0x20
 650:	9301                	srli	a4,a4,0x20
 652:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 656:	fff94583          	lbu	a1,-1(s2)
 65a:	8526                	mv	a0,s1
 65c:	00000097          	auipc	ra,0x0
 660:	f56080e7          	jalr	-170(ra) # 5b2 <putc>
  while(--i >= 0)
 664:	197d                	addi	s2,s2,-1
 666:	ff3918e3          	bne	s2,s3,656 <printint+0x82>
}
 66a:	70e2                	ld	ra,56(sp)
 66c:	7442                	ld	s0,48(sp)
 66e:	74a2                	ld	s1,40(sp)
 670:	7902                	ld	s2,32(sp)
 672:	69e2                	ld	s3,24(sp)
 674:	6121                	addi	sp,sp,64
 676:	8082                	ret
    x = -xx;
 678:	40b005bb          	negw	a1,a1
    neg = 1;
 67c:	4885                	li	a7,1
    x = -xx;
 67e:	bf85                	j	5ee <printint+0x1a>

0000000000000680 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 680:	7119                	addi	sp,sp,-128
 682:	fc86                	sd	ra,120(sp)
 684:	f8a2                	sd	s0,112(sp)
 686:	f4a6                	sd	s1,104(sp)
 688:	f0ca                	sd	s2,96(sp)
 68a:	ecce                	sd	s3,88(sp)
 68c:	e8d2                	sd	s4,80(sp)
 68e:	e4d6                	sd	s5,72(sp)
 690:	e0da                	sd	s6,64(sp)
 692:	fc5e                	sd	s7,56(sp)
 694:	f862                	sd	s8,48(sp)
 696:	f466                	sd	s9,40(sp)
 698:	f06a                	sd	s10,32(sp)
 69a:	ec6e                	sd	s11,24(sp)
 69c:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 69e:	0005c903          	lbu	s2,0(a1)
 6a2:	18090f63          	beqz	s2,840 <vprintf+0x1c0>
 6a6:	8aaa                	mv	s5,a0
 6a8:	8b32                	mv	s6,a2
 6aa:	00158493          	addi	s1,a1,1
  state = 0;
 6ae:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 6b0:	02500a13          	li	s4,37
 6b4:	4c55                	li	s8,21
 6b6:	00000c97          	auipc	s9,0x0
 6ba:	3bac8c93          	addi	s9,s9,954 # a70 <malloc+0x12c>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6be:	02800d93          	li	s11,40
  putc(fd, 'x');
 6c2:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6c4:	00000b97          	auipc	s7,0x0
 6c8:	404b8b93          	addi	s7,s7,1028 # ac8 <digits>
 6cc:	a839                	j	6ea <vprintf+0x6a>
        putc(fd, c);
 6ce:	85ca                	mv	a1,s2
 6d0:	8556                	mv	a0,s5
 6d2:	00000097          	auipc	ra,0x0
 6d6:	ee0080e7          	jalr	-288(ra) # 5b2 <putc>
 6da:	a019                	j	6e0 <vprintf+0x60>
    } else if(state == '%'){
 6dc:	01498d63          	beq	s3,s4,6f6 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 6e0:	0485                	addi	s1,s1,1
 6e2:	fff4c903          	lbu	s2,-1(s1)
 6e6:	14090d63          	beqz	s2,840 <vprintf+0x1c0>
    if(state == 0){
 6ea:	fe0999e3          	bnez	s3,6dc <vprintf+0x5c>
      if(c == '%'){
 6ee:	ff4910e3          	bne	s2,s4,6ce <vprintf+0x4e>
        state = '%';
 6f2:	89d2                	mv	s3,s4
 6f4:	b7f5                	j	6e0 <vprintf+0x60>
      if(c == 'd'){
 6f6:	11490c63          	beq	s2,s4,80e <vprintf+0x18e>
 6fa:	f9d9079b          	addiw	a5,s2,-99
 6fe:	0ff7f793          	zext.b	a5,a5
 702:	10fc6e63          	bltu	s8,a5,81e <vprintf+0x19e>
 706:	f9d9079b          	addiw	a5,s2,-99
 70a:	0ff7f713          	zext.b	a4,a5
 70e:	10ec6863          	bltu	s8,a4,81e <vprintf+0x19e>
 712:	00271793          	slli	a5,a4,0x2
 716:	97e6                	add	a5,a5,s9
 718:	439c                	lw	a5,0(a5)
 71a:	97e6                	add	a5,a5,s9
 71c:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 71e:	008b0913          	addi	s2,s6,8
 722:	4685                	li	a3,1
 724:	4629                	li	a2,10
 726:	000b2583          	lw	a1,0(s6)
 72a:	8556                	mv	a0,s5
 72c:	00000097          	auipc	ra,0x0
 730:	ea8080e7          	jalr	-344(ra) # 5d4 <printint>
 734:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 736:	4981                	li	s3,0
 738:	b765                	j	6e0 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 73a:	008b0913          	addi	s2,s6,8
 73e:	4681                	li	a3,0
 740:	4629                	li	a2,10
 742:	000b2583          	lw	a1,0(s6)
 746:	8556                	mv	a0,s5
 748:	00000097          	auipc	ra,0x0
 74c:	e8c080e7          	jalr	-372(ra) # 5d4 <printint>
 750:	8b4a                	mv	s6,s2
      state = 0;
 752:	4981                	li	s3,0
 754:	b771                	j	6e0 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 756:	008b0913          	addi	s2,s6,8
 75a:	4681                	li	a3,0
 75c:	866a                	mv	a2,s10
 75e:	000b2583          	lw	a1,0(s6)
 762:	8556                	mv	a0,s5
 764:	00000097          	auipc	ra,0x0
 768:	e70080e7          	jalr	-400(ra) # 5d4 <printint>
 76c:	8b4a                	mv	s6,s2
      state = 0;
 76e:	4981                	li	s3,0
 770:	bf85                	j	6e0 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 772:	008b0793          	addi	a5,s6,8
 776:	f8f43423          	sd	a5,-120(s0)
 77a:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 77e:	03000593          	li	a1,48
 782:	8556                	mv	a0,s5
 784:	00000097          	auipc	ra,0x0
 788:	e2e080e7          	jalr	-466(ra) # 5b2 <putc>
  putc(fd, 'x');
 78c:	07800593          	li	a1,120
 790:	8556                	mv	a0,s5
 792:	00000097          	auipc	ra,0x0
 796:	e20080e7          	jalr	-480(ra) # 5b2 <putc>
 79a:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 79c:	03c9d793          	srli	a5,s3,0x3c
 7a0:	97de                	add	a5,a5,s7
 7a2:	0007c583          	lbu	a1,0(a5)
 7a6:	8556                	mv	a0,s5
 7a8:	00000097          	auipc	ra,0x0
 7ac:	e0a080e7          	jalr	-502(ra) # 5b2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7b0:	0992                	slli	s3,s3,0x4
 7b2:	397d                	addiw	s2,s2,-1
 7b4:	fe0914e3          	bnez	s2,79c <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 7b8:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 7bc:	4981                	li	s3,0
 7be:	b70d                	j	6e0 <vprintf+0x60>
        s = va_arg(ap, char*);
 7c0:	008b0913          	addi	s2,s6,8
 7c4:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 7c8:	02098163          	beqz	s3,7ea <vprintf+0x16a>
        while(*s != 0){
 7cc:	0009c583          	lbu	a1,0(s3)
 7d0:	c5ad                	beqz	a1,83a <vprintf+0x1ba>
          putc(fd, *s);
 7d2:	8556                	mv	a0,s5
 7d4:	00000097          	auipc	ra,0x0
 7d8:	dde080e7          	jalr	-546(ra) # 5b2 <putc>
          s++;
 7dc:	0985                	addi	s3,s3,1
        while(*s != 0){
 7de:	0009c583          	lbu	a1,0(s3)
 7e2:	f9e5                	bnez	a1,7d2 <vprintf+0x152>
        s = va_arg(ap, char*);
 7e4:	8b4a                	mv	s6,s2
      state = 0;
 7e6:	4981                	li	s3,0
 7e8:	bde5                	j	6e0 <vprintf+0x60>
          s = "(null)";
 7ea:	00000997          	auipc	s3,0x0
 7ee:	27e98993          	addi	s3,s3,638 # a68 <malloc+0x124>
        while(*s != 0){
 7f2:	85ee                	mv	a1,s11
 7f4:	bff9                	j	7d2 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 7f6:	008b0913          	addi	s2,s6,8
 7fa:	000b4583          	lbu	a1,0(s6)
 7fe:	8556                	mv	a0,s5
 800:	00000097          	auipc	ra,0x0
 804:	db2080e7          	jalr	-590(ra) # 5b2 <putc>
 808:	8b4a                	mv	s6,s2
      state = 0;
 80a:	4981                	li	s3,0
 80c:	bdd1                	j	6e0 <vprintf+0x60>
        putc(fd, c);
 80e:	85d2                	mv	a1,s4
 810:	8556                	mv	a0,s5
 812:	00000097          	auipc	ra,0x0
 816:	da0080e7          	jalr	-608(ra) # 5b2 <putc>
      state = 0;
 81a:	4981                	li	s3,0
 81c:	b5d1                	j	6e0 <vprintf+0x60>
        putc(fd, '%');
 81e:	85d2                	mv	a1,s4
 820:	8556                	mv	a0,s5
 822:	00000097          	auipc	ra,0x0
 826:	d90080e7          	jalr	-624(ra) # 5b2 <putc>
        putc(fd, c);
 82a:	85ca                	mv	a1,s2
 82c:	8556                	mv	a0,s5
 82e:	00000097          	auipc	ra,0x0
 832:	d84080e7          	jalr	-636(ra) # 5b2 <putc>
      state = 0;
 836:	4981                	li	s3,0
 838:	b565                	j	6e0 <vprintf+0x60>
        s = va_arg(ap, char*);
 83a:	8b4a                	mv	s6,s2
      state = 0;
 83c:	4981                	li	s3,0
 83e:	b54d                	j	6e0 <vprintf+0x60>
    }
  }
}
 840:	70e6                	ld	ra,120(sp)
 842:	7446                	ld	s0,112(sp)
 844:	74a6                	ld	s1,104(sp)
 846:	7906                	ld	s2,96(sp)
 848:	69e6                	ld	s3,88(sp)
 84a:	6a46                	ld	s4,80(sp)
 84c:	6aa6                	ld	s5,72(sp)
 84e:	6b06                	ld	s6,64(sp)
 850:	7be2                	ld	s7,56(sp)
 852:	7c42                	ld	s8,48(sp)
 854:	7ca2                	ld	s9,40(sp)
 856:	7d02                	ld	s10,32(sp)
 858:	6de2                	ld	s11,24(sp)
 85a:	6109                	addi	sp,sp,128
 85c:	8082                	ret

000000000000085e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 85e:	715d                	addi	sp,sp,-80
 860:	ec06                	sd	ra,24(sp)
 862:	e822                	sd	s0,16(sp)
 864:	1000                	addi	s0,sp,32
 866:	e010                	sd	a2,0(s0)
 868:	e414                	sd	a3,8(s0)
 86a:	e818                	sd	a4,16(s0)
 86c:	ec1c                	sd	a5,24(s0)
 86e:	03043023          	sd	a6,32(s0)
 872:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 876:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 87a:	8622                	mv	a2,s0
 87c:	00000097          	auipc	ra,0x0
 880:	e04080e7          	jalr	-508(ra) # 680 <vprintf>
}
 884:	60e2                	ld	ra,24(sp)
 886:	6442                	ld	s0,16(sp)
 888:	6161                	addi	sp,sp,80
 88a:	8082                	ret

000000000000088c <printf>:

void
printf(const char *fmt, ...)
{
 88c:	711d                	addi	sp,sp,-96
 88e:	ec06                	sd	ra,24(sp)
 890:	e822                	sd	s0,16(sp)
 892:	1000                	addi	s0,sp,32
 894:	e40c                	sd	a1,8(s0)
 896:	e810                	sd	a2,16(s0)
 898:	ec14                	sd	a3,24(s0)
 89a:	f018                	sd	a4,32(s0)
 89c:	f41c                	sd	a5,40(s0)
 89e:	03043823          	sd	a6,48(s0)
 8a2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8a6:	00840613          	addi	a2,s0,8
 8aa:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8ae:	85aa                	mv	a1,a0
 8b0:	4505                	li	a0,1
 8b2:	00000097          	auipc	ra,0x0
 8b6:	dce080e7          	jalr	-562(ra) # 680 <vprintf>
}
 8ba:	60e2                	ld	ra,24(sp)
 8bc:	6442                	ld	s0,16(sp)
 8be:	6125                	addi	sp,sp,96
 8c0:	8082                	ret

00000000000008c2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8c2:	1141                	addi	sp,sp,-16
 8c4:	e422                	sd	s0,8(sp)
 8c6:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8c8:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8cc:	00000797          	auipc	a5,0x0
 8d0:	2147b783          	ld	a5,532(a5) # ae0 <freep>
 8d4:	a02d                	j	8fe <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8d6:	4618                	lw	a4,8(a2)
 8d8:	9f2d                	addw	a4,a4,a1
 8da:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8de:	6398                	ld	a4,0(a5)
 8e0:	6310                	ld	a2,0(a4)
 8e2:	a83d                	j	920 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8e4:	ff852703          	lw	a4,-8(a0)
 8e8:	9f31                	addw	a4,a4,a2
 8ea:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8ec:	ff053683          	ld	a3,-16(a0)
 8f0:	a091                	j	934 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8f2:	6398                	ld	a4,0(a5)
 8f4:	00e7e463          	bltu	a5,a4,8fc <free+0x3a>
 8f8:	00e6ea63          	bltu	a3,a4,90c <free+0x4a>
{
 8fc:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8fe:	fed7fae3          	bgeu	a5,a3,8f2 <free+0x30>
 902:	6398                	ld	a4,0(a5)
 904:	00e6e463          	bltu	a3,a4,90c <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 908:	fee7eae3          	bltu	a5,a4,8fc <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 90c:	ff852583          	lw	a1,-8(a0)
 910:	6390                	ld	a2,0(a5)
 912:	02059813          	slli	a6,a1,0x20
 916:	01c85713          	srli	a4,a6,0x1c
 91a:	9736                	add	a4,a4,a3
 91c:	fae60de3          	beq	a2,a4,8d6 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 920:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 924:	4790                	lw	a2,8(a5)
 926:	02061593          	slli	a1,a2,0x20
 92a:	01c5d713          	srli	a4,a1,0x1c
 92e:	973e                	add	a4,a4,a5
 930:	fae68ae3          	beq	a3,a4,8e4 <free+0x22>
    p->s.ptr = bp->s.ptr;
 934:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 936:	00000717          	auipc	a4,0x0
 93a:	1af73523          	sd	a5,426(a4) # ae0 <freep>
}
 93e:	6422                	ld	s0,8(sp)
 940:	0141                	addi	sp,sp,16
 942:	8082                	ret

0000000000000944 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 944:	7139                	addi	sp,sp,-64
 946:	fc06                	sd	ra,56(sp)
 948:	f822                	sd	s0,48(sp)
 94a:	f426                	sd	s1,40(sp)
 94c:	f04a                	sd	s2,32(sp)
 94e:	ec4e                	sd	s3,24(sp)
 950:	e852                	sd	s4,16(sp)
 952:	e456                	sd	s5,8(sp)
 954:	e05a                	sd	s6,0(sp)
 956:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 958:	02051493          	slli	s1,a0,0x20
 95c:	9081                	srli	s1,s1,0x20
 95e:	04bd                	addi	s1,s1,15
 960:	8091                	srli	s1,s1,0x4
 962:	0014899b          	addiw	s3,s1,1
 966:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 968:	00000517          	auipc	a0,0x0
 96c:	17853503          	ld	a0,376(a0) # ae0 <freep>
 970:	c515                	beqz	a0,99c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 972:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 974:	4798                	lw	a4,8(a5)
 976:	02977f63          	bgeu	a4,s1,9b4 <malloc+0x70>
 97a:	8a4e                	mv	s4,s3
 97c:	0009871b          	sext.w	a4,s3
 980:	6685                	lui	a3,0x1
 982:	00d77363          	bgeu	a4,a3,988 <malloc+0x44>
 986:	6a05                	lui	s4,0x1
 988:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 98c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 990:	00000917          	auipc	s2,0x0
 994:	15090913          	addi	s2,s2,336 # ae0 <freep>
  if(p == (char*)-1)
 998:	5afd                	li	s5,-1
 99a:	a895                	j	a0e <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 99c:	00000797          	auipc	a5,0x0
 9a0:	54c78793          	addi	a5,a5,1356 # ee8 <base>
 9a4:	00000717          	auipc	a4,0x0
 9a8:	12f73e23          	sd	a5,316(a4) # ae0 <freep>
 9ac:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9ae:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9b2:	b7e1                	j	97a <malloc+0x36>
      if(p->s.size == nunits)
 9b4:	02e48c63          	beq	s1,a4,9ec <malloc+0xa8>
        p->s.size -= nunits;
 9b8:	4137073b          	subw	a4,a4,s3
 9bc:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9be:	02071693          	slli	a3,a4,0x20
 9c2:	01c6d713          	srli	a4,a3,0x1c
 9c6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9c8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9cc:	00000717          	auipc	a4,0x0
 9d0:	10a73a23          	sd	a0,276(a4) # ae0 <freep>
      return (void*)(p + 1);
 9d4:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 9d8:	70e2                	ld	ra,56(sp)
 9da:	7442                	ld	s0,48(sp)
 9dc:	74a2                	ld	s1,40(sp)
 9de:	7902                	ld	s2,32(sp)
 9e0:	69e2                	ld	s3,24(sp)
 9e2:	6a42                	ld	s4,16(sp)
 9e4:	6aa2                	ld	s5,8(sp)
 9e6:	6b02                	ld	s6,0(sp)
 9e8:	6121                	addi	sp,sp,64
 9ea:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 9ec:	6398                	ld	a4,0(a5)
 9ee:	e118                	sd	a4,0(a0)
 9f0:	bff1                	j	9cc <malloc+0x88>
  hp->s.size = nu;
 9f2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9f6:	0541                	addi	a0,a0,16
 9f8:	00000097          	auipc	ra,0x0
 9fc:	eca080e7          	jalr	-310(ra) # 8c2 <free>
  return freep;
 a00:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a04:	d971                	beqz	a0,9d8 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a06:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a08:	4798                	lw	a4,8(a5)
 a0a:	fa9775e3          	bgeu	a4,s1,9b4 <malloc+0x70>
    if(p == freep)
 a0e:	00093703          	ld	a4,0(s2)
 a12:	853e                	mv	a0,a5
 a14:	fef719e3          	bne	a4,a5,a06 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 a18:	8552                	mv	a0,s4
 a1a:	00000097          	auipc	ra,0x0
 a1e:	b78080e7          	jalr	-1160(ra) # 592 <sbrk>
  if(p == (char*)-1)
 a22:	fd5518e3          	bne	a0,s5,9f2 <malloc+0xae>
        return 0;
 a26:	4501                	li	a0,0
 a28:	bf45                	j	9d8 <malloc+0x94>