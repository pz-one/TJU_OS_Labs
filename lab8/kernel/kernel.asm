
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	87013103          	ld	sp,-1936(sp) # 80008870 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	0fd050ef          	jal	ra,80005912 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00021797          	auipc	a5,0x21
    80000034:	21078793          	addi	a5,a5,528 # 80021240 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	132080e7          	jalr	306(ra) # 8000017a <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	fe090913          	addi	s2,s2,-32 # 80009030 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	29e080e7          	jalr	670(ra) # 800062f8 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	33e080e7          	jalr	830(ra) # 800063ac <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	d36080e7          	jalr	-714(ra) # 80005dc0 <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	00e504b3          	add	s1,a0,a4
    800000ac:	777d                	lui	a4,0xfffff
    800000ae:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b0:	94be                	add	s1,s1,a5
    800000b2:	0095ee63          	bltu	a1,s1,800000ce <freerange+0x3c>
    800000b6:	892e                	mv	s2,a1
    kfree(p);
    800000b8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ba:	6985                	lui	s3,0x1
    kfree(p);
    800000bc:	01448533          	add	a0,s1,s4
    800000c0:	00000097          	auipc	ra,0x0
    800000c4:	f5c080e7          	jalr	-164(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c8:	94ce                	add	s1,s1,s3
    800000ca:	fe9979e3          	bgeu	s2,s1,800000bc <freerange+0x2a>
}
    800000ce:	70a2                	ld	ra,40(sp)
    800000d0:	7402                	ld	s0,32(sp)
    800000d2:	64e2                	ld	s1,24(sp)
    800000d4:	6942                	ld	s2,16(sp)
    800000d6:	69a2                	ld	s3,8(sp)
    800000d8:	6a02                	ld	s4,0(sp)
    800000da:	6145                	addi	sp,sp,48
    800000dc:	8082                	ret

00000000800000de <kinit>:
{
    800000de:	1141                	addi	sp,sp,-16
    800000e0:	e406                	sd	ra,8(sp)
    800000e2:	e022                	sd	s0,0(sp)
    800000e4:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e6:	00008597          	auipc	a1,0x8
    800000ea:	f3258593          	addi	a1,a1,-206 # 80008018 <etext+0x18>
    800000ee:	00009517          	auipc	a0,0x9
    800000f2:	f4250513          	addi	a0,a0,-190 # 80009030 <kmem>
    800000f6:	00006097          	auipc	ra,0x6
    800000fa:	172080e7          	jalr	370(ra) # 80006268 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	slli	a1,a1,0x1b
    80000102:	00021517          	auipc	a0,0x21
    80000106:	13e50513          	addi	a0,a0,318 # 80021240 <end>
    8000010a:	00000097          	auipc	ra,0x0
    8000010e:	f88080e7          	jalr	-120(ra) # 80000092 <freerange>
}
    80000112:	60a2                	ld	ra,8(sp)
    80000114:	6402                	ld	s0,0(sp)
    80000116:	0141                	addi	sp,sp,16
    80000118:	8082                	ret

000000008000011a <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    8000011a:	1101                	addi	sp,sp,-32
    8000011c:	ec06                	sd	ra,24(sp)
    8000011e:	e822                	sd	s0,16(sp)
    80000120:	e426                	sd	s1,8(sp)
    80000122:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000124:	00009497          	auipc	s1,0x9
    80000128:	f0c48493          	addi	s1,s1,-244 # 80009030 <kmem>
    8000012c:	8526                	mv	a0,s1
    8000012e:	00006097          	auipc	ra,0x6
    80000132:	1ca080e7          	jalr	458(ra) # 800062f8 <acquire>
  r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
  if(r)
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
    kmem.freelist = r->next;
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	00009517          	auipc	a0,0x9
    80000140:	ef450513          	addi	a0,a0,-268 # 80009030 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000146:	00006097          	auipc	ra,0x6
    8000014a:	266080e7          	jalr	614(ra) # 800063ac <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014e:	6605                	lui	a2,0x1
    80000150:	4595                	li	a1,5
    80000152:	8526                	mv	a0,s1
    80000154:	00000097          	auipc	ra,0x0
    80000158:	026080e7          	jalr	38(ra) # 8000017a <memset>
  return (void*)r;
}
    8000015c:	8526                	mv	a0,s1
    8000015e:	60e2                	ld	ra,24(sp)
    80000160:	6442                	ld	s0,16(sp)
    80000162:	64a2                	ld	s1,8(sp)
    80000164:	6105                	addi	sp,sp,32
    80000166:	8082                	ret
  release(&kmem.lock);
    80000168:	00009517          	auipc	a0,0x9
    8000016c:	ec850513          	addi	a0,a0,-312 # 80009030 <kmem>
    80000170:	00006097          	auipc	ra,0x6
    80000174:	23c080e7          	jalr	572(ra) # 800063ac <release>
  if(r)
    80000178:	b7d5                	j	8000015c <kalloc+0x42>

000000008000017a <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000017a:	1141                	addi	sp,sp,-16
    8000017c:	e422                	sd	s0,8(sp)
    8000017e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000180:	ca19                	beqz	a2,80000196 <memset+0x1c>
    80000182:	87aa                	mv	a5,a0
    80000184:	1602                	slli	a2,a2,0x20
    80000186:	9201                	srli	a2,a2,0x20
    80000188:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    8000018c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000190:	0785                	addi	a5,a5,1
    80000192:	fee79de3          	bne	a5,a4,8000018c <memset+0x12>
  }
  return dst;
}
    80000196:	6422                	ld	s0,8(sp)
    80000198:	0141                	addi	sp,sp,16
    8000019a:	8082                	ret

000000008000019c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019c:	1141                	addi	sp,sp,-16
    8000019e:	e422                	sd	s0,8(sp)
    800001a0:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a2:	ca05                	beqz	a2,800001d2 <memcmp+0x36>
    800001a4:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800001a8:	1682                	slli	a3,a3,0x20
    800001aa:	9281                	srli	a3,a3,0x20
    800001ac:	0685                	addi	a3,a3,1
    800001ae:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b0:	00054783          	lbu	a5,0(a0)
    800001b4:	0005c703          	lbu	a4,0(a1)
    800001b8:	00e79863          	bne	a5,a4,800001c8 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001bc:	0505                	addi	a0,a0,1
    800001be:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001c0:	fed518e3          	bne	a0,a3,800001b0 <memcmp+0x14>
  }

  return 0;
    800001c4:	4501                	li	a0,0
    800001c6:	a019                	j	800001cc <memcmp+0x30>
      return *s1 - *s2;
    800001c8:	40e7853b          	subw	a0,a5,a4
}
    800001cc:	6422                	ld	s0,8(sp)
    800001ce:	0141                	addi	sp,sp,16
    800001d0:	8082                	ret
  return 0;
    800001d2:	4501                	li	a0,0
    800001d4:	bfe5                	j	800001cc <memcmp+0x30>

00000000800001d6 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d6:	1141                	addi	sp,sp,-16
    800001d8:	e422                	sd	s0,8(sp)
    800001da:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001dc:	c205                	beqz	a2,800001fc <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001de:	02a5e263          	bltu	a1,a0,80000202 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001e2:	1602                	slli	a2,a2,0x20
    800001e4:	9201                	srli	a2,a2,0x20
    800001e6:	00c587b3          	add	a5,a1,a2
{
    800001ea:	872a                	mv	a4,a0
      *d++ = *s++;
    800001ec:	0585                	addi	a1,a1,1
    800001ee:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdddc1>
    800001f0:	fff5c683          	lbu	a3,-1(a1)
    800001f4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001f8:	fef59ae3          	bne	a1,a5,800001ec <memmove+0x16>

  return dst;
}
    800001fc:	6422                	ld	s0,8(sp)
    800001fe:	0141                	addi	sp,sp,16
    80000200:	8082                	ret
  if(s < d && s + n > d){
    80000202:	02061693          	slli	a3,a2,0x20
    80000206:	9281                	srli	a3,a3,0x20
    80000208:	00d58733          	add	a4,a1,a3
    8000020c:	fce57be3          	bgeu	a0,a4,800001e2 <memmove+0xc>
    d += n;
    80000210:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000212:	fff6079b          	addiw	a5,a2,-1
    80000216:	1782                	slli	a5,a5,0x20
    80000218:	9381                	srli	a5,a5,0x20
    8000021a:	fff7c793          	not	a5,a5
    8000021e:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000220:	177d                	addi	a4,a4,-1
    80000222:	16fd                	addi	a3,a3,-1
    80000224:	00074603          	lbu	a2,0(a4)
    80000228:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000022c:	fee79ae3          	bne	a5,a4,80000220 <memmove+0x4a>
    80000230:	b7f1                	j	800001fc <memmove+0x26>

0000000080000232 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000232:	1141                	addi	sp,sp,-16
    80000234:	e406                	sd	ra,8(sp)
    80000236:	e022                	sd	s0,0(sp)
    80000238:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000023a:	00000097          	auipc	ra,0x0
    8000023e:	f9c080e7          	jalr	-100(ra) # 800001d6 <memmove>
}
    80000242:	60a2                	ld	ra,8(sp)
    80000244:	6402                	ld	s0,0(sp)
    80000246:	0141                	addi	sp,sp,16
    80000248:	8082                	ret

000000008000024a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000024a:	1141                	addi	sp,sp,-16
    8000024c:	e422                	sd	s0,8(sp)
    8000024e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000250:	ce11                	beqz	a2,8000026c <strncmp+0x22>
    80000252:	00054783          	lbu	a5,0(a0)
    80000256:	cf89                	beqz	a5,80000270 <strncmp+0x26>
    80000258:	0005c703          	lbu	a4,0(a1)
    8000025c:	00f71a63          	bne	a4,a5,80000270 <strncmp+0x26>
    n--, p++, q++;
    80000260:	367d                	addiw	a2,a2,-1
    80000262:	0505                	addi	a0,a0,1
    80000264:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000266:	f675                	bnez	a2,80000252 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000268:	4501                	li	a0,0
    8000026a:	a809                	j	8000027c <strncmp+0x32>
    8000026c:	4501                	li	a0,0
    8000026e:	a039                	j	8000027c <strncmp+0x32>
  if(n == 0)
    80000270:	ca09                	beqz	a2,80000282 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000272:	00054503          	lbu	a0,0(a0)
    80000276:	0005c783          	lbu	a5,0(a1)
    8000027a:	9d1d                	subw	a0,a0,a5
}
    8000027c:	6422                	ld	s0,8(sp)
    8000027e:	0141                	addi	sp,sp,16
    80000280:	8082                	ret
    return 0;
    80000282:	4501                	li	a0,0
    80000284:	bfe5                	j	8000027c <strncmp+0x32>

0000000080000286 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000286:	1141                	addi	sp,sp,-16
    80000288:	e422                	sd	s0,8(sp)
    8000028a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    8000028c:	872a                	mv	a4,a0
    8000028e:	8832                	mv	a6,a2
    80000290:	367d                	addiw	a2,a2,-1
    80000292:	01005963          	blez	a6,800002a4 <strncpy+0x1e>
    80000296:	0705                	addi	a4,a4,1
    80000298:	0005c783          	lbu	a5,0(a1)
    8000029c:	fef70fa3          	sb	a5,-1(a4)
    800002a0:	0585                	addi	a1,a1,1
    800002a2:	f7f5                	bnez	a5,8000028e <strncpy+0x8>
    ;
  while(n-- > 0)
    800002a4:	86ba                	mv	a3,a4
    800002a6:	00c05c63          	blez	a2,800002be <strncpy+0x38>
    *s++ = 0;
    800002aa:	0685                	addi	a3,a3,1
    800002ac:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002b0:	40d707bb          	subw	a5,a4,a3
    800002b4:	37fd                	addiw	a5,a5,-1
    800002b6:	010787bb          	addw	a5,a5,a6
    800002ba:	fef048e3          	bgtz	a5,800002aa <strncpy+0x24>
  return os;
}
    800002be:	6422                	ld	s0,8(sp)
    800002c0:	0141                	addi	sp,sp,16
    800002c2:	8082                	ret

00000000800002c4 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002c4:	1141                	addi	sp,sp,-16
    800002c6:	e422                	sd	s0,8(sp)
    800002c8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002ca:	02c05363          	blez	a2,800002f0 <safestrcpy+0x2c>
    800002ce:	fff6069b          	addiw	a3,a2,-1
    800002d2:	1682                	slli	a3,a3,0x20
    800002d4:	9281                	srli	a3,a3,0x20
    800002d6:	96ae                	add	a3,a3,a1
    800002d8:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002da:	00d58963          	beq	a1,a3,800002ec <safestrcpy+0x28>
    800002de:	0585                	addi	a1,a1,1
    800002e0:	0785                	addi	a5,a5,1
    800002e2:	fff5c703          	lbu	a4,-1(a1)
    800002e6:	fee78fa3          	sb	a4,-1(a5)
    800002ea:	fb65                	bnez	a4,800002da <safestrcpy+0x16>
    ;
  *s = 0;
    800002ec:	00078023          	sb	zero,0(a5)
  return os;
}
    800002f0:	6422                	ld	s0,8(sp)
    800002f2:	0141                	addi	sp,sp,16
    800002f4:	8082                	ret

00000000800002f6 <strlen>:

int
strlen(const char *s)
{
    800002f6:	1141                	addi	sp,sp,-16
    800002f8:	e422                	sd	s0,8(sp)
    800002fa:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002fc:	00054783          	lbu	a5,0(a0)
    80000300:	cf91                	beqz	a5,8000031c <strlen+0x26>
    80000302:	0505                	addi	a0,a0,1
    80000304:	87aa                	mv	a5,a0
    80000306:	4685                	li	a3,1
    80000308:	9e89                	subw	a3,a3,a0
    8000030a:	00f6853b          	addw	a0,a3,a5
    8000030e:	0785                	addi	a5,a5,1
    80000310:	fff7c703          	lbu	a4,-1(a5)
    80000314:	fb7d                	bnez	a4,8000030a <strlen+0x14>
    ;
  return n;
}
    80000316:	6422                	ld	s0,8(sp)
    80000318:	0141                	addi	sp,sp,16
    8000031a:	8082                	ret
  for(n = 0; s[n]; n++)
    8000031c:	4501                	li	a0,0
    8000031e:	bfe5                	j	80000316 <strlen+0x20>

0000000080000320 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000320:	1141                	addi	sp,sp,-16
    80000322:	e406                	sd	ra,8(sp)
    80000324:	e022                	sd	s0,0(sp)
    80000326:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000328:	00001097          	auipc	ra,0x1
    8000032c:	af0080e7          	jalr	-1296(ra) # 80000e18 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000330:	00009717          	auipc	a4,0x9
    80000334:	cd070713          	addi	a4,a4,-816 # 80009000 <started>
  if(cpuid() == 0){
    80000338:	c139                	beqz	a0,8000037e <main+0x5e>
    while(started == 0)
    8000033a:	431c                	lw	a5,0(a4)
    8000033c:	2781                	sext.w	a5,a5
    8000033e:	dff5                	beqz	a5,8000033a <main+0x1a>
      ;
    __sync_synchronize();
    80000340:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000344:	00001097          	auipc	ra,0x1
    80000348:	ad4080e7          	jalr	-1324(ra) # 80000e18 <cpuid>
    8000034c:	85aa                	mv	a1,a0
    8000034e:	00008517          	auipc	a0,0x8
    80000352:	cea50513          	addi	a0,a0,-790 # 80008038 <etext+0x38>
    80000356:	00006097          	auipc	ra,0x6
    8000035a:	ab4080e7          	jalr	-1356(ra) # 80005e0a <printf>
    kvminithart();    // turn on paging
    8000035e:	00000097          	auipc	ra,0x0
    80000362:	0d8080e7          	jalr	216(ra) # 80000436 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000366:	00001097          	auipc	ra,0x1
    8000036a:	734080e7          	jalr	1844(ra) # 80001a9a <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000036e:	00005097          	auipc	ra,0x5
    80000372:	f82080e7          	jalr	-126(ra) # 800052f0 <plicinithart>
  }

  scheduler();        
    80000376:	00001097          	auipc	ra,0x1
    8000037a:	fe0080e7          	jalr	-32(ra) # 80001356 <scheduler>
    consoleinit();
    8000037e:	00006097          	auipc	ra,0x6
    80000382:	952080e7          	jalr	-1710(ra) # 80005cd0 <consoleinit>
    printfinit();
    80000386:	00006097          	auipc	ra,0x6
    8000038a:	c64080e7          	jalr	-924(ra) # 80005fea <printfinit>
    printf("\n");
    8000038e:	00008517          	auipc	a0,0x8
    80000392:	cba50513          	addi	a0,a0,-838 # 80008048 <etext+0x48>
    80000396:	00006097          	auipc	ra,0x6
    8000039a:	a74080e7          	jalr	-1420(ra) # 80005e0a <printf>
    printf("xv6 kernel is booting\n");
    8000039e:	00008517          	auipc	a0,0x8
    800003a2:	c8250513          	addi	a0,a0,-894 # 80008020 <etext+0x20>
    800003a6:	00006097          	auipc	ra,0x6
    800003aa:	a64080e7          	jalr	-1436(ra) # 80005e0a <printf>
    printf("\n");
    800003ae:	00008517          	auipc	a0,0x8
    800003b2:	c9a50513          	addi	a0,a0,-870 # 80008048 <etext+0x48>
    800003b6:	00006097          	auipc	ra,0x6
    800003ba:	a54080e7          	jalr	-1452(ra) # 80005e0a <printf>
    kinit();         // physical page allocator
    800003be:	00000097          	auipc	ra,0x0
    800003c2:	d20080e7          	jalr	-736(ra) # 800000de <kinit>
    kvminit();       // create kernel page table
    800003c6:	00000097          	auipc	ra,0x0
    800003ca:	322080e7          	jalr	802(ra) # 800006e8 <kvminit>
    kvminithart();   // turn on paging
    800003ce:	00000097          	auipc	ra,0x0
    800003d2:	068080e7          	jalr	104(ra) # 80000436 <kvminithart>
    procinit();      // process table
    800003d6:	00001097          	auipc	ra,0x1
    800003da:	992080e7          	jalr	-1646(ra) # 80000d68 <procinit>
    trapinit();      // trap vectors
    800003de:	00001097          	auipc	ra,0x1
    800003e2:	694080e7          	jalr	1684(ra) # 80001a72 <trapinit>
    trapinithart();  // install kernel trap vector
    800003e6:	00001097          	auipc	ra,0x1
    800003ea:	6b4080e7          	jalr	1716(ra) # 80001a9a <trapinithart>
    plicinit();      // set up interrupt controller
    800003ee:	00005097          	auipc	ra,0x5
    800003f2:	eec080e7          	jalr	-276(ra) # 800052da <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003f6:	00005097          	auipc	ra,0x5
    800003fa:	efa080e7          	jalr	-262(ra) # 800052f0 <plicinithart>
    binit();         // buffer cache
    800003fe:	00002097          	auipc	ra,0x2
    80000402:	dde080e7          	jalr	-546(ra) # 800021dc <binit>
    iinit();         // inode table
    80000406:	00002097          	auipc	ra,0x2
    8000040a:	534080e7          	jalr	1332(ra) # 8000293a <iinit>
    fileinit();      // file table
    8000040e:	00003097          	auipc	ra,0x3
    80000412:	592080e7          	jalr	1426(ra) # 800039a0 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000416:	00005097          	auipc	ra,0x5
    8000041a:	ffa080e7          	jalr	-6(ra) # 80005410 <virtio_disk_init>
    userinit();      // first user process
    8000041e:	00001097          	auipc	ra,0x1
    80000422:	cfe080e7          	jalr	-770(ra) # 8000111c <userinit>
    __sync_synchronize();
    80000426:	0ff0000f          	fence
    started = 1;
    8000042a:	4785                	li	a5,1
    8000042c:	00009717          	auipc	a4,0x9
    80000430:	bcf72a23          	sw	a5,-1068(a4) # 80009000 <started>
    80000434:	b789                	j	80000376 <main+0x56>

0000000080000436 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000436:	1141                	addi	sp,sp,-16
    80000438:	e422                	sd	s0,8(sp)
    8000043a:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    8000043c:	00009797          	auipc	a5,0x9
    80000440:	bcc7b783          	ld	a5,-1076(a5) # 80009008 <kernel_pagetable>
    80000444:	83b1                	srli	a5,a5,0xc
    80000446:	577d                	li	a4,-1
    80000448:	177e                	slli	a4,a4,0x3f
    8000044a:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    8000044c:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000450:	12000073          	sfence.vma
  sfence_vma();
}
    80000454:	6422                	ld	s0,8(sp)
    80000456:	0141                	addi	sp,sp,16
    80000458:	8082                	ret

000000008000045a <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000045a:	7139                	addi	sp,sp,-64
    8000045c:	fc06                	sd	ra,56(sp)
    8000045e:	f822                	sd	s0,48(sp)
    80000460:	f426                	sd	s1,40(sp)
    80000462:	f04a                	sd	s2,32(sp)
    80000464:	ec4e                	sd	s3,24(sp)
    80000466:	e852                	sd	s4,16(sp)
    80000468:	e456                	sd	s5,8(sp)
    8000046a:	e05a                	sd	s6,0(sp)
    8000046c:	0080                	addi	s0,sp,64
    8000046e:	84aa                	mv	s1,a0
    80000470:	89ae                	mv	s3,a1
    80000472:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000474:	57fd                	li	a5,-1
    80000476:	83e9                	srli	a5,a5,0x1a
    80000478:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000047a:	4b31                	li	s6,12
  if(va >= MAXVA)
    8000047c:	04b7f263          	bgeu	a5,a1,800004c0 <walk+0x66>
    panic("walk");
    80000480:	00008517          	auipc	a0,0x8
    80000484:	bd050513          	addi	a0,a0,-1072 # 80008050 <etext+0x50>
    80000488:	00006097          	auipc	ra,0x6
    8000048c:	938080e7          	jalr	-1736(ra) # 80005dc0 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000490:	060a8663          	beqz	s5,800004fc <walk+0xa2>
    80000494:	00000097          	auipc	ra,0x0
    80000498:	c86080e7          	jalr	-890(ra) # 8000011a <kalloc>
    8000049c:	84aa                	mv	s1,a0
    8000049e:	c529                	beqz	a0,800004e8 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004a0:	6605                	lui	a2,0x1
    800004a2:	4581                	li	a1,0
    800004a4:	00000097          	auipc	ra,0x0
    800004a8:	cd6080e7          	jalr	-810(ra) # 8000017a <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004ac:	00c4d793          	srli	a5,s1,0xc
    800004b0:	07aa                	slli	a5,a5,0xa
    800004b2:	0017e793          	ori	a5,a5,1
    800004b6:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004ba:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdddb7>
    800004bc:	036a0063          	beq	s4,s6,800004dc <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004c0:	0149d933          	srl	s2,s3,s4
    800004c4:	1ff97913          	andi	s2,s2,511
    800004c8:	090e                	slli	s2,s2,0x3
    800004ca:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004cc:	00093483          	ld	s1,0(s2)
    800004d0:	0014f793          	andi	a5,s1,1
    800004d4:	dfd5                	beqz	a5,80000490 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004d6:	80a9                	srli	s1,s1,0xa
    800004d8:	04b2                	slli	s1,s1,0xc
    800004da:	b7c5                	j	800004ba <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004dc:	00c9d513          	srli	a0,s3,0xc
    800004e0:	1ff57513          	andi	a0,a0,511
    800004e4:	050e                	slli	a0,a0,0x3
    800004e6:	9526                	add	a0,a0,s1
}
    800004e8:	70e2                	ld	ra,56(sp)
    800004ea:	7442                	ld	s0,48(sp)
    800004ec:	74a2                	ld	s1,40(sp)
    800004ee:	7902                	ld	s2,32(sp)
    800004f0:	69e2                	ld	s3,24(sp)
    800004f2:	6a42                	ld	s4,16(sp)
    800004f4:	6aa2                	ld	s5,8(sp)
    800004f6:	6b02                	ld	s6,0(sp)
    800004f8:	6121                	addi	sp,sp,64
    800004fa:	8082                	ret
        return 0;
    800004fc:	4501                	li	a0,0
    800004fe:	b7ed                	j	800004e8 <walk+0x8e>

0000000080000500 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000500:	57fd                	li	a5,-1
    80000502:	83e9                	srli	a5,a5,0x1a
    80000504:	00b7f463          	bgeu	a5,a1,8000050c <walkaddr+0xc>
    return 0;
    80000508:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000050a:	8082                	ret
{
    8000050c:	1141                	addi	sp,sp,-16
    8000050e:	e406                	sd	ra,8(sp)
    80000510:	e022                	sd	s0,0(sp)
    80000512:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000514:	4601                	li	a2,0
    80000516:	00000097          	auipc	ra,0x0
    8000051a:	f44080e7          	jalr	-188(ra) # 8000045a <walk>
  if(pte == 0)
    8000051e:	c105                	beqz	a0,8000053e <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000520:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000522:	0117f693          	andi	a3,a5,17
    80000526:	4745                	li	a4,17
    return 0;
    80000528:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000052a:	00e68663          	beq	a3,a4,80000536 <walkaddr+0x36>
}
    8000052e:	60a2                	ld	ra,8(sp)
    80000530:	6402                	ld	s0,0(sp)
    80000532:	0141                	addi	sp,sp,16
    80000534:	8082                	ret
  pa = PTE2PA(*pte);
    80000536:	83a9                	srli	a5,a5,0xa
    80000538:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000053c:	bfcd                	j	8000052e <walkaddr+0x2e>
    return 0;
    8000053e:	4501                	li	a0,0
    80000540:	b7fd                	j	8000052e <walkaddr+0x2e>

0000000080000542 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000542:	715d                	addi	sp,sp,-80
    80000544:	e486                	sd	ra,72(sp)
    80000546:	e0a2                	sd	s0,64(sp)
    80000548:	fc26                	sd	s1,56(sp)
    8000054a:	f84a                	sd	s2,48(sp)
    8000054c:	f44e                	sd	s3,40(sp)
    8000054e:	f052                	sd	s4,32(sp)
    80000550:	ec56                	sd	s5,24(sp)
    80000552:	e85a                	sd	s6,16(sp)
    80000554:	e45e                	sd	s7,8(sp)
    80000556:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80000558:	c639                	beqz	a2,800005a6 <mappages+0x64>
    8000055a:	8aaa                	mv	s5,a0
    8000055c:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    8000055e:	777d                	lui	a4,0xfffff
    80000560:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80000564:	fff58993          	addi	s3,a1,-1
    80000568:	99b2                	add	s3,s3,a2
    8000056a:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    8000056e:	893e                	mv	s2,a5
    80000570:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000574:	6b85                	lui	s7,0x1
    80000576:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    8000057a:	4605                	li	a2,1
    8000057c:	85ca                	mv	a1,s2
    8000057e:	8556                	mv	a0,s5
    80000580:	00000097          	auipc	ra,0x0
    80000584:	eda080e7          	jalr	-294(ra) # 8000045a <walk>
    80000588:	cd1d                	beqz	a0,800005c6 <mappages+0x84>
    if(*pte & PTE_V)
    8000058a:	611c                	ld	a5,0(a0)
    8000058c:	8b85                	andi	a5,a5,1
    8000058e:	e785                	bnez	a5,800005b6 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000590:	80b1                	srli	s1,s1,0xc
    80000592:	04aa                	slli	s1,s1,0xa
    80000594:	0164e4b3          	or	s1,s1,s6
    80000598:	0014e493          	ori	s1,s1,1
    8000059c:	e104                	sd	s1,0(a0)
    if(a == last)
    8000059e:	05390063          	beq	s2,s3,800005de <mappages+0x9c>
    a += PGSIZE;
    800005a2:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005a4:	bfc9                	j	80000576 <mappages+0x34>
    panic("mappages: size");
    800005a6:	00008517          	auipc	a0,0x8
    800005aa:	ab250513          	addi	a0,a0,-1358 # 80008058 <etext+0x58>
    800005ae:	00006097          	auipc	ra,0x6
    800005b2:	812080e7          	jalr	-2030(ra) # 80005dc0 <panic>
      panic("mappages: remap");
    800005b6:	00008517          	auipc	a0,0x8
    800005ba:	ab250513          	addi	a0,a0,-1358 # 80008068 <etext+0x68>
    800005be:	00006097          	auipc	ra,0x6
    800005c2:	802080e7          	jalr	-2046(ra) # 80005dc0 <panic>
      return -1;
    800005c6:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800005c8:	60a6                	ld	ra,72(sp)
    800005ca:	6406                	ld	s0,64(sp)
    800005cc:	74e2                	ld	s1,56(sp)
    800005ce:	7942                	ld	s2,48(sp)
    800005d0:	79a2                	ld	s3,40(sp)
    800005d2:	7a02                	ld	s4,32(sp)
    800005d4:	6ae2                	ld	s5,24(sp)
    800005d6:	6b42                	ld	s6,16(sp)
    800005d8:	6ba2                	ld	s7,8(sp)
    800005da:	6161                	addi	sp,sp,80
    800005dc:	8082                	ret
  return 0;
    800005de:	4501                	li	a0,0
    800005e0:	b7e5                	j	800005c8 <mappages+0x86>

00000000800005e2 <kvmmap>:
{
    800005e2:	1141                	addi	sp,sp,-16
    800005e4:	e406                	sd	ra,8(sp)
    800005e6:	e022                	sd	s0,0(sp)
    800005e8:	0800                	addi	s0,sp,16
    800005ea:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005ec:	86b2                	mv	a3,a2
    800005ee:	863e                	mv	a2,a5
    800005f0:	00000097          	auipc	ra,0x0
    800005f4:	f52080e7          	jalr	-174(ra) # 80000542 <mappages>
    800005f8:	e509                	bnez	a0,80000602 <kvmmap+0x20>
}
    800005fa:	60a2                	ld	ra,8(sp)
    800005fc:	6402                	ld	s0,0(sp)
    800005fe:	0141                	addi	sp,sp,16
    80000600:	8082                	ret
    panic("kvmmap");
    80000602:	00008517          	auipc	a0,0x8
    80000606:	a7650513          	addi	a0,a0,-1418 # 80008078 <etext+0x78>
    8000060a:	00005097          	auipc	ra,0x5
    8000060e:	7b6080e7          	jalr	1974(ra) # 80005dc0 <panic>

0000000080000612 <kvmmake>:
{
    80000612:	1101                	addi	sp,sp,-32
    80000614:	ec06                	sd	ra,24(sp)
    80000616:	e822                	sd	s0,16(sp)
    80000618:	e426                	sd	s1,8(sp)
    8000061a:	e04a                	sd	s2,0(sp)
    8000061c:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000061e:	00000097          	auipc	ra,0x0
    80000622:	afc080e7          	jalr	-1284(ra) # 8000011a <kalloc>
    80000626:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000628:	6605                	lui	a2,0x1
    8000062a:	4581                	li	a1,0
    8000062c:	00000097          	auipc	ra,0x0
    80000630:	b4e080e7          	jalr	-1202(ra) # 8000017a <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000634:	4719                	li	a4,6
    80000636:	6685                	lui	a3,0x1
    80000638:	10000637          	lui	a2,0x10000
    8000063c:	100005b7          	lui	a1,0x10000
    80000640:	8526                	mv	a0,s1
    80000642:	00000097          	auipc	ra,0x0
    80000646:	fa0080e7          	jalr	-96(ra) # 800005e2 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000064a:	4719                	li	a4,6
    8000064c:	6685                	lui	a3,0x1
    8000064e:	10001637          	lui	a2,0x10001
    80000652:	100015b7          	lui	a1,0x10001
    80000656:	8526                	mv	a0,s1
    80000658:	00000097          	auipc	ra,0x0
    8000065c:	f8a080e7          	jalr	-118(ra) # 800005e2 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000660:	4719                	li	a4,6
    80000662:	004006b7          	lui	a3,0x400
    80000666:	0c000637          	lui	a2,0xc000
    8000066a:	0c0005b7          	lui	a1,0xc000
    8000066e:	8526                	mv	a0,s1
    80000670:	00000097          	auipc	ra,0x0
    80000674:	f72080e7          	jalr	-142(ra) # 800005e2 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80000678:	00008917          	auipc	s2,0x8
    8000067c:	98890913          	addi	s2,s2,-1656 # 80008000 <etext>
    80000680:	4729                	li	a4,10
    80000682:	80008697          	auipc	a3,0x80008
    80000686:	97e68693          	addi	a3,a3,-1666 # 8000 <_entry-0x7fff8000>
    8000068a:	4605                	li	a2,1
    8000068c:	067e                	slli	a2,a2,0x1f
    8000068e:	85b2                	mv	a1,a2
    80000690:	8526                	mv	a0,s1
    80000692:	00000097          	auipc	ra,0x0
    80000696:	f50080e7          	jalr	-176(ra) # 800005e2 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000069a:	4719                	li	a4,6
    8000069c:	46c5                	li	a3,17
    8000069e:	06ee                	slli	a3,a3,0x1b
    800006a0:	412686b3          	sub	a3,a3,s2
    800006a4:	864a                	mv	a2,s2
    800006a6:	85ca                	mv	a1,s2
    800006a8:	8526                	mv	a0,s1
    800006aa:	00000097          	auipc	ra,0x0
    800006ae:	f38080e7          	jalr	-200(ra) # 800005e2 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006b2:	4729                	li	a4,10
    800006b4:	6685                	lui	a3,0x1
    800006b6:	00007617          	auipc	a2,0x7
    800006ba:	94a60613          	addi	a2,a2,-1718 # 80007000 <_trampoline>
    800006be:	040005b7          	lui	a1,0x4000
    800006c2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800006c4:	05b2                	slli	a1,a1,0xc
    800006c6:	8526                	mv	a0,s1
    800006c8:	00000097          	auipc	ra,0x0
    800006cc:	f1a080e7          	jalr	-230(ra) # 800005e2 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006d0:	8526                	mv	a0,s1
    800006d2:	00000097          	auipc	ra,0x0
    800006d6:	600080e7          	jalr	1536(ra) # 80000cd2 <proc_mapstacks>
}
    800006da:	8526                	mv	a0,s1
    800006dc:	60e2                	ld	ra,24(sp)
    800006de:	6442                	ld	s0,16(sp)
    800006e0:	64a2                	ld	s1,8(sp)
    800006e2:	6902                	ld	s2,0(sp)
    800006e4:	6105                	addi	sp,sp,32
    800006e6:	8082                	ret

00000000800006e8 <kvminit>:
{
    800006e8:	1141                	addi	sp,sp,-16
    800006ea:	e406                	sd	ra,8(sp)
    800006ec:	e022                	sd	s0,0(sp)
    800006ee:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800006f0:	00000097          	auipc	ra,0x0
    800006f4:	f22080e7          	jalr	-222(ra) # 80000612 <kvmmake>
    800006f8:	00009797          	auipc	a5,0x9
    800006fc:	90a7b823          	sd	a0,-1776(a5) # 80009008 <kernel_pagetable>
}
    80000700:	60a2                	ld	ra,8(sp)
    80000702:	6402                	ld	s0,0(sp)
    80000704:	0141                	addi	sp,sp,16
    80000706:	8082                	ret

0000000080000708 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000708:	715d                	addi	sp,sp,-80
    8000070a:	e486                	sd	ra,72(sp)
    8000070c:	e0a2                	sd	s0,64(sp)
    8000070e:	fc26                	sd	s1,56(sp)
    80000710:	f84a                	sd	s2,48(sp)
    80000712:	f44e                	sd	s3,40(sp)
    80000714:	f052                	sd	s4,32(sp)
    80000716:	ec56                	sd	s5,24(sp)
    80000718:	e85a                	sd	s6,16(sp)
    8000071a:	e45e                	sd	s7,8(sp)
    8000071c:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000071e:	03459793          	slli	a5,a1,0x34
    80000722:	e795                	bnez	a5,8000074e <uvmunmap+0x46>
    80000724:	8a2a                	mv	s4,a0
    80000726:	892e                	mv	s2,a1
    80000728:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000072a:	0632                	slli	a2,a2,0xc
    8000072c:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000730:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000732:	6b05                	lui	s6,0x1
    80000734:	0735e263          	bltu	a1,s3,80000798 <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000738:	60a6                	ld	ra,72(sp)
    8000073a:	6406                	ld	s0,64(sp)
    8000073c:	74e2                	ld	s1,56(sp)
    8000073e:	7942                	ld	s2,48(sp)
    80000740:	79a2                	ld	s3,40(sp)
    80000742:	7a02                	ld	s4,32(sp)
    80000744:	6ae2                	ld	s5,24(sp)
    80000746:	6b42                	ld	s6,16(sp)
    80000748:	6ba2                	ld	s7,8(sp)
    8000074a:	6161                	addi	sp,sp,80
    8000074c:	8082                	ret
    panic("uvmunmap: not aligned");
    8000074e:	00008517          	auipc	a0,0x8
    80000752:	93250513          	addi	a0,a0,-1742 # 80008080 <etext+0x80>
    80000756:	00005097          	auipc	ra,0x5
    8000075a:	66a080e7          	jalr	1642(ra) # 80005dc0 <panic>
      panic("uvmunmap: walk");
    8000075e:	00008517          	auipc	a0,0x8
    80000762:	93a50513          	addi	a0,a0,-1734 # 80008098 <etext+0x98>
    80000766:	00005097          	auipc	ra,0x5
    8000076a:	65a080e7          	jalr	1626(ra) # 80005dc0 <panic>
      panic("uvmunmap: not mapped");
    8000076e:	00008517          	auipc	a0,0x8
    80000772:	93a50513          	addi	a0,a0,-1734 # 800080a8 <etext+0xa8>
    80000776:	00005097          	auipc	ra,0x5
    8000077a:	64a080e7          	jalr	1610(ra) # 80005dc0 <panic>
      panic("uvmunmap: not a leaf");
    8000077e:	00008517          	auipc	a0,0x8
    80000782:	94250513          	addi	a0,a0,-1726 # 800080c0 <etext+0xc0>
    80000786:	00005097          	auipc	ra,0x5
    8000078a:	63a080e7          	jalr	1594(ra) # 80005dc0 <panic>
    *pte = 0;
    8000078e:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000792:	995a                	add	s2,s2,s6
    80000794:	fb3972e3          	bgeu	s2,s3,80000738 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    80000798:	4601                	li	a2,0
    8000079a:	85ca                	mv	a1,s2
    8000079c:	8552                	mv	a0,s4
    8000079e:	00000097          	auipc	ra,0x0
    800007a2:	cbc080e7          	jalr	-836(ra) # 8000045a <walk>
    800007a6:	84aa                	mv	s1,a0
    800007a8:	d95d                	beqz	a0,8000075e <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007aa:	6108                	ld	a0,0(a0)
    800007ac:	00157793          	andi	a5,a0,1
    800007b0:	dfdd                	beqz	a5,8000076e <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007b2:	3ff57793          	andi	a5,a0,1023
    800007b6:	fd7784e3          	beq	a5,s7,8000077e <uvmunmap+0x76>
    if(do_free){
    800007ba:	fc0a8ae3          	beqz	s5,8000078e <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    800007be:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007c0:	0532                	slli	a0,a0,0xc
    800007c2:	00000097          	auipc	ra,0x0
    800007c6:	85a080e7          	jalr	-1958(ra) # 8000001c <kfree>
    800007ca:	b7d1                	j	8000078e <uvmunmap+0x86>

00000000800007cc <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007cc:	1101                	addi	sp,sp,-32
    800007ce:	ec06                	sd	ra,24(sp)
    800007d0:	e822                	sd	s0,16(sp)
    800007d2:	e426                	sd	s1,8(sp)
    800007d4:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007d6:	00000097          	auipc	ra,0x0
    800007da:	944080e7          	jalr	-1724(ra) # 8000011a <kalloc>
    800007de:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007e0:	c519                	beqz	a0,800007ee <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007e2:	6605                	lui	a2,0x1
    800007e4:	4581                	li	a1,0
    800007e6:	00000097          	auipc	ra,0x0
    800007ea:	994080e7          	jalr	-1644(ra) # 8000017a <memset>
  return pagetable;
}
    800007ee:	8526                	mv	a0,s1
    800007f0:	60e2                	ld	ra,24(sp)
    800007f2:	6442                	ld	s0,16(sp)
    800007f4:	64a2                	ld	s1,8(sp)
    800007f6:	6105                	addi	sp,sp,32
    800007f8:	8082                	ret

00000000800007fa <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    800007fa:	7179                	addi	sp,sp,-48
    800007fc:	f406                	sd	ra,40(sp)
    800007fe:	f022                	sd	s0,32(sp)
    80000800:	ec26                	sd	s1,24(sp)
    80000802:	e84a                	sd	s2,16(sp)
    80000804:	e44e                	sd	s3,8(sp)
    80000806:	e052                	sd	s4,0(sp)
    80000808:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000080a:	6785                	lui	a5,0x1
    8000080c:	04f67863          	bgeu	a2,a5,8000085c <uvminit+0x62>
    80000810:	8a2a                	mv	s4,a0
    80000812:	89ae                	mv	s3,a1
    80000814:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80000816:	00000097          	auipc	ra,0x0
    8000081a:	904080e7          	jalr	-1788(ra) # 8000011a <kalloc>
    8000081e:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000820:	6605                	lui	a2,0x1
    80000822:	4581                	li	a1,0
    80000824:	00000097          	auipc	ra,0x0
    80000828:	956080e7          	jalr	-1706(ra) # 8000017a <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000082c:	4779                	li	a4,30
    8000082e:	86ca                	mv	a3,s2
    80000830:	6605                	lui	a2,0x1
    80000832:	4581                	li	a1,0
    80000834:	8552                	mv	a0,s4
    80000836:	00000097          	auipc	ra,0x0
    8000083a:	d0c080e7          	jalr	-756(ra) # 80000542 <mappages>
  memmove(mem, src, sz);
    8000083e:	8626                	mv	a2,s1
    80000840:	85ce                	mv	a1,s3
    80000842:	854a                	mv	a0,s2
    80000844:	00000097          	auipc	ra,0x0
    80000848:	992080e7          	jalr	-1646(ra) # 800001d6 <memmove>
}
    8000084c:	70a2                	ld	ra,40(sp)
    8000084e:	7402                	ld	s0,32(sp)
    80000850:	64e2                	ld	s1,24(sp)
    80000852:	6942                	ld	s2,16(sp)
    80000854:	69a2                	ld	s3,8(sp)
    80000856:	6a02                	ld	s4,0(sp)
    80000858:	6145                	addi	sp,sp,48
    8000085a:	8082                	ret
    panic("inituvm: more than a page");
    8000085c:	00008517          	auipc	a0,0x8
    80000860:	87c50513          	addi	a0,a0,-1924 # 800080d8 <etext+0xd8>
    80000864:	00005097          	auipc	ra,0x5
    80000868:	55c080e7          	jalr	1372(ra) # 80005dc0 <panic>

000000008000086c <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000086c:	1101                	addi	sp,sp,-32
    8000086e:	ec06                	sd	ra,24(sp)
    80000870:	e822                	sd	s0,16(sp)
    80000872:	e426                	sd	s1,8(sp)
    80000874:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000876:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000878:	00b67d63          	bgeu	a2,a1,80000892 <uvmdealloc+0x26>
    8000087c:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    8000087e:	6785                	lui	a5,0x1
    80000880:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000882:	00f60733          	add	a4,a2,a5
    80000886:	76fd                	lui	a3,0xfffff
    80000888:	8f75                	and	a4,a4,a3
    8000088a:	97ae                	add	a5,a5,a1
    8000088c:	8ff5                	and	a5,a5,a3
    8000088e:	00f76863          	bltu	a4,a5,8000089e <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000892:	8526                	mv	a0,s1
    80000894:	60e2                	ld	ra,24(sp)
    80000896:	6442                	ld	s0,16(sp)
    80000898:	64a2                	ld	s1,8(sp)
    8000089a:	6105                	addi	sp,sp,32
    8000089c:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000089e:	8f99                	sub	a5,a5,a4
    800008a0:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008a2:	4685                	li	a3,1
    800008a4:	0007861b          	sext.w	a2,a5
    800008a8:	85ba                	mv	a1,a4
    800008aa:	00000097          	auipc	ra,0x0
    800008ae:	e5e080e7          	jalr	-418(ra) # 80000708 <uvmunmap>
    800008b2:	b7c5                	j	80000892 <uvmdealloc+0x26>

00000000800008b4 <uvmalloc>:
  if(newsz < oldsz)
    800008b4:	0ab66163          	bltu	a2,a1,80000956 <uvmalloc+0xa2>
{
    800008b8:	7139                	addi	sp,sp,-64
    800008ba:	fc06                	sd	ra,56(sp)
    800008bc:	f822                	sd	s0,48(sp)
    800008be:	f426                	sd	s1,40(sp)
    800008c0:	f04a                	sd	s2,32(sp)
    800008c2:	ec4e                	sd	s3,24(sp)
    800008c4:	e852                	sd	s4,16(sp)
    800008c6:	e456                	sd	s5,8(sp)
    800008c8:	0080                	addi	s0,sp,64
    800008ca:	8aaa                	mv	s5,a0
    800008cc:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008ce:	6785                	lui	a5,0x1
    800008d0:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008d2:	95be                	add	a1,a1,a5
    800008d4:	77fd                	lui	a5,0xfffff
    800008d6:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008da:	08c9f063          	bgeu	s3,a2,8000095a <uvmalloc+0xa6>
    800008de:	894e                	mv	s2,s3
    mem = kalloc();
    800008e0:	00000097          	auipc	ra,0x0
    800008e4:	83a080e7          	jalr	-1990(ra) # 8000011a <kalloc>
    800008e8:	84aa                	mv	s1,a0
    if(mem == 0){
    800008ea:	c51d                	beqz	a0,80000918 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800008ec:	6605                	lui	a2,0x1
    800008ee:	4581                	li	a1,0
    800008f0:	00000097          	auipc	ra,0x0
    800008f4:	88a080e7          	jalr	-1910(ra) # 8000017a <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800008f8:	4779                	li	a4,30
    800008fa:	86a6                	mv	a3,s1
    800008fc:	6605                	lui	a2,0x1
    800008fe:	85ca                	mv	a1,s2
    80000900:	8556                	mv	a0,s5
    80000902:	00000097          	auipc	ra,0x0
    80000906:	c40080e7          	jalr	-960(ra) # 80000542 <mappages>
    8000090a:	e905                	bnez	a0,8000093a <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000090c:	6785                	lui	a5,0x1
    8000090e:	993e                	add	s2,s2,a5
    80000910:	fd4968e3          	bltu	s2,s4,800008e0 <uvmalloc+0x2c>
  return newsz;
    80000914:	8552                	mv	a0,s4
    80000916:	a809                	j	80000928 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80000918:	864e                	mv	a2,s3
    8000091a:	85ca                	mv	a1,s2
    8000091c:	8556                	mv	a0,s5
    8000091e:	00000097          	auipc	ra,0x0
    80000922:	f4e080e7          	jalr	-178(ra) # 8000086c <uvmdealloc>
      return 0;
    80000926:	4501                	li	a0,0
}
    80000928:	70e2                	ld	ra,56(sp)
    8000092a:	7442                	ld	s0,48(sp)
    8000092c:	74a2                	ld	s1,40(sp)
    8000092e:	7902                	ld	s2,32(sp)
    80000930:	69e2                	ld	s3,24(sp)
    80000932:	6a42                	ld	s4,16(sp)
    80000934:	6aa2                	ld	s5,8(sp)
    80000936:	6121                	addi	sp,sp,64
    80000938:	8082                	ret
      kfree(mem);
    8000093a:	8526                	mv	a0,s1
    8000093c:	fffff097          	auipc	ra,0xfffff
    80000940:	6e0080e7          	jalr	1760(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000944:	864e                	mv	a2,s3
    80000946:	85ca                	mv	a1,s2
    80000948:	8556                	mv	a0,s5
    8000094a:	00000097          	auipc	ra,0x0
    8000094e:	f22080e7          	jalr	-222(ra) # 8000086c <uvmdealloc>
      return 0;
    80000952:	4501                	li	a0,0
    80000954:	bfd1                	j	80000928 <uvmalloc+0x74>
    return oldsz;
    80000956:	852e                	mv	a0,a1
}
    80000958:	8082                	ret
  return newsz;
    8000095a:	8532                	mv	a0,a2
    8000095c:	b7f1                	j	80000928 <uvmalloc+0x74>

000000008000095e <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000095e:	7179                	addi	sp,sp,-48
    80000960:	f406                	sd	ra,40(sp)
    80000962:	f022                	sd	s0,32(sp)
    80000964:	ec26                	sd	s1,24(sp)
    80000966:	e84a                	sd	s2,16(sp)
    80000968:	e44e                	sd	s3,8(sp)
    8000096a:	e052                	sd	s4,0(sp)
    8000096c:	1800                	addi	s0,sp,48
    8000096e:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000970:	84aa                	mv	s1,a0
    80000972:	6905                	lui	s2,0x1
    80000974:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000976:	4985                	li	s3,1
    80000978:	a829                	j	80000992 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    8000097a:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    8000097c:	00c79513          	slli	a0,a5,0xc
    80000980:	00000097          	auipc	ra,0x0
    80000984:	fde080e7          	jalr	-34(ra) # 8000095e <freewalk>
      pagetable[i] = 0;
    80000988:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    8000098c:	04a1                	addi	s1,s1,8
    8000098e:	03248163          	beq	s1,s2,800009b0 <freewalk+0x52>
    pte_t pte = pagetable[i];
    80000992:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000994:	00f7f713          	andi	a4,a5,15
    80000998:	ff3701e3          	beq	a4,s3,8000097a <freewalk+0x1c>
    } else if(pte & PTE_V){
    8000099c:	8b85                	andi	a5,a5,1
    8000099e:	d7fd                	beqz	a5,8000098c <freewalk+0x2e>
      panic("freewalk: leaf");
    800009a0:	00007517          	auipc	a0,0x7
    800009a4:	75850513          	addi	a0,a0,1880 # 800080f8 <etext+0xf8>
    800009a8:	00005097          	auipc	ra,0x5
    800009ac:	418080e7          	jalr	1048(ra) # 80005dc0 <panic>
    }
  }
  kfree((void*)pagetable);
    800009b0:	8552                	mv	a0,s4
    800009b2:	fffff097          	auipc	ra,0xfffff
    800009b6:	66a080e7          	jalr	1642(ra) # 8000001c <kfree>
}
    800009ba:	70a2                	ld	ra,40(sp)
    800009bc:	7402                	ld	s0,32(sp)
    800009be:	64e2                	ld	s1,24(sp)
    800009c0:	6942                	ld	s2,16(sp)
    800009c2:	69a2                	ld	s3,8(sp)
    800009c4:	6a02                	ld	s4,0(sp)
    800009c6:	6145                	addi	sp,sp,48
    800009c8:	8082                	ret

00000000800009ca <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009ca:	1101                	addi	sp,sp,-32
    800009cc:	ec06                	sd	ra,24(sp)
    800009ce:	e822                	sd	s0,16(sp)
    800009d0:	e426                	sd	s1,8(sp)
    800009d2:	1000                	addi	s0,sp,32
    800009d4:	84aa                	mv	s1,a0
  if(sz > 0)
    800009d6:	e999                	bnez	a1,800009ec <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009d8:	8526                	mv	a0,s1
    800009da:	00000097          	auipc	ra,0x0
    800009de:	f84080e7          	jalr	-124(ra) # 8000095e <freewalk>
}
    800009e2:	60e2                	ld	ra,24(sp)
    800009e4:	6442                	ld	s0,16(sp)
    800009e6:	64a2                	ld	s1,8(sp)
    800009e8:	6105                	addi	sp,sp,32
    800009ea:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009ec:	6785                	lui	a5,0x1
    800009ee:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800009f0:	95be                	add	a1,a1,a5
    800009f2:	4685                	li	a3,1
    800009f4:	00c5d613          	srli	a2,a1,0xc
    800009f8:	4581                	li	a1,0
    800009fa:	00000097          	auipc	ra,0x0
    800009fe:	d0e080e7          	jalr	-754(ra) # 80000708 <uvmunmap>
    80000a02:	bfd9                	j	800009d8 <uvmfree+0xe>

0000000080000a04 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a04:	c679                	beqz	a2,80000ad2 <uvmcopy+0xce>
{
    80000a06:	715d                	addi	sp,sp,-80
    80000a08:	e486                	sd	ra,72(sp)
    80000a0a:	e0a2                	sd	s0,64(sp)
    80000a0c:	fc26                	sd	s1,56(sp)
    80000a0e:	f84a                	sd	s2,48(sp)
    80000a10:	f44e                	sd	s3,40(sp)
    80000a12:	f052                	sd	s4,32(sp)
    80000a14:	ec56                	sd	s5,24(sp)
    80000a16:	e85a                	sd	s6,16(sp)
    80000a18:	e45e                	sd	s7,8(sp)
    80000a1a:	0880                	addi	s0,sp,80
    80000a1c:	8b2a                	mv	s6,a0
    80000a1e:	8aae                	mv	s5,a1
    80000a20:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a22:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a24:	4601                	li	a2,0
    80000a26:	85ce                	mv	a1,s3
    80000a28:	855a                	mv	a0,s6
    80000a2a:	00000097          	auipc	ra,0x0
    80000a2e:	a30080e7          	jalr	-1488(ra) # 8000045a <walk>
    80000a32:	c531                	beqz	a0,80000a7e <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a34:	6118                	ld	a4,0(a0)
    80000a36:	00177793          	andi	a5,a4,1
    80000a3a:	cbb1                	beqz	a5,80000a8e <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a3c:	00a75593          	srli	a1,a4,0xa
    80000a40:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a44:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a48:	fffff097          	auipc	ra,0xfffff
    80000a4c:	6d2080e7          	jalr	1746(ra) # 8000011a <kalloc>
    80000a50:	892a                	mv	s2,a0
    80000a52:	c939                	beqz	a0,80000aa8 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a54:	6605                	lui	a2,0x1
    80000a56:	85de                	mv	a1,s7
    80000a58:	fffff097          	auipc	ra,0xfffff
    80000a5c:	77e080e7          	jalr	1918(ra) # 800001d6 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a60:	8726                	mv	a4,s1
    80000a62:	86ca                	mv	a3,s2
    80000a64:	6605                	lui	a2,0x1
    80000a66:	85ce                	mv	a1,s3
    80000a68:	8556                	mv	a0,s5
    80000a6a:	00000097          	auipc	ra,0x0
    80000a6e:	ad8080e7          	jalr	-1320(ra) # 80000542 <mappages>
    80000a72:	e515                	bnez	a0,80000a9e <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000a74:	6785                	lui	a5,0x1
    80000a76:	99be                	add	s3,s3,a5
    80000a78:	fb49e6e3          	bltu	s3,s4,80000a24 <uvmcopy+0x20>
    80000a7c:	a081                	j	80000abc <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000a7e:	00007517          	auipc	a0,0x7
    80000a82:	68a50513          	addi	a0,a0,1674 # 80008108 <etext+0x108>
    80000a86:	00005097          	auipc	ra,0x5
    80000a8a:	33a080e7          	jalr	826(ra) # 80005dc0 <panic>
      panic("uvmcopy: page not present");
    80000a8e:	00007517          	auipc	a0,0x7
    80000a92:	69a50513          	addi	a0,a0,1690 # 80008128 <etext+0x128>
    80000a96:	00005097          	auipc	ra,0x5
    80000a9a:	32a080e7          	jalr	810(ra) # 80005dc0 <panic>
      kfree(mem);
    80000a9e:	854a                	mv	a0,s2
    80000aa0:	fffff097          	auipc	ra,0xfffff
    80000aa4:	57c080e7          	jalr	1404(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000aa8:	4685                	li	a3,1
    80000aaa:	00c9d613          	srli	a2,s3,0xc
    80000aae:	4581                	li	a1,0
    80000ab0:	8556                	mv	a0,s5
    80000ab2:	00000097          	auipc	ra,0x0
    80000ab6:	c56080e7          	jalr	-938(ra) # 80000708 <uvmunmap>
  return -1;
    80000aba:	557d                	li	a0,-1
}
    80000abc:	60a6                	ld	ra,72(sp)
    80000abe:	6406                	ld	s0,64(sp)
    80000ac0:	74e2                	ld	s1,56(sp)
    80000ac2:	7942                	ld	s2,48(sp)
    80000ac4:	79a2                	ld	s3,40(sp)
    80000ac6:	7a02                	ld	s4,32(sp)
    80000ac8:	6ae2                	ld	s5,24(sp)
    80000aca:	6b42                	ld	s6,16(sp)
    80000acc:	6ba2                	ld	s7,8(sp)
    80000ace:	6161                	addi	sp,sp,80
    80000ad0:	8082                	ret
  return 0;
    80000ad2:	4501                	li	a0,0
}
    80000ad4:	8082                	ret

0000000080000ad6 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000ad6:	1141                	addi	sp,sp,-16
    80000ad8:	e406                	sd	ra,8(sp)
    80000ada:	e022                	sd	s0,0(sp)
    80000adc:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000ade:	4601                	li	a2,0
    80000ae0:	00000097          	auipc	ra,0x0
    80000ae4:	97a080e7          	jalr	-1670(ra) # 8000045a <walk>
  if(pte == 0)
    80000ae8:	c901                	beqz	a0,80000af8 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000aea:	611c                	ld	a5,0(a0)
    80000aec:	9bbd                	andi	a5,a5,-17
    80000aee:	e11c                	sd	a5,0(a0)
}
    80000af0:	60a2                	ld	ra,8(sp)
    80000af2:	6402                	ld	s0,0(sp)
    80000af4:	0141                	addi	sp,sp,16
    80000af6:	8082                	ret
    panic("uvmclear");
    80000af8:	00007517          	auipc	a0,0x7
    80000afc:	65050513          	addi	a0,a0,1616 # 80008148 <etext+0x148>
    80000b00:	00005097          	auipc	ra,0x5
    80000b04:	2c0080e7          	jalr	704(ra) # 80005dc0 <panic>

0000000080000b08 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b08:	c6bd                	beqz	a3,80000b76 <copyout+0x6e>
{
    80000b0a:	715d                	addi	sp,sp,-80
    80000b0c:	e486                	sd	ra,72(sp)
    80000b0e:	e0a2                	sd	s0,64(sp)
    80000b10:	fc26                	sd	s1,56(sp)
    80000b12:	f84a                	sd	s2,48(sp)
    80000b14:	f44e                	sd	s3,40(sp)
    80000b16:	f052                	sd	s4,32(sp)
    80000b18:	ec56                	sd	s5,24(sp)
    80000b1a:	e85a                	sd	s6,16(sp)
    80000b1c:	e45e                	sd	s7,8(sp)
    80000b1e:	e062                	sd	s8,0(sp)
    80000b20:	0880                	addi	s0,sp,80
    80000b22:	8b2a                	mv	s6,a0
    80000b24:	8c2e                	mv	s8,a1
    80000b26:	8a32                	mv	s4,a2
    80000b28:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b2a:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b2c:	6a85                	lui	s5,0x1
    80000b2e:	a015                	j	80000b52 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b30:	9562                	add	a0,a0,s8
    80000b32:	0004861b          	sext.w	a2,s1
    80000b36:	85d2                	mv	a1,s4
    80000b38:	41250533          	sub	a0,a0,s2
    80000b3c:	fffff097          	auipc	ra,0xfffff
    80000b40:	69a080e7          	jalr	1690(ra) # 800001d6 <memmove>

    len -= n;
    80000b44:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b48:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b4a:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b4e:	02098263          	beqz	s3,80000b72 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b52:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b56:	85ca                	mv	a1,s2
    80000b58:	855a                	mv	a0,s6
    80000b5a:	00000097          	auipc	ra,0x0
    80000b5e:	9a6080e7          	jalr	-1626(ra) # 80000500 <walkaddr>
    if(pa0 == 0)
    80000b62:	cd01                	beqz	a0,80000b7a <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b64:	418904b3          	sub	s1,s2,s8
    80000b68:	94d6                	add	s1,s1,s5
    80000b6a:	fc99f3e3          	bgeu	s3,s1,80000b30 <copyout+0x28>
    80000b6e:	84ce                	mv	s1,s3
    80000b70:	b7c1                	j	80000b30 <copyout+0x28>
  }
  return 0;
    80000b72:	4501                	li	a0,0
    80000b74:	a021                	j	80000b7c <copyout+0x74>
    80000b76:	4501                	li	a0,0
}
    80000b78:	8082                	ret
      return -1;
    80000b7a:	557d                	li	a0,-1
}
    80000b7c:	60a6                	ld	ra,72(sp)
    80000b7e:	6406                	ld	s0,64(sp)
    80000b80:	74e2                	ld	s1,56(sp)
    80000b82:	7942                	ld	s2,48(sp)
    80000b84:	79a2                	ld	s3,40(sp)
    80000b86:	7a02                	ld	s4,32(sp)
    80000b88:	6ae2                	ld	s5,24(sp)
    80000b8a:	6b42                	ld	s6,16(sp)
    80000b8c:	6ba2                	ld	s7,8(sp)
    80000b8e:	6c02                	ld	s8,0(sp)
    80000b90:	6161                	addi	sp,sp,80
    80000b92:	8082                	ret

0000000080000b94 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b94:	caa5                	beqz	a3,80000c04 <copyin+0x70>
{
    80000b96:	715d                	addi	sp,sp,-80
    80000b98:	e486                	sd	ra,72(sp)
    80000b9a:	e0a2                	sd	s0,64(sp)
    80000b9c:	fc26                	sd	s1,56(sp)
    80000b9e:	f84a                	sd	s2,48(sp)
    80000ba0:	f44e                	sd	s3,40(sp)
    80000ba2:	f052                	sd	s4,32(sp)
    80000ba4:	ec56                	sd	s5,24(sp)
    80000ba6:	e85a                	sd	s6,16(sp)
    80000ba8:	e45e                	sd	s7,8(sp)
    80000baa:	e062                	sd	s8,0(sp)
    80000bac:	0880                	addi	s0,sp,80
    80000bae:	8b2a                	mv	s6,a0
    80000bb0:	8a2e                	mv	s4,a1
    80000bb2:	8c32                	mv	s8,a2
    80000bb4:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bb6:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bb8:	6a85                	lui	s5,0x1
    80000bba:	a01d                	j	80000be0 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bbc:	018505b3          	add	a1,a0,s8
    80000bc0:	0004861b          	sext.w	a2,s1
    80000bc4:	412585b3          	sub	a1,a1,s2
    80000bc8:	8552                	mv	a0,s4
    80000bca:	fffff097          	auipc	ra,0xfffff
    80000bce:	60c080e7          	jalr	1548(ra) # 800001d6 <memmove>

    len -= n;
    80000bd2:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000bd6:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000bd8:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000bdc:	02098263          	beqz	s3,80000c00 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000be0:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000be4:	85ca                	mv	a1,s2
    80000be6:	855a                	mv	a0,s6
    80000be8:	00000097          	auipc	ra,0x0
    80000bec:	918080e7          	jalr	-1768(ra) # 80000500 <walkaddr>
    if(pa0 == 0)
    80000bf0:	cd01                	beqz	a0,80000c08 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000bf2:	418904b3          	sub	s1,s2,s8
    80000bf6:	94d6                	add	s1,s1,s5
    80000bf8:	fc99f2e3          	bgeu	s3,s1,80000bbc <copyin+0x28>
    80000bfc:	84ce                	mv	s1,s3
    80000bfe:	bf7d                	j	80000bbc <copyin+0x28>
  }
  return 0;
    80000c00:	4501                	li	a0,0
    80000c02:	a021                	j	80000c0a <copyin+0x76>
    80000c04:	4501                	li	a0,0
}
    80000c06:	8082                	ret
      return -1;
    80000c08:	557d                	li	a0,-1
}
    80000c0a:	60a6                	ld	ra,72(sp)
    80000c0c:	6406                	ld	s0,64(sp)
    80000c0e:	74e2                	ld	s1,56(sp)
    80000c10:	7942                	ld	s2,48(sp)
    80000c12:	79a2                	ld	s3,40(sp)
    80000c14:	7a02                	ld	s4,32(sp)
    80000c16:	6ae2                	ld	s5,24(sp)
    80000c18:	6b42                	ld	s6,16(sp)
    80000c1a:	6ba2                	ld	s7,8(sp)
    80000c1c:	6c02                	ld	s8,0(sp)
    80000c1e:	6161                	addi	sp,sp,80
    80000c20:	8082                	ret

0000000080000c22 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c22:	c2dd                	beqz	a3,80000cc8 <copyinstr+0xa6>
{
    80000c24:	715d                	addi	sp,sp,-80
    80000c26:	e486                	sd	ra,72(sp)
    80000c28:	e0a2                	sd	s0,64(sp)
    80000c2a:	fc26                	sd	s1,56(sp)
    80000c2c:	f84a                	sd	s2,48(sp)
    80000c2e:	f44e                	sd	s3,40(sp)
    80000c30:	f052                	sd	s4,32(sp)
    80000c32:	ec56                	sd	s5,24(sp)
    80000c34:	e85a                	sd	s6,16(sp)
    80000c36:	e45e                	sd	s7,8(sp)
    80000c38:	0880                	addi	s0,sp,80
    80000c3a:	8a2a                	mv	s4,a0
    80000c3c:	8b2e                	mv	s6,a1
    80000c3e:	8bb2                	mv	s7,a2
    80000c40:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c42:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c44:	6985                	lui	s3,0x1
    80000c46:	a02d                	j	80000c70 <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c48:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c4c:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c4e:	37fd                	addiw	a5,a5,-1
    80000c50:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c54:	60a6                	ld	ra,72(sp)
    80000c56:	6406                	ld	s0,64(sp)
    80000c58:	74e2                	ld	s1,56(sp)
    80000c5a:	7942                	ld	s2,48(sp)
    80000c5c:	79a2                	ld	s3,40(sp)
    80000c5e:	7a02                	ld	s4,32(sp)
    80000c60:	6ae2                	ld	s5,24(sp)
    80000c62:	6b42                	ld	s6,16(sp)
    80000c64:	6ba2                	ld	s7,8(sp)
    80000c66:	6161                	addi	sp,sp,80
    80000c68:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c6a:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c6e:	c8a9                	beqz	s1,80000cc0 <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80000c70:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c74:	85ca                	mv	a1,s2
    80000c76:	8552                	mv	a0,s4
    80000c78:	00000097          	auipc	ra,0x0
    80000c7c:	888080e7          	jalr	-1912(ra) # 80000500 <walkaddr>
    if(pa0 == 0)
    80000c80:	c131                	beqz	a0,80000cc4 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000c82:	417906b3          	sub	a3,s2,s7
    80000c86:	96ce                	add	a3,a3,s3
    80000c88:	00d4f363          	bgeu	s1,a3,80000c8e <copyinstr+0x6c>
    80000c8c:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000c8e:	955e                	add	a0,a0,s7
    80000c90:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000c94:	daf9                	beqz	a3,80000c6a <copyinstr+0x48>
    80000c96:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000c98:	41650633          	sub	a2,a0,s6
    80000c9c:	fff48593          	addi	a1,s1,-1
    80000ca0:	95da                	add	a1,a1,s6
    while(n > 0){
    80000ca2:	96da                	add	a3,a3,s6
      if(*p == '\0'){
    80000ca4:	00f60733          	add	a4,a2,a5
    80000ca8:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffdddc0>
    80000cac:	df51                	beqz	a4,80000c48 <copyinstr+0x26>
        *dst = *p;
    80000cae:	00e78023          	sb	a4,0(a5)
      --max;
    80000cb2:	40f584b3          	sub	s1,a1,a5
      dst++;
    80000cb6:	0785                	addi	a5,a5,1
    while(n > 0){
    80000cb8:	fed796e3          	bne	a5,a3,80000ca4 <copyinstr+0x82>
      dst++;
    80000cbc:	8b3e                	mv	s6,a5
    80000cbe:	b775                	j	80000c6a <copyinstr+0x48>
    80000cc0:	4781                	li	a5,0
    80000cc2:	b771                	j	80000c4e <copyinstr+0x2c>
      return -1;
    80000cc4:	557d                	li	a0,-1
    80000cc6:	b779                	j	80000c54 <copyinstr+0x32>
  int got_null = 0;
    80000cc8:	4781                	li	a5,0
  if(got_null){
    80000cca:	37fd                	addiw	a5,a5,-1
    80000ccc:	0007851b          	sext.w	a0,a5
}
    80000cd0:	8082                	ret

0000000080000cd2 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000cd2:	7139                	addi	sp,sp,-64
    80000cd4:	fc06                	sd	ra,56(sp)
    80000cd6:	f822                	sd	s0,48(sp)
    80000cd8:	f426                	sd	s1,40(sp)
    80000cda:	f04a                	sd	s2,32(sp)
    80000cdc:	ec4e                	sd	s3,24(sp)
    80000cde:	e852                	sd	s4,16(sp)
    80000ce0:	e456                	sd	s5,8(sp)
    80000ce2:	e05a                	sd	s6,0(sp)
    80000ce4:	0080                	addi	s0,sp,64
    80000ce6:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ce8:	00008497          	auipc	s1,0x8
    80000cec:	79848493          	addi	s1,s1,1944 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000cf0:	8b26                	mv	s6,s1
    80000cf2:	00007a97          	auipc	s5,0x7
    80000cf6:	30ea8a93          	addi	s5,s5,782 # 80008000 <etext>
    80000cfa:	04000937          	lui	s2,0x4000
    80000cfe:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000d00:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d02:	00009a17          	auipc	s4,0x9
    80000d06:	58ea0a13          	addi	s4,s4,1422 # 8000a290 <tickslock>
    char *pa = kalloc();
    80000d0a:	fffff097          	auipc	ra,0xfffff
    80000d0e:	410080e7          	jalr	1040(ra) # 8000011a <kalloc>
    80000d12:	862a                	mv	a2,a0
    if(pa == 0)
    80000d14:	c131                	beqz	a0,80000d58 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d16:	416485b3          	sub	a1,s1,s6
    80000d1a:	858d                	srai	a1,a1,0x3
    80000d1c:	000ab783          	ld	a5,0(s5)
    80000d20:	02f585b3          	mul	a1,a1,a5
    80000d24:	2585                	addiw	a1,a1,1
    80000d26:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d2a:	4719                	li	a4,6
    80000d2c:	6685                	lui	a3,0x1
    80000d2e:	40b905b3          	sub	a1,s2,a1
    80000d32:	854e                	mv	a0,s3
    80000d34:	00000097          	auipc	ra,0x0
    80000d38:	8ae080e7          	jalr	-1874(ra) # 800005e2 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d3c:	16848493          	addi	s1,s1,360
    80000d40:	fd4495e3          	bne	s1,s4,80000d0a <proc_mapstacks+0x38>
  }
}
    80000d44:	70e2                	ld	ra,56(sp)
    80000d46:	7442                	ld	s0,48(sp)
    80000d48:	74a2                	ld	s1,40(sp)
    80000d4a:	7902                	ld	s2,32(sp)
    80000d4c:	69e2                	ld	s3,24(sp)
    80000d4e:	6a42                	ld	s4,16(sp)
    80000d50:	6aa2                	ld	s5,8(sp)
    80000d52:	6b02                	ld	s6,0(sp)
    80000d54:	6121                	addi	sp,sp,64
    80000d56:	8082                	ret
      panic("kalloc");
    80000d58:	00007517          	auipc	a0,0x7
    80000d5c:	40050513          	addi	a0,a0,1024 # 80008158 <etext+0x158>
    80000d60:	00005097          	auipc	ra,0x5
    80000d64:	060080e7          	jalr	96(ra) # 80005dc0 <panic>

0000000080000d68 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000d68:	7139                	addi	sp,sp,-64
    80000d6a:	fc06                	sd	ra,56(sp)
    80000d6c:	f822                	sd	s0,48(sp)
    80000d6e:	f426                	sd	s1,40(sp)
    80000d70:	f04a                	sd	s2,32(sp)
    80000d72:	ec4e                	sd	s3,24(sp)
    80000d74:	e852                	sd	s4,16(sp)
    80000d76:	e456                	sd	s5,8(sp)
    80000d78:	e05a                	sd	s6,0(sp)
    80000d7a:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000d7c:	00007597          	auipc	a1,0x7
    80000d80:	3e458593          	addi	a1,a1,996 # 80008160 <etext+0x160>
    80000d84:	00008517          	auipc	a0,0x8
    80000d88:	2cc50513          	addi	a0,a0,716 # 80009050 <pid_lock>
    80000d8c:	00005097          	auipc	ra,0x5
    80000d90:	4dc080e7          	jalr	1244(ra) # 80006268 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d94:	00007597          	auipc	a1,0x7
    80000d98:	3d458593          	addi	a1,a1,980 # 80008168 <etext+0x168>
    80000d9c:	00008517          	auipc	a0,0x8
    80000da0:	2cc50513          	addi	a0,a0,716 # 80009068 <wait_lock>
    80000da4:	00005097          	auipc	ra,0x5
    80000da8:	4c4080e7          	jalr	1220(ra) # 80006268 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dac:	00008497          	auipc	s1,0x8
    80000db0:	6d448493          	addi	s1,s1,1748 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000db4:	00007b17          	auipc	s6,0x7
    80000db8:	3c4b0b13          	addi	s6,s6,964 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000dbc:	8aa6                	mv	s5,s1
    80000dbe:	00007a17          	auipc	s4,0x7
    80000dc2:	242a0a13          	addi	s4,s4,578 # 80008000 <etext>
    80000dc6:	04000937          	lui	s2,0x4000
    80000dca:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000dcc:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dce:	00009997          	auipc	s3,0x9
    80000dd2:	4c298993          	addi	s3,s3,1218 # 8000a290 <tickslock>
      initlock(&p->lock, "proc");
    80000dd6:	85da                	mv	a1,s6
    80000dd8:	8526                	mv	a0,s1
    80000dda:	00005097          	auipc	ra,0x5
    80000dde:	48e080e7          	jalr	1166(ra) # 80006268 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000de2:	415487b3          	sub	a5,s1,s5
    80000de6:	878d                	srai	a5,a5,0x3
    80000de8:	000a3703          	ld	a4,0(s4)
    80000dec:	02e787b3          	mul	a5,a5,a4
    80000df0:	2785                	addiw	a5,a5,1
    80000df2:	00d7979b          	slliw	a5,a5,0xd
    80000df6:	40f907b3          	sub	a5,s2,a5
    80000dfa:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dfc:	16848493          	addi	s1,s1,360
    80000e00:	fd349be3          	bne	s1,s3,80000dd6 <procinit+0x6e>
  }
}
    80000e04:	70e2                	ld	ra,56(sp)
    80000e06:	7442                	ld	s0,48(sp)
    80000e08:	74a2                	ld	s1,40(sp)
    80000e0a:	7902                	ld	s2,32(sp)
    80000e0c:	69e2                	ld	s3,24(sp)
    80000e0e:	6a42                	ld	s4,16(sp)
    80000e10:	6aa2                	ld	s5,8(sp)
    80000e12:	6b02                	ld	s6,0(sp)
    80000e14:	6121                	addi	sp,sp,64
    80000e16:	8082                	ret

0000000080000e18 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e18:	1141                	addi	sp,sp,-16
    80000e1a:	e422                	sd	s0,8(sp)
    80000e1c:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e1e:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e20:	2501                	sext.w	a0,a0
    80000e22:	6422                	ld	s0,8(sp)
    80000e24:	0141                	addi	sp,sp,16
    80000e26:	8082                	ret

0000000080000e28 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e28:	1141                	addi	sp,sp,-16
    80000e2a:	e422                	sd	s0,8(sp)
    80000e2c:	0800                	addi	s0,sp,16
    80000e2e:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e30:	2781                	sext.w	a5,a5
    80000e32:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e34:	00008517          	auipc	a0,0x8
    80000e38:	24c50513          	addi	a0,a0,588 # 80009080 <cpus>
    80000e3c:	953e                	add	a0,a0,a5
    80000e3e:	6422                	ld	s0,8(sp)
    80000e40:	0141                	addi	sp,sp,16
    80000e42:	8082                	ret

0000000080000e44 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000e44:	1101                	addi	sp,sp,-32
    80000e46:	ec06                	sd	ra,24(sp)
    80000e48:	e822                	sd	s0,16(sp)
    80000e4a:	e426                	sd	s1,8(sp)
    80000e4c:	1000                	addi	s0,sp,32
  push_off();
    80000e4e:	00005097          	auipc	ra,0x5
    80000e52:	45e080e7          	jalr	1118(ra) # 800062ac <push_off>
    80000e56:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e58:	2781                	sext.w	a5,a5
    80000e5a:	079e                	slli	a5,a5,0x7
    80000e5c:	00008717          	auipc	a4,0x8
    80000e60:	1f470713          	addi	a4,a4,500 # 80009050 <pid_lock>
    80000e64:	97ba                	add	a5,a5,a4
    80000e66:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e68:	00005097          	auipc	ra,0x5
    80000e6c:	4e4080e7          	jalr	1252(ra) # 8000634c <pop_off>
  return p;
}
    80000e70:	8526                	mv	a0,s1
    80000e72:	60e2                	ld	ra,24(sp)
    80000e74:	6442                	ld	s0,16(sp)
    80000e76:	64a2                	ld	s1,8(sp)
    80000e78:	6105                	addi	sp,sp,32
    80000e7a:	8082                	ret

0000000080000e7c <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000e7c:	1141                	addi	sp,sp,-16
    80000e7e:	e406                	sd	ra,8(sp)
    80000e80:	e022                	sd	s0,0(sp)
    80000e82:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000e84:	00000097          	auipc	ra,0x0
    80000e88:	fc0080e7          	jalr	-64(ra) # 80000e44 <myproc>
    80000e8c:	00005097          	auipc	ra,0x5
    80000e90:	520080e7          	jalr	1312(ra) # 800063ac <release>

  if (first) {
    80000e94:	00008797          	auipc	a5,0x8
    80000e98:	98c7a783          	lw	a5,-1652(a5) # 80008820 <first.1>
    80000e9c:	eb89                	bnez	a5,80000eae <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000e9e:	00001097          	auipc	ra,0x1
    80000ea2:	c14080e7          	jalr	-1004(ra) # 80001ab2 <usertrapret>
}
    80000ea6:	60a2                	ld	ra,8(sp)
    80000ea8:	6402                	ld	s0,0(sp)
    80000eaa:	0141                	addi	sp,sp,16
    80000eac:	8082                	ret
    first = 0;
    80000eae:	00008797          	auipc	a5,0x8
    80000eb2:	9607a923          	sw	zero,-1678(a5) # 80008820 <first.1>
    fsinit(ROOTDEV);
    80000eb6:	4505                	li	a0,1
    80000eb8:	00002097          	auipc	ra,0x2
    80000ebc:	a02080e7          	jalr	-1534(ra) # 800028ba <fsinit>
    80000ec0:	bff9                	j	80000e9e <forkret+0x22>

0000000080000ec2 <allocpid>:
allocpid() {
    80000ec2:	1101                	addi	sp,sp,-32
    80000ec4:	ec06                	sd	ra,24(sp)
    80000ec6:	e822                	sd	s0,16(sp)
    80000ec8:	e426                	sd	s1,8(sp)
    80000eca:	e04a                	sd	s2,0(sp)
    80000ecc:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000ece:	00008917          	auipc	s2,0x8
    80000ed2:	18290913          	addi	s2,s2,386 # 80009050 <pid_lock>
    80000ed6:	854a                	mv	a0,s2
    80000ed8:	00005097          	auipc	ra,0x5
    80000edc:	420080e7          	jalr	1056(ra) # 800062f8 <acquire>
  pid = nextpid;
    80000ee0:	00008797          	auipc	a5,0x8
    80000ee4:	94478793          	addi	a5,a5,-1724 # 80008824 <nextpid>
    80000ee8:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000eea:	0014871b          	addiw	a4,s1,1
    80000eee:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000ef0:	854a                	mv	a0,s2
    80000ef2:	00005097          	auipc	ra,0x5
    80000ef6:	4ba080e7          	jalr	1210(ra) # 800063ac <release>
}
    80000efa:	8526                	mv	a0,s1
    80000efc:	60e2                	ld	ra,24(sp)
    80000efe:	6442                	ld	s0,16(sp)
    80000f00:	64a2                	ld	s1,8(sp)
    80000f02:	6902                	ld	s2,0(sp)
    80000f04:	6105                	addi	sp,sp,32
    80000f06:	8082                	ret

0000000080000f08 <proc_pagetable>:
{
    80000f08:	1101                	addi	sp,sp,-32
    80000f0a:	ec06                	sd	ra,24(sp)
    80000f0c:	e822                	sd	s0,16(sp)
    80000f0e:	e426                	sd	s1,8(sp)
    80000f10:	e04a                	sd	s2,0(sp)
    80000f12:	1000                	addi	s0,sp,32
    80000f14:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f16:	00000097          	auipc	ra,0x0
    80000f1a:	8b6080e7          	jalr	-1866(ra) # 800007cc <uvmcreate>
    80000f1e:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f20:	c121                	beqz	a0,80000f60 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f22:	4729                	li	a4,10
    80000f24:	00006697          	auipc	a3,0x6
    80000f28:	0dc68693          	addi	a3,a3,220 # 80007000 <_trampoline>
    80000f2c:	6605                	lui	a2,0x1
    80000f2e:	040005b7          	lui	a1,0x4000
    80000f32:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f34:	05b2                	slli	a1,a1,0xc
    80000f36:	fffff097          	auipc	ra,0xfffff
    80000f3a:	60c080e7          	jalr	1548(ra) # 80000542 <mappages>
    80000f3e:	02054863          	bltz	a0,80000f6e <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f42:	4719                	li	a4,6
    80000f44:	05893683          	ld	a3,88(s2)
    80000f48:	6605                	lui	a2,0x1
    80000f4a:	020005b7          	lui	a1,0x2000
    80000f4e:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f50:	05b6                	slli	a1,a1,0xd
    80000f52:	8526                	mv	a0,s1
    80000f54:	fffff097          	auipc	ra,0xfffff
    80000f58:	5ee080e7          	jalr	1518(ra) # 80000542 <mappages>
    80000f5c:	02054163          	bltz	a0,80000f7e <proc_pagetable+0x76>
}
    80000f60:	8526                	mv	a0,s1
    80000f62:	60e2                	ld	ra,24(sp)
    80000f64:	6442                	ld	s0,16(sp)
    80000f66:	64a2                	ld	s1,8(sp)
    80000f68:	6902                	ld	s2,0(sp)
    80000f6a:	6105                	addi	sp,sp,32
    80000f6c:	8082                	ret
    uvmfree(pagetable, 0);
    80000f6e:	4581                	li	a1,0
    80000f70:	8526                	mv	a0,s1
    80000f72:	00000097          	auipc	ra,0x0
    80000f76:	a58080e7          	jalr	-1448(ra) # 800009ca <uvmfree>
    return 0;
    80000f7a:	4481                	li	s1,0
    80000f7c:	b7d5                	j	80000f60 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f7e:	4681                	li	a3,0
    80000f80:	4605                	li	a2,1
    80000f82:	040005b7          	lui	a1,0x4000
    80000f86:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f88:	05b2                	slli	a1,a1,0xc
    80000f8a:	8526                	mv	a0,s1
    80000f8c:	fffff097          	auipc	ra,0xfffff
    80000f90:	77c080e7          	jalr	1916(ra) # 80000708 <uvmunmap>
    uvmfree(pagetable, 0);
    80000f94:	4581                	li	a1,0
    80000f96:	8526                	mv	a0,s1
    80000f98:	00000097          	auipc	ra,0x0
    80000f9c:	a32080e7          	jalr	-1486(ra) # 800009ca <uvmfree>
    return 0;
    80000fa0:	4481                	li	s1,0
    80000fa2:	bf7d                	j	80000f60 <proc_pagetable+0x58>

0000000080000fa4 <proc_freepagetable>:
{
    80000fa4:	1101                	addi	sp,sp,-32
    80000fa6:	ec06                	sd	ra,24(sp)
    80000fa8:	e822                	sd	s0,16(sp)
    80000faa:	e426                	sd	s1,8(sp)
    80000fac:	e04a                	sd	s2,0(sp)
    80000fae:	1000                	addi	s0,sp,32
    80000fb0:	84aa                	mv	s1,a0
    80000fb2:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fb4:	4681                	li	a3,0
    80000fb6:	4605                	li	a2,1
    80000fb8:	040005b7          	lui	a1,0x4000
    80000fbc:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fbe:	05b2                	slli	a1,a1,0xc
    80000fc0:	fffff097          	auipc	ra,0xfffff
    80000fc4:	748080e7          	jalr	1864(ra) # 80000708 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fc8:	4681                	li	a3,0
    80000fca:	4605                	li	a2,1
    80000fcc:	020005b7          	lui	a1,0x2000
    80000fd0:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000fd2:	05b6                	slli	a1,a1,0xd
    80000fd4:	8526                	mv	a0,s1
    80000fd6:	fffff097          	auipc	ra,0xfffff
    80000fda:	732080e7          	jalr	1842(ra) # 80000708 <uvmunmap>
  uvmfree(pagetable, sz);
    80000fde:	85ca                	mv	a1,s2
    80000fe0:	8526                	mv	a0,s1
    80000fe2:	00000097          	auipc	ra,0x0
    80000fe6:	9e8080e7          	jalr	-1560(ra) # 800009ca <uvmfree>
}
    80000fea:	60e2                	ld	ra,24(sp)
    80000fec:	6442                	ld	s0,16(sp)
    80000fee:	64a2                	ld	s1,8(sp)
    80000ff0:	6902                	ld	s2,0(sp)
    80000ff2:	6105                	addi	sp,sp,32
    80000ff4:	8082                	ret

0000000080000ff6 <freeproc>:
{
    80000ff6:	1101                	addi	sp,sp,-32
    80000ff8:	ec06                	sd	ra,24(sp)
    80000ffa:	e822                	sd	s0,16(sp)
    80000ffc:	e426                	sd	s1,8(sp)
    80000ffe:	1000                	addi	s0,sp,32
    80001000:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001002:	6d28                	ld	a0,88(a0)
    80001004:	c509                	beqz	a0,8000100e <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001006:	fffff097          	auipc	ra,0xfffff
    8000100a:	016080e7          	jalr	22(ra) # 8000001c <kfree>
  p->trapframe = 0;
    8000100e:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001012:	68a8                	ld	a0,80(s1)
    80001014:	c511                	beqz	a0,80001020 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001016:	64ac                	ld	a1,72(s1)
    80001018:	00000097          	auipc	ra,0x0
    8000101c:	f8c080e7          	jalr	-116(ra) # 80000fa4 <proc_freepagetable>
  p->pagetable = 0;
    80001020:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001024:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001028:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000102c:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001030:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001034:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001038:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000103c:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001040:	0004ac23          	sw	zero,24(s1)
}
    80001044:	60e2                	ld	ra,24(sp)
    80001046:	6442                	ld	s0,16(sp)
    80001048:	64a2                	ld	s1,8(sp)
    8000104a:	6105                	addi	sp,sp,32
    8000104c:	8082                	ret

000000008000104e <allocproc>:
{
    8000104e:	1101                	addi	sp,sp,-32
    80001050:	ec06                	sd	ra,24(sp)
    80001052:	e822                	sd	s0,16(sp)
    80001054:	e426                	sd	s1,8(sp)
    80001056:	e04a                	sd	s2,0(sp)
    80001058:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000105a:	00008497          	auipc	s1,0x8
    8000105e:	42648493          	addi	s1,s1,1062 # 80009480 <proc>
    80001062:	00009917          	auipc	s2,0x9
    80001066:	22e90913          	addi	s2,s2,558 # 8000a290 <tickslock>
    acquire(&p->lock);
    8000106a:	8526                	mv	a0,s1
    8000106c:	00005097          	auipc	ra,0x5
    80001070:	28c080e7          	jalr	652(ra) # 800062f8 <acquire>
    if(p->state == UNUSED) {
    80001074:	4c9c                	lw	a5,24(s1)
    80001076:	c395                	beqz	a5,8000109a <allocproc+0x4c>
      release(&p->lock);
    80001078:	8526                	mv	a0,s1
    8000107a:	00005097          	auipc	ra,0x5
    8000107e:	332080e7          	jalr	818(ra) # 800063ac <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001082:	16848493          	addi	s1,s1,360
    80001086:	ff2492e3          	bne	s1,s2,8000106a <allocproc+0x1c>
  return 0;
    8000108a:	4481                	li	s1,0
}
    8000108c:	8526                	mv	a0,s1
    8000108e:	60e2                	ld	ra,24(sp)
    80001090:	6442                	ld	s0,16(sp)
    80001092:	64a2                	ld	s1,8(sp)
    80001094:	6902                	ld	s2,0(sp)
    80001096:	6105                	addi	sp,sp,32
    80001098:	8082                	ret
  p->pid = allocpid();
    8000109a:	00000097          	auipc	ra,0x0
    8000109e:	e28080e7          	jalr	-472(ra) # 80000ec2 <allocpid>
    800010a2:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010a4:	4785                	li	a5,1
    800010a6:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010a8:	fffff097          	auipc	ra,0xfffff
    800010ac:	072080e7          	jalr	114(ra) # 8000011a <kalloc>
    800010b0:	892a                	mv	s2,a0
    800010b2:	eca8                	sd	a0,88(s1)
    800010b4:	cd05                	beqz	a0,800010ec <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800010b6:	8526                	mv	a0,s1
    800010b8:	00000097          	auipc	ra,0x0
    800010bc:	e50080e7          	jalr	-432(ra) # 80000f08 <proc_pagetable>
    800010c0:	892a                	mv	s2,a0
    800010c2:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010c4:	c121                	beqz	a0,80001104 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800010c6:	07000613          	li	a2,112
    800010ca:	4581                	li	a1,0
    800010cc:	06048513          	addi	a0,s1,96
    800010d0:	fffff097          	auipc	ra,0xfffff
    800010d4:	0aa080e7          	jalr	170(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    800010d8:	00000797          	auipc	a5,0x0
    800010dc:	da478793          	addi	a5,a5,-604 # 80000e7c <forkret>
    800010e0:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800010e2:	60bc                	ld	a5,64(s1)
    800010e4:	6705                	lui	a4,0x1
    800010e6:	97ba                	add	a5,a5,a4
    800010e8:	f4bc                	sd	a5,104(s1)
  return p;
    800010ea:	b74d                	j	8000108c <allocproc+0x3e>
    freeproc(p);
    800010ec:	8526                	mv	a0,s1
    800010ee:	00000097          	auipc	ra,0x0
    800010f2:	f08080e7          	jalr	-248(ra) # 80000ff6 <freeproc>
    release(&p->lock);
    800010f6:	8526                	mv	a0,s1
    800010f8:	00005097          	auipc	ra,0x5
    800010fc:	2b4080e7          	jalr	692(ra) # 800063ac <release>
    return 0;
    80001100:	84ca                	mv	s1,s2
    80001102:	b769                	j	8000108c <allocproc+0x3e>
    freeproc(p);
    80001104:	8526                	mv	a0,s1
    80001106:	00000097          	auipc	ra,0x0
    8000110a:	ef0080e7          	jalr	-272(ra) # 80000ff6 <freeproc>
    release(&p->lock);
    8000110e:	8526                	mv	a0,s1
    80001110:	00005097          	auipc	ra,0x5
    80001114:	29c080e7          	jalr	668(ra) # 800063ac <release>
    return 0;
    80001118:	84ca                	mv	s1,s2
    8000111a:	bf8d                	j	8000108c <allocproc+0x3e>

000000008000111c <userinit>:
{
    8000111c:	1101                	addi	sp,sp,-32
    8000111e:	ec06                	sd	ra,24(sp)
    80001120:	e822                	sd	s0,16(sp)
    80001122:	e426                	sd	s1,8(sp)
    80001124:	1000                	addi	s0,sp,32
  p = allocproc();
    80001126:	00000097          	auipc	ra,0x0
    8000112a:	f28080e7          	jalr	-216(ra) # 8000104e <allocproc>
    8000112e:	84aa                	mv	s1,a0
  initproc = p;
    80001130:	00008797          	auipc	a5,0x8
    80001134:	eea7b023          	sd	a0,-288(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001138:	03400613          	li	a2,52
    8000113c:	00007597          	auipc	a1,0x7
    80001140:	6f458593          	addi	a1,a1,1780 # 80008830 <initcode>
    80001144:	6928                	ld	a0,80(a0)
    80001146:	fffff097          	auipc	ra,0xfffff
    8000114a:	6b4080e7          	jalr	1716(ra) # 800007fa <uvminit>
  p->sz = PGSIZE;
    8000114e:	6785                	lui	a5,0x1
    80001150:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001152:	6cb8                	ld	a4,88(s1)
    80001154:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001158:	6cb8                	ld	a4,88(s1)
    8000115a:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000115c:	4641                	li	a2,16
    8000115e:	00007597          	auipc	a1,0x7
    80001162:	02258593          	addi	a1,a1,34 # 80008180 <etext+0x180>
    80001166:	15848513          	addi	a0,s1,344
    8000116a:	fffff097          	auipc	ra,0xfffff
    8000116e:	15a080e7          	jalr	346(ra) # 800002c4 <safestrcpy>
  p->cwd = namei("/");
    80001172:	00007517          	auipc	a0,0x7
    80001176:	01e50513          	addi	a0,a0,30 # 80008190 <etext+0x190>
    8000117a:	00002097          	auipc	ra,0x2
    8000117e:	222080e7          	jalr	546(ra) # 8000339c <namei>
    80001182:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001186:	478d                	li	a5,3
    80001188:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000118a:	8526                	mv	a0,s1
    8000118c:	00005097          	auipc	ra,0x5
    80001190:	220080e7          	jalr	544(ra) # 800063ac <release>
}
    80001194:	60e2                	ld	ra,24(sp)
    80001196:	6442                	ld	s0,16(sp)
    80001198:	64a2                	ld	s1,8(sp)
    8000119a:	6105                	addi	sp,sp,32
    8000119c:	8082                	ret

000000008000119e <growproc>:
{
    8000119e:	1101                	addi	sp,sp,-32
    800011a0:	ec06                	sd	ra,24(sp)
    800011a2:	e822                	sd	s0,16(sp)
    800011a4:	e426                	sd	s1,8(sp)
    800011a6:	e04a                	sd	s2,0(sp)
    800011a8:	1000                	addi	s0,sp,32
    800011aa:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800011ac:	00000097          	auipc	ra,0x0
    800011b0:	c98080e7          	jalr	-872(ra) # 80000e44 <myproc>
    800011b4:	892a                	mv	s2,a0
  sz = p->sz;
    800011b6:	652c                	ld	a1,72(a0)
    800011b8:	0005879b          	sext.w	a5,a1
  if(n > 0){
    800011bc:	00904f63          	bgtz	s1,800011da <growproc+0x3c>
  } else if(n < 0){
    800011c0:	0204cd63          	bltz	s1,800011fa <growproc+0x5c>
  p->sz = sz;
    800011c4:	1782                	slli	a5,a5,0x20
    800011c6:	9381                	srli	a5,a5,0x20
    800011c8:	04f93423          	sd	a5,72(s2)
  return 0;
    800011cc:	4501                	li	a0,0
}
    800011ce:	60e2                	ld	ra,24(sp)
    800011d0:	6442                	ld	s0,16(sp)
    800011d2:	64a2                	ld	s1,8(sp)
    800011d4:	6902                	ld	s2,0(sp)
    800011d6:	6105                	addi	sp,sp,32
    800011d8:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    800011da:	00f4863b          	addw	a2,s1,a5
    800011de:	1602                	slli	a2,a2,0x20
    800011e0:	9201                	srli	a2,a2,0x20
    800011e2:	1582                	slli	a1,a1,0x20
    800011e4:	9181                	srli	a1,a1,0x20
    800011e6:	6928                	ld	a0,80(a0)
    800011e8:	fffff097          	auipc	ra,0xfffff
    800011ec:	6cc080e7          	jalr	1740(ra) # 800008b4 <uvmalloc>
    800011f0:	0005079b          	sext.w	a5,a0
    800011f4:	fbe1                	bnez	a5,800011c4 <growproc+0x26>
      return -1;
    800011f6:	557d                	li	a0,-1
    800011f8:	bfd9                	j	800011ce <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800011fa:	00f4863b          	addw	a2,s1,a5
    800011fe:	1602                	slli	a2,a2,0x20
    80001200:	9201                	srli	a2,a2,0x20
    80001202:	1582                	slli	a1,a1,0x20
    80001204:	9181                	srli	a1,a1,0x20
    80001206:	6928                	ld	a0,80(a0)
    80001208:	fffff097          	auipc	ra,0xfffff
    8000120c:	664080e7          	jalr	1636(ra) # 8000086c <uvmdealloc>
    80001210:	0005079b          	sext.w	a5,a0
    80001214:	bf45                	j	800011c4 <growproc+0x26>

0000000080001216 <fork>:
{
    80001216:	7139                	addi	sp,sp,-64
    80001218:	fc06                	sd	ra,56(sp)
    8000121a:	f822                	sd	s0,48(sp)
    8000121c:	f426                	sd	s1,40(sp)
    8000121e:	f04a                	sd	s2,32(sp)
    80001220:	ec4e                	sd	s3,24(sp)
    80001222:	e852                	sd	s4,16(sp)
    80001224:	e456                	sd	s5,8(sp)
    80001226:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001228:	00000097          	auipc	ra,0x0
    8000122c:	c1c080e7          	jalr	-996(ra) # 80000e44 <myproc>
    80001230:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001232:	00000097          	auipc	ra,0x0
    80001236:	e1c080e7          	jalr	-484(ra) # 8000104e <allocproc>
    8000123a:	10050c63          	beqz	a0,80001352 <fork+0x13c>
    8000123e:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001240:	048ab603          	ld	a2,72(s5)
    80001244:	692c                	ld	a1,80(a0)
    80001246:	050ab503          	ld	a0,80(s5)
    8000124a:	fffff097          	auipc	ra,0xfffff
    8000124e:	7ba080e7          	jalr	1978(ra) # 80000a04 <uvmcopy>
    80001252:	04054863          	bltz	a0,800012a2 <fork+0x8c>
  np->sz = p->sz;
    80001256:	048ab783          	ld	a5,72(s5)
    8000125a:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    8000125e:	058ab683          	ld	a3,88(s5)
    80001262:	87b6                	mv	a5,a3
    80001264:	058a3703          	ld	a4,88(s4)
    80001268:	12068693          	addi	a3,a3,288
    8000126c:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001270:	6788                	ld	a0,8(a5)
    80001272:	6b8c                	ld	a1,16(a5)
    80001274:	6f90                	ld	a2,24(a5)
    80001276:	01073023          	sd	a6,0(a4)
    8000127a:	e708                	sd	a0,8(a4)
    8000127c:	eb0c                	sd	a1,16(a4)
    8000127e:	ef10                	sd	a2,24(a4)
    80001280:	02078793          	addi	a5,a5,32
    80001284:	02070713          	addi	a4,a4,32
    80001288:	fed792e3          	bne	a5,a3,8000126c <fork+0x56>
  np->trapframe->a0 = 0;
    8000128c:	058a3783          	ld	a5,88(s4)
    80001290:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001294:	0d0a8493          	addi	s1,s5,208
    80001298:	0d0a0913          	addi	s2,s4,208
    8000129c:	150a8993          	addi	s3,s5,336
    800012a0:	a00d                	j	800012c2 <fork+0xac>
    freeproc(np);
    800012a2:	8552                	mv	a0,s4
    800012a4:	00000097          	auipc	ra,0x0
    800012a8:	d52080e7          	jalr	-686(ra) # 80000ff6 <freeproc>
    release(&np->lock);
    800012ac:	8552                	mv	a0,s4
    800012ae:	00005097          	auipc	ra,0x5
    800012b2:	0fe080e7          	jalr	254(ra) # 800063ac <release>
    return -1;
    800012b6:	597d                	li	s2,-1
    800012b8:	a059                	j	8000133e <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    800012ba:	04a1                	addi	s1,s1,8
    800012bc:	0921                	addi	s2,s2,8
    800012be:	01348b63          	beq	s1,s3,800012d4 <fork+0xbe>
    if(p->ofile[i])
    800012c2:	6088                	ld	a0,0(s1)
    800012c4:	d97d                	beqz	a0,800012ba <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    800012c6:	00002097          	auipc	ra,0x2
    800012ca:	76c080e7          	jalr	1900(ra) # 80003a32 <filedup>
    800012ce:	00a93023          	sd	a0,0(s2)
    800012d2:	b7e5                	j	800012ba <fork+0xa4>
  np->cwd = idup(p->cwd);
    800012d4:	150ab503          	ld	a0,336(s5)
    800012d8:	00002097          	auipc	ra,0x2
    800012dc:	81e080e7          	jalr	-2018(ra) # 80002af6 <idup>
    800012e0:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800012e4:	4641                	li	a2,16
    800012e6:	158a8593          	addi	a1,s5,344
    800012ea:	158a0513          	addi	a0,s4,344
    800012ee:	fffff097          	auipc	ra,0xfffff
    800012f2:	fd6080e7          	jalr	-42(ra) # 800002c4 <safestrcpy>
  pid = np->pid;
    800012f6:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    800012fa:	8552                	mv	a0,s4
    800012fc:	00005097          	auipc	ra,0x5
    80001300:	0b0080e7          	jalr	176(ra) # 800063ac <release>
  acquire(&wait_lock);
    80001304:	00008497          	auipc	s1,0x8
    80001308:	d6448493          	addi	s1,s1,-668 # 80009068 <wait_lock>
    8000130c:	8526                	mv	a0,s1
    8000130e:	00005097          	auipc	ra,0x5
    80001312:	fea080e7          	jalr	-22(ra) # 800062f8 <acquire>
  np->parent = p;
    80001316:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    8000131a:	8526                	mv	a0,s1
    8000131c:	00005097          	auipc	ra,0x5
    80001320:	090080e7          	jalr	144(ra) # 800063ac <release>
  acquire(&np->lock);
    80001324:	8552                	mv	a0,s4
    80001326:	00005097          	auipc	ra,0x5
    8000132a:	fd2080e7          	jalr	-46(ra) # 800062f8 <acquire>
  np->state = RUNNABLE;
    8000132e:	478d                	li	a5,3
    80001330:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001334:	8552                	mv	a0,s4
    80001336:	00005097          	auipc	ra,0x5
    8000133a:	076080e7          	jalr	118(ra) # 800063ac <release>
}
    8000133e:	854a                	mv	a0,s2
    80001340:	70e2                	ld	ra,56(sp)
    80001342:	7442                	ld	s0,48(sp)
    80001344:	74a2                	ld	s1,40(sp)
    80001346:	7902                	ld	s2,32(sp)
    80001348:	69e2                	ld	s3,24(sp)
    8000134a:	6a42                	ld	s4,16(sp)
    8000134c:	6aa2                	ld	s5,8(sp)
    8000134e:	6121                	addi	sp,sp,64
    80001350:	8082                	ret
    return -1;
    80001352:	597d                	li	s2,-1
    80001354:	b7ed                	j	8000133e <fork+0x128>

0000000080001356 <scheduler>:
{
    80001356:	7139                	addi	sp,sp,-64
    80001358:	fc06                	sd	ra,56(sp)
    8000135a:	f822                	sd	s0,48(sp)
    8000135c:	f426                	sd	s1,40(sp)
    8000135e:	f04a                	sd	s2,32(sp)
    80001360:	ec4e                	sd	s3,24(sp)
    80001362:	e852                	sd	s4,16(sp)
    80001364:	e456                	sd	s5,8(sp)
    80001366:	e05a                	sd	s6,0(sp)
    80001368:	0080                	addi	s0,sp,64
    8000136a:	8792                	mv	a5,tp
  int id = r_tp();
    8000136c:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000136e:	00779a93          	slli	s5,a5,0x7
    80001372:	00008717          	auipc	a4,0x8
    80001376:	cde70713          	addi	a4,a4,-802 # 80009050 <pid_lock>
    8000137a:	9756                	add	a4,a4,s5
    8000137c:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001380:	00008717          	auipc	a4,0x8
    80001384:	d0870713          	addi	a4,a4,-760 # 80009088 <cpus+0x8>
    80001388:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    8000138a:	498d                	li	s3,3
        p->state = RUNNING;
    8000138c:	4b11                	li	s6,4
        c->proc = p;
    8000138e:	079e                	slli	a5,a5,0x7
    80001390:	00008a17          	auipc	s4,0x8
    80001394:	cc0a0a13          	addi	s4,s4,-832 # 80009050 <pid_lock>
    80001398:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    8000139a:	00009917          	auipc	s2,0x9
    8000139e:	ef690913          	addi	s2,s2,-266 # 8000a290 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013a2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013a6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013aa:	10079073          	csrw	sstatus,a5
    800013ae:	00008497          	auipc	s1,0x8
    800013b2:	0d248493          	addi	s1,s1,210 # 80009480 <proc>
    800013b6:	a811                	j	800013ca <scheduler+0x74>
      release(&p->lock);
    800013b8:	8526                	mv	a0,s1
    800013ba:	00005097          	auipc	ra,0x5
    800013be:	ff2080e7          	jalr	-14(ra) # 800063ac <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800013c2:	16848493          	addi	s1,s1,360
    800013c6:	fd248ee3          	beq	s1,s2,800013a2 <scheduler+0x4c>
      acquire(&p->lock);
    800013ca:	8526                	mv	a0,s1
    800013cc:	00005097          	auipc	ra,0x5
    800013d0:	f2c080e7          	jalr	-212(ra) # 800062f8 <acquire>
      if(p->state == RUNNABLE) {
    800013d4:	4c9c                	lw	a5,24(s1)
    800013d6:	ff3791e3          	bne	a5,s3,800013b8 <scheduler+0x62>
        p->state = RUNNING;
    800013da:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800013de:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800013e2:	06048593          	addi	a1,s1,96
    800013e6:	8556                	mv	a0,s5
    800013e8:	00000097          	auipc	ra,0x0
    800013ec:	620080e7          	jalr	1568(ra) # 80001a08 <swtch>
        c->proc = 0;
    800013f0:	020a3823          	sd	zero,48(s4)
    800013f4:	b7d1                	j	800013b8 <scheduler+0x62>

00000000800013f6 <sched>:
{
    800013f6:	7179                	addi	sp,sp,-48
    800013f8:	f406                	sd	ra,40(sp)
    800013fa:	f022                	sd	s0,32(sp)
    800013fc:	ec26                	sd	s1,24(sp)
    800013fe:	e84a                	sd	s2,16(sp)
    80001400:	e44e                	sd	s3,8(sp)
    80001402:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001404:	00000097          	auipc	ra,0x0
    80001408:	a40080e7          	jalr	-1472(ra) # 80000e44 <myproc>
    8000140c:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000140e:	00005097          	auipc	ra,0x5
    80001412:	e70080e7          	jalr	-400(ra) # 8000627e <holding>
    80001416:	c93d                	beqz	a0,8000148c <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001418:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000141a:	2781                	sext.w	a5,a5
    8000141c:	079e                	slli	a5,a5,0x7
    8000141e:	00008717          	auipc	a4,0x8
    80001422:	c3270713          	addi	a4,a4,-974 # 80009050 <pid_lock>
    80001426:	97ba                	add	a5,a5,a4
    80001428:	0a87a703          	lw	a4,168(a5)
    8000142c:	4785                	li	a5,1
    8000142e:	06f71763          	bne	a4,a5,8000149c <sched+0xa6>
  if(p->state == RUNNING)
    80001432:	4c98                	lw	a4,24(s1)
    80001434:	4791                	li	a5,4
    80001436:	06f70b63          	beq	a4,a5,800014ac <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000143a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000143e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001440:	efb5                	bnez	a5,800014bc <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001442:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001444:	00008917          	auipc	s2,0x8
    80001448:	c0c90913          	addi	s2,s2,-1012 # 80009050 <pid_lock>
    8000144c:	2781                	sext.w	a5,a5
    8000144e:	079e                	slli	a5,a5,0x7
    80001450:	97ca                	add	a5,a5,s2
    80001452:	0ac7a983          	lw	s3,172(a5)
    80001456:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001458:	2781                	sext.w	a5,a5
    8000145a:	079e                	slli	a5,a5,0x7
    8000145c:	00008597          	auipc	a1,0x8
    80001460:	c2c58593          	addi	a1,a1,-980 # 80009088 <cpus+0x8>
    80001464:	95be                	add	a1,a1,a5
    80001466:	06048513          	addi	a0,s1,96
    8000146a:	00000097          	auipc	ra,0x0
    8000146e:	59e080e7          	jalr	1438(ra) # 80001a08 <swtch>
    80001472:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001474:	2781                	sext.w	a5,a5
    80001476:	079e                	slli	a5,a5,0x7
    80001478:	993e                	add	s2,s2,a5
    8000147a:	0b392623          	sw	s3,172(s2)
}
    8000147e:	70a2                	ld	ra,40(sp)
    80001480:	7402                	ld	s0,32(sp)
    80001482:	64e2                	ld	s1,24(sp)
    80001484:	6942                	ld	s2,16(sp)
    80001486:	69a2                	ld	s3,8(sp)
    80001488:	6145                	addi	sp,sp,48
    8000148a:	8082                	ret
    panic("sched p->lock");
    8000148c:	00007517          	auipc	a0,0x7
    80001490:	d0c50513          	addi	a0,a0,-756 # 80008198 <etext+0x198>
    80001494:	00005097          	auipc	ra,0x5
    80001498:	92c080e7          	jalr	-1748(ra) # 80005dc0 <panic>
    panic("sched locks");
    8000149c:	00007517          	auipc	a0,0x7
    800014a0:	d0c50513          	addi	a0,a0,-756 # 800081a8 <etext+0x1a8>
    800014a4:	00005097          	auipc	ra,0x5
    800014a8:	91c080e7          	jalr	-1764(ra) # 80005dc0 <panic>
    panic("sched running");
    800014ac:	00007517          	auipc	a0,0x7
    800014b0:	d0c50513          	addi	a0,a0,-756 # 800081b8 <etext+0x1b8>
    800014b4:	00005097          	auipc	ra,0x5
    800014b8:	90c080e7          	jalr	-1780(ra) # 80005dc0 <panic>
    panic("sched interruptible");
    800014bc:	00007517          	auipc	a0,0x7
    800014c0:	d0c50513          	addi	a0,a0,-756 # 800081c8 <etext+0x1c8>
    800014c4:	00005097          	auipc	ra,0x5
    800014c8:	8fc080e7          	jalr	-1796(ra) # 80005dc0 <panic>

00000000800014cc <yield>:
{
    800014cc:	1101                	addi	sp,sp,-32
    800014ce:	ec06                	sd	ra,24(sp)
    800014d0:	e822                	sd	s0,16(sp)
    800014d2:	e426                	sd	s1,8(sp)
    800014d4:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800014d6:	00000097          	auipc	ra,0x0
    800014da:	96e080e7          	jalr	-1682(ra) # 80000e44 <myproc>
    800014de:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800014e0:	00005097          	auipc	ra,0x5
    800014e4:	e18080e7          	jalr	-488(ra) # 800062f8 <acquire>
  p->state = RUNNABLE;
    800014e8:	478d                	li	a5,3
    800014ea:	cc9c                	sw	a5,24(s1)
  sched();
    800014ec:	00000097          	auipc	ra,0x0
    800014f0:	f0a080e7          	jalr	-246(ra) # 800013f6 <sched>
  release(&p->lock);
    800014f4:	8526                	mv	a0,s1
    800014f6:	00005097          	auipc	ra,0x5
    800014fa:	eb6080e7          	jalr	-330(ra) # 800063ac <release>
}
    800014fe:	60e2                	ld	ra,24(sp)
    80001500:	6442                	ld	s0,16(sp)
    80001502:	64a2                	ld	s1,8(sp)
    80001504:	6105                	addi	sp,sp,32
    80001506:	8082                	ret

0000000080001508 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001508:	7179                	addi	sp,sp,-48
    8000150a:	f406                	sd	ra,40(sp)
    8000150c:	f022                	sd	s0,32(sp)
    8000150e:	ec26                	sd	s1,24(sp)
    80001510:	e84a                	sd	s2,16(sp)
    80001512:	e44e                	sd	s3,8(sp)
    80001514:	1800                	addi	s0,sp,48
    80001516:	89aa                	mv	s3,a0
    80001518:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000151a:	00000097          	auipc	ra,0x0
    8000151e:	92a080e7          	jalr	-1750(ra) # 80000e44 <myproc>
    80001522:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001524:	00005097          	auipc	ra,0x5
    80001528:	dd4080e7          	jalr	-556(ra) # 800062f8 <acquire>
  release(lk);
    8000152c:	854a                	mv	a0,s2
    8000152e:	00005097          	auipc	ra,0x5
    80001532:	e7e080e7          	jalr	-386(ra) # 800063ac <release>

  // Go to sleep.
  p->chan = chan;
    80001536:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000153a:	4789                	li	a5,2
    8000153c:	cc9c                	sw	a5,24(s1)

  sched();
    8000153e:	00000097          	auipc	ra,0x0
    80001542:	eb8080e7          	jalr	-328(ra) # 800013f6 <sched>

  // Tidy up.
  p->chan = 0;
    80001546:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000154a:	8526                	mv	a0,s1
    8000154c:	00005097          	auipc	ra,0x5
    80001550:	e60080e7          	jalr	-416(ra) # 800063ac <release>
  acquire(lk);
    80001554:	854a                	mv	a0,s2
    80001556:	00005097          	auipc	ra,0x5
    8000155a:	da2080e7          	jalr	-606(ra) # 800062f8 <acquire>
}
    8000155e:	70a2                	ld	ra,40(sp)
    80001560:	7402                	ld	s0,32(sp)
    80001562:	64e2                	ld	s1,24(sp)
    80001564:	6942                	ld	s2,16(sp)
    80001566:	69a2                	ld	s3,8(sp)
    80001568:	6145                	addi	sp,sp,48
    8000156a:	8082                	ret

000000008000156c <wait>:
{
    8000156c:	715d                	addi	sp,sp,-80
    8000156e:	e486                	sd	ra,72(sp)
    80001570:	e0a2                	sd	s0,64(sp)
    80001572:	fc26                	sd	s1,56(sp)
    80001574:	f84a                	sd	s2,48(sp)
    80001576:	f44e                	sd	s3,40(sp)
    80001578:	f052                	sd	s4,32(sp)
    8000157a:	ec56                	sd	s5,24(sp)
    8000157c:	e85a                	sd	s6,16(sp)
    8000157e:	e45e                	sd	s7,8(sp)
    80001580:	e062                	sd	s8,0(sp)
    80001582:	0880                	addi	s0,sp,80
    80001584:	8aaa                	mv	s5,a0
  struct proc *p = myproc();
    80001586:	00000097          	auipc	ra,0x0
    8000158a:	8be080e7          	jalr	-1858(ra) # 80000e44 <myproc>
    8000158e:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001590:	00008517          	auipc	a0,0x8
    80001594:	ad850513          	addi	a0,a0,-1320 # 80009068 <wait_lock>
    80001598:	00005097          	auipc	ra,0x5
    8000159c:	d60080e7          	jalr	-672(ra) # 800062f8 <acquire>
    havekids = 0;
    800015a0:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800015a2:	4a15                	li	s4,5
        havekids = 1;
    800015a4:	4b05                	li	s6,1
    for(np = proc; np < &proc[NPROC]; np++){
    800015a6:	00009997          	auipc	s3,0x9
    800015aa:	cea98993          	addi	s3,s3,-790 # 8000a290 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015ae:	00008c17          	auipc	s8,0x8
    800015b2:	abac0c13          	addi	s8,s8,-1350 # 80009068 <wait_lock>
    havekids = 0;
    800015b6:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800015b8:	00008497          	auipc	s1,0x8
    800015bc:	ec848493          	addi	s1,s1,-312 # 80009480 <proc>
    800015c0:	a0bd                	j	8000162e <wait+0xc2>
          pid = np->pid;
    800015c2:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800015c6:	000a8e63          	beqz	s5,800015e2 <wait+0x76>
    800015ca:	4691                	li	a3,4
    800015cc:	02c48613          	addi	a2,s1,44
    800015d0:	85d6                	mv	a1,s5
    800015d2:	05093503          	ld	a0,80(s2)
    800015d6:	fffff097          	auipc	ra,0xfffff
    800015da:	532080e7          	jalr	1330(ra) # 80000b08 <copyout>
    800015de:	02054563          	bltz	a0,80001608 <wait+0x9c>
          freeproc(np);
    800015e2:	8526                	mv	a0,s1
    800015e4:	00000097          	auipc	ra,0x0
    800015e8:	a12080e7          	jalr	-1518(ra) # 80000ff6 <freeproc>
          release(&np->lock);
    800015ec:	8526                	mv	a0,s1
    800015ee:	00005097          	auipc	ra,0x5
    800015f2:	dbe080e7          	jalr	-578(ra) # 800063ac <release>
          release(&wait_lock);
    800015f6:	00008517          	auipc	a0,0x8
    800015fa:	a7250513          	addi	a0,a0,-1422 # 80009068 <wait_lock>
    800015fe:	00005097          	auipc	ra,0x5
    80001602:	dae080e7          	jalr	-594(ra) # 800063ac <release>
          return pid;
    80001606:	a09d                	j	8000166c <wait+0x100>
            release(&np->lock);
    80001608:	8526                	mv	a0,s1
    8000160a:	00005097          	auipc	ra,0x5
    8000160e:	da2080e7          	jalr	-606(ra) # 800063ac <release>
            release(&wait_lock);
    80001612:	00008517          	auipc	a0,0x8
    80001616:	a5650513          	addi	a0,a0,-1450 # 80009068 <wait_lock>
    8000161a:	00005097          	auipc	ra,0x5
    8000161e:	d92080e7          	jalr	-622(ra) # 800063ac <release>
            return -1;
    80001622:	59fd                	li	s3,-1
    80001624:	a0a1                	j	8000166c <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    80001626:	16848493          	addi	s1,s1,360
    8000162a:	03348463          	beq	s1,s3,80001652 <wait+0xe6>
      if(np->parent == p){
    8000162e:	7c9c                	ld	a5,56(s1)
    80001630:	ff279be3          	bne	a5,s2,80001626 <wait+0xba>
        acquire(&np->lock);
    80001634:	8526                	mv	a0,s1
    80001636:	00005097          	auipc	ra,0x5
    8000163a:	cc2080e7          	jalr	-830(ra) # 800062f8 <acquire>
        if(np->state == ZOMBIE){
    8000163e:	4c9c                	lw	a5,24(s1)
    80001640:	f94781e3          	beq	a5,s4,800015c2 <wait+0x56>
        release(&np->lock);
    80001644:	8526                	mv	a0,s1
    80001646:	00005097          	auipc	ra,0x5
    8000164a:	d66080e7          	jalr	-666(ra) # 800063ac <release>
        havekids = 1;
    8000164e:	875a                	mv	a4,s6
    80001650:	bfd9                	j	80001626 <wait+0xba>
    if(!havekids || p->killed){
    80001652:	c701                	beqz	a4,8000165a <wait+0xee>
    80001654:	02892783          	lw	a5,40(s2)
    80001658:	c79d                	beqz	a5,80001686 <wait+0x11a>
      release(&wait_lock);
    8000165a:	00008517          	auipc	a0,0x8
    8000165e:	a0e50513          	addi	a0,a0,-1522 # 80009068 <wait_lock>
    80001662:	00005097          	auipc	ra,0x5
    80001666:	d4a080e7          	jalr	-694(ra) # 800063ac <release>
      return -1;
    8000166a:	59fd                	li	s3,-1
}
    8000166c:	854e                	mv	a0,s3
    8000166e:	60a6                	ld	ra,72(sp)
    80001670:	6406                	ld	s0,64(sp)
    80001672:	74e2                	ld	s1,56(sp)
    80001674:	7942                	ld	s2,48(sp)
    80001676:	79a2                	ld	s3,40(sp)
    80001678:	7a02                	ld	s4,32(sp)
    8000167a:	6ae2                	ld	s5,24(sp)
    8000167c:	6b42                	ld	s6,16(sp)
    8000167e:	6ba2                	ld	s7,8(sp)
    80001680:	6c02                	ld	s8,0(sp)
    80001682:	6161                	addi	sp,sp,80
    80001684:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001686:	85e2                	mv	a1,s8
    80001688:	854a                	mv	a0,s2
    8000168a:	00000097          	auipc	ra,0x0
    8000168e:	e7e080e7          	jalr	-386(ra) # 80001508 <sleep>
    havekids = 0;
    80001692:	b715                	j	800015b6 <wait+0x4a>

0000000080001694 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001694:	7139                	addi	sp,sp,-64
    80001696:	fc06                	sd	ra,56(sp)
    80001698:	f822                	sd	s0,48(sp)
    8000169a:	f426                	sd	s1,40(sp)
    8000169c:	f04a                	sd	s2,32(sp)
    8000169e:	ec4e                	sd	s3,24(sp)
    800016a0:	e852                	sd	s4,16(sp)
    800016a2:	e456                	sd	s5,8(sp)
    800016a4:	0080                	addi	s0,sp,64
    800016a6:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800016a8:	00008497          	auipc	s1,0x8
    800016ac:	dd848493          	addi	s1,s1,-552 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800016b0:	4989                	li	s3,2
        p->state = RUNNABLE;
    800016b2:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800016b4:	00009917          	auipc	s2,0x9
    800016b8:	bdc90913          	addi	s2,s2,-1060 # 8000a290 <tickslock>
    800016bc:	a811                	j	800016d0 <wakeup+0x3c>
      }
      release(&p->lock);
    800016be:	8526                	mv	a0,s1
    800016c0:	00005097          	auipc	ra,0x5
    800016c4:	cec080e7          	jalr	-788(ra) # 800063ac <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800016c8:	16848493          	addi	s1,s1,360
    800016cc:	03248663          	beq	s1,s2,800016f8 <wakeup+0x64>
    if(p != myproc()){
    800016d0:	fffff097          	auipc	ra,0xfffff
    800016d4:	774080e7          	jalr	1908(ra) # 80000e44 <myproc>
    800016d8:	fea488e3          	beq	s1,a0,800016c8 <wakeup+0x34>
      acquire(&p->lock);
    800016dc:	8526                	mv	a0,s1
    800016de:	00005097          	auipc	ra,0x5
    800016e2:	c1a080e7          	jalr	-998(ra) # 800062f8 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800016e6:	4c9c                	lw	a5,24(s1)
    800016e8:	fd379be3          	bne	a5,s3,800016be <wakeup+0x2a>
    800016ec:	709c                	ld	a5,32(s1)
    800016ee:	fd4798e3          	bne	a5,s4,800016be <wakeup+0x2a>
        p->state = RUNNABLE;
    800016f2:	0154ac23          	sw	s5,24(s1)
    800016f6:	b7e1                	j	800016be <wakeup+0x2a>
    }
  }
}
    800016f8:	70e2                	ld	ra,56(sp)
    800016fa:	7442                	ld	s0,48(sp)
    800016fc:	74a2                	ld	s1,40(sp)
    800016fe:	7902                	ld	s2,32(sp)
    80001700:	69e2                	ld	s3,24(sp)
    80001702:	6a42                	ld	s4,16(sp)
    80001704:	6aa2                	ld	s5,8(sp)
    80001706:	6121                	addi	sp,sp,64
    80001708:	8082                	ret

000000008000170a <reparent>:
{
    8000170a:	7179                	addi	sp,sp,-48
    8000170c:	f406                	sd	ra,40(sp)
    8000170e:	f022                	sd	s0,32(sp)
    80001710:	ec26                	sd	s1,24(sp)
    80001712:	e84a                	sd	s2,16(sp)
    80001714:	e44e                	sd	s3,8(sp)
    80001716:	e052                	sd	s4,0(sp)
    80001718:	1800                	addi	s0,sp,48
    8000171a:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000171c:	00008497          	auipc	s1,0x8
    80001720:	d6448493          	addi	s1,s1,-668 # 80009480 <proc>
      pp->parent = initproc;
    80001724:	00008a17          	auipc	s4,0x8
    80001728:	8eca0a13          	addi	s4,s4,-1812 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000172c:	00009997          	auipc	s3,0x9
    80001730:	b6498993          	addi	s3,s3,-1180 # 8000a290 <tickslock>
    80001734:	a029                	j	8000173e <reparent+0x34>
    80001736:	16848493          	addi	s1,s1,360
    8000173a:	01348d63          	beq	s1,s3,80001754 <reparent+0x4a>
    if(pp->parent == p){
    8000173e:	7c9c                	ld	a5,56(s1)
    80001740:	ff279be3          	bne	a5,s2,80001736 <reparent+0x2c>
      pp->parent = initproc;
    80001744:	000a3503          	ld	a0,0(s4)
    80001748:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000174a:	00000097          	auipc	ra,0x0
    8000174e:	f4a080e7          	jalr	-182(ra) # 80001694 <wakeup>
    80001752:	b7d5                	j	80001736 <reparent+0x2c>
}
    80001754:	70a2                	ld	ra,40(sp)
    80001756:	7402                	ld	s0,32(sp)
    80001758:	64e2                	ld	s1,24(sp)
    8000175a:	6942                	ld	s2,16(sp)
    8000175c:	69a2                	ld	s3,8(sp)
    8000175e:	6a02                	ld	s4,0(sp)
    80001760:	6145                	addi	sp,sp,48
    80001762:	8082                	ret

0000000080001764 <exit>:
{
    80001764:	7179                	addi	sp,sp,-48
    80001766:	f406                	sd	ra,40(sp)
    80001768:	f022                	sd	s0,32(sp)
    8000176a:	ec26                	sd	s1,24(sp)
    8000176c:	e84a                	sd	s2,16(sp)
    8000176e:	e44e                	sd	s3,8(sp)
    80001770:	e052                	sd	s4,0(sp)
    80001772:	1800                	addi	s0,sp,48
    80001774:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001776:	fffff097          	auipc	ra,0xfffff
    8000177a:	6ce080e7          	jalr	1742(ra) # 80000e44 <myproc>
    8000177e:	89aa                	mv	s3,a0
  if(p == initproc)
    80001780:	00008797          	auipc	a5,0x8
    80001784:	8907b783          	ld	a5,-1904(a5) # 80009010 <initproc>
    80001788:	0d050493          	addi	s1,a0,208
    8000178c:	15050913          	addi	s2,a0,336
    80001790:	02a79363          	bne	a5,a0,800017b6 <exit+0x52>
    panic("init exiting");
    80001794:	00007517          	auipc	a0,0x7
    80001798:	a4c50513          	addi	a0,a0,-1460 # 800081e0 <etext+0x1e0>
    8000179c:	00004097          	auipc	ra,0x4
    800017a0:	624080e7          	jalr	1572(ra) # 80005dc0 <panic>
      fileclose(f);
    800017a4:	00002097          	auipc	ra,0x2
    800017a8:	2e0080e7          	jalr	736(ra) # 80003a84 <fileclose>
      p->ofile[fd] = 0;
    800017ac:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800017b0:	04a1                	addi	s1,s1,8
    800017b2:	01248563          	beq	s1,s2,800017bc <exit+0x58>
    if(p->ofile[fd]){
    800017b6:	6088                	ld	a0,0(s1)
    800017b8:	f575                	bnez	a0,800017a4 <exit+0x40>
    800017ba:	bfdd                	j	800017b0 <exit+0x4c>
  begin_op();
    800017bc:	00002097          	auipc	ra,0x2
    800017c0:	e00080e7          	jalr	-512(ra) # 800035bc <begin_op>
  iput(p->cwd);
    800017c4:	1509b503          	ld	a0,336(s3)
    800017c8:	00001097          	auipc	ra,0x1
    800017cc:	5d0080e7          	jalr	1488(ra) # 80002d98 <iput>
  end_op();
    800017d0:	00002097          	auipc	ra,0x2
    800017d4:	e6a080e7          	jalr	-406(ra) # 8000363a <end_op>
  p->cwd = 0;
    800017d8:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800017dc:	00008497          	auipc	s1,0x8
    800017e0:	88c48493          	addi	s1,s1,-1908 # 80009068 <wait_lock>
    800017e4:	8526                	mv	a0,s1
    800017e6:	00005097          	auipc	ra,0x5
    800017ea:	b12080e7          	jalr	-1262(ra) # 800062f8 <acquire>
  reparent(p);
    800017ee:	854e                	mv	a0,s3
    800017f0:	00000097          	auipc	ra,0x0
    800017f4:	f1a080e7          	jalr	-230(ra) # 8000170a <reparent>
  wakeup(p->parent);
    800017f8:	0389b503          	ld	a0,56(s3)
    800017fc:	00000097          	auipc	ra,0x0
    80001800:	e98080e7          	jalr	-360(ra) # 80001694 <wakeup>
  acquire(&p->lock);
    80001804:	854e                	mv	a0,s3
    80001806:	00005097          	auipc	ra,0x5
    8000180a:	af2080e7          	jalr	-1294(ra) # 800062f8 <acquire>
  p->xstate = status;
    8000180e:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001812:	4795                	li	a5,5
    80001814:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001818:	8526                	mv	a0,s1
    8000181a:	00005097          	auipc	ra,0x5
    8000181e:	b92080e7          	jalr	-1134(ra) # 800063ac <release>
  sched();
    80001822:	00000097          	auipc	ra,0x0
    80001826:	bd4080e7          	jalr	-1068(ra) # 800013f6 <sched>
  panic("zombie exit");
    8000182a:	00007517          	auipc	a0,0x7
    8000182e:	9c650513          	addi	a0,a0,-1594 # 800081f0 <etext+0x1f0>
    80001832:	00004097          	auipc	ra,0x4
    80001836:	58e080e7          	jalr	1422(ra) # 80005dc0 <panic>

000000008000183a <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000183a:	7179                	addi	sp,sp,-48
    8000183c:	f406                	sd	ra,40(sp)
    8000183e:	f022                	sd	s0,32(sp)
    80001840:	ec26                	sd	s1,24(sp)
    80001842:	e84a                	sd	s2,16(sp)
    80001844:	e44e                	sd	s3,8(sp)
    80001846:	1800                	addi	s0,sp,48
    80001848:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000184a:	00008497          	auipc	s1,0x8
    8000184e:	c3648493          	addi	s1,s1,-970 # 80009480 <proc>
    80001852:	00009997          	auipc	s3,0x9
    80001856:	a3e98993          	addi	s3,s3,-1474 # 8000a290 <tickslock>
    acquire(&p->lock);
    8000185a:	8526                	mv	a0,s1
    8000185c:	00005097          	auipc	ra,0x5
    80001860:	a9c080e7          	jalr	-1380(ra) # 800062f8 <acquire>
    if(p->pid == pid){
    80001864:	589c                	lw	a5,48(s1)
    80001866:	03278363          	beq	a5,s2,8000188c <kill+0x52>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000186a:	8526                	mv	a0,s1
    8000186c:	00005097          	auipc	ra,0x5
    80001870:	b40080e7          	jalr	-1216(ra) # 800063ac <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001874:	16848493          	addi	s1,s1,360
    80001878:	ff3491e3          	bne	s1,s3,8000185a <kill+0x20>
  }
  return -1;
    8000187c:	557d                	li	a0,-1
}
    8000187e:	70a2                	ld	ra,40(sp)
    80001880:	7402                	ld	s0,32(sp)
    80001882:	64e2                	ld	s1,24(sp)
    80001884:	6942                	ld	s2,16(sp)
    80001886:	69a2                	ld	s3,8(sp)
    80001888:	6145                	addi	sp,sp,48
    8000188a:	8082                	ret
      p->killed = 1;
    8000188c:	4785                	li	a5,1
    8000188e:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001890:	4c98                	lw	a4,24(s1)
    80001892:	4789                	li	a5,2
    80001894:	00f70963          	beq	a4,a5,800018a6 <kill+0x6c>
      release(&p->lock);
    80001898:	8526                	mv	a0,s1
    8000189a:	00005097          	auipc	ra,0x5
    8000189e:	b12080e7          	jalr	-1262(ra) # 800063ac <release>
      return 0;
    800018a2:	4501                	li	a0,0
    800018a4:	bfe9                	j	8000187e <kill+0x44>
        p->state = RUNNABLE;
    800018a6:	478d                	li	a5,3
    800018a8:	cc9c                	sw	a5,24(s1)
    800018aa:	b7fd                	j	80001898 <kill+0x5e>

00000000800018ac <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800018ac:	7179                	addi	sp,sp,-48
    800018ae:	f406                	sd	ra,40(sp)
    800018b0:	f022                	sd	s0,32(sp)
    800018b2:	ec26                	sd	s1,24(sp)
    800018b4:	e84a                	sd	s2,16(sp)
    800018b6:	e44e                	sd	s3,8(sp)
    800018b8:	e052                	sd	s4,0(sp)
    800018ba:	1800                	addi	s0,sp,48
    800018bc:	84aa                	mv	s1,a0
    800018be:	892e                	mv	s2,a1
    800018c0:	89b2                	mv	s3,a2
    800018c2:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800018c4:	fffff097          	auipc	ra,0xfffff
    800018c8:	580080e7          	jalr	1408(ra) # 80000e44 <myproc>
  if(user_dst){
    800018cc:	c08d                	beqz	s1,800018ee <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800018ce:	86d2                	mv	a3,s4
    800018d0:	864e                	mv	a2,s3
    800018d2:	85ca                	mv	a1,s2
    800018d4:	6928                	ld	a0,80(a0)
    800018d6:	fffff097          	auipc	ra,0xfffff
    800018da:	232080e7          	jalr	562(ra) # 80000b08 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800018de:	70a2                	ld	ra,40(sp)
    800018e0:	7402                	ld	s0,32(sp)
    800018e2:	64e2                	ld	s1,24(sp)
    800018e4:	6942                	ld	s2,16(sp)
    800018e6:	69a2                	ld	s3,8(sp)
    800018e8:	6a02                	ld	s4,0(sp)
    800018ea:	6145                	addi	sp,sp,48
    800018ec:	8082                	ret
    memmove((char *)dst, src, len);
    800018ee:	000a061b          	sext.w	a2,s4
    800018f2:	85ce                	mv	a1,s3
    800018f4:	854a                	mv	a0,s2
    800018f6:	fffff097          	auipc	ra,0xfffff
    800018fa:	8e0080e7          	jalr	-1824(ra) # 800001d6 <memmove>
    return 0;
    800018fe:	8526                	mv	a0,s1
    80001900:	bff9                	j	800018de <either_copyout+0x32>

0000000080001902 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001902:	7179                	addi	sp,sp,-48
    80001904:	f406                	sd	ra,40(sp)
    80001906:	f022                	sd	s0,32(sp)
    80001908:	ec26                	sd	s1,24(sp)
    8000190a:	e84a                	sd	s2,16(sp)
    8000190c:	e44e                	sd	s3,8(sp)
    8000190e:	e052                	sd	s4,0(sp)
    80001910:	1800                	addi	s0,sp,48
    80001912:	892a                	mv	s2,a0
    80001914:	84ae                	mv	s1,a1
    80001916:	89b2                	mv	s3,a2
    80001918:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000191a:	fffff097          	auipc	ra,0xfffff
    8000191e:	52a080e7          	jalr	1322(ra) # 80000e44 <myproc>
  if(user_src){
    80001922:	c08d                	beqz	s1,80001944 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001924:	86d2                	mv	a3,s4
    80001926:	864e                	mv	a2,s3
    80001928:	85ca                	mv	a1,s2
    8000192a:	6928                	ld	a0,80(a0)
    8000192c:	fffff097          	auipc	ra,0xfffff
    80001930:	268080e7          	jalr	616(ra) # 80000b94 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001934:	70a2                	ld	ra,40(sp)
    80001936:	7402                	ld	s0,32(sp)
    80001938:	64e2                	ld	s1,24(sp)
    8000193a:	6942                	ld	s2,16(sp)
    8000193c:	69a2                	ld	s3,8(sp)
    8000193e:	6a02                	ld	s4,0(sp)
    80001940:	6145                	addi	sp,sp,48
    80001942:	8082                	ret
    memmove(dst, (char*)src, len);
    80001944:	000a061b          	sext.w	a2,s4
    80001948:	85ce                	mv	a1,s3
    8000194a:	854a                	mv	a0,s2
    8000194c:	fffff097          	auipc	ra,0xfffff
    80001950:	88a080e7          	jalr	-1910(ra) # 800001d6 <memmove>
    return 0;
    80001954:	8526                	mv	a0,s1
    80001956:	bff9                	j	80001934 <either_copyin+0x32>

0000000080001958 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001958:	715d                	addi	sp,sp,-80
    8000195a:	e486                	sd	ra,72(sp)
    8000195c:	e0a2                	sd	s0,64(sp)
    8000195e:	fc26                	sd	s1,56(sp)
    80001960:	f84a                	sd	s2,48(sp)
    80001962:	f44e                	sd	s3,40(sp)
    80001964:	f052                	sd	s4,32(sp)
    80001966:	ec56                	sd	s5,24(sp)
    80001968:	e85a                	sd	s6,16(sp)
    8000196a:	e45e                	sd	s7,8(sp)
    8000196c:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000196e:	00006517          	auipc	a0,0x6
    80001972:	6da50513          	addi	a0,a0,1754 # 80008048 <etext+0x48>
    80001976:	00004097          	auipc	ra,0x4
    8000197a:	494080e7          	jalr	1172(ra) # 80005e0a <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000197e:	00008497          	auipc	s1,0x8
    80001982:	c5a48493          	addi	s1,s1,-934 # 800095d8 <proc+0x158>
    80001986:	00009917          	auipc	s2,0x9
    8000198a:	a6290913          	addi	s2,s2,-1438 # 8000a3e8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000198e:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001990:	00007997          	auipc	s3,0x7
    80001994:	87098993          	addi	s3,s3,-1936 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    80001998:	00007a97          	auipc	s5,0x7
    8000199c:	870a8a93          	addi	s5,s5,-1936 # 80008208 <etext+0x208>
    printf("\n");
    800019a0:	00006a17          	auipc	s4,0x6
    800019a4:	6a8a0a13          	addi	s4,s4,1704 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019a8:	00007b97          	auipc	s7,0x7
    800019ac:	898b8b93          	addi	s7,s7,-1896 # 80008240 <states.0>
    800019b0:	a00d                	j	800019d2 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800019b2:	ed86a583          	lw	a1,-296(a3)
    800019b6:	8556                	mv	a0,s5
    800019b8:	00004097          	auipc	ra,0x4
    800019bc:	452080e7          	jalr	1106(ra) # 80005e0a <printf>
    printf("\n");
    800019c0:	8552                	mv	a0,s4
    800019c2:	00004097          	auipc	ra,0x4
    800019c6:	448080e7          	jalr	1096(ra) # 80005e0a <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019ca:	16848493          	addi	s1,s1,360
    800019ce:	03248263          	beq	s1,s2,800019f2 <procdump+0x9a>
    if(p->state == UNUSED)
    800019d2:	86a6                	mv	a3,s1
    800019d4:	ec04a783          	lw	a5,-320(s1)
    800019d8:	dbed                	beqz	a5,800019ca <procdump+0x72>
      state = "???";
    800019da:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019dc:	fcfb6be3          	bltu	s6,a5,800019b2 <procdump+0x5a>
    800019e0:	02079713          	slli	a4,a5,0x20
    800019e4:	01d75793          	srli	a5,a4,0x1d
    800019e8:	97de                	add	a5,a5,s7
    800019ea:	6390                	ld	a2,0(a5)
    800019ec:	f279                	bnez	a2,800019b2 <procdump+0x5a>
      state = "???";
    800019ee:	864e                	mv	a2,s3
    800019f0:	b7c9                	j	800019b2 <procdump+0x5a>
  }
}
    800019f2:	60a6                	ld	ra,72(sp)
    800019f4:	6406                	ld	s0,64(sp)
    800019f6:	74e2                	ld	s1,56(sp)
    800019f8:	7942                	ld	s2,48(sp)
    800019fa:	79a2                	ld	s3,40(sp)
    800019fc:	7a02                	ld	s4,32(sp)
    800019fe:	6ae2                	ld	s5,24(sp)
    80001a00:	6b42                	ld	s6,16(sp)
    80001a02:	6ba2                	ld	s7,8(sp)
    80001a04:	6161                	addi	sp,sp,80
    80001a06:	8082                	ret

0000000080001a08 <swtch>:
    80001a08:	00153023          	sd	ra,0(a0)
    80001a0c:	00253423          	sd	sp,8(a0)
    80001a10:	e900                	sd	s0,16(a0)
    80001a12:	ed04                	sd	s1,24(a0)
    80001a14:	03253023          	sd	s2,32(a0)
    80001a18:	03353423          	sd	s3,40(a0)
    80001a1c:	03453823          	sd	s4,48(a0)
    80001a20:	03553c23          	sd	s5,56(a0)
    80001a24:	05653023          	sd	s6,64(a0)
    80001a28:	05753423          	sd	s7,72(a0)
    80001a2c:	05853823          	sd	s8,80(a0)
    80001a30:	05953c23          	sd	s9,88(a0)
    80001a34:	07a53023          	sd	s10,96(a0)
    80001a38:	07b53423          	sd	s11,104(a0)
    80001a3c:	0005b083          	ld	ra,0(a1)
    80001a40:	0085b103          	ld	sp,8(a1)
    80001a44:	6980                	ld	s0,16(a1)
    80001a46:	6d84                	ld	s1,24(a1)
    80001a48:	0205b903          	ld	s2,32(a1)
    80001a4c:	0285b983          	ld	s3,40(a1)
    80001a50:	0305ba03          	ld	s4,48(a1)
    80001a54:	0385ba83          	ld	s5,56(a1)
    80001a58:	0405bb03          	ld	s6,64(a1)
    80001a5c:	0485bb83          	ld	s7,72(a1)
    80001a60:	0505bc03          	ld	s8,80(a1)
    80001a64:	0585bc83          	ld	s9,88(a1)
    80001a68:	0605bd03          	ld	s10,96(a1)
    80001a6c:	0685bd83          	ld	s11,104(a1)
    80001a70:	8082                	ret

0000000080001a72 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001a72:	1141                	addi	sp,sp,-16
    80001a74:	e406                	sd	ra,8(sp)
    80001a76:	e022                	sd	s0,0(sp)
    80001a78:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001a7a:	00006597          	auipc	a1,0x6
    80001a7e:	7f658593          	addi	a1,a1,2038 # 80008270 <states.0+0x30>
    80001a82:	00009517          	auipc	a0,0x9
    80001a86:	80e50513          	addi	a0,a0,-2034 # 8000a290 <tickslock>
    80001a8a:	00004097          	auipc	ra,0x4
    80001a8e:	7de080e7          	jalr	2014(ra) # 80006268 <initlock>
}
    80001a92:	60a2                	ld	ra,8(sp)
    80001a94:	6402                	ld	s0,0(sp)
    80001a96:	0141                	addi	sp,sp,16
    80001a98:	8082                	ret

0000000080001a9a <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001a9a:	1141                	addi	sp,sp,-16
    80001a9c:	e422                	sd	s0,8(sp)
    80001a9e:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001aa0:	00003797          	auipc	a5,0x3
    80001aa4:	78078793          	addi	a5,a5,1920 # 80005220 <kernelvec>
    80001aa8:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001aac:	6422                	ld	s0,8(sp)
    80001aae:	0141                	addi	sp,sp,16
    80001ab0:	8082                	ret

0000000080001ab2 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001ab2:	1141                	addi	sp,sp,-16
    80001ab4:	e406                	sd	ra,8(sp)
    80001ab6:	e022                	sd	s0,0(sp)
    80001ab8:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001aba:	fffff097          	auipc	ra,0xfffff
    80001abe:	38a080e7          	jalr	906(ra) # 80000e44 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ac2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001ac6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ac8:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001acc:	00005697          	auipc	a3,0x5
    80001ad0:	53468693          	addi	a3,a3,1332 # 80007000 <_trampoline>
    80001ad4:	00005717          	auipc	a4,0x5
    80001ad8:	52c70713          	addi	a4,a4,1324 # 80007000 <_trampoline>
    80001adc:	8f15                	sub	a4,a4,a3
    80001ade:	040007b7          	lui	a5,0x4000
    80001ae2:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001ae4:	07b2                	slli	a5,a5,0xc
    80001ae6:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ae8:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001aec:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001aee:	18002673          	csrr	a2,satp
    80001af2:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001af4:	6d30                	ld	a2,88(a0)
    80001af6:	6138                	ld	a4,64(a0)
    80001af8:	6585                	lui	a1,0x1
    80001afa:	972e                	add	a4,a4,a1
    80001afc:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001afe:	6d38                	ld	a4,88(a0)
    80001b00:	00000617          	auipc	a2,0x0
    80001b04:	13860613          	addi	a2,a2,312 # 80001c38 <usertrap>
    80001b08:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b0a:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b0c:	8612                	mv	a2,tp
    80001b0e:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b10:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b14:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b18:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b1c:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001b20:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b22:	6f18                	ld	a4,24(a4)
    80001b24:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b28:	692c                	ld	a1,80(a0)
    80001b2a:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001b2c:	00005717          	auipc	a4,0x5
    80001b30:	56470713          	addi	a4,a4,1380 # 80007090 <userret>
    80001b34:	8f15                	sub	a4,a4,a3
    80001b36:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001b38:	577d                	li	a4,-1
    80001b3a:	177e                	slli	a4,a4,0x3f
    80001b3c:	8dd9                	or	a1,a1,a4
    80001b3e:	02000537          	lui	a0,0x2000
    80001b42:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001b44:	0536                	slli	a0,a0,0xd
    80001b46:	9782                	jalr	a5
}
    80001b48:	60a2                	ld	ra,8(sp)
    80001b4a:	6402                	ld	s0,0(sp)
    80001b4c:	0141                	addi	sp,sp,16
    80001b4e:	8082                	ret

0000000080001b50 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001b50:	1101                	addi	sp,sp,-32
    80001b52:	ec06                	sd	ra,24(sp)
    80001b54:	e822                	sd	s0,16(sp)
    80001b56:	e426                	sd	s1,8(sp)
    80001b58:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001b5a:	00008497          	auipc	s1,0x8
    80001b5e:	73648493          	addi	s1,s1,1846 # 8000a290 <tickslock>
    80001b62:	8526                	mv	a0,s1
    80001b64:	00004097          	auipc	ra,0x4
    80001b68:	794080e7          	jalr	1940(ra) # 800062f8 <acquire>
  ticks++;
    80001b6c:	00007517          	auipc	a0,0x7
    80001b70:	4ac50513          	addi	a0,a0,1196 # 80009018 <ticks>
    80001b74:	411c                	lw	a5,0(a0)
    80001b76:	2785                	addiw	a5,a5,1
    80001b78:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001b7a:	00000097          	auipc	ra,0x0
    80001b7e:	b1a080e7          	jalr	-1254(ra) # 80001694 <wakeup>
  release(&tickslock);
    80001b82:	8526                	mv	a0,s1
    80001b84:	00005097          	auipc	ra,0x5
    80001b88:	828080e7          	jalr	-2008(ra) # 800063ac <release>
}
    80001b8c:	60e2                	ld	ra,24(sp)
    80001b8e:	6442                	ld	s0,16(sp)
    80001b90:	64a2                	ld	s1,8(sp)
    80001b92:	6105                	addi	sp,sp,32
    80001b94:	8082                	ret

0000000080001b96 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001b96:	1101                	addi	sp,sp,-32
    80001b98:	ec06                	sd	ra,24(sp)
    80001b9a:	e822                	sd	s0,16(sp)
    80001b9c:	e426                	sd	s1,8(sp)
    80001b9e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ba0:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001ba4:	00074d63          	bltz	a4,80001bbe <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001ba8:	57fd                	li	a5,-1
    80001baa:	17fe                	slli	a5,a5,0x3f
    80001bac:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001bae:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001bb0:	06f70363          	beq	a4,a5,80001c16 <devintr+0x80>
  }
}
    80001bb4:	60e2                	ld	ra,24(sp)
    80001bb6:	6442                	ld	s0,16(sp)
    80001bb8:	64a2                	ld	s1,8(sp)
    80001bba:	6105                	addi	sp,sp,32
    80001bbc:	8082                	ret
     (scause & 0xff) == 9){
    80001bbe:	0ff77793          	zext.b	a5,a4
  if((scause & 0x8000000000000000L) &&
    80001bc2:	46a5                	li	a3,9
    80001bc4:	fed792e3          	bne	a5,a3,80001ba8 <devintr+0x12>
    int irq = plic_claim();
    80001bc8:	00003097          	auipc	ra,0x3
    80001bcc:	760080e7          	jalr	1888(ra) # 80005328 <plic_claim>
    80001bd0:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001bd2:	47a9                	li	a5,10
    80001bd4:	02f50763          	beq	a0,a5,80001c02 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001bd8:	4785                	li	a5,1
    80001bda:	02f50963          	beq	a0,a5,80001c0c <devintr+0x76>
    return 1;
    80001bde:	4505                	li	a0,1
    } else if(irq){
    80001be0:	d8f1                	beqz	s1,80001bb4 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001be2:	85a6                	mv	a1,s1
    80001be4:	00006517          	auipc	a0,0x6
    80001be8:	69450513          	addi	a0,a0,1684 # 80008278 <states.0+0x38>
    80001bec:	00004097          	auipc	ra,0x4
    80001bf0:	21e080e7          	jalr	542(ra) # 80005e0a <printf>
      plic_complete(irq);
    80001bf4:	8526                	mv	a0,s1
    80001bf6:	00003097          	auipc	ra,0x3
    80001bfa:	756080e7          	jalr	1878(ra) # 8000534c <plic_complete>
    return 1;
    80001bfe:	4505                	li	a0,1
    80001c00:	bf55                	j	80001bb4 <devintr+0x1e>
      uartintr();
    80001c02:	00004097          	auipc	ra,0x4
    80001c06:	616080e7          	jalr	1558(ra) # 80006218 <uartintr>
    80001c0a:	b7ed                	j	80001bf4 <devintr+0x5e>
      virtio_disk_intr();
    80001c0c:	00004097          	auipc	ra,0x4
    80001c10:	bcc080e7          	jalr	-1076(ra) # 800057d8 <virtio_disk_intr>
    80001c14:	b7c5                	j	80001bf4 <devintr+0x5e>
    if(cpuid() == 0){
    80001c16:	fffff097          	auipc	ra,0xfffff
    80001c1a:	202080e7          	jalr	514(ra) # 80000e18 <cpuid>
    80001c1e:	c901                	beqz	a0,80001c2e <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001c20:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001c24:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001c26:	14479073          	csrw	sip,a5
    return 2;
    80001c2a:	4509                	li	a0,2
    80001c2c:	b761                	j	80001bb4 <devintr+0x1e>
      clockintr();
    80001c2e:	00000097          	auipc	ra,0x0
    80001c32:	f22080e7          	jalr	-222(ra) # 80001b50 <clockintr>
    80001c36:	b7ed                	j	80001c20 <devintr+0x8a>

0000000080001c38 <usertrap>:
{
    80001c38:	1101                	addi	sp,sp,-32
    80001c3a:	ec06                	sd	ra,24(sp)
    80001c3c:	e822                	sd	s0,16(sp)
    80001c3e:	e426                	sd	s1,8(sp)
    80001c40:	e04a                	sd	s2,0(sp)
    80001c42:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c44:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001c48:	1007f793          	andi	a5,a5,256
    80001c4c:	e3ad                	bnez	a5,80001cae <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c4e:	00003797          	auipc	a5,0x3
    80001c52:	5d278793          	addi	a5,a5,1490 # 80005220 <kernelvec>
    80001c56:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001c5a:	fffff097          	auipc	ra,0xfffff
    80001c5e:	1ea080e7          	jalr	490(ra) # 80000e44 <myproc>
    80001c62:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001c64:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001c66:	14102773          	csrr	a4,sepc
    80001c6a:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c6c:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001c70:	47a1                	li	a5,8
    80001c72:	04f71c63          	bne	a4,a5,80001cca <usertrap+0x92>
    if(p->killed)
    80001c76:	551c                	lw	a5,40(a0)
    80001c78:	e3b9                	bnez	a5,80001cbe <usertrap+0x86>
    p->trapframe->epc += 4;
    80001c7a:	6cb8                	ld	a4,88(s1)
    80001c7c:	6f1c                	ld	a5,24(a4)
    80001c7e:	0791                	addi	a5,a5,4
    80001c80:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c82:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001c86:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c8a:	10079073          	csrw	sstatus,a5
    syscall();
    80001c8e:	00000097          	auipc	ra,0x0
    80001c92:	2e0080e7          	jalr	736(ra) # 80001f6e <syscall>
  if(p->killed)
    80001c96:	549c                	lw	a5,40(s1)
    80001c98:	ebc1                	bnez	a5,80001d28 <usertrap+0xf0>
  usertrapret();
    80001c9a:	00000097          	auipc	ra,0x0
    80001c9e:	e18080e7          	jalr	-488(ra) # 80001ab2 <usertrapret>
}
    80001ca2:	60e2                	ld	ra,24(sp)
    80001ca4:	6442                	ld	s0,16(sp)
    80001ca6:	64a2                	ld	s1,8(sp)
    80001ca8:	6902                	ld	s2,0(sp)
    80001caa:	6105                	addi	sp,sp,32
    80001cac:	8082                	ret
    panic("usertrap: not from user mode");
    80001cae:	00006517          	auipc	a0,0x6
    80001cb2:	5ea50513          	addi	a0,a0,1514 # 80008298 <states.0+0x58>
    80001cb6:	00004097          	auipc	ra,0x4
    80001cba:	10a080e7          	jalr	266(ra) # 80005dc0 <panic>
      exit(-1);
    80001cbe:	557d                	li	a0,-1
    80001cc0:	00000097          	auipc	ra,0x0
    80001cc4:	aa4080e7          	jalr	-1372(ra) # 80001764 <exit>
    80001cc8:	bf4d                	j	80001c7a <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001cca:	00000097          	auipc	ra,0x0
    80001cce:	ecc080e7          	jalr	-308(ra) # 80001b96 <devintr>
    80001cd2:	892a                	mv	s2,a0
    80001cd4:	c501                	beqz	a0,80001cdc <usertrap+0xa4>
  if(p->killed)
    80001cd6:	549c                	lw	a5,40(s1)
    80001cd8:	c3a1                	beqz	a5,80001d18 <usertrap+0xe0>
    80001cda:	a815                	j	80001d0e <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cdc:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001ce0:	5890                	lw	a2,48(s1)
    80001ce2:	00006517          	auipc	a0,0x6
    80001ce6:	5d650513          	addi	a0,a0,1494 # 800082b8 <states.0+0x78>
    80001cea:	00004097          	auipc	ra,0x4
    80001cee:	120080e7          	jalr	288(ra) # 80005e0a <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001cf2:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001cf6:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001cfa:	00006517          	auipc	a0,0x6
    80001cfe:	5ee50513          	addi	a0,a0,1518 # 800082e8 <states.0+0xa8>
    80001d02:	00004097          	auipc	ra,0x4
    80001d06:	108080e7          	jalr	264(ra) # 80005e0a <printf>
    p->killed = 1;
    80001d0a:	4785                	li	a5,1
    80001d0c:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001d0e:	557d                	li	a0,-1
    80001d10:	00000097          	auipc	ra,0x0
    80001d14:	a54080e7          	jalr	-1452(ra) # 80001764 <exit>
  if(which_dev == 2)
    80001d18:	4789                	li	a5,2
    80001d1a:	f8f910e3          	bne	s2,a5,80001c9a <usertrap+0x62>
    yield();
    80001d1e:	fffff097          	auipc	ra,0xfffff
    80001d22:	7ae080e7          	jalr	1966(ra) # 800014cc <yield>
    80001d26:	bf95                	j	80001c9a <usertrap+0x62>
  int which_dev = 0;
    80001d28:	4901                	li	s2,0
    80001d2a:	b7d5                	j	80001d0e <usertrap+0xd6>

0000000080001d2c <kerneltrap>:
{
    80001d2c:	7179                	addi	sp,sp,-48
    80001d2e:	f406                	sd	ra,40(sp)
    80001d30:	f022                	sd	s0,32(sp)
    80001d32:	ec26                	sd	s1,24(sp)
    80001d34:	e84a                	sd	s2,16(sp)
    80001d36:	e44e                	sd	s3,8(sp)
    80001d38:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d3a:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d3e:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d42:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001d46:	1004f793          	andi	a5,s1,256
    80001d4a:	cb85                	beqz	a5,80001d7a <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d4c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001d50:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001d52:	ef85                	bnez	a5,80001d8a <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001d54:	00000097          	auipc	ra,0x0
    80001d58:	e42080e7          	jalr	-446(ra) # 80001b96 <devintr>
    80001d5c:	cd1d                	beqz	a0,80001d9a <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001d5e:	4789                	li	a5,2
    80001d60:	06f50a63          	beq	a0,a5,80001dd4 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001d64:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d68:	10049073          	csrw	sstatus,s1
}
    80001d6c:	70a2                	ld	ra,40(sp)
    80001d6e:	7402                	ld	s0,32(sp)
    80001d70:	64e2                	ld	s1,24(sp)
    80001d72:	6942                	ld	s2,16(sp)
    80001d74:	69a2                	ld	s3,8(sp)
    80001d76:	6145                	addi	sp,sp,48
    80001d78:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001d7a:	00006517          	auipc	a0,0x6
    80001d7e:	58e50513          	addi	a0,a0,1422 # 80008308 <states.0+0xc8>
    80001d82:	00004097          	auipc	ra,0x4
    80001d86:	03e080e7          	jalr	62(ra) # 80005dc0 <panic>
    panic("kerneltrap: interrupts enabled");
    80001d8a:	00006517          	auipc	a0,0x6
    80001d8e:	5a650513          	addi	a0,a0,1446 # 80008330 <states.0+0xf0>
    80001d92:	00004097          	auipc	ra,0x4
    80001d96:	02e080e7          	jalr	46(ra) # 80005dc0 <panic>
    printf("scause %p\n", scause);
    80001d9a:	85ce                	mv	a1,s3
    80001d9c:	00006517          	auipc	a0,0x6
    80001da0:	5b450513          	addi	a0,a0,1460 # 80008350 <states.0+0x110>
    80001da4:	00004097          	auipc	ra,0x4
    80001da8:	066080e7          	jalr	102(ra) # 80005e0a <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001dac:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001db0:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001db4:	00006517          	auipc	a0,0x6
    80001db8:	5ac50513          	addi	a0,a0,1452 # 80008360 <states.0+0x120>
    80001dbc:	00004097          	auipc	ra,0x4
    80001dc0:	04e080e7          	jalr	78(ra) # 80005e0a <printf>
    panic("kerneltrap");
    80001dc4:	00006517          	auipc	a0,0x6
    80001dc8:	5b450513          	addi	a0,a0,1460 # 80008378 <states.0+0x138>
    80001dcc:	00004097          	auipc	ra,0x4
    80001dd0:	ff4080e7          	jalr	-12(ra) # 80005dc0 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001dd4:	fffff097          	auipc	ra,0xfffff
    80001dd8:	070080e7          	jalr	112(ra) # 80000e44 <myproc>
    80001ddc:	d541                	beqz	a0,80001d64 <kerneltrap+0x38>
    80001dde:	fffff097          	auipc	ra,0xfffff
    80001de2:	066080e7          	jalr	102(ra) # 80000e44 <myproc>
    80001de6:	4d18                	lw	a4,24(a0)
    80001de8:	4791                	li	a5,4
    80001dea:	f6f71de3          	bne	a4,a5,80001d64 <kerneltrap+0x38>
    yield();
    80001dee:	fffff097          	auipc	ra,0xfffff
    80001df2:	6de080e7          	jalr	1758(ra) # 800014cc <yield>
    80001df6:	b7bd                	j	80001d64 <kerneltrap+0x38>

0000000080001df8 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001df8:	1101                	addi	sp,sp,-32
    80001dfa:	ec06                	sd	ra,24(sp)
    80001dfc:	e822                	sd	s0,16(sp)
    80001dfe:	e426                	sd	s1,8(sp)
    80001e00:	1000                	addi	s0,sp,32
    80001e02:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001e04:	fffff097          	auipc	ra,0xfffff
    80001e08:	040080e7          	jalr	64(ra) # 80000e44 <myproc>
  switch (n) {
    80001e0c:	4795                	li	a5,5
    80001e0e:	0497e163          	bltu	a5,s1,80001e50 <argraw+0x58>
    80001e12:	048a                	slli	s1,s1,0x2
    80001e14:	00006717          	auipc	a4,0x6
    80001e18:	59c70713          	addi	a4,a4,1436 # 800083b0 <states.0+0x170>
    80001e1c:	94ba                	add	s1,s1,a4
    80001e1e:	409c                	lw	a5,0(s1)
    80001e20:	97ba                	add	a5,a5,a4
    80001e22:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001e24:	6d3c                	ld	a5,88(a0)
    80001e26:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001e28:	60e2                	ld	ra,24(sp)
    80001e2a:	6442                	ld	s0,16(sp)
    80001e2c:	64a2                	ld	s1,8(sp)
    80001e2e:	6105                	addi	sp,sp,32
    80001e30:	8082                	ret
    return p->trapframe->a1;
    80001e32:	6d3c                	ld	a5,88(a0)
    80001e34:	7fa8                	ld	a0,120(a5)
    80001e36:	bfcd                	j	80001e28 <argraw+0x30>
    return p->trapframe->a2;
    80001e38:	6d3c                	ld	a5,88(a0)
    80001e3a:	63c8                	ld	a0,128(a5)
    80001e3c:	b7f5                	j	80001e28 <argraw+0x30>
    return p->trapframe->a3;
    80001e3e:	6d3c                	ld	a5,88(a0)
    80001e40:	67c8                	ld	a0,136(a5)
    80001e42:	b7dd                	j	80001e28 <argraw+0x30>
    return p->trapframe->a4;
    80001e44:	6d3c                	ld	a5,88(a0)
    80001e46:	6bc8                	ld	a0,144(a5)
    80001e48:	b7c5                	j	80001e28 <argraw+0x30>
    return p->trapframe->a5;
    80001e4a:	6d3c                	ld	a5,88(a0)
    80001e4c:	6fc8                	ld	a0,152(a5)
    80001e4e:	bfe9                	j	80001e28 <argraw+0x30>
  panic("argraw");
    80001e50:	00006517          	auipc	a0,0x6
    80001e54:	53850513          	addi	a0,a0,1336 # 80008388 <states.0+0x148>
    80001e58:	00004097          	auipc	ra,0x4
    80001e5c:	f68080e7          	jalr	-152(ra) # 80005dc0 <panic>

0000000080001e60 <fetchaddr>:
{
    80001e60:	1101                	addi	sp,sp,-32
    80001e62:	ec06                	sd	ra,24(sp)
    80001e64:	e822                	sd	s0,16(sp)
    80001e66:	e426                	sd	s1,8(sp)
    80001e68:	e04a                	sd	s2,0(sp)
    80001e6a:	1000                	addi	s0,sp,32
    80001e6c:	84aa                	mv	s1,a0
    80001e6e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001e70:	fffff097          	auipc	ra,0xfffff
    80001e74:	fd4080e7          	jalr	-44(ra) # 80000e44 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001e78:	653c                	ld	a5,72(a0)
    80001e7a:	02f4f863          	bgeu	s1,a5,80001eaa <fetchaddr+0x4a>
    80001e7e:	00848713          	addi	a4,s1,8
    80001e82:	02e7e663          	bltu	a5,a4,80001eae <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001e86:	46a1                	li	a3,8
    80001e88:	8626                	mv	a2,s1
    80001e8a:	85ca                	mv	a1,s2
    80001e8c:	6928                	ld	a0,80(a0)
    80001e8e:	fffff097          	auipc	ra,0xfffff
    80001e92:	d06080e7          	jalr	-762(ra) # 80000b94 <copyin>
    80001e96:	00a03533          	snez	a0,a0
    80001e9a:	40a00533          	neg	a0,a0
}
    80001e9e:	60e2                	ld	ra,24(sp)
    80001ea0:	6442                	ld	s0,16(sp)
    80001ea2:	64a2                	ld	s1,8(sp)
    80001ea4:	6902                	ld	s2,0(sp)
    80001ea6:	6105                	addi	sp,sp,32
    80001ea8:	8082                	ret
    return -1;
    80001eaa:	557d                	li	a0,-1
    80001eac:	bfcd                	j	80001e9e <fetchaddr+0x3e>
    80001eae:	557d                	li	a0,-1
    80001eb0:	b7fd                	j	80001e9e <fetchaddr+0x3e>

0000000080001eb2 <fetchstr>:
{
    80001eb2:	7179                	addi	sp,sp,-48
    80001eb4:	f406                	sd	ra,40(sp)
    80001eb6:	f022                	sd	s0,32(sp)
    80001eb8:	ec26                	sd	s1,24(sp)
    80001eba:	e84a                	sd	s2,16(sp)
    80001ebc:	e44e                	sd	s3,8(sp)
    80001ebe:	1800                	addi	s0,sp,48
    80001ec0:	892a                	mv	s2,a0
    80001ec2:	84ae                	mv	s1,a1
    80001ec4:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001ec6:	fffff097          	auipc	ra,0xfffff
    80001eca:	f7e080e7          	jalr	-130(ra) # 80000e44 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001ece:	86ce                	mv	a3,s3
    80001ed0:	864a                	mv	a2,s2
    80001ed2:	85a6                	mv	a1,s1
    80001ed4:	6928                	ld	a0,80(a0)
    80001ed6:	fffff097          	auipc	ra,0xfffff
    80001eda:	d4c080e7          	jalr	-692(ra) # 80000c22 <copyinstr>
  if(err < 0)
    80001ede:	00054763          	bltz	a0,80001eec <fetchstr+0x3a>
  return strlen(buf);
    80001ee2:	8526                	mv	a0,s1
    80001ee4:	ffffe097          	auipc	ra,0xffffe
    80001ee8:	412080e7          	jalr	1042(ra) # 800002f6 <strlen>
}
    80001eec:	70a2                	ld	ra,40(sp)
    80001eee:	7402                	ld	s0,32(sp)
    80001ef0:	64e2                	ld	s1,24(sp)
    80001ef2:	6942                	ld	s2,16(sp)
    80001ef4:	69a2                	ld	s3,8(sp)
    80001ef6:	6145                	addi	sp,sp,48
    80001ef8:	8082                	ret

0000000080001efa <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001efa:	1101                	addi	sp,sp,-32
    80001efc:	ec06                	sd	ra,24(sp)
    80001efe:	e822                	sd	s0,16(sp)
    80001f00:	e426                	sd	s1,8(sp)
    80001f02:	1000                	addi	s0,sp,32
    80001f04:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f06:	00000097          	auipc	ra,0x0
    80001f0a:	ef2080e7          	jalr	-270(ra) # 80001df8 <argraw>
    80001f0e:	c088                	sw	a0,0(s1)
  return 0;
}
    80001f10:	4501                	li	a0,0
    80001f12:	60e2                	ld	ra,24(sp)
    80001f14:	6442                	ld	s0,16(sp)
    80001f16:	64a2                	ld	s1,8(sp)
    80001f18:	6105                	addi	sp,sp,32
    80001f1a:	8082                	ret

0000000080001f1c <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80001f1c:	1101                	addi	sp,sp,-32
    80001f1e:	ec06                	sd	ra,24(sp)
    80001f20:	e822                	sd	s0,16(sp)
    80001f22:	e426                	sd	s1,8(sp)
    80001f24:	1000                	addi	s0,sp,32
    80001f26:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f28:	00000097          	auipc	ra,0x0
    80001f2c:	ed0080e7          	jalr	-304(ra) # 80001df8 <argraw>
    80001f30:	e088                	sd	a0,0(s1)
  return 0;
}
    80001f32:	4501                	li	a0,0
    80001f34:	60e2                	ld	ra,24(sp)
    80001f36:	6442                	ld	s0,16(sp)
    80001f38:	64a2                	ld	s1,8(sp)
    80001f3a:	6105                	addi	sp,sp,32
    80001f3c:	8082                	ret

0000000080001f3e <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001f3e:	1101                	addi	sp,sp,-32
    80001f40:	ec06                	sd	ra,24(sp)
    80001f42:	e822                	sd	s0,16(sp)
    80001f44:	e426                	sd	s1,8(sp)
    80001f46:	e04a                	sd	s2,0(sp)
    80001f48:	1000                	addi	s0,sp,32
    80001f4a:	84ae                	mv	s1,a1
    80001f4c:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001f4e:	00000097          	auipc	ra,0x0
    80001f52:	eaa080e7          	jalr	-342(ra) # 80001df8 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80001f56:	864a                	mv	a2,s2
    80001f58:	85a6                	mv	a1,s1
    80001f5a:	00000097          	auipc	ra,0x0
    80001f5e:	f58080e7          	jalr	-168(ra) # 80001eb2 <fetchstr>
}
    80001f62:	60e2                	ld	ra,24(sp)
    80001f64:	6442                	ld	s0,16(sp)
    80001f66:	64a2                	ld	s1,8(sp)
    80001f68:	6902                	ld	s2,0(sp)
    80001f6a:	6105                	addi	sp,sp,32
    80001f6c:	8082                	ret

0000000080001f6e <syscall>:
[SYS_symlink]   sys_symlink,
};

void
syscall(void)
{
    80001f6e:	1101                	addi	sp,sp,-32
    80001f70:	ec06                	sd	ra,24(sp)
    80001f72:	e822                	sd	s0,16(sp)
    80001f74:	e426                	sd	s1,8(sp)
    80001f76:	e04a                	sd	s2,0(sp)
    80001f78:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001f7a:	fffff097          	auipc	ra,0xfffff
    80001f7e:	eca080e7          	jalr	-310(ra) # 80000e44 <myproc>
    80001f82:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001f84:	05853903          	ld	s2,88(a0)
    80001f88:	0a893783          	ld	a5,168(s2)
    80001f8c:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001f90:	37fd                	addiw	a5,a5,-1
    80001f92:	4755                	li	a4,21
    80001f94:	00f76f63          	bltu	a4,a5,80001fb2 <syscall+0x44>
    80001f98:	00369713          	slli	a4,a3,0x3
    80001f9c:	00006797          	auipc	a5,0x6
    80001fa0:	42c78793          	addi	a5,a5,1068 # 800083c8 <syscalls>
    80001fa4:	97ba                	add	a5,a5,a4
    80001fa6:	639c                	ld	a5,0(a5)
    80001fa8:	c789                	beqz	a5,80001fb2 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80001faa:	9782                	jalr	a5
    80001fac:	06a93823          	sd	a0,112(s2)
    80001fb0:	a839                	j	80001fce <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001fb2:	15848613          	addi	a2,s1,344
    80001fb6:	588c                	lw	a1,48(s1)
    80001fb8:	00006517          	auipc	a0,0x6
    80001fbc:	3d850513          	addi	a0,a0,984 # 80008390 <states.0+0x150>
    80001fc0:	00004097          	auipc	ra,0x4
    80001fc4:	e4a080e7          	jalr	-438(ra) # 80005e0a <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80001fc8:	6cbc                	ld	a5,88(s1)
    80001fca:	577d                	li	a4,-1
    80001fcc:	fbb8                	sd	a4,112(a5)
  }
}
    80001fce:	60e2                	ld	ra,24(sp)
    80001fd0:	6442                	ld	s0,16(sp)
    80001fd2:	64a2                	ld	s1,8(sp)
    80001fd4:	6902                	ld	s2,0(sp)
    80001fd6:	6105                	addi	sp,sp,32
    80001fd8:	8082                	ret

0000000080001fda <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80001fda:	1101                	addi	sp,sp,-32
    80001fdc:	ec06                	sd	ra,24(sp)
    80001fde:	e822                	sd	s0,16(sp)
    80001fe0:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80001fe2:	fec40593          	addi	a1,s0,-20
    80001fe6:	4501                	li	a0,0
    80001fe8:	00000097          	auipc	ra,0x0
    80001fec:	f12080e7          	jalr	-238(ra) # 80001efa <argint>
    return -1;
    80001ff0:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80001ff2:	00054963          	bltz	a0,80002004 <sys_exit+0x2a>
  exit(n);
    80001ff6:	fec42503          	lw	a0,-20(s0)
    80001ffa:	fffff097          	auipc	ra,0xfffff
    80001ffe:	76a080e7          	jalr	1898(ra) # 80001764 <exit>
  return 0;  // not reached
    80002002:	4781                	li	a5,0
}
    80002004:	853e                	mv	a0,a5
    80002006:	60e2                	ld	ra,24(sp)
    80002008:	6442                	ld	s0,16(sp)
    8000200a:	6105                	addi	sp,sp,32
    8000200c:	8082                	ret

000000008000200e <sys_getpid>:

uint64
sys_getpid(void)
{
    8000200e:	1141                	addi	sp,sp,-16
    80002010:	e406                	sd	ra,8(sp)
    80002012:	e022                	sd	s0,0(sp)
    80002014:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002016:	fffff097          	auipc	ra,0xfffff
    8000201a:	e2e080e7          	jalr	-466(ra) # 80000e44 <myproc>
}
    8000201e:	5908                	lw	a0,48(a0)
    80002020:	60a2                	ld	ra,8(sp)
    80002022:	6402                	ld	s0,0(sp)
    80002024:	0141                	addi	sp,sp,16
    80002026:	8082                	ret

0000000080002028 <sys_fork>:

uint64
sys_fork(void)
{
    80002028:	1141                	addi	sp,sp,-16
    8000202a:	e406                	sd	ra,8(sp)
    8000202c:	e022                	sd	s0,0(sp)
    8000202e:	0800                	addi	s0,sp,16
  return fork();
    80002030:	fffff097          	auipc	ra,0xfffff
    80002034:	1e6080e7          	jalr	486(ra) # 80001216 <fork>
}
    80002038:	60a2                	ld	ra,8(sp)
    8000203a:	6402                	ld	s0,0(sp)
    8000203c:	0141                	addi	sp,sp,16
    8000203e:	8082                	ret

0000000080002040 <sys_wait>:

uint64
sys_wait(void)
{
    80002040:	1101                	addi	sp,sp,-32
    80002042:	ec06                	sd	ra,24(sp)
    80002044:	e822                	sd	s0,16(sp)
    80002046:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002048:	fe840593          	addi	a1,s0,-24
    8000204c:	4501                	li	a0,0
    8000204e:	00000097          	auipc	ra,0x0
    80002052:	ece080e7          	jalr	-306(ra) # 80001f1c <argaddr>
    80002056:	87aa                	mv	a5,a0
    return -1;
    80002058:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    8000205a:	0007c863          	bltz	a5,8000206a <sys_wait+0x2a>
  return wait(p);
    8000205e:	fe843503          	ld	a0,-24(s0)
    80002062:	fffff097          	auipc	ra,0xfffff
    80002066:	50a080e7          	jalr	1290(ra) # 8000156c <wait>
}
    8000206a:	60e2                	ld	ra,24(sp)
    8000206c:	6442                	ld	s0,16(sp)
    8000206e:	6105                	addi	sp,sp,32
    80002070:	8082                	ret

0000000080002072 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002072:	7179                	addi	sp,sp,-48
    80002074:	f406                	sd	ra,40(sp)
    80002076:	f022                	sd	s0,32(sp)
    80002078:	ec26                	sd	s1,24(sp)
    8000207a:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    8000207c:	fdc40593          	addi	a1,s0,-36
    80002080:	4501                	li	a0,0
    80002082:	00000097          	auipc	ra,0x0
    80002086:	e78080e7          	jalr	-392(ra) # 80001efa <argint>
    8000208a:	87aa                	mv	a5,a0
    return -1;
    8000208c:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    8000208e:	0207c063          	bltz	a5,800020ae <sys_sbrk+0x3c>
  addr = myproc()->sz;
    80002092:	fffff097          	auipc	ra,0xfffff
    80002096:	db2080e7          	jalr	-590(ra) # 80000e44 <myproc>
    8000209a:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    8000209c:	fdc42503          	lw	a0,-36(s0)
    800020a0:	fffff097          	auipc	ra,0xfffff
    800020a4:	0fe080e7          	jalr	254(ra) # 8000119e <growproc>
    800020a8:	00054863          	bltz	a0,800020b8 <sys_sbrk+0x46>
    return -1;
  return addr;
    800020ac:	8526                	mv	a0,s1
}
    800020ae:	70a2                	ld	ra,40(sp)
    800020b0:	7402                	ld	s0,32(sp)
    800020b2:	64e2                	ld	s1,24(sp)
    800020b4:	6145                	addi	sp,sp,48
    800020b6:	8082                	ret
    return -1;
    800020b8:	557d                	li	a0,-1
    800020ba:	bfd5                	j	800020ae <sys_sbrk+0x3c>

00000000800020bc <sys_sleep>:

uint64
sys_sleep(void)
{
    800020bc:	7139                	addi	sp,sp,-64
    800020be:	fc06                	sd	ra,56(sp)
    800020c0:	f822                	sd	s0,48(sp)
    800020c2:	f426                	sd	s1,40(sp)
    800020c4:	f04a                	sd	s2,32(sp)
    800020c6:	ec4e                	sd	s3,24(sp)
    800020c8:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    800020ca:	fcc40593          	addi	a1,s0,-52
    800020ce:	4501                	li	a0,0
    800020d0:	00000097          	auipc	ra,0x0
    800020d4:	e2a080e7          	jalr	-470(ra) # 80001efa <argint>
    return -1;
    800020d8:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800020da:	06054563          	bltz	a0,80002144 <sys_sleep+0x88>
  acquire(&tickslock);
    800020de:	00008517          	auipc	a0,0x8
    800020e2:	1b250513          	addi	a0,a0,434 # 8000a290 <tickslock>
    800020e6:	00004097          	auipc	ra,0x4
    800020ea:	212080e7          	jalr	530(ra) # 800062f8 <acquire>
  ticks0 = ticks;
    800020ee:	00007917          	auipc	s2,0x7
    800020f2:	f2a92903          	lw	s2,-214(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    800020f6:	fcc42783          	lw	a5,-52(s0)
    800020fa:	cf85                	beqz	a5,80002132 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800020fc:	00008997          	auipc	s3,0x8
    80002100:	19498993          	addi	s3,s3,404 # 8000a290 <tickslock>
    80002104:	00007497          	auipc	s1,0x7
    80002108:	f1448493          	addi	s1,s1,-236 # 80009018 <ticks>
    if(myproc()->killed){
    8000210c:	fffff097          	auipc	ra,0xfffff
    80002110:	d38080e7          	jalr	-712(ra) # 80000e44 <myproc>
    80002114:	551c                	lw	a5,40(a0)
    80002116:	ef9d                	bnez	a5,80002154 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002118:	85ce                	mv	a1,s3
    8000211a:	8526                	mv	a0,s1
    8000211c:	fffff097          	auipc	ra,0xfffff
    80002120:	3ec080e7          	jalr	1004(ra) # 80001508 <sleep>
  while(ticks - ticks0 < n){
    80002124:	409c                	lw	a5,0(s1)
    80002126:	412787bb          	subw	a5,a5,s2
    8000212a:	fcc42703          	lw	a4,-52(s0)
    8000212e:	fce7efe3          	bltu	a5,a4,8000210c <sys_sleep+0x50>
  }
  release(&tickslock);
    80002132:	00008517          	auipc	a0,0x8
    80002136:	15e50513          	addi	a0,a0,350 # 8000a290 <tickslock>
    8000213a:	00004097          	auipc	ra,0x4
    8000213e:	272080e7          	jalr	626(ra) # 800063ac <release>
  return 0;
    80002142:	4781                	li	a5,0
}
    80002144:	853e                	mv	a0,a5
    80002146:	70e2                	ld	ra,56(sp)
    80002148:	7442                	ld	s0,48(sp)
    8000214a:	74a2                	ld	s1,40(sp)
    8000214c:	7902                	ld	s2,32(sp)
    8000214e:	69e2                	ld	s3,24(sp)
    80002150:	6121                	addi	sp,sp,64
    80002152:	8082                	ret
      release(&tickslock);
    80002154:	00008517          	auipc	a0,0x8
    80002158:	13c50513          	addi	a0,a0,316 # 8000a290 <tickslock>
    8000215c:	00004097          	auipc	ra,0x4
    80002160:	250080e7          	jalr	592(ra) # 800063ac <release>
      return -1;
    80002164:	57fd                	li	a5,-1
    80002166:	bff9                	j	80002144 <sys_sleep+0x88>

0000000080002168 <sys_kill>:

uint64
sys_kill(void)
{
    80002168:	1101                	addi	sp,sp,-32
    8000216a:	ec06                	sd	ra,24(sp)
    8000216c:	e822                	sd	s0,16(sp)
    8000216e:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002170:	fec40593          	addi	a1,s0,-20
    80002174:	4501                	li	a0,0
    80002176:	00000097          	auipc	ra,0x0
    8000217a:	d84080e7          	jalr	-636(ra) # 80001efa <argint>
    8000217e:	87aa                	mv	a5,a0
    return -1;
    80002180:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002182:	0007c863          	bltz	a5,80002192 <sys_kill+0x2a>
  return kill(pid);
    80002186:	fec42503          	lw	a0,-20(s0)
    8000218a:	fffff097          	auipc	ra,0xfffff
    8000218e:	6b0080e7          	jalr	1712(ra) # 8000183a <kill>
}
    80002192:	60e2                	ld	ra,24(sp)
    80002194:	6442                	ld	s0,16(sp)
    80002196:	6105                	addi	sp,sp,32
    80002198:	8082                	ret

000000008000219a <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000219a:	1101                	addi	sp,sp,-32
    8000219c:	ec06                	sd	ra,24(sp)
    8000219e:	e822                	sd	s0,16(sp)
    800021a0:	e426                	sd	s1,8(sp)
    800021a2:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800021a4:	00008517          	auipc	a0,0x8
    800021a8:	0ec50513          	addi	a0,a0,236 # 8000a290 <tickslock>
    800021ac:	00004097          	auipc	ra,0x4
    800021b0:	14c080e7          	jalr	332(ra) # 800062f8 <acquire>
  xticks = ticks;
    800021b4:	00007497          	auipc	s1,0x7
    800021b8:	e644a483          	lw	s1,-412(s1) # 80009018 <ticks>
  release(&tickslock);
    800021bc:	00008517          	auipc	a0,0x8
    800021c0:	0d450513          	addi	a0,a0,212 # 8000a290 <tickslock>
    800021c4:	00004097          	auipc	ra,0x4
    800021c8:	1e8080e7          	jalr	488(ra) # 800063ac <release>
  return xticks;
}
    800021cc:	02049513          	slli	a0,s1,0x20
    800021d0:	9101                	srli	a0,a0,0x20
    800021d2:	60e2                	ld	ra,24(sp)
    800021d4:	6442                	ld	s0,16(sp)
    800021d6:	64a2                	ld	s1,8(sp)
    800021d8:	6105                	addi	sp,sp,32
    800021da:	8082                	ret

00000000800021dc <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800021dc:	7179                	addi	sp,sp,-48
    800021de:	f406                	sd	ra,40(sp)
    800021e0:	f022                	sd	s0,32(sp)
    800021e2:	ec26                	sd	s1,24(sp)
    800021e4:	e84a                	sd	s2,16(sp)
    800021e6:	e44e                	sd	s3,8(sp)
    800021e8:	e052                	sd	s4,0(sp)
    800021ea:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800021ec:	00006597          	auipc	a1,0x6
    800021f0:	29458593          	addi	a1,a1,660 # 80008480 <syscalls+0xb8>
    800021f4:	00008517          	auipc	a0,0x8
    800021f8:	0b450513          	addi	a0,a0,180 # 8000a2a8 <bcache>
    800021fc:	00004097          	auipc	ra,0x4
    80002200:	06c080e7          	jalr	108(ra) # 80006268 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002204:	00010797          	auipc	a5,0x10
    80002208:	0a478793          	addi	a5,a5,164 # 800122a8 <bcache+0x8000>
    8000220c:	00010717          	auipc	a4,0x10
    80002210:	30470713          	addi	a4,a4,772 # 80012510 <bcache+0x8268>
    80002214:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002218:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000221c:	00008497          	auipc	s1,0x8
    80002220:	0a448493          	addi	s1,s1,164 # 8000a2c0 <bcache+0x18>
    b->next = bcache.head.next;
    80002224:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002226:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002228:	00006a17          	auipc	s4,0x6
    8000222c:	260a0a13          	addi	s4,s4,608 # 80008488 <syscalls+0xc0>
    b->next = bcache.head.next;
    80002230:	2b893783          	ld	a5,696(s2)
    80002234:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002236:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000223a:	85d2                	mv	a1,s4
    8000223c:	01048513          	addi	a0,s1,16
    80002240:	00001097          	auipc	ra,0x1
    80002244:	636080e7          	jalr	1590(ra) # 80003876 <initsleeplock>
    bcache.head.next->prev = b;
    80002248:	2b893783          	ld	a5,696(s2)
    8000224c:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000224e:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002252:	45848493          	addi	s1,s1,1112
    80002256:	fd349de3          	bne	s1,s3,80002230 <binit+0x54>
  }
}
    8000225a:	70a2                	ld	ra,40(sp)
    8000225c:	7402                	ld	s0,32(sp)
    8000225e:	64e2                	ld	s1,24(sp)
    80002260:	6942                	ld	s2,16(sp)
    80002262:	69a2                	ld	s3,8(sp)
    80002264:	6a02                	ld	s4,0(sp)
    80002266:	6145                	addi	sp,sp,48
    80002268:	8082                	ret

000000008000226a <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000226a:	7179                	addi	sp,sp,-48
    8000226c:	f406                	sd	ra,40(sp)
    8000226e:	f022                	sd	s0,32(sp)
    80002270:	ec26                	sd	s1,24(sp)
    80002272:	e84a                	sd	s2,16(sp)
    80002274:	e44e                	sd	s3,8(sp)
    80002276:	1800                	addi	s0,sp,48
    80002278:	892a                	mv	s2,a0
    8000227a:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000227c:	00008517          	auipc	a0,0x8
    80002280:	02c50513          	addi	a0,a0,44 # 8000a2a8 <bcache>
    80002284:	00004097          	auipc	ra,0x4
    80002288:	074080e7          	jalr	116(ra) # 800062f8 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000228c:	00010497          	auipc	s1,0x10
    80002290:	2d44b483          	ld	s1,724(s1) # 80012560 <bcache+0x82b8>
    80002294:	00010797          	auipc	a5,0x10
    80002298:	27c78793          	addi	a5,a5,636 # 80012510 <bcache+0x8268>
    8000229c:	02f48f63          	beq	s1,a5,800022da <bread+0x70>
    800022a0:	873e                	mv	a4,a5
    800022a2:	a021                	j	800022aa <bread+0x40>
    800022a4:	68a4                	ld	s1,80(s1)
    800022a6:	02e48a63          	beq	s1,a4,800022da <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800022aa:	449c                	lw	a5,8(s1)
    800022ac:	ff279ce3          	bne	a5,s2,800022a4 <bread+0x3a>
    800022b0:	44dc                	lw	a5,12(s1)
    800022b2:	ff3799e3          	bne	a5,s3,800022a4 <bread+0x3a>
      b->refcnt++;
    800022b6:	40bc                	lw	a5,64(s1)
    800022b8:	2785                	addiw	a5,a5,1
    800022ba:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800022bc:	00008517          	auipc	a0,0x8
    800022c0:	fec50513          	addi	a0,a0,-20 # 8000a2a8 <bcache>
    800022c4:	00004097          	auipc	ra,0x4
    800022c8:	0e8080e7          	jalr	232(ra) # 800063ac <release>
      acquiresleep(&b->lock);
    800022cc:	01048513          	addi	a0,s1,16
    800022d0:	00001097          	auipc	ra,0x1
    800022d4:	5e0080e7          	jalr	1504(ra) # 800038b0 <acquiresleep>
      return b;
    800022d8:	a8b9                	j	80002336 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800022da:	00010497          	auipc	s1,0x10
    800022de:	27e4b483          	ld	s1,638(s1) # 80012558 <bcache+0x82b0>
    800022e2:	00010797          	auipc	a5,0x10
    800022e6:	22e78793          	addi	a5,a5,558 # 80012510 <bcache+0x8268>
    800022ea:	00f48863          	beq	s1,a5,800022fa <bread+0x90>
    800022ee:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800022f0:	40bc                	lw	a5,64(s1)
    800022f2:	cf81                	beqz	a5,8000230a <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800022f4:	64a4                	ld	s1,72(s1)
    800022f6:	fee49de3          	bne	s1,a4,800022f0 <bread+0x86>
  panic("bget: no buffers");
    800022fa:	00006517          	auipc	a0,0x6
    800022fe:	19650513          	addi	a0,a0,406 # 80008490 <syscalls+0xc8>
    80002302:	00004097          	auipc	ra,0x4
    80002306:	abe080e7          	jalr	-1346(ra) # 80005dc0 <panic>
      b->dev = dev;
    8000230a:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000230e:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002312:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002316:	4785                	li	a5,1
    80002318:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000231a:	00008517          	auipc	a0,0x8
    8000231e:	f8e50513          	addi	a0,a0,-114 # 8000a2a8 <bcache>
    80002322:	00004097          	auipc	ra,0x4
    80002326:	08a080e7          	jalr	138(ra) # 800063ac <release>
      acquiresleep(&b->lock);
    8000232a:	01048513          	addi	a0,s1,16
    8000232e:	00001097          	auipc	ra,0x1
    80002332:	582080e7          	jalr	1410(ra) # 800038b0 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002336:	409c                	lw	a5,0(s1)
    80002338:	cb89                	beqz	a5,8000234a <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000233a:	8526                	mv	a0,s1
    8000233c:	70a2                	ld	ra,40(sp)
    8000233e:	7402                	ld	s0,32(sp)
    80002340:	64e2                	ld	s1,24(sp)
    80002342:	6942                	ld	s2,16(sp)
    80002344:	69a2                	ld	s3,8(sp)
    80002346:	6145                	addi	sp,sp,48
    80002348:	8082                	ret
    virtio_disk_rw(b, 0);
    8000234a:	4581                	li	a1,0
    8000234c:	8526                	mv	a0,s1
    8000234e:	00003097          	auipc	ra,0x3
    80002352:	204080e7          	jalr	516(ra) # 80005552 <virtio_disk_rw>
    b->valid = 1;
    80002356:	4785                	li	a5,1
    80002358:	c09c                	sw	a5,0(s1)
  return b;
    8000235a:	b7c5                	j	8000233a <bread+0xd0>

000000008000235c <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000235c:	1101                	addi	sp,sp,-32
    8000235e:	ec06                	sd	ra,24(sp)
    80002360:	e822                	sd	s0,16(sp)
    80002362:	e426                	sd	s1,8(sp)
    80002364:	1000                	addi	s0,sp,32
    80002366:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002368:	0541                	addi	a0,a0,16
    8000236a:	00001097          	auipc	ra,0x1
    8000236e:	5e0080e7          	jalr	1504(ra) # 8000394a <holdingsleep>
    80002372:	cd01                	beqz	a0,8000238a <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002374:	4585                	li	a1,1
    80002376:	8526                	mv	a0,s1
    80002378:	00003097          	auipc	ra,0x3
    8000237c:	1da080e7          	jalr	474(ra) # 80005552 <virtio_disk_rw>
}
    80002380:	60e2                	ld	ra,24(sp)
    80002382:	6442                	ld	s0,16(sp)
    80002384:	64a2                	ld	s1,8(sp)
    80002386:	6105                	addi	sp,sp,32
    80002388:	8082                	ret
    panic("bwrite");
    8000238a:	00006517          	auipc	a0,0x6
    8000238e:	11e50513          	addi	a0,a0,286 # 800084a8 <syscalls+0xe0>
    80002392:	00004097          	auipc	ra,0x4
    80002396:	a2e080e7          	jalr	-1490(ra) # 80005dc0 <panic>

000000008000239a <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000239a:	1101                	addi	sp,sp,-32
    8000239c:	ec06                	sd	ra,24(sp)
    8000239e:	e822                	sd	s0,16(sp)
    800023a0:	e426                	sd	s1,8(sp)
    800023a2:	e04a                	sd	s2,0(sp)
    800023a4:	1000                	addi	s0,sp,32
    800023a6:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800023a8:	01050913          	addi	s2,a0,16
    800023ac:	854a                	mv	a0,s2
    800023ae:	00001097          	auipc	ra,0x1
    800023b2:	59c080e7          	jalr	1436(ra) # 8000394a <holdingsleep>
    800023b6:	c92d                	beqz	a0,80002428 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800023b8:	854a                	mv	a0,s2
    800023ba:	00001097          	auipc	ra,0x1
    800023be:	54c080e7          	jalr	1356(ra) # 80003906 <releasesleep>

  acquire(&bcache.lock);
    800023c2:	00008517          	auipc	a0,0x8
    800023c6:	ee650513          	addi	a0,a0,-282 # 8000a2a8 <bcache>
    800023ca:	00004097          	auipc	ra,0x4
    800023ce:	f2e080e7          	jalr	-210(ra) # 800062f8 <acquire>
  b->refcnt--;
    800023d2:	40bc                	lw	a5,64(s1)
    800023d4:	37fd                	addiw	a5,a5,-1
    800023d6:	0007871b          	sext.w	a4,a5
    800023da:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800023dc:	eb05                	bnez	a4,8000240c <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800023de:	68bc                	ld	a5,80(s1)
    800023e0:	64b8                	ld	a4,72(s1)
    800023e2:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800023e4:	64bc                	ld	a5,72(s1)
    800023e6:	68b8                	ld	a4,80(s1)
    800023e8:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800023ea:	00010797          	auipc	a5,0x10
    800023ee:	ebe78793          	addi	a5,a5,-322 # 800122a8 <bcache+0x8000>
    800023f2:	2b87b703          	ld	a4,696(a5)
    800023f6:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800023f8:	00010717          	auipc	a4,0x10
    800023fc:	11870713          	addi	a4,a4,280 # 80012510 <bcache+0x8268>
    80002400:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002402:	2b87b703          	ld	a4,696(a5)
    80002406:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002408:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000240c:	00008517          	auipc	a0,0x8
    80002410:	e9c50513          	addi	a0,a0,-356 # 8000a2a8 <bcache>
    80002414:	00004097          	auipc	ra,0x4
    80002418:	f98080e7          	jalr	-104(ra) # 800063ac <release>
}
    8000241c:	60e2                	ld	ra,24(sp)
    8000241e:	6442                	ld	s0,16(sp)
    80002420:	64a2                	ld	s1,8(sp)
    80002422:	6902                	ld	s2,0(sp)
    80002424:	6105                	addi	sp,sp,32
    80002426:	8082                	ret
    panic("brelse");
    80002428:	00006517          	auipc	a0,0x6
    8000242c:	08850513          	addi	a0,a0,136 # 800084b0 <syscalls+0xe8>
    80002430:	00004097          	auipc	ra,0x4
    80002434:	990080e7          	jalr	-1648(ra) # 80005dc0 <panic>

0000000080002438 <bpin>:

void
bpin(struct buf *b) {
    80002438:	1101                	addi	sp,sp,-32
    8000243a:	ec06                	sd	ra,24(sp)
    8000243c:	e822                	sd	s0,16(sp)
    8000243e:	e426                	sd	s1,8(sp)
    80002440:	1000                	addi	s0,sp,32
    80002442:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002444:	00008517          	auipc	a0,0x8
    80002448:	e6450513          	addi	a0,a0,-412 # 8000a2a8 <bcache>
    8000244c:	00004097          	auipc	ra,0x4
    80002450:	eac080e7          	jalr	-340(ra) # 800062f8 <acquire>
  b->refcnt++;
    80002454:	40bc                	lw	a5,64(s1)
    80002456:	2785                	addiw	a5,a5,1
    80002458:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000245a:	00008517          	auipc	a0,0x8
    8000245e:	e4e50513          	addi	a0,a0,-434 # 8000a2a8 <bcache>
    80002462:	00004097          	auipc	ra,0x4
    80002466:	f4a080e7          	jalr	-182(ra) # 800063ac <release>
}
    8000246a:	60e2                	ld	ra,24(sp)
    8000246c:	6442                	ld	s0,16(sp)
    8000246e:	64a2                	ld	s1,8(sp)
    80002470:	6105                	addi	sp,sp,32
    80002472:	8082                	ret

0000000080002474 <bunpin>:

void
bunpin(struct buf *b) {
    80002474:	1101                	addi	sp,sp,-32
    80002476:	ec06                	sd	ra,24(sp)
    80002478:	e822                	sd	s0,16(sp)
    8000247a:	e426                	sd	s1,8(sp)
    8000247c:	1000                	addi	s0,sp,32
    8000247e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002480:	00008517          	auipc	a0,0x8
    80002484:	e2850513          	addi	a0,a0,-472 # 8000a2a8 <bcache>
    80002488:	00004097          	auipc	ra,0x4
    8000248c:	e70080e7          	jalr	-400(ra) # 800062f8 <acquire>
  b->refcnt--;
    80002490:	40bc                	lw	a5,64(s1)
    80002492:	37fd                	addiw	a5,a5,-1
    80002494:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002496:	00008517          	auipc	a0,0x8
    8000249a:	e1250513          	addi	a0,a0,-494 # 8000a2a8 <bcache>
    8000249e:	00004097          	auipc	ra,0x4
    800024a2:	f0e080e7          	jalr	-242(ra) # 800063ac <release>
}
    800024a6:	60e2                	ld	ra,24(sp)
    800024a8:	6442                	ld	s0,16(sp)
    800024aa:	64a2                	ld	s1,8(sp)
    800024ac:	6105                	addi	sp,sp,32
    800024ae:	8082                	ret

00000000800024b0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800024b0:	1101                	addi	sp,sp,-32
    800024b2:	ec06                	sd	ra,24(sp)
    800024b4:	e822                	sd	s0,16(sp)
    800024b6:	e426                	sd	s1,8(sp)
    800024b8:	e04a                	sd	s2,0(sp)
    800024ba:	1000                	addi	s0,sp,32
    800024bc:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800024be:	00d5d59b          	srliw	a1,a1,0xd
    800024c2:	00010797          	auipc	a5,0x10
    800024c6:	4c27a783          	lw	a5,1218(a5) # 80012984 <sb+0x1c>
    800024ca:	9dbd                	addw	a1,a1,a5
    800024cc:	00000097          	auipc	ra,0x0
    800024d0:	d9e080e7          	jalr	-610(ra) # 8000226a <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800024d4:	0074f713          	andi	a4,s1,7
    800024d8:	4785                	li	a5,1
    800024da:	00e797bb          	sllw	a5,a5,a4
  if ((bp->data[bi / 8] & m) == 0)
    800024de:	14ce                	slli	s1,s1,0x33
    800024e0:	90d9                	srli	s1,s1,0x36
    800024e2:	00950733          	add	a4,a0,s1
    800024e6:	05874703          	lbu	a4,88(a4)
    800024ea:	00e7f6b3          	and	a3,a5,a4
    800024ee:	c69d                	beqz	a3,8000251c <bfree+0x6c>
    800024f0:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi / 8] &= ~m;
    800024f2:	94aa                	add	s1,s1,a0
    800024f4:	fff7c793          	not	a5,a5
    800024f8:	8f7d                	and	a4,a4,a5
    800024fa:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800024fe:	00001097          	auipc	ra,0x1
    80002502:	294080e7          	jalr	660(ra) # 80003792 <log_write>
  brelse(bp);
    80002506:	854a                	mv	a0,s2
    80002508:	00000097          	auipc	ra,0x0
    8000250c:	e92080e7          	jalr	-366(ra) # 8000239a <brelse>
}
    80002510:	60e2                	ld	ra,24(sp)
    80002512:	6442                	ld	s0,16(sp)
    80002514:	64a2                	ld	s1,8(sp)
    80002516:	6902                	ld	s2,0(sp)
    80002518:	6105                	addi	sp,sp,32
    8000251a:	8082                	ret
    panic("freeing free block");
    8000251c:	00006517          	auipc	a0,0x6
    80002520:	f9c50513          	addi	a0,a0,-100 # 800084b8 <syscalls+0xf0>
    80002524:	00004097          	auipc	ra,0x4
    80002528:	89c080e7          	jalr	-1892(ra) # 80005dc0 <panic>

000000008000252c <balloc>:
{
    8000252c:	711d                	addi	sp,sp,-96
    8000252e:	ec86                	sd	ra,88(sp)
    80002530:	e8a2                	sd	s0,80(sp)
    80002532:	e4a6                	sd	s1,72(sp)
    80002534:	e0ca                	sd	s2,64(sp)
    80002536:	fc4e                	sd	s3,56(sp)
    80002538:	f852                	sd	s4,48(sp)
    8000253a:	f456                	sd	s5,40(sp)
    8000253c:	f05a                	sd	s6,32(sp)
    8000253e:	ec5e                	sd	s7,24(sp)
    80002540:	e862                	sd	s8,16(sp)
    80002542:	e466                	sd	s9,8(sp)
    80002544:	1080                	addi	s0,sp,96
  for (b = 0; b < sb.size; b += BPB)
    80002546:	00010797          	auipc	a5,0x10
    8000254a:	4267a783          	lw	a5,1062(a5) # 8001296c <sb+0x4>
    8000254e:	cbc1                	beqz	a5,800025de <balloc+0xb2>
    80002550:	8baa                	mv	s7,a0
    80002552:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002554:	00010b17          	auipc	s6,0x10
    80002558:	414b0b13          	addi	s6,s6,1044 # 80012968 <sb>
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++)
    8000255c:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000255e:	4985                	li	s3,1
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++)
    80002560:	6a09                	lui	s4,0x2
  for (b = 0; b < sb.size; b += BPB)
    80002562:	6c89                	lui	s9,0x2
    80002564:	a831                	j	80002580 <balloc+0x54>
    brelse(bp);
    80002566:	854a                	mv	a0,s2
    80002568:	00000097          	auipc	ra,0x0
    8000256c:	e32080e7          	jalr	-462(ra) # 8000239a <brelse>
  for (b = 0; b < sb.size; b += BPB)
    80002570:	015c87bb          	addw	a5,s9,s5
    80002574:	00078a9b          	sext.w	s5,a5
    80002578:	004b2703          	lw	a4,4(s6)
    8000257c:	06eaf163          	bgeu	s5,a4,800025de <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    80002580:	41fad79b          	sraiw	a5,s5,0x1f
    80002584:	0137d79b          	srliw	a5,a5,0x13
    80002588:	015787bb          	addw	a5,a5,s5
    8000258c:	40d7d79b          	sraiw	a5,a5,0xd
    80002590:	01cb2583          	lw	a1,28(s6)
    80002594:	9dbd                	addw	a1,a1,a5
    80002596:	855e                	mv	a0,s7
    80002598:	00000097          	auipc	ra,0x0
    8000259c:	cd2080e7          	jalr	-814(ra) # 8000226a <bread>
    800025a0:	892a                	mv	s2,a0
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++)
    800025a2:	004b2503          	lw	a0,4(s6)
    800025a6:	000a849b          	sext.w	s1,s5
    800025aa:	8762                	mv	a4,s8
    800025ac:	faa4fde3          	bgeu	s1,a0,80002566 <balloc+0x3a>
      m = 1 << (bi % 8);
    800025b0:	00777693          	andi	a3,a4,7
    800025b4:	00d996bb          	sllw	a3,s3,a3
      if ((bp->data[bi / 8] & m) == 0)
    800025b8:	41f7579b          	sraiw	a5,a4,0x1f
    800025bc:	01d7d79b          	srliw	a5,a5,0x1d
    800025c0:	9fb9                	addw	a5,a5,a4
    800025c2:	4037d79b          	sraiw	a5,a5,0x3
    800025c6:	00f90633          	add	a2,s2,a5
    800025ca:	05864603          	lbu	a2,88(a2)
    800025ce:	00c6f5b3          	and	a1,a3,a2
    800025d2:	cd91                	beqz	a1,800025ee <balloc+0xc2>
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++)
    800025d4:	2705                	addiw	a4,a4,1
    800025d6:	2485                	addiw	s1,s1,1
    800025d8:	fd471ae3          	bne	a4,s4,800025ac <balloc+0x80>
    800025dc:	b769                	j	80002566 <balloc+0x3a>
  panic("balloc: out of blocks");
    800025de:	00006517          	auipc	a0,0x6
    800025e2:	ef250513          	addi	a0,a0,-270 # 800084d0 <syscalls+0x108>
    800025e6:	00003097          	auipc	ra,0x3
    800025ea:	7da080e7          	jalr	2010(ra) # 80005dc0 <panic>
        bp->data[bi / 8] |= m; // Mark block in use.
    800025ee:	97ca                	add	a5,a5,s2
    800025f0:	8e55                	or	a2,a2,a3
    800025f2:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800025f6:	854a                	mv	a0,s2
    800025f8:	00001097          	auipc	ra,0x1
    800025fc:	19a080e7          	jalr	410(ra) # 80003792 <log_write>
        brelse(bp);
    80002600:	854a                	mv	a0,s2
    80002602:	00000097          	auipc	ra,0x0
    80002606:	d98080e7          	jalr	-616(ra) # 8000239a <brelse>
  bp = bread(dev, bno);
    8000260a:	85a6                	mv	a1,s1
    8000260c:	855e                	mv	a0,s7
    8000260e:	00000097          	auipc	ra,0x0
    80002612:	c5c080e7          	jalr	-932(ra) # 8000226a <bread>
    80002616:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002618:	40000613          	li	a2,1024
    8000261c:	4581                	li	a1,0
    8000261e:	05850513          	addi	a0,a0,88
    80002622:	ffffe097          	auipc	ra,0xffffe
    80002626:	b58080e7          	jalr	-1192(ra) # 8000017a <memset>
  log_write(bp);
    8000262a:	854a                	mv	a0,s2
    8000262c:	00001097          	auipc	ra,0x1
    80002630:	166080e7          	jalr	358(ra) # 80003792 <log_write>
  brelse(bp);
    80002634:	854a                	mv	a0,s2
    80002636:	00000097          	auipc	ra,0x0
    8000263a:	d64080e7          	jalr	-668(ra) # 8000239a <brelse>
}
    8000263e:	8526                	mv	a0,s1
    80002640:	60e6                	ld	ra,88(sp)
    80002642:	6446                	ld	s0,80(sp)
    80002644:	64a6                	ld	s1,72(sp)
    80002646:	6906                	ld	s2,64(sp)
    80002648:	79e2                	ld	s3,56(sp)
    8000264a:	7a42                	ld	s4,48(sp)
    8000264c:	7aa2                	ld	s5,40(sp)
    8000264e:	7b02                	ld	s6,32(sp)
    80002650:	6be2                	ld	s7,24(sp)
    80002652:	6c42                	ld	s8,16(sp)
    80002654:	6ca2                	ld	s9,8(sp)
    80002656:	6125                	addi	sp,sp,96
    80002658:	8082                	ret

000000008000265a <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    8000265a:	7139                	addi	sp,sp,-64
    8000265c:	fc06                	sd	ra,56(sp)
    8000265e:	f822                	sd	s0,48(sp)
    80002660:	f426                	sd	s1,40(sp)
    80002662:	f04a                	sd	s2,32(sp)
    80002664:	ec4e                	sd	s3,24(sp)
    80002666:	e852                	sd	s4,16(sp)
    80002668:	e456                	sd	s5,8(sp)
    8000266a:	0080                	addi	s0,sp,64
    8000266c:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if (bn < NDIRECT)
    8000266e:	47a9                	li	a5,10
    80002670:	08b7fd63          	bgeu	a5,a1,8000270a <bmap+0xb0>
  {
    if ((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80002674:	ff55849b          	addiw	s1,a1,-11
    80002678:	0004871b          	sext.w	a4,s1

  if (bn < NINDIRECT)
    8000267c:	0ff00793          	li	a5,255
    80002680:	0ae7f963          	bgeu	a5,a4,80002732 <bmap+0xd8>
    brelse(bp);
    return addr;
  }

  // 二级索引
  bn -= NINDIRECT;
    80002684:	ef55849b          	addiw	s1,a1,-267
    80002688:	0004871b          	sext.w	a4,s1
  if (bn < NDINDIRECT)
    8000268c:	67c1                	lui	a5,0x10
    8000268e:	16f77063          	bgeu	a4,a5,800027ee <bmap+0x194>
  {
    if ((addr = ip->addrs[NDIRECT + 1]) == 0)
    80002692:	08052583          	lw	a1,128(a0)
    80002696:	10058263          	beqz	a1,8000279a <bmap+0x140>
      ip->addrs[NDIRECT + 1] = addr = balloc(ip->dev);
    // 通过一级索引，找到下一级索引
    bp = bread(ip->dev, addr);
    8000269a:	0009a503          	lw	a0,0(s3)
    8000269e:	00000097          	auipc	ra,0x0
    800026a2:	bcc080e7          	jalr	-1076(ra) # 8000226a <bread>
    800026a6:	892a                	mv	s2,a0
    a = (uint *)bp->data;
    800026a8:	05850a13          	addi	s4,a0,88
    if ((addr = a[bn / NINDIRECT]) == 0)
    800026ac:	0084d79b          	srliw	a5,s1,0x8
    800026b0:	078a                	slli	a5,a5,0x2
    800026b2:	9a3e                	add	s4,s4,a5
    800026b4:	000a2a83          	lw	s5,0(s4) # 2000 <_entry-0x7fffe000>
    800026b8:	0e0a8b63          	beqz	s5,800027ae <bmap+0x154>
    {
      a[bn / NINDIRECT] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800026bc:	854a                	mv	a0,s2
    800026be:	00000097          	auipc	ra,0x0
    800026c2:	cdc080e7          	jalr	-804(ra) # 8000239a <brelse>
    // 重复上面的代码，实现二级索引
    bp = bread(ip->dev, addr);
    800026c6:	85d6                	mv	a1,s5
    800026c8:	0009a503          	lw	a0,0(s3)
    800026cc:	00000097          	auipc	ra,0x0
    800026d0:	b9e080e7          	jalr	-1122(ra) # 8000226a <bread>
    800026d4:	8a2a                	mv	s4,a0
    a = (uint *)bp->data;
    800026d6:	05850793          	addi	a5,a0,88
    if ((addr = a[bn % NINDIRECT]) == 0)
    800026da:	0ff4f593          	zext.b	a1,s1
    800026de:	058a                	slli	a1,a1,0x2
    800026e0:	00b784b3          	add	s1,a5,a1
    800026e4:	0004a903          	lw	s2,0(s1)
    800026e8:	0e090363          	beqz	s2,800027ce <bmap+0x174>
    {
      a[bn % NINDIRECT] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800026ec:	8552                	mv	a0,s4
    800026ee:	00000097          	auipc	ra,0x0
    800026f2:	cac080e7          	jalr	-852(ra) # 8000239a <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800026f6:	854a                	mv	a0,s2
    800026f8:	70e2                	ld	ra,56(sp)
    800026fa:	7442                	ld	s0,48(sp)
    800026fc:	74a2                	ld	s1,40(sp)
    800026fe:	7902                	ld	s2,32(sp)
    80002700:	69e2                	ld	s3,24(sp)
    80002702:	6a42                	ld	s4,16(sp)
    80002704:	6aa2                	ld	s5,8(sp)
    80002706:	6121                	addi	sp,sp,64
    80002708:	8082                	ret
    if ((addr = ip->addrs[bn]) == 0)
    8000270a:	02059793          	slli	a5,a1,0x20
    8000270e:	01e7d593          	srli	a1,a5,0x1e
    80002712:	00b504b3          	add	s1,a0,a1
    80002716:	0504a903          	lw	s2,80(s1)
    8000271a:	fc091ee3          	bnez	s2,800026f6 <bmap+0x9c>
      ip->addrs[bn] = addr = balloc(ip->dev);
    8000271e:	4108                	lw	a0,0(a0)
    80002720:	00000097          	auipc	ra,0x0
    80002724:	e0c080e7          	jalr	-500(ra) # 8000252c <balloc>
    80002728:	0005091b          	sext.w	s2,a0
    8000272c:	0524a823          	sw	s2,80(s1)
    80002730:	b7d9                	j	800026f6 <bmap+0x9c>
    if ((addr = ip->addrs[NDIRECT]) == 0)
    80002732:	5d6c                	lw	a1,124(a0)
    80002734:	c98d                	beqz	a1,80002766 <bmap+0x10c>
    bp = bread(ip->dev, addr);
    80002736:	0009a503          	lw	a0,0(s3)
    8000273a:	00000097          	auipc	ra,0x0
    8000273e:	b30080e7          	jalr	-1232(ra) # 8000226a <bread>
    80002742:	8a2a                	mv	s4,a0
    a = (uint *)bp->data;
    80002744:	05850793          	addi	a5,a0,88
    if ((addr = a[bn]) == 0)
    80002748:	02049713          	slli	a4,s1,0x20
    8000274c:	01e75493          	srli	s1,a4,0x1e
    80002750:	94be                	add	s1,s1,a5
    80002752:	0004a903          	lw	s2,0(s1)
    80002756:	02090263          	beqz	s2,8000277a <bmap+0x120>
    brelse(bp);
    8000275a:	8552                	mv	a0,s4
    8000275c:	00000097          	auipc	ra,0x0
    80002760:	c3e080e7          	jalr	-962(ra) # 8000239a <brelse>
    return addr;
    80002764:	bf49                	j	800026f6 <bmap+0x9c>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002766:	4108                	lw	a0,0(a0)
    80002768:	00000097          	auipc	ra,0x0
    8000276c:	dc4080e7          	jalr	-572(ra) # 8000252c <balloc>
    80002770:	0005059b          	sext.w	a1,a0
    80002774:	06b9ae23          	sw	a1,124(s3)
    80002778:	bf7d                	j	80002736 <bmap+0xdc>
      a[bn] = addr = balloc(ip->dev);
    8000277a:	0009a503          	lw	a0,0(s3)
    8000277e:	00000097          	auipc	ra,0x0
    80002782:	dae080e7          	jalr	-594(ra) # 8000252c <balloc>
    80002786:	0005091b          	sext.w	s2,a0
    8000278a:	0124a023          	sw	s2,0(s1)
      log_write(bp);
    8000278e:	8552                	mv	a0,s4
    80002790:	00001097          	auipc	ra,0x1
    80002794:	002080e7          	jalr	2(ra) # 80003792 <log_write>
    80002798:	b7c9                	j	8000275a <bmap+0x100>
      ip->addrs[NDIRECT + 1] = addr = balloc(ip->dev);
    8000279a:	4108                	lw	a0,0(a0)
    8000279c:	00000097          	auipc	ra,0x0
    800027a0:	d90080e7          	jalr	-624(ra) # 8000252c <balloc>
    800027a4:	0005059b          	sext.w	a1,a0
    800027a8:	08b9a023          	sw	a1,128(s3)
    800027ac:	b5fd                	j	8000269a <bmap+0x40>
      a[bn / NINDIRECT] = addr = balloc(ip->dev);
    800027ae:	0009a503          	lw	a0,0(s3)
    800027b2:	00000097          	auipc	ra,0x0
    800027b6:	d7a080e7          	jalr	-646(ra) # 8000252c <balloc>
    800027ba:	00050a9b          	sext.w	s5,a0
    800027be:	015a2023          	sw	s5,0(s4)
      log_write(bp);
    800027c2:	854a                	mv	a0,s2
    800027c4:	00001097          	auipc	ra,0x1
    800027c8:	fce080e7          	jalr	-50(ra) # 80003792 <log_write>
    800027cc:	bdc5                	j	800026bc <bmap+0x62>
      a[bn % NINDIRECT] = addr = balloc(ip->dev);
    800027ce:	0009a503          	lw	a0,0(s3)
    800027d2:	00000097          	auipc	ra,0x0
    800027d6:	d5a080e7          	jalr	-678(ra) # 8000252c <balloc>
    800027da:	0005091b          	sext.w	s2,a0
    800027de:	0124a023          	sw	s2,0(s1)
      log_write(bp);
    800027e2:	8552                	mv	a0,s4
    800027e4:	00001097          	auipc	ra,0x1
    800027e8:	fae080e7          	jalr	-82(ra) # 80003792 <log_write>
    800027ec:	b701                	j	800026ec <bmap+0x92>
  panic("bmap: out of range");
    800027ee:	00006517          	auipc	a0,0x6
    800027f2:	cfa50513          	addi	a0,a0,-774 # 800084e8 <syscalls+0x120>
    800027f6:	00003097          	auipc	ra,0x3
    800027fa:	5ca080e7          	jalr	1482(ra) # 80005dc0 <panic>

00000000800027fe <iget>:
{
    800027fe:	7179                	addi	sp,sp,-48
    80002800:	f406                	sd	ra,40(sp)
    80002802:	f022                	sd	s0,32(sp)
    80002804:	ec26                	sd	s1,24(sp)
    80002806:	e84a                	sd	s2,16(sp)
    80002808:	e44e                	sd	s3,8(sp)
    8000280a:	e052                	sd	s4,0(sp)
    8000280c:	1800                	addi	s0,sp,48
    8000280e:	89aa                	mv	s3,a0
    80002810:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002812:	00010517          	auipc	a0,0x10
    80002816:	17650513          	addi	a0,a0,374 # 80012988 <itable>
    8000281a:	00004097          	auipc	ra,0x4
    8000281e:	ade080e7          	jalr	-1314(ra) # 800062f8 <acquire>
  empty = 0;
    80002822:	4901                	li	s2,0
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++)
    80002824:	00010497          	auipc	s1,0x10
    80002828:	17c48493          	addi	s1,s1,380 # 800129a0 <itable+0x18>
    8000282c:	00012697          	auipc	a3,0x12
    80002830:	c0468693          	addi	a3,a3,-1020 # 80014430 <log>
    80002834:	a039                	j	80002842 <iget+0x44>
    if (empty == 0 && ip->ref == 0) // Remember empty slot.
    80002836:	02090b63          	beqz	s2,8000286c <iget+0x6e>
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++)
    8000283a:	08848493          	addi	s1,s1,136
    8000283e:	02d48a63          	beq	s1,a3,80002872 <iget+0x74>
    if (ip->ref > 0 && ip->dev == dev && ip->inum == inum)
    80002842:	449c                	lw	a5,8(s1)
    80002844:	fef059e3          	blez	a5,80002836 <iget+0x38>
    80002848:	4098                	lw	a4,0(s1)
    8000284a:	ff3716e3          	bne	a4,s3,80002836 <iget+0x38>
    8000284e:	40d8                	lw	a4,4(s1)
    80002850:	ff4713e3          	bne	a4,s4,80002836 <iget+0x38>
      ip->ref++;
    80002854:	2785                	addiw	a5,a5,1 # 10001 <_entry-0x7ffeffff>
    80002856:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002858:	00010517          	auipc	a0,0x10
    8000285c:	13050513          	addi	a0,a0,304 # 80012988 <itable>
    80002860:	00004097          	auipc	ra,0x4
    80002864:	b4c080e7          	jalr	-1204(ra) # 800063ac <release>
      return ip;
    80002868:	8926                	mv	s2,s1
    8000286a:	a03d                	j	80002898 <iget+0x9a>
    if (empty == 0 && ip->ref == 0) // Remember empty slot.
    8000286c:	f7f9                	bnez	a5,8000283a <iget+0x3c>
    8000286e:	8926                	mv	s2,s1
    80002870:	b7e9                	j	8000283a <iget+0x3c>
  if (empty == 0)
    80002872:	02090c63          	beqz	s2,800028aa <iget+0xac>
  ip->dev = dev;
    80002876:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000287a:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000287e:	4785                	li	a5,1
    80002880:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002884:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002888:	00010517          	auipc	a0,0x10
    8000288c:	10050513          	addi	a0,a0,256 # 80012988 <itable>
    80002890:	00004097          	auipc	ra,0x4
    80002894:	b1c080e7          	jalr	-1252(ra) # 800063ac <release>
}
    80002898:	854a                	mv	a0,s2
    8000289a:	70a2                	ld	ra,40(sp)
    8000289c:	7402                	ld	s0,32(sp)
    8000289e:	64e2                	ld	s1,24(sp)
    800028a0:	6942                	ld	s2,16(sp)
    800028a2:	69a2                	ld	s3,8(sp)
    800028a4:	6a02                	ld	s4,0(sp)
    800028a6:	6145                	addi	sp,sp,48
    800028a8:	8082                	ret
    panic("iget: no inodes");
    800028aa:	00006517          	auipc	a0,0x6
    800028ae:	c5650513          	addi	a0,a0,-938 # 80008500 <syscalls+0x138>
    800028b2:	00003097          	auipc	ra,0x3
    800028b6:	50e080e7          	jalr	1294(ra) # 80005dc0 <panic>

00000000800028ba <fsinit>:
{
    800028ba:	7179                	addi	sp,sp,-48
    800028bc:	f406                	sd	ra,40(sp)
    800028be:	f022                	sd	s0,32(sp)
    800028c0:	ec26                	sd	s1,24(sp)
    800028c2:	e84a                	sd	s2,16(sp)
    800028c4:	e44e                	sd	s3,8(sp)
    800028c6:	1800                	addi	s0,sp,48
    800028c8:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800028ca:	4585                	li	a1,1
    800028cc:	00000097          	auipc	ra,0x0
    800028d0:	99e080e7          	jalr	-1634(ra) # 8000226a <bread>
    800028d4:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800028d6:	00010997          	auipc	s3,0x10
    800028da:	09298993          	addi	s3,s3,146 # 80012968 <sb>
    800028de:	02000613          	li	a2,32
    800028e2:	05850593          	addi	a1,a0,88
    800028e6:	854e                	mv	a0,s3
    800028e8:	ffffe097          	auipc	ra,0xffffe
    800028ec:	8ee080e7          	jalr	-1810(ra) # 800001d6 <memmove>
  brelse(bp);
    800028f0:	8526                	mv	a0,s1
    800028f2:	00000097          	auipc	ra,0x0
    800028f6:	aa8080e7          	jalr	-1368(ra) # 8000239a <brelse>
  if (sb.magic != FSMAGIC)
    800028fa:	0009a703          	lw	a4,0(s3)
    800028fe:	102037b7          	lui	a5,0x10203
    80002902:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002906:	02f71263          	bne	a4,a5,8000292a <fsinit+0x70>
  initlog(dev, &sb);
    8000290a:	00010597          	auipc	a1,0x10
    8000290e:	05e58593          	addi	a1,a1,94 # 80012968 <sb>
    80002912:	854a                	mv	a0,s2
    80002914:	00001097          	auipc	ra,0x1
    80002918:	c02080e7          	jalr	-1022(ra) # 80003516 <initlog>
}
    8000291c:	70a2                	ld	ra,40(sp)
    8000291e:	7402                	ld	s0,32(sp)
    80002920:	64e2                	ld	s1,24(sp)
    80002922:	6942                	ld	s2,16(sp)
    80002924:	69a2                	ld	s3,8(sp)
    80002926:	6145                	addi	sp,sp,48
    80002928:	8082                	ret
    panic("invalid file system");
    8000292a:	00006517          	auipc	a0,0x6
    8000292e:	be650513          	addi	a0,a0,-1050 # 80008510 <syscalls+0x148>
    80002932:	00003097          	auipc	ra,0x3
    80002936:	48e080e7          	jalr	1166(ra) # 80005dc0 <panic>

000000008000293a <iinit>:
{
    8000293a:	7179                	addi	sp,sp,-48
    8000293c:	f406                	sd	ra,40(sp)
    8000293e:	f022                	sd	s0,32(sp)
    80002940:	ec26                	sd	s1,24(sp)
    80002942:	e84a                	sd	s2,16(sp)
    80002944:	e44e                	sd	s3,8(sp)
    80002946:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002948:	00006597          	auipc	a1,0x6
    8000294c:	be058593          	addi	a1,a1,-1056 # 80008528 <syscalls+0x160>
    80002950:	00010517          	auipc	a0,0x10
    80002954:	03850513          	addi	a0,a0,56 # 80012988 <itable>
    80002958:	00004097          	auipc	ra,0x4
    8000295c:	910080e7          	jalr	-1776(ra) # 80006268 <initlock>
  for (i = 0; i < NINODE; i++)
    80002960:	00010497          	auipc	s1,0x10
    80002964:	05048493          	addi	s1,s1,80 # 800129b0 <itable+0x28>
    80002968:	00012997          	auipc	s3,0x12
    8000296c:	ad898993          	addi	s3,s3,-1320 # 80014440 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002970:	00006917          	auipc	s2,0x6
    80002974:	bc090913          	addi	s2,s2,-1088 # 80008530 <syscalls+0x168>
    80002978:	85ca                	mv	a1,s2
    8000297a:	8526                	mv	a0,s1
    8000297c:	00001097          	auipc	ra,0x1
    80002980:	efa080e7          	jalr	-262(ra) # 80003876 <initsleeplock>
  for (i = 0; i < NINODE; i++)
    80002984:	08848493          	addi	s1,s1,136
    80002988:	ff3498e3          	bne	s1,s3,80002978 <iinit+0x3e>
}
    8000298c:	70a2                	ld	ra,40(sp)
    8000298e:	7402                	ld	s0,32(sp)
    80002990:	64e2                	ld	s1,24(sp)
    80002992:	6942                	ld	s2,16(sp)
    80002994:	69a2                	ld	s3,8(sp)
    80002996:	6145                	addi	sp,sp,48
    80002998:	8082                	ret

000000008000299a <ialloc>:
{
    8000299a:	715d                	addi	sp,sp,-80
    8000299c:	e486                	sd	ra,72(sp)
    8000299e:	e0a2                	sd	s0,64(sp)
    800029a0:	fc26                	sd	s1,56(sp)
    800029a2:	f84a                	sd	s2,48(sp)
    800029a4:	f44e                	sd	s3,40(sp)
    800029a6:	f052                	sd	s4,32(sp)
    800029a8:	ec56                	sd	s5,24(sp)
    800029aa:	e85a                	sd	s6,16(sp)
    800029ac:	e45e                	sd	s7,8(sp)
    800029ae:	0880                	addi	s0,sp,80
  for (inum = 1; inum < sb.ninodes; inum++)
    800029b0:	00010717          	auipc	a4,0x10
    800029b4:	fc472703          	lw	a4,-60(a4) # 80012974 <sb+0xc>
    800029b8:	4785                	li	a5,1
    800029ba:	04e7fa63          	bgeu	a5,a4,80002a0e <ialloc+0x74>
    800029be:	8aaa                	mv	s5,a0
    800029c0:	8bae                	mv	s7,a1
    800029c2:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    800029c4:	00010a17          	auipc	s4,0x10
    800029c8:	fa4a0a13          	addi	s4,s4,-92 # 80012968 <sb>
    800029cc:	00048b1b          	sext.w	s6,s1
    800029d0:	0044d593          	srli	a1,s1,0x4
    800029d4:	018a2783          	lw	a5,24(s4)
    800029d8:	9dbd                	addw	a1,a1,a5
    800029da:	8556                	mv	a0,s5
    800029dc:	00000097          	auipc	ra,0x0
    800029e0:	88e080e7          	jalr	-1906(ra) # 8000226a <bread>
    800029e4:	892a                	mv	s2,a0
    dip = (struct dinode *)bp->data + inum % IPB;
    800029e6:	05850993          	addi	s3,a0,88
    800029ea:	00f4f793          	andi	a5,s1,15
    800029ee:	079a                	slli	a5,a5,0x6
    800029f0:	99be                	add	s3,s3,a5
    if (dip->type == 0)
    800029f2:	00099783          	lh	a5,0(s3)
    800029f6:	c785                	beqz	a5,80002a1e <ialloc+0x84>
    brelse(bp);
    800029f8:	00000097          	auipc	ra,0x0
    800029fc:	9a2080e7          	jalr	-1630(ra) # 8000239a <brelse>
  for (inum = 1; inum < sb.ninodes; inum++)
    80002a00:	0485                	addi	s1,s1,1
    80002a02:	00ca2703          	lw	a4,12(s4)
    80002a06:	0004879b          	sext.w	a5,s1
    80002a0a:	fce7e1e3          	bltu	a5,a4,800029cc <ialloc+0x32>
  panic("ialloc: no inodes");
    80002a0e:	00006517          	auipc	a0,0x6
    80002a12:	b2a50513          	addi	a0,a0,-1238 # 80008538 <syscalls+0x170>
    80002a16:	00003097          	auipc	ra,0x3
    80002a1a:	3aa080e7          	jalr	938(ra) # 80005dc0 <panic>
      memset(dip, 0, sizeof(*dip));
    80002a1e:	04000613          	li	a2,64
    80002a22:	4581                	li	a1,0
    80002a24:	854e                	mv	a0,s3
    80002a26:	ffffd097          	auipc	ra,0xffffd
    80002a2a:	754080e7          	jalr	1876(ra) # 8000017a <memset>
      dip->type = type;
    80002a2e:	01799023          	sh	s7,0(s3)
      log_write(bp); // mark it allocated on the disk
    80002a32:	854a                	mv	a0,s2
    80002a34:	00001097          	auipc	ra,0x1
    80002a38:	d5e080e7          	jalr	-674(ra) # 80003792 <log_write>
      brelse(bp);
    80002a3c:	854a                	mv	a0,s2
    80002a3e:	00000097          	auipc	ra,0x0
    80002a42:	95c080e7          	jalr	-1700(ra) # 8000239a <brelse>
      return iget(dev, inum);
    80002a46:	85da                	mv	a1,s6
    80002a48:	8556                	mv	a0,s5
    80002a4a:	00000097          	auipc	ra,0x0
    80002a4e:	db4080e7          	jalr	-588(ra) # 800027fe <iget>
}
    80002a52:	60a6                	ld	ra,72(sp)
    80002a54:	6406                	ld	s0,64(sp)
    80002a56:	74e2                	ld	s1,56(sp)
    80002a58:	7942                	ld	s2,48(sp)
    80002a5a:	79a2                	ld	s3,40(sp)
    80002a5c:	7a02                	ld	s4,32(sp)
    80002a5e:	6ae2                	ld	s5,24(sp)
    80002a60:	6b42                	ld	s6,16(sp)
    80002a62:	6ba2                	ld	s7,8(sp)
    80002a64:	6161                	addi	sp,sp,80
    80002a66:	8082                	ret

0000000080002a68 <iupdate>:
{
    80002a68:	1101                	addi	sp,sp,-32
    80002a6a:	ec06                	sd	ra,24(sp)
    80002a6c:	e822                	sd	s0,16(sp)
    80002a6e:	e426                	sd	s1,8(sp)
    80002a70:	e04a                	sd	s2,0(sp)
    80002a72:	1000                	addi	s0,sp,32
    80002a74:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002a76:	415c                	lw	a5,4(a0)
    80002a78:	0047d79b          	srliw	a5,a5,0x4
    80002a7c:	00010597          	auipc	a1,0x10
    80002a80:	f045a583          	lw	a1,-252(a1) # 80012980 <sb+0x18>
    80002a84:	9dbd                	addw	a1,a1,a5
    80002a86:	4108                	lw	a0,0(a0)
    80002a88:	fffff097          	auipc	ra,0xfffff
    80002a8c:	7e2080e7          	jalr	2018(ra) # 8000226a <bread>
    80002a90:	892a                	mv	s2,a0
  dip = (struct dinode *)bp->data + ip->inum % IPB;
    80002a92:	05850793          	addi	a5,a0,88
    80002a96:	40d8                	lw	a4,4(s1)
    80002a98:	8b3d                	andi	a4,a4,15
    80002a9a:	071a                	slli	a4,a4,0x6
    80002a9c:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002a9e:	04449703          	lh	a4,68(s1)
    80002aa2:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002aa6:	04649703          	lh	a4,70(s1)
    80002aaa:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002aae:	04849703          	lh	a4,72(s1)
    80002ab2:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002ab6:	04a49703          	lh	a4,74(s1)
    80002aba:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002abe:	44f8                	lw	a4,76(s1)
    80002ac0:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002ac2:	03400613          	li	a2,52
    80002ac6:	05048593          	addi	a1,s1,80
    80002aca:	00c78513          	addi	a0,a5,12
    80002ace:	ffffd097          	auipc	ra,0xffffd
    80002ad2:	708080e7          	jalr	1800(ra) # 800001d6 <memmove>
  log_write(bp);
    80002ad6:	854a                	mv	a0,s2
    80002ad8:	00001097          	auipc	ra,0x1
    80002adc:	cba080e7          	jalr	-838(ra) # 80003792 <log_write>
  brelse(bp);
    80002ae0:	854a                	mv	a0,s2
    80002ae2:	00000097          	auipc	ra,0x0
    80002ae6:	8b8080e7          	jalr	-1864(ra) # 8000239a <brelse>
}
    80002aea:	60e2                	ld	ra,24(sp)
    80002aec:	6442                	ld	s0,16(sp)
    80002aee:	64a2                	ld	s1,8(sp)
    80002af0:	6902                	ld	s2,0(sp)
    80002af2:	6105                	addi	sp,sp,32
    80002af4:	8082                	ret

0000000080002af6 <idup>:
{
    80002af6:	1101                	addi	sp,sp,-32
    80002af8:	ec06                	sd	ra,24(sp)
    80002afa:	e822                	sd	s0,16(sp)
    80002afc:	e426                	sd	s1,8(sp)
    80002afe:	1000                	addi	s0,sp,32
    80002b00:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002b02:	00010517          	auipc	a0,0x10
    80002b06:	e8650513          	addi	a0,a0,-378 # 80012988 <itable>
    80002b0a:	00003097          	auipc	ra,0x3
    80002b0e:	7ee080e7          	jalr	2030(ra) # 800062f8 <acquire>
  ip->ref++;
    80002b12:	449c                	lw	a5,8(s1)
    80002b14:	2785                	addiw	a5,a5,1
    80002b16:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002b18:	00010517          	auipc	a0,0x10
    80002b1c:	e7050513          	addi	a0,a0,-400 # 80012988 <itable>
    80002b20:	00004097          	auipc	ra,0x4
    80002b24:	88c080e7          	jalr	-1908(ra) # 800063ac <release>
}
    80002b28:	8526                	mv	a0,s1
    80002b2a:	60e2                	ld	ra,24(sp)
    80002b2c:	6442                	ld	s0,16(sp)
    80002b2e:	64a2                	ld	s1,8(sp)
    80002b30:	6105                	addi	sp,sp,32
    80002b32:	8082                	ret

0000000080002b34 <ilock>:
{
    80002b34:	1101                	addi	sp,sp,-32
    80002b36:	ec06                	sd	ra,24(sp)
    80002b38:	e822                	sd	s0,16(sp)
    80002b3a:	e426                	sd	s1,8(sp)
    80002b3c:	e04a                	sd	s2,0(sp)
    80002b3e:	1000                	addi	s0,sp,32
  if (ip == 0 || ip->ref < 1)
    80002b40:	c115                	beqz	a0,80002b64 <ilock+0x30>
    80002b42:	84aa                	mv	s1,a0
    80002b44:	451c                	lw	a5,8(a0)
    80002b46:	00f05f63          	blez	a5,80002b64 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002b4a:	0541                	addi	a0,a0,16
    80002b4c:	00001097          	auipc	ra,0x1
    80002b50:	d64080e7          	jalr	-668(ra) # 800038b0 <acquiresleep>
  if (ip->valid == 0)
    80002b54:	40bc                	lw	a5,64(s1)
    80002b56:	cf99                	beqz	a5,80002b74 <ilock+0x40>
}
    80002b58:	60e2                	ld	ra,24(sp)
    80002b5a:	6442                	ld	s0,16(sp)
    80002b5c:	64a2                	ld	s1,8(sp)
    80002b5e:	6902                	ld	s2,0(sp)
    80002b60:	6105                	addi	sp,sp,32
    80002b62:	8082                	ret
    panic("ilock");
    80002b64:	00006517          	auipc	a0,0x6
    80002b68:	9ec50513          	addi	a0,a0,-1556 # 80008550 <syscalls+0x188>
    80002b6c:	00003097          	auipc	ra,0x3
    80002b70:	254080e7          	jalr	596(ra) # 80005dc0 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b74:	40dc                	lw	a5,4(s1)
    80002b76:	0047d79b          	srliw	a5,a5,0x4
    80002b7a:	00010597          	auipc	a1,0x10
    80002b7e:	e065a583          	lw	a1,-506(a1) # 80012980 <sb+0x18>
    80002b82:	9dbd                	addw	a1,a1,a5
    80002b84:	4088                	lw	a0,0(s1)
    80002b86:	fffff097          	auipc	ra,0xfffff
    80002b8a:	6e4080e7          	jalr	1764(ra) # 8000226a <bread>
    80002b8e:	892a                	mv	s2,a0
    dip = (struct dinode *)bp->data + ip->inum % IPB;
    80002b90:	05850593          	addi	a1,a0,88
    80002b94:	40dc                	lw	a5,4(s1)
    80002b96:	8bbd                	andi	a5,a5,15
    80002b98:	079a                	slli	a5,a5,0x6
    80002b9a:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002b9c:	00059783          	lh	a5,0(a1)
    80002ba0:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002ba4:	00259783          	lh	a5,2(a1)
    80002ba8:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002bac:	00459783          	lh	a5,4(a1)
    80002bb0:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002bb4:	00659783          	lh	a5,6(a1)
    80002bb8:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002bbc:	459c                	lw	a5,8(a1)
    80002bbe:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002bc0:	03400613          	li	a2,52
    80002bc4:	05b1                	addi	a1,a1,12
    80002bc6:	05048513          	addi	a0,s1,80
    80002bca:	ffffd097          	auipc	ra,0xffffd
    80002bce:	60c080e7          	jalr	1548(ra) # 800001d6 <memmove>
    brelse(bp);
    80002bd2:	854a                	mv	a0,s2
    80002bd4:	fffff097          	auipc	ra,0xfffff
    80002bd8:	7c6080e7          	jalr	1990(ra) # 8000239a <brelse>
    ip->valid = 1;
    80002bdc:	4785                	li	a5,1
    80002bde:	c0bc                	sw	a5,64(s1)
    if (ip->type == 0)
    80002be0:	04449783          	lh	a5,68(s1)
    80002be4:	fbb5                	bnez	a5,80002b58 <ilock+0x24>
      panic("ilock: no type");
    80002be6:	00006517          	auipc	a0,0x6
    80002bea:	97250513          	addi	a0,a0,-1678 # 80008558 <syscalls+0x190>
    80002bee:	00003097          	auipc	ra,0x3
    80002bf2:	1d2080e7          	jalr	466(ra) # 80005dc0 <panic>

0000000080002bf6 <iunlock>:
{
    80002bf6:	1101                	addi	sp,sp,-32
    80002bf8:	ec06                	sd	ra,24(sp)
    80002bfa:	e822                	sd	s0,16(sp)
    80002bfc:	e426                	sd	s1,8(sp)
    80002bfe:	e04a                	sd	s2,0(sp)
    80002c00:	1000                	addi	s0,sp,32
  if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002c02:	c905                	beqz	a0,80002c32 <iunlock+0x3c>
    80002c04:	84aa                	mv	s1,a0
    80002c06:	01050913          	addi	s2,a0,16
    80002c0a:	854a                	mv	a0,s2
    80002c0c:	00001097          	auipc	ra,0x1
    80002c10:	d3e080e7          	jalr	-706(ra) # 8000394a <holdingsleep>
    80002c14:	cd19                	beqz	a0,80002c32 <iunlock+0x3c>
    80002c16:	449c                	lw	a5,8(s1)
    80002c18:	00f05d63          	blez	a5,80002c32 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002c1c:	854a                	mv	a0,s2
    80002c1e:	00001097          	auipc	ra,0x1
    80002c22:	ce8080e7          	jalr	-792(ra) # 80003906 <releasesleep>
}
    80002c26:	60e2                	ld	ra,24(sp)
    80002c28:	6442                	ld	s0,16(sp)
    80002c2a:	64a2                	ld	s1,8(sp)
    80002c2c:	6902                	ld	s2,0(sp)
    80002c2e:	6105                	addi	sp,sp,32
    80002c30:	8082                	ret
    panic("iunlock");
    80002c32:	00006517          	auipc	a0,0x6
    80002c36:	93650513          	addi	a0,a0,-1738 # 80008568 <syscalls+0x1a0>
    80002c3a:	00003097          	auipc	ra,0x3
    80002c3e:	186080e7          	jalr	390(ra) # 80005dc0 <panic>

0000000080002c42 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void itrunc(struct inode *ip)
{
    80002c42:	715d                	addi	sp,sp,-80
    80002c44:	e486                	sd	ra,72(sp)
    80002c46:	e0a2                	sd	s0,64(sp)
    80002c48:	fc26                	sd	s1,56(sp)
    80002c4a:	f84a                	sd	s2,48(sp)
    80002c4c:	f44e                	sd	s3,40(sp)
    80002c4e:	f052                	sd	s4,32(sp)
    80002c50:	ec56                	sd	s5,24(sp)
    80002c52:	e85a                	sd	s6,16(sp)
    80002c54:	e45e                	sd	s7,8(sp)
    80002c56:	e062                	sd	s8,0(sp)
    80002c58:	0880                	addi	s0,sp,80
    80002c5a:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp, *bp2;
  uint *a, *a2;

  for (i = 0; i < NDIRECT; i++)
    80002c5c:	05050493          	addi	s1,a0,80
    80002c60:	07c50913          	addi	s2,a0,124
    80002c64:	a021                	j	80002c6c <itrunc+0x2a>
    80002c66:	0491                	addi	s1,s1,4
    80002c68:	01248d63          	beq	s1,s2,80002c82 <itrunc+0x40>
  {
    if (ip->addrs[i])
    80002c6c:	408c                	lw	a1,0(s1)
    80002c6e:	dde5                	beqz	a1,80002c66 <itrunc+0x24>
    {
      bfree(ip->dev, ip->addrs[i]);
    80002c70:	0009a503          	lw	a0,0(s3)
    80002c74:	00000097          	auipc	ra,0x0
    80002c78:	83c080e7          	jalr	-1988(ra) # 800024b0 <bfree>
      ip->addrs[i] = 0;
    80002c7c:	0004a023          	sw	zero,0(s1)
    80002c80:	b7dd                	j	80002c66 <itrunc+0x24>
    }
  }

  if (ip->addrs[NDIRECT])
    80002c82:	07c9a583          	lw	a1,124(s3)
    80002c86:	e59d                	bnez	a1,80002cb4 <itrunc+0x72>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  if (ip->addrs[NDIRECT + 1])
    80002c88:	0809a583          	lw	a1,128(s3)
    80002c8c:	eda5                	bnez	a1,80002d04 <itrunc+0xc2>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT + 1]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002c8e:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002c92:	854e                	mv	a0,s3
    80002c94:	00000097          	auipc	ra,0x0
    80002c98:	dd4080e7          	jalr	-556(ra) # 80002a68 <iupdate>
}
    80002c9c:	60a6                	ld	ra,72(sp)
    80002c9e:	6406                	ld	s0,64(sp)
    80002ca0:	74e2                	ld	s1,56(sp)
    80002ca2:	7942                	ld	s2,48(sp)
    80002ca4:	79a2                	ld	s3,40(sp)
    80002ca6:	7a02                	ld	s4,32(sp)
    80002ca8:	6ae2                	ld	s5,24(sp)
    80002caa:	6b42                	ld	s6,16(sp)
    80002cac:	6ba2                	ld	s7,8(sp)
    80002cae:	6c02                	ld	s8,0(sp)
    80002cb0:	6161                	addi	sp,sp,80
    80002cb2:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002cb4:	0009a503          	lw	a0,0(s3)
    80002cb8:	fffff097          	auipc	ra,0xfffff
    80002cbc:	5b2080e7          	jalr	1458(ra) # 8000226a <bread>
    80002cc0:	8a2a                	mv	s4,a0
    for (j = 0; j < NINDIRECT; j++)
    80002cc2:	05850493          	addi	s1,a0,88
    80002cc6:	45850913          	addi	s2,a0,1112
    80002cca:	a021                	j	80002cd2 <itrunc+0x90>
    80002ccc:	0491                	addi	s1,s1,4
    80002cce:	01248b63          	beq	s1,s2,80002ce4 <itrunc+0xa2>
      if (a[j])
    80002cd2:	408c                	lw	a1,0(s1)
    80002cd4:	dde5                	beqz	a1,80002ccc <itrunc+0x8a>
        bfree(ip->dev, a[j]);
    80002cd6:	0009a503          	lw	a0,0(s3)
    80002cda:	fffff097          	auipc	ra,0xfffff
    80002cde:	7d6080e7          	jalr	2006(ra) # 800024b0 <bfree>
    80002ce2:	b7ed                	j	80002ccc <itrunc+0x8a>
    brelse(bp);
    80002ce4:	8552                	mv	a0,s4
    80002ce6:	fffff097          	auipc	ra,0xfffff
    80002cea:	6b4080e7          	jalr	1716(ra) # 8000239a <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002cee:	07c9a583          	lw	a1,124(s3)
    80002cf2:	0009a503          	lw	a0,0(s3)
    80002cf6:	fffff097          	auipc	ra,0xfffff
    80002cfa:	7ba080e7          	jalr	1978(ra) # 800024b0 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002cfe:	0609ae23          	sw	zero,124(s3)
    80002d02:	b759                	j	80002c88 <itrunc+0x46>
    bp = bread(ip->dev, ip->addrs[NDIRECT + 1]);
    80002d04:	0009a503          	lw	a0,0(s3)
    80002d08:	fffff097          	auipc	ra,0xfffff
    80002d0c:	562080e7          	jalr	1378(ra) # 8000226a <bread>
    80002d10:	8c2a                	mv	s8,a0
    for (j = 0; j < NINDIRECT; j++)
    80002d12:	05850a13          	addi	s4,a0,88
    80002d16:	45850b13          	addi	s6,a0,1112
    80002d1a:	a83d                	j	80002d58 <itrunc+0x116>
        for (i = 0; i < NINDIRECT; i++)
    80002d1c:	0491                	addi	s1,s1,4
    80002d1e:	00990b63          	beq	s2,s1,80002d34 <itrunc+0xf2>
          if (a2[i])
    80002d22:	408c                	lw	a1,0(s1)
    80002d24:	dde5                	beqz	a1,80002d1c <itrunc+0xda>
            bfree(ip->dev, a2[i]);
    80002d26:	0009a503          	lw	a0,0(s3)
    80002d2a:	fffff097          	auipc	ra,0xfffff
    80002d2e:	786080e7          	jalr	1926(ra) # 800024b0 <bfree>
    80002d32:	b7ed                	j	80002d1c <itrunc+0xda>
        brelse(bp2);
    80002d34:	855e                	mv	a0,s7
    80002d36:	fffff097          	auipc	ra,0xfffff
    80002d3a:	664080e7          	jalr	1636(ra) # 8000239a <brelse>
        bfree(ip->dev, a[j]);
    80002d3e:	000aa583          	lw	a1,0(s5)
    80002d42:	0009a503          	lw	a0,0(s3)
    80002d46:	fffff097          	auipc	ra,0xfffff
    80002d4a:	76a080e7          	jalr	1898(ra) # 800024b0 <bfree>
        a[j] = 0;
    80002d4e:	000aa023          	sw	zero,0(s5)
    for (j = 0; j < NINDIRECT; j++)
    80002d52:	0a11                	addi	s4,s4,4
    80002d54:	036a0263          	beq	s4,s6,80002d78 <itrunc+0x136>
      if (a[j])
    80002d58:	8ad2                	mv	s5,s4
    80002d5a:	000a2583          	lw	a1,0(s4)
    80002d5e:	d9f5                	beqz	a1,80002d52 <itrunc+0x110>
        bp2 = bread(ip->dev, a[j]);
    80002d60:	0009a503          	lw	a0,0(s3)
    80002d64:	fffff097          	auipc	ra,0xfffff
    80002d68:	506080e7          	jalr	1286(ra) # 8000226a <bread>
    80002d6c:	8baa                	mv	s7,a0
        for (i = 0; i < NINDIRECT; i++)
    80002d6e:	05850493          	addi	s1,a0,88
    80002d72:	45850913          	addi	s2,a0,1112
    80002d76:	b775                	j	80002d22 <itrunc+0xe0>
    brelse(bp);
    80002d78:	8562                	mv	a0,s8
    80002d7a:	fffff097          	auipc	ra,0xfffff
    80002d7e:	620080e7          	jalr	1568(ra) # 8000239a <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT + 1]);
    80002d82:	0809a583          	lw	a1,128(s3)
    80002d86:	0009a503          	lw	a0,0(s3)
    80002d8a:	fffff097          	auipc	ra,0xfffff
    80002d8e:	726080e7          	jalr	1830(ra) # 800024b0 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002d92:	0609ae23          	sw	zero,124(s3)
    80002d96:	bde5                	j	80002c8e <itrunc+0x4c>

0000000080002d98 <iput>:
{
    80002d98:	1101                	addi	sp,sp,-32
    80002d9a:	ec06                	sd	ra,24(sp)
    80002d9c:	e822                	sd	s0,16(sp)
    80002d9e:	e426                	sd	s1,8(sp)
    80002da0:	e04a                	sd	s2,0(sp)
    80002da2:	1000                	addi	s0,sp,32
    80002da4:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002da6:	00010517          	auipc	a0,0x10
    80002daa:	be250513          	addi	a0,a0,-1054 # 80012988 <itable>
    80002dae:	00003097          	auipc	ra,0x3
    80002db2:	54a080e7          	jalr	1354(ra) # 800062f8 <acquire>
  if (ip->ref == 1 && ip->valid && ip->nlink == 0)
    80002db6:	4498                	lw	a4,8(s1)
    80002db8:	4785                	li	a5,1
    80002dba:	02f70363          	beq	a4,a5,80002de0 <iput+0x48>
  ip->ref--;
    80002dbe:	449c                	lw	a5,8(s1)
    80002dc0:	37fd                	addiw	a5,a5,-1
    80002dc2:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002dc4:	00010517          	auipc	a0,0x10
    80002dc8:	bc450513          	addi	a0,a0,-1084 # 80012988 <itable>
    80002dcc:	00003097          	auipc	ra,0x3
    80002dd0:	5e0080e7          	jalr	1504(ra) # 800063ac <release>
}
    80002dd4:	60e2                	ld	ra,24(sp)
    80002dd6:	6442                	ld	s0,16(sp)
    80002dd8:	64a2                	ld	s1,8(sp)
    80002dda:	6902                	ld	s2,0(sp)
    80002ddc:	6105                	addi	sp,sp,32
    80002dde:	8082                	ret
  if (ip->ref == 1 && ip->valid && ip->nlink == 0)
    80002de0:	40bc                	lw	a5,64(s1)
    80002de2:	dff1                	beqz	a5,80002dbe <iput+0x26>
    80002de4:	04a49783          	lh	a5,74(s1)
    80002de8:	fbf9                	bnez	a5,80002dbe <iput+0x26>
    acquiresleep(&ip->lock);
    80002dea:	01048913          	addi	s2,s1,16
    80002dee:	854a                	mv	a0,s2
    80002df0:	00001097          	auipc	ra,0x1
    80002df4:	ac0080e7          	jalr	-1344(ra) # 800038b0 <acquiresleep>
    release(&itable.lock);
    80002df8:	00010517          	auipc	a0,0x10
    80002dfc:	b9050513          	addi	a0,a0,-1136 # 80012988 <itable>
    80002e00:	00003097          	auipc	ra,0x3
    80002e04:	5ac080e7          	jalr	1452(ra) # 800063ac <release>
    itrunc(ip);
    80002e08:	8526                	mv	a0,s1
    80002e0a:	00000097          	auipc	ra,0x0
    80002e0e:	e38080e7          	jalr	-456(ra) # 80002c42 <itrunc>
    ip->type = 0;
    80002e12:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002e16:	8526                	mv	a0,s1
    80002e18:	00000097          	auipc	ra,0x0
    80002e1c:	c50080e7          	jalr	-944(ra) # 80002a68 <iupdate>
    ip->valid = 0;
    80002e20:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e24:	854a                	mv	a0,s2
    80002e26:	00001097          	auipc	ra,0x1
    80002e2a:	ae0080e7          	jalr	-1312(ra) # 80003906 <releasesleep>
    acquire(&itable.lock);
    80002e2e:	00010517          	auipc	a0,0x10
    80002e32:	b5a50513          	addi	a0,a0,-1190 # 80012988 <itable>
    80002e36:	00003097          	auipc	ra,0x3
    80002e3a:	4c2080e7          	jalr	1218(ra) # 800062f8 <acquire>
    80002e3e:	b741                	j	80002dbe <iput+0x26>

0000000080002e40 <iunlockput>:
{
    80002e40:	1101                	addi	sp,sp,-32
    80002e42:	ec06                	sd	ra,24(sp)
    80002e44:	e822                	sd	s0,16(sp)
    80002e46:	e426                	sd	s1,8(sp)
    80002e48:	1000                	addi	s0,sp,32
    80002e4a:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e4c:	00000097          	auipc	ra,0x0
    80002e50:	daa080e7          	jalr	-598(ra) # 80002bf6 <iunlock>
  iput(ip);
    80002e54:	8526                	mv	a0,s1
    80002e56:	00000097          	auipc	ra,0x0
    80002e5a:	f42080e7          	jalr	-190(ra) # 80002d98 <iput>
}
    80002e5e:	60e2                	ld	ra,24(sp)
    80002e60:	6442                	ld	s0,16(sp)
    80002e62:	64a2                	ld	s1,8(sp)
    80002e64:	6105                	addi	sp,sp,32
    80002e66:	8082                	ret

0000000080002e68 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void stati(struct inode *ip, struct stat *st)
{
    80002e68:	1141                	addi	sp,sp,-16
    80002e6a:	e422                	sd	s0,8(sp)
    80002e6c:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002e6e:	411c                	lw	a5,0(a0)
    80002e70:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002e72:	415c                	lw	a5,4(a0)
    80002e74:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002e76:	04451783          	lh	a5,68(a0)
    80002e7a:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002e7e:	04a51783          	lh	a5,74(a0)
    80002e82:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002e86:	04c56783          	lwu	a5,76(a0)
    80002e8a:	e99c                	sd	a5,16(a1)
}
    80002e8c:	6422                	ld	s0,8(sp)
    80002e8e:	0141                	addi	sp,sp,16
    80002e90:	8082                	ret

0000000080002e92 <readi>:
int readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off)
    80002e92:	457c                	lw	a5,76(a0)
    80002e94:	0ed7e963          	bltu	a5,a3,80002f86 <readi+0xf4>
{
    80002e98:	7159                	addi	sp,sp,-112
    80002e9a:	f486                	sd	ra,104(sp)
    80002e9c:	f0a2                	sd	s0,96(sp)
    80002e9e:	eca6                	sd	s1,88(sp)
    80002ea0:	e8ca                	sd	s2,80(sp)
    80002ea2:	e4ce                	sd	s3,72(sp)
    80002ea4:	e0d2                	sd	s4,64(sp)
    80002ea6:	fc56                	sd	s5,56(sp)
    80002ea8:	f85a                	sd	s6,48(sp)
    80002eaa:	f45e                	sd	s7,40(sp)
    80002eac:	f062                	sd	s8,32(sp)
    80002eae:	ec66                	sd	s9,24(sp)
    80002eb0:	e86a                	sd	s10,16(sp)
    80002eb2:	e46e                	sd	s11,8(sp)
    80002eb4:	1880                	addi	s0,sp,112
    80002eb6:	8baa                	mv	s7,a0
    80002eb8:	8c2e                	mv	s8,a1
    80002eba:	8ab2                	mv	s5,a2
    80002ebc:	84b6                	mv	s1,a3
    80002ebe:	8b3a                	mv	s6,a4
  if (off > ip->size || off + n < off)
    80002ec0:	9f35                	addw	a4,a4,a3
    return 0;
    80002ec2:	4501                	li	a0,0
  if (off > ip->size || off + n < off)
    80002ec4:	0ad76063          	bltu	a4,a3,80002f64 <readi+0xd2>
  if (off + n > ip->size)
    80002ec8:	00e7f463          	bgeu	a5,a4,80002ed0 <readi+0x3e>
    n = ip->size - off;
    80002ecc:	40d78b3b          	subw	s6,a5,a3

  for (tot = 0; tot < n; tot += m, off += m, dst += m)
    80002ed0:	0a0b0963          	beqz	s6,80002f82 <readi+0xf0>
    80002ed4:	4981                	li	s3,0
  {
    bp = bread(ip->dev, bmap(ip, off / BSIZE));
    m = min(n - tot, BSIZE - off % BSIZE);
    80002ed6:	40000d13          	li	s10,1024
    if (either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1)
    80002eda:	5cfd                	li	s9,-1
    80002edc:	a82d                	j	80002f16 <readi+0x84>
    80002ede:	020a1d93          	slli	s11,s4,0x20
    80002ee2:	020ddd93          	srli	s11,s11,0x20
    80002ee6:	05890613          	addi	a2,s2,88
    80002eea:	86ee                	mv	a3,s11
    80002eec:	963a                	add	a2,a2,a4
    80002eee:	85d6                	mv	a1,s5
    80002ef0:	8562                	mv	a0,s8
    80002ef2:	fffff097          	auipc	ra,0xfffff
    80002ef6:	9ba080e7          	jalr	-1606(ra) # 800018ac <either_copyout>
    80002efa:	05950d63          	beq	a0,s9,80002f54 <readi+0xc2>
    {
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002efe:	854a                	mv	a0,s2
    80002f00:	fffff097          	auipc	ra,0xfffff
    80002f04:	49a080e7          	jalr	1178(ra) # 8000239a <brelse>
  for (tot = 0; tot < n; tot += m, off += m, dst += m)
    80002f08:	013a09bb          	addw	s3,s4,s3
    80002f0c:	009a04bb          	addw	s1,s4,s1
    80002f10:	9aee                	add	s5,s5,s11
    80002f12:	0569f763          	bgeu	s3,s6,80002f60 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off / BSIZE));
    80002f16:	000ba903          	lw	s2,0(s7)
    80002f1a:	00a4d59b          	srliw	a1,s1,0xa
    80002f1e:	855e                	mv	a0,s7
    80002f20:	fffff097          	auipc	ra,0xfffff
    80002f24:	73a080e7          	jalr	1850(ra) # 8000265a <bmap>
    80002f28:	0005059b          	sext.w	a1,a0
    80002f2c:	854a                	mv	a0,s2
    80002f2e:	fffff097          	auipc	ra,0xfffff
    80002f32:	33c080e7          	jalr	828(ra) # 8000226a <bread>
    80002f36:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    80002f38:	3ff4f713          	andi	a4,s1,1023
    80002f3c:	40ed07bb          	subw	a5,s10,a4
    80002f40:	413b06bb          	subw	a3,s6,s3
    80002f44:	8a3e                	mv	s4,a5
    80002f46:	2781                	sext.w	a5,a5
    80002f48:	0006861b          	sext.w	a2,a3
    80002f4c:	f8f679e3          	bgeu	a2,a5,80002ede <readi+0x4c>
    80002f50:	8a36                	mv	s4,a3
    80002f52:	b771                	j	80002ede <readi+0x4c>
      brelse(bp);
    80002f54:	854a                	mv	a0,s2
    80002f56:	fffff097          	auipc	ra,0xfffff
    80002f5a:	444080e7          	jalr	1092(ra) # 8000239a <brelse>
      tot = -1;
    80002f5e:	59fd                	li	s3,-1
  }
  return tot;
    80002f60:	0009851b          	sext.w	a0,s3
}
    80002f64:	70a6                	ld	ra,104(sp)
    80002f66:	7406                	ld	s0,96(sp)
    80002f68:	64e6                	ld	s1,88(sp)
    80002f6a:	6946                	ld	s2,80(sp)
    80002f6c:	69a6                	ld	s3,72(sp)
    80002f6e:	6a06                	ld	s4,64(sp)
    80002f70:	7ae2                	ld	s5,56(sp)
    80002f72:	7b42                	ld	s6,48(sp)
    80002f74:	7ba2                	ld	s7,40(sp)
    80002f76:	7c02                	ld	s8,32(sp)
    80002f78:	6ce2                	ld	s9,24(sp)
    80002f7a:	6d42                	ld	s10,16(sp)
    80002f7c:	6da2                	ld	s11,8(sp)
    80002f7e:	6165                	addi	sp,sp,112
    80002f80:	8082                	ret
  for (tot = 0; tot < n; tot += m, off += m, dst += m)
    80002f82:	89da                	mv	s3,s6
    80002f84:	bff1                	j	80002f60 <readi+0xce>
    return 0;
    80002f86:	4501                	li	a0,0
}
    80002f88:	8082                	ret

0000000080002f8a <writei>:
int writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off)
    80002f8a:	457c                	lw	a5,76(a0)
    80002f8c:	10d7e963          	bltu	a5,a3,8000309e <writei+0x114>
{
    80002f90:	7159                	addi	sp,sp,-112
    80002f92:	f486                	sd	ra,104(sp)
    80002f94:	f0a2                	sd	s0,96(sp)
    80002f96:	eca6                	sd	s1,88(sp)
    80002f98:	e8ca                	sd	s2,80(sp)
    80002f9a:	e4ce                	sd	s3,72(sp)
    80002f9c:	e0d2                	sd	s4,64(sp)
    80002f9e:	fc56                	sd	s5,56(sp)
    80002fa0:	f85a                	sd	s6,48(sp)
    80002fa2:	f45e                	sd	s7,40(sp)
    80002fa4:	f062                	sd	s8,32(sp)
    80002fa6:	ec66                	sd	s9,24(sp)
    80002fa8:	e86a                	sd	s10,16(sp)
    80002faa:	e46e                	sd	s11,8(sp)
    80002fac:	1880                	addi	s0,sp,112
    80002fae:	8b2a                	mv	s6,a0
    80002fb0:	8c2e                	mv	s8,a1
    80002fb2:	8ab2                	mv	s5,a2
    80002fb4:	8936                	mv	s2,a3
    80002fb6:	8bba                	mv	s7,a4
  if (off > ip->size || off + n < off)
    80002fb8:	9f35                	addw	a4,a4,a3
    80002fba:	0ed76463          	bltu	a4,a3,800030a2 <writei+0x118>
    return -1;
  if (off + n > MAXFILE * BSIZE)
    80002fbe:	040437b7          	lui	a5,0x4043
    80002fc2:	c0078793          	addi	a5,a5,-1024 # 4042c00 <_entry-0x7bfbd400>
    80002fc6:	0ee7e063          	bltu	a5,a4,800030a6 <writei+0x11c>
    return -1;

  for (tot = 0; tot < n; tot += m, off += m, src += m)
    80002fca:	0c0b8863          	beqz	s7,8000309a <writei+0x110>
    80002fce:	4a01                	li	s4,0
  {
    bp = bread(ip->dev, bmap(ip, off / BSIZE));
    m = min(n - tot, BSIZE - off % BSIZE);
    80002fd0:	40000d13          	li	s10,1024
    if (either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1)
    80002fd4:	5cfd                	li	s9,-1
    80002fd6:	a091                	j	8000301a <writei+0x90>
    80002fd8:	02099d93          	slli	s11,s3,0x20
    80002fdc:	020ddd93          	srli	s11,s11,0x20
    80002fe0:	05848513          	addi	a0,s1,88
    80002fe4:	86ee                	mv	a3,s11
    80002fe6:	8656                	mv	a2,s5
    80002fe8:	85e2                	mv	a1,s8
    80002fea:	953a                	add	a0,a0,a4
    80002fec:	fffff097          	auipc	ra,0xfffff
    80002ff0:	916080e7          	jalr	-1770(ra) # 80001902 <either_copyin>
    80002ff4:	07950263          	beq	a0,s9,80003058 <writei+0xce>
    {
      brelse(bp);
      break;
    }
    log_write(bp);
    80002ff8:	8526                	mv	a0,s1
    80002ffa:	00000097          	auipc	ra,0x0
    80002ffe:	798080e7          	jalr	1944(ra) # 80003792 <log_write>
    brelse(bp);
    80003002:	8526                	mv	a0,s1
    80003004:	fffff097          	auipc	ra,0xfffff
    80003008:	396080e7          	jalr	918(ra) # 8000239a <brelse>
  for (tot = 0; tot < n; tot += m, off += m, src += m)
    8000300c:	01498a3b          	addw	s4,s3,s4
    80003010:	0129893b          	addw	s2,s3,s2
    80003014:	9aee                	add	s5,s5,s11
    80003016:	057a7663          	bgeu	s4,s7,80003062 <writei+0xd8>
    bp = bread(ip->dev, bmap(ip, off / BSIZE));
    8000301a:	000b2483          	lw	s1,0(s6)
    8000301e:	00a9559b          	srliw	a1,s2,0xa
    80003022:	855a                	mv	a0,s6
    80003024:	fffff097          	auipc	ra,0xfffff
    80003028:	636080e7          	jalr	1590(ra) # 8000265a <bmap>
    8000302c:	0005059b          	sext.w	a1,a0
    80003030:	8526                	mv	a0,s1
    80003032:	fffff097          	auipc	ra,0xfffff
    80003036:	238080e7          	jalr	568(ra) # 8000226a <bread>
    8000303a:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    8000303c:	3ff97713          	andi	a4,s2,1023
    80003040:	40ed07bb          	subw	a5,s10,a4
    80003044:	414b86bb          	subw	a3,s7,s4
    80003048:	89be                	mv	s3,a5
    8000304a:	2781                	sext.w	a5,a5
    8000304c:	0006861b          	sext.w	a2,a3
    80003050:	f8f674e3          	bgeu	a2,a5,80002fd8 <writei+0x4e>
    80003054:	89b6                	mv	s3,a3
    80003056:	b749                	j	80002fd8 <writei+0x4e>
      brelse(bp);
    80003058:	8526                	mv	a0,s1
    8000305a:	fffff097          	auipc	ra,0xfffff
    8000305e:	340080e7          	jalr	832(ra) # 8000239a <brelse>
  }

  if (off > ip->size)
    80003062:	04cb2783          	lw	a5,76(s6)
    80003066:	0127f463          	bgeu	a5,s2,8000306e <writei+0xe4>
    ip->size = off;
    8000306a:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000306e:	855a                	mv	a0,s6
    80003070:	00000097          	auipc	ra,0x0
    80003074:	9f8080e7          	jalr	-1544(ra) # 80002a68 <iupdate>

  return tot;
    80003078:	000a051b          	sext.w	a0,s4
}
    8000307c:	70a6                	ld	ra,104(sp)
    8000307e:	7406                	ld	s0,96(sp)
    80003080:	64e6                	ld	s1,88(sp)
    80003082:	6946                	ld	s2,80(sp)
    80003084:	69a6                	ld	s3,72(sp)
    80003086:	6a06                	ld	s4,64(sp)
    80003088:	7ae2                	ld	s5,56(sp)
    8000308a:	7b42                	ld	s6,48(sp)
    8000308c:	7ba2                	ld	s7,40(sp)
    8000308e:	7c02                	ld	s8,32(sp)
    80003090:	6ce2                	ld	s9,24(sp)
    80003092:	6d42                	ld	s10,16(sp)
    80003094:	6da2                	ld	s11,8(sp)
    80003096:	6165                	addi	sp,sp,112
    80003098:	8082                	ret
  for (tot = 0; tot < n; tot += m, off += m, src += m)
    8000309a:	8a5e                	mv	s4,s7
    8000309c:	bfc9                	j	8000306e <writei+0xe4>
    return -1;
    8000309e:	557d                	li	a0,-1
}
    800030a0:	8082                	ret
    return -1;
    800030a2:	557d                	li	a0,-1
    800030a4:	bfe1                	j	8000307c <writei+0xf2>
    return -1;
    800030a6:	557d                	li	a0,-1
    800030a8:	bfd1                	j	8000307c <writei+0xf2>

00000000800030aa <namecmp>:

// Directories

int namecmp(const char *s, const char *t)
{
    800030aa:	1141                	addi	sp,sp,-16
    800030ac:	e406                	sd	ra,8(sp)
    800030ae:	e022                	sd	s0,0(sp)
    800030b0:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800030b2:	4639                	li	a2,14
    800030b4:	ffffd097          	auipc	ra,0xffffd
    800030b8:	196080e7          	jalr	406(ra) # 8000024a <strncmp>
}
    800030bc:	60a2                	ld	ra,8(sp)
    800030be:	6402                	ld	s0,0(sp)
    800030c0:	0141                	addi	sp,sp,16
    800030c2:	8082                	ret

00000000800030c4 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode *
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800030c4:	7139                	addi	sp,sp,-64
    800030c6:	fc06                	sd	ra,56(sp)
    800030c8:	f822                	sd	s0,48(sp)
    800030ca:	f426                	sd	s1,40(sp)
    800030cc:	f04a                	sd	s2,32(sp)
    800030ce:	ec4e                	sd	s3,24(sp)
    800030d0:	e852                	sd	s4,16(sp)
    800030d2:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if (dp->type != T_DIR)
    800030d4:	04451703          	lh	a4,68(a0)
    800030d8:	4785                	li	a5,1
    800030da:	00f71a63          	bne	a4,a5,800030ee <dirlookup+0x2a>
    800030de:	892a                	mv	s2,a0
    800030e0:	89ae                	mv	s3,a1
    800030e2:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for (off = 0; off < dp->size; off += sizeof(de))
    800030e4:	457c                	lw	a5,76(a0)
    800030e6:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800030e8:	4501                	li	a0,0
  for (off = 0; off < dp->size; off += sizeof(de))
    800030ea:	e79d                	bnez	a5,80003118 <dirlookup+0x54>
    800030ec:	a8a5                	j	80003164 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800030ee:	00005517          	auipc	a0,0x5
    800030f2:	48250513          	addi	a0,a0,1154 # 80008570 <syscalls+0x1a8>
    800030f6:	00003097          	auipc	ra,0x3
    800030fa:	cca080e7          	jalr	-822(ra) # 80005dc0 <panic>
      panic("dirlookup read");
    800030fe:	00005517          	auipc	a0,0x5
    80003102:	48a50513          	addi	a0,a0,1162 # 80008588 <syscalls+0x1c0>
    80003106:	00003097          	auipc	ra,0x3
    8000310a:	cba080e7          	jalr	-838(ra) # 80005dc0 <panic>
  for (off = 0; off < dp->size; off += sizeof(de))
    8000310e:	24c1                	addiw	s1,s1,16
    80003110:	04c92783          	lw	a5,76(s2)
    80003114:	04f4f763          	bgeu	s1,a5,80003162 <dirlookup+0x9e>
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003118:	4741                	li	a4,16
    8000311a:	86a6                	mv	a3,s1
    8000311c:	fc040613          	addi	a2,s0,-64
    80003120:	4581                	li	a1,0
    80003122:	854a                	mv	a0,s2
    80003124:	00000097          	auipc	ra,0x0
    80003128:	d6e080e7          	jalr	-658(ra) # 80002e92 <readi>
    8000312c:	47c1                	li	a5,16
    8000312e:	fcf518e3          	bne	a0,a5,800030fe <dirlookup+0x3a>
    if (de.inum == 0)
    80003132:	fc045783          	lhu	a5,-64(s0)
    80003136:	dfe1                	beqz	a5,8000310e <dirlookup+0x4a>
    if (namecmp(name, de.name) == 0)
    80003138:	fc240593          	addi	a1,s0,-62
    8000313c:	854e                	mv	a0,s3
    8000313e:	00000097          	auipc	ra,0x0
    80003142:	f6c080e7          	jalr	-148(ra) # 800030aa <namecmp>
    80003146:	f561                	bnez	a0,8000310e <dirlookup+0x4a>
      if (poff)
    80003148:	000a0463          	beqz	s4,80003150 <dirlookup+0x8c>
        *poff = off;
    8000314c:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003150:	fc045583          	lhu	a1,-64(s0)
    80003154:	00092503          	lw	a0,0(s2)
    80003158:	fffff097          	auipc	ra,0xfffff
    8000315c:	6a6080e7          	jalr	1702(ra) # 800027fe <iget>
    80003160:	a011                	j	80003164 <dirlookup+0xa0>
  return 0;
    80003162:	4501                	li	a0,0
}
    80003164:	70e2                	ld	ra,56(sp)
    80003166:	7442                	ld	s0,48(sp)
    80003168:	74a2                	ld	s1,40(sp)
    8000316a:	7902                	ld	s2,32(sp)
    8000316c:	69e2                	ld	s3,24(sp)
    8000316e:	6a42                	ld	s4,16(sp)
    80003170:	6121                	addi	sp,sp,64
    80003172:	8082                	ret

0000000080003174 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode *
namex(char *path, int nameiparent, char *name)
{
    80003174:	711d                	addi	sp,sp,-96
    80003176:	ec86                	sd	ra,88(sp)
    80003178:	e8a2                	sd	s0,80(sp)
    8000317a:	e4a6                	sd	s1,72(sp)
    8000317c:	e0ca                	sd	s2,64(sp)
    8000317e:	fc4e                	sd	s3,56(sp)
    80003180:	f852                	sd	s4,48(sp)
    80003182:	f456                	sd	s5,40(sp)
    80003184:	f05a                	sd	s6,32(sp)
    80003186:	ec5e                	sd	s7,24(sp)
    80003188:	e862                	sd	s8,16(sp)
    8000318a:	e466                	sd	s9,8(sp)
    8000318c:	e06a                	sd	s10,0(sp)
    8000318e:	1080                	addi	s0,sp,96
    80003190:	84aa                	mv	s1,a0
    80003192:	8b2e                	mv	s6,a1
    80003194:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if (*path == '/')
    80003196:	00054703          	lbu	a4,0(a0)
    8000319a:	02f00793          	li	a5,47
    8000319e:	02f70363          	beq	a4,a5,800031c4 <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800031a2:	ffffe097          	auipc	ra,0xffffe
    800031a6:	ca2080e7          	jalr	-862(ra) # 80000e44 <myproc>
    800031aa:	15053503          	ld	a0,336(a0)
    800031ae:	00000097          	auipc	ra,0x0
    800031b2:	948080e7          	jalr	-1720(ra) # 80002af6 <idup>
    800031b6:	8a2a                	mv	s4,a0
  while (*path == '/')
    800031b8:	02f00913          	li	s2,47
  if (len >= DIRSIZ)
    800031bc:	4cb5                	li	s9,13
  len = path - s;
    800031be:	4b81                	li	s7,0

  while ((path = skipelem(path, name)) != 0)
  {
    ilock(ip);
    if (ip->type != T_DIR)
    800031c0:	4c05                	li	s8,1
    800031c2:	a87d                	j	80003280 <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    800031c4:	4585                	li	a1,1
    800031c6:	4505                	li	a0,1
    800031c8:	fffff097          	auipc	ra,0xfffff
    800031cc:	636080e7          	jalr	1590(ra) # 800027fe <iget>
    800031d0:	8a2a                	mv	s4,a0
    800031d2:	b7dd                	j	800031b8 <namex+0x44>
    {
      iunlockput(ip);
    800031d4:	8552                	mv	a0,s4
    800031d6:	00000097          	auipc	ra,0x0
    800031da:	c6a080e7          	jalr	-918(ra) # 80002e40 <iunlockput>
      return 0;
    800031de:	4a01                	li	s4,0
  {
    iput(ip);
    return 0;
  }
  return ip;
}
    800031e0:	8552                	mv	a0,s4
    800031e2:	60e6                	ld	ra,88(sp)
    800031e4:	6446                	ld	s0,80(sp)
    800031e6:	64a6                	ld	s1,72(sp)
    800031e8:	6906                	ld	s2,64(sp)
    800031ea:	79e2                	ld	s3,56(sp)
    800031ec:	7a42                	ld	s4,48(sp)
    800031ee:	7aa2                	ld	s5,40(sp)
    800031f0:	7b02                	ld	s6,32(sp)
    800031f2:	6be2                	ld	s7,24(sp)
    800031f4:	6c42                	ld	s8,16(sp)
    800031f6:	6ca2                	ld	s9,8(sp)
    800031f8:	6d02                	ld	s10,0(sp)
    800031fa:	6125                	addi	sp,sp,96
    800031fc:	8082                	ret
      iunlock(ip);
    800031fe:	8552                	mv	a0,s4
    80003200:	00000097          	auipc	ra,0x0
    80003204:	9f6080e7          	jalr	-1546(ra) # 80002bf6 <iunlock>
      return ip;
    80003208:	bfe1                	j	800031e0 <namex+0x6c>
      iunlockput(ip);
    8000320a:	8552                	mv	a0,s4
    8000320c:	00000097          	auipc	ra,0x0
    80003210:	c34080e7          	jalr	-972(ra) # 80002e40 <iunlockput>
      return 0;
    80003214:	8a4e                	mv	s4,s3
    80003216:	b7e9                	j	800031e0 <namex+0x6c>
  len = path - s;
    80003218:	40998633          	sub	a2,s3,s1
    8000321c:	00060d1b          	sext.w	s10,a2
  if (len >= DIRSIZ)
    80003220:	09acd863          	bge	s9,s10,800032b0 <namex+0x13c>
    memmove(name, s, DIRSIZ);
    80003224:	4639                	li	a2,14
    80003226:	85a6                	mv	a1,s1
    80003228:	8556                	mv	a0,s5
    8000322a:	ffffd097          	auipc	ra,0xffffd
    8000322e:	fac080e7          	jalr	-84(ra) # 800001d6 <memmove>
    80003232:	84ce                	mv	s1,s3
  while (*path == '/')
    80003234:	0004c783          	lbu	a5,0(s1)
    80003238:	01279763          	bne	a5,s2,80003246 <namex+0xd2>
    path++;
    8000323c:	0485                	addi	s1,s1,1
  while (*path == '/')
    8000323e:	0004c783          	lbu	a5,0(s1)
    80003242:	ff278de3          	beq	a5,s2,8000323c <namex+0xc8>
    ilock(ip);
    80003246:	8552                	mv	a0,s4
    80003248:	00000097          	auipc	ra,0x0
    8000324c:	8ec080e7          	jalr	-1812(ra) # 80002b34 <ilock>
    if (ip->type != T_DIR)
    80003250:	044a1783          	lh	a5,68(s4)
    80003254:	f98790e3          	bne	a5,s8,800031d4 <namex+0x60>
    if (nameiparent && *path == '\0')
    80003258:	000b0563          	beqz	s6,80003262 <namex+0xee>
    8000325c:	0004c783          	lbu	a5,0(s1)
    80003260:	dfd9                	beqz	a5,800031fe <namex+0x8a>
    if ((next = dirlookup(ip, name, 0)) == 0)
    80003262:	865e                	mv	a2,s7
    80003264:	85d6                	mv	a1,s5
    80003266:	8552                	mv	a0,s4
    80003268:	00000097          	auipc	ra,0x0
    8000326c:	e5c080e7          	jalr	-420(ra) # 800030c4 <dirlookup>
    80003270:	89aa                	mv	s3,a0
    80003272:	dd41                	beqz	a0,8000320a <namex+0x96>
    iunlockput(ip);
    80003274:	8552                	mv	a0,s4
    80003276:	00000097          	auipc	ra,0x0
    8000327a:	bca080e7          	jalr	-1078(ra) # 80002e40 <iunlockput>
    ip = next;
    8000327e:	8a4e                	mv	s4,s3
  while (*path == '/')
    80003280:	0004c783          	lbu	a5,0(s1)
    80003284:	01279763          	bne	a5,s2,80003292 <namex+0x11e>
    path++;
    80003288:	0485                	addi	s1,s1,1
  while (*path == '/')
    8000328a:	0004c783          	lbu	a5,0(s1)
    8000328e:	ff278de3          	beq	a5,s2,80003288 <namex+0x114>
  if (*path == 0)
    80003292:	cb9d                	beqz	a5,800032c8 <namex+0x154>
  while (*path != '/' && *path != 0)
    80003294:	0004c783          	lbu	a5,0(s1)
    80003298:	89a6                	mv	s3,s1
  len = path - s;
    8000329a:	8d5e                	mv	s10,s7
    8000329c:	865e                	mv	a2,s7
  while (*path != '/' && *path != 0)
    8000329e:	01278963          	beq	a5,s2,800032b0 <namex+0x13c>
    800032a2:	dbbd                	beqz	a5,80003218 <namex+0xa4>
    path++;
    800032a4:	0985                	addi	s3,s3,1
  while (*path != '/' && *path != 0)
    800032a6:	0009c783          	lbu	a5,0(s3)
    800032aa:	ff279ce3          	bne	a5,s2,800032a2 <namex+0x12e>
    800032ae:	b7ad                	j	80003218 <namex+0xa4>
    memmove(name, s, len);
    800032b0:	2601                	sext.w	a2,a2
    800032b2:	85a6                	mv	a1,s1
    800032b4:	8556                	mv	a0,s5
    800032b6:	ffffd097          	auipc	ra,0xffffd
    800032ba:	f20080e7          	jalr	-224(ra) # 800001d6 <memmove>
    name[len] = 0;
    800032be:	9d56                	add	s10,s10,s5
    800032c0:	000d0023          	sb	zero,0(s10)
    800032c4:	84ce                	mv	s1,s3
    800032c6:	b7bd                	j	80003234 <namex+0xc0>
  if (nameiparent)
    800032c8:	f00b0ce3          	beqz	s6,800031e0 <namex+0x6c>
    iput(ip);
    800032cc:	8552                	mv	a0,s4
    800032ce:	00000097          	auipc	ra,0x0
    800032d2:	aca080e7          	jalr	-1334(ra) # 80002d98 <iput>
    return 0;
    800032d6:	4a01                	li	s4,0
    800032d8:	b721                	j	800031e0 <namex+0x6c>

00000000800032da <dirlink>:
{
    800032da:	7139                	addi	sp,sp,-64
    800032dc:	fc06                	sd	ra,56(sp)
    800032de:	f822                	sd	s0,48(sp)
    800032e0:	f426                	sd	s1,40(sp)
    800032e2:	f04a                	sd	s2,32(sp)
    800032e4:	ec4e                	sd	s3,24(sp)
    800032e6:	e852                	sd	s4,16(sp)
    800032e8:	0080                	addi	s0,sp,64
    800032ea:	892a                	mv	s2,a0
    800032ec:	8a2e                	mv	s4,a1
    800032ee:	89b2                	mv	s3,a2
  if ((ip = dirlookup(dp, name, 0)) != 0)
    800032f0:	4601                	li	a2,0
    800032f2:	00000097          	auipc	ra,0x0
    800032f6:	dd2080e7          	jalr	-558(ra) # 800030c4 <dirlookup>
    800032fa:	e93d                	bnez	a0,80003370 <dirlink+0x96>
  for (off = 0; off < dp->size; off += sizeof(de))
    800032fc:	04c92483          	lw	s1,76(s2)
    80003300:	c49d                	beqz	s1,8000332e <dirlink+0x54>
    80003302:	4481                	li	s1,0
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003304:	4741                	li	a4,16
    80003306:	86a6                	mv	a3,s1
    80003308:	fc040613          	addi	a2,s0,-64
    8000330c:	4581                	li	a1,0
    8000330e:	854a                	mv	a0,s2
    80003310:	00000097          	auipc	ra,0x0
    80003314:	b82080e7          	jalr	-1150(ra) # 80002e92 <readi>
    80003318:	47c1                	li	a5,16
    8000331a:	06f51163          	bne	a0,a5,8000337c <dirlink+0xa2>
    if (de.inum == 0)
    8000331e:	fc045783          	lhu	a5,-64(s0)
    80003322:	c791                	beqz	a5,8000332e <dirlink+0x54>
  for (off = 0; off < dp->size; off += sizeof(de))
    80003324:	24c1                	addiw	s1,s1,16
    80003326:	04c92783          	lw	a5,76(s2)
    8000332a:	fcf4ede3          	bltu	s1,a5,80003304 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000332e:	4639                	li	a2,14
    80003330:	85d2                	mv	a1,s4
    80003332:	fc240513          	addi	a0,s0,-62
    80003336:	ffffd097          	auipc	ra,0xffffd
    8000333a:	f50080e7          	jalr	-176(ra) # 80000286 <strncpy>
  de.inum = inum;
    8000333e:	fd341023          	sh	s3,-64(s0)
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003342:	4741                	li	a4,16
    80003344:	86a6                	mv	a3,s1
    80003346:	fc040613          	addi	a2,s0,-64
    8000334a:	4581                	li	a1,0
    8000334c:	854a                	mv	a0,s2
    8000334e:	00000097          	auipc	ra,0x0
    80003352:	c3c080e7          	jalr	-964(ra) # 80002f8a <writei>
    80003356:	872a                	mv	a4,a0
    80003358:	47c1                	li	a5,16
  return 0;
    8000335a:	4501                	li	a0,0
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000335c:	02f71863          	bne	a4,a5,8000338c <dirlink+0xb2>
}
    80003360:	70e2                	ld	ra,56(sp)
    80003362:	7442                	ld	s0,48(sp)
    80003364:	74a2                	ld	s1,40(sp)
    80003366:	7902                	ld	s2,32(sp)
    80003368:	69e2                	ld	s3,24(sp)
    8000336a:	6a42                	ld	s4,16(sp)
    8000336c:	6121                	addi	sp,sp,64
    8000336e:	8082                	ret
    iput(ip);
    80003370:	00000097          	auipc	ra,0x0
    80003374:	a28080e7          	jalr	-1496(ra) # 80002d98 <iput>
    return -1;
    80003378:	557d                	li	a0,-1
    8000337a:	b7dd                	j	80003360 <dirlink+0x86>
      panic("dirlink read");
    8000337c:	00005517          	auipc	a0,0x5
    80003380:	21c50513          	addi	a0,a0,540 # 80008598 <syscalls+0x1d0>
    80003384:	00003097          	auipc	ra,0x3
    80003388:	a3c080e7          	jalr	-1476(ra) # 80005dc0 <panic>
    panic("dirlink");
    8000338c:	00005517          	auipc	a0,0x5
    80003390:	31c50513          	addi	a0,a0,796 # 800086a8 <syscalls+0x2e0>
    80003394:	00003097          	auipc	ra,0x3
    80003398:	a2c080e7          	jalr	-1492(ra) # 80005dc0 <panic>

000000008000339c <namei>:

struct inode *
namei(char *path)
{
    8000339c:	1101                	addi	sp,sp,-32
    8000339e:	ec06                	sd	ra,24(sp)
    800033a0:	e822                	sd	s0,16(sp)
    800033a2:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800033a4:	fe040613          	addi	a2,s0,-32
    800033a8:	4581                	li	a1,0
    800033aa:	00000097          	auipc	ra,0x0
    800033ae:	dca080e7          	jalr	-566(ra) # 80003174 <namex>
}
    800033b2:	60e2                	ld	ra,24(sp)
    800033b4:	6442                	ld	s0,16(sp)
    800033b6:	6105                	addi	sp,sp,32
    800033b8:	8082                	ret

00000000800033ba <nameiparent>:

struct inode *
nameiparent(char *path, char *name)
{
    800033ba:	1141                	addi	sp,sp,-16
    800033bc:	e406                	sd	ra,8(sp)
    800033be:	e022                	sd	s0,0(sp)
    800033c0:	0800                	addi	s0,sp,16
    800033c2:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800033c4:	4585                	li	a1,1
    800033c6:	00000097          	auipc	ra,0x0
    800033ca:	dae080e7          	jalr	-594(ra) # 80003174 <namex>
}
    800033ce:	60a2                	ld	ra,8(sp)
    800033d0:	6402                	ld	s0,0(sp)
    800033d2:	0141                	addi	sp,sp,16
    800033d4:	8082                	ret

00000000800033d6 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800033d6:	1101                	addi	sp,sp,-32
    800033d8:	ec06                	sd	ra,24(sp)
    800033da:	e822                	sd	s0,16(sp)
    800033dc:	e426                	sd	s1,8(sp)
    800033de:	e04a                	sd	s2,0(sp)
    800033e0:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800033e2:	00011917          	auipc	s2,0x11
    800033e6:	04e90913          	addi	s2,s2,78 # 80014430 <log>
    800033ea:	01892583          	lw	a1,24(s2)
    800033ee:	02892503          	lw	a0,40(s2)
    800033f2:	fffff097          	auipc	ra,0xfffff
    800033f6:	e78080e7          	jalr	-392(ra) # 8000226a <bread>
    800033fa:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800033fc:	02c92683          	lw	a3,44(s2)
    80003400:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003402:	02d05863          	blez	a3,80003432 <write_head+0x5c>
    80003406:	00011797          	auipc	a5,0x11
    8000340a:	05a78793          	addi	a5,a5,90 # 80014460 <log+0x30>
    8000340e:	05c50713          	addi	a4,a0,92
    80003412:	36fd                	addiw	a3,a3,-1
    80003414:	02069613          	slli	a2,a3,0x20
    80003418:	01e65693          	srli	a3,a2,0x1e
    8000341c:	00011617          	auipc	a2,0x11
    80003420:	04860613          	addi	a2,a2,72 # 80014464 <log+0x34>
    80003424:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003426:	4390                	lw	a2,0(a5)
    80003428:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000342a:	0791                	addi	a5,a5,4
    8000342c:	0711                	addi	a4,a4,4
    8000342e:	fed79ce3          	bne	a5,a3,80003426 <write_head+0x50>
  }
  bwrite(buf);
    80003432:	8526                	mv	a0,s1
    80003434:	fffff097          	auipc	ra,0xfffff
    80003438:	f28080e7          	jalr	-216(ra) # 8000235c <bwrite>
  brelse(buf);
    8000343c:	8526                	mv	a0,s1
    8000343e:	fffff097          	auipc	ra,0xfffff
    80003442:	f5c080e7          	jalr	-164(ra) # 8000239a <brelse>
}
    80003446:	60e2                	ld	ra,24(sp)
    80003448:	6442                	ld	s0,16(sp)
    8000344a:	64a2                	ld	s1,8(sp)
    8000344c:	6902                	ld	s2,0(sp)
    8000344e:	6105                	addi	sp,sp,32
    80003450:	8082                	ret

0000000080003452 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003452:	00011797          	auipc	a5,0x11
    80003456:	00a7a783          	lw	a5,10(a5) # 8001445c <log+0x2c>
    8000345a:	0af05d63          	blez	a5,80003514 <install_trans+0xc2>
{
    8000345e:	7139                	addi	sp,sp,-64
    80003460:	fc06                	sd	ra,56(sp)
    80003462:	f822                	sd	s0,48(sp)
    80003464:	f426                	sd	s1,40(sp)
    80003466:	f04a                	sd	s2,32(sp)
    80003468:	ec4e                	sd	s3,24(sp)
    8000346a:	e852                	sd	s4,16(sp)
    8000346c:	e456                	sd	s5,8(sp)
    8000346e:	e05a                	sd	s6,0(sp)
    80003470:	0080                	addi	s0,sp,64
    80003472:	8b2a                	mv	s6,a0
    80003474:	00011a97          	auipc	s5,0x11
    80003478:	feca8a93          	addi	s5,s5,-20 # 80014460 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000347c:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000347e:	00011997          	auipc	s3,0x11
    80003482:	fb298993          	addi	s3,s3,-78 # 80014430 <log>
    80003486:	a00d                	j	800034a8 <install_trans+0x56>
    brelse(lbuf);
    80003488:	854a                	mv	a0,s2
    8000348a:	fffff097          	auipc	ra,0xfffff
    8000348e:	f10080e7          	jalr	-240(ra) # 8000239a <brelse>
    brelse(dbuf);
    80003492:	8526                	mv	a0,s1
    80003494:	fffff097          	auipc	ra,0xfffff
    80003498:	f06080e7          	jalr	-250(ra) # 8000239a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000349c:	2a05                	addiw	s4,s4,1
    8000349e:	0a91                	addi	s5,s5,4
    800034a0:	02c9a783          	lw	a5,44(s3)
    800034a4:	04fa5e63          	bge	s4,a5,80003500 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034a8:	0189a583          	lw	a1,24(s3)
    800034ac:	014585bb          	addw	a1,a1,s4
    800034b0:	2585                	addiw	a1,a1,1
    800034b2:	0289a503          	lw	a0,40(s3)
    800034b6:	fffff097          	auipc	ra,0xfffff
    800034ba:	db4080e7          	jalr	-588(ra) # 8000226a <bread>
    800034be:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800034c0:	000aa583          	lw	a1,0(s5)
    800034c4:	0289a503          	lw	a0,40(s3)
    800034c8:	fffff097          	auipc	ra,0xfffff
    800034cc:	da2080e7          	jalr	-606(ra) # 8000226a <bread>
    800034d0:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800034d2:	40000613          	li	a2,1024
    800034d6:	05890593          	addi	a1,s2,88
    800034da:	05850513          	addi	a0,a0,88
    800034de:	ffffd097          	auipc	ra,0xffffd
    800034e2:	cf8080e7          	jalr	-776(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    800034e6:	8526                	mv	a0,s1
    800034e8:	fffff097          	auipc	ra,0xfffff
    800034ec:	e74080e7          	jalr	-396(ra) # 8000235c <bwrite>
    if(recovering == 0)
    800034f0:	f80b1ce3          	bnez	s6,80003488 <install_trans+0x36>
      bunpin(dbuf);
    800034f4:	8526                	mv	a0,s1
    800034f6:	fffff097          	auipc	ra,0xfffff
    800034fa:	f7e080e7          	jalr	-130(ra) # 80002474 <bunpin>
    800034fe:	b769                	j	80003488 <install_trans+0x36>
}
    80003500:	70e2                	ld	ra,56(sp)
    80003502:	7442                	ld	s0,48(sp)
    80003504:	74a2                	ld	s1,40(sp)
    80003506:	7902                	ld	s2,32(sp)
    80003508:	69e2                	ld	s3,24(sp)
    8000350a:	6a42                	ld	s4,16(sp)
    8000350c:	6aa2                	ld	s5,8(sp)
    8000350e:	6b02                	ld	s6,0(sp)
    80003510:	6121                	addi	sp,sp,64
    80003512:	8082                	ret
    80003514:	8082                	ret

0000000080003516 <initlog>:
{
    80003516:	7179                	addi	sp,sp,-48
    80003518:	f406                	sd	ra,40(sp)
    8000351a:	f022                	sd	s0,32(sp)
    8000351c:	ec26                	sd	s1,24(sp)
    8000351e:	e84a                	sd	s2,16(sp)
    80003520:	e44e                	sd	s3,8(sp)
    80003522:	1800                	addi	s0,sp,48
    80003524:	892a                	mv	s2,a0
    80003526:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003528:	00011497          	auipc	s1,0x11
    8000352c:	f0848493          	addi	s1,s1,-248 # 80014430 <log>
    80003530:	00005597          	auipc	a1,0x5
    80003534:	07858593          	addi	a1,a1,120 # 800085a8 <syscalls+0x1e0>
    80003538:	8526                	mv	a0,s1
    8000353a:	00003097          	auipc	ra,0x3
    8000353e:	d2e080e7          	jalr	-722(ra) # 80006268 <initlock>
  log.start = sb->logstart;
    80003542:	0149a583          	lw	a1,20(s3)
    80003546:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003548:	0109a783          	lw	a5,16(s3)
    8000354c:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000354e:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003552:	854a                	mv	a0,s2
    80003554:	fffff097          	auipc	ra,0xfffff
    80003558:	d16080e7          	jalr	-746(ra) # 8000226a <bread>
  log.lh.n = lh->n;
    8000355c:	4d34                	lw	a3,88(a0)
    8000355e:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003560:	02d05663          	blez	a3,8000358c <initlog+0x76>
    80003564:	05c50793          	addi	a5,a0,92
    80003568:	00011717          	auipc	a4,0x11
    8000356c:	ef870713          	addi	a4,a4,-264 # 80014460 <log+0x30>
    80003570:	36fd                	addiw	a3,a3,-1
    80003572:	02069613          	slli	a2,a3,0x20
    80003576:	01e65693          	srli	a3,a2,0x1e
    8000357a:	06050613          	addi	a2,a0,96
    8000357e:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80003580:	4390                	lw	a2,0(a5)
    80003582:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003584:	0791                	addi	a5,a5,4
    80003586:	0711                	addi	a4,a4,4
    80003588:	fed79ce3          	bne	a5,a3,80003580 <initlog+0x6a>
  brelse(buf);
    8000358c:	fffff097          	auipc	ra,0xfffff
    80003590:	e0e080e7          	jalr	-498(ra) # 8000239a <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003594:	4505                	li	a0,1
    80003596:	00000097          	auipc	ra,0x0
    8000359a:	ebc080e7          	jalr	-324(ra) # 80003452 <install_trans>
  log.lh.n = 0;
    8000359e:	00011797          	auipc	a5,0x11
    800035a2:	ea07af23          	sw	zero,-322(a5) # 8001445c <log+0x2c>
  write_head(); // clear the log
    800035a6:	00000097          	auipc	ra,0x0
    800035aa:	e30080e7          	jalr	-464(ra) # 800033d6 <write_head>
}
    800035ae:	70a2                	ld	ra,40(sp)
    800035b0:	7402                	ld	s0,32(sp)
    800035b2:	64e2                	ld	s1,24(sp)
    800035b4:	6942                	ld	s2,16(sp)
    800035b6:	69a2                	ld	s3,8(sp)
    800035b8:	6145                	addi	sp,sp,48
    800035ba:	8082                	ret

00000000800035bc <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800035bc:	1101                	addi	sp,sp,-32
    800035be:	ec06                	sd	ra,24(sp)
    800035c0:	e822                	sd	s0,16(sp)
    800035c2:	e426                	sd	s1,8(sp)
    800035c4:	e04a                	sd	s2,0(sp)
    800035c6:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800035c8:	00011517          	auipc	a0,0x11
    800035cc:	e6850513          	addi	a0,a0,-408 # 80014430 <log>
    800035d0:	00003097          	auipc	ra,0x3
    800035d4:	d28080e7          	jalr	-728(ra) # 800062f8 <acquire>
  while(1){
    if(log.committing){
    800035d8:	00011497          	auipc	s1,0x11
    800035dc:	e5848493          	addi	s1,s1,-424 # 80014430 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035e0:	4979                	li	s2,30
    800035e2:	a039                	j	800035f0 <begin_op+0x34>
      sleep(&log, &log.lock);
    800035e4:	85a6                	mv	a1,s1
    800035e6:	8526                	mv	a0,s1
    800035e8:	ffffe097          	auipc	ra,0xffffe
    800035ec:	f20080e7          	jalr	-224(ra) # 80001508 <sleep>
    if(log.committing){
    800035f0:	50dc                	lw	a5,36(s1)
    800035f2:	fbed                	bnez	a5,800035e4 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035f4:	5098                	lw	a4,32(s1)
    800035f6:	2705                	addiw	a4,a4,1
    800035f8:	0007069b          	sext.w	a3,a4
    800035fc:	0027179b          	slliw	a5,a4,0x2
    80003600:	9fb9                	addw	a5,a5,a4
    80003602:	0017979b          	slliw	a5,a5,0x1
    80003606:	54d8                	lw	a4,44(s1)
    80003608:	9fb9                	addw	a5,a5,a4
    8000360a:	00f95963          	bge	s2,a5,8000361c <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000360e:	85a6                	mv	a1,s1
    80003610:	8526                	mv	a0,s1
    80003612:	ffffe097          	auipc	ra,0xffffe
    80003616:	ef6080e7          	jalr	-266(ra) # 80001508 <sleep>
    8000361a:	bfd9                	j	800035f0 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000361c:	00011517          	auipc	a0,0x11
    80003620:	e1450513          	addi	a0,a0,-492 # 80014430 <log>
    80003624:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003626:	00003097          	auipc	ra,0x3
    8000362a:	d86080e7          	jalr	-634(ra) # 800063ac <release>
      break;
    }
  }
}
    8000362e:	60e2                	ld	ra,24(sp)
    80003630:	6442                	ld	s0,16(sp)
    80003632:	64a2                	ld	s1,8(sp)
    80003634:	6902                	ld	s2,0(sp)
    80003636:	6105                	addi	sp,sp,32
    80003638:	8082                	ret

000000008000363a <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000363a:	7139                	addi	sp,sp,-64
    8000363c:	fc06                	sd	ra,56(sp)
    8000363e:	f822                	sd	s0,48(sp)
    80003640:	f426                	sd	s1,40(sp)
    80003642:	f04a                	sd	s2,32(sp)
    80003644:	ec4e                	sd	s3,24(sp)
    80003646:	e852                	sd	s4,16(sp)
    80003648:	e456                	sd	s5,8(sp)
    8000364a:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000364c:	00011497          	auipc	s1,0x11
    80003650:	de448493          	addi	s1,s1,-540 # 80014430 <log>
    80003654:	8526                	mv	a0,s1
    80003656:	00003097          	auipc	ra,0x3
    8000365a:	ca2080e7          	jalr	-862(ra) # 800062f8 <acquire>
  log.outstanding -= 1;
    8000365e:	509c                	lw	a5,32(s1)
    80003660:	37fd                	addiw	a5,a5,-1
    80003662:	0007891b          	sext.w	s2,a5
    80003666:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003668:	50dc                	lw	a5,36(s1)
    8000366a:	e7b9                	bnez	a5,800036b8 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000366c:	04091e63          	bnez	s2,800036c8 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80003670:	00011497          	auipc	s1,0x11
    80003674:	dc048493          	addi	s1,s1,-576 # 80014430 <log>
    80003678:	4785                	li	a5,1
    8000367a:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000367c:	8526                	mv	a0,s1
    8000367e:	00003097          	auipc	ra,0x3
    80003682:	d2e080e7          	jalr	-722(ra) # 800063ac <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003686:	54dc                	lw	a5,44(s1)
    80003688:	06f04763          	bgtz	a5,800036f6 <end_op+0xbc>
    acquire(&log.lock);
    8000368c:	00011497          	auipc	s1,0x11
    80003690:	da448493          	addi	s1,s1,-604 # 80014430 <log>
    80003694:	8526                	mv	a0,s1
    80003696:	00003097          	auipc	ra,0x3
    8000369a:	c62080e7          	jalr	-926(ra) # 800062f8 <acquire>
    log.committing = 0;
    8000369e:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800036a2:	8526                	mv	a0,s1
    800036a4:	ffffe097          	auipc	ra,0xffffe
    800036a8:	ff0080e7          	jalr	-16(ra) # 80001694 <wakeup>
    release(&log.lock);
    800036ac:	8526                	mv	a0,s1
    800036ae:	00003097          	auipc	ra,0x3
    800036b2:	cfe080e7          	jalr	-770(ra) # 800063ac <release>
}
    800036b6:	a03d                	j	800036e4 <end_op+0xaa>
    panic("log.committing");
    800036b8:	00005517          	auipc	a0,0x5
    800036bc:	ef850513          	addi	a0,a0,-264 # 800085b0 <syscalls+0x1e8>
    800036c0:	00002097          	auipc	ra,0x2
    800036c4:	700080e7          	jalr	1792(ra) # 80005dc0 <panic>
    wakeup(&log);
    800036c8:	00011497          	auipc	s1,0x11
    800036cc:	d6848493          	addi	s1,s1,-664 # 80014430 <log>
    800036d0:	8526                	mv	a0,s1
    800036d2:	ffffe097          	auipc	ra,0xffffe
    800036d6:	fc2080e7          	jalr	-62(ra) # 80001694 <wakeup>
  release(&log.lock);
    800036da:	8526                	mv	a0,s1
    800036dc:	00003097          	auipc	ra,0x3
    800036e0:	cd0080e7          	jalr	-816(ra) # 800063ac <release>
}
    800036e4:	70e2                	ld	ra,56(sp)
    800036e6:	7442                	ld	s0,48(sp)
    800036e8:	74a2                	ld	s1,40(sp)
    800036ea:	7902                	ld	s2,32(sp)
    800036ec:	69e2                	ld	s3,24(sp)
    800036ee:	6a42                	ld	s4,16(sp)
    800036f0:	6aa2                	ld	s5,8(sp)
    800036f2:	6121                	addi	sp,sp,64
    800036f4:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800036f6:	00011a97          	auipc	s5,0x11
    800036fa:	d6aa8a93          	addi	s5,s5,-662 # 80014460 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800036fe:	00011a17          	auipc	s4,0x11
    80003702:	d32a0a13          	addi	s4,s4,-718 # 80014430 <log>
    80003706:	018a2583          	lw	a1,24(s4)
    8000370a:	012585bb          	addw	a1,a1,s2
    8000370e:	2585                	addiw	a1,a1,1
    80003710:	028a2503          	lw	a0,40(s4)
    80003714:	fffff097          	auipc	ra,0xfffff
    80003718:	b56080e7          	jalr	-1194(ra) # 8000226a <bread>
    8000371c:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000371e:	000aa583          	lw	a1,0(s5)
    80003722:	028a2503          	lw	a0,40(s4)
    80003726:	fffff097          	auipc	ra,0xfffff
    8000372a:	b44080e7          	jalr	-1212(ra) # 8000226a <bread>
    8000372e:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003730:	40000613          	li	a2,1024
    80003734:	05850593          	addi	a1,a0,88
    80003738:	05848513          	addi	a0,s1,88
    8000373c:	ffffd097          	auipc	ra,0xffffd
    80003740:	a9a080e7          	jalr	-1382(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    80003744:	8526                	mv	a0,s1
    80003746:	fffff097          	auipc	ra,0xfffff
    8000374a:	c16080e7          	jalr	-1002(ra) # 8000235c <bwrite>
    brelse(from);
    8000374e:	854e                	mv	a0,s3
    80003750:	fffff097          	auipc	ra,0xfffff
    80003754:	c4a080e7          	jalr	-950(ra) # 8000239a <brelse>
    brelse(to);
    80003758:	8526                	mv	a0,s1
    8000375a:	fffff097          	auipc	ra,0xfffff
    8000375e:	c40080e7          	jalr	-960(ra) # 8000239a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003762:	2905                	addiw	s2,s2,1
    80003764:	0a91                	addi	s5,s5,4
    80003766:	02ca2783          	lw	a5,44(s4)
    8000376a:	f8f94ee3          	blt	s2,a5,80003706 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000376e:	00000097          	auipc	ra,0x0
    80003772:	c68080e7          	jalr	-920(ra) # 800033d6 <write_head>
    install_trans(0); // Now install writes to home locations
    80003776:	4501                	li	a0,0
    80003778:	00000097          	auipc	ra,0x0
    8000377c:	cda080e7          	jalr	-806(ra) # 80003452 <install_trans>
    log.lh.n = 0;
    80003780:	00011797          	auipc	a5,0x11
    80003784:	cc07ae23          	sw	zero,-804(a5) # 8001445c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003788:	00000097          	auipc	ra,0x0
    8000378c:	c4e080e7          	jalr	-946(ra) # 800033d6 <write_head>
    80003790:	bdf5                	j	8000368c <end_op+0x52>

0000000080003792 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003792:	1101                	addi	sp,sp,-32
    80003794:	ec06                	sd	ra,24(sp)
    80003796:	e822                	sd	s0,16(sp)
    80003798:	e426                	sd	s1,8(sp)
    8000379a:	e04a                	sd	s2,0(sp)
    8000379c:	1000                	addi	s0,sp,32
    8000379e:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800037a0:	00011917          	auipc	s2,0x11
    800037a4:	c9090913          	addi	s2,s2,-880 # 80014430 <log>
    800037a8:	854a                	mv	a0,s2
    800037aa:	00003097          	auipc	ra,0x3
    800037ae:	b4e080e7          	jalr	-1202(ra) # 800062f8 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800037b2:	02c92603          	lw	a2,44(s2)
    800037b6:	47f5                	li	a5,29
    800037b8:	06c7c563          	blt	a5,a2,80003822 <log_write+0x90>
    800037bc:	00011797          	auipc	a5,0x11
    800037c0:	c907a783          	lw	a5,-880(a5) # 8001444c <log+0x1c>
    800037c4:	37fd                	addiw	a5,a5,-1
    800037c6:	04f65e63          	bge	a2,a5,80003822 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800037ca:	00011797          	auipc	a5,0x11
    800037ce:	c867a783          	lw	a5,-890(a5) # 80014450 <log+0x20>
    800037d2:	06f05063          	blez	a5,80003832 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800037d6:	4781                	li	a5,0
    800037d8:	06c05563          	blez	a2,80003842 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037dc:	44cc                	lw	a1,12(s1)
    800037de:	00011717          	auipc	a4,0x11
    800037e2:	c8270713          	addi	a4,a4,-894 # 80014460 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800037e6:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037e8:	4314                	lw	a3,0(a4)
    800037ea:	04b68c63          	beq	a3,a1,80003842 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800037ee:	2785                	addiw	a5,a5,1
    800037f0:	0711                	addi	a4,a4,4
    800037f2:	fef61be3          	bne	a2,a5,800037e8 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800037f6:	0621                	addi	a2,a2,8
    800037f8:	060a                	slli	a2,a2,0x2
    800037fa:	00011797          	auipc	a5,0x11
    800037fe:	c3678793          	addi	a5,a5,-970 # 80014430 <log>
    80003802:	97b2                	add	a5,a5,a2
    80003804:	44d8                	lw	a4,12(s1)
    80003806:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003808:	8526                	mv	a0,s1
    8000380a:	fffff097          	auipc	ra,0xfffff
    8000380e:	c2e080e7          	jalr	-978(ra) # 80002438 <bpin>
    log.lh.n++;
    80003812:	00011717          	auipc	a4,0x11
    80003816:	c1e70713          	addi	a4,a4,-994 # 80014430 <log>
    8000381a:	575c                	lw	a5,44(a4)
    8000381c:	2785                	addiw	a5,a5,1
    8000381e:	d75c                	sw	a5,44(a4)
    80003820:	a82d                	j	8000385a <log_write+0xc8>
    panic("too big a transaction");
    80003822:	00005517          	auipc	a0,0x5
    80003826:	d9e50513          	addi	a0,a0,-610 # 800085c0 <syscalls+0x1f8>
    8000382a:	00002097          	auipc	ra,0x2
    8000382e:	596080e7          	jalr	1430(ra) # 80005dc0 <panic>
    panic("log_write outside of trans");
    80003832:	00005517          	auipc	a0,0x5
    80003836:	da650513          	addi	a0,a0,-602 # 800085d8 <syscalls+0x210>
    8000383a:	00002097          	auipc	ra,0x2
    8000383e:	586080e7          	jalr	1414(ra) # 80005dc0 <panic>
  log.lh.block[i] = b->blockno;
    80003842:	00878693          	addi	a3,a5,8
    80003846:	068a                	slli	a3,a3,0x2
    80003848:	00011717          	auipc	a4,0x11
    8000384c:	be870713          	addi	a4,a4,-1048 # 80014430 <log>
    80003850:	9736                	add	a4,a4,a3
    80003852:	44d4                	lw	a3,12(s1)
    80003854:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003856:	faf609e3          	beq	a2,a5,80003808 <log_write+0x76>
  }
  release(&log.lock);
    8000385a:	00011517          	auipc	a0,0x11
    8000385e:	bd650513          	addi	a0,a0,-1066 # 80014430 <log>
    80003862:	00003097          	auipc	ra,0x3
    80003866:	b4a080e7          	jalr	-1206(ra) # 800063ac <release>
}
    8000386a:	60e2                	ld	ra,24(sp)
    8000386c:	6442                	ld	s0,16(sp)
    8000386e:	64a2                	ld	s1,8(sp)
    80003870:	6902                	ld	s2,0(sp)
    80003872:	6105                	addi	sp,sp,32
    80003874:	8082                	ret

0000000080003876 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003876:	1101                	addi	sp,sp,-32
    80003878:	ec06                	sd	ra,24(sp)
    8000387a:	e822                	sd	s0,16(sp)
    8000387c:	e426                	sd	s1,8(sp)
    8000387e:	e04a                	sd	s2,0(sp)
    80003880:	1000                	addi	s0,sp,32
    80003882:	84aa                	mv	s1,a0
    80003884:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003886:	00005597          	auipc	a1,0x5
    8000388a:	d7258593          	addi	a1,a1,-654 # 800085f8 <syscalls+0x230>
    8000388e:	0521                	addi	a0,a0,8
    80003890:	00003097          	auipc	ra,0x3
    80003894:	9d8080e7          	jalr	-1576(ra) # 80006268 <initlock>
  lk->name = name;
    80003898:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000389c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038a0:	0204a423          	sw	zero,40(s1)
}
    800038a4:	60e2                	ld	ra,24(sp)
    800038a6:	6442                	ld	s0,16(sp)
    800038a8:	64a2                	ld	s1,8(sp)
    800038aa:	6902                	ld	s2,0(sp)
    800038ac:	6105                	addi	sp,sp,32
    800038ae:	8082                	ret

00000000800038b0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800038b0:	1101                	addi	sp,sp,-32
    800038b2:	ec06                	sd	ra,24(sp)
    800038b4:	e822                	sd	s0,16(sp)
    800038b6:	e426                	sd	s1,8(sp)
    800038b8:	e04a                	sd	s2,0(sp)
    800038ba:	1000                	addi	s0,sp,32
    800038bc:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038be:	00850913          	addi	s2,a0,8
    800038c2:	854a                	mv	a0,s2
    800038c4:	00003097          	auipc	ra,0x3
    800038c8:	a34080e7          	jalr	-1484(ra) # 800062f8 <acquire>
  while (lk->locked) {
    800038cc:	409c                	lw	a5,0(s1)
    800038ce:	cb89                	beqz	a5,800038e0 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800038d0:	85ca                	mv	a1,s2
    800038d2:	8526                	mv	a0,s1
    800038d4:	ffffe097          	auipc	ra,0xffffe
    800038d8:	c34080e7          	jalr	-972(ra) # 80001508 <sleep>
  while (lk->locked) {
    800038dc:	409c                	lw	a5,0(s1)
    800038de:	fbed                	bnez	a5,800038d0 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800038e0:	4785                	li	a5,1
    800038e2:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800038e4:	ffffd097          	auipc	ra,0xffffd
    800038e8:	560080e7          	jalr	1376(ra) # 80000e44 <myproc>
    800038ec:	591c                	lw	a5,48(a0)
    800038ee:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800038f0:	854a                	mv	a0,s2
    800038f2:	00003097          	auipc	ra,0x3
    800038f6:	aba080e7          	jalr	-1350(ra) # 800063ac <release>
}
    800038fa:	60e2                	ld	ra,24(sp)
    800038fc:	6442                	ld	s0,16(sp)
    800038fe:	64a2                	ld	s1,8(sp)
    80003900:	6902                	ld	s2,0(sp)
    80003902:	6105                	addi	sp,sp,32
    80003904:	8082                	ret

0000000080003906 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003906:	1101                	addi	sp,sp,-32
    80003908:	ec06                	sd	ra,24(sp)
    8000390a:	e822                	sd	s0,16(sp)
    8000390c:	e426                	sd	s1,8(sp)
    8000390e:	e04a                	sd	s2,0(sp)
    80003910:	1000                	addi	s0,sp,32
    80003912:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003914:	00850913          	addi	s2,a0,8
    80003918:	854a                	mv	a0,s2
    8000391a:	00003097          	auipc	ra,0x3
    8000391e:	9de080e7          	jalr	-1570(ra) # 800062f8 <acquire>
  lk->locked = 0;
    80003922:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003926:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000392a:	8526                	mv	a0,s1
    8000392c:	ffffe097          	auipc	ra,0xffffe
    80003930:	d68080e7          	jalr	-664(ra) # 80001694 <wakeup>
  release(&lk->lk);
    80003934:	854a                	mv	a0,s2
    80003936:	00003097          	auipc	ra,0x3
    8000393a:	a76080e7          	jalr	-1418(ra) # 800063ac <release>
}
    8000393e:	60e2                	ld	ra,24(sp)
    80003940:	6442                	ld	s0,16(sp)
    80003942:	64a2                	ld	s1,8(sp)
    80003944:	6902                	ld	s2,0(sp)
    80003946:	6105                	addi	sp,sp,32
    80003948:	8082                	ret

000000008000394a <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000394a:	7179                	addi	sp,sp,-48
    8000394c:	f406                	sd	ra,40(sp)
    8000394e:	f022                	sd	s0,32(sp)
    80003950:	ec26                	sd	s1,24(sp)
    80003952:	e84a                	sd	s2,16(sp)
    80003954:	e44e                	sd	s3,8(sp)
    80003956:	1800                	addi	s0,sp,48
    80003958:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000395a:	00850913          	addi	s2,a0,8
    8000395e:	854a                	mv	a0,s2
    80003960:	00003097          	auipc	ra,0x3
    80003964:	998080e7          	jalr	-1640(ra) # 800062f8 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003968:	409c                	lw	a5,0(s1)
    8000396a:	ef99                	bnez	a5,80003988 <holdingsleep+0x3e>
    8000396c:	4481                	li	s1,0
  release(&lk->lk);
    8000396e:	854a                	mv	a0,s2
    80003970:	00003097          	auipc	ra,0x3
    80003974:	a3c080e7          	jalr	-1476(ra) # 800063ac <release>
  return r;
}
    80003978:	8526                	mv	a0,s1
    8000397a:	70a2                	ld	ra,40(sp)
    8000397c:	7402                	ld	s0,32(sp)
    8000397e:	64e2                	ld	s1,24(sp)
    80003980:	6942                	ld	s2,16(sp)
    80003982:	69a2                	ld	s3,8(sp)
    80003984:	6145                	addi	sp,sp,48
    80003986:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003988:	0284a983          	lw	s3,40(s1)
    8000398c:	ffffd097          	auipc	ra,0xffffd
    80003990:	4b8080e7          	jalr	1208(ra) # 80000e44 <myproc>
    80003994:	5904                	lw	s1,48(a0)
    80003996:	413484b3          	sub	s1,s1,s3
    8000399a:	0014b493          	seqz	s1,s1
    8000399e:	bfc1                	j	8000396e <holdingsleep+0x24>

00000000800039a0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800039a0:	1141                	addi	sp,sp,-16
    800039a2:	e406                	sd	ra,8(sp)
    800039a4:	e022                	sd	s0,0(sp)
    800039a6:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800039a8:	00005597          	auipc	a1,0x5
    800039ac:	c6058593          	addi	a1,a1,-928 # 80008608 <syscalls+0x240>
    800039b0:	00011517          	auipc	a0,0x11
    800039b4:	bc850513          	addi	a0,a0,-1080 # 80014578 <ftable>
    800039b8:	00003097          	auipc	ra,0x3
    800039bc:	8b0080e7          	jalr	-1872(ra) # 80006268 <initlock>
}
    800039c0:	60a2                	ld	ra,8(sp)
    800039c2:	6402                	ld	s0,0(sp)
    800039c4:	0141                	addi	sp,sp,16
    800039c6:	8082                	ret

00000000800039c8 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800039c8:	1101                	addi	sp,sp,-32
    800039ca:	ec06                	sd	ra,24(sp)
    800039cc:	e822                	sd	s0,16(sp)
    800039ce:	e426                	sd	s1,8(sp)
    800039d0:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800039d2:	00011517          	auipc	a0,0x11
    800039d6:	ba650513          	addi	a0,a0,-1114 # 80014578 <ftable>
    800039da:	00003097          	auipc	ra,0x3
    800039de:	91e080e7          	jalr	-1762(ra) # 800062f8 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039e2:	00011497          	auipc	s1,0x11
    800039e6:	bae48493          	addi	s1,s1,-1106 # 80014590 <ftable+0x18>
    800039ea:	00012717          	auipc	a4,0x12
    800039ee:	b4670713          	addi	a4,a4,-1210 # 80015530 <ftable+0xfb8>
    if(f->ref == 0){
    800039f2:	40dc                	lw	a5,4(s1)
    800039f4:	cf99                	beqz	a5,80003a12 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039f6:	02848493          	addi	s1,s1,40
    800039fa:	fee49ce3          	bne	s1,a4,800039f2 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800039fe:	00011517          	auipc	a0,0x11
    80003a02:	b7a50513          	addi	a0,a0,-1158 # 80014578 <ftable>
    80003a06:	00003097          	auipc	ra,0x3
    80003a0a:	9a6080e7          	jalr	-1626(ra) # 800063ac <release>
  return 0;
    80003a0e:	4481                	li	s1,0
    80003a10:	a819                	j	80003a26 <filealloc+0x5e>
      f->ref = 1;
    80003a12:	4785                	li	a5,1
    80003a14:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003a16:	00011517          	auipc	a0,0x11
    80003a1a:	b6250513          	addi	a0,a0,-1182 # 80014578 <ftable>
    80003a1e:	00003097          	auipc	ra,0x3
    80003a22:	98e080e7          	jalr	-1650(ra) # 800063ac <release>
}
    80003a26:	8526                	mv	a0,s1
    80003a28:	60e2                	ld	ra,24(sp)
    80003a2a:	6442                	ld	s0,16(sp)
    80003a2c:	64a2                	ld	s1,8(sp)
    80003a2e:	6105                	addi	sp,sp,32
    80003a30:	8082                	ret

0000000080003a32 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003a32:	1101                	addi	sp,sp,-32
    80003a34:	ec06                	sd	ra,24(sp)
    80003a36:	e822                	sd	s0,16(sp)
    80003a38:	e426                	sd	s1,8(sp)
    80003a3a:	1000                	addi	s0,sp,32
    80003a3c:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a3e:	00011517          	auipc	a0,0x11
    80003a42:	b3a50513          	addi	a0,a0,-1222 # 80014578 <ftable>
    80003a46:	00003097          	auipc	ra,0x3
    80003a4a:	8b2080e7          	jalr	-1870(ra) # 800062f8 <acquire>
  if(f->ref < 1)
    80003a4e:	40dc                	lw	a5,4(s1)
    80003a50:	02f05263          	blez	a5,80003a74 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a54:	2785                	addiw	a5,a5,1
    80003a56:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a58:	00011517          	auipc	a0,0x11
    80003a5c:	b2050513          	addi	a0,a0,-1248 # 80014578 <ftable>
    80003a60:	00003097          	auipc	ra,0x3
    80003a64:	94c080e7          	jalr	-1716(ra) # 800063ac <release>
  return f;
}
    80003a68:	8526                	mv	a0,s1
    80003a6a:	60e2                	ld	ra,24(sp)
    80003a6c:	6442                	ld	s0,16(sp)
    80003a6e:	64a2                	ld	s1,8(sp)
    80003a70:	6105                	addi	sp,sp,32
    80003a72:	8082                	ret
    panic("filedup");
    80003a74:	00005517          	auipc	a0,0x5
    80003a78:	b9c50513          	addi	a0,a0,-1124 # 80008610 <syscalls+0x248>
    80003a7c:	00002097          	auipc	ra,0x2
    80003a80:	344080e7          	jalr	836(ra) # 80005dc0 <panic>

0000000080003a84 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003a84:	7139                	addi	sp,sp,-64
    80003a86:	fc06                	sd	ra,56(sp)
    80003a88:	f822                	sd	s0,48(sp)
    80003a8a:	f426                	sd	s1,40(sp)
    80003a8c:	f04a                	sd	s2,32(sp)
    80003a8e:	ec4e                	sd	s3,24(sp)
    80003a90:	e852                	sd	s4,16(sp)
    80003a92:	e456                	sd	s5,8(sp)
    80003a94:	0080                	addi	s0,sp,64
    80003a96:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003a98:	00011517          	auipc	a0,0x11
    80003a9c:	ae050513          	addi	a0,a0,-1312 # 80014578 <ftable>
    80003aa0:	00003097          	auipc	ra,0x3
    80003aa4:	858080e7          	jalr	-1960(ra) # 800062f8 <acquire>
  if(f->ref < 1)
    80003aa8:	40dc                	lw	a5,4(s1)
    80003aaa:	06f05163          	blez	a5,80003b0c <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003aae:	37fd                	addiw	a5,a5,-1
    80003ab0:	0007871b          	sext.w	a4,a5
    80003ab4:	c0dc                	sw	a5,4(s1)
    80003ab6:	06e04363          	bgtz	a4,80003b1c <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003aba:	0004a903          	lw	s2,0(s1)
    80003abe:	0094ca83          	lbu	s5,9(s1)
    80003ac2:	0104ba03          	ld	s4,16(s1)
    80003ac6:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003aca:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003ace:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003ad2:	00011517          	auipc	a0,0x11
    80003ad6:	aa650513          	addi	a0,a0,-1370 # 80014578 <ftable>
    80003ada:	00003097          	auipc	ra,0x3
    80003ade:	8d2080e7          	jalr	-1838(ra) # 800063ac <release>

  if(ff.type == FD_PIPE){
    80003ae2:	4785                	li	a5,1
    80003ae4:	04f90d63          	beq	s2,a5,80003b3e <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003ae8:	3979                	addiw	s2,s2,-2
    80003aea:	4785                	li	a5,1
    80003aec:	0527e063          	bltu	a5,s2,80003b2c <fileclose+0xa8>
    begin_op();
    80003af0:	00000097          	auipc	ra,0x0
    80003af4:	acc080e7          	jalr	-1332(ra) # 800035bc <begin_op>
    iput(ff.ip);
    80003af8:	854e                	mv	a0,s3
    80003afa:	fffff097          	auipc	ra,0xfffff
    80003afe:	29e080e7          	jalr	670(ra) # 80002d98 <iput>
    end_op();
    80003b02:	00000097          	auipc	ra,0x0
    80003b06:	b38080e7          	jalr	-1224(ra) # 8000363a <end_op>
    80003b0a:	a00d                	j	80003b2c <fileclose+0xa8>
    panic("fileclose");
    80003b0c:	00005517          	auipc	a0,0x5
    80003b10:	b0c50513          	addi	a0,a0,-1268 # 80008618 <syscalls+0x250>
    80003b14:	00002097          	auipc	ra,0x2
    80003b18:	2ac080e7          	jalr	684(ra) # 80005dc0 <panic>
    release(&ftable.lock);
    80003b1c:	00011517          	auipc	a0,0x11
    80003b20:	a5c50513          	addi	a0,a0,-1444 # 80014578 <ftable>
    80003b24:	00003097          	auipc	ra,0x3
    80003b28:	888080e7          	jalr	-1912(ra) # 800063ac <release>
  }
}
    80003b2c:	70e2                	ld	ra,56(sp)
    80003b2e:	7442                	ld	s0,48(sp)
    80003b30:	74a2                	ld	s1,40(sp)
    80003b32:	7902                	ld	s2,32(sp)
    80003b34:	69e2                	ld	s3,24(sp)
    80003b36:	6a42                	ld	s4,16(sp)
    80003b38:	6aa2                	ld	s5,8(sp)
    80003b3a:	6121                	addi	sp,sp,64
    80003b3c:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b3e:	85d6                	mv	a1,s5
    80003b40:	8552                	mv	a0,s4
    80003b42:	00000097          	auipc	ra,0x0
    80003b46:	34c080e7          	jalr	844(ra) # 80003e8e <pipeclose>
    80003b4a:	b7cd                	j	80003b2c <fileclose+0xa8>

0000000080003b4c <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003b4c:	715d                	addi	sp,sp,-80
    80003b4e:	e486                	sd	ra,72(sp)
    80003b50:	e0a2                	sd	s0,64(sp)
    80003b52:	fc26                	sd	s1,56(sp)
    80003b54:	f84a                	sd	s2,48(sp)
    80003b56:	f44e                	sd	s3,40(sp)
    80003b58:	0880                	addi	s0,sp,80
    80003b5a:	84aa                	mv	s1,a0
    80003b5c:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b5e:	ffffd097          	auipc	ra,0xffffd
    80003b62:	2e6080e7          	jalr	742(ra) # 80000e44 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003b66:	409c                	lw	a5,0(s1)
    80003b68:	37f9                	addiw	a5,a5,-2
    80003b6a:	4705                	li	a4,1
    80003b6c:	04f76763          	bltu	a4,a5,80003bba <filestat+0x6e>
    80003b70:	892a                	mv	s2,a0
    ilock(f->ip);
    80003b72:	6c88                	ld	a0,24(s1)
    80003b74:	fffff097          	auipc	ra,0xfffff
    80003b78:	fc0080e7          	jalr	-64(ra) # 80002b34 <ilock>
    stati(f->ip, &st);
    80003b7c:	fb840593          	addi	a1,s0,-72
    80003b80:	6c88                	ld	a0,24(s1)
    80003b82:	fffff097          	auipc	ra,0xfffff
    80003b86:	2e6080e7          	jalr	742(ra) # 80002e68 <stati>
    iunlock(f->ip);
    80003b8a:	6c88                	ld	a0,24(s1)
    80003b8c:	fffff097          	auipc	ra,0xfffff
    80003b90:	06a080e7          	jalr	106(ra) # 80002bf6 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003b94:	46e1                	li	a3,24
    80003b96:	fb840613          	addi	a2,s0,-72
    80003b9a:	85ce                	mv	a1,s3
    80003b9c:	05093503          	ld	a0,80(s2)
    80003ba0:	ffffd097          	auipc	ra,0xffffd
    80003ba4:	f68080e7          	jalr	-152(ra) # 80000b08 <copyout>
    80003ba8:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003bac:	60a6                	ld	ra,72(sp)
    80003bae:	6406                	ld	s0,64(sp)
    80003bb0:	74e2                	ld	s1,56(sp)
    80003bb2:	7942                	ld	s2,48(sp)
    80003bb4:	79a2                	ld	s3,40(sp)
    80003bb6:	6161                	addi	sp,sp,80
    80003bb8:	8082                	ret
  return -1;
    80003bba:	557d                	li	a0,-1
    80003bbc:	bfc5                	j	80003bac <filestat+0x60>

0000000080003bbe <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003bbe:	7179                	addi	sp,sp,-48
    80003bc0:	f406                	sd	ra,40(sp)
    80003bc2:	f022                	sd	s0,32(sp)
    80003bc4:	ec26                	sd	s1,24(sp)
    80003bc6:	e84a                	sd	s2,16(sp)
    80003bc8:	e44e                	sd	s3,8(sp)
    80003bca:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003bcc:	00854783          	lbu	a5,8(a0)
    80003bd0:	c3d5                	beqz	a5,80003c74 <fileread+0xb6>
    80003bd2:	84aa                	mv	s1,a0
    80003bd4:	89ae                	mv	s3,a1
    80003bd6:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003bd8:	411c                	lw	a5,0(a0)
    80003bda:	4705                	li	a4,1
    80003bdc:	04e78963          	beq	a5,a4,80003c2e <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003be0:	470d                	li	a4,3
    80003be2:	04e78d63          	beq	a5,a4,80003c3c <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003be6:	4709                	li	a4,2
    80003be8:	06e79e63          	bne	a5,a4,80003c64 <fileread+0xa6>
    ilock(f->ip);
    80003bec:	6d08                	ld	a0,24(a0)
    80003bee:	fffff097          	auipc	ra,0xfffff
    80003bf2:	f46080e7          	jalr	-186(ra) # 80002b34 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003bf6:	874a                	mv	a4,s2
    80003bf8:	5094                	lw	a3,32(s1)
    80003bfa:	864e                	mv	a2,s3
    80003bfc:	4585                	li	a1,1
    80003bfe:	6c88                	ld	a0,24(s1)
    80003c00:	fffff097          	auipc	ra,0xfffff
    80003c04:	292080e7          	jalr	658(ra) # 80002e92 <readi>
    80003c08:	892a                	mv	s2,a0
    80003c0a:	00a05563          	blez	a0,80003c14 <fileread+0x56>
      f->off += r;
    80003c0e:	509c                	lw	a5,32(s1)
    80003c10:	9fa9                	addw	a5,a5,a0
    80003c12:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003c14:	6c88                	ld	a0,24(s1)
    80003c16:	fffff097          	auipc	ra,0xfffff
    80003c1a:	fe0080e7          	jalr	-32(ra) # 80002bf6 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003c1e:	854a                	mv	a0,s2
    80003c20:	70a2                	ld	ra,40(sp)
    80003c22:	7402                	ld	s0,32(sp)
    80003c24:	64e2                	ld	s1,24(sp)
    80003c26:	6942                	ld	s2,16(sp)
    80003c28:	69a2                	ld	s3,8(sp)
    80003c2a:	6145                	addi	sp,sp,48
    80003c2c:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c2e:	6908                	ld	a0,16(a0)
    80003c30:	00000097          	auipc	ra,0x0
    80003c34:	3c0080e7          	jalr	960(ra) # 80003ff0 <piperead>
    80003c38:	892a                	mv	s2,a0
    80003c3a:	b7d5                	j	80003c1e <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003c3c:	02451783          	lh	a5,36(a0)
    80003c40:	03079693          	slli	a3,a5,0x30
    80003c44:	92c1                	srli	a3,a3,0x30
    80003c46:	4725                	li	a4,9
    80003c48:	02d76863          	bltu	a4,a3,80003c78 <fileread+0xba>
    80003c4c:	0792                	slli	a5,a5,0x4
    80003c4e:	00011717          	auipc	a4,0x11
    80003c52:	88a70713          	addi	a4,a4,-1910 # 800144d8 <devsw>
    80003c56:	97ba                	add	a5,a5,a4
    80003c58:	639c                	ld	a5,0(a5)
    80003c5a:	c38d                	beqz	a5,80003c7c <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003c5c:	4505                	li	a0,1
    80003c5e:	9782                	jalr	a5
    80003c60:	892a                	mv	s2,a0
    80003c62:	bf75                	j	80003c1e <fileread+0x60>
    panic("fileread");
    80003c64:	00005517          	auipc	a0,0x5
    80003c68:	9c450513          	addi	a0,a0,-1596 # 80008628 <syscalls+0x260>
    80003c6c:	00002097          	auipc	ra,0x2
    80003c70:	154080e7          	jalr	340(ra) # 80005dc0 <panic>
    return -1;
    80003c74:	597d                	li	s2,-1
    80003c76:	b765                	j	80003c1e <fileread+0x60>
      return -1;
    80003c78:	597d                	li	s2,-1
    80003c7a:	b755                	j	80003c1e <fileread+0x60>
    80003c7c:	597d                	li	s2,-1
    80003c7e:	b745                	j	80003c1e <fileread+0x60>

0000000080003c80 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003c80:	715d                	addi	sp,sp,-80
    80003c82:	e486                	sd	ra,72(sp)
    80003c84:	e0a2                	sd	s0,64(sp)
    80003c86:	fc26                	sd	s1,56(sp)
    80003c88:	f84a                	sd	s2,48(sp)
    80003c8a:	f44e                	sd	s3,40(sp)
    80003c8c:	f052                	sd	s4,32(sp)
    80003c8e:	ec56                	sd	s5,24(sp)
    80003c90:	e85a                	sd	s6,16(sp)
    80003c92:	e45e                	sd	s7,8(sp)
    80003c94:	e062                	sd	s8,0(sp)
    80003c96:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003c98:	00954783          	lbu	a5,9(a0)
    80003c9c:	10078663          	beqz	a5,80003da8 <filewrite+0x128>
    80003ca0:	892a                	mv	s2,a0
    80003ca2:	8b2e                	mv	s6,a1
    80003ca4:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003ca6:	411c                	lw	a5,0(a0)
    80003ca8:	4705                	li	a4,1
    80003caa:	02e78263          	beq	a5,a4,80003cce <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003cae:	470d                	li	a4,3
    80003cb0:	02e78663          	beq	a5,a4,80003cdc <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003cb4:	4709                	li	a4,2
    80003cb6:	0ee79163          	bne	a5,a4,80003d98 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003cba:	0ac05d63          	blez	a2,80003d74 <filewrite+0xf4>
    int i = 0;
    80003cbe:	4981                	li	s3,0
    80003cc0:	6b85                	lui	s7,0x1
    80003cc2:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003cc6:	6c05                	lui	s8,0x1
    80003cc8:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003ccc:	a861                	j	80003d64 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003cce:	6908                	ld	a0,16(a0)
    80003cd0:	00000097          	auipc	ra,0x0
    80003cd4:	22e080e7          	jalr	558(ra) # 80003efe <pipewrite>
    80003cd8:	8a2a                	mv	s4,a0
    80003cda:	a045                	j	80003d7a <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003cdc:	02451783          	lh	a5,36(a0)
    80003ce0:	03079693          	slli	a3,a5,0x30
    80003ce4:	92c1                	srli	a3,a3,0x30
    80003ce6:	4725                	li	a4,9
    80003ce8:	0cd76263          	bltu	a4,a3,80003dac <filewrite+0x12c>
    80003cec:	0792                	slli	a5,a5,0x4
    80003cee:	00010717          	auipc	a4,0x10
    80003cf2:	7ea70713          	addi	a4,a4,2026 # 800144d8 <devsw>
    80003cf6:	97ba                	add	a5,a5,a4
    80003cf8:	679c                	ld	a5,8(a5)
    80003cfa:	cbdd                	beqz	a5,80003db0 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003cfc:	4505                	li	a0,1
    80003cfe:	9782                	jalr	a5
    80003d00:	8a2a                	mv	s4,a0
    80003d02:	a8a5                	j	80003d7a <filewrite+0xfa>
    80003d04:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003d08:	00000097          	auipc	ra,0x0
    80003d0c:	8b4080e7          	jalr	-1868(ra) # 800035bc <begin_op>
      ilock(f->ip);
    80003d10:	01893503          	ld	a0,24(s2)
    80003d14:	fffff097          	auipc	ra,0xfffff
    80003d18:	e20080e7          	jalr	-480(ra) # 80002b34 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d1c:	8756                	mv	a4,s5
    80003d1e:	02092683          	lw	a3,32(s2)
    80003d22:	01698633          	add	a2,s3,s6
    80003d26:	4585                	li	a1,1
    80003d28:	01893503          	ld	a0,24(s2)
    80003d2c:	fffff097          	auipc	ra,0xfffff
    80003d30:	25e080e7          	jalr	606(ra) # 80002f8a <writei>
    80003d34:	84aa                	mv	s1,a0
    80003d36:	00a05763          	blez	a0,80003d44 <filewrite+0xc4>
        f->off += r;
    80003d3a:	02092783          	lw	a5,32(s2)
    80003d3e:	9fa9                	addw	a5,a5,a0
    80003d40:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003d44:	01893503          	ld	a0,24(s2)
    80003d48:	fffff097          	auipc	ra,0xfffff
    80003d4c:	eae080e7          	jalr	-338(ra) # 80002bf6 <iunlock>
      end_op();
    80003d50:	00000097          	auipc	ra,0x0
    80003d54:	8ea080e7          	jalr	-1814(ra) # 8000363a <end_op>

      if(r != n1){
    80003d58:	009a9f63          	bne	s5,s1,80003d76 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003d5c:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003d60:	0149db63          	bge	s3,s4,80003d76 <filewrite+0xf6>
      int n1 = n - i;
    80003d64:	413a04bb          	subw	s1,s4,s3
    80003d68:	0004879b          	sext.w	a5,s1
    80003d6c:	f8fbdce3          	bge	s7,a5,80003d04 <filewrite+0x84>
    80003d70:	84e2                	mv	s1,s8
    80003d72:	bf49                	j	80003d04 <filewrite+0x84>
    int i = 0;
    80003d74:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003d76:	013a1f63          	bne	s4,s3,80003d94 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003d7a:	8552                	mv	a0,s4
    80003d7c:	60a6                	ld	ra,72(sp)
    80003d7e:	6406                	ld	s0,64(sp)
    80003d80:	74e2                	ld	s1,56(sp)
    80003d82:	7942                	ld	s2,48(sp)
    80003d84:	79a2                	ld	s3,40(sp)
    80003d86:	7a02                	ld	s4,32(sp)
    80003d88:	6ae2                	ld	s5,24(sp)
    80003d8a:	6b42                	ld	s6,16(sp)
    80003d8c:	6ba2                	ld	s7,8(sp)
    80003d8e:	6c02                	ld	s8,0(sp)
    80003d90:	6161                	addi	sp,sp,80
    80003d92:	8082                	ret
    ret = (i == n ? n : -1);
    80003d94:	5a7d                	li	s4,-1
    80003d96:	b7d5                	j	80003d7a <filewrite+0xfa>
    panic("filewrite");
    80003d98:	00005517          	auipc	a0,0x5
    80003d9c:	8a050513          	addi	a0,a0,-1888 # 80008638 <syscalls+0x270>
    80003da0:	00002097          	auipc	ra,0x2
    80003da4:	020080e7          	jalr	32(ra) # 80005dc0 <panic>
    return -1;
    80003da8:	5a7d                	li	s4,-1
    80003daa:	bfc1                	j	80003d7a <filewrite+0xfa>
      return -1;
    80003dac:	5a7d                	li	s4,-1
    80003dae:	b7f1                	j	80003d7a <filewrite+0xfa>
    80003db0:	5a7d                	li	s4,-1
    80003db2:	b7e1                	j	80003d7a <filewrite+0xfa>

0000000080003db4 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003db4:	7179                	addi	sp,sp,-48
    80003db6:	f406                	sd	ra,40(sp)
    80003db8:	f022                	sd	s0,32(sp)
    80003dba:	ec26                	sd	s1,24(sp)
    80003dbc:	e84a                	sd	s2,16(sp)
    80003dbe:	e44e                	sd	s3,8(sp)
    80003dc0:	e052                	sd	s4,0(sp)
    80003dc2:	1800                	addi	s0,sp,48
    80003dc4:	84aa                	mv	s1,a0
    80003dc6:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003dc8:	0005b023          	sd	zero,0(a1)
    80003dcc:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003dd0:	00000097          	auipc	ra,0x0
    80003dd4:	bf8080e7          	jalr	-1032(ra) # 800039c8 <filealloc>
    80003dd8:	e088                	sd	a0,0(s1)
    80003dda:	c551                	beqz	a0,80003e66 <pipealloc+0xb2>
    80003ddc:	00000097          	auipc	ra,0x0
    80003de0:	bec080e7          	jalr	-1044(ra) # 800039c8 <filealloc>
    80003de4:	00aa3023          	sd	a0,0(s4)
    80003de8:	c92d                	beqz	a0,80003e5a <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003dea:	ffffc097          	auipc	ra,0xffffc
    80003dee:	330080e7          	jalr	816(ra) # 8000011a <kalloc>
    80003df2:	892a                	mv	s2,a0
    80003df4:	c125                	beqz	a0,80003e54 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003df6:	4985                	li	s3,1
    80003df8:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003dfc:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003e00:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e04:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e08:	00005597          	auipc	a1,0x5
    80003e0c:	84058593          	addi	a1,a1,-1984 # 80008648 <syscalls+0x280>
    80003e10:	00002097          	auipc	ra,0x2
    80003e14:	458080e7          	jalr	1112(ra) # 80006268 <initlock>
  (*f0)->type = FD_PIPE;
    80003e18:	609c                	ld	a5,0(s1)
    80003e1a:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e1e:	609c                	ld	a5,0(s1)
    80003e20:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e24:	609c                	ld	a5,0(s1)
    80003e26:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e2a:	609c                	ld	a5,0(s1)
    80003e2c:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003e30:	000a3783          	ld	a5,0(s4)
    80003e34:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003e38:	000a3783          	ld	a5,0(s4)
    80003e3c:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003e40:	000a3783          	ld	a5,0(s4)
    80003e44:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e48:	000a3783          	ld	a5,0(s4)
    80003e4c:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e50:	4501                	li	a0,0
    80003e52:	a025                	j	80003e7a <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003e54:	6088                	ld	a0,0(s1)
    80003e56:	e501                	bnez	a0,80003e5e <pipealloc+0xaa>
    80003e58:	a039                	j	80003e66 <pipealloc+0xb2>
    80003e5a:	6088                	ld	a0,0(s1)
    80003e5c:	c51d                	beqz	a0,80003e8a <pipealloc+0xd6>
    fileclose(*f0);
    80003e5e:	00000097          	auipc	ra,0x0
    80003e62:	c26080e7          	jalr	-986(ra) # 80003a84 <fileclose>
  if(*f1)
    80003e66:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003e6a:	557d                	li	a0,-1
  if(*f1)
    80003e6c:	c799                	beqz	a5,80003e7a <pipealloc+0xc6>
    fileclose(*f1);
    80003e6e:	853e                	mv	a0,a5
    80003e70:	00000097          	auipc	ra,0x0
    80003e74:	c14080e7          	jalr	-1004(ra) # 80003a84 <fileclose>
  return -1;
    80003e78:	557d                	li	a0,-1
}
    80003e7a:	70a2                	ld	ra,40(sp)
    80003e7c:	7402                	ld	s0,32(sp)
    80003e7e:	64e2                	ld	s1,24(sp)
    80003e80:	6942                	ld	s2,16(sp)
    80003e82:	69a2                	ld	s3,8(sp)
    80003e84:	6a02                	ld	s4,0(sp)
    80003e86:	6145                	addi	sp,sp,48
    80003e88:	8082                	ret
  return -1;
    80003e8a:	557d                	li	a0,-1
    80003e8c:	b7fd                	j	80003e7a <pipealloc+0xc6>

0000000080003e8e <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003e8e:	1101                	addi	sp,sp,-32
    80003e90:	ec06                	sd	ra,24(sp)
    80003e92:	e822                	sd	s0,16(sp)
    80003e94:	e426                	sd	s1,8(sp)
    80003e96:	e04a                	sd	s2,0(sp)
    80003e98:	1000                	addi	s0,sp,32
    80003e9a:	84aa                	mv	s1,a0
    80003e9c:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003e9e:	00002097          	auipc	ra,0x2
    80003ea2:	45a080e7          	jalr	1114(ra) # 800062f8 <acquire>
  if(writable){
    80003ea6:	02090d63          	beqz	s2,80003ee0 <pipeclose+0x52>
    pi->writeopen = 0;
    80003eaa:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003eae:	21848513          	addi	a0,s1,536
    80003eb2:	ffffd097          	auipc	ra,0xffffd
    80003eb6:	7e2080e7          	jalr	2018(ra) # 80001694 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003eba:	2204b783          	ld	a5,544(s1)
    80003ebe:	eb95                	bnez	a5,80003ef2 <pipeclose+0x64>
    release(&pi->lock);
    80003ec0:	8526                	mv	a0,s1
    80003ec2:	00002097          	auipc	ra,0x2
    80003ec6:	4ea080e7          	jalr	1258(ra) # 800063ac <release>
    kfree((char*)pi);
    80003eca:	8526                	mv	a0,s1
    80003ecc:	ffffc097          	auipc	ra,0xffffc
    80003ed0:	150080e7          	jalr	336(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003ed4:	60e2                	ld	ra,24(sp)
    80003ed6:	6442                	ld	s0,16(sp)
    80003ed8:	64a2                	ld	s1,8(sp)
    80003eda:	6902                	ld	s2,0(sp)
    80003edc:	6105                	addi	sp,sp,32
    80003ede:	8082                	ret
    pi->readopen = 0;
    80003ee0:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003ee4:	21c48513          	addi	a0,s1,540
    80003ee8:	ffffd097          	auipc	ra,0xffffd
    80003eec:	7ac080e7          	jalr	1964(ra) # 80001694 <wakeup>
    80003ef0:	b7e9                	j	80003eba <pipeclose+0x2c>
    release(&pi->lock);
    80003ef2:	8526                	mv	a0,s1
    80003ef4:	00002097          	auipc	ra,0x2
    80003ef8:	4b8080e7          	jalr	1208(ra) # 800063ac <release>
}
    80003efc:	bfe1                	j	80003ed4 <pipeclose+0x46>

0000000080003efe <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003efe:	711d                	addi	sp,sp,-96
    80003f00:	ec86                	sd	ra,88(sp)
    80003f02:	e8a2                	sd	s0,80(sp)
    80003f04:	e4a6                	sd	s1,72(sp)
    80003f06:	e0ca                	sd	s2,64(sp)
    80003f08:	fc4e                	sd	s3,56(sp)
    80003f0a:	f852                	sd	s4,48(sp)
    80003f0c:	f456                	sd	s5,40(sp)
    80003f0e:	f05a                	sd	s6,32(sp)
    80003f10:	ec5e                	sd	s7,24(sp)
    80003f12:	e862                	sd	s8,16(sp)
    80003f14:	1080                	addi	s0,sp,96
    80003f16:	84aa                	mv	s1,a0
    80003f18:	8aae                	mv	s5,a1
    80003f1a:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003f1c:	ffffd097          	auipc	ra,0xffffd
    80003f20:	f28080e7          	jalr	-216(ra) # 80000e44 <myproc>
    80003f24:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003f26:	8526                	mv	a0,s1
    80003f28:	00002097          	auipc	ra,0x2
    80003f2c:	3d0080e7          	jalr	976(ra) # 800062f8 <acquire>
  while(i < n){
    80003f30:	0b405363          	blez	s4,80003fd6 <pipewrite+0xd8>
  int i = 0;
    80003f34:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f36:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003f38:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003f3c:	21c48b93          	addi	s7,s1,540
    80003f40:	a089                	j	80003f82 <pipewrite+0x84>
      release(&pi->lock);
    80003f42:	8526                	mv	a0,s1
    80003f44:	00002097          	auipc	ra,0x2
    80003f48:	468080e7          	jalr	1128(ra) # 800063ac <release>
      return -1;
    80003f4c:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f4e:	854a                	mv	a0,s2
    80003f50:	60e6                	ld	ra,88(sp)
    80003f52:	6446                	ld	s0,80(sp)
    80003f54:	64a6                	ld	s1,72(sp)
    80003f56:	6906                	ld	s2,64(sp)
    80003f58:	79e2                	ld	s3,56(sp)
    80003f5a:	7a42                	ld	s4,48(sp)
    80003f5c:	7aa2                	ld	s5,40(sp)
    80003f5e:	7b02                	ld	s6,32(sp)
    80003f60:	6be2                	ld	s7,24(sp)
    80003f62:	6c42                	ld	s8,16(sp)
    80003f64:	6125                	addi	sp,sp,96
    80003f66:	8082                	ret
      wakeup(&pi->nread);
    80003f68:	8562                	mv	a0,s8
    80003f6a:	ffffd097          	auipc	ra,0xffffd
    80003f6e:	72a080e7          	jalr	1834(ra) # 80001694 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003f72:	85a6                	mv	a1,s1
    80003f74:	855e                	mv	a0,s7
    80003f76:	ffffd097          	auipc	ra,0xffffd
    80003f7a:	592080e7          	jalr	1426(ra) # 80001508 <sleep>
  while(i < n){
    80003f7e:	05495d63          	bge	s2,s4,80003fd8 <pipewrite+0xda>
    if(pi->readopen == 0 || pr->killed){
    80003f82:	2204a783          	lw	a5,544(s1)
    80003f86:	dfd5                	beqz	a5,80003f42 <pipewrite+0x44>
    80003f88:	0289a783          	lw	a5,40(s3)
    80003f8c:	fbdd                	bnez	a5,80003f42 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003f8e:	2184a783          	lw	a5,536(s1)
    80003f92:	21c4a703          	lw	a4,540(s1)
    80003f96:	2007879b          	addiw	a5,a5,512
    80003f9a:	fcf707e3          	beq	a4,a5,80003f68 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f9e:	4685                	li	a3,1
    80003fa0:	01590633          	add	a2,s2,s5
    80003fa4:	faf40593          	addi	a1,s0,-81
    80003fa8:	0509b503          	ld	a0,80(s3)
    80003fac:	ffffd097          	auipc	ra,0xffffd
    80003fb0:	be8080e7          	jalr	-1048(ra) # 80000b94 <copyin>
    80003fb4:	03650263          	beq	a0,s6,80003fd8 <pipewrite+0xda>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003fb8:	21c4a783          	lw	a5,540(s1)
    80003fbc:	0017871b          	addiw	a4,a5,1
    80003fc0:	20e4ae23          	sw	a4,540(s1)
    80003fc4:	1ff7f793          	andi	a5,a5,511
    80003fc8:	97a6                	add	a5,a5,s1
    80003fca:	faf44703          	lbu	a4,-81(s0)
    80003fce:	00e78c23          	sb	a4,24(a5)
      i++;
    80003fd2:	2905                	addiw	s2,s2,1
    80003fd4:	b76d                	j	80003f7e <pipewrite+0x80>
  int i = 0;
    80003fd6:	4901                	li	s2,0
  wakeup(&pi->nread);
    80003fd8:	21848513          	addi	a0,s1,536
    80003fdc:	ffffd097          	auipc	ra,0xffffd
    80003fe0:	6b8080e7          	jalr	1720(ra) # 80001694 <wakeup>
  release(&pi->lock);
    80003fe4:	8526                	mv	a0,s1
    80003fe6:	00002097          	auipc	ra,0x2
    80003fea:	3c6080e7          	jalr	966(ra) # 800063ac <release>
  return i;
    80003fee:	b785                	j	80003f4e <pipewrite+0x50>

0000000080003ff0 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003ff0:	715d                	addi	sp,sp,-80
    80003ff2:	e486                	sd	ra,72(sp)
    80003ff4:	e0a2                	sd	s0,64(sp)
    80003ff6:	fc26                	sd	s1,56(sp)
    80003ff8:	f84a                	sd	s2,48(sp)
    80003ffa:	f44e                	sd	s3,40(sp)
    80003ffc:	f052                	sd	s4,32(sp)
    80003ffe:	ec56                	sd	s5,24(sp)
    80004000:	e85a                	sd	s6,16(sp)
    80004002:	0880                	addi	s0,sp,80
    80004004:	84aa                	mv	s1,a0
    80004006:	892e                	mv	s2,a1
    80004008:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000400a:	ffffd097          	auipc	ra,0xffffd
    8000400e:	e3a080e7          	jalr	-454(ra) # 80000e44 <myproc>
    80004012:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004014:	8526                	mv	a0,s1
    80004016:	00002097          	auipc	ra,0x2
    8000401a:	2e2080e7          	jalr	738(ra) # 800062f8 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000401e:	2184a703          	lw	a4,536(s1)
    80004022:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004026:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000402a:	02f71463          	bne	a4,a5,80004052 <piperead+0x62>
    8000402e:	2244a783          	lw	a5,548(s1)
    80004032:	c385                	beqz	a5,80004052 <piperead+0x62>
    if(pr->killed){
    80004034:	028a2783          	lw	a5,40(s4)
    80004038:	ebc9                	bnez	a5,800040ca <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000403a:	85a6                	mv	a1,s1
    8000403c:	854e                	mv	a0,s3
    8000403e:	ffffd097          	auipc	ra,0xffffd
    80004042:	4ca080e7          	jalr	1226(ra) # 80001508 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004046:	2184a703          	lw	a4,536(s1)
    8000404a:	21c4a783          	lw	a5,540(s1)
    8000404e:	fef700e3          	beq	a4,a5,8000402e <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004052:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004054:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004056:	05505463          	blez	s5,8000409e <piperead+0xae>
    if(pi->nread == pi->nwrite)
    8000405a:	2184a783          	lw	a5,536(s1)
    8000405e:	21c4a703          	lw	a4,540(s1)
    80004062:	02f70e63          	beq	a4,a5,8000409e <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004066:	0017871b          	addiw	a4,a5,1
    8000406a:	20e4ac23          	sw	a4,536(s1)
    8000406e:	1ff7f793          	andi	a5,a5,511
    80004072:	97a6                	add	a5,a5,s1
    80004074:	0187c783          	lbu	a5,24(a5)
    80004078:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000407c:	4685                	li	a3,1
    8000407e:	fbf40613          	addi	a2,s0,-65
    80004082:	85ca                	mv	a1,s2
    80004084:	050a3503          	ld	a0,80(s4)
    80004088:	ffffd097          	auipc	ra,0xffffd
    8000408c:	a80080e7          	jalr	-1408(ra) # 80000b08 <copyout>
    80004090:	01650763          	beq	a0,s6,8000409e <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004094:	2985                	addiw	s3,s3,1
    80004096:	0905                	addi	s2,s2,1
    80004098:	fd3a91e3          	bne	s5,s3,8000405a <piperead+0x6a>
    8000409c:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000409e:	21c48513          	addi	a0,s1,540
    800040a2:	ffffd097          	auipc	ra,0xffffd
    800040a6:	5f2080e7          	jalr	1522(ra) # 80001694 <wakeup>
  release(&pi->lock);
    800040aa:	8526                	mv	a0,s1
    800040ac:	00002097          	auipc	ra,0x2
    800040b0:	300080e7          	jalr	768(ra) # 800063ac <release>
  return i;
}
    800040b4:	854e                	mv	a0,s3
    800040b6:	60a6                	ld	ra,72(sp)
    800040b8:	6406                	ld	s0,64(sp)
    800040ba:	74e2                	ld	s1,56(sp)
    800040bc:	7942                	ld	s2,48(sp)
    800040be:	79a2                	ld	s3,40(sp)
    800040c0:	7a02                	ld	s4,32(sp)
    800040c2:	6ae2                	ld	s5,24(sp)
    800040c4:	6b42                	ld	s6,16(sp)
    800040c6:	6161                	addi	sp,sp,80
    800040c8:	8082                	ret
      release(&pi->lock);
    800040ca:	8526                	mv	a0,s1
    800040cc:	00002097          	auipc	ra,0x2
    800040d0:	2e0080e7          	jalr	736(ra) # 800063ac <release>
      return -1;
    800040d4:	59fd                	li	s3,-1
    800040d6:	bff9                	j	800040b4 <piperead+0xc4>

00000000800040d8 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800040d8:	de010113          	addi	sp,sp,-544
    800040dc:	20113c23          	sd	ra,536(sp)
    800040e0:	20813823          	sd	s0,528(sp)
    800040e4:	20913423          	sd	s1,520(sp)
    800040e8:	21213023          	sd	s2,512(sp)
    800040ec:	ffce                	sd	s3,504(sp)
    800040ee:	fbd2                	sd	s4,496(sp)
    800040f0:	f7d6                	sd	s5,488(sp)
    800040f2:	f3da                	sd	s6,480(sp)
    800040f4:	efde                	sd	s7,472(sp)
    800040f6:	ebe2                	sd	s8,464(sp)
    800040f8:	e7e6                	sd	s9,456(sp)
    800040fa:	e3ea                	sd	s10,448(sp)
    800040fc:	ff6e                	sd	s11,440(sp)
    800040fe:	1400                	addi	s0,sp,544
    80004100:	892a                	mv	s2,a0
    80004102:	dea43423          	sd	a0,-536(s0)
    80004106:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000410a:	ffffd097          	auipc	ra,0xffffd
    8000410e:	d3a080e7          	jalr	-710(ra) # 80000e44 <myproc>
    80004112:	84aa                	mv	s1,a0

  begin_op();
    80004114:	fffff097          	auipc	ra,0xfffff
    80004118:	4a8080e7          	jalr	1192(ra) # 800035bc <begin_op>

  if((ip = namei(path)) == 0){
    8000411c:	854a                	mv	a0,s2
    8000411e:	fffff097          	auipc	ra,0xfffff
    80004122:	27e080e7          	jalr	638(ra) # 8000339c <namei>
    80004126:	c93d                	beqz	a0,8000419c <exec+0xc4>
    80004128:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000412a:	fffff097          	auipc	ra,0xfffff
    8000412e:	a0a080e7          	jalr	-1526(ra) # 80002b34 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004132:	04000713          	li	a4,64
    80004136:	4681                	li	a3,0
    80004138:	e5040613          	addi	a2,s0,-432
    8000413c:	4581                	li	a1,0
    8000413e:	8556                	mv	a0,s5
    80004140:	fffff097          	auipc	ra,0xfffff
    80004144:	d52080e7          	jalr	-686(ra) # 80002e92 <readi>
    80004148:	04000793          	li	a5,64
    8000414c:	00f51a63          	bne	a0,a5,80004160 <exec+0x88>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004150:	e5042703          	lw	a4,-432(s0)
    80004154:	464c47b7          	lui	a5,0x464c4
    80004158:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000415c:	04f70663          	beq	a4,a5,800041a8 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004160:	8556                	mv	a0,s5
    80004162:	fffff097          	auipc	ra,0xfffff
    80004166:	cde080e7          	jalr	-802(ra) # 80002e40 <iunlockput>
    end_op();
    8000416a:	fffff097          	auipc	ra,0xfffff
    8000416e:	4d0080e7          	jalr	1232(ra) # 8000363a <end_op>
  }
  return -1;
    80004172:	557d                	li	a0,-1
}
    80004174:	21813083          	ld	ra,536(sp)
    80004178:	21013403          	ld	s0,528(sp)
    8000417c:	20813483          	ld	s1,520(sp)
    80004180:	20013903          	ld	s2,512(sp)
    80004184:	79fe                	ld	s3,504(sp)
    80004186:	7a5e                	ld	s4,496(sp)
    80004188:	7abe                	ld	s5,488(sp)
    8000418a:	7b1e                	ld	s6,480(sp)
    8000418c:	6bfe                	ld	s7,472(sp)
    8000418e:	6c5e                	ld	s8,464(sp)
    80004190:	6cbe                	ld	s9,456(sp)
    80004192:	6d1e                	ld	s10,448(sp)
    80004194:	7dfa                	ld	s11,440(sp)
    80004196:	22010113          	addi	sp,sp,544
    8000419a:	8082                	ret
    end_op();
    8000419c:	fffff097          	auipc	ra,0xfffff
    800041a0:	49e080e7          	jalr	1182(ra) # 8000363a <end_op>
    return -1;
    800041a4:	557d                	li	a0,-1
    800041a6:	b7f9                	j	80004174 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    800041a8:	8526                	mv	a0,s1
    800041aa:	ffffd097          	auipc	ra,0xffffd
    800041ae:	d5e080e7          	jalr	-674(ra) # 80000f08 <proc_pagetable>
    800041b2:	8b2a                	mv	s6,a0
    800041b4:	d555                	beqz	a0,80004160 <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041b6:	e7042783          	lw	a5,-400(s0)
    800041ba:	e8845703          	lhu	a4,-376(s0)
    800041be:	c735                	beqz	a4,8000422a <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800041c0:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041c2:	e0043423          	sd	zero,-504(s0)
    if((ph.vaddr % PGSIZE) != 0)
    800041c6:	6a05                	lui	s4,0x1
    800041c8:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    800041cc:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    800041d0:	6d85                	lui	s11,0x1
    800041d2:	7d7d                	lui	s10,0xfffff
    800041d4:	ac1d                	j	8000440a <exec+0x332>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800041d6:	00004517          	auipc	a0,0x4
    800041da:	47a50513          	addi	a0,a0,1146 # 80008650 <syscalls+0x288>
    800041de:	00002097          	auipc	ra,0x2
    800041e2:	be2080e7          	jalr	-1054(ra) # 80005dc0 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800041e6:	874a                	mv	a4,s2
    800041e8:	009c86bb          	addw	a3,s9,s1
    800041ec:	4581                	li	a1,0
    800041ee:	8556                	mv	a0,s5
    800041f0:	fffff097          	auipc	ra,0xfffff
    800041f4:	ca2080e7          	jalr	-862(ra) # 80002e92 <readi>
    800041f8:	2501                	sext.w	a0,a0
    800041fa:	1aa91863          	bne	s2,a0,800043aa <exec+0x2d2>
  for(i = 0; i < sz; i += PGSIZE){
    800041fe:	009d84bb          	addw	s1,s11,s1
    80004202:	013d09bb          	addw	s3,s10,s3
    80004206:	1f74f263          	bgeu	s1,s7,800043ea <exec+0x312>
    pa = walkaddr(pagetable, va + i);
    8000420a:	02049593          	slli	a1,s1,0x20
    8000420e:	9181                	srli	a1,a1,0x20
    80004210:	95e2                	add	a1,a1,s8
    80004212:	855a                	mv	a0,s6
    80004214:	ffffc097          	auipc	ra,0xffffc
    80004218:	2ec080e7          	jalr	748(ra) # 80000500 <walkaddr>
    8000421c:	862a                	mv	a2,a0
    if(pa == 0)
    8000421e:	dd45                	beqz	a0,800041d6 <exec+0xfe>
      n = PGSIZE;
    80004220:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    80004222:	fd49f2e3          	bgeu	s3,s4,800041e6 <exec+0x10e>
      n = sz - i;
    80004226:	894e                	mv	s2,s3
    80004228:	bf7d                	j	800041e6 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000422a:	4481                	li	s1,0
  iunlockput(ip);
    8000422c:	8556                	mv	a0,s5
    8000422e:	fffff097          	auipc	ra,0xfffff
    80004232:	c12080e7          	jalr	-1006(ra) # 80002e40 <iunlockput>
  end_op();
    80004236:	fffff097          	auipc	ra,0xfffff
    8000423a:	404080e7          	jalr	1028(ra) # 8000363a <end_op>
  p = myproc();
    8000423e:	ffffd097          	auipc	ra,0xffffd
    80004242:	c06080e7          	jalr	-1018(ra) # 80000e44 <myproc>
    80004246:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80004248:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    8000424c:	6785                	lui	a5,0x1
    8000424e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80004250:	97a6                	add	a5,a5,s1
    80004252:	777d                	lui	a4,0xfffff
    80004254:	8ff9                	and	a5,a5,a4
    80004256:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000425a:	6609                	lui	a2,0x2
    8000425c:	963e                	add	a2,a2,a5
    8000425e:	85be                	mv	a1,a5
    80004260:	855a                	mv	a0,s6
    80004262:	ffffc097          	auipc	ra,0xffffc
    80004266:	652080e7          	jalr	1618(ra) # 800008b4 <uvmalloc>
    8000426a:	8c2a                	mv	s8,a0
  ip = 0;
    8000426c:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000426e:	12050e63          	beqz	a0,800043aa <exec+0x2d2>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004272:	75f9                	lui	a1,0xffffe
    80004274:	95aa                	add	a1,a1,a0
    80004276:	855a                	mv	a0,s6
    80004278:	ffffd097          	auipc	ra,0xffffd
    8000427c:	85e080e7          	jalr	-1954(ra) # 80000ad6 <uvmclear>
  stackbase = sp - PGSIZE;
    80004280:	7afd                	lui	s5,0xfffff
    80004282:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    80004284:	df043783          	ld	a5,-528(s0)
    80004288:	6388                	ld	a0,0(a5)
    8000428a:	c925                	beqz	a0,800042fa <exec+0x222>
    8000428c:	e9040993          	addi	s3,s0,-368
    80004290:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004294:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004296:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004298:	ffffc097          	auipc	ra,0xffffc
    8000429c:	05e080e7          	jalr	94(ra) # 800002f6 <strlen>
    800042a0:	0015079b          	addiw	a5,a0,1
    800042a4:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800042a8:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800042ac:	13596363          	bltu	s2,s5,800043d2 <exec+0x2fa>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800042b0:	df043d83          	ld	s11,-528(s0)
    800042b4:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    800042b8:	8552                	mv	a0,s4
    800042ba:	ffffc097          	auipc	ra,0xffffc
    800042be:	03c080e7          	jalr	60(ra) # 800002f6 <strlen>
    800042c2:	0015069b          	addiw	a3,a0,1
    800042c6:	8652                	mv	a2,s4
    800042c8:	85ca                	mv	a1,s2
    800042ca:	855a                	mv	a0,s6
    800042cc:	ffffd097          	auipc	ra,0xffffd
    800042d0:	83c080e7          	jalr	-1988(ra) # 80000b08 <copyout>
    800042d4:	10054363          	bltz	a0,800043da <exec+0x302>
    ustack[argc] = sp;
    800042d8:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800042dc:	0485                	addi	s1,s1,1
    800042de:	008d8793          	addi	a5,s11,8
    800042e2:	def43823          	sd	a5,-528(s0)
    800042e6:	008db503          	ld	a0,8(s11)
    800042ea:	c911                	beqz	a0,800042fe <exec+0x226>
    if(argc >= MAXARG)
    800042ec:	09a1                	addi	s3,s3,8
    800042ee:	fb3c95e3          	bne	s9,s3,80004298 <exec+0x1c0>
  sz = sz1;
    800042f2:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800042f6:	4a81                	li	s5,0
    800042f8:	a84d                	j	800043aa <exec+0x2d2>
  sp = sz;
    800042fa:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800042fc:	4481                	li	s1,0
  ustack[argc] = 0;
    800042fe:	00349793          	slli	a5,s1,0x3
    80004302:	f9078793          	addi	a5,a5,-112
    80004306:	97a2                	add	a5,a5,s0
    80004308:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    8000430c:	00148693          	addi	a3,s1,1
    80004310:	068e                	slli	a3,a3,0x3
    80004312:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004316:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    8000431a:	01597663          	bgeu	s2,s5,80004326 <exec+0x24e>
  sz = sz1;
    8000431e:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004322:	4a81                	li	s5,0
    80004324:	a059                	j	800043aa <exec+0x2d2>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004326:	e9040613          	addi	a2,s0,-368
    8000432a:	85ca                	mv	a1,s2
    8000432c:	855a                	mv	a0,s6
    8000432e:	ffffc097          	auipc	ra,0xffffc
    80004332:	7da080e7          	jalr	2010(ra) # 80000b08 <copyout>
    80004336:	0a054663          	bltz	a0,800043e2 <exec+0x30a>
  p->trapframe->a1 = sp;
    8000433a:	058bb783          	ld	a5,88(s7)
    8000433e:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004342:	de843783          	ld	a5,-536(s0)
    80004346:	0007c703          	lbu	a4,0(a5)
    8000434a:	cf11                	beqz	a4,80004366 <exec+0x28e>
    8000434c:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000434e:	02f00693          	li	a3,47
    80004352:	a039                	j	80004360 <exec+0x288>
      last = s+1;
    80004354:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80004358:	0785                	addi	a5,a5,1
    8000435a:	fff7c703          	lbu	a4,-1(a5)
    8000435e:	c701                	beqz	a4,80004366 <exec+0x28e>
    if(*s == '/')
    80004360:	fed71ce3          	bne	a4,a3,80004358 <exec+0x280>
    80004364:	bfc5                	j	80004354 <exec+0x27c>
  safestrcpy(p->name, last, sizeof(p->name));
    80004366:	4641                	li	a2,16
    80004368:	de843583          	ld	a1,-536(s0)
    8000436c:	158b8513          	addi	a0,s7,344
    80004370:	ffffc097          	auipc	ra,0xffffc
    80004374:	f54080e7          	jalr	-172(ra) # 800002c4 <safestrcpy>
  oldpagetable = p->pagetable;
    80004378:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    8000437c:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    80004380:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004384:	058bb783          	ld	a5,88(s7)
    80004388:	e6843703          	ld	a4,-408(s0)
    8000438c:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000438e:	058bb783          	ld	a5,88(s7)
    80004392:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004396:	85ea                	mv	a1,s10
    80004398:	ffffd097          	auipc	ra,0xffffd
    8000439c:	c0c080e7          	jalr	-1012(ra) # 80000fa4 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800043a0:	0004851b          	sext.w	a0,s1
    800043a4:	bbc1                	j	80004174 <exec+0x9c>
    800043a6:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    800043aa:	df843583          	ld	a1,-520(s0)
    800043ae:	855a                	mv	a0,s6
    800043b0:	ffffd097          	auipc	ra,0xffffd
    800043b4:	bf4080e7          	jalr	-1036(ra) # 80000fa4 <proc_freepagetable>
  if(ip){
    800043b8:	da0a94e3          	bnez	s5,80004160 <exec+0x88>
  return -1;
    800043bc:	557d                	li	a0,-1
    800043be:	bb5d                	j	80004174 <exec+0x9c>
    800043c0:	de943c23          	sd	s1,-520(s0)
    800043c4:	b7dd                	j	800043aa <exec+0x2d2>
    800043c6:	de943c23          	sd	s1,-520(s0)
    800043ca:	b7c5                	j	800043aa <exec+0x2d2>
    800043cc:	de943c23          	sd	s1,-520(s0)
    800043d0:	bfe9                	j	800043aa <exec+0x2d2>
  sz = sz1;
    800043d2:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800043d6:	4a81                	li	s5,0
    800043d8:	bfc9                	j	800043aa <exec+0x2d2>
  sz = sz1;
    800043da:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800043de:	4a81                	li	s5,0
    800043e0:	b7e9                	j	800043aa <exec+0x2d2>
  sz = sz1;
    800043e2:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800043e6:	4a81                	li	s5,0
    800043e8:	b7c9                	j	800043aa <exec+0x2d2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800043ea:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043ee:	e0843783          	ld	a5,-504(s0)
    800043f2:	0017869b          	addiw	a3,a5,1
    800043f6:	e0d43423          	sd	a3,-504(s0)
    800043fa:	e0043783          	ld	a5,-512(s0)
    800043fe:	0387879b          	addiw	a5,a5,56
    80004402:	e8845703          	lhu	a4,-376(s0)
    80004406:	e2e6d3e3          	bge	a3,a4,8000422c <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000440a:	2781                	sext.w	a5,a5
    8000440c:	e0f43023          	sd	a5,-512(s0)
    80004410:	03800713          	li	a4,56
    80004414:	86be                	mv	a3,a5
    80004416:	e1840613          	addi	a2,s0,-488
    8000441a:	4581                	li	a1,0
    8000441c:	8556                	mv	a0,s5
    8000441e:	fffff097          	auipc	ra,0xfffff
    80004422:	a74080e7          	jalr	-1420(ra) # 80002e92 <readi>
    80004426:	03800793          	li	a5,56
    8000442a:	f6f51ee3          	bne	a0,a5,800043a6 <exec+0x2ce>
    if(ph.type != ELF_PROG_LOAD)
    8000442e:	e1842783          	lw	a5,-488(s0)
    80004432:	4705                	li	a4,1
    80004434:	fae79de3          	bne	a5,a4,800043ee <exec+0x316>
    if(ph.memsz < ph.filesz)
    80004438:	e4043603          	ld	a2,-448(s0)
    8000443c:	e3843783          	ld	a5,-456(s0)
    80004440:	f8f660e3          	bltu	a2,a5,800043c0 <exec+0x2e8>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004444:	e2843783          	ld	a5,-472(s0)
    80004448:	963e                	add	a2,a2,a5
    8000444a:	f6f66ee3          	bltu	a2,a5,800043c6 <exec+0x2ee>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000444e:	85a6                	mv	a1,s1
    80004450:	855a                	mv	a0,s6
    80004452:	ffffc097          	auipc	ra,0xffffc
    80004456:	462080e7          	jalr	1122(ra) # 800008b4 <uvmalloc>
    8000445a:	dea43c23          	sd	a0,-520(s0)
    8000445e:	d53d                	beqz	a0,800043cc <exec+0x2f4>
    if((ph.vaddr % PGSIZE) != 0)
    80004460:	e2843c03          	ld	s8,-472(s0)
    80004464:	de043783          	ld	a5,-544(s0)
    80004468:	00fc77b3          	and	a5,s8,a5
    8000446c:	ff9d                	bnez	a5,800043aa <exec+0x2d2>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000446e:	e2042c83          	lw	s9,-480(s0)
    80004472:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004476:	f60b8ae3          	beqz	s7,800043ea <exec+0x312>
    8000447a:	89de                	mv	s3,s7
    8000447c:	4481                	li	s1,0
    8000447e:	b371                	j	8000420a <exec+0x132>

0000000080004480 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004480:	7179                	addi	sp,sp,-48
    80004482:	f406                	sd	ra,40(sp)
    80004484:	f022                	sd	s0,32(sp)
    80004486:	ec26                	sd	s1,24(sp)
    80004488:	e84a                	sd	s2,16(sp)
    8000448a:	1800                	addi	s0,sp,48
    8000448c:	892e                	mv	s2,a1
    8000448e:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if (argint(n, &fd) < 0)
    80004490:	fdc40593          	addi	a1,s0,-36
    80004494:	ffffe097          	auipc	ra,0xffffe
    80004498:	a66080e7          	jalr	-1434(ra) # 80001efa <argint>
    8000449c:	04054063          	bltz	a0,800044dc <argfd+0x5c>
    return -1;
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
    800044a0:	fdc42703          	lw	a4,-36(s0)
    800044a4:	47bd                	li	a5,15
    800044a6:	02e7ed63          	bltu	a5,a4,800044e0 <argfd+0x60>
    800044aa:	ffffd097          	auipc	ra,0xffffd
    800044ae:	99a080e7          	jalr	-1638(ra) # 80000e44 <myproc>
    800044b2:	fdc42703          	lw	a4,-36(s0)
    800044b6:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7ffdddda>
    800044ba:	078e                	slli	a5,a5,0x3
    800044bc:	953e                	add	a0,a0,a5
    800044be:	611c                	ld	a5,0(a0)
    800044c0:	c395                	beqz	a5,800044e4 <argfd+0x64>
    return -1;
  if (pfd)
    800044c2:	00090463          	beqz	s2,800044ca <argfd+0x4a>
    *pfd = fd;
    800044c6:	00e92023          	sw	a4,0(s2)
  if (pf)
    *pf = f;
  return 0;
    800044ca:	4501                	li	a0,0
  if (pf)
    800044cc:	c091                	beqz	s1,800044d0 <argfd+0x50>
    *pf = f;
    800044ce:	e09c                	sd	a5,0(s1)
}
    800044d0:	70a2                	ld	ra,40(sp)
    800044d2:	7402                	ld	s0,32(sp)
    800044d4:	64e2                	ld	s1,24(sp)
    800044d6:	6942                	ld	s2,16(sp)
    800044d8:	6145                	addi	sp,sp,48
    800044da:	8082                	ret
    return -1;
    800044dc:	557d                	li	a0,-1
    800044de:	bfcd                	j	800044d0 <argfd+0x50>
    return -1;
    800044e0:	557d                	li	a0,-1
    800044e2:	b7fd                	j	800044d0 <argfd+0x50>
    800044e4:	557d                	li	a0,-1
    800044e6:	b7ed                	j	800044d0 <argfd+0x50>

00000000800044e8 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800044e8:	1101                	addi	sp,sp,-32
    800044ea:	ec06                	sd	ra,24(sp)
    800044ec:	e822                	sd	s0,16(sp)
    800044ee:	e426                	sd	s1,8(sp)
    800044f0:	1000                	addi	s0,sp,32
    800044f2:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800044f4:	ffffd097          	auipc	ra,0xffffd
    800044f8:	950080e7          	jalr	-1712(ra) # 80000e44 <myproc>
    800044fc:	862a                	mv	a2,a0

  for (fd = 0; fd < NOFILE; fd++)
    800044fe:	0d050793          	addi	a5,a0,208
    80004502:	4501                	li	a0,0
    80004504:	46c1                	li	a3,16
  {
    if (p->ofile[fd] == 0)
    80004506:	6398                	ld	a4,0(a5)
    80004508:	cb19                	beqz	a4,8000451e <fdalloc+0x36>
  for (fd = 0; fd < NOFILE; fd++)
    8000450a:	2505                	addiw	a0,a0,1
    8000450c:	07a1                	addi	a5,a5,8
    8000450e:	fed51ce3          	bne	a0,a3,80004506 <fdalloc+0x1e>
    {
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004512:	557d                	li	a0,-1
}
    80004514:	60e2                	ld	ra,24(sp)
    80004516:	6442                	ld	s0,16(sp)
    80004518:	64a2                	ld	s1,8(sp)
    8000451a:	6105                	addi	sp,sp,32
    8000451c:	8082                	ret
      p->ofile[fd] = f;
    8000451e:	01a50793          	addi	a5,a0,26
    80004522:	078e                	slli	a5,a5,0x3
    80004524:	963e                	add	a2,a2,a5
    80004526:	e204                	sd	s1,0(a2)
      return fd;
    80004528:	b7f5                	j	80004514 <fdalloc+0x2c>

000000008000452a <create>:
  return -1;
}

static struct inode *
create(char *path, short type, short major, short minor)
{
    8000452a:	715d                	addi	sp,sp,-80
    8000452c:	e486                	sd	ra,72(sp)
    8000452e:	e0a2                	sd	s0,64(sp)
    80004530:	fc26                	sd	s1,56(sp)
    80004532:	f84a                	sd	s2,48(sp)
    80004534:	f44e                	sd	s3,40(sp)
    80004536:	f052                	sd	s4,32(sp)
    80004538:	ec56                	sd	s5,24(sp)
    8000453a:	0880                	addi	s0,sp,80
    8000453c:	89ae                	mv	s3,a1
    8000453e:	8ab2                	mv	s5,a2
    80004540:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if ((dp = nameiparent(path, name)) == 0)
    80004542:	fb040593          	addi	a1,s0,-80
    80004546:	fffff097          	auipc	ra,0xfffff
    8000454a:	e74080e7          	jalr	-396(ra) # 800033ba <nameiparent>
    8000454e:	892a                	mv	s2,a0
    80004550:	12050e63          	beqz	a0,8000468c <create+0x162>
    return 0;

  ilock(dp);
    80004554:	ffffe097          	auipc	ra,0xffffe
    80004558:	5e0080e7          	jalr	1504(ra) # 80002b34 <ilock>

  if ((ip = dirlookup(dp, name, 0)) != 0)
    8000455c:	4601                	li	a2,0
    8000455e:	fb040593          	addi	a1,s0,-80
    80004562:	854a                	mv	a0,s2
    80004564:	fffff097          	auipc	ra,0xfffff
    80004568:	b60080e7          	jalr	-1184(ra) # 800030c4 <dirlookup>
    8000456c:	84aa                	mv	s1,a0
    8000456e:	c921                	beqz	a0,800045be <create+0x94>
  {
    iunlockput(dp);
    80004570:	854a                	mv	a0,s2
    80004572:	fffff097          	auipc	ra,0xfffff
    80004576:	8ce080e7          	jalr	-1842(ra) # 80002e40 <iunlockput>
    ilock(ip);
    8000457a:	8526                	mv	a0,s1
    8000457c:	ffffe097          	auipc	ra,0xffffe
    80004580:	5b8080e7          	jalr	1464(ra) # 80002b34 <ilock>
    if (type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004584:	2981                	sext.w	s3,s3
    80004586:	4789                	li	a5,2
    80004588:	02f99463          	bne	s3,a5,800045b0 <create+0x86>
    8000458c:	0444d783          	lhu	a5,68(s1)
    80004590:	37f9                	addiw	a5,a5,-2
    80004592:	17c2                	slli	a5,a5,0x30
    80004594:	93c1                	srli	a5,a5,0x30
    80004596:	4705                	li	a4,1
    80004598:	00f76c63          	bltu	a4,a5,800045b0 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    8000459c:	8526                	mv	a0,s1
    8000459e:	60a6                	ld	ra,72(sp)
    800045a0:	6406                	ld	s0,64(sp)
    800045a2:	74e2                	ld	s1,56(sp)
    800045a4:	7942                	ld	s2,48(sp)
    800045a6:	79a2                	ld	s3,40(sp)
    800045a8:	7a02                	ld	s4,32(sp)
    800045aa:	6ae2                	ld	s5,24(sp)
    800045ac:	6161                	addi	sp,sp,80
    800045ae:	8082                	ret
    iunlockput(ip);
    800045b0:	8526                	mv	a0,s1
    800045b2:	fffff097          	auipc	ra,0xfffff
    800045b6:	88e080e7          	jalr	-1906(ra) # 80002e40 <iunlockput>
    return 0;
    800045ba:	4481                	li	s1,0
    800045bc:	b7c5                	j	8000459c <create+0x72>
  if ((ip = ialloc(dp->dev, type)) == 0)
    800045be:	85ce                	mv	a1,s3
    800045c0:	00092503          	lw	a0,0(s2)
    800045c4:	ffffe097          	auipc	ra,0xffffe
    800045c8:	3d6080e7          	jalr	982(ra) # 8000299a <ialloc>
    800045cc:	84aa                	mv	s1,a0
    800045ce:	c521                	beqz	a0,80004616 <create+0xec>
  ilock(ip);
    800045d0:	ffffe097          	auipc	ra,0xffffe
    800045d4:	564080e7          	jalr	1380(ra) # 80002b34 <ilock>
  ip->major = major;
    800045d8:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    800045dc:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    800045e0:	4a05                	li	s4,1
    800045e2:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    800045e6:	8526                	mv	a0,s1
    800045e8:	ffffe097          	auipc	ra,0xffffe
    800045ec:	480080e7          	jalr	1152(ra) # 80002a68 <iupdate>
  if (type == T_DIR)
    800045f0:	2981                	sext.w	s3,s3
    800045f2:	03498a63          	beq	s3,s4,80004626 <create+0xfc>
  if (dirlink(dp, name, ip->inum) < 0)
    800045f6:	40d0                	lw	a2,4(s1)
    800045f8:	fb040593          	addi	a1,s0,-80
    800045fc:	854a                	mv	a0,s2
    800045fe:	fffff097          	auipc	ra,0xfffff
    80004602:	cdc080e7          	jalr	-804(ra) # 800032da <dirlink>
    80004606:	06054b63          	bltz	a0,8000467c <create+0x152>
  iunlockput(dp);
    8000460a:	854a                	mv	a0,s2
    8000460c:	fffff097          	auipc	ra,0xfffff
    80004610:	834080e7          	jalr	-1996(ra) # 80002e40 <iunlockput>
  return ip;
    80004614:	b761                	j	8000459c <create+0x72>
    panic("create: ialloc");
    80004616:	00004517          	auipc	a0,0x4
    8000461a:	05a50513          	addi	a0,a0,90 # 80008670 <syscalls+0x2a8>
    8000461e:	00001097          	auipc	ra,0x1
    80004622:	7a2080e7          	jalr	1954(ra) # 80005dc0 <panic>
    dp->nlink++; // for ".."
    80004626:	04a95783          	lhu	a5,74(s2)
    8000462a:	2785                	addiw	a5,a5,1
    8000462c:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80004630:	854a                	mv	a0,s2
    80004632:	ffffe097          	auipc	ra,0xffffe
    80004636:	436080e7          	jalr	1078(ra) # 80002a68 <iupdate>
    if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000463a:	40d0                	lw	a2,4(s1)
    8000463c:	00004597          	auipc	a1,0x4
    80004640:	04458593          	addi	a1,a1,68 # 80008680 <syscalls+0x2b8>
    80004644:	8526                	mv	a0,s1
    80004646:	fffff097          	auipc	ra,0xfffff
    8000464a:	c94080e7          	jalr	-876(ra) # 800032da <dirlink>
    8000464e:	00054f63          	bltz	a0,8000466c <create+0x142>
    80004652:	00492603          	lw	a2,4(s2)
    80004656:	00004597          	auipc	a1,0x4
    8000465a:	03258593          	addi	a1,a1,50 # 80008688 <syscalls+0x2c0>
    8000465e:	8526                	mv	a0,s1
    80004660:	fffff097          	auipc	ra,0xfffff
    80004664:	c7a080e7          	jalr	-902(ra) # 800032da <dirlink>
    80004668:	f80557e3          	bgez	a0,800045f6 <create+0xcc>
      panic("create dots");
    8000466c:	00004517          	auipc	a0,0x4
    80004670:	02450513          	addi	a0,a0,36 # 80008690 <syscalls+0x2c8>
    80004674:	00001097          	auipc	ra,0x1
    80004678:	74c080e7          	jalr	1868(ra) # 80005dc0 <panic>
    panic("create: dirlink");
    8000467c:	00004517          	auipc	a0,0x4
    80004680:	02450513          	addi	a0,a0,36 # 800086a0 <syscalls+0x2d8>
    80004684:	00001097          	auipc	ra,0x1
    80004688:	73c080e7          	jalr	1852(ra) # 80005dc0 <panic>
    return 0;
    8000468c:	84aa                	mv	s1,a0
    8000468e:	b739                	j	8000459c <create+0x72>

0000000080004690 <sys_dup>:
{
    80004690:	7179                	addi	sp,sp,-48
    80004692:	f406                	sd	ra,40(sp)
    80004694:	f022                	sd	s0,32(sp)
    80004696:	ec26                	sd	s1,24(sp)
    80004698:	e84a                	sd	s2,16(sp)
    8000469a:	1800                	addi	s0,sp,48
  if (argfd(0, 0, &f) < 0)
    8000469c:	fd840613          	addi	a2,s0,-40
    800046a0:	4581                	li	a1,0
    800046a2:	4501                	li	a0,0
    800046a4:	00000097          	auipc	ra,0x0
    800046a8:	ddc080e7          	jalr	-548(ra) # 80004480 <argfd>
    return -1;
    800046ac:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0)
    800046ae:	02054363          	bltz	a0,800046d4 <sys_dup+0x44>
  if ((fd = fdalloc(f)) < 0)
    800046b2:	fd843903          	ld	s2,-40(s0)
    800046b6:	854a                	mv	a0,s2
    800046b8:	00000097          	auipc	ra,0x0
    800046bc:	e30080e7          	jalr	-464(ra) # 800044e8 <fdalloc>
    800046c0:	84aa                	mv	s1,a0
    return -1;
    800046c2:	57fd                	li	a5,-1
  if ((fd = fdalloc(f)) < 0)
    800046c4:	00054863          	bltz	a0,800046d4 <sys_dup+0x44>
  filedup(f);
    800046c8:	854a                	mv	a0,s2
    800046ca:	fffff097          	auipc	ra,0xfffff
    800046ce:	368080e7          	jalr	872(ra) # 80003a32 <filedup>
  return fd;
    800046d2:	87a6                	mv	a5,s1
}
    800046d4:	853e                	mv	a0,a5
    800046d6:	70a2                	ld	ra,40(sp)
    800046d8:	7402                	ld	s0,32(sp)
    800046da:	64e2                	ld	s1,24(sp)
    800046dc:	6942                	ld	s2,16(sp)
    800046de:	6145                	addi	sp,sp,48
    800046e0:	8082                	ret

00000000800046e2 <sys_read>:
{
    800046e2:	7179                	addi	sp,sp,-48
    800046e4:	f406                	sd	ra,40(sp)
    800046e6:	f022                	sd	s0,32(sp)
    800046e8:	1800                	addi	s0,sp,48
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046ea:	fe840613          	addi	a2,s0,-24
    800046ee:	4581                	li	a1,0
    800046f0:	4501                	li	a0,0
    800046f2:	00000097          	auipc	ra,0x0
    800046f6:	d8e080e7          	jalr	-626(ra) # 80004480 <argfd>
    return -1;
    800046fa:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046fc:	04054163          	bltz	a0,8000473e <sys_read+0x5c>
    80004700:	fe440593          	addi	a1,s0,-28
    80004704:	4509                	li	a0,2
    80004706:	ffffd097          	auipc	ra,0xffffd
    8000470a:	7f4080e7          	jalr	2036(ra) # 80001efa <argint>
    return -1;
    8000470e:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004710:	02054763          	bltz	a0,8000473e <sys_read+0x5c>
    80004714:	fd840593          	addi	a1,s0,-40
    80004718:	4505                	li	a0,1
    8000471a:	ffffe097          	auipc	ra,0xffffe
    8000471e:	802080e7          	jalr	-2046(ra) # 80001f1c <argaddr>
    return -1;
    80004722:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004724:	00054d63          	bltz	a0,8000473e <sys_read+0x5c>
  return fileread(f, p, n);
    80004728:	fe442603          	lw	a2,-28(s0)
    8000472c:	fd843583          	ld	a1,-40(s0)
    80004730:	fe843503          	ld	a0,-24(s0)
    80004734:	fffff097          	auipc	ra,0xfffff
    80004738:	48a080e7          	jalr	1162(ra) # 80003bbe <fileread>
    8000473c:	87aa                	mv	a5,a0
}
    8000473e:	853e                	mv	a0,a5
    80004740:	70a2                	ld	ra,40(sp)
    80004742:	7402                	ld	s0,32(sp)
    80004744:	6145                	addi	sp,sp,48
    80004746:	8082                	ret

0000000080004748 <sys_write>:
{
    80004748:	7179                	addi	sp,sp,-48
    8000474a:	f406                	sd	ra,40(sp)
    8000474c:	f022                	sd	s0,32(sp)
    8000474e:	1800                	addi	s0,sp,48
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004750:	fe840613          	addi	a2,s0,-24
    80004754:	4581                	li	a1,0
    80004756:	4501                	li	a0,0
    80004758:	00000097          	auipc	ra,0x0
    8000475c:	d28080e7          	jalr	-728(ra) # 80004480 <argfd>
    return -1;
    80004760:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004762:	04054163          	bltz	a0,800047a4 <sys_write+0x5c>
    80004766:	fe440593          	addi	a1,s0,-28
    8000476a:	4509                	li	a0,2
    8000476c:	ffffd097          	auipc	ra,0xffffd
    80004770:	78e080e7          	jalr	1934(ra) # 80001efa <argint>
    return -1;
    80004774:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004776:	02054763          	bltz	a0,800047a4 <sys_write+0x5c>
    8000477a:	fd840593          	addi	a1,s0,-40
    8000477e:	4505                	li	a0,1
    80004780:	ffffd097          	auipc	ra,0xffffd
    80004784:	79c080e7          	jalr	1948(ra) # 80001f1c <argaddr>
    return -1;
    80004788:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000478a:	00054d63          	bltz	a0,800047a4 <sys_write+0x5c>
  return filewrite(f, p, n);
    8000478e:	fe442603          	lw	a2,-28(s0)
    80004792:	fd843583          	ld	a1,-40(s0)
    80004796:	fe843503          	ld	a0,-24(s0)
    8000479a:	fffff097          	auipc	ra,0xfffff
    8000479e:	4e6080e7          	jalr	1254(ra) # 80003c80 <filewrite>
    800047a2:	87aa                	mv	a5,a0
}
    800047a4:	853e                	mv	a0,a5
    800047a6:	70a2                	ld	ra,40(sp)
    800047a8:	7402                	ld	s0,32(sp)
    800047aa:	6145                	addi	sp,sp,48
    800047ac:	8082                	ret

00000000800047ae <sys_close>:
{
    800047ae:	1101                	addi	sp,sp,-32
    800047b0:	ec06                	sd	ra,24(sp)
    800047b2:	e822                	sd	s0,16(sp)
    800047b4:	1000                	addi	s0,sp,32
  if (argfd(0, &fd, &f) < 0)
    800047b6:	fe040613          	addi	a2,s0,-32
    800047ba:	fec40593          	addi	a1,s0,-20
    800047be:	4501                	li	a0,0
    800047c0:	00000097          	auipc	ra,0x0
    800047c4:	cc0080e7          	jalr	-832(ra) # 80004480 <argfd>
    return -1;
    800047c8:	57fd                	li	a5,-1
  if (argfd(0, &fd, &f) < 0)
    800047ca:	02054463          	bltz	a0,800047f2 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800047ce:	ffffc097          	auipc	ra,0xffffc
    800047d2:	676080e7          	jalr	1654(ra) # 80000e44 <myproc>
    800047d6:	fec42783          	lw	a5,-20(s0)
    800047da:	07e9                	addi	a5,a5,26
    800047dc:	078e                	slli	a5,a5,0x3
    800047de:	953e                	add	a0,a0,a5
    800047e0:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800047e4:	fe043503          	ld	a0,-32(s0)
    800047e8:	fffff097          	auipc	ra,0xfffff
    800047ec:	29c080e7          	jalr	668(ra) # 80003a84 <fileclose>
  return 0;
    800047f0:	4781                	li	a5,0
}
    800047f2:	853e                	mv	a0,a5
    800047f4:	60e2                	ld	ra,24(sp)
    800047f6:	6442                	ld	s0,16(sp)
    800047f8:	6105                	addi	sp,sp,32
    800047fa:	8082                	ret

00000000800047fc <sys_fstat>:
{
    800047fc:	1101                	addi	sp,sp,-32
    800047fe:	ec06                	sd	ra,24(sp)
    80004800:	e822                	sd	s0,16(sp)
    80004802:	1000                	addi	s0,sp,32
  if (argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004804:	fe840613          	addi	a2,s0,-24
    80004808:	4581                	li	a1,0
    8000480a:	4501                	li	a0,0
    8000480c:	00000097          	auipc	ra,0x0
    80004810:	c74080e7          	jalr	-908(ra) # 80004480 <argfd>
    return -1;
    80004814:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004816:	02054563          	bltz	a0,80004840 <sys_fstat+0x44>
    8000481a:	fe040593          	addi	a1,s0,-32
    8000481e:	4505                	li	a0,1
    80004820:	ffffd097          	auipc	ra,0xffffd
    80004824:	6fc080e7          	jalr	1788(ra) # 80001f1c <argaddr>
    return -1;
    80004828:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000482a:	00054b63          	bltz	a0,80004840 <sys_fstat+0x44>
  return filestat(f, st);
    8000482e:	fe043583          	ld	a1,-32(s0)
    80004832:	fe843503          	ld	a0,-24(s0)
    80004836:	fffff097          	auipc	ra,0xfffff
    8000483a:	316080e7          	jalr	790(ra) # 80003b4c <filestat>
    8000483e:	87aa                	mv	a5,a0
}
    80004840:	853e                	mv	a0,a5
    80004842:	60e2                	ld	ra,24(sp)
    80004844:	6442                	ld	s0,16(sp)
    80004846:	6105                	addi	sp,sp,32
    80004848:	8082                	ret

000000008000484a <sys_link>:
{
    8000484a:	7169                	addi	sp,sp,-304
    8000484c:	f606                	sd	ra,296(sp)
    8000484e:	f222                	sd	s0,288(sp)
    80004850:	ee26                	sd	s1,280(sp)
    80004852:	ea4a                	sd	s2,272(sp)
    80004854:	1a00                	addi	s0,sp,304
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004856:	08000613          	li	a2,128
    8000485a:	ed040593          	addi	a1,s0,-304
    8000485e:	4501                	li	a0,0
    80004860:	ffffd097          	auipc	ra,0xffffd
    80004864:	6de080e7          	jalr	1758(ra) # 80001f3e <argstr>
    return -1;
    80004868:	57fd                	li	a5,-1
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000486a:	10054e63          	bltz	a0,80004986 <sys_link+0x13c>
    8000486e:	08000613          	li	a2,128
    80004872:	f5040593          	addi	a1,s0,-176
    80004876:	4505                	li	a0,1
    80004878:	ffffd097          	auipc	ra,0xffffd
    8000487c:	6c6080e7          	jalr	1734(ra) # 80001f3e <argstr>
    return -1;
    80004880:	57fd                	li	a5,-1
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004882:	10054263          	bltz	a0,80004986 <sys_link+0x13c>
  begin_op();
    80004886:	fffff097          	auipc	ra,0xfffff
    8000488a:	d36080e7          	jalr	-714(ra) # 800035bc <begin_op>
  if ((ip = namei(old)) == 0)
    8000488e:	ed040513          	addi	a0,s0,-304
    80004892:	fffff097          	auipc	ra,0xfffff
    80004896:	b0a080e7          	jalr	-1270(ra) # 8000339c <namei>
    8000489a:	84aa                	mv	s1,a0
    8000489c:	c551                	beqz	a0,80004928 <sys_link+0xde>
  ilock(ip);
    8000489e:	ffffe097          	auipc	ra,0xffffe
    800048a2:	296080e7          	jalr	662(ra) # 80002b34 <ilock>
  if (ip->type == T_DIR)
    800048a6:	04449703          	lh	a4,68(s1)
    800048aa:	4785                	li	a5,1
    800048ac:	08f70463          	beq	a4,a5,80004934 <sys_link+0xea>
  ip->nlink++;
    800048b0:	04a4d783          	lhu	a5,74(s1)
    800048b4:	2785                	addiw	a5,a5,1
    800048b6:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800048ba:	8526                	mv	a0,s1
    800048bc:	ffffe097          	auipc	ra,0xffffe
    800048c0:	1ac080e7          	jalr	428(ra) # 80002a68 <iupdate>
  iunlock(ip);
    800048c4:	8526                	mv	a0,s1
    800048c6:	ffffe097          	auipc	ra,0xffffe
    800048ca:	330080e7          	jalr	816(ra) # 80002bf6 <iunlock>
  if ((dp = nameiparent(new, name)) == 0)
    800048ce:	fd040593          	addi	a1,s0,-48
    800048d2:	f5040513          	addi	a0,s0,-176
    800048d6:	fffff097          	auipc	ra,0xfffff
    800048da:	ae4080e7          	jalr	-1308(ra) # 800033ba <nameiparent>
    800048de:	892a                	mv	s2,a0
    800048e0:	c935                	beqz	a0,80004954 <sys_link+0x10a>
  ilock(dp);
    800048e2:	ffffe097          	auipc	ra,0xffffe
    800048e6:	252080e7          	jalr	594(ra) # 80002b34 <ilock>
  if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0)
    800048ea:	00092703          	lw	a4,0(s2)
    800048ee:	409c                	lw	a5,0(s1)
    800048f0:	04f71d63          	bne	a4,a5,8000494a <sys_link+0x100>
    800048f4:	40d0                	lw	a2,4(s1)
    800048f6:	fd040593          	addi	a1,s0,-48
    800048fa:	854a                	mv	a0,s2
    800048fc:	fffff097          	auipc	ra,0xfffff
    80004900:	9de080e7          	jalr	-1570(ra) # 800032da <dirlink>
    80004904:	04054363          	bltz	a0,8000494a <sys_link+0x100>
  iunlockput(dp);
    80004908:	854a                	mv	a0,s2
    8000490a:	ffffe097          	auipc	ra,0xffffe
    8000490e:	536080e7          	jalr	1334(ra) # 80002e40 <iunlockput>
  iput(ip);
    80004912:	8526                	mv	a0,s1
    80004914:	ffffe097          	auipc	ra,0xffffe
    80004918:	484080e7          	jalr	1156(ra) # 80002d98 <iput>
  end_op();
    8000491c:	fffff097          	auipc	ra,0xfffff
    80004920:	d1e080e7          	jalr	-738(ra) # 8000363a <end_op>
  return 0;
    80004924:	4781                	li	a5,0
    80004926:	a085                	j	80004986 <sys_link+0x13c>
    end_op();
    80004928:	fffff097          	auipc	ra,0xfffff
    8000492c:	d12080e7          	jalr	-750(ra) # 8000363a <end_op>
    return -1;
    80004930:	57fd                	li	a5,-1
    80004932:	a891                	j	80004986 <sys_link+0x13c>
    iunlockput(ip);
    80004934:	8526                	mv	a0,s1
    80004936:	ffffe097          	auipc	ra,0xffffe
    8000493a:	50a080e7          	jalr	1290(ra) # 80002e40 <iunlockput>
    end_op();
    8000493e:	fffff097          	auipc	ra,0xfffff
    80004942:	cfc080e7          	jalr	-772(ra) # 8000363a <end_op>
    return -1;
    80004946:	57fd                	li	a5,-1
    80004948:	a83d                	j	80004986 <sys_link+0x13c>
    iunlockput(dp);
    8000494a:	854a                	mv	a0,s2
    8000494c:	ffffe097          	auipc	ra,0xffffe
    80004950:	4f4080e7          	jalr	1268(ra) # 80002e40 <iunlockput>
  ilock(ip);
    80004954:	8526                	mv	a0,s1
    80004956:	ffffe097          	auipc	ra,0xffffe
    8000495a:	1de080e7          	jalr	478(ra) # 80002b34 <ilock>
  ip->nlink--;
    8000495e:	04a4d783          	lhu	a5,74(s1)
    80004962:	37fd                	addiw	a5,a5,-1
    80004964:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004968:	8526                	mv	a0,s1
    8000496a:	ffffe097          	auipc	ra,0xffffe
    8000496e:	0fe080e7          	jalr	254(ra) # 80002a68 <iupdate>
  iunlockput(ip);
    80004972:	8526                	mv	a0,s1
    80004974:	ffffe097          	auipc	ra,0xffffe
    80004978:	4cc080e7          	jalr	1228(ra) # 80002e40 <iunlockput>
  end_op();
    8000497c:	fffff097          	auipc	ra,0xfffff
    80004980:	cbe080e7          	jalr	-834(ra) # 8000363a <end_op>
  return -1;
    80004984:	57fd                	li	a5,-1
}
    80004986:	853e                	mv	a0,a5
    80004988:	70b2                	ld	ra,296(sp)
    8000498a:	7412                	ld	s0,288(sp)
    8000498c:	64f2                	ld	s1,280(sp)
    8000498e:	6952                	ld	s2,272(sp)
    80004990:	6155                	addi	sp,sp,304
    80004992:	8082                	ret

0000000080004994 <sys_unlink>:
{
    80004994:	7151                	addi	sp,sp,-240
    80004996:	f586                	sd	ra,232(sp)
    80004998:	f1a2                	sd	s0,224(sp)
    8000499a:	eda6                	sd	s1,216(sp)
    8000499c:	e9ca                	sd	s2,208(sp)
    8000499e:	e5ce                	sd	s3,200(sp)
    800049a0:	1980                	addi	s0,sp,240
  if (argstr(0, path, MAXPATH) < 0)
    800049a2:	08000613          	li	a2,128
    800049a6:	f3040593          	addi	a1,s0,-208
    800049aa:	4501                	li	a0,0
    800049ac:	ffffd097          	auipc	ra,0xffffd
    800049b0:	592080e7          	jalr	1426(ra) # 80001f3e <argstr>
    800049b4:	18054163          	bltz	a0,80004b36 <sys_unlink+0x1a2>
  begin_op();
    800049b8:	fffff097          	auipc	ra,0xfffff
    800049bc:	c04080e7          	jalr	-1020(ra) # 800035bc <begin_op>
  if ((dp = nameiparent(path, name)) == 0)
    800049c0:	fb040593          	addi	a1,s0,-80
    800049c4:	f3040513          	addi	a0,s0,-208
    800049c8:	fffff097          	auipc	ra,0xfffff
    800049cc:	9f2080e7          	jalr	-1550(ra) # 800033ba <nameiparent>
    800049d0:	84aa                	mv	s1,a0
    800049d2:	c979                	beqz	a0,80004aa8 <sys_unlink+0x114>
  ilock(dp);
    800049d4:	ffffe097          	auipc	ra,0xffffe
    800049d8:	160080e7          	jalr	352(ra) # 80002b34 <ilock>
  if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800049dc:	00004597          	auipc	a1,0x4
    800049e0:	ca458593          	addi	a1,a1,-860 # 80008680 <syscalls+0x2b8>
    800049e4:	fb040513          	addi	a0,s0,-80
    800049e8:	ffffe097          	auipc	ra,0xffffe
    800049ec:	6c2080e7          	jalr	1730(ra) # 800030aa <namecmp>
    800049f0:	14050a63          	beqz	a0,80004b44 <sys_unlink+0x1b0>
    800049f4:	00004597          	auipc	a1,0x4
    800049f8:	c9458593          	addi	a1,a1,-876 # 80008688 <syscalls+0x2c0>
    800049fc:	fb040513          	addi	a0,s0,-80
    80004a00:	ffffe097          	auipc	ra,0xffffe
    80004a04:	6aa080e7          	jalr	1706(ra) # 800030aa <namecmp>
    80004a08:	12050e63          	beqz	a0,80004b44 <sys_unlink+0x1b0>
  if ((ip = dirlookup(dp, name, &off)) == 0)
    80004a0c:	f2c40613          	addi	a2,s0,-212
    80004a10:	fb040593          	addi	a1,s0,-80
    80004a14:	8526                	mv	a0,s1
    80004a16:	ffffe097          	auipc	ra,0xffffe
    80004a1a:	6ae080e7          	jalr	1710(ra) # 800030c4 <dirlookup>
    80004a1e:	892a                	mv	s2,a0
    80004a20:	12050263          	beqz	a0,80004b44 <sys_unlink+0x1b0>
  ilock(ip);
    80004a24:	ffffe097          	auipc	ra,0xffffe
    80004a28:	110080e7          	jalr	272(ra) # 80002b34 <ilock>
  if (ip->nlink < 1)
    80004a2c:	04a91783          	lh	a5,74(s2)
    80004a30:	08f05263          	blez	a5,80004ab4 <sys_unlink+0x120>
  if (ip->type == T_DIR && !isdirempty(ip))
    80004a34:	04491703          	lh	a4,68(s2)
    80004a38:	4785                	li	a5,1
    80004a3a:	08f70563          	beq	a4,a5,80004ac4 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004a3e:	4641                	li	a2,16
    80004a40:	4581                	li	a1,0
    80004a42:	fc040513          	addi	a0,s0,-64
    80004a46:	ffffb097          	auipc	ra,0xffffb
    80004a4a:	734080e7          	jalr	1844(ra) # 8000017a <memset>
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a4e:	4741                	li	a4,16
    80004a50:	f2c42683          	lw	a3,-212(s0)
    80004a54:	fc040613          	addi	a2,s0,-64
    80004a58:	4581                	li	a1,0
    80004a5a:	8526                	mv	a0,s1
    80004a5c:	ffffe097          	auipc	ra,0xffffe
    80004a60:	52e080e7          	jalr	1326(ra) # 80002f8a <writei>
    80004a64:	47c1                	li	a5,16
    80004a66:	0af51563          	bne	a0,a5,80004b10 <sys_unlink+0x17c>
  if (ip->type == T_DIR)
    80004a6a:	04491703          	lh	a4,68(s2)
    80004a6e:	4785                	li	a5,1
    80004a70:	0af70863          	beq	a4,a5,80004b20 <sys_unlink+0x18c>
  iunlockput(dp);
    80004a74:	8526                	mv	a0,s1
    80004a76:	ffffe097          	auipc	ra,0xffffe
    80004a7a:	3ca080e7          	jalr	970(ra) # 80002e40 <iunlockput>
  ip->nlink--;
    80004a7e:	04a95783          	lhu	a5,74(s2)
    80004a82:	37fd                	addiw	a5,a5,-1
    80004a84:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004a88:	854a                	mv	a0,s2
    80004a8a:	ffffe097          	auipc	ra,0xffffe
    80004a8e:	fde080e7          	jalr	-34(ra) # 80002a68 <iupdate>
  iunlockput(ip);
    80004a92:	854a                	mv	a0,s2
    80004a94:	ffffe097          	auipc	ra,0xffffe
    80004a98:	3ac080e7          	jalr	940(ra) # 80002e40 <iunlockput>
  end_op();
    80004a9c:	fffff097          	auipc	ra,0xfffff
    80004aa0:	b9e080e7          	jalr	-1122(ra) # 8000363a <end_op>
  return 0;
    80004aa4:	4501                	li	a0,0
    80004aa6:	a84d                	j	80004b58 <sys_unlink+0x1c4>
    end_op();
    80004aa8:	fffff097          	auipc	ra,0xfffff
    80004aac:	b92080e7          	jalr	-1134(ra) # 8000363a <end_op>
    return -1;
    80004ab0:	557d                	li	a0,-1
    80004ab2:	a05d                	j	80004b58 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004ab4:	00004517          	auipc	a0,0x4
    80004ab8:	bfc50513          	addi	a0,a0,-1028 # 800086b0 <syscalls+0x2e8>
    80004abc:	00001097          	auipc	ra,0x1
    80004ac0:	304080e7          	jalr	772(ra) # 80005dc0 <panic>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
    80004ac4:	04c92703          	lw	a4,76(s2)
    80004ac8:	02000793          	li	a5,32
    80004acc:	f6e7f9e3          	bgeu	a5,a4,80004a3e <sys_unlink+0xaa>
    80004ad0:	02000993          	li	s3,32
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004ad4:	4741                	li	a4,16
    80004ad6:	86ce                	mv	a3,s3
    80004ad8:	f1840613          	addi	a2,s0,-232
    80004adc:	4581                	li	a1,0
    80004ade:	854a                	mv	a0,s2
    80004ae0:	ffffe097          	auipc	ra,0xffffe
    80004ae4:	3b2080e7          	jalr	946(ra) # 80002e92 <readi>
    80004ae8:	47c1                	li	a5,16
    80004aea:	00f51b63          	bne	a0,a5,80004b00 <sys_unlink+0x16c>
    if (de.inum != 0)
    80004aee:	f1845783          	lhu	a5,-232(s0)
    80004af2:	e7a1                	bnez	a5,80004b3a <sys_unlink+0x1a6>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
    80004af4:	29c1                	addiw	s3,s3,16
    80004af6:	04c92783          	lw	a5,76(s2)
    80004afa:	fcf9ede3          	bltu	s3,a5,80004ad4 <sys_unlink+0x140>
    80004afe:	b781                	j	80004a3e <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004b00:	00004517          	auipc	a0,0x4
    80004b04:	bc850513          	addi	a0,a0,-1080 # 800086c8 <syscalls+0x300>
    80004b08:	00001097          	auipc	ra,0x1
    80004b0c:	2b8080e7          	jalr	696(ra) # 80005dc0 <panic>
    panic("unlink: writei");
    80004b10:	00004517          	auipc	a0,0x4
    80004b14:	bd050513          	addi	a0,a0,-1072 # 800086e0 <syscalls+0x318>
    80004b18:	00001097          	auipc	ra,0x1
    80004b1c:	2a8080e7          	jalr	680(ra) # 80005dc0 <panic>
    dp->nlink--;
    80004b20:	04a4d783          	lhu	a5,74(s1)
    80004b24:	37fd                	addiw	a5,a5,-1
    80004b26:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004b2a:	8526                	mv	a0,s1
    80004b2c:	ffffe097          	auipc	ra,0xffffe
    80004b30:	f3c080e7          	jalr	-196(ra) # 80002a68 <iupdate>
    80004b34:	b781                	j	80004a74 <sys_unlink+0xe0>
    return -1;
    80004b36:	557d                	li	a0,-1
    80004b38:	a005                	j	80004b58 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004b3a:	854a                	mv	a0,s2
    80004b3c:	ffffe097          	auipc	ra,0xffffe
    80004b40:	304080e7          	jalr	772(ra) # 80002e40 <iunlockput>
  iunlockput(dp);
    80004b44:	8526                	mv	a0,s1
    80004b46:	ffffe097          	auipc	ra,0xffffe
    80004b4a:	2fa080e7          	jalr	762(ra) # 80002e40 <iunlockput>
  end_op();
    80004b4e:	fffff097          	auipc	ra,0xfffff
    80004b52:	aec080e7          	jalr	-1300(ra) # 8000363a <end_op>
  return -1;
    80004b56:	557d                	li	a0,-1
}
    80004b58:	70ae                	ld	ra,232(sp)
    80004b5a:	740e                	ld	s0,224(sp)
    80004b5c:	64ee                	ld	s1,216(sp)
    80004b5e:	694e                	ld	s2,208(sp)
    80004b60:	69ae                	ld	s3,200(sp)
    80004b62:	616d                	addi	sp,sp,240
    80004b64:	8082                	ret

0000000080004b66 <sys_open>:

uint64
sys_open(void)
{
    80004b66:	7155                	addi	sp,sp,-208
    80004b68:	e586                	sd	ra,200(sp)
    80004b6a:	e1a2                	sd	s0,192(sp)
    80004b6c:	fd26                	sd	s1,184(sp)
    80004b6e:	f94a                	sd	s2,176(sp)
    80004b70:	f54e                	sd	s3,168(sp)
    80004b72:	f152                	sd	s4,160(sp)
    80004b74:	ed56                	sd	s5,152(sp)
    80004b76:	0980                	addi	s0,sp,208
  struct file *f;
  struct inode *ip;
  int n;
  int depth = 0;

  if ((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b78:	08000613          	li	a2,128
    80004b7c:	f4040593          	addi	a1,s0,-192
    80004b80:	4501                	li	a0,0
    80004b82:	ffffd097          	auipc	ra,0xffffd
    80004b86:	3bc080e7          	jalr	956(ra) # 80001f3e <argstr>
    return -1;
    80004b8a:	597d                	li	s2,-1
  if ((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b8c:	1a054163          	bltz	a0,80004d2e <sys_open+0x1c8>
    80004b90:	f3c40593          	addi	a1,s0,-196
    80004b94:	4505                	li	a0,1
    80004b96:	ffffd097          	auipc	ra,0xffffd
    80004b9a:	364080e7          	jalr	868(ra) # 80001efa <argint>
    80004b9e:	18054863          	bltz	a0,80004d2e <sys_open+0x1c8>

  begin_op();
    80004ba2:	fffff097          	auipc	ra,0xfffff
    80004ba6:	a1a080e7          	jalr	-1510(ra) # 800035bc <begin_op>

  if (omode & O_CREATE)
    80004baa:	f3c42783          	lw	a5,-196(s0)
    80004bae:	2007f793          	andi	a5,a5,512
    80004bb2:	10078f63          	beqz	a5,80004cd0 <sys_open+0x16a>
  {
    ip = create(path, T_FILE, 0, 0);
    80004bb6:	4681                	li	a3,0
    80004bb8:	4601                	li	a2,0
    80004bba:	4589                	li	a1,2
    80004bbc:	f4040513          	addi	a0,s0,-192
    80004bc0:	00000097          	auipc	ra,0x0
    80004bc4:	96a080e7          	jalr	-1686(ra) # 8000452a <create>
    80004bc8:	84aa                	mv	s1,a0
    if (ip == 0)
    80004bca:	cd75                	beqz	a0,80004cc6 <sys_open+0x160>
      return -1;
    }
  }

  // 不断判断该 inode 是否为符号链接
  while (ip->type == T_SYMLINK && !(omode & O_NOFOLLOW))
    80004bcc:	04449783          	lh	a5,68(s1)
    80004bd0:	0007869b          	sext.w	a3,a5
    80004bd4:	4711                	li	a4,4
    80004bd6:	4955                	li	s2,21
    80004bd8:	06e69563          	bne	a3,a4,80004c42 <sys_open+0xdc>
    80004bdc:	6985                	lui	s3,0x1
    80004bde:	80098993          	addi	s3,s3,-2048 # 800 <_entry-0x7ffff800>
      iunlockput(ip);
      end_op();
      return -1;
    }
    // 读取对应的 inode
    if (readi(ip, 0, (uint64)path, 0, MAXPATH) < MAXPATH)
    80004be2:	07f00a13          	li	s4,127
  while (ip->type == T_SYMLINK && !(omode & O_NOFOLLOW))
    80004be6:	4a91                	li	s5,4
    80004be8:	f3c42783          	lw	a5,-196(s0)
    80004bec:	0137f7b3          	and	a5,a5,s3
    80004bf0:	e3b5                	bnez	a5,80004c54 <sys_open+0xee>
    if (depth++ >= 20)
    80004bf2:	397d                	addiw	s2,s2,-1
    80004bf4:	12090363          	beqz	s2,80004d1a <sys_open+0x1b4>
    if (readi(ip, 0, (uint64)path, 0, MAXPATH) < MAXPATH)
    80004bf8:	08000713          	li	a4,128
    80004bfc:	4681                	li	a3,0
    80004bfe:	f4040613          	addi	a2,s0,-192
    80004c02:	4581                	li	a1,0
    80004c04:	8526                	mv	a0,s1
    80004c06:	ffffe097          	auipc	ra,0xffffe
    80004c0a:	28c080e7          	jalr	652(ra) # 80002e92 <readi>
    80004c0e:	12aa5a63          	bge	s4,a0,80004d42 <sys_open+0x1dc>
    {
      iunlockput(ip);
      end_op();
      return -1;
    }
    iunlockput(ip);
    80004c12:	8526                	mv	a0,s1
    80004c14:	ffffe097          	auipc	ra,0xffffe
    80004c18:	22c080e7          	jalr	556(ra) # 80002e40 <iunlockput>
    // 根据文件名称找到对应的 inode
    if ((ip = namei(path)) == 0)
    80004c1c:	f4040513          	addi	a0,s0,-192
    80004c20:	ffffe097          	auipc	ra,0xffffe
    80004c24:	77c080e7          	jalr	1916(ra) # 8000339c <namei>
    80004c28:	84aa                	mv	s1,a0
    80004c2a:	12050763          	beqz	a0,80004d58 <sys_open+0x1f2>
    {
      end_op();
      return -1;
    }
    ilock(ip);
    80004c2e:	ffffe097          	auipc	ra,0xffffe
    80004c32:	f06080e7          	jalr	-250(ra) # 80002b34 <ilock>
  while (ip->type == T_SYMLINK && !(omode & O_NOFOLLOW))
    80004c36:	04449783          	lh	a5,68(s1)
    80004c3a:	0007871b          	sext.w	a4,a5
    80004c3e:	fb5705e3          	beq	a4,s5,80004be8 <sys_open+0x82>
  }

  if (ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV))
    80004c42:	2781                	sext.w	a5,a5
    80004c44:	470d                	li	a4,3
    80004c46:	00e79763          	bne	a5,a4,80004c54 <sys_open+0xee>
    80004c4a:	0464d703          	lhu	a4,70(s1)
    80004c4e:	47a5                	li	a5,9
    80004c50:	10e7ea63          	bltu	a5,a4,80004d64 <sys_open+0x1fe>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0)
    80004c54:	fffff097          	auipc	ra,0xfffff
    80004c58:	d74080e7          	jalr	-652(ra) # 800039c8 <filealloc>
    80004c5c:	89aa                	mv	s3,a0
    80004c5e:	14050063          	beqz	a0,80004d9e <sys_open+0x238>
    80004c62:	00000097          	auipc	ra,0x0
    80004c66:	886080e7          	jalr	-1914(ra) # 800044e8 <fdalloc>
    80004c6a:	892a                	mv	s2,a0
    80004c6c:	12054463          	bltz	a0,80004d94 <sys_open+0x22e>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if (ip->type == T_DEVICE)
    80004c70:	04449703          	lh	a4,68(s1)
    80004c74:	478d                	li	a5,3
    80004c76:	10f70263          	beq	a4,a5,80004d7a <sys_open+0x214>
    f->type = FD_DEVICE;
    f->major = ip->major;
  }
  else
  {
    f->type = FD_INODE;
    80004c7a:	4789                	li	a5,2
    80004c7c:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004c80:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004c84:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004c88:	f3c42783          	lw	a5,-196(s0)
    80004c8c:	0017c713          	xori	a4,a5,1
    80004c90:	8b05                	andi	a4,a4,1
    80004c92:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004c96:	0037f713          	andi	a4,a5,3
    80004c9a:	00e03733          	snez	a4,a4
    80004c9e:	00e984a3          	sb	a4,9(s3)

  if ((omode & O_TRUNC) && ip->type == T_FILE)
    80004ca2:	4007f793          	andi	a5,a5,1024
    80004ca6:	c791                	beqz	a5,80004cb2 <sys_open+0x14c>
    80004ca8:	04449703          	lh	a4,68(s1)
    80004cac:	4789                	li	a5,2
    80004cae:	0cf70d63          	beq	a4,a5,80004d88 <sys_open+0x222>
  {
    itrunc(ip);
  }

  iunlock(ip);
    80004cb2:	8526                	mv	a0,s1
    80004cb4:	ffffe097          	auipc	ra,0xffffe
    80004cb8:	f42080e7          	jalr	-190(ra) # 80002bf6 <iunlock>
  end_op();
    80004cbc:	fffff097          	auipc	ra,0xfffff
    80004cc0:	97e080e7          	jalr	-1666(ra) # 8000363a <end_op>

  return fd;
    80004cc4:	a0ad                	j	80004d2e <sys_open+0x1c8>
      end_op();
    80004cc6:	fffff097          	auipc	ra,0xfffff
    80004cca:	974080e7          	jalr	-1676(ra) # 8000363a <end_op>
      return -1;
    80004cce:	a085                	j	80004d2e <sys_open+0x1c8>
    if ((ip = namei(path)) == 0)
    80004cd0:	f4040513          	addi	a0,s0,-192
    80004cd4:	ffffe097          	auipc	ra,0xffffe
    80004cd8:	6c8080e7          	jalr	1736(ra) # 8000339c <namei>
    80004cdc:	84aa                	mv	s1,a0
    80004cde:	c905                	beqz	a0,80004d0e <sys_open+0x1a8>
    ilock(ip);
    80004ce0:	ffffe097          	auipc	ra,0xffffe
    80004ce4:	e54080e7          	jalr	-428(ra) # 80002b34 <ilock>
    if (ip->type == T_DIR && omode != O_RDONLY)
    80004ce8:	04449703          	lh	a4,68(s1)
    80004cec:	4785                	li	a5,1
    80004cee:	ecf71fe3          	bne	a4,a5,80004bcc <sys_open+0x66>
    80004cf2:	f3c42783          	lw	a5,-196(s0)
    80004cf6:	dfb9                	beqz	a5,80004c54 <sys_open+0xee>
      iunlockput(ip);
    80004cf8:	8526                	mv	a0,s1
    80004cfa:	ffffe097          	auipc	ra,0xffffe
    80004cfe:	146080e7          	jalr	326(ra) # 80002e40 <iunlockput>
      end_op();
    80004d02:	fffff097          	auipc	ra,0xfffff
    80004d06:	938080e7          	jalr	-1736(ra) # 8000363a <end_op>
      return -1;
    80004d0a:	597d                	li	s2,-1
    80004d0c:	a00d                	j	80004d2e <sys_open+0x1c8>
      end_op();
    80004d0e:	fffff097          	auipc	ra,0xfffff
    80004d12:	92c080e7          	jalr	-1748(ra) # 8000363a <end_op>
      return -1;
    80004d16:	597d                	li	s2,-1
    80004d18:	a819                	j	80004d2e <sys_open+0x1c8>
      iunlockput(ip);
    80004d1a:	8526                	mv	a0,s1
    80004d1c:	ffffe097          	auipc	ra,0xffffe
    80004d20:	124080e7          	jalr	292(ra) # 80002e40 <iunlockput>
      end_op();
    80004d24:	fffff097          	auipc	ra,0xfffff
    80004d28:	916080e7          	jalr	-1770(ra) # 8000363a <end_op>
      return -1;
    80004d2c:	597d                	li	s2,-1
}
    80004d2e:	854a                	mv	a0,s2
    80004d30:	60ae                	ld	ra,200(sp)
    80004d32:	640e                	ld	s0,192(sp)
    80004d34:	74ea                	ld	s1,184(sp)
    80004d36:	794a                	ld	s2,176(sp)
    80004d38:	79aa                	ld	s3,168(sp)
    80004d3a:	7a0a                	ld	s4,160(sp)
    80004d3c:	6aea                	ld	s5,152(sp)
    80004d3e:	6169                	addi	sp,sp,208
    80004d40:	8082                	ret
      iunlockput(ip);
    80004d42:	8526                	mv	a0,s1
    80004d44:	ffffe097          	auipc	ra,0xffffe
    80004d48:	0fc080e7          	jalr	252(ra) # 80002e40 <iunlockput>
      end_op();
    80004d4c:	fffff097          	auipc	ra,0xfffff
    80004d50:	8ee080e7          	jalr	-1810(ra) # 8000363a <end_op>
      return -1;
    80004d54:	597d                	li	s2,-1
    80004d56:	bfe1                	j	80004d2e <sys_open+0x1c8>
      end_op();
    80004d58:	fffff097          	auipc	ra,0xfffff
    80004d5c:	8e2080e7          	jalr	-1822(ra) # 8000363a <end_op>
      return -1;
    80004d60:	597d                	li	s2,-1
    80004d62:	b7f1                	j	80004d2e <sys_open+0x1c8>
    iunlockput(ip);
    80004d64:	8526                	mv	a0,s1
    80004d66:	ffffe097          	auipc	ra,0xffffe
    80004d6a:	0da080e7          	jalr	218(ra) # 80002e40 <iunlockput>
    end_op();
    80004d6e:	fffff097          	auipc	ra,0xfffff
    80004d72:	8cc080e7          	jalr	-1844(ra) # 8000363a <end_op>
    return -1;
    80004d76:	597d                	li	s2,-1
    80004d78:	bf5d                	j	80004d2e <sys_open+0x1c8>
    f->type = FD_DEVICE;
    80004d7a:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004d7e:	04649783          	lh	a5,70(s1)
    80004d82:	02f99223          	sh	a5,36(s3)
    80004d86:	bdfd                	j	80004c84 <sys_open+0x11e>
    itrunc(ip);
    80004d88:	8526                	mv	a0,s1
    80004d8a:	ffffe097          	auipc	ra,0xffffe
    80004d8e:	eb8080e7          	jalr	-328(ra) # 80002c42 <itrunc>
    80004d92:	b705                	j	80004cb2 <sys_open+0x14c>
      fileclose(f);
    80004d94:	854e                	mv	a0,s3
    80004d96:	fffff097          	auipc	ra,0xfffff
    80004d9a:	cee080e7          	jalr	-786(ra) # 80003a84 <fileclose>
    iunlockput(ip);
    80004d9e:	8526                	mv	a0,s1
    80004da0:	ffffe097          	auipc	ra,0xffffe
    80004da4:	0a0080e7          	jalr	160(ra) # 80002e40 <iunlockput>
    end_op();
    80004da8:	fffff097          	auipc	ra,0xfffff
    80004dac:	892080e7          	jalr	-1902(ra) # 8000363a <end_op>
    return -1;
    80004db0:	597d                	li	s2,-1
    80004db2:	bfb5                	j	80004d2e <sys_open+0x1c8>

0000000080004db4 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004db4:	7175                	addi	sp,sp,-144
    80004db6:	e506                	sd	ra,136(sp)
    80004db8:	e122                	sd	s0,128(sp)
    80004dba:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004dbc:	fffff097          	auipc	ra,0xfffff
    80004dc0:	800080e7          	jalr	-2048(ra) # 800035bc <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0)
    80004dc4:	08000613          	li	a2,128
    80004dc8:	f7040593          	addi	a1,s0,-144
    80004dcc:	4501                	li	a0,0
    80004dce:	ffffd097          	auipc	ra,0xffffd
    80004dd2:	170080e7          	jalr	368(ra) # 80001f3e <argstr>
    80004dd6:	02054963          	bltz	a0,80004e08 <sys_mkdir+0x54>
    80004dda:	4681                	li	a3,0
    80004ddc:	4601                	li	a2,0
    80004dde:	4585                	li	a1,1
    80004de0:	f7040513          	addi	a0,s0,-144
    80004de4:	fffff097          	auipc	ra,0xfffff
    80004de8:	746080e7          	jalr	1862(ra) # 8000452a <create>
    80004dec:	cd11                	beqz	a0,80004e08 <sys_mkdir+0x54>
  {
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004dee:	ffffe097          	auipc	ra,0xffffe
    80004df2:	052080e7          	jalr	82(ra) # 80002e40 <iunlockput>
  end_op();
    80004df6:	fffff097          	auipc	ra,0xfffff
    80004dfa:	844080e7          	jalr	-1980(ra) # 8000363a <end_op>
  return 0;
    80004dfe:	4501                	li	a0,0
}
    80004e00:	60aa                	ld	ra,136(sp)
    80004e02:	640a                	ld	s0,128(sp)
    80004e04:	6149                	addi	sp,sp,144
    80004e06:	8082                	ret
    end_op();
    80004e08:	fffff097          	auipc	ra,0xfffff
    80004e0c:	832080e7          	jalr	-1998(ra) # 8000363a <end_op>
    return -1;
    80004e10:	557d                	li	a0,-1
    80004e12:	b7fd                	j	80004e00 <sys_mkdir+0x4c>

0000000080004e14 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004e14:	7135                	addi	sp,sp,-160
    80004e16:	ed06                	sd	ra,152(sp)
    80004e18:	e922                	sd	s0,144(sp)
    80004e1a:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004e1c:	ffffe097          	auipc	ra,0xffffe
    80004e20:	7a0080e7          	jalr	1952(ra) # 800035bc <begin_op>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    80004e24:	08000613          	li	a2,128
    80004e28:	f7040593          	addi	a1,s0,-144
    80004e2c:	4501                	li	a0,0
    80004e2e:	ffffd097          	auipc	ra,0xffffd
    80004e32:	110080e7          	jalr	272(ra) # 80001f3e <argstr>
    80004e36:	04054a63          	bltz	a0,80004e8a <sys_mknod+0x76>
      argint(1, &major) < 0 ||
    80004e3a:	f6c40593          	addi	a1,s0,-148
    80004e3e:	4505                	li	a0,1
    80004e40:	ffffd097          	auipc	ra,0xffffd
    80004e44:	0ba080e7          	jalr	186(ra) # 80001efa <argint>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    80004e48:	04054163          	bltz	a0,80004e8a <sys_mknod+0x76>
      argint(2, &minor) < 0 ||
    80004e4c:	f6840593          	addi	a1,s0,-152
    80004e50:	4509                	li	a0,2
    80004e52:	ffffd097          	auipc	ra,0xffffd
    80004e56:	0a8080e7          	jalr	168(ra) # 80001efa <argint>
      argint(1, &major) < 0 ||
    80004e5a:	02054863          	bltz	a0,80004e8a <sys_mknod+0x76>
      (ip = create(path, T_DEVICE, major, minor)) == 0)
    80004e5e:	f6841683          	lh	a3,-152(s0)
    80004e62:	f6c41603          	lh	a2,-148(s0)
    80004e66:	458d                	li	a1,3
    80004e68:	f7040513          	addi	a0,s0,-144
    80004e6c:	fffff097          	auipc	ra,0xfffff
    80004e70:	6be080e7          	jalr	1726(ra) # 8000452a <create>
      argint(2, &minor) < 0 ||
    80004e74:	c919                	beqz	a0,80004e8a <sys_mknod+0x76>
  {
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e76:	ffffe097          	auipc	ra,0xffffe
    80004e7a:	fca080e7          	jalr	-54(ra) # 80002e40 <iunlockput>
  end_op();
    80004e7e:	ffffe097          	auipc	ra,0xffffe
    80004e82:	7bc080e7          	jalr	1980(ra) # 8000363a <end_op>
  return 0;
    80004e86:	4501                	li	a0,0
    80004e88:	a031                	j	80004e94 <sys_mknod+0x80>
    end_op();
    80004e8a:	ffffe097          	auipc	ra,0xffffe
    80004e8e:	7b0080e7          	jalr	1968(ra) # 8000363a <end_op>
    return -1;
    80004e92:	557d                	li	a0,-1
}
    80004e94:	60ea                	ld	ra,152(sp)
    80004e96:	644a                	ld	s0,144(sp)
    80004e98:	610d                	addi	sp,sp,160
    80004e9a:	8082                	ret

0000000080004e9c <sys_chdir>:

uint64
sys_chdir(void)
{
    80004e9c:	7135                	addi	sp,sp,-160
    80004e9e:	ed06                	sd	ra,152(sp)
    80004ea0:	e922                	sd	s0,144(sp)
    80004ea2:	e526                	sd	s1,136(sp)
    80004ea4:	e14a                	sd	s2,128(sp)
    80004ea6:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004ea8:	ffffc097          	auipc	ra,0xffffc
    80004eac:	f9c080e7          	jalr	-100(ra) # 80000e44 <myproc>
    80004eb0:	892a                	mv	s2,a0

  begin_op();
    80004eb2:	ffffe097          	auipc	ra,0xffffe
    80004eb6:	70a080e7          	jalr	1802(ra) # 800035bc <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0)
    80004eba:	08000613          	li	a2,128
    80004ebe:	f6040593          	addi	a1,s0,-160
    80004ec2:	4501                	li	a0,0
    80004ec4:	ffffd097          	auipc	ra,0xffffd
    80004ec8:	07a080e7          	jalr	122(ra) # 80001f3e <argstr>
    80004ecc:	04054b63          	bltz	a0,80004f22 <sys_chdir+0x86>
    80004ed0:	f6040513          	addi	a0,s0,-160
    80004ed4:	ffffe097          	auipc	ra,0xffffe
    80004ed8:	4c8080e7          	jalr	1224(ra) # 8000339c <namei>
    80004edc:	84aa                	mv	s1,a0
    80004ede:	c131                	beqz	a0,80004f22 <sys_chdir+0x86>
  {
    end_op();
    return -1;
  }
  ilock(ip);
    80004ee0:	ffffe097          	auipc	ra,0xffffe
    80004ee4:	c54080e7          	jalr	-940(ra) # 80002b34 <ilock>
  if (ip->type != T_DIR)
    80004ee8:	04449703          	lh	a4,68(s1)
    80004eec:	4785                	li	a5,1
    80004eee:	04f71063          	bne	a4,a5,80004f2e <sys_chdir+0x92>
  {
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004ef2:	8526                	mv	a0,s1
    80004ef4:	ffffe097          	auipc	ra,0xffffe
    80004ef8:	d02080e7          	jalr	-766(ra) # 80002bf6 <iunlock>
  iput(p->cwd);
    80004efc:	15093503          	ld	a0,336(s2)
    80004f00:	ffffe097          	auipc	ra,0xffffe
    80004f04:	e98080e7          	jalr	-360(ra) # 80002d98 <iput>
  end_op();
    80004f08:	ffffe097          	auipc	ra,0xffffe
    80004f0c:	732080e7          	jalr	1842(ra) # 8000363a <end_op>
  p->cwd = ip;
    80004f10:	14993823          	sd	s1,336(s2)
  return 0;
    80004f14:	4501                	li	a0,0
}
    80004f16:	60ea                	ld	ra,152(sp)
    80004f18:	644a                	ld	s0,144(sp)
    80004f1a:	64aa                	ld	s1,136(sp)
    80004f1c:	690a                	ld	s2,128(sp)
    80004f1e:	610d                	addi	sp,sp,160
    80004f20:	8082                	ret
    end_op();
    80004f22:	ffffe097          	auipc	ra,0xffffe
    80004f26:	718080e7          	jalr	1816(ra) # 8000363a <end_op>
    return -1;
    80004f2a:	557d                	li	a0,-1
    80004f2c:	b7ed                	j	80004f16 <sys_chdir+0x7a>
    iunlockput(ip);
    80004f2e:	8526                	mv	a0,s1
    80004f30:	ffffe097          	auipc	ra,0xffffe
    80004f34:	f10080e7          	jalr	-240(ra) # 80002e40 <iunlockput>
    end_op();
    80004f38:	ffffe097          	auipc	ra,0xffffe
    80004f3c:	702080e7          	jalr	1794(ra) # 8000363a <end_op>
    return -1;
    80004f40:	557d                	li	a0,-1
    80004f42:	bfd1                	j	80004f16 <sys_chdir+0x7a>

0000000080004f44 <sys_exec>:

uint64
sys_exec(void)
{
    80004f44:	7145                	addi	sp,sp,-464
    80004f46:	e786                	sd	ra,456(sp)
    80004f48:	e3a2                	sd	s0,448(sp)
    80004f4a:	ff26                	sd	s1,440(sp)
    80004f4c:	fb4a                	sd	s2,432(sp)
    80004f4e:	f74e                	sd	s3,424(sp)
    80004f50:	f352                	sd	s4,416(sp)
    80004f52:	ef56                	sd	s5,408(sp)
    80004f54:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if (argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0)
    80004f56:	08000613          	li	a2,128
    80004f5a:	f4040593          	addi	a1,s0,-192
    80004f5e:	4501                	li	a0,0
    80004f60:	ffffd097          	auipc	ra,0xffffd
    80004f64:	fde080e7          	jalr	-34(ra) # 80001f3e <argstr>
  {
    return -1;
    80004f68:	597d                	li	s2,-1
  if (argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0)
    80004f6a:	0c054b63          	bltz	a0,80005040 <sys_exec+0xfc>
    80004f6e:	e3840593          	addi	a1,s0,-456
    80004f72:	4505                	li	a0,1
    80004f74:	ffffd097          	auipc	ra,0xffffd
    80004f78:	fa8080e7          	jalr	-88(ra) # 80001f1c <argaddr>
    80004f7c:	0c054263          	bltz	a0,80005040 <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    80004f80:	10000613          	li	a2,256
    80004f84:	4581                	li	a1,0
    80004f86:	e4040513          	addi	a0,s0,-448
    80004f8a:	ffffb097          	auipc	ra,0xffffb
    80004f8e:	1f0080e7          	jalr	496(ra) # 8000017a <memset>
  for (i = 0;; i++)
  {
    if (i >= NELEM(argv))
    80004f92:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004f96:	89a6                	mv	s3,s1
    80004f98:	4901                	li	s2,0
    if (i >= NELEM(argv))
    80004f9a:	02000a13          	li	s4,32
    80004f9e:	00090a9b          	sext.w	s5,s2
    {
      goto bad;
    }
    if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0)
    80004fa2:	00391513          	slli	a0,s2,0x3
    80004fa6:	e3040593          	addi	a1,s0,-464
    80004faa:	e3843783          	ld	a5,-456(s0)
    80004fae:	953e                	add	a0,a0,a5
    80004fb0:	ffffd097          	auipc	ra,0xffffd
    80004fb4:	eb0080e7          	jalr	-336(ra) # 80001e60 <fetchaddr>
    80004fb8:	02054a63          	bltz	a0,80004fec <sys_exec+0xa8>
    {
      goto bad;
    }
    if (uarg == 0)
    80004fbc:	e3043783          	ld	a5,-464(s0)
    80004fc0:	c3b9                	beqz	a5,80005006 <sys_exec+0xc2>
    {
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004fc2:	ffffb097          	auipc	ra,0xffffb
    80004fc6:	158080e7          	jalr	344(ra) # 8000011a <kalloc>
    80004fca:	85aa                	mv	a1,a0
    80004fcc:	00a9b023          	sd	a0,0(s3)
    if (argv[i] == 0)
    80004fd0:	cd11                	beqz	a0,80004fec <sys_exec+0xa8>
      goto bad;
    if (fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004fd2:	6605                	lui	a2,0x1
    80004fd4:	e3043503          	ld	a0,-464(s0)
    80004fd8:	ffffd097          	auipc	ra,0xffffd
    80004fdc:	eda080e7          	jalr	-294(ra) # 80001eb2 <fetchstr>
    80004fe0:	00054663          	bltz	a0,80004fec <sys_exec+0xa8>
    if (i >= NELEM(argv))
    80004fe4:	0905                	addi	s2,s2,1
    80004fe6:	09a1                	addi	s3,s3,8
    80004fe8:	fb491be3          	bne	s2,s4,80004f9e <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

bad:
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fec:	f4040913          	addi	s2,s0,-192
    80004ff0:	6088                	ld	a0,0(s1)
    80004ff2:	c531                	beqz	a0,8000503e <sys_exec+0xfa>
    kfree(argv[i]);
    80004ff4:	ffffb097          	auipc	ra,0xffffb
    80004ff8:	028080e7          	jalr	40(ra) # 8000001c <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ffc:	04a1                	addi	s1,s1,8
    80004ffe:	ff2499e3          	bne	s1,s2,80004ff0 <sys_exec+0xac>
  return -1;
    80005002:	597d                	li	s2,-1
    80005004:	a835                	j	80005040 <sys_exec+0xfc>
      argv[i] = 0;
    80005006:	0a8e                	slli	s5,s5,0x3
    80005008:	fc0a8793          	addi	a5,s5,-64 # ffffffffffffefc0 <end+0xffffffff7ffddd80>
    8000500c:	00878ab3          	add	s5,a5,s0
    80005010:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80005014:	e4040593          	addi	a1,s0,-448
    80005018:	f4040513          	addi	a0,s0,-192
    8000501c:	fffff097          	auipc	ra,0xfffff
    80005020:	0bc080e7          	jalr	188(ra) # 800040d8 <exec>
    80005024:	892a                	mv	s2,a0
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005026:	f4040993          	addi	s3,s0,-192
    8000502a:	6088                	ld	a0,0(s1)
    8000502c:	c911                	beqz	a0,80005040 <sys_exec+0xfc>
    kfree(argv[i]);
    8000502e:	ffffb097          	auipc	ra,0xffffb
    80005032:	fee080e7          	jalr	-18(ra) # 8000001c <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005036:	04a1                	addi	s1,s1,8
    80005038:	ff3499e3          	bne	s1,s3,8000502a <sys_exec+0xe6>
    8000503c:	a011                	j	80005040 <sys_exec+0xfc>
  return -1;
    8000503e:	597d                	li	s2,-1
}
    80005040:	854a                	mv	a0,s2
    80005042:	60be                	ld	ra,456(sp)
    80005044:	641e                	ld	s0,448(sp)
    80005046:	74fa                	ld	s1,440(sp)
    80005048:	795a                	ld	s2,432(sp)
    8000504a:	79ba                	ld	s3,424(sp)
    8000504c:	7a1a                	ld	s4,416(sp)
    8000504e:	6afa                	ld	s5,408(sp)
    80005050:	6179                	addi	sp,sp,464
    80005052:	8082                	ret

0000000080005054 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005054:	7139                	addi	sp,sp,-64
    80005056:	fc06                	sd	ra,56(sp)
    80005058:	f822                	sd	s0,48(sp)
    8000505a:	f426                	sd	s1,40(sp)
    8000505c:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000505e:	ffffc097          	auipc	ra,0xffffc
    80005062:	de6080e7          	jalr	-538(ra) # 80000e44 <myproc>
    80005066:	84aa                	mv	s1,a0

  if (argaddr(0, &fdarray) < 0)
    80005068:	fd840593          	addi	a1,s0,-40
    8000506c:	4501                	li	a0,0
    8000506e:	ffffd097          	auipc	ra,0xffffd
    80005072:	eae080e7          	jalr	-338(ra) # 80001f1c <argaddr>
    return -1;
    80005076:	57fd                	li	a5,-1
  if (argaddr(0, &fdarray) < 0)
    80005078:	0e054063          	bltz	a0,80005158 <sys_pipe+0x104>
  if (pipealloc(&rf, &wf) < 0)
    8000507c:	fc840593          	addi	a1,s0,-56
    80005080:	fd040513          	addi	a0,s0,-48
    80005084:	fffff097          	auipc	ra,0xfffff
    80005088:	d30080e7          	jalr	-720(ra) # 80003db4 <pipealloc>
    return -1;
    8000508c:	57fd                	li	a5,-1
  if (pipealloc(&rf, &wf) < 0)
    8000508e:	0c054563          	bltz	a0,80005158 <sys_pipe+0x104>
  fd0 = -1;
    80005092:	fcf42223          	sw	a5,-60(s0)
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0)
    80005096:	fd043503          	ld	a0,-48(s0)
    8000509a:	fffff097          	auipc	ra,0xfffff
    8000509e:	44e080e7          	jalr	1102(ra) # 800044e8 <fdalloc>
    800050a2:	fca42223          	sw	a0,-60(s0)
    800050a6:	08054c63          	bltz	a0,8000513e <sys_pipe+0xea>
    800050aa:	fc843503          	ld	a0,-56(s0)
    800050ae:	fffff097          	auipc	ra,0xfffff
    800050b2:	43a080e7          	jalr	1082(ra) # 800044e8 <fdalloc>
    800050b6:	fca42023          	sw	a0,-64(s0)
    800050ba:	06054963          	bltz	a0,8000512c <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    800050be:	4691                	li	a3,4
    800050c0:	fc440613          	addi	a2,s0,-60
    800050c4:	fd843583          	ld	a1,-40(s0)
    800050c8:	68a8                	ld	a0,80(s1)
    800050ca:	ffffc097          	auipc	ra,0xffffc
    800050ce:	a3e080e7          	jalr	-1474(ra) # 80000b08 <copyout>
    800050d2:	02054063          	bltz	a0,800050f2 <sys_pipe+0x9e>
      copyout(p->pagetable, fdarray + sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0)
    800050d6:	4691                	li	a3,4
    800050d8:	fc040613          	addi	a2,s0,-64
    800050dc:	fd843583          	ld	a1,-40(s0)
    800050e0:	0591                	addi	a1,a1,4
    800050e2:	68a8                	ld	a0,80(s1)
    800050e4:	ffffc097          	auipc	ra,0xffffc
    800050e8:	a24080e7          	jalr	-1500(ra) # 80000b08 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800050ec:	4781                	li	a5,0
  if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    800050ee:	06055563          	bgez	a0,80005158 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    800050f2:	fc442783          	lw	a5,-60(s0)
    800050f6:	07e9                	addi	a5,a5,26
    800050f8:	078e                	slli	a5,a5,0x3
    800050fa:	97a6                	add	a5,a5,s1
    800050fc:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005100:	fc042783          	lw	a5,-64(s0)
    80005104:	07e9                	addi	a5,a5,26
    80005106:	078e                	slli	a5,a5,0x3
    80005108:	00f48533          	add	a0,s1,a5
    8000510c:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005110:	fd043503          	ld	a0,-48(s0)
    80005114:	fffff097          	auipc	ra,0xfffff
    80005118:	970080e7          	jalr	-1680(ra) # 80003a84 <fileclose>
    fileclose(wf);
    8000511c:	fc843503          	ld	a0,-56(s0)
    80005120:	fffff097          	auipc	ra,0xfffff
    80005124:	964080e7          	jalr	-1692(ra) # 80003a84 <fileclose>
    return -1;
    80005128:	57fd                	li	a5,-1
    8000512a:	a03d                	j	80005158 <sys_pipe+0x104>
    if (fd0 >= 0)
    8000512c:	fc442783          	lw	a5,-60(s0)
    80005130:	0007c763          	bltz	a5,8000513e <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005134:	07e9                	addi	a5,a5,26
    80005136:	078e                	slli	a5,a5,0x3
    80005138:	97a6                	add	a5,a5,s1
    8000513a:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000513e:	fd043503          	ld	a0,-48(s0)
    80005142:	fffff097          	auipc	ra,0xfffff
    80005146:	942080e7          	jalr	-1726(ra) # 80003a84 <fileclose>
    fileclose(wf);
    8000514a:	fc843503          	ld	a0,-56(s0)
    8000514e:	fffff097          	auipc	ra,0xfffff
    80005152:	936080e7          	jalr	-1738(ra) # 80003a84 <fileclose>
    return -1;
    80005156:	57fd                	li	a5,-1
}
    80005158:	853e                	mv	a0,a5
    8000515a:	70e2                	ld	ra,56(sp)
    8000515c:	7442                	ld	s0,48(sp)
    8000515e:	74a2                	ld	s1,40(sp)
    80005160:	6121                	addi	sp,sp,64
    80005162:	8082                	ret

0000000080005164 <sys_symlink>:

uint64
sys_symlink(void)
{
    80005164:	712d                	addi	sp,sp,-288
    80005166:	ee06                	sd	ra,280(sp)
    80005168:	ea22                	sd	s0,272(sp)
    8000516a:	e626                	sd	s1,264(sp)
    8000516c:	1200                	addi	s0,sp,288
  char path[MAXPATH], target[MAXPATH];
  struct inode *ip;
  // 读取参数
  if (argstr(0, target, MAXPATH) < 0)
    8000516e:	08000613          	li	a2,128
    80005172:	ee040593          	addi	a1,s0,-288
    80005176:	4501                	li	a0,0
    80005178:	ffffd097          	auipc	ra,0xffffd
    8000517c:	dc6080e7          	jalr	-570(ra) # 80001f3e <argstr>
    return -1;
    80005180:	57fd                	li	a5,-1
  if (argstr(0, target, MAXPATH) < 0)
    80005182:	06054563          	bltz	a0,800051ec <sys_symlink+0x88>
  if (argstr(1, path, MAXPATH) < 0)
    80005186:	08000613          	li	a2,128
    8000518a:	f6040593          	addi	a1,s0,-160
    8000518e:	4505                	li	a0,1
    80005190:	ffffd097          	auipc	ra,0xffffd
    80005194:	dae080e7          	jalr	-594(ra) # 80001f3e <argstr>
    return -1;
    80005198:	57fd                	li	a5,-1
  if (argstr(1, path, MAXPATH) < 0)
    8000519a:	04054963          	bltz	a0,800051ec <sys_symlink+0x88>
  // 开启事务
  begin_op();
    8000519e:	ffffe097          	auipc	ra,0xffffe
    800051a2:	41e080e7          	jalr	1054(ra) # 800035bc <begin_op>
  // 为这个符号链接新建一个 inode
  if ((ip = create(path, T_SYMLINK, 0, 0)) == 0)
    800051a6:	4681                	li	a3,0
    800051a8:	4601                	li	a2,0
    800051aa:	4591                	li	a1,4
    800051ac:	f6040513          	addi	a0,s0,-160
    800051b0:	fffff097          	auipc	ra,0xfffff
    800051b4:	37a080e7          	jalr	890(ra) # 8000452a <create>
    800051b8:	84aa                	mv	s1,a0
    800051ba:	cd1d                	beqz	a0,800051f8 <sys_symlink+0x94>
  {
    end_op();
    return -1;
  }
  // 在符号链接的 data 中写入被链接的文件
  if (writei(ip, 0, (uint64)target, 0, MAXPATH) < MAXPATH)
    800051bc:	08000713          	li	a4,128
    800051c0:	4681                	li	a3,0
    800051c2:	ee040613          	addi	a2,s0,-288
    800051c6:	4581                	li	a1,0
    800051c8:	ffffe097          	auipc	ra,0xffffe
    800051cc:	dc2080e7          	jalr	-574(ra) # 80002f8a <writei>
    800051d0:	07f00793          	li	a5,127
    800051d4:	02a7d863          	bge	a5,a0,80005204 <sys_symlink+0xa0>
    iunlockput(ip);
    end_op();
    return -1;
  }
  // 提交事务
  iunlockput(ip);
    800051d8:	8526                	mv	a0,s1
    800051da:	ffffe097          	auipc	ra,0xffffe
    800051de:	c66080e7          	jalr	-922(ra) # 80002e40 <iunlockput>
  end_op();
    800051e2:	ffffe097          	auipc	ra,0xffffe
    800051e6:	458080e7          	jalr	1112(ra) # 8000363a <end_op>
  return 0;
    800051ea:	4781                	li	a5,0
    800051ec:	853e                	mv	a0,a5
    800051ee:	60f2                	ld	ra,280(sp)
    800051f0:	6452                	ld	s0,272(sp)
    800051f2:	64b2                	ld	s1,264(sp)
    800051f4:	6115                	addi	sp,sp,288
    800051f6:	8082                	ret
    end_op();
    800051f8:	ffffe097          	auipc	ra,0xffffe
    800051fc:	442080e7          	jalr	1090(ra) # 8000363a <end_op>
    return -1;
    80005200:	57fd                	li	a5,-1
    80005202:	b7ed                	j	800051ec <sys_symlink+0x88>
    iunlockput(ip);
    80005204:	8526                	mv	a0,s1
    80005206:	ffffe097          	auipc	ra,0xffffe
    8000520a:	c3a080e7          	jalr	-966(ra) # 80002e40 <iunlockput>
    end_op();
    8000520e:	ffffe097          	auipc	ra,0xffffe
    80005212:	42c080e7          	jalr	1068(ra) # 8000363a <end_op>
    return -1;
    80005216:	57fd                	li	a5,-1
    80005218:	bfd1                	j	800051ec <sys_symlink+0x88>
    8000521a:	0000                	unimp
    8000521c:	0000                	unimp
	...

0000000080005220 <kernelvec>:
    80005220:	7111                	addi	sp,sp,-256
    80005222:	e006                	sd	ra,0(sp)
    80005224:	e40a                	sd	sp,8(sp)
    80005226:	e80e                	sd	gp,16(sp)
    80005228:	ec12                	sd	tp,24(sp)
    8000522a:	f016                	sd	t0,32(sp)
    8000522c:	f41a                	sd	t1,40(sp)
    8000522e:	f81e                	sd	t2,48(sp)
    80005230:	fc22                	sd	s0,56(sp)
    80005232:	e0a6                	sd	s1,64(sp)
    80005234:	e4aa                	sd	a0,72(sp)
    80005236:	e8ae                	sd	a1,80(sp)
    80005238:	ecb2                	sd	a2,88(sp)
    8000523a:	f0b6                	sd	a3,96(sp)
    8000523c:	f4ba                	sd	a4,104(sp)
    8000523e:	f8be                	sd	a5,112(sp)
    80005240:	fcc2                	sd	a6,120(sp)
    80005242:	e146                	sd	a7,128(sp)
    80005244:	e54a                	sd	s2,136(sp)
    80005246:	e94e                	sd	s3,144(sp)
    80005248:	ed52                	sd	s4,152(sp)
    8000524a:	f156                	sd	s5,160(sp)
    8000524c:	f55a                	sd	s6,168(sp)
    8000524e:	f95e                	sd	s7,176(sp)
    80005250:	fd62                	sd	s8,184(sp)
    80005252:	e1e6                	sd	s9,192(sp)
    80005254:	e5ea                	sd	s10,200(sp)
    80005256:	e9ee                	sd	s11,208(sp)
    80005258:	edf2                	sd	t3,216(sp)
    8000525a:	f1f6                	sd	t4,224(sp)
    8000525c:	f5fa                	sd	t5,232(sp)
    8000525e:	f9fe                	sd	t6,240(sp)
    80005260:	acdfc0ef          	jal	ra,80001d2c <kerneltrap>
    80005264:	6082                	ld	ra,0(sp)
    80005266:	6122                	ld	sp,8(sp)
    80005268:	61c2                	ld	gp,16(sp)
    8000526a:	7282                	ld	t0,32(sp)
    8000526c:	7322                	ld	t1,40(sp)
    8000526e:	73c2                	ld	t2,48(sp)
    80005270:	7462                	ld	s0,56(sp)
    80005272:	6486                	ld	s1,64(sp)
    80005274:	6526                	ld	a0,72(sp)
    80005276:	65c6                	ld	a1,80(sp)
    80005278:	6666                	ld	a2,88(sp)
    8000527a:	7686                	ld	a3,96(sp)
    8000527c:	7726                	ld	a4,104(sp)
    8000527e:	77c6                	ld	a5,112(sp)
    80005280:	7866                	ld	a6,120(sp)
    80005282:	688a                	ld	a7,128(sp)
    80005284:	692a                	ld	s2,136(sp)
    80005286:	69ca                	ld	s3,144(sp)
    80005288:	6a6a                	ld	s4,152(sp)
    8000528a:	7a8a                	ld	s5,160(sp)
    8000528c:	7b2a                	ld	s6,168(sp)
    8000528e:	7bca                	ld	s7,176(sp)
    80005290:	7c6a                	ld	s8,184(sp)
    80005292:	6c8e                	ld	s9,192(sp)
    80005294:	6d2e                	ld	s10,200(sp)
    80005296:	6dce                	ld	s11,208(sp)
    80005298:	6e6e                	ld	t3,216(sp)
    8000529a:	7e8e                	ld	t4,224(sp)
    8000529c:	7f2e                	ld	t5,232(sp)
    8000529e:	7fce                	ld	t6,240(sp)
    800052a0:	6111                	addi	sp,sp,256
    800052a2:	10200073          	sret
    800052a6:	00000013          	nop
    800052aa:	00000013          	nop
    800052ae:	0001                	nop

00000000800052b0 <timervec>:
    800052b0:	34051573          	csrrw	a0,mscratch,a0
    800052b4:	e10c                	sd	a1,0(a0)
    800052b6:	e510                	sd	a2,8(a0)
    800052b8:	e914                	sd	a3,16(a0)
    800052ba:	6d0c                	ld	a1,24(a0)
    800052bc:	7110                	ld	a2,32(a0)
    800052be:	6194                	ld	a3,0(a1)
    800052c0:	96b2                	add	a3,a3,a2
    800052c2:	e194                	sd	a3,0(a1)
    800052c4:	4589                	li	a1,2
    800052c6:	14459073          	csrw	sip,a1
    800052ca:	6914                	ld	a3,16(a0)
    800052cc:	6510                	ld	a2,8(a0)
    800052ce:	610c                	ld	a1,0(a0)
    800052d0:	34051573          	csrrw	a0,mscratch,a0
    800052d4:	30200073          	mret
	...

00000000800052da <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800052da:	1141                	addi	sp,sp,-16
    800052dc:	e422                	sd	s0,8(sp)
    800052de:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800052e0:	0c0007b7          	lui	a5,0xc000
    800052e4:	4705                	li	a4,1
    800052e6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800052e8:	c3d8                	sw	a4,4(a5)
}
    800052ea:	6422                	ld	s0,8(sp)
    800052ec:	0141                	addi	sp,sp,16
    800052ee:	8082                	ret

00000000800052f0 <plicinithart>:

void
plicinithart(void)
{
    800052f0:	1141                	addi	sp,sp,-16
    800052f2:	e406                	sd	ra,8(sp)
    800052f4:	e022                	sd	s0,0(sp)
    800052f6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800052f8:	ffffc097          	auipc	ra,0xffffc
    800052fc:	b20080e7          	jalr	-1248(ra) # 80000e18 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005300:	0085171b          	slliw	a4,a0,0x8
    80005304:	0c0027b7          	lui	a5,0xc002
    80005308:	97ba                	add	a5,a5,a4
    8000530a:	40200713          	li	a4,1026
    8000530e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005312:	00d5151b          	slliw	a0,a0,0xd
    80005316:	0c2017b7          	lui	a5,0xc201
    8000531a:	97aa                	add	a5,a5,a0
    8000531c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005320:	60a2                	ld	ra,8(sp)
    80005322:	6402                	ld	s0,0(sp)
    80005324:	0141                	addi	sp,sp,16
    80005326:	8082                	ret

0000000080005328 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005328:	1141                	addi	sp,sp,-16
    8000532a:	e406                	sd	ra,8(sp)
    8000532c:	e022                	sd	s0,0(sp)
    8000532e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005330:	ffffc097          	auipc	ra,0xffffc
    80005334:	ae8080e7          	jalr	-1304(ra) # 80000e18 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005338:	00d5151b          	slliw	a0,a0,0xd
    8000533c:	0c2017b7          	lui	a5,0xc201
    80005340:	97aa                	add	a5,a5,a0
  return irq;
}
    80005342:	43c8                	lw	a0,4(a5)
    80005344:	60a2                	ld	ra,8(sp)
    80005346:	6402                	ld	s0,0(sp)
    80005348:	0141                	addi	sp,sp,16
    8000534a:	8082                	ret

000000008000534c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000534c:	1101                	addi	sp,sp,-32
    8000534e:	ec06                	sd	ra,24(sp)
    80005350:	e822                	sd	s0,16(sp)
    80005352:	e426                	sd	s1,8(sp)
    80005354:	1000                	addi	s0,sp,32
    80005356:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005358:	ffffc097          	auipc	ra,0xffffc
    8000535c:	ac0080e7          	jalr	-1344(ra) # 80000e18 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005360:	00d5151b          	slliw	a0,a0,0xd
    80005364:	0c2017b7          	lui	a5,0xc201
    80005368:	97aa                	add	a5,a5,a0
    8000536a:	c3c4                	sw	s1,4(a5)
}
    8000536c:	60e2                	ld	ra,24(sp)
    8000536e:	6442                	ld	s0,16(sp)
    80005370:	64a2                	ld	s1,8(sp)
    80005372:	6105                	addi	sp,sp,32
    80005374:	8082                	ret

0000000080005376 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005376:	1141                	addi	sp,sp,-16
    80005378:	e406                	sd	ra,8(sp)
    8000537a:	e022                	sd	s0,0(sp)
    8000537c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000537e:	479d                	li	a5,7
    80005380:	06a7c863          	blt	a5,a0,800053f0 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    80005384:	00011717          	auipc	a4,0x11
    80005388:	c7c70713          	addi	a4,a4,-900 # 80016000 <disk>
    8000538c:	972a                	add	a4,a4,a0
    8000538e:	6789                	lui	a5,0x2
    80005390:	97ba                	add	a5,a5,a4
    80005392:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005396:	e7ad                	bnez	a5,80005400 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005398:	00451793          	slli	a5,a0,0x4
    8000539c:	00013717          	auipc	a4,0x13
    800053a0:	c6470713          	addi	a4,a4,-924 # 80018000 <disk+0x2000>
    800053a4:	6314                	ld	a3,0(a4)
    800053a6:	96be                	add	a3,a3,a5
    800053a8:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800053ac:	6314                	ld	a3,0(a4)
    800053ae:	96be                	add	a3,a3,a5
    800053b0:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    800053b4:	6314                	ld	a3,0(a4)
    800053b6:	96be                	add	a3,a3,a5
    800053b8:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    800053bc:	6318                	ld	a4,0(a4)
    800053be:	97ba                	add	a5,a5,a4
    800053c0:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    800053c4:	00011717          	auipc	a4,0x11
    800053c8:	c3c70713          	addi	a4,a4,-964 # 80016000 <disk>
    800053cc:	972a                	add	a4,a4,a0
    800053ce:	6789                	lui	a5,0x2
    800053d0:	97ba                	add	a5,a5,a4
    800053d2:	4705                	li	a4,1
    800053d4:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    800053d8:	00013517          	auipc	a0,0x13
    800053dc:	c4050513          	addi	a0,a0,-960 # 80018018 <disk+0x2018>
    800053e0:	ffffc097          	auipc	ra,0xffffc
    800053e4:	2b4080e7          	jalr	692(ra) # 80001694 <wakeup>
}
    800053e8:	60a2                	ld	ra,8(sp)
    800053ea:	6402                	ld	s0,0(sp)
    800053ec:	0141                	addi	sp,sp,16
    800053ee:	8082                	ret
    panic("free_desc 1");
    800053f0:	00003517          	auipc	a0,0x3
    800053f4:	30050513          	addi	a0,a0,768 # 800086f0 <syscalls+0x328>
    800053f8:	00001097          	auipc	ra,0x1
    800053fc:	9c8080e7          	jalr	-1592(ra) # 80005dc0 <panic>
    panic("free_desc 2");
    80005400:	00003517          	auipc	a0,0x3
    80005404:	30050513          	addi	a0,a0,768 # 80008700 <syscalls+0x338>
    80005408:	00001097          	auipc	ra,0x1
    8000540c:	9b8080e7          	jalr	-1608(ra) # 80005dc0 <panic>

0000000080005410 <virtio_disk_init>:
{
    80005410:	1101                	addi	sp,sp,-32
    80005412:	ec06                	sd	ra,24(sp)
    80005414:	e822                	sd	s0,16(sp)
    80005416:	e426                	sd	s1,8(sp)
    80005418:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000541a:	00003597          	auipc	a1,0x3
    8000541e:	2f658593          	addi	a1,a1,758 # 80008710 <syscalls+0x348>
    80005422:	00013517          	auipc	a0,0x13
    80005426:	d0650513          	addi	a0,a0,-762 # 80018128 <disk+0x2128>
    8000542a:	00001097          	auipc	ra,0x1
    8000542e:	e3e080e7          	jalr	-450(ra) # 80006268 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005432:	100017b7          	lui	a5,0x10001
    80005436:	4398                	lw	a4,0(a5)
    80005438:	2701                	sext.w	a4,a4
    8000543a:	747277b7          	lui	a5,0x74727
    8000543e:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005442:	0ef71063          	bne	a4,a5,80005522 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005446:	100017b7          	lui	a5,0x10001
    8000544a:	43dc                	lw	a5,4(a5)
    8000544c:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000544e:	4705                	li	a4,1
    80005450:	0ce79963          	bne	a5,a4,80005522 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005454:	100017b7          	lui	a5,0x10001
    80005458:	479c                	lw	a5,8(a5)
    8000545a:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000545c:	4709                	li	a4,2
    8000545e:	0ce79263          	bne	a5,a4,80005522 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005462:	100017b7          	lui	a5,0x10001
    80005466:	47d8                	lw	a4,12(a5)
    80005468:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000546a:	554d47b7          	lui	a5,0x554d4
    8000546e:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005472:	0af71863          	bne	a4,a5,80005522 <virtio_disk_init+0x112>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005476:	100017b7          	lui	a5,0x10001
    8000547a:	4705                	li	a4,1
    8000547c:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000547e:	470d                	li	a4,3
    80005480:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005482:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005484:	c7ffe6b7          	lui	a3,0xc7ffe
    80005488:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdd51f>
    8000548c:	8f75                	and	a4,a4,a3
    8000548e:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005490:	472d                	li	a4,11
    80005492:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005494:	473d                	li	a4,15
    80005496:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005498:	6705                	lui	a4,0x1
    8000549a:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000549c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800054a0:	5bdc                	lw	a5,52(a5)
    800054a2:	2781                	sext.w	a5,a5
  if(max == 0)
    800054a4:	c7d9                	beqz	a5,80005532 <virtio_disk_init+0x122>
  if(max < NUM)
    800054a6:	471d                	li	a4,7
    800054a8:	08f77d63          	bgeu	a4,a5,80005542 <virtio_disk_init+0x132>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800054ac:	100014b7          	lui	s1,0x10001
    800054b0:	47a1                	li	a5,8
    800054b2:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    800054b4:	6609                	lui	a2,0x2
    800054b6:	4581                	li	a1,0
    800054b8:	00011517          	auipc	a0,0x11
    800054bc:	b4850513          	addi	a0,a0,-1208 # 80016000 <disk>
    800054c0:	ffffb097          	auipc	ra,0xffffb
    800054c4:	cba080e7          	jalr	-838(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    800054c8:	00011717          	auipc	a4,0x11
    800054cc:	b3870713          	addi	a4,a4,-1224 # 80016000 <disk>
    800054d0:	00c75793          	srli	a5,a4,0xc
    800054d4:	2781                	sext.w	a5,a5
    800054d6:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    800054d8:	00013797          	auipc	a5,0x13
    800054dc:	b2878793          	addi	a5,a5,-1240 # 80018000 <disk+0x2000>
    800054e0:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    800054e2:	00011717          	auipc	a4,0x11
    800054e6:	b9e70713          	addi	a4,a4,-1122 # 80016080 <disk+0x80>
    800054ea:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    800054ec:	00012717          	auipc	a4,0x12
    800054f0:	b1470713          	addi	a4,a4,-1260 # 80017000 <disk+0x1000>
    800054f4:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    800054f6:	4705                	li	a4,1
    800054f8:	00e78c23          	sb	a4,24(a5)
    800054fc:	00e78ca3          	sb	a4,25(a5)
    80005500:	00e78d23          	sb	a4,26(a5)
    80005504:	00e78da3          	sb	a4,27(a5)
    80005508:	00e78e23          	sb	a4,28(a5)
    8000550c:	00e78ea3          	sb	a4,29(a5)
    80005510:	00e78f23          	sb	a4,30(a5)
    80005514:	00e78fa3          	sb	a4,31(a5)
}
    80005518:	60e2                	ld	ra,24(sp)
    8000551a:	6442                	ld	s0,16(sp)
    8000551c:	64a2                	ld	s1,8(sp)
    8000551e:	6105                	addi	sp,sp,32
    80005520:	8082                	ret
    panic("could not find virtio disk");
    80005522:	00003517          	auipc	a0,0x3
    80005526:	1fe50513          	addi	a0,a0,510 # 80008720 <syscalls+0x358>
    8000552a:	00001097          	auipc	ra,0x1
    8000552e:	896080e7          	jalr	-1898(ra) # 80005dc0 <panic>
    panic("virtio disk has no queue 0");
    80005532:	00003517          	auipc	a0,0x3
    80005536:	20e50513          	addi	a0,a0,526 # 80008740 <syscalls+0x378>
    8000553a:	00001097          	auipc	ra,0x1
    8000553e:	886080e7          	jalr	-1914(ra) # 80005dc0 <panic>
    panic("virtio disk max queue too short");
    80005542:	00003517          	auipc	a0,0x3
    80005546:	21e50513          	addi	a0,a0,542 # 80008760 <syscalls+0x398>
    8000554a:	00001097          	auipc	ra,0x1
    8000554e:	876080e7          	jalr	-1930(ra) # 80005dc0 <panic>

0000000080005552 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005552:	7119                	addi	sp,sp,-128
    80005554:	fc86                	sd	ra,120(sp)
    80005556:	f8a2                	sd	s0,112(sp)
    80005558:	f4a6                	sd	s1,104(sp)
    8000555a:	f0ca                	sd	s2,96(sp)
    8000555c:	ecce                	sd	s3,88(sp)
    8000555e:	e8d2                	sd	s4,80(sp)
    80005560:	e4d6                	sd	s5,72(sp)
    80005562:	e0da                	sd	s6,64(sp)
    80005564:	fc5e                	sd	s7,56(sp)
    80005566:	f862                	sd	s8,48(sp)
    80005568:	f466                	sd	s9,40(sp)
    8000556a:	f06a                	sd	s10,32(sp)
    8000556c:	ec6e                	sd	s11,24(sp)
    8000556e:	0100                	addi	s0,sp,128
    80005570:	8aaa                	mv	s5,a0
    80005572:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005574:	00c52c83          	lw	s9,12(a0)
    80005578:	001c9c9b          	slliw	s9,s9,0x1
    8000557c:	1c82                	slli	s9,s9,0x20
    8000557e:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005582:	00013517          	auipc	a0,0x13
    80005586:	ba650513          	addi	a0,a0,-1114 # 80018128 <disk+0x2128>
    8000558a:	00001097          	auipc	ra,0x1
    8000558e:	d6e080e7          	jalr	-658(ra) # 800062f8 <acquire>
  for(int i = 0; i < 3; i++){
    80005592:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005594:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005596:	00011c17          	auipc	s8,0x11
    8000559a:	a6ac0c13          	addi	s8,s8,-1430 # 80016000 <disk>
    8000559e:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    800055a0:	4b0d                	li	s6,3
    800055a2:	a0ad                	j	8000560c <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    800055a4:	00fc0733          	add	a4,s8,a5
    800055a8:	975e                	add	a4,a4,s7
    800055aa:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800055ae:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800055b0:	0207c563          	bltz	a5,800055da <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800055b4:	2905                	addiw	s2,s2,1
    800055b6:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    800055b8:	19690c63          	beq	s2,s6,80005750 <virtio_disk_rw+0x1fe>
    idx[i] = alloc_desc();
    800055bc:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800055be:	00013717          	auipc	a4,0x13
    800055c2:	a5a70713          	addi	a4,a4,-1446 # 80018018 <disk+0x2018>
    800055c6:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800055c8:	00074683          	lbu	a3,0(a4)
    800055cc:	fee1                	bnez	a3,800055a4 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    800055ce:	2785                	addiw	a5,a5,1
    800055d0:	0705                	addi	a4,a4,1
    800055d2:	fe979be3          	bne	a5,s1,800055c8 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    800055d6:	57fd                	li	a5,-1
    800055d8:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800055da:	01205d63          	blez	s2,800055f4 <virtio_disk_rw+0xa2>
    800055de:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    800055e0:	000a2503          	lw	a0,0(s4)
    800055e4:	00000097          	auipc	ra,0x0
    800055e8:	d92080e7          	jalr	-622(ra) # 80005376 <free_desc>
      for(int j = 0; j < i; j++)
    800055ec:	2d85                	addiw	s11,s11,1
    800055ee:	0a11                	addi	s4,s4,4
    800055f0:	ff2d98e3          	bne	s11,s2,800055e0 <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800055f4:	00013597          	auipc	a1,0x13
    800055f8:	b3458593          	addi	a1,a1,-1228 # 80018128 <disk+0x2128>
    800055fc:	00013517          	auipc	a0,0x13
    80005600:	a1c50513          	addi	a0,a0,-1508 # 80018018 <disk+0x2018>
    80005604:	ffffc097          	auipc	ra,0xffffc
    80005608:	f04080e7          	jalr	-252(ra) # 80001508 <sleep>
  for(int i = 0; i < 3; i++){
    8000560c:	f8040a13          	addi	s4,s0,-128
{
    80005610:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80005612:	894e                	mv	s2,s3
    80005614:	b765                	j	800055bc <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005616:	00013697          	auipc	a3,0x13
    8000561a:	9ea6b683          	ld	a3,-1558(a3) # 80018000 <disk+0x2000>
    8000561e:	96ba                	add	a3,a3,a4
    80005620:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005624:	00011817          	auipc	a6,0x11
    80005628:	9dc80813          	addi	a6,a6,-1572 # 80016000 <disk>
    8000562c:	00013697          	auipc	a3,0x13
    80005630:	9d468693          	addi	a3,a3,-1580 # 80018000 <disk+0x2000>
    80005634:	6290                	ld	a2,0(a3)
    80005636:	963a                	add	a2,a2,a4
    80005638:	00c65583          	lhu	a1,12(a2)
    8000563c:	0015e593          	ori	a1,a1,1
    80005640:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    80005644:	f8842603          	lw	a2,-120(s0)
    80005648:	628c                	ld	a1,0(a3)
    8000564a:	972e                	add	a4,a4,a1
    8000564c:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005650:	20050593          	addi	a1,a0,512
    80005654:	0592                	slli	a1,a1,0x4
    80005656:	95c2                	add	a1,a1,a6
    80005658:	577d                	li	a4,-1
    8000565a:	02e58823          	sb	a4,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000565e:	00461713          	slli	a4,a2,0x4
    80005662:	6290                	ld	a2,0(a3)
    80005664:	963a                	add	a2,a2,a4
    80005666:	03078793          	addi	a5,a5,48
    8000566a:	97c2                	add	a5,a5,a6
    8000566c:	e21c                	sd	a5,0(a2)
  disk.desc[idx[2]].len = 1;
    8000566e:	629c                	ld	a5,0(a3)
    80005670:	97ba                	add	a5,a5,a4
    80005672:	4605                	li	a2,1
    80005674:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005676:	629c                	ld	a5,0(a3)
    80005678:	97ba                	add	a5,a5,a4
    8000567a:	4809                	li	a6,2
    8000567c:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005680:	629c                	ld	a5,0(a3)
    80005682:	97ba                	add	a5,a5,a4
    80005684:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005688:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    8000568c:	0355b423          	sd	s5,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005690:	6698                	ld	a4,8(a3)
    80005692:	00275783          	lhu	a5,2(a4)
    80005696:	8b9d                	andi	a5,a5,7
    80005698:	0786                	slli	a5,a5,0x1
    8000569a:	973e                	add	a4,a4,a5
    8000569c:	00a71223          	sh	a0,4(a4)

  __sync_synchronize();
    800056a0:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800056a4:	6698                	ld	a4,8(a3)
    800056a6:	00275783          	lhu	a5,2(a4)
    800056aa:	2785                	addiw	a5,a5,1
    800056ac:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800056b0:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800056b4:	100017b7          	lui	a5,0x10001
    800056b8:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800056bc:	004aa783          	lw	a5,4(s5)
    800056c0:	02c79163          	bne	a5,a2,800056e2 <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    800056c4:	00013917          	auipc	s2,0x13
    800056c8:	a6490913          	addi	s2,s2,-1436 # 80018128 <disk+0x2128>
  while(b->disk == 1) {
    800056cc:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800056ce:	85ca                	mv	a1,s2
    800056d0:	8556                	mv	a0,s5
    800056d2:	ffffc097          	auipc	ra,0xffffc
    800056d6:	e36080e7          	jalr	-458(ra) # 80001508 <sleep>
  while(b->disk == 1) {
    800056da:	004aa783          	lw	a5,4(s5)
    800056de:	fe9788e3          	beq	a5,s1,800056ce <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    800056e2:	f8042903          	lw	s2,-128(s0)
    800056e6:	20090713          	addi	a4,s2,512
    800056ea:	0712                	slli	a4,a4,0x4
    800056ec:	00011797          	auipc	a5,0x11
    800056f0:	91478793          	addi	a5,a5,-1772 # 80016000 <disk>
    800056f4:	97ba                	add	a5,a5,a4
    800056f6:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    800056fa:	00013997          	auipc	s3,0x13
    800056fe:	90698993          	addi	s3,s3,-1786 # 80018000 <disk+0x2000>
    80005702:	00491713          	slli	a4,s2,0x4
    80005706:	0009b783          	ld	a5,0(s3)
    8000570a:	97ba                	add	a5,a5,a4
    8000570c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005710:	854a                	mv	a0,s2
    80005712:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005716:	00000097          	auipc	ra,0x0
    8000571a:	c60080e7          	jalr	-928(ra) # 80005376 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000571e:	8885                	andi	s1,s1,1
    80005720:	f0ed                	bnez	s1,80005702 <virtio_disk_rw+0x1b0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005722:	00013517          	auipc	a0,0x13
    80005726:	a0650513          	addi	a0,a0,-1530 # 80018128 <disk+0x2128>
    8000572a:	00001097          	auipc	ra,0x1
    8000572e:	c82080e7          	jalr	-894(ra) # 800063ac <release>
}
    80005732:	70e6                	ld	ra,120(sp)
    80005734:	7446                	ld	s0,112(sp)
    80005736:	74a6                	ld	s1,104(sp)
    80005738:	7906                	ld	s2,96(sp)
    8000573a:	69e6                	ld	s3,88(sp)
    8000573c:	6a46                	ld	s4,80(sp)
    8000573e:	6aa6                	ld	s5,72(sp)
    80005740:	6b06                	ld	s6,64(sp)
    80005742:	7be2                	ld	s7,56(sp)
    80005744:	7c42                	ld	s8,48(sp)
    80005746:	7ca2                	ld	s9,40(sp)
    80005748:	7d02                	ld	s10,32(sp)
    8000574a:	6de2                	ld	s11,24(sp)
    8000574c:	6109                	addi	sp,sp,128
    8000574e:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005750:	f8042503          	lw	a0,-128(s0)
    80005754:	20050793          	addi	a5,a0,512
    80005758:	0792                	slli	a5,a5,0x4
  if(write)
    8000575a:	00011817          	auipc	a6,0x11
    8000575e:	8a680813          	addi	a6,a6,-1882 # 80016000 <disk>
    80005762:	00f80733          	add	a4,a6,a5
    80005766:	01a036b3          	snez	a3,s10
    8000576a:	0ad72423          	sw	a3,168(a4)
  buf0->reserved = 0;
    8000576e:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80005772:	0b973823          	sd	s9,176(a4)
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005776:	7679                	lui	a2,0xffffe
    80005778:	963e                	add	a2,a2,a5
    8000577a:	00013697          	auipc	a3,0x13
    8000577e:	88668693          	addi	a3,a3,-1914 # 80018000 <disk+0x2000>
    80005782:	6298                	ld	a4,0(a3)
    80005784:	9732                	add	a4,a4,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005786:	0a878593          	addi	a1,a5,168
    8000578a:	95c2                	add	a1,a1,a6
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000578c:	e30c                	sd	a1,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000578e:	6298                	ld	a4,0(a3)
    80005790:	9732                	add	a4,a4,a2
    80005792:	45c1                	li	a1,16
    80005794:	c70c                	sw	a1,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005796:	6298                	ld	a4,0(a3)
    80005798:	9732                	add	a4,a4,a2
    8000579a:	4585                	li	a1,1
    8000579c:	00b71623          	sh	a1,12(a4)
  disk.desc[idx[0]].next = idx[1];
    800057a0:	f8442703          	lw	a4,-124(s0)
    800057a4:	628c                	ld	a1,0(a3)
    800057a6:	962e                	add	a2,a2,a1
    800057a8:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffdcdce>
  disk.desc[idx[1]].addr = (uint64) b->data;
    800057ac:	0712                	slli	a4,a4,0x4
    800057ae:	6290                	ld	a2,0(a3)
    800057b0:	963a                	add	a2,a2,a4
    800057b2:	058a8593          	addi	a1,s5,88
    800057b6:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800057b8:	6294                	ld	a3,0(a3)
    800057ba:	96ba                	add	a3,a3,a4
    800057bc:	40000613          	li	a2,1024
    800057c0:	c690                	sw	a2,8(a3)
  if(write)
    800057c2:	e40d1ae3          	bnez	s10,80005616 <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800057c6:	00013697          	auipc	a3,0x13
    800057ca:	83a6b683          	ld	a3,-1990(a3) # 80018000 <disk+0x2000>
    800057ce:	96ba                	add	a3,a3,a4
    800057d0:	4609                	li	a2,2
    800057d2:	00c69623          	sh	a2,12(a3)
    800057d6:	b5b9                	j	80005624 <virtio_disk_rw+0xd2>

00000000800057d8 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800057d8:	1101                	addi	sp,sp,-32
    800057da:	ec06                	sd	ra,24(sp)
    800057dc:	e822                	sd	s0,16(sp)
    800057de:	e426                	sd	s1,8(sp)
    800057e0:	e04a                	sd	s2,0(sp)
    800057e2:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800057e4:	00013517          	auipc	a0,0x13
    800057e8:	94450513          	addi	a0,a0,-1724 # 80018128 <disk+0x2128>
    800057ec:	00001097          	auipc	ra,0x1
    800057f0:	b0c080e7          	jalr	-1268(ra) # 800062f8 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800057f4:	10001737          	lui	a4,0x10001
    800057f8:	533c                	lw	a5,96(a4)
    800057fa:	8b8d                	andi	a5,a5,3
    800057fc:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800057fe:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005802:	00012797          	auipc	a5,0x12
    80005806:	7fe78793          	addi	a5,a5,2046 # 80018000 <disk+0x2000>
    8000580a:	6b94                	ld	a3,16(a5)
    8000580c:	0207d703          	lhu	a4,32(a5)
    80005810:	0026d783          	lhu	a5,2(a3)
    80005814:	06f70163          	beq	a4,a5,80005876 <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005818:	00010917          	auipc	s2,0x10
    8000581c:	7e890913          	addi	s2,s2,2024 # 80016000 <disk>
    80005820:	00012497          	auipc	s1,0x12
    80005824:	7e048493          	addi	s1,s1,2016 # 80018000 <disk+0x2000>
    __sync_synchronize();
    80005828:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000582c:	6898                	ld	a4,16(s1)
    8000582e:	0204d783          	lhu	a5,32(s1)
    80005832:	8b9d                	andi	a5,a5,7
    80005834:	078e                	slli	a5,a5,0x3
    80005836:	97ba                	add	a5,a5,a4
    80005838:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000583a:	20078713          	addi	a4,a5,512
    8000583e:	0712                	slli	a4,a4,0x4
    80005840:	974a                	add	a4,a4,s2
    80005842:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    80005846:	e731                	bnez	a4,80005892 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005848:	20078793          	addi	a5,a5,512
    8000584c:	0792                	slli	a5,a5,0x4
    8000584e:	97ca                	add	a5,a5,s2
    80005850:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005852:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005856:	ffffc097          	auipc	ra,0xffffc
    8000585a:	e3e080e7          	jalr	-450(ra) # 80001694 <wakeup>

    disk.used_idx += 1;
    8000585e:	0204d783          	lhu	a5,32(s1)
    80005862:	2785                	addiw	a5,a5,1
    80005864:	17c2                	slli	a5,a5,0x30
    80005866:	93c1                	srli	a5,a5,0x30
    80005868:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    8000586c:	6898                	ld	a4,16(s1)
    8000586e:	00275703          	lhu	a4,2(a4)
    80005872:	faf71be3          	bne	a4,a5,80005828 <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    80005876:	00013517          	auipc	a0,0x13
    8000587a:	8b250513          	addi	a0,a0,-1870 # 80018128 <disk+0x2128>
    8000587e:	00001097          	auipc	ra,0x1
    80005882:	b2e080e7          	jalr	-1234(ra) # 800063ac <release>
}
    80005886:	60e2                	ld	ra,24(sp)
    80005888:	6442                	ld	s0,16(sp)
    8000588a:	64a2                	ld	s1,8(sp)
    8000588c:	6902                	ld	s2,0(sp)
    8000588e:	6105                	addi	sp,sp,32
    80005890:	8082                	ret
      panic("virtio_disk_intr status");
    80005892:	00003517          	auipc	a0,0x3
    80005896:	eee50513          	addi	a0,a0,-274 # 80008780 <syscalls+0x3b8>
    8000589a:	00000097          	auipc	ra,0x0
    8000589e:	526080e7          	jalr	1318(ra) # 80005dc0 <panic>

00000000800058a2 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    800058a2:	1141                	addi	sp,sp,-16
    800058a4:	e422                	sd	s0,8(sp)
    800058a6:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800058a8:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    800058ac:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    800058b0:	0037979b          	slliw	a5,a5,0x3
    800058b4:	02004737          	lui	a4,0x2004
    800058b8:	97ba                	add	a5,a5,a4
    800058ba:	0200c737          	lui	a4,0x200c
    800058be:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    800058c2:	000f4637          	lui	a2,0xf4
    800058c6:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800058ca:	9732                	add	a4,a4,a2
    800058cc:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800058ce:	00259693          	slli	a3,a1,0x2
    800058d2:	96ae                	add	a3,a3,a1
    800058d4:	068e                	slli	a3,a3,0x3
    800058d6:	00013717          	auipc	a4,0x13
    800058da:	72a70713          	addi	a4,a4,1834 # 80019000 <timer_scratch>
    800058de:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800058e0:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800058e2:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800058e4:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800058e8:	00000797          	auipc	a5,0x0
    800058ec:	9c878793          	addi	a5,a5,-1592 # 800052b0 <timervec>
    800058f0:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800058f4:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800058f8:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800058fc:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005900:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005904:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005908:	30479073          	csrw	mie,a5
}
    8000590c:	6422                	ld	s0,8(sp)
    8000590e:	0141                	addi	sp,sp,16
    80005910:	8082                	ret

0000000080005912 <start>:
{
    80005912:	1141                	addi	sp,sp,-16
    80005914:	e406                	sd	ra,8(sp)
    80005916:	e022                	sd	s0,0(sp)
    80005918:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000591a:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000591e:	7779                	lui	a4,0xffffe
    80005920:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdd5bf>
    80005924:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005926:	6705                	lui	a4,0x1
    80005928:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000592c:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000592e:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005932:	ffffb797          	auipc	a5,0xffffb
    80005936:	9ee78793          	addi	a5,a5,-1554 # 80000320 <main>
    8000593a:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    8000593e:	4781                	li	a5,0
    80005940:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005944:	67c1                	lui	a5,0x10
    80005946:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005948:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    8000594c:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005950:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005954:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005958:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    8000595c:	57fd                	li	a5,-1
    8000595e:	83a9                	srli	a5,a5,0xa
    80005960:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005964:	47bd                	li	a5,15
    80005966:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    8000596a:	00000097          	auipc	ra,0x0
    8000596e:	f38080e7          	jalr	-200(ra) # 800058a2 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005972:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005976:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005978:	823e                	mv	tp,a5
  asm volatile("mret");
    8000597a:	30200073          	mret
}
    8000597e:	60a2                	ld	ra,8(sp)
    80005980:	6402                	ld	s0,0(sp)
    80005982:	0141                	addi	sp,sp,16
    80005984:	8082                	ret

0000000080005986 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005986:	715d                	addi	sp,sp,-80
    80005988:	e486                	sd	ra,72(sp)
    8000598a:	e0a2                	sd	s0,64(sp)
    8000598c:	fc26                	sd	s1,56(sp)
    8000598e:	f84a                	sd	s2,48(sp)
    80005990:	f44e                	sd	s3,40(sp)
    80005992:	f052                	sd	s4,32(sp)
    80005994:	ec56                	sd	s5,24(sp)
    80005996:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005998:	04c05763          	blez	a2,800059e6 <consolewrite+0x60>
    8000599c:	8a2a                	mv	s4,a0
    8000599e:	84ae                	mv	s1,a1
    800059a0:	89b2                	mv	s3,a2
    800059a2:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800059a4:	5afd                	li	s5,-1
    800059a6:	4685                	li	a3,1
    800059a8:	8626                	mv	a2,s1
    800059aa:	85d2                	mv	a1,s4
    800059ac:	fbf40513          	addi	a0,s0,-65
    800059b0:	ffffc097          	auipc	ra,0xffffc
    800059b4:	f52080e7          	jalr	-174(ra) # 80001902 <either_copyin>
    800059b8:	01550d63          	beq	a0,s5,800059d2 <consolewrite+0x4c>
      break;
    uartputc(c);
    800059bc:	fbf44503          	lbu	a0,-65(s0)
    800059c0:	00000097          	auipc	ra,0x0
    800059c4:	77e080e7          	jalr	1918(ra) # 8000613e <uartputc>
  for(i = 0; i < n; i++){
    800059c8:	2905                	addiw	s2,s2,1
    800059ca:	0485                	addi	s1,s1,1
    800059cc:	fd299de3          	bne	s3,s2,800059a6 <consolewrite+0x20>
    800059d0:	894e                	mv	s2,s3
  }

  return i;
}
    800059d2:	854a                	mv	a0,s2
    800059d4:	60a6                	ld	ra,72(sp)
    800059d6:	6406                	ld	s0,64(sp)
    800059d8:	74e2                	ld	s1,56(sp)
    800059da:	7942                	ld	s2,48(sp)
    800059dc:	79a2                	ld	s3,40(sp)
    800059de:	7a02                	ld	s4,32(sp)
    800059e0:	6ae2                	ld	s5,24(sp)
    800059e2:	6161                	addi	sp,sp,80
    800059e4:	8082                	ret
  for(i = 0; i < n; i++){
    800059e6:	4901                	li	s2,0
    800059e8:	b7ed                	j	800059d2 <consolewrite+0x4c>

00000000800059ea <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800059ea:	7159                	addi	sp,sp,-112
    800059ec:	f486                	sd	ra,104(sp)
    800059ee:	f0a2                	sd	s0,96(sp)
    800059f0:	eca6                	sd	s1,88(sp)
    800059f2:	e8ca                	sd	s2,80(sp)
    800059f4:	e4ce                	sd	s3,72(sp)
    800059f6:	e0d2                	sd	s4,64(sp)
    800059f8:	fc56                	sd	s5,56(sp)
    800059fa:	f85a                	sd	s6,48(sp)
    800059fc:	f45e                	sd	s7,40(sp)
    800059fe:	f062                	sd	s8,32(sp)
    80005a00:	ec66                	sd	s9,24(sp)
    80005a02:	e86a                	sd	s10,16(sp)
    80005a04:	1880                	addi	s0,sp,112
    80005a06:	8aaa                	mv	s5,a0
    80005a08:	8a2e                	mv	s4,a1
    80005a0a:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005a0c:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005a10:	0001b517          	auipc	a0,0x1b
    80005a14:	73050513          	addi	a0,a0,1840 # 80021140 <cons>
    80005a18:	00001097          	auipc	ra,0x1
    80005a1c:	8e0080e7          	jalr	-1824(ra) # 800062f8 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005a20:	0001b497          	auipc	s1,0x1b
    80005a24:	72048493          	addi	s1,s1,1824 # 80021140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005a28:	0001b917          	auipc	s2,0x1b
    80005a2c:	7b090913          	addi	s2,s2,1968 # 800211d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005a30:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a32:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005a34:	4ca9                	li	s9,10
  while(n > 0){
    80005a36:	07305863          	blez	s3,80005aa6 <consoleread+0xbc>
    while(cons.r == cons.w){
    80005a3a:	0984a783          	lw	a5,152(s1)
    80005a3e:	09c4a703          	lw	a4,156(s1)
    80005a42:	02f71463          	bne	a4,a5,80005a6a <consoleread+0x80>
      if(myproc()->killed){
    80005a46:	ffffb097          	auipc	ra,0xffffb
    80005a4a:	3fe080e7          	jalr	1022(ra) # 80000e44 <myproc>
    80005a4e:	551c                	lw	a5,40(a0)
    80005a50:	e7b5                	bnez	a5,80005abc <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    80005a52:	85a6                	mv	a1,s1
    80005a54:	854a                	mv	a0,s2
    80005a56:	ffffc097          	auipc	ra,0xffffc
    80005a5a:	ab2080e7          	jalr	-1358(ra) # 80001508 <sleep>
    while(cons.r == cons.w){
    80005a5e:	0984a783          	lw	a5,152(s1)
    80005a62:	09c4a703          	lw	a4,156(s1)
    80005a66:	fef700e3          	beq	a4,a5,80005a46 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005a6a:	0017871b          	addiw	a4,a5,1
    80005a6e:	08e4ac23          	sw	a4,152(s1)
    80005a72:	07f7f713          	andi	a4,a5,127
    80005a76:	9726                	add	a4,a4,s1
    80005a78:	01874703          	lbu	a4,24(a4)
    80005a7c:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80005a80:	077d0563          	beq	s10,s7,80005aea <consoleread+0x100>
    cbuf = c;
    80005a84:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a88:	4685                	li	a3,1
    80005a8a:	f9f40613          	addi	a2,s0,-97
    80005a8e:	85d2                	mv	a1,s4
    80005a90:	8556                	mv	a0,s5
    80005a92:	ffffc097          	auipc	ra,0xffffc
    80005a96:	e1a080e7          	jalr	-486(ra) # 800018ac <either_copyout>
    80005a9a:	01850663          	beq	a0,s8,80005aa6 <consoleread+0xbc>
    dst++;
    80005a9e:	0a05                	addi	s4,s4,1
    --n;
    80005aa0:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80005aa2:	f99d1ae3          	bne	s10,s9,80005a36 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005aa6:	0001b517          	auipc	a0,0x1b
    80005aaa:	69a50513          	addi	a0,a0,1690 # 80021140 <cons>
    80005aae:	00001097          	auipc	ra,0x1
    80005ab2:	8fe080e7          	jalr	-1794(ra) # 800063ac <release>

  return target - n;
    80005ab6:	413b053b          	subw	a0,s6,s3
    80005aba:	a811                	j	80005ace <consoleread+0xe4>
        release(&cons.lock);
    80005abc:	0001b517          	auipc	a0,0x1b
    80005ac0:	68450513          	addi	a0,a0,1668 # 80021140 <cons>
    80005ac4:	00001097          	auipc	ra,0x1
    80005ac8:	8e8080e7          	jalr	-1816(ra) # 800063ac <release>
        return -1;
    80005acc:	557d                	li	a0,-1
}
    80005ace:	70a6                	ld	ra,104(sp)
    80005ad0:	7406                	ld	s0,96(sp)
    80005ad2:	64e6                	ld	s1,88(sp)
    80005ad4:	6946                	ld	s2,80(sp)
    80005ad6:	69a6                	ld	s3,72(sp)
    80005ad8:	6a06                	ld	s4,64(sp)
    80005ada:	7ae2                	ld	s5,56(sp)
    80005adc:	7b42                	ld	s6,48(sp)
    80005ade:	7ba2                	ld	s7,40(sp)
    80005ae0:	7c02                	ld	s8,32(sp)
    80005ae2:	6ce2                	ld	s9,24(sp)
    80005ae4:	6d42                	ld	s10,16(sp)
    80005ae6:	6165                	addi	sp,sp,112
    80005ae8:	8082                	ret
      if(n < target){
    80005aea:	0009871b          	sext.w	a4,s3
    80005aee:	fb677ce3          	bgeu	a4,s6,80005aa6 <consoleread+0xbc>
        cons.r--;
    80005af2:	0001b717          	auipc	a4,0x1b
    80005af6:	6ef72323          	sw	a5,1766(a4) # 800211d8 <cons+0x98>
    80005afa:	b775                	j	80005aa6 <consoleread+0xbc>

0000000080005afc <consputc>:
{
    80005afc:	1141                	addi	sp,sp,-16
    80005afe:	e406                	sd	ra,8(sp)
    80005b00:	e022                	sd	s0,0(sp)
    80005b02:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005b04:	10000793          	li	a5,256
    80005b08:	00f50a63          	beq	a0,a5,80005b1c <consputc+0x20>
    uartputc_sync(c);
    80005b0c:	00000097          	auipc	ra,0x0
    80005b10:	560080e7          	jalr	1376(ra) # 8000606c <uartputc_sync>
}
    80005b14:	60a2                	ld	ra,8(sp)
    80005b16:	6402                	ld	s0,0(sp)
    80005b18:	0141                	addi	sp,sp,16
    80005b1a:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005b1c:	4521                	li	a0,8
    80005b1e:	00000097          	auipc	ra,0x0
    80005b22:	54e080e7          	jalr	1358(ra) # 8000606c <uartputc_sync>
    80005b26:	02000513          	li	a0,32
    80005b2a:	00000097          	auipc	ra,0x0
    80005b2e:	542080e7          	jalr	1346(ra) # 8000606c <uartputc_sync>
    80005b32:	4521                	li	a0,8
    80005b34:	00000097          	auipc	ra,0x0
    80005b38:	538080e7          	jalr	1336(ra) # 8000606c <uartputc_sync>
    80005b3c:	bfe1                	j	80005b14 <consputc+0x18>

0000000080005b3e <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005b3e:	1101                	addi	sp,sp,-32
    80005b40:	ec06                	sd	ra,24(sp)
    80005b42:	e822                	sd	s0,16(sp)
    80005b44:	e426                	sd	s1,8(sp)
    80005b46:	e04a                	sd	s2,0(sp)
    80005b48:	1000                	addi	s0,sp,32
    80005b4a:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005b4c:	0001b517          	auipc	a0,0x1b
    80005b50:	5f450513          	addi	a0,a0,1524 # 80021140 <cons>
    80005b54:	00000097          	auipc	ra,0x0
    80005b58:	7a4080e7          	jalr	1956(ra) # 800062f8 <acquire>

  switch(c){
    80005b5c:	47d5                	li	a5,21
    80005b5e:	0af48663          	beq	s1,a5,80005c0a <consoleintr+0xcc>
    80005b62:	0297ca63          	blt	a5,s1,80005b96 <consoleintr+0x58>
    80005b66:	47a1                	li	a5,8
    80005b68:	0ef48763          	beq	s1,a5,80005c56 <consoleintr+0x118>
    80005b6c:	47c1                	li	a5,16
    80005b6e:	10f49a63          	bne	s1,a5,80005c82 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005b72:	ffffc097          	auipc	ra,0xffffc
    80005b76:	de6080e7          	jalr	-538(ra) # 80001958 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005b7a:	0001b517          	auipc	a0,0x1b
    80005b7e:	5c650513          	addi	a0,a0,1478 # 80021140 <cons>
    80005b82:	00001097          	auipc	ra,0x1
    80005b86:	82a080e7          	jalr	-2006(ra) # 800063ac <release>
}
    80005b8a:	60e2                	ld	ra,24(sp)
    80005b8c:	6442                	ld	s0,16(sp)
    80005b8e:	64a2                	ld	s1,8(sp)
    80005b90:	6902                	ld	s2,0(sp)
    80005b92:	6105                	addi	sp,sp,32
    80005b94:	8082                	ret
  switch(c){
    80005b96:	07f00793          	li	a5,127
    80005b9a:	0af48e63          	beq	s1,a5,80005c56 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005b9e:	0001b717          	auipc	a4,0x1b
    80005ba2:	5a270713          	addi	a4,a4,1442 # 80021140 <cons>
    80005ba6:	0a072783          	lw	a5,160(a4)
    80005baa:	09872703          	lw	a4,152(a4)
    80005bae:	9f99                	subw	a5,a5,a4
    80005bb0:	07f00713          	li	a4,127
    80005bb4:	fcf763e3          	bltu	a4,a5,80005b7a <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005bb8:	47b5                	li	a5,13
    80005bba:	0cf48763          	beq	s1,a5,80005c88 <consoleintr+0x14a>
      consputc(c);
    80005bbe:	8526                	mv	a0,s1
    80005bc0:	00000097          	auipc	ra,0x0
    80005bc4:	f3c080e7          	jalr	-196(ra) # 80005afc <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005bc8:	0001b797          	auipc	a5,0x1b
    80005bcc:	57878793          	addi	a5,a5,1400 # 80021140 <cons>
    80005bd0:	0a07a703          	lw	a4,160(a5)
    80005bd4:	0017069b          	addiw	a3,a4,1
    80005bd8:	0006861b          	sext.w	a2,a3
    80005bdc:	0ad7a023          	sw	a3,160(a5)
    80005be0:	07f77713          	andi	a4,a4,127
    80005be4:	97ba                	add	a5,a5,a4
    80005be6:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005bea:	47a9                	li	a5,10
    80005bec:	0cf48563          	beq	s1,a5,80005cb6 <consoleintr+0x178>
    80005bf0:	4791                	li	a5,4
    80005bf2:	0cf48263          	beq	s1,a5,80005cb6 <consoleintr+0x178>
    80005bf6:	0001b797          	auipc	a5,0x1b
    80005bfa:	5e27a783          	lw	a5,1506(a5) # 800211d8 <cons+0x98>
    80005bfe:	0807879b          	addiw	a5,a5,128
    80005c02:	f6f61ce3          	bne	a2,a5,80005b7a <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005c06:	863e                	mv	a2,a5
    80005c08:	a07d                	j	80005cb6 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005c0a:	0001b717          	auipc	a4,0x1b
    80005c0e:	53670713          	addi	a4,a4,1334 # 80021140 <cons>
    80005c12:	0a072783          	lw	a5,160(a4)
    80005c16:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005c1a:	0001b497          	auipc	s1,0x1b
    80005c1e:	52648493          	addi	s1,s1,1318 # 80021140 <cons>
    while(cons.e != cons.w &&
    80005c22:	4929                	li	s2,10
    80005c24:	f4f70be3          	beq	a4,a5,80005b7a <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005c28:	37fd                	addiw	a5,a5,-1
    80005c2a:	07f7f713          	andi	a4,a5,127
    80005c2e:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005c30:	01874703          	lbu	a4,24(a4)
    80005c34:	f52703e3          	beq	a4,s2,80005b7a <consoleintr+0x3c>
      cons.e--;
    80005c38:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005c3c:	10000513          	li	a0,256
    80005c40:	00000097          	auipc	ra,0x0
    80005c44:	ebc080e7          	jalr	-324(ra) # 80005afc <consputc>
    while(cons.e != cons.w &&
    80005c48:	0a04a783          	lw	a5,160(s1)
    80005c4c:	09c4a703          	lw	a4,156(s1)
    80005c50:	fcf71ce3          	bne	a4,a5,80005c28 <consoleintr+0xea>
    80005c54:	b71d                	j	80005b7a <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005c56:	0001b717          	auipc	a4,0x1b
    80005c5a:	4ea70713          	addi	a4,a4,1258 # 80021140 <cons>
    80005c5e:	0a072783          	lw	a5,160(a4)
    80005c62:	09c72703          	lw	a4,156(a4)
    80005c66:	f0f70ae3          	beq	a4,a5,80005b7a <consoleintr+0x3c>
      cons.e--;
    80005c6a:	37fd                	addiw	a5,a5,-1
    80005c6c:	0001b717          	auipc	a4,0x1b
    80005c70:	56f72a23          	sw	a5,1396(a4) # 800211e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005c74:	10000513          	li	a0,256
    80005c78:	00000097          	auipc	ra,0x0
    80005c7c:	e84080e7          	jalr	-380(ra) # 80005afc <consputc>
    80005c80:	bded                	j	80005b7a <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005c82:	ee048ce3          	beqz	s1,80005b7a <consoleintr+0x3c>
    80005c86:	bf21                	j	80005b9e <consoleintr+0x60>
      consputc(c);
    80005c88:	4529                	li	a0,10
    80005c8a:	00000097          	auipc	ra,0x0
    80005c8e:	e72080e7          	jalr	-398(ra) # 80005afc <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005c92:	0001b797          	auipc	a5,0x1b
    80005c96:	4ae78793          	addi	a5,a5,1198 # 80021140 <cons>
    80005c9a:	0a07a703          	lw	a4,160(a5)
    80005c9e:	0017069b          	addiw	a3,a4,1
    80005ca2:	0006861b          	sext.w	a2,a3
    80005ca6:	0ad7a023          	sw	a3,160(a5)
    80005caa:	07f77713          	andi	a4,a4,127
    80005cae:	97ba                	add	a5,a5,a4
    80005cb0:	4729                	li	a4,10
    80005cb2:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005cb6:	0001b797          	auipc	a5,0x1b
    80005cba:	52c7a323          	sw	a2,1318(a5) # 800211dc <cons+0x9c>
        wakeup(&cons.r);
    80005cbe:	0001b517          	auipc	a0,0x1b
    80005cc2:	51a50513          	addi	a0,a0,1306 # 800211d8 <cons+0x98>
    80005cc6:	ffffc097          	auipc	ra,0xffffc
    80005cca:	9ce080e7          	jalr	-1586(ra) # 80001694 <wakeup>
    80005cce:	b575                	j	80005b7a <consoleintr+0x3c>

0000000080005cd0 <consoleinit>:

void
consoleinit(void)
{
    80005cd0:	1141                	addi	sp,sp,-16
    80005cd2:	e406                	sd	ra,8(sp)
    80005cd4:	e022                	sd	s0,0(sp)
    80005cd6:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005cd8:	00003597          	auipc	a1,0x3
    80005cdc:	ac058593          	addi	a1,a1,-1344 # 80008798 <syscalls+0x3d0>
    80005ce0:	0001b517          	auipc	a0,0x1b
    80005ce4:	46050513          	addi	a0,a0,1120 # 80021140 <cons>
    80005ce8:	00000097          	auipc	ra,0x0
    80005cec:	580080e7          	jalr	1408(ra) # 80006268 <initlock>

  uartinit();
    80005cf0:	00000097          	auipc	ra,0x0
    80005cf4:	32c080e7          	jalr	812(ra) # 8000601c <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005cf8:	0000e797          	auipc	a5,0xe
    80005cfc:	7e078793          	addi	a5,a5,2016 # 800144d8 <devsw>
    80005d00:	00000717          	auipc	a4,0x0
    80005d04:	cea70713          	addi	a4,a4,-790 # 800059ea <consoleread>
    80005d08:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005d0a:	00000717          	auipc	a4,0x0
    80005d0e:	c7c70713          	addi	a4,a4,-900 # 80005986 <consolewrite>
    80005d12:	ef98                	sd	a4,24(a5)
}
    80005d14:	60a2                	ld	ra,8(sp)
    80005d16:	6402                	ld	s0,0(sp)
    80005d18:	0141                	addi	sp,sp,16
    80005d1a:	8082                	ret

0000000080005d1c <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005d1c:	7179                	addi	sp,sp,-48
    80005d1e:	f406                	sd	ra,40(sp)
    80005d20:	f022                	sd	s0,32(sp)
    80005d22:	ec26                	sd	s1,24(sp)
    80005d24:	e84a                	sd	s2,16(sp)
    80005d26:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005d28:	c219                	beqz	a2,80005d2e <printint+0x12>
    80005d2a:	08054763          	bltz	a0,80005db8 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005d2e:	2501                	sext.w	a0,a0
    80005d30:	4881                	li	a7,0
    80005d32:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005d36:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005d38:	2581                	sext.w	a1,a1
    80005d3a:	00003617          	auipc	a2,0x3
    80005d3e:	a8e60613          	addi	a2,a2,-1394 # 800087c8 <digits>
    80005d42:	883a                	mv	a6,a4
    80005d44:	2705                	addiw	a4,a4,1
    80005d46:	02b577bb          	remuw	a5,a0,a1
    80005d4a:	1782                	slli	a5,a5,0x20
    80005d4c:	9381                	srli	a5,a5,0x20
    80005d4e:	97b2                	add	a5,a5,a2
    80005d50:	0007c783          	lbu	a5,0(a5)
    80005d54:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005d58:	0005079b          	sext.w	a5,a0
    80005d5c:	02b5553b          	divuw	a0,a0,a1
    80005d60:	0685                	addi	a3,a3,1
    80005d62:	feb7f0e3          	bgeu	a5,a1,80005d42 <printint+0x26>

  if(sign)
    80005d66:	00088c63          	beqz	a7,80005d7e <printint+0x62>
    buf[i++] = '-';
    80005d6a:	fe070793          	addi	a5,a4,-32
    80005d6e:	00878733          	add	a4,a5,s0
    80005d72:	02d00793          	li	a5,45
    80005d76:	fef70823          	sb	a5,-16(a4)
    80005d7a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005d7e:	02e05763          	blez	a4,80005dac <printint+0x90>
    80005d82:	fd040793          	addi	a5,s0,-48
    80005d86:	00e784b3          	add	s1,a5,a4
    80005d8a:	fff78913          	addi	s2,a5,-1
    80005d8e:	993a                	add	s2,s2,a4
    80005d90:	377d                	addiw	a4,a4,-1
    80005d92:	1702                	slli	a4,a4,0x20
    80005d94:	9301                	srli	a4,a4,0x20
    80005d96:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005d9a:	fff4c503          	lbu	a0,-1(s1)
    80005d9e:	00000097          	auipc	ra,0x0
    80005da2:	d5e080e7          	jalr	-674(ra) # 80005afc <consputc>
  while(--i >= 0)
    80005da6:	14fd                	addi	s1,s1,-1
    80005da8:	ff2499e3          	bne	s1,s2,80005d9a <printint+0x7e>
}
    80005dac:	70a2                	ld	ra,40(sp)
    80005dae:	7402                	ld	s0,32(sp)
    80005db0:	64e2                	ld	s1,24(sp)
    80005db2:	6942                	ld	s2,16(sp)
    80005db4:	6145                	addi	sp,sp,48
    80005db6:	8082                	ret
    x = -xx;
    80005db8:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005dbc:	4885                	li	a7,1
    x = -xx;
    80005dbe:	bf95                	j	80005d32 <printint+0x16>

0000000080005dc0 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005dc0:	1101                	addi	sp,sp,-32
    80005dc2:	ec06                	sd	ra,24(sp)
    80005dc4:	e822                	sd	s0,16(sp)
    80005dc6:	e426                	sd	s1,8(sp)
    80005dc8:	1000                	addi	s0,sp,32
    80005dca:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005dcc:	0001b797          	auipc	a5,0x1b
    80005dd0:	4207aa23          	sw	zero,1076(a5) # 80021200 <pr+0x18>
  printf("panic: ");
    80005dd4:	00003517          	auipc	a0,0x3
    80005dd8:	9cc50513          	addi	a0,a0,-1588 # 800087a0 <syscalls+0x3d8>
    80005ddc:	00000097          	auipc	ra,0x0
    80005de0:	02e080e7          	jalr	46(ra) # 80005e0a <printf>
  printf(s);
    80005de4:	8526                	mv	a0,s1
    80005de6:	00000097          	auipc	ra,0x0
    80005dea:	024080e7          	jalr	36(ra) # 80005e0a <printf>
  printf("\n");
    80005dee:	00002517          	auipc	a0,0x2
    80005df2:	25a50513          	addi	a0,a0,602 # 80008048 <etext+0x48>
    80005df6:	00000097          	auipc	ra,0x0
    80005dfa:	014080e7          	jalr	20(ra) # 80005e0a <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005dfe:	4785                	li	a5,1
    80005e00:	00003717          	auipc	a4,0x3
    80005e04:	20f72e23          	sw	a5,540(a4) # 8000901c <panicked>
  for(;;)
    80005e08:	a001                	j	80005e08 <panic+0x48>

0000000080005e0a <printf>:
{
    80005e0a:	7131                	addi	sp,sp,-192
    80005e0c:	fc86                	sd	ra,120(sp)
    80005e0e:	f8a2                	sd	s0,112(sp)
    80005e10:	f4a6                	sd	s1,104(sp)
    80005e12:	f0ca                	sd	s2,96(sp)
    80005e14:	ecce                	sd	s3,88(sp)
    80005e16:	e8d2                	sd	s4,80(sp)
    80005e18:	e4d6                	sd	s5,72(sp)
    80005e1a:	e0da                	sd	s6,64(sp)
    80005e1c:	fc5e                	sd	s7,56(sp)
    80005e1e:	f862                	sd	s8,48(sp)
    80005e20:	f466                	sd	s9,40(sp)
    80005e22:	f06a                	sd	s10,32(sp)
    80005e24:	ec6e                	sd	s11,24(sp)
    80005e26:	0100                	addi	s0,sp,128
    80005e28:	8a2a                	mv	s4,a0
    80005e2a:	e40c                	sd	a1,8(s0)
    80005e2c:	e810                	sd	a2,16(s0)
    80005e2e:	ec14                	sd	a3,24(s0)
    80005e30:	f018                	sd	a4,32(s0)
    80005e32:	f41c                	sd	a5,40(s0)
    80005e34:	03043823          	sd	a6,48(s0)
    80005e38:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005e3c:	0001bd97          	auipc	s11,0x1b
    80005e40:	3c4dad83          	lw	s11,964(s11) # 80021200 <pr+0x18>
  if(locking)
    80005e44:	020d9b63          	bnez	s11,80005e7a <printf+0x70>
  if (fmt == 0)
    80005e48:	040a0263          	beqz	s4,80005e8c <printf+0x82>
  va_start(ap, fmt);
    80005e4c:	00840793          	addi	a5,s0,8
    80005e50:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e54:	000a4503          	lbu	a0,0(s4)
    80005e58:	14050f63          	beqz	a0,80005fb6 <printf+0x1ac>
    80005e5c:	4981                	li	s3,0
    if(c != '%'){
    80005e5e:	02500a93          	li	s5,37
    switch(c){
    80005e62:	07000b93          	li	s7,112
  consputc('x');
    80005e66:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e68:	00003b17          	auipc	s6,0x3
    80005e6c:	960b0b13          	addi	s6,s6,-1696 # 800087c8 <digits>
    switch(c){
    80005e70:	07300c93          	li	s9,115
    80005e74:	06400c13          	li	s8,100
    80005e78:	a82d                	j	80005eb2 <printf+0xa8>
    acquire(&pr.lock);
    80005e7a:	0001b517          	auipc	a0,0x1b
    80005e7e:	36e50513          	addi	a0,a0,878 # 800211e8 <pr>
    80005e82:	00000097          	auipc	ra,0x0
    80005e86:	476080e7          	jalr	1142(ra) # 800062f8 <acquire>
    80005e8a:	bf7d                	j	80005e48 <printf+0x3e>
    panic("null fmt");
    80005e8c:	00003517          	auipc	a0,0x3
    80005e90:	92450513          	addi	a0,a0,-1756 # 800087b0 <syscalls+0x3e8>
    80005e94:	00000097          	auipc	ra,0x0
    80005e98:	f2c080e7          	jalr	-212(ra) # 80005dc0 <panic>
      consputc(c);
    80005e9c:	00000097          	auipc	ra,0x0
    80005ea0:	c60080e7          	jalr	-928(ra) # 80005afc <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005ea4:	2985                	addiw	s3,s3,1
    80005ea6:	013a07b3          	add	a5,s4,s3
    80005eaa:	0007c503          	lbu	a0,0(a5)
    80005eae:	10050463          	beqz	a0,80005fb6 <printf+0x1ac>
    if(c != '%'){
    80005eb2:	ff5515e3          	bne	a0,s5,80005e9c <printf+0x92>
    c = fmt[++i] & 0xff;
    80005eb6:	2985                	addiw	s3,s3,1
    80005eb8:	013a07b3          	add	a5,s4,s3
    80005ebc:	0007c783          	lbu	a5,0(a5)
    80005ec0:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005ec4:	cbed                	beqz	a5,80005fb6 <printf+0x1ac>
    switch(c){
    80005ec6:	05778a63          	beq	a5,s7,80005f1a <printf+0x110>
    80005eca:	02fbf663          	bgeu	s7,a5,80005ef6 <printf+0xec>
    80005ece:	09978863          	beq	a5,s9,80005f5e <printf+0x154>
    80005ed2:	07800713          	li	a4,120
    80005ed6:	0ce79563          	bne	a5,a4,80005fa0 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005eda:	f8843783          	ld	a5,-120(s0)
    80005ede:	00878713          	addi	a4,a5,8
    80005ee2:	f8e43423          	sd	a4,-120(s0)
    80005ee6:	4605                	li	a2,1
    80005ee8:	85ea                	mv	a1,s10
    80005eea:	4388                	lw	a0,0(a5)
    80005eec:	00000097          	auipc	ra,0x0
    80005ef0:	e30080e7          	jalr	-464(ra) # 80005d1c <printint>
      break;
    80005ef4:	bf45                	j	80005ea4 <printf+0x9a>
    switch(c){
    80005ef6:	09578f63          	beq	a5,s5,80005f94 <printf+0x18a>
    80005efa:	0b879363          	bne	a5,s8,80005fa0 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005efe:	f8843783          	ld	a5,-120(s0)
    80005f02:	00878713          	addi	a4,a5,8
    80005f06:	f8e43423          	sd	a4,-120(s0)
    80005f0a:	4605                	li	a2,1
    80005f0c:	45a9                	li	a1,10
    80005f0e:	4388                	lw	a0,0(a5)
    80005f10:	00000097          	auipc	ra,0x0
    80005f14:	e0c080e7          	jalr	-500(ra) # 80005d1c <printint>
      break;
    80005f18:	b771                	j	80005ea4 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005f1a:	f8843783          	ld	a5,-120(s0)
    80005f1e:	00878713          	addi	a4,a5,8
    80005f22:	f8e43423          	sd	a4,-120(s0)
    80005f26:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005f2a:	03000513          	li	a0,48
    80005f2e:	00000097          	auipc	ra,0x0
    80005f32:	bce080e7          	jalr	-1074(ra) # 80005afc <consputc>
  consputc('x');
    80005f36:	07800513          	li	a0,120
    80005f3a:	00000097          	auipc	ra,0x0
    80005f3e:	bc2080e7          	jalr	-1086(ra) # 80005afc <consputc>
    80005f42:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f44:	03c95793          	srli	a5,s2,0x3c
    80005f48:	97da                	add	a5,a5,s6
    80005f4a:	0007c503          	lbu	a0,0(a5)
    80005f4e:	00000097          	auipc	ra,0x0
    80005f52:	bae080e7          	jalr	-1106(ra) # 80005afc <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005f56:	0912                	slli	s2,s2,0x4
    80005f58:	34fd                	addiw	s1,s1,-1
    80005f5a:	f4ed                	bnez	s1,80005f44 <printf+0x13a>
    80005f5c:	b7a1                	j	80005ea4 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005f5e:	f8843783          	ld	a5,-120(s0)
    80005f62:	00878713          	addi	a4,a5,8
    80005f66:	f8e43423          	sd	a4,-120(s0)
    80005f6a:	6384                	ld	s1,0(a5)
    80005f6c:	cc89                	beqz	s1,80005f86 <printf+0x17c>
      for(; *s; s++)
    80005f6e:	0004c503          	lbu	a0,0(s1)
    80005f72:	d90d                	beqz	a0,80005ea4 <printf+0x9a>
        consputc(*s);
    80005f74:	00000097          	auipc	ra,0x0
    80005f78:	b88080e7          	jalr	-1144(ra) # 80005afc <consputc>
      for(; *s; s++)
    80005f7c:	0485                	addi	s1,s1,1
    80005f7e:	0004c503          	lbu	a0,0(s1)
    80005f82:	f96d                	bnez	a0,80005f74 <printf+0x16a>
    80005f84:	b705                	j	80005ea4 <printf+0x9a>
        s = "(null)";
    80005f86:	00003497          	auipc	s1,0x3
    80005f8a:	82248493          	addi	s1,s1,-2014 # 800087a8 <syscalls+0x3e0>
      for(; *s; s++)
    80005f8e:	02800513          	li	a0,40
    80005f92:	b7cd                	j	80005f74 <printf+0x16a>
      consputc('%');
    80005f94:	8556                	mv	a0,s5
    80005f96:	00000097          	auipc	ra,0x0
    80005f9a:	b66080e7          	jalr	-1178(ra) # 80005afc <consputc>
      break;
    80005f9e:	b719                	j	80005ea4 <printf+0x9a>
      consputc('%');
    80005fa0:	8556                	mv	a0,s5
    80005fa2:	00000097          	auipc	ra,0x0
    80005fa6:	b5a080e7          	jalr	-1190(ra) # 80005afc <consputc>
      consputc(c);
    80005faa:	8526                	mv	a0,s1
    80005fac:	00000097          	auipc	ra,0x0
    80005fb0:	b50080e7          	jalr	-1200(ra) # 80005afc <consputc>
      break;
    80005fb4:	bdc5                	j	80005ea4 <printf+0x9a>
  if(locking)
    80005fb6:	020d9163          	bnez	s11,80005fd8 <printf+0x1ce>
}
    80005fba:	70e6                	ld	ra,120(sp)
    80005fbc:	7446                	ld	s0,112(sp)
    80005fbe:	74a6                	ld	s1,104(sp)
    80005fc0:	7906                	ld	s2,96(sp)
    80005fc2:	69e6                	ld	s3,88(sp)
    80005fc4:	6a46                	ld	s4,80(sp)
    80005fc6:	6aa6                	ld	s5,72(sp)
    80005fc8:	6b06                	ld	s6,64(sp)
    80005fca:	7be2                	ld	s7,56(sp)
    80005fcc:	7c42                	ld	s8,48(sp)
    80005fce:	7ca2                	ld	s9,40(sp)
    80005fd0:	7d02                	ld	s10,32(sp)
    80005fd2:	6de2                	ld	s11,24(sp)
    80005fd4:	6129                	addi	sp,sp,192
    80005fd6:	8082                	ret
    release(&pr.lock);
    80005fd8:	0001b517          	auipc	a0,0x1b
    80005fdc:	21050513          	addi	a0,a0,528 # 800211e8 <pr>
    80005fe0:	00000097          	auipc	ra,0x0
    80005fe4:	3cc080e7          	jalr	972(ra) # 800063ac <release>
}
    80005fe8:	bfc9                	j	80005fba <printf+0x1b0>

0000000080005fea <printfinit>:
    ;
}

void
printfinit(void)
{
    80005fea:	1101                	addi	sp,sp,-32
    80005fec:	ec06                	sd	ra,24(sp)
    80005fee:	e822                	sd	s0,16(sp)
    80005ff0:	e426                	sd	s1,8(sp)
    80005ff2:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005ff4:	0001b497          	auipc	s1,0x1b
    80005ff8:	1f448493          	addi	s1,s1,500 # 800211e8 <pr>
    80005ffc:	00002597          	auipc	a1,0x2
    80006000:	7c458593          	addi	a1,a1,1988 # 800087c0 <syscalls+0x3f8>
    80006004:	8526                	mv	a0,s1
    80006006:	00000097          	auipc	ra,0x0
    8000600a:	262080e7          	jalr	610(ra) # 80006268 <initlock>
  pr.locking = 1;
    8000600e:	4785                	li	a5,1
    80006010:	cc9c                	sw	a5,24(s1)
}
    80006012:	60e2                	ld	ra,24(sp)
    80006014:	6442                	ld	s0,16(sp)
    80006016:	64a2                	ld	s1,8(sp)
    80006018:	6105                	addi	sp,sp,32
    8000601a:	8082                	ret

000000008000601c <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000601c:	1141                	addi	sp,sp,-16
    8000601e:	e406                	sd	ra,8(sp)
    80006020:	e022                	sd	s0,0(sp)
    80006022:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006024:	100007b7          	lui	a5,0x10000
    80006028:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000602c:	f8000713          	li	a4,-128
    80006030:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006034:	470d                	li	a4,3
    80006036:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    8000603a:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000603e:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006042:	469d                	li	a3,7
    80006044:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006048:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000604c:	00002597          	auipc	a1,0x2
    80006050:	79458593          	addi	a1,a1,1940 # 800087e0 <digits+0x18>
    80006054:	0001b517          	auipc	a0,0x1b
    80006058:	1b450513          	addi	a0,a0,436 # 80021208 <uart_tx_lock>
    8000605c:	00000097          	auipc	ra,0x0
    80006060:	20c080e7          	jalr	524(ra) # 80006268 <initlock>
}
    80006064:	60a2                	ld	ra,8(sp)
    80006066:	6402                	ld	s0,0(sp)
    80006068:	0141                	addi	sp,sp,16
    8000606a:	8082                	ret

000000008000606c <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000606c:	1101                	addi	sp,sp,-32
    8000606e:	ec06                	sd	ra,24(sp)
    80006070:	e822                	sd	s0,16(sp)
    80006072:	e426                	sd	s1,8(sp)
    80006074:	1000                	addi	s0,sp,32
    80006076:	84aa                	mv	s1,a0
  push_off();
    80006078:	00000097          	auipc	ra,0x0
    8000607c:	234080e7          	jalr	564(ra) # 800062ac <push_off>

  if(panicked){
    80006080:	00003797          	auipc	a5,0x3
    80006084:	f9c7a783          	lw	a5,-100(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006088:	10000737          	lui	a4,0x10000
  if(panicked){
    8000608c:	c391                	beqz	a5,80006090 <uartputc_sync+0x24>
    for(;;)
    8000608e:	a001                	j	8000608e <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006090:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006094:	0207f793          	andi	a5,a5,32
    80006098:	dfe5                	beqz	a5,80006090 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000609a:	0ff4f513          	zext.b	a0,s1
    8000609e:	100007b7          	lui	a5,0x10000
    800060a2:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    800060a6:	00000097          	auipc	ra,0x0
    800060aa:	2a6080e7          	jalr	678(ra) # 8000634c <pop_off>
}
    800060ae:	60e2                	ld	ra,24(sp)
    800060b0:	6442                	ld	s0,16(sp)
    800060b2:	64a2                	ld	s1,8(sp)
    800060b4:	6105                	addi	sp,sp,32
    800060b6:	8082                	ret

00000000800060b8 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800060b8:	00003797          	auipc	a5,0x3
    800060bc:	f687b783          	ld	a5,-152(a5) # 80009020 <uart_tx_r>
    800060c0:	00003717          	auipc	a4,0x3
    800060c4:	f6873703          	ld	a4,-152(a4) # 80009028 <uart_tx_w>
    800060c8:	06f70a63          	beq	a4,a5,8000613c <uartstart+0x84>
{
    800060cc:	7139                	addi	sp,sp,-64
    800060ce:	fc06                	sd	ra,56(sp)
    800060d0:	f822                	sd	s0,48(sp)
    800060d2:	f426                	sd	s1,40(sp)
    800060d4:	f04a                	sd	s2,32(sp)
    800060d6:	ec4e                	sd	s3,24(sp)
    800060d8:	e852                	sd	s4,16(sp)
    800060da:	e456                	sd	s5,8(sp)
    800060dc:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800060de:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800060e2:	0001ba17          	auipc	s4,0x1b
    800060e6:	126a0a13          	addi	s4,s4,294 # 80021208 <uart_tx_lock>
    uart_tx_r += 1;
    800060ea:	00003497          	auipc	s1,0x3
    800060ee:	f3648493          	addi	s1,s1,-202 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    800060f2:	00003997          	auipc	s3,0x3
    800060f6:	f3698993          	addi	s3,s3,-202 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800060fa:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    800060fe:	02077713          	andi	a4,a4,32
    80006102:	c705                	beqz	a4,8000612a <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006104:	01f7f713          	andi	a4,a5,31
    80006108:	9752                	add	a4,a4,s4
    8000610a:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    8000610e:	0785                	addi	a5,a5,1
    80006110:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006112:	8526                	mv	a0,s1
    80006114:	ffffb097          	auipc	ra,0xffffb
    80006118:	580080e7          	jalr	1408(ra) # 80001694 <wakeup>
    
    WriteReg(THR, c);
    8000611c:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006120:	609c                	ld	a5,0(s1)
    80006122:	0009b703          	ld	a4,0(s3)
    80006126:	fcf71ae3          	bne	a4,a5,800060fa <uartstart+0x42>
  }
}
    8000612a:	70e2                	ld	ra,56(sp)
    8000612c:	7442                	ld	s0,48(sp)
    8000612e:	74a2                	ld	s1,40(sp)
    80006130:	7902                	ld	s2,32(sp)
    80006132:	69e2                	ld	s3,24(sp)
    80006134:	6a42                	ld	s4,16(sp)
    80006136:	6aa2                	ld	s5,8(sp)
    80006138:	6121                	addi	sp,sp,64
    8000613a:	8082                	ret
    8000613c:	8082                	ret

000000008000613e <uartputc>:
{
    8000613e:	7179                	addi	sp,sp,-48
    80006140:	f406                	sd	ra,40(sp)
    80006142:	f022                	sd	s0,32(sp)
    80006144:	ec26                	sd	s1,24(sp)
    80006146:	e84a                	sd	s2,16(sp)
    80006148:	e44e                	sd	s3,8(sp)
    8000614a:	e052                	sd	s4,0(sp)
    8000614c:	1800                	addi	s0,sp,48
    8000614e:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006150:	0001b517          	auipc	a0,0x1b
    80006154:	0b850513          	addi	a0,a0,184 # 80021208 <uart_tx_lock>
    80006158:	00000097          	auipc	ra,0x0
    8000615c:	1a0080e7          	jalr	416(ra) # 800062f8 <acquire>
  if(panicked){
    80006160:	00003797          	auipc	a5,0x3
    80006164:	ebc7a783          	lw	a5,-324(a5) # 8000901c <panicked>
    80006168:	c391                	beqz	a5,8000616c <uartputc+0x2e>
    for(;;)
    8000616a:	a001                	j	8000616a <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000616c:	00003717          	auipc	a4,0x3
    80006170:	ebc73703          	ld	a4,-324(a4) # 80009028 <uart_tx_w>
    80006174:	00003797          	auipc	a5,0x3
    80006178:	eac7b783          	ld	a5,-340(a5) # 80009020 <uart_tx_r>
    8000617c:	02078793          	addi	a5,a5,32
    80006180:	02e79b63          	bne	a5,a4,800061b6 <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006184:	0001b997          	auipc	s3,0x1b
    80006188:	08498993          	addi	s3,s3,132 # 80021208 <uart_tx_lock>
    8000618c:	00003497          	auipc	s1,0x3
    80006190:	e9448493          	addi	s1,s1,-364 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006194:	00003917          	auipc	s2,0x3
    80006198:	e9490913          	addi	s2,s2,-364 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000619c:	85ce                	mv	a1,s3
    8000619e:	8526                	mv	a0,s1
    800061a0:	ffffb097          	auipc	ra,0xffffb
    800061a4:	368080e7          	jalr	872(ra) # 80001508 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800061a8:	00093703          	ld	a4,0(s2)
    800061ac:	609c                	ld	a5,0(s1)
    800061ae:	02078793          	addi	a5,a5,32
    800061b2:	fee785e3          	beq	a5,a4,8000619c <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800061b6:	0001b497          	auipc	s1,0x1b
    800061ba:	05248493          	addi	s1,s1,82 # 80021208 <uart_tx_lock>
    800061be:	01f77793          	andi	a5,a4,31
    800061c2:	97a6                	add	a5,a5,s1
    800061c4:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    800061c8:	0705                	addi	a4,a4,1
    800061ca:	00003797          	auipc	a5,0x3
    800061ce:	e4e7bf23          	sd	a4,-418(a5) # 80009028 <uart_tx_w>
      uartstart();
    800061d2:	00000097          	auipc	ra,0x0
    800061d6:	ee6080e7          	jalr	-282(ra) # 800060b8 <uartstart>
      release(&uart_tx_lock);
    800061da:	8526                	mv	a0,s1
    800061dc:	00000097          	auipc	ra,0x0
    800061e0:	1d0080e7          	jalr	464(ra) # 800063ac <release>
}
    800061e4:	70a2                	ld	ra,40(sp)
    800061e6:	7402                	ld	s0,32(sp)
    800061e8:	64e2                	ld	s1,24(sp)
    800061ea:	6942                	ld	s2,16(sp)
    800061ec:	69a2                	ld	s3,8(sp)
    800061ee:	6a02                	ld	s4,0(sp)
    800061f0:	6145                	addi	sp,sp,48
    800061f2:	8082                	ret

00000000800061f4 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800061f4:	1141                	addi	sp,sp,-16
    800061f6:	e422                	sd	s0,8(sp)
    800061f8:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800061fa:	100007b7          	lui	a5,0x10000
    800061fe:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006202:	8b85                	andi	a5,a5,1
    80006204:	cb81                	beqz	a5,80006214 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    80006206:	100007b7          	lui	a5,0x10000
    8000620a:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000620e:	6422                	ld	s0,8(sp)
    80006210:	0141                	addi	sp,sp,16
    80006212:	8082                	ret
    return -1;
    80006214:	557d                	li	a0,-1
    80006216:	bfe5                	j	8000620e <uartgetc+0x1a>

0000000080006218 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006218:	1101                	addi	sp,sp,-32
    8000621a:	ec06                	sd	ra,24(sp)
    8000621c:	e822                	sd	s0,16(sp)
    8000621e:	e426                	sd	s1,8(sp)
    80006220:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006222:	54fd                	li	s1,-1
    80006224:	a029                	j	8000622e <uartintr+0x16>
      break;
    consoleintr(c);
    80006226:	00000097          	auipc	ra,0x0
    8000622a:	918080e7          	jalr	-1768(ra) # 80005b3e <consoleintr>
    int c = uartgetc();
    8000622e:	00000097          	auipc	ra,0x0
    80006232:	fc6080e7          	jalr	-58(ra) # 800061f4 <uartgetc>
    if(c == -1)
    80006236:	fe9518e3          	bne	a0,s1,80006226 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000623a:	0001b497          	auipc	s1,0x1b
    8000623e:	fce48493          	addi	s1,s1,-50 # 80021208 <uart_tx_lock>
    80006242:	8526                	mv	a0,s1
    80006244:	00000097          	auipc	ra,0x0
    80006248:	0b4080e7          	jalr	180(ra) # 800062f8 <acquire>
  uartstart();
    8000624c:	00000097          	auipc	ra,0x0
    80006250:	e6c080e7          	jalr	-404(ra) # 800060b8 <uartstart>
  release(&uart_tx_lock);
    80006254:	8526                	mv	a0,s1
    80006256:	00000097          	auipc	ra,0x0
    8000625a:	156080e7          	jalr	342(ra) # 800063ac <release>
}
    8000625e:	60e2                	ld	ra,24(sp)
    80006260:	6442                	ld	s0,16(sp)
    80006262:	64a2                	ld	s1,8(sp)
    80006264:	6105                	addi	sp,sp,32
    80006266:	8082                	ret

0000000080006268 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006268:	1141                	addi	sp,sp,-16
    8000626a:	e422                	sd	s0,8(sp)
    8000626c:	0800                	addi	s0,sp,16
  lk->name = name;
    8000626e:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006270:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006274:	00053823          	sd	zero,16(a0)
}
    80006278:	6422                	ld	s0,8(sp)
    8000627a:	0141                	addi	sp,sp,16
    8000627c:	8082                	ret

000000008000627e <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000627e:	411c                	lw	a5,0(a0)
    80006280:	e399                	bnez	a5,80006286 <holding+0x8>
    80006282:	4501                	li	a0,0
  return r;
}
    80006284:	8082                	ret
{
    80006286:	1101                	addi	sp,sp,-32
    80006288:	ec06                	sd	ra,24(sp)
    8000628a:	e822                	sd	s0,16(sp)
    8000628c:	e426                	sd	s1,8(sp)
    8000628e:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006290:	6904                	ld	s1,16(a0)
    80006292:	ffffb097          	auipc	ra,0xffffb
    80006296:	b96080e7          	jalr	-1130(ra) # 80000e28 <mycpu>
    8000629a:	40a48533          	sub	a0,s1,a0
    8000629e:	00153513          	seqz	a0,a0
}
    800062a2:	60e2                	ld	ra,24(sp)
    800062a4:	6442                	ld	s0,16(sp)
    800062a6:	64a2                	ld	s1,8(sp)
    800062a8:	6105                	addi	sp,sp,32
    800062aa:	8082                	ret

00000000800062ac <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800062ac:	1101                	addi	sp,sp,-32
    800062ae:	ec06                	sd	ra,24(sp)
    800062b0:	e822                	sd	s0,16(sp)
    800062b2:	e426                	sd	s1,8(sp)
    800062b4:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800062b6:	100024f3          	csrr	s1,sstatus
    800062ba:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800062be:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800062c0:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800062c4:	ffffb097          	auipc	ra,0xffffb
    800062c8:	b64080e7          	jalr	-1180(ra) # 80000e28 <mycpu>
    800062cc:	5d3c                	lw	a5,120(a0)
    800062ce:	cf89                	beqz	a5,800062e8 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800062d0:	ffffb097          	auipc	ra,0xffffb
    800062d4:	b58080e7          	jalr	-1192(ra) # 80000e28 <mycpu>
    800062d8:	5d3c                	lw	a5,120(a0)
    800062da:	2785                	addiw	a5,a5,1
    800062dc:	dd3c                	sw	a5,120(a0)
}
    800062de:	60e2                	ld	ra,24(sp)
    800062e0:	6442                	ld	s0,16(sp)
    800062e2:	64a2                	ld	s1,8(sp)
    800062e4:	6105                	addi	sp,sp,32
    800062e6:	8082                	ret
    mycpu()->intena = old;
    800062e8:	ffffb097          	auipc	ra,0xffffb
    800062ec:	b40080e7          	jalr	-1216(ra) # 80000e28 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800062f0:	8085                	srli	s1,s1,0x1
    800062f2:	8885                	andi	s1,s1,1
    800062f4:	dd64                	sw	s1,124(a0)
    800062f6:	bfe9                	j	800062d0 <push_off+0x24>

00000000800062f8 <acquire>:
{
    800062f8:	1101                	addi	sp,sp,-32
    800062fa:	ec06                	sd	ra,24(sp)
    800062fc:	e822                	sd	s0,16(sp)
    800062fe:	e426                	sd	s1,8(sp)
    80006300:	1000                	addi	s0,sp,32
    80006302:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006304:	00000097          	auipc	ra,0x0
    80006308:	fa8080e7          	jalr	-88(ra) # 800062ac <push_off>
  if(holding(lk))
    8000630c:	8526                	mv	a0,s1
    8000630e:	00000097          	auipc	ra,0x0
    80006312:	f70080e7          	jalr	-144(ra) # 8000627e <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006316:	4705                	li	a4,1
  if(holding(lk))
    80006318:	e115                	bnez	a0,8000633c <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000631a:	87ba                	mv	a5,a4
    8000631c:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006320:	2781                	sext.w	a5,a5
    80006322:	ffe5                	bnez	a5,8000631a <acquire+0x22>
  __sync_synchronize();
    80006324:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006328:	ffffb097          	auipc	ra,0xffffb
    8000632c:	b00080e7          	jalr	-1280(ra) # 80000e28 <mycpu>
    80006330:	e888                	sd	a0,16(s1)
}
    80006332:	60e2                	ld	ra,24(sp)
    80006334:	6442                	ld	s0,16(sp)
    80006336:	64a2                	ld	s1,8(sp)
    80006338:	6105                	addi	sp,sp,32
    8000633a:	8082                	ret
    panic("acquire");
    8000633c:	00002517          	auipc	a0,0x2
    80006340:	4ac50513          	addi	a0,a0,1196 # 800087e8 <digits+0x20>
    80006344:	00000097          	auipc	ra,0x0
    80006348:	a7c080e7          	jalr	-1412(ra) # 80005dc0 <panic>

000000008000634c <pop_off>:

void
pop_off(void)
{
    8000634c:	1141                	addi	sp,sp,-16
    8000634e:	e406                	sd	ra,8(sp)
    80006350:	e022                	sd	s0,0(sp)
    80006352:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006354:	ffffb097          	auipc	ra,0xffffb
    80006358:	ad4080e7          	jalr	-1324(ra) # 80000e28 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000635c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006360:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006362:	e78d                	bnez	a5,8000638c <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006364:	5d3c                	lw	a5,120(a0)
    80006366:	02f05b63          	blez	a5,8000639c <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    8000636a:	37fd                	addiw	a5,a5,-1
    8000636c:	0007871b          	sext.w	a4,a5
    80006370:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006372:	eb09                	bnez	a4,80006384 <pop_off+0x38>
    80006374:	5d7c                	lw	a5,124(a0)
    80006376:	c799                	beqz	a5,80006384 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006378:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000637c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006380:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006384:	60a2                	ld	ra,8(sp)
    80006386:	6402                	ld	s0,0(sp)
    80006388:	0141                	addi	sp,sp,16
    8000638a:	8082                	ret
    panic("pop_off - interruptible");
    8000638c:	00002517          	auipc	a0,0x2
    80006390:	46450513          	addi	a0,a0,1124 # 800087f0 <digits+0x28>
    80006394:	00000097          	auipc	ra,0x0
    80006398:	a2c080e7          	jalr	-1492(ra) # 80005dc0 <panic>
    panic("pop_off");
    8000639c:	00002517          	auipc	a0,0x2
    800063a0:	46c50513          	addi	a0,a0,1132 # 80008808 <digits+0x40>
    800063a4:	00000097          	auipc	ra,0x0
    800063a8:	a1c080e7          	jalr	-1508(ra) # 80005dc0 <panic>

00000000800063ac <release>:
{
    800063ac:	1101                	addi	sp,sp,-32
    800063ae:	ec06                	sd	ra,24(sp)
    800063b0:	e822                	sd	s0,16(sp)
    800063b2:	e426                	sd	s1,8(sp)
    800063b4:	1000                	addi	s0,sp,32
    800063b6:	84aa                	mv	s1,a0
  if(!holding(lk))
    800063b8:	00000097          	auipc	ra,0x0
    800063bc:	ec6080e7          	jalr	-314(ra) # 8000627e <holding>
    800063c0:	c115                	beqz	a0,800063e4 <release+0x38>
  lk->cpu = 0;
    800063c2:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800063c6:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800063ca:	0f50000f          	fence	iorw,ow
    800063ce:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800063d2:	00000097          	auipc	ra,0x0
    800063d6:	f7a080e7          	jalr	-134(ra) # 8000634c <pop_off>
}
    800063da:	60e2                	ld	ra,24(sp)
    800063dc:	6442                	ld	s0,16(sp)
    800063de:	64a2                	ld	s1,8(sp)
    800063e0:	6105                	addi	sp,sp,32
    800063e2:	8082                	ret
    panic("release");
    800063e4:	00002517          	auipc	a0,0x2
    800063e8:	42c50513          	addi	a0,a0,1068 # 80008810 <digits+0x48>
    800063ec:	00000097          	auipc	ra,0x0
    800063f0:	9d4080e7          	jalr	-1580(ra) # 80005dc0 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
