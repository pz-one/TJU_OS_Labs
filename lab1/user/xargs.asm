
user/_xargs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <printargs>:
void printargs(char* args[MAXARG][CMDSTYLE], int args_num);

/* 打印参数 */
void printargs(char* args[MAXARG][CMDSTYLE], int args_num)
{
    for (int i = 0; i < args_num; i++)
   0:	06b05f63          	blez	a1,7e <printargs+0x7e>
{
   4:	715d                	addi	sp,sp,-80
   6:	e486                	sd	ra,72(sp)
   8:	e0a2                	sd	s0,64(sp)
   a:	fc26                	sd	s1,56(sp)
   c:	f84a                	sd	s2,48(sp)
   e:	f44e                	sd	s3,40(sp)
  10:	f052                	sd	s4,32(sp)
  12:	ec56                	sd	s5,24(sp)
  14:	e85a                	sd	s6,16(sp)
  16:	e45e                	sd	s7,8(sp)
  18:	0880                	addi	s0,sp,80
  1a:	8aae                	mv	s5,a1
  1c:	84aa                	mv	s1,a0
    for (int i = 0; i < args_num; i++)
  1e:	4901                	li	s2,0
    {
        /* 打印组合后的代码 */
        printf("--------------args %d:--------------\n", i + 1);
  20:	00001b97          	auipc	s7,0x1
  24:	a10b8b93          	addi	s7,s7,-1520 # a30 <malloc+0xec>
        printf("cmd: %s, arg: %s, argslen: %d \n", args[i][0], args[i][1], strlen(args[i][1]));
  28:	00001b17          	auipc	s6,0x1
  2c:	a30b0b13          	addi	s6,s6,-1488 # a58 <malloc+0x114>
        printf("--------------args %d:--------------\n", i + 1);
  30:	2905                	addiw	s2,s2,1
  32:	85ca                	mv	a1,s2
  34:	855e                	mv	a0,s7
  36:	00001097          	auipc	ra,0x1
  3a:	856080e7          	jalr	-1962(ra) # 88c <printf>
        printf("cmd: %s, arg: %s, argslen: %d \n", args[i][0], args[i][1], strlen(args[i][1]));
  3e:	0004ba03          	ld	s4,0(s1)
  42:	0084b983          	ld	s3,8(s1)
  46:	854e                	mv	a0,s3
  48:	00000097          	auipc	ra,0x0
  4c:	2a6080e7          	jalr	678(ra) # 2ee <strlen>
  50:	0005069b          	sext.w	a3,a0
  54:	864e                	mv	a2,s3
  56:	85d2                	mv	a1,s4
  58:	855a                	mv	a0,s6
  5a:	00001097          	auipc	ra,0x1
  5e:	832080e7          	jalr	-1998(ra) # 88c <printf>
    for (int i = 0; i < args_num; i++)
  62:	04c1                	addi	s1,s1,16
  64:	fd5916e3          	bne	s2,s5,30 <printargs+0x30>
    }
    
}
  68:	60a6                	ld	ra,72(sp)
  6a:	6406                	ld	s0,64(sp)
  6c:	74e2                	ld	s1,56(sp)
  6e:	7942                	ld	s2,48(sp)
  70:	79a2                	ld	s3,40(sp)
  72:	7a02                	ld	s4,32(sp)
  74:	6ae2                	ld	s5,24(sp)
  76:	6b42                	ld	s6,16(sp)
  78:	6ba2                	ld	s7,8(sp)
  7a:	6161                	addi	sp,sp,80
  7c:	8082                	ret
  7e:	8082                	ret

0000000000000080 <substring>:
/* 以‘\n’分割的子串 */
void substring(char s[], char *sub, int pos, int len) 
{
  80:	1141                	addi	sp,sp,-16
  82:	e422                	sd	s0,8(sp)
  84:	0800                	addi	s0,sp,16
   int c = 0;   
   while (c < len) 
  86:	02d05963          	blez	a3,b8 <substring+0x38>
  8a:	9532                	add	a0,a0,a2
  8c:	87ae                	mv	a5,a1
  8e:	00158613          	addi	a2,a1,1
  92:	fff6871b          	addiw	a4,a3,-1
  96:	1702                	slli	a4,a4,0x20
  98:	9301                	srli	a4,a4,0x20
  9a:	963a                	add	a2,a2,a4
   {
      *(sub + c) = s[pos+c];
  9c:	00054703          	lbu	a4,0(a0)
  a0:	00e78023          	sb	a4,0(a5)
   while (c < len) 
  a4:	0505                	addi	a0,a0,1
  a6:	0785                	addi	a5,a5,1
  a8:	fec79ae3          	bne	a5,a2,9c <substring+0x1c>
      c++;
   }
   *(sub + c) = '\0';
  ac:	95b6                	add	a1,a1,a3
  ae:	00058023          	sb	zero,0(a1)
}
  b2:	6422                	ld	s0,8(sp)
  b4:	0141                	addi	sp,sp,16
  b6:	8082                	ret
   int c = 0;   
  b8:	4681                	li	a3,0
  ba:	bfcd                	j	ac <substring+0x2c>

00000000000000bc <cutoffinput>:

/* 截断 '\n' */
char* cutoffinput(char *buf)
{
  bc:	1101                	addi	sp,sp,-32
  be:	ec06                	sd	ra,24(sp)
  c0:	e822                	sd	s0,16(sp)
  c2:	e426                	sd	s1,8(sp)
  c4:	e04a                	sd	s2,0(sp)
  c6:	1000                	addi	s0,sp,32
  c8:	84aa                	mv	s1,a0
    /* 为char *新分配一片地址空间，否则编译器默认指向同一片地址 */
    if(strlen(buf) > 1 && buf[strlen(buf) - 1] == '\n')
  ca:	00000097          	auipc	ra,0x0
  ce:	224080e7          	jalr	548(ra) # 2ee <strlen>
  d2:	2501                	sext.w	a0,a0
  d4:	4785                	li	a5,1
  d6:	02a7f063          	bgeu	a5,a0,f6 <cutoffinput+0x3a>
  da:	8526                	mv	a0,s1
  dc:	00000097          	auipc	ra,0x0
  e0:	212080e7          	jalr	530(ra) # 2ee <strlen>
  e4:	357d                	addiw	a0,a0,-1
  e6:	1502                	slli	a0,a0,0x20
  e8:	9101                	srli	a0,a0,0x20
  ea:	9526                	add	a0,a0,s1
  ec:	00054703          	lbu	a4,0(a0)
  f0:	47a9                	li	a5,10
  f2:	02f70963          	beq	a4,a5,124 <cutoffinput+0x68>
        substring(buf, subbuff, 0, strlen(buf) - 1);
        return subbuff;
    }
    else
    {
        char *subbuff = (char*)malloc(sizeof(char) * strlen(buf));
  f6:	8526                	mv	a0,s1
  f8:	00000097          	auipc	ra,0x0
  fc:	1f6080e7          	jalr	502(ra) # 2ee <strlen>
 100:	2501                	sext.w	a0,a0
 102:	00001097          	auipc	ra,0x1
 106:	842080e7          	jalr	-1982(ra) # 944 <malloc>
 10a:	892a                	mv	s2,a0
        strcpy(subbuff, buf);
 10c:	85a6                	mv	a1,s1
 10e:	00000097          	auipc	ra,0x0
 112:	198080e7          	jalr	408(ra) # 2a6 <strcpy>
        return subbuff;
    }
}
 116:	854a                	mv	a0,s2
 118:	60e2                	ld	ra,24(sp)
 11a:	6442                	ld	s0,16(sp)
 11c:	64a2                	ld	s1,8(sp)
 11e:	6902                	ld	s2,0(sp)
 120:	6105                	addi	sp,sp,32
 122:	8082                	ret
        char *subbuff = (char*)malloc(sizeof(char) * (strlen(buf) - 1));
 124:	8526                	mv	a0,s1
 126:	00000097          	auipc	ra,0x0
 12a:	1c8080e7          	jalr	456(ra) # 2ee <strlen>
 12e:	357d                	addiw	a0,a0,-1
 130:	00001097          	auipc	ra,0x1
 134:	814080e7          	jalr	-2028(ra) # 944 <malloc>
 138:	892a                	mv	s2,a0
        substring(buf, subbuff, 0, strlen(buf) - 1);
 13a:	8526                	mv	a0,s1
 13c:	00000097          	auipc	ra,0x0
 140:	1b2080e7          	jalr	434(ra) # 2ee <strlen>
 144:	fff5069b          	addiw	a3,a0,-1
 148:	4601                	li	a2,0
 14a:	85ca                	mv	a1,s2
 14c:	8526                	mv	a0,s1
 14e:	00000097          	auipc	ra,0x0
 152:	f32080e7          	jalr	-206(ra) # 80 <substring>
        return subbuff;
 156:	b7c1                	j	116 <cutoffinput+0x5a>

0000000000000158 <main>:

int main(int argc, char *argv[])
{
 158:	d3010113          	addi	sp,sp,-720
 15c:	2c113423          	sd	ra,712(sp)
 160:	2c813023          	sd	s0,704(sp)
 164:	2a913c23          	sd	s1,696(sp)
 168:	2b213823          	sd	s2,688(sp)
 16c:	2b313423          	sd	s3,680(sp)
 170:	2b413023          	sd	s4,672(sp)
 174:	29513c23          	sd	s5,664(sp)
 178:	29613823          	sd	s6,656(sp)
 17c:	29713423          	sd	s7,648(sp)
 180:	29813023          	sd	s8,640(sp)
 184:	0d80                	addi	s0,sp,720
 186:	8aaa                	mv	s5,a0
 188:	8bae                	mv	s7,a1
    int pid;
    char buf[MAXPATH];
    char *args[MAXARG];
    char *cmd;
    /* 默认命令为echo */
    if(argc == 1)
 18a:	4785                	li	a5,1
    {
        cmd = "echo";
 18c:	00001b17          	auipc	s6,0x1
 190:	8ecb0b13          	addi	s6,s6,-1812 # a78 <malloc+0x134>
    if(argc == 1)
 194:	00f50463          	beq	a0,a5,19c <main+0x44>
    }
    else
    {
        cmd = argv[1];
 198:	0085bb03          	ld	s6,8(a1)
    }
    /* 计数器 */
    int args_num = 0;
 19c:	e3040993          	addi	s3,s0,-464
        cmd = "echo";
 1a0:	8a4e                	mv	s4,s3
    int args_num = 0;
 1a2:	4901                	li	s2,0
        gets(buf, MAXPATH);
        //printf("buf:%s",buf);
        char *arg = cutoffinput(buf);
        //printf("xargs:gets arg: %s, arglen: %d\n", arg, strlen(arg)); 
        //press ctrl + D
        if(strlen(arg) == 0 || args_num >= MAXARG)
 1a4:	02000c13          	li	s8,32
        memset(buf, 0, sizeof(buf));
 1a8:	08000613          	li	a2,128
 1ac:	4581                	li	a1,0
 1ae:	f3040513          	addi	a0,s0,-208
 1b2:	00000097          	auipc	ra,0x0
 1b6:	166080e7          	jalr	358(ra) # 318 <memset>
        gets(buf, MAXPATH);
 1ba:	08000593          	li	a1,128
 1be:	f3040513          	addi	a0,s0,-208
 1c2:	00000097          	auipc	ra,0x0
 1c6:	19c080e7          	jalr	412(ra) # 35e <gets>
        char *arg = cutoffinput(buf);
 1ca:	f3040513          	addi	a0,s0,-208
 1ce:	00000097          	auipc	ra,0x0
 1d2:	eee080e7          	jalr	-274(ra) # bc <cutoffinput>
 1d6:	84aa                	mv	s1,a0
        if(strlen(arg) == 0 || args_num >= MAXARG)
 1d8:	00000097          	auipc	ra,0x0
 1dc:	116080e7          	jalr	278(ra) # 2ee <strlen>
 1e0:	0005079b          	sext.w	a5,a0
 1e4:	cb81                	beqz	a5,1f4 <main+0x9c>
 1e6:	0b890963          	beq	s2,s8,298 <main+0x140>
	{
            break;
        }
        args[args_num]= arg;
 1ea:	009a3023          	sd	s1,0(s4)
        args_num++;
 1ee:	2905                	addiw	s2,s2,1
    while (1)
 1f0:	0a21                	addi	s4,s4,8
    {
 1f2:	bf5d                	j	1a8 <main+0x50>
    //   printf("Break Here\n");
     
    // 填充exec需要执行的命令至argv2exec
    int argstartpos = 1;
    char *argv2exec[MAXARG];
    argv2exec[0] = cmd;
 1f4:	d3643823          	sd	s6,-720(s0)
    //自身参数输入
    for (; argstartpos < argc-1; argstartpos++)
 1f8:	4789                	li	a5,2
 1fa:	0957d763          	bge	a5,s5,288 <main+0x130>
 1fe:	010b8793          	addi	a5,s7,16
 202:	d3840713          	addi	a4,s0,-712
 206:	000a861b          	sext.w	a2,s5
 20a:	3af5                	addiw	s5,s5,-3
 20c:	020a9693          	slli	a3,s5,0x20
 210:	01d6da93          	srli	s5,a3,0x1d
 214:	0be1                	addi	s7,s7,24
 216:	9ade                	add	s5,s5,s7
    {
        argv2exec[argstartpos] = argv[argstartpos+1];
 218:	6394                	ld	a3,0(a5)
 21a:	e314                	sd	a3,0(a4)
    for (; argstartpos < argc-1; argstartpos++)
 21c:	07a1                	addi	a5,a5,8
 21e:	0721                	addi	a4,a4,8
 220:	ff579ce3          	bne	a5,s5,218 <main+0xc0>
 224:	367d                	addiw	a2,a2,-1
    }
    //其他输入
    for (int i = 0; i < args_num; i++)
 226:	03205763          	blez	s2,254 <main+0xfc>
 22a:	00361793          	slli	a5,a2,0x3
 22e:	d3040713          	addi	a4,s0,-720
 232:	97ba                	add	a5,a5,a4
 234:	fff9069b          	addiw	a3,s2,-1
 238:	02069713          	slli	a4,a3,0x20
 23c:	01d75693          	srli	a3,a4,0x1d
 240:	00898713          	addi	a4,s3,8
 244:	96ba                	add	a3,a3,a4
    {
        argv2exec[i + argstartpos] = args[i];
 246:	0009b703          	ld	a4,0(s3)
 24a:	e398                	sd	a4,0(a5)
    for (int i = 0; i < args_num; i++)
 24c:	09a1                	addi	s3,s3,8
 24e:	07a1                	addi	a5,a5,8
 250:	fed99be3          	bne	s3,a3,246 <main+0xee>
    }
    argv2exec[args_num + argstartpos] = 0;
 254:	00c9063b          	addw	a2,s2,a2
 258:	060e                	slli	a2,a2,0x3
 25a:	fb060793          	addi	a5,a2,-80
 25e:	00878633          	add	a2,a5,s0
 262:	d8063023          	sd	zero,-640(a2)
    {
	    printf("%s \n",argv2exec[i]);
    }
*/
    /* 运行cmd */
    if((pid = fork()) == 0)
 266:	00000097          	auipc	ra,0x0
 26a:	2a4080e7          	jalr	676(ra) # 50a <fork>
 26e:	ed19                	bnez	a0,28c <main+0x134>
    {   
        exec(cmd, argv2exec);    
 270:	d3040593          	addi	a1,s0,-720
 274:	855a                	mv	a0,s6
 276:	00000097          	auipc	ra,0x0
 27a:	2d4080e7          	jalr	724(ra) # 54a <exec>
    else
    {
        /* code */
        wait(0);
    }
    exit(0);
 27e:	4501                	li	a0,0
 280:	00000097          	auipc	ra,0x0
 284:	292080e7          	jalr	658(ra) # 512 <exit>
    int argstartpos = 1;
 288:	4605                	li	a2,1
 28a:	bf71                	j	226 <main+0xce>
        wait(0);
 28c:	4501                	li	a0,0
 28e:	00000097          	auipc	ra,0x0
 292:	28c080e7          	jalr	652(ra) # 51a <wait>
 296:	b7e5                	j	27e <main+0x126>
    argv2exec[0] = cmd;
 298:	d3643823          	sd	s6,-720(s0)
    for (; argstartpos < argc-1; argstartpos++)
 29c:	4789                	li	a5,2
    int argstartpos = 1;
 29e:	4605                	li	a2,1
    for (; argstartpos < argc-1; argstartpos++)
 2a0:	f557cfe3          	blt	a5,s5,1fe <main+0xa6>
 2a4:	b759                	j	22a <main+0xd2>

00000000000002a6 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 2a6:	1141                	addi	sp,sp,-16
 2a8:	e422                	sd	s0,8(sp)
 2aa:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2ac:	87aa                	mv	a5,a0
 2ae:	0585                	addi	a1,a1,1
 2b0:	0785                	addi	a5,a5,1
 2b2:	fff5c703          	lbu	a4,-1(a1)
 2b6:	fee78fa3          	sb	a4,-1(a5)
 2ba:	fb75                	bnez	a4,2ae <strcpy+0x8>
    ;
  return os;
}
 2bc:	6422                	ld	s0,8(sp)
 2be:	0141                	addi	sp,sp,16
 2c0:	8082                	ret

00000000000002c2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2c2:	1141                	addi	sp,sp,-16
 2c4:	e422                	sd	s0,8(sp)
 2c6:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2c8:	00054783          	lbu	a5,0(a0)
 2cc:	cb91                	beqz	a5,2e0 <strcmp+0x1e>
 2ce:	0005c703          	lbu	a4,0(a1)
 2d2:	00f71763          	bne	a4,a5,2e0 <strcmp+0x1e>
    p++, q++;
 2d6:	0505                	addi	a0,a0,1
 2d8:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2da:	00054783          	lbu	a5,0(a0)
 2de:	fbe5                	bnez	a5,2ce <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2e0:	0005c503          	lbu	a0,0(a1)
}
 2e4:	40a7853b          	subw	a0,a5,a0
 2e8:	6422                	ld	s0,8(sp)
 2ea:	0141                	addi	sp,sp,16
 2ec:	8082                	ret

00000000000002ee <strlen>:

uint
strlen(const char *s)
{
 2ee:	1141                	addi	sp,sp,-16
 2f0:	e422                	sd	s0,8(sp)
 2f2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2f4:	00054783          	lbu	a5,0(a0)
 2f8:	cf91                	beqz	a5,314 <strlen+0x26>
 2fa:	0505                	addi	a0,a0,1
 2fc:	87aa                	mv	a5,a0
 2fe:	4685                	li	a3,1
 300:	9e89                	subw	a3,a3,a0
 302:	00f6853b          	addw	a0,a3,a5
 306:	0785                	addi	a5,a5,1
 308:	fff7c703          	lbu	a4,-1(a5)
 30c:	fb7d                	bnez	a4,302 <strlen+0x14>
    ;
  return n;
}
 30e:	6422                	ld	s0,8(sp)
 310:	0141                	addi	sp,sp,16
 312:	8082                	ret
  for(n = 0; s[n]; n++)
 314:	4501                	li	a0,0
 316:	bfe5                	j	30e <strlen+0x20>

0000000000000318 <memset>:

void*
memset(void *dst, int c, uint n)
{
 318:	1141                	addi	sp,sp,-16
 31a:	e422                	sd	s0,8(sp)
 31c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 31e:	ca19                	beqz	a2,334 <memset+0x1c>
 320:	87aa                	mv	a5,a0
 322:	1602                	slli	a2,a2,0x20
 324:	9201                	srli	a2,a2,0x20
 326:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 32a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 32e:	0785                	addi	a5,a5,1
 330:	fee79de3          	bne	a5,a4,32a <memset+0x12>
  }
  return dst;
}
 334:	6422                	ld	s0,8(sp)
 336:	0141                	addi	sp,sp,16
 338:	8082                	ret

000000000000033a <strchr>:

char*
strchr(const char *s, char c)
{
 33a:	1141                	addi	sp,sp,-16
 33c:	e422                	sd	s0,8(sp)
 33e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 340:	00054783          	lbu	a5,0(a0)
 344:	cb99                	beqz	a5,35a <strchr+0x20>
    if(*s == c)
 346:	00f58763          	beq	a1,a5,354 <strchr+0x1a>
  for(; *s; s++)
 34a:	0505                	addi	a0,a0,1
 34c:	00054783          	lbu	a5,0(a0)
 350:	fbfd                	bnez	a5,346 <strchr+0xc>
      return (char*)s;
  return 0;
 352:	4501                	li	a0,0
}
 354:	6422                	ld	s0,8(sp)
 356:	0141                	addi	sp,sp,16
 358:	8082                	ret
  return 0;
 35a:	4501                	li	a0,0
 35c:	bfe5                	j	354 <strchr+0x1a>

000000000000035e <gets>:

char*
gets(char *buf, int max)
{
 35e:	711d                	addi	sp,sp,-96
 360:	ec86                	sd	ra,88(sp)
 362:	e8a2                	sd	s0,80(sp)
 364:	e4a6                	sd	s1,72(sp)
 366:	e0ca                	sd	s2,64(sp)
 368:	fc4e                	sd	s3,56(sp)
 36a:	f852                	sd	s4,48(sp)
 36c:	f456                	sd	s5,40(sp)
 36e:	f05a                	sd	s6,32(sp)
 370:	ec5e                	sd	s7,24(sp)
 372:	1080                	addi	s0,sp,96
 374:	8baa                	mv	s7,a0
 376:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 378:	892a                	mv	s2,a0
 37a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 37c:	4aa9                	li	s5,10
 37e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 380:	89a6                	mv	s3,s1
 382:	2485                	addiw	s1,s1,1
 384:	0344d863          	bge	s1,s4,3b4 <gets+0x56>
    cc = read(0, &c, 1);
 388:	4605                	li	a2,1
 38a:	faf40593          	addi	a1,s0,-81
 38e:	4501                	li	a0,0
 390:	00000097          	auipc	ra,0x0
 394:	19a080e7          	jalr	410(ra) # 52a <read>
    if(cc < 1)
 398:	00a05e63          	blez	a0,3b4 <gets+0x56>
    buf[i++] = c;
 39c:	faf44783          	lbu	a5,-81(s0)
 3a0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3a4:	01578763          	beq	a5,s5,3b2 <gets+0x54>
 3a8:	0905                	addi	s2,s2,1
 3aa:	fd679be3          	bne	a5,s6,380 <gets+0x22>
  for(i=0; i+1 < max; ){
 3ae:	89a6                	mv	s3,s1
 3b0:	a011                	j	3b4 <gets+0x56>
 3b2:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3b4:	99de                	add	s3,s3,s7
 3b6:	00098023          	sb	zero,0(s3)
  return buf;
}
 3ba:	855e                	mv	a0,s7
 3bc:	60e6                	ld	ra,88(sp)
 3be:	6446                	ld	s0,80(sp)
 3c0:	64a6                	ld	s1,72(sp)
 3c2:	6906                	ld	s2,64(sp)
 3c4:	79e2                	ld	s3,56(sp)
 3c6:	7a42                	ld	s4,48(sp)
 3c8:	7aa2                	ld	s5,40(sp)
 3ca:	7b02                	ld	s6,32(sp)
 3cc:	6be2                	ld	s7,24(sp)
 3ce:	6125                	addi	sp,sp,96
 3d0:	8082                	ret

00000000000003d2 <stat>:

int
stat(const char *n, struct stat *st)
{
 3d2:	1101                	addi	sp,sp,-32
 3d4:	ec06                	sd	ra,24(sp)
 3d6:	e822                	sd	s0,16(sp)
 3d8:	e426                	sd	s1,8(sp)
 3da:	e04a                	sd	s2,0(sp)
 3dc:	1000                	addi	s0,sp,32
 3de:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3e0:	4581                	li	a1,0
 3e2:	00000097          	auipc	ra,0x0
 3e6:	170080e7          	jalr	368(ra) # 552 <open>
  if(fd < 0)
 3ea:	02054563          	bltz	a0,414 <stat+0x42>
 3ee:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3f0:	85ca                	mv	a1,s2
 3f2:	00000097          	auipc	ra,0x0
 3f6:	178080e7          	jalr	376(ra) # 56a <fstat>
 3fa:	892a                	mv	s2,a0
  close(fd);
 3fc:	8526                	mv	a0,s1
 3fe:	00000097          	auipc	ra,0x0
 402:	13c080e7          	jalr	316(ra) # 53a <close>
  return r;
}
 406:	854a                	mv	a0,s2
 408:	60e2                	ld	ra,24(sp)
 40a:	6442                	ld	s0,16(sp)
 40c:	64a2                	ld	s1,8(sp)
 40e:	6902                	ld	s2,0(sp)
 410:	6105                	addi	sp,sp,32
 412:	8082                	ret
    return -1;
 414:	597d                	li	s2,-1
 416:	bfc5                	j	406 <stat+0x34>

0000000000000418 <atoi>:

int
atoi(const char *s)
{
 418:	1141                	addi	sp,sp,-16
 41a:	e422                	sd	s0,8(sp)
 41c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 41e:	00054683          	lbu	a3,0(a0)
 422:	fd06879b          	addiw	a5,a3,-48
 426:	0ff7f793          	zext.b	a5,a5
 42a:	4625                	li	a2,9
 42c:	02f66863          	bltu	a2,a5,45c <atoi+0x44>
 430:	872a                	mv	a4,a0
  n = 0;
 432:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 434:	0705                	addi	a4,a4,1
 436:	0025179b          	slliw	a5,a0,0x2
 43a:	9fa9                	addw	a5,a5,a0
 43c:	0017979b          	slliw	a5,a5,0x1
 440:	9fb5                	addw	a5,a5,a3
 442:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 446:	00074683          	lbu	a3,0(a4)
 44a:	fd06879b          	addiw	a5,a3,-48
 44e:	0ff7f793          	zext.b	a5,a5
 452:	fef671e3          	bgeu	a2,a5,434 <atoi+0x1c>
  return n;
}
 456:	6422                	ld	s0,8(sp)
 458:	0141                	addi	sp,sp,16
 45a:	8082                	ret
  n = 0;
 45c:	4501                	li	a0,0
 45e:	bfe5                	j	456 <atoi+0x3e>

0000000000000460 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 460:	1141                	addi	sp,sp,-16
 462:	e422                	sd	s0,8(sp)
 464:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 466:	02b57463          	bgeu	a0,a1,48e <memmove+0x2e>
    while(n-- > 0)
 46a:	00c05f63          	blez	a2,488 <memmove+0x28>
 46e:	1602                	slli	a2,a2,0x20
 470:	9201                	srli	a2,a2,0x20
 472:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 476:	872a                	mv	a4,a0
      *dst++ = *src++;
 478:	0585                	addi	a1,a1,1
 47a:	0705                	addi	a4,a4,1
 47c:	fff5c683          	lbu	a3,-1(a1)
 480:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 484:	fee79ae3          	bne	a5,a4,478 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 488:	6422                	ld	s0,8(sp)
 48a:	0141                	addi	sp,sp,16
 48c:	8082                	ret
    dst += n;
 48e:	00c50733          	add	a4,a0,a2
    src += n;
 492:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 494:	fec05ae3          	blez	a2,488 <memmove+0x28>
 498:	fff6079b          	addiw	a5,a2,-1
 49c:	1782                	slli	a5,a5,0x20
 49e:	9381                	srli	a5,a5,0x20
 4a0:	fff7c793          	not	a5,a5
 4a4:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4a6:	15fd                	addi	a1,a1,-1
 4a8:	177d                	addi	a4,a4,-1
 4aa:	0005c683          	lbu	a3,0(a1)
 4ae:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4b2:	fee79ae3          	bne	a5,a4,4a6 <memmove+0x46>
 4b6:	bfc9                	j	488 <memmove+0x28>

00000000000004b8 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4b8:	1141                	addi	sp,sp,-16
 4ba:	e422                	sd	s0,8(sp)
 4bc:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4be:	ca05                	beqz	a2,4ee <memcmp+0x36>
 4c0:	fff6069b          	addiw	a3,a2,-1
 4c4:	1682                	slli	a3,a3,0x20
 4c6:	9281                	srli	a3,a3,0x20
 4c8:	0685                	addi	a3,a3,1
 4ca:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 4cc:	00054783          	lbu	a5,0(a0)
 4d0:	0005c703          	lbu	a4,0(a1)
 4d4:	00e79863          	bne	a5,a4,4e4 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 4d8:	0505                	addi	a0,a0,1
    p2++;
 4da:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4dc:	fed518e3          	bne	a0,a3,4cc <memcmp+0x14>
  }
  return 0;
 4e0:	4501                	li	a0,0
 4e2:	a019                	j	4e8 <memcmp+0x30>
      return *p1 - *p2;
 4e4:	40e7853b          	subw	a0,a5,a4
}
 4e8:	6422                	ld	s0,8(sp)
 4ea:	0141                	addi	sp,sp,16
 4ec:	8082                	ret
  return 0;
 4ee:	4501                	li	a0,0
 4f0:	bfe5                	j	4e8 <memcmp+0x30>

00000000000004f2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4f2:	1141                	addi	sp,sp,-16
 4f4:	e406                	sd	ra,8(sp)
 4f6:	e022                	sd	s0,0(sp)
 4f8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4fa:	00000097          	auipc	ra,0x0
 4fe:	f66080e7          	jalr	-154(ra) # 460 <memmove>
}
 502:	60a2                	ld	ra,8(sp)
 504:	6402                	ld	s0,0(sp)
 506:	0141                	addi	sp,sp,16
 508:	8082                	ret

000000000000050a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 50a:	4885                	li	a7,1
 ecall
 50c:	00000073          	ecall
 ret
 510:	8082                	ret

0000000000000512 <exit>:
.global exit
exit:
 li a7, SYS_exit
 512:	4889                	li	a7,2
 ecall
 514:	00000073          	ecall
 ret
 518:	8082                	ret

000000000000051a <wait>:
.global wait
wait:
 li a7, SYS_wait
 51a:	488d                	li	a7,3
 ecall
 51c:	00000073          	ecall
 ret
 520:	8082                	ret

0000000000000522 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 522:	4891                	li	a7,4
 ecall
 524:	00000073          	ecall
 ret
 528:	8082                	ret

000000000000052a <read>:
.global read
read:
 li a7, SYS_read
 52a:	4895                	li	a7,5
 ecall
 52c:	00000073          	ecall
 ret
 530:	8082                	ret

0000000000000532 <write>:
.global write
write:
 li a7, SYS_write
 532:	48c1                	li	a7,16
 ecall
 534:	00000073          	ecall
 ret
 538:	8082                	ret

000000000000053a <close>:
.global close
close:
 li a7, SYS_close
 53a:	48d5                	li	a7,21
 ecall
 53c:	00000073          	ecall
 ret
 540:	8082                	ret

0000000000000542 <kill>:
.global kill
kill:
 li a7, SYS_kill
 542:	4899                	li	a7,6
 ecall
 544:	00000073          	ecall
 ret
 548:	8082                	ret

000000000000054a <exec>:
.global exec
exec:
 li a7, SYS_exec
 54a:	489d                	li	a7,7
 ecall
 54c:	00000073          	ecall
 ret
 550:	8082                	ret

0000000000000552 <open>:
.global open
open:
 li a7, SYS_open
 552:	48bd                	li	a7,15
 ecall
 554:	00000073          	ecall
 ret
 558:	8082                	ret

000000000000055a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 55a:	48c5                	li	a7,17
 ecall
 55c:	00000073          	ecall
 ret
 560:	8082                	ret

0000000000000562 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 562:	48c9                	li	a7,18
 ecall
 564:	00000073          	ecall
 ret
 568:	8082                	ret

000000000000056a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 56a:	48a1                	li	a7,8
 ecall
 56c:	00000073          	ecall
 ret
 570:	8082                	ret

0000000000000572 <link>:
.global link
link:
 li a7, SYS_link
 572:	48cd                	li	a7,19
 ecall
 574:	00000073          	ecall
 ret
 578:	8082                	ret

000000000000057a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 57a:	48d1                	li	a7,20
 ecall
 57c:	00000073          	ecall
 ret
 580:	8082                	ret

0000000000000582 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 582:	48a5                	li	a7,9
 ecall
 584:	00000073          	ecall
 ret
 588:	8082                	ret

000000000000058a <dup>:
.global dup
dup:
 li a7, SYS_dup
 58a:	48a9                	li	a7,10
 ecall
 58c:	00000073          	ecall
 ret
 590:	8082                	ret

0000000000000592 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 592:	48ad                	li	a7,11
 ecall
 594:	00000073          	ecall
 ret
 598:	8082                	ret

000000000000059a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 59a:	48b1                	li	a7,12
 ecall
 59c:	00000073          	ecall
 ret
 5a0:	8082                	ret

00000000000005a2 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5a2:	48b5                	li	a7,13
 ecall
 5a4:	00000073          	ecall
 ret
 5a8:	8082                	ret

00000000000005aa <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5aa:	48b9                	li	a7,14
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
 5c8:	f6e080e7          	jalr	-146(ra) # 532 <write>
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
 5fa:	4ea50513          	addi	a0,a0,1258 # ae0 <digits>
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
 6ba:	3d2c8c93          	addi	s9,s9,978 # a88 <malloc+0x144>
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
 6c8:	41cb8b93          	addi	s7,s7,1052 # ae0 <digits>
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
 7ee:	29698993          	addi	s3,s3,662 # a80 <malloc+0x13c>
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
 8d0:	22c7b783          	ld	a5,556(a5) # af8 <freep>
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
 93a:	1cf73123          	sd	a5,450(a4) # af8 <freep>
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
 96c:	19053503          	ld	a0,400(a0) # af8 <freep>
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
 994:	16890913          	addi	s2,s2,360 # af8 <freep>
  if(p == (char*)-1)
 998:	5afd                	li	s5,-1
 99a:	a895                	j	a0e <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 99c:	00000797          	auipc	a5,0x0
 9a0:	16478793          	addi	a5,a5,356 # b00 <base>
 9a4:	00000717          	auipc	a4,0x0
 9a8:	14f73a23          	sd	a5,340(a4) # af8 <freep>
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
 9d0:	12a73623          	sd	a0,300(a4) # af8 <freep>
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
 a1e:	b80080e7          	jalr	-1152(ra) # 59a <sbrk>
  if(p == (char*)-1)
 a22:	fd5518e3          	bne	a0,s5,9f2 <malloc+0xae>
        return 0;
 a26:	4501                	li	a0,0
 a28:	bf45                	j	9d8 <malloc+0x94>
