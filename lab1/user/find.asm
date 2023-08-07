
user/_find:     file format elf64-littleriscv


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
  do
  {  // a * matches zero or more instances
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

000000000000011a <fmtname>:
    exit(0);
}

// 对比ls中的fmtname，去掉了空白字符串
char*fmtname(char *path)
{
 11a:	1101                	addi	sp,sp,-32
 11c:	ec06                	sd	ra,24(sp)
 11e:	e822                	sd	s0,16(sp)
 120:	e426                	sd	s1,8(sp)
 122:	e04a                	sd	s2,0(sp)
 124:	1000                	addi	s0,sp,32
 126:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
 128:	00000097          	auipc	ra,0x0
 12c:	2fc080e7          	jalr	764(ra) # 424 <strlen>
 130:	02051593          	slli	a1,a0,0x20
 134:	9181                	srli	a1,a1,0x20
 136:	95a6                	add	a1,a1,s1
 138:	02f00713          	li	a4,47
 13c:	0095e963          	bltu	a1,s1,14e <fmtname+0x34>
 140:	0005c783          	lbu	a5,0(a1)
 144:	00e78563          	beq	a5,a4,14e <fmtname+0x34>
 148:	15fd                	addi	a1,a1,-1
 14a:	fe95fbe3          	bgeu	a1,s1,140 <fmtname+0x26>
    ;
  p++;
 14e:	00158493          	addi	s1,a1,1
  // printf("len of p: %d\n", strlen(p));
  if(strlen(p) >= DIRSIZ)
 152:	8526                	mv	a0,s1
 154:	00000097          	auipc	ra,0x0
 158:	2d0080e7          	jalr	720(ra) # 424 <strlen>
 15c:	2501                	sext.w	a0,a0
 15e:	47b5                	li	a5,13
 160:	00a7f963          	bgeu	a5,a0,172 <fmtname+0x58>
    return p;
  memset(buf, '\0', sizeof(buf));
  memmove(buf, p, strlen(p));
  //memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
 164:	8526                	mv	a0,s1
 166:	60e2                	ld	ra,24(sp)
 168:	6442                	ld	s0,16(sp)
 16a:	64a2                	ld	s1,8(sp)
 16c:	6902                	ld	s2,0(sp)
 16e:	6105                	addi	sp,sp,32
 170:	8082                	ret
  memset(buf, '\0', sizeof(buf));
 172:	00001917          	auipc	s2,0x1
 176:	aee90913          	addi	s2,s2,-1298 # c60 <buf.0>
 17a:	463d                	li	a2,15
 17c:	4581                	li	a1,0
 17e:	854a                	mv	a0,s2
 180:	00000097          	auipc	ra,0x0
 184:	2ce080e7          	jalr	718(ra) # 44e <memset>
  memmove(buf, p, strlen(p));
 188:	8526                	mv	a0,s1
 18a:	00000097          	auipc	ra,0x0
 18e:	29a080e7          	jalr	666(ra) # 424 <strlen>
 192:	0005061b          	sext.w	a2,a0
 196:	85a6                	mv	a1,s1
 198:	854a                	mv	a0,s2
 19a:	00000097          	auipc	ra,0x0
 19e:	3fc080e7          	jalr	1020(ra) # 596 <memmove>
  return buf;
 1a2:	84ca                	mv	s1,s2
 1a4:	b7c1                	j	164 <fmtname+0x4a>

00000000000001a6 <find>:

void find(char *path, char *re){
 1a6:	d8010113          	addi	sp,sp,-640
 1aa:	26113c23          	sd	ra,632(sp)
 1ae:	26813823          	sd	s0,624(sp)
 1b2:	26913423          	sd	s1,616(sp)
 1b6:	27213023          	sd	s2,608(sp)
 1ba:	25313c23          	sd	s3,600(sp)
 1be:	25413823          	sd	s4,592(sp)
 1c2:	25513423          	sd	s5,584(sp)
 1c6:	25613023          	sd	s6,576(sp)
 1ca:	23713c23          	sd	s7,568(sp)
 1ce:	23813823          	sd	s8,560(sp)
 1d2:	0500                	addi	s0,sp,640
 1d4:	892a                	mv	s2,a0
 1d6:	89ae                	mv	s3,a1
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;
  //该部分仿照ls制作
  if((fd = open(path, 0)) < 0)
 1d8:	4581                	li	a1,0
 1da:	00000097          	auipc	ra,0x0
 1de:	4ae080e7          	jalr	1198(ra) # 688 <open>
 1e2:	06054d63          	bltz	a0,25c <find+0xb6>
 1e6:	84aa                	mv	s1,a0
  {
      fprintf(2, "find: cannot open %s\n", path);
      return;
  }

  if(fstat(fd, &st) < 0)
 1e8:	d8840593          	addi	a1,s0,-632
 1ec:	00000097          	auipc	ra,0x0
 1f0:	4b4080e7          	jalr	1204(ra) # 6a0 <fstat>
 1f4:	06054f63          	bltz	a0,272 <find+0xcc>
      fprintf(2, "find: cannot stat %s\n", path);
      close(fd);
      return;
  }
  
  switch(st.type){
 1f8:	d9041783          	lh	a5,-624(s0)
 1fc:	0007869b          	sext.w	a3,a5
 200:	4705                	li	a4,1
 202:	0ae68263          	beq	a3,a4,2a6 <find+0x100>
 206:	4709                	li	a4,2
 208:	00e69e63          	bne	a3,a4,224 <find+0x7e>
  case T_FILE:
      //printf("File re: %s, fmtpath: %s\n", re, fmtname(path));
      if(match(re, fmtname(path)))
 20c:	854a                	mv	a0,s2
 20e:	00000097          	auipc	ra,0x0
 212:	f0c080e7          	jalr	-244(ra) # 11a <fmtname>
 216:	85aa                	mv	a1,a0
 218:	854e                	mv	a0,s3
 21a:	00000097          	auipc	ra,0x0
 21e:	eb2080e7          	jalr	-334(ra) # cc <match>
 222:	e925                	bnez	a0,292 <find+0xec>
            find(buf, re);
          }
      }
      break;
  }
  close(fd);
 224:	8526                	mv	a0,s1
 226:	00000097          	auipc	ra,0x0
 22a:	44a080e7          	jalr	1098(ra) # 670 <close>
}
 22e:	27813083          	ld	ra,632(sp)
 232:	27013403          	ld	s0,624(sp)
 236:	26813483          	ld	s1,616(sp)
 23a:	26013903          	ld	s2,608(sp)
 23e:	25813983          	ld	s3,600(sp)
 242:	25013a03          	ld	s4,592(sp)
 246:	24813a83          	ld	s5,584(sp)
 24a:	24013b03          	ld	s6,576(sp)
 24e:	23813b83          	ld	s7,568(sp)
 252:	23013c03          	ld	s8,560(sp)
 256:	28010113          	addi	sp,sp,640
 25a:	8082                	ret
      fprintf(2, "find: cannot open %s\n", path);
 25c:	864a                	mv	a2,s2
 25e:	00001597          	auipc	a1,0x1
 262:	90258593          	addi	a1,a1,-1790 # b60 <malloc+0xe6>
 266:	4509                	li	a0,2
 268:	00000097          	auipc	ra,0x0
 26c:	72c080e7          	jalr	1836(ra) # 994 <fprintf>
      return;
 270:	bf7d                	j	22e <find+0x88>
      fprintf(2, "find: cannot stat %s\n", path);
 272:	864a                	mv	a2,s2
 274:	00001597          	auipc	a1,0x1
 278:	90458593          	addi	a1,a1,-1788 # b78 <malloc+0xfe>
 27c:	4509                	li	a0,2
 27e:	00000097          	auipc	ra,0x0
 282:	716080e7          	jalr	1814(ra) # 994 <fprintf>
      close(fd);
 286:	8526                	mv	a0,s1
 288:	00000097          	auipc	ra,0x0
 28c:	3e8080e7          	jalr	1000(ra) # 670 <close>
      return;
 290:	bf79                	j	22e <find+0x88>
          printf("%s\n", path);
 292:	85ca                	mv	a1,s2
 294:	00001517          	auipc	a0,0x1
 298:	8fc50513          	addi	a0,a0,-1796 # b90 <malloc+0x116>
 29c:	00000097          	auipc	ra,0x0
 2a0:	726080e7          	jalr	1830(ra) # 9c2 <printf>
 2a4:	b741                	j	224 <find+0x7e>
      if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf)
 2a6:	854a                	mv	a0,s2
 2a8:	00000097          	auipc	ra,0x0
 2ac:	17c080e7          	jalr	380(ra) # 424 <strlen>
 2b0:	2541                	addiw	a0,a0,16
 2b2:	20000793          	li	a5,512
 2b6:	00a7fb63          	bgeu	a5,a0,2cc <find+0x126>
          printf("find: path too long\n");
 2ba:	00001517          	auipc	a0,0x1
 2be:	8de50513          	addi	a0,a0,-1826 # b98 <malloc+0x11e>
 2c2:	00000097          	auipc	ra,0x0
 2c6:	700080e7          	jalr	1792(ra) # 9c2 <printf>
          break;
 2ca:	bfa9                	j	224 <find+0x7e>
      strcpy(buf, path);
 2cc:	85ca                	mv	a1,s2
 2ce:	db040513          	addi	a0,s0,-592
 2d2:	00000097          	auipc	ra,0x0
 2d6:	10a080e7          	jalr	266(ra) # 3dc <strcpy>
      p = buf + strlen(buf);
 2da:	db040513          	addi	a0,s0,-592
 2de:	00000097          	auipc	ra,0x0
 2e2:	146080e7          	jalr	326(ra) # 424 <strlen>
 2e6:	1502                	slli	a0,a0,0x20
 2e8:	9101                	srli	a0,a0,0x20
 2ea:	db040793          	addi	a5,s0,-592
 2ee:	00a78933          	add	s2,a5,a0
      *p++ = '/';
 2f2:	00190a93          	addi	s5,s2,1
 2f6:	02f00793          	li	a5,47
 2fa:	00f90023          	sb	a5,0(s2)
          if(strcmp(".", lstname) == 0 || strcmp("..", lstname) == 0)
 2fe:	00001b17          	auipc	s6,0x1
 302:	8b2b0b13          	addi	s6,s6,-1870 # bb0 <malloc+0x136>
 306:	00001b97          	auipc	s7,0x1
 30a:	8b2b8b93          	addi	s7,s7,-1870 # bb8 <malloc+0x13e>
              printf("find: cannot stat %s\n", buf);
 30e:	00001c17          	auipc	s8,0x1
 312:	86ac0c13          	addi	s8,s8,-1942 # b78 <malloc+0xfe>
      while(read(fd, &de, sizeof(de)) == sizeof(de))
 316:	4641                	li	a2,16
 318:	da040593          	addi	a1,s0,-608
 31c:	8526                	mv	a0,s1
 31e:	00000097          	auipc	ra,0x0
 322:	342080e7          	jalr	834(ra) # 660 <read>
 326:	47c1                	li	a5,16
 328:	eef51ee3          	bne	a0,a5,224 <find+0x7e>
          if(de.inum == 0)
 32c:	da045783          	lhu	a5,-608(s0)
 330:	d3fd                	beqz	a5,316 <find+0x170>
          memmove(p, de.name, DIRSIZ);
 332:	4639                	li	a2,14
 334:	da240593          	addi	a1,s0,-606
 338:	8556                	mv	a0,s5
 33a:	00000097          	auipc	ra,0x0
 33e:	25c080e7          	jalr	604(ra) # 596 <memmove>
          p[DIRSIZ] = 0;
 342:	000907a3          	sb	zero,15(s2)
          if(stat(buf, &st) < 0)
 346:	d8840593          	addi	a1,s0,-632
 34a:	db040513          	addi	a0,s0,-592
 34e:	00000097          	auipc	ra,0x0
 352:	1ba080e7          	jalr	442(ra) # 508 <stat>
 356:	02054f63          	bltz	a0,394 <find+0x1ee>
          char* lstname = fmtname(buf);
 35a:	db040513          	addi	a0,s0,-592
 35e:	00000097          	auipc	ra,0x0
 362:	dbc080e7          	jalr	-580(ra) # 11a <fmtname>
 366:	8a2a                	mv	s4,a0
          if(strcmp(".", lstname) == 0 || strcmp("..", lstname) == 0)
 368:	85aa                	mv	a1,a0
 36a:	855a                	mv	a0,s6
 36c:	00000097          	auipc	ra,0x0
 370:	08c080e7          	jalr	140(ra) # 3f8 <strcmp>
 374:	d14d                	beqz	a0,316 <find+0x170>
 376:	85d2                	mv	a1,s4
 378:	855e                	mv	a0,s7
 37a:	00000097          	auipc	ra,0x0
 37e:	07e080e7          	jalr	126(ra) # 3f8 <strcmp>
 382:	d951                	beqz	a0,316 <find+0x170>
            find(buf, re);
 384:	85ce                	mv	a1,s3
 386:	db040513          	addi	a0,s0,-592
 38a:	00000097          	auipc	ra,0x0
 38e:	e1c080e7          	jalr	-484(ra) # 1a6 <find>
 392:	b751                	j	316 <find+0x170>
              printf("find: cannot stat %s\n", buf);
 394:	db040593          	addi	a1,s0,-592
 398:	8562                	mv	a0,s8
 39a:	00000097          	auipc	ra,0x0
 39e:	628080e7          	jalr	1576(ra) # 9c2 <printf>
              continue;
 3a2:	bf95                	j	316 <find+0x170>

00000000000003a4 <main>:
{
 3a4:	1141                	addi	sp,sp,-16
 3a6:	e406                	sd	ra,8(sp)
 3a8:	e022                	sd	s0,0(sp)
 3aa:	0800                	addi	s0,sp,16
    if(argc < 2)
 3ac:	4705                	li	a4,1
 3ae:	00a75e63          	bge	a4,a0,3ca <main+0x26>
 3b2:	87ae                	mv	a5,a1
      find(argv[1], argv[2]);
 3b4:	698c                	ld	a1,16(a1)
 3b6:	6788                	ld	a0,8(a5)
 3b8:	00000097          	auipc	ra,0x0
 3bc:	dee080e7          	jalr	-530(ra) # 1a6 <find>
    exit(0);
 3c0:	4501                	li	a0,0
 3c2:	00000097          	auipc	ra,0x0
 3c6:	286080e7          	jalr	646(ra) # 648 <exit>
      printf("Parameters are not enough\n");
 3ca:	00000517          	auipc	a0,0x0
 3ce:	7f650513          	addi	a0,a0,2038 # bc0 <malloc+0x146>
 3d2:	00000097          	auipc	ra,0x0
 3d6:	5f0080e7          	jalr	1520(ra) # 9c2 <printf>
 3da:	b7dd                	j	3c0 <main+0x1c>

00000000000003dc <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 3dc:	1141                	addi	sp,sp,-16
 3de:	e422                	sd	s0,8(sp)
 3e0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 3e2:	87aa                	mv	a5,a0
 3e4:	0585                	addi	a1,a1,1
 3e6:	0785                	addi	a5,a5,1
 3e8:	fff5c703          	lbu	a4,-1(a1)
 3ec:	fee78fa3          	sb	a4,-1(a5)
 3f0:	fb75                	bnez	a4,3e4 <strcpy+0x8>
    ;
  return os;
}
 3f2:	6422                	ld	s0,8(sp)
 3f4:	0141                	addi	sp,sp,16
 3f6:	8082                	ret

00000000000003f8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3f8:	1141                	addi	sp,sp,-16
 3fa:	e422                	sd	s0,8(sp)
 3fc:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 3fe:	00054783          	lbu	a5,0(a0)
 402:	cb91                	beqz	a5,416 <strcmp+0x1e>
 404:	0005c703          	lbu	a4,0(a1)
 408:	00f71763          	bne	a4,a5,416 <strcmp+0x1e>
    p++, q++;
 40c:	0505                	addi	a0,a0,1
 40e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 410:	00054783          	lbu	a5,0(a0)
 414:	fbe5                	bnez	a5,404 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 416:	0005c503          	lbu	a0,0(a1)
}
 41a:	40a7853b          	subw	a0,a5,a0
 41e:	6422                	ld	s0,8(sp)
 420:	0141                	addi	sp,sp,16
 422:	8082                	ret

0000000000000424 <strlen>:

uint
strlen(const char *s)
{
 424:	1141                	addi	sp,sp,-16
 426:	e422                	sd	s0,8(sp)
 428:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 42a:	00054783          	lbu	a5,0(a0)
 42e:	cf91                	beqz	a5,44a <strlen+0x26>
 430:	0505                	addi	a0,a0,1
 432:	87aa                	mv	a5,a0
 434:	4685                	li	a3,1
 436:	9e89                	subw	a3,a3,a0
 438:	00f6853b          	addw	a0,a3,a5
 43c:	0785                	addi	a5,a5,1
 43e:	fff7c703          	lbu	a4,-1(a5)
 442:	fb7d                	bnez	a4,438 <strlen+0x14>
    ;
  return n;
}
 444:	6422                	ld	s0,8(sp)
 446:	0141                	addi	sp,sp,16
 448:	8082                	ret
  for(n = 0; s[n]; n++)
 44a:	4501                	li	a0,0
 44c:	bfe5                	j	444 <strlen+0x20>

000000000000044e <memset>:

void*
memset(void *dst, int c, uint n)
{
 44e:	1141                	addi	sp,sp,-16
 450:	e422                	sd	s0,8(sp)
 452:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 454:	ca19                	beqz	a2,46a <memset+0x1c>
 456:	87aa                	mv	a5,a0
 458:	1602                	slli	a2,a2,0x20
 45a:	9201                	srli	a2,a2,0x20
 45c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 460:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 464:	0785                	addi	a5,a5,1
 466:	fee79de3          	bne	a5,a4,460 <memset+0x12>
  }
  return dst;
}
 46a:	6422                	ld	s0,8(sp)
 46c:	0141                	addi	sp,sp,16
 46e:	8082                	ret

0000000000000470 <strchr>:

char*
strchr(const char *s, char c)
{
 470:	1141                	addi	sp,sp,-16
 472:	e422                	sd	s0,8(sp)
 474:	0800                	addi	s0,sp,16
  for(; *s; s++)
 476:	00054783          	lbu	a5,0(a0)
 47a:	cb99                	beqz	a5,490 <strchr+0x20>
    if(*s == c)
 47c:	00f58763          	beq	a1,a5,48a <strchr+0x1a>
  for(; *s; s++)
 480:	0505                	addi	a0,a0,1
 482:	00054783          	lbu	a5,0(a0)
 486:	fbfd                	bnez	a5,47c <strchr+0xc>
      return (char*)s;
  return 0;
 488:	4501                	li	a0,0
}
 48a:	6422                	ld	s0,8(sp)
 48c:	0141                	addi	sp,sp,16
 48e:	8082                	ret
  return 0;
 490:	4501                	li	a0,0
 492:	bfe5                	j	48a <strchr+0x1a>

0000000000000494 <gets>:

char*
gets(char *buf, int max)
{
 494:	711d                	addi	sp,sp,-96
 496:	ec86                	sd	ra,88(sp)
 498:	e8a2                	sd	s0,80(sp)
 49a:	e4a6                	sd	s1,72(sp)
 49c:	e0ca                	sd	s2,64(sp)
 49e:	fc4e                	sd	s3,56(sp)
 4a0:	f852                	sd	s4,48(sp)
 4a2:	f456                	sd	s5,40(sp)
 4a4:	f05a                	sd	s6,32(sp)
 4a6:	ec5e                	sd	s7,24(sp)
 4a8:	1080                	addi	s0,sp,96
 4aa:	8baa                	mv	s7,a0
 4ac:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4ae:	892a                	mv	s2,a0
 4b0:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 4b2:	4aa9                	li	s5,10
 4b4:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 4b6:	89a6                	mv	s3,s1
 4b8:	2485                	addiw	s1,s1,1
 4ba:	0344d863          	bge	s1,s4,4ea <gets+0x56>
    cc = read(0, &c, 1);
 4be:	4605                	li	a2,1
 4c0:	faf40593          	addi	a1,s0,-81
 4c4:	4501                	li	a0,0
 4c6:	00000097          	auipc	ra,0x0
 4ca:	19a080e7          	jalr	410(ra) # 660 <read>
    if(cc < 1)
 4ce:	00a05e63          	blez	a0,4ea <gets+0x56>
    buf[i++] = c;
 4d2:	faf44783          	lbu	a5,-81(s0)
 4d6:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 4da:	01578763          	beq	a5,s5,4e8 <gets+0x54>
 4de:	0905                	addi	s2,s2,1
 4e0:	fd679be3          	bne	a5,s6,4b6 <gets+0x22>
  for(i=0; i+1 < max; ){
 4e4:	89a6                	mv	s3,s1
 4e6:	a011                	j	4ea <gets+0x56>
 4e8:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 4ea:	99de                	add	s3,s3,s7
 4ec:	00098023          	sb	zero,0(s3)
  return buf;
}
 4f0:	855e                	mv	a0,s7
 4f2:	60e6                	ld	ra,88(sp)
 4f4:	6446                	ld	s0,80(sp)
 4f6:	64a6                	ld	s1,72(sp)
 4f8:	6906                	ld	s2,64(sp)
 4fa:	79e2                	ld	s3,56(sp)
 4fc:	7a42                	ld	s4,48(sp)
 4fe:	7aa2                	ld	s5,40(sp)
 500:	7b02                	ld	s6,32(sp)
 502:	6be2                	ld	s7,24(sp)
 504:	6125                	addi	sp,sp,96
 506:	8082                	ret

0000000000000508 <stat>:

int
stat(const char *n, struct stat *st)
{
 508:	1101                	addi	sp,sp,-32
 50a:	ec06                	sd	ra,24(sp)
 50c:	e822                	sd	s0,16(sp)
 50e:	e426                	sd	s1,8(sp)
 510:	e04a                	sd	s2,0(sp)
 512:	1000                	addi	s0,sp,32
 514:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 516:	4581                	li	a1,0
 518:	00000097          	auipc	ra,0x0
 51c:	170080e7          	jalr	368(ra) # 688 <open>
  if(fd < 0)
 520:	02054563          	bltz	a0,54a <stat+0x42>
 524:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 526:	85ca                	mv	a1,s2
 528:	00000097          	auipc	ra,0x0
 52c:	178080e7          	jalr	376(ra) # 6a0 <fstat>
 530:	892a                	mv	s2,a0
  close(fd);
 532:	8526                	mv	a0,s1
 534:	00000097          	auipc	ra,0x0
 538:	13c080e7          	jalr	316(ra) # 670 <close>
  return r;
}
 53c:	854a                	mv	a0,s2
 53e:	60e2                	ld	ra,24(sp)
 540:	6442                	ld	s0,16(sp)
 542:	64a2                	ld	s1,8(sp)
 544:	6902                	ld	s2,0(sp)
 546:	6105                	addi	sp,sp,32
 548:	8082                	ret
    return -1;
 54a:	597d                	li	s2,-1
 54c:	bfc5                	j	53c <stat+0x34>

000000000000054e <atoi>:

int
atoi(const char *s)
{
 54e:	1141                	addi	sp,sp,-16
 550:	e422                	sd	s0,8(sp)
 552:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 554:	00054683          	lbu	a3,0(a0)
 558:	fd06879b          	addiw	a5,a3,-48
 55c:	0ff7f793          	zext.b	a5,a5
 560:	4625                	li	a2,9
 562:	02f66863          	bltu	a2,a5,592 <atoi+0x44>
 566:	872a                	mv	a4,a0
  n = 0;
 568:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 56a:	0705                	addi	a4,a4,1
 56c:	0025179b          	slliw	a5,a0,0x2
 570:	9fa9                	addw	a5,a5,a0
 572:	0017979b          	slliw	a5,a5,0x1
 576:	9fb5                	addw	a5,a5,a3
 578:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 57c:	00074683          	lbu	a3,0(a4)
 580:	fd06879b          	addiw	a5,a3,-48
 584:	0ff7f793          	zext.b	a5,a5
 588:	fef671e3          	bgeu	a2,a5,56a <atoi+0x1c>
  return n;
}
 58c:	6422                	ld	s0,8(sp)
 58e:	0141                	addi	sp,sp,16
 590:	8082                	ret
  n = 0;
 592:	4501                	li	a0,0
 594:	bfe5                	j	58c <atoi+0x3e>

0000000000000596 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 596:	1141                	addi	sp,sp,-16
 598:	e422                	sd	s0,8(sp)
 59a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 59c:	02b57463          	bgeu	a0,a1,5c4 <memmove+0x2e>
    while(n-- > 0)
 5a0:	00c05f63          	blez	a2,5be <memmove+0x28>
 5a4:	1602                	slli	a2,a2,0x20
 5a6:	9201                	srli	a2,a2,0x20
 5a8:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 5ac:	872a                	mv	a4,a0
      *dst++ = *src++;
 5ae:	0585                	addi	a1,a1,1
 5b0:	0705                	addi	a4,a4,1
 5b2:	fff5c683          	lbu	a3,-1(a1)
 5b6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 5ba:	fee79ae3          	bne	a5,a4,5ae <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 5be:	6422                	ld	s0,8(sp)
 5c0:	0141                	addi	sp,sp,16
 5c2:	8082                	ret
    dst += n;
 5c4:	00c50733          	add	a4,a0,a2
    src += n;
 5c8:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 5ca:	fec05ae3          	blez	a2,5be <memmove+0x28>
 5ce:	fff6079b          	addiw	a5,a2,-1
 5d2:	1782                	slli	a5,a5,0x20
 5d4:	9381                	srli	a5,a5,0x20
 5d6:	fff7c793          	not	a5,a5
 5da:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 5dc:	15fd                	addi	a1,a1,-1
 5de:	177d                	addi	a4,a4,-1
 5e0:	0005c683          	lbu	a3,0(a1)
 5e4:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 5e8:	fee79ae3          	bne	a5,a4,5dc <memmove+0x46>
 5ec:	bfc9                	j	5be <memmove+0x28>

00000000000005ee <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 5ee:	1141                	addi	sp,sp,-16
 5f0:	e422                	sd	s0,8(sp)
 5f2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 5f4:	ca05                	beqz	a2,624 <memcmp+0x36>
 5f6:	fff6069b          	addiw	a3,a2,-1
 5fa:	1682                	slli	a3,a3,0x20
 5fc:	9281                	srli	a3,a3,0x20
 5fe:	0685                	addi	a3,a3,1
 600:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 602:	00054783          	lbu	a5,0(a0)
 606:	0005c703          	lbu	a4,0(a1)
 60a:	00e79863          	bne	a5,a4,61a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 60e:	0505                	addi	a0,a0,1
    p2++;
 610:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 612:	fed518e3          	bne	a0,a3,602 <memcmp+0x14>
  }
  return 0;
 616:	4501                	li	a0,0
 618:	a019                	j	61e <memcmp+0x30>
      return *p1 - *p2;
 61a:	40e7853b          	subw	a0,a5,a4
}
 61e:	6422                	ld	s0,8(sp)
 620:	0141                	addi	sp,sp,16
 622:	8082                	ret
  return 0;
 624:	4501                	li	a0,0
 626:	bfe5                	j	61e <memcmp+0x30>

0000000000000628 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 628:	1141                	addi	sp,sp,-16
 62a:	e406                	sd	ra,8(sp)
 62c:	e022                	sd	s0,0(sp)
 62e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 630:	00000097          	auipc	ra,0x0
 634:	f66080e7          	jalr	-154(ra) # 596 <memmove>
}
 638:	60a2                	ld	ra,8(sp)
 63a:	6402                	ld	s0,0(sp)
 63c:	0141                	addi	sp,sp,16
 63e:	8082                	ret

0000000000000640 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 640:	4885                	li	a7,1
 ecall
 642:	00000073          	ecall
 ret
 646:	8082                	ret

0000000000000648 <exit>:
.global exit
exit:
 li a7, SYS_exit
 648:	4889                	li	a7,2
 ecall
 64a:	00000073          	ecall
 ret
 64e:	8082                	ret

0000000000000650 <wait>:
.global wait
wait:
 li a7, SYS_wait
 650:	488d                	li	a7,3
 ecall
 652:	00000073          	ecall
 ret
 656:	8082                	ret

0000000000000658 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 658:	4891                	li	a7,4
 ecall
 65a:	00000073          	ecall
 ret
 65e:	8082                	ret

0000000000000660 <read>:
.global read
read:
 li a7, SYS_read
 660:	4895                	li	a7,5
 ecall
 662:	00000073          	ecall
 ret
 666:	8082                	ret

0000000000000668 <write>:
.global write
write:
 li a7, SYS_write
 668:	48c1                	li	a7,16
 ecall
 66a:	00000073          	ecall
 ret
 66e:	8082                	ret

0000000000000670 <close>:
.global close
close:
 li a7, SYS_close
 670:	48d5                	li	a7,21
 ecall
 672:	00000073          	ecall
 ret
 676:	8082                	ret

0000000000000678 <kill>:
.global kill
kill:
 li a7, SYS_kill
 678:	4899                	li	a7,6
 ecall
 67a:	00000073          	ecall
 ret
 67e:	8082                	ret

0000000000000680 <exec>:
.global exec
exec:
 li a7, SYS_exec
 680:	489d                	li	a7,7
 ecall
 682:	00000073          	ecall
 ret
 686:	8082                	ret

0000000000000688 <open>:
.global open
open:
 li a7, SYS_open
 688:	48bd                	li	a7,15
 ecall
 68a:	00000073          	ecall
 ret
 68e:	8082                	ret

0000000000000690 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 690:	48c5                	li	a7,17
 ecall
 692:	00000073          	ecall
 ret
 696:	8082                	ret

0000000000000698 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 698:	48c9                	li	a7,18
 ecall
 69a:	00000073          	ecall
 ret
 69e:	8082                	ret

00000000000006a0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 6a0:	48a1                	li	a7,8
 ecall
 6a2:	00000073          	ecall
 ret
 6a6:	8082                	ret

00000000000006a8 <link>:
.global link
link:
 li a7, SYS_link
 6a8:	48cd                	li	a7,19
 ecall
 6aa:	00000073          	ecall
 ret
 6ae:	8082                	ret

00000000000006b0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 6b0:	48d1                	li	a7,20
 ecall
 6b2:	00000073          	ecall
 ret
 6b6:	8082                	ret

00000000000006b8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 6b8:	48a5                	li	a7,9
 ecall
 6ba:	00000073          	ecall
 ret
 6be:	8082                	ret

00000000000006c0 <dup>:
.global dup
dup:
 li a7, SYS_dup
 6c0:	48a9                	li	a7,10
 ecall
 6c2:	00000073          	ecall
 ret
 6c6:	8082                	ret

00000000000006c8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 6c8:	48ad                	li	a7,11
 ecall
 6ca:	00000073          	ecall
 ret
 6ce:	8082                	ret

00000000000006d0 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 6d0:	48b1                	li	a7,12
 ecall
 6d2:	00000073          	ecall
 ret
 6d6:	8082                	ret

00000000000006d8 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 6d8:	48b5                	li	a7,13
 ecall
 6da:	00000073          	ecall
 ret
 6de:	8082                	ret

00000000000006e0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 6e0:	48b9                	li	a7,14
 ecall
 6e2:	00000073          	ecall
 ret
 6e6:	8082                	ret

00000000000006e8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 6e8:	1101                	addi	sp,sp,-32
 6ea:	ec06                	sd	ra,24(sp)
 6ec:	e822                	sd	s0,16(sp)
 6ee:	1000                	addi	s0,sp,32
 6f0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 6f4:	4605                	li	a2,1
 6f6:	fef40593          	addi	a1,s0,-17
 6fa:	00000097          	auipc	ra,0x0
 6fe:	f6e080e7          	jalr	-146(ra) # 668 <write>
}
 702:	60e2                	ld	ra,24(sp)
 704:	6442                	ld	s0,16(sp)
 706:	6105                	addi	sp,sp,32
 708:	8082                	ret

000000000000070a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 70a:	7139                	addi	sp,sp,-64
 70c:	fc06                	sd	ra,56(sp)
 70e:	f822                	sd	s0,48(sp)
 710:	f426                	sd	s1,40(sp)
 712:	f04a                	sd	s2,32(sp)
 714:	ec4e                	sd	s3,24(sp)
 716:	0080                	addi	s0,sp,64
 718:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 71a:	c299                	beqz	a3,720 <printint+0x16>
 71c:	0805c963          	bltz	a1,7ae <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 720:	2581                	sext.w	a1,a1
  neg = 0;
 722:	4881                	li	a7,0
 724:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 728:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 72a:	2601                	sext.w	a2,a2
 72c:	00000517          	auipc	a0,0x0
 730:	51450513          	addi	a0,a0,1300 # c40 <digits>
 734:	883a                	mv	a6,a4
 736:	2705                	addiw	a4,a4,1
 738:	02c5f7bb          	remuw	a5,a1,a2
 73c:	1782                	slli	a5,a5,0x20
 73e:	9381                	srli	a5,a5,0x20
 740:	97aa                	add	a5,a5,a0
 742:	0007c783          	lbu	a5,0(a5)
 746:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 74a:	0005879b          	sext.w	a5,a1
 74e:	02c5d5bb          	divuw	a1,a1,a2
 752:	0685                	addi	a3,a3,1
 754:	fec7f0e3          	bgeu	a5,a2,734 <printint+0x2a>
  if(neg)
 758:	00088c63          	beqz	a7,770 <printint+0x66>
    buf[i++] = '-';
 75c:	fd070793          	addi	a5,a4,-48
 760:	00878733          	add	a4,a5,s0
 764:	02d00793          	li	a5,45
 768:	fef70823          	sb	a5,-16(a4)
 76c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 770:	02e05863          	blez	a4,7a0 <printint+0x96>
 774:	fc040793          	addi	a5,s0,-64
 778:	00e78933          	add	s2,a5,a4
 77c:	fff78993          	addi	s3,a5,-1
 780:	99ba                	add	s3,s3,a4
 782:	377d                	addiw	a4,a4,-1
 784:	1702                	slli	a4,a4,0x20
 786:	9301                	srli	a4,a4,0x20
 788:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 78c:	fff94583          	lbu	a1,-1(s2)
 790:	8526                	mv	a0,s1
 792:	00000097          	auipc	ra,0x0
 796:	f56080e7          	jalr	-170(ra) # 6e8 <putc>
  while(--i >= 0)
 79a:	197d                	addi	s2,s2,-1
 79c:	ff3918e3          	bne	s2,s3,78c <printint+0x82>
}
 7a0:	70e2                	ld	ra,56(sp)
 7a2:	7442                	ld	s0,48(sp)
 7a4:	74a2                	ld	s1,40(sp)
 7a6:	7902                	ld	s2,32(sp)
 7a8:	69e2                	ld	s3,24(sp)
 7aa:	6121                	addi	sp,sp,64
 7ac:	8082                	ret
    x = -xx;
 7ae:	40b005bb          	negw	a1,a1
    neg = 1;
 7b2:	4885                	li	a7,1
    x = -xx;
 7b4:	bf85                	j	724 <printint+0x1a>

00000000000007b6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 7b6:	7119                	addi	sp,sp,-128
 7b8:	fc86                	sd	ra,120(sp)
 7ba:	f8a2                	sd	s0,112(sp)
 7bc:	f4a6                	sd	s1,104(sp)
 7be:	f0ca                	sd	s2,96(sp)
 7c0:	ecce                	sd	s3,88(sp)
 7c2:	e8d2                	sd	s4,80(sp)
 7c4:	e4d6                	sd	s5,72(sp)
 7c6:	e0da                	sd	s6,64(sp)
 7c8:	fc5e                	sd	s7,56(sp)
 7ca:	f862                	sd	s8,48(sp)
 7cc:	f466                	sd	s9,40(sp)
 7ce:	f06a                	sd	s10,32(sp)
 7d0:	ec6e                	sd	s11,24(sp)
 7d2:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 7d4:	0005c903          	lbu	s2,0(a1)
 7d8:	18090f63          	beqz	s2,976 <vprintf+0x1c0>
 7dc:	8aaa                	mv	s5,a0
 7de:	8b32                	mv	s6,a2
 7e0:	00158493          	addi	s1,a1,1
  state = 0;
 7e4:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 7e6:	02500a13          	li	s4,37
 7ea:	4c55                	li	s8,21
 7ec:	00000c97          	auipc	s9,0x0
 7f0:	3fcc8c93          	addi	s9,s9,1020 # be8 <malloc+0x16e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 7f4:	02800d93          	li	s11,40
  putc(fd, 'x');
 7f8:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7fa:	00000b97          	auipc	s7,0x0
 7fe:	446b8b93          	addi	s7,s7,1094 # c40 <digits>
 802:	a839                	j	820 <vprintf+0x6a>
        putc(fd, c);
 804:	85ca                	mv	a1,s2
 806:	8556                	mv	a0,s5
 808:	00000097          	auipc	ra,0x0
 80c:	ee0080e7          	jalr	-288(ra) # 6e8 <putc>
 810:	a019                	j	816 <vprintf+0x60>
    } else if(state == '%'){
 812:	01498d63          	beq	s3,s4,82c <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 816:	0485                	addi	s1,s1,1
 818:	fff4c903          	lbu	s2,-1(s1)
 81c:	14090d63          	beqz	s2,976 <vprintf+0x1c0>
    if(state == 0){
 820:	fe0999e3          	bnez	s3,812 <vprintf+0x5c>
      if(c == '%'){
 824:	ff4910e3          	bne	s2,s4,804 <vprintf+0x4e>
        state = '%';
 828:	89d2                	mv	s3,s4
 82a:	b7f5                	j	816 <vprintf+0x60>
      if(c == 'd'){
 82c:	11490c63          	beq	s2,s4,944 <vprintf+0x18e>
 830:	f9d9079b          	addiw	a5,s2,-99
 834:	0ff7f793          	zext.b	a5,a5
 838:	10fc6e63          	bltu	s8,a5,954 <vprintf+0x19e>
 83c:	f9d9079b          	addiw	a5,s2,-99
 840:	0ff7f713          	zext.b	a4,a5
 844:	10ec6863          	bltu	s8,a4,954 <vprintf+0x19e>
 848:	00271793          	slli	a5,a4,0x2
 84c:	97e6                	add	a5,a5,s9
 84e:	439c                	lw	a5,0(a5)
 850:	97e6                	add	a5,a5,s9
 852:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 854:	008b0913          	addi	s2,s6,8
 858:	4685                	li	a3,1
 85a:	4629                	li	a2,10
 85c:	000b2583          	lw	a1,0(s6)
 860:	8556                	mv	a0,s5
 862:	00000097          	auipc	ra,0x0
 866:	ea8080e7          	jalr	-344(ra) # 70a <printint>
 86a:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 86c:	4981                	li	s3,0
 86e:	b765                	j	816 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 870:	008b0913          	addi	s2,s6,8
 874:	4681                	li	a3,0
 876:	4629                	li	a2,10
 878:	000b2583          	lw	a1,0(s6)
 87c:	8556                	mv	a0,s5
 87e:	00000097          	auipc	ra,0x0
 882:	e8c080e7          	jalr	-372(ra) # 70a <printint>
 886:	8b4a                	mv	s6,s2
      state = 0;
 888:	4981                	li	s3,0
 88a:	b771                	j	816 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 88c:	008b0913          	addi	s2,s6,8
 890:	4681                	li	a3,0
 892:	866a                	mv	a2,s10
 894:	000b2583          	lw	a1,0(s6)
 898:	8556                	mv	a0,s5
 89a:	00000097          	auipc	ra,0x0
 89e:	e70080e7          	jalr	-400(ra) # 70a <printint>
 8a2:	8b4a                	mv	s6,s2
      state = 0;
 8a4:	4981                	li	s3,0
 8a6:	bf85                	j	816 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 8a8:	008b0793          	addi	a5,s6,8
 8ac:	f8f43423          	sd	a5,-120(s0)
 8b0:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 8b4:	03000593          	li	a1,48
 8b8:	8556                	mv	a0,s5
 8ba:	00000097          	auipc	ra,0x0
 8be:	e2e080e7          	jalr	-466(ra) # 6e8 <putc>
  putc(fd, 'x');
 8c2:	07800593          	li	a1,120
 8c6:	8556                	mv	a0,s5
 8c8:	00000097          	auipc	ra,0x0
 8cc:	e20080e7          	jalr	-480(ra) # 6e8 <putc>
 8d0:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8d2:	03c9d793          	srli	a5,s3,0x3c
 8d6:	97de                	add	a5,a5,s7
 8d8:	0007c583          	lbu	a1,0(a5)
 8dc:	8556                	mv	a0,s5
 8de:	00000097          	auipc	ra,0x0
 8e2:	e0a080e7          	jalr	-502(ra) # 6e8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 8e6:	0992                	slli	s3,s3,0x4
 8e8:	397d                	addiw	s2,s2,-1
 8ea:	fe0914e3          	bnez	s2,8d2 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 8ee:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 8f2:	4981                	li	s3,0
 8f4:	b70d                	j	816 <vprintf+0x60>
        s = va_arg(ap, char*);
 8f6:	008b0913          	addi	s2,s6,8
 8fa:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 8fe:	02098163          	beqz	s3,920 <vprintf+0x16a>
        while(*s != 0){
 902:	0009c583          	lbu	a1,0(s3)
 906:	c5ad                	beqz	a1,970 <vprintf+0x1ba>
          putc(fd, *s);
 908:	8556                	mv	a0,s5
 90a:	00000097          	auipc	ra,0x0
 90e:	dde080e7          	jalr	-546(ra) # 6e8 <putc>
          s++;
 912:	0985                	addi	s3,s3,1
        while(*s != 0){
 914:	0009c583          	lbu	a1,0(s3)
 918:	f9e5                	bnez	a1,908 <vprintf+0x152>
        s = va_arg(ap, char*);
 91a:	8b4a                	mv	s6,s2
      state = 0;
 91c:	4981                	li	s3,0
 91e:	bde5                	j	816 <vprintf+0x60>
          s = "(null)";
 920:	00000997          	auipc	s3,0x0
 924:	2c098993          	addi	s3,s3,704 # be0 <malloc+0x166>
        while(*s != 0){
 928:	85ee                	mv	a1,s11
 92a:	bff9                	j	908 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 92c:	008b0913          	addi	s2,s6,8
 930:	000b4583          	lbu	a1,0(s6)
 934:	8556                	mv	a0,s5
 936:	00000097          	auipc	ra,0x0
 93a:	db2080e7          	jalr	-590(ra) # 6e8 <putc>
 93e:	8b4a                	mv	s6,s2
      state = 0;
 940:	4981                	li	s3,0
 942:	bdd1                	j	816 <vprintf+0x60>
        putc(fd, c);
 944:	85d2                	mv	a1,s4
 946:	8556                	mv	a0,s5
 948:	00000097          	auipc	ra,0x0
 94c:	da0080e7          	jalr	-608(ra) # 6e8 <putc>
      state = 0;
 950:	4981                	li	s3,0
 952:	b5d1                	j	816 <vprintf+0x60>
        putc(fd, '%');
 954:	85d2                	mv	a1,s4
 956:	8556                	mv	a0,s5
 958:	00000097          	auipc	ra,0x0
 95c:	d90080e7          	jalr	-624(ra) # 6e8 <putc>
        putc(fd, c);
 960:	85ca                	mv	a1,s2
 962:	8556                	mv	a0,s5
 964:	00000097          	auipc	ra,0x0
 968:	d84080e7          	jalr	-636(ra) # 6e8 <putc>
      state = 0;
 96c:	4981                	li	s3,0
 96e:	b565                	j	816 <vprintf+0x60>
        s = va_arg(ap, char*);
 970:	8b4a                	mv	s6,s2
      state = 0;
 972:	4981                	li	s3,0
 974:	b54d                	j	816 <vprintf+0x60>
    }
  }
}
 976:	70e6                	ld	ra,120(sp)
 978:	7446                	ld	s0,112(sp)
 97a:	74a6                	ld	s1,104(sp)
 97c:	7906                	ld	s2,96(sp)
 97e:	69e6                	ld	s3,88(sp)
 980:	6a46                	ld	s4,80(sp)
 982:	6aa6                	ld	s5,72(sp)
 984:	6b06                	ld	s6,64(sp)
 986:	7be2                	ld	s7,56(sp)
 988:	7c42                	ld	s8,48(sp)
 98a:	7ca2                	ld	s9,40(sp)
 98c:	7d02                	ld	s10,32(sp)
 98e:	6de2                	ld	s11,24(sp)
 990:	6109                	addi	sp,sp,128
 992:	8082                	ret

0000000000000994 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 994:	715d                	addi	sp,sp,-80
 996:	ec06                	sd	ra,24(sp)
 998:	e822                	sd	s0,16(sp)
 99a:	1000                	addi	s0,sp,32
 99c:	e010                	sd	a2,0(s0)
 99e:	e414                	sd	a3,8(s0)
 9a0:	e818                	sd	a4,16(s0)
 9a2:	ec1c                	sd	a5,24(s0)
 9a4:	03043023          	sd	a6,32(s0)
 9a8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 9ac:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 9b0:	8622                	mv	a2,s0
 9b2:	00000097          	auipc	ra,0x0
 9b6:	e04080e7          	jalr	-508(ra) # 7b6 <vprintf>
}
 9ba:	60e2                	ld	ra,24(sp)
 9bc:	6442                	ld	s0,16(sp)
 9be:	6161                	addi	sp,sp,80
 9c0:	8082                	ret

00000000000009c2 <printf>:

void
printf(const char *fmt, ...)
{
 9c2:	711d                	addi	sp,sp,-96
 9c4:	ec06                	sd	ra,24(sp)
 9c6:	e822                	sd	s0,16(sp)
 9c8:	1000                	addi	s0,sp,32
 9ca:	e40c                	sd	a1,8(s0)
 9cc:	e810                	sd	a2,16(s0)
 9ce:	ec14                	sd	a3,24(s0)
 9d0:	f018                	sd	a4,32(s0)
 9d2:	f41c                	sd	a5,40(s0)
 9d4:	03043823          	sd	a6,48(s0)
 9d8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 9dc:	00840613          	addi	a2,s0,8
 9e0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 9e4:	85aa                	mv	a1,a0
 9e6:	4505                	li	a0,1
 9e8:	00000097          	auipc	ra,0x0
 9ec:	dce080e7          	jalr	-562(ra) # 7b6 <vprintf>
}
 9f0:	60e2                	ld	ra,24(sp)
 9f2:	6442                	ld	s0,16(sp)
 9f4:	6125                	addi	sp,sp,96
 9f6:	8082                	ret

00000000000009f8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9f8:	1141                	addi	sp,sp,-16
 9fa:	e422                	sd	s0,8(sp)
 9fc:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 9fe:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a02:	00000797          	auipc	a5,0x0
 a06:	2567b783          	ld	a5,598(a5) # c58 <freep>
 a0a:	a02d                	j	a34 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 a0c:	4618                	lw	a4,8(a2)
 a0e:	9f2d                	addw	a4,a4,a1
 a10:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a14:	6398                	ld	a4,0(a5)
 a16:	6310                	ld	a2,0(a4)
 a18:	a83d                	j	a56 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 a1a:	ff852703          	lw	a4,-8(a0)
 a1e:	9f31                	addw	a4,a4,a2
 a20:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 a22:	ff053683          	ld	a3,-16(a0)
 a26:	a091                	j	a6a <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a28:	6398                	ld	a4,0(a5)
 a2a:	00e7e463          	bltu	a5,a4,a32 <free+0x3a>
 a2e:	00e6ea63          	bltu	a3,a4,a42 <free+0x4a>
{
 a32:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a34:	fed7fae3          	bgeu	a5,a3,a28 <free+0x30>
 a38:	6398                	ld	a4,0(a5)
 a3a:	00e6e463          	bltu	a3,a4,a42 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a3e:	fee7eae3          	bltu	a5,a4,a32 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 a42:	ff852583          	lw	a1,-8(a0)
 a46:	6390                	ld	a2,0(a5)
 a48:	02059813          	slli	a6,a1,0x20
 a4c:	01c85713          	srli	a4,a6,0x1c
 a50:	9736                	add	a4,a4,a3
 a52:	fae60de3          	beq	a2,a4,a0c <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 a56:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 a5a:	4790                	lw	a2,8(a5)
 a5c:	02061593          	slli	a1,a2,0x20
 a60:	01c5d713          	srli	a4,a1,0x1c
 a64:	973e                	add	a4,a4,a5
 a66:	fae68ae3          	beq	a3,a4,a1a <free+0x22>
    p->s.ptr = bp->s.ptr;
 a6a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 a6c:	00000717          	auipc	a4,0x0
 a70:	1ef73623          	sd	a5,492(a4) # c58 <freep>
}
 a74:	6422                	ld	s0,8(sp)
 a76:	0141                	addi	sp,sp,16
 a78:	8082                	ret

0000000000000a7a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a7a:	7139                	addi	sp,sp,-64
 a7c:	fc06                	sd	ra,56(sp)
 a7e:	f822                	sd	s0,48(sp)
 a80:	f426                	sd	s1,40(sp)
 a82:	f04a                	sd	s2,32(sp)
 a84:	ec4e                	sd	s3,24(sp)
 a86:	e852                	sd	s4,16(sp)
 a88:	e456                	sd	s5,8(sp)
 a8a:	e05a                	sd	s6,0(sp)
 a8c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a8e:	02051493          	slli	s1,a0,0x20
 a92:	9081                	srli	s1,s1,0x20
 a94:	04bd                	addi	s1,s1,15
 a96:	8091                	srli	s1,s1,0x4
 a98:	0014899b          	addiw	s3,s1,1
 a9c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 a9e:	00000517          	auipc	a0,0x0
 aa2:	1ba53503          	ld	a0,442(a0) # c58 <freep>
 aa6:	c515                	beqz	a0,ad2 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 aa8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 aaa:	4798                	lw	a4,8(a5)
 aac:	02977f63          	bgeu	a4,s1,aea <malloc+0x70>
 ab0:	8a4e                	mv	s4,s3
 ab2:	0009871b          	sext.w	a4,s3
 ab6:	6685                	lui	a3,0x1
 ab8:	00d77363          	bgeu	a4,a3,abe <malloc+0x44>
 abc:	6a05                	lui	s4,0x1
 abe:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 ac2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 ac6:	00000917          	auipc	s2,0x0
 aca:	19290913          	addi	s2,s2,402 # c58 <freep>
  if(p == (char*)-1)
 ace:	5afd                	li	s5,-1
 ad0:	a895                	j	b44 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 ad2:	00000797          	auipc	a5,0x0
 ad6:	59e78793          	addi	a5,a5,1438 # 1070 <base>
 ada:	00000717          	auipc	a4,0x0
 ade:	16f73f23          	sd	a5,382(a4) # c58 <freep>
 ae2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 ae4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 ae8:	b7e1                	j	ab0 <malloc+0x36>
      if(p->s.size == nunits)
 aea:	02e48c63          	beq	s1,a4,b22 <malloc+0xa8>
        p->s.size -= nunits;
 aee:	4137073b          	subw	a4,a4,s3
 af2:	c798                	sw	a4,8(a5)
        p += p->s.size;
 af4:	02071693          	slli	a3,a4,0x20
 af8:	01c6d713          	srli	a4,a3,0x1c
 afc:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 afe:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b02:	00000717          	auipc	a4,0x0
 b06:	14a73b23          	sd	a0,342(a4) # c58 <freep>
      return (void*)(p + 1);
 b0a:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 b0e:	70e2                	ld	ra,56(sp)
 b10:	7442                	ld	s0,48(sp)
 b12:	74a2                	ld	s1,40(sp)
 b14:	7902                	ld	s2,32(sp)
 b16:	69e2                	ld	s3,24(sp)
 b18:	6a42                	ld	s4,16(sp)
 b1a:	6aa2                	ld	s5,8(sp)
 b1c:	6b02                	ld	s6,0(sp)
 b1e:	6121                	addi	sp,sp,64
 b20:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 b22:	6398                	ld	a4,0(a5)
 b24:	e118                	sd	a4,0(a0)
 b26:	bff1                	j	b02 <malloc+0x88>
  hp->s.size = nu;
 b28:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 b2c:	0541                	addi	a0,a0,16
 b2e:	00000097          	auipc	ra,0x0
 b32:	eca080e7          	jalr	-310(ra) # 9f8 <free>
  return freep;
 b36:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 b3a:	d971                	beqz	a0,b0e <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b3c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b3e:	4798                	lw	a4,8(a5)
 b40:	fa9775e3          	bgeu	a4,s1,aea <malloc+0x70>
    if(p == freep)
 b44:	00093703          	ld	a4,0(s2)
 b48:	853e                	mv	a0,a5
 b4a:	fef719e3          	bne	a4,a5,b3c <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 b4e:	8552                	mv	a0,s4
 b50:	00000097          	auipc	ra,0x0
 b54:	b80080e7          	jalr	-1152(ra) # 6d0 <sbrk>
  if(p == (char*)-1)
 b58:	fd5518e3          	bne	a0,s5,b28 <malloc+0xae>
        return 0;
 b5c:	4501                	li	a0,0
 b5e:	bf45                	j	b0e <malloc+0x94>
