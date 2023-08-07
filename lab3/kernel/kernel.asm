
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	92013103          	ld	sp,-1760(sp) # 80008920 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	0dd050ef          	jal	ra,800058f2 <start>

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
    80000030:	00026797          	auipc	a5,0x26
    80000034:	21078793          	addi	a5,a5,528 # 80026240 <end>
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
    8000005e:	27e080e7          	jalr	638(ra) # 800062d8 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	31e080e7          	jalr	798(ra) # 8000638c <release>
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
    8000008e:	d16080e7          	jalr	-746(ra) # 80005da0 <panic>

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
    800000fa:	152080e7          	jalr	338(ra) # 80006248 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	slli	a1,a1,0x1b
    80000102:	00026517          	auipc	a0,0x26
    80000106:	13e50513          	addi	a0,a0,318 # 80026240 <end>
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
    80000132:	1aa080e7          	jalr	426(ra) # 800062d8 <acquire>
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
    8000014a:	246080e7          	jalr	582(ra) # 8000638c <release>

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
    80000174:	21c080e7          	jalr	540(ra) # 8000638c <release>
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
    800001ee:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffd8dc1>
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
    8000032c:	be2080e7          	jalr	-1054(ra) # 80000f0a <cpuid>
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
    80000348:	bc6080e7          	jalr	-1082(ra) # 80000f0a <cpuid>
    8000034c:	85aa                	mv	a1,a0
    8000034e:	00008517          	auipc	a0,0x8
    80000352:	cea50513          	addi	a0,a0,-790 # 80008038 <etext+0x38>
    80000356:	00006097          	auipc	ra,0x6
    8000035a:	a94080e7          	jalr	-1388(ra) # 80005dea <printf>
    kvminithart();    // turn on paging
    8000035e:	00000097          	auipc	ra,0x0
    80000362:	0d8080e7          	jalr	216(ra) # 80000436 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000366:	00002097          	auipc	ra,0x2
    8000036a:	8d6080e7          	jalr	-1834(ra) # 80001c3c <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000036e:	00005097          	auipc	ra,0x5
    80000372:	f62080e7          	jalr	-158(ra) # 800052d0 <plicinithart>
  }

  scheduler();        
    80000376:	00001097          	auipc	ra,0x1
    8000037a:	182080e7          	jalr	386(ra) # 800014f8 <scheduler>
    consoleinit();
    8000037e:	00006097          	auipc	ra,0x6
    80000382:	932080e7          	jalr	-1742(ra) # 80005cb0 <consoleinit>
    printfinit();
    80000386:	00006097          	auipc	ra,0x6
    8000038a:	c44080e7          	jalr	-956(ra) # 80005fca <printfinit>
    printf("\n");
    8000038e:	00008517          	auipc	a0,0x8
    80000392:	cba50513          	addi	a0,a0,-838 # 80008048 <etext+0x48>
    80000396:	00006097          	auipc	ra,0x6
    8000039a:	a54080e7          	jalr	-1452(ra) # 80005dea <printf>
    printf("xv6 kernel is booting\n");
    8000039e:	00008517          	auipc	a0,0x8
    800003a2:	c8250513          	addi	a0,a0,-894 # 80008020 <etext+0x20>
    800003a6:	00006097          	auipc	ra,0x6
    800003aa:	a44080e7          	jalr	-1468(ra) # 80005dea <printf>
    printf("\n");
    800003ae:	00008517          	auipc	a0,0x8
    800003b2:	c9a50513          	addi	a0,a0,-870 # 80008048 <etext+0x48>
    800003b6:	00006097          	auipc	ra,0x6
    800003ba:	a34080e7          	jalr	-1484(ra) # 80005dea <printf>
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
    800003da:	a86080e7          	jalr	-1402(ra) # 80000e5c <procinit>
    trapinit();      // trap vectors
    800003de:	00002097          	auipc	ra,0x2
    800003e2:	836080e7          	jalr	-1994(ra) # 80001c14 <trapinit>
    trapinithart();  // install kernel trap vector
    800003e6:	00002097          	auipc	ra,0x2
    800003ea:	856080e7          	jalr	-1962(ra) # 80001c3c <trapinithart>
    plicinit();      // set up interrupt controller
    800003ee:	00005097          	auipc	ra,0x5
    800003f2:	ecc080e7          	jalr	-308(ra) # 800052ba <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003f6:	00005097          	auipc	ra,0x5
    800003fa:	eda080e7          	jalr	-294(ra) # 800052d0 <plicinithart>
    binit();         // buffer cache
    800003fe:	00002097          	auipc	ra,0x2
    80000402:	07e080e7          	jalr	126(ra) # 8000247c <binit>
    iinit();         // inode table
    80000406:	00002097          	auipc	ra,0x2
    8000040a:	70c080e7          	jalr	1804(ra) # 80002b12 <iinit>
    fileinit();      // file table
    8000040e:	00003097          	auipc	ra,0x3
    80000412:	6be080e7          	jalr	1726(ra) # 80003acc <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000416:	00005097          	auipc	ra,0x5
    8000041a:	fda080e7          	jalr	-38(ra) # 800053f0 <virtio_disk_init>
    userinit();      // first user process
    8000041e:	00001097          	auipc	ra,0x1
    80000422:	ea0080e7          	jalr	-352(ra) # 800012be <userinit>
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
    8000048c:	918080e7          	jalr	-1768(ra) # 80005da0 <panic>
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
    800004ba:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffd8db7>
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
    800005ae:	00005097          	auipc	ra,0x5
    800005b2:	7f2080e7          	jalr	2034(ra) # 80005da0 <panic>
      panic("mappages: remap");
    800005b6:	00008517          	auipc	a0,0x8
    800005ba:	ab250513          	addi	a0,a0,-1358 # 80008068 <etext+0x68>
    800005be:	00005097          	auipc	ra,0x5
    800005c2:	7e2080e7          	jalr	2018(ra) # 80005da0 <panic>
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
    8000060e:	796080e7          	jalr	1942(ra) # 80005da0 <panic>

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
    800006d6:	6f6080e7          	jalr	1782(ra) # 80000dc8 <proc_mapstacks>
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
    8000075a:	64a080e7          	jalr	1610(ra) # 80005da0 <panic>
      panic("uvmunmap: walk");
    8000075e:	00008517          	auipc	a0,0x8
    80000762:	93a50513          	addi	a0,a0,-1734 # 80008098 <etext+0x98>
    80000766:	00005097          	auipc	ra,0x5
    8000076a:	63a080e7          	jalr	1594(ra) # 80005da0 <panic>
      panic("uvmunmap: not mapped");
    8000076e:	00008517          	auipc	a0,0x8
    80000772:	93a50513          	addi	a0,a0,-1734 # 800080a8 <etext+0xa8>
    80000776:	00005097          	auipc	ra,0x5
    8000077a:	62a080e7          	jalr	1578(ra) # 80005da0 <panic>
      panic("uvmunmap: not a leaf");
    8000077e:	00008517          	auipc	a0,0x8
    80000782:	94250513          	addi	a0,a0,-1726 # 800080c0 <etext+0xc0>
    80000786:	00005097          	auipc	ra,0x5
    8000078a:	61a080e7          	jalr	1562(ra) # 80005da0 <panic>
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
    80000868:	53c080e7          	jalr	1340(ra) # 80005da0 <panic>

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
    800009ac:	3f8080e7          	jalr	1016(ra) # 80005da0 <panic>
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
    80000a8a:	31a080e7          	jalr	794(ra) # 80005da0 <panic>
      panic("uvmcopy: page not present");
    80000a8e:	00007517          	auipc	a0,0x7
    80000a92:	69a50513          	addi	a0,a0,1690 # 80008128 <etext+0x128>
    80000a96:	00005097          	auipc	ra,0x5
    80000a9a:	30a080e7          	jalr	778(ra) # 80005da0 <panic>
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
    80000b04:	2a0080e7          	jalr	672(ra) # 80005da0 <panic>

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
    80000ca8:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd8dc0>
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

0000000080000cd2 <travelsal_pt>:

void travelsal_pt(pagetable_t pagetable,int level)
{
    80000cd2:	711d                	addi	sp,sp,-96
    80000cd4:	ec86                	sd	ra,88(sp)
    80000cd6:	e8a2                	sd	s0,80(sp)
    80000cd8:	e4a6                	sd	s1,72(sp)
    80000cda:	e0ca                	sd	s2,64(sp)
    80000cdc:	fc4e                	sd	s3,56(sp)
    80000cde:	f852                	sd	s4,48(sp)
    80000ce0:	f456                	sd	s5,40(sp)
    80000ce2:	f05a                	sd	s6,32(sp)
    80000ce4:	ec5e                	sd	s7,24(sp)
    80000ce6:	e862                	sd	s8,16(sp)
    80000ce8:	e466                	sd	s9,8(sp)
    80000cea:	1080                	addi	s0,sp,96
    80000cec:	8a2e                	mv	s4,a1
	for(int i=0;i<512;i++)
    80000cee:	892a                	mv	s2,a0
    80000cf0:	4481                	li	s1,0
			if(level==0)
			{
				printf("..%d: pte %p pa %p\n",i,pte,child);
				travelsal_pt((pagetable_t)child,level+1);
			}
			else if(level==1)
    80000cf2:	4a85                	li	s5,1
			{
				printf(".. ..%d: pte %p pa %p\n",i,pte,child);
        travelsal_pt((pagetable_t)child,level+1);
			}
			else
				printf(".. .. ..%d: pte %p pa %p\n",i,pte,child);
    80000cf4:	00007b17          	auipc	s6,0x7
    80000cf8:	494b0b13          	addi	s6,s6,1172 # 80008188 <etext+0x188>
				printf(".. ..%d: pte %p pa %p\n",i,pte,child);
    80000cfc:	00007c17          	auipc	s8,0x7
    80000d00:	474c0c13          	addi	s8,s8,1140 # 80008170 <etext+0x170>
				printf("..%d: pte %p pa %p\n",i,pte,child);
    80000d04:	00007b97          	auipc	s7,0x7
    80000d08:	454b8b93          	addi	s7,s7,1108 # 80008158 <etext+0x158>
	for(int i=0;i<512;i++)
    80000d0c:	20000993          	li	s3,512
    80000d10:	a015                	j	80000d34 <travelsal_pt+0x62>
				printf("..%d: pte %p pa %p\n",i,pte,child);
    80000d12:	86e6                	mv	a3,s9
    80000d14:	85a6                	mv	a1,s1
    80000d16:	855e                	mv	a0,s7
    80000d18:	00005097          	auipc	ra,0x5
    80000d1c:	0d2080e7          	jalr	210(ra) # 80005dea <printf>
				travelsal_pt((pagetable_t)child,level+1);
    80000d20:	85d6                	mv	a1,s5
    80000d22:	8566                	mv	a0,s9
    80000d24:	00000097          	auipc	ra,0x0
    80000d28:	fae080e7          	jalr	-82(ra) # 80000cd2 <travelsal_pt>
	for(int i=0;i<512;i++)
    80000d2c:	2485                	addiw	s1,s1,1
    80000d2e:	0921                	addi	s2,s2,8 # 1008 <_entry-0x7fffeff8>
    80000d30:	05348563          	beq	s1,s3,80000d7a <travelsal_pt+0xa8>
		pte_t pte=pagetable[i];
    80000d34:	00093603          	ld	a2,0(s2)
		if(pte & PTE_V)
    80000d38:	00167793          	andi	a5,a2,1
    80000d3c:	dbe5                	beqz	a5,80000d2c <travelsal_pt+0x5a>
			uint64 child=PTE2PA(pte);
    80000d3e:	00a65693          	srli	a3,a2,0xa
    80000d42:	00c69c93          	slli	s9,a3,0xc
			if(level==0)
    80000d46:	fc0a06e3          	beqz	s4,80000d12 <travelsal_pt+0x40>
			else if(level==1)
    80000d4a:	015a0a63          	beq	s4,s5,80000d5e <travelsal_pt+0x8c>
				printf(".. .. ..%d: pte %p pa %p\n",i,pte,child);
    80000d4e:	86e6                	mv	a3,s9
    80000d50:	85a6                	mv	a1,s1
    80000d52:	855a                	mv	a0,s6
    80000d54:	00005097          	auipc	ra,0x5
    80000d58:	096080e7          	jalr	150(ra) # 80005dea <printf>
    80000d5c:	bfc1                	j	80000d2c <travelsal_pt+0x5a>
				printf(".. ..%d: pte %p pa %p\n",i,pte,child);
    80000d5e:	86e6                	mv	a3,s9
    80000d60:	85a6                	mv	a1,s1
    80000d62:	8562                	mv	a0,s8
    80000d64:	00005097          	auipc	ra,0x5
    80000d68:	086080e7          	jalr	134(ra) # 80005dea <printf>
        travelsal_pt((pagetable_t)child,level+1);
    80000d6c:	4589                	li	a1,2
    80000d6e:	8566                	mv	a0,s9
    80000d70:	00000097          	auipc	ra,0x0
    80000d74:	f62080e7          	jalr	-158(ra) # 80000cd2 <travelsal_pt>
    80000d78:	bf55                	j	80000d2c <travelsal_pt+0x5a>
		}
	}

}
    80000d7a:	60e6                	ld	ra,88(sp)
    80000d7c:	6446                	ld	s0,80(sp)
    80000d7e:	64a6                	ld	s1,72(sp)
    80000d80:	6906                	ld	s2,64(sp)
    80000d82:	79e2                	ld	s3,56(sp)
    80000d84:	7a42                	ld	s4,48(sp)
    80000d86:	7aa2                	ld	s5,40(sp)
    80000d88:	7b02                	ld	s6,32(sp)
    80000d8a:	6be2                	ld	s7,24(sp)
    80000d8c:	6c42                	ld	s8,16(sp)
    80000d8e:	6ca2                	ld	s9,8(sp)
    80000d90:	6125                	addi	sp,sp,96
    80000d92:	8082                	ret

0000000080000d94 <vmprint>:
void
vmprint(pagetable_t pagetable)
{
    80000d94:	1101                	addi	sp,sp,-32
    80000d96:	ec06                	sd	ra,24(sp)
    80000d98:	e822                	sd	s0,16(sp)
    80000d9a:	e426                	sd	s1,8(sp)
    80000d9c:	1000                	addi	s0,sp,32
    80000d9e:	84aa                	mv	s1,a0
	printf("page table %p\n",pagetable);
    80000da0:	85aa                	mv	a1,a0
    80000da2:	00007517          	auipc	a0,0x7
    80000da6:	40650513          	addi	a0,a0,1030 # 800081a8 <etext+0x1a8>
    80000daa:	00005097          	auipc	ra,0x5
    80000dae:	040080e7          	jalr	64(ra) # 80005dea <printf>
	travelsal_pt(pagetable,0);
    80000db2:	4581                	li	a1,0
    80000db4:	8526                	mv	a0,s1
    80000db6:	00000097          	auipc	ra,0x0
    80000dba:	f1c080e7          	jalr	-228(ra) # 80000cd2 <travelsal_pt>
    80000dbe:	60e2                	ld	ra,24(sp)
    80000dc0:	6442                	ld	s0,16(sp)
    80000dc2:	64a2                	ld	s1,8(sp)
    80000dc4:	6105                	addi	sp,sp,32
    80000dc6:	8082                	ret

0000000080000dc8 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000dc8:	7139                	addi	sp,sp,-64
    80000dca:	fc06                	sd	ra,56(sp)
    80000dcc:	f822                	sd	s0,48(sp)
    80000dce:	f426                	sd	s1,40(sp)
    80000dd0:	f04a                	sd	s2,32(sp)
    80000dd2:	ec4e                	sd	s3,24(sp)
    80000dd4:	e852                	sd	s4,16(sp)
    80000dd6:	e456                	sd	s5,8(sp)
    80000dd8:	e05a                	sd	s6,0(sp)
    80000dda:	0080                	addi	s0,sp,64
    80000ddc:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dde:	00008497          	auipc	s1,0x8
    80000de2:	6a248493          	addi	s1,s1,1698 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000de6:	8b26                	mv	s6,s1
    80000de8:	00007a97          	auipc	s5,0x7
    80000dec:	218a8a93          	addi	s5,s5,536 # 80008000 <etext>
    80000df0:	01000937          	lui	s2,0x1000
    80000df4:	197d                	addi	s2,s2,-1 # ffffff <_entry-0x7f000001>
    80000df6:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000df8:	0000ea17          	auipc	s4,0xe
    80000dfc:	288a0a13          	addi	s4,s4,648 # 8000f080 <tickslock>
    char *pa = kalloc();
    80000e00:	fffff097          	auipc	ra,0xfffff
    80000e04:	31a080e7          	jalr	794(ra) # 8000011a <kalloc>
    80000e08:	862a                	mv	a2,a0
    if(pa == 0)
    80000e0a:	c129                	beqz	a0,80000e4c <proc_mapstacks+0x84>
    uint64 va = KSTACK((int) (p - proc));
    80000e0c:	416485b3          	sub	a1,s1,s6
    80000e10:	8591                	srai	a1,a1,0x4
    80000e12:	000ab783          	ld	a5,0(s5)
    80000e16:	02f585b3          	mul	a1,a1,a5
    80000e1a:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000e1e:	4719                	li	a4,6
    80000e20:	6685                	lui	a3,0x1
    80000e22:	40b905b3          	sub	a1,s2,a1
    80000e26:	854e                	mv	a0,s3
    80000e28:	fffff097          	auipc	ra,0xfffff
    80000e2c:	7ba080e7          	jalr	1978(ra) # 800005e2 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e30:	17048493          	addi	s1,s1,368
    80000e34:	fd4496e3          	bne	s1,s4,80000e00 <proc_mapstacks+0x38>
  }
}
    80000e38:	70e2                	ld	ra,56(sp)
    80000e3a:	7442                	ld	s0,48(sp)
    80000e3c:	74a2                	ld	s1,40(sp)
    80000e3e:	7902                	ld	s2,32(sp)
    80000e40:	69e2                	ld	s3,24(sp)
    80000e42:	6a42                	ld	s4,16(sp)
    80000e44:	6aa2                	ld	s5,8(sp)
    80000e46:	6b02                	ld	s6,0(sp)
    80000e48:	6121                	addi	sp,sp,64
    80000e4a:	8082                	ret
      panic("kalloc");
    80000e4c:	00007517          	auipc	a0,0x7
    80000e50:	36c50513          	addi	a0,a0,876 # 800081b8 <etext+0x1b8>
    80000e54:	00005097          	auipc	ra,0x5
    80000e58:	f4c080e7          	jalr	-180(ra) # 80005da0 <panic>

0000000080000e5c <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000e5c:	7139                	addi	sp,sp,-64
    80000e5e:	fc06                	sd	ra,56(sp)
    80000e60:	f822                	sd	s0,48(sp)
    80000e62:	f426                	sd	s1,40(sp)
    80000e64:	f04a                	sd	s2,32(sp)
    80000e66:	ec4e                	sd	s3,24(sp)
    80000e68:	e852                	sd	s4,16(sp)
    80000e6a:	e456                	sd	s5,8(sp)
    80000e6c:	e05a                	sd	s6,0(sp)
    80000e6e:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000e70:	00007597          	auipc	a1,0x7
    80000e74:	35058593          	addi	a1,a1,848 # 800081c0 <etext+0x1c0>
    80000e78:	00008517          	auipc	a0,0x8
    80000e7c:	1d850513          	addi	a0,a0,472 # 80009050 <pid_lock>
    80000e80:	00005097          	auipc	ra,0x5
    80000e84:	3c8080e7          	jalr	968(ra) # 80006248 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000e88:	00007597          	auipc	a1,0x7
    80000e8c:	34058593          	addi	a1,a1,832 # 800081c8 <etext+0x1c8>
    80000e90:	00008517          	auipc	a0,0x8
    80000e94:	1d850513          	addi	a0,a0,472 # 80009068 <wait_lock>
    80000e98:	00005097          	auipc	ra,0x5
    80000e9c:	3b0080e7          	jalr	944(ra) # 80006248 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ea0:	00008497          	auipc	s1,0x8
    80000ea4:	5e048493          	addi	s1,s1,1504 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000ea8:	00007b17          	auipc	s6,0x7
    80000eac:	330b0b13          	addi	s6,s6,816 # 800081d8 <etext+0x1d8>
      p->kstack = KSTACK((int) (p - proc));
    80000eb0:	8aa6                	mv	s5,s1
    80000eb2:	00007a17          	auipc	s4,0x7
    80000eb6:	14ea0a13          	addi	s4,s4,334 # 80008000 <etext>
    80000eba:	01000937          	lui	s2,0x1000
    80000ebe:	197d                	addi	s2,s2,-1 # ffffff <_entry-0x7f000001>
    80000ec0:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ec2:	0000e997          	auipc	s3,0xe
    80000ec6:	1be98993          	addi	s3,s3,446 # 8000f080 <tickslock>
      initlock(&p->lock, "proc");
    80000eca:	85da                	mv	a1,s6
    80000ecc:	8526                	mv	a0,s1
    80000ece:	00005097          	auipc	ra,0x5
    80000ed2:	37a080e7          	jalr	890(ra) # 80006248 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000ed6:	415487b3          	sub	a5,s1,s5
    80000eda:	8791                	srai	a5,a5,0x4
    80000edc:	000a3703          	ld	a4,0(s4)
    80000ee0:	02e787b3          	mul	a5,a5,a4
    80000ee4:	00d7979b          	slliw	a5,a5,0xd
    80000ee8:	40f907b3          	sub	a5,s2,a5
    80000eec:	e4bc                	sd	a5,72(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000eee:	17048493          	addi	s1,s1,368
    80000ef2:	fd349ce3          	bne	s1,s3,80000eca <procinit+0x6e>
  }
}
    80000ef6:	70e2                	ld	ra,56(sp)
    80000ef8:	7442                	ld	s0,48(sp)
    80000efa:	74a2                	ld	s1,40(sp)
    80000efc:	7902                	ld	s2,32(sp)
    80000efe:	69e2                	ld	s3,24(sp)
    80000f00:	6a42                	ld	s4,16(sp)
    80000f02:	6aa2                	ld	s5,8(sp)
    80000f04:	6b02                	ld	s6,0(sp)
    80000f06:	6121                	addi	sp,sp,64
    80000f08:	8082                	ret

0000000080000f0a <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000f0a:	1141                	addi	sp,sp,-16
    80000f0c:	e422                	sd	s0,8(sp)
    80000f0e:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000f10:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000f12:	2501                	sext.w	a0,a0
    80000f14:	6422                	ld	s0,8(sp)
    80000f16:	0141                	addi	sp,sp,16
    80000f18:	8082                	ret

0000000080000f1a <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000f1a:	1141                	addi	sp,sp,-16
    80000f1c:	e422                	sd	s0,8(sp)
    80000f1e:	0800                	addi	s0,sp,16
    80000f20:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000f22:	2781                	sext.w	a5,a5
    80000f24:	079e                	slli	a5,a5,0x7
  return c;
}
    80000f26:	00008517          	auipc	a0,0x8
    80000f2a:	15a50513          	addi	a0,a0,346 # 80009080 <cpus>
    80000f2e:	953e                	add	a0,a0,a5
    80000f30:	6422                	ld	s0,8(sp)
    80000f32:	0141                	addi	sp,sp,16
    80000f34:	8082                	ret

0000000080000f36 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000f36:	1101                	addi	sp,sp,-32
    80000f38:	ec06                	sd	ra,24(sp)
    80000f3a:	e822                	sd	s0,16(sp)
    80000f3c:	e426                	sd	s1,8(sp)
    80000f3e:	1000                	addi	s0,sp,32
  push_off();
    80000f40:	00005097          	auipc	ra,0x5
    80000f44:	34c080e7          	jalr	844(ra) # 8000628c <push_off>
    80000f48:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000f4a:	2781                	sext.w	a5,a5
    80000f4c:	079e                	slli	a5,a5,0x7
    80000f4e:	00008717          	auipc	a4,0x8
    80000f52:	10270713          	addi	a4,a4,258 # 80009050 <pid_lock>
    80000f56:	97ba                	add	a5,a5,a4
    80000f58:	7b84                	ld	s1,48(a5)
  pop_off();
    80000f5a:	00005097          	auipc	ra,0x5
    80000f5e:	3d2080e7          	jalr	978(ra) # 8000632c <pop_off>
  return p;
}
    80000f62:	8526                	mv	a0,s1
    80000f64:	60e2                	ld	ra,24(sp)
    80000f66:	6442                	ld	s0,16(sp)
    80000f68:	64a2                	ld	s1,8(sp)
    80000f6a:	6105                	addi	sp,sp,32
    80000f6c:	8082                	ret

0000000080000f6e <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000f6e:	1141                	addi	sp,sp,-16
    80000f70:	e406                	sd	ra,8(sp)
    80000f72:	e022                	sd	s0,0(sp)
    80000f74:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000f76:	00000097          	auipc	ra,0x0
    80000f7a:	fc0080e7          	jalr	-64(ra) # 80000f36 <myproc>
    80000f7e:	00005097          	auipc	ra,0x5
    80000f82:	40e080e7          	jalr	1038(ra) # 8000638c <release>

  if (first) {
    80000f86:	00008797          	auipc	a5,0x8
    80000f8a:	94a7a783          	lw	a5,-1718(a5) # 800088d0 <first.1>
    80000f8e:	eb89                	bnez	a5,80000fa0 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000f90:	00001097          	auipc	ra,0x1
    80000f94:	cc4080e7          	jalr	-828(ra) # 80001c54 <usertrapret>
}
    80000f98:	60a2                	ld	ra,8(sp)
    80000f9a:	6402                	ld	s0,0(sp)
    80000f9c:	0141                	addi	sp,sp,16
    80000f9e:	8082                	ret
    first = 0;
    80000fa0:	00008797          	auipc	a5,0x8
    80000fa4:	9207a823          	sw	zero,-1744(a5) # 800088d0 <first.1>
    fsinit(ROOTDEV);
    80000fa8:	4505                	li	a0,1
    80000faa:	00002097          	auipc	ra,0x2
    80000fae:	ae8080e7          	jalr	-1304(ra) # 80002a92 <fsinit>
    80000fb2:	bff9                	j	80000f90 <forkret+0x22>

0000000080000fb4 <allocpid>:
allocpid() {
    80000fb4:	1101                	addi	sp,sp,-32
    80000fb6:	ec06                	sd	ra,24(sp)
    80000fb8:	e822                	sd	s0,16(sp)
    80000fba:	e426                	sd	s1,8(sp)
    80000fbc:	e04a                	sd	s2,0(sp)
    80000fbe:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000fc0:	00008917          	auipc	s2,0x8
    80000fc4:	09090913          	addi	s2,s2,144 # 80009050 <pid_lock>
    80000fc8:	854a                	mv	a0,s2
    80000fca:	00005097          	auipc	ra,0x5
    80000fce:	30e080e7          	jalr	782(ra) # 800062d8 <acquire>
  pid = nextpid;
    80000fd2:	00008797          	auipc	a5,0x8
    80000fd6:	90278793          	addi	a5,a5,-1790 # 800088d4 <nextpid>
    80000fda:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000fdc:	0014871b          	addiw	a4,s1,1
    80000fe0:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000fe2:	854a                	mv	a0,s2
    80000fe4:	00005097          	auipc	ra,0x5
    80000fe8:	3a8080e7          	jalr	936(ra) # 8000638c <release>
}
    80000fec:	8526                	mv	a0,s1
    80000fee:	60e2                	ld	ra,24(sp)
    80000ff0:	6442                	ld	s0,16(sp)
    80000ff2:	64a2                	ld	s1,8(sp)
    80000ff4:	6902                	ld	s2,0(sp)
    80000ff6:	6105                	addi	sp,sp,32
    80000ff8:	8082                	ret

0000000080000ffa <proc_pagetable>:
{
    80000ffa:	1101                	addi	sp,sp,-32
    80000ffc:	ec06                	sd	ra,24(sp)
    80000ffe:	e822                	sd	s0,16(sp)
    80001000:	e426                	sd	s1,8(sp)
    80001002:	e04a                	sd	s2,0(sp)
    80001004:	1000                	addi	s0,sp,32
    80001006:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001008:	fffff097          	auipc	ra,0xfffff
    8000100c:	7c4080e7          	jalr	1988(ra) # 800007cc <uvmcreate>
    80001010:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001012:	cd39                	beqz	a0,80001070 <proc_pagetable+0x76>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001014:	4729                	li	a4,10
    80001016:	00006697          	auipc	a3,0x6
    8000101a:	fea68693          	addi	a3,a3,-22 # 80007000 <_trampoline>
    8000101e:	6605                	lui	a2,0x1
    80001020:	040005b7          	lui	a1,0x4000
    80001024:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001026:	05b2                	slli	a1,a1,0xc
    80001028:	fffff097          	auipc	ra,0xfffff
    8000102c:	51a080e7          	jalr	1306(ra) # 80000542 <mappages>
    80001030:	04054763          	bltz	a0,8000107e <proc_pagetable+0x84>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001034:	4719                	li	a4,6
    80001036:	06093683          	ld	a3,96(s2)
    8000103a:	6605                	lui	a2,0x1
    8000103c:	020005b7          	lui	a1,0x2000
    80001040:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001042:	05b6                	slli	a1,a1,0xd
    80001044:	8526                	mv	a0,s1
    80001046:	fffff097          	auipc	ra,0xfffff
    8000104a:	4fc080e7          	jalr	1276(ra) # 80000542 <mappages>
    8000104e:	04054063          	bltz	a0,8000108e <proc_pagetable+0x94>
   if(mappages(pagetable, USYSCALL, PGSIZE,
    80001052:	4749                	li	a4,18
    80001054:	01893683          	ld	a3,24(s2)
    80001058:	6605                	lui	a2,0x1
    8000105a:	040005b7          	lui	a1,0x4000
    8000105e:	15f5                	addi	a1,a1,-3 # 3fffffd <_entry-0x7c000003>
    80001060:	05b2                	slli	a1,a1,0xc
    80001062:	8526                	mv	a0,s1
    80001064:	fffff097          	auipc	ra,0xfffff
    80001068:	4de080e7          	jalr	1246(ra) # 80000542 <mappages>
    8000106c:	04054463          	bltz	a0,800010b4 <proc_pagetable+0xba>
}
    80001070:	8526                	mv	a0,s1
    80001072:	60e2                	ld	ra,24(sp)
    80001074:	6442                	ld	s0,16(sp)
    80001076:	64a2                	ld	s1,8(sp)
    80001078:	6902                	ld	s2,0(sp)
    8000107a:	6105                	addi	sp,sp,32
    8000107c:	8082                	ret
    uvmfree(pagetable, 0);
    8000107e:	4581                	li	a1,0
    80001080:	8526                	mv	a0,s1
    80001082:	00000097          	auipc	ra,0x0
    80001086:	948080e7          	jalr	-1720(ra) # 800009ca <uvmfree>
    return 0;
    8000108a:	4481                	li	s1,0
    8000108c:	b7d5                	j	80001070 <proc_pagetable+0x76>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000108e:	4681                	li	a3,0
    80001090:	4605                	li	a2,1
    80001092:	040005b7          	lui	a1,0x4000
    80001096:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001098:	05b2                	slli	a1,a1,0xc
    8000109a:	8526                	mv	a0,s1
    8000109c:	fffff097          	auipc	ra,0xfffff
    800010a0:	66c080e7          	jalr	1644(ra) # 80000708 <uvmunmap>
    uvmfree(pagetable, 0);
    800010a4:	4581                	li	a1,0
    800010a6:	8526                	mv	a0,s1
    800010a8:	00000097          	auipc	ra,0x0
    800010ac:	922080e7          	jalr	-1758(ra) # 800009ca <uvmfree>
    return 0;
    800010b0:	4481                	li	s1,0
    800010b2:	bf7d                	j	80001070 <proc_pagetable+0x76>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010b4:	4681                	li	a3,0
    800010b6:	4605                	li	a2,1
    800010b8:	040005b7          	lui	a1,0x4000
    800010bc:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800010be:	05b2                	slli	a1,a1,0xc
    800010c0:	8526                	mv	a0,s1
    800010c2:	fffff097          	auipc	ra,0xfffff
    800010c6:	646080e7          	jalr	1606(ra) # 80000708 <uvmunmap>
    uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800010ca:	4681                	li	a3,0
    800010cc:	4605                	li	a2,1
    800010ce:	020005b7          	lui	a1,0x2000
    800010d2:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800010d4:	05b6                	slli	a1,a1,0xd
    800010d6:	8526                	mv	a0,s1
    800010d8:	fffff097          	auipc	ra,0xfffff
    800010dc:	630080e7          	jalr	1584(ra) # 80000708 <uvmunmap>
    uvmfree(pagetable, 0);
    800010e0:	4581                	li	a1,0
    800010e2:	8526                	mv	a0,s1
    800010e4:	00000097          	auipc	ra,0x0
    800010e8:	8e6080e7          	jalr	-1818(ra) # 800009ca <uvmfree>
    return 0;
    800010ec:	4481                	li	s1,0
    800010ee:	b749                	j	80001070 <proc_pagetable+0x76>

00000000800010f0 <proc_freepagetable>:
{
    800010f0:	7179                	addi	sp,sp,-48
    800010f2:	f406                	sd	ra,40(sp)
    800010f4:	f022                	sd	s0,32(sp)
    800010f6:	ec26                	sd	s1,24(sp)
    800010f8:	e84a                	sd	s2,16(sp)
    800010fa:	e44e                	sd	s3,8(sp)
    800010fc:	1800                	addi	s0,sp,48
    800010fe:	84aa                	mv	s1,a0
    80001100:	89ae                	mv	s3,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001102:	4681                	li	a3,0
    80001104:	4605                	li	a2,1
    80001106:	04000937          	lui	s2,0x4000
    8000110a:	fff90593          	addi	a1,s2,-1 # 3ffffff <_entry-0x7c000001>
    8000110e:	05b2                	slli	a1,a1,0xc
    80001110:	fffff097          	auipc	ra,0xfffff
    80001114:	5f8080e7          	jalr	1528(ra) # 80000708 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001118:	4681                	li	a3,0
    8000111a:	4605                	li	a2,1
    8000111c:	020005b7          	lui	a1,0x2000
    80001120:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001122:	05b6                	slli	a1,a1,0xd
    80001124:	8526                	mv	a0,s1
    80001126:	fffff097          	auipc	ra,0xfffff
    8000112a:	5e2080e7          	jalr	1506(ra) # 80000708 <uvmunmap>
  uvmunmap(pagetable, USYSCALL, 1, 0);
    8000112e:	4681                	li	a3,0
    80001130:	4605                	li	a2,1
    80001132:	1975                	addi	s2,s2,-3
    80001134:	00c91593          	slli	a1,s2,0xc
    80001138:	8526                	mv	a0,s1
    8000113a:	fffff097          	auipc	ra,0xfffff
    8000113e:	5ce080e7          	jalr	1486(ra) # 80000708 <uvmunmap>
  uvmfree(pagetable, sz);
    80001142:	85ce                	mv	a1,s3
    80001144:	8526                	mv	a0,s1
    80001146:	00000097          	auipc	ra,0x0
    8000114a:	884080e7          	jalr	-1916(ra) # 800009ca <uvmfree>
}
    8000114e:	70a2                	ld	ra,40(sp)
    80001150:	7402                	ld	s0,32(sp)
    80001152:	64e2                	ld	s1,24(sp)
    80001154:	6942                	ld	s2,16(sp)
    80001156:	69a2                	ld	s3,8(sp)
    80001158:	6145                	addi	sp,sp,48
    8000115a:	8082                	ret

000000008000115c <freeproc>:
{
    8000115c:	1101                	addi	sp,sp,-32
    8000115e:	ec06                	sd	ra,24(sp)
    80001160:	e822                	sd	s0,16(sp)
    80001162:	e426                	sd	s1,8(sp)
    80001164:	1000                	addi	s0,sp,32
    80001166:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001168:	7128                	ld	a0,96(a0)
    8000116a:	c509                	beqz	a0,80001174 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000116c:	fffff097          	auipc	ra,0xfffff
    80001170:	eb0080e7          	jalr	-336(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001174:	0604b023          	sd	zero,96(s1)
  if(p->usyscall)
    80001178:	6c88                	ld	a0,24(s1)
    8000117a:	c509                	beqz	a0,80001184 <freeproc+0x28>
    kfree((void*)p->usyscall);
    8000117c:	fffff097          	auipc	ra,0xfffff
    80001180:	ea0080e7          	jalr	-352(ra) # 8000001c <kfree>
  p->usyscall = 0;
    80001184:	0004bc23          	sd	zero,24(s1)
  if(p->pagetable)
    80001188:	6ca8                	ld	a0,88(s1)
    8000118a:	c511                	beqz	a0,80001196 <freeproc+0x3a>
    proc_freepagetable(p->pagetable, p->sz);
    8000118c:	68ac                	ld	a1,80(s1)
    8000118e:	00000097          	auipc	ra,0x0
    80001192:	f62080e7          	jalr	-158(ra) # 800010f0 <proc_freepagetable>
  p->pagetable = 0;
    80001196:	0404bc23          	sd	zero,88(s1)
  p->sz = 0;
    8000119a:	0404b823          	sd	zero,80(s1)
  p->pid = 0;
    8000119e:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    800011a2:	0404b023          	sd	zero,64(s1)
  p->name[0] = 0;
    800011a6:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    800011aa:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    800011ae:	0204a823          	sw	zero,48(s1)
  p->xstate = 0;
    800011b2:	0204aa23          	sw	zero,52(s1)
  p->state = UNUSED;
    800011b6:	0204a023          	sw	zero,32(s1)
}
    800011ba:	60e2                	ld	ra,24(sp)
    800011bc:	6442                	ld	s0,16(sp)
    800011be:	64a2                	ld	s1,8(sp)
    800011c0:	6105                	addi	sp,sp,32
    800011c2:	8082                	ret

00000000800011c4 <allocproc>:
{
    800011c4:	1101                	addi	sp,sp,-32
    800011c6:	ec06                	sd	ra,24(sp)
    800011c8:	e822                	sd	s0,16(sp)
    800011ca:	e426                	sd	s1,8(sp)
    800011cc:	e04a                	sd	s2,0(sp)
    800011ce:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800011d0:	00008497          	auipc	s1,0x8
    800011d4:	2b048493          	addi	s1,s1,688 # 80009480 <proc>
    800011d8:	0000e917          	auipc	s2,0xe
    800011dc:	ea890913          	addi	s2,s2,-344 # 8000f080 <tickslock>
    acquire(&p->lock);
    800011e0:	8526                	mv	a0,s1
    800011e2:	00005097          	auipc	ra,0x5
    800011e6:	0f6080e7          	jalr	246(ra) # 800062d8 <acquire>
    if(p->state == UNUSED) {
    800011ea:	509c                	lw	a5,32(s1)
    800011ec:	cf81                	beqz	a5,80001204 <allocproc+0x40>
      release(&p->lock);
    800011ee:	8526                	mv	a0,s1
    800011f0:	00005097          	auipc	ra,0x5
    800011f4:	19c080e7          	jalr	412(ra) # 8000638c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800011f8:	17048493          	addi	s1,s1,368
    800011fc:	ff2492e3          	bne	s1,s2,800011e0 <allocproc+0x1c>
  return 0;
    80001200:	4481                	li	s1,0
    80001202:	a09d                	j	80001268 <allocproc+0xa4>
  p->pid = allocpid();
    80001204:	00000097          	auipc	ra,0x0
    80001208:	db0080e7          	jalr	-592(ra) # 80000fb4 <allocpid>
    8000120c:	dc88                	sw	a0,56(s1)
  p->state = USED;
    8000120e:	4785                	li	a5,1
    80001210:	d09c                	sw	a5,32(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001212:	fffff097          	auipc	ra,0xfffff
    80001216:	f08080e7          	jalr	-248(ra) # 8000011a <kalloc>
    8000121a:	892a                	mv	s2,a0
    8000121c:	f0a8                	sd	a0,96(s1)
    8000121e:	cd21                	beqz	a0,80001276 <allocproc+0xb2>
 if((p->usyscall = (struct usyscall *)kalloc()) == 0){
    80001220:	fffff097          	auipc	ra,0xfffff
    80001224:	efa080e7          	jalr	-262(ra) # 8000011a <kalloc>
    80001228:	892a                	mv	s2,a0
    8000122a:	ec88                	sd	a0,24(s1)
    8000122c:	c12d                	beqz	a0,8000128e <allocproc+0xca>
  p->pagetable = proc_pagetable(p);
    8000122e:	8526                	mv	a0,s1
    80001230:	00000097          	auipc	ra,0x0
    80001234:	dca080e7          	jalr	-566(ra) # 80000ffa <proc_pagetable>
    80001238:	892a                	mv	s2,a0
    8000123a:	eca8                	sd	a0,88(s1)
  if(p->pagetable == 0){
    8000123c:	c52d                	beqz	a0,800012a6 <allocproc+0xe2>
  memset(&p->context, 0, sizeof(p->context));
    8000123e:	07000613          	li	a2,112
    80001242:	4581                	li	a1,0
    80001244:	06848513          	addi	a0,s1,104
    80001248:	fffff097          	auipc	ra,0xfffff
    8000124c:	f32080e7          	jalr	-206(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    80001250:	00000797          	auipc	a5,0x0
    80001254:	d1e78793          	addi	a5,a5,-738 # 80000f6e <forkret>
    80001258:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    8000125a:	64bc                	ld	a5,72(s1)
    8000125c:	6705                	lui	a4,0x1
    8000125e:	97ba                	add	a5,a5,a4
    80001260:	f8bc                	sd	a5,112(s1)
  p->usyscall->pid = p->pid;
    80001262:	6c9c                	ld	a5,24(s1)
    80001264:	5c98                	lw	a4,56(s1)
    80001266:	c398                	sw	a4,0(a5)
}
    80001268:	8526                	mv	a0,s1
    8000126a:	60e2                	ld	ra,24(sp)
    8000126c:	6442                	ld	s0,16(sp)
    8000126e:	64a2                	ld	s1,8(sp)
    80001270:	6902                	ld	s2,0(sp)
    80001272:	6105                	addi	sp,sp,32
    80001274:	8082                	ret
    freeproc(p);
    80001276:	8526                	mv	a0,s1
    80001278:	00000097          	auipc	ra,0x0
    8000127c:	ee4080e7          	jalr	-284(ra) # 8000115c <freeproc>
    release(&p->lock);
    80001280:	8526                	mv	a0,s1
    80001282:	00005097          	auipc	ra,0x5
    80001286:	10a080e7          	jalr	266(ra) # 8000638c <release>
    return 0;
    8000128a:	84ca                	mv	s1,s2
    8000128c:	bff1                	j	80001268 <allocproc+0xa4>
    freeproc(p);
    8000128e:	8526                	mv	a0,s1
    80001290:	00000097          	auipc	ra,0x0
    80001294:	ecc080e7          	jalr	-308(ra) # 8000115c <freeproc>
    release(&p->lock);
    80001298:	8526                	mv	a0,s1
    8000129a:	00005097          	auipc	ra,0x5
    8000129e:	0f2080e7          	jalr	242(ra) # 8000638c <release>
    return 0;
    800012a2:	84ca                	mv	s1,s2
    800012a4:	b7d1                	j	80001268 <allocproc+0xa4>
    freeproc(p);
    800012a6:	8526                	mv	a0,s1
    800012a8:	00000097          	auipc	ra,0x0
    800012ac:	eb4080e7          	jalr	-332(ra) # 8000115c <freeproc>
    release(&p->lock);
    800012b0:	8526                	mv	a0,s1
    800012b2:	00005097          	auipc	ra,0x5
    800012b6:	0da080e7          	jalr	218(ra) # 8000638c <release>
    return 0;
    800012ba:	84ca                	mv	s1,s2
    800012bc:	b775                	j	80001268 <allocproc+0xa4>

00000000800012be <userinit>:
{
    800012be:	1101                	addi	sp,sp,-32
    800012c0:	ec06                	sd	ra,24(sp)
    800012c2:	e822                	sd	s0,16(sp)
    800012c4:	e426                	sd	s1,8(sp)
    800012c6:	1000                	addi	s0,sp,32
  p = allocproc();
    800012c8:	00000097          	auipc	ra,0x0
    800012cc:	efc080e7          	jalr	-260(ra) # 800011c4 <allocproc>
    800012d0:	84aa                	mv	s1,a0
  initproc = p;
    800012d2:	00008797          	auipc	a5,0x8
    800012d6:	d2a7bf23          	sd	a0,-706(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    800012da:	03400613          	li	a2,52
    800012de:	00007597          	auipc	a1,0x7
    800012e2:	60258593          	addi	a1,a1,1538 # 800088e0 <initcode>
    800012e6:	6d28                	ld	a0,88(a0)
    800012e8:	fffff097          	auipc	ra,0xfffff
    800012ec:	512080e7          	jalr	1298(ra) # 800007fa <uvminit>
  p->sz = PGSIZE;
    800012f0:	6785                	lui	a5,0x1
    800012f2:	e8bc                	sd	a5,80(s1)
  p->trapframe->epc = 0;      // user program counter
    800012f4:	70b8                	ld	a4,96(s1)
    800012f6:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800012fa:	70b8                	ld	a4,96(s1)
    800012fc:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800012fe:	4641                	li	a2,16
    80001300:	00007597          	auipc	a1,0x7
    80001304:	ee058593          	addi	a1,a1,-288 # 800081e0 <etext+0x1e0>
    80001308:	16048513          	addi	a0,s1,352
    8000130c:	fffff097          	auipc	ra,0xfffff
    80001310:	fb8080e7          	jalr	-72(ra) # 800002c4 <safestrcpy>
  p->cwd = namei("/");
    80001314:	00007517          	auipc	a0,0x7
    80001318:	edc50513          	addi	a0,a0,-292 # 800081f0 <etext+0x1f0>
    8000131c:	00002097          	auipc	ra,0x2
    80001320:	1ac080e7          	jalr	428(ra) # 800034c8 <namei>
    80001324:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    80001328:	478d                	li	a5,3
    8000132a:	d09c                	sw	a5,32(s1)
  release(&p->lock);
    8000132c:	8526                	mv	a0,s1
    8000132e:	00005097          	auipc	ra,0x5
    80001332:	05e080e7          	jalr	94(ra) # 8000638c <release>
}
    80001336:	60e2                	ld	ra,24(sp)
    80001338:	6442                	ld	s0,16(sp)
    8000133a:	64a2                	ld	s1,8(sp)
    8000133c:	6105                	addi	sp,sp,32
    8000133e:	8082                	ret

0000000080001340 <growproc>:
{
    80001340:	1101                	addi	sp,sp,-32
    80001342:	ec06                	sd	ra,24(sp)
    80001344:	e822                	sd	s0,16(sp)
    80001346:	e426                	sd	s1,8(sp)
    80001348:	e04a                	sd	s2,0(sp)
    8000134a:	1000                	addi	s0,sp,32
    8000134c:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000134e:	00000097          	auipc	ra,0x0
    80001352:	be8080e7          	jalr	-1048(ra) # 80000f36 <myproc>
    80001356:	892a                	mv	s2,a0
  sz = p->sz;
    80001358:	692c                	ld	a1,80(a0)
    8000135a:	0005879b          	sext.w	a5,a1
  if(n > 0){
    8000135e:	00904f63          	bgtz	s1,8000137c <growproc+0x3c>
  } else if(n < 0){
    80001362:	0204cd63          	bltz	s1,8000139c <growproc+0x5c>
  p->sz = sz;
    80001366:	1782                	slli	a5,a5,0x20
    80001368:	9381                	srli	a5,a5,0x20
    8000136a:	04f93823          	sd	a5,80(s2)
  return 0;
    8000136e:	4501                	li	a0,0
}
    80001370:	60e2                	ld	ra,24(sp)
    80001372:	6442                	ld	s0,16(sp)
    80001374:	64a2                	ld	s1,8(sp)
    80001376:	6902                	ld	s2,0(sp)
    80001378:	6105                	addi	sp,sp,32
    8000137a:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    8000137c:	00f4863b          	addw	a2,s1,a5
    80001380:	1602                	slli	a2,a2,0x20
    80001382:	9201                	srli	a2,a2,0x20
    80001384:	1582                	slli	a1,a1,0x20
    80001386:	9181                	srli	a1,a1,0x20
    80001388:	6d28                	ld	a0,88(a0)
    8000138a:	fffff097          	auipc	ra,0xfffff
    8000138e:	52a080e7          	jalr	1322(ra) # 800008b4 <uvmalloc>
    80001392:	0005079b          	sext.w	a5,a0
    80001396:	fbe1                	bnez	a5,80001366 <growproc+0x26>
      return -1;
    80001398:	557d                	li	a0,-1
    8000139a:	bfd9                	j	80001370 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000139c:	00f4863b          	addw	a2,s1,a5
    800013a0:	1602                	slli	a2,a2,0x20
    800013a2:	9201                	srli	a2,a2,0x20
    800013a4:	1582                	slli	a1,a1,0x20
    800013a6:	9181                	srli	a1,a1,0x20
    800013a8:	6d28                	ld	a0,88(a0)
    800013aa:	fffff097          	auipc	ra,0xfffff
    800013ae:	4c2080e7          	jalr	1218(ra) # 8000086c <uvmdealloc>
    800013b2:	0005079b          	sext.w	a5,a0
    800013b6:	bf45                	j	80001366 <growproc+0x26>

00000000800013b8 <fork>:
{
    800013b8:	7139                	addi	sp,sp,-64
    800013ba:	fc06                	sd	ra,56(sp)
    800013bc:	f822                	sd	s0,48(sp)
    800013be:	f426                	sd	s1,40(sp)
    800013c0:	f04a                	sd	s2,32(sp)
    800013c2:	ec4e                	sd	s3,24(sp)
    800013c4:	e852                	sd	s4,16(sp)
    800013c6:	e456                	sd	s5,8(sp)
    800013c8:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800013ca:	00000097          	auipc	ra,0x0
    800013ce:	b6c080e7          	jalr	-1172(ra) # 80000f36 <myproc>
    800013d2:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    800013d4:	00000097          	auipc	ra,0x0
    800013d8:	df0080e7          	jalr	-528(ra) # 800011c4 <allocproc>
    800013dc:	10050c63          	beqz	a0,800014f4 <fork+0x13c>
    800013e0:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800013e2:	050ab603          	ld	a2,80(s5)
    800013e6:	6d2c                	ld	a1,88(a0)
    800013e8:	058ab503          	ld	a0,88(s5)
    800013ec:	fffff097          	auipc	ra,0xfffff
    800013f0:	618080e7          	jalr	1560(ra) # 80000a04 <uvmcopy>
    800013f4:	04054863          	bltz	a0,80001444 <fork+0x8c>
  np->sz = p->sz;
    800013f8:	050ab783          	ld	a5,80(s5)
    800013fc:	04fa3823          	sd	a5,80(s4)
  *(np->trapframe) = *(p->trapframe);
    80001400:	060ab683          	ld	a3,96(s5)
    80001404:	87b6                	mv	a5,a3
    80001406:	060a3703          	ld	a4,96(s4)
    8000140a:	12068693          	addi	a3,a3,288
    8000140e:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001412:	6788                	ld	a0,8(a5)
    80001414:	6b8c                	ld	a1,16(a5)
    80001416:	6f90                	ld	a2,24(a5)
    80001418:	01073023          	sd	a6,0(a4)
    8000141c:	e708                	sd	a0,8(a4)
    8000141e:	eb0c                	sd	a1,16(a4)
    80001420:	ef10                	sd	a2,24(a4)
    80001422:	02078793          	addi	a5,a5,32
    80001426:	02070713          	addi	a4,a4,32
    8000142a:	fed792e3          	bne	a5,a3,8000140e <fork+0x56>
  np->trapframe->a0 = 0;
    8000142e:	060a3783          	ld	a5,96(s4)
    80001432:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001436:	0d8a8493          	addi	s1,s5,216
    8000143a:	0d8a0913          	addi	s2,s4,216
    8000143e:	158a8993          	addi	s3,s5,344
    80001442:	a00d                	j	80001464 <fork+0xac>
    freeproc(np);
    80001444:	8552                	mv	a0,s4
    80001446:	00000097          	auipc	ra,0x0
    8000144a:	d16080e7          	jalr	-746(ra) # 8000115c <freeproc>
    release(&np->lock);
    8000144e:	8552                	mv	a0,s4
    80001450:	00005097          	auipc	ra,0x5
    80001454:	f3c080e7          	jalr	-196(ra) # 8000638c <release>
    return -1;
    80001458:	597d                	li	s2,-1
    8000145a:	a059                	j	800014e0 <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    8000145c:	04a1                	addi	s1,s1,8
    8000145e:	0921                	addi	s2,s2,8
    80001460:	01348b63          	beq	s1,s3,80001476 <fork+0xbe>
    if(p->ofile[i])
    80001464:	6088                	ld	a0,0(s1)
    80001466:	d97d                	beqz	a0,8000145c <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001468:	00002097          	auipc	ra,0x2
    8000146c:	6f6080e7          	jalr	1782(ra) # 80003b5e <filedup>
    80001470:	00a93023          	sd	a0,0(s2)
    80001474:	b7e5                	j	8000145c <fork+0xa4>
  np->cwd = idup(p->cwd);
    80001476:	158ab503          	ld	a0,344(s5)
    8000147a:	00002097          	auipc	ra,0x2
    8000147e:	854080e7          	jalr	-1964(ra) # 80002cce <idup>
    80001482:	14aa3c23          	sd	a0,344(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001486:	4641                	li	a2,16
    80001488:	160a8593          	addi	a1,s5,352
    8000148c:	160a0513          	addi	a0,s4,352
    80001490:	fffff097          	auipc	ra,0xfffff
    80001494:	e34080e7          	jalr	-460(ra) # 800002c4 <safestrcpy>
  pid = np->pid;
    80001498:	038a2903          	lw	s2,56(s4)
  release(&np->lock);
    8000149c:	8552                	mv	a0,s4
    8000149e:	00005097          	auipc	ra,0x5
    800014a2:	eee080e7          	jalr	-274(ra) # 8000638c <release>
  acquire(&wait_lock);
    800014a6:	00008497          	auipc	s1,0x8
    800014aa:	bc248493          	addi	s1,s1,-1086 # 80009068 <wait_lock>
    800014ae:	8526                	mv	a0,s1
    800014b0:	00005097          	auipc	ra,0x5
    800014b4:	e28080e7          	jalr	-472(ra) # 800062d8 <acquire>
  np->parent = p;
    800014b8:	055a3023          	sd	s5,64(s4)
  release(&wait_lock);
    800014bc:	8526                	mv	a0,s1
    800014be:	00005097          	auipc	ra,0x5
    800014c2:	ece080e7          	jalr	-306(ra) # 8000638c <release>
  acquire(&np->lock);
    800014c6:	8552                	mv	a0,s4
    800014c8:	00005097          	auipc	ra,0x5
    800014cc:	e10080e7          	jalr	-496(ra) # 800062d8 <acquire>
  np->state = RUNNABLE;
    800014d0:	478d                	li	a5,3
    800014d2:	02fa2023          	sw	a5,32(s4)
  release(&np->lock);
    800014d6:	8552                	mv	a0,s4
    800014d8:	00005097          	auipc	ra,0x5
    800014dc:	eb4080e7          	jalr	-332(ra) # 8000638c <release>
}
    800014e0:	854a                	mv	a0,s2
    800014e2:	70e2                	ld	ra,56(sp)
    800014e4:	7442                	ld	s0,48(sp)
    800014e6:	74a2                	ld	s1,40(sp)
    800014e8:	7902                	ld	s2,32(sp)
    800014ea:	69e2                	ld	s3,24(sp)
    800014ec:	6a42                	ld	s4,16(sp)
    800014ee:	6aa2                	ld	s5,8(sp)
    800014f0:	6121                	addi	sp,sp,64
    800014f2:	8082                	ret
    return -1;
    800014f4:	597d                	li	s2,-1
    800014f6:	b7ed                	j	800014e0 <fork+0x128>

00000000800014f8 <scheduler>:
{
    800014f8:	7139                	addi	sp,sp,-64
    800014fa:	fc06                	sd	ra,56(sp)
    800014fc:	f822                	sd	s0,48(sp)
    800014fe:	f426                	sd	s1,40(sp)
    80001500:	f04a                	sd	s2,32(sp)
    80001502:	ec4e                	sd	s3,24(sp)
    80001504:	e852                	sd	s4,16(sp)
    80001506:	e456                	sd	s5,8(sp)
    80001508:	e05a                	sd	s6,0(sp)
    8000150a:	0080                	addi	s0,sp,64
    8000150c:	8792                	mv	a5,tp
  int id = r_tp();
    8000150e:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001510:	00779a93          	slli	s5,a5,0x7
    80001514:	00008717          	auipc	a4,0x8
    80001518:	b3c70713          	addi	a4,a4,-1220 # 80009050 <pid_lock>
    8000151c:	9756                	add	a4,a4,s5
    8000151e:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001522:	00008717          	auipc	a4,0x8
    80001526:	b6670713          	addi	a4,a4,-1178 # 80009088 <cpus+0x8>
    8000152a:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    8000152c:	498d                	li	s3,3
        p->state = RUNNING;
    8000152e:	4b11                	li	s6,4
        c->proc = p;
    80001530:	079e                	slli	a5,a5,0x7
    80001532:	00008a17          	auipc	s4,0x8
    80001536:	b1ea0a13          	addi	s4,s4,-1250 # 80009050 <pid_lock>
    8000153a:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    8000153c:	0000e917          	auipc	s2,0xe
    80001540:	b4490913          	addi	s2,s2,-1212 # 8000f080 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001544:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001548:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000154c:	10079073          	csrw	sstatus,a5
    80001550:	00008497          	auipc	s1,0x8
    80001554:	f3048493          	addi	s1,s1,-208 # 80009480 <proc>
    80001558:	a811                	j	8000156c <scheduler+0x74>
      release(&p->lock);
    8000155a:	8526                	mv	a0,s1
    8000155c:	00005097          	auipc	ra,0x5
    80001560:	e30080e7          	jalr	-464(ra) # 8000638c <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001564:	17048493          	addi	s1,s1,368
    80001568:	fd248ee3          	beq	s1,s2,80001544 <scheduler+0x4c>
      acquire(&p->lock);
    8000156c:	8526                	mv	a0,s1
    8000156e:	00005097          	auipc	ra,0x5
    80001572:	d6a080e7          	jalr	-662(ra) # 800062d8 <acquire>
      if(p->state == RUNNABLE) {
    80001576:	509c                	lw	a5,32(s1)
    80001578:	ff3791e3          	bne	a5,s3,8000155a <scheduler+0x62>
        p->state = RUNNING;
    8000157c:	0364a023          	sw	s6,32(s1)
        c->proc = p;
    80001580:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001584:	06848593          	addi	a1,s1,104
    80001588:	8556                	mv	a0,s5
    8000158a:	00000097          	auipc	ra,0x0
    8000158e:	620080e7          	jalr	1568(ra) # 80001baa <swtch>
        c->proc = 0;
    80001592:	020a3823          	sd	zero,48(s4)
    80001596:	b7d1                	j	8000155a <scheduler+0x62>

0000000080001598 <sched>:
{
    80001598:	7179                	addi	sp,sp,-48
    8000159a:	f406                	sd	ra,40(sp)
    8000159c:	f022                	sd	s0,32(sp)
    8000159e:	ec26                	sd	s1,24(sp)
    800015a0:	e84a                	sd	s2,16(sp)
    800015a2:	e44e                	sd	s3,8(sp)
    800015a4:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800015a6:	00000097          	auipc	ra,0x0
    800015aa:	990080e7          	jalr	-1648(ra) # 80000f36 <myproc>
    800015ae:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800015b0:	00005097          	auipc	ra,0x5
    800015b4:	cae080e7          	jalr	-850(ra) # 8000625e <holding>
    800015b8:	c93d                	beqz	a0,8000162e <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800015ba:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800015bc:	2781                	sext.w	a5,a5
    800015be:	079e                	slli	a5,a5,0x7
    800015c0:	00008717          	auipc	a4,0x8
    800015c4:	a9070713          	addi	a4,a4,-1392 # 80009050 <pid_lock>
    800015c8:	97ba                	add	a5,a5,a4
    800015ca:	0a87a703          	lw	a4,168(a5)
    800015ce:	4785                	li	a5,1
    800015d0:	06f71763          	bne	a4,a5,8000163e <sched+0xa6>
  if(p->state == RUNNING)
    800015d4:	5098                	lw	a4,32(s1)
    800015d6:	4791                	li	a5,4
    800015d8:	06f70b63          	beq	a4,a5,8000164e <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800015dc:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800015e0:	8b89                	andi	a5,a5,2
  if(intr_get())
    800015e2:	efb5                	bnez	a5,8000165e <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800015e4:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800015e6:	00008917          	auipc	s2,0x8
    800015ea:	a6a90913          	addi	s2,s2,-1430 # 80009050 <pid_lock>
    800015ee:	2781                	sext.w	a5,a5
    800015f0:	079e                	slli	a5,a5,0x7
    800015f2:	97ca                	add	a5,a5,s2
    800015f4:	0ac7a983          	lw	s3,172(a5)
    800015f8:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800015fa:	2781                	sext.w	a5,a5
    800015fc:	079e                	slli	a5,a5,0x7
    800015fe:	00008597          	auipc	a1,0x8
    80001602:	a8a58593          	addi	a1,a1,-1398 # 80009088 <cpus+0x8>
    80001606:	95be                	add	a1,a1,a5
    80001608:	06848513          	addi	a0,s1,104
    8000160c:	00000097          	auipc	ra,0x0
    80001610:	59e080e7          	jalr	1438(ra) # 80001baa <swtch>
    80001614:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001616:	2781                	sext.w	a5,a5
    80001618:	079e                	slli	a5,a5,0x7
    8000161a:	993e                	add	s2,s2,a5
    8000161c:	0b392623          	sw	s3,172(s2)
}
    80001620:	70a2                	ld	ra,40(sp)
    80001622:	7402                	ld	s0,32(sp)
    80001624:	64e2                	ld	s1,24(sp)
    80001626:	6942                	ld	s2,16(sp)
    80001628:	69a2                	ld	s3,8(sp)
    8000162a:	6145                	addi	sp,sp,48
    8000162c:	8082                	ret
    panic("sched p->lock");
    8000162e:	00007517          	auipc	a0,0x7
    80001632:	bca50513          	addi	a0,a0,-1078 # 800081f8 <etext+0x1f8>
    80001636:	00004097          	auipc	ra,0x4
    8000163a:	76a080e7          	jalr	1898(ra) # 80005da0 <panic>
    panic("sched locks");
    8000163e:	00007517          	auipc	a0,0x7
    80001642:	bca50513          	addi	a0,a0,-1078 # 80008208 <etext+0x208>
    80001646:	00004097          	auipc	ra,0x4
    8000164a:	75a080e7          	jalr	1882(ra) # 80005da0 <panic>
    panic("sched running");
    8000164e:	00007517          	auipc	a0,0x7
    80001652:	bca50513          	addi	a0,a0,-1078 # 80008218 <etext+0x218>
    80001656:	00004097          	auipc	ra,0x4
    8000165a:	74a080e7          	jalr	1866(ra) # 80005da0 <panic>
    panic("sched interruptible");
    8000165e:	00007517          	auipc	a0,0x7
    80001662:	bca50513          	addi	a0,a0,-1078 # 80008228 <etext+0x228>
    80001666:	00004097          	auipc	ra,0x4
    8000166a:	73a080e7          	jalr	1850(ra) # 80005da0 <panic>

000000008000166e <yield>:
{
    8000166e:	1101                	addi	sp,sp,-32
    80001670:	ec06                	sd	ra,24(sp)
    80001672:	e822                	sd	s0,16(sp)
    80001674:	e426                	sd	s1,8(sp)
    80001676:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001678:	00000097          	auipc	ra,0x0
    8000167c:	8be080e7          	jalr	-1858(ra) # 80000f36 <myproc>
    80001680:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001682:	00005097          	auipc	ra,0x5
    80001686:	c56080e7          	jalr	-938(ra) # 800062d8 <acquire>
  p->state = RUNNABLE;
    8000168a:	478d                	li	a5,3
    8000168c:	d09c                	sw	a5,32(s1)
  sched();
    8000168e:	00000097          	auipc	ra,0x0
    80001692:	f0a080e7          	jalr	-246(ra) # 80001598 <sched>
  release(&p->lock);
    80001696:	8526                	mv	a0,s1
    80001698:	00005097          	auipc	ra,0x5
    8000169c:	cf4080e7          	jalr	-780(ra) # 8000638c <release>
}
    800016a0:	60e2                	ld	ra,24(sp)
    800016a2:	6442                	ld	s0,16(sp)
    800016a4:	64a2                	ld	s1,8(sp)
    800016a6:	6105                	addi	sp,sp,32
    800016a8:	8082                	ret

00000000800016aa <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800016aa:	7179                	addi	sp,sp,-48
    800016ac:	f406                	sd	ra,40(sp)
    800016ae:	f022                	sd	s0,32(sp)
    800016b0:	ec26                	sd	s1,24(sp)
    800016b2:	e84a                	sd	s2,16(sp)
    800016b4:	e44e                	sd	s3,8(sp)
    800016b6:	1800                	addi	s0,sp,48
    800016b8:	89aa                	mv	s3,a0
    800016ba:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800016bc:	00000097          	auipc	ra,0x0
    800016c0:	87a080e7          	jalr	-1926(ra) # 80000f36 <myproc>
    800016c4:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800016c6:	00005097          	auipc	ra,0x5
    800016ca:	c12080e7          	jalr	-1006(ra) # 800062d8 <acquire>
  release(lk);
    800016ce:	854a                	mv	a0,s2
    800016d0:	00005097          	auipc	ra,0x5
    800016d4:	cbc080e7          	jalr	-836(ra) # 8000638c <release>

  // Go to sleep.
  p->chan = chan;
    800016d8:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    800016dc:	4789                	li	a5,2
    800016de:	d09c                	sw	a5,32(s1)

  sched();
    800016e0:	00000097          	auipc	ra,0x0
    800016e4:	eb8080e7          	jalr	-328(ra) # 80001598 <sched>

  // Tidy up.
  p->chan = 0;
    800016e8:	0204b423          	sd	zero,40(s1)

  // Reacquire original lock.
  release(&p->lock);
    800016ec:	8526                	mv	a0,s1
    800016ee:	00005097          	auipc	ra,0x5
    800016f2:	c9e080e7          	jalr	-866(ra) # 8000638c <release>
  acquire(lk);
    800016f6:	854a                	mv	a0,s2
    800016f8:	00005097          	auipc	ra,0x5
    800016fc:	be0080e7          	jalr	-1056(ra) # 800062d8 <acquire>
}
    80001700:	70a2                	ld	ra,40(sp)
    80001702:	7402                	ld	s0,32(sp)
    80001704:	64e2                	ld	s1,24(sp)
    80001706:	6942                	ld	s2,16(sp)
    80001708:	69a2                	ld	s3,8(sp)
    8000170a:	6145                	addi	sp,sp,48
    8000170c:	8082                	ret

000000008000170e <wait>:
{
    8000170e:	715d                	addi	sp,sp,-80
    80001710:	e486                	sd	ra,72(sp)
    80001712:	e0a2                	sd	s0,64(sp)
    80001714:	fc26                	sd	s1,56(sp)
    80001716:	f84a                	sd	s2,48(sp)
    80001718:	f44e                	sd	s3,40(sp)
    8000171a:	f052                	sd	s4,32(sp)
    8000171c:	ec56                	sd	s5,24(sp)
    8000171e:	e85a                	sd	s6,16(sp)
    80001720:	e45e                	sd	s7,8(sp)
    80001722:	e062                	sd	s8,0(sp)
    80001724:	0880                	addi	s0,sp,80
    80001726:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001728:	00000097          	auipc	ra,0x0
    8000172c:	80e080e7          	jalr	-2034(ra) # 80000f36 <myproc>
    80001730:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001732:	00008517          	auipc	a0,0x8
    80001736:	93650513          	addi	a0,a0,-1738 # 80009068 <wait_lock>
    8000173a:	00005097          	auipc	ra,0x5
    8000173e:	b9e080e7          	jalr	-1122(ra) # 800062d8 <acquire>
    havekids = 0;
    80001742:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    80001744:	4a15                	li	s4,5
        havekids = 1;
    80001746:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    80001748:	0000e997          	auipc	s3,0xe
    8000174c:	93898993          	addi	s3,s3,-1736 # 8000f080 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001750:	00008c17          	auipc	s8,0x8
    80001754:	918c0c13          	addi	s8,s8,-1768 # 80009068 <wait_lock>
    havekids = 0;
    80001758:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    8000175a:	00008497          	auipc	s1,0x8
    8000175e:	d2648493          	addi	s1,s1,-730 # 80009480 <proc>
    80001762:	a0bd                	j	800017d0 <wait+0xc2>
          pid = np->pid;
    80001764:	0384a983          	lw	s3,56(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80001768:	000b0e63          	beqz	s6,80001784 <wait+0x76>
    8000176c:	4691                	li	a3,4
    8000176e:	03448613          	addi	a2,s1,52
    80001772:	85da                	mv	a1,s6
    80001774:	05893503          	ld	a0,88(s2)
    80001778:	fffff097          	auipc	ra,0xfffff
    8000177c:	390080e7          	jalr	912(ra) # 80000b08 <copyout>
    80001780:	02054563          	bltz	a0,800017aa <wait+0x9c>
          freeproc(np);
    80001784:	8526                	mv	a0,s1
    80001786:	00000097          	auipc	ra,0x0
    8000178a:	9d6080e7          	jalr	-1578(ra) # 8000115c <freeproc>
          release(&np->lock);
    8000178e:	8526                	mv	a0,s1
    80001790:	00005097          	auipc	ra,0x5
    80001794:	bfc080e7          	jalr	-1028(ra) # 8000638c <release>
          release(&wait_lock);
    80001798:	00008517          	auipc	a0,0x8
    8000179c:	8d050513          	addi	a0,a0,-1840 # 80009068 <wait_lock>
    800017a0:	00005097          	auipc	ra,0x5
    800017a4:	bec080e7          	jalr	-1044(ra) # 8000638c <release>
          return pid;
    800017a8:	a09d                	j	8000180e <wait+0x100>
            release(&np->lock);
    800017aa:	8526                	mv	a0,s1
    800017ac:	00005097          	auipc	ra,0x5
    800017b0:	be0080e7          	jalr	-1056(ra) # 8000638c <release>
            release(&wait_lock);
    800017b4:	00008517          	auipc	a0,0x8
    800017b8:	8b450513          	addi	a0,a0,-1868 # 80009068 <wait_lock>
    800017bc:	00005097          	auipc	ra,0x5
    800017c0:	bd0080e7          	jalr	-1072(ra) # 8000638c <release>
            return -1;
    800017c4:	59fd                	li	s3,-1
    800017c6:	a0a1                	j	8000180e <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    800017c8:	17048493          	addi	s1,s1,368
    800017cc:	03348463          	beq	s1,s3,800017f4 <wait+0xe6>
      if(np->parent == p){
    800017d0:	60bc                	ld	a5,64(s1)
    800017d2:	ff279be3          	bne	a5,s2,800017c8 <wait+0xba>
        acquire(&np->lock);
    800017d6:	8526                	mv	a0,s1
    800017d8:	00005097          	auipc	ra,0x5
    800017dc:	b00080e7          	jalr	-1280(ra) # 800062d8 <acquire>
        if(np->state == ZOMBIE){
    800017e0:	509c                	lw	a5,32(s1)
    800017e2:	f94781e3          	beq	a5,s4,80001764 <wait+0x56>
        release(&np->lock);
    800017e6:	8526                	mv	a0,s1
    800017e8:	00005097          	auipc	ra,0x5
    800017ec:	ba4080e7          	jalr	-1116(ra) # 8000638c <release>
        havekids = 1;
    800017f0:	8756                	mv	a4,s5
    800017f2:	bfd9                	j	800017c8 <wait+0xba>
    if(!havekids || p->killed){
    800017f4:	c701                	beqz	a4,800017fc <wait+0xee>
    800017f6:	03092783          	lw	a5,48(s2)
    800017fa:	c79d                	beqz	a5,80001828 <wait+0x11a>
      release(&wait_lock);
    800017fc:	00008517          	auipc	a0,0x8
    80001800:	86c50513          	addi	a0,a0,-1940 # 80009068 <wait_lock>
    80001804:	00005097          	auipc	ra,0x5
    80001808:	b88080e7          	jalr	-1144(ra) # 8000638c <release>
      return -1;
    8000180c:	59fd                	li	s3,-1
}
    8000180e:	854e                	mv	a0,s3
    80001810:	60a6                	ld	ra,72(sp)
    80001812:	6406                	ld	s0,64(sp)
    80001814:	74e2                	ld	s1,56(sp)
    80001816:	7942                	ld	s2,48(sp)
    80001818:	79a2                	ld	s3,40(sp)
    8000181a:	7a02                	ld	s4,32(sp)
    8000181c:	6ae2                	ld	s5,24(sp)
    8000181e:	6b42                	ld	s6,16(sp)
    80001820:	6ba2                	ld	s7,8(sp)
    80001822:	6c02                	ld	s8,0(sp)
    80001824:	6161                	addi	sp,sp,80
    80001826:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001828:	85e2                	mv	a1,s8
    8000182a:	854a                	mv	a0,s2
    8000182c:	00000097          	auipc	ra,0x0
    80001830:	e7e080e7          	jalr	-386(ra) # 800016aa <sleep>
    havekids = 0;
    80001834:	b715                	j	80001758 <wait+0x4a>

0000000080001836 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001836:	7139                	addi	sp,sp,-64
    80001838:	fc06                	sd	ra,56(sp)
    8000183a:	f822                	sd	s0,48(sp)
    8000183c:	f426                	sd	s1,40(sp)
    8000183e:	f04a                	sd	s2,32(sp)
    80001840:	ec4e                	sd	s3,24(sp)
    80001842:	e852                	sd	s4,16(sp)
    80001844:	e456                	sd	s5,8(sp)
    80001846:	0080                	addi	s0,sp,64
    80001848:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000184a:	00008497          	auipc	s1,0x8
    8000184e:	c3648493          	addi	s1,s1,-970 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001852:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001854:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001856:	0000e917          	auipc	s2,0xe
    8000185a:	82a90913          	addi	s2,s2,-2006 # 8000f080 <tickslock>
    8000185e:	a811                	j	80001872 <wakeup+0x3c>
      }
      release(&p->lock);
    80001860:	8526                	mv	a0,s1
    80001862:	00005097          	auipc	ra,0x5
    80001866:	b2a080e7          	jalr	-1238(ra) # 8000638c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000186a:	17048493          	addi	s1,s1,368
    8000186e:	03248663          	beq	s1,s2,8000189a <wakeup+0x64>
    if(p != myproc()){
    80001872:	fffff097          	auipc	ra,0xfffff
    80001876:	6c4080e7          	jalr	1732(ra) # 80000f36 <myproc>
    8000187a:	fea488e3          	beq	s1,a0,8000186a <wakeup+0x34>
      acquire(&p->lock);
    8000187e:	8526                	mv	a0,s1
    80001880:	00005097          	auipc	ra,0x5
    80001884:	a58080e7          	jalr	-1448(ra) # 800062d8 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001888:	509c                	lw	a5,32(s1)
    8000188a:	fd379be3          	bne	a5,s3,80001860 <wakeup+0x2a>
    8000188e:	749c                	ld	a5,40(s1)
    80001890:	fd4798e3          	bne	a5,s4,80001860 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001894:	0354a023          	sw	s5,32(s1)
    80001898:	b7e1                	j	80001860 <wakeup+0x2a>
    }
  }
}
    8000189a:	70e2                	ld	ra,56(sp)
    8000189c:	7442                	ld	s0,48(sp)
    8000189e:	74a2                	ld	s1,40(sp)
    800018a0:	7902                	ld	s2,32(sp)
    800018a2:	69e2                	ld	s3,24(sp)
    800018a4:	6a42                	ld	s4,16(sp)
    800018a6:	6aa2                	ld	s5,8(sp)
    800018a8:	6121                	addi	sp,sp,64
    800018aa:	8082                	ret

00000000800018ac <reparent>:
{
    800018ac:	7179                	addi	sp,sp,-48
    800018ae:	f406                	sd	ra,40(sp)
    800018b0:	f022                	sd	s0,32(sp)
    800018b2:	ec26                	sd	s1,24(sp)
    800018b4:	e84a                	sd	s2,16(sp)
    800018b6:	e44e                	sd	s3,8(sp)
    800018b8:	e052                	sd	s4,0(sp)
    800018ba:	1800                	addi	s0,sp,48
    800018bc:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800018be:	00008497          	auipc	s1,0x8
    800018c2:	bc248493          	addi	s1,s1,-1086 # 80009480 <proc>
      pp->parent = initproc;
    800018c6:	00007a17          	auipc	s4,0x7
    800018ca:	74aa0a13          	addi	s4,s4,1866 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800018ce:	0000d997          	auipc	s3,0xd
    800018d2:	7b298993          	addi	s3,s3,1970 # 8000f080 <tickslock>
    800018d6:	a029                	j	800018e0 <reparent+0x34>
    800018d8:	17048493          	addi	s1,s1,368
    800018dc:	01348d63          	beq	s1,s3,800018f6 <reparent+0x4a>
    if(pp->parent == p){
    800018e0:	60bc                	ld	a5,64(s1)
    800018e2:	ff279be3          	bne	a5,s2,800018d8 <reparent+0x2c>
      pp->parent = initproc;
    800018e6:	000a3503          	ld	a0,0(s4)
    800018ea:	e0a8                	sd	a0,64(s1)
      wakeup(initproc);
    800018ec:	00000097          	auipc	ra,0x0
    800018f0:	f4a080e7          	jalr	-182(ra) # 80001836 <wakeup>
    800018f4:	b7d5                	j	800018d8 <reparent+0x2c>
}
    800018f6:	70a2                	ld	ra,40(sp)
    800018f8:	7402                	ld	s0,32(sp)
    800018fa:	64e2                	ld	s1,24(sp)
    800018fc:	6942                	ld	s2,16(sp)
    800018fe:	69a2                	ld	s3,8(sp)
    80001900:	6a02                	ld	s4,0(sp)
    80001902:	6145                	addi	sp,sp,48
    80001904:	8082                	ret

0000000080001906 <exit>:
{
    80001906:	7179                	addi	sp,sp,-48
    80001908:	f406                	sd	ra,40(sp)
    8000190a:	f022                	sd	s0,32(sp)
    8000190c:	ec26                	sd	s1,24(sp)
    8000190e:	e84a                	sd	s2,16(sp)
    80001910:	e44e                	sd	s3,8(sp)
    80001912:	e052                	sd	s4,0(sp)
    80001914:	1800                	addi	s0,sp,48
    80001916:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001918:	fffff097          	auipc	ra,0xfffff
    8000191c:	61e080e7          	jalr	1566(ra) # 80000f36 <myproc>
    80001920:	89aa                	mv	s3,a0
  if(p == initproc)
    80001922:	00007797          	auipc	a5,0x7
    80001926:	6ee7b783          	ld	a5,1774(a5) # 80009010 <initproc>
    8000192a:	0d850493          	addi	s1,a0,216
    8000192e:	15850913          	addi	s2,a0,344
    80001932:	02a79363          	bne	a5,a0,80001958 <exit+0x52>
    panic("init exiting");
    80001936:	00007517          	auipc	a0,0x7
    8000193a:	90a50513          	addi	a0,a0,-1782 # 80008240 <etext+0x240>
    8000193e:	00004097          	auipc	ra,0x4
    80001942:	462080e7          	jalr	1122(ra) # 80005da0 <panic>
      fileclose(f);
    80001946:	00002097          	auipc	ra,0x2
    8000194a:	26a080e7          	jalr	618(ra) # 80003bb0 <fileclose>
      p->ofile[fd] = 0;
    8000194e:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001952:	04a1                	addi	s1,s1,8
    80001954:	01248563          	beq	s1,s2,8000195e <exit+0x58>
    if(p->ofile[fd]){
    80001958:	6088                	ld	a0,0(s1)
    8000195a:	f575                	bnez	a0,80001946 <exit+0x40>
    8000195c:	bfdd                	j	80001952 <exit+0x4c>
  begin_op();
    8000195e:	00002097          	auipc	ra,0x2
    80001962:	d8a080e7          	jalr	-630(ra) # 800036e8 <begin_op>
  iput(p->cwd);
    80001966:	1589b503          	ld	a0,344(s3)
    8000196a:	00001097          	auipc	ra,0x1
    8000196e:	55c080e7          	jalr	1372(ra) # 80002ec6 <iput>
  end_op();
    80001972:	00002097          	auipc	ra,0x2
    80001976:	df4080e7          	jalr	-524(ra) # 80003766 <end_op>
  p->cwd = 0;
    8000197a:	1409bc23          	sd	zero,344(s3)
  acquire(&wait_lock);
    8000197e:	00007497          	auipc	s1,0x7
    80001982:	6ea48493          	addi	s1,s1,1770 # 80009068 <wait_lock>
    80001986:	8526                	mv	a0,s1
    80001988:	00005097          	auipc	ra,0x5
    8000198c:	950080e7          	jalr	-1712(ra) # 800062d8 <acquire>
  reparent(p);
    80001990:	854e                	mv	a0,s3
    80001992:	00000097          	auipc	ra,0x0
    80001996:	f1a080e7          	jalr	-230(ra) # 800018ac <reparent>
  wakeup(p->parent);
    8000199a:	0409b503          	ld	a0,64(s3)
    8000199e:	00000097          	auipc	ra,0x0
    800019a2:	e98080e7          	jalr	-360(ra) # 80001836 <wakeup>
  acquire(&p->lock);
    800019a6:	854e                	mv	a0,s3
    800019a8:	00005097          	auipc	ra,0x5
    800019ac:	930080e7          	jalr	-1744(ra) # 800062d8 <acquire>
  p->xstate = status;
    800019b0:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    800019b4:	4795                	li	a5,5
    800019b6:	02f9a023          	sw	a5,32(s3)
  release(&wait_lock);
    800019ba:	8526                	mv	a0,s1
    800019bc:	00005097          	auipc	ra,0x5
    800019c0:	9d0080e7          	jalr	-1584(ra) # 8000638c <release>
  sched();
    800019c4:	00000097          	auipc	ra,0x0
    800019c8:	bd4080e7          	jalr	-1068(ra) # 80001598 <sched>
  panic("zombie exit");
    800019cc:	00007517          	auipc	a0,0x7
    800019d0:	88450513          	addi	a0,a0,-1916 # 80008250 <etext+0x250>
    800019d4:	00004097          	auipc	ra,0x4
    800019d8:	3cc080e7          	jalr	972(ra) # 80005da0 <panic>

00000000800019dc <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800019dc:	7179                	addi	sp,sp,-48
    800019de:	f406                	sd	ra,40(sp)
    800019e0:	f022                	sd	s0,32(sp)
    800019e2:	ec26                	sd	s1,24(sp)
    800019e4:	e84a                	sd	s2,16(sp)
    800019e6:	e44e                	sd	s3,8(sp)
    800019e8:	1800                	addi	s0,sp,48
    800019ea:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800019ec:	00008497          	auipc	s1,0x8
    800019f0:	a9448493          	addi	s1,s1,-1388 # 80009480 <proc>
    800019f4:	0000d997          	auipc	s3,0xd
    800019f8:	68c98993          	addi	s3,s3,1676 # 8000f080 <tickslock>
    acquire(&p->lock);
    800019fc:	8526                	mv	a0,s1
    800019fe:	00005097          	auipc	ra,0x5
    80001a02:	8da080e7          	jalr	-1830(ra) # 800062d8 <acquire>
    if(p->pid == pid){
    80001a06:	5c9c                	lw	a5,56(s1)
    80001a08:	01278d63          	beq	a5,s2,80001a22 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001a0c:	8526                	mv	a0,s1
    80001a0e:	00005097          	auipc	ra,0x5
    80001a12:	97e080e7          	jalr	-1666(ra) # 8000638c <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a16:	17048493          	addi	s1,s1,368
    80001a1a:	ff3491e3          	bne	s1,s3,800019fc <kill+0x20>
  }
  return -1;
    80001a1e:	557d                	li	a0,-1
    80001a20:	a829                	j	80001a3a <kill+0x5e>
      p->killed = 1;
    80001a22:	4785                	li	a5,1
    80001a24:	d89c                	sw	a5,48(s1)
      if(p->state == SLEEPING){
    80001a26:	5098                	lw	a4,32(s1)
    80001a28:	4789                	li	a5,2
    80001a2a:	00f70f63          	beq	a4,a5,80001a48 <kill+0x6c>
      release(&p->lock);
    80001a2e:	8526                	mv	a0,s1
    80001a30:	00005097          	auipc	ra,0x5
    80001a34:	95c080e7          	jalr	-1700(ra) # 8000638c <release>
      return 0;
    80001a38:	4501                	li	a0,0
}
    80001a3a:	70a2                	ld	ra,40(sp)
    80001a3c:	7402                	ld	s0,32(sp)
    80001a3e:	64e2                	ld	s1,24(sp)
    80001a40:	6942                	ld	s2,16(sp)
    80001a42:	69a2                	ld	s3,8(sp)
    80001a44:	6145                	addi	sp,sp,48
    80001a46:	8082                	ret
        p->state = RUNNABLE;
    80001a48:	478d                	li	a5,3
    80001a4a:	d09c                	sw	a5,32(s1)
    80001a4c:	b7cd                	j	80001a2e <kill+0x52>

0000000080001a4e <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001a4e:	7179                	addi	sp,sp,-48
    80001a50:	f406                	sd	ra,40(sp)
    80001a52:	f022                	sd	s0,32(sp)
    80001a54:	ec26                	sd	s1,24(sp)
    80001a56:	e84a                	sd	s2,16(sp)
    80001a58:	e44e                	sd	s3,8(sp)
    80001a5a:	e052                	sd	s4,0(sp)
    80001a5c:	1800                	addi	s0,sp,48
    80001a5e:	84aa                	mv	s1,a0
    80001a60:	892e                	mv	s2,a1
    80001a62:	89b2                	mv	s3,a2
    80001a64:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a66:	fffff097          	auipc	ra,0xfffff
    80001a6a:	4d0080e7          	jalr	1232(ra) # 80000f36 <myproc>
  if(user_dst){
    80001a6e:	c08d                	beqz	s1,80001a90 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001a70:	86d2                	mv	a3,s4
    80001a72:	864e                	mv	a2,s3
    80001a74:	85ca                	mv	a1,s2
    80001a76:	6d28                	ld	a0,88(a0)
    80001a78:	fffff097          	auipc	ra,0xfffff
    80001a7c:	090080e7          	jalr	144(ra) # 80000b08 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001a80:	70a2                	ld	ra,40(sp)
    80001a82:	7402                	ld	s0,32(sp)
    80001a84:	64e2                	ld	s1,24(sp)
    80001a86:	6942                	ld	s2,16(sp)
    80001a88:	69a2                	ld	s3,8(sp)
    80001a8a:	6a02                	ld	s4,0(sp)
    80001a8c:	6145                	addi	sp,sp,48
    80001a8e:	8082                	ret
    memmove((char *)dst, src, len);
    80001a90:	000a061b          	sext.w	a2,s4
    80001a94:	85ce                	mv	a1,s3
    80001a96:	854a                	mv	a0,s2
    80001a98:	ffffe097          	auipc	ra,0xffffe
    80001a9c:	73e080e7          	jalr	1854(ra) # 800001d6 <memmove>
    return 0;
    80001aa0:	8526                	mv	a0,s1
    80001aa2:	bff9                	j	80001a80 <either_copyout+0x32>

0000000080001aa4 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001aa4:	7179                	addi	sp,sp,-48
    80001aa6:	f406                	sd	ra,40(sp)
    80001aa8:	f022                	sd	s0,32(sp)
    80001aaa:	ec26                	sd	s1,24(sp)
    80001aac:	e84a                	sd	s2,16(sp)
    80001aae:	e44e                	sd	s3,8(sp)
    80001ab0:	e052                	sd	s4,0(sp)
    80001ab2:	1800                	addi	s0,sp,48
    80001ab4:	892a                	mv	s2,a0
    80001ab6:	84ae                	mv	s1,a1
    80001ab8:	89b2                	mv	s3,a2
    80001aba:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001abc:	fffff097          	auipc	ra,0xfffff
    80001ac0:	47a080e7          	jalr	1146(ra) # 80000f36 <myproc>
  if(user_src){
    80001ac4:	c08d                	beqz	s1,80001ae6 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001ac6:	86d2                	mv	a3,s4
    80001ac8:	864e                	mv	a2,s3
    80001aca:	85ca                	mv	a1,s2
    80001acc:	6d28                	ld	a0,88(a0)
    80001ace:	fffff097          	auipc	ra,0xfffff
    80001ad2:	0c6080e7          	jalr	198(ra) # 80000b94 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001ad6:	70a2                	ld	ra,40(sp)
    80001ad8:	7402                	ld	s0,32(sp)
    80001ada:	64e2                	ld	s1,24(sp)
    80001adc:	6942                	ld	s2,16(sp)
    80001ade:	69a2                	ld	s3,8(sp)
    80001ae0:	6a02                	ld	s4,0(sp)
    80001ae2:	6145                	addi	sp,sp,48
    80001ae4:	8082                	ret
    memmove(dst, (char*)src, len);
    80001ae6:	000a061b          	sext.w	a2,s4
    80001aea:	85ce                	mv	a1,s3
    80001aec:	854a                	mv	a0,s2
    80001aee:	ffffe097          	auipc	ra,0xffffe
    80001af2:	6e8080e7          	jalr	1768(ra) # 800001d6 <memmove>
    return 0;
    80001af6:	8526                	mv	a0,s1
    80001af8:	bff9                	j	80001ad6 <either_copyin+0x32>

0000000080001afa <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001afa:	715d                	addi	sp,sp,-80
    80001afc:	e486                	sd	ra,72(sp)
    80001afe:	e0a2                	sd	s0,64(sp)
    80001b00:	fc26                	sd	s1,56(sp)
    80001b02:	f84a                	sd	s2,48(sp)
    80001b04:	f44e                	sd	s3,40(sp)
    80001b06:	f052                	sd	s4,32(sp)
    80001b08:	ec56                	sd	s5,24(sp)
    80001b0a:	e85a                	sd	s6,16(sp)
    80001b0c:	e45e                	sd	s7,8(sp)
    80001b0e:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001b10:	00006517          	auipc	a0,0x6
    80001b14:	53850513          	addi	a0,a0,1336 # 80008048 <etext+0x48>
    80001b18:	00004097          	auipc	ra,0x4
    80001b1c:	2d2080e7          	jalr	722(ra) # 80005dea <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b20:	00008497          	auipc	s1,0x8
    80001b24:	ac048493          	addi	s1,s1,-1344 # 800095e0 <proc+0x160>
    80001b28:	0000d917          	auipc	s2,0xd
    80001b2c:	6b890913          	addi	s2,s2,1720 # 8000f1e0 <bcache+0x148>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b30:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001b32:	00006997          	auipc	s3,0x6
    80001b36:	72e98993          	addi	s3,s3,1838 # 80008260 <etext+0x260>
    printf("%d %s %s", p->pid, state, p->name);
    80001b3a:	00006a97          	auipc	s5,0x6
    80001b3e:	72ea8a93          	addi	s5,s5,1838 # 80008268 <etext+0x268>
    printf("\n");
    80001b42:	00006a17          	auipc	s4,0x6
    80001b46:	506a0a13          	addi	s4,s4,1286 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b4a:	00006b97          	auipc	s7,0x6
    80001b4e:	756b8b93          	addi	s7,s7,1878 # 800082a0 <states.0>
    80001b52:	a00d                	j	80001b74 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001b54:	ed86a583          	lw	a1,-296(a3)
    80001b58:	8556                	mv	a0,s5
    80001b5a:	00004097          	auipc	ra,0x4
    80001b5e:	290080e7          	jalr	656(ra) # 80005dea <printf>
    printf("\n");
    80001b62:	8552                	mv	a0,s4
    80001b64:	00004097          	auipc	ra,0x4
    80001b68:	286080e7          	jalr	646(ra) # 80005dea <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b6c:	17048493          	addi	s1,s1,368
    80001b70:	03248263          	beq	s1,s2,80001b94 <procdump+0x9a>
    if(p->state == UNUSED)
    80001b74:	86a6                	mv	a3,s1
    80001b76:	ec04a783          	lw	a5,-320(s1)
    80001b7a:	dbed                	beqz	a5,80001b6c <procdump+0x72>
      state = "???";
    80001b7c:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b7e:	fcfb6be3          	bltu	s6,a5,80001b54 <procdump+0x5a>
    80001b82:	02079713          	slli	a4,a5,0x20
    80001b86:	01d75793          	srli	a5,a4,0x1d
    80001b8a:	97de                	add	a5,a5,s7
    80001b8c:	6390                	ld	a2,0(a5)
    80001b8e:	f279                	bnez	a2,80001b54 <procdump+0x5a>
      state = "???";
    80001b90:	864e                	mv	a2,s3
    80001b92:	b7c9                	j	80001b54 <procdump+0x5a>
  }
}
    80001b94:	60a6                	ld	ra,72(sp)
    80001b96:	6406                	ld	s0,64(sp)
    80001b98:	74e2                	ld	s1,56(sp)
    80001b9a:	7942                	ld	s2,48(sp)
    80001b9c:	79a2                	ld	s3,40(sp)
    80001b9e:	7a02                	ld	s4,32(sp)
    80001ba0:	6ae2                	ld	s5,24(sp)
    80001ba2:	6b42                	ld	s6,16(sp)
    80001ba4:	6ba2                	ld	s7,8(sp)
    80001ba6:	6161                	addi	sp,sp,80
    80001ba8:	8082                	ret

0000000080001baa <swtch>:
    80001baa:	00153023          	sd	ra,0(a0)
    80001bae:	00253423          	sd	sp,8(a0)
    80001bb2:	e900                	sd	s0,16(a0)
    80001bb4:	ed04                	sd	s1,24(a0)
    80001bb6:	03253023          	sd	s2,32(a0)
    80001bba:	03353423          	sd	s3,40(a0)
    80001bbe:	03453823          	sd	s4,48(a0)
    80001bc2:	03553c23          	sd	s5,56(a0)
    80001bc6:	05653023          	sd	s6,64(a0)
    80001bca:	05753423          	sd	s7,72(a0)
    80001bce:	05853823          	sd	s8,80(a0)
    80001bd2:	05953c23          	sd	s9,88(a0)
    80001bd6:	07a53023          	sd	s10,96(a0)
    80001bda:	07b53423          	sd	s11,104(a0)
    80001bde:	0005b083          	ld	ra,0(a1)
    80001be2:	0085b103          	ld	sp,8(a1)
    80001be6:	6980                	ld	s0,16(a1)
    80001be8:	6d84                	ld	s1,24(a1)
    80001bea:	0205b903          	ld	s2,32(a1)
    80001bee:	0285b983          	ld	s3,40(a1)
    80001bf2:	0305ba03          	ld	s4,48(a1)
    80001bf6:	0385ba83          	ld	s5,56(a1)
    80001bfa:	0405bb03          	ld	s6,64(a1)
    80001bfe:	0485bb83          	ld	s7,72(a1)
    80001c02:	0505bc03          	ld	s8,80(a1)
    80001c06:	0585bc83          	ld	s9,88(a1)
    80001c0a:	0605bd03          	ld	s10,96(a1)
    80001c0e:	0685bd83          	ld	s11,104(a1)
    80001c12:	8082                	ret

0000000080001c14 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001c14:	1141                	addi	sp,sp,-16
    80001c16:	e406                	sd	ra,8(sp)
    80001c18:	e022                	sd	s0,0(sp)
    80001c1a:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001c1c:	00006597          	auipc	a1,0x6
    80001c20:	6b458593          	addi	a1,a1,1716 # 800082d0 <states.0+0x30>
    80001c24:	0000d517          	auipc	a0,0xd
    80001c28:	45c50513          	addi	a0,a0,1116 # 8000f080 <tickslock>
    80001c2c:	00004097          	auipc	ra,0x4
    80001c30:	61c080e7          	jalr	1564(ra) # 80006248 <initlock>
}
    80001c34:	60a2                	ld	ra,8(sp)
    80001c36:	6402                	ld	s0,0(sp)
    80001c38:	0141                	addi	sp,sp,16
    80001c3a:	8082                	ret

0000000080001c3c <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001c3c:	1141                	addi	sp,sp,-16
    80001c3e:	e422                	sd	s0,8(sp)
    80001c40:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c42:	00003797          	auipc	a5,0x3
    80001c46:	5be78793          	addi	a5,a5,1470 # 80005200 <kernelvec>
    80001c4a:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001c4e:	6422                	ld	s0,8(sp)
    80001c50:	0141                	addi	sp,sp,16
    80001c52:	8082                	ret

0000000080001c54 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001c54:	1141                	addi	sp,sp,-16
    80001c56:	e406                	sd	ra,8(sp)
    80001c58:	e022                	sd	s0,0(sp)
    80001c5a:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001c5c:	fffff097          	auipc	ra,0xfffff
    80001c60:	2da080e7          	jalr	730(ra) # 80000f36 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c64:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001c68:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c6a:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001c6e:	00005697          	auipc	a3,0x5
    80001c72:	39268693          	addi	a3,a3,914 # 80007000 <_trampoline>
    80001c76:	00005717          	auipc	a4,0x5
    80001c7a:	38a70713          	addi	a4,a4,906 # 80007000 <_trampoline>
    80001c7e:	8f15                	sub	a4,a4,a3
    80001c80:	040007b7          	lui	a5,0x4000
    80001c84:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001c86:	07b2                	slli	a5,a5,0xc
    80001c88:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c8a:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001c8e:	7138                	ld	a4,96(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001c90:	18002673          	csrr	a2,satp
    80001c94:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001c96:	7130                	ld	a2,96(a0)
    80001c98:	6538                	ld	a4,72(a0)
    80001c9a:	6585                	lui	a1,0x1
    80001c9c:	972e                	add	a4,a4,a1
    80001c9e:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001ca0:	7138                	ld	a4,96(a0)
    80001ca2:	00000617          	auipc	a2,0x0
    80001ca6:	13860613          	addi	a2,a2,312 # 80001dda <usertrap>
    80001caa:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001cac:	7138                	ld	a4,96(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001cae:	8612                	mv	a2,tp
    80001cb0:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cb2:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001cb6:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001cba:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001cbe:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001cc2:	7138                	ld	a4,96(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001cc4:	6f18                	ld	a4,24(a4)
    80001cc6:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001cca:	6d2c                	ld	a1,88(a0)
    80001ccc:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001cce:	00005717          	auipc	a4,0x5
    80001cd2:	3c270713          	addi	a4,a4,962 # 80007090 <userret>
    80001cd6:	8f15                	sub	a4,a4,a3
    80001cd8:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001cda:	577d                	li	a4,-1
    80001cdc:	177e                	slli	a4,a4,0x3f
    80001cde:	8dd9                	or	a1,a1,a4
    80001ce0:	02000537          	lui	a0,0x2000
    80001ce4:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001ce6:	0536                	slli	a0,a0,0xd
    80001ce8:	9782                	jalr	a5
}
    80001cea:	60a2                	ld	ra,8(sp)
    80001cec:	6402                	ld	s0,0(sp)
    80001cee:	0141                	addi	sp,sp,16
    80001cf0:	8082                	ret

0000000080001cf2 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001cf2:	1101                	addi	sp,sp,-32
    80001cf4:	ec06                	sd	ra,24(sp)
    80001cf6:	e822                	sd	s0,16(sp)
    80001cf8:	e426                	sd	s1,8(sp)
    80001cfa:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001cfc:	0000d497          	auipc	s1,0xd
    80001d00:	38448493          	addi	s1,s1,900 # 8000f080 <tickslock>
    80001d04:	8526                	mv	a0,s1
    80001d06:	00004097          	auipc	ra,0x4
    80001d0a:	5d2080e7          	jalr	1490(ra) # 800062d8 <acquire>
  ticks++;
    80001d0e:	00007517          	auipc	a0,0x7
    80001d12:	30a50513          	addi	a0,a0,778 # 80009018 <ticks>
    80001d16:	411c                	lw	a5,0(a0)
    80001d18:	2785                	addiw	a5,a5,1
    80001d1a:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001d1c:	00000097          	auipc	ra,0x0
    80001d20:	b1a080e7          	jalr	-1254(ra) # 80001836 <wakeup>
  release(&tickslock);
    80001d24:	8526                	mv	a0,s1
    80001d26:	00004097          	auipc	ra,0x4
    80001d2a:	666080e7          	jalr	1638(ra) # 8000638c <release>
}
    80001d2e:	60e2                	ld	ra,24(sp)
    80001d30:	6442                	ld	s0,16(sp)
    80001d32:	64a2                	ld	s1,8(sp)
    80001d34:	6105                	addi	sp,sp,32
    80001d36:	8082                	ret

0000000080001d38 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001d38:	1101                	addi	sp,sp,-32
    80001d3a:	ec06                	sd	ra,24(sp)
    80001d3c:	e822                	sd	s0,16(sp)
    80001d3e:	e426                	sd	s1,8(sp)
    80001d40:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d42:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001d46:	00074d63          	bltz	a4,80001d60 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001d4a:	57fd                	li	a5,-1
    80001d4c:	17fe                	slli	a5,a5,0x3f
    80001d4e:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001d50:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001d52:	06f70363          	beq	a4,a5,80001db8 <devintr+0x80>
  }
}
    80001d56:	60e2                	ld	ra,24(sp)
    80001d58:	6442                	ld	s0,16(sp)
    80001d5a:	64a2                	ld	s1,8(sp)
    80001d5c:	6105                	addi	sp,sp,32
    80001d5e:	8082                	ret
     (scause & 0xff) == 9){
    80001d60:	0ff77793          	zext.b	a5,a4
  if((scause & 0x8000000000000000L) &&
    80001d64:	46a5                	li	a3,9
    80001d66:	fed792e3          	bne	a5,a3,80001d4a <devintr+0x12>
    int irq = plic_claim();
    80001d6a:	00003097          	auipc	ra,0x3
    80001d6e:	59e080e7          	jalr	1438(ra) # 80005308 <plic_claim>
    80001d72:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001d74:	47a9                	li	a5,10
    80001d76:	02f50763          	beq	a0,a5,80001da4 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001d7a:	4785                	li	a5,1
    80001d7c:	02f50963          	beq	a0,a5,80001dae <devintr+0x76>
    return 1;
    80001d80:	4505                	li	a0,1
    } else if(irq){
    80001d82:	d8f1                	beqz	s1,80001d56 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001d84:	85a6                	mv	a1,s1
    80001d86:	00006517          	auipc	a0,0x6
    80001d8a:	55250513          	addi	a0,a0,1362 # 800082d8 <states.0+0x38>
    80001d8e:	00004097          	auipc	ra,0x4
    80001d92:	05c080e7          	jalr	92(ra) # 80005dea <printf>
      plic_complete(irq);
    80001d96:	8526                	mv	a0,s1
    80001d98:	00003097          	auipc	ra,0x3
    80001d9c:	594080e7          	jalr	1428(ra) # 8000532c <plic_complete>
    return 1;
    80001da0:	4505                	li	a0,1
    80001da2:	bf55                	j	80001d56 <devintr+0x1e>
      uartintr();
    80001da4:	00004097          	auipc	ra,0x4
    80001da8:	454080e7          	jalr	1108(ra) # 800061f8 <uartintr>
    80001dac:	b7ed                	j	80001d96 <devintr+0x5e>
      virtio_disk_intr();
    80001dae:	00004097          	auipc	ra,0x4
    80001db2:	a0a080e7          	jalr	-1526(ra) # 800057b8 <virtio_disk_intr>
    80001db6:	b7c5                	j	80001d96 <devintr+0x5e>
    if(cpuid() == 0){
    80001db8:	fffff097          	auipc	ra,0xfffff
    80001dbc:	152080e7          	jalr	338(ra) # 80000f0a <cpuid>
    80001dc0:	c901                	beqz	a0,80001dd0 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001dc2:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001dc6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001dc8:	14479073          	csrw	sip,a5
    return 2;
    80001dcc:	4509                	li	a0,2
    80001dce:	b761                	j	80001d56 <devintr+0x1e>
      clockintr();
    80001dd0:	00000097          	auipc	ra,0x0
    80001dd4:	f22080e7          	jalr	-222(ra) # 80001cf2 <clockintr>
    80001dd8:	b7ed                	j	80001dc2 <devintr+0x8a>

0000000080001dda <usertrap>:
{
    80001dda:	1101                	addi	sp,sp,-32
    80001ddc:	ec06                	sd	ra,24(sp)
    80001dde:	e822                	sd	s0,16(sp)
    80001de0:	e426                	sd	s1,8(sp)
    80001de2:	e04a                	sd	s2,0(sp)
    80001de4:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001de6:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001dea:	1007f793          	andi	a5,a5,256
    80001dee:	e3ad                	bnez	a5,80001e50 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001df0:	00003797          	auipc	a5,0x3
    80001df4:	41078793          	addi	a5,a5,1040 # 80005200 <kernelvec>
    80001df8:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001dfc:	fffff097          	auipc	ra,0xfffff
    80001e00:	13a080e7          	jalr	314(ra) # 80000f36 <myproc>
    80001e04:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001e06:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e08:	14102773          	csrr	a4,sepc
    80001e0c:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e0e:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001e12:	47a1                	li	a5,8
    80001e14:	04f71c63          	bne	a4,a5,80001e6c <usertrap+0x92>
    if(p->killed)
    80001e18:	591c                	lw	a5,48(a0)
    80001e1a:	e3b9                	bnez	a5,80001e60 <usertrap+0x86>
    p->trapframe->epc += 4;
    80001e1c:	70b8                	ld	a4,96(s1)
    80001e1e:	6f1c                	ld	a5,24(a4)
    80001e20:	0791                	addi	a5,a5,4
    80001e22:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e24:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001e28:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e2c:	10079073          	csrw	sstatus,a5
    syscall();
    80001e30:	00000097          	auipc	ra,0x0
    80001e34:	2e0080e7          	jalr	736(ra) # 80002110 <syscall>
  if(p->killed)
    80001e38:	589c                	lw	a5,48(s1)
    80001e3a:	ebc1                	bnez	a5,80001eca <usertrap+0xf0>
  usertrapret();
    80001e3c:	00000097          	auipc	ra,0x0
    80001e40:	e18080e7          	jalr	-488(ra) # 80001c54 <usertrapret>
}
    80001e44:	60e2                	ld	ra,24(sp)
    80001e46:	6442                	ld	s0,16(sp)
    80001e48:	64a2                	ld	s1,8(sp)
    80001e4a:	6902                	ld	s2,0(sp)
    80001e4c:	6105                	addi	sp,sp,32
    80001e4e:	8082                	ret
    panic("usertrap: not from user mode");
    80001e50:	00006517          	auipc	a0,0x6
    80001e54:	4a850513          	addi	a0,a0,1192 # 800082f8 <states.0+0x58>
    80001e58:	00004097          	auipc	ra,0x4
    80001e5c:	f48080e7          	jalr	-184(ra) # 80005da0 <panic>
      exit(-1);
    80001e60:	557d                	li	a0,-1
    80001e62:	00000097          	auipc	ra,0x0
    80001e66:	aa4080e7          	jalr	-1372(ra) # 80001906 <exit>
    80001e6a:	bf4d                	j	80001e1c <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001e6c:	00000097          	auipc	ra,0x0
    80001e70:	ecc080e7          	jalr	-308(ra) # 80001d38 <devintr>
    80001e74:	892a                	mv	s2,a0
    80001e76:	c501                	beqz	a0,80001e7e <usertrap+0xa4>
  if(p->killed)
    80001e78:	589c                	lw	a5,48(s1)
    80001e7a:	c3a1                	beqz	a5,80001eba <usertrap+0xe0>
    80001e7c:	a815                	j	80001eb0 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e7e:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001e82:	5c90                	lw	a2,56(s1)
    80001e84:	00006517          	auipc	a0,0x6
    80001e88:	49450513          	addi	a0,a0,1172 # 80008318 <states.0+0x78>
    80001e8c:	00004097          	auipc	ra,0x4
    80001e90:	f5e080e7          	jalr	-162(ra) # 80005dea <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e94:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e98:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e9c:	00006517          	auipc	a0,0x6
    80001ea0:	4ac50513          	addi	a0,a0,1196 # 80008348 <states.0+0xa8>
    80001ea4:	00004097          	auipc	ra,0x4
    80001ea8:	f46080e7          	jalr	-186(ra) # 80005dea <printf>
    p->killed = 1;
    80001eac:	4785                	li	a5,1
    80001eae:	d89c                	sw	a5,48(s1)
    exit(-1);
    80001eb0:	557d                	li	a0,-1
    80001eb2:	00000097          	auipc	ra,0x0
    80001eb6:	a54080e7          	jalr	-1452(ra) # 80001906 <exit>
  if(which_dev == 2)
    80001eba:	4789                	li	a5,2
    80001ebc:	f8f910e3          	bne	s2,a5,80001e3c <usertrap+0x62>
    yield();
    80001ec0:	fffff097          	auipc	ra,0xfffff
    80001ec4:	7ae080e7          	jalr	1966(ra) # 8000166e <yield>
    80001ec8:	bf95                	j	80001e3c <usertrap+0x62>
  int which_dev = 0;
    80001eca:	4901                	li	s2,0
    80001ecc:	b7d5                	j	80001eb0 <usertrap+0xd6>

0000000080001ece <kerneltrap>:
{
    80001ece:	7179                	addi	sp,sp,-48
    80001ed0:	f406                	sd	ra,40(sp)
    80001ed2:	f022                	sd	s0,32(sp)
    80001ed4:	ec26                	sd	s1,24(sp)
    80001ed6:	e84a                	sd	s2,16(sp)
    80001ed8:	e44e                	sd	s3,8(sp)
    80001eda:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001edc:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ee0:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ee4:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001ee8:	1004f793          	andi	a5,s1,256
    80001eec:	cb85                	beqz	a5,80001f1c <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001eee:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001ef2:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001ef4:	ef85                	bnez	a5,80001f2c <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001ef6:	00000097          	auipc	ra,0x0
    80001efa:	e42080e7          	jalr	-446(ra) # 80001d38 <devintr>
    80001efe:	cd1d                	beqz	a0,80001f3c <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f00:	4789                	li	a5,2
    80001f02:	06f50a63          	beq	a0,a5,80001f76 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001f06:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f0a:	10049073          	csrw	sstatus,s1
}
    80001f0e:	70a2                	ld	ra,40(sp)
    80001f10:	7402                	ld	s0,32(sp)
    80001f12:	64e2                	ld	s1,24(sp)
    80001f14:	6942                	ld	s2,16(sp)
    80001f16:	69a2                	ld	s3,8(sp)
    80001f18:	6145                	addi	sp,sp,48
    80001f1a:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001f1c:	00006517          	auipc	a0,0x6
    80001f20:	44c50513          	addi	a0,a0,1100 # 80008368 <states.0+0xc8>
    80001f24:	00004097          	auipc	ra,0x4
    80001f28:	e7c080e7          	jalr	-388(ra) # 80005da0 <panic>
    panic("kerneltrap: interrupts enabled");
    80001f2c:	00006517          	auipc	a0,0x6
    80001f30:	46450513          	addi	a0,a0,1124 # 80008390 <states.0+0xf0>
    80001f34:	00004097          	auipc	ra,0x4
    80001f38:	e6c080e7          	jalr	-404(ra) # 80005da0 <panic>
    printf("scause %p\n", scause);
    80001f3c:	85ce                	mv	a1,s3
    80001f3e:	00006517          	auipc	a0,0x6
    80001f42:	47250513          	addi	a0,a0,1138 # 800083b0 <states.0+0x110>
    80001f46:	00004097          	auipc	ra,0x4
    80001f4a:	ea4080e7          	jalr	-348(ra) # 80005dea <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f4e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f52:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f56:	00006517          	auipc	a0,0x6
    80001f5a:	46a50513          	addi	a0,a0,1130 # 800083c0 <states.0+0x120>
    80001f5e:	00004097          	auipc	ra,0x4
    80001f62:	e8c080e7          	jalr	-372(ra) # 80005dea <printf>
    panic("kerneltrap");
    80001f66:	00006517          	auipc	a0,0x6
    80001f6a:	47250513          	addi	a0,a0,1138 # 800083d8 <states.0+0x138>
    80001f6e:	00004097          	auipc	ra,0x4
    80001f72:	e32080e7          	jalr	-462(ra) # 80005da0 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f76:	fffff097          	auipc	ra,0xfffff
    80001f7a:	fc0080e7          	jalr	-64(ra) # 80000f36 <myproc>
    80001f7e:	d541                	beqz	a0,80001f06 <kerneltrap+0x38>
    80001f80:	fffff097          	auipc	ra,0xfffff
    80001f84:	fb6080e7          	jalr	-74(ra) # 80000f36 <myproc>
    80001f88:	5118                	lw	a4,32(a0)
    80001f8a:	4791                	li	a5,4
    80001f8c:	f6f71de3          	bne	a4,a5,80001f06 <kerneltrap+0x38>
    yield();
    80001f90:	fffff097          	auipc	ra,0xfffff
    80001f94:	6de080e7          	jalr	1758(ra) # 8000166e <yield>
    80001f98:	b7bd                	j	80001f06 <kerneltrap+0x38>

0000000080001f9a <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001f9a:	1101                	addi	sp,sp,-32
    80001f9c:	ec06                	sd	ra,24(sp)
    80001f9e:	e822                	sd	s0,16(sp)
    80001fa0:	e426                	sd	s1,8(sp)
    80001fa2:	1000                	addi	s0,sp,32
    80001fa4:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001fa6:	fffff097          	auipc	ra,0xfffff
    80001faa:	f90080e7          	jalr	-112(ra) # 80000f36 <myproc>
  switch (n) {
    80001fae:	4795                	li	a5,5
    80001fb0:	0497e163          	bltu	a5,s1,80001ff2 <argraw+0x58>
    80001fb4:	048a                	slli	s1,s1,0x2
    80001fb6:	00006717          	auipc	a4,0x6
    80001fba:	45a70713          	addi	a4,a4,1114 # 80008410 <states.0+0x170>
    80001fbe:	94ba                	add	s1,s1,a4
    80001fc0:	409c                	lw	a5,0(s1)
    80001fc2:	97ba                	add	a5,a5,a4
    80001fc4:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001fc6:	713c                	ld	a5,96(a0)
    80001fc8:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001fca:	60e2                	ld	ra,24(sp)
    80001fcc:	6442                	ld	s0,16(sp)
    80001fce:	64a2                	ld	s1,8(sp)
    80001fd0:	6105                	addi	sp,sp,32
    80001fd2:	8082                	ret
    return p->trapframe->a1;
    80001fd4:	713c                	ld	a5,96(a0)
    80001fd6:	7fa8                	ld	a0,120(a5)
    80001fd8:	bfcd                	j	80001fca <argraw+0x30>
    return p->trapframe->a2;
    80001fda:	713c                	ld	a5,96(a0)
    80001fdc:	63c8                	ld	a0,128(a5)
    80001fde:	b7f5                	j	80001fca <argraw+0x30>
    return p->trapframe->a3;
    80001fe0:	713c                	ld	a5,96(a0)
    80001fe2:	67c8                	ld	a0,136(a5)
    80001fe4:	b7dd                	j	80001fca <argraw+0x30>
    return p->trapframe->a4;
    80001fe6:	713c                	ld	a5,96(a0)
    80001fe8:	6bc8                	ld	a0,144(a5)
    80001fea:	b7c5                	j	80001fca <argraw+0x30>
    return p->trapframe->a5;
    80001fec:	713c                	ld	a5,96(a0)
    80001fee:	6fc8                	ld	a0,152(a5)
    80001ff0:	bfe9                	j	80001fca <argraw+0x30>
  panic("argraw");
    80001ff2:	00006517          	auipc	a0,0x6
    80001ff6:	3f650513          	addi	a0,a0,1014 # 800083e8 <states.0+0x148>
    80001ffa:	00004097          	auipc	ra,0x4
    80001ffe:	da6080e7          	jalr	-602(ra) # 80005da0 <panic>

0000000080002002 <fetchaddr>:
{
    80002002:	1101                	addi	sp,sp,-32
    80002004:	ec06                	sd	ra,24(sp)
    80002006:	e822                	sd	s0,16(sp)
    80002008:	e426                	sd	s1,8(sp)
    8000200a:	e04a                	sd	s2,0(sp)
    8000200c:	1000                	addi	s0,sp,32
    8000200e:	84aa                	mv	s1,a0
    80002010:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002012:	fffff097          	auipc	ra,0xfffff
    80002016:	f24080e7          	jalr	-220(ra) # 80000f36 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    8000201a:	693c                	ld	a5,80(a0)
    8000201c:	02f4f863          	bgeu	s1,a5,8000204c <fetchaddr+0x4a>
    80002020:	00848713          	addi	a4,s1,8
    80002024:	02e7e663          	bltu	a5,a4,80002050 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002028:	46a1                	li	a3,8
    8000202a:	8626                	mv	a2,s1
    8000202c:	85ca                	mv	a1,s2
    8000202e:	6d28                	ld	a0,88(a0)
    80002030:	fffff097          	auipc	ra,0xfffff
    80002034:	b64080e7          	jalr	-1180(ra) # 80000b94 <copyin>
    80002038:	00a03533          	snez	a0,a0
    8000203c:	40a00533          	neg	a0,a0
}
    80002040:	60e2                	ld	ra,24(sp)
    80002042:	6442                	ld	s0,16(sp)
    80002044:	64a2                	ld	s1,8(sp)
    80002046:	6902                	ld	s2,0(sp)
    80002048:	6105                	addi	sp,sp,32
    8000204a:	8082                	ret
    return -1;
    8000204c:	557d                	li	a0,-1
    8000204e:	bfcd                	j	80002040 <fetchaddr+0x3e>
    80002050:	557d                	li	a0,-1
    80002052:	b7fd                	j	80002040 <fetchaddr+0x3e>

0000000080002054 <fetchstr>:
{
    80002054:	7179                	addi	sp,sp,-48
    80002056:	f406                	sd	ra,40(sp)
    80002058:	f022                	sd	s0,32(sp)
    8000205a:	ec26                	sd	s1,24(sp)
    8000205c:	e84a                	sd	s2,16(sp)
    8000205e:	e44e                	sd	s3,8(sp)
    80002060:	1800                	addi	s0,sp,48
    80002062:	892a                	mv	s2,a0
    80002064:	84ae                	mv	s1,a1
    80002066:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002068:	fffff097          	auipc	ra,0xfffff
    8000206c:	ece080e7          	jalr	-306(ra) # 80000f36 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002070:	86ce                	mv	a3,s3
    80002072:	864a                	mv	a2,s2
    80002074:	85a6                	mv	a1,s1
    80002076:	6d28                	ld	a0,88(a0)
    80002078:	fffff097          	auipc	ra,0xfffff
    8000207c:	baa080e7          	jalr	-1110(ra) # 80000c22 <copyinstr>
  if(err < 0)
    80002080:	00054763          	bltz	a0,8000208e <fetchstr+0x3a>
  return strlen(buf);
    80002084:	8526                	mv	a0,s1
    80002086:	ffffe097          	auipc	ra,0xffffe
    8000208a:	270080e7          	jalr	624(ra) # 800002f6 <strlen>
}
    8000208e:	70a2                	ld	ra,40(sp)
    80002090:	7402                	ld	s0,32(sp)
    80002092:	64e2                	ld	s1,24(sp)
    80002094:	6942                	ld	s2,16(sp)
    80002096:	69a2                	ld	s3,8(sp)
    80002098:	6145                	addi	sp,sp,48
    8000209a:	8082                	ret

000000008000209c <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    8000209c:	1101                	addi	sp,sp,-32
    8000209e:	ec06                	sd	ra,24(sp)
    800020a0:	e822                	sd	s0,16(sp)
    800020a2:	e426                	sd	s1,8(sp)
    800020a4:	1000                	addi	s0,sp,32
    800020a6:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800020a8:	00000097          	auipc	ra,0x0
    800020ac:	ef2080e7          	jalr	-270(ra) # 80001f9a <argraw>
    800020b0:	c088                	sw	a0,0(s1)
  return 0;
}
    800020b2:	4501                	li	a0,0
    800020b4:	60e2                	ld	ra,24(sp)
    800020b6:	6442                	ld	s0,16(sp)
    800020b8:	64a2                	ld	s1,8(sp)
    800020ba:	6105                	addi	sp,sp,32
    800020bc:	8082                	ret

00000000800020be <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    800020be:	1101                	addi	sp,sp,-32
    800020c0:	ec06                	sd	ra,24(sp)
    800020c2:	e822                	sd	s0,16(sp)
    800020c4:	e426                	sd	s1,8(sp)
    800020c6:	1000                	addi	s0,sp,32
    800020c8:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800020ca:	00000097          	auipc	ra,0x0
    800020ce:	ed0080e7          	jalr	-304(ra) # 80001f9a <argraw>
    800020d2:	e088                	sd	a0,0(s1)
  return 0;
}
    800020d4:	4501                	li	a0,0
    800020d6:	60e2                	ld	ra,24(sp)
    800020d8:	6442                	ld	s0,16(sp)
    800020da:	64a2                	ld	s1,8(sp)
    800020dc:	6105                	addi	sp,sp,32
    800020de:	8082                	ret

00000000800020e0 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800020e0:	1101                	addi	sp,sp,-32
    800020e2:	ec06                	sd	ra,24(sp)
    800020e4:	e822                	sd	s0,16(sp)
    800020e6:	e426                	sd	s1,8(sp)
    800020e8:	e04a                	sd	s2,0(sp)
    800020ea:	1000                	addi	s0,sp,32
    800020ec:	84ae                	mv	s1,a1
    800020ee:	8932                	mv	s2,a2
  *ip = argraw(n);
    800020f0:	00000097          	auipc	ra,0x0
    800020f4:	eaa080e7          	jalr	-342(ra) # 80001f9a <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    800020f8:	864a                	mv	a2,s2
    800020fa:	85a6                	mv	a1,s1
    800020fc:	00000097          	auipc	ra,0x0
    80002100:	f58080e7          	jalr	-168(ra) # 80002054 <fetchstr>
}
    80002104:	60e2                	ld	ra,24(sp)
    80002106:	6442                	ld	s0,16(sp)
    80002108:	64a2                	ld	s1,8(sp)
    8000210a:	6902                	ld	s2,0(sp)
    8000210c:	6105                	addi	sp,sp,32
    8000210e:	8082                	ret

0000000080002110 <syscall>:



void
syscall(void)
{
    80002110:	1101                	addi	sp,sp,-32
    80002112:	ec06                	sd	ra,24(sp)
    80002114:	e822                	sd	s0,16(sp)
    80002116:	e426                	sd	s1,8(sp)
    80002118:	e04a                	sd	s2,0(sp)
    8000211a:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000211c:	fffff097          	auipc	ra,0xfffff
    80002120:	e1a080e7          	jalr	-486(ra) # 80000f36 <myproc>
    80002124:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002126:	06053903          	ld	s2,96(a0)
    8000212a:	0a893783          	ld	a5,168(s2)
    8000212e:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002132:	37fd                	addiw	a5,a5,-1
    80002134:	4775                	li	a4,29
    80002136:	00f76f63          	bltu	a4,a5,80002154 <syscall+0x44>
    8000213a:	00369713          	slli	a4,a3,0x3
    8000213e:	00006797          	auipc	a5,0x6
    80002142:	2ea78793          	addi	a5,a5,746 # 80008428 <syscalls>
    80002146:	97ba                	add	a5,a5,a4
    80002148:	639c                	ld	a5,0(a5)
    8000214a:	c789                	beqz	a5,80002154 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    8000214c:	9782                	jalr	a5
    8000214e:	06a93823          	sd	a0,112(s2)
    80002152:	a839                	j	80002170 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002154:	16048613          	addi	a2,s1,352
    80002158:	5c8c                	lw	a1,56(s1)
    8000215a:	00006517          	auipc	a0,0x6
    8000215e:	29650513          	addi	a0,a0,662 # 800083f0 <states.0+0x150>
    80002162:	00004097          	auipc	ra,0x4
    80002166:	c88080e7          	jalr	-888(ra) # 80005dea <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000216a:	70bc                	ld	a5,96(s1)
    8000216c:	577d                	li	a4,-1
    8000216e:	fbb8                	sd	a4,112(a5)
  }
}
    80002170:	60e2                	ld	ra,24(sp)
    80002172:	6442                	ld	s0,16(sp)
    80002174:	64a2                	ld	s1,8(sp)
    80002176:	6902                	ld	s2,0(sp)
    80002178:	6105                	addi	sp,sp,32
    8000217a:	8082                	ret

000000008000217c <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000217c:	1101                	addi	sp,sp,-32
    8000217e:	ec06                	sd	ra,24(sp)
    80002180:	e822                	sd	s0,16(sp)
    80002182:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002184:	fec40593          	addi	a1,s0,-20
    80002188:	4501                	li	a0,0
    8000218a:	00000097          	auipc	ra,0x0
    8000218e:	f12080e7          	jalr	-238(ra) # 8000209c <argint>
    return -1;
    80002192:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002194:	00054963          	bltz	a0,800021a6 <sys_exit+0x2a>
  exit(n);
    80002198:	fec42503          	lw	a0,-20(s0)
    8000219c:	fffff097          	auipc	ra,0xfffff
    800021a0:	76a080e7          	jalr	1898(ra) # 80001906 <exit>
  return 0;  // not reached
    800021a4:	4781                	li	a5,0
}
    800021a6:	853e                	mv	a0,a5
    800021a8:	60e2                	ld	ra,24(sp)
    800021aa:	6442                	ld	s0,16(sp)
    800021ac:	6105                	addi	sp,sp,32
    800021ae:	8082                	ret

00000000800021b0 <sys_getpid>:

uint64
sys_getpid(void)
{
    800021b0:	1141                	addi	sp,sp,-16
    800021b2:	e406                	sd	ra,8(sp)
    800021b4:	e022                	sd	s0,0(sp)
    800021b6:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800021b8:	fffff097          	auipc	ra,0xfffff
    800021bc:	d7e080e7          	jalr	-642(ra) # 80000f36 <myproc>
}
    800021c0:	5d08                	lw	a0,56(a0)
    800021c2:	60a2                	ld	ra,8(sp)
    800021c4:	6402                	ld	s0,0(sp)
    800021c6:	0141                	addi	sp,sp,16
    800021c8:	8082                	ret

00000000800021ca <sys_fork>:

uint64
sys_fork(void)
{
    800021ca:	1141                	addi	sp,sp,-16
    800021cc:	e406                	sd	ra,8(sp)
    800021ce:	e022                	sd	s0,0(sp)
    800021d0:	0800                	addi	s0,sp,16
  return fork();
    800021d2:	fffff097          	auipc	ra,0xfffff
    800021d6:	1e6080e7          	jalr	486(ra) # 800013b8 <fork>
}
    800021da:	60a2                	ld	ra,8(sp)
    800021dc:	6402                	ld	s0,0(sp)
    800021de:	0141                	addi	sp,sp,16
    800021e0:	8082                	ret

00000000800021e2 <sys_wait>:

uint64
sys_wait(void)
{
    800021e2:	1101                	addi	sp,sp,-32
    800021e4:	ec06                	sd	ra,24(sp)
    800021e6:	e822                	sd	s0,16(sp)
    800021e8:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    800021ea:	fe840593          	addi	a1,s0,-24
    800021ee:	4501                	li	a0,0
    800021f0:	00000097          	auipc	ra,0x0
    800021f4:	ece080e7          	jalr	-306(ra) # 800020be <argaddr>
    800021f8:	87aa                	mv	a5,a0
    return -1;
    800021fa:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    800021fc:	0007c863          	bltz	a5,8000220c <sys_wait+0x2a>
  return wait(p);
    80002200:	fe843503          	ld	a0,-24(s0)
    80002204:	fffff097          	auipc	ra,0xfffff
    80002208:	50a080e7          	jalr	1290(ra) # 8000170e <wait>
}
    8000220c:	60e2                	ld	ra,24(sp)
    8000220e:	6442                	ld	s0,16(sp)
    80002210:	6105                	addi	sp,sp,32
    80002212:	8082                	ret

0000000080002214 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002214:	7179                	addi	sp,sp,-48
    80002216:	f406                	sd	ra,40(sp)
    80002218:	f022                	sd	s0,32(sp)
    8000221a:	ec26                	sd	s1,24(sp)
    8000221c:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    8000221e:	fdc40593          	addi	a1,s0,-36
    80002222:	4501                	li	a0,0
    80002224:	00000097          	auipc	ra,0x0
    80002228:	e78080e7          	jalr	-392(ra) # 8000209c <argint>
    8000222c:	87aa                	mv	a5,a0
    return -1;
    8000222e:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002230:	0207c063          	bltz	a5,80002250 <sys_sbrk+0x3c>
  
  addr = myproc()->sz;
    80002234:	fffff097          	auipc	ra,0xfffff
    80002238:	d02080e7          	jalr	-766(ra) # 80000f36 <myproc>
    8000223c:	4924                	lw	s1,80(a0)
  if(growproc(n) < 0)
    8000223e:	fdc42503          	lw	a0,-36(s0)
    80002242:	fffff097          	auipc	ra,0xfffff
    80002246:	0fe080e7          	jalr	254(ra) # 80001340 <growproc>
    8000224a:	00054863          	bltz	a0,8000225a <sys_sbrk+0x46>
    return -1;
  return addr;
    8000224e:	8526                	mv	a0,s1
}
    80002250:	70a2                	ld	ra,40(sp)
    80002252:	7402                	ld	s0,32(sp)
    80002254:	64e2                	ld	s1,24(sp)
    80002256:	6145                	addi	sp,sp,48
    80002258:	8082                	ret
    return -1;
    8000225a:	557d                	li	a0,-1
    8000225c:	bfd5                	j	80002250 <sys_sbrk+0x3c>

000000008000225e <sys_sleep>:

uint64
sys_sleep(void)
{
    8000225e:	7139                	addi	sp,sp,-64
    80002260:	fc06                	sd	ra,56(sp)
    80002262:	f822                	sd	s0,48(sp)
    80002264:	f426                	sd	s1,40(sp)
    80002266:	f04a                	sd	s2,32(sp)
    80002268:	ec4e                	sd	s3,24(sp)
    8000226a:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;


  if(argint(0, &n) < 0)
    8000226c:	fcc40593          	addi	a1,s0,-52
    80002270:	4501                	li	a0,0
    80002272:	00000097          	auipc	ra,0x0
    80002276:	e2a080e7          	jalr	-470(ra) # 8000209c <argint>
    return -1;
    8000227a:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    8000227c:	06054563          	bltz	a0,800022e6 <sys_sleep+0x88>
  acquire(&tickslock);
    80002280:	0000d517          	auipc	a0,0xd
    80002284:	e0050513          	addi	a0,a0,-512 # 8000f080 <tickslock>
    80002288:	00004097          	auipc	ra,0x4
    8000228c:	050080e7          	jalr	80(ra) # 800062d8 <acquire>
  ticks0 = ticks;
    80002290:	00007917          	auipc	s2,0x7
    80002294:	d8892903          	lw	s2,-632(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    80002298:	fcc42783          	lw	a5,-52(s0)
    8000229c:	cf85                	beqz	a5,800022d4 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000229e:	0000d997          	auipc	s3,0xd
    800022a2:	de298993          	addi	s3,s3,-542 # 8000f080 <tickslock>
    800022a6:	00007497          	auipc	s1,0x7
    800022aa:	d7248493          	addi	s1,s1,-654 # 80009018 <ticks>
    if(myproc()->killed){
    800022ae:	fffff097          	auipc	ra,0xfffff
    800022b2:	c88080e7          	jalr	-888(ra) # 80000f36 <myproc>
    800022b6:	591c                	lw	a5,48(a0)
    800022b8:	ef9d                	bnez	a5,800022f6 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800022ba:	85ce                	mv	a1,s3
    800022bc:	8526                	mv	a0,s1
    800022be:	fffff097          	auipc	ra,0xfffff
    800022c2:	3ec080e7          	jalr	1004(ra) # 800016aa <sleep>
  while(ticks - ticks0 < n){
    800022c6:	409c                	lw	a5,0(s1)
    800022c8:	412787bb          	subw	a5,a5,s2
    800022cc:	fcc42703          	lw	a4,-52(s0)
    800022d0:	fce7efe3          	bltu	a5,a4,800022ae <sys_sleep+0x50>
  }
  release(&tickslock);
    800022d4:	0000d517          	auipc	a0,0xd
    800022d8:	dac50513          	addi	a0,a0,-596 # 8000f080 <tickslock>
    800022dc:	00004097          	auipc	ra,0x4
    800022e0:	0b0080e7          	jalr	176(ra) # 8000638c <release>
  return 0;
    800022e4:	4781                	li	a5,0
}
    800022e6:	853e                	mv	a0,a5
    800022e8:	70e2                	ld	ra,56(sp)
    800022ea:	7442                	ld	s0,48(sp)
    800022ec:	74a2                	ld	s1,40(sp)
    800022ee:	7902                	ld	s2,32(sp)
    800022f0:	69e2                	ld	s3,24(sp)
    800022f2:	6121                	addi	sp,sp,64
    800022f4:	8082                	ret
      release(&tickslock);
    800022f6:	0000d517          	auipc	a0,0xd
    800022fa:	d8a50513          	addi	a0,a0,-630 # 8000f080 <tickslock>
    800022fe:	00004097          	auipc	ra,0x4
    80002302:	08e080e7          	jalr	142(ra) # 8000638c <release>
      return -1;
    80002306:	57fd                	li	a5,-1
    80002308:	bff9                	j	800022e6 <sys_sleep+0x88>

000000008000230a <sys_pgaccess>:
// 在这里声明对kernel/vm.c/walk函数的引用声明
extern pte_t * walk(pagetable_t, uint64, int);

int
sys_pgaccess(void)
{
    8000230a:	715d                	addi	sp,sp,-80
    8000230c:	e486                	sd	ra,72(sp)
    8000230e:	e0a2                	sd	s0,64(sp)
    80002310:	fc26                	sd	s1,56(sp)
    80002312:	f84a                	sd	s2,48(sp)
    80002314:	f44e                	sd	s3,40(sp)
    80002316:	0880                	addi	s0,sp,80
  // lab pgtbl: your code here.
  // 在内核态下声明一个BitMask，用来存放结果
  uint64 BitMask = 0;
    80002318:	fc043423          	sd	zero,-56(s0)
  uint64 StartVA;
  int NumberOfPages;
  uint64 BitMaskVA;
  
  // 首先读取要访问的页面数量
  if(argint(1, &NumberOfPages) < 0)
    8000231c:	fbc40593          	addi	a1,s0,-68
    80002320:	4505                	li	a0,1
    80002322:	00000097          	auipc	ra,0x0
    80002326:	d7a080e7          	jalr	-646(ra) # 8000209c <argint>
    8000232a:	0c054763          	bltz	a0,800023f8 <sys_pgaccess+0xee>
    return -1;
  
  // 如果页面数量超过了一次可以读取的最大范围
  // 系统调用直接返回
  if(NumberOfPages > MAXSCAN)
    8000232e:	fbc42703          	lw	a4,-68(s0)
    80002332:	02000793          	li	a5,32
    80002336:	0ce7c363          	blt	a5,a4,800023fc <sys_pgaccess+0xf2>
    return -1;                    
  
  // 读取页面开始地址和指向用户态存放结果的BitMask的指针
  if(argaddr(0, &StartVA) < 0)
    8000233a:	fc040593          	addi	a1,s0,-64
    8000233e:	4501                	li	a0,0
    80002340:	00000097          	auipc	ra,0x0
    80002344:	d7e080e7          	jalr	-642(ra) # 800020be <argaddr>
    80002348:	0a054c63          	bltz	a0,80002400 <sys_pgaccess+0xf6>
    return -1;
  if(argaddr(2, &BitMaskVA) < 0)
    8000234c:	fb040593          	addi	a1,s0,-80
    80002350:	4509                	li	a0,2
    80002352:	00000097          	auipc	ra,0x0
    80002356:	d6c080e7          	jalr	-660(ra) # 800020be <argaddr>
    8000235a:	0a054563          	bltz	a0,80002404 <sys_pgaccess+0xfa>
  int i;
  pte_t* pte;
	
  // 从起始地址开始，逐页判断PTE_A是否被置位
  // 如果被置位，则设置对应BitMask的位，并将PTE_A清空
  for(i = 0 ; i < NumberOfPages ; StartVA += PGSIZE, ++i){
    8000235e:	fbc42783          	lw	a5,-68(s0)
    80002362:	06f05563          	blez	a5,800023cc <sys_pgaccess+0xc2>
    80002366:	4481                	li	s1,0
    if((pte = walk(myproc()->pagetable, StartVA, 0)) == 0)
      panic("pgaccess : walk failed");
    if(*pte & PTE_A){
      BitMask |= 1 << i;	// 设置BitMask对应位
    80002368:	4985                	li	s3,1
  for(i = 0 ; i < NumberOfPages ; StartVA += PGSIZE, ++i){
    8000236a:	6905                	lui	s2,0x1
    8000236c:	a01d                	j	80002392 <sys_pgaccess+0x88>
      panic("pgaccess : walk failed");
    8000236e:	00006517          	auipc	a0,0x6
    80002372:	1b250513          	addi	a0,a0,434 # 80008520 <syscalls+0xf8>
    80002376:	00004097          	auipc	ra,0x4
    8000237a:	a2a080e7          	jalr	-1494(ra) # 80005da0 <panic>
  for(i = 0 ; i < NumberOfPages ; StartVA += PGSIZE, ++i){
    8000237e:	fc043783          	ld	a5,-64(s0)
    80002382:	97ca                	add	a5,a5,s2
    80002384:	fcf43023          	sd	a5,-64(s0)
    80002388:	2485                	addiw	s1,s1,1
    8000238a:	fbc42783          	lw	a5,-68(s0)
    8000238e:	02f4df63          	bge	s1,a5,800023cc <sys_pgaccess+0xc2>
    if((pte = walk(myproc()->pagetable, StartVA, 0)) == 0)
    80002392:	fffff097          	auipc	ra,0xfffff
    80002396:	ba4080e7          	jalr	-1116(ra) # 80000f36 <myproc>
    8000239a:	4601                	li	a2,0
    8000239c:	fc043583          	ld	a1,-64(s0)
    800023a0:	6d28                	ld	a0,88(a0)
    800023a2:	ffffe097          	auipc	ra,0xffffe
    800023a6:	0b8080e7          	jalr	184(ra) # 8000045a <walk>
    800023aa:	d171                	beqz	a0,8000236e <sys_pgaccess+0x64>
    if(*pte & PTE_A){
    800023ac:	611c                	ld	a5,0(a0)
    800023ae:	0407f793          	andi	a5,a5,64
    800023b2:	d7f1                	beqz	a5,8000237e <sys_pgaccess+0x74>
      BitMask |= 1 << i;	// 设置BitMask对应位
    800023b4:	0099973b          	sllw	a4,s3,s1
    800023b8:	fc843783          	ld	a5,-56(s0)
    800023bc:	8fd9                	or	a5,a5,a4
    800023be:	fcf43423          	sd	a5,-56(s0)
      *pte &= ~PTE_A;		// 将PTE_A清空
    800023c2:	611c                	ld	a5,0(a0)
    800023c4:	fbf7f793          	andi	a5,a5,-65
    800023c8:	e11c                	sd	a5,0(a0)
    800023ca:	bf55                	j	8000237e <sys_pgaccess+0x74>
    }
  }
  
  // 最后使用copyout将内核态下的BitMask拷贝到用户态
  copyout(myproc()->pagetable, BitMaskVA, (char*)&BitMask, sizeof(BitMask));
    800023cc:	fffff097          	auipc	ra,0xfffff
    800023d0:	b6a080e7          	jalr	-1174(ra) # 80000f36 <myproc>
    800023d4:	46a1                	li	a3,8
    800023d6:	fc840613          	addi	a2,s0,-56
    800023da:	fb043583          	ld	a1,-80(s0)
    800023de:	6d28                	ld	a0,88(a0)
    800023e0:	ffffe097          	auipc	ra,0xffffe
    800023e4:	728080e7          	jalr	1832(ra) # 80000b08 <copyout>

  return 0;
    800023e8:	4501                	li	a0,0
}
    800023ea:	60a6                	ld	ra,72(sp)
    800023ec:	6406                	ld	s0,64(sp)
    800023ee:	74e2                	ld	s1,56(sp)
    800023f0:	7942                	ld	s2,48(sp)
    800023f2:	79a2                	ld	s3,40(sp)
    800023f4:	6161                	addi	sp,sp,80
    800023f6:	8082                	ret
    return -1;
    800023f8:	557d                	li	a0,-1
    800023fa:	bfc5                	j	800023ea <sys_pgaccess+0xe0>
    return -1;                    
    800023fc:	557d                	li	a0,-1
    800023fe:	b7f5                	j	800023ea <sys_pgaccess+0xe0>
    return -1;
    80002400:	557d                	li	a0,-1
    80002402:	b7e5                	j	800023ea <sys_pgaccess+0xe0>
    return -1;
    80002404:	557d                	li	a0,-1
    80002406:	b7d5                	j	800023ea <sys_pgaccess+0xe0>

0000000080002408 <sys_kill>:
#endif

uint64
sys_kill(void)
{
    80002408:	1101                	addi	sp,sp,-32
    8000240a:	ec06                	sd	ra,24(sp)
    8000240c:	e822                	sd	s0,16(sp)
    8000240e:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002410:	fec40593          	addi	a1,s0,-20
    80002414:	4501                	li	a0,0
    80002416:	00000097          	auipc	ra,0x0
    8000241a:	c86080e7          	jalr	-890(ra) # 8000209c <argint>
    8000241e:	87aa                	mv	a5,a0
    return -1;
    80002420:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002422:	0007c863          	bltz	a5,80002432 <sys_kill+0x2a>
  return kill(pid);
    80002426:	fec42503          	lw	a0,-20(s0)
    8000242a:	fffff097          	auipc	ra,0xfffff
    8000242e:	5b2080e7          	jalr	1458(ra) # 800019dc <kill>
}
    80002432:	60e2                	ld	ra,24(sp)
    80002434:	6442                	ld	s0,16(sp)
    80002436:	6105                	addi	sp,sp,32
    80002438:	8082                	ret

000000008000243a <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000243a:	1101                	addi	sp,sp,-32
    8000243c:	ec06                	sd	ra,24(sp)
    8000243e:	e822                	sd	s0,16(sp)
    80002440:	e426                	sd	s1,8(sp)
    80002442:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002444:	0000d517          	auipc	a0,0xd
    80002448:	c3c50513          	addi	a0,a0,-964 # 8000f080 <tickslock>
    8000244c:	00004097          	auipc	ra,0x4
    80002450:	e8c080e7          	jalr	-372(ra) # 800062d8 <acquire>
  xticks = ticks;
    80002454:	00007497          	auipc	s1,0x7
    80002458:	bc44a483          	lw	s1,-1084(s1) # 80009018 <ticks>
  release(&tickslock);
    8000245c:	0000d517          	auipc	a0,0xd
    80002460:	c2450513          	addi	a0,a0,-988 # 8000f080 <tickslock>
    80002464:	00004097          	auipc	ra,0x4
    80002468:	f28080e7          	jalr	-216(ra) # 8000638c <release>
  return xticks;
}
    8000246c:	02049513          	slli	a0,s1,0x20
    80002470:	9101                	srli	a0,a0,0x20
    80002472:	60e2                	ld	ra,24(sp)
    80002474:	6442                	ld	s0,16(sp)
    80002476:	64a2                	ld	s1,8(sp)
    80002478:	6105                	addi	sp,sp,32
    8000247a:	8082                	ret

000000008000247c <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000247c:	7179                	addi	sp,sp,-48
    8000247e:	f406                	sd	ra,40(sp)
    80002480:	f022                	sd	s0,32(sp)
    80002482:	ec26                	sd	s1,24(sp)
    80002484:	e84a                	sd	s2,16(sp)
    80002486:	e44e                	sd	s3,8(sp)
    80002488:	e052                	sd	s4,0(sp)
    8000248a:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000248c:	00006597          	auipc	a1,0x6
    80002490:	0ac58593          	addi	a1,a1,172 # 80008538 <syscalls+0x110>
    80002494:	0000d517          	auipc	a0,0xd
    80002498:	c0450513          	addi	a0,a0,-1020 # 8000f098 <bcache>
    8000249c:	00004097          	auipc	ra,0x4
    800024a0:	dac080e7          	jalr	-596(ra) # 80006248 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800024a4:	00015797          	auipc	a5,0x15
    800024a8:	bf478793          	addi	a5,a5,-1036 # 80017098 <bcache+0x8000>
    800024ac:	00015717          	auipc	a4,0x15
    800024b0:	e5470713          	addi	a4,a4,-428 # 80017300 <bcache+0x8268>
    800024b4:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800024b8:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800024bc:	0000d497          	auipc	s1,0xd
    800024c0:	bf448493          	addi	s1,s1,-1036 # 8000f0b0 <bcache+0x18>
    b->next = bcache.head.next;
    800024c4:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800024c6:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800024c8:	00006a17          	auipc	s4,0x6
    800024cc:	078a0a13          	addi	s4,s4,120 # 80008540 <syscalls+0x118>
    b->next = bcache.head.next;
    800024d0:	2b893783          	ld	a5,696(s2) # 12b8 <_entry-0x7fffed48>
    800024d4:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800024d6:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800024da:	85d2                	mv	a1,s4
    800024dc:	01048513          	addi	a0,s1,16
    800024e0:	00001097          	auipc	ra,0x1
    800024e4:	4c2080e7          	jalr	1218(ra) # 800039a2 <initsleeplock>
    bcache.head.next->prev = b;
    800024e8:	2b893783          	ld	a5,696(s2)
    800024ec:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800024ee:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800024f2:	45848493          	addi	s1,s1,1112
    800024f6:	fd349de3          	bne	s1,s3,800024d0 <binit+0x54>
  }
}
    800024fa:	70a2                	ld	ra,40(sp)
    800024fc:	7402                	ld	s0,32(sp)
    800024fe:	64e2                	ld	s1,24(sp)
    80002500:	6942                	ld	s2,16(sp)
    80002502:	69a2                	ld	s3,8(sp)
    80002504:	6a02                	ld	s4,0(sp)
    80002506:	6145                	addi	sp,sp,48
    80002508:	8082                	ret

000000008000250a <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000250a:	7179                	addi	sp,sp,-48
    8000250c:	f406                	sd	ra,40(sp)
    8000250e:	f022                	sd	s0,32(sp)
    80002510:	ec26                	sd	s1,24(sp)
    80002512:	e84a                	sd	s2,16(sp)
    80002514:	e44e                	sd	s3,8(sp)
    80002516:	1800                	addi	s0,sp,48
    80002518:	892a                	mv	s2,a0
    8000251a:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000251c:	0000d517          	auipc	a0,0xd
    80002520:	b7c50513          	addi	a0,a0,-1156 # 8000f098 <bcache>
    80002524:	00004097          	auipc	ra,0x4
    80002528:	db4080e7          	jalr	-588(ra) # 800062d8 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000252c:	00015497          	auipc	s1,0x15
    80002530:	e244b483          	ld	s1,-476(s1) # 80017350 <bcache+0x82b8>
    80002534:	00015797          	auipc	a5,0x15
    80002538:	dcc78793          	addi	a5,a5,-564 # 80017300 <bcache+0x8268>
    8000253c:	02f48f63          	beq	s1,a5,8000257a <bread+0x70>
    80002540:	873e                	mv	a4,a5
    80002542:	a021                	j	8000254a <bread+0x40>
    80002544:	68a4                	ld	s1,80(s1)
    80002546:	02e48a63          	beq	s1,a4,8000257a <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000254a:	449c                	lw	a5,8(s1)
    8000254c:	ff279ce3          	bne	a5,s2,80002544 <bread+0x3a>
    80002550:	44dc                	lw	a5,12(s1)
    80002552:	ff3799e3          	bne	a5,s3,80002544 <bread+0x3a>
      b->refcnt++;
    80002556:	40bc                	lw	a5,64(s1)
    80002558:	2785                	addiw	a5,a5,1
    8000255a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000255c:	0000d517          	auipc	a0,0xd
    80002560:	b3c50513          	addi	a0,a0,-1220 # 8000f098 <bcache>
    80002564:	00004097          	auipc	ra,0x4
    80002568:	e28080e7          	jalr	-472(ra) # 8000638c <release>
      acquiresleep(&b->lock);
    8000256c:	01048513          	addi	a0,s1,16
    80002570:	00001097          	auipc	ra,0x1
    80002574:	46c080e7          	jalr	1132(ra) # 800039dc <acquiresleep>
      return b;
    80002578:	a8b9                	j	800025d6 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000257a:	00015497          	auipc	s1,0x15
    8000257e:	dce4b483          	ld	s1,-562(s1) # 80017348 <bcache+0x82b0>
    80002582:	00015797          	auipc	a5,0x15
    80002586:	d7e78793          	addi	a5,a5,-642 # 80017300 <bcache+0x8268>
    8000258a:	00f48863          	beq	s1,a5,8000259a <bread+0x90>
    8000258e:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002590:	40bc                	lw	a5,64(s1)
    80002592:	cf81                	beqz	a5,800025aa <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002594:	64a4                	ld	s1,72(s1)
    80002596:	fee49de3          	bne	s1,a4,80002590 <bread+0x86>
  panic("bget: no buffers");
    8000259a:	00006517          	auipc	a0,0x6
    8000259e:	fae50513          	addi	a0,a0,-82 # 80008548 <syscalls+0x120>
    800025a2:	00003097          	auipc	ra,0x3
    800025a6:	7fe080e7          	jalr	2046(ra) # 80005da0 <panic>
      b->dev = dev;
    800025aa:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800025ae:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800025b2:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800025b6:	4785                	li	a5,1
    800025b8:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800025ba:	0000d517          	auipc	a0,0xd
    800025be:	ade50513          	addi	a0,a0,-1314 # 8000f098 <bcache>
    800025c2:	00004097          	auipc	ra,0x4
    800025c6:	dca080e7          	jalr	-566(ra) # 8000638c <release>
      acquiresleep(&b->lock);
    800025ca:	01048513          	addi	a0,s1,16
    800025ce:	00001097          	auipc	ra,0x1
    800025d2:	40e080e7          	jalr	1038(ra) # 800039dc <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800025d6:	409c                	lw	a5,0(s1)
    800025d8:	cb89                	beqz	a5,800025ea <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800025da:	8526                	mv	a0,s1
    800025dc:	70a2                	ld	ra,40(sp)
    800025de:	7402                	ld	s0,32(sp)
    800025e0:	64e2                	ld	s1,24(sp)
    800025e2:	6942                	ld	s2,16(sp)
    800025e4:	69a2                	ld	s3,8(sp)
    800025e6:	6145                	addi	sp,sp,48
    800025e8:	8082                	ret
    virtio_disk_rw(b, 0);
    800025ea:	4581                	li	a1,0
    800025ec:	8526                	mv	a0,s1
    800025ee:	00003097          	auipc	ra,0x3
    800025f2:	f44080e7          	jalr	-188(ra) # 80005532 <virtio_disk_rw>
    b->valid = 1;
    800025f6:	4785                	li	a5,1
    800025f8:	c09c                	sw	a5,0(s1)
  return b;
    800025fa:	b7c5                	j	800025da <bread+0xd0>

00000000800025fc <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800025fc:	1101                	addi	sp,sp,-32
    800025fe:	ec06                	sd	ra,24(sp)
    80002600:	e822                	sd	s0,16(sp)
    80002602:	e426                	sd	s1,8(sp)
    80002604:	1000                	addi	s0,sp,32
    80002606:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002608:	0541                	addi	a0,a0,16
    8000260a:	00001097          	auipc	ra,0x1
    8000260e:	46c080e7          	jalr	1132(ra) # 80003a76 <holdingsleep>
    80002612:	cd01                	beqz	a0,8000262a <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002614:	4585                	li	a1,1
    80002616:	8526                	mv	a0,s1
    80002618:	00003097          	auipc	ra,0x3
    8000261c:	f1a080e7          	jalr	-230(ra) # 80005532 <virtio_disk_rw>
}
    80002620:	60e2                	ld	ra,24(sp)
    80002622:	6442                	ld	s0,16(sp)
    80002624:	64a2                	ld	s1,8(sp)
    80002626:	6105                	addi	sp,sp,32
    80002628:	8082                	ret
    panic("bwrite");
    8000262a:	00006517          	auipc	a0,0x6
    8000262e:	f3650513          	addi	a0,a0,-202 # 80008560 <syscalls+0x138>
    80002632:	00003097          	auipc	ra,0x3
    80002636:	76e080e7          	jalr	1902(ra) # 80005da0 <panic>

000000008000263a <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000263a:	1101                	addi	sp,sp,-32
    8000263c:	ec06                	sd	ra,24(sp)
    8000263e:	e822                	sd	s0,16(sp)
    80002640:	e426                	sd	s1,8(sp)
    80002642:	e04a                	sd	s2,0(sp)
    80002644:	1000                	addi	s0,sp,32
    80002646:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002648:	01050913          	addi	s2,a0,16
    8000264c:	854a                	mv	a0,s2
    8000264e:	00001097          	auipc	ra,0x1
    80002652:	428080e7          	jalr	1064(ra) # 80003a76 <holdingsleep>
    80002656:	c92d                	beqz	a0,800026c8 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002658:	854a                	mv	a0,s2
    8000265a:	00001097          	auipc	ra,0x1
    8000265e:	3d8080e7          	jalr	984(ra) # 80003a32 <releasesleep>

  acquire(&bcache.lock);
    80002662:	0000d517          	auipc	a0,0xd
    80002666:	a3650513          	addi	a0,a0,-1482 # 8000f098 <bcache>
    8000266a:	00004097          	auipc	ra,0x4
    8000266e:	c6e080e7          	jalr	-914(ra) # 800062d8 <acquire>
  b->refcnt--;
    80002672:	40bc                	lw	a5,64(s1)
    80002674:	37fd                	addiw	a5,a5,-1
    80002676:	0007871b          	sext.w	a4,a5
    8000267a:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000267c:	eb05                	bnez	a4,800026ac <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000267e:	68bc                	ld	a5,80(s1)
    80002680:	64b8                	ld	a4,72(s1)
    80002682:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002684:	64bc                	ld	a5,72(s1)
    80002686:	68b8                	ld	a4,80(s1)
    80002688:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000268a:	00015797          	auipc	a5,0x15
    8000268e:	a0e78793          	addi	a5,a5,-1522 # 80017098 <bcache+0x8000>
    80002692:	2b87b703          	ld	a4,696(a5)
    80002696:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002698:	00015717          	auipc	a4,0x15
    8000269c:	c6870713          	addi	a4,a4,-920 # 80017300 <bcache+0x8268>
    800026a0:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800026a2:	2b87b703          	ld	a4,696(a5)
    800026a6:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800026a8:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800026ac:	0000d517          	auipc	a0,0xd
    800026b0:	9ec50513          	addi	a0,a0,-1556 # 8000f098 <bcache>
    800026b4:	00004097          	auipc	ra,0x4
    800026b8:	cd8080e7          	jalr	-808(ra) # 8000638c <release>
}
    800026bc:	60e2                	ld	ra,24(sp)
    800026be:	6442                	ld	s0,16(sp)
    800026c0:	64a2                	ld	s1,8(sp)
    800026c2:	6902                	ld	s2,0(sp)
    800026c4:	6105                	addi	sp,sp,32
    800026c6:	8082                	ret
    panic("brelse");
    800026c8:	00006517          	auipc	a0,0x6
    800026cc:	ea050513          	addi	a0,a0,-352 # 80008568 <syscalls+0x140>
    800026d0:	00003097          	auipc	ra,0x3
    800026d4:	6d0080e7          	jalr	1744(ra) # 80005da0 <panic>

00000000800026d8 <bpin>:

void
bpin(struct buf *b) {
    800026d8:	1101                	addi	sp,sp,-32
    800026da:	ec06                	sd	ra,24(sp)
    800026dc:	e822                	sd	s0,16(sp)
    800026de:	e426                	sd	s1,8(sp)
    800026e0:	1000                	addi	s0,sp,32
    800026e2:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800026e4:	0000d517          	auipc	a0,0xd
    800026e8:	9b450513          	addi	a0,a0,-1612 # 8000f098 <bcache>
    800026ec:	00004097          	auipc	ra,0x4
    800026f0:	bec080e7          	jalr	-1044(ra) # 800062d8 <acquire>
  b->refcnt++;
    800026f4:	40bc                	lw	a5,64(s1)
    800026f6:	2785                	addiw	a5,a5,1
    800026f8:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800026fa:	0000d517          	auipc	a0,0xd
    800026fe:	99e50513          	addi	a0,a0,-1634 # 8000f098 <bcache>
    80002702:	00004097          	auipc	ra,0x4
    80002706:	c8a080e7          	jalr	-886(ra) # 8000638c <release>
}
    8000270a:	60e2                	ld	ra,24(sp)
    8000270c:	6442                	ld	s0,16(sp)
    8000270e:	64a2                	ld	s1,8(sp)
    80002710:	6105                	addi	sp,sp,32
    80002712:	8082                	ret

0000000080002714 <bunpin>:

void
bunpin(struct buf *b) {
    80002714:	1101                	addi	sp,sp,-32
    80002716:	ec06                	sd	ra,24(sp)
    80002718:	e822                	sd	s0,16(sp)
    8000271a:	e426                	sd	s1,8(sp)
    8000271c:	1000                	addi	s0,sp,32
    8000271e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002720:	0000d517          	auipc	a0,0xd
    80002724:	97850513          	addi	a0,a0,-1672 # 8000f098 <bcache>
    80002728:	00004097          	auipc	ra,0x4
    8000272c:	bb0080e7          	jalr	-1104(ra) # 800062d8 <acquire>
  b->refcnt--;
    80002730:	40bc                	lw	a5,64(s1)
    80002732:	37fd                	addiw	a5,a5,-1
    80002734:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002736:	0000d517          	auipc	a0,0xd
    8000273a:	96250513          	addi	a0,a0,-1694 # 8000f098 <bcache>
    8000273e:	00004097          	auipc	ra,0x4
    80002742:	c4e080e7          	jalr	-946(ra) # 8000638c <release>
}
    80002746:	60e2                	ld	ra,24(sp)
    80002748:	6442                	ld	s0,16(sp)
    8000274a:	64a2                	ld	s1,8(sp)
    8000274c:	6105                	addi	sp,sp,32
    8000274e:	8082                	ret

0000000080002750 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002750:	1101                	addi	sp,sp,-32
    80002752:	ec06                	sd	ra,24(sp)
    80002754:	e822                	sd	s0,16(sp)
    80002756:	e426                	sd	s1,8(sp)
    80002758:	e04a                	sd	s2,0(sp)
    8000275a:	1000                	addi	s0,sp,32
    8000275c:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000275e:	00d5d59b          	srliw	a1,a1,0xd
    80002762:	00015797          	auipc	a5,0x15
    80002766:	0127a783          	lw	a5,18(a5) # 80017774 <sb+0x1c>
    8000276a:	9dbd                	addw	a1,a1,a5
    8000276c:	00000097          	auipc	ra,0x0
    80002770:	d9e080e7          	jalr	-610(ra) # 8000250a <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002774:	0074f713          	andi	a4,s1,7
    80002778:	4785                	li	a5,1
    8000277a:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000277e:	14ce                	slli	s1,s1,0x33
    80002780:	90d9                	srli	s1,s1,0x36
    80002782:	00950733          	add	a4,a0,s1
    80002786:	05874703          	lbu	a4,88(a4)
    8000278a:	00e7f6b3          	and	a3,a5,a4
    8000278e:	c69d                	beqz	a3,800027bc <bfree+0x6c>
    80002790:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002792:	94aa                	add	s1,s1,a0
    80002794:	fff7c793          	not	a5,a5
    80002798:	8f7d                	and	a4,a4,a5
    8000279a:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000279e:	00001097          	auipc	ra,0x1
    800027a2:	120080e7          	jalr	288(ra) # 800038be <log_write>
  brelse(bp);
    800027a6:	854a                	mv	a0,s2
    800027a8:	00000097          	auipc	ra,0x0
    800027ac:	e92080e7          	jalr	-366(ra) # 8000263a <brelse>
}
    800027b0:	60e2                	ld	ra,24(sp)
    800027b2:	6442                	ld	s0,16(sp)
    800027b4:	64a2                	ld	s1,8(sp)
    800027b6:	6902                	ld	s2,0(sp)
    800027b8:	6105                	addi	sp,sp,32
    800027ba:	8082                	ret
    panic("freeing free block");
    800027bc:	00006517          	auipc	a0,0x6
    800027c0:	db450513          	addi	a0,a0,-588 # 80008570 <syscalls+0x148>
    800027c4:	00003097          	auipc	ra,0x3
    800027c8:	5dc080e7          	jalr	1500(ra) # 80005da0 <panic>

00000000800027cc <balloc>:
{
    800027cc:	711d                	addi	sp,sp,-96
    800027ce:	ec86                	sd	ra,88(sp)
    800027d0:	e8a2                	sd	s0,80(sp)
    800027d2:	e4a6                	sd	s1,72(sp)
    800027d4:	e0ca                	sd	s2,64(sp)
    800027d6:	fc4e                	sd	s3,56(sp)
    800027d8:	f852                	sd	s4,48(sp)
    800027da:	f456                	sd	s5,40(sp)
    800027dc:	f05a                	sd	s6,32(sp)
    800027de:	ec5e                	sd	s7,24(sp)
    800027e0:	e862                	sd	s8,16(sp)
    800027e2:	e466                	sd	s9,8(sp)
    800027e4:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800027e6:	00015797          	auipc	a5,0x15
    800027ea:	f767a783          	lw	a5,-138(a5) # 8001775c <sb+0x4>
    800027ee:	cbc1                	beqz	a5,8000287e <balloc+0xb2>
    800027f0:	8baa                	mv	s7,a0
    800027f2:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800027f4:	00015b17          	auipc	s6,0x15
    800027f8:	f64b0b13          	addi	s6,s6,-156 # 80017758 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027fc:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800027fe:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002800:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002802:	6c89                	lui	s9,0x2
    80002804:	a831                	j	80002820 <balloc+0x54>
    brelse(bp);
    80002806:	854a                	mv	a0,s2
    80002808:	00000097          	auipc	ra,0x0
    8000280c:	e32080e7          	jalr	-462(ra) # 8000263a <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002810:	015c87bb          	addw	a5,s9,s5
    80002814:	00078a9b          	sext.w	s5,a5
    80002818:	004b2703          	lw	a4,4(s6)
    8000281c:	06eaf163          	bgeu	s5,a4,8000287e <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    80002820:	41fad79b          	sraiw	a5,s5,0x1f
    80002824:	0137d79b          	srliw	a5,a5,0x13
    80002828:	015787bb          	addw	a5,a5,s5
    8000282c:	40d7d79b          	sraiw	a5,a5,0xd
    80002830:	01cb2583          	lw	a1,28(s6)
    80002834:	9dbd                	addw	a1,a1,a5
    80002836:	855e                	mv	a0,s7
    80002838:	00000097          	auipc	ra,0x0
    8000283c:	cd2080e7          	jalr	-814(ra) # 8000250a <bread>
    80002840:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002842:	004b2503          	lw	a0,4(s6)
    80002846:	000a849b          	sext.w	s1,s5
    8000284a:	8762                	mv	a4,s8
    8000284c:	faa4fde3          	bgeu	s1,a0,80002806 <balloc+0x3a>
      m = 1 << (bi % 8);
    80002850:	00777693          	andi	a3,a4,7
    80002854:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002858:	41f7579b          	sraiw	a5,a4,0x1f
    8000285c:	01d7d79b          	srliw	a5,a5,0x1d
    80002860:	9fb9                	addw	a5,a5,a4
    80002862:	4037d79b          	sraiw	a5,a5,0x3
    80002866:	00f90633          	add	a2,s2,a5
    8000286a:	05864603          	lbu	a2,88(a2)
    8000286e:	00c6f5b3          	and	a1,a3,a2
    80002872:	cd91                	beqz	a1,8000288e <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002874:	2705                	addiw	a4,a4,1
    80002876:	2485                	addiw	s1,s1,1
    80002878:	fd471ae3          	bne	a4,s4,8000284c <balloc+0x80>
    8000287c:	b769                	j	80002806 <balloc+0x3a>
  panic("balloc: out of blocks");
    8000287e:	00006517          	auipc	a0,0x6
    80002882:	d0a50513          	addi	a0,a0,-758 # 80008588 <syscalls+0x160>
    80002886:	00003097          	auipc	ra,0x3
    8000288a:	51a080e7          	jalr	1306(ra) # 80005da0 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000288e:	97ca                	add	a5,a5,s2
    80002890:	8e55                	or	a2,a2,a3
    80002892:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002896:	854a                	mv	a0,s2
    80002898:	00001097          	auipc	ra,0x1
    8000289c:	026080e7          	jalr	38(ra) # 800038be <log_write>
        brelse(bp);
    800028a0:	854a                	mv	a0,s2
    800028a2:	00000097          	auipc	ra,0x0
    800028a6:	d98080e7          	jalr	-616(ra) # 8000263a <brelse>
  bp = bread(dev, bno);
    800028aa:	85a6                	mv	a1,s1
    800028ac:	855e                	mv	a0,s7
    800028ae:	00000097          	auipc	ra,0x0
    800028b2:	c5c080e7          	jalr	-932(ra) # 8000250a <bread>
    800028b6:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800028b8:	40000613          	li	a2,1024
    800028bc:	4581                	li	a1,0
    800028be:	05850513          	addi	a0,a0,88
    800028c2:	ffffe097          	auipc	ra,0xffffe
    800028c6:	8b8080e7          	jalr	-1864(ra) # 8000017a <memset>
  log_write(bp);
    800028ca:	854a                	mv	a0,s2
    800028cc:	00001097          	auipc	ra,0x1
    800028d0:	ff2080e7          	jalr	-14(ra) # 800038be <log_write>
  brelse(bp);
    800028d4:	854a                	mv	a0,s2
    800028d6:	00000097          	auipc	ra,0x0
    800028da:	d64080e7          	jalr	-668(ra) # 8000263a <brelse>
}
    800028de:	8526                	mv	a0,s1
    800028e0:	60e6                	ld	ra,88(sp)
    800028e2:	6446                	ld	s0,80(sp)
    800028e4:	64a6                	ld	s1,72(sp)
    800028e6:	6906                	ld	s2,64(sp)
    800028e8:	79e2                	ld	s3,56(sp)
    800028ea:	7a42                	ld	s4,48(sp)
    800028ec:	7aa2                	ld	s5,40(sp)
    800028ee:	7b02                	ld	s6,32(sp)
    800028f0:	6be2                	ld	s7,24(sp)
    800028f2:	6c42                	ld	s8,16(sp)
    800028f4:	6ca2                	ld	s9,8(sp)
    800028f6:	6125                	addi	sp,sp,96
    800028f8:	8082                	ret

00000000800028fa <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800028fa:	7179                	addi	sp,sp,-48
    800028fc:	f406                	sd	ra,40(sp)
    800028fe:	f022                	sd	s0,32(sp)
    80002900:	ec26                	sd	s1,24(sp)
    80002902:	e84a                	sd	s2,16(sp)
    80002904:	e44e                	sd	s3,8(sp)
    80002906:	e052                	sd	s4,0(sp)
    80002908:	1800                	addi	s0,sp,48
    8000290a:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000290c:	47ad                	li	a5,11
    8000290e:	04b7fe63          	bgeu	a5,a1,8000296a <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80002912:	ff45849b          	addiw	s1,a1,-12
    80002916:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000291a:	0ff00793          	li	a5,255
    8000291e:	0ae7e463          	bltu	a5,a4,800029c6 <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002922:	08052583          	lw	a1,128(a0)
    80002926:	c5b5                	beqz	a1,80002992 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002928:	00092503          	lw	a0,0(s2)
    8000292c:	00000097          	auipc	ra,0x0
    80002930:	bde080e7          	jalr	-1058(ra) # 8000250a <bread>
    80002934:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002936:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000293a:	02049713          	slli	a4,s1,0x20
    8000293e:	01e75593          	srli	a1,a4,0x1e
    80002942:	00b784b3          	add	s1,a5,a1
    80002946:	0004a983          	lw	s3,0(s1)
    8000294a:	04098e63          	beqz	s3,800029a6 <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    8000294e:	8552                	mv	a0,s4
    80002950:	00000097          	auipc	ra,0x0
    80002954:	cea080e7          	jalr	-790(ra) # 8000263a <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002958:	854e                	mv	a0,s3
    8000295a:	70a2                	ld	ra,40(sp)
    8000295c:	7402                	ld	s0,32(sp)
    8000295e:	64e2                	ld	s1,24(sp)
    80002960:	6942                	ld	s2,16(sp)
    80002962:	69a2                	ld	s3,8(sp)
    80002964:	6a02                	ld	s4,0(sp)
    80002966:	6145                	addi	sp,sp,48
    80002968:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    8000296a:	02059793          	slli	a5,a1,0x20
    8000296e:	01e7d593          	srli	a1,a5,0x1e
    80002972:	00b504b3          	add	s1,a0,a1
    80002976:	0504a983          	lw	s3,80(s1)
    8000297a:	fc099fe3          	bnez	s3,80002958 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    8000297e:	4108                	lw	a0,0(a0)
    80002980:	00000097          	auipc	ra,0x0
    80002984:	e4c080e7          	jalr	-436(ra) # 800027cc <balloc>
    80002988:	0005099b          	sext.w	s3,a0
    8000298c:	0534a823          	sw	s3,80(s1)
    80002990:	b7e1                	j	80002958 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002992:	4108                	lw	a0,0(a0)
    80002994:	00000097          	auipc	ra,0x0
    80002998:	e38080e7          	jalr	-456(ra) # 800027cc <balloc>
    8000299c:	0005059b          	sext.w	a1,a0
    800029a0:	08b92023          	sw	a1,128(s2)
    800029a4:	b751                	j	80002928 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    800029a6:	00092503          	lw	a0,0(s2)
    800029aa:	00000097          	auipc	ra,0x0
    800029ae:	e22080e7          	jalr	-478(ra) # 800027cc <balloc>
    800029b2:	0005099b          	sext.w	s3,a0
    800029b6:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800029ba:	8552                	mv	a0,s4
    800029bc:	00001097          	auipc	ra,0x1
    800029c0:	f02080e7          	jalr	-254(ra) # 800038be <log_write>
    800029c4:	b769                	j	8000294e <bmap+0x54>
  panic("bmap: out of range");
    800029c6:	00006517          	auipc	a0,0x6
    800029ca:	bda50513          	addi	a0,a0,-1062 # 800085a0 <syscalls+0x178>
    800029ce:	00003097          	auipc	ra,0x3
    800029d2:	3d2080e7          	jalr	978(ra) # 80005da0 <panic>

00000000800029d6 <iget>:
{
    800029d6:	7179                	addi	sp,sp,-48
    800029d8:	f406                	sd	ra,40(sp)
    800029da:	f022                	sd	s0,32(sp)
    800029dc:	ec26                	sd	s1,24(sp)
    800029de:	e84a                	sd	s2,16(sp)
    800029e0:	e44e                	sd	s3,8(sp)
    800029e2:	e052                	sd	s4,0(sp)
    800029e4:	1800                	addi	s0,sp,48
    800029e6:	89aa                	mv	s3,a0
    800029e8:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800029ea:	00015517          	auipc	a0,0x15
    800029ee:	d8e50513          	addi	a0,a0,-626 # 80017778 <itable>
    800029f2:	00004097          	auipc	ra,0x4
    800029f6:	8e6080e7          	jalr	-1818(ra) # 800062d8 <acquire>
  empty = 0;
    800029fa:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800029fc:	00015497          	auipc	s1,0x15
    80002a00:	d9448493          	addi	s1,s1,-620 # 80017790 <itable+0x18>
    80002a04:	00017697          	auipc	a3,0x17
    80002a08:	81c68693          	addi	a3,a3,-2020 # 80019220 <log>
    80002a0c:	a039                	j	80002a1a <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a0e:	02090b63          	beqz	s2,80002a44 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a12:	08848493          	addi	s1,s1,136
    80002a16:	02d48a63          	beq	s1,a3,80002a4a <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002a1a:	449c                	lw	a5,8(s1)
    80002a1c:	fef059e3          	blez	a5,80002a0e <iget+0x38>
    80002a20:	4098                	lw	a4,0(s1)
    80002a22:	ff3716e3          	bne	a4,s3,80002a0e <iget+0x38>
    80002a26:	40d8                	lw	a4,4(s1)
    80002a28:	ff4713e3          	bne	a4,s4,80002a0e <iget+0x38>
      ip->ref++;
    80002a2c:	2785                	addiw	a5,a5,1
    80002a2e:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002a30:	00015517          	auipc	a0,0x15
    80002a34:	d4850513          	addi	a0,a0,-696 # 80017778 <itable>
    80002a38:	00004097          	auipc	ra,0x4
    80002a3c:	954080e7          	jalr	-1708(ra) # 8000638c <release>
      return ip;
    80002a40:	8926                	mv	s2,s1
    80002a42:	a03d                	j	80002a70 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a44:	f7f9                	bnez	a5,80002a12 <iget+0x3c>
    80002a46:	8926                	mv	s2,s1
    80002a48:	b7e9                	j	80002a12 <iget+0x3c>
  if(empty == 0)
    80002a4a:	02090c63          	beqz	s2,80002a82 <iget+0xac>
  ip->dev = dev;
    80002a4e:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002a52:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002a56:	4785                	li	a5,1
    80002a58:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002a5c:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002a60:	00015517          	auipc	a0,0x15
    80002a64:	d1850513          	addi	a0,a0,-744 # 80017778 <itable>
    80002a68:	00004097          	auipc	ra,0x4
    80002a6c:	924080e7          	jalr	-1756(ra) # 8000638c <release>
}
    80002a70:	854a                	mv	a0,s2
    80002a72:	70a2                	ld	ra,40(sp)
    80002a74:	7402                	ld	s0,32(sp)
    80002a76:	64e2                	ld	s1,24(sp)
    80002a78:	6942                	ld	s2,16(sp)
    80002a7a:	69a2                	ld	s3,8(sp)
    80002a7c:	6a02                	ld	s4,0(sp)
    80002a7e:	6145                	addi	sp,sp,48
    80002a80:	8082                	ret
    panic("iget: no inodes");
    80002a82:	00006517          	auipc	a0,0x6
    80002a86:	b3650513          	addi	a0,a0,-1226 # 800085b8 <syscalls+0x190>
    80002a8a:	00003097          	auipc	ra,0x3
    80002a8e:	316080e7          	jalr	790(ra) # 80005da0 <panic>

0000000080002a92 <fsinit>:
fsinit(int dev) {
    80002a92:	7179                	addi	sp,sp,-48
    80002a94:	f406                	sd	ra,40(sp)
    80002a96:	f022                	sd	s0,32(sp)
    80002a98:	ec26                	sd	s1,24(sp)
    80002a9a:	e84a                	sd	s2,16(sp)
    80002a9c:	e44e                	sd	s3,8(sp)
    80002a9e:	1800                	addi	s0,sp,48
    80002aa0:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002aa2:	4585                	li	a1,1
    80002aa4:	00000097          	auipc	ra,0x0
    80002aa8:	a66080e7          	jalr	-1434(ra) # 8000250a <bread>
    80002aac:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002aae:	00015997          	auipc	s3,0x15
    80002ab2:	caa98993          	addi	s3,s3,-854 # 80017758 <sb>
    80002ab6:	02000613          	li	a2,32
    80002aba:	05850593          	addi	a1,a0,88
    80002abe:	854e                	mv	a0,s3
    80002ac0:	ffffd097          	auipc	ra,0xffffd
    80002ac4:	716080e7          	jalr	1814(ra) # 800001d6 <memmove>
  brelse(bp);
    80002ac8:	8526                	mv	a0,s1
    80002aca:	00000097          	auipc	ra,0x0
    80002ace:	b70080e7          	jalr	-1168(ra) # 8000263a <brelse>
  if(sb.magic != FSMAGIC)
    80002ad2:	0009a703          	lw	a4,0(s3)
    80002ad6:	102037b7          	lui	a5,0x10203
    80002ada:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002ade:	02f71263          	bne	a4,a5,80002b02 <fsinit+0x70>
  initlog(dev, &sb);
    80002ae2:	00015597          	auipc	a1,0x15
    80002ae6:	c7658593          	addi	a1,a1,-906 # 80017758 <sb>
    80002aea:	854a                	mv	a0,s2
    80002aec:	00001097          	auipc	ra,0x1
    80002af0:	b56080e7          	jalr	-1194(ra) # 80003642 <initlog>
}
    80002af4:	70a2                	ld	ra,40(sp)
    80002af6:	7402                	ld	s0,32(sp)
    80002af8:	64e2                	ld	s1,24(sp)
    80002afa:	6942                	ld	s2,16(sp)
    80002afc:	69a2                	ld	s3,8(sp)
    80002afe:	6145                	addi	sp,sp,48
    80002b00:	8082                	ret
    panic("invalid file system");
    80002b02:	00006517          	auipc	a0,0x6
    80002b06:	ac650513          	addi	a0,a0,-1338 # 800085c8 <syscalls+0x1a0>
    80002b0a:	00003097          	auipc	ra,0x3
    80002b0e:	296080e7          	jalr	662(ra) # 80005da0 <panic>

0000000080002b12 <iinit>:
{
    80002b12:	7179                	addi	sp,sp,-48
    80002b14:	f406                	sd	ra,40(sp)
    80002b16:	f022                	sd	s0,32(sp)
    80002b18:	ec26                	sd	s1,24(sp)
    80002b1a:	e84a                	sd	s2,16(sp)
    80002b1c:	e44e                	sd	s3,8(sp)
    80002b1e:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002b20:	00006597          	auipc	a1,0x6
    80002b24:	ac058593          	addi	a1,a1,-1344 # 800085e0 <syscalls+0x1b8>
    80002b28:	00015517          	auipc	a0,0x15
    80002b2c:	c5050513          	addi	a0,a0,-944 # 80017778 <itable>
    80002b30:	00003097          	auipc	ra,0x3
    80002b34:	718080e7          	jalr	1816(ra) # 80006248 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002b38:	00015497          	auipc	s1,0x15
    80002b3c:	c6848493          	addi	s1,s1,-920 # 800177a0 <itable+0x28>
    80002b40:	00016997          	auipc	s3,0x16
    80002b44:	6f098993          	addi	s3,s3,1776 # 80019230 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002b48:	00006917          	auipc	s2,0x6
    80002b4c:	aa090913          	addi	s2,s2,-1376 # 800085e8 <syscalls+0x1c0>
    80002b50:	85ca                	mv	a1,s2
    80002b52:	8526                	mv	a0,s1
    80002b54:	00001097          	auipc	ra,0x1
    80002b58:	e4e080e7          	jalr	-434(ra) # 800039a2 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002b5c:	08848493          	addi	s1,s1,136
    80002b60:	ff3498e3          	bne	s1,s3,80002b50 <iinit+0x3e>
}
    80002b64:	70a2                	ld	ra,40(sp)
    80002b66:	7402                	ld	s0,32(sp)
    80002b68:	64e2                	ld	s1,24(sp)
    80002b6a:	6942                	ld	s2,16(sp)
    80002b6c:	69a2                	ld	s3,8(sp)
    80002b6e:	6145                	addi	sp,sp,48
    80002b70:	8082                	ret

0000000080002b72 <ialloc>:
{
    80002b72:	715d                	addi	sp,sp,-80
    80002b74:	e486                	sd	ra,72(sp)
    80002b76:	e0a2                	sd	s0,64(sp)
    80002b78:	fc26                	sd	s1,56(sp)
    80002b7a:	f84a                	sd	s2,48(sp)
    80002b7c:	f44e                	sd	s3,40(sp)
    80002b7e:	f052                	sd	s4,32(sp)
    80002b80:	ec56                	sd	s5,24(sp)
    80002b82:	e85a                	sd	s6,16(sp)
    80002b84:	e45e                	sd	s7,8(sp)
    80002b86:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b88:	00015717          	auipc	a4,0x15
    80002b8c:	bdc72703          	lw	a4,-1060(a4) # 80017764 <sb+0xc>
    80002b90:	4785                	li	a5,1
    80002b92:	04e7fa63          	bgeu	a5,a4,80002be6 <ialloc+0x74>
    80002b96:	8aaa                	mv	s5,a0
    80002b98:	8bae                	mv	s7,a1
    80002b9a:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002b9c:	00015a17          	auipc	s4,0x15
    80002ba0:	bbca0a13          	addi	s4,s4,-1092 # 80017758 <sb>
    80002ba4:	00048b1b          	sext.w	s6,s1
    80002ba8:	0044d593          	srli	a1,s1,0x4
    80002bac:	018a2783          	lw	a5,24(s4)
    80002bb0:	9dbd                	addw	a1,a1,a5
    80002bb2:	8556                	mv	a0,s5
    80002bb4:	00000097          	auipc	ra,0x0
    80002bb8:	956080e7          	jalr	-1706(ra) # 8000250a <bread>
    80002bbc:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002bbe:	05850993          	addi	s3,a0,88
    80002bc2:	00f4f793          	andi	a5,s1,15
    80002bc6:	079a                	slli	a5,a5,0x6
    80002bc8:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002bca:	00099783          	lh	a5,0(s3)
    80002bce:	c785                	beqz	a5,80002bf6 <ialloc+0x84>
    brelse(bp);
    80002bd0:	00000097          	auipc	ra,0x0
    80002bd4:	a6a080e7          	jalr	-1430(ra) # 8000263a <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002bd8:	0485                	addi	s1,s1,1
    80002bda:	00ca2703          	lw	a4,12(s4)
    80002bde:	0004879b          	sext.w	a5,s1
    80002be2:	fce7e1e3          	bltu	a5,a4,80002ba4 <ialloc+0x32>
  panic("ialloc: no inodes");
    80002be6:	00006517          	auipc	a0,0x6
    80002bea:	a0a50513          	addi	a0,a0,-1526 # 800085f0 <syscalls+0x1c8>
    80002bee:	00003097          	auipc	ra,0x3
    80002bf2:	1b2080e7          	jalr	434(ra) # 80005da0 <panic>
      memset(dip, 0, sizeof(*dip));
    80002bf6:	04000613          	li	a2,64
    80002bfa:	4581                	li	a1,0
    80002bfc:	854e                	mv	a0,s3
    80002bfe:	ffffd097          	auipc	ra,0xffffd
    80002c02:	57c080e7          	jalr	1404(ra) # 8000017a <memset>
      dip->type = type;
    80002c06:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002c0a:	854a                	mv	a0,s2
    80002c0c:	00001097          	auipc	ra,0x1
    80002c10:	cb2080e7          	jalr	-846(ra) # 800038be <log_write>
      brelse(bp);
    80002c14:	854a                	mv	a0,s2
    80002c16:	00000097          	auipc	ra,0x0
    80002c1a:	a24080e7          	jalr	-1500(ra) # 8000263a <brelse>
      return iget(dev, inum);
    80002c1e:	85da                	mv	a1,s6
    80002c20:	8556                	mv	a0,s5
    80002c22:	00000097          	auipc	ra,0x0
    80002c26:	db4080e7          	jalr	-588(ra) # 800029d6 <iget>
}
    80002c2a:	60a6                	ld	ra,72(sp)
    80002c2c:	6406                	ld	s0,64(sp)
    80002c2e:	74e2                	ld	s1,56(sp)
    80002c30:	7942                	ld	s2,48(sp)
    80002c32:	79a2                	ld	s3,40(sp)
    80002c34:	7a02                	ld	s4,32(sp)
    80002c36:	6ae2                	ld	s5,24(sp)
    80002c38:	6b42                	ld	s6,16(sp)
    80002c3a:	6ba2                	ld	s7,8(sp)
    80002c3c:	6161                	addi	sp,sp,80
    80002c3e:	8082                	ret

0000000080002c40 <iupdate>:
{
    80002c40:	1101                	addi	sp,sp,-32
    80002c42:	ec06                	sd	ra,24(sp)
    80002c44:	e822                	sd	s0,16(sp)
    80002c46:	e426                	sd	s1,8(sp)
    80002c48:	e04a                	sd	s2,0(sp)
    80002c4a:	1000                	addi	s0,sp,32
    80002c4c:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c4e:	415c                	lw	a5,4(a0)
    80002c50:	0047d79b          	srliw	a5,a5,0x4
    80002c54:	00015597          	auipc	a1,0x15
    80002c58:	b1c5a583          	lw	a1,-1252(a1) # 80017770 <sb+0x18>
    80002c5c:	9dbd                	addw	a1,a1,a5
    80002c5e:	4108                	lw	a0,0(a0)
    80002c60:	00000097          	auipc	ra,0x0
    80002c64:	8aa080e7          	jalr	-1878(ra) # 8000250a <bread>
    80002c68:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c6a:	05850793          	addi	a5,a0,88
    80002c6e:	40d8                	lw	a4,4(s1)
    80002c70:	8b3d                	andi	a4,a4,15
    80002c72:	071a                	slli	a4,a4,0x6
    80002c74:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002c76:	04449703          	lh	a4,68(s1)
    80002c7a:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002c7e:	04649703          	lh	a4,70(s1)
    80002c82:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002c86:	04849703          	lh	a4,72(s1)
    80002c8a:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002c8e:	04a49703          	lh	a4,74(s1)
    80002c92:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002c96:	44f8                	lw	a4,76(s1)
    80002c98:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002c9a:	03400613          	li	a2,52
    80002c9e:	05048593          	addi	a1,s1,80
    80002ca2:	00c78513          	addi	a0,a5,12
    80002ca6:	ffffd097          	auipc	ra,0xffffd
    80002caa:	530080e7          	jalr	1328(ra) # 800001d6 <memmove>
  log_write(bp);
    80002cae:	854a                	mv	a0,s2
    80002cb0:	00001097          	auipc	ra,0x1
    80002cb4:	c0e080e7          	jalr	-1010(ra) # 800038be <log_write>
  brelse(bp);
    80002cb8:	854a                	mv	a0,s2
    80002cba:	00000097          	auipc	ra,0x0
    80002cbe:	980080e7          	jalr	-1664(ra) # 8000263a <brelse>
}
    80002cc2:	60e2                	ld	ra,24(sp)
    80002cc4:	6442                	ld	s0,16(sp)
    80002cc6:	64a2                	ld	s1,8(sp)
    80002cc8:	6902                	ld	s2,0(sp)
    80002cca:	6105                	addi	sp,sp,32
    80002ccc:	8082                	ret

0000000080002cce <idup>:
{
    80002cce:	1101                	addi	sp,sp,-32
    80002cd0:	ec06                	sd	ra,24(sp)
    80002cd2:	e822                	sd	s0,16(sp)
    80002cd4:	e426                	sd	s1,8(sp)
    80002cd6:	1000                	addi	s0,sp,32
    80002cd8:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002cda:	00015517          	auipc	a0,0x15
    80002cde:	a9e50513          	addi	a0,a0,-1378 # 80017778 <itable>
    80002ce2:	00003097          	auipc	ra,0x3
    80002ce6:	5f6080e7          	jalr	1526(ra) # 800062d8 <acquire>
  ip->ref++;
    80002cea:	449c                	lw	a5,8(s1)
    80002cec:	2785                	addiw	a5,a5,1
    80002cee:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002cf0:	00015517          	auipc	a0,0x15
    80002cf4:	a8850513          	addi	a0,a0,-1400 # 80017778 <itable>
    80002cf8:	00003097          	auipc	ra,0x3
    80002cfc:	694080e7          	jalr	1684(ra) # 8000638c <release>
}
    80002d00:	8526                	mv	a0,s1
    80002d02:	60e2                	ld	ra,24(sp)
    80002d04:	6442                	ld	s0,16(sp)
    80002d06:	64a2                	ld	s1,8(sp)
    80002d08:	6105                	addi	sp,sp,32
    80002d0a:	8082                	ret

0000000080002d0c <ilock>:
{
    80002d0c:	1101                	addi	sp,sp,-32
    80002d0e:	ec06                	sd	ra,24(sp)
    80002d10:	e822                	sd	s0,16(sp)
    80002d12:	e426                	sd	s1,8(sp)
    80002d14:	e04a                	sd	s2,0(sp)
    80002d16:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002d18:	c115                	beqz	a0,80002d3c <ilock+0x30>
    80002d1a:	84aa                	mv	s1,a0
    80002d1c:	451c                	lw	a5,8(a0)
    80002d1e:	00f05f63          	blez	a5,80002d3c <ilock+0x30>
  acquiresleep(&ip->lock);
    80002d22:	0541                	addi	a0,a0,16
    80002d24:	00001097          	auipc	ra,0x1
    80002d28:	cb8080e7          	jalr	-840(ra) # 800039dc <acquiresleep>
  if(ip->valid == 0){
    80002d2c:	40bc                	lw	a5,64(s1)
    80002d2e:	cf99                	beqz	a5,80002d4c <ilock+0x40>
}
    80002d30:	60e2                	ld	ra,24(sp)
    80002d32:	6442                	ld	s0,16(sp)
    80002d34:	64a2                	ld	s1,8(sp)
    80002d36:	6902                	ld	s2,0(sp)
    80002d38:	6105                	addi	sp,sp,32
    80002d3a:	8082                	ret
    panic("ilock");
    80002d3c:	00006517          	auipc	a0,0x6
    80002d40:	8cc50513          	addi	a0,a0,-1844 # 80008608 <syscalls+0x1e0>
    80002d44:	00003097          	auipc	ra,0x3
    80002d48:	05c080e7          	jalr	92(ra) # 80005da0 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d4c:	40dc                	lw	a5,4(s1)
    80002d4e:	0047d79b          	srliw	a5,a5,0x4
    80002d52:	00015597          	auipc	a1,0x15
    80002d56:	a1e5a583          	lw	a1,-1506(a1) # 80017770 <sb+0x18>
    80002d5a:	9dbd                	addw	a1,a1,a5
    80002d5c:	4088                	lw	a0,0(s1)
    80002d5e:	fffff097          	auipc	ra,0xfffff
    80002d62:	7ac080e7          	jalr	1964(ra) # 8000250a <bread>
    80002d66:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002d68:	05850593          	addi	a1,a0,88
    80002d6c:	40dc                	lw	a5,4(s1)
    80002d6e:	8bbd                	andi	a5,a5,15
    80002d70:	079a                	slli	a5,a5,0x6
    80002d72:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002d74:	00059783          	lh	a5,0(a1)
    80002d78:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002d7c:	00259783          	lh	a5,2(a1)
    80002d80:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002d84:	00459783          	lh	a5,4(a1)
    80002d88:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002d8c:	00659783          	lh	a5,6(a1)
    80002d90:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002d94:	459c                	lw	a5,8(a1)
    80002d96:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002d98:	03400613          	li	a2,52
    80002d9c:	05b1                	addi	a1,a1,12
    80002d9e:	05048513          	addi	a0,s1,80
    80002da2:	ffffd097          	auipc	ra,0xffffd
    80002da6:	434080e7          	jalr	1076(ra) # 800001d6 <memmove>
    brelse(bp);
    80002daa:	854a                	mv	a0,s2
    80002dac:	00000097          	auipc	ra,0x0
    80002db0:	88e080e7          	jalr	-1906(ra) # 8000263a <brelse>
    ip->valid = 1;
    80002db4:	4785                	li	a5,1
    80002db6:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002db8:	04449783          	lh	a5,68(s1)
    80002dbc:	fbb5                	bnez	a5,80002d30 <ilock+0x24>
      panic("ilock: no type");
    80002dbe:	00006517          	auipc	a0,0x6
    80002dc2:	85250513          	addi	a0,a0,-1966 # 80008610 <syscalls+0x1e8>
    80002dc6:	00003097          	auipc	ra,0x3
    80002dca:	fda080e7          	jalr	-38(ra) # 80005da0 <panic>

0000000080002dce <iunlock>:
{
    80002dce:	1101                	addi	sp,sp,-32
    80002dd0:	ec06                	sd	ra,24(sp)
    80002dd2:	e822                	sd	s0,16(sp)
    80002dd4:	e426                	sd	s1,8(sp)
    80002dd6:	e04a                	sd	s2,0(sp)
    80002dd8:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002dda:	c905                	beqz	a0,80002e0a <iunlock+0x3c>
    80002ddc:	84aa                	mv	s1,a0
    80002dde:	01050913          	addi	s2,a0,16
    80002de2:	854a                	mv	a0,s2
    80002de4:	00001097          	auipc	ra,0x1
    80002de8:	c92080e7          	jalr	-878(ra) # 80003a76 <holdingsleep>
    80002dec:	cd19                	beqz	a0,80002e0a <iunlock+0x3c>
    80002dee:	449c                	lw	a5,8(s1)
    80002df0:	00f05d63          	blez	a5,80002e0a <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002df4:	854a                	mv	a0,s2
    80002df6:	00001097          	auipc	ra,0x1
    80002dfa:	c3c080e7          	jalr	-964(ra) # 80003a32 <releasesleep>
}
    80002dfe:	60e2                	ld	ra,24(sp)
    80002e00:	6442                	ld	s0,16(sp)
    80002e02:	64a2                	ld	s1,8(sp)
    80002e04:	6902                	ld	s2,0(sp)
    80002e06:	6105                	addi	sp,sp,32
    80002e08:	8082                	ret
    panic("iunlock");
    80002e0a:	00006517          	auipc	a0,0x6
    80002e0e:	81650513          	addi	a0,a0,-2026 # 80008620 <syscalls+0x1f8>
    80002e12:	00003097          	auipc	ra,0x3
    80002e16:	f8e080e7          	jalr	-114(ra) # 80005da0 <panic>

0000000080002e1a <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002e1a:	7179                	addi	sp,sp,-48
    80002e1c:	f406                	sd	ra,40(sp)
    80002e1e:	f022                	sd	s0,32(sp)
    80002e20:	ec26                	sd	s1,24(sp)
    80002e22:	e84a                	sd	s2,16(sp)
    80002e24:	e44e                	sd	s3,8(sp)
    80002e26:	e052                	sd	s4,0(sp)
    80002e28:	1800                	addi	s0,sp,48
    80002e2a:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002e2c:	05050493          	addi	s1,a0,80
    80002e30:	08050913          	addi	s2,a0,128
    80002e34:	a021                	j	80002e3c <itrunc+0x22>
    80002e36:	0491                	addi	s1,s1,4
    80002e38:	01248d63          	beq	s1,s2,80002e52 <itrunc+0x38>
    if(ip->addrs[i]){
    80002e3c:	408c                	lw	a1,0(s1)
    80002e3e:	dde5                	beqz	a1,80002e36 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002e40:	0009a503          	lw	a0,0(s3)
    80002e44:	00000097          	auipc	ra,0x0
    80002e48:	90c080e7          	jalr	-1780(ra) # 80002750 <bfree>
      ip->addrs[i] = 0;
    80002e4c:	0004a023          	sw	zero,0(s1)
    80002e50:	b7dd                	j	80002e36 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002e52:	0809a583          	lw	a1,128(s3)
    80002e56:	e185                	bnez	a1,80002e76 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002e58:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002e5c:	854e                	mv	a0,s3
    80002e5e:	00000097          	auipc	ra,0x0
    80002e62:	de2080e7          	jalr	-542(ra) # 80002c40 <iupdate>
}
    80002e66:	70a2                	ld	ra,40(sp)
    80002e68:	7402                	ld	s0,32(sp)
    80002e6a:	64e2                	ld	s1,24(sp)
    80002e6c:	6942                	ld	s2,16(sp)
    80002e6e:	69a2                	ld	s3,8(sp)
    80002e70:	6a02                	ld	s4,0(sp)
    80002e72:	6145                	addi	sp,sp,48
    80002e74:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002e76:	0009a503          	lw	a0,0(s3)
    80002e7a:	fffff097          	auipc	ra,0xfffff
    80002e7e:	690080e7          	jalr	1680(ra) # 8000250a <bread>
    80002e82:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002e84:	05850493          	addi	s1,a0,88
    80002e88:	45850913          	addi	s2,a0,1112
    80002e8c:	a021                	j	80002e94 <itrunc+0x7a>
    80002e8e:	0491                	addi	s1,s1,4
    80002e90:	01248b63          	beq	s1,s2,80002ea6 <itrunc+0x8c>
      if(a[j])
    80002e94:	408c                	lw	a1,0(s1)
    80002e96:	dde5                	beqz	a1,80002e8e <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002e98:	0009a503          	lw	a0,0(s3)
    80002e9c:	00000097          	auipc	ra,0x0
    80002ea0:	8b4080e7          	jalr	-1868(ra) # 80002750 <bfree>
    80002ea4:	b7ed                	j	80002e8e <itrunc+0x74>
    brelse(bp);
    80002ea6:	8552                	mv	a0,s4
    80002ea8:	fffff097          	auipc	ra,0xfffff
    80002eac:	792080e7          	jalr	1938(ra) # 8000263a <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002eb0:	0809a583          	lw	a1,128(s3)
    80002eb4:	0009a503          	lw	a0,0(s3)
    80002eb8:	00000097          	auipc	ra,0x0
    80002ebc:	898080e7          	jalr	-1896(ra) # 80002750 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002ec0:	0809a023          	sw	zero,128(s3)
    80002ec4:	bf51                	j	80002e58 <itrunc+0x3e>

0000000080002ec6 <iput>:
{
    80002ec6:	1101                	addi	sp,sp,-32
    80002ec8:	ec06                	sd	ra,24(sp)
    80002eca:	e822                	sd	s0,16(sp)
    80002ecc:	e426                	sd	s1,8(sp)
    80002ece:	e04a                	sd	s2,0(sp)
    80002ed0:	1000                	addi	s0,sp,32
    80002ed2:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002ed4:	00015517          	auipc	a0,0x15
    80002ed8:	8a450513          	addi	a0,a0,-1884 # 80017778 <itable>
    80002edc:	00003097          	auipc	ra,0x3
    80002ee0:	3fc080e7          	jalr	1020(ra) # 800062d8 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002ee4:	4498                	lw	a4,8(s1)
    80002ee6:	4785                	li	a5,1
    80002ee8:	02f70363          	beq	a4,a5,80002f0e <iput+0x48>
  ip->ref--;
    80002eec:	449c                	lw	a5,8(s1)
    80002eee:	37fd                	addiw	a5,a5,-1
    80002ef0:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002ef2:	00015517          	auipc	a0,0x15
    80002ef6:	88650513          	addi	a0,a0,-1914 # 80017778 <itable>
    80002efa:	00003097          	auipc	ra,0x3
    80002efe:	492080e7          	jalr	1170(ra) # 8000638c <release>
}
    80002f02:	60e2                	ld	ra,24(sp)
    80002f04:	6442                	ld	s0,16(sp)
    80002f06:	64a2                	ld	s1,8(sp)
    80002f08:	6902                	ld	s2,0(sp)
    80002f0a:	6105                	addi	sp,sp,32
    80002f0c:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f0e:	40bc                	lw	a5,64(s1)
    80002f10:	dff1                	beqz	a5,80002eec <iput+0x26>
    80002f12:	04a49783          	lh	a5,74(s1)
    80002f16:	fbf9                	bnez	a5,80002eec <iput+0x26>
    acquiresleep(&ip->lock);
    80002f18:	01048913          	addi	s2,s1,16
    80002f1c:	854a                	mv	a0,s2
    80002f1e:	00001097          	auipc	ra,0x1
    80002f22:	abe080e7          	jalr	-1346(ra) # 800039dc <acquiresleep>
    release(&itable.lock);
    80002f26:	00015517          	auipc	a0,0x15
    80002f2a:	85250513          	addi	a0,a0,-1966 # 80017778 <itable>
    80002f2e:	00003097          	auipc	ra,0x3
    80002f32:	45e080e7          	jalr	1118(ra) # 8000638c <release>
    itrunc(ip);
    80002f36:	8526                	mv	a0,s1
    80002f38:	00000097          	auipc	ra,0x0
    80002f3c:	ee2080e7          	jalr	-286(ra) # 80002e1a <itrunc>
    ip->type = 0;
    80002f40:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002f44:	8526                	mv	a0,s1
    80002f46:	00000097          	auipc	ra,0x0
    80002f4a:	cfa080e7          	jalr	-774(ra) # 80002c40 <iupdate>
    ip->valid = 0;
    80002f4e:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002f52:	854a                	mv	a0,s2
    80002f54:	00001097          	auipc	ra,0x1
    80002f58:	ade080e7          	jalr	-1314(ra) # 80003a32 <releasesleep>
    acquire(&itable.lock);
    80002f5c:	00015517          	auipc	a0,0x15
    80002f60:	81c50513          	addi	a0,a0,-2020 # 80017778 <itable>
    80002f64:	00003097          	auipc	ra,0x3
    80002f68:	374080e7          	jalr	884(ra) # 800062d8 <acquire>
    80002f6c:	b741                	j	80002eec <iput+0x26>

0000000080002f6e <iunlockput>:
{
    80002f6e:	1101                	addi	sp,sp,-32
    80002f70:	ec06                	sd	ra,24(sp)
    80002f72:	e822                	sd	s0,16(sp)
    80002f74:	e426                	sd	s1,8(sp)
    80002f76:	1000                	addi	s0,sp,32
    80002f78:	84aa                	mv	s1,a0
  iunlock(ip);
    80002f7a:	00000097          	auipc	ra,0x0
    80002f7e:	e54080e7          	jalr	-428(ra) # 80002dce <iunlock>
  iput(ip);
    80002f82:	8526                	mv	a0,s1
    80002f84:	00000097          	auipc	ra,0x0
    80002f88:	f42080e7          	jalr	-190(ra) # 80002ec6 <iput>
}
    80002f8c:	60e2                	ld	ra,24(sp)
    80002f8e:	6442                	ld	s0,16(sp)
    80002f90:	64a2                	ld	s1,8(sp)
    80002f92:	6105                	addi	sp,sp,32
    80002f94:	8082                	ret

0000000080002f96 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002f96:	1141                	addi	sp,sp,-16
    80002f98:	e422                	sd	s0,8(sp)
    80002f9a:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002f9c:	411c                	lw	a5,0(a0)
    80002f9e:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002fa0:	415c                	lw	a5,4(a0)
    80002fa2:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002fa4:	04451783          	lh	a5,68(a0)
    80002fa8:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002fac:	04a51783          	lh	a5,74(a0)
    80002fb0:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002fb4:	04c56783          	lwu	a5,76(a0)
    80002fb8:	e99c                	sd	a5,16(a1)
}
    80002fba:	6422                	ld	s0,8(sp)
    80002fbc:	0141                	addi	sp,sp,16
    80002fbe:	8082                	ret

0000000080002fc0 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002fc0:	457c                	lw	a5,76(a0)
    80002fc2:	0ed7e963          	bltu	a5,a3,800030b4 <readi+0xf4>
{
    80002fc6:	7159                	addi	sp,sp,-112
    80002fc8:	f486                	sd	ra,104(sp)
    80002fca:	f0a2                	sd	s0,96(sp)
    80002fcc:	eca6                	sd	s1,88(sp)
    80002fce:	e8ca                	sd	s2,80(sp)
    80002fd0:	e4ce                	sd	s3,72(sp)
    80002fd2:	e0d2                	sd	s4,64(sp)
    80002fd4:	fc56                	sd	s5,56(sp)
    80002fd6:	f85a                	sd	s6,48(sp)
    80002fd8:	f45e                	sd	s7,40(sp)
    80002fda:	f062                	sd	s8,32(sp)
    80002fdc:	ec66                	sd	s9,24(sp)
    80002fde:	e86a                	sd	s10,16(sp)
    80002fe0:	e46e                	sd	s11,8(sp)
    80002fe2:	1880                	addi	s0,sp,112
    80002fe4:	8baa                	mv	s7,a0
    80002fe6:	8c2e                	mv	s8,a1
    80002fe8:	8ab2                	mv	s5,a2
    80002fea:	84b6                	mv	s1,a3
    80002fec:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002fee:	9f35                	addw	a4,a4,a3
    return 0;
    80002ff0:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002ff2:	0ad76063          	bltu	a4,a3,80003092 <readi+0xd2>
  if(off + n > ip->size)
    80002ff6:	00e7f463          	bgeu	a5,a4,80002ffe <readi+0x3e>
    n = ip->size - off;
    80002ffa:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ffe:	0a0b0963          	beqz	s6,800030b0 <readi+0xf0>
    80003002:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003004:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003008:	5cfd                	li	s9,-1
    8000300a:	a82d                	j	80003044 <readi+0x84>
    8000300c:	020a1d93          	slli	s11,s4,0x20
    80003010:	020ddd93          	srli	s11,s11,0x20
    80003014:	05890613          	addi	a2,s2,88
    80003018:	86ee                	mv	a3,s11
    8000301a:	963a                	add	a2,a2,a4
    8000301c:	85d6                	mv	a1,s5
    8000301e:	8562                	mv	a0,s8
    80003020:	fffff097          	auipc	ra,0xfffff
    80003024:	a2e080e7          	jalr	-1490(ra) # 80001a4e <either_copyout>
    80003028:	05950d63          	beq	a0,s9,80003082 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    8000302c:	854a                	mv	a0,s2
    8000302e:	fffff097          	auipc	ra,0xfffff
    80003032:	60c080e7          	jalr	1548(ra) # 8000263a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003036:	013a09bb          	addw	s3,s4,s3
    8000303a:	009a04bb          	addw	s1,s4,s1
    8000303e:	9aee                	add	s5,s5,s11
    80003040:	0569f763          	bgeu	s3,s6,8000308e <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003044:	000ba903          	lw	s2,0(s7)
    80003048:	00a4d59b          	srliw	a1,s1,0xa
    8000304c:	855e                	mv	a0,s7
    8000304e:	00000097          	auipc	ra,0x0
    80003052:	8ac080e7          	jalr	-1876(ra) # 800028fa <bmap>
    80003056:	0005059b          	sext.w	a1,a0
    8000305a:	854a                	mv	a0,s2
    8000305c:	fffff097          	auipc	ra,0xfffff
    80003060:	4ae080e7          	jalr	1198(ra) # 8000250a <bread>
    80003064:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003066:	3ff4f713          	andi	a4,s1,1023
    8000306a:	40ed07bb          	subw	a5,s10,a4
    8000306e:	413b06bb          	subw	a3,s6,s3
    80003072:	8a3e                	mv	s4,a5
    80003074:	2781                	sext.w	a5,a5
    80003076:	0006861b          	sext.w	a2,a3
    8000307a:	f8f679e3          	bgeu	a2,a5,8000300c <readi+0x4c>
    8000307e:	8a36                	mv	s4,a3
    80003080:	b771                	j	8000300c <readi+0x4c>
      brelse(bp);
    80003082:	854a                	mv	a0,s2
    80003084:	fffff097          	auipc	ra,0xfffff
    80003088:	5b6080e7          	jalr	1462(ra) # 8000263a <brelse>
      tot = -1;
    8000308c:	59fd                	li	s3,-1
  }
  return tot;
    8000308e:	0009851b          	sext.w	a0,s3
}
    80003092:	70a6                	ld	ra,104(sp)
    80003094:	7406                	ld	s0,96(sp)
    80003096:	64e6                	ld	s1,88(sp)
    80003098:	6946                	ld	s2,80(sp)
    8000309a:	69a6                	ld	s3,72(sp)
    8000309c:	6a06                	ld	s4,64(sp)
    8000309e:	7ae2                	ld	s5,56(sp)
    800030a0:	7b42                	ld	s6,48(sp)
    800030a2:	7ba2                	ld	s7,40(sp)
    800030a4:	7c02                	ld	s8,32(sp)
    800030a6:	6ce2                	ld	s9,24(sp)
    800030a8:	6d42                	ld	s10,16(sp)
    800030aa:	6da2                	ld	s11,8(sp)
    800030ac:	6165                	addi	sp,sp,112
    800030ae:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800030b0:	89da                	mv	s3,s6
    800030b2:	bff1                	j	8000308e <readi+0xce>
    return 0;
    800030b4:	4501                	li	a0,0
}
    800030b6:	8082                	ret

00000000800030b8 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800030b8:	457c                	lw	a5,76(a0)
    800030ba:	10d7e863          	bltu	a5,a3,800031ca <writei+0x112>
{
    800030be:	7159                	addi	sp,sp,-112
    800030c0:	f486                	sd	ra,104(sp)
    800030c2:	f0a2                	sd	s0,96(sp)
    800030c4:	eca6                	sd	s1,88(sp)
    800030c6:	e8ca                	sd	s2,80(sp)
    800030c8:	e4ce                	sd	s3,72(sp)
    800030ca:	e0d2                	sd	s4,64(sp)
    800030cc:	fc56                	sd	s5,56(sp)
    800030ce:	f85a                	sd	s6,48(sp)
    800030d0:	f45e                	sd	s7,40(sp)
    800030d2:	f062                	sd	s8,32(sp)
    800030d4:	ec66                	sd	s9,24(sp)
    800030d6:	e86a                	sd	s10,16(sp)
    800030d8:	e46e                	sd	s11,8(sp)
    800030da:	1880                	addi	s0,sp,112
    800030dc:	8b2a                	mv	s6,a0
    800030de:	8c2e                	mv	s8,a1
    800030e0:	8ab2                	mv	s5,a2
    800030e2:	8936                	mv	s2,a3
    800030e4:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    800030e6:	00e687bb          	addw	a5,a3,a4
    800030ea:	0ed7e263          	bltu	a5,a3,800031ce <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800030ee:	00043737          	lui	a4,0x43
    800030f2:	0ef76063          	bltu	a4,a5,800031d2 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030f6:	0c0b8863          	beqz	s7,800031c6 <writei+0x10e>
    800030fa:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800030fc:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003100:	5cfd                	li	s9,-1
    80003102:	a091                	j	80003146 <writei+0x8e>
    80003104:	02099d93          	slli	s11,s3,0x20
    80003108:	020ddd93          	srli	s11,s11,0x20
    8000310c:	05848513          	addi	a0,s1,88
    80003110:	86ee                	mv	a3,s11
    80003112:	8656                	mv	a2,s5
    80003114:	85e2                	mv	a1,s8
    80003116:	953a                	add	a0,a0,a4
    80003118:	fffff097          	auipc	ra,0xfffff
    8000311c:	98c080e7          	jalr	-1652(ra) # 80001aa4 <either_copyin>
    80003120:	07950263          	beq	a0,s9,80003184 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003124:	8526                	mv	a0,s1
    80003126:	00000097          	auipc	ra,0x0
    8000312a:	798080e7          	jalr	1944(ra) # 800038be <log_write>
    brelse(bp);
    8000312e:	8526                	mv	a0,s1
    80003130:	fffff097          	auipc	ra,0xfffff
    80003134:	50a080e7          	jalr	1290(ra) # 8000263a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003138:	01498a3b          	addw	s4,s3,s4
    8000313c:	0129893b          	addw	s2,s3,s2
    80003140:	9aee                	add	s5,s5,s11
    80003142:	057a7663          	bgeu	s4,s7,8000318e <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003146:	000b2483          	lw	s1,0(s6)
    8000314a:	00a9559b          	srliw	a1,s2,0xa
    8000314e:	855a                	mv	a0,s6
    80003150:	fffff097          	auipc	ra,0xfffff
    80003154:	7aa080e7          	jalr	1962(ra) # 800028fa <bmap>
    80003158:	0005059b          	sext.w	a1,a0
    8000315c:	8526                	mv	a0,s1
    8000315e:	fffff097          	auipc	ra,0xfffff
    80003162:	3ac080e7          	jalr	940(ra) # 8000250a <bread>
    80003166:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003168:	3ff97713          	andi	a4,s2,1023
    8000316c:	40ed07bb          	subw	a5,s10,a4
    80003170:	414b86bb          	subw	a3,s7,s4
    80003174:	89be                	mv	s3,a5
    80003176:	2781                	sext.w	a5,a5
    80003178:	0006861b          	sext.w	a2,a3
    8000317c:	f8f674e3          	bgeu	a2,a5,80003104 <writei+0x4c>
    80003180:	89b6                	mv	s3,a3
    80003182:	b749                	j	80003104 <writei+0x4c>
      brelse(bp);
    80003184:	8526                	mv	a0,s1
    80003186:	fffff097          	auipc	ra,0xfffff
    8000318a:	4b4080e7          	jalr	1204(ra) # 8000263a <brelse>
  }

  if(off > ip->size)
    8000318e:	04cb2783          	lw	a5,76(s6)
    80003192:	0127f463          	bgeu	a5,s2,8000319a <writei+0xe2>
    ip->size = off;
    80003196:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000319a:	855a                	mv	a0,s6
    8000319c:	00000097          	auipc	ra,0x0
    800031a0:	aa4080e7          	jalr	-1372(ra) # 80002c40 <iupdate>

  return tot;
    800031a4:	000a051b          	sext.w	a0,s4
}
    800031a8:	70a6                	ld	ra,104(sp)
    800031aa:	7406                	ld	s0,96(sp)
    800031ac:	64e6                	ld	s1,88(sp)
    800031ae:	6946                	ld	s2,80(sp)
    800031b0:	69a6                	ld	s3,72(sp)
    800031b2:	6a06                	ld	s4,64(sp)
    800031b4:	7ae2                	ld	s5,56(sp)
    800031b6:	7b42                	ld	s6,48(sp)
    800031b8:	7ba2                	ld	s7,40(sp)
    800031ba:	7c02                	ld	s8,32(sp)
    800031bc:	6ce2                	ld	s9,24(sp)
    800031be:	6d42                	ld	s10,16(sp)
    800031c0:	6da2                	ld	s11,8(sp)
    800031c2:	6165                	addi	sp,sp,112
    800031c4:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800031c6:	8a5e                	mv	s4,s7
    800031c8:	bfc9                	j	8000319a <writei+0xe2>
    return -1;
    800031ca:	557d                	li	a0,-1
}
    800031cc:	8082                	ret
    return -1;
    800031ce:	557d                	li	a0,-1
    800031d0:	bfe1                	j	800031a8 <writei+0xf0>
    return -1;
    800031d2:	557d                	li	a0,-1
    800031d4:	bfd1                	j	800031a8 <writei+0xf0>

00000000800031d6 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800031d6:	1141                	addi	sp,sp,-16
    800031d8:	e406                	sd	ra,8(sp)
    800031da:	e022                	sd	s0,0(sp)
    800031dc:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800031de:	4639                	li	a2,14
    800031e0:	ffffd097          	auipc	ra,0xffffd
    800031e4:	06a080e7          	jalr	106(ra) # 8000024a <strncmp>
}
    800031e8:	60a2                	ld	ra,8(sp)
    800031ea:	6402                	ld	s0,0(sp)
    800031ec:	0141                	addi	sp,sp,16
    800031ee:	8082                	ret

00000000800031f0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800031f0:	7139                	addi	sp,sp,-64
    800031f2:	fc06                	sd	ra,56(sp)
    800031f4:	f822                	sd	s0,48(sp)
    800031f6:	f426                	sd	s1,40(sp)
    800031f8:	f04a                	sd	s2,32(sp)
    800031fa:	ec4e                	sd	s3,24(sp)
    800031fc:	e852                	sd	s4,16(sp)
    800031fe:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003200:	04451703          	lh	a4,68(a0)
    80003204:	4785                	li	a5,1
    80003206:	00f71a63          	bne	a4,a5,8000321a <dirlookup+0x2a>
    8000320a:	892a                	mv	s2,a0
    8000320c:	89ae                	mv	s3,a1
    8000320e:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003210:	457c                	lw	a5,76(a0)
    80003212:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003214:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003216:	e79d                	bnez	a5,80003244 <dirlookup+0x54>
    80003218:	a8a5                	j	80003290 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000321a:	00005517          	auipc	a0,0x5
    8000321e:	40e50513          	addi	a0,a0,1038 # 80008628 <syscalls+0x200>
    80003222:	00003097          	auipc	ra,0x3
    80003226:	b7e080e7          	jalr	-1154(ra) # 80005da0 <panic>
      panic("dirlookup read");
    8000322a:	00005517          	auipc	a0,0x5
    8000322e:	41650513          	addi	a0,a0,1046 # 80008640 <syscalls+0x218>
    80003232:	00003097          	auipc	ra,0x3
    80003236:	b6e080e7          	jalr	-1170(ra) # 80005da0 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000323a:	24c1                	addiw	s1,s1,16
    8000323c:	04c92783          	lw	a5,76(s2)
    80003240:	04f4f763          	bgeu	s1,a5,8000328e <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003244:	4741                	li	a4,16
    80003246:	86a6                	mv	a3,s1
    80003248:	fc040613          	addi	a2,s0,-64
    8000324c:	4581                	li	a1,0
    8000324e:	854a                	mv	a0,s2
    80003250:	00000097          	auipc	ra,0x0
    80003254:	d70080e7          	jalr	-656(ra) # 80002fc0 <readi>
    80003258:	47c1                	li	a5,16
    8000325a:	fcf518e3          	bne	a0,a5,8000322a <dirlookup+0x3a>
    if(de.inum == 0)
    8000325e:	fc045783          	lhu	a5,-64(s0)
    80003262:	dfe1                	beqz	a5,8000323a <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003264:	fc240593          	addi	a1,s0,-62
    80003268:	854e                	mv	a0,s3
    8000326a:	00000097          	auipc	ra,0x0
    8000326e:	f6c080e7          	jalr	-148(ra) # 800031d6 <namecmp>
    80003272:	f561                	bnez	a0,8000323a <dirlookup+0x4a>
      if(poff)
    80003274:	000a0463          	beqz	s4,8000327c <dirlookup+0x8c>
        *poff = off;
    80003278:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000327c:	fc045583          	lhu	a1,-64(s0)
    80003280:	00092503          	lw	a0,0(s2)
    80003284:	fffff097          	auipc	ra,0xfffff
    80003288:	752080e7          	jalr	1874(ra) # 800029d6 <iget>
    8000328c:	a011                	j	80003290 <dirlookup+0xa0>
  return 0;
    8000328e:	4501                	li	a0,0
}
    80003290:	70e2                	ld	ra,56(sp)
    80003292:	7442                	ld	s0,48(sp)
    80003294:	74a2                	ld	s1,40(sp)
    80003296:	7902                	ld	s2,32(sp)
    80003298:	69e2                	ld	s3,24(sp)
    8000329a:	6a42                	ld	s4,16(sp)
    8000329c:	6121                	addi	sp,sp,64
    8000329e:	8082                	ret

00000000800032a0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800032a0:	711d                	addi	sp,sp,-96
    800032a2:	ec86                	sd	ra,88(sp)
    800032a4:	e8a2                	sd	s0,80(sp)
    800032a6:	e4a6                	sd	s1,72(sp)
    800032a8:	e0ca                	sd	s2,64(sp)
    800032aa:	fc4e                	sd	s3,56(sp)
    800032ac:	f852                	sd	s4,48(sp)
    800032ae:	f456                	sd	s5,40(sp)
    800032b0:	f05a                	sd	s6,32(sp)
    800032b2:	ec5e                	sd	s7,24(sp)
    800032b4:	e862                	sd	s8,16(sp)
    800032b6:	e466                	sd	s9,8(sp)
    800032b8:	e06a                	sd	s10,0(sp)
    800032ba:	1080                	addi	s0,sp,96
    800032bc:	84aa                	mv	s1,a0
    800032be:	8b2e                	mv	s6,a1
    800032c0:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800032c2:	00054703          	lbu	a4,0(a0)
    800032c6:	02f00793          	li	a5,47
    800032ca:	02f70363          	beq	a4,a5,800032f0 <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800032ce:	ffffe097          	auipc	ra,0xffffe
    800032d2:	c68080e7          	jalr	-920(ra) # 80000f36 <myproc>
    800032d6:	15853503          	ld	a0,344(a0)
    800032da:	00000097          	auipc	ra,0x0
    800032de:	9f4080e7          	jalr	-1548(ra) # 80002cce <idup>
    800032e2:	8a2a                	mv	s4,a0
  while(*path == '/')
    800032e4:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800032e8:	4cb5                	li	s9,13
  len = path - s;
    800032ea:	4b81                	li	s7,0

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800032ec:	4c05                	li	s8,1
    800032ee:	a87d                	j	800033ac <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    800032f0:	4585                	li	a1,1
    800032f2:	4505                	li	a0,1
    800032f4:	fffff097          	auipc	ra,0xfffff
    800032f8:	6e2080e7          	jalr	1762(ra) # 800029d6 <iget>
    800032fc:	8a2a                	mv	s4,a0
    800032fe:	b7dd                	j	800032e4 <namex+0x44>
      iunlockput(ip);
    80003300:	8552                	mv	a0,s4
    80003302:	00000097          	auipc	ra,0x0
    80003306:	c6c080e7          	jalr	-916(ra) # 80002f6e <iunlockput>
      return 0;
    8000330a:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000330c:	8552                	mv	a0,s4
    8000330e:	60e6                	ld	ra,88(sp)
    80003310:	6446                	ld	s0,80(sp)
    80003312:	64a6                	ld	s1,72(sp)
    80003314:	6906                	ld	s2,64(sp)
    80003316:	79e2                	ld	s3,56(sp)
    80003318:	7a42                	ld	s4,48(sp)
    8000331a:	7aa2                	ld	s5,40(sp)
    8000331c:	7b02                	ld	s6,32(sp)
    8000331e:	6be2                	ld	s7,24(sp)
    80003320:	6c42                	ld	s8,16(sp)
    80003322:	6ca2                	ld	s9,8(sp)
    80003324:	6d02                	ld	s10,0(sp)
    80003326:	6125                	addi	sp,sp,96
    80003328:	8082                	ret
      iunlock(ip);
    8000332a:	8552                	mv	a0,s4
    8000332c:	00000097          	auipc	ra,0x0
    80003330:	aa2080e7          	jalr	-1374(ra) # 80002dce <iunlock>
      return ip;
    80003334:	bfe1                	j	8000330c <namex+0x6c>
      iunlockput(ip);
    80003336:	8552                	mv	a0,s4
    80003338:	00000097          	auipc	ra,0x0
    8000333c:	c36080e7          	jalr	-970(ra) # 80002f6e <iunlockput>
      return 0;
    80003340:	8a4e                	mv	s4,s3
    80003342:	b7e9                	j	8000330c <namex+0x6c>
  len = path - s;
    80003344:	40998633          	sub	a2,s3,s1
    80003348:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    8000334c:	09acd863          	bge	s9,s10,800033dc <namex+0x13c>
    memmove(name, s, DIRSIZ);
    80003350:	4639                	li	a2,14
    80003352:	85a6                	mv	a1,s1
    80003354:	8556                	mv	a0,s5
    80003356:	ffffd097          	auipc	ra,0xffffd
    8000335a:	e80080e7          	jalr	-384(ra) # 800001d6 <memmove>
    8000335e:	84ce                	mv	s1,s3
  while(*path == '/')
    80003360:	0004c783          	lbu	a5,0(s1)
    80003364:	01279763          	bne	a5,s2,80003372 <namex+0xd2>
    path++;
    80003368:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000336a:	0004c783          	lbu	a5,0(s1)
    8000336e:	ff278de3          	beq	a5,s2,80003368 <namex+0xc8>
    ilock(ip);
    80003372:	8552                	mv	a0,s4
    80003374:	00000097          	auipc	ra,0x0
    80003378:	998080e7          	jalr	-1640(ra) # 80002d0c <ilock>
    if(ip->type != T_DIR){
    8000337c:	044a1783          	lh	a5,68(s4)
    80003380:	f98790e3          	bne	a5,s8,80003300 <namex+0x60>
    if(nameiparent && *path == '\0'){
    80003384:	000b0563          	beqz	s6,8000338e <namex+0xee>
    80003388:	0004c783          	lbu	a5,0(s1)
    8000338c:	dfd9                	beqz	a5,8000332a <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000338e:	865e                	mv	a2,s7
    80003390:	85d6                	mv	a1,s5
    80003392:	8552                	mv	a0,s4
    80003394:	00000097          	auipc	ra,0x0
    80003398:	e5c080e7          	jalr	-420(ra) # 800031f0 <dirlookup>
    8000339c:	89aa                	mv	s3,a0
    8000339e:	dd41                	beqz	a0,80003336 <namex+0x96>
    iunlockput(ip);
    800033a0:	8552                	mv	a0,s4
    800033a2:	00000097          	auipc	ra,0x0
    800033a6:	bcc080e7          	jalr	-1076(ra) # 80002f6e <iunlockput>
    ip = next;
    800033aa:	8a4e                	mv	s4,s3
  while(*path == '/')
    800033ac:	0004c783          	lbu	a5,0(s1)
    800033b0:	01279763          	bne	a5,s2,800033be <namex+0x11e>
    path++;
    800033b4:	0485                	addi	s1,s1,1
  while(*path == '/')
    800033b6:	0004c783          	lbu	a5,0(s1)
    800033ba:	ff278de3          	beq	a5,s2,800033b4 <namex+0x114>
  if(*path == 0)
    800033be:	cb9d                	beqz	a5,800033f4 <namex+0x154>
  while(*path != '/' && *path != 0)
    800033c0:	0004c783          	lbu	a5,0(s1)
    800033c4:	89a6                	mv	s3,s1
  len = path - s;
    800033c6:	8d5e                	mv	s10,s7
    800033c8:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    800033ca:	01278963          	beq	a5,s2,800033dc <namex+0x13c>
    800033ce:	dbbd                	beqz	a5,80003344 <namex+0xa4>
    path++;
    800033d0:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800033d2:	0009c783          	lbu	a5,0(s3)
    800033d6:	ff279ce3          	bne	a5,s2,800033ce <namex+0x12e>
    800033da:	b7ad                	j	80003344 <namex+0xa4>
    memmove(name, s, len);
    800033dc:	2601                	sext.w	a2,a2
    800033de:	85a6                	mv	a1,s1
    800033e0:	8556                	mv	a0,s5
    800033e2:	ffffd097          	auipc	ra,0xffffd
    800033e6:	df4080e7          	jalr	-524(ra) # 800001d6 <memmove>
    name[len] = 0;
    800033ea:	9d56                	add	s10,s10,s5
    800033ec:	000d0023          	sb	zero,0(s10)
    800033f0:	84ce                	mv	s1,s3
    800033f2:	b7bd                	j	80003360 <namex+0xc0>
  if(nameiparent){
    800033f4:	f00b0ce3          	beqz	s6,8000330c <namex+0x6c>
    iput(ip);
    800033f8:	8552                	mv	a0,s4
    800033fa:	00000097          	auipc	ra,0x0
    800033fe:	acc080e7          	jalr	-1332(ra) # 80002ec6 <iput>
    return 0;
    80003402:	4a01                	li	s4,0
    80003404:	b721                	j	8000330c <namex+0x6c>

0000000080003406 <dirlink>:
{
    80003406:	7139                	addi	sp,sp,-64
    80003408:	fc06                	sd	ra,56(sp)
    8000340a:	f822                	sd	s0,48(sp)
    8000340c:	f426                	sd	s1,40(sp)
    8000340e:	f04a                	sd	s2,32(sp)
    80003410:	ec4e                	sd	s3,24(sp)
    80003412:	e852                	sd	s4,16(sp)
    80003414:	0080                	addi	s0,sp,64
    80003416:	892a                	mv	s2,a0
    80003418:	8a2e                	mv	s4,a1
    8000341a:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000341c:	4601                	li	a2,0
    8000341e:	00000097          	auipc	ra,0x0
    80003422:	dd2080e7          	jalr	-558(ra) # 800031f0 <dirlookup>
    80003426:	e93d                	bnez	a0,8000349c <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003428:	04c92483          	lw	s1,76(s2)
    8000342c:	c49d                	beqz	s1,8000345a <dirlink+0x54>
    8000342e:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003430:	4741                	li	a4,16
    80003432:	86a6                	mv	a3,s1
    80003434:	fc040613          	addi	a2,s0,-64
    80003438:	4581                	li	a1,0
    8000343a:	854a                	mv	a0,s2
    8000343c:	00000097          	auipc	ra,0x0
    80003440:	b84080e7          	jalr	-1148(ra) # 80002fc0 <readi>
    80003444:	47c1                	li	a5,16
    80003446:	06f51163          	bne	a0,a5,800034a8 <dirlink+0xa2>
    if(de.inum == 0)
    8000344a:	fc045783          	lhu	a5,-64(s0)
    8000344e:	c791                	beqz	a5,8000345a <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003450:	24c1                	addiw	s1,s1,16
    80003452:	04c92783          	lw	a5,76(s2)
    80003456:	fcf4ede3          	bltu	s1,a5,80003430 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000345a:	4639                	li	a2,14
    8000345c:	85d2                	mv	a1,s4
    8000345e:	fc240513          	addi	a0,s0,-62
    80003462:	ffffd097          	auipc	ra,0xffffd
    80003466:	e24080e7          	jalr	-476(ra) # 80000286 <strncpy>
  de.inum = inum;
    8000346a:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000346e:	4741                	li	a4,16
    80003470:	86a6                	mv	a3,s1
    80003472:	fc040613          	addi	a2,s0,-64
    80003476:	4581                	li	a1,0
    80003478:	854a                	mv	a0,s2
    8000347a:	00000097          	auipc	ra,0x0
    8000347e:	c3e080e7          	jalr	-962(ra) # 800030b8 <writei>
    80003482:	872a                	mv	a4,a0
    80003484:	47c1                	li	a5,16
  return 0;
    80003486:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003488:	02f71863          	bne	a4,a5,800034b8 <dirlink+0xb2>
}
    8000348c:	70e2                	ld	ra,56(sp)
    8000348e:	7442                	ld	s0,48(sp)
    80003490:	74a2                	ld	s1,40(sp)
    80003492:	7902                	ld	s2,32(sp)
    80003494:	69e2                	ld	s3,24(sp)
    80003496:	6a42                	ld	s4,16(sp)
    80003498:	6121                	addi	sp,sp,64
    8000349a:	8082                	ret
    iput(ip);
    8000349c:	00000097          	auipc	ra,0x0
    800034a0:	a2a080e7          	jalr	-1494(ra) # 80002ec6 <iput>
    return -1;
    800034a4:	557d                	li	a0,-1
    800034a6:	b7dd                	j	8000348c <dirlink+0x86>
      panic("dirlink read");
    800034a8:	00005517          	auipc	a0,0x5
    800034ac:	1a850513          	addi	a0,a0,424 # 80008650 <syscalls+0x228>
    800034b0:	00003097          	auipc	ra,0x3
    800034b4:	8f0080e7          	jalr	-1808(ra) # 80005da0 <panic>
    panic("dirlink");
    800034b8:	00005517          	auipc	a0,0x5
    800034bc:	2a850513          	addi	a0,a0,680 # 80008760 <syscalls+0x338>
    800034c0:	00003097          	auipc	ra,0x3
    800034c4:	8e0080e7          	jalr	-1824(ra) # 80005da0 <panic>

00000000800034c8 <namei>:

struct inode*
namei(char *path)
{
    800034c8:	1101                	addi	sp,sp,-32
    800034ca:	ec06                	sd	ra,24(sp)
    800034cc:	e822                	sd	s0,16(sp)
    800034ce:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800034d0:	fe040613          	addi	a2,s0,-32
    800034d4:	4581                	li	a1,0
    800034d6:	00000097          	auipc	ra,0x0
    800034da:	dca080e7          	jalr	-566(ra) # 800032a0 <namex>
}
    800034de:	60e2                	ld	ra,24(sp)
    800034e0:	6442                	ld	s0,16(sp)
    800034e2:	6105                	addi	sp,sp,32
    800034e4:	8082                	ret

00000000800034e6 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800034e6:	1141                	addi	sp,sp,-16
    800034e8:	e406                	sd	ra,8(sp)
    800034ea:	e022                	sd	s0,0(sp)
    800034ec:	0800                	addi	s0,sp,16
    800034ee:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800034f0:	4585                	li	a1,1
    800034f2:	00000097          	auipc	ra,0x0
    800034f6:	dae080e7          	jalr	-594(ra) # 800032a0 <namex>
}
    800034fa:	60a2                	ld	ra,8(sp)
    800034fc:	6402                	ld	s0,0(sp)
    800034fe:	0141                	addi	sp,sp,16
    80003500:	8082                	ret

0000000080003502 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003502:	1101                	addi	sp,sp,-32
    80003504:	ec06                	sd	ra,24(sp)
    80003506:	e822                	sd	s0,16(sp)
    80003508:	e426                	sd	s1,8(sp)
    8000350a:	e04a                	sd	s2,0(sp)
    8000350c:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000350e:	00016917          	auipc	s2,0x16
    80003512:	d1290913          	addi	s2,s2,-750 # 80019220 <log>
    80003516:	01892583          	lw	a1,24(s2)
    8000351a:	02892503          	lw	a0,40(s2)
    8000351e:	fffff097          	auipc	ra,0xfffff
    80003522:	fec080e7          	jalr	-20(ra) # 8000250a <bread>
    80003526:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003528:	02c92683          	lw	a3,44(s2)
    8000352c:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000352e:	02d05863          	blez	a3,8000355e <write_head+0x5c>
    80003532:	00016797          	auipc	a5,0x16
    80003536:	d1e78793          	addi	a5,a5,-738 # 80019250 <log+0x30>
    8000353a:	05c50713          	addi	a4,a0,92
    8000353e:	36fd                	addiw	a3,a3,-1
    80003540:	02069613          	slli	a2,a3,0x20
    80003544:	01e65693          	srli	a3,a2,0x1e
    80003548:	00016617          	auipc	a2,0x16
    8000354c:	d0c60613          	addi	a2,a2,-756 # 80019254 <log+0x34>
    80003550:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003552:	4390                	lw	a2,0(a5)
    80003554:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003556:	0791                	addi	a5,a5,4
    80003558:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    8000355a:	fed79ce3          	bne	a5,a3,80003552 <write_head+0x50>
  }
  bwrite(buf);
    8000355e:	8526                	mv	a0,s1
    80003560:	fffff097          	auipc	ra,0xfffff
    80003564:	09c080e7          	jalr	156(ra) # 800025fc <bwrite>
  brelse(buf);
    80003568:	8526                	mv	a0,s1
    8000356a:	fffff097          	auipc	ra,0xfffff
    8000356e:	0d0080e7          	jalr	208(ra) # 8000263a <brelse>
}
    80003572:	60e2                	ld	ra,24(sp)
    80003574:	6442                	ld	s0,16(sp)
    80003576:	64a2                	ld	s1,8(sp)
    80003578:	6902                	ld	s2,0(sp)
    8000357a:	6105                	addi	sp,sp,32
    8000357c:	8082                	ret

000000008000357e <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000357e:	00016797          	auipc	a5,0x16
    80003582:	cce7a783          	lw	a5,-818(a5) # 8001924c <log+0x2c>
    80003586:	0af05d63          	blez	a5,80003640 <install_trans+0xc2>
{
    8000358a:	7139                	addi	sp,sp,-64
    8000358c:	fc06                	sd	ra,56(sp)
    8000358e:	f822                	sd	s0,48(sp)
    80003590:	f426                	sd	s1,40(sp)
    80003592:	f04a                	sd	s2,32(sp)
    80003594:	ec4e                	sd	s3,24(sp)
    80003596:	e852                	sd	s4,16(sp)
    80003598:	e456                	sd	s5,8(sp)
    8000359a:	e05a                	sd	s6,0(sp)
    8000359c:	0080                	addi	s0,sp,64
    8000359e:	8b2a                	mv	s6,a0
    800035a0:	00016a97          	auipc	s5,0x16
    800035a4:	cb0a8a93          	addi	s5,s5,-848 # 80019250 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035a8:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800035aa:	00016997          	auipc	s3,0x16
    800035ae:	c7698993          	addi	s3,s3,-906 # 80019220 <log>
    800035b2:	a00d                	j	800035d4 <install_trans+0x56>
    brelse(lbuf);
    800035b4:	854a                	mv	a0,s2
    800035b6:	fffff097          	auipc	ra,0xfffff
    800035ba:	084080e7          	jalr	132(ra) # 8000263a <brelse>
    brelse(dbuf);
    800035be:	8526                	mv	a0,s1
    800035c0:	fffff097          	auipc	ra,0xfffff
    800035c4:	07a080e7          	jalr	122(ra) # 8000263a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035c8:	2a05                	addiw	s4,s4,1
    800035ca:	0a91                	addi	s5,s5,4
    800035cc:	02c9a783          	lw	a5,44(s3)
    800035d0:	04fa5e63          	bge	s4,a5,8000362c <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800035d4:	0189a583          	lw	a1,24(s3)
    800035d8:	014585bb          	addw	a1,a1,s4
    800035dc:	2585                	addiw	a1,a1,1
    800035de:	0289a503          	lw	a0,40(s3)
    800035e2:	fffff097          	auipc	ra,0xfffff
    800035e6:	f28080e7          	jalr	-216(ra) # 8000250a <bread>
    800035ea:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800035ec:	000aa583          	lw	a1,0(s5)
    800035f0:	0289a503          	lw	a0,40(s3)
    800035f4:	fffff097          	auipc	ra,0xfffff
    800035f8:	f16080e7          	jalr	-234(ra) # 8000250a <bread>
    800035fc:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800035fe:	40000613          	li	a2,1024
    80003602:	05890593          	addi	a1,s2,88
    80003606:	05850513          	addi	a0,a0,88
    8000360a:	ffffd097          	auipc	ra,0xffffd
    8000360e:	bcc080e7          	jalr	-1076(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003612:	8526                	mv	a0,s1
    80003614:	fffff097          	auipc	ra,0xfffff
    80003618:	fe8080e7          	jalr	-24(ra) # 800025fc <bwrite>
    if(recovering == 0)
    8000361c:	f80b1ce3          	bnez	s6,800035b4 <install_trans+0x36>
      bunpin(dbuf);
    80003620:	8526                	mv	a0,s1
    80003622:	fffff097          	auipc	ra,0xfffff
    80003626:	0f2080e7          	jalr	242(ra) # 80002714 <bunpin>
    8000362a:	b769                	j	800035b4 <install_trans+0x36>
}
    8000362c:	70e2                	ld	ra,56(sp)
    8000362e:	7442                	ld	s0,48(sp)
    80003630:	74a2                	ld	s1,40(sp)
    80003632:	7902                	ld	s2,32(sp)
    80003634:	69e2                	ld	s3,24(sp)
    80003636:	6a42                	ld	s4,16(sp)
    80003638:	6aa2                	ld	s5,8(sp)
    8000363a:	6b02                	ld	s6,0(sp)
    8000363c:	6121                	addi	sp,sp,64
    8000363e:	8082                	ret
    80003640:	8082                	ret

0000000080003642 <initlog>:
{
    80003642:	7179                	addi	sp,sp,-48
    80003644:	f406                	sd	ra,40(sp)
    80003646:	f022                	sd	s0,32(sp)
    80003648:	ec26                	sd	s1,24(sp)
    8000364a:	e84a                	sd	s2,16(sp)
    8000364c:	e44e                	sd	s3,8(sp)
    8000364e:	1800                	addi	s0,sp,48
    80003650:	892a                	mv	s2,a0
    80003652:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003654:	00016497          	auipc	s1,0x16
    80003658:	bcc48493          	addi	s1,s1,-1076 # 80019220 <log>
    8000365c:	00005597          	auipc	a1,0x5
    80003660:	00458593          	addi	a1,a1,4 # 80008660 <syscalls+0x238>
    80003664:	8526                	mv	a0,s1
    80003666:	00003097          	auipc	ra,0x3
    8000366a:	be2080e7          	jalr	-1054(ra) # 80006248 <initlock>
  log.start = sb->logstart;
    8000366e:	0149a583          	lw	a1,20(s3)
    80003672:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003674:	0109a783          	lw	a5,16(s3)
    80003678:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000367a:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000367e:	854a                	mv	a0,s2
    80003680:	fffff097          	auipc	ra,0xfffff
    80003684:	e8a080e7          	jalr	-374(ra) # 8000250a <bread>
  log.lh.n = lh->n;
    80003688:	4d34                	lw	a3,88(a0)
    8000368a:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000368c:	02d05663          	blez	a3,800036b8 <initlog+0x76>
    80003690:	05c50793          	addi	a5,a0,92
    80003694:	00016717          	auipc	a4,0x16
    80003698:	bbc70713          	addi	a4,a4,-1092 # 80019250 <log+0x30>
    8000369c:	36fd                	addiw	a3,a3,-1
    8000369e:	02069613          	slli	a2,a3,0x20
    800036a2:	01e65693          	srli	a3,a2,0x1e
    800036a6:	06050613          	addi	a2,a0,96
    800036aa:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    800036ac:	4390                	lw	a2,0(a5)
    800036ae:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800036b0:	0791                	addi	a5,a5,4
    800036b2:	0711                	addi	a4,a4,4
    800036b4:	fed79ce3          	bne	a5,a3,800036ac <initlog+0x6a>
  brelse(buf);
    800036b8:	fffff097          	auipc	ra,0xfffff
    800036bc:	f82080e7          	jalr	-126(ra) # 8000263a <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800036c0:	4505                	li	a0,1
    800036c2:	00000097          	auipc	ra,0x0
    800036c6:	ebc080e7          	jalr	-324(ra) # 8000357e <install_trans>
  log.lh.n = 0;
    800036ca:	00016797          	auipc	a5,0x16
    800036ce:	b807a123          	sw	zero,-1150(a5) # 8001924c <log+0x2c>
  write_head(); // clear the log
    800036d2:	00000097          	auipc	ra,0x0
    800036d6:	e30080e7          	jalr	-464(ra) # 80003502 <write_head>
}
    800036da:	70a2                	ld	ra,40(sp)
    800036dc:	7402                	ld	s0,32(sp)
    800036de:	64e2                	ld	s1,24(sp)
    800036e0:	6942                	ld	s2,16(sp)
    800036e2:	69a2                	ld	s3,8(sp)
    800036e4:	6145                	addi	sp,sp,48
    800036e6:	8082                	ret

00000000800036e8 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800036e8:	1101                	addi	sp,sp,-32
    800036ea:	ec06                	sd	ra,24(sp)
    800036ec:	e822                	sd	s0,16(sp)
    800036ee:	e426                	sd	s1,8(sp)
    800036f0:	e04a                	sd	s2,0(sp)
    800036f2:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800036f4:	00016517          	auipc	a0,0x16
    800036f8:	b2c50513          	addi	a0,a0,-1236 # 80019220 <log>
    800036fc:	00003097          	auipc	ra,0x3
    80003700:	bdc080e7          	jalr	-1060(ra) # 800062d8 <acquire>
  while(1){
    if(log.committing){
    80003704:	00016497          	auipc	s1,0x16
    80003708:	b1c48493          	addi	s1,s1,-1252 # 80019220 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000370c:	4979                	li	s2,30
    8000370e:	a039                	j	8000371c <begin_op+0x34>
      sleep(&log, &log.lock);
    80003710:	85a6                	mv	a1,s1
    80003712:	8526                	mv	a0,s1
    80003714:	ffffe097          	auipc	ra,0xffffe
    80003718:	f96080e7          	jalr	-106(ra) # 800016aa <sleep>
    if(log.committing){
    8000371c:	50dc                	lw	a5,36(s1)
    8000371e:	fbed                	bnez	a5,80003710 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003720:	5098                	lw	a4,32(s1)
    80003722:	2705                	addiw	a4,a4,1
    80003724:	0007069b          	sext.w	a3,a4
    80003728:	0027179b          	slliw	a5,a4,0x2
    8000372c:	9fb9                	addw	a5,a5,a4
    8000372e:	0017979b          	slliw	a5,a5,0x1
    80003732:	54d8                	lw	a4,44(s1)
    80003734:	9fb9                	addw	a5,a5,a4
    80003736:	00f95963          	bge	s2,a5,80003748 <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000373a:	85a6                	mv	a1,s1
    8000373c:	8526                	mv	a0,s1
    8000373e:	ffffe097          	auipc	ra,0xffffe
    80003742:	f6c080e7          	jalr	-148(ra) # 800016aa <sleep>
    80003746:	bfd9                	j	8000371c <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003748:	00016517          	auipc	a0,0x16
    8000374c:	ad850513          	addi	a0,a0,-1320 # 80019220 <log>
    80003750:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003752:	00003097          	auipc	ra,0x3
    80003756:	c3a080e7          	jalr	-966(ra) # 8000638c <release>
      break;
    }
  }
}
    8000375a:	60e2                	ld	ra,24(sp)
    8000375c:	6442                	ld	s0,16(sp)
    8000375e:	64a2                	ld	s1,8(sp)
    80003760:	6902                	ld	s2,0(sp)
    80003762:	6105                	addi	sp,sp,32
    80003764:	8082                	ret

0000000080003766 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003766:	7139                	addi	sp,sp,-64
    80003768:	fc06                	sd	ra,56(sp)
    8000376a:	f822                	sd	s0,48(sp)
    8000376c:	f426                	sd	s1,40(sp)
    8000376e:	f04a                	sd	s2,32(sp)
    80003770:	ec4e                	sd	s3,24(sp)
    80003772:	e852                	sd	s4,16(sp)
    80003774:	e456                	sd	s5,8(sp)
    80003776:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003778:	00016497          	auipc	s1,0x16
    8000377c:	aa848493          	addi	s1,s1,-1368 # 80019220 <log>
    80003780:	8526                	mv	a0,s1
    80003782:	00003097          	auipc	ra,0x3
    80003786:	b56080e7          	jalr	-1194(ra) # 800062d8 <acquire>
  log.outstanding -= 1;
    8000378a:	509c                	lw	a5,32(s1)
    8000378c:	37fd                	addiw	a5,a5,-1
    8000378e:	0007891b          	sext.w	s2,a5
    80003792:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003794:	50dc                	lw	a5,36(s1)
    80003796:	e7b9                	bnez	a5,800037e4 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003798:	04091e63          	bnez	s2,800037f4 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    8000379c:	00016497          	auipc	s1,0x16
    800037a0:	a8448493          	addi	s1,s1,-1404 # 80019220 <log>
    800037a4:	4785                	li	a5,1
    800037a6:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800037a8:	8526                	mv	a0,s1
    800037aa:	00003097          	auipc	ra,0x3
    800037ae:	be2080e7          	jalr	-1054(ra) # 8000638c <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800037b2:	54dc                	lw	a5,44(s1)
    800037b4:	06f04763          	bgtz	a5,80003822 <end_op+0xbc>
    acquire(&log.lock);
    800037b8:	00016497          	auipc	s1,0x16
    800037bc:	a6848493          	addi	s1,s1,-1432 # 80019220 <log>
    800037c0:	8526                	mv	a0,s1
    800037c2:	00003097          	auipc	ra,0x3
    800037c6:	b16080e7          	jalr	-1258(ra) # 800062d8 <acquire>
    log.committing = 0;
    800037ca:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800037ce:	8526                	mv	a0,s1
    800037d0:	ffffe097          	auipc	ra,0xffffe
    800037d4:	066080e7          	jalr	102(ra) # 80001836 <wakeup>
    release(&log.lock);
    800037d8:	8526                	mv	a0,s1
    800037da:	00003097          	auipc	ra,0x3
    800037de:	bb2080e7          	jalr	-1102(ra) # 8000638c <release>
}
    800037e2:	a03d                	j	80003810 <end_op+0xaa>
    panic("log.committing");
    800037e4:	00005517          	auipc	a0,0x5
    800037e8:	e8450513          	addi	a0,a0,-380 # 80008668 <syscalls+0x240>
    800037ec:	00002097          	auipc	ra,0x2
    800037f0:	5b4080e7          	jalr	1460(ra) # 80005da0 <panic>
    wakeup(&log);
    800037f4:	00016497          	auipc	s1,0x16
    800037f8:	a2c48493          	addi	s1,s1,-1492 # 80019220 <log>
    800037fc:	8526                	mv	a0,s1
    800037fe:	ffffe097          	auipc	ra,0xffffe
    80003802:	038080e7          	jalr	56(ra) # 80001836 <wakeup>
  release(&log.lock);
    80003806:	8526                	mv	a0,s1
    80003808:	00003097          	auipc	ra,0x3
    8000380c:	b84080e7          	jalr	-1148(ra) # 8000638c <release>
}
    80003810:	70e2                	ld	ra,56(sp)
    80003812:	7442                	ld	s0,48(sp)
    80003814:	74a2                	ld	s1,40(sp)
    80003816:	7902                	ld	s2,32(sp)
    80003818:	69e2                	ld	s3,24(sp)
    8000381a:	6a42                	ld	s4,16(sp)
    8000381c:	6aa2                	ld	s5,8(sp)
    8000381e:	6121                	addi	sp,sp,64
    80003820:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80003822:	00016a97          	auipc	s5,0x16
    80003826:	a2ea8a93          	addi	s5,s5,-1490 # 80019250 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000382a:	00016a17          	auipc	s4,0x16
    8000382e:	9f6a0a13          	addi	s4,s4,-1546 # 80019220 <log>
    80003832:	018a2583          	lw	a1,24(s4)
    80003836:	012585bb          	addw	a1,a1,s2
    8000383a:	2585                	addiw	a1,a1,1
    8000383c:	028a2503          	lw	a0,40(s4)
    80003840:	fffff097          	auipc	ra,0xfffff
    80003844:	cca080e7          	jalr	-822(ra) # 8000250a <bread>
    80003848:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000384a:	000aa583          	lw	a1,0(s5)
    8000384e:	028a2503          	lw	a0,40(s4)
    80003852:	fffff097          	auipc	ra,0xfffff
    80003856:	cb8080e7          	jalr	-840(ra) # 8000250a <bread>
    8000385a:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000385c:	40000613          	li	a2,1024
    80003860:	05850593          	addi	a1,a0,88
    80003864:	05848513          	addi	a0,s1,88
    80003868:	ffffd097          	auipc	ra,0xffffd
    8000386c:	96e080e7          	jalr	-1682(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    80003870:	8526                	mv	a0,s1
    80003872:	fffff097          	auipc	ra,0xfffff
    80003876:	d8a080e7          	jalr	-630(ra) # 800025fc <bwrite>
    brelse(from);
    8000387a:	854e                	mv	a0,s3
    8000387c:	fffff097          	auipc	ra,0xfffff
    80003880:	dbe080e7          	jalr	-578(ra) # 8000263a <brelse>
    brelse(to);
    80003884:	8526                	mv	a0,s1
    80003886:	fffff097          	auipc	ra,0xfffff
    8000388a:	db4080e7          	jalr	-588(ra) # 8000263a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000388e:	2905                	addiw	s2,s2,1
    80003890:	0a91                	addi	s5,s5,4
    80003892:	02ca2783          	lw	a5,44(s4)
    80003896:	f8f94ee3          	blt	s2,a5,80003832 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000389a:	00000097          	auipc	ra,0x0
    8000389e:	c68080e7          	jalr	-920(ra) # 80003502 <write_head>
    install_trans(0); // Now install writes to home locations
    800038a2:	4501                	li	a0,0
    800038a4:	00000097          	auipc	ra,0x0
    800038a8:	cda080e7          	jalr	-806(ra) # 8000357e <install_trans>
    log.lh.n = 0;
    800038ac:	00016797          	auipc	a5,0x16
    800038b0:	9a07a023          	sw	zero,-1632(a5) # 8001924c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800038b4:	00000097          	auipc	ra,0x0
    800038b8:	c4e080e7          	jalr	-946(ra) # 80003502 <write_head>
    800038bc:	bdf5                	j	800037b8 <end_op+0x52>

00000000800038be <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800038be:	1101                	addi	sp,sp,-32
    800038c0:	ec06                	sd	ra,24(sp)
    800038c2:	e822                	sd	s0,16(sp)
    800038c4:	e426                	sd	s1,8(sp)
    800038c6:	e04a                	sd	s2,0(sp)
    800038c8:	1000                	addi	s0,sp,32
    800038ca:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800038cc:	00016917          	auipc	s2,0x16
    800038d0:	95490913          	addi	s2,s2,-1708 # 80019220 <log>
    800038d4:	854a                	mv	a0,s2
    800038d6:	00003097          	auipc	ra,0x3
    800038da:	a02080e7          	jalr	-1534(ra) # 800062d8 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800038de:	02c92603          	lw	a2,44(s2)
    800038e2:	47f5                	li	a5,29
    800038e4:	06c7c563          	blt	a5,a2,8000394e <log_write+0x90>
    800038e8:	00016797          	auipc	a5,0x16
    800038ec:	9547a783          	lw	a5,-1708(a5) # 8001923c <log+0x1c>
    800038f0:	37fd                	addiw	a5,a5,-1
    800038f2:	04f65e63          	bge	a2,a5,8000394e <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800038f6:	00016797          	auipc	a5,0x16
    800038fa:	94a7a783          	lw	a5,-1718(a5) # 80019240 <log+0x20>
    800038fe:	06f05063          	blez	a5,8000395e <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003902:	4781                	li	a5,0
    80003904:	06c05563          	blez	a2,8000396e <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003908:	44cc                	lw	a1,12(s1)
    8000390a:	00016717          	auipc	a4,0x16
    8000390e:	94670713          	addi	a4,a4,-1722 # 80019250 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003912:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003914:	4314                	lw	a3,0(a4)
    80003916:	04b68c63          	beq	a3,a1,8000396e <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000391a:	2785                	addiw	a5,a5,1
    8000391c:	0711                	addi	a4,a4,4
    8000391e:	fef61be3          	bne	a2,a5,80003914 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003922:	0621                	addi	a2,a2,8
    80003924:	060a                	slli	a2,a2,0x2
    80003926:	00016797          	auipc	a5,0x16
    8000392a:	8fa78793          	addi	a5,a5,-1798 # 80019220 <log>
    8000392e:	97b2                	add	a5,a5,a2
    80003930:	44d8                	lw	a4,12(s1)
    80003932:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003934:	8526                	mv	a0,s1
    80003936:	fffff097          	auipc	ra,0xfffff
    8000393a:	da2080e7          	jalr	-606(ra) # 800026d8 <bpin>
    log.lh.n++;
    8000393e:	00016717          	auipc	a4,0x16
    80003942:	8e270713          	addi	a4,a4,-1822 # 80019220 <log>
    80003946:	575c                	lw	a5,44(a4)
    80003948:	2785                	addiw	a5,a5,1
    8000394a:	d75c                	sw	a5,44(a4)
    8000394c:	a82d                	j	80003986 <log_write+0xc8>
    panic("too big a transaction");
    8000394e:	00005517          	auipc	a0,0x5
    80003952:	d2a50513          	addi	a0,a0,-726 # 80008678 <syscalls+0x250>
    80003956:	00002097          	auipc	ra,0x2
    8000395a:	44a080e7          	jalr	1098(ra) # 80005da0 <panic>
    panic("log_write outside of trans");
    8000395e:	00005517          	auipc	a0,0x5
    80003962:	d3250513          	addi	a0,a0,-718 # 80008690 <syscalls+0x268>
    80003966:	00002097          	auipc	ra,0x2
    8000396a:	43a080e7          	jalr	1082(ra) # 80005da0 <panic>
  log.lh.block[i] = b->blockno;
    8000396e:	00878693          	addi	a3,a5,8
    80003972:	068a                	slli	a3,a3,0x2
    80003974:	00016717          	auipc	a4,0x16
    80003978:	8ac70713          	addi	a4,a4,-1876 # 80019220 <log>
    8000397c:	9736                	add	a4,a4,a3
    8000397e:	44d4                	lw	a3,12(s1)
    80003980:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003982:	faf609e3          	beq	a2,a5,80003934 <log_write+0x76>
  }
  release(&log.lock);
    80003986:	00016517          	auipc	a0,0x16
    8000398a:	89a50513          	addi	a0,a0,-1894 # 80019220 <log>
    8000398e:	00003097          	auipc	ra,0x3
    80003992:	9fe080e7          	jalr	-1538(ra) # 8000638c <release>
}
    80003996:	60e2                	ld	ra,24(sp)
    80003998:	6442                	ld	s0,16(sp)
    8000399a:	64a2                	ld	s1,8(sp)
    8000399c:	6902                	ld	s2,0(sp)
    8000399e:	6105                	addi	sp,sp,32
    800039a0:	8082                	ret

00000000800039a2 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800039a2:	1101                	addi	sp,sp,-32
    800039a4:	ec06                	sd	ra,24(sp)
    800039a6:	e822                	sd	s0,16(sp)
    800039a8:	e426                	sd	s1,8(sp)
    800039aa:	e04a                	sd	s2,0(sp)
    800039ac:	1000                	addi	s0,sp,32
    800039ae:	84aa                	mv	s1,a0
    800039b0:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800039b2:	00005597          	auipc	a1,0x5
    800039b6:	cfe58593          	addi	a1,a1,-770 # 800086b0 <syscalls+0x288>
    800039ba:	0521                	addi	a0,a0,8
    800039bc:	00003097          	auipc	ra,0x3
    800039c0:	88c080e7          	jalr	-1908(ra) # 80006248 <initlock>
  lk->name = name;
    800039c4:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800039c8:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800039cc:	0204a423          	sw	zero,40(s1)
}
    800039d0:	60e2                	ld	ra,24(sp)
    800039d2:	6442                	ld	s0,16(sp)
    800039d4:	64a2                	ld	s1,8(sp)
    800039d6:	6902                	ld	s2,0(sp)
    800039d8:	6105                	addi	sp,sp,32
    800039da:	8082                	ret

00000000800039dc <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800039dc:	1101                	addi	sp,sp,-32
    800039de:	ec06                	sd	ra,24(sp)
    800039e0:	e822                	sd	s0,16(sp)
    800039e2:	e426                	sd	s1,8(sp)
    800039e4:	e04a                	sd	s2,0(sp)
    800039e6:	1000                	addi	s0,sp,32
    800039e8:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800039ea:	00850913          	addi	s2,a0,8
    800039ee:	854a                	mv	a0,s2
    800039f0:	00003097          	auipc	ra,0x3
    800039f4:	8e8080e7          	jalr	-1816(ra) # 800062d8 <acquire>
  while (lk->locked) {
    800039f8:	409c                	lw	a5,0(s1)
    800039fa:	cb89                	beqz	a5,80003a0c <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800039fc:	85ca                	mv	a1,s2
    800039fe:	8526                	mv	a0,s1
    80003a00:	ffffe097          	auipc	ra,0xffffe
    80003a04:	caa080e7          	jalr	-854(ra) # 800016aa <sleep>
  while (lk->locked) {
    80003a08:	409c                	lw	a5,0(s1)
    80003a0a:	fbed                	bnez	a5,800039fc <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003a0c:	4785                	li	a5,1
    80003a0e:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003a10:	ffffd097          	auipc	ra,0xffffd
    80003a14:	526080e7          	jalr	1318(ra) # 80000f36 <myproc>
    80003a18:	5d1c                	lw	a5,56(a0)
    80003a1a:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003a1c:	854a                	mv	a0,s2
    80003a1e:	00003097          	auipc	ra,0x3
    80003a22:	96e080e7          	jalr	-1682(ra) # 8000638c <release>
}
    80003a26:	60e2                	ld	ra,24(sp)
    80003a28:	6442                	ld	s0,16(sp)
    80003a2a:	64a2                	ld	s1,8(sp)
    80003a2c:	6902                	ld	s2,0(sp)
    80003a2e:	6105                	addi	sp,sp,32
    80003a30:	8082                	ret

0000000080003a32 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003a32:	1101                	addi	sp,sp,-32
    80003a34:	ec06                	sd	ra,24(sp)
    80003a36:	e822                	sd	s0,16(sp)
    80003a38:	e426                	sd	s1,8(sp)
    80003a3a:	e04a                	sd	s2,0(sp)
    80003a3c:	1000                	addi	s0,sp,32
    80003a3e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a40:	00850913          	addi	s2,a0,8
    80003a44:	854a                	mv	a0,s2
    80003a46:	00003097          	auipc	ra,0x3
    80003a4a:	892080e7          	jalr	-1902(ra) # 800062d8 <acquire>
  lk->locked = 0;
    80003a4e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a52:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003a56:	8526                	mv	a0,s1
    80003a58:	ffffe097          	auipc	ra,0xffffe
    80003a5c:	dde080e7          	jalr	-546(ra) # 80001836 <wakeup>
  release(&lk->lk);
    80003a60:	854a                	mv	a0,s2
    80003a62:	00003097          	auipc	ra,0x3
    80003a66:	92a080e7          	jalr	-1750(ra) # 8000638c <release>
}
    80003a6a:	60e2                	ld	ra,24(sp)
    80003a6c:	6442                	ld	s0,16(sp)
    80003a6e:	64a2                	ld	s1,8(sp)
    80003a70:	6902                	ld	s2,0(sp)
    80003a72:	6105                	addi	sp,sp,32
    80003a74:	8082                	ret

0000000080003a76 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003a76:	7179                	addi	sp,sp,-48
    80003a78:	f406                	sd	ra,40(sp)
    80003a7a:	f022                	sd	s0,32(sp)
    80003a7c:	ec26                	sd	s1,24(sp)
    80003a7e:	e84a                	sd	s2,16(sp)
    80003a80:	e44e                	sd	s3,8(sp)
    80003a82:	1800                	addi	s0,sp,48
    80003a84:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003a86:	00850913          	addi	s2,a0,8
    80003a8a:	854a                	mv	a0,s2
    80003a8c:	00003097          	auipc	ra,0x3
    80003a90:	84c080e7          	jalr	-1972(ra) # 800062d8 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a94:	409c                	lw	a5,0(s1)
    80003a96:	ef99                	bnez	a5,80003ab4 <holdingsleep+0x3e>
    80003a98:	4481                	li	s1,0
  release(&lk->lk);
    80003a9a:	854a                	mv	a0,s2
    80003a9c:	00003097          	auipc	ra,0x3
    80003aa0:	8f0080e7          	jalr	-1808(ra) # 8000638c <release>
  return r;
}
    80003aa4:	8526                	mv	a0,s1
    80003aa6:	70a2                	ld	ra,40(sp)
    80003aa8:	7402                	ld	s0,32(sp)
    80003aaa:	64e2                	ld	s1,24(sp)
    80003aac:	6942                	ld	s2,16(sp)
    80003aae:	69a2                	ld	s3,8(sp)
    80003ab0:	6145                	addi	sp,sp,48
    80003ab2:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003ab4:	0284a983          	lw	s3,40(s1)
    80003ab8:	ffffd097          	auipc	ra,0xffffd
    80003abc:	47e080e7          	jalr	1150(ra) # 80000f36 <myproc>
    80003ac0:	5d04                	lw	s1,56(a0)
    80003ac2:	413484b3          	sub	s1,s1,s3
    80003ac6:	0014b493          	seqz	s1,s1
    80003aca:	bfc1                	j	80003a9a <holdingsleep+0x24>

0000000080003acc <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003acc:	1141                	addi	sp,sp,-16
    80003ace:	e406                	sd	ra,8(sp)
    80003ad0:	e022                	sd	s0,0(sp)
    80003ad2:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003ad4:	00005597          	auipc	a1,0x5
    80003ad8:	bec58593          	addi	a1,a1,-1044 # 800086c0 <syscalls+0x298>
    80003adc:	00016517          	auipc	a0,0x16
    80003ae0:	88c50513          	addi	a0,a0,-1908 # 80019368 <ftable>
    80003ae4:	00002097          	auipc	ra,0x2
    80003ae8:	764080e7          	jalr	1892(ra) # 80006248 <initlock>
}
    80003aec:	60a2                	ld	ra,8(sp)
    80003aee:	6402                	ld	s0,0(sp)
    80003af0:	0141                	addi	sp,sp,16
    80003af2:	8082                	ret

0000000080003af4 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003af4:	1101                	addi	sp,sp,-32
    80003af6:	ec06                	sd	ra,24(sp)
    80003af8:	e822                	sd	s0,16(sp)
    80003afa:	e426                	sd	s1,8(sp)
    80003afc:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003afe:	00016517          	auipc	a0,0x16
    80003b02:	86a50513          	addi	a0,a0,-1942 # 80019368 <ftable>
    80003b06:	00002097          	auipc	ra,0x2
    80003b0a:	7d2080e7          	jalr	2002(ra) # 800062d8 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b0e:	00016497          	auipc	s1,0x16
    80003b12:	87248493          	addi	s1,s1,-1934 # 80019380 <ftable+0x18>
    80003b16:	00017717          	auipc	a4,0x17
    80003b1a:	80a70713          	addi	a4,a4,-2038 # 8001a320 <ftable+0xfb8>
    if(f->ref == 0){
    80003b1e:	40dc                	lw	a5,4(s1)
    80003b20:	cf99                	beqz	a5,80003b3e <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b22:	02848493          	addi	s1,s1,40
    80003b26:	fee49ce3          	bne	s1,a4,80003b1e <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003b2a:	00016517          	auipc	a0,0x16
    80003b2e:	83e50513          	addi	a0,a0,-1986 # 80019368 <ftable>
    80003b32:	00003097          	auipc	ra,0x3
    80003b36:	85a080e7          	jalr	-1958(ra) # 8000638c <release>
  return 0;
    80003b3a:	4481                	li	s1,0
    80003b3c:	a819                	j	80003b52 <filealloc+0x5e>
      f->ref = 1;
    80003b3e:	4785                	li	a5,1
    80003b40:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003b42:	00016517          	auipc	a0,0x16
    80003b46:	82650513          	addi	a0,a0,-2010 # 80019368 <ftable>
    80003b4a:	00003097          	auipc	ra,0x3
    80003b4e:	842080e7          	jalr	-1982(ra) # 8000638c <release>
}
    80003b52:	8526                	mv	a0,s1
    80003b54:	60e2                	ld	ra,24(sp)
    80003b56:	6442                	ld	s0,16(sp)
    80003b58:	64a2                	ld	s1,8(sp)
    80003b5a:	6105                	addi	sp,sp,32
    80003b5c:	8082                	ret

0000000080003b5e <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003b5e:	1101                	addi	sp,sp,-32
    80003b60:	ec06                	sd	ra,24(sp)
    80003b62:	e822                	sd	s0,16(sp)
    80003b64:	e426                	sd	s1,8(sp)
    80003b66:	1000                	addi	s0,sp,32
    80003b68:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003b6a:	00015517          	auipc	a0,0x15
    80003b6e:	7fe50513          	addi	a0,a0,2046 # 80019368 <ftable>
    80003b72:	00002097          	auipc	ra,0x2
    80003b76:	766080e7          	jalr	1894(ra) # 800062d8 <acquire>
  if(f->ref < 1)
    80003b7a:	40dc                	lw	a5,4(s1)
    80003b7c:	02f05263          	blez	a5,80003ba0 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003b80:	2785                	addiw	a5,a5,1
    80003b82:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003b84:	00015517          	auipc	a0,0x15
    80003b88:	7e450513          	addi	a0,a0,2020 # 80019368 <ftable>
    80003b8c:	00003097          	auipc	ra,0x3
    80003b90:	800080e7          	jalr	-2048(ra) # 8000638c <release>
  return f;
}
    80003b94:	8526                	mv	a0,s1
    80003b96:	60e2                	ld	ra,24(sp)
    80003b98:	6442                	ld	s0,16(sp)
    80003b9a:	64a2                	ld	s1,8(sp)
    80003b9c:	6105                	addi	sp,sp,32
    80003b9e:	8082                	ret
    panic("filedup");
    80003ba0:	00005517          	auipc	a0,0x5
    80003ba4:	b2850513          	addi	a0,a0,-1240 # 800086c8 <syscalls+0x2a0>
    80003ba8:	00002097          	auipc	ra,0x2
    80003bac:	1f8080e7          	jalr	504(ra) # 80005da0 <panic>

0000000080003bb0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003bb0:	7139                	addi	sp,sp,-64
    80003bb2:	fc06                	sd	ra,56(sp)
    80003bb4:	f822                	sd	s0,48(sp)
    80003bb6:	f426                	sd	s1,40(sp)
    80003bb8:	f04a                	sd	s2,32(sp)
    80003bba:	ec4e                	sd	s3,24(sp)
    80003bbc:	e852                	sd	s4,16(sp)
    80003bbe:	e456                	sd	s5,8(sp)
    80003bc0:	0080                	addi	s0,sp,64
    80003bc2:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003bc4:	00015517          	auipc	a0,0x15
    80003bc8:	7a450513          	addi	a0,a0,1956 # 80019368 <ftable>
    80003bcc:	00002097          	auipc	ra,0x2
    80003bd0:	70c080e7          	jalr	1804(ra) # 800062d8 <acquire>
  if(f->ref < 1)
    80003bd4:	40dc                	lw	a5,4(s1)
    80003bd6:	06f05163          	blez	a5,80003c38 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003bda:	37fd                	addiw	a5,a5,-1
    80003bdc:	0007871b          	sext.w	a4,a5
    80003be0:	c0dc                	sw	a5,4(s1)
    80003be2:	06e04363          	bgtz	a4,80003c48 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003be6:	0004a903          	lw	s2,0(s1)
    80003bea:	0094ca83          	lbu	s5,9(s1)
    80003bee:	0104ba03          	ld	s4,16(s1)
    80003bf2:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003bf6:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003bfa:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003bfe:	00015517          	auipc	a0,0x15
    80003c02:	76a50513          	addi	a0,a0,1898 # 80019368 <ftable>
    80003c06:	00002097          	auipc	ra,0x2
    80003c0a:	786080e7          	jalr	1926(ra) # 8000638c <release>

  if(ff.type == FD_PIPE){
    80003c0e:	4785                	li	a5,1
    80003c10:	04f90d63          	beq	s2,a5,80003c6a <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003c14:	3979                	addiw	s2,s2,-2
    80003c16:	4785                	li	a5,1
    80003c18:	0527e063          	bltu	a5,s2,80003c58 <fileclose+0xa8>
    begin_op();
    80003c1c:	00000097          	auipc	ra,0x0
    80003c20:	acc080e7          	jalr	-1332(ra) # 800036e8 <begin_op>
    iput(ff.ip);
    80003c24:	854e                	mv	a0,s3
    80003c26:	fffff097          	auipc	ra,0xfffff
    80003c2a:	2a0080e7          	jalr	672(ra) # 80002ec6 <iput>
    end_op();
    80003c2e:	00000097          	auipc	ra,0x0
    80003c32:	b38080e7          	jalr	-1224(ra) # 80003766 <end_op>
    80003c36:	a00d                	j	80003c58 <fileclose+0xa8>
    panic("fileclose");
    80003c38:	00005517          	auipc	a0,0x5
    80003c3c:	a9850513          	addi	a0,a0,-1384 # 800086d0 <syscalls+0x2a8>
    80003c40:	00002097          	auipc	ra,0x2
    80003c44:	160080e7          	jalr	352(ra) # 80005da0 <panic>
    release(&ftable.lock);
    80003c48:	00015517          	auipc	a0,0x15
    80003c4c:	72050513          	addi	a0,a0,1824 # 80019368 <ftable>
    80003c50:	00002097          	auipc	ra,0x2
    80003c54:	73c080e7          	jalr	1852(ra) # 8000638c <release>
  }
}
    80003c58:	70e2                	ld	ra,56(sp)
    80003c5a:	7442                	ld	s0,48(sp)
    80003c5c:	74a2                	ld	s1,40(sp)
    80003c5e:	7902                	ld	s2,32(sp)
    80003c60:	69e2                	ld	s3,24(sp)
    80003c62:	6a42                	ld	s4,16(sp)
    80003c64:	6aa2                	ld	s5,8(sp)
    80003c66:	6121                	addi	sp,sp,64
    80003c68:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003c6a:	85d6                	mv	a1,s5
    80003c6c:	8552                	mv	a0,s4
    80003c6e:	00000097          	auipc	ra,0x0
    80003c72:	34c080e7          	jalr	844(ra) # 80003fba <pipeclose>
    80003c76:	b7cd                	j	80003c58 <fileclose+0xa8>

0000000080003c78 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003c78:	715d                	addi	sp,sp,-80
    80003c7a:	e486                	sd	ra,72(sp)
    80003c7c:	e0a2                	sd	s0,64(sp)
    80003c7e:	fc26                	sd	s1,56(sp)
    80003c80:	f84a                	sd	s2,48(sp)
    80003c82:	f44e                	sd	s3,40(sp)
    80003c84:	0880                	addi	s0,sp,80
    80003c86:	84aa                	mv	s1,a0
    80003c88:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003c8a:	ffffd097          	auipc	ra,0xffffd
    80003c8e:	2ac080e7          	jalr	684(ra) # 80000f36 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003c92:	409c                	lw	a5,0(s1)
    80003c94:	37f9                	addiw	a5,a5,-2
    80003c96:	4705                	li	a4,1
    80003c98:	04f76763          	bltu	a4,a5,80003ce6 <filestat+0x6e>
    80003c9c:	892a                	mv	s2,a0
    ilock(f->ip);
    80003c9e:	6c88                	ld	a0,24(s1)
    80003ca0:	fffff097          	auipc	ra,0xfffff
    80003ca4:	06c080e7          	jalr	108(ra) # 80002d0c <ilock>
    stati(f->ip, &st);
    80003ca8:	fb840593          	addi	a1,s0,-72
    80003cac:	6c88                	ld	a0,24(s1)
    80003cae:	fffff097          	auipc	ra,0xfffff
    80003cb2:	2e8080e7          	jalr	744(ra) # 80002f96 <stati>
    iunlock(f->ip);
    80003cb6:	6c88                	ld	a0,24(s1)
    80003cb8:	fffff097          	auipc	ra,0xfffff
    80003cbc:	116080e7          	jalr	278(ra) # 80002dce <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003cc0:	46e1                	li	a3,24
    80003cc2:	fb840613          	addi	a2,s0,-72
    80003cc6:	85ce                	mv	a1,s3
    80003cc8:	05893503          	ld	a0,88(s2)
    80003ccc:	ffffd097          	auipc	ra,0xffffd
    80003cd0:	e3c080e7          	jalr	-452(ra) # 80000b08 <copyout>
    80003cd4:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003cd8:	60a6                	ld	ra,72(sp)
    80003cda:	6406                	ld	s0,64(sp)
    80003cdc:	74e2                	ld	s1,56(sp)
    80003cde:	7942                	ld	s2,48(sp)
    80003ce0:	79a2                	ld	s3,40(sp)
    80003ce2:	6161                	addi	sp,sp,80
    80003ce4:	8082                	ret
  return -1;
    80003ce6:	557d                	li	a0,-1
    80003ce8:	bfc5                	j	80003cd8 <filestat+0x60>

0000000080003cea <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003cea:	7179                	addi	sp,sp,-48
    80003cec:	f406                	sd	ra,40(sp)
    80003cee:	f022                	sd	s0,32(sp)
    80003cf0:	ec26                	sd	s1,24(sp)
    80003cf2:	e84a                	sd	s2,16(sp)
    80003cf4:	e44e                	sd	s3,8(sp)
    80003cf6:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003cf8:	00854783          	lbu	a5,8(a0)
    80003cfc:	c3d5                	beqz	a5,80003da0 <fileread+0xb6>
    80003cfe:	84aa                	mv	s1,a0
    80003d00:	89ae                	mv	s3,a1
    80003d02:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d04:	411c                	lw	a5,0(a0)
    80003d06:	4705                	li	a4,1
    80003d08:	04e78963          	beq	a5,a4,80003d5a <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d0c:	470d                	li	a4,3
    80003d0e:	04e78d63          	beq	a5,a4,80003d68 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d12:	4709                	li	a4,2
    80003d14:	06e79e63          	bne	a5,a4,80003d90 <fileread+0xa6>
    ilock(f->ip);
    80003d18:	6d08                	ld	a0,24(a0)
    80003d1a:	fffff097          	auipc	ra,0xfffff
    80003d1e:	ff2080e7          	jalr	-14(ra) # 80002d0c <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003d22:	874a                	mv	a4,s2
    80003d24:	5094                	lw	a3,32(s1)
    80003d26:	864e                	mv	a2,s3
    80003d28:	4585                	li	a1,1
    80003d2a:	6c88                	ld	a0,24(s1)
    80003d2c:	fffff097          	auipc	ra,0xfffff
    80003d30:	294080e7          	jalr	660(ra) # 80002fc0 <readi>
    80003d34:	892a                	mv	s2,a0
    80003d36:	00a05563          	blez	a0,80003d40 <fileread+0x56>
      f->off += r;
    80003d3a:	509c                	lw	a5,32(s1)
    80003d3c:	9fa9                	addw	a5,a5,a0
    80003d3e:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003d40:	6c88                	ld	a0,24(s1)
    80003d42:	fffff097          	auipc	ra,0xfffff
    80003d46:	08c080e7          	jalr	140(ra) # 80002dce <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003d4a:	854a                	mv	a0,s2
    80003d4c:	70a2                	ld	ra,40(sp)
    80003d4e:	7402                	ld	s0,32(sp)
    80003d50:	64e2                	ld	s1,24(sp)
    80003d52:	6942                	ld	s2,16(sp)
    80003d54:	69a2                	ld	s3,8(sp)
    80003d56:	6145                	addi	sp,sp,48
    80003d58:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003d5a:	6908                	ld	a0,16(a0)
    80003d5c:	00000097          	auipc	ra,0x0
    80003d60:	3c0080e7          	jalr	960(ra) # 8000411c <piperead>
    80003d64:	892a                	mv	s2,a0
    80003d66:	b7d5                	j	80003d4a <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003d68:	02451783          	lh	a5,36(a0)
    80003d6c:	03079693          	slli	a3,a5,0x30
    80003d70:	92c1                	srli	a3,a3,0x30
    80003d72:	4725                	li	a4,9
    80003d74:	02d76863          	bltu	a4,a3,80003da4 <fileread+0xba>
    80003d78:	0792                	slli	a5,a5,0x4
    80003d7a:	00015717          	auipc	a4,0x15
    80003d7e:	54e70713          	addi	a4,a4,1358 # 800192c8 <devsw>
    80003d82:	97ba                	add	a5,a5,a4
    80003d84:	639c                	ld	a5,0(a5)
    80003d86:	c38d                	beqz	a5,80003da8 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003d88:	4505                	li	a0,1
    80003d8a:	9782                	jalr	a5
    80003d8c:	892a                	mv	s2,a0
    80003d8e:	bf75                	j	80003d4a <fileread+0x60>
    panic("fileread");
    80003d90:	00005517          	auipc	a0,0x5
    80003d94:	95050513          	addi	a0,a0,-1712 # 800086e0 <syscalls+0x2b8>
    80003d98:	00002097          	auipc	ra,0x2
    80003d9c:	008080e7          	jalr	8(ra) # 80005da0 <panic>
    return -1;
    80003da0:	597d                	li	s2,-1
    80003da2:	b765                	j	80003d4a <fileread+0x60>
      return -1;
    80003da4:	597d                	li	s2,-1
    80003da6:	b755                	j	80003d4a <fileread+0x60>
    80003da8:	597d                	li	s2,-1
    80003daa:	b745                	j	80003d4a <fileread+0x60>

0000000080003dac <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003dac:	715d                	addi	sp,sp,-80
    80003dae:	e486                	sd	ra,72(sp)
    80003db0:	e0a2                	sd	s0,64(sp)
    80003db2:	fc26                	sd	s1,56(sp)
    80003db4:	f84a                	sd	s2,48(sp)
    80003db6:	f44e                	sd	s3,40(sp)
    80003db8:	f052                	sd	s4,32(sp)
    80003dba:	ec56                	sd	s5,24(sp)
    80003dbc:	e85a                	sd	s6,16(sp)
    80003dbe:	e45e                	sd	s7,8(sp)
    80003dc0:	e062                	sd	s8,0(sp)
    80003dc2:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003dc4:	00954783          	lbu	a5,9(a0)
    80003dc8:	10078663          	beqz	a5,80003ed4 <filewrite+0x128>
    80003dcc:	892a                	mv	s2,a0
    80003dce:	8b2e                	mv	s6,a1
    80003dd0:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003dd2:	411c                	lw	a5,0(a0)
    80003dd4:	4705                	li	a4,1
    80003dd6:	02e78263          	beq	a5,a4,80003dfa <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003dda:	470d                	li	a4,3
    80003ddc:	02e78663          	beq	a5,a4,80003e08 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003de0:	4709                	li	a4,2
    80003de2:	0ee79163          	bne	a5,a4,80003ec4 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003de6:	0ac05d63          	blez	a2,80003ea0 <filewrite+0xf4>
    int i = 0;
    80003dea:	4981                	li	s3,0
    80003dec:	6b85                	lui	s7,0x1
    80003dee:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003df2:	6c05                	lui	s8,0x1
    80003df4:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003df8:	a861                	j	80003e90 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003dfa:	6908                	ld	a0,16(a0)
    80003dfc:	00000097          	auipc	ra,0x0
    80003e00:	22e080e7          	jalr	558(ra) # 8000402a <pipewrite>
    80003e04:	8a2a                	mv	s4,a0
    80003e06:	a045                	j	80003ea6 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003e08:	02451783          	lh	a5,36(a0)
    80003e0c:	03079693          	slli	a3,a5,0x30
    80003e10:	92c1                	srli	a3,a3,0x30
    80003e12:	4725                	li	a4,9
    80003e14:	0cd76263          	bltu	a4,a3,80003ed8 <filewrite+0x12c>
    80003e18:	0792                	slli	a5,a5,0x4
    80003e1a:	00015717          	auipc	a4,0x15
    80003e1e:	4ae70713          	addi	a4,a4,1198 # 800192c8 <devsw>
    80003e22:	97ba                	add	a5,a5,a4
    80003e24:	679c                	ld	a5,8(a5)
    80003e26:	cbdd                	beqz	a5,80003edc <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003e28:	4505                	li	a0,1
    80003e2a:	9782                	jalr	a5
    80003e2c:	8a2a                	mv	s4,a0
    80003e2e:	a8a5                	j	80003ea6 <filewrite+0xfa>
    80003e30:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003e34:	00000097          	auipc	ra,0x0
    80003e38:	8b4080e7          	jalr	-1868(ra) # 800036e8 <begin_op>
      ilock(f->ip);
    80003e3c:	01893503          	ld	a0,24(s2)
    80003e40:	fffff097          	auipc	ra,0xfffff
    80003e44:	ecc080e7          	jalr	-308(ra) # 80002d0c <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003e48:	8756                	mv	a4,s5
    80003e4a:	02092683          	lw	a3,32(s2)
    80003e4e:	01698633          	add	a2,s3,s6
    80003e52:	4585                	li	a1,1
    80003e54:	01893503          	ld	a0,24(s2)
    80003e58:	fffff097          	auipc	ra,0xfffff
    80003e5c:	260080e7          	jalr	608(ra) # 800030b8 <writei>
    80003e60:	84aa                	mv	s1,a0
    80003e62:	00a05763          	blez	a0,80003e70 <filewrite+0xc4>
        f->off += r;
    80003e66:	02092783          	lw	a5,32(s2)
    80003e6a:	9fa9                	addw	a5,a5,a0
    80003e6c:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003e70:	01893503          	ld	a0,24(s2)
    80003e74:	fffff097          	auipc	ra,0xfffff
    80003e78:	f5a080e7          	jalr	-166(ra) # 80002dce <iunlock>
      end_op();
    80003e7c:	00000097          	auipc	ra,0x0
    80003e80:	8ea080e7          	jalr	-1814(ra) # 80003766 <end_op>

      if(r != n1){
    80003e84:	009a9f63          	bne	s5,s1,80003ea2 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003e88:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003e8c:	0149db63          	bge	s3,s4,80003ea2 <filewrite+0xf6>
      int n1 = n - i;
    80003e90:	413a04bb          	subw	s1,s4,s3
    80003e94:	0004879b          	sext.w	a5,s1
    80003e98:	f8fbdce3          	bge	s7,a5,80003e30 <filewrite+0x84>
    80003e9c:	84e2                	mv	s1,s8
    80003e9e:	bf49                	j	80003e30 <filewrite+0x84>
    int i = 0;
    80003ea0:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003ea2:	013a1f63          	bne	s4,s3,80003ec0 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003ea6:	8552                	mv	a0,s4
    80003ea8:	60a6                	ld	ra,72(sp)
    80003eaa:	6406                	ld	s0,64(sp)
    80003eac:	74e2                	ld	s1,56(sp)
    80003eae:	7942                	ld	s2,48(sp)
    80003eb0:	79a2                	ld	s3,40(sp)
    80003eb2:	7a02                	ld	s4,32(sp)
    80003eb4:	6ae2                	ld	s5,24(sp)
    80003eb6:	6b42                	ld	s6,16(sp)
    80003eb8:	6ba2                	ld	s7,8(sp)
    80003eba:	6c02                	ld	s8,0(sp)
    80003ebc:	6161                	addi	sp,sp,80
    80003ebe:	8082                	ret
    ret = (i == n ? n : -1);
    80003ec0:	5a7d                	li	s4,-1
    80003ec2:	b7d5                	j	80003ea6 <filewrite+0xfa>
    panic("filewrite");
    80003ec4:	00005517          	auipc	a0,0x5
    80003ec8:	82c50513          	addi	a0,a0,-2004 # 800086f0 <syscalls+0x2c8>
    80003ecc:	00002097          	auipc	ra,0x2
    80003ed0:	ed4080e7          	jalr	-300(ra) # 80005da0 <panic>
    return -1;
    80003ed4:	5a7d                	li	s4,-1
    80003ed6:	bfc1                	j	80003ea6 <filewrite+0xfa>
      return -1;
    80003ed8:	5a7d                	li	s4,-1
    80003eda:	b7f1                	j	80003ea6 <filewrite+0xfa>
    80003edc:	5a7d                	li	s4,-1
    80003ede:	b7e1                	j	80003ea6 <filewrite+0xfa>

0000000080003ee0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003ee0:	7179                	addi	sp,sp,-48
    80003ee2:	f406                	sd	ra,40(sp)
    80003ee4:	f022                	sd	s0,32(sp)
    80003ee6:	ec26                	sd	s1,24(sp)
    80003ee8:	e84a                	sd	s2,16(sp)
    80003eea:	e44e                	sd	s3,8(sp)
    80003eec:	e052                	sd	s4,0(sp)
    80003eee:	1800                	addi	s0,sp,48
    80003ef0:	84aa                	mv	s1,a0
    80003ef2:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003ef4:	0005b023          	sd	zero,0(a1)
    80003ef8:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003efc:	00000097          	auipc	ra,0x0
    80003f00:	bf8080e7          	jalr	-1032(ra) # 80003af4 <filealloc>
    80003f04:	e088                	sd	a0,0(s1)
    80003f06:	c551                	beqz	a0,80003f92 <pipealloc+0xb2>
    80003f08:	00000097          	auipc	ra,0x0
    80003f0c:	bec080e7          	jalr	-1044(ra) # 80003af4 <filealloc>
    80003f10:	00aa3023          	sd	a0,0(s4)
    80003f14:	c92d                	beqz	a0,80003f86 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003f16:	ffffc097          	auipc	ra,0xffffc
    80003f1a:	204080e7          	jalr	516(ra) # 8000011a <kalloc>
    80003f1e:	892a                	mv	s2,a0
    80003f20:	c125                	beqz	a0,80003f80 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003f22:	4985                	li	s3,1
    80003f24:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003f28:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003f2c:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003f30:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003f34:	00004597          	auipc	a1,0x4
    80003f38:	7cc58593          	addi	a1,a1,1996 # 80008700 <syscalls+0x2d8>
    80003f3c:	00002097          	auipc	ra,0x2
    80003f40:	30c080e7          	jalr	780(ra) # 80006248 <initlock>
  (*f0)->type = FD_PIPE;
    80003f44:	609c                	ld	a5,0(s1)
    80003f46:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003f4a:	609c                	ld	a5,0(s1)
    80003f4c:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003f50:	609c                	ld	a5,0(s1)
    80003f52:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003f56:	609c                	ld	a5,0(s1)
    80003f58:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003f5c:	000a3783          	ld	a5,0(s4)
    80003f60:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003f64:	000a3783          	ld	a5,0(s4)
    80003f68:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003f6c:	000a3783          	ld	a5,0(s4)
    80003f70:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003f74:	000a3783          	ld	a5,0(s4)
    80003f78:	0127b823          	sd	s2,16(a5)
  return 0;
    80003f7c:	4501                	li	a0,0
    80003f7e:	a025                	j	80003fa6 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003f80:	6088                	ld	a0,0(s1)
    80003f82:	e501                	bnez	a0,80003f8a <pipealloc+0xaa>
    80003f84:	a039                	j	80003f92 <pipealloc+0xb2>
    80003f86:	6088                	ld	a0,0(s1)
    80003f88:	c51d                	beqz	a0,80003fb6 <pipealloc+0xd6>
    fileclose(*f0);
    80003f8a:	00000097          	auipc	ra,0x0
    80003f8e:	c26080e7          	jalr	-986(ra) # 80003bb0 <fileclose>
  if(*f1)
    80003f92:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003f96:	557d                	li	a0,-1
  if(*f1)
    80003f98:	c799                	beqz	a5,80003fa6 <pipealloc+0xc6>
    fileclose(*f1);
    80003f9a:	853e                	mv	a0,a5
    80003f9c:	00000097          	auipc	ra,0x0
    80003fa0:	c14080e7          	jalr	-1004(ra) # 80003bb0 <fileclose>
  return -1;
    80003fa4:	557d                	li	a0,-1
}
    80003fa6:	70a2                	ld	ra,40(sp)
    80003fa8:	7402                	ld	s0,32(sp)
    80003faa:	64e2                	ld	s1,24(sp)
    80003fac:	6942                	ld	s2,16(sp)
    80003fae:	69a2                	ld	s3,8(sp)
    80003fb0:	6a02                	ld	s4,0(sp)
    80003fb2:	6145                	addi	sp,sp,48
    80003fb4:	8082                	ret
  return -1;
    80003fb6:	557d                	li	a0,-1
    80003fb8:	b7fd                	j	80003fa6 <pipealloc+0xc6>

0000000080003fba <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003fba:	1101                	addi	sp,sp,-32
    80003fbc:	ec06                	sd	ra,24(sp)
    80003fbe:	e822                	sd	s0,16(sp)
    80003fc0:	e426                	sd	s1,8(sp)
    80003fc2:	e04a                	sd	s2,0(sp)
    80003fc4:	1000                	addi	s0,sp,32
    80003fc6:	84aa                	mv	s1,a0
    80003fc8:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003fca:	00002097          	auipc	ra,0x2
    80003fce:	30e080e7          	jalr	782(ra) # 800062d8 <acquire>
  if(writable){
    80003fd2:	02090d63          	beqz	s2,8000400c <pipeclose+0x52>
    pi->writeopen = 0;
    80003fd6:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003fda:	21848513          	addi	a0,s1,536
    80003fde:	ffffe097          	auipc	ra,0xffffe
    80003fe2:	858080e7          	jalr	-1960(ra) # 80001836 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003fe6:	2204b783          	ld	a5,544(s1)
    80003fea:	eb95                	bnez	a5,8000401e <pipeclose+0x64>
    release(&pi->lock);
    80003fec:	8526                	mv	a0,s1
    80003fee:	00002097          	auipc	ra,0x2
    80003ff2:	39e080e7          	jalr	926(ra) # 8000638c <release>
    kfree((char*)pi);
    80003ff6:	8526                	mv	a0,s1
    80003ff8:	ffffc097          	auipc	ra,0xffffc
    80003ffc:	024080e7          	jalr	36(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80004000:	60e2                	ld	ra,24(sp)
    80004002:	6442                	ld	s0,16(sp)
    80004004:	64a2                	ld	s1,8(sp)
    80004006:	6902                	ld	s2,0(sp)
    80004008:	6105                	addi	sp,sp,32
    8000400a:	8082                	ret
    pi->readopen = 0;
    8000400c:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004010:	21c48513          	addi	a0,s1,540
    80004014:	ffffe097          	auipc	ra,0xffffe
    80004018:	822080e7          	jalr	-2014(ra) # 80001836 <wakeup>
    8000401c:	b7e9                	j	80003fe6 <pipeclose+0x2c>
    release(&pi->lock);
    8000401e:	8526                	mv	a0,s1
    80004020:	00002097          	auipc	ra,0x2
    80004024:	36c080e7          	jalr	876(ra) # 8000638c <release>
}
    80004028:	bfe1                	j	80004000 <pipeclose+0x46>

000000008000402a <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    8000402a:	711d                	addi	sp,sp,-96
    8000402c:	ec86                	sd	ra,88(sp)
    8000402e:	e8a2                	sd	s0,80(sp)
    80004030:	e4a6                	sd	s1,72(sp)
    80004032:	e0ca                	sd	s2,64(sp)
    80004034:	fc4e                	sd	s3,56(sp)
    80004036:	f852                	sd	s4,48(sp)
    80004038:	f456                	sd	s5,40(sp)
    8000403a:	f05a                	sd	s6,32(sp)
    8000403c:	ec5e                	sd	s7,24(sp)
    8000403e:	e862                	sd	s8,16(sp)
    80004040:	1080                	addi	s0,sp,96
    80004042:	84aa                	mv	s1,a0
    80004044:	8aae                	mv	s5,a1
    80004046:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004048:	ffffd097          	auipc	ra,0xffffd
    8000404c:	eee080e7          	jalr	-274(ra) # 80000f36 <myproc>
    80004050:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004052:	8526                	mv	a0,s1
    80004054:	00002097          	auipc	ra,0x2
    80004058:	284080e7          	jalr	644(ra) # 800062d8 <acquire>
  while(i < n){
    8000405c:	0b405363          	blez	s4,80004102 <pipewrite+0xd8>
  int i = 0;
    80004060:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004062:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004064:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004068:	21c48b93          	addi	s7,s1,540
    8000406c:	a089                	j	800040ae <pipewrite+0x84>
      release(&pi->lock);
    8000406e:	8526                	mv	a0,s1
    80004070:	00002097          	auipc	ra,0x2
    80004074:	31c080e7          	jalr	796(ra) # 8000638c <release>
      return -1;
    80004078:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000407a:	854a                	mv	a0,s2
    8000407c:	60e6                	ld	ra,88(sp)
    8000407e:	6446                	ld	s0,80(sp)
    80004080:	64a6                	ld	s1,72(sp)
    80004082:	6906                	ld	s2,64(sp)
    80004084:	79e2                	ld	s3,56(sp)
    80004086:	7a42                	ld	s4,48(sp)
    80004088:	7aa2                	ld	s5,40(sp)
    8000408a:	7b02                	ld	s6,32(sp)
    8000408c:	6be2                	ld	s7,24(sp)
    8000408e:	6c42                	ld	s8,16(sp)
    80004090:	6125                	addi	sp,sp,96
    80004092:	8082                	ret
      wakeup(&pi->nread);
    80004094:	8562                	mv	a0,s8
    80004096:	ffffd097          	auipc	ra,0xffffd
    8000409a:	7a0080e7          	jalr	1952(ra) # 80001836 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000409e:	85a6                	mv	a1,s1
    800040a0:	855e                	mv	a0,s7
    800040a2:	ffffd097          	auipc	ra,0xffffd
    800040a6:	608080e7          	jalr	1544(ra) # 800016aa <sleep>
  while(i < n){
    800040aa:	05495d63          	bge	s2,s4,80004104 <pipewrite+0xda>
    if(pi->readopen == 0 || pr->killed){
    800040ae:	2204a783          	lw	a5,544(s1)
    800040b2:	dfd5                	beqz	a5,8000406e <pipewrite+0x44>
    800040b4:	0309a783          	lw	a5,48(s3)
    800040b8:	fbdd                	bnez	a5,8000406e <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800040ba:	2184a783          	lw	a5,536(s1)
    800040be:	21c4a703          	lw	a4,540(s1)
    800040c2:	2007879b          	addiw	a5,a5,512
    800040c6:	fcf707e3          	beq	a4,a5,80004094 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800040ca:	4685                	li	a3,1
    800040cc:	01590633          	add	a2,s2,s5
    800040d0:	faf40593          	addi	a1,s0,-81
    800040d4:	0589b503          	ld	a0,88(s3)
    800040d8:	ffffd097          	auipc	ra,0xffffd
    800040dc:	abc080e7          	jalr	-1348(ra) # 80000b94 <copyin>
    800040e0:	03650263          	beq	a0,s6,80004104 <pipewrite+0xda>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800040e4:	21c4a783          	lw	a5,540(s1)
    800040e8:	0017871b          	addiw	a4,a5,1
    800040ec:	20e4ae23          	sw	a4,540(s1)
    800040f0:	1ff7f793          	andi	a5,a5,511
    800040f4:	97a6                	add	a5,a5,s1
    800040f6:	faf44703          	lbu	a4,-81(s0)
    800040fa:	00e78c23          	sb	a4,24(a5)
      i++;
    800040fe:	2905                	addiw	s2,s2,1
    80004100:	b76d                	j	800040aa <pipewrite+0x80>
  int i = 0;
    80004102:	4901                	li	s2,0
  wakeup(&pi->nread);
    80004104:	21848513          	addi	a0,s1,536
    80004108:	ffffd097          	auipc	ra,0xffffd
    8000410c:	72e080e7          	jalr	1838(ra) # 80001836 <wakeup>
  release(&pi->lock);
    80004110:	8526                	mv	a0,s1
    80004112:	00002097          	auipc	ra,0x2
    80004116:	27a080e7          	jalr	634(ra) # 8000638c <release>
  return i;
    8000411a:	b785                	j	8000407a <pipewrite+0x50>

000000008000411c <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000411c:	715d                	addi	sp,sp,-80
    8000411e:	e486                	sd	ra,72(sp)
    80004120:	e0a2                	sd	s0,64(sp)
    80004122:	fc26                	sd	s1,56(sp)
    80004124:	f84a                	sd	s2,48(sp)
    80004126:	f44e                	sd	s3,40(sp)
    80004128:	f052                	sd	s4,32(sp)
    8000412a:	ec56                	sd	s5,24(sp)
    8000412c:	e85a                	sd	s6,16(sp)
    8000412e:	0880                	addi	s0,sp,80
    80004130:	84aa                	mv	s1,a0
    80004132:	892e                	mv	s2,a1
    80004134:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004136:	ffffd097          	auipc	ra,0xffffd
    8000413a:	e00080e7          	jalr	-512(ra) # 80000f36 <myproc>
    8000413e:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004140:	8526                	mv	a0,s1
    80004142:	00002097          	auipc	ra,0x2
    80004146:	196080e7          	jalr	406(ra) # 800062d8 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000414a:	2184a703          	lw	a4,536(s1)
    8000414e:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004152:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004156:	02f71463          	bne	a4,a5,8000417e <piperead+0x62>
    8000415a:	2244a783          	lw	a5,548(s1)
    8000415e:	c385                	beqz	a5,8000417e <piperead+0x62>
    if(pr->killed){
    80004160:	030a2783          	lw	a5,48(s4)
    80004164:	ebc9                	bnez	a5,800041f6 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004166:	85a6                	mv	a1,s1
    80004168:	854e                	mv	a0,s3
    8000416a:	ffffd097          	auipc	ra,0xffffd
    8000416e:	540080e7          	jalr	1344(ra) # 800016aa <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004172:	2184a703          	lw	a4,536(s1)
    80004176:	21c4a783          	lw	a5,540(s1)
    8000417a:	fef700e3          	beq	a4,a5,8000415a <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000417e:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004180:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004182:	05505463          	blez	s5,800041ca <piperead+0xae>
    if(pi->nread == pi->nwrite)
    80004186:	2184a783          	lw	a5,536(s1)
    8000418a:	21c4a703          	lw	a4,540(s1)
    8000418e:	02f70e63          	beq	a4,a5,800041ca <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004192:	0017871b          	addiw	a4,a5,1
    80004196:	20e4ac23          	sw	a4,536(s1)
    8000419a:	1ff7f793          	andi	a5,a5,511
    8000419e:	97a6                	add	a5,a5,s1
    800041a0:	0187c783          	lbu	a5,24(a5)
    800041a4:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800041a8:	4685                	li	a3,1
    800041aa:	fbf40613          	addi	a2,s0,-65
    800041ae:	85ca                	mv	a1,s2
    800041b0:	058a3503          	ld	a0,88(s4)
    800041b4:	ffffd097          	auipc	ra,0xffffd
    800041b8:	954080e7          	jalr	-1708(ra) # 80000b08 <copyout>
    800041bc:	01650763          	beq	a0,s6,800041ca <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041c0:	2985                	addiw	s3,s3,1
    800041c2:	0905                	addi	s2,s2,1
    800041c4:	fd3a91e3          	bne	s5,s3,80004186 <piperead+0x6a>
    800041c8:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800041ca:	21c48513          	addi	a0,s1,540
    800041ce:	ffffd097          	auipc	ra,0xffffd
    800041d2:	668080e7          	jalr	1640(ra) # 80001836 <wakeup>
  release(&pi->lock);
    800041d6:	8526                	mv	a0,s1
    800041d8:	00002097          	auipc	ra,0x2
    800041dc:	1b4080e7          	jalr	436(ra) # 8000638c <release>
  return i;
}
    800041e0:	854e                	mv	a0,s3
    800041e2:	60a6                	ld	ra,72(sp)
    800041e4:	6406                	ld	s0,64(sp)
    800041e6:	74e2                	ld	s1,56(sp)
    800041e8:	7942                	ld	s2,48(sp)
    800041ea:	79a2                	ld	s3,40(sp)
    800041ec:	7a02                	ld	s4,32(sp)
    800041ee:	6ae2                	ld	s5,24(sp)
    800041f0:	6b42                	ld	s6,16(sp)
    800041f2:	6161                	addi	sp,sp,80
    800041f4:	8082                	ret
      release(&pi->lock);
    800041f6:	8526                	mv	a0,s1
    800041f8:	00002097          	auipc	ra,0x2
    800041fc:	194080e7          	jalr	404(ra) # 8000638c <release>
      return -1;
    80004200:	59fd                	li	s3,-1
    80004202:	bff9                	j	800041e0 <piperead+0xc4>

0000000080004204 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004204:	de010113          	addi	sp,sp,-544
    80004208:	20113c23          	sd	ra,536(sp)
    8000420c:	20813823          	sd	s0,528(sp)
    80004210:	20913423          	sd	s1,520(sp)
    80004214:	21213023          	sd	s2,512(sp)
    80004218:	ffce                	sd	s3,504(sp)
    8000421a:	fbd2                	sd	s4,496(sp)
    8000421c:	f7d6                	sd	s5,488(sp)
    8000421e:	f3da                	sd	s6,480(sp)
    80004220:	efde                	sd	s7,472(sp)
    80004222:	ebe2                	sd	s8,464(sp)
    80004224:	e7e6                	sd	s9,456(sp)
    80004226:	e3ea                	sd	s10,448(sp)
    80004228:	ff6e                	sd	s11,440(sp)
    8000422a:	1400                	addi	s0,sp,544
    8000422c:	892a                	mv	s2,a0
    8000422e:	dea43423          	sd	a0,-536(s0)
    80004232:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004236:	ffffd097          	auipc	ra,0xffffd
    8000423a:	d00080e7          	jalr	-768(ra) # 80000f36 <myproc>
    8000423e:	84aa                	mv	s1,a0

  begin_op();
    80004240:	fffff097          	auipc	ra,0xfffff
    80004244:	4a8080e7          	jalr	1192(ra) # 800036e8 <begin_op>

  if((ip = namei(path)) == 0){
    80004248:	854a                	mv	a0,s2
    8000424a:	fffff097          	auipc	ra,0xfffff
    8000424e:	27e080e7          	jalr	638(ra) # 800034c8 <namei>
    80004252:	c93d                	beqz	a0,800042c8 <exec+0xc4>
    80004254:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004256:	fffff097          	auipc	ra,0xfffff
    8000425a:	ab6080e7          	jalr	-1354(ra) # 80002d0c <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000425e:	04000713          	li	a4,64
    80004262:	4681                	li	a3,0
    80004264:	e5040613          	addi	a2,s0,-432
    80004268:	4581                	li	a1,0
    8000426a:	8556                	mv	a0,s5
    8000426c:	fffff097          	auipc	ra,0xfffff
    80004270:	d54080e7          	jalr	-684(ra) # 80002fc0 <readi>
    80004274:	04000793          	li	a5,64
    80004278:	00f51a63          	bne	a0,a5,8000428c <exec+0x88>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    8000427c:	e5042703          	lw	a4,-432(s0)
    80004280:	464c47b7          	lui	a5,0x464c4
    80004284:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004288:	04f70663          	beq	a4,a5,800042d4 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000428c:	8556                	mv	a0,s5
    8000428e:	fffff097          	auipc	ra,0xfffff
    80004292:	ce0080e7          	jalr	-800(ra) # 80002f6e <iunlockput>
    end_op();
    80004296:	fffff097          	auipc	ra,0xfffff
    8000429a:	4d0080e7          	jalr	1232(ra) # 80003766 <end_op>
  }
  return -1;
    8000429e:	557d                	li	a0,-1
}
    800042a0:	21813083          	ld	ra,536(sp)
    800042a4:	21013403          	ld	s0,528(sp)
    800042a8:	20813483          	ld	s1,520(sp)
    800042ac:	20013903          	ld	s2,512(sp)
    800042b0:	79fe                	ld	s3,504(sp)
    800042b2:	7a5e                	ld	s4,496(sp)
    800042b4:	7abe                	ld	s5,488(sp)
    800042b6:	7b1e                	ld	s6,480(sp)
    800042b8:	6bfe                	ld	s7,472(sp)
    800042ba:	6c5e                	ld	s8,464(sp)
    800042bc:	6cbe                	ld	s9,456(sp)
    800042be:	6d1e                	ld	s10,448(sp)
    800042c0:	7dfa                	ld	s11,440(sp)
    800042c2:	22010113          	addi	sp,sp,544
    800042c6:	8082                	ret
    end_op();
    800042c8:	fffff097          	auipc	ra,0xfffff
    800042cc:	49e080e7          	jalr	1182(ra) # 80003766 <end_op>
    return -1;
    800042d0:	557d                	li	a0,-1
    800042d2:	b7f9                	j	800042a0 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    800042d4:	8526                	mv	a0,s1
    800042d6:	ffffd097          	auipc	ra,0xffffd
    800042da:	d24080e7          	jalr	-732(ra) # 80000ffa <proc_pagetable>
    800042de:	8b2a                	mv	s6,a0
    800042e0:	d555                	beqz	a0,8000428c <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042e2:	e7042783          	lw	a5,-400(s0)
    800042e6:	e8845703          	lhu	a4,-376(s0)
    800042ea:	c735                	beqz	a4,80004356 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800042ec:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042ee:	e0043423          	sd	zero,-504(s0)
    if((ph.vaddr % PGSIZE) != 0)
    800042f2:	6a05                	lui	s4,0x1
    800042f4:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    800042f8:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    800042fc:	6d85                	lui	s11,0x1
    800042fe:	7d7d                	lui	s10,0xfffff
    80004300:	a4b9                	j	8000454e <exec+0x34a>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004302:	00004517          	auipc	a0,0x4
    80004306:	40650513          	addi	a0,a0,1030 # 80008708 <syscalls+0x2e0>
    8000430a:	00002097          	auipc	ra,0x2
    8000430e:	a96080e7          	jalr	-1386(ra) # 80005da0 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004312:	874a                	mv	a4,s2
    80004314:	009c86bb          	addw	a3,s9,s1
    80004318:	4581                	li	a1,0
    8000431a:	8556                	mv	a0,s5
    8000431c:	fffff097          	auipc	ra,0xfffff
    80004320:	ca4080e7          	jalr	-860(ra) # 80002fc0 <readi>
    80004324:	2501                	sext.w	a0,a0
    80004326:	1ca91463          	bne	s2,a0,800044ee <exec+0x2ea>
  for(i = 0; i < sz; i += PGSIZE){
    8000432a:	009d84bb          	addw	s1,s11,s1
    8000432e:	013d09bb          	addw	s3,s10,s3
    80004332:	1f74fe63          	bgeu	s1,s7,8000452e <exec+0x32a>
    pa = walkaddr(pagetable, va + i);
    80004336:	02049593          	slli	a1,s1,0x20
    8000433a:	9181                	srli	a1,a1,0x20
    8000433c:	95e2                	add	a1,a1,s8
    8000433e:	855a                	mv	a0,s6
    80004340:	ffffc097          	auipc	ra,0xffffc
    80004344:	1c0080e7          	jalr	448(ra) # 80000500 <walkaddr>
    80004348:	862a                	mv	a2,a0
    if(pa == 0)
    8000434a:	dd45                	beqz	a0,80004302 <exec+0xfe>
      n = PGSIZE;
    8000434c:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    8000434e:	fd49f2e3          	bgeu	s3,s4,80004312 <exec+0x10e>
      n = sz - i;
    80004352:	894e                	mv	s2,s3
    80004354:	bf7d                	j	80004312 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004356:	4481                	li	s1,0
  iunlockput(ip);
    80004358:	8556                	mv	a0,s5
    8000435a:	fffff097          	auipc	ra,0xfffff
    8000435e:	c14080e7          	jalr	-1004(ra) # 80002f6e <iunlockput>
  end_op();
    80004362:	fffff097          	auipc	ra,0xfffff
    80004366:	404080e7          	jalr	1028(ra) # 80003766 <end_op>
  p = myproc();
    8000436a:	ffffd097          	auipc	ra,0xffffd
    8000436e:	bcc080e7          	jalr	-1076(ra) # 80000f36 <myproc>
    80004372:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80004374:	05053d03          	ld	s10,80(a0)
  sz = PGROUNDUP(sz);
    80004378:	6785                	lui	a5,0x1
    8000437a:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000437c:	97a6                	add	a5,a5,s1
    8000437e:	777d                	lui	a4,0xfffff
    80004380:	8ff9                	and	a5,a5,a4
    80004382:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004386:	6609                	lui	a2,0x2
    80004388:	963e                	add	a2,a2,a5
    8000438a:	85be                	mv	a1,a5
    8000438c:	855a                	mv	a0,s6
    8000438e:	ffffc097          	auipc	ra,0xffffc
    80004392:	526080e7          	jalr	1318(ra) # 800008b4 <uvmalloc>
    80004396:	8c2a                	mv	s8,a0
  ip = 0;
    80004398:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000439a:	14050a63          	beqz	a0,800044ee <exec+0x2ea>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000439e:	75f9                	lui	a1,0xffffe
    800043a0:	95aa                	add	a1,a1,a0
    800043a2:	855a                	mv	a0,s6
    800043a4:	ffffc097          	auipc	ra,0xffffc
    800043a8:	732080e7          	jalr	1842(ra) # 80000ad6 <uvmclear>
  stackbase = sp - PGSIZE;
    800043ac:	7afd                	lui	s5,0xfffff
    800043ae:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    800043b0:	df043783          	ld	a5,-528(s0)
    800043b4:	6388                	ld	a0,0(a5)
    800043b6:	c925                	beqz	a0,80004426 <exec+0x222>
    800043b8:	e9040993          	addi	s3,s0,-368
    800043bc:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    800043c0:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800043c2:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800043c4:	ffffc097          	auipc	ra,0xffffc
    800043c8:	f32080e7          	jalr	-206(ra) # 800002f6 <strlen>
    800043cc:	0015079b          	addiw	a5,a0,1
    800043d0:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800043d4:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800043d8:	13596f63          	bltu	s2,s5,80004516 <exec+0x312>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800043dc:	df043d83          	ld	s11,-528(s0)
    800043e0:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    800043e4:	8552                	mv	a0,s4
    800043e6:	ffffc097          	auipc	ra,0xffffc
    800043ea:	f10080e7          	jalr	-240(ra) # 800002f6 <strlen>
    800043ee:	0015069b          	addiw	a3,a0,1
    800043f2:	8652                	mv	a2,s4
    800043f4:	85ca                	mv	a1,s2
    800043f6:	855a                	mv	a0,s6
    800043f8:	ffffc097          	auipc	ra,0xffffc
    800043fc:	710080e7          	jalr	1808(ra) # 80000b08 <copyout>
    80004400:	10054f63          	bltz	a0,8000451e <exec+0x31a>
    ustack[argc] = sp;
    80004404:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004408:	0485                	addi	s1,s1,1
    8000440a:	008d8793          	addi	a5,s11,8
    8000440e:	def43823          	sd	a5,-528(s0)
    80004412:	008db503          	ld	a0,8(s11)
    80004416:	c911                	beqz	a0,8000442a <exec+0x226>
    if(argc >= MAXARG)
    80004418:	09a1                	addi	s3,s3,8
    8000441a:	fb3c95e3          	bne	s9,s3,800043c4 <exec+0x1c0>
  sz = sz1;
    8000441e:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004422:	4a81                	li	s5,0
    80004424:	a0e9                	j	800044ee <exec+0x2ea>
  sp = sz;
    80004426:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004428:	4481                	li	s1,0
  ustack[argc] = 0;
    8000442a:	00349793          	slli	a5,s1,0x3
    8000442e:	f9078793          	addi	a5,a5,-112
    80004432:	97a2                	add	a5,a5,s0
    80004434:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004438:	00148693          	addi	a3,s1,1
    8000443c:	068e                	slli	a3,a3,0x3
    8000443e:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004442:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004446:	01597663          	bgeu	s2,s5,80004452 <exec+0x24e>
  sz = sz1;
    8000444a:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000444e:	4a81                	li	s5,0
    80004450:	a879                	j	800044ee <exec+0x2ea>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004452:	e9040613          	addi	a2,s0,-368
    80004456:	85ca                	mv	a1,s2
    80004458:	855a                	mv	a0,s6
    8000445a:	ffffc097          	auipc	ra,0xffffc
    8000445e:	6ae080e7          	jalr	1710(ra) # 80000b08 <copyout>
    80004462:	0c054263          	bltz	a0,80004526 <exec+0x322>
  p->trapframe->a1 = sp;
    80004466:	060bb783          	ld	a5,96(s7)
    8000446a:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000446e:	de843783          	ld	a5,-536(s0)
    80004472:	0007c703          	lbu	a4,0(a5)
    80004476:	cf11                	beqz	a4,80004492 <exec+0x28e>
    80004478:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000447a:	02f00693          	li	a3,47
    8000447e:	a039                	j	8000448c <exec+0x288>
      last = s+1;
    80004480:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80004484:	0785                	addi	a5,a5,1
    80004486:	fff7c703          	lbu	a4,-1(a5)
    8000448a:	c701                	beqz	a4,80004492 <exec+0x28e>
    if(*s == '/')
    8000448c:	fed71ce3          	bne	a4,a3,80004484 <exec+0x280>
    80004490:	bfc5                	j	80004480 <exec+0x27c>
  safestrcpy(p->name, last, sizeof(p->name));
    80004492:	4641                	li	a2,16
    80004494:	de843583          	ld	a1,-536(s0)
    80004498:	160b8513          	addi	a0,s7,352
    8000449c:	ffffc097          	auipc	ra,0xffffc
    800044a0:	e28080e7          	jalr	-472(ra) # 800002c4 <safestrcpy>
  oldpagetable = p->pagetable;
    800044a4:	058bb503          	ld	a0,88(s7)
  p->pagetable = pagetable;
    800044a8:	056bbc23          	sd	s6,88(s7)
  p->sz = sz;
    800044ac:	058bb823          	sd	s8,80(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800044b0:	060bb783          	ld	a5,96(s7)
    800044b4:	e6843703          	ld	a4,-408(s0)
    800044b8:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800044ba:	060bb783          	ld	a5,96(s7)
    800044be:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800044c2:	85ea                	mv	a1,s10
    800044c4:	ffffd097          	auipc	ra,0xffffd
    800044c8:	c2c080e7          	jalr	-980(ra) # 800010f0 <proc_freepagetable>
  if(p->pid==1)
    800044cc:	038ba703          	lw	a4,56(s7)
    800044d0:	4785                	li	a5,1
    800044d2:	00f70563          	beq	a4,a5,800044dc <exec+0x2d8>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800044d6:	0004851b          	sext.w	a0,s1
    800044da:	b3d9                	j	800042a0 <exec+0x9c>
	  vmprint(p->pagetable);
    800044dc:	058bb503          	ld	a0,88(s7)
    800044e0:	ffffd097          	auipc	ra,0xffffd
    800044e4:	8b4080e7          	jalr	-1868(ra) # 80000d94 <vmprint>
    800044e8:	b7fd                	j	800044d6 <exec+0x2d2>
    800044ea:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    800044ee:	df843583          	ld	a1,-520(s0)
    800044f2:	855a                	mv	a0,s6
    800044f4:	ffffd097          	auipc	ra,0xffffd
    800044f8:	bfc080e7          	jalr	-1028(ra) # 800010f0 <proc_freepagetable>
  if(ip){
    800044fc:	d80a98e3          	bnez	s5,8000428c <exec+0x88>
  return -1;
    80004500:	557d                	li	a0,-1
    80004502:	bb79                	j	800042a0 <exec+0x9c>
    80004504:	de943c23          	sd	s1,-520(s0)
    80004508:	b7dd                	j	800044ee <exec+0x2ea>
    8000450a:	de943c23          	sd	s1,-520(s0)
    8000450e:	b7c5                	j	800044ee <exec+0x2ea>
    80004510:	de943c23          	sd	s1,-520(s0)
    80004514:	bfe9                	j	800044ee <exec+0x2ea>
  sz = sz1;
    80004516:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000451a:	4a81                	li	s5,0
    8000451c:	bfc9                	j	800044ee <exec+0x2ea>
  sz = sz1;
    8000451e:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004522:	4a81                	li	s5,0
    80004524:	b7e9                	j	800044ee <exec+0x2ea>
  sz = sz1;
    80004526:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000452a:	4a81                	li	s5,0
    8000452c:	b7c9                	j	800044ee <exec+0x2ea>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000452e:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004532:	e0843783          	ld	a5,-504(s0)
    80004536:	0017869b          	addiw	a3,a5,1
    8000453a:	e0d43423          	sd	a3,-504(s0)
    8000453e:	e0043783          	ld	a5,-512(s0)
    80004542:	0387879b          	addiw	a5,a5,56
    80004546:	e8845703          	lhu	a4,-376(s0)
    8000454a:	e0e6d7e3          	bge	a3,a4,80004358 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000454e:	2781                	sext.w	a5,a5
    80004550:	e0f43023          	sd	a5,-512(s0)
    80004554:	03800713          	li	a4,56
    80004558:	86be                	mv	a3,a5
    8000455a:	e1840613          	addi	a2,s0,-488
    8000455e:	4581                	li	a1,0
    80004560:	8556                	mv	a0,s5
    80004562:	fffff097          	auipc	ra,0xfffff
    80004566:	a5e080e7          	jalr	-1442(ra) # 80002fc0 <readi>
    8000456a:	03800793          	li	a5,56
    8000456e:	f6f51ee3          	bne	a0,a5,800044ea <exec+0x2e6>
    if(ph.type != ELF_PROG_LOAD)
    80004572:	e1842783          	lw	a5,-488(s0)
    80004576:	4705                	li	a4,1
    80004578:	fae79de3          	bne	a5,a4,80004532 <exec+0x32e>
    if(ph.memsz < ph.filesz)
    8000457c:	e4043603          	ld	a2,-448(s0)
    80004580:	e3843783          	ld	a5,-456(s0)
    80004584:	f8f660e3          	bltu	a2,a5,80004504 <exec+0x300>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004588:	e2843783          	ld	a5,-472(s0)
    8000458c:	963e                	add	a2,a2,a5
    8000458e:	f6f66ee3          	bltu	a2,a5,8000450a <exec+0x306>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004592:	85a6                	mv	a1,s1
    80004594:	855a                	mv	a0,s6
    80004596:	ffffc097          	auipc	ra,0xffffc
    8000459a:	31e080e7          	jalr	798(ra) # 800008b4 <uvmalloc>
    8000459e:	dea43c23          	sd	a0,-520(s0)
    800045a2:	d53d                	beqz	a0,80004510 <exec+0x30c>
    if((ph.vaddr % PGSIZE) != 0)
    800045a4:	e2843c03          	ld	s8,-472(s0)
    800045a8:	de043783          	ld	a5,-544(s0)
    800045ac:	00fc77b3          	and	a5,s8,a5
    800045b0:	ff9d                	bnez	a5,800044ee <exec+0x2ea>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800045b2:	e2042c83          	lw	s9,-480(s0)
    800045b6:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800045ba:	f60b8ae3          	beqz	s7,8000452e <exec+0x32a>
    800045be:	89de                	mv	s3,s7
    800045c0:	4481                	li	s1,0
    800045c2:	bb95                	j	80004336 <exec+0x132>

00000000800045c4 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800045c4:	7179                	addi	sp,sp,-48
    800045c6:	f406                	sd	ra,40(sp)
    800045c8:	f022                	sd	s0,32(sp)
    800045ca:	ec26                	sd	s1,24(sp)
    800045cc:	e84a                	sd	s2,16(sp)
    800045ce:	1800                	addi	s0,sp,48
    800045d0:	892e                	mv	s2,a1
    800045d2:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    800045d4:	fdc40593          	addi	a1,s0,-36
    800045d8:	ffffe097          	auipc	ra,0xffffe
    800045dc:	ac4080e7          	jalr	-1340(ra) # 8000209c <argint>
    800045e0:	04054063          	bltz	a0,80004620 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800045e4:	fdc42703          	lw	a4,-36(s0)
    800045e8:	47bd                	li	a5,15
    800045ea:	02e7ed63          	bltu	a5,a4,80004624 <argfd+0x60>
    800045ee:	ffffd097          	auipc	ra,0xffffd
    800045f2:	948080e7          	jalr	-1720(ra) # 80000f36 <myproc>
    800045f6:	fdc42703          	lw	a4,-36(s0)
    800045fa:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7ffd8dda>
    800045fe:	078e                	slli	a5,a5,0x3
    80004600:	953e                	add	a0,a0,a5
    80004602:	651c                	ld	a5,8(a0)
    80004604:	c395                	beqz	a5,80004628 <argfd+0x64>
    return -1;
  if(pfd)
    80004606:	00090463          	beqz	s2,8000460e <argfd+0x4a>
    *pfd = fd;
    8000460a:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000460e:	4501                	li	a0,0
  if(pf)
    80004610:	c091                	beqz	s1,80004614 <argfd+0x50>
    *pf = f;
    80004612:	e09c                	sd	a5,0(s1)
}
    80004614:	70a2                	ld	ra,40(sp)
    80004616:	7402                	ld	s0,32(sp)
    80004618:	64e2                	ld	s1,24(sp)
    8000461a:	6942                	ld	s2,16(sp)
    8000461c:	6145                	addi	sp,sp,48
    8000461e:	8082                	ret
    return -1;
    80004620:	557d                	li	a0,-1
    80004622:	bfcd                	j	80004614 <argfd+0x50>
    return -1;
    80004624:	557d                	li	a0,-1
    80004626:	b7fd                	j	80004614 <argfd+0x50>
    80004628:	557d                	li	a0,-1
    8000462a:	b7ed                	j	80004614 <argfd+0x50>

000000008000462c <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000462c:	1101                	addi	sp,sp,-32
    8000462e:	ec06                	sd	ra,24(sp)
    80004630:	e822                	sd	s0,16(sp)
    80004632:	e426                	sd	s1,8(sp)
    80004634:	1000                	addi	s0,sp,32
    80004636:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004638:	ffffd097          	auipc	ra,0xffffd
    8000463c:	8fe080e7          	jalr	-1794(ra) # 80000f36 <myproc>
    80004640:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004642:	0d850793          	addi	a5,a0,216
    80004646:	4501                	li	a0,0
    80004648:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000464a:	6398                	ld	a4,0(a5)
    8000464c:	cb19                	beqz	a4,80004662 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    8000464e:	2505                	addiw	a0,a0,1
    80004650:	07a1                	addi	a5,a5,8
    80004652:	fed51ce3          	bne	a0,a3,8000464a <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004656:	557d                	li	a0,-1
}
    80004658:	60e2                	ld	ra,24(sp)
    8000465a:	6442                	ld	s0,16(sp)
    8000465c:	64a2                	ld	s1,8(sp)
    8000465e:	6105                	addi	sp,sp,32
    80004660:	8082                	ret
      p->ofile[fd] = f;
    80004662:	01a50793          	addi	a5,a0,26
    80004666:	078e                	slli	a5,a5,0x3
    80004668:	963e                	add	a2,a2,a5
    8000466a:	e604                	sd	s1,8(a2)
      return fd;
    8000466c:	b7f5                	j	80004658 <fdalloc+0x2c>

000000008000466e <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000466e:	715d                	addi	sp,sp,-80
    80004670:	e486                	sd	ra,72(sp)
    80004672:	e0a2                	sd	s0,64(sp)
    80004674:	fc26                	sd	s1,56(sp)
    80004676:	f84a                	sd	s2,48(sp)
    80004678:	f44e                	sd	s3,40(sp)
    8000467a:	f052                	sd	s4,32(sp)
    8000467c:	ec56                	sd	s5,24(sp)
    8000467e:	0880                	addi	s0,sp,80
    80004680:	89ae                	mv	s3,a1
    80004682:	8ab2                	mv	s5,a2
    80004684:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004686:	fb040593          	addi	a1,s0,-80
    8000468a:	fffff097          	auipc	ra,0xfffff
    8000468e:	e5c080e7          	jalr	-420(ra) # 800034e6 <nameiparent>
    80004692:	892a                	mv	s2,a0
    80004694:	12050e63          	beqz	a0,800047d0 <create+0x162>
    return 0;

  ilock(dp);
    80004698:	ffffe097          	auipc	ra,0xffffe
    8000469c:	674080e7          	jalr	1652(ra) # 80002d0c <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800046a0:	4601                	li	a2,0
    800046a2:	fb040593          	addi	a1,s0,-80
    800046a6:	854a                	mv	a0,s2
    800046a8:	fffff097          	auipc	ra,0xfffff
    800046ac:	b48080e7          	jalr	-1208(ra) # 800031f0 <dirlookup>
    800046b0:	84aa                	mv	s1,a0
    800046b2:	c921                	beqz	a0,80004702 <create+0x94>
    iunlockput(dp);
    800046b4:	854a                	mv	a0,s2
    800046b6:	fffff097          	auipc	ra,0xfffff
    800046ba:	8b8080e7          	jalr	-1864(ra) # 80002f6e <iunlockput>
    ilock(ip);
    800046be:	8526                	mv	a0,s1
    800046c0:	ffffe097          	auipc	ra,0xffffe
    800046c4:	64c080e7          	jalr	1612(ra) # 80002d0c <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800046c8:	2981                	sext.w	s3,s3
    800046ca:	4789                	li	a5,2
    800046cc:	02f99463          	bne	s3,a5,800046f4 <create+0x86>
    800046d0:	0444d783          	lhu	a5,68(s1)
    800046d4:	37f9                	addiw	a5,a5,-2
    800046d6:	17c2                	slli	a5,a5,0x30
    800046d8:	93c1                	srli	a5,a5,0x30
    800046da:	4705                	li	a4,1
    800046dc:	00f76c63          	bltu	a4,a5,800046f4 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800046e0:	8526                	mv	a0,s1
    800046e2:	60a6                	ld	ra,72(sp)
    800046e4:	6406                	ld	s0,64(sp)
    800046e6:	74e2                	ld	s1,56(sp)
    800046e8:	7942                	ld	s2,48(sp)
    800046ea:	79a2                	ld	s3,40(sp)
    800046ec:	7a02                	ld	s4,32(sp)
    800046ee:	6ae2                	ld	s5,24(sp)
    800046f0:	6161                	addi	sp,sp,80
    800046f2:	8082                	ret
    iunlockput(ip);
    800046f4:	8526                	mv	a0,s1
    800046f6:	fffff097          	auipc	ra,0xfffff
    800046fa:	878080e7          	jalr	-1928(ra) # 80002f6e <iunlockput>
    return 0;
    800046fe:	4481                	li	s1,0
    80004700:	b7c5                	j	800046e0 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004702:	85ce                	mv	a1,s3
    80004704:	00092503          	lw	a0,0(s2)
    80004708:	ffffe097          	auipc	ra,0xffffe
    8000470c:	46a080e7          	jalr	1130(ra) # 80002b72 <ialloc>
    80004710:	84aa                	mv	s1,a0
    80004712:	c521                	beqz	a0,8000475a <create+0xec>
  ilock(ip);
    80004714:	ffffe097          	auipc	ra,0xffffe
    80004718:	5f8080e7          	jalr	1528(ra) # 80002d0c <ilock>
  ip->major = major;
    8000471c:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80004720:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80004724:	4a05                	li	s4,1
    80004726:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    8000472a:	8526                	mv	a0,s1
    8000472c:	ffffe097          	auipc	ra,0xffffe
    80004730:	514080e7          	jalr	1300(ra) # 80002c40 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004734:	2981                	sext.w	s3,s3
    80004736:	03498a63          	beq	s3,s4,8000476a <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    8000473a:	40d0                	lw	a2,4(s1)
    8000473c:	fb040593          	addi	a1,s0,-80
    80004740:	854a                	mv	a0,s2
    80004742:	fffff097          	auipc	ra,0xfffff
    80004746:	cc4080e7          	jalr	-828(ra) # 80003406 <dirlink>
    8000474a:	06054b63          	bltz	a0,800047c0 <create+0x152>
  iunlockput(dp);
    8000474e:	854a                	mv	a0,s2
    80004750:	fffff097          	auipc	ra,0xfffff
    80004754:	81e080e7          	jalr	-2018(ra) # 80002f6e <iunlockput>
  return ip;
    80004758:	b761                	j	800046e0 <create+0x72>
    panic("create: ialloc");
    8000475a:	00004517          	auipc	a0,0x4
    8000475e:	fce50513          	addi	a0,a0,-50 # 80008728 <syscalls+0x300>
    80004762:	00001097          	auipc	ra,0x1
    80004766:	63e080e7          	jalr	1598(ra) # 80005da0 <panic>
    dp->nlink++;  // for ".."
    8000476a:	04a95783          	lhu	a5,74(s2)
    8000476e:	2785                	addiw	a5,a5,1
    80004770:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80004774:	854a                	mv	a0,s2
    80004776:	ffffe097          	auipc	ra,0xffffe
    8000477a:	4ca080e7          	jalr	1226(ra) # 80002c40 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000477e:	40d0                	lw	a2,4(s1)
    80004780:	00004597          	auipc	a1,0x4
    80004784:	fb858593          	addi	a1,a1,-72 # 80008738 <syscalls+0x310>
    80004788:	8526                	mv	a0,s1
    8000478a:	fffff097          	auipc	ra,0xfffff
    8000478e:	c7c080e7          	jalr	-900(ra) # 80003406 <dirlink>
    80004792:	00054f63          	bltz	a0,800047b0 <create+0x142>
    80004796:	00492603          	lw	a2,4(s2)
    8000479a:	00004597          	auipc	a1,0x4
    8000479e:	fa658593          	addi	a1,a1,-90 # 80008740 <syscalls+0x318>
    800047a2:	8526                	mv	a0,s1
    800047a4:	fffff097          	auipc	ra,0xfffff
    800047a8:	c62080e7          	jalr	-926(ra) # 80003406 <dirlink>
    800047ac:	f80557e3          	bgez	a0,8000473a <create+0xcc>
      panic("create dots");
    800047b0:	00004517          	auipc	a0,0x4
    800047b4:	f9850513          	addi	a0,a0,-104 # 80008748 <syscalls+0x320>
    800047b8:	00001097          	auipc	ra,0x1
    800047bc:	5e8080e7          	jalr	1512(ra) # 80005da0 <panic>
    panic("create: dirlink");
    800047c0:	00004517          	auipc	a0,0x4
    800047c4:	f9850513          	addi	a0,a0,-104 # 80008758 <syscalls+0x330>
    800047c8:	00001097          	auipc	ra,0x1
    800047cc:	5d8080e7          	jalr	1496(ra) # 80005da0 <panic>
    return 0;
    800047d0:	84aa                	mv	s1,a0
    800047d2:	b739                	j	800046e0 <create+0x72>

00000000800047d4 <sys_dup>:
{
    800047d4:	7179                	addi	sp,sp,-48
    800047d6:	f406                	sd	ra,40(sp)
    800047d8:	f022                	sd	s0,32(sp)
    800047da:	ec26                	sd	s1,24(sp)
    800047dc:	e84a                	sd	s2,16(sp)
    800047de:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800047e0:	fd840613          	addi	a2,s0,-40
    800047e4:	4581                	li	a1,0
    800047e6:	4501                	li	a0,0
    800047e8:	00000097          	auipc	ra,0x0
    800047ec:	ddc080e7          	jalr	-548(ra) # 800045c4 <argfd>
    return -1;
    800047f0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800047f2:	02054363          	bltz	a0,80004818 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    800047f6:	fd843903          	ld	s2,-40(s0)
    800047fa:	854a                	mv	a0,s2
    800047fc:	00000097          	auipc	ra,0x0
    80004800:	e30080e7          	jalr	-464(ra) # 8000462c <fdalloc>
    80004804:	84aa                	mv	s1,a0
    return -1;
    80004806:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004808:	00054863          	bltz	a0,80004818 <sys_dup+0x44>
  filedup(f);
    8000480c:	854a                	mv	a0,s2
    8000480e:	fffff097          	auipc	ra,0xfffff
    80004812:	350080e7          	jalr	848(ra) # 80003b5e <filedup>
  return fd;
    80004816:	87a6                	mv	a5,s1
}
    80004818:	853e                	mv	a0,a5
    8000481a:	70a2                	ld	ra,40(sp)
    8000481c:	7402                	ld	s0,32(sp)
    8000481e:	64e2                	ld	s1,24(sp)
    80004820:	6942                	ld	s2,16(sp)
    80004822:	6145                	addi	sp,sp,48
    80004824:	8082                	ret

0000000080004826 <sys_read>:
{
    80004826:	7179                	addi	sp,sp,-48
    80004828:	f406                	sd	ra,40(sp)
    8000482a:	f022                	sd	s0,32(sp)
    8000482c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000482e:	fe840613          	addi	a2,s0,-24
    80004832:	4581                	li	a1,0
    80004834:	4501                	li	a0,0
    80004836:	00000097          	auipc	ra,0x0
    8000483a:	d8e080e7          	jalr	-626(ra) # 800045c4 <argfd>
    return -1;
    8000483e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004840:	04054163          	bltz	a0,80004882 <sys_read+0x5c>
    80004844:	fe440593          	addi	a1,s0,-28
    80004848:	4509                	li	a0,2
    8000484a:	ffffe097          	auipc	ra,0xffffe
    8000484e:	852080e7          	jalr	-1966(ra) # 8000209c <argint>
    return -1;
    80004852:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004854:	02054763          	bltz	a0,80004882 <sys_read+0x5c>
    80004858:	fd840593          	addi	a1,s0,-40
    8000485c:	4505                	li	a0,1
    8000485e:	ffffe097          	auipc	ra,0xffffe
    80004862:	860080e7          	jalr	-1952(ra) # 800020be <argaddr>
    return -1;
    80004866:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004868:	00054d63          	bltz	a0,80004882 <sys_read+0x5c>
  return fileread(f, p, n);
    8000486c:	fe442603          	lw	a2,-28(s0)
    80004870:	fd843583          	ld	a1,-40(s0)
    80004874:	fe843503          	ld	a0,-24(s0)
    80004878:	fffff097          	auipc	ra,0xfffff
    8000487c:	472080e7          	jalr	1138(ra) # 80003cea <fileread>
    80004880:	87aa                	mv	a5,a0
}
    80004882:	853e                	mv	a0,a5
    80004884:	70a2                	ld	ra,40(sp)
    80004886:	7402                	ld	s0,32(sp)
    80004888:	6145                	addi	sp,sp,48
    8000488a:	8082                	ret

000000008000488c <sys_write>:
{
    8000488c:	7179                	addi	sp,sp,-48
    8000488e:	f406                	sd	ra,40(sp)
    80004890:	f022                	sd	s0,32(sp)
    80004892:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004894:	fe840613          	addi	a2,s0,-24
    80004898:	4581                	li	a1,0
    8000489a:	4501                	li	a0,0
    8000489c:	00000097          	auipc	ra,0x0
    800048a0:	d28080e7          	jalr	-728(ra) # 800045c4 <argfd>
    return -1;
    800048a4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048a6:	04054163          	bltz	a0,800048e8 <sys_write+0x5c>
    800048aa:	fe440593          	addi	a1,s0,-28
    800048ae:	4509                	li	a0,2
    800048b0:	ffffd097          	auipc	ra,0xffffd
    800048b4:	7ec080e7          	jalr	2028(ra) # 8000209c <argint>
    return -1;
    800048b8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048ba:	02054763          	bltz	a0,800048e8 <sys_write+0x5c>
    800048be:	fd840593          	addi	a1,s0,-40
    800048c2:	4505                	li	a0,1
    800048c4:	ffffd097          	auipc	ra,0xffffd
    800048c8:	7fa080e7          	jalr	2042(ra) # 800020be <argaddr>
    return -1;
    800048cc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048ce:	00054d63          	bltz	a0,800048e8 <sys_write+0x5c>
  return filewrite(f, p, n);
    800048d2:	fe442603          	lw	a2,-28(s0)
    800048d6:	fd843583          	ld	a1,-40(s0)
    800048da:	fe843503          	ld	a0,-24(s0)
    800048de:	fffff097          	auipc	ra,0xfffff
    800048e2:	4ce080e7          	jalr	1230(ra) # 80003dac <filewrite>
    800048e6:	87aa                	mv	a5,a0
}
    800048e8:	853e                	mv	a0,a5
    800048ea:	70a2                	ld	ra,40(sp)
    800048ec:	7402                	ld	s0,32(sp)
    800048ee:	6145                	addi	sp,sp,48
    800048f0:	8082                	ret

00000000800048f2 <sys_close>:
{
    800048f2:	1101                	addi	sp,sp,-32
    800048f4:	ec06                	sd	ra,24(sp)
    800048f6:	e822                	sd	s0,16(sp)
    800048f8:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800048fa:	fe040613          	addi	a2,s0,-32
    800048fe:	fec40593          	addi	a1,s0,-20
    80004902:	4501                	li	a0,0
    80004904:	00000097          	auipc	ra,0x0
    80004908:	cc0080e7          	jalr	-832(ra) # 800045c4 <argfd>
    return -1;
    8000490c:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000490e:	02054463          	bltz	a0,80004936 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004912:	ffffc097          	auipc	ra,0xffffc
    80004916:	624080e7          	jalr	1572(ra) # 80000f36 <myproc>
    8000491a:	fec42783          	lw	a5,-20(s0)
    8000491e:	07e9                	addi	a5,a5,26
    80004920:	078e                	slli	a5,a5,0x3
    80004922:	953e                	add	a0,a0,a5
    80004924:	00053423          	sd	zero,8(a0)
  fileclose(f);
    80004928:	fe043503          	ld	a0,-32(s0)
    8000492c:	fffff097          	auipc	ra,0xfffff
    80004930:	284080e7          	jalr	644(ra) # 80003bb0 <fileclose>
  return 0;
    80004934:	4781                	li	a5,0
}
    80004936:	853e                	mv	a0,a5
    80004938:	60e2                	ld	ra,24(sp)
    8000493a:	6442                	ld	s0,16(sp)
    8000493c:	6105                	addi	sp,sp,32
    8000493e:	8082                	ret

0000000080004940 <sys_fstat>:
{
    80004940:	1101                	addi	sp,sp,-32
    80004942:	ec06                	sd	ra,24(sp)
    80004944:	e822                	sd	s0,16(sp)
    80004946:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004948:	fe840613          	addi	a2,s0,-24
    8000494c:	4581                	li	a1,0
    8000494e:	4501                	li	a0,0
    80004950:	00000097          	auipc	ra,0x0
    80004954:	c74080e7          	jalr	-908(ra) # 800045c4 <argfd>
    return -1;
    80004958:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000495a:	02054563          	bltz	a0,80004984 <sys_fstat+0x44>
    8000495e:	fe040593          	addi	a1,s0,-32
    80004962:	4505                	li	a0,1
    80004964:	ffffd097          	auipc	ra,0xffffd
    80004968:	75a080e7          	jalr	1882(ra) # 800020be <argaddr>
    return -1;
    8000496c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000496e:	00054b63          	bltz	a0,80004984 <sys_fstat+0x44>
  return filestat(f, st);
    80004972:	fe043583          	ld	a1,-32(s0)
    80004976:	fe843503          	ld	a0,-24(s0)
    8000497a:	fffff097          	auipc	ra,0xfffff
    8000497e:	2fe080e7          	jalr	766(ra) # 80003c78 <filestat>
    80004982:	87aa                	mv	a5,a0
}
    80004984:	853e                	mv	a0,a5
    80004986:	60e2                	ld	ra,24(sp)
    80004988:	6442                	ld	s0,16(sp)
    8000498a:	6105                	addi	sp,sp,32
    8000498c:	8082                	ret

000000008000498e <sys_link>:
{
    8000498e:	7169                	addi	sp,sp,-304
    80004990:	f606                	sd	ra,296(sp)
    80004992:	f222                	sd	s0,288(sp)
    80004994:	ee26                	sd	s1,280(sp)
    80004996:	ea4a                	sd	s2,272(sp)
    80004998:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000499a:	08000613          	li	a2,128
    8000499e:	ed040593          	addi	a1,s0,-304
    800049a2:	4501                	li	a0,0
    800049a4:	ffffd097          	auipc	ra,0xffffd
    800049a8:	73c080e7          	jalr	1852(ra) # 800020e0 <argstr>
    return -1;
    800049ac:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049ae:	10054e63          	bltz	a0,80004aca <sys_link+0x13c>
    800049b2:	08000613          	li	a2,128
    800049b6:	f5040593          	addi	a1,s0,-176
    800049ba:	4505                	li	a0,1
    800049bc:	ffffd097          	auipc	ra,0xffffd
    800049c0:	724080e7          	jalr	1828(ra) # 800020e0 <argstr>
    return -1;
    800049c4:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049c6:	10054263          	bltz	a0,80004aca <sys_link+0x13c>
  begin_op();
    800049ca:	fffff097          	auipc	ra,0xfffff
    800049ce:	d1e080e7          	jalr	-738(ra) # 800036e8 <begin_op>
  if((ip = namei(old)) == 0){
    800049d2:	ed040513          	addi	a0,s0,-304
    800049d6:	fffff097          	auipc	ra,0xfffff
    800049da:	af2080e7          	jalr	-1294(ra) # 800034c8 <namei>
    800049de:	84aa                	mv	s1,a0
    800049e0:	c551                	beqz	a0,80004a6c <sys_link+0xde>
  ilock(ip);
    800049e2:	ffffe097          	auipc	ra,0xffffe
    800049e6:	32a080e7          	jalr	810(ra) # 80002d0c <ilock>
  if(ip->type == T_DIR){
    800049ea:	04449703          	lh	a4,68(s1)
    800049ee:	4785                	li	a5,1
    800049f0:	08f70463          	beq	a4,a5,80004a78 <sys_link+0xea>
  ip->nlink++;
    800049f4:	04a4d783          	lhu	a5,74(s1)
    800049f8:	2785                	addiw	a5,a5,1
    800049fa:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800049fe:	8526                	mv	a0,s1
    80004a00:	ffffe097          	auipc	ra,0xffffe
    80004a04:	240080e7          	jalr	576(ra) # 80002c40 <iupdate>
  iunlock(ip);
    80004a08:	8526                	mv	a0,s1
    80004a0a:	ffffe097          	auipc	ra,0xffffe
    80004a0e:	3c4080e7          	jalr	964(ra) # 80002dce <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004a12:	fd040593          	addi	a1,s0,-48
    80004a16:	f5040513          	addi	a0,s0,-176
    80004a1a:	fffff097          	auipc	ra,0xfffff
    80004a1e:	acc080e7          	jalr	-1332(ra) # 800034e6 <nameiparent>
    80004a22:	892a                	mv	s2,a0
    80004a24:	c935                	beqz	a0,80004a98 <sys_link+0x10a>
  ilock(dp);
    80004a26:	ffffe097          	auipc	ra,0xffffe
    80004a2a:	2e6080e7          	jalr	742(ra) # 80002d0c <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004a2e:	00092703          	lw	a4,0(s2)
    80004a32:	409c                	lw	a5,0(s1)
    80004a34:	04f71d63          	bne	a4,a5,80004a8e <sys_link+0x100>
    80004a38:	40d0                	lw	a2,4(s1)
    80004a3a:	fd040593          	addi	a1,s0,-48
    80004a3e:	854a                	mv	a0,s2
    80004a40:	fffff097          	auipc	ra,0xfffff
    80004a44:	9c6080e7          	jalr	-1594(ra) # 80003406 <dirlink>
    80004a48:	04054363          	bltz	a0,80004a8e <sys_link+0x100>
  iunlockput(dp);
    80004a4c:	854a                	mv	a0,s2
    80004a4e:	ffffe097          	auipc	ra,0xffffe
    80004a52:	520080e7          	jalr	1312(ra) # 80002f6e <iunlockput>
  iput(ip);
    80004a56:	8526                	mv	a0,s1
    80004a58:	ffffe097          	auipc	ra,0xffffe
    80004a5c:	46e080e7          	jalr	1134(ra) # 80002ec6 <iput>
  end_op();
    80004a60:	fffff097          	auipc	ra,0xfffff
    80004a64:	d06080e7          	jalr	-762(ra) # 80003766 <end_op>
  return 0;
    80004a68:	4781                	li	a5,0
    80004a6a:	a085                	j	80004aca <sys_link+0x13c>
    end_op();
    80004a6c:	fffff097          	auipc	ra,0xfffff
    80004a70:	cfa080e7          	jalr	-774(ra) # 80003766 <end_op>
    return -1;
    80004a74:	57fd                	li	a5,-1
    80004a76:	a891                	j	80004aca <sys_link+0x13c>
    iunlockput(ip);
    80004a78:	8526                	mv	a0,s1
    80004a7a:	ffffe097          	auipc	ra,0xffffe
    80004a7e:	4f4080e7          	jalr	1268(ra) # 80002f6e <iunlockput>
    end_op();
    80004a82:	fffff097          	auipc	ra,0xfffff
    80004a86:	ce4080e7          	jalr	-796(ra) # 80003766 <end_op>
    return -1;
    80004a8a:	57fd                	li	a5,-1
    80004a8c:	a83d                	j	80004aca <sys_link+0x13c>
    iunlockput(dp);
    80004a8e:	854a                	mv	a0,s2
    80004a90:	ffffe097          	auipc	ra,0xffffe
    80004a94:	4de080e7          	jalr	1246(ra) # 80002f6e <iunlockput>
  ilock(ip);
    80004a98:	8526                	mv	a0,s1
    80004a9a:	ffffe097          	auipc	ra,0xffffe
    80004a9e:	272080e7          	jalr	626(ra) # 80002d0c <ilock>
  ip->nlink--;
    80004aa2:	04a4d783          	lhu	a5,74(s1)
    80004aa6:	37fd                	addiw	a5,a5,-1
    80004aa8:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004aac:	8526                	mv	a0,s1
    80004aae:	ffffe097          	auipc	ra,0xffffe
    80004ab2:	192080e7          	jalr	402(ra) # 80002c40 <iupdate>
  iunlockput(ip);
    80004ab6:	8526                	mv	a0,s1
    80004ab8:	ffffe097          	auipc	ra,0xffffe
    80004abc:	4b6080e7          	jalr	1206(ra) # 80002f6e <iunlockput>
  end_op();
    80004ac0:	fffff097          	auipc	ra,0xfffff
    80004ac4:	ca6080e7          	jalr	-858(ra) # 80003766 <end_op>
  return -1;
    80004ac8:	57fd                	li	a5,-1
}
    80004aca:	853e                	mv	a0,a5
    80004acc:	70b2                	ld	ra,296(sp)
    80004ace:	7412                	ld	s0,288(sp)
    80004ad0:	64f2                	ld	s1,280(sp)
    80004ad2:	6952                	ld	s2,272(sp)
    80004ad4:	6155                	addi	sp,sp,304
    80004ad6:	8082                	ret

0000000080004ad8 <sys_unlink>:
{
    80004ad8:	7151                	addi	sp,sp,-240
    80004ada:	f586                	sd	ra,232(sp)
    80004adc:	f1a2                	sd	s0,224(sp)
    80004ade:	eda6                	sd	s1,216(sp)
    80004ae0:	e9ca                	sd	s2,208(sp)
    80004ae2:	e5ce                	sd	s3,200(sp)
    80004ae4:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004ae6:	08000613          	li	a2,128
    80004aea:	f3040593          	addi	a1,s0,-208
    80004aee:	4501                	li	a0,0
    80004af0:	ffffd097          	auipc	ra,0xffffd
    80004af4:	5f0080e7          	jalr	1520(ra) # 800020e0 <argstr>
    80004af8:	18054163          	bltz	a0,80004c7a <sys_unlink+0x1a2>
  begin_op();
    80004afc:	fffff097          	auipc	ra,0xfffff
    80004b00:	bec080e7          	jalr	-1044(ra) # 800036e8 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004b04:	fb040593          	addi	a1,s0,-80
    80004b08:	f3040513          	addi	a0,s0,-208
    80004b0c:	fffff097          	auipc	ra,0xfffff
    80004b10:	9da080e7          	jalr	-1574(ra) # 800034e6 <nameiparent>
    80004b14:	84aa                	mv	s1,a0
    80004b16:	c979                	beqz	a0,80004bec <sys_unlink+0x114>
  ilock(dp);
    80004b18:	ffffe097          	auipc	ra,0xffffe
    80004b1c:	1f4080e7          	jalr	500(ra) # 80002d0c <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004b20:	00004597          	auipc	a1,0x4
    80004b24:	c1858593          	addi	a1,a1,-1000 # 80008738 <syscalls+0x310>
    80004b28:	fb040513          	addi	a0,s0,-80
    80004b2c:	ffffe097          	auipc	ra,0xffffe
    80004b30:	6aa080e7          	jalr	1706(ra) # 800031d6 <namecmp>
    80004b34:	14050a63          	beqz	a0,80004c88 <sys_unlink+0x1b0>
    80004b38:	00004597          	auipc	a1,0x4
    80004b3c:	c0858593          	addi	a1,a1,-1016 # 80008740 <syscalls+0x318>
    80004b40:	fb040513          	addi	a0,s0,-80
    80004b44:	ffffe097          	auipc	ra,0xffffe
    80004b48:	692080e7          	jalr	1682(ra) # 800031d6 <namecmp>
    80004b4c:	12050e63          	beqz	a0,80004c88 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004b50:	f2c40613          	addi	a2,s0,-212
    80004b54:	fb040593          	addi	a1,s0,-80
    80004b58:	8526                	mv	a0,s1
    80004b5a:	ffffe097          	auipc	ra,0xffffe
    80004b5e:	696080e7          	jalr	1686(ra) # 800031f0 <dirlookup>
    80004b62:	892a                	mv	s2,a0
    80004b64:	12050263          	beqz	a0,80004c88 <sys_unlink+0x1b0>
  ilock(ip);
    80004b68:	ffffe097          	auipc	ra,0xffffe
    80004b6c:	1a4080e7          	jalr	420(ra) # 80002d0c <ilock>
  if(ip->nlink < 1)
    80004b70:	04a91783          	lh	a5,74(s2)
    80004b74:	08f05263          	blez	a5,80004bf8 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004b78:	04491703          	lh	a4,68(s2)
    80004b7c:	4785                	li	a5,1
    80004b7e:	08f70563          	beq	a4,a5,80004c08 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004b82:	4641                	li	a2,16
    80004b84:	4581                	li	a1,0
    80004b86:	fc040513          	addi	a0,s0,-64
    80004b8a:	ffffb097          	auipc	ra,0xffffb
    80004b8e:	5f0080e7          	jalr	1520(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b92:	4741                	li	a4,16
    80004b94:	f2c42683          	lw	a3,-212(s0)
    80004b98:	fc040613          	addi	a2,s0,-64
    80004b9c:	4581                	li	a1,0
    80004b9e:	8526                	mv	a0,s1
    80004ba0:	ffffe097          	auipc	ra,0xffffe
    80004ba4:	518080e7          	jalr	1304(ra) # 800030b8 <writei>
    80004ba8:	47c1                	li	a5,16
    80004baa:	0af51563          	bne	a0,a5,80004c54 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004bae:	04491703          	lh	a4,68(s2)
    80004bb2:	4785                	li	a5,1
    80004bb4:	0af70863          	beq	a4,a5,80004c64 <sys_unlink+0x18c>
  iunlockput(dp);
    80004bb8:	8526                	mv	a0,s1
    80004bba:	ffffe097          	auipc	ra,0xffffe
    80004bbe:	3b4080e7          	jalr	948(ra) # 80002f6e <iunlockput>
  ip->nlink--;
    80004bc2:	04a95783          	lhu	a5,74(s2)
    80004bc6:	37fd                	addiw	a5,a5,-1
    80004bc8:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004bcc:	854a                	mv	a0,s2
    80004bce:	ffffe097          	auipc	ra,0xffffe
    80004bd2:	072080e7          	jalr	114(ra) # 80002c40 <iupdate>
  iunlockput(ip);
    80004bd6:	854a                	mv	a0,s2
    80004bd8:	ffffe097          	auipc	ra,0xffffe
    80004bdc:	396080e7          	jalr	918(ra) # 80002f6e <iunlockput>
  end_op();
    80004be0:	fffff097          	auipc	ra,0xfffff
    80004be4:	b86080e7          	jalr	-1146(ra) # 80003766 <end_op>
  return 0;
    80004be8:	4501                	li	a0,0
    80004bea:	a84d                	j	80004c9c <sys_unlink+0x1c4>
    end_op();
    80004bec:	fffff097          	auipc	ra,0xfffff
    80004bf0:	b7a080e7          	jalr	-1158(ra) # 80003766 <end_op>
    return -1;
    80004bf4:	557d                	li	a0,-1
    80004bf6:	a05d                	j	80004c9c <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004bf8:	00004517          	auipc	a0,0x4
    80004bfc:	b7050513          	addi	a0,a0,-1168 # 80008768 <syscalls+0x340>
    80004c00:	00001097          	auipc	ra,0x1
    80004c04:	1a0080e7          	jalr	416(ra) # 80005da0 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c08:	04c92703          	lw	a4,76(s2)
    80004c0c:	02000793          	li	a5,32
    80004c10:	f6e7f9e3          	bgeu	a5,a4,80004b82 <sys_unlink+0xaa>
    80004c14:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c18:	4741                	li	a4,16
    80004c1a:	86ce                	mv	a3,s3
    80004c1c:	f1840613          	addi	a2,s0,-232
    80004c20:	4581                	li	a1,0
    80004c22:	854a                	mv	a0,s2
    80004c24:	ffffe097          	auipc	ra,0xffffe
    80004c28:	39c080e7          	jalr	924(ra) # 80002fc0 <readi>
    80004c2c:	47c1                	li	a5,16
    80004c2e:	00f51b63          	bne	a0,a5,80004c44 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004c32:	f1845783          	lhu	a5,-232(s0)
    80004c36:	e7a1                	bnez	a5,80004c7e <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c38:	29c1                	addiw	s3,s3,16
    80004c3a:	04c92783          	lw	a5,76(s2)
    80004c3e:	fcf9ede3          	bltu	s3,a5,80004c18 <sys_unlink+0x140>
    80004c42:	b781                	j	80004b82 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004c44:	00004517          	auipc	a0,0x4
    80004c48:	b3c50513          	addi	a0,a0,-1220 # 80008780 <syscalls+0x358>
    80004c4c:	00001097          	auipc	ra,0x1
    80004c50:	154080e7          	jalr	340(ra) # 80005da0 <panic>
    panic("unlink: writei");
    80004c54:	00004517          	auipc	a0,0x4
    80004c58:	b4450513          	addi	a0,a0,-1212 # 80008798 <syscalls+0x370>
    80004c5c:	00001097          	auipc	ra,0x1
    80004c60:	144080e7          	jalr	324(ra) # 80005da0 <panic>
    dp->nlink--;
    80004c64:	04a4d783          	lhu	a5,74(s1)
    80004c68:	37fd                	addiw	a5,a5,-1
    80004c6a:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004c6e:	8526                	mv	a0,s1
    80004c70:	ffffe097          	auipc	ra,0xffffe
    80004c74:	fd0080e7          	jalr	-48(ra) # 80002c40 <iupdate>
    80004c78:	b781                	j	80004bb8 <sys_unlink+0xe0>
    return -1;
    80004c7a:	557d                	li	a0,-1
    80004c7c:	a005                	j	80004c9c <sys_unlink+0x1c4>
    iunlockput(ip);
    80004c7e:	854a                	mv	a0,s2
    80004c80:	ffffe097          	auipc	ra,0xffffe
    80004c84:	2ee080e7          	jalr	750(ra) # 80002f6e <iunlockput>
  iunlockput(dp);
    80004c88:	8526                	mv	a0,s1
    80004c8a:	ffffe097          	auipc	ra,0xffffe
    80004c8e:	2e4080e7          	jalr	740(ra) # 80002f6e <iunlockput>
  end_op();
    80004c92:	fffff097          	auipc	ra,0xfffff
    80004c96:	ad4080e7          	jalr	-1324(ra) # 80003766 <end_op>
  return -1;
    80004c9a:	557d                	li	a0,-1
}
    80004c9c:	70ae                	ld	ra,232(sp)
    80004c9e:	740e                	ld	s0,224(sp)
    80004ca0:	64ee                	ld	s1,216(sp)
    80004ca2:	694e                	ld	s2,208(sp)
    80004ca4:	69ae                	ld	s3,200(sp)
    80004ca6:	616d                	addi	sp,sp,240
    80004ca8:	8082                	ret

0000000080004caa <sys_open>:

uint64
sys_open(void)
{
    80004caa:	7131                	addi	sp,sp,-192
    80004cac:	fd06                	sd	ra,184(sp)
    80004cae:	f922                	sd	s0,176(sp)
    80004cb0:	f526                	sd	s1,168(sp)
    80004cb2:	f14a                	sd	s2,160(sp)
    80004cb4:	ed4e                	sd	s3,152(sp)
    80004cb6:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004cb8:	08000613          	li	a2,128
    80004cbc:	f5040593          	addi	a1,s0,-176
    80004cc0:	4501                	li	a0,0
    80004cc2:	ffffd097          	auipc	ra,0xffffd
    80004cc6:	41e080e7          	jalr	1054(ra) # 800020e0 <argstr>
    return -1;
    80004cca:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004ccc:	0c054163          	bltz	a0,80004d8e <sys_open+0xe4>
    80004cd0:	f4c40593          	addi	a1,s0,-180
    80004cd4:	4505                	li	a0,1
    80004cd6:	ffffd097          	auipc	ra,0xffffd
    80004cda:	3c6080e7          	jalr	966(ra) # 8000209c <argint>
    80004cde:	0a054863          	bltz	a0,80004d8e <sys_open+0xe4>

  begin_op();
    80004ce2:	fffff097          	auipc	ra,0xfffff
    80004ce6:	a06080e7          	jalr	-1530(ra) # 800036e8 <begin_op>

  if(omode & O_CREATE){
    80004cea:	f4c42783          	lw	a5,-180(s0)
    80004cee:	2007f793          	andi	a5,a5,512
    80004cf2:	cbdd                	beqz	a5,80004da8 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004cf4:	4681                	li	a3,0
    80004cf6:	4601                	li	a2,0
    80004cf8:	4589                	li	a1,2
    80004cfa:	f5040513          	addi	a0,s0,-176
    80004cfe:	00000097          	auipc	ra,0x0
    80004d02:	970080e7          	jalr	-1680(ra) # 8000466e <create>
    80004d06:	892a                	mv	s2,a0
    if(ip == 0){
    80004d08:	c959                	beqz	a0,80004d9e <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004d0a:	04491703          	lh	a4,68(s2)
    80004d0e:	478d                	li	a5,3
    80004d10:	00f71763          	bne	a4,a5,80004d1e <sys_open+0x74>
    80004d14:	04695703          	lhu	a4,70(s2)
    80004d18:	47a5                	li	a5,9
    80004d1a:	0ce7ec63          	bltu	a5,a4,80004df2 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004d1e:	fffff097          	auipc	ra,0xfffff
    80004d22:	dd6080e7          	jalr	-554(ra) # 80003af4 <filealloc>
    80004d26:	89aa                	mv	s3,a0
    80004d28:	10050263          	beqz	a0,80004e2c <sys_open+0x182>
    80004d2c:	00000097          	auipc	ra,0x0
    80004d30:	900080e7          	jalr	-1792(ra) # 8000462c <fdalloc>
    80004d34:	84aa                	mv	s1,a0
    80004d36:	0e054663          	bltz	a0,80004e22 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004d3a:	04491703          	lh	a4,68(s2)
    80004d3e:	478d                	li	a5,3
    80004d40:	0cf70463          	beq	a4,a5,80004e08 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004d44:	4789                	li	a5,2
    80004d46:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004d4a:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004d4e:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004d52:	f4c42783          	lw	a5,-180(s0)
    80004d56:	0017c713          	xori	a4,a5,1
    80004d5a:	8b05                	andi	a4,a4,1
    80004d5c:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004d60:	0037f713          	andi	a4,a5,3
    80004d64:	00e03733          	snez	a4,a4
    80004d68:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004d6c:	4007f793          	andi	a5,a5,1024
    80004d70:	c791                	beqz	a5,80004d7c <sys_open+0xd2>
    80004d72:	04491703          	lh	a4,68(s2)
    80004d76:	4789                	li	a5,2
    80004d78:	08f70f63          	beq	a4,a5,80004e16 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004d7c:	854a                	mv	a0,s2
    80004d7e:	ffffe097          	auipc	ra,0xffffe
    80004d82:	050080e7          	jalr	80(ra) # 80002dce <iunlock>
  end_op();
    80004d86:	fffff097          	auipc	ra,0xfffff
    80004d8a:	9e0080e7          	jalr	-1568(ra) # 80003766 <end_op>

  return fd;
}
    80004d8e:	8526                	mv	a0,s1
    80004d90:	70ea                	ld	ra,184(sp)
    80004d92:	744a                	ld	s0,176(sp)
    80004d94:	74aa                	ld	s1,168(sp)
    80004d96:	790a                	ld	s2,160(sp)
    80004d98:	69ea                	ld	s3,152(sp)
    80004d9a:	6129                	addi	sp,sp,192
    80004d9c:	8082                	ret
      end_op();
    80004d9e:	fffff097          	auipc	ra,0xfffff
    80004da2:	9c8080e7          	jalr	-1592(ra) # 80003766 <end_op>
      return -1;
    80004da6:	b7e5                	j	80004d8e <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004da8:	f5040513          	addi	a0,s0,-176
    80004dac:	ffffe097          	auipc	ra,0xffffe
    80004db0:	71c080e7          	jalr	1820(ra) # 800034c8 <namei>
    80004db4:	892a                	mv	s2,a0
    80004db6:	c905                	beqz	a0,80004de6 <sys_open+0x13c>
    ilock(ip);
    80004db8:	ffffe097          	auipc	ra,0xffffe
    80004dbc:	f54080e7          	jalr	-172(ra) # 80002d0c <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004dc0:	04491703          	lh	a4,68(s2)
    80004dc4:	4785                	li	a5,1
    80004dc6:	f4f712e3          	bne	a4,a5,80004d0a <sys_open+0x60>
    80004dca:	f4c42783          	lw	a5,-180(s0)
    80004dce:	dba1                	beqz	a5,80004d1e <sys_open+0x74>
      iunlockput(ip);
    80004dd0:	854a                	mv	a0,s2
    80004dd2:	ffffe097          	auipc	ra,0xffffe
    80004dd6:	19c080e7          	jalr	412(ra) # 80002f6e <iunlockput>
      end_op();
    80004dda:	fffff097          	auipc	ra,0xfffff
    80004dde:	98c080e7          	jalr	-1652(ra) # 80003766 <end_op>
      return -1;
    80004de2:	54fd                	li	s1,-1
    80004de4:	b76d                	j	80004d8e <sys_open+0xe4>
      end_op();
    80004de6:	fffff097          	auipc	ra,0xfffff
    80004dea:	980080e7          	jalr	-1664(ra) # 80003766 <end_op>
      return -1;
    80004dee:	54fd                	li	s1,-1
    80004df0:	bf79                	j	80004d8e <sys_open+0xe4>
    iunlockput(ip);
    80004df2:	854a                	mv	a0,s2
    80004df4:	ffffe097          	auipc	ra,0xffffe
    80004df8:	17a080e7          	jalr	378(ra) # 80002f6e <iunlockput>
    end_op();
    80004dfc:	fffff097          	auipc	ra,0xfffff
    80004e00:	96a080e7          	jalr	-1686(ra) # 80003766 <end_op>
    return -1;
    80004e04:	54fd                	li	s1,-1
    80004e06:	b761                	j	80004d8e <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004e08:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004e0c:	04691783          	lh	a5,70(s2)
    80004e10:	02f99223          	sh	a5,36(s3)
    80004e14:	bf2d                	j	80004d4e <sys_open+0xa4>
    itrunc(ip);
    80004e16:	854a                	mv	a0,s2
    80004e18:	ffffe097          	auipc	ra,0xffffe
    80004e1c:	002080e7          	jalr	2(ra) # 80002e1a <itrunc>
    80004e20:	bfb1                	j	80004d7c <sys_open+0xd2>
      fileclose(f);
    80004e22:	854e                	mv	a0,s3
    80004e24:	fffff097          	auipc	ra,0xfffff
    80004e28:	d8c080e7          	jalr	-628(ra) # 80003bb0 <fileclose>
    iunlockput(ip);
    80004e2c:	854a                	mv	a0,s2
    80004e2e:	ffffe097          	auipc	ra,0xffffe
    80004e32:	140080e7          	jalr	320(ra) # 80002f6e <iunlockput>
    end_op();
    80004e36:	fffff097          	auipc	ra,0xfffff
    80004e3a:	930080e7          	jalr	-1744(ra) # 80003766 <end_op>
    return -1;
    80004e3e:	54fd                	li	s1,-1
    80004e40:	b7b9                	j	80004d8e <sys_open+0xe4>

0000000080004e42 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004e42:	7175                	addi	sp,sp,-144
    80004e44:	e506                	sd	ra,136(sp)
    80004e46:	e122                	sd	s0,128(sp)
    80004e48:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004e4a:	fffff097          	auipc	ra,0xfffff
    80004e4e:	89e080e7          	jalr	-1890(ra) # 800036e8 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004e52:	08000613          	li	a2,128
    80004e56:	f7040593          	addi	a1,s0,-144
    80004e5a:	4501                	li	a0,0
    80004e5c:	ffffd097          	auipc	ra,0xffffd
    80004e60:	284080e7          	jalr	644(ra) # 800020e0 <argstr>
    80004e64:	02054963          	bltz	a0,80004e96 <sys_mkdir+0x54>
    80004e68:	4681                	li	a3,0
    80004e6a:	4601                	li	a2,0
    80004e6c:	4585                	li	a1,1
    80004e6e:	f7040513          	addi	a0,s0,-144
    80004e72:	fffff097          	auipc	ra,0xfffff
    80004e76:	7fc080e7          	jalr	2044(ra) # 8000466e <create>
    80004e7a:	cd11                	beqz	a0,80004e96 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e7c:	ffffe097          	auipc	ra,0xffffe
    80004e80:	0f2080e7          	jalr	242(ra) # 80002f6e <iunlockput>
  end_op();
    80004e84:	fffff097          	auipc	ra,0xfffff
    80004e88:	8e2080e7          	jalr	-1822(ra) # 80003766 <end_op>
  return 0;
    80004e8c:	4501                	li	a0,0
}
    80004e8e:	60aa                	ld	ra,136(sp)
    80004e90:	640a                	ld	s0,128(sp)
    80004e92:	6149                	addi	sp,sp,144
    80004e94:	8082                	ret
    end_op();
    80004e96:	fffff097          	auipc	ra,0xfffff
    80004e9a:	8d0080e7          	jalr	-1840(ra) # 80003766 <end_op>
    return -1;
    80004e9e:	557d                	li	a0,-1
    80004ea0:	b7fd                	j	80004e8e <sys_mkdir+0x4c>

0000000080004ea2 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004ea2:	7135                	addi	sp,sp,-160
    80004ea4:	ed06                	sd	ra,152(sp)
    80004ea6:	e922                	sd	s0,144(sp)
    80004ea8:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004eaa:	fffff097          	auipc	ra,0xfffff
    80004eae:	83e080e7          	jalr	-1986(ra) # 800036e8 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004eb2:	08000613          	li	a2,128
    80004eb6:	f7040593          	addi	a1,s0,-144
    80004eba:	4501                	li	a0,0
    80004ebc:	ffffd097          	auipc	ra,0xffffd
    80004ec0:	224080e7          	jalr	548(ra) # 800020e0 <argstr>
    80004ec4:	04054a63          	bltz	a0,80004f18 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004ec8:	f6c40593          	addi	a1,s0,-148
    80004ecc:	4505                	li	a0,1
    80004ece:	ffffd097          	auipc	ra,0xffffd
    80004ed2:	1ce080e7          	jalr	462(ra) # 8000209c <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004ed6:	04054163          	bltz	a0,80004f18 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004eda:	f6840593          	addi	a1,s0,-152
    80004ede:	4509                	li	a0,2
    80004ee0:	ffffd097          	auipc	ra,0xffffd
    80004ee4:	1bc080e7          	jalr	444(ra) # 8000209c <argint>
     argint(1, &major) < 0 ||
    80004ee8:	02054863          	bltz	a0,80004f18 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004eec:	f6841683          	lh	a3,-152(s0)
    80004ef0:	f6c41603          	lh	a2,-148(s0)
    80004ef4:	458d                	li	a1,3
    80004ef6:	f7040513          	addi	a0,s0,-144
    80004efa:	fffff097          	auipc	ra,0xfffff
    80004efe:	774080e7          	jalr	1908(ra) # 8000466e <create>
     argint(2, &minor) < 0 ||
    80004f02:	c919                	beqz	a0,80004f18 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f04:	ffffe097          	auipc	ra,0xffffe
    80004f08:	06a080e7          	jalr	106(ra) # 80002f6e <iunlockput>
  end_op();
    80004f0c:	fffff097          	auipc	ra,0xfffff
    80004f10:	85a080e7          	jalr	-1958(ra) # 80003766 <end_op>
  return 0;
    80004f14:	4501                	li	a0,0
    80004f16:	a031                	j	80004f22 <sys_mknod+0x80>
    end_op();
    80004f18:	fffff097          	auipc	ra,0xfffff
    80004f1c:	84e080e7          	jalr	-1970(ra) # 80003766 <end_op>
    return -1;
    80004f20:	557d                	li	a0,-1
}
    80004f22:	60ea                	ld	ra,152(sp)
    80004f24:	644a                	ld	s0,144(sp)
    80004f26:	610d                	addi	sp,sp,160
    80004f28:	8082                	ret

0000000080004f2a <sys_chdir>:

uint64
sys_chdir(void)
{
    80004f2a:	7135                	addi	sp,sp,-160
    80004f2c:	ed06                	sd	ra,152(sp)
    80004f2e:	e922                	sd	s0,144(sp)
    80004f30:	e526                	sd	s1,136(sp)
    80004f32:	e14a                	sd	s2,128(sp)
    80004f34:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004f36:	ffffc097          	auipc	ra,0xffffc
    80004f3a:	000080e7          	jalr	ra # 80000f36 <myproc>
    80004f3e:	892a                	mv	s2,a0
  
  begin_op();
    80004f40:	ffffe097          	auipc	ra,0xffffe
    80004f44:	7a8080e7          	jalr	1960(ra) # 800036e8 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004f48:	08000613          	li	a2,128
    80004f4c:	f6040593          	addi	a1,s0,-160
    80004f50:	4501                	li	a0,0
    80004f52:	ffffd097          	auipc	ra,0xffffd
    80004f56:	18e080e7          	jalr	398(ra) # 800020e0 <argstr>
    80004f5a:	04054b63          	bltz	a0,80004fb0 <sys_chdir+0x86>
    80004f5e:	f6040513          	addi	a0,s0,-160
    80004f62:	ffffe097          	auipc	ra,0xffffe
    80004f66:	566080e7          	jalr	1382(ra) # 800034c8 <namei>
    80004f6a:	84aa                	mv	s1,a0
    80004f6c:	c131                	beqz	a0,80004fb0 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004f6e:	ffffe097          	auipc	ra,0xffffe
    80004f72:	d9e080e7          	jalr	-610(ra) # 80002d0c <ilock>
  if(ip->type != T_DIR){
    80004f76:	04449703          	lh	a4,68(s1)
    80004f7a:	4785                	li	a5,1
    80004f7c:	04f71063          	bne	a4,a5,80004fbc <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004f80:	8526                	mv	a0,s1
    80004f82:	ffffe097          	auipc	ra,0xffffe
    80004f86:	e4c080e7          	jalr	-436(ra) # 80002dce <iunlock>
  iput(p->cwd);
    80004f8a:	15893503          	ld	a0,344(s2)
    80004f8e:	ffffe097          	auipc	ra,0xffffe
    80004f92:	f38080e7          	jalr	-200(ra) # 80002ec6 <iput>
  end_op();
    80004f96:	ffffe097          	auipc	ra,0xffffe
    80004f9a:	7d0080e7          	jalr	2000(ra) # 80003766 <end_op>
  p->cwd = ip;
    80004f9e:	14993c23          	sd	s1,344(s2)
  return 0;
    80004fa2:	4501                	li	a0,0
}
    80004fa4:	60ea                	ld	ra,152(sp)
    80004fa6:	644a                	ld	s0,144(sp)
    80004fa8:	64aa                	ld	s1,136(sp)
    80004faa:	690a                	ld	s2,128(sp)
    80004fac:	610d                	addi	sp,sp,160
    80004fae:	8082                	ret
    end_op();
    80004fb0:	ffffe097          	auipc	ra,0xffffe
    80004fb4:	7b6080e7          	jalr	1974(ra) # 80003766 <end_op>
    return -1;
    80004fb8:	557d                	li	a0,-1
    80004fba:	b7ed                	j	80004fa4 <sys_chdir+0x7a>
    iunlockput(ip);
    80004fbc:	8526                	mv	a0,s1
    80004fbe:	ffffe097          	auipc	ra,0xffffe
    80004fc2:	fb0080e7          	jalr	-80(ra) # 80002f6e <iunlockput>
    end_op();
    80004fc6:	ffffe097          	auipc	ra,0xffffe
    80004fca:	7a0080e7          	jalr	1952(ra) # 80003766 <end_op>
    return -1;
    80004fce:	557d                	li	a0,-1
    80004fd0:	bfd1                	j	80004fa4 <sys_chdir+0x7a>

0000000080004fd2 <sys_exec>:

uint64
sys_exec(void)
{
    80004fd2:	7145                	addi	sp,sp,-464
    80004fd4:	e786                	sd	ra,456(sp)
    80004fd6:	e3a2                	sd	s0,448(sp)
    80004fd8:	ff26                	sd	s1,440(sp)
    80004fda:	fb4a                	sd	s2,432(sp)
    80004fdc:	f74e                	sd	s3,424(sp)
    80004fde:	f352                	sd	s4,416(sp)
    80004fe0:	ef56                	sd	s5,408(sp)
    80004fe2:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004fe4:	08000613          	li	a2,128
    80004fe8:	f4040593          	addi	a1,s0,-192
    80004fec:	4501                	li	a0,0
    80004fee:	ffffd097          	auipc	ra,0xffffd
    80004ff2:	0f2080e7          	jalr	242(ra) # 800020e0 <argstr>
    return -1;
    80004ff6:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004ff8:	0c054b63          	bltz	a0,800050ce <sys_exec+0xfc>
    80004ffc:	e3840593          	addi	a1,s0,-456
    80005000:	4505                	li	a0,1
    80005002:	ffffd097          	auipc	ra,0xffffd
    80005006:	0bc080e7          	jalr	188(ra) # 800020be <argaddr>
    8000500a:	0c054263          	bltz	a0,800050ce <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    8000500e:	10000613          	li	a2,256
    80005012:	4581                	li	a1,0
    80005014:	e4040513          	addi	a0,s0,-448
    80005018:	ffffb097          	auipc	ra,0xffffb
    8000501c:	162080e7          	jalr	354(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005020:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005024:	89a6                	mv	s3,s1
    80005026:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005028:	02000a13          	li	s4,32
    8000502c:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005030:	00391513          	slli	a0,s2,0x3
    80005034:	e3040593          	addi	a1,s0,-464
    80005038:	e3843783          	ld	a5,-456(s0)
    8000503c:	953e                	add	a0,a0,a5
    8000503e:	ffffd097          	auipc	ra,0xffffd
    80005042:	fc4080e7          	jalr	-60(ra) # 80002002 <fetchaddr>
    80005046:	02054a63          	bltz	a0,8000507a <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    8000504a:	e3043783          	ld	a5,-464(s0)
    8000504e:	c3b9                	beqz	a5,80005094 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005050:	ffffb097          	auipc	ra,0xffffb
    80005054:	0ca080e7          	jalr	202(ra) # 8000011a <kalloc>
    80005058:	85aa                	mv	a1,a0
    8000505a:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000505e:	cd11                	beqz	a0,8000507a <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005060:	6605                	lui	a2,0x1
    80005062:	e3043503          	ld	a0,-464(s0)
    80005066:	ffffd097          	auipc	ra,0xffffd
    8000506a:	fee080e7          	jalr	-18(ra) # 80002054 <fetchstr>
    8000506e:	00054663          	bltz	a0,8000507a <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80005072:	0905                	addi	s2,s2,1
    80005074:	09a1                	addi	s3,s3,8
    80005076:	fb491be3          	bne	s2,s4,8000502c <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000507a:	f4040913          	addi	s2,s0,-192
    8000507e:	6088                	ld	a0,0(s1)
    80005080:	c531                	beqz	a0,800050cc <sys_exec+0xfa>
    kfree(argv[i]);
    80005082:	ffffb097          	auipc	ra,0xffffb
    80005086:	f9a080e7          	jalr	-102(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000508a:	04a1                	addi	s1,s1,8
    8000508c:	ff2499e3          	bne	s1,s2,8000507e <sys_exec+0xac>
  return -1;
    80005090:	597d                	li	s2,-1
    80005092:	a835                	j	800050ce <sys_exec+0xfc>
      argv[i] = 0;
    80005094:	0a8e                	slli	s5,s5,0x3
    80005096:	fc0a8793          	addi	a5,s5,-64 # ffffffffffffefc0 <end+0xffffffff7ffd8d80>
    8000509a:	00878ab3          	add	s5,a5,s0
    8000509e:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    800050a2:	e4040593          	addi	a1,s0,-448
    800050a6:	f4040513          	addi	a0,s0,-192
    800050aa:	fffff097          	auipc	ra,0xfffff
    800050ae:	15a080e7          	jalr	346(ra) # 80004204 <exec>
    800050b2:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050b4:	f4040993          	addi	s3,s0,-192
    800050b8:	6088                	ld	a0,0(s1)
    800050ba:	c911                	beqz	a0,800050ce <sys_exec+0xfc>
    kfree(argv[i]);
    800050bc:	ffffb097          	auipc	ra,0xffffb
    800050c0:	f60080e7          	jalr	-160(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050c4:	04a1                	addi	s1,s1,8
    800050c6:	ff3499e3          	bne	s1,s3,800050b8 <sys_exec+0xe6>
    800050ca:	a011                	j	800050ce <sys_exec+0xfc>
  return -1;
    800050cc:	597d                	li	s2,-1
}
    800050ce:	854a                	mv	a0,s2
    800050d0:	60be                	ld	ra,456(sp)
    800050d2:	641e                	ld	s0,448(sp)
    800050d4:	74fa                	ld	s1,440(sp)
    800050d6:	795a                	ld	s2,432(sp)
    800050d8:	79ba                	ld	s3,424(sp)
    800050da:	7a1a                	ld	s4,416(sp)
    800050dc:	6afa                	ld	s5,408(sp)
    800050de:	6179                	addi	sp,sp,464
    800050e0:	8082                	ret

00000000800050e2 <sys_pipe>:

uint64
sys_pipe(void)
{
    800050e2:	7139                	addi	sp,sp,-64
    800050e4:	fc06                	sd	ra,56(sp)
    800050e6:	f822                	sd	s0,48(sp)
    800050e8:	f426                	sd	s1,40(sp)
    800050ea:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800050ec:	ffffc097          	auipc	ra,0xffffc
    800050f0:	e4a080e7          	jalr	-438(ra) # 80000f36 <myproc>
    800050f4:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    800050f6:	fd840593          	addi	a1,s0,-40
    800050fa:	4501                	li	a0,0
    800050fc:	ffffd097          	auipc	ra,0xffffd
    80005100:	fc2080e7          	jalr	-62(ra) # 800020be <argaddr>
    return -1;
    80005104:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005106:	0e054063          	bltz	a0,800051e6 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    8000510a:	fc840593          	addi	a1,s0,-56
    8000510e:	fd040513          	addi	a0,s0,-48
    80005112:	fffff097          	auipc	ra,0xfffff
    80005116:	dce080e7          	jalr	-562(ra) # 80003ee0 <pipealloc>
    return -1;
    8000511a:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    8000511c:	0c054563          	bltz	a0,800051e6 <sys_pipe+0x104>
  fd0 = -1;
    80005120:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005124:	fd043503          	ld	a0,-48(s0)
    80005128:	fffff097          	auipc	ra,0xfffff
    8000512c:	504080e7          	jalr	1284(ra) # 8000462c <fdalloc>
    80005130:	fca42223          	sw	a0,-60(s0)
    80005134:	08054c63          	bltz	a0,800051cc <sys_pipe+0xea>
    80005138:	fc843503          	ld	a0,-56(s0)
    8000513c:	fffff097          	auipc	ra,0xfffff
    80005140:	4f0080e7          	jalr	1264(ra) # 8000462c <fdalloc>
    80005144:	fca42023          	sw	a0,-64(s0)
    80005148:	06054963          	bltz	a0,800051ba <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000514c:	4691                	li	a3,4
    8000514e:	fc440613          	addi	a2,s0,-60
    80005152:	fd843583          	ld	a1,-40(s0)
    80005156:	6ca8                	ld	a0,88(s1)
    80005158:	ffffc097          	auipc	ra,0xffffc
    8000515c:	9b0080e7          	jalr	-1616(ra) # 80000b08 <copyout>
    80005160:	02054063          	bltz	a0,80005180 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005164:	4691                	li	a3,4
    80005166:	fc040613          	addi	a2,s0,-64
    8000516a:	fd843583          	ld	a1,-40(s0)
    8000516e:	0591                	addi	a1,a1,4
    80005170:	6ca8                	ld	a0,88(s1)
    80005172:	ffffc097          	auipc	ra,0xffffc
    80005176:	996080e7          	jalr	-1642(ra) # 80000b08 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000517a:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000517c:	06055563          	bgez	a0,800051e6 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005180:	fc442783          	lw	a5,-60(s0)
    80005184:	07e9                	addi	a5,a5,26
    80005186:	078e                	slli	a5,a5,0x3
    80005188:	97a6                	add	a5,a5,s1
    8000518a:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    8000518e:	fc042783          	lw	a5,-64(s0)
    80005192:	07e9                	addi	a5,a5,26
    80005194:	078e                	slli	a5,a5,0x3
    80005196:	00f48533          	add	a0,s1,a5
    8000519a:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    8000519e:	fd043503          	ld	a0,-48(s0)
    800051a2:	fffff097          	auipc	ra,0xfffff
    800051a6:	a0e080e7          	jalr	-1522(ra) # 80003bb0 <fileclose>
    fileclose(wf);
    800051aa:	fc843503          	ld	a0,-56(s0)
    800051ae:	fffff097          	auipc	ra,0xfffff
    800051b2:	a02080e7          	jalr	-1534(ra) # 80003bb0 <fileclose>
    return -1;
    800051b6:	57fd                	li	a5,-1
    800051b8:	a03d                	j	800051e6 <sys_pipe+0x104>
    if(fd0 >= 0)
    800051ba:	fc442783          	lw	a5,-60(s0)
    800051be:	0007c763          	bltz	a5,800051cc <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    800051c2:	07e9                	addi	a5,a5,26
    800051c4:	078e                	slli	a5,a5,0x3
    800051c6:	97a6                	add	a5,a5,s1
    800051c8:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    800051cc:	fd043503          	ld	a0,-48(s0)
    800051d0:	fffff097          	auipc	ra,0xfffff
    800051d4:	9e0080e7          	jalr	-1568(ra) # 80003bb0 <fileclose>
    fileclose(wf);
    800051d8:	fc843503          	ld	a0,-56(s0)
    800051dc:	fffff097          	auipc	ra,0xfffff
    800051e0:	9d4080e7          	jalr	-1580(ra) # 80003bb0 <fileclose>
    return -1;
    800051e4:	57fd                	li	a5,-1
}
    800051e6:	853e                	mv	a0,a5
    800051e8:	70e2                	ld	ra,56(sp)
    800051ea:	7442                	ld	s0,48(sp)
    800051ec:	74a2                	ld	s1,40(sp)
    800051ee:	6121                	addi	sp,sp,64
    800051f0:	8082                	ret
	...

0000000080005200 <kernelvec>:
    80005200:	7111                	addi	sp,sp,-256
    80005202:	e006                	sd	ra,0(sp)
    80005204:	e40a                	sd	sp,8(sp)
    80005206:	e80e                	sd	gp,16(sp)
    80005208:	ec12                	sd	tp,24(sp)
    8000520a:	f016                	sd	t0,32(sp)
    8000520c:	f41a                	sd	t1,40(sp)
    8000520e:	f81e                	sd	t2,48(sp)
    80005210:	fc22                	sd	s0,56(sp)
    80005212:	e0a6                	sd	s1,64(sp)
    80005214:	e4aa                	sd	a0,72(sp)
    80005216:	e8ae                	sd	a1,80(sp)
    80005218:	ecb2                	sd	a2,88(sp)
    8000521a:	f0b6                	sd	a3,96(sp)
    8000521c:	f4ba                	sd	a4,104(sp)
    8000521e:	f8be                	sd	a5,112(sp)
    80005220:	fcc2                	sd	a6,120(sp)
    80005222:	e146                	sd	a7,128(sp)
    80005224:	e54a                	sd	s2,136(sp)
    80005226:	e94e                	sd	s3,144(sp)
    80005228:	ed52                	sd	s4,152(sp)
    8000522a:	f156                	sd	s5,160(sp)
    8000522c:	f55a                	sd	s6,168(sp)
    8000522e:	f95e                	sd	s7,176(sp)
    80005230:	fd62                	sd	s8,184(sp)
    80005232:	e1e6                	sd	s9,192(sp)
    80005234:	e5ea                	sd	s10,200(sp)
    80005236:	e9ee                	sd	s11,208(sp)
    80005238:	edf2                	sd	t3,216(sp)
    8000523a:	f1f6                	sd	t4,224(sp)
    8000523c:	f5fa                	sd	t5,232(sp)
    8000523e:	f9fe                	sd	t6,240(sp)
    80005240:	c8ffc0ef          	jal	ra,80001ece <kerneltrap>
    80005244:	6082                	ld	ra,0(sp)
    80005246:	6122                	ld	sp,8(sp)
    80005248:	61c2                	ld	gp,16(sp)
    8000524a:	7282                	ld	t0,32(sp)
    8000524c:	7322                	ld	t1,40(sp)
    8000524e:	73c2                	ld	t2,48(sp)
    80005250:	7462                	ld	s0,56(sp)
    80005252:	6486                	ld	s1,64(sp)
    80005254:	6526                	ld	a0,72(sp)
    80005256:	65c6                	ld	a1,80(sp)
    80005258:	6666                	ld	a2,88(sp)
    8000525a:	7686                	ld	a3,96(sp)
    8000525c:	7726                	ld	a4,104(sp)
    8000525e:	77c6                	ld	a5,112(sp)
    80005260:	7866                	ld	a6,120(sp)
    80005262:	688a                	ld	a7,128(sp)
    80005264:	692a                	ld	s2,136(sp)
    80005266:	69ca                	ld	s3,144(sp)
    80005268:	6a6a                	ld	s4,152(sp)
    8000526a:	7a8a                	ld	s5,160(sp)
    8000526c:	7b2a                	ld	s6,168(sp)
    8000526e:	7bca                	ld	s7,176(sp)
    80005270:	7c6a                	ld	s8,184(sp)
    80005272:	6c8e                	ld	s9,192(sp)
    80005274:	6d2e                	ld	s10,200(sp)
    80005276:	6dce                	ld	s11,208(sp)
    80005278:	6e6e                	ld	t3,216(sp)
    8000527a:	7e8e                	ld	t4,224(sp)
    8000527c:	7f2e                	ld	t5,232(sp)
    8000527e:	7fce                	ld	t6,240(sp)
    80005280:	6111                	addi	sp,sp,256
    80005282:	10200073          	sret
    80005286:	00000013          	nop
    8000528a:	00000013          	nop
    8000528e:	0001                	nop

0000000080005290 <timervec>:
    80005290:	34051573          	csrrw	a0,mscratch,a0
    80005294:	e10c                	sd	a1,0(a0)
    80005296:	e510                	sd	a2,8(a0)
    80005298:	e914                	sd	a3,16(a0)
    8000529a:	6d0c                	ld	a1,24(a0)
    8000529c:	7110                	ld	a2,32(a0)
    8000529e:	6194                	ld	a3,0(a1)
    800052a0:	96b2                	add	a3,a3,a2
    800052a2:	e194                	sd	a3,0(a1)
    800052a4:	4589                	li	a1,2
    800052a6:	14459073          	csrw	sip,a1
    800052aa:	6914                	ld	a3,16(a0)
    800052ac:	6510                	ld	a2,8(a0)
    800052ae:	610c                	ld	a1,0(a0)
    800052b0:	34051573          	csrrw	a0,mscratch,a0
    800052b4:	30200073          	mret
	...

00000000800052ba <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800052ba:	1141                	addi	sp,sp,-16
    800052bc:	e422                	sd	s0,8(sp)
    800052be:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800052c0:	0c0007b7          	lui	a5,0xc000
    800052c4:	4705                	li	a4,1
    800052c6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800052c8:	c3d8                	sw	a4,4(a5)
}
    800052ca:	6422                	ld	s0,8(sp)
    800052cc:	0141                	addi	sp,sp,16
    800052ce:	8082                	ret

00000000800052d0 <plicinithart>:

void
plicinithart(void)
{
    800052d0:	1141                	addi	sp,sp,-16
    800052d2:	e406                	sd	ra,8(sp)
    800052d4:	e022                	sd	s0,0(sp)
    800052d6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800052d8:	ffffc097          	auipc	ra,0xffffc
    800052dc:	c32080e7          	jalr	-974(ra) # 80000f0a <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800052e0:	0085171b          	slliw	a4,a0,0x8
    800052e4:	0c0027b7          	lui	a5,0xc002
    800052e8:	97ba                	add	a5,a5,a4
    800052ea:	40200713          	li	a4,1026
    800052ee:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800052f2:	00d5151b          	slliw	a0,a0,0xd
    800052f6:	0c2017b7          	lui	a5,0xc201
    800052fa:	97aa                	add	a5,a5,a0
    800052fc:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005300:	60a2                	ld	ra,8(sp)
    80005302:	6402                	ld	s0,0(sp)
    80005304:	0141                	addi	sp,sp,16
    80005306:	8082                	ret

0000000080005308 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005308:	1141                	addi	sp,sp,-16
    8000530a:	e406                	sd	ra,8(sp)
    8000530c:	e022                	sd	s0,0(sp)
    8000530e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005310:	ffffc097          	auipc	ra,0xffffc
    80005314:	bfa080e7          	jalr	-1030(ra) # 80000f0a <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005318:	00d5151b          	slliw	a0,a0,0xd
    8000531c:	0c2017b7          	lui	a5,0xc201
    80005320:	97aa                	add	a5,a5,a0
  return irq;
}
    80005322:	43c8                	lw	a0,4(a5)
    80005324:	60a2                	ld	ra,8(sp)
    80005326:	6402                	ld	s0,0(sp)
    80005328:	0141                	addi	sp,sp,16
    8000532a:	8082                	ret

000000008000532c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000532c:	1101                	addi	sp,sp,-32
    8000532e:	ec06                	sd	ra,24(sp)
    80005330:	e822                	sd	s0,16(sp)
    80005332:	e426                	sd	s1,8(sp)
    80005334:	1000                	addi	s0,sp,32
    80005336:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005338:	ffffc097          	auipc	ra,0xffffc
    8000533c:	bd2080e7          	jalr	-1070(ra) # 80000f0a <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005340:	00d5151b          	slliw	a0,a0,0xd
    80005344:	0c2017b7          	lui	a5,0xc201
    80005348:	97aa                	add	a5,a5,a0
    8000534a:	c3c4                	sw	s1,4(a5)
}
    8000534c:	60e2                	ld	ra,24(sp)
    8000534e:	6442                	ld	s0,16(sp)
    80005350:	64a2                	ld	s1,8(sp)
    80005352:	6105                	addi	sp,sp,32
    80005354:	8082                	ret

0000000080005356 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005356:	1141                	addi	sp,sp,-16
    80005358:	e406                	sd	ra,8(sp)
    8000535a:	e022                	sd	s0,0(sp)
    8000535c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000535e:	479d                	li	a5,7
    80005360:	06a7c863          	blt	a5,a0,800053d0 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    80005364:	00016717          	auipc	a4,0x16
    80005368:	c9c70713          	addi	a4,a4,-868 # 8001b000 <disk>
    8000536c:	972a                	add	a4,a4,a0
    8000536e:	6789                	lui	a5,0x2
    80005370:	97ba                	add	a5,a5,a4
    80005372:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005376:	e7ad                	bnez	a5,800053e0 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005378:	00451793          	slli	a5,a0,0x4
    8000537c:	00018717          	auipc	a4,0x18
    80005380:	c8470713          	addi	a4,a4,-892 # 8001d000 <disk+0x2000>
    80005384:	6314                	ld	a3,0(a4)
    80005386:	96be                	add	a3,a3,a5
    80005388:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    8000538c:	6314                	ld	a3,0(a4)
    8000538e:	96be                	add	a3,a3,a5
    80005390:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005394:	6314                	ld	a3,0(a4)
    80005396:	96be                	add	a3,a3,a5
    80005398:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000539c:	6318                	ld	a4,0(a4)
    8000539e:	97ba                	add	a5,a5,a4
    800053a0:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    800053a4:	00016717          	auipc	a4,0x16
    800053a8:	c5c70713          	addi	a4,a4,-932 # 8001b000 <disk>
    800053ac:	972a                	add	a4,a4,a0
    800053ae:	6789                	lui	a5,0x2
    800053b0:	97ba                	add	a5,a5,a4
    800053b2:	4705                	li	a4,1
    800053b4:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    800053b8:	00018517          	auipc	a0,0x18
    800053bc:	c6050513          	addi	a0,a0,-928 # 8001d018 <disk+0x2018>
    800053c0:	ffffc097          	auipc	ra,0xffffc
    800053c4:	476080e7          	jalr	1142(ra) # 80001836 <wakeup>
}
    800053c8:	60a2                	ld	ra,8(sp)
    800053ca:	6402                	ld	s0,0(sp)
    800053cc:	0141                	addi	sp,sp,16
    800053ce:	8082                	ret
    panic("free_desc 1");
    800053d0:	00003517          	auipc	a0,0x3
    800053d4:	3d850513          	addi	a0,a0,984 # 800087a8 <syscalls+0x380>
    800053d8:	00001097          	auipc	ra,0x1
    800053dc:	9c8080e7          	jalr	-1592(ra) # 80005da0 <panic>
    panic("free_desc 2");
    800053e0:	00003517          	auipc	a0,0x3
    800053e4:	3d850513          	addi	a0,a0,984 # 800087b8 <syscalls+0x390>
    800053e8:	00001097          	auipc	ra,0x1
    800053ec:	9b8080e7          	jalr	-1608(ra) # 80005da0 <panic>

00000000800053f0 <virtio_disk_init>:
{
    800053f0:	1101                	addi	sp,sp,-32
    800053f2:	ec06                	sd	ra,24(sp)
    800053f4:	e822                	sd	s0,16(sp)
    800053f6:	e426                	sd	s1,8(sp)
    800053f8:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800053fa:	00003597          	auipc	a1,0x3
    800053fe:	3ce58593          	addi	a1,a1,974 # 800087c8 <syscalls+0x3a0>
    80005402:	00018517          	auipc	a0,0x18
    80005406:	d2650513          	addi	a0,a0,-730 # 8001d128 <disk+0x2128>
    8000540a:	00001097          	auipc	ra,0x1
    8000540e:	e3e080e7          	jalr	-450(ra) # 80006248 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005412:	100017b7          	lui	a5,0x10001
    80005416:	4398                	lw	a4,0(a5)
    80005418:	2701                	sext.w	a4,a4
    8000541a:	747277b7          	lui	a5,0x74727
    8000541e:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005422:	0ef71063          	bne	a4,a5,80005502 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005426:	100017b7          	lui	a5,0x10001
    8000542a:	43dc                	lw	a5,4(a5)
    8000542c:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000542e:	4705                	li	a4,1
    80005430:	0ce79963          	bne	a5,a4,80005502 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005434:	100017b7          	lui	a5,0x10001
    80005438:	479c                	lw	a5,8(a5)
    8000543a:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000543c:	4709                	li	a4,2
    8000543e:	0ce79263          	bne	a5,a4,80005502 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005442:	100017b7          	lui	a5,0x10001
    80005446:	47d8                	lw	a4,12(a5)
    80005448:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000544a:	554d47b7          	lui	a5,0x554d4
    8000544e:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005452:	0af71863          	bne	a4,a5,80005502 <virtio_disk_init+0x112>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005456:	100017b7          	lui	a5,0x10001
    8000545a:	4705                	li	a4,1
    8000545c:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000545e:	470d                	li	a4,3
    80005460:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005462:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005464:	c7ffe6b7          	lui	a3,0xc7ffe
    80005468:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
    8000546c:	8f75                	and	a4,a4,a3
    8000546e:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005470:	472d                	li	a4,11
    80005472:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005474:	473d                	li	a4,15
    80005476:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005478:	6705                	lui	a4,0x1
    8000547a:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000547c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005480:	5bdc                	lw	a5,52(a5)
    80005482:	2781                	sext.w	a5,a5
  if(max == 0)
    80005484:	c7d9                	beqz	a5,80005512 <virtio_disk_init+0x122>
  if(max < NUM)
    80005486:	471d                	li	a4,7
    80005488:	08f77d63          	bgeu	a4,a5,80005522 <virtio_disk_init+0x132>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000548c:	100014b7          	lui	s1,0x10001
    80005490:	47a1                	li	a5,8
    80005492:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005494:	6609                	lui	a2,0x2
    80005496:	4581                	li	a1,0
    80005498:	00016517          	auipc	a0,0x16
    8000549c:	b6850513          	addi	a0,a0,-1176 # 8001b000 <disk>
    800054a0:	ffffb097          	auipc	ra,0xffffb
    800054a4:	cda080e7          	jalr	-806(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    800054a8:	00016717          	auipc	a4,0x16
    800054ac:	b5870713          	addi	a4,a4,-1192 # 8001b000 <disk>
    800054b0:	00c75793          	srli	a5,a4,0xc
    800054b4:	2781                	sext.w	a5,a5
    800054b6:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    800054b8:	00018797          	auipc	a5,0x18
    800054bc:	b4878793          	addi	a5,a5,-1208 # 8001d000 <disk+0x2000>
    800054c0:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    800054c2:	00016717          	auipc	a4,0x16
    800054c6:	bbe70713          	addi	a4,a4,-1090 # 8001b080 <disk+0x80>
    800054ca:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    800054cc:	00017717          	auipc	a4,0x17
    800054d0:	b3470713          	addi	a4,a4,-1228 # 8001c000 <disk+0x1000>
    800054d4:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    800054d6:	4705                	li	a4,1
    800054d8:	00e78c23          	sb	a4,24(a5)
    800054dc:	00e78ca3          	sb	a4,25(a5)
    800054e0:	00e78d23          	sb	a4,26(a5)
    800054e4:	00e78da3          	sb	a4,27(a5)
    800054e8:	00e78e23          	sb	a4,28(a5)
    800054ec:	00e78ea3          	sb	a4,29(a5)
    800054f0:	00e78f23          	sb	a4,30(a5)
    800054f4:	00e78fa3          	sb	a4,31(a5)
}
    800054f8:	60e2                	ld	ra,24(sp)
    800054fa:	6442                	ld	s0,16(sp)
    800054fc:	64a2                	ld	s1,8(sp)
    800054fe:	6105                	addi	sp,sp,32
    80005500:	8082                	ret
    panic("could not find virtio disk");
    80005502:	00003517          	auipc	a0,0x3
    80005506:	2d650513          	addi	a0,a0,726 # 800087d8 <syscalls+0x3b0>
    8000550a:	00001097          	auipc	ra,0x1
    8000550e:	896080e7          	jalr	-1898(ra) # 80005da0 <panic>
    panic("virtio disk has no queue 0");
    80005512:	00003517          	auipc	a0,0x3
    80005516:	2e650513          	addi	a0,a0,742 # 800087f8 <syscalls+0x3d0>
    8000551a:	00001097          	auipc	ra,0x1
    8000551e:	886080e7          	jalr	-1914(ra) # 80005da0 <panic>
    panic("virtio disk max queue too short");
    80005522:	00003517          	auipc	a0,0x3
    80005526:	2f650513          	addi	a0,a0,758 # 80008818 <syscalls+0x3f0>
    8000552a:	00001097          	auipc	ra,0x1
    8000552e:	876080e7          	jalr	-1930(ra) # 80005da0 <panic>

0000000080005532 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005532:	7119                	addi	sp,sp,-128
    80005534:	fc86                	sd	ra,120(sp)
    80005536:	f8a2                	sd	s0,112(sp)
    80005538:	f4a6                	sd	s1,104(sp)
    8000553a:	f0ca                	sd	s2,96(sp)
    8000553c:	ecce                	sd	s3,88(sp)
    8000553e:	e8d2                	sd	s4,80(sp)
    80005540:	e4d6                	sd	s5,72(sp)
    80005542:	e0da                	sd	s6,64(sp)
    80005544:	fc5e                	sd	s7,56(sp)
    80005546:	f862                	sd	s8,48(sp)
    80005548:	f466                	sd	s9,40(sp)
    8000554a:	f06a                	sd	s10,32(sp)
    8000554c:	ec6e                	sd	s11,24(sp)
    8000554e:	0100                	addi	s0,sp,128
    80005550:	8aaa                	mv	s5,a0
    80005552:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005554:	00c52c83          	lw	s9,12(a0)
    80005558:	001c9c9b          	slliw	s9,s9,0x1
    8000555c:	1c82                	slli	s9,s9,0x20
    8000555e:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005562:	00018517          	auipc	a0,0x18
    80005566:	bc650513          	addi	a0,a0,-1082 # 8001d128 <disk+0x2128>
    8000556a:	00001097          	auipc	ra,0x1
    8000556e:	d6e080e7          	jalr	-658(ra) # 800062d8 <acquire>
  for(int i = 0; i < 3; i++){
    80005572:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005574:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005576:	00016c17          	auipc	s8,0x16
    8000557a:	a8ac0c13          	addi	s8,s8,-1398 # 8001b000 <disk>
    8000557e:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    80005580:	4b0d                	li	s6,3
    80005582:	a0ad                	j	800055ec <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    80005584:	00fc0733          	add	a4,s8,a5
    80005588:	975e                	add	a4,a4,s7
    8000558a:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    8000558e:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005590:	0207c563          	bltz	a5,800055ba <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005594:	2905                	addiw	s2,s2,1
    80005596:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    80005598:	19690c63          	beq	s2,s6,80005730 <virtio_disk_rw+0x1fe>
    idx[i] = alloc_desc();
    8000559c:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    8000559e:	00018717          	auipc	a4,0x18
    800055a2:	a7a70713          	addi	a4,a4,-1414 # 8001d018 <disk+0x2018>
    800055a6:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800055a8:	00074683          	lbu	a3,0(a4)
    800055ac:	fee1                	bnez	a3,80005584 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    800055ae:	2785                	addiw	a5,a5,1
    800055b0:	0705                	addi	a4,a4,1
    800055b2:	fe979be3          	bne	a5,s1,800055a8 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    800055b6:	57fd                	li	a5,-1
    800055b8:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800055ba:	01205d63          	blez	s2,800055d4 <virtio_disk_rw+0xa2>
    800055be:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    800055c0:	000a2503          	lw	a0,0(s4)
    800055c4:	00000097          	auipc	ra,0x0
    800055c8:	d92080e7          	jalr	-622(ra) # 80005356 <free_desc>
      for(int j = 0; j < i; j++)
    800055cc:	2d85                	addiw	s11,s11,1
    800055ce:	0a11                	addi	s4,s4,4
    800055d0:	ff2d98e3          	bne	s11,s2,800055c0 <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800055d4:	00018597          	auipc	a1,0x18
    800055d8:	b5458593          	addi	a1,a1,-1196 # 8001d128 <disk+0x2128>
    800055dc:	00018517          	auipc	a0,0x18
    800055e0:	a3c50513          	addi	a0,a0,-1476 # 8001d018 <disk+0x2018>
    800055e4:	ffffc097          	auipc	ra,0xffffc
    800055e8:	0c6080e7          	jalr	198(ra) # 800016aa <sleep>
  for(int i = 0; i < 3; i++){
    800055ec:	f8040a13          	addi	s4,s0,-128
{
    800055f0:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    800055f2:	894e                	mv	s2,s3
    800055f4:	b765                	j	8000559c <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800055f6:	00018697          	auipc	a3,0x18
    800055fa:	a0a6b683          	ld	a3,-1526(a3) # 8001d000 <disk+0x2000>
    800055fe:	96ba                	add	a3,a3,a4
    80005600:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005604:	00016817          	auipc	a6,0x16
    80005608:	9fc80813          	addi	a6,a6,-1540 # 8001b000 <disk>
    8000560c:	00018697          	auipc	a3,0x18
    80005610:	9f468693          	addi	a3,a3,-1548 # 8001d000 <disk+0x2000>
    80005614:	6290                	ld	a2,0(a3)
    80005616:	963a                	add	a2,a2,a4
    80005618:	00c65583          	lhu	a1,12(a2)
    8000561c:	0015e593          	ori	a1,a1,1
    80005620:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    80005624:	f8842603          	lw	a2,-120(s0)
    80005628:	628c                	ld	a1,0(a3)
    8000562a:	972e                	add	a4,a4,a1
    8000562c:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005630:	20050593          	addi	a1,a0,512
    80005634:	0592                	slli	a1,a1,0x4
    80005636:	95c2                	add	a1,a1,a6
    80005638:	577d                	li	a4,-1
    8000563a:	02e58823          	sb	a4,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000563e:	00461713          	slli	a4,a2,0x4
    80005642:	6290                	ld	a2,0(a3)
    80005644:	963a                	add	a2,a2,a4
    80005646:	03078793          	addi	a5,a5,48
    8000564a:	97c2                	add	a5,a5,a6
    8000564c:	e21c                	sd	a5,0(a2)
  disk.desc[idx[2]].len = 1;
    8000564e:	629c                	ld	a5,0(a3)
    80005650:	97ba                	add	a5,a5,a4
    80005652:	4605                	li	a2,1
    80005654:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005656:	629c                	ld	a5,0(a3)
    80005658:	97ba                	add	a5,a5,a4
    8000565a:	4809                	li	a6,2
    8000565c:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005660:	629c                	ld	a5,0(a3)
    80005662:	97ba                	add	a5,a5,a4
    80005664:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005668:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    8000566c:	0355b423          	sd	s5,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005670:	6698                	ld	a4,8(a3)
    80005672:	00275783          	lhu	a5,2(a4)
    80005676:	8b9d                	andi	a5,a5,7
    80005678:	0786                	slli	a5,a5,0x1
    8000567a:	973e                	add	a4,a4,a5
    8000567c:	00a71223          	sh	a0,4(a4)

  __sync_synchronize();
    80005680:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005684:	6698                	ld	a4,8(a3)
    80005686:	00275783          	lhu	a5,2(a4)
    8000568a:	2785                	addiw	a5,a5,1
    8000568c:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005690:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005694:	100017b7          	lui	a5,0x10001
    80005698:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8000569c:	004aa783          	lw	a5,4(s5)
    800056a0:	02c79163          	bne	a5,a2,800056c2 <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    800056a4:	00018917          	auipc	s2,0x18
    800056a8:	a8490913          	addi	s2,s2,-1404 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    800056ac:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800056ae:	85ca                	mv	a1,s2
    800056b0:	8556                	mv	a0,s5
    800056b2:	ffffc097          	auipc	ra,0xffffc
    800056b6:	ff8080e7          	jalr	-8(ra) # 800016aa <sleep>
  while(b->disk == 1) {
    800056ba:	004aa783          	lw	a5,4(s5)
    800056be:	fe9788e3          	beq	a5,s1,800056ae <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    800056c2:	f8042903          	lw	s2,-128(s0)
    800056c6:	20090713          	addi	a4,s2,512
    800056ca:	0712                	slli	a4,a4,0x4
    800056cc:	00016797          	auipc	a5,0x16
    800056d0:	93478793          	addi	a5,a5,-1740 # 8001b000 <disk>
    800056d4:	97ba                	add	a5,a5,a4
    800056d6:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    800056da:	00018997          	auipc	s3,0x18
    800056de:	92698993          	addi	s3,s3,-1754 # 8001d000 <disk+0x2000>
    800056e2:	00491713          	slli	a4,s2,0x4
    800056e6:	0009b783          	ld	a5,0(s3)
    800056ea:	97ba                	add	a5,a5,a4
    800056ec:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800056f0:	854a                	mv	a0,s2
    800056f2:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800056f6:	00000097          	auipc	ra,0x0
    800056fa:	c60080e7          	jalr	-928(ra) # 80005356 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800056fe:	8885                	andi	s1,s1,1
    80005700:	f0ed                	bnez	s1,800056e2 <virtio_disk_rw+0x1b0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005702:	00018517          	auipc	a0,0x18
    80005706:	a2650513          	addi	a0,a0,-1498 # 8001d128 <disk+0x2128>
    8000570a:	00001097          	auipc	ra,0x1
    8000570e:	c82080e7          	jalr	-894(ra) # 8000638c <release>
}
    80005712:	70e6                	ld	ra,120(sp)
    80005714:	7446                	ld	s0,112(sp)
    80005716:	74a6                	ld	s1,104(sp)
    80005718:	7906                	ld	s2,96(sp)
    8000571a:	69e6                	ld	s3,88(sp)
    8000571c:	6a46                	ld	s4,80(sp)
    8000571e:	6aa6                	ld	s5,72(sp)
    80005720:	6b06                	ld	s6,64(sp)
    80005722:	7be2                	ld	s7,56(sp)
    80005724:	7c42                	ld	s8,48(sp)
    80005726:	7ca2                	ld	s9,40(sp)
    80005728:	7d02                	ld	s10,32(sp)
    8000572a:	6de2                	ld	s11,24(sp)
    8000572c:	6109                	addi	sp,sp,128
    8000572e:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005730:	f8042503          	lw	a0,-128(s0)
    80005734:	20050793          	addi	a5,a0,512
    80005738:	0792                	slli	a5,a5,0x4
  if(write)
    8000573a:	00016817          	auipc	a6,0x16
    8000573e:	8c680813          	addi	a6,a6,-1850 # 8001b000 <disk>
    80005742:	00f80733          	add	a4,a6,a5
    80005746:	01a036b3          	snez	a3,s10
    8000574a:	0ad72423          	sw	a3,168(a4)
  buf0->reserved = 0;
    8000574e:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80005752:	0b973823          	sd	s9,176(a4)
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005756:	7679                	lui	a2,0xffffe
    80005758:	963e                	add	a2,a2,a5
    8000575a:	00018697          	auipc	a3,0x18
    8000575e:	8a668693          	addi	a3,a3,-1882 # 8001d000 <disk+0x2000>
    80005762:	6298                	ld	a4,0(a3)
    80005764:	9732                	add	a4,a4,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005766:	0a878593          	addi	a1,a5,168
    8000576a:	95c2                	add	a1,a1,a6
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000576c:	e30c                	sd	a1,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000576e:	6298                	ld	a4,0(a3)
    80005770:	9732                	add	a4,a4,a2
    80005772:	45c1                	li	a1,16
    80005774:	c70c                	sw	a1,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005776:	6298                	ld	a4,0(a3)
    80005778:	9732                	add	a4,a4,a2
    8000577a:	4585                	li	a1,1
    8000577c:	00b71623          	sh	a1,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005780:	f8442703          	lw	a4,-124(s0)
    80005784:	628c                	ld	a1,0(a3)
    80005786:	962e                	add	a2,a2,a1
    80005788:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd7dce>
  disk.desc[idx[1]].addr = (uint64) b->data;
    8000578c:	0712                	slli	a4,a4,0x4
    8000578e:	6290                	ld	a2,0(a3)
    80005790:	963a                	add	a2,a2,a4
    80005792:	058a8593          	addi	a1,s5,88
    80005796:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005798:	6294                	ld	a3,0(a3)
    8000579a:	96ba                	add	a3,a3,a4
    8000579c:	40000613          	li	a2,1024
    800057a0:	c690                	sw	a2,8(a3)
  if(write)
    800057a2:	e40d1ae3          	bnez	s10,800055f6 <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800057a6:	00018697          	auipc	a3,0x18
    800057aa:	85a6b683          	ld	a3,-1958(a3) # 8001d000 <disk+0x2000>
    800057ae:	96ba                	add	a3,a3,a4
    800057b0:	4609                	li	a2,2
    800057b2:	00c69623          	sh	a2,12(a3)
    800057b6:	b5b9                	j	80005604 <virtio_disk_rw+0xd2>

00000000800057b8 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800057b8:	1101                	addi	sp,sp,-32
    800057ba:	ec06                	sd	ra,24(sp)
    800057bc:	e822                	sd	s0,16(sp)
    800057be:	e426                	sd	s1,8(sp)
    800057c0:	e04a                	sd	s2,0(sp)
    800057c2:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800057c4:	00018517          	auipc	a0,0x18
    800057c8:	96450513          	addi	a0,a0,-1692 # 8001d128 <disk+0x2128>
    800057cc:	00001097          	auipc	ra,0x1
    800057d0:	b0c080e7          	jalr	-1268(ra) # 800062d8 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800057d4:	10001737          	lui	a4,0x10001
    800057d8:	533c                	lw	a5,96(a4)
    800057da:	8b8d                	andi	a5,a5,3
    800057dc:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800057de:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800057e2:	00018797          	auipc	a5,0x18
    800057e6:	81e78793          	addi	a5,a5,-2018 # 8001d000 <disk+0x2000>
    800057ea:	6b94                	ld	a3,16(a5)
    800057ec:	0207d703          	lhu	a4,32(a5)
    800057f0:	0026d783          	lhu	a5,2(a3)
    800057f4:	06f70163          	beq	a4,a5,80005856 <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800057f8:	00016917          	auipc	s2,0x16
    800057fc:	80890913          	addi	s2,s2,-2040 # 8001b000 <disk>
    80005800:	00018497          	auipc	s1,0x18
    80005804:	80048493          	addi	s1,s1,-2048 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    80005808:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000580c:	6898                	ld	a4,16(s1)
    8000580e:	0204d783          	lhu	a5,32(s1)
    80005812:	8b9d                	andi	a5,a5,7
    80005814:	078e                	slli	a5,a5,0x3
    80005816:	97ba                	add	a5,a5,a4
    80005818:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000581a:	20078713          	addi	a4,a5,512
    8000581e:	0712                	slli	a4,a4,0x4
    80005820:	974a                	add	a4,a4,s2
    80005822:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    80005826:	e731                	bnez	a4,80005872 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005828:	20078793          	addi	a5,a5,512
    8000582c:	0792                	slli	a5,a5,0x4
    8000582e:	97ca                	add	a5,a5,s2
    80005830:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005832:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005836:	ffffc097          	auipc	ra,0xffffc
    8000583a:	000080e7          	jalr	ra # 80001836 <wakeup>

    disk.used_idx += 1;
    8000583e:	0204d783          	lhu	a5,32(s1)
    80005842:	2785                	addiw	a5,a5,1
    80005844:	17c2                	slli	a5,a5,0x30
    80005846:	93c1                	srli	a5,a5,0x30
    80005848:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    8000584c:	6898                	ld	a4,16(s1)
    8000584e:	00275703          	lhu	a4,2(a4)
    80005852:	faf71be3          	bne	a4,a5,80005808 <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    80005856:	00018517          	auipc	a0,0x18
    8000585a:	8d250513          	addi	a0,a0,-1838 # 8001d128 <disk+0x2128>
    8000585e:	00001097          	auipc	ra,0x1
    80005862:	b2e080e7          	jalr	-1234(ra) # 8000638c <release>
}
    80005866:	60e2                	ld	ra,24(sp)
    80005868:	6442                	ld	s0,16(sp)
    8000586a:	64a2                	ld	s1,8(sp)
    8000586c:	6902                	ld	s2,0(sp)
    8000586e:	6105                	addi	sp,sp,32
    80005870:	8082                	ret
      panic("virtio_disk_intr status");
    80005872:	00003517          	auipc	a0,0x3
    80005876:	fc650513          	addi	a0,a0,-58 # 80008838 <syscalls+0x410>
    8000587a:	00000097          	auipc	ra,0x0
    8000587e:	526080e7          	jalr	1318(ra) # 80005da0 <panic>

0000000080005882 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005882:	1141                	addi	sp,sp,-16
    80005884:	e422                	sd	s0,8(sp)
    80005886:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005888:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    8000588c:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005890:	0037979b          	slliw	a5,a5,0x3
    80005894:	02004737          	lui	a4,0x2004
    80005898:	97ba                	add	a5,a5,a4
    8000589a:	0200c737          	lui	a4,0x200c
    8000589e:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    800058a2:	000f4637          	lui	a2,0xf4
    800058a6:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800058aa:	9732                	add	a4,a4,a2
    800058ac:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800058ae:	00259693          	slli	a3,a1,0x2
    800058b2:	96ae                	add	a3,a3,a1
    800058b4:	068e                	slli	a3,a3,0x3
    800058b6:	00018717          	auipc	a4,0x18
    800058ba:	74a70713          	addi	a4,a4,1866 # 8001e000 <timer_scratch>
    800058be:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800058c0:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800058c2:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800058c4:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800058c8:	00000797          	auipc	a5,0x0
    800058cc:	9c878793          	addi	a5,a5,-1592 # 80005290 <timervec>
    800058d0:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800058d4:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800058d8:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800058dc:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800058e0:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800058e4:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800058e8:	30479073          	csrw	mie,a5
}
    800058ec:	6422                	ld	s0,8(sp)
    800058ee:	0141                	addi	sp,sp,16
    800058f0:	8082                	ret

00000000800058f2 <start>:
{
    800058f2:	1141                	addi	sp,sp,-16
    800058f4:	e406                	sd	ra,8(sp)
    800058f6:	e022                	sd	s0,0(sp)
    800058f8:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800058fa:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800058fe:	7779                	lui	a4,0xffffe
    80005900:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    80005904:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005906:	6705                	lui	a4,0x1
    80005908:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000590c:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000590e:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005912:	ffffb797          	auipc	a5,0xffffb
    80005916:	a0e78793          	addi	a5,a5,-1522 # 80000320 <main>
    8000591a:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    8000591e:	4781                	li	a5,0
    80005920:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005924:	67c1                	lui	a5,0x10
    80005926:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005928:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    8000592c:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005930:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005934:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005938:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    8000593c:	57fd                	li	a5,-1
    8000593e:	83a9                	srli	a5,a5,0xa
    80005940:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005944:	47bd                	li	a5,15
    80005946:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    8000594a:	00000097          	auipc	ra,0x0
    8000594e:	f38080e7          	jalr	-200(ra) # 80005882 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005952:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005956:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005958:	823e                	mv	tp,a5
  asm volatile("mret");
    8000595a:	30200073          	mret
}
    8000595e:	60a2                	ld	ra,8(sp)
    80005960:	6402                	ld	s0,0(sp)
    80005962:	0141                	addi	sp,sp,16
    80005964:	8082                	ret

0000000080005966 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005966:	715d                	addi	sp,sp,-80
    80005968:	e486                	sd	ra,72(sp)
    8000596a:	e0a2                	sd	s0,64(sp)
    8000596c:	fc26                	sd	s1,56(sp)
    8000596e:	f84a                	sd	s2,48(sp)
    80005970:	f44e                	sd	s3,40(sp)
    80005972:	f052                	sd	s4,32(sp)
    80005974:	ec56                	sd	s5,24(sp)
    80005976:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005978:	04c05763          	blez	a2,800059c6 <consolewrite+0x60>
    8000597c:	8a2a                	mv	s4,a0
    8000597e:	84ae                	mv	s1,a1
    80005980:	89b2                	mv	s3,a2
    80005982:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005984:	5afd                	li	s5,-1
    80005986:	4685                	li	a3,1
    80005988:	8626                	mv	a2,s1
    8000598a:	85d2                	mv	a1,s4
    8000598c:	fbf40513          	addi	a0,s0,-65
    80005990:	ffffc097          	auipc	ra,0xffffc
    80005994:	114080e7          	jalr	276(ra) # 80001aa4 <either_copyin>
    80005998:	01550d63          	beq	a0,s5,800059b2 <consolewrite+0x4c>
      break;
    uartputc(c);
    8000599c:	fbf44503          	lbu	a0,-65(s0)
    800059a0:	00000097          	auipc	ra,0x0
    800059a4:	77e080e7          	jalr	1918(ra) # 8000611e <uartputc>
  for(i = 0; i < n; i++){
    800059a8:	2905                	addiw	s2,s2,1
    800059aa:	0485                	addi	s1,s1,1
    800059ac:	fd299de3          	bne	s3,s2,80005986 <consolewrite+0x20>
    800059b0:	894e                	mv	s2,s3
  }

  return i;
}
    800059b2:	854a                	mv	a0,s2
    800059b4:	60a6                	ld	ra,72(sp)
    800059b6:	6406                	ld	s0,64(sp)
    800059b8:	74e2                	ld	s1,56(sp)
    800059ba:	7942                	ld	s2,48(sp)
    800059bc:	79a2                	ld	s3,40(sp)
    800059be:	7a02                	ld	s4,32(sp)
    800059c0:	6ae2                	ld	s5,24(sp)
    800059c2:	6161                	addi	sp,sp,80
    800059c4:	8082                	ret
  for(i = 0; i < n; i++){
    800059c6:	4901                	li	s2,0
    800059c8:	b7ed                	j	800059b2 <consolewrite+0x4c>

00000000800059ca <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800059ca:	7159                	addi	sp,sp,-112
    800059cc:	f486                	sd	ra,104(sp)
    800059ce:	f0a2                	sd	s0,96(sp)
    800059d0:	eca6                	sd	s1,88(sp)
    800059d2:	e8ca                	sd	s2,80(sp)
    800059d4:	e4ce                	sd	s3,72(sp)
    800059d6:	e0d2                	sd	s4,64(sp)
    800059d8:	fc56                	sd	s5,56(sp)
    800059da:	f85a                	sd	s6,48(sp)
    800059dc:	f45e                	sd	s7,40(sp)
    800059de:	f062                	sd	s8,32(sp)
    800059e0:	ec66                	sd	s9,24(sp)
    800059e2:	e86a                	sd	s10,16(sp)
    800059e4:	1880                	addi	s0,sp,112
    800059e6:	8aaa                	mv	s5,a0
    800059e8:	8a2e                	mv	s4,a1
    800059ea:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800059ec:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    800059f0:	00020517          	auipc	a0,0x20
    800059f4:	75050513          	addi	a0,a0,1872 # 80026140 <cons>
    800059f8:	00001097          	auipc	ra,0x1
    800059fc:	8e0080e7          	jalr	-1824(ra) # 800062d8 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005a00:	00020497          	auipc	s1,0x20
    80005a04:	74048493          	addi	s1,s1,1856 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005a08:	00020917          	auipc	s2,0x20
    80005a0c:	7d090913          	addi	s2,s2,2000 # 800261d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005a10:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a12:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005a14:	4ca9                	li	s9,10
  while(n > 0){
    80005a16:	07305863          	blez	s3,80005a86 <consoleread+0xbc>
    while(cons.r == cons.w){
    80005a1a:	0984a783          	lw	a5,152(s1)
    80005a1e:	09c4a703          	lw	a4,156(s1)
    80005a22:	02f71463          	bne	a4,a5,80005a4a <consoleread+0x80>
      if(myproc()->killed){
    80005a26:	ffffb097          	auipc	ra,0xffffb
    80005a2a:	510080e7          	jalr	1296(ra) # 80000f36 <myproc>
    80005a2e:	591c                	lw	a5,48(a0)
    80005a30:	e7b5                	bnez	a5,80005a9c <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    80005a32:	85a6                	mv	a1,s1
    80005a34:	854a                	mv	a0,s2
    80005a36:	ffffc097          	auipc	ra,0xffffc
    80005a3a:	c74080e7          	jalr	-908(ra) # 800016aa <sleep>
    while(cons.r == cons.w){
    80005a3e:	0984a783          	lw	a5,152(s1)
    80005a42:	09c4a703          	lw	a4,156(s1)
    80005a46:	fef700e3          	beq	a4,a5,80005a26 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005a4a:	0017871b          	addiw	a4,a5,1
    80005a4e:	08e4ac23          	sw	a4,152(s1)
    80005a52:	07f7f713          	andi	a4,a5,127
    80005a56:	9726                	add	a4,a4,s1
    80005a58:	01874703          	lbu	a4,24(a4)
    80005a5c:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80005a60:	077d0563          	beq	s10,s7,80005aca <consoleread+0x100>
    cbuf = c;
    80005a64:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a68:	4685                	li	a3,1
    80005a6a:	f9f40613          	addi	a2,s0,-97
    80005a6e:	85d2                	mv	a1,s4
    80005a70:	8556                	mv	a0,s5
    80005a72:	ffffc097          	auipc	ra,0xffffc
    80005a76:	fdc080e7          	jalr	-36(ra) # 80001a4e <either_copyout>
    80005a7a:	01850663          	beq	a0,s8,80005a86 <consoleread+0xbc>
    dst++;
    80005a7e:	0a05                	addi	s4,s4,1
    --n;
    80005a80:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80005a82:	f99d1ae3          	bne	s10,s9,80005a16 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005a86:	00020517          	auipc	a0,0x20
    80005a8a:	6ba50513          	addi	a0,a0,1722 # 80026140 <cons>
    80005a8e:	00001097          	auipc	ra,0x1
    80005a92:	8fe080e7          	jalr	-1794(ra) # 8000638c <release>

  return target - n;
    80005a96:	413b053b          	subw	a0,s6,s3
    80005a9a:	a811                	j	80005aae <consoleread+0xe4>
        release(&cons.lock);
    80005a9c:	00020517          	auipc	a0,0x20
    80005aa0:	6a450513          	addi	a0,a0,1700 # 80026140 <cons>
    80005aa4:	00001097          	auipc	ra,0x1
    80005aa8:	8e8080e7          	jalr	-1816(ra) # 8000638c <release>
        return -1;
    80005aac:	557d                	li	a0,-1
}
    80005aae:	70a6                	ld	ra,104(sp)
    80005ab0:	7406                	ld	s0,96(sp)
    80005ab2:	64e6                	ld	s1,88(sp)
    80005ab4:	6946                	ld	s2,80(sp)
    80005ab6:	69a6                	ld	s3,72(sp)
    80005ab8:	6a06                	ld	s4,64(sp)
    80005aba:	7ae2                	ld	s5,56(sp)
    80005abc:	7b42                	ld	s6,48(sp)
    80005abe:	7ba2                	ld	s7,40(sp)
    80005ac0:	7c02                	ld	s8,32(sp)
    80005ac2:	6ce2                	ld	s9,24(sp)
    80005ac4:	6d42                	ld	s10,16(sp)
    80005ac6:	6165                	addi	sp,sp,112
    80005ac8:	8082                	ret
      if(n < target){
    80005aca:	0009871b          	sext.w	a4,s3
    80005ace:	fb677ce3          	bgeu	a4,s6,80005a86 <consoleread+0xbc>
        cons.r--;
    80005ad2:	00020717          	auipc	a4,0x20
    80005ad6:	70f72323          	sw	a5,1798(a4) # 800261d8 <cons+0x98>
    80005ada:	b775                	j	80005a86 <consoleread+0xbc>

0000000080005adc <consputc>:
{
    80005adc:	1141                	addi	sp,sp,-16
    80005ade:	e406                	sd	ra,8(sp)
    80005ae0:	e022                	sd	s0,0(sp)
    80005ae2:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005ae4:	10000793          	li	a5,256
    80005ae8:	00f50a63          	beq	a0,a5,80005afc <consputc+0x20>
    uartputc_sync(c);
    80005aec:	00000097          	auipc	ra,0x0
    80005af0:	560080e7          	jalr	1376(ra) # 8000604c <uartputc_sync>
}
    80005af4:	60a2                	ld	ra,8(sp)
    80005af6:	6402                	ld	s0,0(sp)
    80005af8:	0141                	addi	sp,sp,16
    80005afa:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005afc:	4521                	li	a0,8
    80005afe:	00000097          	auipc	ra,0x0
    80005b02:	54e080e7          	jalr	1358(ra) # 8000604c <uartputc_sync>
    80005b06:	02000513          	li	a0,32
    80005b0a:	00000097          	auipc	ra,0x0
    80005b0e:	542080e7          	jalr	1346(ra) # 8000604c <uartputc_sync>
    80005b12:	4521                	li	a0,8
    80005b14:	00000097          	auipc	ra,0x0
    80005b18:	538080e7          	jalr	1336(ra) # 8000604c <uartputc_sync>
    80005b1c:	bfe1                	j	80005af4 <consputc+0x18>

0000000080005b1e <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005b1e:	1101                	addi	sp,sp,-32
    80005b20:	ec06                	sd	ra,24(sp)
    80005b22:	e822                	sd	s0,16(sp)
    80005b24:	e426                	sd	s1,8(sp)
    80005b26:	e04a                	sd	s2,0(sp)
    80005b28:	1000                	addi	s0,sp,32
    80005b2a:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005b2c:	00020517          	auipc	a0,0x20
    80005b30:	61450513          	addi	a0,a0,1556 # 80026140 <cons>
    80005b34:	00000097          	auipc	ra,0x0
    80005b38:	7a4080e7          	jalr	1956(ra) # 800062d8 <acquire>

  switch(c){
    80005b3c:	47d5                	li	a5,21
    80005b3e:	0af48663          	beq	s1,a5,80005bea <consoleintr+0xcc>
    80005b42:	0297ca63          	blt	a5,s1,80005b76 <consoleintr+0x58>
    80005b46:	47a1                	li	a5,8
    80005b48:	0ef48763          	beq	s1,a5,80005c36 <consoleintr+0x118>
    80005b4c:	47c1                	li	a5,16
    80005b4e:	10f49a63          	bne	s1,a5,80005c62 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005b52:	ffffc097          	auipc	ra,0xffffc
    80005b56:	fa8080e7          	jalr	-88(ra) # 80001afa <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005b5a:	00020517          	auipc	a0,0x20
    80005b5e:	5e650513          	addi	a0,a0,1510 # 80026140 <cons>
    80005b62:	00001097          	auipc	ra,0x1
    80005b66:	82a080e7          	jalr	-2006(ra) # 8000638c <release>
}
    80005b6a:	60e2                	ld	ra,24(sp)
    80005b6c:	6442                	ld	s0,16(sp)
    80005b6e:	64a2                	ld	s1,8(sp)
    80005b70:	6902                	ld	s2,0(sp)
    80005b72:	6105                	addi	sp,sp,32
    80005b74:	8082                	ret
  switch(c){
    80005b76:	07f00793          	li	a5,127
    80005b7a:	0af48e63          	beq	s1,a5,80005c36 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005b7e:	00020717          	auipc	a4,0x20
    80005b82:	5c270713          	addi	a4,a4,1474 # 80026140 <cons>
    80005b86:	0a072783          	lw	a5,160(a4)
    80005b8a:	09872703          	lw	a4,152(a4)
    80005b8e:	9f99                	subw	a5,a5,a4
    80005b90:	07f00713          	li	a4,127
    80005b94:	fcf763e3          	bltu	a4,a5,80005b5a <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005b98:	47b5                	li	a5,13
    80005b9a:	0cf48763          	beq	s1,a5,80005c68 <consoleintr+0x14a>
      consputc(c);
    80005b9e:	8526                	mv	a0,s1
    80005ba0:	00000097          	auipc	ra,0x0
    80005ba4:	f3c080e7          	jalr	-196(ra) # 80005adc <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005ba8:	00020797          	auipc	a5,0x20
    80005bac:	59878793          	addi	a5,a5,1432 # 80026140 <cons>
    80005bb0:	0a07a703          	lw	a4,160(a5)
    80005bb4:	0017069b          	addiw	a3,a4,1
    80005bb8:	0006861b          	sext.w	a2,a3
    80005bbc:	0ad7a023          	sw	a3,160(a5)
    80005bc0:	07f77713          	andi	a4,a4,127
    80005bc4:	97ba                	add	a5,a5,a4
    80005bc6:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005bca:	47a9                	li	a5,10
    80005bcc:	0cf48563          	beq	s1,a5,80005c96 <consoleintr+0x178>
    80005bd0:	4791                	li	a5,4
    80005bd2:	0cf48263          	beq	s1,a5,80005c96 <consoleintr+0x178>
    80005bd6:	00020797          	auipc	a5,0x20
    80005bda:	6027a783          	lw	a5,1538(a5) # 800261d8 <cons+0x98>
    80005bde:	0807879b          	addiw	a5,a5,128
    80005be2:	f6f61ce3          	bne	a2,a5,80005b5a <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005be6:	863e                	mv	a2,a5
    80005be8:	a07d                	j	80005c96 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005bea:	00020717          	auipc	a4,0x20
    80005bee:	55670713          	addi	a4,a4,1366 # 80026140 <cons>
    80005bf2:	0a072783          	lw	a5,160(a4)
    80005bf6:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005bfa:	00020497          	auipc	s1,0x20
    80005bfe:	54648493          	addi	s1,s1,1350 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005c02:	4929                	li	s2,10
    80005c04:	f4f70be3          	beq	a4,a5,80005b5a <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005c08:	37fd                	addiw	a5,a5,-1
    80005c0a:	07f7f713          	andi	a4,a5,127
    80005c0e:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005c10:	01874703          	lbu	a4,24(a4)
    80005c14:	f52703e3          	beq	a4,s2,80005b5a <consoleintr+0x3c>
      cons.e--;
    80005c18:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005c1c:	10000513          	li	a0,256
    80005c20:	00000097          	auipc	ra,0x0
    80005c24:	ebc080e7          	jalr	-324(ra) # 80005adc <consputc>
    while(cons.e != cons.w &&
    80005c28:	0a04a783          	lw	a5,160(s1)
    80005c2c:	09c4a703          	lw	a4,156(s1)
    80005c30:	fcf71ce3          	bne	a4,a5,80005c08 <consoleintr+0xea>
    80005c34:	b71d                	j	80005b5a <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005c36:	00020717          	auipc	a4,0x20
    80005c3a:	50a70713          	addi	a4,a4,1290 # 80026140 <cons>
    80005c3e:	0a072783          	lw	a5,160(a4)
    80005c42:	09c72703          	lw	a4,156(a4)
    80005c46:	f0f70ae3          	beq	a4,a5,80005b5a <consoleintr+0x3c>
      cons.e--;
    80005c4a:	37fd                	addiw	a5,a5,-1
    80005c4c:	00020717          	auipc	a4,0x20
    80005c50:	58f72a23          	sw	a5,1428(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005c54:	10000513          	li	a0,256
    80005c58:	00000097          	auipc	ra,0x0
    80005c5c:	e84080e7          	jalr	-380(ra) # 80005adc <consputc>
    80005c60:	bded                	j	80005b5a <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005c62:	ee048ce3          	beqz	s1,80005b5a <consoleintr+0x3c>
    80005c66:	bf21                	j	80005b7e <consoleintr+0x60>
      consputc(c);
    80005c68:	4529                	li	a0,10
    80005c6a:	00000097          	auipc	ra,0x0
    80005c6e:	e72080e7          	jalr	-398(ra) # 80005adc <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005c72:	00020797          	auipc	a5,0x20
    80005c76:	4ce78793          	addi	a5,a5,1230 # 80026140 <cons>
    80005c7a:	0a07a703          	lw	a4,160(a5)
    80005c7e:	0017069b          	addiw	a3,a4,1
    80005c82:	0006861b          	sext.w	a2,a3
    80005c86:	0ad7a023          	sw	a3,160(a5)
    80005c8a:	07f77713          	andi	a4,a4,127
    80005c8e:	97ba                	add	a5,a5,a4
    80005c90:	4729                	li	a4,10
    80005c92:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005c96:	00020797          	auipc	a5,0x20
    80005c9a:	54c7a323          	sw	a2,1350(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005c9e:	00020517          	auipc	a0,0x20
    80005ca2:	53a50513          	addi	a0,a0,1338 # 800261d8 <cons+0x98>
    80005ca6:	ffffc097          	auipc	ra,0xffffc
    80005caa:	b90080e7          	jalr	-1136(ra) # 80001836 <wakeup>
    80005cae:	b575                	j	80005b5a <consoleintr+0x3c>

0000000080005cb0 <consoleinit>:

void
consoleinit(void)
{
    80005cb0:	1141                	addi	sp,sp,-16
    80005cb2:	e406                	sd	ra,8(sp)
    80005cb4:	e022                	sd	s0,0(sp)
    80005cb6:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005cb8:	00003597          	auipc	a1,0x3
    80005cbc:	b9858593          	addi	a1,a1,-1128 # 80008850 <syscalls+0x428>
    80005cc0:	00020517          	auipc	a0,0x20
    80005cc4:	48050513          	addi	a0,a0,1152 # 80026140 <cons>
    80005cc8:	00000097          	auipc	ra,0x0
    80005ccc:	580080e7          	jalr	1408(ra) # 80006248 <initlock>

  uartinit();
    80005cd0:	00000097          	auipc	ra,0x0
    80005cd4:	32c080e7          	jalr	812(ra) # 80005ffc <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005cd8:	00013797          	auipc	a5,0x13
    80005cdc:	5f078793          	addi	a5,a5,1520 # 800192c8 <devsw>
    80005ce0:	00000717          	auipc	a4,0x0
    80005ce4:	cea70713          	addi	a4,a4,-790 # 800059ca <consoleread>
    80005ce8:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005cea:	00000717          	auipc	a4,0x0
    80005cee:	c7c70713          	addi	a4,a4,-900 # 80005966 <consolewrite>
    80005cf2:	ef98                	sd	a4,24(a5)
}
    80005cf4:	60a2                	ld	ra,8(sp)
    80005cf6:	6402                	ld	s0,0(sp)
    80005cf8:	0141                	addi	sp,sp,16
    80005cfa:	8082                	ret

0000000080005cfc <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005cfc:	7179                	addi	sp,sp,-48
    80005cfe:	f406                	sd	ra,40(sp)
    80005d00:	f022                	sd	s0,32(sp)
    80005d02:	ec26                	sd	s1,24(sp)
    80005d04:	e84a                	sd	s2,16(sp)
    80005d06:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005d08:	c219                	beqz	a2,80005d0e <printint+0x12>
    80005d0a:	08054763          	bltz	a0,80005d98 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005d0e:	2501                	sext.w	a0,a0
    80005d10:	4881                	li	a7,0
    80005d12:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005d16:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005d18:	2581                	sext.w	a1,a1
    80005d1a:	00003617          	auipc	a2,0x3
    80005d1e:	b6660613          	addi	a2,a2,-1178 # 80008880 <digits>
    80005d22:	883a                	mv	a6,a4
    80005d24:	2705                	addiw	a4,a4,1
    80005d26:	02b577bb          	remuw	a5,a0,a1
    80005d2a:	1782                	slli	a5,a5,0x20
    80005d2c:	9381                	srli	a5,a5,0x20
    80005d2e:	97b2                	add	a5,a5,a2
    80005d30:	0007c783          	lbu	a5,0(a5)
    80005d34:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005d38:	0005079b          	sext.w	a5,a0
    80005d3c:	02b5553b          	divuw	a0,a0,a1
    80005d40:	0685                	addi	a3,a3,1
    80005d42:	feb7f0e3          	bgeu	a5,a1,80005d22 <printint+0x26>

  if(sign)
    80005d46:	00088c63          	beqz	a7,80005d5e <printint+0x62>
    buf[i++] = '-';
    80005d4a:	fe070793          	addi	a5,a4,-32
    80005d4e:	00878733          	add	a4,a5,s0
    80005d52:	02d00793          	li	a5,45
    80005d56:	fef70823          	sb	a5,-16(a4)
    80005d5a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005d5e:	02e05763          	blez	a4,80005d8c <printint+0x90>
    80005d62:	fd040793          	addi	a5,s0,-48
    80005d66:	00e784b3          	add	s1,a5,a4
    80005d6a:	fff78913          	addi	s2,a5,-1
    80005d6e:	993a                	add	s2,s2,a4
    80005d70:	377d                	addiw	a4,a4,-1
    80005d72:	1702                	slli	a4,a4,0x20
    80005d74:	9301                	srli	a4,a4,0x20
    80005d76:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005d7a:	fff4c503          	lbu	a0,-1(s1)
    80005d7e:	00000097          	auipc	ra,0x0
    80005d82:	d5e080e7          	jalr	-674(ra) # 80005adc <consputc>
  while(--i >= 0)
    80005d86:	14fd                	addi	s1,s1,-1
    80005d88:	ff2499e3          	bne	s1,s2,80005d7a <printint+0x7e>
}
    80005d8c:	70a2                	ld	ra,40(sp)
    80005d8e:	7402                	ld	s0,32(sp)
    80005d90:	64e2                	ld	s1,24(sp)
    80005d92:	6942                	ld	s2,16(sp)
    80005d94:	6145                	addi	sp,sp,48
    80005d96:	8082                	ret
    x = -xx;
    80005d98:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005d9c:	4885                	li	a7,1
    x = -xx;
    80005d9e:	bf95                	j	80005d12 <printint+0x16>

0000000080005da0 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005da0:	1101                	addi	sp,sp,-32
    80005da2:	ec06                	sd	ra,24(sp)
    80005da4:	e822                	sd	s0,16(sp)
    80005da6:	e426                	sd	s1,8(sp)
    80005da8:	1000                	addi	s0,sp,32
    80005daa:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005dac:	00020797          	auipc	a5,0x20
    80005db0:	4407aa23          	sw	zero,1108(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005db4:	00003517          	auipc	a0,0x3
    80005db8:	aa450513          	addi	a0,a0,-1372 # 80008858 <syscalls+0x430>
    80005dbc:	00000097          	auipc	ra,0x0
    80005dc0:	02e080e7          	jalr	46(ra) # 80005dea <printf>
  printf(s);
    80005dc4:	8526                	mv	a0,s1
    80005dc6:	00000097          	auipc	ra,0x0
    80005dca:	024080e7          	jalr	36(ra) # 80005dea <printf>
  printf("\n");
    80005dce:	00002517          	auipc	a0,0x2
    80005dd2:	27a50513          	addi	a0,a0,634 # 80008048 <etext+0x48>
    80005dd6:	00000097          	auipc	ra,0x0
    80005dda:	014080e7          	jalr	20(ra) # 80005dea <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005dde:	4785                	li	a5,1
    80005de0:	00003717          	auipc	a4,0x3
    80005de4:	22f72e23          	sw	a5,572(a4) # 8000901c <panicked>
  for(;;)
    80005de8:	a001                	j	80005de8 <panic+0x48>

0000000080005dea <printf>:
{
    80005dea:	7131                	addi	sp,sp,-192
    80005dec:	fc86                	sd	ra,120(sp)
    80005dee:	f8a2                	sd	s0,112(sp)
    80005df0:	f4a6                	sd	s1,104(sp)
    80005df2:	f0ca                	sd	s2,96(sp)
    80005df4:	ecce                	sd	s3,88(sp)
    80005df6:	e8d2                	sd	s4,80(sp)
    80005df8:	e4d6                	sd	s5,72(sp)
    80005dfa:	e0da                	sd	s6,64(sp)
    80005dfc:	fc5e                	sd	s7,56(sp)
    80005dfe:	f862                	sd	s8,48(sp)
    80005e00:	f466                	sd	s9,40(sp)
    80005e02:	f06a                	sd	s10,32(sp)
    80005e04:	ec6e                	sd	s11,24(sp)
    80005e06:	0100                	addi	s0,sp,128
    80005e08:	8a2a                	mv	s4,a0
    80005e0a:	e40c                	sd	a1,8(s0)
    80005e0c:	e810                	sd	a2,16(s0)
    80005e0e:	ec14                	sd	a3,24(s0)
    80005e10:	f018                	sd	a4,32(s0)
    80005e12:	f41c                	sd	a5,40(s0)
    80005e14:	03043823          	sd	a6,48(s0)
    80005e18:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005e1c:	00020d97          	auipc	s11,0x20
    80005e20:	3e4dad83          	lw	s11,996(s11) # 80026200 <pr+0x18>
  if(locking)
    80005e24:	020d9b63          	bnez	s11,80005e5a <printf+0x70>
  if (fmt == 0)
    80005e28:	040a0263          	beqz	s4,80005e6c <printf+0x82>
  va_start(ap, fmt);
    80005e2c:	00840793          	addi	a5,s0,8
    80005e30:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e34:	000a4503          	lbu	a0,0(s4)
    80005e38:	14050f63          	beqz	a0,80005f96 <printf+0x1ac>
    80005e3c:	4981                	li	s3,0
    if(c != '%'){
    80005e3e:	02500a93          	li	s5,37
    switch(c){
    80005e42:	07000b93          	li	s7,112
  consputc('x');
    80005e46:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e48:	00003b17          	auipc	s6,0x3
    80005e4c:	a38b0b13          	addi	s6,s6,-1480 # 80008880 <digits>
    switch(c){
    80005e50:	07300c93          	li	s9,115
    80005e54:	06400c13          	li	s8,100
    80005e58:	a82d                	j	80005e92 <printf+0xa8>
    acquire(&pr.lock);
    80005e5a:	00020517          	auipc	a0,0x20
    80005e5e:	38e50513          	addi	a0,a0,910 # 800261e8 <pr>
    80005e62:	00000097          	auipc	ra,0x0
    80005e66:	476080e7          	jalr	1142(ra) # 800062d8 <acquire>
    80005e6a:	bf7d                	j	80005e28 <printf+0x3e>
    panic("null fmt");
    80005e6c:	00003517          	auipc	a0,0x3
    80005e70:	9fc50513          	addi	a0,a0,-1540 # 80008868 <syscalls+0x440>
    80005e74:	00000097          	auipc	ra,0x0
    80005e78:	f2c080e7          	jalr	-212(ra) # 80005da0 <panic>
      consputc(c);
    80005e7c:	00000097          	auipc	ra,0x0
    80005e80:	c60080e7          	jalr	-928(ra) # 80005adc <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e84:	2985                	addiw	s3,s3,1
    80005e86:	013a07b3          	add	a5,s4,s3
    80005e8a:	0007c503          	lbu	a0,0(a5)
    80005e8e:	10050463          	beqz	a0,80005f96 <printf+0x1ac>
    if(c != '%'){
    80005e92:	ff5515e3          	bne	a0,s5,80005e7c <printf+0x92>
    c = fmt[++i] & 0xff;
    80005e96:	2985                	addiw	s3,s3,1
    80005e98:	013a07b3          	add	a5,s4,s3
    80005e9c:	0007c783          	lbu	a5,0(a5)
    80005ea0:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005ea4:	cbed                	beqz	a5,80005f96 <printf+0x1ac>
    switch(c){
    80005ea6:	05778a63          	beq	a5,s7,80005efa <printf+0x110>
    80005eaa:	02fbf663          	bgeu	s7,a5,80005ed6 <printf+0xec>
    80005eae:	09978863          	beq	a5,s9,80005f3e <printf+0x154>
    80005eb2:	07800713          	li	a4,120
    80005eb6:	0ce79563          	bne	a5,a4,80005f80 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005eba:	f8843783          	ld	a5,-120(s0)
    80005ebe:	00878713          	addi	a4,a5,8
    80005ec2:	f8e43423          	sd	a4,-120(s0)
    80005ec6:	4605                	li	a2,1
    80005ec8:	85ea                	mv	a1,s10
    80005eca:	4388                	lw	a0,0(a5)
    80005ecc:	00000097          	auipc	ra,0x0
    80005ed0:	e30080e7          	jalr	-464(ra) # 80005cfc <printint>
      break;
    80005ed4:	bf45                	j	80005e84 <printf+0x9a>
    switch(c){
    80005ed6:	09578f63          	beq	a5,s5,80005f74 <printf+0x18a>
    80005eda:	0b879363          	bne	a5,s8,80005f80 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005ede:	f8843783          	ld	a5,-120(s0)
    80005ee2:	00878713          	addi	a4,a5,8
    80005ee6:	f8e43423          	sd	a4,-120(s0)
    80005eea:	4605                	li	a2,1
    80005eec:	45a9                	li	a1,10
    80005eee:	4388                	lw	a0,0(a5)
    80005ef0:	00000097          	auipc	ra,0x0
    80005ef4:	e0c080e7          	jalr	-500(ra) # 80005cfc <printint>
      break;
    80005ef8:	b771                	j	80005e84 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005efa:	f8843783          	ld	a5,-120(s0)
    80005efe:	00878713          	addi	a4,a5,8
    80005f02:	f8e43423          	sd	a4,-120(s0)
    80005f06:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005f0a:	03000513          	li	a0,48
    80005f0e:	00000097          	auipc	ra,0x0
    80005f12:	bce080e7          	jalr	-1074(ra) # 80005adc <consputc>
  consputc('x');
    80005f16:	07800513          	li	a0,120
    80005f1a:	00000097          	auipc	ra,0x0
    80005f1e:	bc2080e7          	jalr	-1086(ra) # 80005adc <consputc>
    80005f22:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f24:	03c95793          	srli	a5,s2,0x3c
    80005f28:	97da                	add	a5,a5,s6
    80005f2a:	0007c503          	lbu	a0,0(a5)
    80005f2e:	00000097          	auipc	ra,0x0
    80005f32:	bae080e7          	jalr	-1106(ra) # 80005adc <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005f36:	0912                	slli	s2,s2,0x4
    80005f38:	34fd                	addiw	s1,s1,-1
    80005f3a:	f4ed                	bnez	s1,80005f24 <printf+0x13a>
    80005f3c:	b7a1                	j	80005e84 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005f3e:	f8843783          	ld	a5,-120(s0)
    80005f42:	00878713          	addi	a4,a5,8
    80005f46:	f8e43423          	sd	a4,-120(s0)
    80005f4a:	6384                	ld	s1,0(a5)
    80005f4c:	cc89                	beqz	s1,80005f66 <printf+0x17c>
      for(; *s; s++)
    80005f4e:	0004c503          	lbu	a0,0(s1)
    80005f52:	d90d                	beqz	a0,80005e84 <printf+0x9a>
        consputc(*s);
    80005f54:	00000097          	auipc	ra,0x0
    80005f58:	b88080e7          	jalr	-1144(ra) # 80005adc <consputc>
      for(; *s; s++)
    80005f5c:	0485                	addi	s1,s1,1
    80005f5e:	0004c503          	lbu	a0,0(s1)
    80005f62:	f96d                	bnez	a0,80005f54 <printf+0x16a>
    80005f64:	b705                	j	80005e84 <printf+0x9a>
        s = "(null)";
    80005f66:	00003497          	auipc	s1,0x3
    80005f6a:	8fa48493          	addi	s1,s1,-1798 # 80008860 <syscalls+0x438>
      for(; *s; s++)
    80005f6e:	02800513          	li	a0,40
    80005f72:	b7cd                	j	80005f54 <printf+0x16a>
      consputc('%');
    80005f74:	8556                	mv	a0,s5
    80005f76:	00000097          	auipc	ra,0x0
    80005f7a:	b66080e7          	jalr	-1178(ra) # 80005adc <consputc>
      break;
    80005f7e:	b719                	j	80005e84 <printf+0x9a>
      consputc('%');
    80005f80:	8556                	mv	a0,s5
    80005f82:	00000097          	auipc	ra,0x0
    80005f86:	b5a080e7          	jalr	-1190(ra) # 80005adc <consputc>
      consputc(c);
    80005f8a:	8526                	mv	a0,s1
    80005f8c:	00000097          	auipc	ra,0x0
    80005f90:	b50080e7          	jalr	-1200(ra) # 80005adc <consputc>
      break;
    80005f94:	bdc5                	j	80005e84 <printf+0x9a>
  if(locking)
    80005f96:	020d9163          	bnez	s11,80005fb8 <printf+0x1ce>
}
    80005f9a:	70e6                	ld	ra,120(sp)
    80005f9c:	7446                	ld	s0,112(sp)
    80005f9e:	74a6                	ld	s1,104(sp)
    80005fa0:	7906                	ld	s2,96(sp)
    80005fa2:	69e6                	ld	s3,88(sp)
    80005fa4:	6a46                	ld	s4,80(sp)
    80005fa6:	6aa6                	ld	s5,72(sp)
    80005fa8:	6b06                	ld	s6,64(sp)
    80005faa:	7be2                	ld	s7,56(sp)
    80005fac:	7c42                	ld	s8,48(sp)
    80005fae:	7ca2                	ld	s9,40(sp)
    80005fb0:	7d02                	ld	s10,32(sp)
    80005fb2:	6de2                	ld	s11,24(sp)
    80005fb4:	6129                	addi	sp,sp,192
    80005fb6:	8082                	ret
    release(&pr.lock);
    80005fb8:	00020517          	auipc	a0,0x20
    80005fbc:	23050513          	addi	a0,a0,560 # 800261e8 <pr>
    80005fc0:	00000097          	auipc	ra,0x0
    80005fc4:	3cc080e7          	jalr	972(ra) # 8000638c <release>
}
    80005fc8:	bfc9                	j	80005f9a <printf+0x1b0>

0000000080005fca <printfinit>:
    ;
}

void
printfinit(void)
{
    80005fca:	1101                	addi	sp,sp,-32
    80005fcc:	ec06                	sd	ra,24(sp)
    80005fce:	e822                	sd	s0,16(sp)
    80005fd0:	e426                	sd	s1,8(sp)
    80005fd2:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005fd4:	00020497          	auipc	s1,0x20
    80005fd8:	21448493          	addi	s1,s1,532 # 800261e8 <pr>
    80005fdc:	00003597          	auipc	a1,0x3
    80005fe0:	89c58593          	addi	a1,a1,-1892 # 80008878 <syscalls+0x450>
    80005fe4:	8526                	mv	a0,s1
    80005fe6:	00000097          	auipc	ra,0x0
    80005fea:	262080e7          	jalr	610(ra) # 80006248 <initlock>
  pr.locking = 1;
    80005fee:	4785                	li	a5,1
    80005ff0:	cc9c                	sw	a5,24(s1)
}
    80005ff2:	60e2                	ld	ra,24(sp)
    80005ff4:	6442                	ld	s0,16(sp)
    80005ff6:	64a2                	ld	s1,8(sp)
    80005ff8:	6105                	addi	sp,sp,32
    80005ffa:	8082                	ret

0000000080005ffc <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005ffc:	1141                	addi	sp,sp,-16
    80005ffe:	e406                	sd	ra,8(sp)
    80006000:	e022                	sd	s0,0(sp)
    80006002:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006004:	100007b7          	lui	a5,0x10000
    80006008:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000600c:	f8000713          	li	a4,-128
    80006010:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006014:	470d                	li	a4,3
    80006016:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    8000601a:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000601e:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006022:	469d                	li	a3,7
    80006024:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006028:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000602c:	00003597          	auipc	a1,0x3
    80006030:	86c58593          	addi	a1,a1,-1940 # 80008898 <digits+0x18>
    80006034:	00020517          	auipc	a0,0x20
    80006038:	1d450513          	addi	a0,a0,468 # 80026208 <uart_tx_lock>
    8000603c:	00000097          	auipc	ra,0x0
    80006040:	20c080e7          	jalr	524(ra) # 80006248 <initlock>
}
    80006044:	60a2                	ld	ra,8(sp)
    80006046:	6402                	ld	s0,0(sp)
    80006048:	0141                	addi	sp,sp,16
    8000604a:	8082                	ret

000000008000604c <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000604c:	1101                	addi	sp,sp,-32
    8000604e:	ec06                	sd	ra,24(sp)
    80006050:	e822                	sd	s0,16(sp)
    80006052:	e426                	sd	s1,8(sp)
    80006054:	1000                	addi	s0,sp,32
    80006056:	84aa                	mv	s1,a0
  push_off();
    80006058:	00000097          	auipc	ra,0x0
    8000605c:	234080e7          	jalr	564(ra) # 8000628c <push_off>

  if(panicked){
    80006060:	00003797          	auipc	a5,0x3
    80006064:	fbc7a783          	lw	a5,-68(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006068:	10000737          	lui	a4,0x10000
  if(panicked){
    8000606c:	c391                	beqz	a5,80006070 <uartputc_sync+0x24>
    for(;;)
    8000606e:	a001                	j	8000606e <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006070:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006074:	0207f793          	andi	a5,a5,32
    80006078:	dfe5                	beqz	a5,80006070 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000607a:	0ff4f513          	zext.b	a0,s1
    8000607e:	100007b7          	lui	a5,0x10000
    80006082:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80006086:	00000097          	auipc	ra,0x0
    8000608a:	2a6080e7          	jalr	678(ra) # 8000632c <pop_off>
}
    8000608e:	60e2                	ld	ra,24(sp)
    80006090:	6442                	ld	s0,16(sp)
    80006092:	64a2                	ld	s1,8(sp)
    80006094:	6105                	addi	sp,sp,32
    80006096:	8082                	ret

0000000080006098 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006098:	00003797          	auipc	a5,0x3
    8000609c:	f887b783          	ld	a5,-120(a5) # 80009020 <uart_tx_r>
    800060a0:	00003717          	auipc	a4,0x3
    800060a4:	f8873703          	ld	a4,-120(a4) # 80009028 <uart_tx_w>
    800060a8:	06f70a63          	beq	a4,a5,8000611c <uartstart+0x84>
{
    800060ac:	7139                	addi	sp,sp,-64
    800060ae:	fc06                	sd	ra,56(sp)
    800060b0:	f822                	sd	s0,48(sp)
    800060b2:	f426                	sd	s1,40(sp)
    800060b4:	f04a                	sd	s2,32(sp)
    800060b6:	ec4e                	sd	s3,24(sp)
    800060b8:	e852                	sd	s4,16(sp)
    800060ba:	e456                	sd	s5,8(sp)
    800060bc:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800060be:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800060c2:	00020a17          	auipc	s4,0x20
    800060c6:	146a0a13          	addi	s4,s4,326 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    800060ca:	00003497          	auipc	s1,0x3
    800060ce:	f5648493          	addi	s1,s1,-170 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    800060d2:	00003997          	auipc	s3,0x3
    800060d6:	f5698993          	addi	s3,s3,-170 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800060da:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    800060de:	02077713          	andi	a4,a4,32
    800060e2:	c705                	beqz	a4,8000610a <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800060e4:	01f7f713          	andi	a4,a5,31
    800060e8:	9752                	add	a4,a4,s4
    800060ea:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    800060ee:	0785                	addi	a5,a5,1
    800060f0:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800060f2:	8526                	mv	a0,s1
    800060f4:	ffffb097          	auipc	ra,0xffffb
    800060f8:	742080e7          	jalr	1858(ra) # 80001836 <wakeup>
    
    WriteReg(THR, c);
    800060fc:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006100:	609c                	ld	a5,0(s1)
    80006102:	0009b703          	ld	a4,0(s3)
    80006106:	fcf71ae3          	bne	a4,a5,800060da <uartstart+0x42>
  }
}
    8000610a:	70e2                	ld	ra,56(sp)
    8000610c:	7442                	ld	s0,48(sp)
    8000610e:	74a2                	ld	s1,40(sp)
    80006110:	7902                	ld	s2,32(sp)
    80006112:	69e2                	ld	s3,24(sp)
    80006114:	6a42                	ld	s4,16(sp)
    80006116:	6aa2                	ld	s5,8(sp)
    80006118:	6121                	addi	sp,sp,64
    8000611a:	8082                	ret
    8000611c:	8082                	ret

000000008000611e <uartputc>:
{
    8000611e:	7179                	addi	sp,sp,-48
    80006120:	f406                	sd	ra,40(sp)
    80006122:	f022                	sd	s0,32(sp)
    80006124:	ec26                	sd	s1,24(sp)
    80006126:	e84a                	sd	s2,16(sp)
    80006128:	e44e                	sd	s3,8(sp)
    8000612a:	e052                	sd	s4,0(sp)
    8000612c:	1800                	addi	s0,sp,48
    8000612e:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006130:	00020517          	auipc	a0,0x20
    80006134:	0d850513          	addi	a0,a0,216 # 80026208 <uart_tx_lock>
    80006138:	00000097          	auipc	ra,0x0
    8000613c:	1a0080e7          	jalr	416(ra) # 800062d8 <acquire>
  if(panicked){
    80006140:	00003797          	auipc	a5,0x3
    80006144:	edc7a783          	lw	a5,-292(a5) # 8000901c <panicked>
    80006148:	c391                	beqz	a5,8000614c <uartputc+0x2e>
    for(;;)
    8000614a:	a001                	j	8000614a <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000614c:	00003717          	auipc	a4,0x3
    80006150:	edc73703          	ld	a4,-292(a4) # 80009028 <uart_tx_w>
    80006154:	00003797          	auipc	a5,0x3
    80006158:	ecc7b783          	ld	a5,-308(a5) # 80009020 <uart_tx_r>
    8000615c:	02078793          	addi	a5,a5,32
    80006160:	02e79b63          	bne	a5,a4,80006196 <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006164:	00020997          	auipc	s3,0x20
    80006168:	0a498993          	addi	s3,s3,164 # 80026208 <uart_tx_lock>
    8000616c:	00003497          	auipc	s1,0x3
    80006170:	eb448493          	addi	s1,s1,-332 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006174:	00003917          	auipc	s2,0x3
    80006178:	eb490913          	addi	s2,s2,-332 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000617c:	85ce                	mv	a1,s3
    8000617e:	8526                	mv	a0,s1
    80006180:	ffffb097          	auipc	ra,0xffffb
    80006184:	52a080e7          	jalr	1322(ra) # 800016aa <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006188:	00093703          	ld	a4,0(s2)
    8000618c:	609c                	ld	a5,0(s1)
    8000618e:	02078793          	addi	a5,a5,32
    80006192:	fee785e3          	beq	a5,a4,8000617c <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006196:	00020497          	auipc	s1,0x20
    8000619a:	07248493          	addi	s1,s1,114 # 80026208 <uart_tx_lock>
    8000619e:	01f77793          	andi	a5,a4,31
    800061a2:	97a6                	add	a5,a5,s1
    800061a4:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    800061a8:	0705                	addi	a4,a4,1
    800061aa:	00003797          	auipc	a5,0x3
    800061ae:	e6e7bf23          	sd	a4,-386(a5) # 80009028 <uart_tx_w>
      uartstart();
    800061b2:	00000097          	auipc	ra,0x0
    800061b6:	ee6080e7          	jalr	-282(ra) # 80006098 <uartstart>
      release(&uart_tx_lock);
    800061ba:	8526                	mv	a0,s1
    800061bc:	00000097          	auipc	ra,0x0
    800061c0:	1d0080e7          	jalr	464(ra) # 8000638c <release>
}
    800061c4:	70a2                	ld	ra,40(sp)
    800061c6:	7402                	ld	s0,32(sp)
    800061c8:	64e2                	ld	s1,24(sp)
    800061ca:	6942                	ld	s2,16(sp)
    800061cc:	69a2                	ld	s3,8(sp)
    800061ce:	6a02                	ld	s4,0(sp)
    800061d0:	6145                	addi	sp,sp,48
    800061d2:	8082                	ret

00000000800061d4 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800061d4:	1141                	addi	sp,sp,-16
    800061d6:	e422                	sd	s0,8(sp)
    800061d8:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800061da:	100007b7          	lui	a5,0x10000
    800061de:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800061e2:	8b85                	andi	a5,a5,1
    800061e4:	cb81                	beqz	a5,800061f4 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    800061e6:	100007b7          	lui	a5,0x10000
    800061ea:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800061ee:	6422                	ld	s0,8(sp)
    800061f0:	0141                	addi	sp,sp,16
    800061f2:	8082                	ret
    return -1;
    800061f4:	557d                	li	a0,-1
    800061f6:	bfe5                	j	800061ee <uartgetc+0x1a>

00000000800061f8 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    800061f8:	1101                	addi	sp,sp,-32
    800061fa:	ec06                	sd	ra,24(sp)
    800061fc:	e822                	sd	s0,16(sp)
    800061fe:	e426                	sd	s1,8(sp)
    80006200:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006202:	54fd                	li	s1,-1
    80006204:	a029                	j	8000620e <uartintr+0x16>
      break;
    consoleintr(c);
    80006206:	00000097          	auipc	ra,0x0
    8000620a:	918080e7          	jalr	-1768(ra) # 80005b1e <consoleintr>
    int c = uartgetc();
    8000620e:	00000097          	auipc	ra,0x0
    80006212:	fc6080e7          	jalr	-58(ra) # 800061d4 <uartgetc>
    if(c == -1)
    80006216:	fe9518e3          	bne	a0,s1,80006206 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000621a:	00020497          	auipc	s1,0x20
    8000621e:	fee48493          	addi	s1,s1,-18 # 80026208 <uart_tx_lock>
    80006222:	8526                	mv	a0,s1
    80006224:	00000097          	auipc	ra,0x0
    80006228:	0b4080e7          	jalr	180(ra) # 800062d8 <acquire>
  uartstart();
    8000622c:	00000097          	auipc	ra,0x0
    80006230:	e6c080e7          	jalr	-404(ra) # 80006098 <uartstart>
  release(&uart_tx_lock);
    80006234:	8526                	mv	a0,s1
    80006236:	00000097          	auipc	ra,0x0
    8000623a:	156080e7          	jalr	342(ra) # 8000638c <release>
}
    8000623e:	60e2                	ld	ra,24(sp)
    80006240:	6442                	ld	s0,16(sp)
    80006242:	64a2                	ld	s1,8(sp)
    80006244:	6105                	addi	sp,sp,32
    80006246:	8082                	ret

0000000080006248 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006248:	1141                	addi	sp,sp,-16
    8000624a:	e422                	sd	s0,8(sp)
    8000624c:	0800                	addi	s0,sp,16
  lk->name = name;
    8000624e:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006250:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006254:	00053823          	sd	zero,16(a0)
}
    80006258:	6422                	ld	s0,8(sp)
    8000625a:	0141                	addi	sp,sp,16
    8000625c:	8082                	ret

000000008000625e <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000625e:	411c                	lw	a5,0(a0)
    80006260:	e399                	bnez	a5,80006266 <holding+0x8>
    80006262:	4501                	li	a0,0
  return r;
}
    80006264:	8082                	ret
{
    80006266:	1101                	addi	sp,sp,-32
    80006268:	ec06                	sd	ra,24(sp)
    8000626a:	e822                	sd	s0,16(sp)
    8000626c:	e426                	sd	s1,8(sp)
    8000626e:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006270:	6904                	ld	s1,16(a0)
    80006272:	ffffb097          	auipc	ra,0xffffb
    80006276:	ca8080e7          	jalr	-856(ra) # 80000f1a <mycpu>
    8000627a:	40a48533          	sub	a0,s1,a0
    8000627e:	00153513          	seqz	a0,a0
}
    80006282:	60e2                	ld	ra,24(sp)
    80006284:	6442                	ld	s0,16(sp)
    80006286:	64a2                	ld	s1,8(sp)
    80006288:	6105                	addi	sp,sp,32
    8000628a:	8082                	ret

000000008000628c <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    8000628c:	1101                	addi	sp,sp,-32
    8000628e:	ec06                	sd	ra,24(sp)
    80006290:	e822                	sd	s0,16(sp)
    80006292:	e426                	sd	s1,8(sp)
    80006294:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006296:	100024f3          	csrr	s1,sstatus
    8000629a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000629e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800062a0:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800062a4:	ffffb097          	auipc	ra,0xffffb
    800062a8:	c76080e7          	jalr	-906(ra) # 80000f1a <mycpu>
    800062ac:	5d3c                	lw	a5,120(a0)
    800062ae:	cf89                	beqz	a5,800062c8 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800062b0:	ffffb097          	auipc	ra,0xffffb
    800062b4:	c6a080e7          	jalr	-918(ra) # 80000f1a <mycpu>
    800062b8:	5d3c                	lw	a5,120(a0)
    800062ba:	2785                	addiw	a5,a5,1
    800062bc:	dd3c                	sw	a5,120(a0)
}
    800062be:	60e2                	ld	ra,24(sp)
    800062c0:	6442                	ld	s0,16(sp)
    800062c2:	64a2                	ld	s1,8(sp)
    800062c4:	6105                	addi	sp,sp,32
    800062c6:	8082                	ret
    mycpu()->intena = old;
    800062c8:	ffffb097          	auipc	ra,0xffffb
    800062cc:	c52080e7          	jalr	-942(ra) # 80000f1a <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800062d0:	8085                	srli	s1,s1,0x1
    800062d2:	8885                	andi	s1,s1,1
    800062d4:	dd64                	sw	s1,124(a0)
    800062d6:	bfe9                	j	800062b0 <push_off+0x24>

00000000800062d8 <acquire>:
{
    800062d8:	1101                	addi	sp,sp,-32
    800062da:	ec06                	sd	ra,24(sp)
    800062dc:	e822                	sd	s0,16(sp)
    800062de:	e426                	sd	s1,8(sp)
    800062e0:	1000                	addi	s0,sp,32
    800062e2:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800062e4:	00000097          	auipc	ra,0x0
    800062e8:	fa8080e7          	jalr	-88(ra) # 8000628c <push_off>
  if(holding(lk))
    800062ec:	8526                	mv	a0,s1
    800062ee:	00000097          	auipc	ra,0x0
    800062f2:	f70080e7          	jalr	-144(ra) # 8000625e <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800062f6:	4705                	li	a4,1
  if(holding(lk))
    800062f8:	e115                	bnez	a0,8000631c <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800062fa:	87ba                	mv	a5,a4
    800062fc:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006300:	2781                	sext.w	a5,a5
    80006302:	ffe5                	bnez	a5,800062fa <acquire+0x22>
  __sync_synchronize();
    80006304:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006308:	ffffb097          	auipc	ra,0xffffb
    8000630c:	c12080e7          	jalr	-1006(ra) # 80000f1a <mycpu>
    80006310:	e888                	sd	a0,16(s1)
}
    80006312:	60e2                	ld	ra,24(sp)
    80006314:	6442                	ld	s0,16(sp)
    80006316:	64a2                	ld	s1,8(sp)
    80006318:	6105                	addi	sp,sp,32
    8000631a:	8082                	ret
    panic("acquire");
    8000631c:	00002517          	auipc	a0,0x2
    80006320:	58450513          	addi	a0,a0,1412 # 800088a0 <digits+0x20>
    80006324:	00000097          	auipc	ra,0x0
    80006328:	a7c080e7          	jalr	-1412(ra) # 80005da0 <panic>

000000008000632c <pop_off>:

void
pop_off(void)
{
    8000632c:	1141                	addi	sp,sp,-16
    8000632e:	e406                	sd	ra,8(sp)
    80006330:	e022                	sd	s0,0(sp)
    80006332:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006334:	ffffb097          	auipc	ra,0xffffb
    80006338:	be6080e7          	jalr	-1050(ra) # 80000f1a <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000633c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006340:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006342:	e78d                	bnez	a5,8000636c <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006344:	5d3c                	lw	a5,120(a0)
    80006346:	02f05b63          	blez	a5,8000637c <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    8000634a:	37fd                	addiw	a5,a5,-1
    8000634c:	0007871b          	sext.w	a4,a5
    80006350:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006352:	eb09                	bnez	a4,80006364 <pop_off+0x38>
    80006354:	5d7c                	lw	a5,124(a0)
    80006356:	c799                	beqz	a5,80006364 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006358:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000635c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006360:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006364:	60a2                	ld	ra,8(sp)
    80006366:	6402                	ld	s0,0(sp)
    80006368:	0141                	addi	sp,sp,16
    8000636a:	8082                	ret
    panic("pop_off - interruptible");
    8000636c:	00002517          	auipc	a0,0x2
    80006370:	53c50513          	addi	a0,a0,1340 # 800088a8 <digits+0x28>
    80006374:	00000097          	auipc	ra,0x0
    80006378:	a2c080e7          	jalr	-1492(ra) # 80005da0 <panic>
    panic("pop_off");
    8000637c:	00002517          	auipc	a0,0x2
    80006380:	54450513          	addi	a0,a0,1348 # 800088c0 <digits+0x40>
    80006384:	00000097          	auipc	ra,0x0
    80006388:	a1c080e7          	jalr	-1508(ra) # 80005da0 <panic>

000000008000638c <release>:
{
    8000638c:	1101                	addi	sp,sp,-32
    8000638e:	ec06                	sd	ra,24(sp)
    80006390:	e822                	sd	s0,16(sp)
    80006392:	e426                	sd	s1,8(sp)
    80006394:	1000                	addi	s0,sp,32
    80006396:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006398:	00000097          	auipc	ra,0x0
    8000639c:	ec6080e7          	jalr	-314(ra) # 8000625e <holding>
    800063a0:	c115                	beqz	a0,800063c4 <release+0x38>
  lk->cpu = 0;
    800063a2:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800063a6:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800063aa:	0f50000f          	fence	iorw,ow
    800063ae:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800063b2:	00000097          	auipc	ra,0x0
    800063b6:	f7a080e7          	jalr	-134(ra) # 8000632c <pop_off>
}
    800063ba:	60e2                	ld	ra,24(sp)
    800063bc:	6442                	ld	s0,16(sp)
    800063be:	64a2                	ld	s1,8(sp)
    800063c0:	6105                	addi	sp,sp,32
    800063c2:	8082                	ret
    panic("release");
    800063c4:	00002517          	auipc	a0,0x2
    800063c8:	50450513          	addi	a0,a0,1284 # 800088c8 <digits+0x48>
    800063cc:	00000097          	auipc	ra,0x0
    800063d0:	9d4080e7          	jalr	-1580(ra) # 80005da0 <panic>
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
