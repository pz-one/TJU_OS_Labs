
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	84013103          	ld	sp,-1984(sp) # 80008840 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	34d050ef          	jal	ra,80005b62 <start>

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
    80000030:	00032797          	auipc	a5,0x32
    80000034:	21078793          	addi	a5,a5,528 # 80032240 <end>
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
    8000005e:	4ee080e7          	jalr	1262(ra) # 80006548 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	58e080e7          	jalr	1422(ra) # 800065fc <release>
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
    8000008e:	f86080e7          	jalr	-122(ra) # 80006010 <panic>

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
    800000fa:	3c2080e7          	jalr	962(ra) # 800064b8 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	slli	a1,a1,0x1b
    80000102:	00032517          	auipc	a0,0x32
    80000106:	13e50513          	addi	a0,a0,318 # 80032240 <end>
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
    80000132:	41a080e7          	jalr	1050(ra) # 80006548 <acquire>
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
    8000014a:	4b6080e7          	jalr	1206(ra) # 800065fc <release>

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
    80000174:	48c080e7          	jalr	1164(ra) # 800065fc <release>
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
    800001ee:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffccdc1>
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
    8000032c:	ad6080e7          	jalr	-1322(ra) # 80000dfe <cpuid>
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
    80000348:	aba080e7          	jalr	-1350(ra) # 80000dfe <cpuid>
    8000034c:	85aa                	mv	a1,a0
    8000034e:	00008517          	auipc	a0,0x8
    80000352:	cea50513          	addi	a0,a0,-790 # 80008038 <etext+0x38>
    80000356:	00006097          	auipc	ra,0x6
    8000035a:	d04080e7          	jalr	-764(ra) # 8000605a <printf>
    kvminithart();    // turn on paging
    8000035e:	00000097          	auipc	ra,0x0
    80000362:	0d8080e7          	jalr	216(ra) # 80000436 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000366:	00001097          	auipc	ra,0x1
    8000036a:	794080e7          	jalr	1940(ra) # 80001afa <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000036e:	00005097          	auipc	ra,0x5
    80000372:	1d2080e7          	jalr	466(ra) # 80005540 <plicinithart>
  }

  scheduler();        
    80000376:	00001097          	auipc	ra,0x1
    8000037a:	004080e7          	jalr	4(ra) # 8000137a <scheduler>
    consoleinit();
    8000037e:	00006097          	auipc	ra,0x6
    80000382:	ba2080e7          	jalr	-1118(ra) # 80005f20 <consoleinit>
    printfinit();
    80000386:	00006097          	auipc	ra,0x6
    8000038a:	eb4080e7          	jalr	-332(ra) # 8000623a <printfinit>
    printf("\n");
    8000038e:	00008517          	auipc	a0,0x8
    80000392:	cba50513          	addi	a0,a0,-838 # 80008048 <etext+0x48>
    80000396:	00006097          	auipc	ra,0x6
    8000039a:	cc4080e7          	jalr	-828(ra) # 8000605a <printf>
    printf("xv6 kernel is booting\n");
    8000039e:	00008517          	auipc	a0,0x8
    800003a2:	c8250513          	addi	a0,a0,-894 # 80008020 <etext+0x20>
    800003a6:	00006097          	auipc	ra,0x6
    800003aa:	cb4080e7          	jalr	-844(ra) # 8000605a <printf>
    printf("\n");
    800003ae:	00008517          	auipc	a0,0x8
    800003b2:	c9a50513          	addi	a0,a0,-870 # 80008048 <etext+0x48>
    800003b6:	00006097          	auipc	ra,0x6
    800003ba:	ca4080e7          	jalr	-860(ra) # 8000605a <printf>
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
    800003da:	978080e7          	jalr	-1672(ra) # 80000d4e <procinit>
    trapinit();      // trap vectors
    800003de:	00001097          	auipc	ra,0x1
    800003e2:	6f4080e7          	jalr	1780(ra) # 80001ad2 <trapinit>
    trapinithart();  // install kernel trap vector
    800003e6:	00001097          	auipc	ra,0x1
    800003ea:	714080e7          	jalr	1812(ra) # 80001afa <trapinithart>
    plicinit();      // set up interrupt controller
    800003ee:	00005097          	auipc	ra,0x5
    800003f2:	13c080e7          	jalr	316(ra) # 8000552a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003f6:	00005097          	auipc	ra,0x5
    800003fa:	14a080e7          	jalr	330(ra) # 80005540 <plicinithart>
    binit();         // buffer cache
    800003fe:	00002097          	auipc	ra,0x2
    80000402:	f6e080e7          	jalr	-146(ra) # 8000236c <binit>
    iinit();         // inode table
    80000406:	00002097          	auipc	ra,0x2
    8000040a:	5fc080e7          	jalr	1532(ra) # 80002a02 <iinit>
    fileinit();      // file table
    8000040e:	00003097          	auipc	ra,0x3
    80000412:	5ae080e7          	jalr	1454(ra) # 800039bc <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000416:	00005097          	auipc	ra,0x5
    8000041a:	24a080e7          	jalr	586(ra) # 80005660 <virtio_disk_init>
    userinit();      // first user process
    8000041e:	00001097          	auipc	ra,0x1
    80000422:	ce4080e7          	jalr	-796(ra) # 80001102 <userinit>
    __sync_synchronize();
    80000426:	0ff0000f          	fence
    started = 1;
    8000042a:	4785                	li	a5,1
    8000042c:	00009717          	auipc	a4,0x9
    80000430:	bcf72a23          	sw	a5,-1068(a4) # 80009000 <started>
    80000434:	b789                	j	80000376 <main+0x56>

0000000080000436 <kvminithart>:
}

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void kvminithart()
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
  if (va >= MAXVA)
    80000474:	57fd                	li	a5,-1
    80000476:	83e9                	srli	a5,a5,0x1a
    80000478:	4a79                	li	s4,30
    panic("walk");

  for (int level = 2; level > 0; level--)
    8000047a:	4b31                	li	s6,12
  if (va >= MAXVA)
    8000047c:	04b7f263          	bgeu	a5,a1,800004c0 <walk+0x66>
    panic("walk");
    80000480:	00008517          	auipc	a0,0x8
    80000484:	bd050513          	addi	a0,a0,-1072 # 80008050 <etext+0x50>
    80000488:	00006097          	auipc	ra,0x6
    8000048c:	b88080e7          	jalr	-1144(ra) # 80006010 <panic>
    {
      pagetable = (pagetable_t)PTE2PA(*pte);
    }
    else
    {
      if (!alloc || (pagetable = (pde_t *)kalloc()) == 0)
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
  for (int level = 2; level > 0; level--)
    800004ba:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffccdb7>
    800004bc:	036a0063          	beq	s4,s6,800004dc <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004c0:	0149d933          	srl	s2,s3,s4
    800004c4:	1ff97913          	andi	s2,s2,511
    800004c8:	090e                	slli	s2,s2,0x3
    800004ca:	9926                	add	s2,s2,s1
    if (*pte & PTE_V)
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

  if (va >= MAXVA)
    80000500:	57fd                	li	a5,-1
    80000502:	83e9                	srli	a5,a5,0x1a
    80000504:	00b7f463          	bgeu	a5,a1,8000050c <walkaddr+0xc>
    return 0;
    80000508:	4501                	li	a0,0
    return 0;
  if ((*pte & PTE_U) == 0)
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
  if (pte == 0)
    8000051e:	c105                	beqz	a0,8000053e <walkaddr+0x3e>
  if ((*pte & PTE_V) == 0)
    80000520:	611c                	ld	a5,0(a0)
  if ((*pte & PTE_U) == 0)
    80000522:	0117f693          	andi	a3,a5,17
    80000526:	4745                	li	a4,17
    return 0;
    80000528:	4501                	li	a0,0
  if ((*pte & PTE_U) == 0)
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
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
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

  if (size == 0)
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
    if (*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if (a == last)
      break;
    a += PGSIZE;
    80000574:	6b85                	lui	s7,0x1
    80000576:	012a04b3          	add	s1,s4,s2
    if ((pte = walk(pagetable, a, 1)) == 0)
    8000057a:	4605                	li	a2,1
    8000057c:	85ca                	mv	a1,s2
    8000057e:	8556                	mv	a0,s5
    80000580:	00000097          	auipc	ra,0x0
    80000584:	eda080e7          	jalr	-294(ra) # 8000045a <walk>
    80000588:	cd1d                	beqz	a0,800005c6 <mappages+0x84>
    if (*pte & PTE_V)
    8000058a:	611c                	ld	a5,0(a0)
    8000058c:	8b85                	andi	a5,a5,1
    8000058e:	e785                	bnez	a5,800005b6 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000590:	80b1                	srli	s1,s1,0xc
    80000592:	04aa                	slli	s1,s1,0xa
    80000594:	0164e4b3          	or	s1,s1,s6
    80000598:	0014e493          	ori	s1,s1,1
    8000059c:	e104                	sd	s1,0(a0)
    if (a == last)
    8000059e:	05390063          	beq	s2,s3,800005de <mappages+0x9c>
    a += PGSIZE;
    800005a2:	995e                	add	s2,s2,s7
    if ((pte = walk(pagetable, a, 1)) == 0)
    800005a4:	bfc9                	j	80000576 <mappages+0x34>
    panic("mappages: size");
    800005a6:	00008517          	auipc	a0,0x8
    800005aa:	ab250513          	addi	a0,a0,-1358 # 80008058 <etext+0x58>
    800005ae:	00006097          	auipc	ra,0x6
    800005b2:	a62080e7          	jalr	-1438(ra) # 80006010 <panic>
      panic("mappages: remap");
    800005b6:	00008517          	auipc	a0,0x8
    800005ba:	ab250513          	addi	a0,a0,-1358 # 80008068 <etext+0x68>
    800005be:	00006097          	auipc	ra,0x6
    800005c2:	a52080e7          	jalr	-1454(ra) # 80006010 <panic>
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
  if (mappages(kpgtbl, va, sz, pa, perm) != 0)
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
    8000060a:	00006097          	auipc	ra,0x6
    8000060e:	a06080e7          	jalr	-1530(ra) # 80006010 <panic>

0000000080000612 <kvmmake>:
{
    80000612:	1101                	addi	sp,sp,-32
    80000614:	ec06                	sd	ra,24(sp)
    80000616:	e822                	sd	s0,16(sp)
    80000618:	e426                	sd	s1,8(sp)
    8000061a:	e04a                	sd	s2,0(sp)
    8000061c:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t)kalloc();
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
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext - KERNBASE, PTE_R | PTE_X);
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
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP - (uint64)etext, PTE_R | PTE_W);
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
    800006d6:	5e6080e7          	jalr	1510(ra) # 80000cb8 <proc_mapstacks>
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
void uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
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

  if ((va % PGSIZE) != 0)
    8000071e:	03459793          	slli	a5,a1,0x34
    80000722:	e795                	bnez	a5,8000074e <uvmunmap+0x46>
    80000724:	8a2a                	mv	s4,a0
    80000726:	892e                	mv	s2,a1
    80000728:	8b36                	mv	s6,a3
    panic("uvmunmap: not aligned");

  for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
    8000072a:	0632                	slli	a2,a2,0xc
    8000072c:	00b609b3          	add	s3,a2,a1
    if ((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if ((*pte & PTE_V) == 0)
      continue;
    // panic("uvmunmap: not mapped");
    if (PTE_FLAGS(*pte) == PTE_V)
    80000730:	4b85                	li	s7,1
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
    80000732:	6a85                	lui	s5,0x1
    80000734:	0535ea63          	bltu	a1,s3,80000788 <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
      kfree((void *)pa);
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
    80000756:	00006097          	auipc	ra,0x6
    8000075a:	8ba080e7          	jalr	-1862(ra) # 80006010 <panic>
      panic("uvmunmap: walk");
    8000075e:	00008517          	auipc	a0,0x8
    80000762:	93a50513          	addi	a0,a0,-1734 # 80008098 <etext+0x98>
    80000766:	00006097          	auipc	ra,0x6
    8000076a:	8aa080e7          	jalr	-1878(ra) # 80006010 <panic>
      panic("uvmunmap: not a leaf");
    8000076e:	00008517          	auipc	a0,0x8
    80000772:	93a50513          	addi	a0,a0,-1734 # 800080a8 <etext+0xa8>
    80000776:	00006097          	auipc	ra,0x6
    8000077a:	89a080e7          	jalr	-1894(ra) # 80006010 <panic>
    *pte = 0;
    8000077e:	0004b023          	sd	zero,0(s1)
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
    80000782:	9956                	add	s2,s2,s5
    80000784:	fb397ae3          	bgeu	s2,s3,80000738 <uvmunmap+0x30>
    if ((pte = walk(pagetable, a, 0)) == 0)
    80000788:	4601                	li	a2,0
    8000078a:	85ca                	mv	a1,s2
    8000078c:	8552                	mv	a0,s4
    8000078e:	00000097          	auipc	ra,0x0
    80000792:	ccc080e7          	jalr	-820(ra) # 8000045a <walk>
    80000796:	84aa                	mv	s1,a0
    80000798:	d179                	beqz	a0,8000075e <uvmunmap+0x56>
    if ((*pte & PTE_V) == 0)
    8000079a:	611c                	ld	a5,0(a0)
    8000079c:	0017f713          	andi	a4,a5,1
    800007a0:	d36d                	beqz	a4,80000782 <uvmunmap+0x7a>
    if (PTE_FLAGS(*pte) == PTE_V)
    800007a2:	3ff7f713          	andi	a4,a5,1023
    800007a6:	fd7704e3          	beq	a4,s7,8000076e <uvmunmap+0x66>
    if (do_free)
    800007aa:	fc0b0ae3          	beqz	s6,8000077e <uvmunmap+0x76>
      uint64 pa = PTE2PA(*pte);
    800007ae:	83a9                	srli	a5,a5,0xa
      kfree((void *)pa);
    800007b0:	00c79513          	slli	a0,a5,0xc
    800007b4:	00000097          	auipc	ra,0x0
    800007b8:	868080e7          	jalr	-1944(ra) # 8000001c <kfree>
    800007bc:	b7c9                	j	8000077e <uvmunmap+0x76>

00000000800007be <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007be:	1101                	addi	sp,sp,-32
    800007c0:	ec06                	sd	ra,24(sp)
    800007c2:	e822                	sd	s0,16(sp)
    800007c4:	e426                	sd	s1,8(sp)
    800007c6:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t)kalloc();
    800007c8:	00000097          	auipc	ra,0x0
    800007cc:	952080e7          	jalr	-1710(ra) # 8000011a <kalloc>
    800007d0:	84aa                	mv	s1,a0
  if (pagetable == 0)
    800007d2:	c519                	beqz	a0,800007e0 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007d4:	6605                	lui	a2,0x1
    800007d6:	4581                	li	a1,0
    800007d8:	00000097          	auipc	ra,0x0
    800007dc:	9a2080e7          	jalr	-1630(ra) # 8000017a <memset>
  return pagetable;
}
    800007e0:	8526                	mv	a0,s1
    800007e2:	60e2                	ld	ra,24(sp)
    800007e4:	6442                	ld	s0,16(sp)
    800007e6:	64a2                	ld	s1,8(sp)
    800007e8:	6105                	addi	sp,sp,32
    800007ea:	8082                	ret

00000000800007ec <uvminit>:

// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    800007ec:	7179                	addi	sp,sp,-48
    800007ee:	f406                	sd	ra,40(sp)
    800007f0:	f022                	sd	s0,32(sp)
    800007f2:	ec26                	sd	s1,24(sp)
    800007f4:	e84a                	sd	s2,16(sp)
    800007f6:	e44e                	sd	s3,8(sp)
    800007f8:	e052                	sd	s4,0(sp)
    800007fa:	1800                	addi	s0,sp,48
  char *mem;

  if (sz >= PGSIZE)
    800007fc:	6785                	lui	a5,0x1
    800007fe:	04f67863          	bgeu	a2,a5,8000084e <uvminit+0x62>
    80000802:	8a2a                	mv	s4,a0
    80000804:	89ae                	mv	s3,a1
    80000806:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80000808:	00000097          	auipc	ra,0x0
    8000080c:	912080e7          	jalr	-1774(ra) # 8000011a <kalloc>
    80000810:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000812:	6605                	lui	a2,0x1
    80000814:	4581                	li	a1,0
    80000816:	00000097          	auipc	ra,0x0
    8000081a:	964080e7          	jalr	-1692(ra) # 8000017a <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W | PTE_R | PTE_X | PTE_U);
    8000081e:	4779                	li	a4,30
    80000820:	86ca                	mv	a3,s2
    80000822:	6605                	lui	a2,0x1
    80000824:	4581                	li	a1,0
    80000826:	8552                	mv	a0,s4
    80000828:	00000097          	auipc	ra,0x0
    8000082c:	d1a080e7          	jalr	-742(ra) # 80000542 <mappages>
  memmove(mem, src, sz);
    80000830:	8626                	mv	a2,s1
    80000832:	85ce                	mv	a1,s3
    80000834:	854a                	mv	a0,s2
    80000836:	00000097          	auipc	ra,0x0
    8000083a:	9a0080e7          	jalr	-1632(ra) # 800001d6 <memmove>
}
    8000083e:	70a2                	ld	ra,40(sp)
    80000840:	7402                	ld	s0,32(sp)
    80000842:	64e2                	ld	s1,24(sp)
    80000844:	6942                	ld	s2,16(sp)
    80000846:	69a2                	ld	s3,8(sp)
    80000848:	6a02                	ld	s4,0(sp)
    8000084a:	6145                	addi	sp,sp,48
    8000084c:	8082                	ret
    panic("inituvm: more than a page");
    8000084e:	00008517          	auipc	a0,0x8
    80000852:	87250513          	addi	a0,a0,-1934 # 800080c0 <etext+0xc0>
    80000856:	00005097          	auipc	ra,0x5
    8000085a:	7ba080e7          	jalr	1978(ra) # 80006010 <panic>

000000008000085e <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000085e:	1101                	addi	sp,sp,-32
    80000860:	ec06                	sd	ra,24(sp)
    80000862:	e822                	sd	s0,16(sp)
    80000864:	e426                	sd	s1,8(sp)
    80000866:	1000                	addi	s0,sp,32
  if (newsz >= oldsz)
    return oldsz;
    80000868:	84ae                	mv	s1,a1
  if (newsz >= oldsz)
    8000086a:	00b67d63          	bgeu	a2,a1,80000884 <uvmdealloc+0x26>
    8000086e:	84b2                	mv	s1,a2

  if (PGROUNDUP(newsz) < PGROUNDUP(oldsz))
    80000870:	6785                	lui	a5,0x1
    80000872:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000874:	00f60733          	add	a4,a2,a5
    80000878:	76fd                	lui	a3,0xfffff
    8000087a:	8f75                	and	a4,a4,a3
    8000087c:	97ae                	add	a5,a5,a1
    8000087e:	8ff5                	and	a5,a5,a3
    80000880:	00f76863          	bltu	a4,a5,80000890 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000884:	8526                	mv	a0,s1
    80000886:	60e2                	ld	ra,24(sp)
    80000888:	6442                	ld	s0,16(sp)
    8000088a:	64a2                	ld	s1,8(sp)
    8000088c:	6105                	addi	sp,sp,32
    8000088e:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000890:	8f99                	sub	a5,a5,a4
    80000892:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80000894:	4685                	li	a3,1
    80000896:	0007861b          	sext.w	a2,a5
    8000089a:	85ba                	mv	a1,a4
    8000089c:	00000097          	auipc	ra,0x0
    800008a0:	e6c080e7          	jalr	-404(ra) # 80000708 <uvmunmap>
    800008a4:	b7c5                	j	80000884 <uvmdealloc+0x26>

00000000800008a6 <uvmalloc>:
  if (newsz < oldsz)
    800008a6:	0ab66163          	bltu	a2,a1,80000948 <uvmalloc+0xa2>
{
    800008aa:	7139                	addi	sp,sp,-64
    800008ac:	fc06                	sd	ra,56(sp)
    800008ae:	f822                	sd	s0,48(sp)
    800008b0:	f426                	sd	s1,40(sp)
    800008b2:	f04a                	sd	s2,32(sp)
    800008b4:	ec4e                	sd	s3,24(sp)
    800008b6:	e852                	sd	s4,16(sp)
    800008b8:	e456                	sd	s5,8(sp)
    800008ba:	0080                	addi	s0,sp,64
    800008bc:	8aaa                	mv	s5,a0
    800008be:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008c0:	6785                	lui	a5,0x1
    800008c2:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008c4:	95be                	add	a1,a1,a5
    800008c6:	77fd                	lui	a5,0xfffff
    800008c8:	00f5f9b3          	and	s3,a1,a5
  for (a = oldsz; a < newsz; a += PGSIZE)
    800008cc:	08c9f063          	bgeu	s3,a2,8000094c <uvmalloc+0xa6>
    800008d0:	894e                	mv	s2,s3
    mem = kalloc();
    800008d2:	00000097          	auipc	ra,0x0
    800008d6:	848080e7          	jalr	-1976(ra) # 8000011a <kalloc>
    800008da:	84aa                	mv	s1,a0
    if (mem == 0)
    800008dc:	c51d                	beqz	a0,8000090a <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800008de:	6605                	lui	a2,0x1
    800008e0:	4581                	li	a1,0
    800008e2:	00000097          	auipc	ra,0x0
    800008e6:	898080e7          	jalr	-1896(ra) # 8000017a <memset>
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W | PTE_X | PTE_R | PTE_U) != 0)
    800008ea:	4779                	li	a4,30
    800008ec:	86a6                	mv	a3,s1
    800008ee:	6605                	lui	a2,0x1
    800008f0:	85ca                	mv	a1,s2
    800008f2:	8556                	mv	a0,s5
    800008f4:	00000097          	auipc	ra,0x0
    800008f8:	c4e080e7          	jalr	-946(ra) # 80000542 <mappages>
    800008fc:	e905                	bnez	a0,8000092c <uvmalloc+0x86>
  for (a = oldsz; a < newsz; a += PGSIZE)
    800008fe:	6785                	lui	a5,0x1
    80000900:	993e                	add	s2,s2,a5
    80000902:	fd4968e3          	bltu	s2,s4,800008d2 <uvmalloc+0x2c>
  return newsz;
    80000906:	8552                	mv	a0,s4
    80000908:	a809                	j	8000091a <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    8000090a:	864e                	mv	a2,s3
    8000090c:	85ca                	mv	a1,s2
    8000090e:	8556                	mv	a0,s5
    80000910:	00000097          	auipc	ra,0x0
    80000914:	f4e080e7          	jalr	-178(ra) # 8000085e <uvmdealloc>
      return 0;
    80000918:	4501                	li	a0,0
}
    8000091a:	70e2                	ld	ra,56(sp)
    8000091c:	7442                	ld	s0,48(sp)
    8000091e:	74a2                	ld	s1,40(sp)
    80000920:	7902                	ld	s2,32(sp)
    80000922:	69e2                	ld	s3,24(sp)
    80000924:	6a42                	ld	s4,16(sp)
    80000926:	6aa2                	ld	s5,8(sp)
    80000928:	6121                	addi	sp,sp,64
    8000092a:	8082                	ret
      kfree(mem);
    8000092c:	8526                	mv	a0,s1
    8000092e:	fffff097          	auipc	ra,0xfffff
    80000932:	6ee080e7          	jalr	1774(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000936:	864e                	mv	a2,s3
    80000938:	85ca                	mv	a1,s2
    8000093a:	8556                	mv	a0,s5
    8000093c:	00000097          	auipc	ra,0x0
    80000940:	f22080e7          	jalr	-222(ra) # 8000085e <uvmdealloc>
      return 0;
    80000944:	4501                	li	a0,0
    80000946:	bfd1                	j	8000091a <uvmalloc+0x74>
    return oldsz;
    80000948:	852e                	mv	a0,a1
}
    8000094a:	8082                	ret
  return newsz;
    8000094c:	8532                	mv	a0,a2
    8000094e:	b7f1                	j	8000091a <uvmalloc+0x74>

0000000080000950 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void freewalk(pagetable_t pagetable)
{
    80000950:	7179                	addi	sp,sp,-48
    80000952:	f406                	sd	ra,40(sp)
    80000954:	f022                	sd	s0,32(sp)
    80000956:	ec26                	sd	s1,24(sp)
    80000958:	e84a                	sd	s2,16(sp)
    8000095a:	e44e                	sd	s3,8(sp)
    8000095c:	e052                	sd	s4,0(sp)
    8000095e:	1800                	addi	s0,sp,48
    80000960:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for (int i = 0; i < 512; i++)
    80000962:	84aa                	mv	s1,a0
    80000964:	6905                	lui	s2,0x1
    80000966:	992a                	add	s2,s2,a0
  {
    pte_t pte = pagetable[i];
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0)
    80000968:	4985                	li	s3,1
    8000096a:	a829                	j	80000984 <freewalk+0x34>
    {
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    8000096c:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    8000096e:	00c79513          	slli	a0,a5,0xc
    80000972:	00000097          	auipc	ra,0x0
    80000976:	fde080e7          	jalr	-34(ra) # 80000950 <freewalk>
      pagetable[i] = 0;
    8000097a:	0004b023          	sd	zero,0(s1)
  for (int i = 0; i < 512; i++)
    8000097e:	04a1                	addi	s1,s1,8
    80000980:	03248163          	beq	s1,s2,800009a2 <freewalk+0x52>
    pte_t pte = pagetable[i];
    80000984:	609c                	ld	a5,0(s1)
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0)
    80000986:	00f7f713          	andi	a4,a5,15
    8000098a:	ff3701e3          	beq	a4,s3,8000096c <freewalk+0x1c>
    }
    else if (pte & PTE_V)
    8000098e:	8b85                	andi	a5,a5,1
    80000990:	d7fd                	beqz	a5,8000097e <freewalk+0x2e>
    {
      panic("freewalk: leaf");
    80000992:	00007517          	auipc	a0,0x7
    80000996:	74e50513          	addi	a0,a0,1870 # 800080e0 <etext+0xe0>
    8000099a:	00005097          	auipc	ra,0x5
    8000099e:	676080e7          	jalr	1654(ra) # 80006010 <panic>
    }
  }
  kfree((void *)pagetable);
    800009a2:	8552                	mv	a0,s4
    800009a4:	fffff097          	auipc	ra,0xfffff
    800009a8:	678080e7          	jalr	1656(ra) # 8000001c <kfree>
}
    800009ac:	70a2                	ld	ra,40(sp)
    800009ae:	7402                	ld	s0,32(sp)
    800009b0:	64e2                	ld	s1,24(sp)
    800009b2:	6942                	ld	s2,16(sp)
    800009b4:	69a2                	ld	s3,8(sp)
    800009b6:	6a02                	ld	s4,0(sp)
    800009b8:	6145                	addi	sp,sp,48
    800009ba:	8082                	ret

00000000800009bc <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009bc:	1101                	addi	sp,sp,-32
    800009be:	ec06                	sd	ra,24(sp)
    800009c0:	e822                	sd	s0,16(sp)
    800009c2:	e426                	sd	s1,8(sp)
    800009c4:	1000                	addi	s0,sp,32
    800009c6:	84aa                	mv	s1,a0
  if (sz > 0)
    800009c8:	e999                	bnez	a1,800009de <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
  freewalk(pagetable);
    800009ca:	8526                	mv	a0,s1
    800009cc:	00000097          	auipc	ra,0x0
    800009d0:	f84080e7          	jalr	-124(ra) # 80000950 <freewalk>
}
    800009d4:	60e2                	ld	ra,24(sp)
    800009d6:	6442                	ld	s0,16(sp)
    800009d8:	64a2                	ld	s1,8(sp)
    800009da:	6105                	addi	sp,sp,32
    800009dc:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    800009de:	6785                	lui	a5,0x1
    800009e0:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800009e2:	95be                	add	a1,a1,a5
    800009e4:	4685                	li	a3,1
    800009e6:	00c5d613          	srli	a2,a1,0xc
    800009ea:	4581                	li	a1,0
    800009ec:	00000097          	auipc	ra,0x0
    800009f0:	d1c080e7          	jalr	-740(ra) # 80000708 <uvmunmap>
    800009f4:	bfd9                	j	800009ca <uvmfree+0xe>

00000000800009f6 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for (i = 0; i < sz; i += PGSIZE)
    800009f6:	c269                	beqz	a2,80000ab8 <uvmcopy+0xc2>
{
    800009f8:	715d                	addi	sp,sp,-80
    800009fa:	e486                	sd	ra,72(sp)
    800009fc:	e0a2                	sd	s0,64(sp)
    800009fe:	fc26                	sd	s1,56(sp)
    80000a00:	f84a                	sd	s2,48(sp)
    80000a02:	f44e                	sd	s3,40(sp)
    80000a04:	f052                	sd	s4,32(sp)
    80000a06:	ec56                	sd	s5,24(sp)
    80000a08:	e85a                	sd	s6,16(sp)
    80000a0a:	e45e                	sd	s7,8(sp)
    80000a0c:	0880                	addi	s0,sp,80
    80000a0e:	8aaa                	mv	s5,a0
    80000a10:	8b2e                	mv	s6,a1
    80000a12:	8a32                	mv	s4,a2
  for (i = 0; i < sz; i += PGSIZE)
    80000a14:	4481                	li	s1,0
    80000a16:	a829                	j	80000a30 <uvmcopy+0x3a>
  {
    if ((pte = walk(old, i, 0)) == 0)
      panic("uvmcopy: pte should exist");
    80000a18:	00007517          	auipc	a0,0x7
    80000a1c:	6d850513          	addi	a0,a0,1752 # 800080f0 <etext+0xf0>
    80000a20:	00005097          	auipc	ra,0x5
    80000a24:	5f0080e7          	jalr	1520(ra) # 80006010 <panic>
  for (i = 0; i < sz; i += PGSIZE)
    80000a28:	6785                	lui	a5,0x1
    80000a2a:	94be                	add	s1,s1,a5
    80000a2c:	0944f463          	bgeu	s1,s4,80000ab4 <uvmcopy+0xbe>
    if ((pte = walk(old, i, 0)) == 0)
    80000a30:	4601                	li	a2,0
    80000a32:	85a6                	mv	a1,s1
    80000a34:	8556                	mv	a0,s5
    80000a36:	00000097          	auipc	ra,0x0
    80000a3a:	a24080e7          	jalr	-1500(ra) # 8000045a <walk>
    80000a3e:	dd69                	beqz	a0,80000a18 <uvmcopy+0x22>
    if ((*pte & PTE_V) == 0)
    80000a40:	6118                	ld	a4,0(a0)
    80000a42:	00177793          	andi	a5,a4,1
    80000a46:	d3ed                	beqz	a5,80000a28 <uvmcopy+0x32>
      // panic("uvmcopy: page not present");
      continue;
    pa = PTE2PA(*pte);
    80000a48:	00a75593          	srli	a1,a4,0xa
    80000a4c:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a50:	3ff77913          	andi	s2,a4,1023
    if ((mem = kalloc()) == 0)
    80000a54:	fffff097          	auipc	ra,0xfffff
    80000a58:	6c6080e7          	jalr	1734(ra) # 8000011a <kalloc>
    80000a5c:	89aa                	mv	s3,a0
    80000a5e:	c515                	beqz	a0,80000a8a <uvmcopy+0x94>
      goto err;
    memmove(mem, (char *)pa, PGSIZE);
    80000a60:	6605                	lui	a2,0x1
    80000a62:	85de                	mv	a1,s7
    80000a64:	fffff097          	auipc	ra,0xfffff
    80000a68:	772080e7          	jalr	1906(ra) # 800001d6 <memmove>
    if (mappages(new, i, PGSIZE, (uint64)mem, flags) != 0)
    80000a6c:	874a                	mv	a4,s2
    80000a6e:	86ce                	mv	a3,s3
    80000a70:	6605                	lui	a2,0x1
    80000a72:	85a6                	mv	a1,s1
    80000a74:	855a                	mv	a0,s6
    80000a76:	00000097          	auipc	ra,0x0
    80000a7a:	acc080e7          	jalr	-1332(ra) # 80000542 <mappages>
    80000a7e:	d54d                	beqz	a0,80000a28 <uvmcopy+0x32>
    {
      kfree(mem);
    80000a80:	854e                	mv	a0,s3
    80000a82:	fffff097          	auipc	ra,0xfffff
    80000a86:	59a080e7          	jalr	1434(ra) # 8000001c <kfree>
    }
  }
  return 0;

err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000a8a:	4685                	li	a3,1
    80000a8c:	00c4d613          	srli	a2,s1,0xc
    80000a90:	4581                	li	a1,0
    80000a92:	855a                	mv	a0,s6
    80000a94:	00000097          	auipc	ra,0x0
    80000a98:	c74080e7          	jalr	-908(ra) # 80000708 <uvmunmap>
  return -1;
    80000a9c:	557d                	li	a0,-1
}
    80000a9e:	60a6                	ld	ra,72(sp)
    80000aa0:	6406                	ld	s0,64(sp)
    80000aa2:	74e2                	ld	s1,56(sp)
    80000aa4:	7942                	ld	s2,48(sp)
    80000aa6:	79a2                	ld	s3,40(sp)
    80000aa8:	7a02                	ld	s4,32(sp)
    80000aaa:	6ae2                	ld	s5,24(sp)
    80000aac:	6b42                	ld	s6,16(sp)
    80000aae:	6ba2                	ld	s7,8(sp)
    80000ab0:	6161                	addi	sp,sp,80
    80000ab2:	8082                	ret
  return 0;
    80000ab4:	4501                	li	a0,0
    80000ab6:	b7e5                	j	80000a9e <uvmcopy+0xa8>
    80000ab8:	4501                	li	a0,0
}
    80000aba:	8082                	ret

0000000080000abc <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void uvmclear(pagetable_t pagetable, uint64 va)
{
    80000abc:	1141                	addi	sp,sp,-16
    80000abe:	e406                	sd	ra,8(sp)
    80000ac0:	e022                	sd	s0,0(sp)
    80000ac2:	0800                	addi	s0,sp,16
  pte_t *pte;

  pte = walk(pagetable, va, 0);
    80000ac4:	4601                	li	a2,0
    80000ac6:	00000097          	auipc	ra,0x0
    80000aca:	994080e7          	jalr	-1644(ra) # 8000045a <walk>
  if (pte == 0)
    80000ace:	c901                	beqz	a0,80000ade <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000ad0:	611c                	ld	a5,0(a0)
    80000ad2:	9bbd                	andi	a5,a5,-17
    80000ad4:	e11c                	sd	a5,0(a0)
}
    80000ad6:	60a2                	ld	ra,8(sp)
    80000ad8:	6402                	ld	s0,0(sp)
    80000ada:	0141                	addi	sp,sp,16
    80000adc:	8082                	ret
    panic("uvmclear");
    80000ade:	00007517          	auipc	a0,0x7
    80000ae2:	63250513          	addi	a0,a0,1586 # 80008110 <etext+0x110>
    80000ae6:	00005097          	auipc	ra,0x5
    80000aea:	52a080e7          	jalr	1322(ra) # 80006010 <panic>

0000000080000aee <copyout>:
// Return 0 on success, -1 on error.
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while (len > 0)
    80000aee:	c6bd                	beqz	a3,80000b5c <copyout+0x6e>
{
    80000af0:	715d                	addi	sp,sp,-80
    80000af2:	e486                	sd	ra,72(sp)
    80000af4:	e0a2                	sd	s0,64(sp)
    80000af6:	fc26                	sd	s1,56(sp)
    80000af8:	f84a                	sd	s2,48(sp)
    80000afa:	f44e                	sd	s3,40(sp)
    80000afc:	f052                	sd	s4,32(sp)
    80000afe:	ec56                	sd	s5,24(sp)
    80000b00:	e85a                	sd	s6,16(sp)
    80000b02:	e45e                	sd	s7,8(sp)
    80000b04:	e062                	sd	s8,0(sp)
    80000b06:	0880                	addi	s0,sp,80
    80000b08:	8b2a                	mv	s6,a0
    80000b0a:	8c2e                	mv	s8,a1
    80000b0c:	8a32                	mv	s4,a2
    80000b0e:	89b6                	mv	s3,a3
  {
    va0 = PGROUNDDOWN(dstva);
    80000b10:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b12:	6a85                	lui	s5,0x1
    80000b14:	a015                	j	80000b38 <copyout+0x4a>
    if (n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b16:	9562                	add	a0,a0,s8
    80000b18:	0004861b          	sext.w	a2,s1
    80000b1c:	85d2                	mv	a1,s4
    80000b1e:	41250533          	sub	a0,a0,s2
    80000b22:	fffff097          	auipc	ra,0xfffff
    80000b26:	6b4080e7          	jalr	1716(ra) # 800001d6 <memmove>

    len -= n;
    80000b2a:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b2e:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b30:	01590c33          	add	s8,s2,s5
  while (len > 0)
    80000b34:	02098263          	beqz	s3,80000b58 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b38:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b3c:	85ca                	mv	a1,s2
    80000b3e:	855a                	mv	a0,s6
    80000b40:	00000097          	auipc	ra,0x0
    80000b44:	9c0080e7          	jalr	-1600(ra) # 80000500 <walkaddr>
    if (pa0 == 0)
    80000b48:	cd01                	beqz	a0,80000b60 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b4a:	418904b3          	sub	s1,s2,s8
    80000b4e:	94d6                	add	s1,s1,s5
    80000b50:	fc99f3e3          	bgeu	s3,s1,80000b16 <copyout+0x28>
    80000b54:	84ce                	mv	s1,s3
    80000b56:	b7c1                	j	80000b16 <copyout+0x28>
  }
  return 0;
    80000b58:	4501                	li	a0,0
    80000b5a:	a021                	j	80000b62 <copyout+0x74>
    80000b5c:	4501                	li	a0,0
}
    80000b5e:	8082                	ret
      return -1;
    80000b60:	557d                	li	a0,-1
}
    80000b62:	60a6                	ld	ra,72(sp)
    80000b64:	6406                	ld	s0,64(sp)
    80000b66:	74e2                	ld	s1,56(sp)
    80000b68:	7942                	ld	s2,48(sp)
    80000b6a:	79a2                	ld	s3,40(sp)
    80000b6c:	7a02                	ld	s4,32(sp)
    80000b6e:	6ae2                	ld	s5,24(sp)
    80000b70:	6b42                	ld	s6,16(sp)
    80000b72:	6ba2                	ld	s7,8(sp)
    80000b74:	6c02                	ld	s8,0(sp)
    80000b76:	6161                	addi	sp,sp,80
    80000b78:	8082                	ret

0000000080000b7a <copyin>:
// Return 0 on success, -1 on error.
int copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while (len > 0)
    80000b7a:	caa5                	beqz	a3,80000bea <copyin+0x70>
{
    80000b7c:	715d                	addi	sp,sp,-80
    80000b7e:	e486                	sd	ra,72(sp)
    80000b80:	e0a2                	sd	s0,64(sp)
    80000b82:	fc26                	sd	s1,56(sp)
    80000b84:	f84a                	sd	s2,48(sp)
    80000b86:	f44e                	sd	s3,40(sp)
    80000b88:	f052                	sd	s4,32(sp)
    80000b8a:	ec56                	sd	s5,24(sp)
    80000b8c:	e85a                	sd	s6,16(sp)
    80000b8e:	e45e                	sd	s7,8(sp)
    80000b90:	e062                	sd	s8,0(sp)
    80000b92:	0880                	addi	s0,sp,80
    80000b94:	8b2a                	mv	s6,a0
    80000b96:	8a2e                	mv	s4,a1
    80000b98:	8c32                	mv	s8,a2
    80000b9a:	89b6                	mv	s3,a3
  {
    va0 = PGROUNDDOWN(srcva);
    80000b9c:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000b9e:	6a85                	lui	s5,0x1
    80000ba0:	a01d                	j	80000bc6 <copyin+0x4c>
    if (n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000ba2:	018505b3          	add	a1,a0,s8
    80000ba6:	0004861b          	sext.w	a2,s1
    80000baa:	412585b3          	sub	a1,a1,s2
    80000bae:	8552                	mv	a0,s4
    80000bb0:	fffff097          	auipc	ra,0xfffff
    80000bb4:	626080e7          	jalr	1574(ra) # 800001d6 <memmove>

    len -= n;
    80000bb8:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000bbc:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000bbe:	01590c33          	add	s8,s2,s5
  while (len > 0)
    80000bc2:	02098263          	beqz	s3,80000be6 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000bc6:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bca:	85ca                	mv	a1,s2
    80000bcc:	855a                	mv	a0,s6
    80000bce:	00000097          	auipc	ra,0x0
    80000bd2:	932080e7          	jalr	-1742(ra) # 80000500 <walkaddr>
    if (pa0 == 0)
    80000bd6:	cd01                	beqz	a0,80000bee <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000bd8:	418904b3          	sub	s1,s2,s8
    80000bdc:	94d6                	add	s1,s1,s5
    80000bde:	fc99f2e3          	bgeu	s3,s1,80000ba2 <copyin+0x28>
    80000be2:	84ce                	mv	s1,s3
    80000be4:	bf7d                	j	80000ba2 <copyin+0x28>
  }
  return 0;
    80000be6:	4501                	li	a0,0
    80000be8:	a021                	j	80000bf0 <copyin+0x76>
    80000bea:	4501                	li	a0,0
}
    80000bec:	8082                	ret
      return -1;
    80000bee:	557d                	li	a0,-1
}
    80000bf0:	60a6                	ld	ra,72(sp)
    80000bf2:	6406                	ld	s0,64(sp)
    80000bf4:	74e2                	ld	s1,56(sp)
    80000bf6:	7942                	ld	s2,48(sp)
    80000bf8:	79a2                	ld	s3,40(sp)
    80000bfa:	7a02                	ld	s4,32(sp)
    80000bfc:	6ae2                	ld	s5,24(sp)
    80000bfe:	6b42                	ld	s6,16(sp)
    80000c00:	6ba2                	ld	s7,8(sp)
    80000c02:	6c02                	ld	s8,0(sp)
    80000c04:	6161                	addi	sp,sp,80
    80000c06:	8082                	ret

0000000080000c08 <copyinstr>:
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while (got_null == 0 && max > 0)
    80000c08:	c2dd                	beqz	a3,80000cae <copyinstr+0xa6>
{
    80000c0a:	715d                	addi	sp,sp,-80
    80000c0c:	e486                	sd	ra,72(sp)
    80000c0e:	e0a2                	sd	s0,64(sp)
    80000c10:	fc26                	sd	s1,56(sp)
    80000c12:	f84a                	sd	s2,48(sp)
    80000c14:	f44e                	sd	s3,40(sp)
    80000c16:	f052                	sd	s4,32(sp)
    80000c18:	ec56                	sd	s5,24(sp)
    80000c1a:	e85a                	sd	s6,16(sp)
    80000c1c:	e45e                	sd	s7,8(sp)
    80000c1e:	0880                	addi	s0,sp,80
    80000c20:	8a2a                	mv	s4,a0
    80000c22:	8b2e                	mv	s6,a1
    80000c24:	8bb2                	mv	s7,a2
    80000c26:	84b6                	mv	s1,a3
  {
    va0 = PGROUNDDOWN(srcva);
    80000c28:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c2a:	6985                	lui	s3,0x1
    80000c2c:	a02d                	j	80000c56 <copyinstr+0x4e>
    char *p = (char *)(pa0 + (srcva - va0));
    while (n > 0)
    {
      if (*p == '\0')
      {
        *dst = '\0';
    80000c2e:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c32:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if (got_null)
    80000c34:	37fd                	addiw	a5,a5,-1
    80000c36:	0007851b          	sext.w	a0,a5
  }
  else
  {
    return -1;
  }
}
    80000c3a:	60a6                	ld	ra,72(sp)
    80000c3c:	6406                	ld	s0,64(sp)
    80000c3e:	74e2                	ld	s1,56(sp)
    80000c40:	7942                	ld	s2,48(sp)
    80000c42:	79a2                	ld	s3,40(sp)
    80000c44:	7a02                	ld	s4,32(sp)
    80000c46:	6ae2                	ld	s5,24(sp)
    80000c48:	6b42                	ld	s6,16(sp)
    80000c4a:	6ba2                	ld	s7,8(sp)
    80000c4c:	6161                	addi	sp,sp,80
    80000c4e:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c50:	01390bb3          	add	s7,s2,s3
  while (got_null == 0 && max > 0)
    80000c54:	c8a9                	beqz	s1,80000ca6 <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80000c56:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c5a:	85ca                	mv	a1,s2
    80000c5c:	8552                	mv	a0,s4
    80000c5e:	00000097          	auipc	ra,0x0
    80000c62:	8a2080e7          	jalr	-1886(ra) # 80000500 <walkaddr>
    if (pa0 == 0)
    80000c66:	c131                	beqz	a0,80000caa <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000c68:	417906b3          	sub	a3,s2,s7
    80000c6c:	96ce                	add	a3,a3,s3
    80000c6e:	00d4f363          	bgeu	s1,a3,80000c74 <copyinstr+0x6c>
    80000c72:	86a6                	mv	a3,s1
    char *p = (char *)(pa0 + (srcva - va0));
    80000c74:	955e                	add	a0,a0,s7
    80000c76:	41250533          	sub	a0,a0,s2
    while (n > 0)
    80000c7a:	daf9                	beqz	a3,80000c50 <copyinstr+0x48>
    80000c7c:	87da                	mv	a5,s6
      if (*p == '\0')
    80000c7e:	41650633          	sub	a2,a0,s6
    80000c82:	fff48593          	addi	a1,s1,-1
    80000c86:	95da                	add	a1,a1,s6
    while (n > 0)
    80000c88:	96da                	add	a3,a3,s6
      if (*p == '\0')
    80000c8a:	00f60733          	add	a4,a2,a5
    80000c8e:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffccdc0>
    80000c92:	df51                	beqz	a4,80000c2e <copyinstr+0x26>
        *dst = *p;
    80000c94:	00e78023          	sb	a4,0(a5)
      --max;
    80000c98:	40f584b3          	sub	s1,a1,a5
      dst++;
    80000c9c:	0785                	addi	a5,a5,1
    while (n > 0)
    80000c9e:	fed796e3          	bne	a5,a3,80000c8a <copyinstr+0x82>
      dst++;
    80000ca2:	8b3e                	mv	s6,a5
    80000ca4:	b775                	j	80000c50 <copyinstr+0x48>
    80000ca6:	4781                	li	a5,0
    80000ca8:	b771                	j	80000c34 <copyinstr+0x2c>
      return -1;
    80000caa:	557d                	li	a0,-1
    80000cac:	b779                	j	80000c3a <copyinstr+0x32>
  int got_null = 0;
    80000cae:	4781                	li	a5,0
  if (got_null)
    80000cb0:	37fd                	addiw	a5,a5,-1
    80000cb2:	0007851b          	sext.w	a0,a5
}
    80000cb6:	8082                	ret

0000000080000cb8 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void proc_mapstacks(pagetable_t kpgtbl)
{
    80000cb8:	7139                	addi	sp,sp,-64
    80000cba:	fc06                	sd	ra,56(sp)
    80000cbc:	f822                	sd	s0,48(sp)
    80000cbe:	f426                	sd	s1,40(sp)
    80000cc0:	f04a                	sd	s2,32(sp)
    80000cc2:	ec4e                	sd	s3,24(sp)
    80000cc4:	e852                	sd	s4,16(sp)
    80000cc6:	e456                	sd	s5,8(sp)
    80000cc8:	e05a                	sd	s6,0(sp)
    80000cca:	0080                	addi	s0,sp,64
    80000ccc:	89aa                	mv	s3,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    80000cce:	00008497          	auipc	s1,0x8
    80000cd2:	7b248493          	addi	s1,s1,1970 # 80009480 <proc>
  {
    char *pa = kalloc();
    if (pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int)(p - proc));
    80000cd6:	8b26                	mv	s6,s1
    80000cd8:	00007a97          	auipc	s5,0x7
    80000cdc:	328a8a93          	addi	s5,s5,808 # 80008000 <etext>
    80000ce0:	04000937          	lui	s2,0x4000
    80000ce4:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000ce6:	0932                	slli	s2,s2,0xc
  for (p = proc; p < &proc[NPROC]; p++)
    80000ce8:	0001aa17          	auipc	s4,0x1a
    80000cec:	198a0a13          	addi	s4,s4,408 # 8001ae80 <tickslock>
    char *pa = kalloc();
    80000cf0:	fffff097          	auipc	ra,0xfffff
    80000cf4:	42a080e7          	jalr	1066(ra) # 8000011a <kalloc>
    80000cf8:	862a                	mv	a2,a0
    if (pa == 0)
    80000cfa:	c131                	beqz	a0,80000d3e <proc_mapstacks+0x86>
    uint64 va = KSTACK((int)(p - proc));
    80000cfc:	416485b3          	sub	a1,s1,s6
    80000d00:	858d                	srai	a1,a1,0x3
    80000d02:	000ab783          	ld	a5,0(s5)
    80000d06:	02f585b3          	mul	a1,a1,a5
    80000d0a:	2585                	addiw	a1,a1,1
    80000d0c:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d10:	4719                	li	a4,6
    80000d12:	6685                	lui	a3,0x1
    80000d14:	40b905b3          	sub	a1,s2,a1
    80000d18:	854e                	mv	a0,s3
    80000d1a:	00000097          	auipc	ra,0x0
    80000d1e:	8c8080e7          	jalr	-1848(ra) # 800005e2 <kvmmap>
  for (p = proc; p < &proc[NPROC]; p++)
    80000d22:	46848493          	addi	s1,s1,1128
    80000d26:	fd4495e3          	bne	s1,s4,80000cf0 <proc_mapstacks+0x38>
  }
}
    80000d2a:	70e2                	ld	ra,56(sp)
    80000d2c:	7442                	ld	s0,48(sp)
    80000d2e:	74a2                	ld	s1,40(sp)
    80000d30:	7902                	ld	s2,32(sp)
    80000d32:	69e2                	ld	s3,24(sp)
    80000d34:	6a42                	ld	s4,16(sp)
    80000d36:	6aa2                	ld	s5,8(sp)
    80000d38:	6b02                	ld	s6,0(sp)
    80000d3a:	6121                	addi	sp,sp,64
    80000d3c:	8082                	ret
      panic("kalloc");
    80000d3e:	00007517          	auipc	a0,0x7
    80000d42:	3e250513          	addi	a0,a0,994 # 80008120 <etext+0x120>
    80000d46:	00005097          	auipc	ra,0x5
    80000d4a:	2ca080e7          	jalr	714(ra) # 80006010 <panic>

0000000080000d4e <procinit>:

// initialize the proc table at boot time.
void procinit(void)
{
    80000d4e:	7139                	addi	sp,sp,-64
    80000d50:	fc06                	sd	ra,56(sp)
    80000d52:	f822                	sd	s0,48(sp)
    80000d54:	f426                	sd	s1,40(sp)
    80000d56:	f04a                	sd	s2,32(sp)
    80000d58:	ec4e                	sd	s3,24(sp)
    80000d5a:	e852                	sd	s4,16(sp)
    80000d5c:	e456                	sd	s5,8(sp)
    80000d5e:	e05a                	sd	s6,0(sp)
    80000d60:	0080                	addi	s0,sp,64
  struct proc *p;

  initlock(&pid_lock, "nextpid");
    80000d62:	00007597          	auipc	a1,0x7
    80000d66:	3c658593          	addi	a1,a1,966 # 80008128 <etext+0x128>
    80000d6a:	00008517          	auipc	a0,0x8
    80000d6e:	2e650513          	addi	a0,a0,742 # 80009050 <pid_lock>
    80000d72:	00005097          	auipc	ra,0x5
    80000d76:	746080e7          	jalr	1862(ra) # 800064b8 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d7a:	00007597          	auipc	a1,0x7
    80000d7e:	3b658593          	addi	a1,a1,950 # 80008130 <etext+0x130>
    80000d82:	00008517          	auipc	a0,0x8
    80000d86:	2e650513          	addi	a0,a0,742 # 80009068 <wait_lock>
    80000d8a:	00005097          	auipc	ra,0x5
    80000d8e:	72e080e7          	jalr	1838(ra) # 800064b8 <initlock>
  for (p = proc; p < &proc[NPROC]; p++)
    80000d92:	00008497          	auipc	s1,0x8
    80000d96:	6ee48493          	addi	s1,s1,1774 # 80009480 <proc>
  {
    initlock(&p->lock, "proc");
    80000d9a:	00007b17          	auipc	s6,0x7
    80000d9e:	3a6b0b13          	addi	s6,s6,934 # 80008140 <etext+0x140>
    p->kstack = KSTACK((int)(p - proc));
    80000da2:	8aa6                	mv	s5,s1
    80000da4:	00007a17          	auipc	s4,0x7
    80000da8:	25ca0a13          	addi	s4,s4,604 # 80008000 <etext>
    80000dac:	04000937          	lui	s2,0x4000
    80000db0:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000db2:	0932                	slli	s2,s2,0xc
  for (p = proc; p < &proc[NPROC]; p++)
    80000db4:	0001a997          	auipc	s3,0x1a
    80000db8:	0cc98993          	addi	s3,s3,204 # 8001ae80 <tickslock>
    initlock(&p->lock, "proc");
    80000dbc:	85da                	mv	a1,s6
    80000dbe:	8526                	mv	a0,s1
    80000dc0:	00005097          	auipc	ra,0x5
    80000dc4:	6f8080e7          	jalr	1784(ra) # 800064b8 <initlock>
    p->kstack = KSTACK((int)(p - proc));
    80000dc8:	415487b3          	sub	a5,s1,s5
    80000dcc:	878d                	srai	a5,a5,0x3
    80000dce:	000a3703          	ld	a4,0(s4)
    80000dd2:	02e787b3          	mul	a5,a5,a4
    80000dd6:	2785                	addiw	a5,a5,1
    80000dd8:	00d7979b          	slliw	a5,a5,0xd
    80000ddc:	40f907b3          	sub	a5,s2,a5
    80000de0:	e0bc                	sd	a5,64(s1)
  for (p = proc; p < &proc[NPROC]; p++)
    80000de2:	46848493          	addi	s1,s1,1128
    80000de6:	fd349be3          	bne	s1,s3,80000dbc <procinit+0x6e>
  }
}
    80000dea:	70e2                	ld	ra,56(sp)
    80000dec:	7442                	ld	s0,48(sp)
    80000dee:	74a2                	ld	s1,40(sp)
    80000df0:	7902                	ld	s2,32(sp)
    80000df2:	69e2                	ld	s3,24(sp)
    80000df4:	6a42                	ld	s4,16(sp)
    80000df6:	6aa2                	ld	s5,8(sp)
    80000df8:	6b02                	ld	s6,0(sp)
    80000dfa:	6121                	addi	sp,sp,64
    80000dfc:	8082                	ret

0000000080000dfe <cpuid>:

// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int cpuid()
{
    80000dfe:	1141                	addi	sp,sp,-16
    80000e00:	e422                	sd	s0,8(sp)
    80000e02:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e04:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e06:	2501                	sext.w	a0,a0
    80000e08:	6422                	ld	s0,8(sp)
    80000e0a:	0141                	addi	sp,sp,16
    80000e0c:	8082                	ret

0000000080000e0e <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu *
mycpu(void)
{
    80000e0e:	1141                	addi	sp,sp,-16
    80000e10:	e422                	sd	s0,8(sp)
    80000e12:	0800                	addi	s0,sp,16
    80000e14:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e16:	2781                	sext.w	a5,a5
    80000e18:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e1a:	00008517          	auipc	a0,0x8
    80000e1e:	26650513          	addi	a0,a0,614 # 80009080 <cpus>
    80000e22:	953e                	add	a0,a0,a5
    80000e24:	6422                	ld	s0,8(sp)
    80000e26:	0141                	addi	sp,sp,16
    80000e28:	8082                	ret

0000000080000e2a <myproc>:

// Return the current struct proc *, or zero if none.
struct proc *
myproc(void)
{
    80000e2a:	1101                	addi	sp,sp,-32
    80000e2c:	ec06                	sd	ra,24(sp)
    80000e2e:	e822                	sd	s0,16(sp)
    80000e30:	e426                	sd	s1,8(sp)
    80000e32:	1000                	addi	s0,sp,32
  push_off();
    80000e34:	00005097          	auipc	ra,0x5
    80000e38:	6c8080e7          	jalr	1736(ra) # 800064fc <push_off>
    80000e3c:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e3e:	2781                	sext.w	a5,a5
    80000e40:	079e                	slli	a5,a5,0x7
    80000e42:	00008717          	auipc	a4,0x8
    80000e46:	20e70713          	addi	a4,a4,526 # 80009050 <pid_lock>
    80000e4a:	97ba                	add	a5,a5,a4
    80000e4c:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e4e:	00005097          	auipc	ra,0x5
    80000e52:	74e080e7          	jalr	1870(ra) # 8000659c <pop_off>
  return p;
}
    80000e56:	8526                	mv	a0,s1
    80000e58:	60e2                	ld	ra,24(sp)
    80000e5a:	6442                	ld	s0,16(sp)
    80000e5c:	64a2                	ld	s1,8(sp)
    80000e5e:	6105                	addi	sp,sp,32
    80000e60:	8082                	ret

0000000080000e62 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void)
{
    80000e62:	1141                	addi	sp,sp,-16
    80000e64:	e406                	sd	ra,8(sp)
    80000e66:	e022                	sd	s0,0(sp)
    80000e68:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000e6a:	00000097          	auipc	ra,0x0
    80000e6e:	fc0080e7          	jalr	-64(ra) # 80000e2a <myproc>
    80000e72:	00005097          	auipc	ra,0x5
    80000e76:	78a080e7          	jalr	1930(ra) # 800065fc <release>

  if (first)
    80000e7a:	00008797          	auipc	a5,0x8
    80000e7e:	9767a783          	lw	a5,-1674(a5) # 800087f0 <first.1>
    80000e82:	eb89                	bnez	a5,80000e94 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000e84:	00001097          	auipc	ra,0x1
    80000e88:	c8e080e7          	jalr	-882(ra) # 80001b12 <usertrapret>
}
    80000e8c:	60a2                	ld	ra,8(sp)
    80000e8e:	6402                	ld	s0,0(sp)
    80000e90:	0141                	addi	sp,sp,16
    80000e92:	8082                	ret
    first = 0;
    80000e94:	00008797          	auipc	a5,0x8
    80000e98:	9407ae23          	sw	zero,-1700(a5) # 800087f0 <first.1>
    fsinit(ROOTDEV);
    80000e9c:	4505                	li	a0,1
    80000e9e:	00002097          	auipc	ra,0x2
    80000ea2:	ae4080e7          	jalr	-1308(ra) # 80002982 <fsinit>
    80000ea6:	bff9                	j	80000e84 <forkret+0x22>

0000000080000ea8 <allocpid>:
{
    80000ea8:	1101                	addi	sp,sp,-32
    80000eaa:	ec06                	sd	ra,24(sp)
    80000eac:	e822                	sd	s0,16(sp)
    80000eae:	e426                	sd	s1,8(sp)
    80000eb0:	e04a                	sd	s2,0(sp)
    80000eb2:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000eb4:	00008917          	auipc	s2,0x8
    80000eb8:	19c90913          	addi	s2,s2,412 # 80009050 <pid_lock>
    80000ebc:	854a                	mv	a0,s2
    80000ebe:	00005097          	auipc	ra,0x5
    80000ec2:	68a080e7          	jalr	1674(ra) # 80006548 <acquire>
  pid = nextpid;
    80000ec6:	00008797          	auipc	a5,0x8
    80000eca:	92e78793          	addi	a5,a5,-1746 # 800087f4 <nextpid>
    80000ece:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000ed0:	0014871b          	addiw	a4,s1,1
    80000ed4:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000ed6:	854a                	mv	a0,s2
    80000ed8:	00005097          	auipc	ra,0x5
    80000edc:	724080e7          	jalr	1828(ra) # 800065fc <release>
}
    80000ee0:	8526                	mv	a0,s1
    80000ee2:	60e2                	ld	ra,24(sp)
    80000ee4:	6442                	ld	s0,16(sp)
    80000ee6:	64a2                	ld	s1,8(sp)
    80000ee8:	6902                	ld	s2,0(sp)
    80000eea:	6105                	addi	sp,sp,32
    80000eec:	8082                	ret

0000000080000eee <proc_pagetable>:
{
    80000eee:	1101                	addi	sp,sp,-32
    80000ef0:	ec06                	sd	ra,24(sp)
    80000ef2:	e822                	sd	s0,16(sp)
    80000ef4:	e426                	sd	s1,8(sp)
    80000ef6:	e04a                	sd	s2,0(sp)
    80000ef8:	1000                	addi	s0,sp,32
    80000efa:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000efc:	00000097          	auipc	ra,0x0
    80000f00:	8c2080e7          	jalr	-1854(ra) # 800007be <uvmcreate>
    80000f04:	84aa                	mv	s1,a0
  if (pagetable == 0)
    80000f06:	c121                	beqz	a0,80000f46 <proc_pagetable+0x58>
  if (mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f08:	4729                	li	a4,10
    80000f0a:	00006697          	auipc	a3,0x6
    80000f0e:	0f668693          	addi	a3,a3,246 # 80007000 <_trampoline>
    80000f12:	6605                	lui	a2,0x1
    80000f14:	040005b7          	lui	a1,0x4000
    80000f18:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f1a:	05b2                	slli	a1,a1,0xc
    80000f1c:	fffff097          	auipc	ra,0xfffff
    80000f20:	626080e7          	jalr	1574(ra) # 80000542 <mappages>
    80000f24:	02054863          	bltz	a0,80000f54 <proc_pagetable+0x66>
  if (mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f28:	4719                	li	a4,6
    80000f2a:	05893683          	ld	a3,88(s2)
    80000f2e:	6605                	lui	a2,0x1
    80000f30:	020005b7          	lui	a1,0x2000
    80000f34:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f36:	05b6                	slli	a1,a1,0xd
    80000f38:	8526                	mv	a0,s1
    80000f3a:	fffff097          	auipc	ra,0xfffff
    80000f3e:	608080e7          	jalr	1544(ra) # 80000542 <mappages>
    80000f42:	02054163          	bltz	a0,80000f64 <proc_pagetable+0x76>
}
    80000f46:	8526                	mv	a0,s1
    80000f48:	60e2                	ld	ra,24(sp)
    80000f4a:	6442                	ld	s0,16(sp)
    80000f4c:	64a2                	ld	s1,8(sp)
    80000f4e:	6902                	ld	s2,0(sp)
    80000f50:	6105                	addi	sp,sp,32
    80000f52:	8082                	ret
    uvmfree(pagetable, 0);
    80000f54:	4581                	li	a1,0
    80000f56:	8526                	mv	a0,s1
    80000f58:	00000097          	auipc	ra,0x0
    80000f5c:	a64080e7          	jalr	-1436(ra) # 800009bc <uvmfree>
    return 0;
    80000f60:	4481                	li	s1,0
    80000f62:	b7d5                	j	80000f46 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f64:	4681                	li	a3,0
    80000f66:	4605                	li	a2,1
    80000f68:	040005b7          	lui	a1,0x4000
    80000f6c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f6e:	05b2                	slli	a1,a1,0xc
    80000f70:	8526                	mv	a0,s1
    80000f72:	fffff097          	auipc	ra,0xfffff
    80000f76:	796080e7          	jalr	1942(ra) # 80000708 <uvmunmap>
    uvmfree(pagetable, 0);
    80000f7a:	4581                	li	a1,0
    80000f7c:	8526                	mv	a0,s1
    80000f7e:	00000097          	auipc	ra,0x0
    80000f82:	a3e080e7          	jalr	-1474(ra) # 800009bc <uvmfree>
    return 0;
    80000f86:	4481                	li	s1,0
    80000f88:	bf7d                	j	80000f46 <proc_pagetable+0x58>

0000000080000f8a <proc_freepagetable>:
{
    80000f8a:	1101                	addi	sp,sp,-32
    80000f8c:	ec06                	sd	ra,24(sp)
    80000f8e:	e822                	sd	s0,16(sp)
    80000f90:	e426                	sd	s1,8(sp)
    80000f92:	e04a                	sd	s2,0(sp)
    80000f94:	1000                	addi	s0,sp,32
    80000f96:	84aa                	mv	s1,a0
    80000f98:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f9a:	4681                	li	a3,0
    80000f9c:	4605                	li	a2,1
    80000f9e:	040005b7          	lui	a1,0x4000
    80000fa2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fa4:	05b2                	slli	a1,a1,0xc
    80000fa6:	fffff097          	auipc	ra,0xfffff
    80000faa:	762080e7          	jalr	1890(ra) # 80000708 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fae:	4681                	li	a3,0
    80000fb0:	4605                	li	a2,1
    80000fb2:	020005b7          	lui	a1,0x2000
    80000fb6:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000fb8:	05b6                	slli	a1,a1,0xd
    80000fba:	8526                	mv	a0,s1
    80000fbc:	fffff097          	auipc	ra,0xfffff
    80000fc0:	74c080e7          	jalr	1868(ra) # 80000708 <uvmunmap>
  uvmfree(pagetable, sz);
    80000fc4:	85ca                	mv	a1,s2
    80000fc6:	8526                	mv	a0,s1
    80000fc8:	00000097          	auipc	ra,0x0
    80000fcc:	9f4080e7          	jalr	-1548(ra) # 800009bc <uvmfree>
}
    80000fd0:	60e2                	ld	ra,24(sp)
    80000fd2:	6442                	ld	s0,16(sp)
    80000fd4:	64a2                	ld	s1,8(sp)
    80000fd6:	6902                	ld	s2,0(sp)
    80000fd8:	6105                	addi	sp,sp,32
    80000fda:	8082                	ret

0000000080000fdc <freeproc>:
{
    80000fdc:	1101                	addi	sp,sp,-32
    80000fde:	ec06                	sd	ra,24(sp)
    80000fe0:	e822                	sd	s0,16(sp)
    80000fe2:	e426                	sd	s1,8(sp)
    80000fe4:	1000                	addi	s0,sp,32
    80000fe6:	84aa                	mv	s1,a0
  if (p->trapframe)
    80000fe8:	6d28                	ld	a0,88(a0)
    80000fea:	c509                	beqz	a0,80000ff4 <freeproc+0x18>
    kfree((void *)p->trapframe);
    80000fec:	fffff097          	auipc	ra,0xfffff
    80000ff0:	030080e7          	jalr	48(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80000ff4:	0404bc23          	sd	zero,88(s1)
  if (p->pagetable)
    80000ff8:	68a8                	ld	a0,80(s1)
    80000ffa:	c511                	beqz	a0,80001006 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80000ffc:	64ac                	ld	a1,72(s1)
    80000ffe:	00000097          	auipc	ra,0x0
    80001002:	f8c080e7          	jalr	-116(ra) # 80000f8a <proc_freepagetable>
  p->pagetable = 0;
    80001006:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    8000100a:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    8000100e:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001012:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001016:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    8000101a:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000101e:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001022:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001026:	0004ac23          	sw	zero,24(s1)
}
    8000102a:	60e2                	ld	ra,24(sp)
    8000102c:	6442                	ld	s0,16(sp)
    8000102e:	64a2                	ld	s1,8(sp)
    80001030:	6105                	addi	sp,sp,32
    80001032:	8082                	ret

0000000080001034 <allocproc>:
{
    80001034:	1101                	addi	sp,sp,-32
    80001036:	ec06                	sd	ra,24(sp)
    80001038:	e822                	sd	s0,16(sp)
    8000103a:	e426                	sd	s1,8(sp)
    8000103c:	e04a                	sd	s2,0(sp)
    8000103e:	1000                	addi	s0,sp,32
  for (p = proc; p < &proc[NPROC]; p++)
    80001040:	00008497          	auipc	s1,0x8
    80001044:	44048493          	addi	s1,s1,1088 # 80009480 <proc>
    80001048:	0001a917          	auipc	s2,0x1a
    8000104c:	e3890913          	addi	s2,s2,-456 # 8001ae80 <tickslock>
    acquire(&p->lock);
    80001050:	8526                	mv	a0,s1
    80001052:	00005097          	auipc	ra,0x5
    80001056:	4f6080e7          	jalr	1270(ra) # 80006548 <acquire>
    if (p->state == UNUSED)
    8000105a:	4c9c                	lw	a5,24(s1)
    8000105c:	cf81                	beqz	a5,80001074 <allocproc+0x40>
      release(&p->lock);
    8000105e:	8526                	mv	a0,s1
    80001060:	00005097          	auipc	ra,0x5
    80001064:	59c080e7          	jalr	1436(ra) # 800065fc <release>
  for (p = proc; p < &proc[NPROC]; p++)
    80001068:	46848493          	addi	s1,s1,1128
    8000106c:	ff2492e3          	bne	s1,s2,80001050 <allocproc+0x1c>
  return 0;
    80001070:	4481                	li	s1,0
    80001072:	a889                	j	800010c4 <allocproc+0x90>
  p->pid = allocpid();
    80001074:	00000097          	auipc	ra,0x0
    80001078:	e34080e7          	jalr	-460(ra) # 80000ea8 <allocpid>
    8000107c:	d888                	sw	a0,48(s1)
  p->state = USED;
    8000107e:	4785                	li	a5,1
    80001080:	cc9c                	sw	a5,24(s1)
  if ((p->trapframe = (struct trapframe *)kalloc()) == 0)
    80001082:	fffff097          	auipc	ra,0xfffff
    80001086:	098080e7          	jalr	152(ra) # 8000011a <kalloc>
    8000108a:	892a                	mv	s2,a0
    8000108c:	eca8                	sd	a0,88(s1)
    8000108e:	c131                	beqz	a0,800010d2 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001090:	8526                	mv	a0,s1
    80001092:	00000097          	auipc	ra,0x0
    80001096:	e5c080e7          	jalr	-420(ra) # 80000eee <proc_pagetable>
    8000109a:	892a                	mv	s2,a0
    8000109c:	e8a8                	sd	a0,80(s1)
  if (p->pagetable == 0)
    8000109e:	c531                	beqz	a0,800010ea <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800010a0:	07000613          	li	a2,112
    800010a4:	4581                	li	a1,0
    800010a6:	06048513          	addi	a0,s1,96
    800010aa:	fffff097          	auipc	ra,0xfffff
    800010ae:	0d0080e7          	jalr	208(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    800010b2:	00000797          	auipc	a5,0x0
    800010b6:	db078793          	addi	a5,a5,-592 # 80000e62 <forkret>
    800010ba:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800010bc:	60bc                	ld	a5,64(s1)
    800010be:	6705                	lui	a4,0x1
    800010c0:	97ba                	add	a5,a5,a4
    800010c2:	f4bc                	sd	a5,104(s1)
}
    800010c4:	8526                	mv	a0,s1
    800010c6:	60e2                	ld	ra,24(sp)
    800010c8:	6442                	ld	s0,16(sp)
    800010ca:	64a2                	ld	s1,8(sp)
    800010cc:	6902                	ld	s2,0(sp)
    800010ce:	6105                	addi	sp,sp,32
    800010d0:	8082                	ret
    freeproc(p);
    800010d2:	8526                	mv	a0,s1
    800010d4:	00000097          	auipc	ra,0x0
    800010d8:	f08080e7          	jalr	-248(ra) # 80000fdc <freeproc>
    release(&p->lock);
    800010dc:	8526                	mv	a0,s1
    800010de:	00005097          	auipc	ra,0x5
    800010e2:	51e080e7          	jalr	1310(ra) # 800065fc <release>
    return 0;
    800010e6:	84ca                	mv	s1,s2
    800010e8:	bff1                	j	800010c4 <allocproc+0x90>
    freeproc(p);
    800010ea:	8526                	mv	a0,s1
    800010ec:	00000097          	auipc	ra,0x0
    800010f0:	ef0080e7          	jalr	-272(ra) # 80000fdc <freeproc>
    release(&p->lock);
    800010f4:	8526                	mv	a0,s1
    800010f6:	00005097          	auipc	ra,0x5
    800010fa:	506080e7          	jalr	1286(ra) # 800065fc <release>
    return 0;
    800010fe:	84ca                	mv	s1,s2
    80001100:	b7d1                	j	800010c4 <allocproc+0x90>

0000000080001102 <userinit>:
{
    80001102:	1101                	addi	sp,sp,-32
    80001104:	ec06                	sd	ra,24(sp)
    80001106:	e822                	sd	s0,16(sp)
    80001108:	e426                	sd	s1,8(sp)
    8000110a:	1000                	addi	s0,sp,32
  p = allocproc();
    8000110c:	00000097          	auipc	ra,0x0
    80001110:	f28080e7          	jalr	-216(ra) # 80001034 <allocproc>
    80001114:	84aa                	mv	s1,a0
  initproc = p;
    80001116:	00008797          	auipc	a5,0x8
    8000111a:	eea7bd23          	sd	a0,-262(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    8000111e:	03400613          	li	a2,52
    80001122:	00007597          	auipc	a1,0x7
    80001126:	6de58593          	addi	a1,a1,1758 # 80008800 <initcode>
    8000112a:	6928                	ld	a0,80(a0)
    8000112c:	fffff097          	auipc	ra,0xfffff
    80001130:	6c0080e7          	jalr	1728(ra) # 800007ec <uvminit>
  p->sz = PGSIZE;
    80001134:	6785                	lui	a5,0x1
    80001136:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;     // user program counter
    80001138:	6cb8                	ld	a4,88(s1)
    8000113a:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE; // user stack pointer
    8000113e:	6cb8                	ld	a4,88(s1)
    80001140:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001142:	4641                	li	a2,16
    80001144:	00007597          	auipc	a1,0x7
    80001148:	00458593          	addi	a1,a1,4 # 80008148 <etext+0x148>
    8000114c:	15848513          	addi	a0,s1,344
    80001150:	fffff097          	auipc	ra,0xfffff
    80001154:	174080e7          	jalr	372(ra) # 800002c4 <safestrcpy>
  p->cwd = namei("/");
    80001158:	00007517          	auipc	a0,0x7
    8000115c:	00050513          	mv	a0,a0
    80001160:	00002097          	auipc	ra,0x2
    80001164:	258080e7          	jalr	600(ra) # 800033b8 <namei>
    80001168:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000116c:	478d                	li	a5,3
    8000116e:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001170:	8526                	mv	a0,s1
    80001172:	00005097          	auipc	ra,0x5
    80001176:	48a080e7          	jalr	1162(ra) # 800065fc <release>
}
    8000117a:	60e2                	ld	ra,24(sp)
    8000117c:	6442                	ld	s0,16(sp)
    8000117e:	64a2                	ld	s1,8(sp)
    80001180:	6105                	addi	sp,sp,32
    80001182:	8082                	ret

0000000080001184 <growproc>:
{
    80001184:	1101                	addi	sp,sp,-32
    80001186:	ec06                	sd	ra,24(sp)
    80001188:	e822                	sd	s0,16(sp)
    8000118a:	e426                	sd	s1,8(sp)
    8000118c:	e04a                	sd	s2,0(sp)
    8000118e:	1000                	addi	s0,sp,32
    80001190:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001192:	00000097          	auipc	ra,0x0
    80001196:	c98080e7          	jalr	-872(ra) # 80000e2a <myproc>
    8000119a:	892a                	mv	s2,a0
  sz = p->sz;
    8000119c:	652c                	ld	a1,72(a0)
    8000119e:	0005879b          	sext.w	a5,a1
  if (n > 0)
    800011a2:	00904f63          	bgtz	s1,800011c0 <growproc+0x3c>
  else if (n < 0)
    800011a6:	0204cd63          	bltz	s1,800011e0 <growproc+0x5c>
  p->sz = sz;
    800011aa:	1782                	slli	a5,a5,0x20
    800011ac:	9381                	srli	a5,a5,0x20
    800011ae:	04f93423          	sd	a5,72(s2)
  return 0;
    800011b2:	4501                	li	a0,0
}
    800011b4:	60e2                	ld	ra,24(sp)
    800011b6:	6442                	ld	s0,16(sp)
    800011b8:	64a2                	ld	s1,8(sp)
    800011ba:	6902                	ld	s2,0(sp)
    800011bc:	6105                	addi	sp,sp,32
    800011be:	8082                	ret
    if ((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0)
    800011c0:	00f4863b          	addw	a2,s1,a5
    800011c4:	1602                	slli	a2,a2,0x20
    800011c6:	9201                	srli	a2,a2,0x20
    800011c8:	1582                	slli	a1,a1,0x20
    800011ca:	9181                	srli	a1,a1,0x20
    800011cc:	6928                	ld	a0,80(a0)
    800011ce:	fffff097          	auipc	ra,0xfffff
    800011d2:	6d8080e7          	jalr	1752(ra) # 800008a6 <uvmalloc>
    800011d6:	0005079b          	sext.w	a5,a0
    800011da:	fbe1                	bnez	a5,800011aa <growproc+0x26>
      return -1;
    800011dc:	557d                	li	a0,-1
    800011de:	bfd9                	j	800011b4 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800011e0:	00f4863b          	addw	a2,s1,a5
    800011e4:	1602                	slli	a2,a2,0x20
    800011e6:	9201                	srli	a2,a2,0x20
    800011e8:	1582                	slli	a1,a1,0x20
    800011ea:	9181                	srli	a1,a1,0x20
    800011ec:	6928                	ld	a0,80(a0)
    800011ee:	fffff097          	auipc	ra,0xfffff
    800011f2:	670080e7          	jalr	1648(ra) # 8000085e <uvmdealloc>
    800011f6:	0005079b          	sext.w	a5,a0
    800011fa:	bf45                	j	800011aa <growproc+0x26>

00000000800011fc <fork>:
{
    800011fc:	7139                	addi	sp,sp,-64
    800011fe:	fc06                	sd	ra,56(sp)
    80001200:	f822                	sd	s0,48(sp)
    80001202:	f426                	sd	s1,40(sp)
    80001204:	f04a                	sd	s2,32(sp)
    80001206:	ec4e                	sd	s3,24(sp)
    80001208:	e852                	sd	s4,16(sp)
    8000120a:	e456                	sd	s5,8(sp)
    8000120c:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    8000120e:	00000097          	auipc	ra,0x0
    80001212:	c1c080e7          	jalr	-996(ra) # 80000e2a <myproc>
    80001216:	8a2a                	mv	s4,a0
  if ((np = allocproc()) == 0)
    80001218:	00000097          	auipc	ra,0x0
    8000121c:	e1c080e7          	jalr	-484(ra) # 80001034 <allocproc>
    80001220:	14050b63          	beqz	a0,80001376 <fork+0x17a>
    80001224:	89aa                	mv	s3,a0
    80001226:	168a0913          	addi	s2,s4,360
    8000122a:	16850493          	addi	s1,a0,360 # 800082c0 <states.0+0xb8>
    8000122e:	46850a93          	addi	s5,a0,1128
    80001232:	a039                	j	80001240 <fork+0x44>
  for (int i = 0; i < MAXVMA; i++)
    80001234:	03090913          	addi	s2,s2,48
    80001238:	03048493          	addi	s1,s1,48
    8000123c:	03548363          	beq	s1,s5,80001262 <fork+0x66>
    if (v->used)
    80001240:	00092783          	lw	a5,0(s2)
    80001244:	dbe5                	beqz	a5,80001234 <fork+0x38>
      memmove(nv, v, sizeof(struct VMA));
    80001246:	03000613          	li	a2,48
    8000124a:	85ca                	mv	a1,s2
    8000124c:	8526                	mv	a0,s1
    8000124e:	fffff097          	auipc	ra,0xfffff
    80001252:	f88080e7          	jalr	-120(ra) # 800001d6 <memmove>
      filedup(nv->f);
    80001256:	7088                	ld	a0,32(s1)
    80001258:	00002097          	auipc	ra,0x2
    8000125c:	7f6080e7          	jalr	2038(ra) # 80003a4e <filedup>
    80001260:	bfd1                	j	80001234 <fork+0x38>
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0)
    80001262:	048a3603          	ld	a2,72(s4)
    80001266:	0509b583          	ld	a1,80(s3)
    8000126a:	050a3503          	ld	a0,80(s4)
    8000126e:	fffff097          	auipc	ra,0xfffff
    80001272:	788080e7          	jalr	1928(ra) # 800009f6 <uvmcopy>
    80001276:	04054863          	bltz	a0,800012c6 <fork+0xca>
  np->sz = p->sz;
    8000127a:	048a3783          	ld	a5,72(s4)
    8000127e:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    80001282:	058a3683          	ld	a3,88(s4)
    80001286:	87b6                	mv	a5,a3
    80001288:	0589b703          	ld	a4,88(s3)
    8000128c:	12068693          	addi	a3,a3,288
    80001290:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001294:	6788                	ld	a0,8(a5)
    80001296:	6b8c                	ld	a1,16(a5)
    80001298:	6f90                	ld	a2,24(a5)
    8000129a:	01073023          	sd	a6,0(a4)
    8000129e:	e708                	sd	a0,8(a4)
    800012a0:	eb0c                	sd	a1,16(a4)
    800012a2:	ef10                	sd	a2,24(a4)
    800012a4:	02078793          	addi	a5,a5,32
    800012a8:	02070713          	addi	a4,a4,32
    800012ac:	fed792e3          	bne	a5,a3,80001290 <fork+0x94>
  np->trapframe->a0 = 0;
    800012b0:	0589b783          	ld	a5,88(s3)
    800012b4:	0607b823          	sd	zero,112(a5)
  for (i = 0; i < NOFILE; i++)
    800012b8:	0d0a0493          	addi	s1,s4,208
    800012bc:	0d098913          	addi	s2,s3,208
    800012c0:	150a0a93          	addi	s5,s4,336
    800012c4:	a03d                	j	800012f2 <fork+0xf6>
    freeproc(np);
    800012c6:	854e                	mv	a0,s3
    800012c8:	00000097          	auipc	ra,0x0
    800012cc:	d14080e7          	jalr	-748(ra) # 80000fdc <freeproc>
    release(&np->lock);
    800012d0:	854e                	mv	a0,s3
    800012d2:	00005097          	auipc	ra,0x5
    800012d6:	32a080e7          	jalr	810(ra) # 800065fc <release>
    return -1;
    800012da:	597d                	li	s2,-1
    800012dc:	a059                	j	80001362 <fork+0x166>
      np->ofile[i] = filedup(p->ofile[i]);
    800012de:	00002097          	auipc	ra,0x2
    800012e2:	770080e7          	jalr	1904(ra) # 80003a4e <filedup>
    800012e6:	00a93023          	sd	a0,0(s2)
  for (i = 0; i < NOFILE; i++)
    800012ea:	04a1                	addi	s1,s1,8
    800012ec:	0921                	addi	s2,s2,8
    800012ee:	01548563          	beq	s1,s5,800012f8 <fork+0xfc>
    if (p->ofile[i])
    800012f2:	6088                	ld	a0,0(s1)
    800012f4:	f56d                	bnez	a0,800012de <fork+0xe2>
    800012f6:	bfd5                	j	800012ea <fork+0xee>
  np->cwd = idup(p->cwd);
    800012f8:	150a3503          	ld	a0,336(s4)
    800012fc:	00002097          	auipc	ra,0x2
    80001300:	8c2080e7          	jalr	-1854(ra) # 80002bbe <idup>
    80001304:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001308:	4641                	li	a2,16
    8000130a:	158a0593          	addi	a1,s4,344
    8000130e:	15898513          	addi	a0,s3,344
    80001312:	fffff097          	auipc	ra,0xfffff
    80001316:	fb2080e7          	jalr	-78(ra) # 800002c4 <safestrcpy>
  pid = np->pid;
    8000131a:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    8000131e:	854e                	mv	a0,s3
    80001320:	00005097          	auipc	ra,0x5
    80001324:	2dc080e7          	jalr	732(ra) # 800065fc <release>
  acquire(&wait_lock);
    80001328:	00008497          	auipc	s1,0x8
    8000132c:	d4048493          	addi	s1,s1,-704 # 80009068 <wait_lock>
    80001330:	8526                	mv	a0,s1
    80001332:	00005097          	auipc	ra,0x5
    80001336:	216080e7          	jalr	534(ra) # 80006548 <acquire>
  np->parent = p;
    8000133a:	0349bc23          	sd	s4,56(s3)
  release(&wait_lock);
    8000133e:	8526                	mv	a0,s1
    80001340:	00005097          	auipc	ra,0x5
    80001344:	2bc080e7          	jalr	700(ra) # 800065fc <release>
  acquire(&np->lock);
    80001348:	854e                	mv	a0,s3
    8000134a:	00005097          	auipc	ra,0x5
    8000134e:	1fe080e7          	jalr	510(ra) # 80006548 <acquire>
  np->state = RUNNABLE;
    80001352:	478d                	li	a5,3
    80001354:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001358:	854e                	mv	a0,s3
    8000135a:	00005097          	auipc	ra,0x5
    8000135e:	2a2080e7          	jalr	674(ra) # 800065fc <release>
}
    80001362:	854a                	mv	a0,s2
    80001364:	70e2                	ld	ra,56(sp)
    80001366:	7442                	ld	s0,48(sp)
    80001368:	74a2                	ld	s1,40(sp)
    8000136a:	7902                	ld	s2,32(sp)
    8000136c:	69e2                	ld	s3,24(sp)
    8000136e:	6a42                	ld	s4,16(sp)
    80001370:	6aa2                	ld	s5,8(sp)
    80001372:	6121                	addi	sp,sp,64
    80001374:	8082                	ret
    return -1;
    80001376:	597d                	li	s2,-1
    80001378:	b7ed                	j	80001362 <fork+0x166>

000000008000137a <scheduler>:
{
    8000137a:	7139                	addi	sp,sp,-64
    8000137c:	fc06                	sd	ra,56(sp)
    8000137e:	f822                	sd	s0,48(sp)
    80001380:	f426                	sd	s1,40(sp)
    80001382:	f04a                	sd	s2,32(sp)
    80001384:	ec4e                	sd	s3,24(sp)
    80001386:	e852                	sd	s4,16(sp)
    80001388:	e456                	sd	s5,8(sp)
    8000138a:	e05a                	sd	s6,0(sp)
    8000138c:	0080                	addi	s0,sp,64
    8000138e:	8792                	mv	a5,tp
  int id = r_tp();
    80001390:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001392:	00779a93          	slli	s5,a5,0x7
    80001396:	00008717          	auipc	a4,0x8
    8000139a:	cba70713          	addi	a4,a4,-838 # 80009050 <pid_lock>
    8000139e:	9756                	add	a4,a4,s5
    800013a0:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013a4:	00008717          	auipc	a4,0x8
    800013a8:	ce470713          	addi	a4,a4,-796 # 80009088 <cpus+0x8>
    800013ac:	9aba                	add	s5,s5,a4
      if (p->state == RUNNABLE)
    800013ae:	498d                	li	s3,3
        p->state = RUNNING;
    800013b0:	4b11                	li	s6,4
        c->proc = p;
    800013b2:	079e                	slli	a5,a5,0x7
    800013b4:	00008a17          	auipc	s4,0x8
    800013b8:	c9ca0a13          	addi	s4,s4,-868 # 80009050 <pid_lock>
    800013bc:	9a3e                	add	s4,s4,a5
    for (p = proc; p < &proc[NPROC]; p++)
    800013be:	0001a917          	auipc	s2,0x1a
    800013c2:	ac290913          	addi	s2,s2,-1342 # 8001ae80 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013c6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013ca:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013ce:	10079073          	csrw	sstatus,a5
    800013d2:	00008497          	auipc	s1,0x8
    800013d6:	0ae48493          	addi	s1,s1,174 # 80009480 <proc>
    800013da:	a811                	j	800013ee <scheduler+0x74>
      release(&p->lock);
    800013dc:	8526                	mv	a0,s1
    800013de:	00005097          	auipc	ra,0x5
    800013e2:	21e080e7          	jalr	542(ra) # 800065fc <release>
    for (p = proc; p < &proc[NPROC]; p++)
    800013e6:	46848493          	addi	s1,s1,1128
    800013ea:	fd248ee3          	beq	s1,s2,800013c6 <scheduler+0x4c>
      acquire(&p->lock);
    800013ee:	8526                	mv	a0,s1
    800013f0:	00005097          	auipc	ra,0x5
    800013f4:	158080e7          	jalr	344(ra) # 80006548 <acquire>
      if (p->state == RUNNABLE)
    800013f8:	4c9c                	lw	a5,24(s1)
    800013fa:	ff3791e3          	bne	a5,s3,800013dc <scheduler+0x62>
        p->state = RUNNING;
    800013fe:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001402:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001406:	06048593          	addi	a1,s1,96
    8000140a:	8556                	mv	a0,s5
    8000140c:	00000097          	auipc	ra,0x0
    80001410:	65c080e7          	jalr	1628(ra) # 80001a68 <swtch>
        c->proc = 0;
    80001414:	020a3823          	sd	zero,48(s4)
    80001418:	b7d1                	j	800013dc <scheduler+0x62>

000000008000141a <sched>:
{
    8000141a:	7179                	addi	sp,sp,-48
    8000141c:	f406                	sd	ra,40(sp)
    8000141e:	f022                	sd	s0,32(sp)
    80001420:	ec26                	sd	s1,24(sp)
    80001422:	e84a                	sd	s2,16(sp)
    80001424:	e44e                	sd	s3,8(sp)
    80001426:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001428:	00000097          	auipc	ra,0x0
    8000142c:	a02080e7          	jalr	-1534(ra) # 80000e2a <myproc>
    80001430:	84aa                	mv	s1,a0
  if (!holding(&p->lock))
    80001432:	00005097          	auipc	ra,0x5
    80001436:	09c080e7          	jalr	156(ra) # 800064ce <holding>
    8000143a:	c93d                	beqz	a0,800014b0 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000143c:	8792                	mv	a5,tp
  if (mycpu()->noff != 1)
    8000143e:	2781                	sext.w	a5,a5
    80001440:	079e                	slli	a5,a5,0x7
    80001442:	00008717          	auipc	a4,0x8
    80001446:	c0e70713          	addi	a4,a4,-1010 # 80009050 <pid_lock>
    8000144a:	97ba                	add	a5,a5,a4
    8000144c:	0a87a703          	lw	a4,168(a5)
    80001450:	4785                	li	a5,1
    80001452:	06f71763          	bne	a4,a5,800014c0 <sched+0xa6>
  if (p->state == RUNNING)
    80001456:	4c98                	lw	a4,24(s1)
    80001458:	4791                	li	a5,4
    8000145a:	06f70b63          	beq	a4,a5,800014d0 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000145e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001462:	8b89                	andi	a5,a5,2
  if (intr_get())
    80001464:	efb5                	bnez	a5,800014e0 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001466:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001468:	00008917          	auipc	s2,0x8
    8000146c:	be890913          	addi	s2,s2,-1048 # 80009050 <pid_lock>
    80001470:	2781                	sext.w	a5,a5
    80001472:	079e                	slli	a5,a5,0x7
    80001474:	97ca                	add	a5,a5,s2
    80001476:	0ac7a983          	lw	s3,172(a5)
    8000147a:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000147c:	2781                	sext.w	a5,a5
    8000147e:	079e                	slli	a5,a5,0x7
    80001480:	00008597          	auipc	a1,0x8
    80001484:	c0858593          	addi	a1,a1,-1016 # 80009088 <cpus+0x8>
    80001488:	95be                	add	a1,a1,a5
    8000148a:	06048513          	addi	a0,s1,96
    8000148e:	00000097          	auipc	ra,0x0
    80001492:	5da080e7          	jalr	1498(ra) # 80001a68 <swtch>
    80001496:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001498:	2781                	sext.w	a5,a5
    8000149a:	079e                	slli	a5,a5,0x7
    8000149c:	993e                	add	s2,s2,a5
    8000149e:	0b392623          	sw	s3,172(s2)
}
    800014a2:	70a2                	ld	ra,40(sp)
    800014a4:	7402                	ld	s0,32(sp)
    800014a6:	64e2                	ld	s1,24(sp)
    800014a8:	6942                	ld	s2,16(sp)
    800014aa:	69a2                	ld	s3,8(sp)
    800014ac:	6145                	addi	sp,sp,48
    800014ae:	8082                	ret
    panic("sched p->lock");
    800014b0:	00007517          	auipc	a0,0x7
    800014b4:	cb050513          	addi	a0,a0,-848 # 80008160 <etext+0x160>
    800014b8:	00005097          	auipc	ra,0x5
    800014bc:	b58080e7          	jalr	-1192(ra) # 80006010 <panic>
    panic("sched locks");
    800014c0:	00007517          	auipc	a0,0x7
    800014c4:	cb050513          	addi	a0,a0,-848 # 80008170 <etext+0x170>
    800014c8:	00005097          	auipc	ra,0x5
    800014cc:	b48080e7          	jalr	-1208(ra) # 80006010 <panic>
    panic("sched running");
    800014d0:	00007517          	auipc	a0,0x7
    800014d4:	cb050513          	addi	a0,a0,-848 # 80008180 <etext+0x180>
    800014d8:	00005097          	auipc	ra,0x5
    800014dc:	b38080e7          	jalr	-1224(ra) # 80006010 <panic>
    panic("sched interruptible");
    800014e0:	00007517          	auipc	a0,0x7
    800014e4:	cb050513          	addi	a0,a0,-848 # 80008190 <etext+0x190>
    800014e8:	00005097          	auipc	ra,0x5
    800014ec:	b28080e7          	jalr	-1240(ra) # 80006010 <panic>

00000000800014f0 <yield>:
{
    800014f0:	1101                	addi	sp,sp,-32
    800014f2:	ec06                	sd	ra,24(sp)
    800014f4:	e822                	sd	s0,16(sp)
    800014f6:	e426                	sd	s1,8(sp)
    800014f8:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800014fa:	00000097          	auipc	ra,0x0
    800014fe:	930080e7          	jalr	-1744(ra) # 80000e2a <myproc>
    80001502:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001504:	00005097          	auipc	ra,0x5
    80001508:	044080e7          	jalr	68(ra) # 80006548 <acquire>
  p->state = RUNNABLE;
    8000150c:	478d                	li	a5,3
    8000150e:	cc9c                	sw	a5,24(s1)
  sched();
    80001510:	00000097          	auipc	ra,0x0
    80001514:	f0a080e7          	jalr	-246(ra) # 8000141a <sched>
  release(&p->lock);
    80001518:	8526                	mv	a0,s1
    8000151a:	00005097          	auipc	ra,0x5
    8000151e:	0e2080e7          	jalr	226(ra) # 800065fc <release>
}
    80001522:	60e2                	ld	ra,24(sp)
    80001524:	6442                	ld	s0,16(sp)
    80001526:	64a2                	ld	s1,8(sp)
    80001528:	6105                	addi	sp,sp,32
    8000152a:	8082                	ret

000000008000152c <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
    8000152c:	7179                	addi	sp,sp,-48
    8000152e:	f406                	sd	ra,40(sp)
    80001530:	f022                	sd	s0,32(sp)
    80001532:	ec26                	sd	s1,24(sp)
    80001534:	e84a                	sd	s2,16(sp)
    80001536:	e44e                	sd	s3,8(sp)
    80001538:	1800                	addi	s0,sp,48
    8000153a:	89aa                	mv	s3,a0
    8000153c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000153e:	00000097          	auipc	ra,0x0
    80001542:	8ec080e7          	jalr	-1812(ra) # 80000e2a <myproc>
    80001546:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock); // DOC: sleeplock1
    80001548:	00005097          	auipc	ra,0x5
    8000154c:	000080e7          	jalr	ra # 80006548 <acquire>
  release(lk);
    80001550:	854a                	mv	a0,s2
    80001552:	00005097          	auipc	ra,0x5
    80001556:	0aa080e7          	jalr	170(ra) # 800065fc <release>

  // Go to sleep.
  p->chan = chan;
    8000155a:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000155e:	4789                	li	a5,2
    80001560:	cc9c                	sw	a5,24(s1)

  sched();
    80001562:	00000097          	auipc	ra,0x0
    80001566:	eb8080e7          	jalr	-328(ra) # 8000141a <sched>

  // Tidy up.
  p->chan = 0;
    8000156a:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000156e:	8526                	mv	a0,s1
    80001570:	00005097          	auipc	ra,0x5
    80001574:	08c080e7          	jalr	140(ra) # 800065fc <release>
  acquire(lk);
    80001578:	854a                	mv	a0,s2
    8000157a:	00005097          	auipc	ra,0x5
    8000157e:	fce080e7          	jalr	-50(ra) # 80006548 <acquire>
}
    80001582:	70a2                	ld	ra,40(sp)
    80001584:	7402                	ld	s0,32(sp)
    80001586:	64e2                	ld	s1,24(sp)
    80001588:	6942                	ld	s2,16(sp)
    8000158a:	69a2                	ld	s3,8(sp)
    8000158c:	6145                	addi	sp,sp,48
    8000158e:	8082                	ret

0000000080001590 <wait>:
{
    80001590:	715d                	addi	sp,sp,-80
    80001592:	e486                	sd	ra,72(sp)
    80001594:	e0a2                	sd	s0,64(sp)
    80001596:	fc26                	sd	s1,56(sp)
    80001598:	f84a                	sd	s2,48(sp)
    8000159a:	f44e                	sd	s3,40(sp)
    8000159c:	f052                	sd	s4,32(sp)
    8000159e:	ec56                	sd	s5,24(sp)
    800015a0:	e85a                	sd	s6,16(sp)
    800015a2:	e45e                	sd	s7,8(sp)
    800015a4:	e062                	sd	s8,0(sp)
    800015a6:	0880                	addi	s0,sp,80
    800015a8:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015aa:	00000097          	auipc	ra,0x0
    800015ae:	880080e7          	jalr	-1920(ra) # 80000e2a <myproc>
    800015b2:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015b4:	00008517          	auipc	a0,0x8
    800015b8:	ab450513          	addi	a0,a0,-1356 # 80009068 <wait_lock>
    800015bc:	00005097          	auipc	ra,0x5
    800015c0:	f8c080e7          	jalr	-116(ra) # 80006548 <acquire>
    havekids = 0;
    800015c4:	4b81                	li	s7,0
        if (np->state == ZOMBIE)
    800015c6:	4a15                	li	s4,5
        havekids = 1;
    800015c8:	4a85                	li	s5,1
    for (np = proc; np < &proc[NPROC]; np++)
    800015ca:	0001a997          	auipc	s3,0x1a
    800015ce:	8b698993          	addi	s3,s3,-1866 # 8001ae80 <tickslock>
    sleep(p, &wait_lock); // DOC: wait-sleep
    800015d2:	00008c17          	auipc	s8,0x8
    800015d6:	a96c0c13          	addi	s8,s8,-1386 # 80009068 <wait_lock>
    havekids = 0;
    800015da:	875e                	mv	a4,s7
    for (np = proc; np < &proc[NPROC]; np++)
    800015dc:	00008497          	auipc	s1,0x8
    800015e0:	ea448493          	addi	s1,s1,-348 # 80009480 <proc>
    800015e4:	a0bd                	j	80001652 <wait+0xc2>
          pid = np->pid;
    800015e6:	0304a983          	lw	s3,48(s1)
          if (addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800015ea:	000b0e63          	beqz	s6,80001606 <wait+0x76>
    800015ee:	4691                	li	a3,4
    800015f0:	02c48613          	addi	a2,s1,44
    800015f4:	85da                	mv	a1,s6
    800015f6:	05093503          	ld	a0,80(s2)
    800015fa:	fffff097          	auipc	ra,0xfffff
    800015fe:	4f4080e7          	jalr	1268(ra) # 80000aee <copyout>
    80001602:	02054563          	bltz	a0,8000162c <wait+0x9c>
          freeproc(np);
    80001606:	8526                	mv	a0,s1
    80001608:	00000097          	auipc	ra,0x0
    8000160c:	9d4080e7          	jalr	-1580(ra) # 80000fdc <freeproc>
          release(&np->lock);
    80001610:	8526                	mv	a0,s1
    80001612:	00005097          	auipc	ra,0x5
    80001616:	fea080e7          	jalr	-22(ra) # 800065fc <release>
          release(&wait_lock);
    8000161a:	00008517          	auipc	a0,0x8
    8000161e:	a4e50513          	addi	a0,a0,-1458 # 80009068 <wait_lock>
    80001622:	00005097          	auipc	ra,0x5
    80001626:	fda080e7          	jalr	-38(ra) # 800065fc <release>
          return pid;
    8000162a:	a09d                	j	80001690 <wait+0x100>
            release(&np->lock);
    8000162c:	8526                	mv	a0,s1
    8000162e:	00005097          	auipc	ra,0x5
    80001632:	fce080e7          	jalr	-50(ra) # 800065fc <release>
            release(&wait_lock);
    80001636:	00008517          	auipc	a0,0x8
    8000163a:	a3250513          	addi	a0,a0,-1486 # 80009068 <wait_lock>
    8000163e:	00005097          	auipc	ra,0x5
    80001642:	fbe080e7          	jalr	-66(ra) # 800065fc <release>
            return -1;
    80001646:	59fd                	li	s3,-1
    80001648:	a0a1                	j	80001690 <wait+0x100>
    for (np = proc; np < &proc[NPROC]; np++)
    8000164a:	46848493          	addi	s1,s1,1128
    8000164e:	03348463          	beq	s1,s3,80001676 <wait+0xe6>
      if (np->parent == p)
    80001652:	7c9c                	ld	a5,56(s1)
    80001654:	ff279be3          	bne	a5,s2,8000164a <wait+0xba>
        acquire(&np->lock);
    80001658:	8526                	mv	a0,s1
    8000165a:	00005097          	auipc	ra,0x5
    8000165e:	eee080e7          	jalr	-274(ra) # 80006548 <acquire>
        if (np->state == ZOMBIE)
    80001662:	4c9c                	lw	a5,24(s1)
    80001664:	f94781e3          	beq	a5,s4,800015e6 <wait+0x56>
        release(&np->lock);
    80001668:	8526                	mv	a0,s1
    8000166a:	00005097          	auipc	ra,0x5
    8000166e:	f92080e7          	jalr	-110(ra) # 800065fc <release>
        havekids = 1;
    80001672:	8756                	mv	a4,s5
    80001674:	bfd9                	j	8000164a <wait+0xba>
    if (!havekids || p->killed)
    80001676:	c701                	beqz	a4,8000167e <wait+0xee>
    80001678:	02892783          	lw	a5,40(s2)
    8000167c:	c79d                	beqz	a5,800016aa <wait+0x11a>
      release(&wait_lock);
    8000167e:	00008517          	auipc	a0,0x8
    80001682:	9ea50513          	addi	a0,a0,-1558 # 80009068 <wait_lock>
    80001686:	00005097          	auipc	ra,0x5
    8000168a:	f76080e7          	jalr	-138(ra) # 800065fc <release>
      return -1;
    8000168e:	59fd                	li	s3,-1
}
    80001690:	854e                	mv	a0,s3
    80001692:	60a6                	ld	ra,72(sp)
    80001694:	6406                	ld	s0,64(sp)
    80001696:	74e2                	ld	s1,56(sp)
    80001698:	7942                	ld	s2,48(sp)
    8000169a:	79a2                	ld	s3,40(sp)
    8000169c:	7a02                	ld	s4,32(sp)
    8000169e:	6ae2                	ld	s5,24(sp)
    800016a0:	6b42                	ld	s6,16(sp)
    800016a2:	6ba2                	ld	s7,8(sp)
    800016a4:	6c02                	ld	s8,0(sp)
    800016a6:	6161                	addi	sp,sp,80
    800016a8:	8082                	ret
    sleep(p, &wait_lock); // DOC: wait-sleep
    800016aa:	85e2                	mv	a1,s8
    800016ac:	854a                	mv	a0,s2
    800016ae:	00000097          	auipc	ra,0x0
    800016b2:	e7e080e7          	jalr	-386(ra) # 8000152c <sleep>
    havekids = 0;
    800016b6:	b715                	j	800015da <wait+0x4a>

00000000800016b8 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan)
{
    800016b8:	7139                	addi	sp,sp,-64
    800016ba:	fc06                	sd	ra,56(sp)
    800016bc:	f822                	sd	s0,48(sp)
    800016be:	f426                	sd	s1,40(sp)
    800016c0:	f04a                	sd	s2,32(sp)
    800016c2:	ec4e                	sd	s3,24(sp)
    800016c4:	e852                	sd	s4,16(sp)
    800016c6:	e456                	sd	s5,8(sp)
    800016c8:	0080                	addi	s0,sp,64
    800016ca:	8a2a                	mv	s4,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    800016cc:	00008497          	auipc	s1,0x8
    800016d0:	db448493          	addi	s1,s1,-588 # 80009480 <proc>
  {
    if (p != myproc())
    {
      acquire(&p->lock);
      if (p->state == SLEEPING && p->chan == chan)
    800016d4:	4989                	li	s3,2
      {
        p->state = RUNNABLE;
    800016d6:	4a8d                	li	s5,3
  for (p = proc; p < &proc[NPROC]; p++)
    800016d8:	00019917          	auipc	s2,0x19
    800016dc:	7a890913          	addi	s2,s2,1960 # 8001ae80 <tickslock>
    800016e0:	a811                	j	800016f4 <wakeup+0x3c>
      }
      release(&p->lock);
    800016e2:	8526                	mv	a0,s1
    800016e4:	00005097          	auipc	ra,0x5
    800016e8:	f18080e7          	jalr	-232(ra) # 800065fc <release>
  for (p = proc; p < &proc[NPROC]; p++)
    800016ec:	46848493          	addi	s1,s1,1128
    800016f0:	03248663          	beq	s1,s2,8000171c <wakeup+0x64>
    if (p != myproc())
    800016f4:	fffff097          	auipc	ra,0xfffff
    800016f8:	736080e7          	jalr	1846(ra) # 80000e2a <myproc>
    800016fc:	fea488e3          	beq	s1,a0,800016ec <wakeup+0x34>
      acquire(&p->lock);
    80001700:	8526                	mv	a0,s1
    80001702:	00005097          	auipc	ra,0x5
    80001706:	e46080e7          	jalr	-442(ra) # 80006548 <acquire>
      if (p->state == SLEEPING && p->chan == chan)
    8000170a:	4c9c                	lw	a5,24(s1)
    8000170c:	fd379be3          	bne	a5,s3,800016e2 <wakeup+0x2a>
    80001710:	709c                	ld	a5,32(s1)
    80001712:	fd4798e3          	bne	a5,s4,800016e2 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001716:	0154ac23          	sw	s5,24(s1)
    8000171a:	b7e1                	j	800016e2 <wakeup+0x2a>
    }
  }
}
    8000171c:	70e2                	ld	ra,56(sp)
    8000171e:	7442                	ld	s0,48(sp)
    80001720:	74a2                	ld	s1,40(sp)
    80001722:	7902                	ld	s2,32(sp)
    80001724:	69e2                	ld	s3,24(sp)
    80001726:	6a42                	ld	s4,16(sp)
    80001728:	6aa2                	ld	s5,8(sp)
    8000172a:	6121                	addi	sp,sp,64
    8000172c:	8082                	ret

000000008000172e <reparent>:
{
    8000172e:	7179                	addi	sp,sp,-48
    80001730:	f406                	sd	ra,40(sp)
    80001732:	f022                	sd	s0,32(sp)
    80001734:	ec26                	sd	s1,24(sp)
    80001736:	e84a                	sd	s2,16(sp)
    80001738:	e44e                	sd	s3,8(sp)
    8000173a:	e052                	sd	s4,0(sp)
    8000173c:	1800                	addi	s0,sp,48
    8000173e:	892a                	mv	s2,a0
  for (pp = proc; pp < &proc[NPROC]; pp++)
    80001740:	00008497          	auipc	s1,0x8
    80001744:	d4048493          	addi	s1,s1,-704 # 80009480 <proc>
      pp->parent = initproc;
    80001748:	00008a17          	auipc	s4,0x8
    8000174c:	8c8a0a13          	addi	s4,s4,-1848 # 80009010 <initproc>
  for (pp = proc; pp < &proc[NPROC]; pp++)
    80001750:	00019997          	auipc	s3,0x19
    80001754:	73098993          	addi	s3,s3,1840 # 8001ae80 <tickslock>
    80001758:	a029                	j	80001762 <reparent+0x34>
    8000175a:	46848493          	addi	s1,s1,1128
    8000175e:	01348d63          	beq	s1,s3,80001778 <reparent+0x4a>
    if (pp->parent == p)
    80001762:	7c9c                	ld	a5,56(s1)
    80001764:	ff279be3          	bne	a5,s2,8000175a <reparent+0x2c>
      pp->parent = initproc;
    80001768:	000a3503          	ld	a0,0(s4)
    8000176c:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000176e:	00000097          	auipc	ra,0x0
    80001772:	f4a080e7          	jalr	-182(ra) # 800016b8 <wakeup>
    80001776:	b7d5                	j	8000175a <reparent+0x2c>
}
    80001778:	70a2                	ld	ra,40(sp)
    8000177a:	7402                	ld	s0,32(sp)
    8000177c:	64e2                	ld	s1,24(sp)
    8000177e:	6942                	ld	s2,16(sp)
    80001780:	69a2                	ld	s3,8(sp)
    80001782:	6a02                	ld	s4,0(sp)
    80001784:	6145                	addi	sp,sp,48
    80001786:	8082                	ret

0000000080001788 <exit>:
{
    80001788:	7179                	addi	sp,sp,-48
    8000178a:	f406                	sd	ra,40(sp)
    8000178c:	f022                	sd	s0,32(sp)
    8000178e:	ec26                	sd	s1,24(sp)
    80001790:	e84a                	sd	s2,16(sp)
    80001792:	e44e                	sd	s3,8(sp)
    80001794:	e052                	sd	s4,0(sp)
    80001796:	1800                	addi	s0,sp,48
    80001798:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000179a:	fffff097          	auipc	ra,0xfffff
    8000179e:	690080e7          	jalr	1680(ra) # 80000e2a <myproc>
    800017a2:	892a                	mv	s2,a0
  if (p == initproc)
    800017a4:	00008797          	auipc	a5,0x8
    800017a8:	86c7b783          	ld	a5,-1940(a5) # 80009010 <initproc>
    800017ac:	0d050493          	addi	s1,a0,208
    800017b0:	15050993          	addi	s3,a0,336
    800017b4:	02a79363          	bne	a5,a0,800017da <exit+0x52>
    panic("init exiting");
    800017b8:	00007517          	auipc	a0,0x7
    800017bc:	9f050513          	addi	a0,a0,-1552 # 800081a8 <etext+0x1a8>
    800017c0:	00005097          	auipc	ra,0x5
    800017c4:	850080e7          	jalr	-1968(ra) # 80006010 <panic>
      fileclose(f);
    800017c8:	00002097          	auipc	ra,0x2
    800017cc:	2d8080e7          	jalr	728(ra) # 80003aa0 <fileclose>
      p->ofile[fd] = 0;
    800017d0:	0004b023          	sd	zero,0(s1)
  for (int fd = 0; fd < NOFILE; fd++)
    800017d4:	04a1                	addi	s1,s1,8
    800017d6:	01348563          	beq	s1,s3,800017e0 <exit+0x58>
    if (p->ofile[fd])
    800017da:	6088                	ld	a0,0(s1)
    800017dc:	f575                	bnez	a0,800017c8 <exit+0x40>
    800017de:	bfdd                	j	800017d4 <exit+0x4c>
    800017e0:	16890493          	addi	s1,s2,360
    800017e4:	46890993          	addi	s3,s2,1128
    800017e8:	a029                	j	800017f2 <exit+0x6a>
  for (int i = 0; i < MAXVMA; i++)
    800017ea:	03048493          	addi	s1,s1,48
    800017ee:	03348763          	beq	s1,s3,8000181c <exit+0x94>
    if (v->used)
    800017f2:	409c                	lw	a5,0(s1)
    800017f4:	dbfd                	beqz	a5,800017ea <exit+0x62>
      uvmunmap(p->pagetable, v->addr, v->len / PGSIZE, 0);
    800017f6:	6890                	ld	a2,16(s1)
    800017f8:	4681                	li	a3,0
    800017fa:	8231                	srli	a2,a2,0xc
    800017fc:	648c                	ld	a1,8(s1)
    800017fe:	05093503          	ld	a0,80(s2)
    80001802:	fffff097          	auipc	ra,0xfffff
    80001806:	f06080e7          	jalr	-250(ra) # 80000708 <uvmunmap>
      memset(v, 0, sizeof(struct VMA));
    8000180a:	03000613          	li	a2,48
    8000180e:	4581                	li	a1,0
    80001810:	8526                	mv	a0,s1
    80001812:	fffff097          	auipc	ra,0xfffff
    80001816:	968080e7          	jalr	-1688(ra) # 8000017a <memset>
    8000181a:	bfc1                	j	800017ea <exit+0x62>
  begin_op();
    8000181c:	00002097          	auipc	ra,0x2
    80001820:	dbc080e7          	jalr	-580(ra) # 800035d8 <begin_op>
  iput(p->cwd);
    80001824:	15093503          	ld	a0,336(s2)
    80001828:	00001097          	auipc	ra,0x1
    8000182c:	58e080e7          	jalr	1422(ra) # 80002db6 <iput>
  end_op();
    80001830:	00002097          	auipc	ra,0x2
    80001834:	e26080e7          	jalr	-474(ra) # 80003656 <end_op>
  p->cwd = 0;
    80001838:	14093823          	sd	zero,336(s2)
  acquire(&wait_lock);
    8000183c:	00008497          	auipc	s1,0x8
    80001840:	82c48493          	addi	s1,s1,-2004 # 80009068 <wait_lock>
    80001844:	8526                	mv	a0,s1
    80001846:	00005097          	auipc	ra,0x5
    8000184a:	d02080e7          	jalr	-766(ra) # 80006548 <acquire>
  reparent(p);
    8000184e:	854a                	mv	a0,s2
    80001850:	00000097          	auipc	ra,0x0
    80001854:	ede080e7          	jalr	-290(ra) # 8000172e <reparent>
  wakeup(p->parent);
    80001858:	03893503          	ld	a0,56(s2)
    8000185c:	00000097          	auipc	ra,0x0
    80001860:	e5c080e7          	jalr	-420(ra) # 800016b8 <wakeup>
  acquire(&p->lock);
    80001864:	854a                	mv	a0,s2
    80001866:	00005097          	auipc	ra,0x5
    8000186a:	ce2080e7          	jalr	-798(ra) # 80006548 <acquire>
  p->xstate = status;
    8000186e:	03492623          	sw	s4,44(s2)
  p->state = ZOMBIE;
    80001872:	4795                	li	a5,5
    80001874:	00f92c23          	sw	a5,24(s2)
  release(&wait_lock);
    80001878:	8526                	mv	a0,s1
    8000187a:	00005097          	auipc	ra,0x5
    8000187e:	d82080e7          	jalr	-638(ra) # 800065fc <release>
  sched();
    80001882:	00000097          	auipc	ra,0x0
    80001886:	b98080e7          	jalr	-1128(ra) # 8000141a <sched>
  panic("zombie exit");
    8000188a:	00007517          	auipc	a0,0x7
    8000188e:	92e50513          	addi	a0,a0,-1746 # 800081b8 <etext+0x1b8>
    80001892:	00004097          	auipc	ra,0x4
    80001896:	77e080e7          	jalr	1918(ra) # 80006010 <panic>

000000008000189a <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid)
{
    8000189a:	7179                	addi	sp,sp,-48
    8000189c:	f406                	sd	ra,40(sp)
    8000189e:	f022                	sd	s0,32(sp)
    800018a0:	ec26                	sd	s1,24(sp)
    800018a2:	e84a                	sd	s2,16(sp)
    800018a4:	e44e                	sd	s3,8(sp)
    800018a6:	1800                	addi	s0,sp,48
    800018a8:	892a                	mv	s2,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    800018aa:	00008497          	auipc	s1,0x8
    800018ae:	bd648493          	addi	s1,s1,-1066 # 80009480 <proc>
    800018b2:	00019997          	auipc	s3,0x19
    800018b6:	5ce98993          	addi	s3,s3,1486 # 8001ae80 <tickslock>
  {
    acquire(&p->lock);
    800018ba:	8526                	mv	a0,s1
    800018bc:	00005097          	auipc	ra,0x5
    800018c0:	c8c080e7          	jalr	-884(ra) # 80006548 <acquire>
    if (p->pid == pid)
    800018c4:	589c                	lw	a5,48(s1)
    800018c6:	01278d63          	beq	a5,s2,800018e0 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800018ca:	8526                	mv	a0,s1
    800018cc:	00005097          	auipc	ra,0x5
    800018d0:	d30080e7          	jalr	-720(ra) # 800065fc <release>
  for (p = proc; p < &proc[NPROC]; p++)
    800018d4:	46848493          	addi	s1,s1,1128
    800018d8:	ff3491e3          	bne	s1,s3,800018ba <kill+0x20>
  }
  return -1;
    800018dc:	557d                	li	a0,-1
    800018de:	a829                	j	800018f8 <kill+0x5e>
      p->killed = 1;
    800018e0:	4785                	li	a5,1
    800018e2:	d49c                	sw	a5,40(s1)
      if (p->state == SLEEPING)
    800018e4:	4c98                	lw	a4,24(s1)
    800018e6:	4789                	li	a5,2
    800018e8:	00f70f63          	beq	a4,a5,80001906 <kill+0x6c>
      release(&p->lock);
    800018ec:	8526                	mv	a0,s1
    800018ee:	00005097          	auipc	ra,0x5
    800018f2:	d0e080e7          	jalr	-754(ra) # 800065fc <release>
      return 0;
    800018f6:	4501                	li	a0,0
}
    800018f8:	70a2                	ld	ra,40(sp)
    800018fa:	7402                	ld	s0,32(sp)
    800018fc:	64e2                	ld	s1,24(sp)
    800018fe:	6942                	ld	s2,16(sp)
    80001900:	69a2                	ld	s3,8(sp)
    80001902:	6145                	addi	sp,sp,48
    80001904:	8082                	ret
        p->state = RUNNABLE;
    80001906:	478d                	li	a5,3
    80001908:	cc9c                	sw	a5,24(s1)
    8000190a:	b7cd                	j	800018ec <kill+0x52>

000000008000190c <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000190c:	7179                	addi	sp,sp,-48
    8000190e:	f406                	sd	ra,40(sp)
    80001910:	f022                	sd	s0,32(sp)
    80001912:	ec26                	sd	s1,24(sp)
    80001914:	e84a                	sd	s2,16(sp)
    80001916:	e44e                	sd	s3,8(sp)
    80001918:	e052                	sd	s4,0(sp)
    8000191a:	1800                	addi	s0,sp,48
    8000191c:	84aa                	mv	s1,a0
    8000191e:	892e                	mv	s2,a1
    80001920:	89b2                	mv	s3,a2
    80001922:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001924:	fffff097          	auipc	ra,0xfffff
    80001928:	506080e7          	jalr	1286(ra) # 80000e2a <myproc>
  if (user_dst)
    8000192c:	c08d                	beqz	s1,8000194e <either_copyout+0x42>
  {
    return copyout(p->pagetable, dst, src, len);
    8000192e:	86d2                	mv	a3,s4
    80001930:	864e                	mv	a2,s3
    80001932:	85ca                	mv	a1,s2
    80001934:	6928                	ld	a0,80(a0)
    80001936:	fffff097          	auipc	ra,0xfffff
    8000193a:	1b8080e7          	jalr	440(ra) # 80000aee <copyout>
  else
  {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000193e:	70a2                	ld	ra,40(sp)
    80001940:	7402                	ld	s0,32(sp)
    80001942:	64e2                	ld	s1,24(sp)
    80001944:	6942                	ld	s2,16(sp)
    80001946:	69a2                	ld	s3,8(sp)
    80001948:	6a02                	ld	s4,0(sp)
    8000194a:	6145                	addi	sp,sp,48
    8000194c:	8082                	ret
    memmove((char *)dst, src, len);
    8000194e:	000a061b          	sext.w	a2,s4
    80001952:	85ce                	mv	a1,s3
    80001954:	854a                	mv	a0,s2
    80001956:	fffff097          	auipc	ra,0xfffff
    8000195a:	880080e7          	jalr	-1920(ra) # 800001d6 <memmove>
    return 0;
    8000195e:	8526                	mv	a0,s1
    80001960:	bff9                	j	8000193e <either_copyout+0x32>

0000000080001962 <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001962:	7179                	addi	sp,sp,-48
    80001964:	f406                	sd	ra,40(sp)
    80001966:	f022                	sd	s0,32(sp)
    80001968:	ec26                	sd	s1,24(sp)
    8000196a:	e84a                	sd	s2,16(sp)
    8000196c:	e44e                	sd	s3,8(sp)
    8000196e:	e052                	sd	s4,0(sp)
    80001970:	1800                	addi	s0,sp,48
    80001972:	892a                	mv	s2,a0
    80001974:	84ae                	mv	s1,a1
    80001976:	89b2                	mv	s3,a2
    80001978:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000197a:	fffff097          	auipc	ra,0xfffff
    8000197e:	4b0080e7          	jalr	1200(ra) # 80000e2a <myproc>
  if (user_src)
    80001982:	c08d                	beqz	s1,800019a4 <either_copyin+0x42>
  {
    return copyin(p->pagetable, dst, src, len);
    80001984:	86d2                	mv	a3,s4
    80001986:	864e                	mv	a2,s3
    80001988:	85ca                	mv	a1,s2
    8000198a:	6928                	ld	a0,80(a0)
    8000198c:	fffff097          	auipc	ra,0xfffff
    80001990:	1ee080e7          	jalr	494(ra) # 80000b7a <copyin>
  else
  {
    memmove(dst, (char *)src, len);
    return 0;
  }
}
    80001994:	70a2                	ld	ra,40(sp)
    80001996:	7402                	ld	s0,32(sp)
    80001998:	64e2                	ld	s1,24(sp)
    8000199a:	6942                	ld	s2,16(sp)
    8000199c:	69a2                	ld	s3,8(sp)
    8000199e:	6a02                	ld	s4,0(sp)
    800019a0:	6145                	addi	sp,sp,48
    800019a2:	8082                	ret
    memmove(dst, (char *)src, len);
    800019a4:	000a061b          	sext.w	a2,s4
    800019a8:	85ce                	mv	a1,s3
    800019aa:	854a                	mv	a0,s2
    800019ac:	fffff097          	auipc	ra,0xfffff
    800019b0:	82a080e7          	jalr	-2006(ra) # 800001d6 <memmove>
    return 0;
    800019b4:	8526                	mv	a0,s1
    800019b6:	bff9                	j	80001994 <either_copyin+0x32>

00000000800019b8 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
    800019b8:	715d                	addi	sp,sp,-80
    800019ba:	e486                	sd	ra,72(sp)
    800019bc:	e0a2                	sd	s0,64(sp)
    800019be:	fc26                	sd	s1,56(sp)
    800019c0:	f84a                	sd	s2,48(sp)
    800019c2:	f44e                	sd	s3,40(sp)
    800019c4:	f052                	sd	s4,32(sp)
    800019c6:	ec56                	sd	s5,24(sp)
    800019c8:	e85a                	sd	s6,16(sp)
    800019ca:	e45e                	sd	s7,8(sp)
    800019cc:	0880                	addi	s0,sp,80
      [RUNNING] "run   ",
      [ZOMBIE] "zombie"};
  struct proc *p;
  char *state;

  printf("\n");
    800019ce:	00006517          	auipc	a0,0x6
    800019d2:	67a50513          	addi	a0,a0,1658 # 80008048 <etext+0x48>
    800019d6:	00004097          	auipc	ra,0x4
    800019da:	684080e7          	jalr	1668(ra) # 8000605a <printf>
  for (p = proc; p < &proc[NPROC]; p++)
    800019de:	00008497          	auipc	s1,0x8
    800019e2:	bfa48493          	addi	s1,s1,-1030 # 800095d8 <proc+0x158>
    800019e6:	00019917          	auipc	s2,0x19
    800019ea:	5f290913          	addi	s2,s2,1522 # 8001afd8 <bcache+0x140>
  {
    if (p->state == UNUSED)
      continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019ee:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800019f0:	00006997          	auipc	s3,0x6
    800019f4:	7d898993          	addi	s3,s3,2008 # 800081c8 <etext+0x1c8>
    printf("%d %s %s", p->pid, state, p->name);
    800019f8:	00006a97          	auipc	s5,0x6
    800019fc:	7d8a8a93          	addi	s5,s5,2008 # 800081d0 <etext+0x1d0>
    printf("\n");
    80001a00:	00006a17          	auipc	s4,0x6
    80001a04:	648a0a13          	addi	s4,s4,1608 # 80008048 <etext+0x48>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a08:	00007b97          	auipc	s7,0x7
    80001a0c:	800b8b93          	addi	s7,s7,-2048 # 80008208 <states.0>
    80001a10:	a00d                	j	80001a32 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a12:	ed86a583          	lw	a1,-296(a3)
    80001a16:	8556                	mv	a0,s5
    80001a18:	00004097          	auipc	ra,0x4
    80001a1c:	642080e7          	jalr	1602(ra) # 8000605a <printf>
    printf("\n");
    80001a20:	8552                	mv	a0,s4
    80001a22:	00004097          	auipc	ra,0x4
    80001a26:	638080e7          	jalr	1592(ra) # 8000605a <printf>
  for (p = proc; p < &proc[NPROC]; p++)
    80001a2a:	46848493          	addi	s1,s1,1128
    80001a2e:	03248263          	beq	s1,s2,80001a52 <procdump+0x9a>
    if (p->state == UNUSED)
    80001a32:	86a6                	mv	a3,s1
    80001a34:	ec04a783          	lw	a5,-320(s1)
    80001a38:	dbed                	beqz	a5,80001a2a <procdump+0x72>
      state = "???";
    80001a3a:	864e                	mv	a2,s3
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a3c:	fcfb6be3          	bltu	s6,a5,80001a12 <procdump+0x5a>
    80001a40:	02079713          	slli	a4,a5,0x20
    80001a44:	01d75793          	srli	a5,a4,0x1d
    80001a48:	97de                	add	a5,a5,s7
    80001a4a:	6390                	ld	a2,0(a5)
    80001a4c:	f279                	bnez	a2,80001a12 <procdump+0x5a>
      state = "???";
    80001a4e:	864e                	mv	a2,s3
    80001a50:	b7c9                	j	80001a12 <procdump+0x5a>
  }
}
    80001a52:	60a6                	ld	ra,72(sp)
    80001a54:	6406                	ld	s0,64(sp)
    80001a56:	74e2                	ld	s1,56(sp)
    80001a58:	7942                	ld	s2,48(sp)
    80001a5a:	79a2                	ld	s3,40(sp)
    80001a5c:	7a02                	ld	s4,32(sp)
    80001a5e:	6ae2                	ld	s5,24(sp)
    80001a60:	6b42                	ld	s6,16(sp)
    80001a62:	6ba2                	ld	s7,8(sp)
    80001a64:	6161                	addi	sp,sp,80
    80001a66:	8082                	ret

0000000080001a68 <swtch>:
    80001a68:	00153023          	sd	ra,0(a0)
    80001a6c:	00253423          	sd	sp,8(a0)
    80001a70:	e900                	sd	s0,16(a0)
    80001a72:	ed04                	sd	s1,24(a0)
    80001a74:	03253023          	sd	s2,32(a0)
    80001a78:	03353423          	sd	s3,40(a0)
    80001a7c:	03453823          	sd	s4,48(a0)
    80001a80:	03553c23          	sd	s5,56(a0)
    80001a84:	05653023          	sd	s6,64(a0)
    80001a88:	05753423          	sd	s7,72(a0)
    80001a8c:	05853823          	sd	s8,80(a0)
    80001a90:	05953c23          	sd	s9,88(a0)
    80001a94:	07a53023          	sd	s10,96(a0)
    80001a98:	07b53423          	sd	s11,104(a0)
    80001a9c:	0005b083          	ld	ra,0(a1)
    80001aa0:	0085b103          	ld	sp,8(a1)
    80001aa4:	6980                	ld	s0,16(a1)
    80001aa6:	6d84                	ld	s1,24(a1)
    80001aa8:	0205b903          	ld	s2,32(a1)
    80001aac:	0285b983          	ld	s3,40(a1)
    80001ab0:	0305ba03          	ld	s4,48(a1)
    80001ab4:	0385ba83          	ld	s5,56(a1)
    80001ab8:	0405bb03          	ld	s6,64(a1)
    80001abc:	0485bb83          	ld	s7,72(a1)
    80001ac0:	0505bc03          	ld	s8,80(a1)
    80001ac4:	0585bc83          	ld	s9,88(a1)
    80001ac8:	0605bd03          	ld	s10,96(a1)
    80001acc:	0685bd83          	ld	s11,104(a1)
    80001ad0:	8082                	ret

0000000080001ad2 <trapinit>:
void kernelvec();

extern int devintr();

void trapinit(void)
{
    80001ad2:	1141                	addi	sp,sp,-16
    80001ad4:	e406                	sd	ra,8(sp)
    80001ad6:	e022                	sd	s0,0(sp)
    80001ad8:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001ada:	00006597          	auipc	a1,0x6
    80001ade:	75e58593          	addi	a1,a1,1886 # 80008238 <states.0+0x30>
    80001ae2:	00019517          	auipc	a0,0x19
    80001ae6:	39e50513          	addi	a0,a0,926 # 8001ae80 <tickslock>
    80001aea:	00005097          	auipc	ra,0x5
    80001aee:	9ce080e7          	jalr	-1586(ra) # 800064b8 <initlock>
}
    80001af2:	60a2                	ld	ra,8(sp)
    80001af4:	6402                	ld	s0,0(sp)
    80001af6:	0141                	addi	sp,sp,16
    80001af8:	8082                	ret

0000000080001afa <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void)
{
    80001afa:	1141                	addi	sp,sp,-16
    80001afc:	e422                	sd	s0,8(sp)
    80001afe:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b00:	00004797          	auipc	a5,0x4
    80001b04:	97078793          	addi	a5,a5,-1680 # 80005470 <kernelvec>
    80001b08:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b0c:	6422                	ld	s0,8(sp)
    80001b0e:	0141                	addi	sp,sp,16
    80001b10:	8082                	ret

0000000080001b12 <usertrapret>:

//
// return to user space
//
void usertrapret(void)
{
    80001b12:	1141                	addi	sp,sp,-16
    80001b14:	e406                	sd	ra,8(sp)
    80001b16:	e022                	sd	s0,0(sp)
    80001b18:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b1a:	fffff097          	auipc	ra,0xfffff
    80001b1e:	310080e7          	jalr	784(ra) # 80000e2a <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b22:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b26:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b28:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001b2c:	00005697          	auipc	a3,0x5
    80001b30:	4d468693          	addi	a3,a3,1236 # 80007000 <_trampoline>
    80001b34:	00005717          	auipc	a4,0x5
    80001b38:	4cc70713          	addi	a4,a4,1228 # 80007000 <_trampoline>
    80001b3c:	8f15                	sub	a4,a4,a3
    80001b3e:	040007b7          	lui	a5,0x4000
    80001b42:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001b44:	07b2                	slli	a5,a5,0xc
    80001b46:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b48:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b4c:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b4e:	18002673          	csrr	a2,satp
    80001b52:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b54:	6d30                	ld	a2,88(a0)
    80001b56:	6138                	ld	a4,64(a0)
    80001b58:	6585                	lui	a1,0x1
    80001b5a:	972e                	add	a4,a4,a1
    80001b5c:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b5e:	6d38                	ld	a4,88(a0)
    80001b60:	00000617          	auipc	a2,0x0
    80001b64:	13860613          	addi	a2,a2,312 # 80001c98 <usertrap>
    80001b68:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80001b6a:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b6c:	8612                	mv	a2,tp
    80001b6e:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b70:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b74:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b78:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b7c:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001b80:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b82:	6f18                	ld	a4,24(a4)
    80001b84:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b88:	692c                	ld	a1,80(a0)
    80001b8a:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001b8c:	00005717          	auipc	a4,0x5
    80001b90:	50470713          	addi	a4,a4,1284 # 80007090 <userret>
    80001b94:	8f15                	sub	a4,a4,a3
    80001b96:	97ba                	add	a5,a5,a4
  ((void (*)(uint64, uint64))fn)(TRAPFRAME, satp);
    80001b98:	577d                	li	a4,-1
    80001b9a:	177e                	slli	a4,a4,0x3f
    80001b9c:	8dd9                	or	a1,a1,a4
    80001b9e:	02000537          	lui	a0,0x2000
    80001ba2:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001ba4:	0536                	slli	a0,a0,0xd
    80001ba6:	9782                	jalr	a5
}
    80001ba8:	60a2                	ld	ra,8(sp)
    80001baa:	6402                	ld	s0,0(sp)
    80001bac:	0141                	addi	sp,sp,16
    80001bae:	8082                	ret

0000000080001bb0 <clockintr>:
  w_sepc(sepc);
  w_sstatus(sstatus);
}

void clockintr()
{
    80001bb0:	1101                	addi	sp,sp,-32
    80001bb2:	ec06                	sd	ra,24(sp)
    80001bb4:	e822                	sd	s0,16(sp)
    80001bb6:	e426                	sd	s1,8(sp)
    80001bb8:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001bba:	00019497          	auipc	s1,0x19
    80001bbe:	2c648493          	addi	s1,s1,710 # 8001ae80 <tickslock>
    80001bc2:	8526                	mv	a0,s1
    80001bc4:	00005097          	auipc	ra,0x5
    80001bc8:	984080e7          	jalr	-1660(ra) # 80006548 <acquire>
  ticks++;
    80001bcc:	00007517          	auipc	a0,0x7
    80001bd0:	44c50513          	addi	a0,a0,1100 # 80009018 <ticks>
    80001bd4:	411c                	lw	a5,0(a0)
    80001bd6:	2785                	addiw	a5,a5,1
    80001bd8:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001bda:	00000097          	auipc	ra,0x0
    80001bde:	ade080e7          	jalr	-1314(ra) # 800016b8 <wakeup>
  release(&tickslock);
    80001be2:	8526                	mv	a0,s1
    80001be4:	00005097          	auipc	ra,0x5
    80001be8:	a18080e7          	jalr	-1512(ra) # 800065fc <release>
}
    80001bec:	60e2                	ld	ra,24(sp)
    80001bee:	6442                	ld	s0,16(sp)
    80001bf0:	64a2                	ld	s1,8(sp)
    80001bf2:	6105                	addi	sp,sp,32
    80001bf4:	8082                	ret

0000000080001bf6 <devintr>:
// and handle it.
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int devintr()
{
    80001bf6:	1101                	addi	sp,sp,-32
    80001bf8:	ec06                	sd	ra,24(sp)
    80001bfa:	e822                	sd	s0,16(sp)
    80001bfc:	e426                	sd	s1,8(sp)
    80001bfe:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c00:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if ((scause & 0x8000000000000000L) &&
    80001c04:	00074d63          	bltz	a4,80001c1e <devintr+0x28>
    if (irq)
      plic_complete(irq);

    return 1;
  }
  else if (scause == 0x8000000000000001L)
    80001c08:	57fd                	li	a5,-1
    80001c0a:	17fe                	slli	a5,a5,0x3f
    80001c0c:	0785                	addi	a5,a5,1

    return 2;
  }
  else
  {
    return 0;
    80001c0e:	4501                	li	a0,0
  else if (scause == 0x8000000000000001L)
    80001c10:	06f70363          	beq	a4,a5,80001c76 <devintr+0x80>
  }
}
    80001c14:	60e2                	ld	ra,24(sp)
    80001c16:	6442                	ld	s0,16(sp)
    80001c18:	64a2                	ld	s1,8(sp)
    80001c1a:	6105                	addi	sp,sp,32
    80001c1c:	8082                	ret
      (scause & 0xff) == 9)
    80001c1e:	0ff77793          	zext.b	a5,a4
  if ((scause & 0x8000000000000000L) &&
    80001c22:	46a5                	li	a3,9
    80001c24:	fed792e3          	bne	a5,a3,80001c08 <devintr+0x12>
    int irq = plic_claim();
    80001c28:	00004097          	auipc	ra,0x4
    80001c2c:	950080e7          	jalr	-1712(ra) # 80005578 <plic_claim>
    80001c30:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ)
    80001c32:	47a9                	li	a5,10
    80001c34:	02f50763          	beq	a0,a5,80001c62 <devintr+0x6c>
    else if (irq == VIRTIO0_IRQ)
    80001c38:	4785                	li	a5,1
    80001c3a:	02f50963          	beq	a0,a5,80001c6c <devintr+0x76>
    return 1;
    80001c3e:	4505                	li	a0,1
    else if (irq)
    80001c40:	d8f1                	beqz	s1,80001c14 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c42:	85a6                	mv	a1,s1
    80001c44:	00006517          	auipc	a0,0x6
    80001c48:	5fc50513          	addi	a0,a0,1532 # 80008240 <states.0+0x38>
    80001c4c:	00004097          	auipc	ra,0x4
    80001c50:	40e080e7          	jalr	1038(ra) # 8000605a <printf>
      plic_complete(irq);
    80001c54:	8526                	mv	a0,s1
    80001c56:	00004097          	auipc	ra,0x4
    80001c5a:	946080e7          	jalr	-1722(ra) # 8000559c <plic_complete>
    return 1;
    80001c5e:	4505                	li	a0,1
    80001c60:	bf55                	j	80001c14 <devintr+0x1e>
      uartintr();
    80001c62:	00005097          	auipc	ra,0x5
    80001c66:	806080e7          	jalr	-2042(ra) # 80006468 <uartintr>
    80001c6a:	b7ed                	j	80001c54 <devintr+0x5e>
      virtio_disk_intr();
    80001c6c:	00004097          	auipc	ra,0x4
    80001c70:	dbc080e7          	jalr	-580(ra) # 80005a28 <virtio_disk_intr>
    80001c74:	b7c5                	j	80001c54 <devintr+0x5e>
    if (cpuid() == 0)
    80001c76:	fffff097          	auipc	ra,0xfffff
    80001c7a:	188080e7          	jalr	392(ra) # 80000dfe <cpuid>
    80001c7e:	c901                	beqz	a0,80001c8e <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001c80:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001c84:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001c86:	14479073          	csrw	sip,a5
    return 2;
    80001c8a:	4509                	li	a0,2
    80001c8c:	b761                	j	80001c14 <devintr+0x1e>
      clockintr();
    80001c8e:	00000097          	auipc	ra,0x0
    80001c92:	f22080e7          	jalr	-222(ra) # 80001bb0 <clockintr>
    80001c96:	b7ed                	j	80001c80 <devintr+0x8a>

0000000080001c98 <usertrap>:
{
    80001c98:	715d                	addi	sp,sp,-80
    80001c9a:	e486                	sd	ra,72(sp)
    80001c9c:	e0a2                	sd	s0,64(sp)
    80001c9e:	fc26                	sd	s1,56(sp)
    80001ca0:	f84a                	sd	s2,48(sp)
    80001ca2:	f44e                	sd	s3,40(sp)
    80001ca4:	f052                	sd	s4,32(sp)
    80001ca6:	ec56                	sd	s5,24(sp)
    80001ca8:	e85a                	sd	s6,16(sp)
    80001caa:	e45e                	sd	s7,8(sp)
    80001cac:	0880                	addi	s0,sp,80
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cae:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0)
    80001cb2:	1007f793          	andi	a5,a5,256
    80001cb6:	e7bd                	bnez	a5,80001d24 <usertrap+0x8c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cb8:	00003797          	auipc	a5,0x3
    80001cbc:	7b878793          	addi	a5,a5,1976 # 80005470 <kernelvec>
    80001cc0:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001cc4:	fffff097          	auipc	ra,0xfffff
    80001cc8:	166080e7          	jalr	358(ra) # 80000e2a <myproc>
    80001ccc:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001cce:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001cd0:	14102773          	csrr	a4,sepc
    80001cd4:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cd6:	14202773          	csrr	a4,scause
  if (r_scause() == 8)
    80001cda:	47a1                	li	a5,8
    80001cdc:	06f71263          	bne	a4,a5,80001d40 <usertrap+0xa8>
    if (p->killed)
    80001ce0:	551c                	lw	a5,40(a0)
    80001ce2:	eba9                	bnez	a5,80001d34 <usertrap+0x9c>
    p->trapframe->epc += 4;
    80001ce4:	6cb8                	ld	a4,88(s1)
    80001ce6:	6f1c                	ld	a5,24(a4)
    80001ce8:	0791                	addi	a5,a5,4
    80001cea:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cec:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001cf0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001cf4:	10079073          	csrw	sstatus,a5
    syscall();
    80001cf8:	00000097          	auipc	ra,0x0
    80001cfc:	406080e7          	jalr	1030(ra) # 800020fe <syscall>
  if (p->killed)
    80001d00:	549c                	lw	a5,40(s1)
    80001d02:	1a079b63          	bnez	a5,80001eb8 <usertrap+0x220>
  usertrapret();
    80001d06:	00000097          	auipc	ra,0x0
    80001d0a:	e0c080e7          	jalr	-500(ra) # 80001b12 <usertrapret>
}
    80001d0e:	60a6                	ld	ra,72(sp)
    80001d10:	6406                	ld	s0,64(sp)
    80001d12:	74e2                	ld	s1,56(sp)
    80001d14:	7942                	ld	s2,48(sp)
    80001d16:	79a2                	ld	s3,40(sp)
    80001d18:	7a02                	ld	s4,32(sp)
    80001d1a:	6ae2                	ld	s5,24(sp)
    80001d1c:	6b42                	ld	s6,16(sp)
    80001d1e:	6ba2                	ld	s7,8(sp)
    80001d20:	6161                	addi	sp,sp,80
    80001d22:	8082                	ret
    panic("usertrap: not from user mode");
    80001d24:	00006517          	auipc	a0,0x6
    80001d28:	53c50513          	addi	a0,a0,1340 # 80008260 <states.0+0x58>
    80001d2c:	00004097          	auipc	ra,0x4
    80001d30:	2e4080e7          	jalr	740(ra) # 80006010 <panic>
      exit(-1);
    80001d34:	557d                	li	a0,-1
    80001d36:	00000097          	auipc	ra,0x0
    80001d3a:	a52080e7          	jalr	-1454(ra) # 80001788 <exit>
    80001d3e:	b75d                	j	80001ce4 <usertrap+0x4c>
  else if ((which_dev = devintr()) != 0)
    80001d40:	00000097          	auipc	ra,0x0
    80001d44:	eb6080e7          	jalr	-330(ra) # 80001bf6 <devintr>
    80001d48:	892a                	mv	s2,a0
    80001d4a:	16051363          	bnez	a0,80001eb0 <usertrap+0x218>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d4e:	14202773          	csrr	a4,scause
  else if (r_scause() == 13 || r_scause() == 15) // page fault
    80001d52:	47b5                	li	a5,13
    80001d54:	04f70d63          	beq	a4,a5,80001dae <usertrap+0x116>
    80001d58:	14202773          	csrr	a4,scause
    80001d5c:	47bd                	li	a5,15
    80001d5e:	04f70863          	beq	a4,a5,80001dae <usertrap+0x116>
    80001d62:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001d66:	5890                	lw	a2,48(s1)
    80001d68:	00006517          	auipc	a0,0x6
    80001d6c:	51850513          	addi	a0,a0,1304 # 80008280 <states.0+0x78>
    80001d70:	00004097          	auipc	ra,0x4
    80001d74:	2ea080e7          	jalr	746(ra) # 8000605a <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d78:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d7c:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d80:	00006517          	auipc	a0,0x6
    80001d84:	53050513          	addi	a0,a0,1328 # 800082b0 <states.0+0xa8>
    80001d88:	00004097          	auipc	ra,0x4
    80001d8c:	2d2080e7          	jalr	722(ra) # 8000605a <printf>
    p->killed = 1;
    80001d90:	4785                	li	a5,1
    80001d92:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001d94:	557d                	li	a0,-1
    80001d96:	00000097          	auipc	ra,0x0
    80001d9a:	9f2080e7          	jalr	-1550(ra) # 80001788 <exit>
  if (which_dev == 2)
    80001d9e:	4789                	li	a5,2
    80001da0:	f6f913e3          	bne	s2,a5,80001d06 <usertrap+0x6e>
    yield();
    80001da4:	fffff097          	auipc	ra,0xfffff
    80001da8:	74c080e7          	jalr	1868(ra) # 800014f0 <yield>
    80001dac:	bfa9                	j	80001d06 <usertrap+0x6e>
    80001dae:	14302a73          	csrr	s4,stval
    if (va >= p->sz)
    80001db2:	64bc                	ld	a5,72(s1)
    80001db4:	fafa77e3          	bgeu	s4,a5,80001d62 <usertrap+0xca>
    if (va < p->trapframe->sp)
    80001db8:	6cbc                	ld	a5,88(s1)
    80001dba:	7b9c                	ld	a5,48(a5)
    80001dbc:	fafa63e3          	bltu	s4,a5,80001d62 <usertrap+0xca>
    80001dc0:	16848793          	addi	a5,s1,360
    for (uint i = 0; i < MAXVMA; i++)
    80001dc4:	4981                	li	s3,0
    80001dc6:	4641                	li	a2,16
    80001dc8:	a821                	j	80001de0 <usertrap+0x148>
          kfree(mem);
    80001dca:	8556                	mv	a0,s5
    80001dcc:	ffffe097          	auipc	ra,0xffffe
    80001dd0:	250080e7          	jalr	592(ra) # 8000001c <kfree>
          goto a;
    80001dd4:	b779                	j	80001d62 <usertrap+0xca>
    for (uint i = 0; i < MAXVMA; i++)
    80001dd6:	2985                	addiw	s3,s3,1
    80001dd8:	03078793          	addi	a5,a5,48
    80001ddc:	f8c983e3          	beq	s3,a2,80001d62 <usertrap+0xca>
      if (v->used && va >= v->addr && va < v->addr + v->len) // find corresponding vma
    80001de0:	4398                	lw	a4,0(a5)
    80001de2:	db75                	beqz	a4,80001dd6 <usertrap+0x13e>
    80001de4:	6798                	ld	a4,8(a5)
    80001de6:	feea68e3          	bltu	s4,a4,80001dd6 <usertrap+0x13e>
    80001dea:	6b94                	ld	a3,16(a5)
    80001dec:	9736                	add	a4,a4,a3
    80001dee:	feea74e3          	bgeu	s4,a4,80001dd6 <usertrap+0x13e>
        mem = kalloc();
    80001df2:	ffffe097          	auipc	ra,0xffffe
    80001df6:	328080e7          	jalr	808(ra) # 8000011a <kalloc>
    80001dfa:	8aaa                	mv	s5,a0
        memset(mem, 0, PGSIZE);
    80001dfc:	6605                	lui	a2,0x1
    80001dfe:	4581                	li	a1,0
    80001e00:	ffffe097          	auipc	ra,0xffffe
    80001e04:	37a080e7          	jalr	890(ra) # 8000017a <memset>
        if (mem == 0)
    80001e08:	f40a8de3          	beqz	s5,80001d62 <usertrap+0xca>
        va = PGROUNDDOWN(va);
    80001e0c:	77fd                	lui	a5,0xfffff
    80001e0e:	00fa7a33          	and	s4,s4,a5
        uint64 off = v->start_point + va - v->addr; // starting point + extra offset
    80001e12:	02099693          	slli	a3,s3,0x20
    80001e16:	9281                	srli	a3,a3,0x20
    80001e18:	00169793          	slli	a5,a3,0x1
    80001e1c:	00d78733          	add	a4,a5,a3
    80001e20:	0712                	slli	a4,a4,0x4
    80001e22:	9726                	add	a4,a4,s1
    80001e24:	19073b03          	ld	s6,400(a4)
    80001e28:	00d78733          	add	a4,a5,a3
    80001e2c:	0712                	slli	a4,a4,0x4
    80001e2e:	9726                	add	a4,a4,s1
    80001e30:	17073b83          	ld	s7,368(a4)
        if (mappages(p->pagetable, va, PGSIZE, (uint64)mem, (v->prot << 1) | PTE_U) != 0)
    80001e34:	18072703          	lw	a4,384(a4)
    80001e38:	0017171b          	slliw	a4,a4,0x1
    80001e3c:	01076713          	ori	a4,a4,16
    80001e40:	2701                	sext.w	a4,a4
    80001e42:	86d6                	mv	a3,s5
    80001e44:	6605                	lui	a2,0x1
    80001e46:	85d2                	mv	a1,s4
    80001e48:	68a8                	ld	a0,80(s1)
    80001e4a:	ffffe097          	auipc	ra,0xffffe
    80001e4e:	6f8080e7          	jalr	1784(ra) # 80000542 <mappages>
    80001e52:	fd25                	bnez	a0,80001dca <usertrap+0x132>
        ilock(v->f->ip);
    80001e54:	1982                	slli	s3,s3,0x20
    80001e56:	0209d993          	srli	s3,s3,0x20
    80001e5a:	00199913          	slli	s2,s3,0x1
    80001e5e:	013907b3          	add	a5,s2,s3
    80001e62:	0792                	slli	a5,a5,0x4
    80001e64:	97a6                	add	a5,a5,s1
    80001e66:	1887b783          	ld	a5,392(a5) # fffffffffffff188 <end+0xffffffff7ffccf48>
    80001e6a:	6f88                	ld	a0,24(a5)
    80001e6c:	00001097          	auipc	ra,0x1
    80001e70:	d90080e7          	jalr	-624(ra) # 80002bfc <ilock>
        uint64 off = v->start_point + va - v->addr; // starting point + extra offset
    80001e74:	014b06b3          	add	a3,s6,s4
        readi(v->f->ip, 1, va, off, PGSIZE);
    80001e78:	013907b3          	add	a5,s2,s3
    80001e7c:	0792                	slli	a5,a5,0x4
    80001e7e:	97a6                	add	a5,a5,s1
    80001e80:	1887b783          	ld	a5,392(a5)
    80001e84:	6705                	lui	a4,0x1
    80001e86:	417686bb          	subw	a3,a3,s7
    80001e8a:	8652                	mv	a2,s4
    80001e8c:	4585                	li	a1,1
    80001e8e:	6f88                	ld	a0,24(a5)
    80001e90:	00001097          	auipc	ra,0x1
    80001e94:	020080e7          	jalr	32(ra) # 80002eb0 <readi>
        iunlock(v->f->ip);
    80001e98:	013907b3          	add	a5,s2,s3
    80001e9c:	0792                	slli	a5,a5,0x4
    80001e9e:	97a6                	add	a5,a5,s1
    80001ea0:	1887b783          	ld	a5,392(a5)
    80001ea4:	6f88                	ld	a0,24(a5)
    80001ea6:	00001097          	auipc	ra,0x1
    80001eaa:	e18080e7          	jalr	-488(ra) # 80002cbe <iunlock>
    if (!lazy)
    80001eae:	bd89                	j	80001d00 <usertrap+0x68>
  if (p->killed)
    80001eb0:	549c                	lw	a5,40(s1)
    80001eb2:	ee0786e3          	beqz	a5,80001d9e <usertrap+0x106>
    80001eb6:	bdf9                	j	80001d94 <usertrap+0xfc>
    80001eb8:	4901                	li	s2,0
    80001eba:	bde9                	j	80001d94 <usertrap+0xfc>

0000000080001ebc <kerneltrap>:
{
    80001ebc:	7179                	addi	sp,sp,-48
    80001ebe:	f406                	sd	ra,40(sp)
    80001ec0:	f022                	sd	s0,32(sp)
    80001ec2:	ec26                	sd	s1,24(sp)
    80001ec4:	e84a                	sd	s2,16(sp)
    80001ec6:	e44e                	sd	s3,8(sp)
    80001ec8:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001eca:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ece:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ed2:	142029f3          	csrr	s3,scause
  if ((sstatus & SSTATUS_SPP) == 0)
    80001ed6:	1004f793          	andi	a5,s1,256
    80001eda:	cb85                	beqz	a5,80001f0a <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001edc:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001ee0:	8b89                	andi	a5,a5,2
  if (intr_get() != 0)
    80001ee2:	ef85                	bnez	a5,80001f1a <kerneltrap+0x5e>
  if ((which_dev = devintr()) == 0)
    80001ee4:	00000097          	auipc	ra,0x0
    80001ee8:	d12080e7          	jalr	-750(ra) # 80001bf6 <devintr>
    80001eec:	cd1d                	beqz	a0,80001f2a <kerneltrap+0x6e>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001eee:	4789                	li	a5,2
    80001ef0:	06f50a63          	beq	a0,a5,80001f64 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001ef4:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ef8:	10049073          	csrw	sstatus,s1
}
    80001efc:	70a2                	ld	ra,40(sp)
    80001efe:	7402                	ld	s0,32(sp)
    80001f00:	64e2                	ld	s1,24(sp)
    80001f02:	6942                	ld	s2,16(sp)
    80001f04:	69a2                	ld	s3,8(sp)
    80001f06:	6145                	addi	sp,sp,48
    80001f08:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001f0a:	00006517          	auipc	a0,0x6
    80001f0e:	3c650513          	addi	a0,a0,966 # 800082d0 <states.0+0xc8>
    80001f12:	00004097          	auipc	ra,0x4
    80001f16:	0fe080e7          	jalr	254(ra) # 80006010 <panic>
    panic("kerneltrap: interrupts enabled");
    80001f1a:	00006517          	auipc	a0,0x6
    80001f1e:	3de50513          	addi	a0,a0,990 # 800082f8 <states.0+0xf0>
    80001f22:	00004097          	auipc	ra,0x4
    80001f26:	0ee080e7          	jalr	238(ra) # 80006010 <panic>
    printf("scause %p\n", scause);
    80001f2a:	85ce                	mv	a1,s3
    80001f2c:	00006517          	auipc	a0,0x6
    80001f30:	3ec50513          	addi	a0,a0,1004 # 80008318 <states.0+0x110>
    80001f34:	00004097          	auipc	ra,0x4
    80001f38:	126080e7          	jalr	294(ra) # 8000605a <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f3c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f40:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f44:	00006517          	auipc	a0,0x6
    80001f48:	3e450513          	addi	a0,a0,996 # 80008328 <states.0+0x120>
    80001f4c:	00004097          	auipc	ra,0x4
    80001f50:	10e080e7          	jalr	270(ra) # 8000605a <printf>
    panic("kerneltrap");
    80001f54:	00006517          	auipc	a0,0x6
    80001f58:	3ec50513          	addi	a0,a0,1004 # 80008340 <states.0+0x138>
    80001f5c:	00004097          	auipc	ra,0x4
    80001f60:	0b4080e7          	jalr	180(ra) # 80006010 <panic>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f64:	fffff097          	auipc	ra,0xfffff
    80001f68:	ec6080e7          	jalr	-314(ra) # 80000e2a <myproc>
    80001f6c:	d541                	beqz	a0,80001ef4 <kerneltrap+0x38>
    80001f6e:	fffff097          	auipc	ra,0xfffff
    80001f72:	ebc080e7          	jalr	-324(ra) # 80000e2a <myproc>
    80001f76:	4d18                	lw	a4,24(a0)
    80001f78:	4791                	li	a5,4
    80001f7a:	f6f71de3          	bne	a4,a5,80001ef4 <kerneltrap+0x38>
    yield();
    80001f7e:	fffff097          	auipc	ra,0xfffff
    80001f82:	572080e7          	jalr	1394(ra) # 800014f0 <yield>
    80001f86:	b7bd                	j	80001ef4 <kerneltrap+0x38>

0000000080001f88 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001f88:	1101                	addi	sp,sp,-32
    80001f8a:	ec06                	sd	ra,24(sp)
    80001f8c:	e822                	sd	s0,16(sp)
    80001f8e:	e426                	sd	s1,8(sp)
    80001f90:	1000                	addi	s0,sp,32
    80001f92:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001f94:	fffff097          	auipc	ra,0xfffff
    80001f98:	e96080e7          	jalr	-362(ra) # 80000e2a <myproc>
  switch (n) {
    80001f9c:	4795                	li	a5,5
    80001f9e:	0497e163          	bltu	a5,s1,80001fe0 <argraw+0x58>
    80001fa2:	048a                	slli	s1,s1,0x2
    80001fa4:	00006717          	auipc	a4,0x6
    80001fa8:	3d470713          	addi	a4,a4,980 # 80008378 <states.0+0x170>
    80001fac:	94ba                	add	s1,s1,a4
    80001fae:	409c                	lw	a5,0(s1)
    80001fb0:	97ba                	add	a5,a5,a4
    80001fb2:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001fb4:	6d3c                	ld	a5,88(a0)
    80001fb6:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001fb8:	60e2                	ld	ra,24(sp)
    80001fba:	6442                	ld	s0,16(sp)
    80001fbc:	64a2                	ld	s1,8(sp)
    80001fbe:	6105                	addi	sp,sp,32
    80001fc0:	8082                	ret
    return p->trapframe->a1;
    80001fc2:	6d3c                	ld	a5,88(a0)
    80001fc4:	7fa8                	ld	a0,120(a5)
    80001fc6:	bfcd                	j	80001fb8 <argraw+0x30>
    return p->trapframe->a2;
    80001fc8:	6d3c                	ld	a5,88(a0)
    80001fca:	63c8                	ld	a0,128(a5)
    80001fcc:	b7f5                	j	80001fb8 <argraw+0x30>
    return p->trapframe->a3;
    80001fce:	6d3c                	ld	a5,88(a0)
    80001fd0:	67c8                	ld	a0,136(a5)
    80001fd2:	b7dd                	j	80001fb8 <argraw+0x30>
    return p->trapframe->a4;
    80001fd4:	6d3c                	ld	a5,88(a0)
    80001fd6:	6bc8                	ld	a0,144(a5)
    80001fd8:	b7c5                	j	80001fb8 <argraw+0x30>
    return p->trapframe->a5;
    80001fda:	6d3c                	ld	a5,88(a0)
    80001fdc:	6fc8                	ld	a0,152(a5)
    80001fde:	bfe9                	j	80001fb8 <argraw+0x30>
  panic("argraw");
    80001fe0:	00006517          	auipc	a0,0x6
    80001fe4:	37050513          	addi	a0,a0,880 # 80008350 <states.0+0x148>
    80001fe8:	00004097          	auipc	ra,0x4
    80001fec:	028080e7          	jalr	40(ra) # 80006010 <panic>

0000000080001ff0 <fetchaddr>:
{
    80001ff0:	1101                	addi	sp,sp,-32
    80001ff2:	ec06                	sd	ra,24(sp)
    80001ff4:	e822                	sd	s0,16(sp)
    80001ff6:	e426                	sd	s1,8(sp)
    80001ff8:	e04a                	sd	s2,0(sp)
    80001ffa:	1000                	addi	s0,sp,32
    80001ffc:	84aa                	mv	s1,a0
    80001ffe:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002000:	fffff097          	auipc	ra,0xfffff
    80002004:	e2a080e7          	jalr	-470(ra) # 80000e2a <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002008:	653c                	ld	a5,72(a0)
    8000200a:	02f4f863          	bgeu	s1,a5,8000203a <fetchaddr+0x4a>
    8000200e:	00848713          	addi	a4,s1,8
    80002012:	02e7e663          	bltu	a5,a4,8000203e <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002016:	46a1                	li	a3,8
    80002018:	8626                	mv	a2,s1
    8000201a:	85ca                	mv	a1,s2
    8000201c:	6928                	ld	a0,80(a0)
    8000201e:	fffff097          	auipc	ra,0xfffff
    80002022:	b5c080e7          	jalr	-1188(ra) # 80000b7a <copyin>
    80002026:	00a03533          	snez	a0,a0
    8000202a:	40a00533          	neg	a0,a0
}
    8000202e:	60e2                	ld	ra,24(sp)
    80002030:	6442                	ld	s0,16(sp)
    80002032:	64a2                	ld	s1,8(sp)
    80002034:	6902                	ld	s2,0(sp)
    80002036:	6105                	addi	sp,sp,32
    80002038:	8082                	ret
    return -1;
    8000203a:	557d                	li	a0,-1
    8000203c:	bfcd                	j	8000202e <fetchaddr+0x3e>
    8000203e:	557d                	li	a0,-1
    80002040:	b7fd                	j	8000202e <fetchaddr+0x3e>

0000000080002042 <fetchstr>:
{
    80002042:	7179                	addi	sp,sp,-48
    80002044:	f406                	sd	ra,40(sp)
    80002046:	f022                	sd	s0,32(sp)
    80002048:	ec26                	sd	s1,24(sp)
    8000204a:	e84a                	sd	s2,16(sp)
    8000204c:	e44e                	sd	s3,8(sp)
    8000204e:	1800                	addi	s0,sp,48
    80002050:	892a                	mv	s2,a0
    80002052:	84ae                	mv	s1,a1
    80002054:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002056:	fffff097          	auipc	ra,0xfffff
    8000205a:	dd4080e7          	jalr	-556(ra) # 80000e2a <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    8000205e:	86ce                	mv	a3,s3
    80002060:	864a                	mv	a2,s2
    80002062:	85a6                	mv	a1,s1
    80002064:	6928                	ld	a0,80(a0)
    80002066:	fffff097          	auipc	ra,0xfffff
    8000206a:	ba2080e7          	jalr	-1118(ra) # 80000c08 <copyinstr>
  if(err < 0)
    8000206e:	00054763          	bltz	a0,8000207c <fetchstr+0x3a>
  return strlen(buf);
    80002072:	8526                	mv	a0,s1
    80002074:	ffffe097          	auipc	ra,0xffffe
    80002078:	282080e7          	jalr	642(ra) # 800002f6 <strlen>
}
    8000207c:	70a2                	ld	ra,40(sp)
    8000207e:	7402                	ld	s0,32(sp)
    80002080:	64e2                	ld	s1,24(sp)
    80002082:	6942                	ld	s2,16(sp)
    80002084:	69a2                	ld	s3,8(sp)
    80002086:	6145                	addi	sp,sp,48
    80002088:	8082                	ret

000000008000208a <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    8000208a:	1101                	addi	sp,sp,-32
    8000208c:	ec06                	sd	ra,24(sp)
    8000208e:	e822                	sd	s0,16(sp)
    80002090:	e426                	sd	s1,8(sp)
    80002092:	1000                	addi	s0,sp,32
    80002094:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002096:	00000097          	auipc	ra,0x0
    8000209a:	ef2080e7          	jalr	-270(ra) # 80001f88 <argraw>
    8000209e:	c088                	sw	a0,0(s1)
  return 0;
}
    800020a0:	4501                	li	a0,0
    800020a2:	60e2                	ld	ra,24(sp)
    800020a4:	6442                	ld	s0,16(sp)
    800020a6:	64a2                	ld	s1,8(sp)
    800020a8:	6105                	addi	sp,sp,32
    800020aa:	8082                	ret

00000000800020ac <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    800020ac:	1101                	addi	sp,sp,-32
    800020ae:	ec06                	sd	ra,24(sp)
    800020b0:	e822                	sd	s0,16(sp)
    800020b2:	e426                	sd	s1,8(sp)
    800020b4:	1000                	addi	s0,sp,32
    800020b6:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800020b8:	00000097          	auipc	ra,0x0
    800020bc:	ed0080e7          	jalr	-304(ra) # 80001f88 <argraw>
    800020c0:	e088                	sd	a0,0(s1)
  return 0;
}
    800020c2:	4501                	li	a0,0
    800020c4:	60e2                	ld	ra,24(sp)
    800020c6:	6442                	ld	s0,16(sp)
    800020c8:	64a2                	ld	s1,8(sp)
    800020ca:	6105                	addi	sp,sp,32
    800020cc:	8082                	ret

00000000800020ce <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800020ce:	1101                	addi	sp,sp,-32
    800020d0:	ec06                	sd	ra,24(sp)
    800020d2:	e822                	sd	s0,16(sp)
    800020d4:	e426                	sd	s1,8(sp)
    800020d6:	e04a                	sd	s2,0(sp)
    800020d8:	1000                	addi	s0,sp,32
    800020da:	84ae                	mv	s1,a1
    800020dc:	8932                	mv	s2,a2
  *ip = argraw(n);
    800020de:	00000097          	auipc	ra,0x0
    800020e2:	eaa080e7          	jalr	-342(ra) # 80001f88 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    800020e6:	864a                	mv	a2,s2
    800020e8:	85a6                	mv	a1,s1
    800020ea:	00000097          	auipc	ra,0x0
    800020ee:	f58080e7          	jalr	-168(ra) # 80002042 <fetchstr>
}
    800020f2:	60e2                	ld	ra,24(sp)
    800020f4:	6442                	ld	s0,16(sp)
    800020f6:	64a2                	ld	s1,8(sp)
    800020f8:	6902                	ld	s2,0(sp)
    800020fa:	6105                	addi	sp,sp,32
    800020fc:	8082                	ret

00000000800020fe <syscall>:
[SYS_munmap]  sys_munmap,
};

void
syscall(void)
{
    800020fe:	1101                	addi	sp,sp,-32
    80002100:	ec06                	sd	ra,24(sp)
    80002102:	e822                	sd	s0,16(sp)
    80002104:	e426                	sd	s1,8(sp)
    80002106:	e04a                	sd	s2,0(sp)
    80002108:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000210a:	fffff097          	auipc	ra,0xfffff
    8000210e:	d20080e7          	jalr	-736(ra) # 80000e2a <myproc>
    80002112:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002114:	05853903          	ld	s2,88(a0)
    80002118:	0a893783          	ld	a5,168(s2)
    8000211c:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002120:	37fd                	addiw	a5,a5,-1
    80002122:	4759                	li	a4,22
    80002124:	00f76f63          	bltu	a4,a5,80002142 <syscall+0x44>
    80002128:	00369713          	slli	a4,a3,0x3
    8000212c:	00006797          	auipc	a5,0x6
    80002130:	26478793          	addi	a5,a5,612 # 80008390 <syscalls>
    80002134:	97ba                	add	a5,a5,a4
    80002136:	639c                	ld	a5,0(a5)
    80002138:	c789                	beqz	a5,80002142 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    8000213a:	9782                	jalr	a5
    8000213c:	06a93823          	sd	a0,112(s2)
    80002140:	a839                	j	8000215e <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002142:	15848613          	addi	a2,s1,344
    80002146:	588c                	lw	a1,48(s1)
    80002148:	00006517          	auipc	a0,0x6
    8000214c:	21050513          	addi	a0,a0,528 # 80008358 <states.0+0x150>
    80002150:	00004097          	auipc	ra,0x4
    80002154:	f0a080e7          	jalr	-246(ra) # 8000605a <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002158:	6cbc                	ld	a5,88(s1)
    8000215a:	577d                	li	a4,-1
    8000215c:	fbb8                	sd	a4,112(a5)
  }
}
    8000215e:	60e2                	ld	ra,24(sp)
    80002160:	6442                	ld	s0,16(sp)
    80002162:	64a2                	ld	s1,8(sp)
    80002164:	6902                	ld	s2,0(sp)
    80002166:	6105                	addi	sp,sp,32
    80002168:	8082                	ret

000000008000216a <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000216a:	1101                	addi	sp,sp,-32
    8000216c:	ec06                	sd	ra,24(sp)
    8000216e:	e822                	sd	s0,16(sp)
    80002170:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002172:	fec40593          	addi	a1,s0,-20
    80002176:	4501                	li	a0,0
    80002178:	00000097          	auipc	ra,0x0
    8000217c:	f12080e7          	jalr	-238(ra) # 8000208a <argint>
    return -1;
    80002180:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002182:	00054963          	bltz	a0,80002194 <sys_exit+0x2a>
  exit(n);
    80002186:	fec42503          	lw	a0,-20(s0)
    8000218a:	fffff097          	auipc	ra,0xfffff
    8000218e:	5fe080e7          	jalr	1534(ra) # 80001788 <exit>
  return 0;  // not reached
    80002192:	4781                	li	a5,0
}
    80002194:	853e                	mv	a0,a5
    80002196:	60e2                	ld	ra,24(sp)
    80002198:	6442                	ld	s0,16(sp)
    8000219a:	6105                	addi	sp,sp,32
    8000219c:	8082                	ret

000000008000219e <sys_getpid>:

uint64
sys_getpid(void)
{
    8000219e:	1141                	addi	sp,sp,-16
    800021a0:	e406                	sd	ra,8(sp)
    800021a2:	e022                	sd	s0,0(sp)
    800021a4:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800021a6:	fffff097          	auipc	ra,0xfffff
    800021aa:	c84080e7          	jalr	-892(ra) # 80000e2a <myproc>
}
    800021ae:	5908                	lw	a0,48(a0)
    800021b0:	60a2                	ld	ra,8(sp)
    800021b2:	6402                	ld	s0,0(sp)
    800021b4:	0141                	addi	sp,sp,16
    800021b6:	8082                	ret

00000000800021b8 <sys_fork>:

uint64
sys_fork(void)
{
    800021b8:	1141                	addi	sp,sp,-16
    800021ba:	e406                	sd	ra,8(sp)
    800021bc:	e022                	sd	s0,0(sp)
    800021be:	0800                	addi	s0,sp,16
  return fork();
    800021c0:	fffff097          	auipc	ra,0xfffff
    800021c4:	03c080e7          	jalr	60(ra) # 800011fc <fork>
}
    800021c8:	60a2                	ld	ra,8(sp)
    800021ca:	6402                	ld	s0,0(sp)
    800021cc:	0141                	addi	sp,sp,16
    800021ce:	8082                	ret

00000000800021d0 <sys_wait>:

uint64
sys_wait(void)
{
    800021d0:	1101                	addi	sp,sp,-32
    800021d2:	ec06                	sd	ra,24(sp)
    800021d4:	e822                	sd	s0,16(sp)
    800021d6:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    800021d8:	fe840593          	addi	a1,s0,-24
    800021dc:	4501                	li	a0,0
    800021de:	00000097          	auipc	ra,0x0
    800021e2:	ece080e7          	jalr	-306(ra) # 800020ac <argaddr>
    800021e6:	87aa                	mv	a5,a0
    return -1;
    800021e8:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    800021ea:	0007c863          	bltz	a5,800021fa <sys_wait+0x2a>
  return wait(p);
    800021ee:	fe843503          	ld	a0,-24(s0)
    800021f2:	fffff097          	auipc	ra,0xfffff
    800021f6:	39e080e7          	jalr	926(ra) # 80001590 <wait>
}
    800021fa:	60e2                	ld	ra,24(sp)
    800021fc:	6442                	ld	s0,16(sp)
    800021fe:	6105                	addi	sp,sp,32
    80002200:	8082                	ret

0000000080002202 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002202:	7179                	addi	sp,sp,-48
    80002204:	f406                	sd	ra,40(sp)
    80002206:	f022                	sd	s0,32(sp)
    80002208:	ec26                	sd	s1,24(sp)
    8000220a:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    8000220c:	fdc40593          	addi	a1,s0,-36
    80002210:	4501                	li	a0,0
    80002212:	00000097          	auipc	ra,0x0
    80002216:	e78080e7          	jalr	-392(ra) # 8000208a <argint>
    8000221a:	87aa                	mv	a5,a0
    return -1;
    8000221c:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    8000221e:	0207c063          	bltz	a5,8000223e <sys_sbrk+0x3c>
  addr = myproc()->sz;
    80002222:	fffff097          	auipc	ra,0xfffff
    80002226:	c08080e7          	jalr	-1016(ra) # 80000e2a <myproc>
    8000222a:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    8000222c:	fdc42503          	lw	a0,-36(s0)
    80002230:	fffff097          	auipc	ra,0xfffff
    80002234:	f54080e7          	jalr	-172(ra) # 80001184 <growproc>
    80002238:	00054863          	bltz	a0,80002248 <sys_sbrk+0x46>
    return -1;
  return addr;
    8000223c:	8526                	mv	a0,s1
}
    8000223e:	70a2                	ld	ra,40(sp)
    80002240:	7402                	ld	s0,32(sp)
    80002242:	64e2                	ld	s1,24(sp)
    80002244:	6145                	addi	sp,sp,48
    80002246:	8082                	ret
    return -1;
    80002248:	557d                	li	a0,-1
    8000224a:	bfd5                	j	8000223e <sys_sbrk+0x3c>

000000008000224c <sys_sleep>:

uint64
sys_sleep(void)
{
    8000224c:	7139                	addi	sp,sp,-64
    8000224e:	fc06                	sd	ra,56(sp)
    80002250:	f822                	sd	s0,48(sp)
    80002252:	f426                	sd	s1,40(sp)
    80002254:	f04a                	sd	s2,32(sp)
    80002256:	ec4e                	sd	s3,24(sp)
    80002258:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    8000225a:	fcc40593          	addi	a1,s0,-52
    8000225e:	4501                	li	a0,0
    80002260:	00000097          	auipc	ra,0x0
    80002264:	e2a080e7          	jalr	-470(ra) # 8000208a <argint>
    return -1;
    80002268:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    8000226a:	06054563          	bltz	a0,800022d4 <sys_sleep+0x88>
  acquire(&tickslock);
    8000226e:	00019517          	auipc	a0,0x19
    80002272:	c1250513          	addi	a0,a0,-1006 # 8001ae80 <tickslock>
    80002276:	00004097          	auipc	ra,0x4
    8000227a:	2d2080e7          	jalr	722(ra) # 80006548 <acquire>
  ticks0 = ticks;
    8000227e:	00007917          	auipc	s2,0x7
    80002282:	d9a92903          	lw	s2,-614(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    80002286:	fcc42783          	lw	a5,-52(s0)
    8000228a:	cf85                	beqz	a5,800022c2 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000228c:	00019997          	auipc	s3,0x19
    80002290:	bf498993          	addi	s3,s3,-1036 # 8001ae80 <tickslock>
    80002294:	00007497          	auipc	s1,0x7
    80002298:	d8448493          	addi	s1,s1,-636 # 80009018 <ticks>
    if(myproc()->killed){
    8000229c:	fffff097          	auipc	ra,0xfffff
    800022a0:	b8e080e7          	jalr	-1138(ra) # 80000e2a <myproc>
    800022a4:	551c                	lw	a5,40(a0)
    800022a6:	ef9d                	bnez	a5,800022e4 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800022a8:	85ce                	mv	a1,s3
    800022aa:	8526                	mv	a0,s1
    800022ac:	fffff097          	auipc	ra,0xfffff
    800022b0:	280080e7          	jalr	640(ra) # 8000152c <sleep>
  while(ticks - ticks0 < n){
    800022b4:	409c                	lw	a5,0(s1)
    800022b6:	412787bb          	subw	a5,a5,s2
    800022ba:	fcc42703          	lw	a4,-52(s0)
    800022be:	fce7efe3          	bltu	a5,a4,8000229c <sys_sleep+0x50>
  }
  release(&tickslock);
    800022c2:	00019517          	auipc	a0,0x19
    800022c6:	bbe50513          	addi	a0,a0,-1090 # 8001ae80 <tickslock>
    800022ca:	00004097          	auipc	ra,0x4
    800022ce:	332080e7          	jalr	818(ra) # 800065fc <release>
  return 0;
    800022d2:	4781                	li	a5,0
}
    800022d4:	853e                	mv	a0,a5
    800022d6:	70e2                	ld	ra,56(sp)
    800022d8:	7442                	ld	s0,48(sp)
    800022da:	74a2                	ld	s1,40(sp)
    800022dc:	7902                	ld	s2,32(sp)
    800022de:	69e2                	ld	s3,24(sp)
    800022e0:	6121                	addi	sp,sp,64
    800022e2:	8082                	ret
      release(&tickslock);
    800022e4:	00019517          	auipc	a0,0x19
    800022e8:	b9c50513          	addi	a0,a0,-1124 # 8001ae80 <tickslock>
    800022ec:	00004097          	auipc	ra,0x4
    800022f0:	310080e7          	jalr	784(ra) # 800065fc <release>
      return -1;
    800022f4:	57fd                	li	a5,-1
    800022f6:	bff9                	j	800022d4 <sys_sleep+0x88>

00000000800022f8 <sys_kill>:

uint64
sys_kill(void)
{
    800022f8:	1101                	addi	sp,sp,-32
    800022fa:	ec06                	sd	ra,24(sp)
    800022fc:	e822                	sd	s0,16(sp)
    800022fe:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002300:	fec40593          	addi	a1,s0,-20
    80002304:	4501                	li	a0,0
    80002306:	00000097          	auipc	ra,0x0
    8000230a:	d84080e7          	jalr	-636(ra) # 8000208a <argint>
    8000230e:	87aa                	mv	a5,a0
    return -1;
    80002310:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002312:	0007c863          	bltz	a5,80002322 <sys_kill+0x2a>
  return kill(pid);
    80002316:	fec42503          	lw	a0,-20(s0)
    8000231a:	fffff097          	auipc	ra,0xfffff
    8000231e:	580080e7          	jalr	1408(ra) # 8000189a <kill>
}
    80002322:	60e2                	ld	ra,24(sp)
    80002324:	6442                	ld	s0,16(sp)
    80002326:	6105                	addi	sp,sp,32
    80002328:	8082                	ret

000000008000232a <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000232a:	1101                	addi	sp,sp,-32
    8000232c:	ec06                	sd	ra,24(sp)
    8000232e:	e822                	sd	s0,16(sp)
    80002330:	e426                	sd	s1,8(sp)
    80002332:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002334:	00019517          	auipc	a0,0x19
    80002338:	b4c50513          	addi	a0,a0,-1204 # 8001ae80 <tickslock>
    8000233c:	00004097          	auipc	ra,0x4
    80002340:	20c080e7          	jalr	524(ra) # 80006548 <acquire>
  xticks = ticks;
    80002344:	00007497          	auipc	s1,0x7
    80002348:	cd44a483          	lw	s1,-812(s1) # 80009018 <ticks>
  release(&tickslock);
    8000234c:	00019517          	auipc	a0,0x19
    80002350:	b3450513          	addi	a0,a0,-1228 # 8001ae80 <tickslock>
    80002354:	00004097          	auipc	ra,0x4
    80002358:	2a8080e7          	jalr	680(ra) # 800065fc <release>
  return xticks;
}
    8000235c:	02049513          	slli	a0,s1,0x20
    80002360:	9101                	srli	a0,a0,0x20
    80002362:	60e2                	ld	ra,24(sp)
    80002364:	6442                	ld	s0,16(sp)
    80002366:	64a2                	ld	s1,8(sp)
    80002368:	6105                	addi	sp,sp,32
    8000236a:	8082                	ret

000000008000236c <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000236c:	7179                	addi	sp,sp,-48
    8000236e:	f406                	sd	ra,40(sp)
    80002370:	f022                	sd	s0,32(sp)
    80002372:	ec26                	sd	s1,24(sp)
    80002374:	e84a                	sd	s2,16(sp)
    80002376:	e44e                	sd	s3,8(sp)
    80002378:	e052                	sd	s4,0(sp)
    8000237a:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000237c:	00006597          	auipc	a1,0x6
    80002380:	0d458593          	addi	a1,a1,212 # 80008450 <syscalls+0xc0>
    80002384:	00019517          	auipc	a0,0x19
    80002388:	b1450513          	addi	a0,a0,-1260 # 8001ae98 <bcache>
    8000238c:	00004097          	auipc	ra,0x4
    80002390:	12c080e7          	jalr	300(ra) # 800064b8 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002394:	00021797          	auipc	a5,0x21
    80002398:	b0478793          	addi	a5,a5,-1276 # 80022e98 <bcache+0x8000>
    8000239c:	00021717          	auipc	a4,0x21
    800023a0:	d6470713          	addi	a4,a4,-668 # 80023100 <bcache+0x8268>
    800023a4:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800023a8:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023ac:	00019497          	auipc	s1,0x19
    800023b0:	b0448493          	addi	s1,s1,-1276 # 8001aeb0 <bcache+0x18>
    b->next = bcache.head.next;
    800023b4:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800023b6:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800023b8:	00006a17          	auipc	s4,0x6
    800023bc:	0a0a0a13          	addi	s4,s4,160 # 80008458 <syscalls+0xc8>
    b->next = bcache.head.next;
    800023c0:	2b893783          	ld	a5,696(s2)
    800023c4:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800023c6:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800023ca:	85d2                	mv	a1,s4
    800023cc:	01048513          	addi	a0,s1,16
    800023d0:	00001097          	auipc	ra,0x1
    800023d4:	4c2080e7          	jalr	1218(ra) # 80003892 <initsleeplock>
    bcache.head.next->prev = b;
    800023d8:	2b893783          	ld	a5,696(s2)
    800023dc:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800023de:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023e2:	45848493          	addi	s1,s1,1112
    800023e6:	fd349de3          	bne	s1,s3,800023c0 <binit+0x54>
  }
}
    800023ea:	70a2                	ld	ra,40(sp)
    800023ec:	7402                	ld	s0,32(sp)
    800023ee:	64e2                	ld	s1,24(sp)
    800023f0:	6942                	ld	s2,16(sp)
    800023f2:	69a2                	ld	s3,8(sp)
    800023f4:	6a02                	ld	s4,0(sp)
    800023f6:	6145                	addi	sp,sp,48
    800023f8:	8082                	ret

00000000800023fa <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800023fa:	7179                	addi	sp,sp,-48
    800023fc:	f406                	sd	ra,40(sp)
    800023fe:	f022                	sd	s0,32(sp)
    80002400:	ec26                	sd	s1,24(sp)
    80002402:	e84a                	sd	s2,16(sp)
    80002404:	e44e                	sd	s3,8(sp)
    80002406:	1800                	addi	s0,sp,48
    80002408:	892a                	mv	s2,a0
    8000240a:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000240c:	00019517          	auipc	a0,0x19
    80002410:	a8c50513          	addi	a0,a0,-1396 # 8001ae98 <bcache>
    80002414:	00004097          	auipc	ra,0x4
    80002418:	134080e7          	jalr	308(ra) # 80006548 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000241c:	00021497          	auipc	s1,0x21
    80002420:	d344b483          	ld	s1,-716(s1) # 80023150 <bcache+0x82b8>
    80002424:	00021797          	auipc	a5,0x21
    80002428:	cdc78793          	addi	a5,a5,-804 # 80023100 <bcache+0x8268>
    8000242c:	02f48f63          	beq	s1,a5,8000246a <bread+0x70>
    80002430:	873e                	mv	a4,a5
    80002432:	a021                	j	8000243a <bread+0x40>
    80002434:	68a4                	ld	s1,80(s1)
    80002436:	02e48a63          	beq	s1,a4,8000246a <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000243a:	449c                	lw	a5,8(s1)
    8000243c:	ff279ce3          	bne	a5,s2,80002434 <bread+0x3a>
    80002440:	44dc                	lw	a5,12(s1)
    80002442:	ff3799e3          	bne	a5,s3,80002434 <bread+0x3a>
      b->refcnt++;
    80002446:	40bc                	lw	a5,64(s1)
    80002448:	2785                	addiw	a5,a5,1
    8000244a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000244c:	00019517          	auipc	a0,0x19
    80002450:	a4c50513          	addi	a0,a0,-1460 # 8001ae98 <bcache>
    80002454:	00004097          	auipc	ra,0x4
    80002458:	1a8080e7          	jalr	424(ra) # 800065fc <release>
      acquiresleep(&b->lock);
    8000245c:	01048513          	addi	a0,s1,16
    80002460:	00001097          	auipc	ra,0x1
    80002464:	46c080e7          	jalr	1132(ra) # 800038cc <acquiresleep>
      return b;
    80002468:	a8b9                	j	800024c6 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000246a:	00021497          	auipc	s1,0x21
    8000246e:	cde4b483          	ld	s1,-802(s1) # 80023148 <bcache+0x82b0>
    80002472:	00021797          	auipc	a5,0x21
    80002476:	c8e78793          	addi	a5,a5,-882 # 80023100 <bcache+0x8268>
    8000247a:	00f48863          	beq	s1,a5,8000248a <bread+0x90>
    8000247e:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002480:	40bc                	lw	a5,64(s1)
    80002482:	cf81                	beqz	a5,8000249a <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002484:	64a4                	ld	s1,72(s1)
    80002486:	fee49de3          	bne	s1,a4,80002480 <bread+0x86>
  panic("bget: no buffers");
    8000248a:	00006517          	auipc	a0,0x6
    8000248e:	fd650513          	addi	a0,a0,-42 # 80008460 <syscalls+0xd0>
    80002492:	00004097          	auipc	ra,0x4
    80002496:	b7e080e7          	jalr	-1154(ra) # 80006010 <panic>
      b->dev = dev;
    8000249a:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000249e:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800024a2:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800024a6:	4785                	li	a5,1
    800024a8:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800024aa:	00019517          	auipc	a0,0x19
    800024ae:	9ee50513          	addi	a0,a0,-1554 # 8001ae98 <bcache>
    800024b2:	00004097          	auipc	ra,0x4
    800024b6:	14a080e7          	jalr	330(ra) # 800065fc <release>
      acquiresleep(&b->lock);
    800024ba:	01048513          	addi	a0,s1,16
    800024be:	00001097          	auipc	ra,0x1
    800024c2:	40e080e7          	jalr	1038(ra) # 800038cc <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800024c6:	409c                	lw	a5,0(s1)
    800024c8:	cb89                	beqz	a5,800024da <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800024ca:	8526                	mv	a0,s1
    800024cc:	70a2                	ld	ra,40(sp)
    800024ce:	7402                	ld	s0,32(sp)
    800024d0:	64e2                	ld	s1,24(sp)
    800024d2:	6942                	ld	s2,16(sp)
    800024d4:	69a2                	ld	s3,8(sp)
    800024d6:	6145                	addi	sp,sp,48
    800024d8:	8082                	ret
    virtio_disk_rw(b, 0);
    800024da:	4581                	li	a1,0
    800024dc:	8526                	mv	a0,s1
    800024de:	00003097          	auipc	ra,0x3
    800024e2:	2c4080e7          	jalr	708(ra) # 800057a2 <virtio_disk_rw>
    b->valid = 1;
    800024e6:	4785                	li	a5,1
    800024e8:	c09c                	sw	a5,0(s1)
  return b;
    800024ea:	b7c5                	j	800024ca <bread+0xd0>

00000000800024ec <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800024ec:	1101                	addi	sp,sp,-32
    800024ee:	ec06                	sd	ra,24(sp)
    800024f0:	e822                	sd	s0,16(sp)
    800024f2:	e426                	sd	s1,8(sp)
    800024f4:	1000                	addi	s0,sp,32
    800024f6:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024f8:	0541                	addi	a0,a0,16
    800024fa:	00001097          	auipc	ra,0x1
    800024fe:	46c080e7          	jalr	1132(ra) # 80003966 <holdingsleep>
    80002502:	cd01                	beqz	a0,8000251a <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002504:	4585                	li	a1,1
    80002506:	8526                	mv	a0,s1
    80002508:	00003097          	auipc	ra,0x3
    8000250c:	29a080e7          	jalr	666(ra) # 800057a2 <virtio_disk_rw>
}
    80002510:	60e2                	ld	ra,24(sp)
    80002512:	6442                	ld	s0,16(sp)
    80002514:	64a2                	ld	s1,8(sp)
    80002516:	6105                	addi	sp,sp,32
    80002518:	8082                	ret
    panic("bwrite");
    8000251a:	00006517          	auipc	a0,0x6
    8000251e:	f5e50513          	addi	a0,a0,-162 # 80008478 <syscalls+0xe8>
    80002522:	00004097          	auipc	ra,0x4
    80002526:	aee080e7          	jalr	-1298(ra) # 80006010 <panic>

000000008000252a <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000252a:	1101                	addi	sp,sp,-32
    8000252c:	ec06                	sd	ra,24(sp)
    8000252e:	e822                	sd	s0,16(sp)
    80002530:	e426                	sd	s1,8(sp)
    80002532:	e04a                	sd	s2,0(sp)
    80002534:	1000                	addi	s0,sp,32
    80002536:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002538:	01050913          	addi	s2,a0,16
    8000253c:	854a                	mv	a0,s2
    8000253e:	00001097          	auipc	ra,0x1
    80002542:	428080e7          	jalr	1064(ra) # 80003966 <holdingsleep>
    80002546:	c92d                	beqz	a0,800025b8 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002548:	854a                	mv	a0,s2
    8000254a:	00001097          	auipc	ra,0x1
    8000254e:	3d8080e7          	jalr	984(ra) # 80003922 <releasesleep>

  acquire(&bcache.lock);
    80002552:	00019517          	auipc	a0,0x19
    80002556:	94650513          	addi	a0,a0,-1722 # 8001ae98 <bcache>
    8000255a:	00004097          	auipc	ra,0x4
    8000255e:	fee080e7          	jalr	-18(ra) # 80006548 <acquire>
  b->refcnt--;
    80002562:	40bc                	lw	a5,64(s1)
    80002564:	37fd                	addiw	a5,a5,-1
    80002566:	0007871b          	sext.w	a4,a5
    8000256a:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000256c:	eb05                	bnez	a4,8000259c <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000256e:	68bc                	ld	a5,80(s1)
    80002570:	64b8                	ld	a4,72(s1)
    80002572:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002574:	64bc                	ld	a5,72(s1)
    80002576:	68b8                	ld	a4,80(s1)
    80002578:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000257a:	00021797          	auipc	a5,0x21
    8000257e:	91e78793          	addi	a5,a5,-1762 # 80022e98 <bcache+0x8000>
    80002582:	2b87b703          	ld	a4,696(a5)
    80002586:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002588:	00021717          	auipc	a4,0x21
    8000258c:	b7870713          	addi	a4,a4,-1160 # 80023100 <bcache+0x8268>
    80002590:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002592:	2b87b703          	ld	a4,696(a5)
    80002596:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002598:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000259c:	00019517          	auipc	a0,0x19
    800025a0:	8fc50513          	addi	a0,a0,-1796 # 8001ae98 <bcache>
    800025a4:	00004097          	auipc	ra,0x4
    800025a8:	058080e7          	jalr	88(ra) # 800065fc <release>
}
    800025ac:	60e2                	ld	ra,24(sp)
    800025ae:	6442                	ld	s0,16(sp)
    800025b0:	64a2                	ld	s1,8(sp)
    800025b2:	6902                	ld	s2,0(sp)
    800025b4:	6105                	addi	sp,sp,32
    800025b6:	8082                	ret
    panic("brelse");
    800025b8:	00006517          	auipc	a0,0x6
    800025bc:	ec850513          	addi	a0,a0,-312 # 80008480 <syscalls+0xf0>
    800025c0:	00004097          	auipc	ra,0x4
    800025c4:	a50080e7          	jalr	-1456(ra) # 80006010 <panic>

00000000800025c8 <bpin>:

void
bpin(struct buf *b) {
    800025c8:	1101                	addi	sp,sp,-32
    800025ca:	ec06                	sd	ra,24(sp)
    800025cc:	e822                	sd	s0,16(sp)
    800025ce:	e426                	sd	s1,8(sp)
    800025d0:	1000                	addi	s0,sp,32
    800025d2:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025d4:	00019517          	auipc	a0,0x19
    800025d8:	8c450513          	addi	a0,a0,-1852 # 8001ae98 <bcache>
    800025dc:	00004097          	auipc	ra,0x4
    800025e0:	f6c080e7          	jalr	-148(ra) # 80006548 <acquire>
  b->refcnt++;
    800025e4:	40bc                	lw	a5,64(s1)
    800025e6:	2785                	addiw	a5,a5,1
    800025e8:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025ea:	00019517          	auipc	a0,0x19
    800025ee:	8ae50513          	addi	a0,a0,-1874 # 8001ae98 <bcache>
    800025f2:	00004097          	auipc	ra,0x4
    800025f6:	00a080e7          	jalr	10(ra) # 800065fc <release>
}
    800025fa:	60e2                	ld	ra,24(sp)
    800025fc:	6442                	ld	s0,16(sp)
    800025fe:	64a2                	ld	s1,8(sp)
    80002600:	6105                	addi	sp,sp,32
    80002602:	8082                	ret

0000000080002604 <bunpin>:

void
bunpin(struct buf *b) {
    80002604:	1101                	addi	sp,sp,-32
    80002606:	ec06                	sd	ra,24(sp)
    80002608:	e822                	sd	s0,16(sp)
    8000260a:	e426                	sd	s1,8(sp)
    8000260c:	1000                	addi	s0,sp,32
    8000260e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002610:	00019517          	auipc	a0,0x19
    80002614:	88850513          	addi	a0,a0,-1912 # 8001ae98 <bcache>
    80002618:	00004097          	auipc	ra,0x4
    8000261c:	f30080e7          	jalr	-208(ra) # 80006548 <acquire>
  b->refcnt--;
    80002620:	40bc                	lw	a5,64(s1)
    80002622:	37fd                	addiw	a5,a5,-1
    80002624:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002626:	00019517          	auipc	a0,0x19
    8000262a:	87250513          	addi	a0,a0,-1934 # 8001ae98 <bcache>
    8000262e:	00004097          	auipc	ra,0x4
    80002632:	fce080e7          	jalr	-50(ra) # 800065fc <release>
}
    80002636:	60e2                	ld	ra,24(sp)
    80002638:	6442                	ld	s0,16(sp)
    8000263a:	64a2                	ld	s1,8(sp)
    8000263c:	6105                	addi	sp,sp,32
    8000263e:	8082                	ret

0000000080002640 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002640:	1101                	addi	sp,sp,-32
    80002642:	ec06                	sd	ra,24(sp)
    80002644:	e822                	sd	s0,16(sp)
    80002646:	e426                	sd	s1,8(sp)
    80002648:	e04a                	sd	s2,0(sp)
    8000264a:	1000                	addi	s0,sp,32
    8000264c:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000264e:	00d5d59b          	srliw	a1,a1,0xd
    80002652:	00021797          	auipc	a5,0x21
    80002656:	f227a783          	lw	a5,-222(a5) # 80023574 <sb+0x1c>
    8000265a:	9dbd                	addw	a1,a1,a5
    8000265c:	00000097          	auipc	ra,0x0
    80002660:	d9e080e7          	jalr	-610(ra) # 800023fa <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002664:	0074f713          	andi	a4,s1,7
    80002668:	4785                	li	a5,1
    8000266a:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000266e:	14ce                	slli	s1,s1,0x33
    80002670:	90d9                	srli	s1,s1,0x36
    80002672:	00950733          	add	a4,a0,s1
    80002676:	05874703          	lbu	a4,88(a4)
    8000267a:	00e7f6b3          	and	a3,a5,a4
    8000267e:	c69d                	beqz	a3,800026ac <bfree+0x6c>
    80002680:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002682:	94aa                	add	s1,s1,a0
    80002684:	fff7c793          	not	a5,a5
    80002688:	8f7d                	and	a4,a4,a5
    8000268a:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000268e:	00001097          	auipc	ra,0x1
    80002692:	120080e7          	jalr	288(ra) # 800037ae <log_write>
  brelse(bp);
    80002696:	854a                	mv	a0,s2
    80002698:	00000097          	auipc	ra,0x0
    8000269c:	e92080e7          	jalr	-366(ra) # 8000252a <brelse>
}
    800026a0:	60e2                	ld	ra,24(sp)
    800026a2:	6442                	ld	s0,16(sp)
    800026a4:	64a2                	ld	s1,8(sp)
    800026a6:	6902                	ld	s2,0(sp)
    800026a8:	6105                	addi	sp,sp,32
    800026aa:	8082                	ret
    panic("freeing free block");
    800026ac:	00006517          	auipc	a0,0x6
    800026b0:	ddc50513          	addi	a0,a0,-548 # 80008488 <syscalls+0xf8>
    800026b4:	00004097          	auipc	ra,0x4
    800026b8:	95c080e7          	jalr	-1700(ra) # 80006010 <panic>

00000000800026bc <balloc>:
{
    800026bc:	711d                	addi	sp,sp,-96
    800026be:	ec86                	sd	ra,88(sp)
    800026c0:	e8a2                	sd	s0,80(sp)
    800026c2:	e4a6                	sd	s1,72(sp)
    800026c4:	e0ca                	sd	s2,64(sp)
    800026c6:	fc4e                	sd	s3,56(sp)
    800026c8:	f852                	sd	s4,48(sp)
    800026ca:	f456                	sd	s5,40(sp)
    800026cc:	f05a                	sd	s6,32(sp)
    800026ce:	ec5e                	sd	s7,24(sp)
    800026d0:	e862                	sd	s8,16(sp)
    800026d2:	e466                	sd	s9,8(sp)
    800026d4:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800026d6:	00021797          	auipc	a5,0x21
    800026da:	e867a783          	lw	a5,-378(a5) # 8002355c <sb+0x4>
    800026de:	cbc1                	beqz	a5,8000276e <balloc+0xb2>
    800026e0:	8baa                	mv	s7,a0
    800026e2:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800026e4:	00021b17          	auipc	s6,0x21
    800026e8:	e74b0b13          	addi	s6,s6,-396 # 80023558 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026ec:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800026ee:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026f0:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800026f2:	6c89                	lui	s9,0x2
    800026f4:	a831                	j	80002710 <balloc+0x54>
    brelse(bp);
    800026f6:	854a                	mv	a0,s2
    800026f8:	00000097          	auipc	ra,0x0
    800026fc:	e32080e7          	jalr	-462(ra) # 8000252a <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002700:	015c87bb          	addw	a5,s9,s5
    80002704:	00078a9b          	sext.w	s5,a5
    80002708:	004b2703          	lw	a4,4(s6)
    8000270c:	06eaf163          	bgeu	s5,a4,8000276e <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    80002710:	41fad79b          	sraiw	a5,s5,0x1f
    80002714:	0137d79b          	srliw	a5,a5,0x13
    80002718:	015787bb          	addw	a5,a5,s5
    8000271c:	40d7d79b          	sraiw	a5,a5,0xd
    80002720:	01cb2583          	lw	a1,28(s6)
    80002724:	9dbd                	addw	a1,a1,a5
    80002726:	855e                	mv	a0,s7
    80002728:	00000097          	auipc	ra,0x0
    8000272c:	cd2080e7          	jalr	-814(ra) # 800023fa <bread>
    80002730:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002732:	004b2503          	lw	a0,4(s6)
    80002736:	000a849b          	sext.w	s1,s5
    8000273a:	8762                	mv	a4,s8
    8000273c:	faa4fde3          	bgeu	s1,a0,800026f6 <balloc+0x3a>
      m = 1 << (bi % 8);
    80002740:	00777693          	andi	a3,a4,7
    80002744:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002748:	41f7579b          	sraiw	a5,a4,0x1f
    8000274c:	01d7d79b          	srliw	a5,a5,0x1d
    80002750:	9fb9                	addw	a5,a5,a4
    80002752:	4037d79b          	sraiw	a5,a5,0x3
    80002756:	00f90633          	add	a2,s2,a5
    8000275a:	05864603          	lbu	a2,88(a2) # 1058 <_entry-0x7fffefa8>
    8000275e:	00c6f5b3          	and	a1,a3,a2
    80002762:	cd91                	beqz	a1,8000277e <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002764:	2705                	addiw	a4,a4,1
    80002766:	2485                	addiw	s1,s1,1
    80002768:	fd471ae3          	bne	a4,s4,8000273c <balloc+0x80>
    8000276c:	b769                	j	800026f6 <balloc+0x3a>
  panic("balloc: out of blocks");
    8000276e:	00006517          	auipc	a0,0x6
    80002772:	d3250513          	addi	a0,a0,-718 # 800084a0 <syscalls+0x110>
    80002776:	00004097          	auipc	ra,0x4
    8000277a:	89a080e7          	jalr	-1894(ra) # 80006010 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000277e:	97ca                	add	a5,a5,s2
    80002780:	8e55                	or	a2,a2,a3
    80002782:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002786:	854a                	mv	a0,s2
    80002788:	00001097          	auipc	ra,0x1
    8000278c:	026080e7          	jalr	38(ra) # 800037ae <log_write>
        brelse(bp);
    80002790:	854a                	mv	a0,s2
    80002792:	00000097          	auipc	ra,0x0
    80002796:	d98080e7          	jalr	-616(ra) # 8000252a <brelse>
  bp = bread(dev, bno);
    8000279a:	85a6                	mv	a1,s1
    8000279c:	855e                	mv	a0,s7
    8000279e:	00000097          	auipc	ra,0x0
    800027a2:	c5c080e7          	jalr	-932(ra) # 800023fa <bread>
    800027a6:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800027a8:	40000613          	li	a2,1024
    800027ac:	4581                	li	a1,0
    800027ae:	05850513          	addi	a0,a0,88
    800027b2:	ffffe097          	auipc	ra,0xffffe
    800027b6:	9c8080e7          	jalr	-1592(ra) # 8000017a <memset>
  log_write(bp);
    800027ba:	854a                	mv	a0,s2
    800027bc:	00001097          	auipc	ra,0x1
    800027c0:	ff2080e7          	jalr	-14(ra) # 800037ae <log_write>
  brelse(bp);
    800027c4:	854a                	mv	a0,s2
    800027c6:	00000097          	auipc	ra,0x0
    800027ca:	d64080e7          	jalr	-668(ra) # 8000252a <brelse>
}
    800027ce:	8526                	mv	a0,s1
    800027d0:	60e6                	ld	ra,88(sp)
    800027d2:	6446                	ld	s0,80(sp)
    800027d4:	64a6                	ld	s1,72(sp)
    800027d6:	6906                	ld	s2,64(sp)
    800027d8:	79e2                	ld	s3,56(sp)
    800027da:	7a42                	ld	s4,48(sp)
    800027dc:	7aa2                	ld	s5,40(sp)
    800027de:	7b02                	ld	s6,32(sp)
    800027e0:	6be2                	ld	s7,24(sp)
    800027e2:	6c42                	ld	s8,16(sp)
    800027e4:	6ca2                	ld	s9,8(sp)
    800027e6:	6125                	addi	sp,sp,96
    800027e8:	8082                	ret

00000000800027ea <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800027ea:	7179                	addi	sp,sp,-48
    800027ec:	f406                	sd	ra,40(sp)
    800027ee:	f022                	sd	s0,32(sp)
    800027f0:	ec26                	sd	s1,24(sp)
    800027f2:	e84a                	sd	s2,16(sp)
    800027f4:	e44e                	sd	s3,8(sp)
    800027f6:	e052                	sd	s4,0(sp)
    800027f8:	1800                	addi	s0,sp,48
    800027fa:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800027fc:	47ad                	li	a5,11
    800027fe:	04b7fe63          	bgeu	a5,a1,8000285a <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80002802:	ff45849b          	addiw	s1,a1,-12
    80002806:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000280a:	0ff00793          	li	a5,255
    8000280e:	0ae7e463          	bltu	a5,a4,800028b6 <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002812:	08052583          	lw	a1,128(a0)
    80002816:	c5b5                	beqz	a1,80002882 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002818:	00092503          	lw	a0,0(s2)
    8000281c:	00000097          	auipc	ra,0x0
    80002820:	bde080e7          	jalr	-1058(ra) # 800023fa <bread>
    80002824:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002826:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000282a:	02049713          	slli	a4,s1,0x20
    8000282e:	01e75593          	srli	a1,a4,0x1e
    80002832:	00b784b3          	add	s1,a5,a1
    80002836:	0004a983          	lw	s3,0(s1)
    8000283a:	04098e63          	beqz	s3,80002896 <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    8000283e:	8552                	mv	a0,s4
    80002840:	00000097          	auipc	ra,0x0
    80002844:	cea080e7          	jalr	-790(ra) # 8000252a <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002848:	854e                	mv	a0,s3
    8000284a:	70a2                	ld	ra,40(sp)
    8000284c:	7402                	ld	s0,32(sp)
    8000284e:	64e2                	ld	s1,24(sp)
    80002850:	6942                	ld	s2,16(sp)
    80002852:	69a2                	ld	s3,8(sp)
    80002854:	6a02                	ld	s4,0(sp)
    80002856:	6145                	addi	sp,sp,48
    80002858:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    8000285a:	02059793          	slli	a5,a1,0x20
    8000285e:	01e7d593          	srli	a1,a5,0x1e
    80002862:	00b504b3          	add	s1,a0,a1
    80002866:	0504a983          	lw	s3,80(s1)
    8000286a:	fc099fe3          	bnez	s3,80002848 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    8000286e:	4108                	lw	a0,0(a0)
    80002870:	00000097          	auipc	ra,0x0
    80002874:	e4c080e7          	jalr	-436(ra) # 800026bc <balloc>
    80002878:	0005099b          	sext.w	s3,a0
    8000287c:	0534a823          	sw	s3,80(s1)
    80002880:	b7e1                	j	80002848 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002882:	4108                	lw	a0,0(a0)
    80002884:	00000097          	auipc	ra,0x0
    80002888:	e38080e7          	jalr	-456(ra) # 800026bc <balloc>
    8000288c:	0005059b          	sext.w	a1,a0
    80002890:	08b92023          	sw	a1,128(s2)
    80002894:	b751                	j	80002818 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002896:	00092503          	lw	a0,0(s2)
    8000289a:	00000097          	auipc	ra,0x0
    8000289e:	e22080e7          	jalr	-478(ra) # 800026bc <balloc>
    800028a2:	0005099b          	sext.w	s3,a0
    800028a6:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800028aa:	8552                	mv	a0,s4
    800028ac:	00001097          	auipc	ra,0x1
    800028b0:	f02080e7          	jalr	-254(ra) # 800037ae <log_write>
    800028b4:	b769                	j	8000283e <bmap+0x54>
  panic("bmap: out of range");
    800028b6:	00006517          	auipc	a0,0x6
    800028ba:	c0250513          	addi	a0,a0,-1022 # 800084b8 <syscalls+0x128>
    800028be:	00003097          	auipc	ra,0x3
    800028c2:	752080e7          	jalr	1874(ra) # 80006010 <panic>

00000000800028c6 <iget>:
{
    800028c6:	7179                	addi	sp,sp,-48
    800028c8:	f406                	sd	ra,40(sp)
    800028ca:	f022                	sd	s0,32(sp)
    800028cc:	ec26                	sd	s1,24(sp)
    800028ce:	e84a                	sd	s2,16(sp)
    800028d0:	e44e                	sd	s3,8(sp)
    800028d2:	e052                	sd	s4,0(sp)
    800028d4:	1800                	addi	s0,sp,48
    800028d6:	89aa                	mv	s3,a0
    800028d8:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800028da:	00021517          	auipc	a0,0x21
    800028de:	c9e50513          	addi	a0,a0,-866 # 80023578 <itable>
    800028e2:	00004097          	auipc	ra,0x4
    800028e6:	c66080e7          	jalr	-922(ra) # 80006548 <acquire>
  empty = 0;
    800028ea:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028ec:	00021497          	auipc	s1,0x21
    800028f0:	ca448493          	addi	s1,s1,-860 # 80023590 <itable+0x18>
    800028f4:	00022697          	auipc	a3,0x22
    800028f8:	72c68693          	addi	a3,a3,1836 # 80025020 <log>
    800028fc:	a039                	j	8000290a <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028fe:	02090b63          	beqz	s2,80002934 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002902:	08848493          	addi	s1,s1,136
    80002906:	02d48a63          	beq	s1,a3,8000293a <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000290a:	449c                	lw	a5,8(s1)
    8000290c:	fef059e3          	blez	a5,800028fe <iget+0x38>
    80002910:	4098                	lw	a4,0(s1)
    80002912:	ff3716e3          	bne	a4,s3,800028fe <iget+0x38>
    80002916:	40d8                	lw	a4,4(s1)
    80002918:	ff4713e3          	bne	a4,s4,800028fe <iget+0x38>
      ip->ref++;
    8000291c:	2785                	addiw	a5,a5,1
    8000291e:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002920:	00021517          	auipc	a0,0x21
    80002924:	c5850513          	addi	a0,a0,-936 # 80023578 <itable>
    80002928:	00004097          	auipc	ra,0x4
    8000292c:	cd4080e7          	jalr	-812(ra) # 800065fc <release>
      return ip;
    80002930:	8926                	mv	s2,s1
    80002932:	a03d                	j	80002960 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002934:	f7f9                	bnez	a5,80002902 <iget+0x3c>
    80002936:	8926                	mv	s2,s1
    80002938:	b7e9                	j	80002902 <iget+0x3c>
  if(empty == 0)
    8000293a:	02090c63          	beqz	s2,80002972 <iget+0xac>
  ip->dev = dev;
    8000293e:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002942:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002946:	4785                	li	a5,1
    80002948:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000294c:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002950:	00021517          	auipc	a0,0x21
    80002954:	c2850513          	addi	a0,a0,-984 # 80023578 <itable>
    80002958:	00004097          	auipc	ra,0x4
    8000295c:	ca4080e7          	jalr	-860(ra) # 800065fc <release>
}
    80002960:	854a                	mv	a0,s2
    80002962:	70a2                	ld	ra,40(sp)
    80002964:	7402                	ld	s0,32(sp)
    80002966:	64e2                	ld	s1,24(sp)
    80002968:	6942                	ld	s2,16(sp)
    8000296a:	69a2                	ld	s3,8(sp)
    8000296c:	6a02                	ld	s4,0(sp)
    8000296e:	6145                	addi	sp,sp,48
    80002970:	8082                	ret
    panic("iget: no inodes");
    80002972:	00006517          	auipc	a0,0x6
    80002976:	b5e50513          	addi	a0,a0,-1186 # 800084d0 <syscalls+0x140>
    8000297a:	00003097          	auipc	ra,0x3
    8000297e:	696080e7          	jalr	1686(ra) # 80006010 <panic>

0000000080002982 <fsinit>:
fsinit(int dev) {
    80002982:	7179                	addi	sp,sp,-48
    80002984:	f406                	sd	ra,40(sp)
    80002986:	f022                	sd	s0,32(sp)
    80002988:	ec26                	sd	s1,24(sp)
    8000298a:	e84a                	sd	s2,16(sp)
    8000298c:	e44e                	sd	s3,8(sp)
    8000298e:	1800                	addi	s0,sp,48
    80002990:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002992:	4585                	li	a1,1
    80002994:	00000097          	auipc	ra,0x0
    80002998:	a66080e7          	jalr	-1434(ra) # 800023fa <bread>
    8000299c:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000299e:	00021997          	auipc	s3,0x21
    800029a2:	bba98993          	addi	s3,s3,-1094 # 80023558 <sb>
    800029a6:	02000613          	li	a2,32
    800029aa:	05850593          	addi	a1,a0,88
    800029ae:	854e                	mv	a0,s3
    800029b0:	ffffe097          	auipc	ra,0xffffe
    800029b4:	826080e7          	jalr	-2010(ra) # 800001d6 <memmove>
  brelse(bp);
    800029b8:	8526                	mv	a0,s1
    800029ba:	00000097          	auipc	ra,0x0
    800029be:	b70080e7          	jalr	-1168(ra) # 8000252a <brelse>
  if(sb.magic != FSMAGIC)
    800029c2:	0009a703          	lw	a4,0(s3)
    800029c6:	102037b7          	lui	a5,0x10203
    800029ca:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800029ce:	02f71263          	bne	a4,a5,800029f2 <fsinit+0x70>
  initlog(dev, &sb);
    800029d2:	00021597          	auipc	a1,0x21
    800029d6:	b8658593          	addi	a1,a1,-1146 # 80023558 <sb>
    800029da:	854a                	mv	a0,s2
    800029dc:	00001097          	auipc	ra,0x1
    800029e0:	b56080e7          	jalr	-1194(ra) # 80003532 <initlog>
}
    800029e4:	70a2                	ld	ra,40(sp)
    800029e6:	7402                	ld	s0,32(sp)
    800029e8:	64e2                	ld	s1,24(sp)
    800029ea:	6942                	ld	s2,16(sp)
    800029ec:	69a2                	ld	s3,8(sp)
    800029ee:	6145                	addi	sp,sp,48
    800029f0:	8082                	ret
    panic("invalid file system");
    800029f2:	00006517          	auipc	a0,0x6
    800029f6:	aee50513          	addi	a0,a0,-1298 # 800084e0 <syscalls+0x150>
    800029fa:	00003097          	auipc	ra,0x3
    800029fe:	616080e7          	jalr	1558(ra) # 80006010 <panic>

0000000080002a02 <iinit>:
{
    80002a02:	7179                	addi	sp,sp,-48
    80002a04:	f406                	sd	ra,40(sp)
    80002a06:	f022                	sd	s0,32(sp)
    80002a08:	ec26                	sd	s1,24(sp)
    80002a0a:	e84a                	sd	s2,16(sp)
    80002a0c:	e44e                	sd	s3,8(sp)
    80002a0e:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002a10:	00006597          	auipc	a1,0x6
    80002a14:	ae858593          	addi	a1,a1,-1304 # 800084f8 <syscalls+0x168>
    80002a18:	00021517          	auipc	a0,0x21
    80002a1c:	b6050513          	addi	a0,a0,-1184 # 80023578 <itable>
    80002a20:	00004097          	auipc	ra,0x4
    80002a24:	a98080e7          	jalr	-1384(ra) # 800064b8 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002a28:	00021497          	auipc	s1,0x21
    80002a2c:	b7848493          	addi	s1,s1,-1160 # 800235a0 <itable+0x28>
    80002a30:	00022997          	auipc	s3,0x22
    80002a34:	60098993          	addi	s3,s3,1536 # 80025030 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002a38:	00006917          	auipc	s2,0x6
    80002a3c:	ac890913          	addi	s2,s2,-1336 # 80008500 <syscalls+0x170>
    80002a40:	85ca                	mv	a1,s2
    80002a42:	8526                	mv	a0,s1
    80002a44:	00001097          	auipc	ra,0x1
    80002a48:	e4e080e7          	jalr	-434(ra) # 80003892 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002a4c:	08848493          	addi	s1,s1,136
    80002a50:	ff3498e3          	bne	s1,s3,80002a40 <iinit+0x3e>
}
    80002a54:	70a2                	ld	ra,40(sp)
    80002a56:	7402                	ld	s0,32(sp)
    80002a58:	64e2                	ld	s1,24(sp)
    80002a5a:	6942                	ld	s2,16(sp)
    80002a5c:	69a2                	ld	s3,8(sp)
    80002a5e:	6145                	addi	sp,sp,48
    80002a60:	8082                	ret

0000000080002a62 <ialloc>:
{
    80002a62:	715d                	addi	sp,sp,-80
    80002a64:	e486                	sd	ra,72(sp)
    80002a66:	e0a2                	sd	s0,64(sp)
    80002a68:	fc26                	sd	s1,56(sp)
    80002a6a:	f84a                	sd	s2,48(sp)
    80002a6c:	f44e                	sd	s3,40(sp)
    80002a6e:	f052                	sd	s4,32(sp)
    80002a70:	ec56                	sd	s5,24(sp)
    80002a72:	e85a                	sd	s6,16(sp)
    80002a74:	e45e                	sd	s7,8(sp)
    80002a76:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a78:	00021717          	auipc	a4,0x21
    80002a7c:	aec72703          	lw	a4,-1300(a4) # 80023564 <sb+0xc>
    80002a80:	4785                	li	a5,1
    80002a82:	04e7fa63          	bgeu	a5,a4,80002ad6 <ialloc+0x74>
    80002a86:	8aaa                	mv	s5,a0
    80002a88:	8bae                	mv	s7,a1
    80002a8a:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002a8c:	00021a17          	auipc	s4,0x21
    80002a90:	acca0a13          	addi	s4,s4,-1332 # 80023558 <sb>
    80002a94:	00048b1b          	sext.w	s6,s1
    80002a98:	0044d593          	srli	a1,s1,0x4
    80002a9c:	018a2783          	lw	a5,24(s4)
    80002aa0:	9dbd                	addw	a1,a1,a5
    80002aa2:	8556                	mv	a0,s5
    80002aa4:	00000097          	auipc	ra,0x0
    80002aa8:	956080e7          	jalr	-1706(ra) # 800023fa <bread>
    80002aac:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002aae:	05850993          	addi	s3,a0,88
    80002ab2:	00f4f793          	andi	a5,s1,15
    80002ab6:	079a                	slli	a5,a5,0x6
    80002ab8:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002aba:	00099783          	lh	a5,0(s3)
    80002abe:	c785                	beqz	a5,80002ae6 <ialloc+0x84>
    brelse(bp);
    80002ac0:	00000097          	auipc	ra,0x0
    80002ac4:	a6a080e7          	jalr	-1430(ra) # 8000252a <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002ac8:	0485                	addi	s1,s1,1
    80002aca:	00ca2703          	lw	a4,12(s4)
    80002ace:	0004879b          	sext.w	a5,s1
    80002ad2:	fce7e1e3          	bltu	a5,a4,80002a94 <ialloc+0x32>
  panic("ialloc: no inodes");
    80002ad6:	00006517          	auipc	a0,0x6
    80002ada:	a3250513          	addi	a0,a0,-1486 # 80008508 <syscalls+0x178>
    80002ade:	00003097          	auipc	ra,0x3
    80002ae2:	532080e7          	jalr	1330(ra) # 80006010 <panic>
      memset(dip, 0, sizeof(*dip));
    80002ae6:	04000613          	li	a2,64
    80002aea:	4581                	li	a1,0
    80002aec:	854e                	mv	a0,s3
    80002aee:	ffffd097          	auipc	ra,0xffffd
    80002af2:	68c080e7          	jalr	1676(ra) # 8000017a <memset>
      dip->type = type;
    80002af6:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002afa:	854a                	mv	a0,s2
    80002afc:	00001097          	auipc	ra,0x1
    80002b00:	cb2080e7          	jalr	-846(ra) # 800037ae <log_write>
      brelse(bp);
    80002b04:	854a                	mv	a0,s2
    80002b06:	00000097          	auipc	ra,0x0
    80002b0a:	a24080e7          	jalr	-1500(ra) # 8000252a <brelse>
      return iget(dev, inum);
    80002b0e:	85da                	mv	a1,s6
    80002b10:	8556                	mv	a0,s5
    80002b12:	00000097          	auipc	ra,0x0
    80002b16:	db4080e7          	jalr	-588(ra) # 800028c6 <iget>
}
    80002b1a:	60a6                	ld	ra,72(sp)
    80002b1c:	6406                	ld	s0,64(sp)
    80002b1e:	74e2                	ld	s1,56(sp)
    80002b20:	7942                	ld	s2,48(sp)
    80002b22:	79a2                	ld	s3,40(sp)
    80002b24:	7a02                	ld	s4,32(sp)
    80002b26:	6ae2                	ld	s5,24(sp)
    80002b28:	6b42                	ld	s6,16(sp)
    80002b2a:	6ba2                	ld	s7,8(sp)
    80002b2c:	6161                	addi	sp,sp,80
    80002b2e:	8082                	ret

0000000080002b30 <iupdate>:
{
    80002b30:	1101                	addi	sp,sp,-32
    80002b32:	ec06                	sd	ra,24(sp)
    80002b34:	e822                	sd	s0,16(sp)
    80002b36:	e426                	sd	s1,8(sp)
    80002b38:	e04a                	sd	s2,0(sp)
    80002b3a:	1000                	addi	s0,sp,32
    80002b3c:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b3e:	415c                	lw	a5,4(a0)
    80002b40:	0047d79b          	srliw	a5,a5,0x4
    80002b44:	00021597          	auipc	a1,0x21
    80002b48:	a2c5a583          	lw	a1,-1492(a1) # 80023570 <sb+0x18>
    80002b4c:	9dbd                	addw	a1,a1,a5
    80002b4e:	4108                	lw	a0,0(a0)
    80002b50:	00000097          	auipc	ra,0x0
    80002b54:	8aa080e7          	jalr	-1878(ra) # 800023fa <bread>
    80002b58:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b5a:	05850793          	addi	a5,a0,88
    80002b5e:	40d8                	lw	a4,4(s1)
    80002b60:	8b3d                	andi	a4,a4,15
    80002b62:	071a                	slli	a4,a4,0x6
    80002b64:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002b66:	04449703          	lh	a4,68(s1)
    80002b6a:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002b6e:	04649703          	lh	a4,70(s1)
    80002b72:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002b76:	04849703          	lh	a4,72(s1)
    80002b7a:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002b7e:	04a49703          	lh	a4,74(s1)
    80002b82:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002b86:	44f8                	lw	a4,76(s1)
    80002b88:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002b8a:	03400613          	li	a2,52
    80002b8e:	05048593          	addi	a1,s1,80
    80002b92:	00c78513          	addi	a0,a5,12
    80002b96:	ffffd097          	auipc	ra,0xffffd
    80002b9a:	640080e7          	jalr	1600(ra) # 800001d6 <memmove>
  log_write(bp);
    80002b9e:	854a                	mv	a0,s2
    80002ba0:	00001097          	auipc	ra,0x1
    80002ba4:	c0e080e7          	jalr	-1010(ra) # 800037ae <log_write>
  brelse(bp);
    80002ba8:	854a                	mv	a0,s2
    80002baa:	00000097          	auipc	ra,0x0
    80002bae:	980080e7          	jalr	-1664(ra) # 8000252a <brelse>
}
    80002bb2:	60e2                	ld	ra,24(sp)
    80002bb4:	6442                	ld	s0,16(sp)
    80002bb6:	64a2                	ld	s1,8(sp)
    80002bb8:	6902                	ld	s2,0(sp)
    80002bba:	6105                	addi	sp,sp,32
    80002bbc:	8082                	ret

0000000080002bbe <idup>:
{
    80002bbe:	1101                	addi	sp,sp,-32
    80002bc0:	ec06                	sd	ra,24(sp)
    80002bc2:	e822                	sd	s0,16(sp)
    80002bc4:	e426                	sd	s1,8(sp)
    80002bc6:	1000                	addi	s0,sp,32
    80002bc8:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002bca:	00021517          	auipc	a0,0x21
    80002bce:	9ae50513          	addi	a0,a0,-1618 # 80023578 <itable>
    80002bd2:	00004097          	auipc	ra,0x4
    80002bd6:	976080e7          	jalr	-1674(ra) # 80006548 <acquire>
  ip->ref++;
    80002bda:	449c                	lw	a5,8(s1)
    80002bdc:	2785                	addiw	a5,a5,1
    80002bde:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002be0:	00021517          	auipc	a0,0x21
    80002be4:	99850513          	addi	a0,a0,-1640 # 80023578 <itable>
    80002be8:	00004097          	auipc	ra,0x4
    80002bec:	a14080e7          	jalr	-1516(ra) # 800065fc <release>
}
    80002bf0:	8526                	mv	a0,s1
    80002bf2:	60e2                	ld	ra,24(sp)
    80002bf4:	6442                	ld	s0,16(sp)
    80002bf6:	64a2                	ld	s1,8(sp)
    80002bf8:	6105                	addi	sp,sp,32
    80002bfa:	8082                	ret

0000000080002bfc <ilock>:
{
    80002bfc:	1101                	addi	sp,sp,-32
    80002bfe:	ec06                	sd	ra,24(sp)
    80002c00:	e822                	sd	s0,16(sp)
    80002c02:	e426                	sd	s1,8(sp)
    80002c04:	e04a                	sd	s2,0(sp)
    80002c06:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002c08:	c115                	beqz	a0,80002c2c <ilock+0x30>
    80002c0a:	84aa                	mv	s1,a0
    80002c0c:	451c                	lw	a5,8(a0)
    80002c0e:	00f05f63          	blez	a5,80002c2c <ilock+0x30>
  acquiresleep(&ip->lock);
    80002c12:	0541                	addi	a0,a0,16
    80002c14:	00001097          	auipc	ra,0x1
    80002c18:	cb8080e7          	jalr	-840(ra) # 800038cc <acquiresleep>
  if(ip->valid == 0){
    80002c1c:	40bc                	lw	a5,64(s1)
    80002c1e:	cf99                	beqz	a5,80002c3c <ilock+0x40>
}
    80002c20:	60e2                	ld	ra,24(sp)
    80002c22:	6442                	ld	s0,16(sp)
    80002c24:	64a2                	ld	s1,8(sp)
    80002c26:	6902                	ld	s2,0(sp)
    80002c28:	6105                	addi	sp,sp,32
    80002c2a:	8082                	ret
    panic("ilock");
    80002c2c:	00006517          	auipc	a0,0x6
    80002c30:	8f450513          	addi	a0,a0,-1804 # 80008520 <syscalls+0x190>
    80002c34:	00003097          	auipc	ra,0x3
    80002c38:	3dc080e7          	jalr	988(ra) # 80006010 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c3c:	40dc                	lw	a5,4(s1)
    80002c3e:	0047d79b          	srliw	a5,a5,0x4
    80002c42:	00021597          	auipc	a1,0x21
    80002c46:	92e5a583          	lw	a1,-1746(a1) # 80023570 <sb+0x18>
    80002c4a:	9dbd                	addw	a1,a1,a5
    80002c4c:	4088                	lw	a0,0(s1)
    80002c4e:	fffff097          	auipc	ra,0xfffff
    80002c52:	7ac080e7          	jalr	1964(ra) # 800023fa <bread>
    80002c56:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c58:	05850593          	addi	a1,a0,88
    80002c5c:	40dc                	lw	a5,4(s1)
    80002c5e:	8bbd                	andi	a5,a5,15
    80002c60:	079a                	slli	a5,a5,0x6
    80002c62:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002c64:	00059783          	lh	a5,0(a1)
    80002c68:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c6c:	00259783          	lh	a5,2(a1)
    80002c70:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c74:	00459783          	lh	a5,4(a1)
    80002c78:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002c7c:	00659783          	lh	a5,6(a1)
    80002c80:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002c84:	459c                	lw	a5,8(a1)
    80002c86:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002c88:	03400613          	li	a2,52
    80002c8c:	05b1                	addi	a1,a1,12
    80002c8e:	05048513          	addi	a0,s1,80
    80002c92:	ffffd097          	auipc	ra,0xffffd
    80002c96:	544080e7          	jalr	1348(ra) # 800001d6 <memmove>
    brelse(bp);
    80002c9a:	854a                	mv	a0,s2
    80002c9c:	00000097          	auipc	ra,0x0
    80002ca0:	88e080e7          	jalr	-1906(ra) # 8000252a <brelse>
    ip->valid = 1;
    80002ca4:	4785                	li	a5,1
    80002ca6:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002ca8:	04449783          	lh	a5,68(s1)
    80002cac:	fbb5                	bnez	a5,80002c20 <ilock+0x24>
      panic("ilock: no type");
    80002cae:	00006517          	auipc	a0,0x6
    80002cb2:	87a50513          	addi	a0,a0,-1926 # 80008528 <syscalls+0x198>
    80002cb6:	00003097          	auipc	ra,0x3
    80002cba:	35a080e7          	jalr	858(ra) # 80006010 <panic>

0000000080002cbe <iunlock>:
{
    80002cbe:	1101                	addi	sp,sp,-32
    80002cc0:	ec06                	sd	ra,24(sp)
    80002cc2:	e822                	sd	s0,16(sp)
    80002cc4:	e426                	sd	s1,8(sp)
    80002cc6:	e04a                	sd	s2,0(sp)
    80002cc8:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002cca:	c905                	beqz	a0,80002cfa <iunlock+0x3c>
    80002ccc:	84aa                	mv	s1,a0
    80002cce:	01050913          	addi	s2,a0,16
    80002cd2:	854a                	mv	a0,s2
    80002cd4:	00001097          	auipc	ra,0x1
    80002cd8:	c92080e7          	jalr	-878(ra) # 80003966 <holdingsleep>
    80002cdc:	cd19                	beqz	a0,80002cfa <iunlock+0x3c>
    80002cde:	449c                	lw	a5,8(s1)
    80002ce0:	00f05d63          	blez	a5,80002cfa <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002ce4:	854a                	mv	a0,s2
    80002ce6:	00001097          	auipc	ra,0x1
    80002cea:	c3c080e7          	jalr	-964(ra) # 80003922 <releasesleep>
}
    80002cee:	60e2                	ld	ra,24(sp)
    80002cf0:	6442                	ld	s0,16(sp)
    80002cf2:	64a2                	ld	s1,8(sp)
    80002cf4:	6902                	ld	s2,0(sp)
    80002cf6:	6105                	addi	sp,sp,32
    80002cf8:	8082                	ret
    panic("iunlock");
    80002cfa:	00006517          	auipc	a0,0x6
    80002cfe:	83e50513          	addi	a0,a0,-1986 # 80008538 <syscalls+0x1a8>
    80002d02:	00003097          	auipc	ra,0x3
    80002d06:	30e080e7          	jalr	782(ra) # 80006010 <panic>

0000000080002d0a <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002d0a:	7179                	addi	sp,sp,-48
    80002d0c:	f406                	sd	ra,40(sp)
    80002d0e:	f022                	sd	s0,32(sp)
    80002d10:	ec26                	sd	s1,24(sp)
    80002d12:	e84a                	sd	s2,16(sp)
    80002d14:	e44e                	sd	s3,8(sp)
    80002d16:	e052                	sd	s4,0(sp)
    80002d18:	1800                	addi	s0,sp,48
    80002d1a:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002d1c:	05050493          	addi	s1,a0,80
    80002d20:	08050913          	addi	s2,a0,128
    80002d24:	a021                	j	80002d2c <itrunc+0x22>
    80002d26:	0491                	addi	s1,s1,4
    80002d28:	01248d63          	beq	s1,s2,80002d42 <itrunc+0x38>
    if(ip->addrs[i]){
    80002d2c:	408c                	lw	a1,0(s1)
    80002d2e:	dde5                	beqz	a1,80002d26 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002d30:	0009a503          	lw	a0,0(s3)
    80002d34:	00000097          	auipc	ra,0x0
    80002d38:	90c080e7          	jalr	-1780(ra) # 80002640 <bfree>
      ip->addrs[i] = 0;
    80002d3c:	0004a023          	sw	zero,0(s1)
    80002d40:	b7dd                	j	80002d26 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002d42:	0809a583          	lw	a1,128(s3)
    80002d46:	e185                	bnez	a1,80002d66 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002d48:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002d4c:	854e                	mv	a0,s3
    80002d4e:	00000097          	auipc	ra,0x0
    80002d52:	de2080e7          	jalr	-542(ra) # 80002b30 <iupdate>
}
    80002d56:	70a2                	ld	ra,40(sp)
    80002d58:	7402                	ld	s0,32(sp)
    80002d5a:	64e2                	ld	s1,24(sp)
    80002d5c:	6942                	ld	s2,16(sp)
    80002d5e:	69a2                	ld	s3,8(sp)
    80002d60:	6a02                	ld	s4,0(sp)
    80002d62:	6145                	addi	sp,sp,48
    80002d64:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d66:	0009a503          	lw	a0,0(s3)
    80002d6a:	fffff097          	auipc	ra,0xfffff
    80002d6e:	690080e7          	jalr	1680(ra) # 800023fa <bread>
    80002d72:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002d74:	05850493          	addi	s1,a0,88
    80002d78:	45850913          	addi	s2,a0,1112
    80002d7c:	a021                	j	80002d84 <itrunc+0x7a>
    80002d7e:	0491                	addi	s1,s1,4
    80002d80:	01248b63          	beq	s1,s2,80002d96 <itrunc+0x8c>
      if(a[j])
    80002d84:	408c                	lw	a1,0(s1)
    80002d86:	dde5                	beqz	a1,80002d7e <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002d88:	0009a503          	lw	a0,0(s3)
    80002d8c:	00000097          	auipc	ra,0x0
    80002d90:	8b4080e7          	jalr	-1868(ra) # 80002640 <bfree>
    80002d94:	b7ed                	j	80002d7e <itrunc+0x74>
    brelse(bp);
    80002d96:	8552                	mv	a0,s4
    80002d98:	fffff097          	auipc	ra,0xfffff
    80002d9c:	792080e7          	jalr	1938(ra) # 8000252a <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002da0:	0809a583          	lw	a1,128(s3)
    80002da4:	0009a503          	lw	a0,0(s3)
    80002da8:	00000097          	auipc	ra,0x0
    80002dac:	898080e7          	jalr	-1896(ra) # 80002640 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002db0:	0809a023          	sw	zero,128(s3)
    80002db4:	bf51                	j	80002d48 <itrunc+0x3e>

0000000080002db6 <iput>:
{
    80002db6:	1101                	addi	sp,sp,-32
    80002db8:	ec06                	sd	ra,24(sp)
    80002dba:	e822                	sd	s0,16(sp)
    80002dbc:	e426                	sd	s1,8(sp)
    80002dbe:	e04a                	sd	s2,0(sp)
    80002dc0:	1000                	addi	s0,sp,32
    80002dc2:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002dc4:	00020517          	auipc	a0,0x20
    80002dc8:	7b450513          	addi	a0,a0,1972 # 80023578 <itable>
    80002dcc:	00003097          	auipc	ra,0x3
    80002dd0:	77c080e7          	jalr	1916(ra) # 80006548 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002dd4:	4498                	lw	a4,8(s1)
    80002dd6:	4785                	li	a5,1
    80002dd8:	02f70363          	beq	a4,a5,80002dfe <iput+0x48>
  ip->ref--;
    80002ddc:	449c                	lw	a5,8(s1)
    80002dde:	37fd                	addiw	a5,a5,-1
    80002de0:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002de2:	00020517          	auipc	a0,0x20
    80002de6:	79650513          	addi	a0,a0,1942 # 80023578 <itable>
    80002dea:	00004097          	auipc	ra,0x4
    80002dee:	812080e7          	jalr	-2030(ra) # 800065fc <release>
}
    80002df2:	60e2                	ld	ra,24(sp)
    80002df4:	6442                	ld	s0,16(sp)
    80002df6:	64a2                	ld	s1,8(sp)
    80002df8:	6902                	ld	s2,0(sp)
    80002dfa:	6105                	addi	sp,sp,32
    80002dfc:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002dfe:	40bc                	lw	a5,64(s1)
    80002e00:	dff1                	beqz	a5,80002ddc <iput+0x26>
    80002e02:	04a49783          	lh	a5,74(s1)
    80002e06:	fbf9                	bnez	a5,80002ddc <iput+0x26>
    acquiresleep(&ip->lock);
    80002e08:	01048913          	addi	s2,s1,16
    80002e0c:	854a                	mv	a0,s2
    80002e0e:	00001097          	auipc	ra,0x1
    80002e12:	abe080e7          	jalr	-1346(ra) # 800038cc <acquiresleep>
    release(&itable.lock);
    80002e16:	00020517          	auipc	a0,0x20
    80002e1a:	76250513          	addi	a0,a0,1890 # 80023578 <itable>
    80002e1e:	00003097          	auipc	ra,0x3
    80002e22:	7de080e7          	jalr	2014(ra) # 800065fc <release>
    itrunc(ip);
    80002e26:	8526                	mv	a0,s1
    80002e28:	00000097          	auipc	ra,0x0
    80002e2c:	ee2080e7          	jalr	-286(ra) # 80002d0a <itrunc>
    ip->type = 0;
    80002e30:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002e34:	8526                	mv	a0,s1
    80002e36:	00000097          	auipc	ra,0x0
    80002e3a:	cfa080e7          	jalr	-774(ra) # 80002b30 <iupdate>
    ip->valid = 0;
    80002e3e:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e42:	854a                	mv	a0,s2
    80002e44:	00001097          	auipc	ra,0x1
    80002e48:	ade080e7          	jalr	-1314(ra) # 80003922 <releasesleep>
    acquire(&itable.lock);
    80002e4c:	00020517          	auipc	a0,0x20
    80002e50:	72c50513          	addi	a0,a0,1836 # 80023578 <itable>
    80002e54:	00003097          	auipc	ra,0x3
    80002e58:	6f4080e7          	jalr	1780(ra) # 80006548 <acquire>
    80002e5c:	b741                	j	80002ddc <iput+0x26>

0000000080002e5e <iunlockput>:
{
    80002e5e:	1101                	addi	sp,sp,-32
    80002e60:	ec06                	sd	ra,24(sp)
    80002e62:	e822                	sd	s0,16(sp)
    80002e64:	e426                	sd	s1,8(sp)
    80002e66:	1000                	addi	s0,sp,32
    80002e68:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e6a:	00000097          	auipc	ra,0x0
    80002e6e:	e54080e7          	jalr	-428(ra) # 80002cbe <iunlock>
  iput(ip);
    80002e72:	8526                	mv	a0,s1
    80002e74:	00000097          	auipc	ra,0x0
    80002e78:	f42080e7          	jalr	-190(ra) # 80002db6 <iput>
}
    80002e7c:	60e2                	ld	ra,24(sp)
    80002e7e:	6442                	ld	s0,16(sp)
    80002e80:	64a2                	ld	s1,8(sp)
    80002e82:	6105                	addi	sp,sp,32
    80002e84:	8082                	ret

0000000080002e86 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002e86:	1141                	addi	sp,sp,-16
    80002e88:	e422                	sd	s0,8(sp)
    80002e8a:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002e8c:	411c                	lw	a5,0(a0)
    80002e8e:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002e90:	415c                	lw	a5,4(a0)
    80002e92:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002e94:	04451783          	lh	a5,68(a0)
    80002e98:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002e9c:	04a51783          	lh	a5,74(a0)
    80002ea0:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002ea4:	04c56783          	lwu	a5,76(a0)
    80002ea8:	e99c                	sd	a5,16(a1)
}
    80002eaa:	6422                	ld	s0,8(sp)
    80002eac:	0141                	addi	sp,sp,16
    80002eae:	8082                	ret

0000000080002eb0 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002eb0:	457c                	lw	a5,76(a0)
    80002eb2:	0ed7e963          	bltu	a5,a3,80002fa4 <readi+0xf4>
{
    80002eb6:	7159                	addi	sp,sp,-112
    80002eb8:	f486                	sd	ra,104(sp)
    80002eba:	f0a2                	sd	s0,96(sp)
    80002ebc:	eca6                	sd	s1,88(sp)
    80002ebe:	e8ca                	sd	s2,80(sp)
    80002ec0:	e4ce                	sd	s3,72(sp)
    80002ec2:	e0d2                	sd	s4,64(sp)
    80002ec4:	fc56                	sd	s5,56(sp)
    80002ec6:	f85a                	sd	s6,48(sp)
    80002ec8:	f45e                	sd	s7,40(sp)
    80002eca:	f062                	sd	s8,32(sp)
    80002ecc:	ec66                	sd	s9,24(sp)
    80002ece:	e86a                	sd	s10,16(sp)
    80002ed0:	e46e                	sd	s11,8(sp)
    80002ed2:	1880                	addi	s0,sp,112
    80002ed4:	8baa                	mv	s7,a0
    80002ed6:	8c2e                	mv	s8,a1
    80002ed8:	8ab2                	mv	s5,a2
    80002eda:	84b6                	mv	s1,a3
    80002edc:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002ede:	9f35                	addw	a4,a4,a3
    return 0;
    80002ee0:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002ee2:	0ad76063          	bltu	a4,a3,80002f82 <readi+0xd2>
  if(off + n > ip->size)
    80002ee6:	00e7f463          	bgeu	a5,a4,80002eee <readi+0x3e>
    n = ip->size - off;
    80002eea:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002eee:	0a0b0963          	beqz	s6,80002fa0 <readi+0xf0>
    80002ef2:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ef4:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002ef8:	5cfd                	li	s9,-1
    80002efa:	a82d                	j	80002f34 <readi+0x84>
    80002efc:	020a1d93          	slli	s11,s4,0x20
    80002f00:	020ddd93          	srli	s11,s11,0x20
    80002f04:	05890613          	addi	a2,s2,88
    80002f08:	86ee                	mv	a3,s11
    80002f0a:	963a                	add	a2,a2,a4
    80002f0c:	85d6                	mv	a1,s5
    80002f0e:	8562                	mv	a0,s8
    80002f10:	fffff097          	auipc	ra,0xfffff
    80002f14:	9fc080e7          	jalr	-1540(ra) # 8000190c <either_copyout>
    80002f18:	05950d63          	beq	a0,s9,80002f72 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002f1c:	854a                	mv	a0,s2
    80002f1e:	fffff097          	auipc	ra,0xfffff
    80002f22:	60c080e7          	jalr	1548(ra) # 8000252a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f26:	013a09bb          	addw	s3,s4,s3
    80002f2a:	009a04bb          	addw	s1,s4,s1
    80002f2e:	9aee                	add	s5,s5,s11
    80002f30:	0569f763          	bgeu	s3,s6,80002f7e <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002f34:	000ba903          	lw	s2,0(s7)
    80002f38:	00a4d59b          	srliw	a1,s1,0xa
    80002f3c:	855e                	mv	a0,s7
    80002f3e:	00000097          	auipc	ra,0x0
    80002f42:	8ac080e7          	jalr	-1876(ra) # 800027ea <bmap>
    80002f46:	0005059b          	sext.w	a1,a0
    80002f4a:	854a                	mv	a0,s2
    80002f4c:	fffff097          	auipc	ra,0xfffff
    80002f50:	4ae080e7          	jalr	1198(ra) # 800023fa <bread>
    80002f54:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f56:	3ff4f713          	andi	a4,s1,1023
    80002f5a:	40ed07bb          	subw	a5,s10,a4
    80002f5e:	413b06bb          	subw	a3,s6,s3
    80002f62:	8a3e                	mv	s4,a5
    80002f64:	2781                	sext.w	a5,a5
    80002f66:	0006861b          	sext.w	a2,a3
    80002f6a:	f8f679e3          	bgeu	a2,a5,80002efc <readi+0x4c>
    80002f6e:	8a36                	mv	s4,a3
    80002f70:	b771                	j	80002efc <readi+0x4c>
      brelse(bp);
    80002f72:	854a                	mv	a0,s2
    80002f74:	fffff097          	auipc	ra,0xfffff
    80002f78:	5b6080e7          	jalr	1462(ra) # 8000252a <brelse>
      tot = -1;
    80002f7c:	59fd                	li	s3,-1
  }
  return tot;
    80002f7e:	0009851b          	sext.w	a0,s3
}
    80002f82:	70a6                	ld	ra,104(sp)
    80002f84:	7406                	ld	s0,96(sp)
    80002f86:	64e6                	ld	s1,88(sp)
    80002f88:	6946                	ld	s2,80(sp)
    80002f8a:	69a6                	ld	s3,72(sp)
    80002f8c:	6a06                	ld	s4,64(sp)
    80002f8e:	7ae2                	ld	s5,56(sp)
    80002f90:	7b42                	ld	s6,48(sp)
    80002f92:	7ba2                	ld	s7,40(sp)
    80002f94:	7c02                	ld	s8,32(sp)
    80002f96:	6ce2                	ld	s9,24(sp)
    80002f98:	6d42                	ld	s10,16(sp)
    80002f9a:	6da2                	ld	s11,8(sp)
    80002f9c:	6165                	addi	sp,sp,112
    80002f9e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002fa0:	89da                	mv	s3,s6
    80002fa2:	bff1                	j	80002f7e <readi+0xce>
    return 0;
    80002fa4:	4501                	li	a0,0
}
    80002fa6:	8082                	ret

0000000080002fa8 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002fa8:	457c                	lw	a5,76(a0)
    80002faa:	10d7e863          	bltu	a5,a3,800030ba <writei+0x112>
{
    80002fae:	7159                	addi	sp,sp,-112
    80002fb0:	f486                	sd	ra,104(sp)
    80002fb2:	f0a2                	sd	s0,96(sp)
    80002fb4:	eca6                	sd	s1,88(sp)
    80002fb6:	e8ca                	sd	s2,80(sp)
    80002fb8:	e4ce                	sd	s3,72(sp)
    80002fba:	e0d2                	sd	s4,64(sp)
    80002fbc:	fc56                	sd	s5,56(sp)
    80002fbe:	f85a                	sd	s6,48(sp)
    80002fc0:	f45e                	sd	s7,40(sp)
    80002fc2:	f062                	sd	s8,32(sp)
    80002fc4:	ec66                	sd	s9,24(sp)
    80002fc6:	e86a                	sd	s10,16(sp)
    80002fc8:	e46e                	sd	s11,8(sp)
    80002fca:	1880                	addi	s0,sp,112
    80002fcc:	8b2a                	mv	s6,a0
    80002fce:	8c2e                	mv	s8,a1
    80002fd0:	8ab2                	mv	s5,a2
    80002fd2:	8936                	mv	s2,a3
    80002fd4:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80002fd6:	00e687bb          	addw	a5,a3,a4
    80002fda:	0ed7e263          	bltu	a5,a3,800030be <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002fde:	00043737          	lui	a4,0x43
    80002fe2:	0ef76063          	bltu	a4,a5,800030c2 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fe6:	0c0b8863          	beqz	s7,800030b6 <writei+0x10e>
    80002fea:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fec:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002ff0:	5cfd                	li	s9,-1
    80002ff2:	a091                	j	80003036 <writei+0x8e>
    80002ff4:	02099d93          	slli	s11,s3,0x20
    80002ff8:	020ddd93          	srli	s11,s11,0x20
    80002ffc:	05848513          	addi	a0,s1,88
    80003000:	86ee                	mv	a3,s11
    80003002:	8656                	mv	a2,s5
    80003004:	85e2                	mv	a1,s8
    80003006:	953a                	add	a0,a0,a4
    80003008:	fffff097          	auipc	ra,0xfffff
    8000300c:	95a080e7          	jalr	-1702(ra) # 80001962 <either_copyin>
    80003010:	07950263          	beq	a0,s9,80003074 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003014:	8526                	mv	a0,s1
    80003016:	00000097          	auipc	ra,0x0
    8000301a:	798080e7          	jalr	1944(ra) # 800037ae <log_write>
    brelse(bp);
    8000301e:	8526                	mv	a0,s1
    80003020:	fffff097          	auipc	ra,0xfffff
    80003024:	50a080e7          	jalr	1290(ra) # 8000252a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003028:	01498a3b          	addw	s4,s3,s4
    8000302c:	0129893b          	addw	s2,s3,s2
    80003030:	9aee                	add	s5,s5,s11
    80003032:	057a7663          	bgeu	s4,s7,8000307e <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003036:	000b2483          	lw	s1,0(s6)
    8000303a:	00a9559b          	srliw	a1,s2,0xa
    8000303e:	855a                	mv	a0,s6
    80003040:	fffff097          	auipc	ra,0xfffff
    80003044:	7aa080e7          	jalr	1962(ra) # 800027ea <bmap>
    80003048:	0005059b          	sext.w	a1,a0
    8000304c:	8526                	mv	a0,s1
    8000304e:	fffff097          	auipc	ra,0xfffff
    80003052:	3ac080e7          	jalr	940(ra) # 800023fa <bread>
    80003056:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003058:	3ff97713          	andi	a4,s2,1023
    8000305c:	40ed07bb          	subw	a5,s10,a4
    80003060:	414b86bb          	subw	a3,s7,s4
    80003064:	89be                	mv	s3,a5
    80003066:	2781                	sext.w	a5,a5
    80003068:	0006861b          	sext.w	a2,a3
    8000306c:	f8f674e3          	bgeu	a2,a5,80002ff4 <writei+0x4c>
    80003070:	89b6                	mv	s3,a3
    80003072:	b749                	j	80002ff4 <writei+0x4c>
      brelse(bp);
    80003074:	8526                	mv	a0,s1
    80003076:	fffff097          	auipc	ra,0xfffff
    8000307a:	4b4080e7          	jalr	1204(ra) # 8000252a <brelse>
  }

  if(off > ip->size)
    8000307e:	04cb2783          	lw	a5,76(s6)
    80003082:	0127f463          	bgeu	a5,s2,8000308a <writei+0xe2>
    ip->size = off;
    80003086:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000308a:	855a                	mv	a0,s6
    8000308c:	00000097          	auipc	ra,0x0
    80003090:	aa4080e7          	jalr	-1372(ra) # 80002b30 <iupdate>

  return tot;
    80003094:	000a051b          	sext.w	a0,s4
}
    80003098:	70a6                	ld	ra,104(sp)
    8000309a:	7406                	ld	s0,96(sp)
    8000309c:	64e6                	ld	s1,88(sp)
    8000309e:	6946                	ld	s2,80(sp)
    800030a0:	69a6                	ld	s3,72(sp)
    800030a2:	6a06                	ld	s4,64(sp)
    800030a4:	7ae2                	ld	s5,56(sp)
    800030a6:	7b42                	ld	s6,48(sp)
    800030a8:	7ba2                	ld	s7,40(sp)
    800030aa:	7c02                	ld	s8,32(sp)
    800030ac:	6ce2                	ld	s9,24(sp)
    800030ae:	6d42                	ld	s10,16(sp)
    800030b0:	6da2                	ld	s11,8(sp)
    800030b2:	6165                	addi	sp,sp,112
    800030b4:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030b6:	8a5e                	mv	s4,s7
    800030b8:	bfc9                	j	8000308a <writei+0xe2>
    return -1;
    800030ba:	557d                	li	a0,-1
}
    800030bc:	8082                	ret
    return -1;
    800030be:	557d                	li	a0,-1
    800030c0:	bfe1                	j	80003098 <writei+0xf0>
    return -1;
    800030c2:	557d                	li	a0,-1
    800030c4:	bfd1                	j	80003098 <writei+0xf0>

00000000800030c6 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800030c6:	1141                	addi	sp,sp,-16
    800030c8:	e406                	sd	ra,8(sp)
    800030ca:	e022                	sd	s0,0(sp)
    800030cc:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800030ce:	4639                	li	a2,14
    800030d0:	ffffd097          	auipc	ra,0xffffd
    800030d4:	17a080e7          	jalr	378(ra) # 8000024a <strncmp>
}
    800030d8:	60a2                	ld	ra,8(sp)
    800030da:	6402                	ld	s0,0(sp)
    800030dc:	0141                	addi	sp,sp,16
    800030de:	8082                	ret

00000000800030e0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800030e0:	7139                	addi	sp,sp,-64
    800030e2:	fc06                	sd	ra,56(sp)
    800030e4:	f822                	sd	s0,48(sp)
    800030e6:	f426                	sd	s1,40(sp)
    800030e8:	f04a                	sd	s2,32(sp)
    800030ea:	ec4e                	sd	s3,24(sp)
    800030ec:	e852                	sd	s4,16(sp)
    800030ee:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800030f0:	04451703          	lh	a4,68(a0)
    800030f4:	4785                	li	a5,1
    800030f6:	00f71a63          	bne	a4,a5,8000310a <dirlookup+0x2a>
    800030fa:	892a                	mv	s2,a0
    800030fc:	89ae                	mv	s3,a1
    800030fe:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003100:	457c                	lw	a5,76(a0)
    80003102:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003104:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003106:	e79d                	bnez	a5,80003134 <dirlookup+0x54>
    80003108:	a8a5                	j	80003180 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000310a:	00005517          	auipc	a0,0x5
    8000310e:	43650513          	addi	a0,a0,1078 # 80008540 <syscalls+0x1b0>
    80003112:	00003097          	auipc	ra,0x3
    80003116:	efe080e7          	jalr	-258(ra) # 80006010 <panic>
      panic("dirlookup read");
    8000311a:	00005517          	auipc	a0,0x5
    8000311e:	43e50513          	addi	a0,a0,1086 # 80008558 <syscalls+0x1c8>
    80003122:	00003097          	auipc	ra,0x3
    80003126:	eee080e7          	jalr	-274(ra) # 80006010 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000312a:	24c1                	addiw	s1,s1,16
    8000312c:	04c92783          	lw	a5,76(s2)
    80003130:	04f4f763          	bgeu	s1,a5,8000317e <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003134:	4741                	li	a4,16
    80003136:	86a6                	mv	a3,s1
    80003138:	fc040613          	addi	a2,s0,-64
    8000313c:	4581                	li	a1,0
    8000313e:	854a                	mv	a0,s2
    80003140:	00000097          	auipc	ra,0x0
    80003144:	d70080e7          	jalr	-656(ra) # 80002eb0 <readi>
    80003148:	47c1                	li	a5,16
    8000314a:	fcf518e3          	bne	a0,a5,8000311a <dirlookup+0x3a>
    if(de.inum == 0)
    8000314e:	fc045783          	lhu	a5,-64(s0)
    80003152:	dfe1                	beqz	a5,8000312a <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003154:	fc240593          	addi	a1,s0,-62
    80003158:	854e                	mv	a0,s3
    8000315a:	00000097          	auipc	ra,0x0
    8000315e:	f6c080e7          	jalr	-148(ra) # 800030c6 <namecmp>
    80003162:	f561                	bnez	a0,8000312a <dirlookup+0x4a>
      if(poff)
    80003164:	000a0463          	beqz	s4,8000316c <dirlookup+0x8c>
        *poff = off;
    80003168:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000316c:	fc045583          	lhu	a1,-64(s0)
    80003170:	00092503          	lw	a0,0(s2)
    80003174:	fffff097          	auipc	ra,0xfffff
    80003178:	752080e7          	jalr	1874(ra) # 800028c6 <iget>
    8000317c:	a011                	j	80003180 <dirlookup+0xa0>
  return 0;
    8000317e:	4501                	li	a0,0
}
    80003180:	70e2                	ld	ra,56(sp)
    80003182:	7442                	ld	s0,48(sp)
    80003184:	74a2                	ld	s1,40(sp)
    80003186:	7902                	ld	s2,32(sp)
    80003188:	69e2                	ld	s3,24(sp)
    8000318a:	6a42                	ld	s4,16(sp)
    8000318c:	6121                	addi	sp,sp,64
    8000318e:	8082                	ret

0000000080003190 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003190:	711d                	addi	sp,sp,-96
    80003192:	ec86                	sd	ra,88(sp)
    80003194:	e8a2                	sd	s0,80(sp)
    80003196:	e4a6                	sd	s1,72(sp)
    80003198:	e0ca                	sd	s2,64(sp)
    8000319a:	fc4e                	sd	s3,56(sp)
    8000319c:	f852                	sd	s4,48(sp)
    8000319e:	f456                	sd	s5,40(sp)
    800031a0:	f05a                	sd	s6,32(sp)
    800031a2:	ec5e                	sd	s7,24(sp)
    800031a4:	e862                	sd	s8,16(sp)
    800031a6:	e466                	sd	s9,8(sp)
    800031a8:	e06a                	sd	s10,0(sp)
    800031aa:	1080                	addi	s0,sp,96
    800031ac:	84aa                	mv	s1,a0
    800031ae:	8b2e                	mv	s6,a1
    800031b0:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800031b2:	00054703          	lbu	a4,0(a0)
    800031b6:	02f00793          	li	a5,47
    800031ba:	02f70363          	beq	a4,a5,800031e0 <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800031be:	ffffe097          	auipc	ra,0xffffe
    800031c2:	c6c080e7          	jalr	-916(ra) # 80000e2a <myproc>
    800031c6:	15053503          	ld	a0,336(a0)
    800031ca:	00000097          	auipc	ra,0x0
    800031ce:	9f4080e7          	jalr	-1548(ra) # 80002bbe <idup>
    800031d2:	8a2a                	mv	s4,a0
  while(*path == '/')
    800031d4:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800031d8:	4cb5                	li	s9,13
  len = path - s;
    800031da:	4b81                	li	s7,0

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800031dc:	4c05                	li	s8,1
    800031de:	a87d                	j	8000329c <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    800031e0:	4585                	li	a1,1
    800031e2:	4505                	li	a0,1
    800031e4:	fffff097          	auipc	ra,0xfffff
    800031e8:	6e2080e7          	jalr	1762(ra) # 800028c6 <iget>
    800031ec:	8a2a                	mv	s4,a0
    800031ee:	b7dd                	j	800031d4 <namex+0x44>
      iunlockput(ip);
    800031f0:	8552                	mv	a0,s4
    800031f2:	00000097          	auipc	ra,0x0
    800031f6:	c6c080e7          	jalr	-916(ra) # 80002e5e <iunlockput>
      return 0;
    800031fa:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800031fc:	8552                	mv	a0,s4
    800031fe:	60e6                	ld	ra,88(sp)
    80003200:	6446                	ld	s0,80(sp)
    80003202:	64a6                	ld	s1,72(sp)
    80003204:	6906                	ld	s2,64(sp)
    80003206:	79e2                	ld	s3,56(sp)
    80003208:	7a42                	ld	s4,48(sp)
    8000320a:	7aa2                	ld	s5,40(sp)
    8000320c:	7b02                	ld	s6,32(sp)
    8000320e:	6be2                	ld	s7,24(sp)
    80003210:	6c42                	ld	s8,16(sp)
    80003212:	6ca2                	ld	s9,8(sp)
    80003214:	6d02                	ld	s10,0(sp)
    80003216:	6125                	addi	sp,sp,96
    80003218:	8082                	ret
      iunlock(ip);
    8000321a:	8552                	mv	a0,s4
    8000321c:	00000097          	auipc	ra,0x0
    80003220:	aa2080e7          	jalr	-1374(ra) # 80002cbe <iunlock>
      return ip;
    80003224:	bfe1                	j	800031fc <namex+0x6c>
      iunlockput(ip);
    80003226:	8552                	mv	a0,s4
    80003228:	00000097          	auipc	ra,0x0
    8000322c:	c36080e7          	jalr	-970(ra) # 80002e5e <iunlockput>
      return 0;
    80003230:	8a4e                	mv	s4,s3
    80003232:	b7e9                	j	800031fc <namex+0x6c>
  len = path - s;
    80003234:	40998633          	sub	a2,s3,s1
    80003238:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    8000323c:	09acd863          	bge	s9,s10,800032cc <namex+0x13c>
    memmove(name, s, DIRSIZ);
    80003240:	4639                	li	a2,14
    80003242:	85a6                	mv	a1,s1
    80003244:	8556                	mv	a0,s5
    80003246:	ffffd097          	auipc	ra,0xffffd
    8000324a:	f90080e7          	jalr	-112(ra) # 800001d6 <memmove>
    8000324e:	84ce                	mv	s1,s3
  while(*path == '/')
    80003250:	0004c783          	lbu	a5,0(s1)
    80003254:	01279763          	bne	a5,s2,80003262 <namex+0xd2>
    path++;
    80003258:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000325a:	0004c783          	lbu	a5,0(s1)
    8000325e:	ff278de3          	beq	a5,s2,80003258 <namex+0xc8>
    ilock(ip);
    80003262:	8552                	mv	a0,s4
    80003264:	00000097          	auipc	ra,0x0
    80003268:	998080e7          	jalr	-1640(ra) # 80002bfc <ilock>
    if(ip->type != T_DIR){
    8000326c:	044a1783          	lh	a5,68(s4)
    80003270:	f98790e3          	bne	a5,s8,800031f0 <namex+0x60>
    if(nameiparent && *path == '\0'){
    80003274:	000b0563          	beqz	s6,8000327e <namex+0xee>
    80003278:	0004c783          	lbu	a5,0(s1)
    8000327c:	dfd9                	beqz	a5,8000321a <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000327e:	865e                	mv	a2,s7
    80003280:	85d6                	mv	a1,s5
    80003282:	8552                	mv	a0,s4
    80003284:	00000097          	auipc	ra,0x0
    80003288:	e5c080e7          	jalr	-420(ra) # 800030e0 <dirlookup>
    8000328c:	89aa                	mv	s3,a0
    8000328e:	dd41                	beqz	a0,80003226 <namex+0x96>
    iunlockput(ip);
    80003290:	8552                	mv	a0,s4
    80003292:	00000097          	auipc	ra,0x0
    80003296:	bcc080e7          	jalr	-1076(ra) # 80002e5e <iunlockput>
    ip = next;
    8000329a:	8a4e                	mv	s4,s3
  while(*path == '/')
    8000329c:	0004c783          	lbu	a5,0(s1)
    800032a0:	01279763          	bne	a5,s2,800032ae <namex+0x11e>
    path++;
    800032a4:	0485                	addi	s1,s1,1
  while(*path == '/')
    800032a6:	0004c783          	lbu	a5,0(s1)
    800032aa:	ff278de3          	beq	a5,s2,800032a4 <namex+0x114>
  if(*path == 0)
    800032ae:	cb9d                	beqz	a5,800032e4 <namex+0x154>
  while(*path != '/' && *path != 0)
    800032b0:	0004c783          	lbu	a5,0(s1)
    800032b4:	89a6                	mv	s3,s1
  len = path - s;
    800032b6:	8d5e                	mv	s10,s7
    800032b8:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    800032ba:	01278963          	beq	a5,s2,800032cc <namex+0x13c>
    800032be:	dbbd                	beqz	a5,80003234 <namex+0xa4>
    path++;
    800032c0:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800032c2:	0009c783          	lbu	a5,0(s3)
    800032c6:	ff279ce3          	bne	a5,s2,800032be <namex+0x12e>
    800032ca:	b7ad                	j	80003234 <namex+0xa4>
    memmove(name, s, len);
    800032cc:	2601                	sext.w	a2,a2
    800032ce:	85a6                	mv	a1,s1
    800032d0:	8556                	mv	a0,s5
    800032d2:	ffffd097          	auipc	ra,0xffffd
    800032d6:	f04080e7          	jalr	-252(ra) # 800001d6 <memmove>
    name[len] = 0;
    800032da:	9d56                	add	s10,s10,s5
    800032dc:	000d0023          	sb	zero,0(s10)
    800032e0:	84ce                	mv	s1,s3
    800032e2:	b7bd                	j	80003250 <namex+0xc0>
  if(nameiparent){
    800032e4:	f00b0ce3          	beqz	s6,800031fc <namex+0x6c>
    iput(ip);
    800032e8:	8552                	mv	a0,s4
    800032ea:	00000097          	auipc	ra,0x0
    800032ee:	acc080e7          	jalr	-1332(ra) # 80002db6 <iput>
    return 0;
    800032f2:	4a01                	li	s4,0
    800032f4:	b721                	j	800031fc <namex+0x6c>

00000000800032f6 <dirlink>:
{
    800032f6:	7139                	addi	sp,sp,-64
    800032f8:	fc06                	sd	ra,56(sp)
    800032fa:	f822                	sd	s0,48(sp)
    800032fc:	f426                	sd	s1,40(sp)
    800032fe:	f04a                	sd	s2,32(sp)
    80003300:	ec4e                	sd	s3,24(sp)
    80003302:	e852                	sd	s4,16(sp)
    80003304:	0080                	addi	s0,sp,64
    80003306:	892a                	mv	s2,a0
    80003308:	8a2e                	mv	s4,a1
    8000330a:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000330c:	4601                	li	a2,0
    8000330e:	00000097          	auipc	ra,0x0
    80003312:	dd2080e7          	jalr	-558(ra) # 800030e0 <dirlookup>
    80003316:	e93d                	bnez	a0,8000338c <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003318:	04c92483          	lw	s1,76(s2)
    8000331c:	c49d                	beqz	s1,8000334a <dirlink+0x54>
    8000331e:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003320:	4741                	li	a4,16
    80003322:	86a6                	mv	a3,s1
    80003324:	fc040613          	addi	a2,s0,-64
    80003328:	4581                	li	a1,0
    8000332a:	854a                	mv	a0,s2
    8000332c:	00000097          	auipc	ra,0x0
    80003330:	b84080e7          	jalr	-1148(ra) # 80002eb0 <readi>
    80003334:	47c1                	li	a5,16
    80003336:	06f51163          	bne	a0,a5,80003398 <dirlink+0xa2>
    if(de.inum == 0)
    8000333a:	fc045783          	lhu	a5,-64(s0)
    8000333e:	c791                	beqz	a5,8000334a <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003340:	24c1                	addiw	s1,s1,16
    80003342:	04c92783          	lw	a5,76(s2)
    80003346:	fcf4ede3          	bltu	s1,a5,80003320 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000334a:	4639                	li	a2,14
    8000334c:	85d2                	mv	a1,s4
    8000334e:	fc240513          	addi	a0,s0,-62
    80003352:	ffffd097          	auipc	ra,0xffffd
    80003356:	f34080e7          	jalr	-204(ra) # 80000286 <strncpy>
  de.inum = inum;
    8000335a:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000335e:	4741                	li	a4,16
    80003360:	86a6                	mv	a3,s1
    80003362:	fc040613          	addi	a2,s0,-64
    80003366:	4581                	li	a1,0
    80003368:	854a                	mv	a0,s2
    8000336a:	00000097          	auipc	ra,0x0
    8000336e:	c3e080e7          	jalr	-962(ra) # 80002fa8 <writei>
    80003372:	872a                	mv	a4,a0
    80003374:	47c1                	li	a5,16
  return 0;
    80003376:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003378:	02f71863          	bne	a4,a5,800033a8 <dirlink+0xb2>
}
    8000337c:	70e2                	ld	ra,56(sp)
    8000337e:	7442                	ld	s0,48(sp)
    80003380:	74a2                	ld	s1,40(sp)
    80003382:	7902                	ld	s2,32(sp)
    80003384:	69e2                	ld	s3,24(sp)
    80003386:	6a42                	ld	s4,16(sp)
    80003388:	6121                	addi	sp,sp,64
    8000338a:	8082                	ret
    iput(ip);
    8000338c:	00000097          	auipc	ra,0x0
    80003390:	a2a080e7          	jalr	-1494(ra) # 80002db6 <iput>
    return -1;
    80003394:	557d                	li	a0,-1
    80003396:	b7dd                	j	8000337c <dirlink+0x86>
      panic("dirlink read");
    80003398:	00005517          	auipc	a0,0x5
    8000339c:	1d050513          	addi	a0,a0,464 # 80008568 <syscalls+0x1d8>
    800033a0:	00003097          	auipc	ra,0x3
    800033a4:	c70080e7          	jalr	-912(ra) # 80006010 <panic>
    panic("dirlink");
    800033a8:	00005517          	auipc	a0,0x5
    800033ac:	2d050513          	addi	a0,a0,720 # 80008678 <syscalls+0x2e8>
    800033b0:	00003097          	auipc	ra,0x3
    800033b4:	c60080e7          	jalr	-928(ra) # 80006010 <panic>

00000000800033b8 <namei>:

struct inode*
namei(char *path)
{
    800033b8:	1101                	addi	sp,sp,-32
    800033ba:	ec06                	sd	ra,24(sp)
    800033bc:	e822                	sd	s0,16(sp)
    800033be:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800033c0:	fe040613          	addi	a2,s0,-32
    800033c4:	4581                	li	a1,0
    800033c6:	00000097          	auipc	ra,0x0
    800033ca:	dca080e7          	jalr	-566(ra) # 80003190 <namex>
}
    800033ce:	60e2                	ld	ra,24(sp)
    800033d0:	6442                	ld	s0,16(sp)
    800033d2:	6105                	addi	sp,sp,32
    800033d4:	8082                	ret

00000000800033d6 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800033d6:	1141                	addi	sp,sp,-16
    800033d8:	e406                	sd	ra,8(sp)
    800033da:	e022                	sd	s0,0(sp)
    800033dc:	0800                	addi	s0,sp,16
    800033de:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800033e0:	4585                	li	a1,1
    800033e2:	00000097          	auipc	ra,0x0
    800033e6:	dae080e7          	jalr	-594(ra) # 80003190 <namex>
}
    800033ea:	60a2                	ld	ra,8(sp)
    800033ec:	6402                	ld	s0,0(sp)
    800033ee:	0141                	addi	sp,sp,16
    800033f0:	8082                	ret

00000000800033f2 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800033f2:	1101                	addi	sp,sp,-32
    800033f4:	ec06                	sd	ra,24(sp)
    800033f6:	e822                	sd	s0,16(sp)
    800033f8:	e426                	sd	s1,8(sp)
    800033fa:	e04a                	sd	s2,0(sp)
    800033fc:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800033fe:	00022917          	auipc	s2,0x22
    80003402:	c2290913          	addi	s2,s2,-990 # 80025020 <log>
    80003406:	01892583          	lw	a1,24(s2)
    8000340a:	02892503          	lw	a0,40(s2)
    8000340e:	fffff097          	auipc	ra,0xfffff
    80003412:	fec080e7          	jalr	-20(ra) # 800023fa <bread>
    80003416:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003418:	02c92683          	lw	a3,44(s2)
    8000341c:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000341e:	02d05863          	blez	a3,8000344e <write_head+0x5c>
    80003422:	00022797          	auipc	a5,0x22
    80003426:	c2e78793          	addi	a5,a5,-978 # 80025050 <log+0x30>
    8000342a:	05c50713          	addi	a4,a0,92
    8000342e:	36fd                	addiw	a3,a3,-1
    80003430:	02069613          	slli	a2,a3,0x20
    80003434:	01e65693          	srli	a3,a2,0x1e
    80003438:	00022617          	auipc	a2,0x22
    8000343c:	c1c60613          	addi	a2,a2,-996 # 80025054 <log+0x34>
    80003440:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003442:	4390                	lw	a2,0(a5)
    80003444:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003446:	0791                	addi	a5,a5,4
    80003448:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    8000344a:	fed79ce3          	bne	a5,a3,80003442 <write_head+0x50>
  }
  bwrite(buf);
    8000344e:	8526                	mv	a0,s1
    80003450:	fffff097          	auipc	ra,0xfffff
    80003454:	09c080e7          	jalr	156(ra) # 800024ec <bwrite>
  brelse(buf);
    80003458:	8526                	mv	a0,s1
    8000345a:	fffff097          	auipc	ra,0xfffff
    8000345e:	0d0080e7          	jalr	208(ra) # 8000252a <brelse>
}
    80003462:	60e2                	ld	ra,24(sp)
    80003464:	6442                	ld	s0,16(sp)
    80003466:	64a2                	ld	s1,8(sp)
    80003468:	6902                	ld	s2,0(sp)
    8000346a:	6105                	addi	sp,sp,32
    8000346c:	8082                	ret

000000008000346e <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000346e:	00022797          	auipc	a5,0x22
    80003472:	bde7a783          	lw	a5,-1058(a5) # 8002504c <log+0x2c>
    80003476:	0af05d63          	blez	a5,80003530 <install_trans+0xc2>
{
    8000347a:	7139                	addi	sp,sp,-64
    8000347c:	fc06                	sd	ra,56(sp)
    8000347e:	f822                	sd	s0,48(sp)
    80003480:	f426                	sd	s1,40(sp)
    80003482:	f04a                	sd	s2,32(sp)
    80003484:	ec4e                	sd	s3,24(sp)
    80003486:	e852                	sd	s4,16(sp)
    80003488:	e456                	sd	s5,8(sp)
    8000348a:	e05a                	sd	s6,0(sp)
    8000348c:	0080                	addi	s0,sp,64
    8000348e:	8b2a                	mv	s6,a0
    80003490:	00022a97          	auipc	s5,0x22
    80003494:	bc0a8a93          	addi	s5,s5,-1088 # 80025050 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003498:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000349a:	00022997          	auipc	s3,0x22
    8000349e:	b8698993          	addi	s3,s3,-1146 # 80025020 <log>
    800034a2:	a00d                	j	800034c4 <install_trans+0x56>
    brelse(lbuf);
    800034a4:	854a                	mv	a0,s2
    800034a6:	fffff097          	auipc	ra,0xfffff
    800034aa:	084080e7          	jalr	132(ra) # 8000252a <brelse>
    brelse(dbuf);
    800034ae:	8526                	mv	a0,s1
    800034b0:	fffff097          	auipc	ra,0xfffff
    800034b4:	07a080e7          	jalr	122(ra) # 8000252a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034b8:	2a05                	addiw	s4,s4,1
    800034ba:	0a91                	addi	s5,s5,4
    800034bc:	02c9a783          	lw	a5,44(s3)
    800034c0:	04fa5e63          	bge	s4,a5,8000351c <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034c4:	0189a583          	lw	a1,24(s3)
    800034c8:	014585bb          	addw	a1,a1,s4
    800034cc:	2585                	addiw	a1,a1,1
    800034ce:	0289a503          	lw	a0,40(s3)
    800034d2:	fffff097          	auipc	ra,0xfffff
    800034d6:	f28080e7          	jalr	-216(ra) # 800023fa <bread>
    800034da:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800034dc:	000aa583          	lw	a1,0(s5)
    800034e0:	0289a503          	lw	a0,40(s3)
    800034e4:	fffff097          	auipc	ra,0xfffff
    800034e8:	f16080e7          	jalr	-234(ra) # 800023fa <bread>
    800034ec:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800034ee:	40000613          	li	a2,1024
    800034f2:	05890593          	addi	a1,s2,88
    800034f6:	05850513          	addi	a0,a0,88
    800034fa:	ffffd097          	auipc	ra,0xffffd
    800034fe:	cdc080e7          	jalr	-804(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003502:	8526                	mv	a0,s1
    80003504:	fffff097          	auipc	ra,0xfffff
    80003508:	fe8080e7          	jalr	-24(ra) # 800024ec <bwrite>
    if(recovering == 0)
    8000350c:	f80b1ce3          	bnez	s6,800034a4 <install_trans+0x36>
      bunpin(dbuf);
    80003510:	8526                	mv	a0,s1
    80003512:	fffff097          	auipc	ra,0xfffff
    80003516:	0f2080e7          	jalr	242(ra) # 80002604 <bunpin>
    8000351a:	b769                	j	800034a4 <install_trans+0x36>
}
    8000351c:	70e2                	ld	ra,56(sp)
    8000351e:	7442                	ld	s0,48(sp)
    80003520:	74a2                	ld	s1,40(sp)
    80003522:	7902                	ld	s2,32(sp)
    80003524:	69e2                	ld	s3,24(sp)
    80003526:	6a42                	ld	s4,16(sp)
    80003528:	6aa2                	ld	s5,8(sp)
    8000352a:	6b02                	ld	s6,0(sp)
    8000352c:	6121                	addi	sp,sp,64
    8000352e:	8082                	ret
    80003530:	8082                	ret

0000000080003532 <initlog>:
{
    80003532:	7179                	addi	sp,sp,-48
    80003534:	f406                	sd	ra,40(sp)
    80003536:	f022                	sd	s0,32(sp)
    80003538:	ec26                	sd	s1,24(sp)
    8000353a:	e84a                	sd	s2,16(sp)
    8000353c:	e44e                	sd	s3,8(sp)
    8000353e:	1800                	addi	s0,sp,48
    80003540:	892a                	mv	s2,a0
    80003542:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003544:	00022497          	auipc	s1,0x22
    80003548:	adc48493          	addi	s1,s1,-1316 # 80025020 <log>
    8000354c:	00005597          	auipc	a1,0x5
    80003550:	02c58593          	addi	a1,a1,44 # 80008578 <syscalls+0x1e8>
    80003554:	8526                	mv	a0,s1
    80003556:	00003097          	auipc	ra,0x3
    8000355a:	f62080e7          	jalr	-158(ra) # 800064b8 <initlock>
  log.start = sb->logstart;
    8000355e:	0149a583          	lw	a1,20(s3)
    80003562:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003564:	0109a783          	lw	a5,16(s3)
    80003568:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000356a:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000356e:	854a                	mv	a0,s2
    80003570:	fffff097          	auipc	ra,0xfffff
    80003574:	e8a080e7          	jalr	-374(ra) # 800023fa <bread>
  log.lh.n = lh->n;
    80003578:	4d34                	lw	a3,88(a0)
    8000357a:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000357c:	02d05663          	blez	a3,800035a8 <initlog+0x76>
    80003580:	05c50793          	addi	a5,a0,92
    80003584:	00022717          	auipc	a4,0x22
    80003588:	acc70713          	addi	a4,a4,-1332 # 80025050 <log+0x30>
    8000358c:	36fd                	addiw	a3,a3,-1
    8000358e:	02069613          	slli	a2,a3,0x20
    80003592:	01e65693          	srli	a3,a2,0x1e
    80003596:	06050613          	addi	a2,a0,96
    8000359a:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    8000359c:	4390                	lw	a2,0(a5)
    8000359e:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800035a0:	0791                	addi	a5,a5,4
    800035a2:	0711                	addi	a4,a4,4
    800035a4:	fed79ce3          	bne	a5,a3,8000359c <initlog+0x6a>
  brelse(buf);
    800035a8:	fffff097          	auipc	ra,0xfffff
    800035ac:	f82080e7          	jalr	-126(ra) # 8000252a <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800035b0:	4505                	li	a0,1
    800035b2:	00000097          	auipc	ra,0x0
    800035b6:	ebc080e7          	jalr	-324(ra) # 8000346e <install_trans>
  log.lh.n = 0;
    800035ba:	00022797          	auipc	a5,0x22
    800035be:	a807a923          	sw	zero,-1390(a5) # 8002504c <log+0x2c>
  write_head(); // clear the log
    800035c2:	00000097          	auipc	ra,0x0
    800035c6:	e30080e7          	jalr	-464(ra) # 800033f2 <write_head>
}
    800035ca:	70a2                	ld	ra,40(sp)
    800035cc:	7402                	ld	s0,32(sp)
    800035ce:	64e2                	ld	s1,24(sp)
    800035d0:	6942                	ld	s2,16(sp)
    800035d2:	69a2                	ld	s3,8(sp)
    800035d4:	6145                	addi	sp,sp,48
    800035d6:	8082                	ret

00000000800035d8 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800035d8:	1101                	addi	sp,sp,-32
    800035da:	ec06                	sd	ra,24(sp)
    800035dc:	e822                	sd	s0,16(sp)
    800035de:	e426                	sd	s1,8(sp)
    800035e0:	e04a                	sd	s2,0(sp)
    800035e2:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800035e4:	00022517          	auipc	a0,0x22
    800035e8:	a3c50513          	addi	a0,a0,-1476 # 80025020 <log>
    800035ec:	00003097          	auipc	ra,0x3
    800035f0:	f5c080e7          	jalr	-164(ra) # 80006548 <acquire>
  while(1){
    if(log.committing){
    800035f4:	00022497          	auipc	s1,0x22
    800035f8:	a2c48493          	addi	s1,s1,-1492 # 80025020 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035fc:	4979                	li	s2,30
    800035fe:	a039                	j	8000360c <begin_op+0x34>
      sleep(&log, &log.lock);
    80003600:	85a6                	mv	a1,s1
    80003602:	8526                	mv	a0,s1
    80003604:	ffffe097          	auipc	ra,0xffffe
    80003608:	f28080e7          	jalr	-216(ra) # 8000152c <sleep>
    if(log.committing){
    8000360c:	50dc                	lw	a5,36(s1)
    8000360e:	fbed                	bnez	a5,80003600 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003610:	5098                	lw	a4,32(s1)
    80003612:	2705                	addiw	a4,a4,1
    80003614:	0007069b          	sext.w	a3,a4
    80003618:	0027179b          	slliw	a5,a4,0x2
    8000361c:	9fb9                	addw	a5,a5,a4
    8000361e:	0017979b          	slliw	a5,a5,0x1
    80003622:	54d8                	lw	a4,44(s1)
    80003624:	9fb9                	addw	a5,a5,a4
    80003626:	00f95963          	bge	s2,a5,80003638 <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000362a:	85a6                	mv	a1,s1
    8000362c:	8526                	mv	a0,s1
    8000362e:	ffffe097          	auipc	ra,0xffffe
    80003632:	efe080e7          	jalr	-258(ra) # 8000152c <sleep>
    80003636:	bfd9                	j	8000360c <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003638:	00022517          	auipc	a0,0x22
    8000363c:	9e850513          	addi	a0,a0,-1560 # 80025020 <log>
    80003640:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003642:	00003097          	auipc	ra,0x3
    80003646:	fba080e7          	jalr	-70(ra) # 800065fc <release>
      break;
    }
  }
}
    8000364a:	60e2                	ld	ra,24(sp)
    8000364c:	6442                	ld	s0,16(sp)
    8000364e:	64a2                	ld	s1,8(sp)
    80003650:	6902                	ld	s2,0(sp)
    80003652:	6105                	addi	sp,sp,32
    80003654:	8082                	ret

0000000080003656 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003656:	7139                	addi	sp,sp,-64
    80003658:	fc06                	sd	ra,56(sp)
    8000365a:	f822                	sd	s0,48(sp)
    8000365c:	f426                	sd	s1,40(sp)
    8000365e:	f04a                	sd	s2,32(sp)
    80003660:	ec4e                	sd	s3,24(sp)
    80003662:	e852                	sd	s4,16(sp)
    80003664:	e456                	sd	s5,8(sp)
    80003666:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003668:	00022497          	auipc	s1,0x22
    8000366c:	9b848493          	addi	s1,s1,-1608 # 80025020 <log>
    80003670:	8526                	mv	a0,s1
    80003672:	00003097          	auipc	ra,0x3
    80003676:	ed6080e7          	jalr	-298(ra) # 80006548 <acquire>
  log.outstanding -= 1;
    8000367a:	509c                	lw	a5,32(s1)
    8000367c:	37fd                	addiw	a5,a5,-1
    8000367e:	0007891b          	sext.w	s2,a5
    80003682:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003684:	50dc                	lw	a5,36(s1)
    80003686:	e7b9                	bnez	a5,800036d4 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003688:	04091e63          	bnez	s2,800036e4 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    8000368c:	00022497          	auipc	s1,0x22
    80003690:	99448493          	addi	s1,s1,-1644 # 80025020 <log>
    80003694:	4785                	li	a5,1
    80003696:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003698:	8526                	mv	a0,s1
    8000369a:	00003097          	auipc	ra,0x3
    8000369e:	f62080e7          	jalr	-158(ra) # 800065fc <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800036a2:	54dc                	lw	a5,44(s1)
    800036a4:	06f04763          	bgtz	a5,80003712 <end_op+0xbc>
    acquire(&log.lock);
    800036a8:	00022497          	auipc	s1,0x22
    800036ac:	97848493          	addi	s1,s1,-1672 # 80025020 <log>
    800036b0:	8526                	mv	a0,s1
    800036b2:	00003097          	auipc	ra,0x3
    800036b6:	e96080e7          	jalr	-362(ra) # 80006548 <acquire>
    log.committing = 0;
    800036ba:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800036be:	8526                	mv	a0,s1
    800036c0:	ffffe097          	auipc	ra,0xffffe
    800036c4:	ff8080e7          	jalr	-8(ra) # 800016b8 <wakeup>
    release(&log.lock);
    800036c8:	8526                	mv	a0,s1
    800036ca:	00003097          	auipc	ra,0x3
    800036ce:	f32080e7          	jalr	-206(ra) # 800065fc <release>
}
    800036d2:	a03d                	j	80003700 <end_op+0xaa>
    panic("log.committing");
    800036d4:	00005517          	auipc	a0,0x5
    800036d8:	eac50513          	addi	a0,a0,-340 # 80008580 <syscalls+0x1f0>
    800036dc:	00003097          	auipc	ra,0x3
    800036e0:	934080e7          	jalr	-1740(ra) # 80006010 <panic>
    wakeup(&log);
    800036e4:	00022497          	auipc	s1,0x22
    800036e8:	93c48493          	addi	s1,s1,-1732 # 80025020 <log>
    800036ec:	8526                	mv	a0,s1
    800036ee:	ffffe097          	auipc	ra,0xffffe
    800036f2:	fca080e7          	jalr	-54(ra) # 800016b8 <wakeup>
  release(&log.lock);
    800036f6:	8526                	mv	a0,s1
    800036f8:	00003097          	auipc	ra,0x3
    800036fc:	f04080e7          	jalr	-252(ra) # 800065fc <release>
}
    80003700:	70e2                	ld	ra,56(sp)
    80003702:	7442                	ld	s0,48(sp)
    80003704:	74a2                	ld	s1,40(sp)
    80003706:	7902                	ld	s2,32(sp)
    80003708:	69e2                	ld	s3,24(sp)
    8000370a:	6a42                	ld	s4,16(sp)
    8000370c:	6aa2                	ld	s5,8(sp)
    8000370e:	6121                	addi	sp,sp,64
    80003710:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80003712:	00022a97          	auipc	s5,0x22
    80003716:	93ea8a93          	addi	s5,s5,-1730 # 80025050 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000371a:	00022a17          	auipc	s4,0x22
    8000371e:	906a0a13          	addi	s4,s4,-1786 # 80025020 <log>
    80003722:	018a2583          	lw	a1,24(s4)
    80003726:	012585bb          	addw	a1,a1,s2
    8000372a:	2585                	addiw	a1,a1,1
    8000372c:	028a2503          	lw	a0,40(s4)
    80003730:	fffff097          	auipc	ra,0xfffff
    80003734:	cca080e7          	jalr	-822(ra) # 800023fa <bread>
    80003738:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000373a:	000aa583          	lw	a1,0(s5)
    8000373e:	028a2503          	lw	a0,40(s4)
    80003742:	fffff097          	auipc	ra,0xfffff
    80003746:	cb8080e7          	jalr	-840(ra) # 800023fa <bread>
    8000374a:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000374c:	40000613          	li	a2,1024
    80003750:	05850593          	addi	a1,a0,88
    80003754:	05848513          	addi	a0,s1,88
    80003758:	ffffd097          	auipc	ra,0xffffd
    8000375c:	a7e080e7          	jalr	-1410(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    80003760:	8526                	mv	a0,s1
    80003762:	fffff097          	auipc	ra,0xfffff
    80003766:	d8a080e7          	jalr	-630(ra) # 800024ec <bwrite>
    brelse(from);
    8000376a:	854e                	mv	a0,s3
    8000376c:	fffff097          	auipc	ra,0xfffff
    80003770:	dbe080e7          	jalr	-578(ra) # 8000252a <brelse>
    brelse(to);
    80003774:	8526                	mv	a0,s1
    80003776:	fffff097          	auipc	ra,0xfffff
    8000377a:	db4080e7          	jalr	-588(ra) # 8000252a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000377e:	2905                	addiw	s2,s2,1
    80003780:	0a91                	addi	s5,s5,4
    80003782:	02ca2783          	lw	a5,44(s4)
    80003786:	f8f94ee3          	blt	s2,a5,80003722 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000378a:	00000097          	auipc	ra,0x0
    8000378e:	c68080e7          	jalr	-920(ra) # 800033f2 <write_head>
    install_trans(0); // Now install writes to home locations
    80003792:	4501                	li	a0,0
    80003794:	00000097          	auipc	ra,0x0
    80003798:	cda080e7          	jalr	-806(ra) # 8000346e <install_trans>
    log.lh.n = 0;
    8000379c:	00022797          	auipc	a5,0x22
    800037a0:	8a07a823          	sw	zero,-1872(a5) # 8002504c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800037a4:	00000097          	auipc	ra,0x0
    800037a8:	c4e080e7          	jalr	-946(ra) # 800033f2 <write_head>
    800037ac:	bdf5                	j	800036a8 <end_op+0x52>

00000000800037ae <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800037ae:	1101                	addi	sp,sp,-32
    800037b0:	ec06                	sd	ra,24(sp)
    800037b2:	e822                	sd	s0,16(sp)
    800037b4:	e426                	sd	s1,8(sp)
    800037b6:	e04a                	sd	s2,0(sp)
    800037b8:	1000                	addi	s0,sp,32
    800037ba:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800037bc:	00022917          	auipc	s2,0x22
    800037c0:	86490913          	addi	s2,s2,-1948 # 80025020 <log>
    800037c4:	854a                	mv	a0,s2
    800037c6:	00003097          	auipc	ra,0x3
    800037ca:	d82080e7          	jalr	-638(ra) # 80006548 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800037ce:	02c92603          	lw	a2,44(s2)
    800037d2:	47f5                	li	a5,29
    800037d4:	06c7c563          	blt	a5,a2,8000383e <log_write+0x90>
    800037d8:	00022797          	auipc	a5,0x22
    800037dc:	8647a783          	lw	a5,-1948(a5) # 8002503c <log+0x1c>
    800037e0:	37fd                	addiw	a5,a5,-1
    800037e2:	04f65e63          	bge	a2,a5,8000383e <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800037e6:	00022797          	auipc	a5,0x22
    800037ea:	85a7a783          	lw	a5,-1958(a5) # 80025040 <log+0x20>
    800037ee:	06f05063          	blez	a5,8000384e <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800037f2:	4781                	li	a5,0
    800037f4:	06c05563          	blez	a2,8000385e <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037f8:	44cc                	lw	a1,12(s1)
    800037fa:	00022717          	auipc	a4,0x22
    800037fe:	85670713          	addi	a4,a4,-1962 # 80025050 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003802:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003804:	4314                	lw	a3,0(a4)
    80003806:	04b68c63          	beq	a3,a1,8000385e <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000380a:	2785                	addiw	a5,a5,1
    8000380c:	0711                	addi	a4,a4,4
    8000380e:	fef61be3          	bne	a2,a5,80003804 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003812:	0621                	addi	a2,a2,8
    80003814:	060a                	slli	a2,a2,0x2
    80003816:	00022797          	auipc	a5,0x22
    8000381a:	80a78793          	addi	a5,a5,-2038 # 80025020 <log>
    8000381e:	97b2                	add	a5,a5,a2
    80003820:	44d8                	lw	a4,12(s1)
    80003822:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003824:	8526                	mv	a0,s1
    80003826:	fffff097          	auipc	ra,0xfffff
    8000382a:	da2080e7          	jalr	-606(ra) # 800025c8 <bpin>
    log.lh.n++;
    8000382e:	00021717          	auipc	a4,0x21
    80003832:	7f270713          	addi	a4,a4,2034 # 80025020 <log>
    80003836:	575c                	lw	a5,44(a4)
    80003838:	2785                	addiw	a5,a5,1
    8000383a:	d75c                	sw	a5,44(a4)
    8000383c:	a82d                	j	80003876 <log_write+0xc8>
    panic("too big a transaction");
    8000383e:	00005517          	auipc	a0,0x5
    80003842:	d5250513          	addi	a0,a0,-686 # 80008590 <syscalls+0x200>
    80003846:	00002097          	auipc	ra,0x2
    8000384a:	7ca080e7          	jalr	1994(ra) # 80006010 <panic>
    panic("log_write outside of trans");
    8000384e:	00005517          	auipc	a0,0x5
    80003852:	d5a50513          	addi	a0,a0,-678 # 800085a8 <syscalls+0x218>
    80003856:	00002097          	auipc	ra,0x2
    8000385a:	7ba080e7          	jalr	1978(ra) # 80006010 <panic>
  log.lh.block[i] = b->blockno;
    8000385e:	00878693          	addi	a3,a5,8
    80003862:	068a                	slli	a3,a3,0x2
    80003864:	00021717          	auipc	a4,0x21
    80003868:	7bc70713          	addi	a4,a4,1980 # 80025020 <log>
    8000386c:	9736                	add	a4,a4,a3
    8000386e:	44d4                	lw	a3,12(s1)
    80003870:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003872:	faf609e3          	beq	a2,a5,80003824 <log_write+0x76>
  }
  release(&log.lock);
    80003876:	00021517          	auipc	a0,0x21
    8000387a:	7aa50513          	addi	a0,a0,1962 # 80025020 <log>
    8000387e:	00003097          	auipc	ra,0x3
    80003882:	d7e080e7          	jalr	-642(ra) # 800065fc <release>
}
    80003886:	60e2                	ld	ra,24(sp)
    80003888:	6442                	ld	s0,16(sp)
    8000388a:	64a2                	ld	s1,8(sp)
    8000388c:	6902                	ld	s2,0(sp)
    8000388e:	6105                	addi	sp,sp,32
    80003890:	8082                	ret

0000000080003892 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003892:	1101                	addi	sp,sp,-32
    80003894:	ec06                	sd	ra,24(sp)
    80003896:	e822                	sd	s0,16(sp)
    80003898:	e426                	sd	s1,8(sp)
    8000389a:	e04a                	sd	s2,0(sp)
    8000389c:	1000                	addi	s0,sp,32
    8000389e:	84aa                	mv	s1,a0
    800038a0:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800038a2:	00005597          	auipc	a1,0x5
    800038a6:	d2658593          	addi	a1,a1,-730 # 800085c8 <syscalls+0x238>
    800038aa:	0521                	addi	a0,a0,8
    800038ac:	00003097          	auipc	ra,0x3
    800038b0:	c0c080e7          	jalr	-1012(ra) # 800064b8 <initlock>
  lk->name = name;
    800038b4:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800038b8:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038bc:	0204a423          	sw	zero,40(s1)
}
    800038c0:	60e2                	ld	ra,24(sp)
    800038c2:	6442                	ld	s0,16(sp)
    800038c4:	64a2                	ld	s1,8(sp)
    800038c6:	6902                	ld	s2,0(sp)
    800038c8:	6105                	addi	sp,sp,32
    800038ca:	8082                	ret

00000000800038cc <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800038cc:	1101                	addi	sp,sp,-32
    800038ce:	ec06                	sd	ra,24(sp)
    800038d0:	e822                	sd	s0,16(sp)
    800038d2:	e426                	sd	s1,8(sp)
    800038d4:	e04a                	sd	s2,0(sp)
    800038d6:	1000                	addi	s0,sp,32
    800038d8:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038da:	00850913          	addi	s2,a0,8
    800038de:	854a                	mv	a0,s2
    800038e0:	00003097          	auipc	ra,0x3
    800038e4:	c68080e7          	jalr	-920(ra) # 80006548 <acquire>
  while (lk->locked) {
    800038e8:	409c                	lw	a5,0(s1)
    800038ea:	cb89                	beqz	a5,800038fc <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800038ec:	85ca                	mv	a1,s2
    800038ee:	8526                	mv	a0,s1
    800038f0:	ffffe097          	auipc	ra,0xffffe
    800038f4:	c3c080e7          	jalr	-964(ra) # 8000152c <sleep>
  while (lk->locked) {
    800038f8:	409c                	lw	a5,0(s1)
    800038fa:	fbed                	bnez	a5,800038ec <acquiresleep+0x20>
  }
  lk->locked = 1;
    800038fc:	4785                	li	a5,1
    800038fe:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003900:	ffffd097          	auipc	ra,0xffffd
    80003904:	52a080e7          	jalr	1322(ra) # 80000e2a <myproc>
    80003908:	591c                	lw	a5,48(a0)
    8000390a:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000390c:	854a                	mv	a0,s2
    8000390e:	00003097          	auipc	ra,0x3
    80003912:	cee080e7          	jalr	-786(ra) # 800065fc <release>
}
    80003916:	60e2                	ld	ra,24(sp)
    80003918:	6442                	ld	s0,16(sp)
    8000391a:	64a2                	ld	s1,8(sp)
    8000391c:	6902                	ld	s2,0(sp)
    8000391e:	6105                	addi	sp,sp,32
    80003920:	8082                	ret

0000000080003922 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003922:	1101                	addi	sp,sp,-32
    80003924:	ec06                	sd	ra,24(sp)
    80003926:	e822                	sd	s0,16(sp)
    80003928:	e426                	sd	s1,8(sp)
    8000392a:	e04a                	sd	s2,0(sp)
    8000392c:	1000                	addi	s0,sp,32
    8000392e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003930:	00850913          	addi	s2,a0,8
    80003934:	854a                	mv	a0,s2
    80003936:	00003097          	auipc	ra,0x3
    8000393a:	c12080e7          	jalr	-1006(ra) # 80006548 <acquire>
  lk->locked = 0;
    8000393e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003942:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003946:	8526                	mv	a0,s1
    80003948:	ffffe097          	auipc	ra,0xffffe
    8000394c:	d70080e7          	jalr	-656(ra) # 800016b8 <wakeup>
  release(&lk->lk);
    80003950:	854a                	mv	a0,s2
    80003952:	00003097          	auipc	ra,0x3
    80003956:	caa080e7          	jalr	-854(ra) # 800065fc <release>
}
    8000395a:	60e2                	ld	ra,24(sp)
    8000395c:	6442                	ld	s0,16(sp)
    8000395e:	64a2                	ld	s1,8(sp)
    80003960:	6902                	ld	s2,0(sp)
    80003962:	6105                	addi	sp,sp,32
    80003964:	8082                	ret

0000000080003966 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003966:	7179                	addi	sp,sp,-48
    80003968:	f406                	sd	ra,40(sp)
    8000396a:	f022                	sd	s0,32(sp)
    8000396c:	ec26                	sd	s1,24(sp)
    8000396e:	e84a                	sd	s2,16(sp)
    80003970:	e44e                	sd	s3,8(sp)
    80003972:	1800                	addi	s0,sp,48
    80003974:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003976:	00850913          	addi	s2,a0,8
    8000397a:	854a                	mv	a0,s2
    8000397c:	00003097          	auipc	ra,0x3
    80003980:	bcc080e7          	jalr	-1076(ra) # 80006548 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003984:	409c                	lw	a5,0(s1)
    80003986:	ef99                	bnez	a5,800039a4 <holdingsleep+0x3e>
    80003988:	4481                	li	s1,0
  release(&lk->lk);
    8000398a:	854a                	mv	a0,s2
    8000398c:	00003097          	auipc	ra,0x3
    80003990:	c70080e7          	jalr	-912(ra) # 800065fc <release>
  return r;
}
    80003994:	8526                	mv	a0,s1
    80003996:	70a2                	ld	ra,40(sp)
    80003998:	7402                	ld	s0,32(sp)
    8000399a:	64e2                	ld	s1,24(sp)
    8000399c:	6942                	ld	s2,16(sp)
    8000399e:	69a2                	ld	s3,8(sp)
    800039a0:	6145                	addi	sp,sp,48
    800039a2:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800039a4:	0284a983          	lw	s3,40(s1)
    800039a8:	ffffd097          	auipc	ra,0xffffd
    800039ac:	482080e7          	jalr	1154(ra) # 80000e2a <myproc>
    800039b0:	5904                	lw	s1,48(a0)
    800039b2:	413484b3          	sub	s1,s1,s3
    800039b6:	0014b493          	seqz	s1,s1
    800039ba:	bfc1                	j	8000398a <holdingsleep+0x24>

00000000800039bc <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800039bc:	1141                	addi	sp,sp,-16
    800039be:	e406                	sd	ra,8(sp)
    800039c0:	e022                	sd	s0,0(sp)
    800039c2:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800039c4:	00005597          	auipc	a1,0x5
    800039c8:	c1458593          	addi	a1,a1,-1004 # 800085d8 <syscalls+0x248>
    800039cc:	00021517          	auipc	a0,0x21
    800039d0:	79c50513          	addi	a0,a0,1948 # 80025168 <ftable>
    800039d4:	00003097          	auipc	ra,0x3
    800039d8:	ae4080e7          	jalr	-1308(ra) # 800064b8 <initlock>
}
    800039dc:	60a2                	ld	ra,8(sp)
    800039de:	6402                	ld	s0,0(sp)
    800039e0:	0141                	addi	sp,sp,16
    800039e2:	8082                	ret

00000000800039e4 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800039e4:	1101                	addi	sp,sp,-32
    800039e6:	ec06                	sd	ra,24(sp)
    800039e8:	e822                	sd	s0,16(sp)
    800039ea:	e426                	sd	s1,8(sp)
    800039ec:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800039ee:	00021517          	auipc	a0,0x21
    800039f2:	77a50513          	addi	a0,a0,1914 # 80025168 <ftable>
    800039f6:	00003097          	auipc	ra,0x3
    800039fa:	b52080e7          	jalr	-1198(ra) # 80006548 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039fe:	00021497          	auipc	s1,0x21
    80003a02:	78248493          	addi	s1,s1,1922 # 80025180 <ftable+0x18>
    80003a06:	00022717          	auipc	a4,0x22
    80003a0a:	71a70713          	addi	a4,a4,1818 # 80026120 <ftable+0xfb8>
    if(f->ref == 0){
    80003a0e:	40dc                	lw	a5,4(s1)
    80003a10:	cf99                	beqz	a5,80003a2e <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a12:	02848493          	addi	s1,s1,40
    80003a16:	fee49ce3          	bne	s1,a4,80003a0e <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003a1a:	00021517          	auipc	a0,0x21
    80003a1e:	74e50513          	addi	a0,a0,1870 # 80025168 <ftable>
    80003a22:	00003097          	auipc	ra,0x3
    80003a26:	bda080e7          	jalr	-1062(ra) # 800065fc <release>
  return 0;
    80003a2a:	4481                	li	s1,0
    80003a2c:	a819                	j	80003a42 <filealloc+0x5e>
      f->ref = 1;
    80003a2e:	4785                	li	a5,1
    80003a30:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003a32:	00021517          	auipc	a0,0x21
    80003a36:	73650513          	addi	a0,a0,1846 # 80025168 <ftable>
    80003a3a:	00003097          	auipc	ra,0x3
    80003a3e:	bc2080e7          	jalr	-1086(ra) # 800065fc <release>
}
    80003a42:	8526                	mv	a0,s1
    80003a44:	60e2                	ld	ra,24(sp)
    80003a46:	6442                	ld	s0,16(sp)
    80003a48:	64a2                	ld	s1,8(sp)
    80003a4a:	6105                	addi	sp,sp,32
    80003a4c:	8082                	ret

0000000080003a4e <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003a4e:	1101                	addi	sp,sp,-32
    80003a50:	ec06                	sd	ra,24(sp)
    80003a52:	e822                	sd	s0,16(sp)
    80003a54:	e426                	sd	s1,8(sp)
    80003a56:	1000                	addi	s0,sp,32
    80003a58:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a5a:	00021517          	auipc	a0,0x21
    80003a5e:	70e50513          	addi	a0,a0,1806 # 80025168 <ftable>
    80003a62:	00003097          	auipc	ra,0x3
    80003a66:	ae6080e7          	jalr	-1306(ra) # 80006548 <acquire>
  if(f->ref < 1)
    80003a6a:	40dc                	lw	a5,4(s1)
    80003a6c:	02f05263          	blez	a5,80003a90 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a70:	2785                	addiw	a5,a5,1
    80003a72:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a74:	00021517          	auipc	a0,0x21
    80003a78:	6f450513          	addi	a0,a0,1780 # 80025168 <ftable>
    80003a7c:	00003097          	auipc	ra,0x3
    80003a80:	b80080e7          	jalr	-1152(ra) # 800065fc <release>
  return f;
}
    80003a84:	8526                	mv	a0,s1
    80003a86:	60e2                	ld	ra,24(sp)
    80003a88:	6442                	ld	s0,16(sp)
    80003a8a:	64a2                	ld	s1,8(sp)
    80003a8c:	6105                	addi	sp,sp,32
    80003a8e:	8082                	ret
    panic("filedup");
    80003a90:	00005517          	auipc	a0,0x5
    80003a94:	b5050513          	addi	a0,a0,-1200 # 800085e0 <syscalls+0x250>
    80003a98:	00002097          	auipc	ra,0x2
    80003a9c:	578080e7          	jalr	1400(ra) # 80006010 <panic>

0000000080003aa0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003aa0:	7139                	addi	sp,sp,-64
    80003aa2:	fc06                	sd	ra,56(sp)
    80003aa4:	f822                	sd	s0,48(sp)
    80003aa6:	f426                	sd	s1,40(sp)
    80003aa8:	f04a                	sd	s2,32(sp)
    80003aaa:	ec4e                	sd	s3,24(sp)
    80003aac:	e852                	sd	s4,16(sp)
    80003aae:	e456                	sd	s5,8(sp)
    80003ab0:	0080                	addi	s0,sp,64
    80003ab2:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003ab4:	00021517          	auipc	a0,0x21
    80003ab8:	6b450513          	addi	a0,a0,1716 # 80025168 <ftable>
    80003abc:	00003097          	auipc	ra,0x3
    80003ac0:	a8c080e7          	jalr	-1396(ra) # 80006548 <acquire>
  if(f->ref < 1)
    80003ac4:	40dc                	lw	a5,4(s1)
    80003ac6:	06f05163          	blez	a5,80003b28 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003aca:	37fd                	addiw	a5,a5,-1
    80003acc:	0007871b          	sext.w	a4,a5
    80003ad0:	c0dc                	sw	a5,4(s1)
    80003ad2:	06e04363          	bgtz	a4,80003b38 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003ad6:	0004a903          	lw	s2,0(s1)
    80003ada:	0094ca83          	lbu	s5,9(s1)
    80003ade:	0104ba03          	ld	s4,16(s1)
    80003ae2:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003ae6:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003aea:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003aee:	00021517          	auipc	a0,0x21
    80003af2:	67a50513          	addi	a0,a0,1658 # 80025168 <ftable>
    80003af6:	00003097          	auipc	ra,0x3
    80003afa:	b06080e7          	jalr	-1274(ra) # 800065fc <release>

  if(ff.type == FD_PIPE){
    80003afe:	4785                	li	a5,1
    80003b00:	04f90d63          	beq	s2,a5,80003b5a <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003b04:	3979                	addiw	s2,s2,-2
    80003b06:	4785                	li	a5,1
    80003b08:	0527e063          	bltu	a5,s2,80003b48 <fileclose+0xa8>
    begin_op();
    80003b0c:	00000097          	auipc	ra,0x0
    80003b10:	acc080e7          	jalr	-1332(ra) # 800035d8 <begin_op>
    iput(ff.ip);
    80003b14:	854e                	mv	a0,s3
    80003b16:	fffff097          	auipc	ra,0xfffff
    80003b1a:	2a0080e7          	jalr	672(ra) # 80002db6 <iput>
    end_op();
    80003b1e:	00000097          	auipc	ra,0x0
    80003b22:	b38080e7          	jalr	-1224(ra) # 80003656 <end_op>
    80003b26:	a00d                	j	80003b48 <fileclose+0xa8>
    panic("fileclose");
    80003b28:	00005517          	auipc	a0,0x5
    80003b2c:	ac050513          	addi	a0,a0,-1344 # 800085e8 <syscalls+0x258>
    80003b30:	00002097          	auipc	ra,0x2
    80003b34:	4e0080e7          	jalr	1248(ra) # 80006010 <panic>
    release(&ftable.lock);
    80003b38:	00021517          	auipc	a0,0x21
    80003b3c:	63050513          	addi	a0,a0,1584 # 80025168 <ftable>
    80003b40:	00003097          	auipc	ra,0x3
    80003b44:	abc080e7          	jalr	-1348(ra) # 800065fc <release>
  }
}
    80003b48:	70e2                	ld	ra,56(sp)
    80003b4a:	7442                	ld	s0,48(sp)
    80003b4c:	74a2                	ld	s1,40(sp)
    80003b4e:	7902                	ld	s2,32(sp)
    80003b50:	69e2                	ld	s3,24(sp)
    80003b52:	6a42                	ld	s4,16(sp)
    80003b54:	6aa2                	ld	s5,8(sp)
    80003b56:	6121                	addi	sp,sp,64
    80003b58:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b5a:	85d6                	mv	a1,s5
    80003b5c:	8552                	mv	a0,s4
    80003b5e:	00000097          	auipc	ra,0x0
    80003b62:	34c080e7          	jalr	844(ra) # 80003eaa <pipeclose>
    80003b66:	b7cd                	j	80003b48 <fileclose+0xa8>

0000000080003b68 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003b68:	715d                	addi	sp,sp,-80
    80003b6a:	e486                	sd	ra,72(sp)
    80003b6c:	e0a2                	sd	s0,64(sp)
    80003b6e:	fc26                	sd	s1,56(sp)
    80003b70:	f84a                	sd	s2,48(sp)
    80003b72:	f44e                	sd	s3,40(sp)
    80003b74:	0880                	addi	s0,sp,80
    80003b76:	84aa                	mv	s1,a0
    80003b78:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b7a:	ffffd097          	auipc	ra,0xffffd
    80003b7e:	2b0080e7          	jalr	688(ra) # 80000e2a <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003b82:	409c                	lw	a5,0(s1)
    80003b84:	37f9                	addiw	a5,a5,-2
    80003b86:	4705                	li	a4,1
    80003b88:	04f76763          	bltu	a4,a5,80003bd6 <filestat+0x6e>
    80003b8c:	892a                	mv	s2,a0
    ilock(f->ip);
    80003b8e:	6c88                	ld	a0,24(s1)
    80003b90:	fffff097          	auipc	ra,0xfffff
    80003b94:	06c080e7          	jalr	108(ra) # 80002bfc <ilock>
    stati(f->ip, &st);
    80003b98:	fb840593          	addi	a1,s0,-72
    80003b9c:	6c88                	ld	a0,24(s1)
    80003b9e:	fffff097          	auipc	ra,0xfffff
    80003ba2:	2e8080e7          	jalr	744(ra) # 80002e86 <stati>
    iunlock(f->ip);
    80003ba6:	6c88                	ld	a0,24(s1)
    80003ba8:	fffff097          	auipc	ra,0xfffff
    80003bac:	116080e7          	jalr	278(ra) # 80002cbe <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003bb0:	46e1                	li	a3,24
    80003bb2:	fb840613          	addi	a2,s0,-72
    80003bb6:	85ce                	mv	a1,s3
    80003bb8:	05093503          	ld	a0,80(s2)
    80003bbc:	ffffd097          	auipc	ra,0xffffd
    80003bc0:	f32080e7          	jalr	-206(ra) # 80000aee <copyout>
    80003bc4:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003bc8:	60a6                	ld	ra,72(sp)
    80003bca:	6406                	ld	s0,64(sp)
    80003bcc:	74e2                	ld	s1,56(sp)
    80003bce:	7942                	ld	s2,48(sp)
    80003bd0:	79a2                	ld	s3,40(sp)
    80003bd2:	6161                	addi	sp,sp,80
    80003bd4:	8082                	ret
  return -1;
    80003bd6:	557d                	li	a0,-1
    80003bd8:	bfc5                	j	80003bc8 <filestat+0x60>

0000000080003bda <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003bda:	7179                	addi	sp,sp,-48
    80003bdc:	f406                	sd	ra,40(sp)
    80003bde:	f022                	sd	s0,32(sp)
    80003be0:	ec26                	sd	s1,24(sp)
    80003be2:	e84a                	sd	s2,16(sp)
    80003be4:	e44e                	sd	s3,8(sp)
    80003be6:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003be8:	00854783          	lbu	a5,8(a0)
    80003bec:	c3d5                	beqz	a5,80003c90 <fileread+0xb6>
    80003bee:	84aa                	mv	s1,a0
    80003bf0:	89ae                	mv	s3,a1
    80003bf2:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003bf4:	411c                	lw	a5,0(a0)
    80003bf6:	4705                	li	a4,1
    80003bf8:	04e78963          	beq	a5,a4,80003c4a <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003bfc:	470d                	li	a4,3
    80003bfe:	04e78d63          	beq	a5,a4,80003c58 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c02:	4709                	li	a4,2
    80003c04:	06e79e63          	bne	a5,a4,80003c80 <fileread+0xa6>
    ilock(f->ip);
    80003c08:	6d08                	ld	a0,24(a0)
    80003c0a:	fffff097          	auipc	ra,0xfffff
    80003c0e:	ff2080e7          	jalr	-14(ra) # 80002bfc <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003c12:	874a                	mv	a4,s2
    80003c14:	5094                	lw	a3,32(s1)
    80003c16:	864e                	mv	a2,s3
    80003c18:	4585                	li	a1,1
    80003c1a:	6c88                	ld	a0,24(s1)
    80003c1c:	fffff097          	auipc	ra,0xfffff
    80003c20:	294080e7          	jalr	660(ra) # 80002eb0 <readi>
    80003c24:	892a                	mv	s2,a0
    80003c26:	00a05563          	blez	a0,80003c30 <fileread+0x56>
      f->off += r;
    80003c2a:	509c                	lw	a5,32(s1)
    80003c2c:	9fa9                	addw	a5,a5,a0
    80003c2e:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003c30:	6c88                	ld	a0,24(s1)
    80003c32:	fffff097          	auipc	ra,0xfffff
    80003c36:	08c080e7          	jalr	140(ra) # 80002cbe <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003c3a:	854a                	mv	a0,s2
    80003c3c:	70a2                	ld	ra,40(sp)
    80003c3e:	7402                	ld	s0,32(sp)
    80003c40:	64e2                	ld	s1,24(sp)
    80003c42:	6942                	ld	s2,16(sp)
    80003c44:	69a2                	ld	s3,8(sp)
    80003c46:	6145                	addi	sp,sp,48
    80003c48:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c4a:	6908                	ld	a0,16(a0)
    80003c4c:	00000097          	auipc	ra,0x0
    80003c50:	3c0080e7          	jalr	960(ra) # 8000400c <piperead>
    80003c54:	892a                	mv	s2,a0
    80003c56:	b7d5                	j	80003c3a <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003c58:	02451783          	lh	a5,36(a0)
    80003c5c:	03079693          	slli	a3,a5,0x30
    80003c60:	92c1                	srli	a3,a3,0x30
    80003c62:	4725                	li	a4,9
    80003c64:	02d76863          	bltu	a4,a3,80003c94 <fileread+0xba>
    80003c68:	0792                	slli	a5,a5,0x4
    80003c6a:	00021717          	auipc	a4,0x21
    80003c6e:	45e70713          	addi	a4,a4,1118 # 800250c8 <devsw>
    80003c72:	97ba                	add	a5,a5,a4
    80003c74:	639c                	ld	a5,0(a5)
    80003c76:	c38d                	beqz	a5,80003c98 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003c78:	4505                	li	a0,1
    80003c7a:	9782                	jalr	a5
    80003c7c:	892a                	mv	s2,a0
    80003c7e:	bf75                	j	80003c3a <fileread+0x60>
    panic("fileread");
    80003c80:	00005517          	auipc	a0,0x5
    80003c84:	97850513          	addi	a0,a0,-1672 # 800085f8 <syscalls+0x268>
    80003c88:	00002097          	auipc	ra,0x2
    80003c8c:	388080e7          	jalr	904(ra) # 80006010 <panic>
    return -1;
    80003c90:	597d                	li	s2,-1
    80003c92:	b765                	j	80003c3a <fileread+0x60>
      return -1;
    80003c94:	597d                	li	s2,-1
    80003c96:	b755                	j	80003c3a <fileread+0x60>
    80003c98:	597d                	li	s2,-1
    80003c9a:	b745                	j	80003c3a <fileread+0x60>

0000000080003c9c <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003c9c:	715d                	addi	sp,sp,-80
    80003c9e:	e486                	sd	ra,72(sp)
    80003ca0:	e0a2                	sd	s0,64(sp)
    80003ca2:	fc26                	sd	s1,56(sp)
    80003ca4:	f84a                	sd	s2,48(sp)
    80003ca6:	f44e                	sd	s3,40(sp)
    80003ca8:	f052                	sd	s4,32(sp)
    80003caa:	ec56                	sd	s5,24(sp)
    80003cac:	e85a                	sd	s6,16(sp)
    80003cae:	e45e                	sd	s7,8(sp)
    80003cb0:	e062                	sd	s8,0(sp)
    80003cb2:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003cb4:	00954783          	lbu	a5,9(a0)
    80003cb8:	10078663          	beqz	a5,80003dc4 <filewrite+0x128>
    80003cbc:	892a                	mv	s2,a0
    80003cbe:	8b2e                	mv	s6,a1
    80003cc0:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003cc2:	411c                	lw	a5,0(a0)
    80003cc4:	4705                	li	a4,1
    80003cc6:	02e78263          	beq	a5,a4,80003cea <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003cca:	470d                	li	a4,3
    80003ccc:	02e78663          	beq	a5,a4,80003cf8 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003cd0:	4709                	li	a4,2
    80003cd2:	0ee79163          	bne	a5,a4,80003db4 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003cd6:	0ac05d63          	blez	a2,80003d90 <filewrite+0xf4>
    int i = 0;
    80003cda:	4981                	li	s3,0
    80003cdc:	6b85                	lui	s7,0x1
    80003cde:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003ce2:	6c05                	lui	s8,0x1
    80003ce4:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003ce8:	a861                	j	80003d80 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003cea:	6908                	ld	a0,16(a0)
    80003cec:	00000097          	auipc	ra,0x0
    80003cf0:	22e080e7          	jalr	558(ra) # 80003f1a <pipewrite>
    80003cf4:	8a2a                	mv	s4,a0
    80003cf6:	a045                	j	80003d96 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003cf8:	02451783          	lh	a5,36(a0)
    80003cfc:	03079693          	slli	a3,a5,0x30
    80003d00:	92c1                	srli	a3,a3,0x30
    80003d02:	4725                	li	a4,9
    80003d04:	0cd76263          	bltu	a4,a3,80003dc8 <filewrite+0x12c>
    80003d08:	0792                	slli	a5,a5,0x4
    80003d0a:	00021717          	auipc	a4,0x21
    80003d0e:	3be70713          	addi	a4,a4,958 # 800250c8 <devsw>
    80003d12:	97ba                	add	a5,a5,a4
    80003d14:	679c                	ld	a5,8(a5)
    80003d16:	cbdd                	beqz	a5,80003dcc <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003d18:	4505                	li	a0,1
    80003d1a:	9782                	jalr	a5
    80003d1c:	8a2a                	mv	s4,a0
    80003d1e:	a8a5                	j	80003d96 <filewrite+0xfa>
    80003d20:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003d24:	00000097          	auipc	ra,0x0
    80003d28:	8b4080e7          	jalr	-1868(ra) # 800035d8 <begin_op>
      ilock(f->ip);
    80003d2c:	01893503          	ld	a0,24(s2)
    80003d30:	fffff097          	auipc	ra,0xfffff
    80003d34:	ecc080e7          	jalr	-308(ra) # 80002bfc <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d38:	8756                	mv	a4,s5
    80003d3a:	02092683          	lw	a3,32(s2)
    80003d3e:	01698633          	add	a2,s3,s6
    80003d42:	4585                	li	a1,1
    80003d44:	01893503          	ld	a0,24(s2)
    80003d48:	fffff097          	auipc	ra,0xfffff
    80003d4c:	260080e7          	jalr	608(ra) # 80002fa8 <writei>
    80003d50:	84aa                	mv	s1,a0
    80003d52:	00a05763          	blez	a0,80003d60 <filewrite+0xc4>
        f->off += r;
    80003d56:	02092783          	lw	a5,32(s2)
    80003d5a:	9fa9                	addw	a5,a5,a0
    80003d5c:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003d60:	01893503          	ld	a0,24(s2)
    80003d64:	fffff097          	auipc	ra,0xfffff
    80003d68:	f5a080e7          	jalr	-166(ra) # 80002cbe <iunlock>
      end_op();
    80003d6c:	00000097          	auipc	ra,0x0
    80003d70:	8ea080e7          	jalr	-1814(ra) # 80003656 <end_op>

      if(r != n1){
    80003d74:	009a9f63          	bne	s5,s1,80003d92 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003d78:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003d7c:	0149db63          	bge	s3,s4,80003d92 <filewrite+0xf6>
      int n1 = n - i;
    80003d80:	413a04bb          	subw	s1,s4,s3
    80003d84:	0004879b          	sext.w	a5,s1
    80003d88:	f8fbdce3          	bge	s7,a5,80003d20 <filewrite+0x84>
    80003d8c:	84e2                	mv	s1,s8
    80003d8e:	bf49                	j	80003d20 <filewrite+0x84>
    int i = 0;
    80003d90:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003d92:	013a1f63          	bne	s4,s3,80003db0 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003d96:	8552                	mv	a0,s4
    80003d98:	60a6                	ld	ra,72(sp)
    80003d9a:	6406                	ld	s0,64(sp)
    80003d9c:	74e2                	ld	s1,56(sp)
    80003d9e:	7942                	ld	s2,48(sp)
    80003da0:	79a2                	ld	s3,40(sp)
    80003da2:	7a02                	ld	s4,32(sp)
    80003da4:	6ae2                	ld	s5,24(sp)
    80003da6:	6b42                	ld	s6,16(sp)
    80003da8:	6ba2                	ld	s7,8(sp)
    80003daa:	6c02                	ld	s8,0(sp)
    80003dac:	6161                	addi	sp,sp,80
    80003dae:	8082                	ret
    ret = (i == n ? n : -1);
    80003db0:	5a7d                	li	s4,-1
    80003db2:	b7d5                	j	80003d96 <filewrite+0xfa>
    panic("filewrite");
    80003db4:	00005517          	auipc	a0,0x5
    80003db8:	85450513          	addi	a0,a0,-1964 # 80008608 <syscalls+0x278>
    80003dbc:	00002097          	auipc	ra,0x2
    80003dc0:	254080e7          	jalr	596(ra) # 80006010 <panic>
    return -1;
    80003dc4:	5a7d                	li	s4,-1
    80003dc6:	bfc1                	j	80003d96 <filewrite+0xfa>
      return -1;
    80003dc8:	5a7d                	li	s4,-1
    80003dca:	b7f1                	j	80003d96 <filewrite+0xfa>
    80003dcc:	5a7d                	li	s4,-1
    80003dce:	b7e1                	j	80003d96 <filewrite+0xfa>

0000000080003dd0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003dd0:	7179                	addi	sp,sp,-48
    80003dd2:	f406                	sd	ra,40(sp)
    80003dd4:	f022                	sd	s0,32(sp)
    80003dd6:	ec26                	sd	s1,24(sp)
    80003dd8:	e84a                	sd	s2,16(sp)
    80003dda:	e44e                	sd	s3,8(sp)
    80003ddc:	e052                	sd	s4,0(sp)
    80003dde:	1800                	addi	s0,sp,48
    80003de0:	84aa                	mv	s1,a0
    80003de2:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003de4:	0005b023          	sd	zero,0(a1)
    80003de8:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003dec:	00000097          	auipc	ra,0x0
    80003df0:	bf8080e7          	jalr	-1032(ra) # 800039e4 <filealloc>
    80003df4:	e088                	sd	a0,0(s1)
    80003df6:	c551                	beqz	a0,80003e82 <pipealloc+0xb2>
    80003df8:	00000097          	auipc	ra,0x0
    80003dfc:	bec080e7          	jalr	-1044(ra) # 800039e4 <filealloc>
    80003e00:	00aa3023          	sd	a0,0(s4)
    80003e04:	c92d                	beqz	a0,80003e76 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003e06:	ffffc097          	auipc	ra,0xffffc
    80003e0a:	314080e7          	jalr	788(ra) # 8000011a <kalloc>
    80003e0e:	892a                	mv	s2,a0
    80003e10:	c125                	beqz	a0,80003e70 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003e12:	4985                	li	s3,1
    80003e14:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003e18:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003e1c:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e20:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e24:	00004597          	auipc	a1,0x4
    80003e28:	7f458593          	addi	a1,a1,2036 # 80008618 <syscalls+0x288>
    80003e2c:	00002097          	auipc	ra,0x2
    80003e30:	68c080e7          	jalr	1676(ra) # 800064b8 <initlock>
  (*f0)->type = FD_PIPE;
    80003e34:	609c                	ld	a5,0(s1)
    80003e36:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e3a:	609c                	ld	a5,0(s1)
    80003e3c:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e40:	609c                	ld	a5,0(s1)
    80003e42:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e46:	609c                	ld	a5,0(s1)
    80003e48:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003e4c:	000a3783          	ld	a5,0(s4)
    80003e50:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003e54:	000a3783          	ld	a5,0(s4)
    80003e58:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003e5c:	000a3783          	ld	a5,0(s4)
    80003e60:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e64:	000a3783          	ld	a5,0(s4)
    80003e68:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e6c:	4501                	li	a0,0
    80003e6e:	a025                	j	80003e96 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003e70:	6088                	ld	a0,0(s1)
    80003e72:	e501                	bnez	a0,80003e7a <pipealloc+0xaa>
    80003e74:	a039                	j	80003e82 <pipealloc+0xb2>
    80003e76:	6088                	ld	a0,0(s1)
    80003e78:	c51d                	beqz	a0,80003ea6 <pipealloc+0xd6>
    fileclose(*f0);
    80003e7a:	00000097          	auipc	ra,0x0
    80003e7e:	c26080e7          	jalr	-986(ra) # 80003aa0 <fileclose>
  if(*f1)
    80003e82:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003e86:	557d                	li	a0,-1
  if(*f1)
    80003e88:	c799                	beqz	a5,80003e96 <pipealloc+0xc6>
    fileclose(*f1);
    80003e8a:	853e                	mv	a0,a5
    80003e8c:	00000097          	auipc	ra,0x0
    80003e90:	c14080e7          	jalr	-1004(ra) # 80003aa0 <fileclose>
  return -1;
    80003e94:	557d                	li	a0,-1
}
    80003e96:	70a2                	ld	ra,40(sp)
    80003e98:	7402                	ld	s0,32(sp)
    80003e9a:	64e2                	ld	s1,24(sp)
    80003e9c:	6942                	ld	s2,16(sp)
    80003e9e:	69a2                	ld	s3,8(sp)
    80003ea0:	6a02                	ld	s4,0(sp)
    80003ea2:	6145                	addi	sp,sp,48
    80003ea4:	8082                	ret
  return -1;
    80003ea6:	557d                	li	a0,-1
    80003ea8:	b7fd                	j	80003e96 <pipealloc+0xc6>

0000000080003eaa <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003eaa:	1101                	addi	sp,sp,-32
    80003eac:	ec06                	sd	ra,24(sp)
    80003eae:	e822                	sd	s0,16(sp)
    80003eb0:	e426                	sd	s1,8(sp)
    80003eb2:	e04a                	sd	s2,0(sp)
    80003eb4:	1000                	addi	s0,sp,32
    80003eb6:	84aa                	mv	s1,a0
    80003eb8:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003eba:	00002097          	auipc	ra,0x2
    80003ebe:	68e080e7          	jalr	1678(ra) # 80006548 <acquire>
  if(writable){
    80003ec2:	02090d63          	beqz	s2,80003efc <pipeclose+0x52>
    pi->writeopen = 0;
    80003ec6:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003eca:	21848513          	addi	a0,s1,536
    80003ece:	ffffd097          	auipc	ra,0xffffd
    80003ed2:	7ea080e7          	jalr	2026(ra) # 800016b8 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003ed6:	2204b783          	ld	a5,544(s1)
    80003eda:	eb95                	bnez	a5,80003f0e <pipeclose+0x64>
    release(&pi->lock);
    80003edc:	8526                	mv	a0,s1
    80003ede:	00002097          	auipc	ra,0x2
    80003ee2:	71e080e7          	jalr	1822(ra) # 800065fc <release>
    kfree((char*)pi);
    80003ee6:	8526                	mv	a0,s1
    80003ee8:	ffffc097          	auipc	ra,0xffffc
    80003eec:	134080e7          	jalr	308(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003ef0:	60e2                	ld	ra,24(sp)
    80003ef2:	6442                	ld	s0,16(sp)
    80003ef4:	64a2                	ld	s1,8(sp)
    80003ef6:	6902                	ld	s2,0(sp)
    80003ef8:	6105                	addi	sp,sp,32
    80003efa:	8082                	ret
    pi->readopen = 0;
    80003efc:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003f00:	21c48513          	addi	a0,s1,540
    80003f04:	ffffd097          	auipc	ra,0xffffd
    80003f08:	7b4080e7          	jalr	1972(ra) # 800016b8 <wakeup>
    80003f0c:	b7e9                	j	80003ed6 <pipeclose+0x2c>
    release(&pi->lock);
    80003f0e:	8526                	mv	a0,s1
    80003f10:	00002097          	auipc	ra,0x2
    80003f14:	6ec080e7          	jalr	1772(ra) # 800065fc <release>
}
    80003f18:	bfe1                	j	80003ef0 <pipeclose+0x46>

0000000080003f1a <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003f1a:	711d                	addi	sp,sp,-96
    80003f1c:	ec86                	sd	ra,88(sp)
    80003f1e:	e8a2                	sd	s0,80(sp)
    80003f20:	e4a6                	sd	s1,72(sp)
    80003f22:	e0ca                	sd	s2,64(sp)
    80003f24:	fc4e                	sd	s3,56(sp)
    80003f26:	f852                	sd	s4,48(sp)
    80003f28:	f456                	sd	s5,40(sp)
    80003f2a:	f05a                	sd	s6,32(sp)
    80003f2c:	ec5e                	sd	s7,24(sp)
    80003f2e:	e862                	sd	s8,16(sp)
    80003f30:	1080                	addi	s0,sp,96
    80003f32:	84aa                	mv	s1,a0
    80003f34:	8aae                	mv	s5,a1
    80003f36:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003f38:	ffffd097          	auipc	ra,0xffffd
    80003f3c:	ef2080e7          	jalr	-270(ra) # 80000e2a <myproc>
    80003f40:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003f42:	8526                	mv	a0,s1
    80003f44:	00002097          	auipc	ra,0x2
    80003f48:	604080e7          	jalr	1540(ra) # 80006548 <acquire>
  while(i < n){
    80003f4c:	0b405363          	blez	s4,80003ff2 <pipewrite+0xd8>
  int i = 0;
    80003f50:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f52:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003f54:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003f58:	21c48b93          	addi	s7,s1,540
    80003f5c:	a089                	j	80003f9e <pipewrite+0x84>
      release(&pi->lock);
    80003f5e:	8526                	mv	a0,s1
    80003f60:	00002097          	auipc	ra,0x2
    80003f64:	69c080e7          	jalr	1692(ra) # 800065fc <release>
      return -1;
    80003f68:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f6a:	854a                	mv	a0,s2
    80003f6c:	60e6                	ld	ra,88(sp)
    80003f6e:	6446                	ld	s0,80(sp)
    80003f70:	64a6                	ld	s1,72(sp)
    80003f72:	6906                	ld	s2,64(sp)
    80003f74:	79e2                	ld	s3,56(sp)
    80003f76:	7a42                	ld	s4,48(sp)
    80003f78:	7aa2                	ld	s5,40(sp)
    80003f7a:	7b02                	ld	s6,32(sp)
    80003f7c:	6be2                	ld	s7,24(sp)
    80003f7e:	6c42                	ld	s8,16(sp)
    80003f80:	6125                	addi	sp,sp,96
    80003f82:	8082                	ret
      wakeup(&pi->nread);
    80003f84:	8562                	mv	a0,s8
    80003f86:	ffffd097          	auipc	ra,0xffffd
    80003f8a:	732080e7          	jalr	1842(ra) # 800016b8 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003f8e:	85a6                	mv	a1,s1
    80003f90:	855e                	mv	a0,s7
    80003f92:	ffffd097          	auipc	ra,0xffffd
    80003f96:	59a080e7          	jalr	1434(ra) # 8000152c <sleep>
  while(i < n){
    80003f9a:	05495d63          	bge	s2,s4,80003ff4 <pipewrite+0xda>
    if(pi->readopen == 0 || pr->killed){
    80003f9e:	2204a783          	lw	a5,544(s1)
    80003fa2:	dfd5                	beqz	a5,80003f5e <pipewrite+0x44>
    80003fa4:	0289a783          	lw	a5,40(s3)
    80003fa8:	fbdd                	bnez	a5,80003f5e <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003faa:	2184a783          	lw	a5,536(s1)
    80003fae:	21c4a703          	lw	a4,540(s1)
    80003fb2:	2007879b          	addiw	a5,a5,512
    80003fb6:	fcf707e3          	beq	a4,a5,80003f84 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003fba:	4685                	li	a3,1
    80003fbc:	01590633          	add	a2,s2,s5
    80003fc0:	faf40593          	addi	a1,s0,-81
    80003fc4:	0509b503          	ld	a0,80(s3)
    80003fc8:	ffffd097          	auipc	ra,0xffffd
    80003fcc:	bb2080e7          	jalr	-1102(ra) # 80000b7a <copyin>
    80003fd0:	03650263          	beq	a0,s6,80003ff4 <pipewrite+0xda>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003fd4:	21c4a783          	lw	a5,540(s1)
    80003fd8:	0017871b          	addiw	a4,a5,1
    80003fdc:	20e4ae23          	sw	a4,540(s1)
    80003fe0:	1ff7f793          	andi	a5,a5,511
    80003fe4:	97a6                	add	a5,a5,s1
    80003fe6:	faf44703          	lbu	a4,-81(s0)
    80003fea:	00e78c23          	sb	a4,24(a5)
      i++;
    80003fee:	2905                	addiw	s2,s2,1
    80003ff0:	b76d                	j	80003f9a <pipewrite+0x80>
  int i = 0;
    80003ff2:	4901                	li	s2,0
  wakeup(&pi->nread);
    80003ff4:	21848513          	addi	a0,s1,536
    80003ff8:	ffffd097          	auipc	ra,0xffffd
    80003ffc:	6c0080e7          	jalr	1728(ra) # 800016b8 <wakeup>
  release(&pi->lock);
    80004000:	8526                	mv	a0,s1
    80004002:	00002097          	auipc	ra,0x2
    80004006:	5fa080e7          	jalr	1530(ra) # 800065fc <release>
  return i;
    8000400a:	b785                	j	80003f6a <pipewrite+0x50>

000000008000400c <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000400c:	715d                	addi	sp,sp,-80
    8000400e:	e486                	sd	ra,72(sp)
    80004010:	e0a2                	sd	s0,64(sp)
    80004012:	fc26                	sd	s1,56(sp)
    80004014:	f84a                	sd	s2,48(sp)
    80004016:	f44e                	sd	s3,40(sp)
    80004018:	f052                	sd	s4,32(sp)
    8000401a:	ec56                	sd	s5,24(sp)
    8000401c:	e85a                	sd	s6,16(sp)
    8000401e:	0880                	addi	s0,sp,80
    80004020:	84aa                	mv	s1,a0
    80004022:	892e                	mv	s2,a1
    80004024:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004026:	ffffd097          	auipc	ra,0xffffd
    8000402a:	e04080e7          	jalr	-508(ra) # 80000e2a <myproc>
    8000402e:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004030:	8526                	mv	a0,s1
    80004032:	00002097          	auipc	ra,0x2
    80004036:	516080e7          	jalr	1302(ra) # 80006548 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000403a:	2184a703          	lw	a4,536(s1)
    8000403e:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004042:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004046:	02f71463          	bne	a4,a5,8000406e <piperead+0x62>
    8000404a:	2244a783          	lw	a5,548(s1)
    8000404e:	c385                	beqz	a5,8000406e <piperead+0x62>
    if(pr->killed){
    80004050:	028a2783          	lw	a5,40(s4)
    80004054:	ebc9                	bnez	a5,800040e6 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004056:	85a6                	mv	a1,s1
    80004058:	854e                	mv	a0,s3
    8000405a:	ffffd097          	auipc	ra,0xffffd
    8000405e:	4d2080e7          	jalr	1234(ra) # 8000152c <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004062:	2184a703          	lw	a4,536(s1)
    80004066:	21c4a783          	lw	a5,540(s1)
    8000406a:	fef700e3          	beq	a4,a5,8000404a <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000406e:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004070:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004072:	05505463          	blez	s5,800040ba <piperead+0xae>
    if(pi->nread == pi->nwrite)
    80004076:	2184a783          	lw	a5,536(s1)
    8000407a:	21c4a703          	lw	a4,540(s1)
    8000407e:	02f70e63          	beq	a4,a5,800040ba <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004082:	0017871b          	addiw	a4,a5,1
    80004086:	20e4ac23          	sw	a4,536(s1)
    8000408a:	1ff7f793          	andi	a5,a5,511
    8000408e:	97a6                	add	a5,a5,s1
    80004090:	0187c783          	lbu	a5,24(a5)
    80004094:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004098:	4685                	li	a3,1
    8000409a:	fbf40613          	addi	a2,s0,-65
    8000409e:	85ca                	mv	a1,s2
    800040a0:	050a3503          	ld	a0,80(s4)
    800040a4:	ffffd097          	auipc	ra,0xffffd
    800040a8:	a4a080e7          	jalr	-1462(ra) # 80000aee <copyout>
    800040ac:	01650763          	beq	a0,s6,800040ba <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040b0:	2985                	addiw	s3,s3,1
    800040b2:	0905                	addi	s2,s2,1
    800040b4:	fd3a91e3          	bne	s5,s3,80004076 <piperead+0x6a>
    800040b8:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800040ba:	21c48513          	addi	a0,s1,540
    800040be:	ffffd097          	auipc	ra,0xffffd
    800040c2:	5fa080e7          	jalr	1530(ra) # 800016b8 <wakeup>
  release(&pi->lock);
    800040c6:	8526                	mv	a0,s1
    800040c8:	00002097          	auipc	ra,0x2
    800040cc:	534080e7          	jalr	1332(ra) # 800065fc <release>
  return i;
}
    800040d0:	854e                	mv	a0,s3
    800040d2:	60a6                	ld	ra,72(sp)
    800040d4:	6406                	ld	s0,64(sp)
    800040d6:	74e2                	ld	s1,56(sp)
    800040d8:	7942                	ld	s2,48(sp)
    800040da:	79a2                	ld	s3,40(sp)
    800040dc:	7a02                	ld	s4,32(sp)
    800040de:	6ae2                	ld	s5,24(sp)
    800040e0:	6b42                	ld	s6,16(sp)
    800040e2:	6161                	addi	sp,sp,80
    800040e4:	8082                	ret
      release(&pi->lock);
    800040e6:	8526                	mv	a0,s1
    800040e8:	00002097          	auipc	ra,0x2
    800040ec:	514080e7          	jalr	1300(ra) # 800065fc <release>
      return -1;
    800040f0:	59fd                	li	s3,-1
    800040f2:	bff9                	j	800040d0 <piperead+0xc4>

00000000800040f4 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800040f4:	de010113          	addi	sp,sp,-544
    800040f8:	20113c23          	sd	ra,536(sp)
    800040fc:	20813823          	sd	s0,528(sp)
    80004100:	20913423          	sd	s1,520(sp)
    80004104:	21213023          	sd	s2,512(sp)
    80004108:	ffce                	sd	s3,504(sp)
    8000410a:	fbd2                	sd	s4,496(sp)
    8000410c:	f7d6                	sd	s5,488(sp)
    8000410e:	f3da                	sd	s6,480(sp)
    80004110:	efde                	sd	s7,472(sp)
    80004112:	ebe2                	sd	s8,464(sp)
    80004114:	e7e6                	sd	s9,456(sp)
    80004116:	e3ea                	sd	s10,448(sp)
    80004118:	ff6e                	sd	s11,440(sp)
    8000411a:	1400                	addi	s0,sp,544
    8000411c:	892a                	mv	s2,a0
    8000411e:	dea43423          	sd	a0,-536(s0)
    80004122:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004126:	ffffd097          	auipc	ra,0xffffd
    8000412a:	d04080e7          	jalr	-764(ra) # 80000e2a <myproc>
    8000412e:	84aa                	mv	s1,a0

  begin_op();
    80004130:	fffff097          	auipc	ra,0xfffff
    80004134:	4a8080e7          	jalr	1192(ra) # 800035d8 <begin_op>

  if((ip = namei(path)) == 0){
    80004138:	854a                	mv	a0,s2
    8000413a:	fffff097          	auipc	ra,0xfffff
    8000413e:	27e080e7          	jalr	638(ra) # 800033b8 <namei>
    80004142:	c93d                	beqz	a0,800041b8 <exec+0xc4>
    80004144:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004146:	fffff097          	auipc	ra,0xfffff
    8000414a:	ab6080e7          	jalr	-1354(ra) # 80002bfc <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000414e:	04000713          	li	a4,64
    80004152:	4681                	li	a3,0
    80004154:	e5040613          	addi	a2,s0,-432
    80004158:	4581                	li	a1,0
    8000415a:	8556                	mv	a0,s5
    8000415c:	fffff097          	auipc	ra,0xfffff
    80004160:	d54080e7          	jalr	-684(ra) # 80002eb0 <readi>
    80004164:	04000793          	li	a5,64
    80004168:	00f51a63          	bne	a0,a5,8000417c <exec+0x88>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    8000416c:	e5042703          	lw	a4,-432(s0)
    80004170:	464c47b7          	lui	a5,0x464c4
    80004174:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004178:	04f70663          	beq	a4,a5,800041c4 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000417c:	8556                	mv	a0,s5
    8000417e:	fffff097          	auipc	ra,0xfffff
    80004182:	ce0080e7          	jalr	-800(ra) # 80002e5e <iunlockput>
    end_op();
    80004186:	fffff097          	auipc	ra,0xfffff
    8000418a:	4d0080e7          	jalr	1232(ra) # 80003656 <end_op>
  }
  return -1;
    8000418e:	557d                	li	a0,-1
}
    80004190:	21813083          	ld	ra,536(sp)
    80004194:	21013403          	ld	s0,528(sp)
    80004198:	20813483          	ld	s1,520(sp)
    8000419c:	20013903          	ld	s2,512(sp)
    800041a0:	79fe                	ld	s3,504(sp)
    800041a2:	7a5e                	ld	s4,496(sp)
    800041a4:	7abe                	ld	s5,488(sp)
    800041a6:	7b1e                	ld	s6,480(sp)
    800041a8:	6bfe                	ld	s7,472(sp)
    800041aa:	6c5e                	ld	s8,464(sp)
    800041ac:	6cbe                	ld	s9,456(sp)
    800041ae:	6d1e                	ld	s10,448(sp)
    800041b0:	7dfa                	ld	s11,440(sp)
    800041b2:	22010113          	addi	sp,sp,544
    800041b6:	8082                	ret
    end_op();
    800041b8:	fffff097          	auipc	ra,0xfffff
    800041bc:	49e080e7          	jalr	1182(ra) # 80003656 <end_op>
    return -1;
    800041c0:	557d                	li	a0,-1
    800041c2:	b7f9                	j	80004190 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    800041c4:	8526                	mv	a0,s1
    800041c6:	ffffd097          	auipc	ra,0xffffd
    800041ca:	d28080e7          	jalr	-728(ra) # 80000eee <proc_pagetable>
    800041ce:	8b2a                	mv	s6,a0
    800041d0:	d555                	beqz	a0,8000417c <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041d2:	e7042783          	lw	a5,-400(s0)
    800041d6:	e8845703          	lhu	a4,-376(s0)
    800041da:	c735                	beqz	a4,80004246 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800041dc:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041de:	e0043423          	sd	zero,-504(s0)
    if((ph.vaddr % PGSIZE) != 0)
    800041e2:	6a05                	lui	s4,0x1
    800041e4:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    800041e8:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    800041ec:	6d85                	lui	s11,0x1
    800041ee:	7d7d                	lui	s10,0xfffff
    800041f0:	ac1d                	j	80004426 <exec+0x332>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800041f2:	00004517          	auipc	a0,0x4
    800041f6:	42e50513          	addi	a0,a0,1070 # 80008620 <syscalls+0x290>
    800041fa:	00002097          	auipc	ra,0x2
    800041fe:	e16080e7          	jalr	-490(ra) # 80006010 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004202:	874a                	mv	a4,s2
    80004204:	009c86bb          	addw	a3,s9,s1
    80004208:	4581                	li	a1,0
    8000420a:	8556                	mv	a0,s5
    8000420c:	fffff097          	auipc	ra,0xfffff
    80004210:	ca4080e7          	jalr	-860(ra) # 80002eb0 <readi>
    80004214:	2501                	sext.w	a0,a0
    80004216:	1aa91863          	bne	s2,a0,800043c6 <exec+0x2d2>
  for(i = 0; i < sz; i += PGSIZE){
    8000421a:	009d84bb          	addw	s1,s11,s1
    8000421e:	013d09bb          	addw	s3,s10,s3
    80004222:	1f74f263          	bgeu	s1,s7,80004406 <exec+0x312>
    pa = walkaddr(pagetable, va + i);
    80004226:	02049593          	slli	a1,s1,0x20
    8000422a:	9181                	srli	a1,a1,0x20
    8000422c:	95e2                	add	a1,a1,s8
    8000422e:	855a                	mv	a0,s6
    80004230:	ffffc097          	auipc	ra,0xffffc
    80004234:	2d0080e7          	jalr	720(ra) # 80000500 <walkaddr>
    80004238:	862a                	mv	a2,a0
    if(pa == 0)
    8000423a:	dd45                	beqz	a0,800041f2 <exec+0xfe>
      n = PGSIZE;
    8000423c:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    8000423e:	fd49f2e3          	bgeu	s3,s4,80004202 <exec+0x10e>
      n = sz - i;
    80004242:	894e                	mv	s2,s3
    80004244:	bf7d                	j	80004202 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004246:	4481                	li	s1,0
  iunlockput(ip);
    80004248:	8556                	mv	a0,s5
    8000424a:	fffff097          	auipc	ra,0xfffff
    8000424e:	c14080e7          	jalr	-1004(ra) # 80002e5e <iunlockput>
  end_op();
    80004252:	fffff097          	auipc	ra,0xfffff
    80004256:	404080e7          	jalr	1028(ra) # 80003656 <end_op>
  p = myproc();
    8000425a:	ffffd097          	auipc	ra,0xffffd
    8000425e:	bd0080e7          	jalr	-1072(ra) # 80000e2a <myproc>
    80004262:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80004264:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004268:	6785                	lui	a5,0x1
    8000426a:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000426c:	97a6                	add	a5,a5,s1
    8000426e:	777d                	lui	a4,0xfffff
    80004270:	8ff9                	and	a5,a5,a4
    80004272:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004276:	6609                	lui	a2,0x2
    80004278:	963e                	add	a2,a2,a5
    8000427a:	85be                	mv	a1,a5
    8000427c:	855a                	mv	a0,s6
    8000427e:	ffffc097          	auipc	ra,0xffffc
    80004282:	628080e7          	jalr	1576(ra) # 800008a6 <uvmalloc>
    80004286:	8c2a                	mv	s8,a0
  ip = 0;
    80004288:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000428a:	12050e63          	beqz	a0,800043c6 <exec+0x2d2>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000428e:	75f9                	lui	a1,0xffffe
    80004290:	95aa                	add	a1,a1,a0
    80004292:	855a                	mv	a0,s6
    80004294:	ffffd097          	auipc	ra,0xffffd
    80004298:	828080e7          	jalr	-2008(ra) # 80000abc <uvmclear>
  stackbase = sp - PGSIZE;
    8000429c:	7afd                	lui	s5,0xfffff
    8000429e:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    800042a0:	df043783          	ld	a5,-528(s0)
    800042a4:	6388                	ld	a0,0(a5)
    800042a6:	c925                	beqz	a0,80004316 <exec+0x222>
    800042a8:	e9040993          	addi	s3,s0,-368
    800042ac:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    800042b0:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800042b2:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800042b4:	ffffc097          	auipc	ra,0xffffc
    800042b8:	042080e7          	jalr	66(ra) # 800002f6 <strlen>
    800042bc:	0015079b          	addiw	a5,a0,1
    800042c0:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800042c4:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800042c8:	13596363          	bltu	s2,s5,800043ee <exec+0x2fa>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800042cc:	df043d83          	ld	s11,-528(s0)
    800042d0:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    800042d4:	8552                	mv	a0,s4
    800042d6:	ffffc097          	auipc	ra,0xffffc
    800042da:	020080e7          	jalr	32(ra) # 800002f6 <strlen>
    800042de:	0015069b          	addiw	a3,a0,1
    800042e2:	8652                	mv	a2,s4
    800042e4:	85ca                	mv	a1,s2
    800042e6:	855a                	mv	a0,s6
    800042e8:	ffffd097          	auipc	ra,0xffffd
    800042ec:	806080e7          	jalr	-2042(ra) # 80000aee <copyout>
    800042f0:	10054363          	bltz	a0,800043f6 <exec+0x302>
    ustack[argc] = sp;
    800042f4:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800042f8:	0485                	addi	s1,s1,1
    800042fa:	008d8793          	addi	a5,s11,8
    800042fe:	def43823          	sd	a5,-528(s0)
    80004302:	008db503          	ld	a0,8(s11)
    80004306:	c911                	beqz	a0,8000431a <exec+0x226>
    if(argc >= MAXARG)
    80004308:	09a1                	addi	s3,s3,8
    8000430a:	fb3c95e3          	bne	s9,s3,800042b4 <exec+0x1c0>
  sz = sz1;
    8000430e:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004312:	4a81                	li	s5,0
    80004314:	a84d                	j	800043c6 <exec+0x2d2>
  sp = sz;
    80004316:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004318:	4481                	li	s1,0
  ustack[argc] = 0;
    8000431a:	00349793          	slli	a5,s1,0x3
    8000431e:	f9078793          	addi	a5,a5,-112
    80004322:	97a2                	add	a5,a5,s0
    80004324:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004328:	00148693          	addi	a3,s1,1
    8000432c:	068e                	slli	a3,a3,0x3
    8000432e:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004332:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004336:	01597663          	bgeu	s2,s5,80004342 <exec+0x24e>
  sz = sz1;
    8000433a:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000433e:	4a81                	li	s5,0
    80004340:	a059                	j	800043c6 <exec+0x2d2>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004342:	e9040613          	addi	a2,s0,-368
    80004346:	85ca                	mv	a1,s2
    80004348:	855a                	mv	a0,s6
    8000434a:	ffffc097          	auipc	ra,0xffffc
    8000434e:	7a4080e7          	jalr	1956(ra) # 80000aee <copyout>
    80004352:	0a054663          	bltz	a0,800043fe <exec+0x30a>
  p->trapframe->a1 = sp;
    80004356:	058bb783          	ld	a5,88(s7)
    8000435a:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000435e:	de843783          	ld	a5,-536(s0)
    80004362:	0007c703          	lbu	a4,0(a5)
    80004366:	cf11                	beqz	a4,80004382 <exec+0x28e>
    80004368:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000436a:	02f00693          	li	a3,47
    8000436e:	a039                	j	8000437c <exec+0x288>
      last = s+1;
    80004370:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80004374:	0785                	addi	a5,a5,1
    80004376:	fff7c703          	lbu	a4,-1(a5)
    8000437a:	c701                	beqz	a4,80004382 <exec+0x28e>
    if(*s == '/')
    8000437c:	fed71ce3          	bne	a4,a3,80004374 <exec+0x280>
    80004380:	bfc5                	j	80004370 <exec+0x27c>
  safestrcpy(p->name, last, sizeof(p->name));
    80004382:	4641                	li	a2,16
    80004384:	de843583          	ld	a1,-536(s0)
    80004388:	158b8513          	addi	a0,s7,344
    8000438c:	ffffc097          	auipc	ra,0xffffc
    80004390:	f38080e7          	jalr	-200(ra) # 800002c4 <safestrcpy>
  oldpagetable = p->pagetable;
    80004394:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80004398:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    8000439c:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800043a0:	058bb783          	ld	a5,88(s7)
    800043a4:	e6843703          	ld	a4,-408(s0)
    800043a8:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800043aa:	058bb783          	ld	a5,88(s7)
    800043ae:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800043b2:	85ea                	mv	a1,s10
    800043b4:	ffffd097          	auipc	ra,0xffffd
    800043b8:	bd6080e7          	jalr	-1066(ra) # 80000f8a <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800043bc:	0004851b          	sext.w	a0,s1
    800043c0:	bbc1                	j	80004190 <exec+0x9c>
    800043c2:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    800043c6:	df843583          	ld	a1,-520(s0)
    800043ca:	855a                	mv	a0,s6
    800043cc:	ffffd097          	auipc	ra,0xffffd
    800043d0:	bbe080e7          	jalr	-1090(ra) # 80000f8a <proc_freepagetable>
  if(ip){
    800043d4:	da0a94e3          	bnez	s5,8000417c <exec+0x88>
  return -1;
    800043d8:	557d                	li	a0,-1
    800043da:	bb5d                	j	80004190 <exec+0x9c>
    800043dc:	de943c23          	sd	s1,-520(s0)
    800043e0:	b7dd                	j	800043c6 <exec+0x2d2>
    800043e2:	de943c23          	sd	s1,-520(s0)
    800043e6:	b7c5                	j	800043c6 <exec+0x2d2>
    800043e8:	de943c23          	sd	s1,-520(s0)
    800043ec:	bfe9                	j	800043c6 <exec+0x2d2>
  sz = sz1;
    800043ee:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800043f2:	4a81                	li	s5,0
    800043f4:	bfc9                	j	800043c6 <exec+0x2d2>
  sz = sz1;
    800043f6:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800043fa:	4a81                	li	s5,0
    800043fc:	b7e9                	j	800043c6 <exec+0x2d2>
  sz = sz1;
    800043fe:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004402:	4a81                	li	s5,0
    80004404:	b7c9                	j	800043c6 <exec+0x2d2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004406:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000440a:	e0843783          	ld	a5,-504(s0)
    8000440e:	0017869b          	addiw	a3,a5,1
    80004412:	e0d43423          	sd	a3,-504(s0)
    80004416:	e0043783          	ld	a5,-512(s0)
    8000441a:	0387879b          	addiw	a5,a5,56
    8000441e:	e8845703          	lhu	a4,-376(s0)
    80004422:	e2e6d3e3          	bge	a3,a4,80004248 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004426:	2781                	sext.w	a5,a5
    80004428:	e0f43023          	sd	a5,-512(s0)
    8000442c:	03800713          	li	a4,56
    80004430:	86be                	mv	a3,a5
    80004432:	e1840613          	addi	a2,s0,-488
    80004436:	4581                	li	a1,0
    80004438:	8556                	mv	a0,s5
    8000443a:	fffff097          	auipc	ra,0xfffff
    8000443e:	a76080e7          	jalr	-1418(ra) # 80002eb0 <readi>
    80004442:	03800793          	li	a5,56
    80004446:	f6f51ee3          	bne	a0,a5,800043c2 <exec+0x2ce>
    if(ph.type != ELF_PROG_LOAD)
    8000444a:	e1842783          	lw	a5,-488(s0)
    8000444e:	4705                	li	a4,1
    80004450:	fae79de3          	bne	a5,a4,8000440a <exec+0x316>
    if(ph.memsz < ph.filesz)
    80004454:	e4043603          	ld	a2,-448(s0)
    80004458:	e3843783          	ld	a5,-456(s0)
    8000445c:	f8f660e3          	bltu	a2,a5,800043dc <exec+0x2e8>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004460:	e2843783          	ld	a5,-472(s0)
    80004464:	963e                	add	a2,a2,a5
    80004466:	f6f66ee3          	bltu	a2,a5,800043e2 <exec+0x2ee>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000446a:	85a6                	mv	a1,s1
    8000446c:	855a                	mv	a0,s6
    8000446e:	ffffc097          	auipc	ra,0xffffc
    80004472:	438080e7          	jalr	1080(ra) # 800008a6 <uvmalloc>
    80004476:	dea43c23          	sd	a0,-520(s0)
    8000447a:	d53d                	beqz	a0,800043e8 <exec+0x2f4>
    if((ph.vaddr % PGSIZE) != 0)
    8000447c:	e2843c03          	ld	s8,-472(s0)
    80004480:	de043783          	ld	a5,-544(s0)
    80004484:	00fc77b3          	and	a5,s8,a5
    80004488:	ff9d                	bnez	a5,800043c6 <exec+0x2d2>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000448a:	e2042c83          	lw	s9,-480(s0)
    8000448e:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004492:	f60b8ae3          	beqz	s7,80004406 <exec+0x312>
    80004496:	89de                	mv	s3,s7
    80004498:	4481                	li	s1,0
    8000449a:	b371                	j	80004226 <exec+0x132>

000000008000449c <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000449c:	7179                	addi	sp,sp,-48
    8000449e:	f406                	sd	ra,40(sp)
    800044a0:	f022                	sd	s0,32(sp)
    800044a2:	ec26                	sd	s1,24(sp)
    800044a4:	e84a                	sd	s2,16(sp)
    800044a6:	1800                	addi	s0,sp,48
    800044a8:	892e                	mv	s2,a1
    800044aa:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if (argint(n, &fd) < 0)
    800044ac:	fdc40593          	addi	a1,s0,-36
    800044b0:	ffffe097          	auipc	ra,0xffffe
    800044b4:	bda080e7          	jalr	-1062(ra) # 8000208a <argint>
    800044b8:	04054063          	bltz	a0,800044f8 <argfd+0x5c>
    return -1;
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
    800044bc:	fdc42703          	lw	a4,-36(s0)
    800044c0:	47bd                	li	a5,15
    800044c2:	02e7ed63          	bltu	a5,a4,800044fc <argfd+0x60>
    800044c6:	ffffd097          	auipc	ra,0xffffd
    800044ca:	964080e7          	jalr	-1692(ra) # 80000e2a <myproc>
    800044ce:	fdc42703          	lw	a4,-36(s0)
    800044d2:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7ffccdda>
    800044d6:	078e                	slli	a5,a5,0x3
    800044d8:	953e                	add	a0,a0,a5
    800044da:	611c                	ld	a5,0(a0)
    800044dc:	c395                	beqz	a5,80004500 <argfd+0x64>
    return -1;
  if (pfd)
    800044de:	00090463          	beqz	s2,800044e6 <argfd+0x4a>
    *pfd = fd;
    800044e2:	00e92023          	sw	a4,0(s2)
  if (pf)
    *pf = f;
  return 0;
    800044e6:	4501                	li	a0,0
  if (pf)
    800044e8:	c091                	beqz	s1,800044ec <argfd+0x50>
    *pf = f;
    800044ea:	e09c                	sd	a5,0(s1)
}
    800044ec:	70a2                	ld	ra,40(sp)
    800044ee:	7402                	ld	s0,32(sp)
    800044f0:	64e2                	ld	s1,24(sp)
    800044f2:	6942                	ld	s2,16(sp)
    800044f4:	6145                	addi	sp,sp,48
    800044f6:	8082                	ret
    return -1;
    800044f8:	557d                	li	a0,-1
    800044fa:	bfcd                	j	800044ec <argfd+0x50>
    return -1;
    800044fc:	557d                	li	a0,-1
    800044fe:	b7fd                	j	800044ec <argfd+0x50>
    80004500:	557d                	li	a0,-1
    80004502:	b7ed                	j	800044ec <argfd+0x50>

0000000080004504 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004504:	1101                	addi	sp,sp,-32
    80004506:	ec06                	sd	ra,24(sp)
    80004508:	e822                	sd	s0,16(sp)
    8000450a:	e426                	sd	s1,8(sp)
    8000450c:	1000                	addi	s0,sp,32
    8000450e:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004510:	ffffd097          	auipc	ra,0xffffd
    80004514:	91a080e7          	jalr	-1766(ra) # 80000e2a <myproc>
    80004518:	862a                	mv	a2,a0

  for (fd = 0; fd < NOFILE; fd++)
    8000451a:	0d050793          	addi	a5,a0,208
    8000451e:	4501                	li	a0,0
    80004520:	46c1                	li	a3,16
  {
    if (p->ofile[fd] == 0)
    80004522:	6398                	ld	a4,0(a5)
    80004524:	cb19                	beqz	a4,8000453a <fdalloc+0x36>
  for (fd = 0; fd < NOFILE; fd++)
    80004526:	2505                	addiw	a0,a0,1
    80004528:	07a1                	addi	a5,a5,8
    8000452a:	fed51ce3          	bne	a0,a3,80004522 <fdalloc+0x1e>
    {
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000452e:	557d                	li	a0,-1
}
    80004530:	60e2                	ld	ra,24(sp)
    80004532:	6442                	ld	s0,16(sp)
    80004534:	64a2                	ld	s1,8(sp)
    80004536:	6105                	addi	sp,sp,32
    80004538:	8082                	ret
      p->ofile[fd] = f;
    8000453a:	01a50793          	addi	a5,a0,26
    8000453e:	078e                	slli	a5,a5,0x3
    80004540:	963e                	add	a2,a2,a5
    80004542:	e204                	sd	s1,0(a2)
      return fd;
    80004544:	b7f5                	j	80004530 <fdalloc+0x2c>

0000000080004546 <create>:
  return -1;
}

static struct inode *
create(char *path, short type, short major, short minor)
{
    80004546:	715d                	addi	sp,sp,-80
    80004548:	e486                	sd	ra,72(sp)
    8000454a:	e0a2                	sd	s0,64(sp)
    8000454c:	fc26                	sd	s1,56(sp)
    8000454e:	f84a                	sd	s2,48(sp)
    80004550:	f44e                	sd	s3,40(sp)
    80004552:	f052                	sd	s4,32(sp)
    80004554:	ec56                	sd	s5,24(sp)
    80004556:	0880                	addi	s0,sp,80
    80004558:	89ae                	mv	s3,a1
    8000455a:	8ab2                	mv	s5,a2
    8000455c:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if ((dp = nameiparent(path, name)) == 0)
    8000455e:	fb040593          	addi	a1,s0,-80
    80004562:	fffff097          	auipc	ra,0xfffff
    80004566:	e74080e7          	jalr	-396(ra) # 800033d6 <nameiparent>
    8000456a:	892a                	mv	s2,a0
    8000456c:	12050e63          	beqz	a0,800046a8 <create+0x162>
    return 0;

  ilock(dp);
    80004570:	ffffe097          	auipc	ra,0xffffe
    80004574:	68c080e7          	jalr	1676(ra) # 80002bfc <ilock>

  if ((ip = dirlookup(dp, name, 0)) != 0)
    80004578:	4601                	li	a2,0
    8000457a:	fb040593          	addi	a1,s0,-80
    8000457e:	854a                	mv	a0,s2
    80004580:	fffff097          	auipc	ra,0xfffff
    80004584:	b60080e7          	jalr	-1184(ra) # 800030e0 <dirlookup>
    80004588:	84aa                	mv	s1,a0
    8000458a:	c921                	beqz	a0,800045da <create+0x94>
  {
    iunlockput(dp);
    8000458c:	854a                	mv	a0,s2
    8000458e:	fffff097          	auipc	ra,0xfffff
    80004592:	8d0080e7          	jalr	-1840(ra) # 80002e5e <iunlockput>
    ilock(ip);
    80004596:	8526                	mv	a0,s1
    80004598:	ffffe097          	auipc	ra,0xffffe
    8000459c:	664080e7          	jalr	1636(ra) # 80002bfc <ilock>
    if (type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800045a0:	2981                	sext.w	s3,s3
    800045a2:	4789                	li	a5,2
    800045a4:	02f99463          	bne	s3,a5,800045cc <create+0x86>
    800045a8:	0444d783          	lhu	a5,68(s1)
    800045ac:	37f9                	addiw	a5,a5,-2
    800045ae:	17c2                	slli	a5,a5,0x30
    800045b0:	93c1                	srli	a5,a5,0x30
    800045b2:	4705                	li	a4,1
    800045b4:	00f76c63          	bltu	a4,a5,800045cc <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800045b8:	8526                	mv	a0,s1
    800045ba:	60a6                	ld	ra,72(sp)
    800045bc:	6406                	ld	s0,64(sp)
    800045be:	74e2                	ld	s1,56(sp)
    800045c0:	7942                	ld	s2,48(sp)
    800045c2:	79a2                	ld	s3,40(sp)
    800045c4:	7a02                	ld	s4,32(sp)
    800045c6:	6ae2                	ld	s5,24(sp)
    800045c8:	6161                	addi	sp,sp,80
    800045ca:	8082                	ret
    iunlockput(ip);
    800045cc:	8526                	mv	a0,s1
    800045ce:	fffff097          	auipc	ra,0xfffff
    800045d2:	890080e7          	jalr	-1904(ra) # 80002e5e <iunlockput>
    return 0;
    800045d6:	4481                	li	s1,0
    800045d8:	b7c5                	j	800045b8 <create+0x72>
  if ((ip = ialloc(dp->dev, type)) == 0)
    800045da:	85ce                	mv	a1,s3
    800045dc:	00092503          	lw	a0,0(s2)
    800045e0:	ffffe097          	auipc	ra,0xffffe
    800045e4:	482080e7          	jalr	1154(ra) # 80002a62 <ialloc>
    800045e8:	84aa                	mv	s1,a0
    800045ea:	c521                	beqz	a0,80004632 <create+0xec>
  ilock(ip);
    800045ec:	ffffe097          	auipc	ra,0xffffe
    800045f0:	610080e7          	jalr	1552(ra) # 80002bfc <ilock>
  ip->major = major;
    800045f4:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    800045f8:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    800045fc:	4a05                	li	s4,1
    800045fe:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    80004602:	8526                	mv	a0,s1
    80004604:	ffffe097          	auipc	ra,0xffffe
    80004608:	52c080e7          	jalr	1324(ra) # 80002b30 <iupdate>
  if (type == T_DIR)
    8000460c:	2981                	sext.w	s3,s3
    8000460e:	03498a63          	beq	s3,s4,80004642 <create+0xfc>
  if (dirlink(dp, name, ip->inum) < 0)
    80004612:	40d0                	lw	a2,4(s1)
    80004614:	fb040593          	addi	a1,s0,-80
    80004618:	854a                	mv	a0,s2
    8000461a:	fffff097          	auipc	ra,0xfffff
    8000461e:	cdc080e7          	jalr	-804(ra) # 800032f6 <dirlink>
    80004622:	06054b63          	bltz	a0,80004698 <create+0x152>
  iunlockput(dp);
    80004626:	854a                	mv	a0,s2
    80004628:	fffff097          	auipc	ra,0xfffff
    8000462c:	836080e7          	jalr	-1994(ra) # 80002e5e <iunlockput>
  return ip;
    80004630:	b761                	j	800045b8 <create+0x72>
    panic("create: ialloc");
    80004632:	00004517          	auipc	a0,0x4
    80004636:	00e50513          	addi	a0,a0,14 # 80008640 <syscalls+0x2b0>
    8000463a:	00002097          	auipc	ra,0x2
    8000463e:	9d6080e7          	jalr	-1578(ra) # 80006010 <panic>
    dp->nlink++; // for ".."
    80004642:	04a95783          	lhu	a5,74(s2)
    80004646:	2785                	addiw	a5,a5,1
    80004648:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    8000464c:	854a                	mv	a0,s2
    8000464e:	ffffe097          	auipc	ra,0xffffe
    80004652:	4e2080e7          	jalr	1250(ra) # 80002b30 <iupdate>
    if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004656:	40d0                	lw	a2,4(s1)
    80004658:	00004597          	auipc	a1,0x4
    8000465c:	ff858593          	addi	a1,a1,-8 # 80008650 <syscalls+0x2c0>
    80004660:	8526                	mv	a0,s1
    80004662:	fffff097          	auipc	ra,0xfffff
    80004666:	c94080e7          	jalr	-876(ra) # 800032f6 <dirlink>
    8000466a:	00054f63          	bltz	a0,80004688 <create+0x142>
    8000466e:	00492603          	lw	a2,4(s2)
    80004672:	00004597          	auipc	a1,0x4
    80004676:	fe658593          	addi	a1,a1,-26 # 80008658 <syscalls+0x2c8>
    8000467a:	8526                	mv	a0,s1
    8000467c:	fffff097          	auipc	ra,0xfffff
    80004680:	c7a080e7          	jalr	-902(ra) # 800032f6 <dirlink>
    80004684:	f80557e3          	bgez	a0,80004612 <create+0xcc>
      panic("create dots");
    80004688:	00004517          	auipc	a0,0x4
    8000468c:	fd850513          	addi	a0,a0,-40 # 80008660 <syscalls+0x2d0>
    80004690:	00002097          	auipc	ra,0x2
    80004694:	980080e7          	jalr	-1664(ra) # 80006010 <panic>
    panic("create: dirlink");
    80004698:	00004517          	auipc	a0,0x4
    8000469c:	fd850513          	addi	a0,a0,-40 # 80008670 <syscalls+0x2e0>
    800046a0:	00002097          	auipc	ra,0x2
    800046a4:	970080e7          	jalr	-1680(ra) # 80006010 <panic>
    return 0;
    800046a8:	84aa                	mv	s1,a0
    800046aa:	b739                	j	800045b8 <create+0x72>

00000000800046ac <sys_dup>:
{
    800046ac:	7179                	addi	sp,sp,-48
    800046ae:	f406                	sd	ra,40(sp)
    800046b0:	f022                	sd	s0,32(sp)
    800046b2:	ec26                	sd	s1,24(sp)
    800046b4:	e84a                	sd	s2,16(sp)
    800046b6:	1800                	addi	s0,sp,48
  if (argfd(0, 0, &f) < 0)
    800046b8:	fd840613          	addi	a2,s0,-40
    800046bc:	4581                	li	a1,0
    800046be:	4501                	li	a0,0
    800046c0:	00000097          	auipc	ra,0x0
    800046c4:	ddc080e7          	jalr	-548(ra) # 8000449c <argfd>
    return -1;
    800046c8:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0)
    800046ca:	02054363          	bltz	a0,800046f0 <sys_dup+0x44>
  if ((fd = fdalloc(f)) < 0)
    800046ce:	fd843903          	ld	s2,-40(s0)
    800046d2:	854a                	mv	a0,s2
    800046d4:	00000097          	auipc	ra,0x0
    800046d8:	e30080e7          	jalr	-464(ra) # 80004504 <fdalloc>
    800046dc:	84aa                	mv	s1,a0
    return -1;
    800046de:	57fd                	li	a5,-1
  if ((fd = fdalloc(f)) < 0)
    800046e0:	00054863          	bltz	a0,800046f0 <sys_dup+0x44>
  filedup(f);
    800046e4:	854a                	mv	a0,s2
    800046e6:	fffff097          	auipc	ra,0xfffff
    800046ea:	368080e7          	jalr	872(ra) # 80003a4e <filedup>
  return fd;
    800046ee:	87a6                	mv	a5,s1
}
    800046f0:	853e                	mv	a0,a5
    800046f2:	70a2                	ld	ra,40(sp)
    800046f4:	7402                	ld	s0,32(sp)
    800046f6:	64e2                	ld	s1,24(sp)
    800046f8:	6942                	ld	s2,16(sp)
    800046fa:	6145                	addi	sp,sp,48
    800046fc:	8082                	ret

00000000800046fe <sys_read>:
{
    800046fe:	7179                	addi	sp,sp,-48
    80004700:	f406                	sd	ra,40(sp)
    80004702:	f022                	sd	s0,32(sp)
    80004704:	1800                	addi	s0,sp,48
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004706:	fe840613          	addi	a2,s0,-24
    8000470a:	4581                	li	a1,0
    8000470c:	4501                	li	a0,0
    8000470e:	00000097          	auipc	ra,0x0
    80004712:	d8e080e7          	jalr	-626(ra) # 8000449c <argfd>
    return -1;
    80004716:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004718:	04054163          	bltz	a0,8000475a <sys_read+0x5c>
    8000471c:	fe440593          	addi	a1,s0,-28
    80004720:	4509                	li	a0,2
    80004722:	ffffe097          	auipc	ra,0xffffe
    80004726:	968080e7          	jalr	-1688(ra) # 8000208a <argint>
    return -1;
    8000472a:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000472c:	02054763          	bltz	a0,8000475a <sys_read+0x5c>
    80004730:	fd840593          	addi	a1,s0,-40
    80004734:	4505                	li	a0,1
    80004736:	ffffe097          	auipc	ra,0xffffe
    8000473a:	976080e7          	jalr	-1674(ra) # 800020ac <argaddr>
    return -1;
    8000473e:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004740:	00054d63          	bltz	a0,8000475a <sys_read+0x5c>
  return fileread(f, p, n);
    80004744:	fe442603          	lw	a2,-28(s0)
    80004748:	fd843583          	ld	a1,-40(s0)
    8000474c:	fe843503          	ld	a0,-24(s0)
    80004750:	fffff097          	auipc	ra,0xfffff
    80004754:	48a080e7          	jalr	1162(ra) # 80003bda <fileread>
    80004758:	87aa                	mv	a5,a0
}
    8000475a:	853e                	mv	a0,a5
    8000475c:	70a2                	ld	ra,40(sp)
    8000475e:	7402                	ld	s0,32(sp)
    80004760:	6145                	addi	sp,sp,48
    80004762:	8082                	ret

0000000080004764 <sys_write>:
{
    80004764:	7179                	addi	sp,sp,-48
    80004766:	f406                	sd	ra,40(sp)
    80004768:	f022                	sd	s0,32(sp)
    8000476a:	1800                	addi	s0,sp,48
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000476c:	fe840613          	addi	a2,s0,-24
    80004770:	4581                	li	a1,0
    80004772:	4501                	li	a0,0
    80004774:	00000097          	auipc	ra,0x0
    80004778:	d28080e7          	jalr	-728(ra) # 8000449c <argfd>
    return -1;
    8000477c:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000477e:	04054163          	bltz	a0,800047c0 <sys_write+0x5c>
    80004782:	fe440593          	addi	a1,s0,-28
    80004786:	4509                	li	a0,2
    80004788:	ffffe097          	auipc	ra,0xffffe
    8000478c:	902080e7          	jalr	-1790(ra) # 8000208a <argint>
    return -1;
    80004790:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004792:	02054763          	bltz	a0,800047c0 <sys_write+0x5c>
    80004796:	fd840593          	addi	a1,s0,-40
    8000479a:	4505                	li	a0,1
    8000479c:	ffffe097          	auipc	ra,0xffffe
    800047a0:	910080e7          	jalr	-1776(ra) # 800020ac <argaddr>
    return -1;
    800047a4:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047a6:	00054d63          	bltz	a0,800047c0 <sys_write+0x5c>
  return filewrite(f, p, n);
    800047aa:	fe442603          	lw	a2,-28(s0)
    800047ae:	fd843583          	ld	a1,-40(s0)
    800047b2:	fe843503          	ld	a0,-24(s0)
    800047b6:	fffff097          	auipc	ra,0xfffff
    800047ba:	4e6080e7          	jalr	1254(ra) # 80003c9c <filewrite>
    800047be:	87aa                	mv	a5,a0
}
    800047c0:	853e                	mv	a0,a5
    800047c2:	70a2                	ld	ra,40(sp)
    800047c4:	7402                	ld	s0,32(sp)
    800047c6:	6145                	addi	sp,sp,48
    800047c8:	8082                	ret

00000000800047ca <sys_close>:
{
    800047ca:	1101                	addi	sp,sp,-32
    800047cc:	ec06                	sd	ra,24(sp)
    800047ce:	e822                	sd	s0,16(sp)
    800047d0:	1000                	addi	s0,sp,32
  if (argfd(0, &fd, &f) < 0)
    800047d2:	fe040613          	addi	a2,s0,-32
    800047d6:	fec40593          	addi	a1,s0,-20
    800047da:	4501                	li	a0,0
    800047dc:	00000097          	auipc	ra,0x0
    800047e0:	cc0080e7          	jalr	-832(ra) # 8000449c <argfd>
    return -1;
    800047e4:	57fd                	li	a5,-1
  if (argfd(0, &fd, &f) < 0)
    800047e6:	02054463          	bltz	a0,8000480e <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800047ea:	ffffc097          	auipc	ra,0xffffc
    800047ee:	640080e7          	jalr	1600(ra) # 80000e2a <myproc>
    800047f2:	fec42783          	lw	a5,-20(s0)
    800047f6:	07e9                	addi	a5,a5,26
    800047f8:	078e                	slli	a5,a5,0x3
    800047fa:	953e                	add	a0,a0,a5
    800047fc:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004800:	fe043503          	ld	a0,-32(s0)
    80004804:	fffff097          	auipc	ra,0xfffff
    80004808:	29c080e7          	jalr	668(ra) # 80003aa0 <fileclose>
  return 0;
    8000480c:	4781                	li	a5,0
}
    8000480e:	853e                	mv	a0,a5
    80004810:	60e2                	ld	ra,24(sp)
    80004812:	6442                	ld	s0,16(sp)
    80004814:	6105                	addi	sp,sp,32
    80004816:	8082                	ret

0000000080004818 <sys_fstat>:
{
    80004818:	1101                	addi	sp,sp,-32
    8000481a:	ec06                	sd	ra,24(sp)
    8000481c:	e822                	sd	s0,16(sp)
    8000481e:	1000                	addi	s0,sp,32
  if (argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004820:	fe840613          	addi	a2,s0,-24
    80004824:	4581                	li	a1,0
    80004826:	4501                	li	a0,0
    80004828:	00000097          	auipc	ra,0x0
    8000482c:	c74080e7          	jalr	-908(ra) # 8000449c <argfd>
    return -1;
    80004830:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004832:	02054563          	bltz	a0,8000485c <sys_fstat+0x44>
    80004836:	fe040593          	addi	a1,s0,-32
    8000483a:	4505                	li	a0,1
    8000483c:	ffffe097          	auipc	ra,0xffffe
    80004840:	870080e7          	jalr	-1936(ra) # 800020ac <argaddr>
    return -1;
    80004844:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004846:	00054b63          	bltz	a0,8000485c <sys_fstat+0x44>
  return filestat(f, st);
    8000484a:	fe043583          	ld	a1,-32(s0)
    8000484e:	fe843503          	ld	a0,-24(s0)
    80004852:	fffff097          	auipc	ra,0xfffff
    80004856:	316080e7          	jalr	790(ra) # 80003b68 <filestat>
    8000485a:	87aa                	mv	a5,a0
}
    8000485c:	853e                	mv	a0,a5
    8000485e:	60e2                	ld	ra,24(sp)
    80004860:	6442                	ld	s0,16(sp)
    80004862:	6105                	addi	sp,sp,32
    80004864:	8082                	ret

0000000080004866 <sys_link>:
{
    80004866:	7169                	addi	sp,sp,-304
    80004868:	f606                	sd	ra,296(sp)
    8000486a:	f222                	sd	s0,288(sp)
    8000486c:	ee26                	sd	s1,280(sp)
    8000486e:	ea4a                	sd	s2,272(sp)
    80004870:	1a00                	addi	s0,sp,304
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004872:	08000613          	li	a2,128
    80004876:	ed040593          	addi	a1,s0,-304
    8000487a:	4501                	li	a0,0
    8000487c:	ffffe097          	auipc	ra,0xffffe
    80004880:	852080e7          	jalr	-1966(ra) # 800020ce <argstr>
    return -1;
    80004884:	57fd                	li	a5,-1
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004886:	10054e63          	bltz	a0,800049a2 <sys_link+0x13c>
    8000488a:	08000613          	li	a2,128
    8000488e:	f5040593          	addi	a1,s0,-176
    80004892:	4505                	li	a0,1
    80004894:	ffffe097          	auipc	ra,0xffffe
    80004898:	83a080e7          	jalr	-1990(ra) # 800020ce <argstr>
    return -1;
    8000489c:	57fd                	li	a5,-1
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000489e:	10054263          	bltz	a0,800049a2 <sys_link+0x13c>
  begin_op();
    800048a2:	fffff097          	auipc	ra,0xfffff
    800048a6:	d36080e7          	jalr	-714(ra) # 800035d8 <begin_op>
  if ((ip = namei(old)) == 0)
    800048aa:	ed040513          	addi	a0,s0,-304
    800048ae:	fffff097          	auipc	ra,0xfffff
    800048b2:	b0a080e7          	jalr	-1270(ra) # 800033b8 <namei>
    800048b6:	84aa                	mv	s1,a0
    800048b8:	c551                	beqz	a0,80004944 <sys_link+0xde>
  ilock(ip);
    800048ba:	ffffe097          	auipc	ra,0xffffe
    800048be:	342080e7          	jalr	834(ra) # 80002bfc <ilock>
  if (ip->type == T_DIR)
    800048c2:	04449703          	lh	a4,68(s1)
    800048c6:	4785                	li	a5,1
    800048c8:	08f70463          	beq	a4,a5,80004950 <sys_link+0xea>
  ip->nlink++;
    800048cc:	04a4d783          	lhu	a5,74(s1)
    800048d0:	2785                	addiw	a5,a5,1
    800048d2:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800048d6:	8526                	mv	a0,s1
    800048d8:	ffffe097          	auipc	ra,0xffffe
    800048dc:	258080e7          	jalr	600(ra) # 80002b30 <iupdate>
  iunlock(ip);
    800048e0:	8526                	mv	a0,s1
    800048e2:	ffffe097          	auipc	ra,0xffffe
    800048e6:	3dc080e7          	jalr	988(ra) # 80002cbe <iunlock>
  if ((dp = nameiparent(new, name)) == 0)
    800048ea:	fd040593          	addi	a1,s0,-48
    800048ee:	f5040513          	addi	a0,s0,-176
    800048f2:	fffff097          	auipc	ra,0xfffff
    800048f6:	ae4080e7          	jalr	-1308(ra) # 800033d6 <nameiparent>
    800048fa:	892a                	mv	s2,a0
    800048fc:	c935                	beqz	a0,80004970 <sys_link+0x10a>
  ilock(dp);
    800048fe:	ffffe097          	auipc	ra,0xffffe
    80004902:	2fe080e7          	jalr	766(ra) # 80002bfc <ilock>
  if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0)
    80004906:	00092703          	lw	a4,0(s2)
    8000490a:	409c                	lw	a5,0(s1)
    8000490c:	04f71d63          	bne	a4,a5,80004966 <sys_link+0x100>
    80004910:	40d0                	lw	a2,4(s1)
    80004912:	fd040593          	addi	a1,s0,-48
    80004916:	854a                	mv	a0,s2
    80004918:	fffff097          	auipc	ra,0xfffff
    8000491c:	9de080e7          	jalr	-1570(ra) # 800032f6 <dirlink>
    80004920:	04054363          	bltz	a0,80004966 <sys_link+0x100>
  iunlockput(dp);
    80004924:	854a                	mv	a0,s2
    80004926:	ffffe097          	auipc	ra,0xffffe
    8000492a:	538080e7          	jalr	1336(ra) # 80002e5e <iunlockput>
  iput(ip);
    8000492e:	8526                	mv	a0,s1
    80004930:	ffffe097          	auipc	ra,0xffffe
    80004934:	486080e7          	jalr	1158(ra) # 80002db6 <iput>
  end_op();
    80004938:	fffff097          	auipc	ra,0xfffff
    8000493c:	d1e080e7          	jalr	-738(ra) # 80003656 <end_op>
  return 0;
    80004940:	4781                	li	a5,0
    80004942:	a085                	j	800049a2 <sys_link+0x13c>
    end_op();
    80004944:	fffff097          	auipc	ra,0xfffff
    80004948:	d12080e7          	jalr	-750(ra) # 80003656 <end_op>
    return -1;
    8000494c:	57fd                	li	a5,-1
    8000494e:	a891                	j	800049a2 <sys_link+0x13c>
    iunlockput(ip);
    80004950:	8526                	mv	a0,s1
    80004952:	ffffe097          	auipc	ra,0xffffe
    80004956:	50c080e7          	jalr	1292(ra) # 80002e5e <iunlockput>
    end_op();
    8000495a:	fffff097          	auipc	ra,0xfffff
    8000495e:	cfc080e7          	jalr	-772(ra) # 80003656 <end_op>
    return -1;
    80004962:	57fd                	li	a5,-1
    80004964:	a83d                	j	800049a2 <sys_link+0x13c>
    iunlockput(dp);
    80004966:	854a                	mv	a0,s2
    80004968:	ffffe097          	auipc	ra,0xffffe
    8000496c:	4f6080e7          	jalr	1270(ra) # 80002e5e <iunlockput>
  ilock(ip);
    80004970:	8526                	mv	a0,s1
    80004972:	ffffe097          	auipc	ra,0xffffe
    80004976:	28a080e7          	jalr	650(ra) # 80002bfc <ilock>
  ip->nlink--;
    8000497a:	04a4d783          	lhu	a5,74(s1)
    8000497e:	37fd                	addiw	a5,a5,-1
    80004980:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004984:	8526                	mv	a0,s1
    80004986:	ffffe097          	auipc	ra,0xffffe
    8000498a:	1aa080e7          	jalr	426(ra) # 80002b30 <iupdate>
  iunlockput(ip);
    8000498e:	8526                	mv	a0,s1
    80004990:	ffffe097          	auipc	ra,0xffffe
    80004994:	4ce080e7          	jalr	1230(ra) # 80002e5e <iunlockput>
  end_op();
    80004998:	fffff097          	auipc	ra,0xfffff
    8000499c:	cbe080e7          	jalr	-834(ra) # 80003656 <end_op>
  return -1;
    800049a0:	57fd                	li	a5,-1
}
    800049a2:	853e                	mv	a0,a5
    800049a4:	70b2                	ld	ra,296(sp)
    800049a6:	7412                	ld	s0,288(sp)
    800049a8:	64f2                	ld	s1,280(sp)
    800049aa:	6952                	ld	s2,272(sp)
    800049ac:	6155                	addi	sp,sp,304
    800049ae:	8082                	ret

00000000800049b0 <sys_unlink>:
{
    800049b0:	7151                	addi	sp,sp,-240
    800049b2:	f586                	sd	ra,232(sp)
    800049b4:	f1a2                	sd	s0,224(sp)
    800049b6:	eda6                	sd	s1,216(sp)
    800049b8:	e9ca                	sd	s2,208(sp)
    800049ba:	e5ce                	sd	s3,200(sp)
    800049bc:	1980                	addi	s0,sp,240
  if (argstr(0, path, MAXPATH) < 0)
    800049be:	08000613          	li	a2,128
    800049c2:	f3040593          	addi	a1,s0,-208
    800049c6:	4501                	li	a0,0
    800049c8:	ffffd097          	auipc	ra,0xffffd
    800049cc:	706080e7          	jalr	1798(ra) # 800020ce <argstr>
    800049d0:	18054163          	bltz	a0,80004b52 <sys_unlink+0x1a2>
  begin_op();
    800049d4:	fffff097          	auipc	ra,0xfffff
    800049d8:	c04080e7          	jalr	-1020(ra) # 800035d8 <begin_op>
  if ((dp = nameiparent(path, name)) == 0)
    800049dc:	fb040593          	addi	a1,s0,-80
    800049e0:	f3040513          	addi	a0,s0,-208
    800049e4:	fffff097          	auipc	ra,0xfffff
    800049e8:	9f2080e7          	jalr	-1550(ra) # 800033d6 <nameiparent>
    800049ec:	84aa                	mv	s1,a0
    800049ee:	c979                	beqz	a0,80004ac4 <sys_unlink+0x114>
  ilock(dp);
    800049f0:	ffffe097          	auipc	ra,0xffffe
    800049f4:	20c080e7          	jalr	524(ra) # 80002bfc <ilock>
  if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800049f8:	00004597          	auipc	a1,0x4
    800049fc:	c5858593          	addi	a1,a1,-936 # 80008650 <syscalls+0x2c0>
    80004a00:	fb040513          	addi	a0,s0,-80
    80004a04:	ffffe097          	auipc	ra,0xffffe
    80004a08:	6c2080e7          	jalr	1730(ra) # 800030c6 <namecmp>
    80004a0c:	14050a63          	beqz	a0,80004b60 <sys_unlink+0x1b0>
    80004a10:	00004597          	auipc	a1,0x4
    80004a14:	c4858593          	addi	a1,a1,-952 # 80008658 <syscalls+0x2c8>
    80004a18:	fb040513          	addi	a0,s0,-80
    80004a1c:	ffffe097          	auipc	ra,0xffffe
    80004a20:	6aa080e7          	jalr	1706(ra) # 800030c6 <namecmp>
    80004a24:	12050e63          	beqz	a0,80004b60 <sys_unlink+0x1b0>
  if ((ip = dirlookup(dp, name, &off)) == 0)
    80004a28:	f2c40613          	addi	a2,s0,-212
    80004a2c:	fb040593          	addi	a1,s0,-80
    80004a30:	8526                	mv	a0,s1
    80004a32:	ffffe097          	auipc	ra,0xffffe
    80004a36:	6ae080e7          	jalr	1710(ra) # 800030e0 <dirlookup>
    80004a3a:	892a                	mv	s2,a0
    80004a3c:	12050263          	beqz	a0,80004b60 <sys_unlink+0x1b0>
  ilock(ip);
    80004a40:	ffffe097          	auipc	ra,0xffffe
    80004a44:	1bc080e7          	jalr	444(ra) # 80002bfc <ilock>
  if (ip->nlink < 1)
    80004a48:	04a91783          	lh	a5,74(s2)
    80004a4c:	08f05263          	blez	a5,80004ad0 <sys_unlink+0x120>
  if (ip->type == T_DIR && !isdirempty(ip))
    80004a50:	04491703          	lh	a4,68(s2)
    80004a54:	4785                	li	a5,1
    80004a56:	08f70563          	beq	a4,a5,80004ae0 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004a5a:	4641                	li	a2,16
    80004a5c:	4581                	li	a1,0
    80004a5e:	fc040513          	addi	a0,s0,-64
    80004a62:	ffffb097          	auipc	ra,0xffffb
    80004a66:	718080e7          	jalr	1816(ra) # 8000017a <memset>
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a6a:	4741                	li	a4,16
    80004a6c:	f2c42683          	lw	a3,-212(s0)
    80004a70:	fc040613          	addi	a2,s0,-64
    80004a74:	4581                	li	a1,0
    80004a76:	8526                	mv	a0,s1
    80004a78:	ffffe097          	auipc	ra,0xffffe
    80004a7c:	530080e7          	jalr	1328(ra) # 80002fa8 <writei>
    80004a80:	47c1                	li	a5,16
    80004a82:	0af51563          	bne	a0,a5,80004b2c <sys_unlink+0x17c>
  if (ip->type == T_DIR)
    80004a86:	04491703          	lh	a4,68(s2)
    80004a8a:	4785                	li	a5,1
    80004a8c:	0af70863          	beq	a4,a5,80004b3c <sys_unlink+0x18c>
  iunlockput(dp);
    80004a90:	8526                	mv	a0,s1
    80004a92:	ffffe097          	auipc	ra,0xffffe
    80004a96:	3cc080e7          	jalr	972(ra) # 80002e5e <iunlockput>
  ip->nlink--;
    80004a9a:	04a95783          	lhu	a5,74(s2)
    80004a9e:	37fd                	addiw	a5,a5,-1
    80004aa0:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004aa4:	854a                	mv	a0,s2
    80004aa6:	ffffe097          	auipc	ra,0xffffe
    80004aaa:	08a080e7          	jalr	138(ra) # 80002b30 <iupdate>
  iunlockput(ip);
    80004aae:	854a                	mv	a0,s2
    80004ab0:	ffffe097          	auipc	ra,0xffffe
    80004ab4:	3ae080e7          	jalr	942(ra) # 80002e5e <iunlockput>
  end_op();
    80004ab8:	fffff097          	auipc	ra,0xfffff
    80004abc:	b9e080e7          	jalr	-1122(ra) # 80003656 <end_op>
  return 0;
    80004ac0:	4501                	li	a0,0
    80004ac2:	a84d                	j	80004b74 <sys_unlink+0x1c4>
    end_op();
    80004ac4:	fffff097          	auipc	ra,0xfffff
    80004ac8:	b92080e7          	jalr	-1134(ra) # 80003656 <end_op>
    return -1;
    80004acc:	557d                	li	a0,-1
    80004ace:	a05d                	j	80004b74 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004ad0:	00004517          	auipc	a0,0x4
    80004ad4:	bb050513          	addi	a0,a0,-1104 # 80008680 <syscalls+0x2f0>
    80004ad8:	00001097          	auipc	ra,0x1
    80004adc:	538080e7          	jalr	1336(ra) # 80006010 <panic>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
    80004ae0:	04c92703          	lw	a4,76(s2)
    80004ae4:	02000793          	li	a5,32
    80004ae8:	f6e7f9e3          	bgeu	a5,a4,80004a5a <sys_unlink+0xaa>
    80004aec:	02000993          	li	s3,32
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004af0:	4741                	li	a4,16
    80004af2:	86ce                	mv	a3,s3
    80004af4:	f1840613          	addi	a2,s0,-232
    80004af8:	4581                	li	a1,0
    80004afa:	854a                	mv	a0,s2
    80004afc:	ffffe097          	auipc	ra,0xffffe
    80004b00:	3b4080e7          	jalr	948(ra) # 80002eb0 <readi>
    80004b04:	47c1                	li	a5,16
    80004b06:	00f51b63          	bne	a0,a5,80004b1c <sys_unlink+0x16c>
    if (de.inum != 0)
    80004b0a:	f1845783          	lhu	a5,-232(s0)
    80004b0e:	e7a1                	bnez	a5,80004b56 <sys_unlink+0x1a6>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
    80004b10:	29c1                	addiw	s3,s3,16
    80004b12:	04c92783          	lw	a5,76(s2)
    80004b16:	fcf9ede3          	bltu	s3,a5,80004af0 <sys_unlink+0x140>
    80004b1a:	b781                	j	80004a5a <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004b1c:	00004517          	auipc	a0,0x4
    80004b20:	b7c50513          	addi	a0,a0,-1156 # 80008698 <syscalls+0x308>
    80004b24:	00001097          	auipc	ra,0x1
    80004b28:	4ec080e7          	jalr	1260(ra) # 80006010 <panic>
    panic("unlink: writei");
    80004b2c:	00004517          	auipc	a0,0x4
    80004b30:	b8450513          	addi	a0,a0,-1148 # 800086b0 <syscalls+0x320>
    80004b34:	00001097          	auipc	ra,0x1
    80004b38:	4dc080e7          	jalr	1244(ra) # 80006010 <panic>
    dp->nlink--;
    80004b3c:	04a4d783          	lhu	a5,74(s1)
    80004b40:	37fd                	addiw	a5,a5,-1
    80004b42:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004b46:	8526                	mv	a0,s1
    80004b48:	ffffe097          	auipc	ra,0xffffe
    80004b4c:	fe8080e7          	jalr	-24(ra) # 80002b30 <iupdate>
    80004b50:	b781                	j	80004a90 <sys_unlink+0xe0>
    return -1;
    80004b52:	557d                	li	a0,-1
    80004b54:	a005                	j	80004b74 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004b56:	854a                	mv	a0,s2
    80004b58:	ffffe097          	auipc	ra,0xffffe
    80004b5c:	306080e7          	jalr	774(ra) # 80002e5e <iunlockput>
  iunlockput(dp);
    80004b60:	8526                	mv	a0,s1
    80004b62:	ffffe097          	auipc	ra,0xffffe
    80004b66:	2fc080e7          	jalr	764(ra) # 80002e5e <iunlockput>
  end_op();
    80004b6a:	fffff097          	auipc	ra,0xfffff
    80004b6e:	aec080e7          	jalr	-1300(ra) # 80003656 <end_op>
  return -1;
    80004b72:	557d                	li	a0,-1
}
    80004b74:	70ae                	ld	ra,232(sp)
    80004b76:	740e                	ld	s0,224(sp)
    80004b78:	64ee                	ld	s1,216(sp)
    80004b7a:	694e                	ld	s2,208(sp)
    80004b7c:	69ae                	ld	s3,200(sp)
    80004b7e:	616d                	addi	sp,sp,240
    80004b80:	8082                	ret

0000000080004b82 <sys_open>:

uint64
sys_open(void)
{
    80004b82:	7131                	addi	sp,sp,-192
    80004b84:	fd06                	sd	ra,184(sp)
    80004b86:	f922                	sd	s0,176(sp)
    80004b88:	f526                	sd	s1,168(sp)
    80004b8a:	f14a                	sd	s2,160(sp)
    80004b8c:	ed4e                	sd	s3,152(sp)
    80004b8e:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if ((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b90:	08000613          	li	a2,128
    80004b94:	f5040593          	addi	a1,s0,-176
    80004b98:	4501                	li	a0,0
    80004b9a:	ffffd097          	auipc	ra,0xffffd
    80004b9e:	534080e7          	jalr	1332(ra) # 800020ce <argstr>
    return -1;
    80004ba2:	54fd                	li	s1,-1
  if ((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004ba4:	0c054163          	bltz	a0,80004c66 <sys_open+0xe4>
    80004ba8:	f4c40593          	addi	a1,s0,-180
    80004bac:	4505                	li	a0,1
    80004bae:	ffffd097          	auipc	ra,0xffffd
    80004bb2:	4dc080e7          	jalr	1244(ra) # 8000208a <argint>
    80004bb6:	0a054863          	bltz	a0,80004c66 <sys_open+0xe4>

  begin_op();
    80004bba:	fffff097          	auipc	ra,0xfffff
    80004bbe:	a1e080e7          	jalr	-1506(ra) # 800035d8 <begin_op>

  if (omode & O_CREATE)
    80004bc2:	f4c42783          	lw	a5,-180(s0)
    80004bc6:	2007f793          	andi	a5,a5,512
    80004bca:	cbdd                	beqz	a5,80004c80 <sys_open+0xfe>
  {
    ip = create(path, T_FILE, 0, 0);
    80004bcc:	4681                	li	a3,0
    80004bce:	4601                	li	a2,0
    80004bd0:	4589                	li	a1,2
    80004bd2:	f5040513          	addi	a0,s0,-176
    80004bd6:	00000097          	auipc	ra,0x0
    80004bda:	970080e7          	jalr	-1680(ra) # 80004546 <create>
    80004bde:	892a                	mv	s2,a0
    if (ip == 0)
    80004be0:	c959                	beqz	a0,80004c76 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if (ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV))
    80004be2:	04491703          	lh	a4,68(s2)
    80004be6:	478d                	li	a5,3
    80004be8:	00f71763          	bne	a4,a5,80004bf6 <sys_open+0x74>
    80004bec:	04695703          	lhu	a4,70(s2)
    80004bf0:	47a5                	li	a5,9
    80004bf2:	0ce7ec63          	bltu	a5,a4,80004cca <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0)
    80004bf6:	fffff097          	auipc	ra,0xfffff
    80004bfa:	dee080e7          	jalr	-530(ra) # 800039e4 <filealloc>
    80004bfe:	89aa                	mv	s3,a0
    80004c00:	10050263          	beqz	a0,80004d04 <sys_open+0x182>
    80004c04:	00000097          	auipc	ra,0x0
    80004c08:	900080e7          	jalr	-1792(ra) # 80004504 <fdalloc>
    80004c0c:	84aa                	mv	s1,a0
    80004c0e:	0e054663          	bltz	a0,80004cfa <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if (ip->type == T_DEVICE)
    80004c12:	04491703          	lh	a4,68(s2)
    80004c16:	478d                	li	a5,3
    80004c18:	0cf70463          	beq	a4,a5,80004ce0 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  }
  else
  {
    f->type = FD_INODE;
    80004c1c:	4789                	li	a5,2
    80004c1e:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004c22:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004c26:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004c2a:	f4c42783          	lw	a5,-180(s0)
    80004c2e:	0017c713          	xori	a4,a5,1
    80004c32:	8b05                	andi	a4,a4,1
    80004c34:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004c38:	0037f713          	andi	a4,a5,3
    80004c3c:	00e03733          	snez	a4,a4
    80004c40:	00e984a3          	sb	a4,9(s3)

  if ((omode & O_TRUNC) && ip->type == T_FILE)
    80004c44:	4007f793          	andi	a5,a5,1024
    80004c48:	c791                	beqz	a5,80004c54 <sys_open+0xd2>
    80004c4a:	04491703          	lh	a4,68(s2)
    80004c4e:	4789                	li	a5,2
    80004c50:	08f70f63          	beq	a4,a5,80004cee <sys_open+0x16c>
  {
    itrunc(ip);
  }

  iunlock(ip);
    80004c54:	854a                	mv	a0,s2
    80004c56:	ffffe097          	auipc	ra,0xffffe
    80004c5a:	068080e7          	jalr	104(ra) # 80002cbe <iunlock>
  end_op();
    80004c5e:	fffff097          	auipc	ra,0xfffff
    80004c62:	9f8080e7          	jalr	-1544(ra) # 80003656 <end_op>

  return fd;
}
    80004c66:	8526                	mv	a0,s1
    80004c68:	70ea                	ld	ra,184(sp)
    80004c6a:	744a                	ld	s0,176(sp)
    80004c6c:	74aa                	ld	s1,168(sp)
    80004c6e:	790a                	ld	s2,160(sp)
    80004c70:	69ea                	ld	s3,152(sp)
    80004c72:	6129                	addi	sp,sp,192
    80004c74:	8082                	ret
      end_op();
    80004c76:	fffff097          	auipc	ra,0xfffff
    80004c7a:	9e0080e7          	jalr	-1568(ra) # 80003656 <end_op>
      return -1;
    80004c7e:	b7e5                	j	80004c66 <sys_open+0xe4>
    if ((ip = namei(path)) == 0)
    80004c80:	f5040513          	addi	a0,s0,-176
    80004c84:	ffffe097          	auipc	ra,0xffffe
    80004c88:	734080e7          	jalr	1844(ra) # 800033b8 <namei>
    80004c8c:	892a                	mv	s2,a0
    80004c8e:	c905                	beqz	a0,80004cbe <sys_open+0x13c>
    ilock(ip);
    80004c90:	ffffe097          	auipc	ra,0xffffe
    80004c94:	f6c080e7          	jalr	-148(ra) # 80002bfc <ilock>
    if (ip->type == T_DIR && omode != O_RDONLY)
    80004c98:	04491703          	lh	a4,68(s2)
    80004c9c:	4785                	li	a5,1
    80004c9e:	f4f712e3          	bne	a4,a5,80004be2 <sys_open+0x60>
    80004ca2:	f4c42783          	lw	a5,-180(s0)
    80004ca6:	dba1                	beqz	a5,80004bf6 <sys_open+0x74>
      iunlockput(ip);
    80004ca8:	854a                	mv	a0,s2
    80004caa:	ffffe097          	auipc	ra,0xffffe
    80004cae:	1b4080e7          	jalr	436(ra) # 80002e5e <iunlockput>
      end_op();
    80004cb2:	fffff097          	auipc	ra,0xfffff
    80004cb6:	9a4080e7          	jalr	-1628(ra) # 80003656 <end_op>
      return -1;
    80004cba:	54fd                	li	s1,-1
    80004cbc:	b76d                	j	80004c66 <sys_open+0xe4>
      end_op();
    80004cbe:	fffff097          	auipc	ra,0xfffff
    80004cc2:	998080e7          	jalr	-1640(ra) # 80003656 <end_op>
      return -1;
    80004cc6:	54fd                	li	s1,-1
    80004cc8:	bf79                	j	80004c66 <sys_open+0xe4>
    iunlockput(ip);
    80004cca:	854a                	mv	a0,s2
    80004ccc:	ffffe097          	auipc	ra,0xffffe
    80004cd0:	192080e7          	jalr	402(ra) # 80002e5e <iunlockput>
    end_op();
    80004cd4:	fffff097          	auipc	ra,0xfffff
    80004cd8:	982080e7          	jalr	-1662(ra) # 80003656 <end_op>
    return -1;
    80004cdc:	54fd                	li	s1,-1
    80004cde:	b761                	j	80004c66 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004ce0:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004ce4:	04691783          	lh	a5,70(s2)
    80004ce8:	02f99223          	sh	a5,36(s3)
    80004cec:	bf2d                	j	80004c26 <sys_open+0xa4>
    itrunc(ip);
    80004cee:	854a                	mv	a0,s2
    80004cf0:	ffffe097          	auipc	ra,0xffffe
    80004cf4:	01a080e7          	jalr	26(ra) # 80002d0a <itrunc>
    80004cf8:	bfb1                	j	80004c54 <sys_open+0xd2>
      fileclose(f);
    80004cfa:	854e                	mv	a0,s3
    80004cfc:	fffff097          	auipc	ra,0xfffff
    80004d00:	da4080e7          	jalr	-604(ra) # 80003aa0 <fileclose>
    iunlockput(ip);
    80004d04:	854a                	mv	a0,s2
    80004d06:	ffffe097          	auipc	ra,0xffffe
    80004d0a:	158080e7          	jalr	344(ra) # 80002e5e <iunlockput>
    end_op();
    80004d0e:	fffff097          	auipc	ra,0xfffff
    80004d12:	948080e7          	jalr	-1720(ra) # 80003656 <end_op>
    return -1;
    80004d16:	54fd                	li	s1,-1
    80004d18:	b7b9                	j	80004c66 <sys_open+0xe4>

0000000080004d1a <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004d1a:	7175                	addi	sp,sp,-144
    80004d1c:	e506                	sd	ra,136(sp)
    80004d1e:	e122                	sd	s0,128(sp)
    80004d20:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004d22:	fffff097          	auipc	ra,0xfffff
    80004d26:	8b6080e7          	jalr	-1866(ra) # 800035d8 <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0)
    80004d2a:	08000613          	li	a2,128
    80004d2e:	f7040593          	addi	a1,s0,-144
    80004d32:	4501                	li	a0,0
    80004d34:	ffffd097          	auipc	ra,0xffffd
    80004d38:	39a080e7          	jalr	922(ra) # 800020ce <argstr>
    80004d3c:	02054963          	bltz	a0,80004d6e <sys_mkdir+0x54>
    80004d40:	4681                	li	a3,0
    80004d42:	4601                	li	a2,0
    80004d44:	4585                	li	a1,1
    80004d46:	f7040513          	addi	a0,s0,-144
    80004d4a:	fffff097          	auipc	ra,0xfffff
    80004d4e:	7fc080e7          	jalr	2044(ra) # 80004546 <create>
    80004d52:	cd11                	beqz	a0,80004d6e <sys_mkdir+0x54>
  {
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d54:	ffffe097          	auipc	ra,0xffffe
    80004d58:	10a080e7          	jalr	266(ra) # 80002e5e <iunlockput>
  end_op();
    80004d5c:	fffff097          	auipc	ra,0xfffff
    80004d60:	8fa080e7          	jalr	-1798(ra) # 80003656 <end_op>
  return 0;
    80004d64:	4501                	li	a0,0
}
    80004d66:	60aa                	ld	ra,136(sp)
    80004d68:	640a                	ld	s0,128(sp)
    80004d6a:	6149                	addi	sp,sp,144
    80004d6c:	8082                	ret
    end_op();
    80004d6e:	fffff097          	auipc	ra,0xfffff
    80004d72:	8e8080e7          	jalr	-1816(ra) # 80003656 <end_op>
    return -1;
    80004d76:	557d                	li	a0,-1
    80004d78:	b7fd                	j	80004d66 <sys_mkdir+0x4c>

0000000080004d7a <sys_mknod>:

uint64
sys_mknod(void)
{
    80004d7a:	7135                	addi	sp,sp,-160
    80004d7c:	ed06                	sd	ra,152(sp)
    80004d7e:	e922                	sd	s0,144(sp)
    80004d80:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004d82:	fffff097          	auipc	ra,0xfffff
    80004d86:	856080e7          	jalr	-1962(ra) # 800035d8 <begin_op>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    80004d8a:	08000613          	li	a2,128
    80004d8e:	f7040593          	addi	a1,s0,-144
    80004d92:	4501                	li	a0,0
    80004d94:	ffffd097          	auipc	ra,0xffffd
    80004d98:	33a080e7          	jalr	826(ra) # 800020ce <argstr>
    80004d9c:	04054a63          	bltz	a0,80004df0 <sys_mknod+0x76>
      argint(1, &major) < 0 ||
    80004da0:	f6c40593          	addi	a1,s0,-148
    80004da4:	4505                	li	a0,1
    80004da6:	ffffd097          	auipc	ra,0xffffd
    80004daa:	2e4080e7          	jalr	740(ra) # 8000208a <argint>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    80004dae:	04054163          	bltz	a0,80004df0 <sys_mknod+0x76>
      argint(2, &minor) < 0 ||
    80004db2:	f6840593          	addi	a1,s0,-152
    80004db6:	4509                	li	a0,2
    80004db8:	ffffd097          	auipc	ra,0xffffd
    80004dbc:	2d2080e7          	jalr	722(ra) # 8000208a <argint>
      argint(1, &major) < 0 ||
    80004dc0:	02054863          	bltz	a0,80004df0 <sys_mknod+0x76>
      (ip = create(path, T_DEVICE, major, minor)) == 0)
    80004dc4:	f6841683          	lh	a3,-152(s0)
    80004dc8:	f6c41603          	lh	a2,-148(s0)
    80004dcc:	458d                	li	a1,3
    80004dce:	f7040513          	addi	a0,s0,-144
    80004dd2:	fffff097          	auipc	ra,0xfffff
    80004dd6:	774080e7          	jalr	1908(ra) # 80004546 <create>
      argint(2, &minor) < 0 ||
    80004dda:	c919                	beqz	a0,80004df0 <sys_mknod+0x76>
  {
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004ddc:	ffffe097          	auipc	ra,0xffffe
    80004de0:	082080e7          	jalr	130(ra) # 80002e5e <iunlockput>
  end_op();
    80004de4:	fffff097          	auipc	ra,0xfffff
    80004de8:	872080e7          	jalr	-1934(ra) # 80003656 <end_op>
  return 0;
    80004dec:	4501                	li	a0,0
    80004dee:	a031                	j	80004dfa <sys_mknod+0x80>
    end_op();
    80004df0:	fffff097          	auipc	ra,0xfffff
    80004df4:	866080e7          	jalr	-1946(ra) # 80003656 <end_op>
    return -1;
    80004df8:	557d                	li	a0,-1
}
    80004dfa:	60ea                	ld	ra,152(sp)
    80004dfc:	644a                	ld	s0,144(sp)
    80004dfe:	610d                	addi	sp,sp,160
    80004e00:	8082                	ret

0000000080004e02 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004e02:	7135                	addi	sp,sp,-160
    80004e04:	ed06                	sd	ra,152(sp)
    80004e06:	e922                	sd	s0,144(sp)
    80004e08:	e526                	sd	s1,136(sp)
    80004e0a:	e14a                	sd	s2,128(sp)
    80004e0c:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004e0e:	ffffc097          	auipc	ra,0xffffc
    80004e12:	01c080e7          	jalr	28(ra) # 80000e2a <myproc>
    80004e16:	892a                	mv	s2,a0

  begin_op();
    80004e18:	ffffe097          	auipc	ra,0xffffe
    80004e1c:	7c0080e7          	jalr	1984(ra) # 800035d8 <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0)
    80004e20:	08000613          	li	a2,128
    80004e24:	f6040593          	addi	a1,s0,-160
    80004e28:	4501                	li	a0,0
    80004e2a:	ffffd097          	auipc	ra,0xffffd
    80004e2e:	2a4080e7          	jalr	676(ra) # 800020ce <argstr>
    80004e32:	04054b63          	bltz	a0,80004e88 <sys_chdir+0x86>
    80004e36:	f6040513          	addi	a0,s0,-160
    80004e3a:	ffffe097          	auipc	ra,0xffffe
    80004e3e:	57e080e7          	jalr	1406(ra) # 800033b8 <namei>
    80004e42:	84aa                	mv	s1,a0
    80004e44:	c131                	beqz	a0,80004e88 <sys_chdir+0x86>
  {
    end_op();
    return -1;
  }
  ilock(ip);
    80004e46:	ffffe097          	auipc	ra,0xffffe
    80004e4a:	db6080e7          	jalr	-586(ra) # 80002bfc <ilock>
  if (ip->type != T_DIR)
    80004e4e:	04449703          	lh	a4,68(s1)
    80004e52:	4785                	li	a5,1
    80004e54:	04f71063          	bne	a4,a5,80004e94 <sys_chdir+0x92>
  {
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004e58:	8526                	mv	a0,s1
    80004e5a:	ffffe097          	auipc	ra,0xffffe
    80004e5e:	e64080e7          	jalr	-412(ra) # 80002cbe <iunlock>
  iput(p->cwd);
    80004e62:	15093503          	ld	a0,336(s2)
    80004e66:	ffffe097          	auipc	ra,0xffffe
    80004e6a:	f50080e7          	jalr	-176(ra) # 80002db6 <iput>
  end_op();
    80004e6e:	ffffe097          	auipc	ra,0xffffe
    80004e72:	7e8080e7          	jalr	2024(ra) # 80003656 <end_op>
  p->cwd = ip;
    80004e76:	14993823          	sd	s1,336(s2)
  return 0;
    80004e7a:	4501                	li	a0,0
}
    80004e7c:	60ea                	ld	ra,152(sp)
    80004e7e:	644a                	ld	s0,144(sp)
    80004e80:	64aa                	ld	s1,136(sp)
    80004e82:	690a                	ld	s2,128(sp)
    80004e84:	610d                	addi	sp,sp,160
    80004e86:	8082                	ret
    end_op();
    80004e88:	ffffe097          	auipc	ra,0xffffe
    80004e8c:	7ce080e7          	jalr	1998(ra) # 80003656 <end_op>
    return -1;
    80004e90:	557d                	li	a0,-1
    80004e92:	b7ed                	j	80004e7c <sys_chdir+0x7a>
    iunlockput(ip);
    80004e94:	8526                	mv	a0,s1
    80004e96:	ffffe097          	auipc	ra,0xffffe
    80004e9a:	fc8080e7          	jalr	-56(ra) # 80002e5e <iunlockput>
    end_op();
    80004e9e:	ffffe097          	auipc	ra,0xffffe
    80004ea2:	7b8080e7          	jalr	1976(ra) # 80003656 <end_op>
    return -1;
    80004ea6:	557d                	li	a0,-1
    80004ea8:	bfd1                	j	80004e7c <sys_chdir+0x7a>

0000000080004eaa <sys_exec>:

uint64
sys_exec(void)
{
    80004eaa:	7145                	addi	sp,sp,-464
    80004eac:	e786                	sd	ra,456(sp)
    80004eae:	e3a2                	sd	s0,448(sp)
    80004eb0:	ff26                	sd	s1,440(sp)
    80004eb2:	fb4a                	sd	s2,432(sp)
    80004eb4:	f74e                	sd	s3,424(sp)
    80004eb6:	f352                	sd	s4,416(sp)
    80004eb8:	ef56                	sd	s5,408(sp)
    80004eba:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if (argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0)
    80004ebc:	08000613          	li	a2,128
    80004ec0:	f4040593          	addi	a1,s0,-192
    80004ec4:	4501                	li	a0,0
    80004ec6:	ffffd097          	auipc	ra,0xffffd
    80004eca:	208080e7          	jalr	520(ra) # 800020ce <argstr>
  {
    return -1;
    80004ece:	597d                	li	s2,-1
  if (argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0)
    80004ed0:	0c054b63          	bltz	a0,80004fa6 <sys_exec+0xfc>
    80004ed4:	e3840593          	addi	a1,s0,-456
    80004ed8:	4505                	li	a0,1
    80004eda:	ffffd097          	auipc	ra,0xffffd
    80004ede:	1d2080e7          	jalr	466(ra) # 800020ac <argaddr>
    80004ee2:	0c054263          	bltz	a0,80004fa6 <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    80004ee6:	10000613          	li	a2,256
    80004eea:	4581                	li	a1,0
    80004eec:	e4040513          	addi	a0,s0,-448
    80004ef0:	ffffb097          	auipc	ra,0xffffb
    80004ef4:	28a080e7          	jalr	650(ra) # 8000017a <memset>
  for (i = 0;; i++)
  {
    if (i >= NELEM(argv))
    80004ef8:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004efc:	89a6                	mv	s3,s1
    80004efe:	4901                	li	s2,0
    if (i >= NELEM(argv))
    80004f00:	02000a13          	li	s4,32
    80004f04:	00090a9b          	sext.w	s5,s2
    {
      goto bad;
    }
    if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0)
    80004f08:	00391513          	slli	a0,s2,0x3
    80004f0c:	e3040593          	addi	a1,s0,-464
    80004f10:	e3843783          	ld	a5,-456(s0)
    80004f14:	953e                	add	a0,a0,a5
    80004f16:	ffffd097          	auipc	ra,0xffffd
    80004f1a:	0da080e7          	jalr	218(ra) # 80001ff0 <fetchaddr>
    80004f1e:	02054a63          	bltz	a0,80004f52 <sys_exec+0xa8>
    {
      goto bad;
    }
    if (uarg == 0)
    80004f22:	e3043783          	ld	a5,-464(s0)
    80004f26:	c3b9                	beqz	a5,80004f6c <sys_exec+0xc2>
    {
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004f28:	ffffb097          	auipc	ra,0xffffb
    80004f2c:	1f2080e7          	jalr	498(ra) # 8000011a <kalloc>
    80004f30:	85aa                	mv	a1,a0
    80004f32:	00a9b023          	sd	a0,0(s3)
    if (argv[i] == 0)
    80004f36:	cd11                	beqz	a0,80004f52 <sys_exec+0xa8>
      goto bad;
    if (fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004f38:	6605                	lui	a2,0x1
    80004f3a:	e3043503          	ld	a0,-464(s0)
    80004f3e:	ffffd097          	auipc	ra,0xffffd
    80004f42:	104080e7          	jalr	260(ra) # 80002042 <fetchstr>
    80004f46:	00054663          	bltz	a0,80004f52 <sys_exec+0xa8>
    if (i >= NELEM(argv))
    80004f4a:	0905                	addi	s2,s2,1
    80004f4c:	09a1                	addi	s3,s3,8
    80004f4e:	fb491be3          	bne	s2,s4,80004f04 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

bad:
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f52:	f4040913          	addi	s2,s0,-192
    80004f56:	6088                	ld	a0,0(s1)
    80004f58:	c531                	beqz	a0,80004fa4 <sys_exec+0xfa>
    kfree(argv[i]);
    80004f5a:	ffffb097          	auipc	ra,0xffffb
    80004f5e:	0c2080e7          	jalr	194(ra) # 8000001c <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f62:	04a1                	addi	s1,s1,8
    80004f64:	ff2499e3          	bne	s1,s2,80004f56 <sys_exec+0xac>
  return -1;
    80004f68:	597d                	li	s2,-1
    80004f6a:	a835                	j	80004fa6 <sys_exec+0xfc>
      argv[i] = 0;
    80004f6c:	0a8e                	slli	s5,s5,0x3
    80004f6e:	fc0a8793          	addi	a5,s5,-64 # ffffffffffffefc0 <end+0xffffffff7ffccd80>
    80004f72:	00878ab3          	add	s5,a5,s0
    80004f76:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004f7a:	e4040593          	addi	a1,s0,-448
    80004f7e:	f4040513          	addi	a0,s0,-192
    80004f82:	fffff097          	auipc	ra,0xfffff
    80004f86:	172080e7          	jalr	370(ra) # 800040f4 <exec>
    80004f8a:	892a                	mv	s2,a0
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f8c:	f4040993          	addi	s3,s0,-192
    80004f90:	6088                	ld	a0,0(s1)
    80004f92:	c911                	beqz	a0,80004fa6 <sys_exec+0xfc>
    kfree(argv[i]);
    80004f94:	ffffb097          	auipc	ra,0xffffb
    80004f98:	088080e7          	jalr	136(ra) # 8000001c <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f9c:	04a1                	addi	s1,s1,8
    80004f9e:	ff3499e3          	bne	s1,s3,80004f90 <sys_exec+0xe6>
    80004fa2:	a011                	j	80004fa6 <sys_exec+0xfc>
  return -1;
    80004fa4:	597d                	li	s2,-1
}
    80004fa6:	854a                	mv	a0,s2
    80004fa8:	60be                	ld	ra,456(sp)
    80004faa:	641e                	ld	s0,448(sp)
    80004fac:	74fa                	ld	s1,440(sp)
    80004fae:	795a                	ld	s2,432(sp)
    80004fb0:	79ba                	ld	s3,424(sp)
    80004fb2:	7a1a                	ld	s4,416(sp)
    80004fb4:	6afa                	ld	s5,408(sp)
    80004fb6:	6179                	addi	sp,sp,464
    80004fb8:	8082                	ret

0000000080004fba <sys_pipe>:

uint64
sys_pipe(void)
{
    80004fba:	7139                	addi	sp,sp,-64
    80004fbc:	fc06                	sd	ra,56(sp)
    80004fbe:	f822                	sd	s0,48(sp)
    80004fc0:	f426                	sd	s1,40(sp)
    80004fc2:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004fc4:	ffffc097          	auipc	ra,0xffffc
    80004fc8:	e66080e7          	jalr	-410(ra) # 80000e2a <myproc>
    80004fcc:	84aa                	mv	s1,a0

  if (argaddr(0, &fdarray) < 0)
    80004fce:	fd840593          	addi	a1,s0,-40
    80004fd2:	4501                	li	a0,0
    80004fd4:	ffffd097          	auipc	ra,0xffffd
    80004fd8:	0d8080e7          	jalr	216(ra) # 800020ac <argaddr>
    return -1;
    80004fdc:	57fd                	li	a5,-1
  if (argaddr(0, &fdarray) < 0)
    80004fde:	0e054063          	bltz	a0,800050be <sys_pipe+0x104>
  if (pipealloc(&rf, &wf) < 0)
    80004fe2:	fc840593          	addi	a1,s0,-56
    80004fe6:	fd040513          	addi	a0,s0,-48
    80004fea:	fffff097          	auipc	ra,0xfffff
    80004fee:	de6080e7          	jalr	-538(ra) # 80003dd0 <pipealloc>
    return -1;
    80004ff2:	57fd                	li	a5,-1
  if (pipealloc(&rf, &wf) < 0)
    80004ff4:	0c054563          	bltz	a0,800050be <sys_pipe+0x104>
  fd0 = -1;
    80004ff8:	fcf42223          	sw	a5,-60(s0)
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0)
    80004ffc:	fd043503          	ld	a0,-48(s0)
    80005000:	fffff097          	auipc	ra,0xfffff
    80005004:	504080e7          	jalr	1284(ra) # 80004504 <fdalloc>
    80005008:	fca42223          	sw	a0,-60(s0)
    8000500c:	08054c63          	bltz	a0,800050a4 <sys_pipe+0xea>
    80005010:	fc843503          	ld	a0,-56(s0)
    80005014:	fffff097          	auipc	ra,0xfffff
    80005018:	4f0080e7          	jalr	1264(ra) # 80004504 <fdalloc>
    8000501c:	fca42023          	sw	a0,-64(s0)
    80005020:	06054963          	bltz	a0,80005092 <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    80005024:	4691                	li	a3,4
    80005026:	fc440613          	addi	a2,s0,-60
    8000502a:	fd843583          	ld	a1,-40(s0)
    8000502e:	68a8                	ld	a0,80(s1)
    80005030:	ffffc097          	auipc	ra,0xffffc
    80005034:	abe080e7          	jalr	-1346(ra) # 80000aee <copyout>
    80005038:	02054063          	bltz	a0,80005058 <sys_pipe+0x9e>
      copyout(p->pagetable, fdarray + sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0)
    8000503c:	4691                	li	a3,4
    8000503e:	fc040613          	addi	a2,s0,-64
    80005042:	fd843583          	ld	a1,-40(s0)
    80005046:	0591                	addi	a1,a1,4
    80005048:	68a8                	ld	a0,80(s1)
    8000504a:	ffffc097          	auipc	ra,0xffffc
    8000504e:	aa4080e7          	jalr	-1372(ra) # 80000aee <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005052:	4781                	li	a5,0
  if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    80005054:	06055563          	bgez	a0,800050be <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005058:	fc442783          	lw	a5,-60(s0)
    8000505c:	07e9                	addi	a5,a5,26
    8000505e:	078e                	slli	a5,a5,0x3
    80005060:	97a6                	add	a5,a5,s1
    80005062:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005066:	fc042783          	lw	a5,-64(s0)
    8000506a:	07e9                	addi	a5,a5,26
    8000506c:	078e                	slli	a5,a5,0x3
    8000506e:	00f48533          	add	a0,s1,a5
    80005072:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005076:	fd043503          	ld	a0,-48(s0)
    8000507a:	fffff097          	auipc	ra,0xfffff
    8000507e:	a26080e7          	jalr	-1498(ra) # 80003aa0 <fileclose>
    fileclose(wf);
    80005082:	fc843503          	ld	a0,-56(s0)
    80005086:	fffff097          	auipc	ra,0xfffff
    8000508a:	a1a080e7          	jalr	-1510(ra) # 80003aa0 <fileclose>
    return -1;
    8000508e:	57fd                	li	a5,-1
    80005090:	a03d                	j	800050be <sys_pipe+0x104>
    if (fd0 >= 0)
    80005092:	fc442783          	lw	a5,-60(s0)
    80005096:	0007c763          	bltz	a5,800050a4 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    8000509a:	07e9                	addi	a5,a5,26
    8000509c:	078e                	slli	a5,a5,0x3
    8000509e:	97a6                	add	a5,a5,s1
    800050a0:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800050a4:	fd043503          	ld	a0,-48(s0)
    800050a8:	fffff097          	auipc	ra,0xfffff
    800050ac:	9f8080e7          	jalr	-1544(ra) # 80003aa0 <fileclose>
    fileclose(wf);
    800050b0:	fc843503          	ld	a0,-56(s0)
    800050b4:	fffff097          	auipc	ra,0xfffff
    800050b8:	9ec080e7          	jalr	-1556(ra) # 80003aa0 <fileclose>
    return -1;
    800050bc:	57fd                	li	a5,-1
}
    800050be:	853e                	mv	a0,a5
    800050c0:	70e2                	ld	ra,56(sp)
    800050c2:	7442                	ld	s0,48(sp)
    800050c4:	74a2                	ld	s1,40(sp)
    800050c6:	6121                	addi	sp,sp,64
    800050c8:	8082                	ret

00000000800050ca <sys_mmap>:

uint64
sys_mmap(void)
{
    800050ca:	715d                	addi	sp,sp,-80
    800050cc:	e486                	sd	ra,72(sp)
    800050ce:	e0a2                	sd	s0,64(sp)
    800050d0:	fc26                	sd	s1,56(sp)
    800050d2:	f84a                	sd	s2,48(sp)
    800050d4:	f44e                	sd	s3,40(sp)
    800050d6:	f052                	sd	s4,32(sp)
    800050d8:	0880                	addi	s0,sp,80
  int len;
  int prot, flags, fd;
  struct file *f;
  if (argint(1, &len) < 0 || argint(2, &prot) < 0 || argint(3, &flags) < 0 || argfd(4, &fd, &f) < 0)
    800050da:	fcc40593          	addi	a1,s0,-52
    800050de:	4505                	li	a0,1
    800050e0:	ffffd097          	auipc	ra,0xffffd
    800050e4:	faa080e7          	jalr	-86(ra) # 8000208a <argint>
    return -1;
    800050e8:	57fd                	li	a5,-1
  if (argint(1, &len) < 0 || argint(2, &prot) < 0 || argint(3, &flags) < 0 || argfd(4, &fd, &f) < 0)
    800050ea:	08054063          	bltz	a0,8000516a <sys_mmap+0xa0>
    800050ee:	fc840593          	addi	a1,s0,-56
    800050f2:	4509                	li	a0,2
    800050f4:	ffffd097          	auipc	ra,0xffffd
    800050f8:	f96080e7          	jalr	-106(ra) # 8000208a <argint>
    return -1;
    800050fc:	57fd                	li	a5,-1
  if (argint(1, &len) < 0 || argint(2, &prot) < 0 || argint(3, &flags) < 0 || argfd(4, &fd, &f) < 0)
    800050fe:	06054663          	bltz	a0,8000516a <sys_mmap+0xa0>
    80005102:	fc440593          	addi	a1,s0,-60
    80005106:	450d                	li	a0,3
    80005108:	ffffd097          	auipc	ra,0xffffd
    8000510c:	f82080e7          	jalr	-126(ra) # 8000208a <argint>
    return -1;
    80005110:	57fd                	li	a5,-1
  if (argint(1, &len) < 0 || argint(2, &prot) < 0 || argint(3, &flags) < 0 || argfd(4, &fd, &f) < 0)
    80005112:	04054c63          	bltz	a0,8000516a <sys_mmap+0xa0>
    80005116:	fb840613          	addi	a2,s0,-72
    8000511a:	fc040593          	addi	a1,s0,-64
    8000511e:	4511                	li	a0,4
    80005120:	fffff097          	auipc	ra,0xfffff
    80005124:	37c080e7          	jalr	892(ra) # 8000449c <argfd>
    80005128:	0e054263          	bltz	a0,8000520c <sys_mmap+0x142>

  // if file is read-only,but map it as writable.return fail
  if (!f->writable && (prot & PROT_WRITE) && (flags & MAP_SHARED))
    8000512c:	fb843a03          	ld	s4,-72(s0)
    80005130:	009a4783          	lbu	a5,9(s4)
    80005134:	eb91                	bnez	a5,80005148 <sys_mmap+0x7e>
    80005136:	fc842783          	lw	a5,-56(s0)
    8000513a:	8b89                	andi	a5,a5,2
    8000513c:	c791                	beqz	a5,80005148 <sys_mmap+0x7e>
    8000513e:	fc442703          	lw	a4,-60(s0)
    80005142:	8b05                	andi	a4,a4,1
  {
    return -1;
    80005144:	57fd                	li	a5,-1
  if (!f->writable && (prot & PROT_WRITE) && (flags & MAP_SHARED))
    80005146:	e315                	bnez	a4,8000516a <sys_mmap+0xa0>
  }

  struct proc *p = myproc();
    80005148:	ffffc097          	auipc	ra,0xffffc
    8000514c:	ce2080e7          	jalr	-798(ra) # 80000e2a <myproc>
    80005150:	892a                	mv	s2,a0
  for (uint i = 0; i < MAXVMA; i++)
    80005152:	16850793          	addi	a5,a0,360
    80005156:	4701                	li	a4,0
    80005158:	4641                	li	a2,16
  {
    struct VMA *v = &p->vma[i];
    if (!v->used) // find an unsed vma
    8000515a:	4394                	lw	a3,0(a5)
    8000515c:	c285                	beqz	a3,8000517c <sys_mmap+0xb2>
  for (uint i = 0; i < MAXVMA; i++)
    8000515e:	2705                	addiw	a4,a4,1
    80005160:	03078793          	addi	a5,a5,48
    80005164:	fec71be3          	bne	a4,a2,8000515a <sys_mmap+0x90>
      v->start_point = 0; // staring point in f to map is 0
      return v->addr;
    }
  }

  return -1;
    80005168:	57fd                	li	a5,-1
}
    8000516a:	853e                	mv	a0,a5
    8000516c:	60a6                	ld	ra,72(sp)
    8000516e:	6406                	ld	s0,64(sp)
    80005170:	74e2                	ld	s1,56(sp)
    80005172:	7942                	ld	s2,48(sp)
    80005174:	79a2                	ld	s3,40(sp)
    80005176:	7a02                	ld	s4,32(sp)
    80005178:	6161                	addi	sp,sp,80
    8000517a:	8082                	ret
      v->used = 1;
    8000517c:	02071493          	slli	s1,a4,0x20
    80005180:	9081                	srli	s1,s1,0x20
    80005182:	00149993          	slli	s3,s1,0x1
    80005186:	009987b3          	add	a5,s3,s1
    8000518a:	0792                	slli	a5,a5,0x4
    8000518c:	97ca                	add	a5,a5,s2
    8000518e:	4705                	li	a4,1
    80005190:	16e7a423          	sw	a4,360(a5)
      v->addr = p->sz; // use p->sz to p->sz+len to map the file
    80005194:	04893703          	ld	a4,72(s2)
    80005198:	009987b3          	add	a5,s3,s1
    8000519c:	0792                	slli	a5,a5,0x4
    8000519e:	97ca                	add	a5,a5,s2
    800051a0:	16e7b823          	sd	a4,368(a5)
      len = PGROUNDUP(len);
    800051a4:	fcc42683          	lw	a3,-52(s0)
    800051a8:	6785                	lui	a5,0x1
    800051aa:	37fd                	addiw	a5,a5,-1 # fff <_entry-0x7ffff001>
    800051ac:	9fb5                	addw	a5,a5,a3
    800051ae:	76fd                	lui	a3,0xfffff
    800051b0:	8ff5                	and	a5,a5,a3
    800051b2:	2781                	sext.w	a5,a5
    800051b4:	fcf42623          	sw	a5,-52(s0)
      p->sz += len;
    800051b8:	973e                	add	a4,a4,a5
    800051ba:	04e93423          	sd	a4,72(s2)
      v->len = len;
    800051be:	00998733          	add	a4,s3,s1
    800051c2:	0712                	slli	a4,a4,0x4
    800051c4:	974a                	add	a4,a4,s2
    800051c6:	16f73c23          	sd	a5,376(a4)
      v->prot = prot;
    800051ca:	87ba                	mv	a5,a4
    800051cc:	fc842703          	lw	a4,-56(s0)
    800051d0:	18e7a023          	sw	a4,384(a5)
      v->flags = flags;
    800051d4:	009987b3          	add	a5,s3,s1
    800051d8:	0792                	slli	a5,a5,0x4
    800051da:	97ca                	add	a5,a5,s2
    800051dc:	fc442703          	lw	a4,-60(s0)
    800051e0:	18e7a223          	sw	a4,388(a5)
      v->f = filedup(f);  // increase the file's ref cnt
    800051e4:	8552                	mv	a0,s4
    800051e6:	fffff097          	auipc	ra,0xfffff
    800051ea:	868080e7          	jalr	-1944(ra) # 80003a4e <filedup>
    800051ee:	009987b3          	add	a5,s3,s1
    800051f2:	0792                	slli	a5,a5,0x4
    800051f4:	97ca                	add	a5,a5,s2
    800051f6:	18a7b423          	sd	a0,392(a5)
      v->start_point = 0; // staring point in f to map is 0
    800051fa:	009987b3          	add	a5,s3,s1
    800051fe:	0792                	slli	a5,a5,0x4
    80005200:	97ca                	add	a5,a5,s2
    80005202:	1807b823          	sd	zero,400(a5)
      return v->addr;
    80005206:	1707b783          	ld	a5,368(a5)
    8000520a:	b785                	j	8000516a <sys_mmap+0xa0>
    return -1;
    8000520c:	57fd                	li	a5,-1
    8000520e:	bfb1                	j	8000516a <sys_mmap+0xa0>

0000000080005210 <file_write_new>:

int file_write_new(struct file *f, uint64 addr, int n, uint off)
{
  int r = 0;
  if (f->writable == 0)
    80005210:	00954783          	lbu	a5,9(a0)
    80005214:	c3d5                	beqz	a5,800052b8 <file_write_new+0xa8>
{
    80005216:	711d                	addi	sp,sp,-96
    80005218:	ec86                	sd	ra,88(sp)
    8000521a:	e8a2                	sd	s0,80(sp)
    8000521c:	e4a6                	sd	s1,72(sp)
    8000521e:	e0ca                	sd	s2,64(sp)
    80005220:	fc4e                	sd	s3,56(sp)
    80005222:	f852                	sd	s4,48(sp)
    80005224:	f456                	sd	s5,40(sp)
    80005226:	f05a                	sd	s6,32(sp)
    80005228:	ec5e                	sd	s7,24(sp)
    8000522a:	e862                	sd	s8,16(sp)
    8000522c:	e466                	sd	s9,8(sp)
    8000522e:	1080                	addi	s0,sp,96
    80005230:	89aa                	mv	s3,a0
    80005232:	8bae                	mv	s7,a1
    80005234:	8ab2                	mv	s5,a2
    80005236:	8a36                	mv	s4,a3
    return -1;

  int max = ((MAXOPBLOCKS - 1 - 1 - 2) / 2) * BSIZE;
  int i = 0;
  while (i < n)
    80005238:	08c05263          	blez	a2,800052bc <file_write_new+0xac>
  int i = 0;
    8000523c:	4901                	li	s2,0
    8000523e:	6c05                	lui	s8,0x1
    80005240:	c00c0c13          	addi	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80005244:	6c85                	lui	s9,0x1
    80005246:	c00c8c9b          	addiw	s9,s9,-1024 # c00 <_entry-0x7ffff400>
    8000524a:	a8a9                	j	800052a4 <file_write_new+0x94>
    8000524c:	00048b1b          	sext.w	s6,s1
  {
    int n1 = n - i;
    if (n1 > max)
      n1 = max;

    begin_op();
    80005250:	ffffe097          	auipc	ra,0xffffe
    80005254:	388080e7          	jalr	904(ra) # 800035d8 <begin_op>
    ilock(f->ip);
    80005258:	0189b503          	ld	a0,24(s3)
    8000525c:	ffffe097          	auipc	ra,0xffffe
    80005260:	9a0080e7          	jalr	-1632(ra) # 80002bfc <ilock>
    if ((r = writei(f->ip, 1, addr + i, off, n1)) > 0)
    80005264:	875a                	mv	a4,s6
    80005266:	86d2                	mv	a3,s4
    80005268:	01790633          	add	a2,s2,s7
    8000526c:	4585                	li	a1,1
    8000526e:	0189b503          	ld	a0,24(s3)
    80005272:	ffffe097          	auipc	ra,0xffffe
    80005276:	d36080e7          	jalr	-714(ra) # 80002fa8 <writei>
    8000527a:	84aa                	mv	s1,a0
    8000527c:	00a05463          	blez	a0,80005284 <file_write_new+0x74>
      off += r;
    80005280:	01450a3b          	addw	s4,a0,s4
    iunlock(f->ip);
    80005284:	0189b503          	ld	a0,24(s3)
    80005288:	ffffe097          	auipc	ra,0xffffe
    8000528c:	a36080e7          	jalr	-1482(ra) # 80002cbe <iunlock>
    end_op();
    80005290:	ffffe097          	auipc	ra,0xffffe
    80005294:	3c6080e7          	jalr	966(ra) # 80003656 <end_op>

    if (r != n1)
    80005298:	029b1463          	bne	s6,s1,800052c0 <file_write_new+0xb0>
      break;
    i += r;
    8000529c:	0124893b          	addw	s2,s1,s2
  while (i < n)
    800052a0:	01595a63          	bge	s2,s5,800052b4 <file_write_new+0xa4>
    int n1 = n - i;
    800052a4:	412a84bb          	subw	s1,s5,s2
    800052a8:	0004879b          	sext.w	a5,s1
    800052ac:	fafc50e3          	bge	s8,a5,8000524c <file_write_new+0x3c>
    800052b0:	84e6                	mv	s1,s9
    800052b2:	bf69                	j	8000524c <file_write_new+0x3c>
  }

  return 0;
    800052b4:	4501                	li	a0,0
    800052b6:	a031                	j	800052c2 <file_write_new+0xb2>
    return -1;
    800052b8:	557d                	li	a0,-1
}
    800052ba:	8082                	ret
  return 0;
    800052bc:	4501                	li	a0,0
    800052be:	a011                	j	800052c2 <file_write_new+0xb2>
    800052c0:	4501                	li	a0,0
}
    800052c2:	60e6                	ld	ra,88(sp)
    800052c4:	6446                	ld	s0,80(sp)
    800052c6:	64a6                	ld	s1,72(sp)
    800052c8:	6906                	ld	s2,64(sp)
    800052ca:	79e2                	ld	s3,56(sp)
    800052cc:	7a42                	ld	s4,48(sp)
    800052ce:	7aa2                	ld	s5,40(sp)
    800052d0:	7b02                	ld	s6,32(sp)
    800052d2:	6be2                	ld	s7,24(sp)
    800052d4:	6c42                	ld	s8,16(sp)
    800052d6:	6ca2                	ld	s9,8(sp)
    800052d8:	6125                	addi	sp,sp,96
    800052da:	8082                	ret

00000000800052dc <sys_munmap>:

uint64
sys_munmap(void)
{
    800052dc:	7139                	addi	sp,sp,-64
    800052de:	fc06                	sd	ra,56(sp)
    800052e0:	f822                	sd	s0,48(sp)
    800052e2:	f426                	sd	s1,40(sp)
    800052e4:	f04a                	sd	s2,32(sp)
    800052e6:	ec4e                	sd	s3,24(sp)
    800052e8:	e852                	sd	s4,16(sp)
    800052ea:	0080                	addi	s0,sp,64
  uint64 addr;
  int len;
  int close = 0;
  if (argaddr(0, &addr) < 0 || argint(1, &len) < 0)
    800052ec:	fc840593          	addi	a1,s0,-56
    800052f0:	4501                	li	a0,0
    800052f2:	ffffd097          	auipc	ra,0xffffd
    800052f6:	dba080e7          	jalr	-582(ra) # 800020ac <argaddr>
    return -1;
    800052fa:	57fd                	li	a5,-1
  if (argaddr(0, &addr) < 0 || argint(1, &len) < 0)
    800052fc:	14054b63          	bltz	a0,80005452 <sys_munmap+0x176>
    80005300:	fc440593          	addi	a1,s0,-60
    80005304:	4505                	li	a0,1
    80005306:	ffffd097          	auipc	ra,0xffffd
    8000530a:	d84080e7          	jalr	-636(ra) # 8000208a <argint>
    return -1;
    8000530e:	57fd                	li	a5,-1
  if (argaddr(0, &addr) < 0 || argint(1, &len) < 0)
    80005310:	14054163          	bltz	a0,80005452 <sys_munmap+0x176>
  struct proc *p = myproc();
    80005314:	ffffc097          	auipc	ra,0xffffc
    80005318:	b16080e7          	jalr	-1258(ra) # 80000e2a <myproc>
    8000531c:	892a                	mv	s2,a0
  for (uint i = 0; i < MAXVMA; i++)
  {
    struct VMA *v = &p->vma[i];
    // only unmap at start,end or the whole region
    if (v->used && addr >= v->addr && addr <= v->addr + v->len)
    8000531e:	fc843583          	ld	a1,-56(s0)
    80005322:	16850793          	addi	a5,a0,360
  for (uint i = 0; i < MAXVMA; i++)
    80005326:	4481                	li	s1,0
    80005328:	4641                	li	a2,16
    8000532a:	a0b5                	j	80005396 <sys_munmap+0xba>
    {
      uint64 npages = 0;
      uint off = v->start_point;
      if (addr == v->addr) // unmap at start
      {
        if (len >= v->len) // unmap whole region
    8000532c:	fc442603          	lw	a2,-60(s0)
    80005330:	03066063          	bltu	a2,a6,80005350 <sys_munmap+0x74>
        {
          len = v->len;
    80005334:	fd042223          	sw	a6,-60(s0)
          v->used = 0;
    80005338:	02049713          	slli	a4,s1,0x20
    8000533c:	9301                	srli	a4,a4,0x20
    8000533e:	00171793          	slli	a5,a4,0x1
    80005342:	97ba                	add	a5,a5,a4
    80005344:	0792                	slli	a5,a5,0x4
    80005346:	97ca                	add	a5,a5,s2
    80005348:	1607a423          	sw	zero,360(a5)
          close = 1;
    8000534c:	4a05                	li	s4,1
    8000534e:	a8a5                	j	800053c6 <sys_munmap+0xea>
        }
        else // unmap from start but not whole region
        {
          v->addr += len;
    80005350:	02049893          	slli	a7,s1,0x20
    80005354:	0208d893          	srli	a7,a7,0x20
    80005358:	00189793          	slli	a5,a7,0x1
    8000535c:	01178533          	add	a0,a5,a7
    80005360:	0512                	slli	a0,a0,0x4
    80005362:	954a                	add	a0,a0,s2
    80005364:	9732                	add	a4,a4,a2
    80005366:	16e53823          	sd	a4,368(a0)
          v->start_point = len; // update start point at which to map
    8000536a:	18c53823          	sd	a2,400(a0)
  int close = 0;
    8000536e:	4a01                	li	s4,0
    80005370:	a899                	j	800053c6 <sys_munmap+0xea>
      v->len -= len;
      p->sz -= len;

      if (v->flags & MAP_SHARED) // need to write back pages
      {
        file_write_new(v->f, addr, len, off);
    80005372:	00151793          	slli	a5,a0,0x1
    80005376:	97aa                	add	a5,a5,a0
    80005378:	0792                	slli	a5,a5,0x4
    8000537a:	97ca                	add	a5,a5,s2
    8000537c:	2681                	sext.w	a3,a3
    8000537e:	1887b503          	ld	a0,392(a5)
    80005382:	00000097          	auipc	ra,0x0
    80005386:	e8e080e7          	jalr	-370(ra) # 80005210 <file_write_new>
    8000538a:	a069                	j	80005414 <sys_munmap+0x138>
  for (uint i = 0; i < MAXVMA; i++)
    8000538c:	2485                	addiw	s1,s1,1
    8000538e:	03078793          	addi	a5,a5,48
    80005392:	0ac48f63          	beq	s1,a2,80005450 <sys_munmap+0x174>
    if (v->used && addr >= v->addr && addr <= v->addr + v->len)
    80005396:	4398                	lw	a4,0(a5)
    80005398:	db75                	beqz	a4,8000538c <sys_munmap+0xb0>
    8000539a:	6798                	ld	a4,8(a5)
    8000539c:	fee5e8e3          	bltu	a1,a4,8000538c <sys_munmap+0xb0>
    800053a0:	0107b803          	ld	a6,16(a5)
    800053a4:	010706b3          	add	a3,a4,a6
    800053a8:	feb6e2e3          	bltu	a3,a1,8000538c <sys_munmap+0xb0>
      uint off = v->start_point;
    800053ac:	02049693          	slli	a3,s1,0x20
    800053b0:	9281                	srli	a3,a3,0x20
    800053b2:	00169793          	slli	a5,a3,0x1
    800053b6:	97b6                	add	a5,a5,a3
    800053b8:	0792                	slli	a5,a5,0x4
    800053ba:	97ca                	add	a5,a5,s2
    800053bc:	1907b683          	ld	a3,400(a5)
  int close = 0;
    800053c0:	4a01                	li	s4,0
      if (addr == v->addr) // unmap at start
    800053c2:	f6b705e3          	beq	a4,a1,8000532c <sys_munmap+0x50>
      len = PGROUNDUP(len);
    800053c6:	fc442783          	lw	a5,-60(s0)
    800053ca:	6985                	lui	s3,0x1
    800053cc:	39fd                	addiw	s3,s3,-1 # fff <_entry-0x7ffff001>
    800053ce:	00f989bb          	addw	s3,s3,a5
    800053d2:	767d                	lui	a2,0xfffff
    800053d4:	00c9f633          	and	a2,s3,a2
    800053d8:	2601                	sext.w	a2,a2
    800053da:	fcc42223          	sw	a2,-60(s0)
      npages = len / PGSIZE;
    800053de:	40c9d99b          	sraiw	s3,s3,0xc
      v->len -= len;
    800053e2:	02049513          	slli	a0,s1,0x20
    800053e6:	9101                	srli	a0,a0,0x20
    800053e8:	00151793          	slli	a5,a0,0x1
    800053ec:	00a78733          	add	a4,a5,a0
    800053f0:	0712                	slli	a4,a4,0x4
    800053f2:	974a                	add	a4,a4,s2
    800053f4:	40c80833          	sub	a6,a6,a2
    800053f8:	17073c23          	sd	a6,376(a4)
      p->sz -= len;
    800053fc:	04893703          	ld	a4,72(s2)
    80005400:	8f11                	sub	a4,a4,a2
    80005402:	04e93423          	sd	a4,72(s2)
      if (v->flags & MAP_SHARED) // need to write back pages
    80005406:	97aa                	add	a5,a5,a0
    80005408:	0792                	slli	a5,a5,0x4
    8000540a:	97ca                	add	a5,a5,s2
    8000540c:	1847a783          	lw	a5,388(a5)
    80005410:	8b85                	andi	a5,a5,1
    80005412:	f3a5                	bnez	a5,80005372 <sys_munmap+0x96>
      }

      uvmunmap(p->pagetable, PGROUNDDOWN(addr), npages, 0);
    80005414:	4681                	li	a3,0
    80005416:	864e                	mv	a2,s3
    80005418:	75fd                	lui	a1,0xfffff
    8000541a:	fc843783          	ld	a5,-56(s0)
    8000541e:	8dfd                	and	a1,a1,a5
    80005420:	05093503          	ld	a0,80(s2)
    80005424:	ffffb097          	auipc	ra,0xffffb
    80005428:	2e4080e7          	jalr	740(ra) # 80000708 <uvmunmap>
      // decrease ref cnt of v->f
      if (close)
        fileclose(v->f);

      return 0;
    8000542c:	4781                	li	a5,0
      if (close)
    8000542e:	020a0263          	beqz	s4,80005452 <sys_munmap+0x176>
        fileclose(v->f);
    80005432:	1482                	slli	s1,s1,0x20
    80005434:	9081                	srli	s1,s1,0x20
    80005436:	00149793          	slli	a5,s1,0x1
    8000543a:	97a6                	add	a5,a5,s1
    8000543c:	0792                	slli	a5,a5,0x4
    8000543e:	993e                	add	s2,s2,a5
    80005440:	18893503          	ld	a0,392(s2)
    80005444:	ffffe097          	auipc	ra,0xffffe
    80005448:	65c080e7          	jalr	1628(ra) # 80003aa0 <fileclose>
      return 0;
    8000544c:	4781                	li	a5,0
    8000544e:	a011                	j	80005452 <sys_munmap+0x176>
    }
  }
  return -1;
    80005450:	57fd                	li	a5,-1
}
    80005452:	853e                	mv	a0,a5
    80005454:	70e2                	ld	ra,56(sp)
    80005456:	7442                	ld	s0,48(sp)
    80005458:	74a2                	ld	s1,40(sp)
    8000545a:	7902                	ld	s2,32(sp)
    8000545c:	69e2                	ld	s3,24(sp)
    8000545e:	6a42                	ld	s4,16(sp)
    80005460:	6121                	addi	sp,sp,64
    80005462:	8082                	ret
	...

0000000080005470 <kernelvec>:
    80005470:	7111                	addi	sp,sp,-256
    80005472:	e006                	sd	ra,0(sp)
    80005474:	e40a                	sd	sp,8(sp)
    80005476:	e80e                	sd	gp,16(sp)
    80005478:	ec12                	sd	tp,24(sp)
    8000547a:	f016                	sd	t0,32(sp)
    8000547c:	f41a                	sd	t1,40(sp)
    8000547e:	f81e                	sd	t2,48(sp)
    80005480:	fc22                	sd	s0,56(sp)
    80005482:	e0a6                	sd	s1,64(sp)
    80005484:	e4aa                	sd	a0,72(sp)
    80005486:	e8ae                	sd	a1,80(sp)
    80005488:	ecb2                	sd	a2,88(sp)
    8000548a:	f0b6                	sd	a3,96(sp)
    8000548c:	f4ba                	sd	a4,104(sp)
    8000548e:	f8be                	sd	a5,112(sp)
    80005490:	fcc2                	sd	a6,120(sp)
    80005492:	e146                	sd	a7,128(sp)
    80005494:	e54a                	sd	s2,136(sp)
    80005496:	e94e                	sd	s3,144(sp)
    80005498:	ed52                	sd	s4,152(sp)
    8000549a:	f156                	sd	s5,160(sp)
    8000549c:	f55a                	sd	s6,168(sp)
    8000549e:	f95e                	sd	s7,176(sp)
    800054a0:	fd62                	sd	s8,184(sp)
    800054a2:	e1e6                	sd	s9,192(sp)
    800054a4:	e5ea                	sd	s10,200(sp)
    800054a6:	e9ee                	sd	s11,208(sp)
    800054a8:	edf2                	sd	t3,216(sp)
    800054aa:	f1f6                	sd	t4,224(sp)
    800054ac:	f5fa                	sd	t5,232(sp)
    800054ae:	f9fe                	sd	t6,240(sp)
    800054b0:	a0dfc0ef          	jal	ra,80001ebc <kerneltrap>
    800054b4:	6082                	ld	ra,0(sp)
    800054b6:	6122                	ld	sp,8(sp)
    800054b8:	61c2                	ld	gp,16(sp)
    800054ba:	7282                	ld	t0,32(sp)
    800054bc:	7322                	ld	t1,40(sp)
    800054be:	73c2                	ld	t2,48(sp)
    800054c0:	7462                	ld	s0,56(sp)
    800054c2:	6486                	ld	s1,64(sp)
    800054c4:	6526                	ld	a0,72(sp)
    800054c6:	65c6                	ld	a1,80(sp)
    800054c8:	6666                	ld	a2,88(sp)
    800054ca:	7686                	ld	a3,96(sp)
    800054cc:	7726                	ld	a4,104(sp)
    800054ce:	77c6                	ld	a5,112(sp)
    800054d0:	7866                	ld	a6,120(sp)
    800054d2:	688a                	ld	a7,128(sp)
    800054d4:	692a                	ld	s2,136(sp)
    800054d6:	69ca                	ld	s3,144(sp)
    800054d8:	6a6a                	ld	s4,152(sp)
    800054da:	7a8a                	ld	s5,160(sp)
    800054dc:	7b2a                	ld	s6,168(sp)
    800054de:	7bca                	ld	s7,176(sp)
    800054e0:	7c6a                	ld	s8,184(sp)
    800054e2:	6c8e                	ld	s9,192(sp)
    800054e4:	6d2e                	ld	s10,200(sp)
    800054e6:	6dce                	ld	s11,208(sp)
    800054e8:	6e6e                	ld	t3,216(sp)
    800054ea:	7e8e                	ld	t4,224(sp)
    800054ec:	7f2e                	ld	t5,232(sp)
    800054ee:	7fce                	ld	t6,240(sp)
    800054f0:	6111                	addi	sp,sp,256
    800054f2:	10200073          	sret
    800054f6:	00000013          	nop
    800054fa:	00000013          	nop
    800054fe:	0001                	nop

0000000080005500 <timervec>:
    80005500:	34051573          	csrrw	a0,mscratch,a0
    80005504:	e10c                	sd	a1,0(a0)
    80005506:	e510                	sd	a2,8(a0)
    80005508:	e914                	sd	a3,16(a0)
    8000550a:	6d0c                	ld	a1,24(a0)
    8000550c:	7110                	ld	a2,32(a0)
    8000550e:	6194                	ld	a3,0(a1)
    80005510:	96b2                	add	a3,a3,a2
    80005512:	e194                	sd	a3,0(a1)
    80005514:	4589                	li	a1,2
    80005516:	14459073          	csrw	sip,a1
    8000551a:	6914                	ld	a3,16(a0)
    8000551c:	6510                	ld	a2,8(a0)
    8000551e:	610c                	ld	a1,0(a0)
    80005520:	34051573          	csrrw	a0,mscratch,a0
    80005524:	30200073          	mret
	...

000000008000552a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000552a:	1141                	addi	sp,sp,-16
    8000552c:	e422                	sd	s0,8(sp)
    8000552e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005530:	0c0007b7          	lui	a5,0xc000
    80005534:	4705                	li	a4,1
    80005536:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005538:	c3d8                	sw	a4,4(a5)
}
    8000553a:	6422                	ld	s0,8(sp)
    8000553c:	0141                	addi	sp,sp,16
    8000553e:	8082                	ret

0000000080005540 <plicinithart>:

void
plicinithart(void)
{
    80005540:	1141                	addi	sp,sp,-16
    80005542:	e406                	sd	ra,8(sp)
    80005544:	e022                	sd	s0,0(sp)
    80005546:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005548:	ffffc097          	auipc	ra,0xffffc
    8000554c:	8b6080e7          	jalr	-1866(ra) # 80000dfe <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005550:	0085171b          	slliw	a4,a0,0x8
    80005554:	0c0027b7          	lui	a5,0xc002
    80005558:	97ba                	add	a5,a5,a4
    8000555a:	40200713          	li	a4,1026
    8000555e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005562:	00d5151b          	slliw	a0,a0,0xd
    80005566:	0c2017b7          	lui	a5,0xc201
    8000556a:	97aa                	add	a5,a5,a0
    8000556c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005570:	60a2                	ld	ra,8(sp)
    80005572:	6402                	ld	s0,0(sp)
    80005574:	0141                	addi	sp,sp,16
    80005576:	8082                	ret

0000000080005578 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005578:	1141                	addi	sp,sp,-16
    8000557a:	e406                	sd	ra,8(sp)
    8000557c:	e022                	sd	s0,0(sp)
    8000557e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005580:	ffffc097          	auipc	ra,0xffffc
    80005584:	87e080e7          	jalr	-1922(ra) # 80000dfe <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005588:	00d5151b          	slliw	a0,a0,0xd
    8000558c:	0c2017b7          	lui	a5,0xc201
    80005590:	97aa                	add	a5,a5,a0
  return irq;
}
    80005592:	43c8                	lw	a0,4(a5)
    80005594:	60a2                	ld	ra,8(sp)
    80005596:	6402                	ld	s0,0(sp)
    80005598:	0141                	addi	sp,sp,16
    8000559a:	8082                	ret

000000008000559c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000559c:	1101                	addi	sp,sp,-32
    8000559e:	ec06                	sd	ra,24(sp)
    800055a0:	e822                	sd	s0,16(sp)
    800055a2:	e426                	sd	s1,8(sp)
    800055a4:	1000                	addi	s0,sp,32
    800055a6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800055a8:	ffffc097          	auipc	ra,0xffffc
    800055ac:	856080e7          	jalr	-1962(ra) # 80000dfe <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800055b0:	00d5151b          	slliw	a0,a0,0xd
    800055b4:	0c2017b7          	lui	a5,0xc201
    800055b8:	97aa                	add	a5,a5,a0
    800055ba:	c3c4                	sw	s1,4(a5)
}
    800055bc:	60e2                	ld	ra,24(sp)
    800055be:	6442                	ld	s0,16(sp)
    800055c0:	64a2                	ld	s1,8(sp)
    800055c2:	6105                	addi	sp,sp,32
    800055c4:	8082                	ret

00000000800055c6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800055c6:	1141                	addi	sp,sp,-16
    800055c8:	e406                	sd	ra,8(sp)
    800055ca:	e022                	sd	s0,0(sp)
    800055cc:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800055ce:	479d                	li	a5,7
    800055d0:	06a7c863          	blt	a5,a0,80005640 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    800055d4:	00022717          	auipc	a4,0x22
    800055d8:	a2c70713          	addi	a4,a4,-1492 # 80027000 <disk>
    800055dc:	972a                	add	a4,a4,a0
    800055de:	6789                	lui	a5,0x2
    800055e0:	97ba                	add	a5,a5,a4
    800055e2:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800055e6:	e7ad                	bnez	a5,80005650 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800055e8:	00451793          	slli	a5,a0,0x4
    800055ec:	00024717          	auipc	a4,0x24
    800055f0:	a1470713          	addi	a4,a4,-1516 # 80029000 <disk+0x2000>
    800055f4:	6314                	ld	a3,0(a4)
    800055f6:	96be                	add	a3,a3,a5
    800055f8:	0006b023          	sd	zero,0(a3) # fffffffffffff000 <end+0xffffffff7ffccdc0>
  disk.desc[i].len = 0;
    800055fc:	6314                	ld	a3,0(a4)
    800055fe:	96be                	add	a3,a3,a5
    80005600:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005604:	6314                	ld	a3,0(a4)
    80005606:	96be                	add	a3,a3,a5
    80005608:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000560c:	6318                	ld	a4,0(a4)
    8000560e:	97ba                	add	a5,a5,a4
    80005610:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005614:	00022717          	auipc	a4,0x22
    80005618:	9ec70713          	addi	a4,a4,-1556 # 80027000 <disk>
    8000561c:	972a                	add	a4,a4,a0
    8000561e:	6789                	lui	a5,0x2
    80005620:	97ba                	add	a5,a5,a4
    80005622:	4705                	li	a4,1
    80005624:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    80005628:	00024517          	auipc	a0,0x24
    8000562c:	9f050513          	addi	a0,a0,-1552 # 80029018 <disk+0x2018>
    80005630:	ffffc097          	auipc	ra,0xffffc
    80005634:	088080e7          	jalr	136(ra) # 800016b8 <wakeup>
}
    80005638:	60a2                	ld	ra,8(sp)
    8000563a:	6402                	ld	s0,0(sp)
    8000563c:	0141                	addi	sp,sp,16
    8000563e:	8082                	ret
    panic("free_desc 1");
    80005640:	00003517          	auipc	a0,0x3
    80005644:	08050513          	addi	a0,a0,128 # 800086c0 <syscalls+0x330>
    80005648:	00001097          	auipc	ra,0x1
    8000564c:	9c8080e7          	jalr	-1592(ra) # 80006010 <panic>
    panic("free_desc 2");
    80005650:	00003517          	auipc	a0,0x3
    80005654:	08050513          	addi	a0,a0,128 # 800086d0 <syscalls+0x340>
    80005658:	00001097          	auipc	ra,0x1
    8000565c:	9b8080e7          	jalr	-1608(ra) # 80006010 <panic>

0000000080005660 <virtio_disk_init>:
{
    80005660:	1101                	addi	sp,sp,-32
    80005662:	ec06                	sd	ra,24(sp)
    80005664:	e822                	sd	s0,16(sp)
    80005666:	e426                	sd	s1,8(sp)
    80005668:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000566a:	00003597          	auipc	a1,0x3
    8000566e:	07658593          	addi	a1,a1,118 # 800086e0 <syscalls+0x350>
    80005672:	00024517          	auipc	a0,0x24
    80005676:	ab650513          	addi	a0,a0,-1354 # 80029128 <disk+0x2128>
    8000567a:	00001097          	auipc	ra,0x1
    8000567e:	e3e080e7          	jalr	-450(ra) # 800064b8 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005682:	100017b7          	lui	a5,0x10001
    80005686:	4398                	lw	a4,0(a5)
    80005688:	2701                	sext.w	a4,a4
    8000568a:	747277b7          	lui	a5,0x74727
    8000568e:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005692:	0ef71063          	bne	a4,a5,80005772 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005696:	100017b7          	lui	a5,0x10001
    8000569a:	43dc                	lw	a5,4(a5)
    8000569c:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000569e:	4705                	li	a4,1
    800056a0:	0ce79963          	bne	a5,a4,80005772 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800056a4:	100017b7          	lui	a5,0x10001
    800056a8:	479c                	lw	a5,8(a5)
    800056aa:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800056ac:	4709                	li	a4,2
    800056ae:	0ce79263          	bne	a5,a4,80005772 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800056b2:	100017b7          	lui	a5,0x10001
    800056b6:	47d8                	lw	a4,12(a5)
    800056b8:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800056ba:	554d47b7          	lui	a5,0x554d4
    800056be:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800056c2:	0af71863          	bne	a4,a5,80005772 <virtio_disk_init+0x112>
  *R(VIRTIO_MMIO_STATUS) = status;
    800056c6:	100017b7          	lui	a5,0x10001
    800056ca:	4705                	li	a4,1
    800056cc:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800056ce:	470d                	li	a4,3
    800056d0:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800056d2:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800056d4:	c7ffe6b7          	lui	a3,0xc7ffe
    800056d8:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fcc51f>
    800056dc:	8f75                	and	a4,a4,a3
    800056de:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800056e0:	472d                	li	a4,11
    800056e2:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800056e4:	473d                	li	a4,15
    800056e6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    800056e8:	6705                	lui	a4,0x1
    800056ea:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800056ec:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800056f0:	5bdc                	lw	a5,52(a5)
    800056f2:	2781                	sext.w	a5,a5
  if(max == 0)
    800056f4:	c7d9                	beqz	a5,80005782 <virtio_disk_init+0x122>
  if(max < NUM)
    800056f6:	471d                	li	a4,7
    800056f8:	08f77d63          	bgeu	a4,a5,80005792 <virtio_disk_init+0x132>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800056fc:	100014b7          	lui	s1,0x10001
    80005700:	47a1                	li	a5,8
    80005702:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005704:	6609                	lui	a2,0x2
    80005706:	4581                	li	a1,0
    80005708:	00022517          	auipc	a0,0x22
    8000570c:	8f850513          	addi	a0,a0,-1800 # 80027000 <disk>
    80005710:	ffffb097          	auipc	ra,0xffffb
    80005714:	a6a080e7          	jalr	-1430(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005718:	00022717          	auipc	a4,0x22
    8000571c:	8e870713          	addi	a4,a4,-1816 # 80027000 <disk>
    80005720:	00c75793          	srli	a5,a4,0xc
    80005724:	2781                	sext.w	a5,a5
    80005726:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    80005728:	00024797          	auipc	a5,0x24
    8000572c:	8d878793          	addi	a5,a5,-1832 # 80029000 <disk+0x2000>
    80005730:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005732:	00022717          	auipc	a4,0x22
    80005736:	94e70713          	addi	a4,a4,-1714 # 80027080 <disk+0x80>
    8000573a:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    8000573c:	00023717          	auipc	a4,0x23
    80005740:	8c470713          	addi	a4,a4,-1852 # 80028000 <disk+0x1000>
    80005744:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005746:	4705                	li	a4,1
    80005748:	00e78c23          	sb	a4,24(a5)
    8000574c:	00e78ca3          	sb	a4,25(a5)
    80005750:	00e78d23          	sb	a4,26(a5)
    80005754:	00e78da3          	sb	a4,27(a5)
    80005758:	00e78e23          	sb	a4,28(a5)
    8000575c:	00e78ea3          	sb	a4,29(a5)
    80005760:	00e78f23          	sb	a4,30(a5)
    80005764:	00e78fa3          	sb	a4,31(a5)
}
    80005768:	60e2                	ld	ra,24(sp)
    8000576a:	6442                	ld	s0,16(sp)
    8000576c:	64a2                	ld	s1,8(sp)
    8000576e:	6105                	addi	sp,sp,32
    80005770:	8082                	ret
    panic("could not find virtio disk");
    80005772:	00003517          	auipc	a0,0x3
    80005776:	f7e50513          	addi	a0,a0,-130 # 800086f0 <syscalls+0x360>
    8000577a:	00001097          	auipc	ra,0x1
    8000577e:	896080e7          	jalr	-1898(ra) # 80006010 <panic>
    panic("virtio disk has no queue 0");
    80005782:	00003517          	auipc	a0,0x3
    80005786:	f8e50513          	addi	a0,a0,-114 # 80008710 <syscalls+0x380>
    8000578a:	00001097          	auipc	ra,0x1
    8000578e:	886080e7          	jalr	-1914(ra) # 80006010 <panic>
    panic("virtio disk max queue too short");
    80005792:	00003517          	auipc	a0,0x3
    80005796:	f9e50513          	addi	a0,a0,-98 # 80008730 <syscalls+0x3a0>
    8000579a:	00001097          	auipc	ra,0x1
    8000579e:	876080e7          	jalr	-1930(ra) # 80006010 <panic>

00000000800057a2 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800057a2:	7119                	addi	sp,sp,-128
    800057a4:	fc86                	sd	ra,120(sp)
    800057a6:	f8a2                	sd	s0,112(sp)
    800057a8:	f4a6                	sd	s1,104(sp)
    800057aa:	f0ca                	sd	s2,96(sp)
    800057ac:	ecce                	sd	s3,88(sp)
    800057ae:	e8d2                	sd	s4,80(sp)
    800057b0:	e4d6                	sd	s5,72(sp)
    800057b2:	e0da                	sd	s6,64(sp)
    800057b4:	fc5e                	sd	s7,56(sp)
    800057b6:	f862                	sd	s8,48(sp)
    800057b8:	f466                	sd	s9,40(sp)
    800057ba:	f06a                	sd	s10,32(sp)
    800057bc:	ec6e                	sd	s11,24(sp)
    800057be:	0100                	addi	s0,sp,128
    800057c0:	8aaa                	mv	s5,a0
    800057c2:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800057c4:	00c52c83          	lw	s9,12(a0)
    800057c8:	001c9c9b          	slliw	s9,s9,0x1
    800057cc:	1c82                	slli	s9,s9,0x20
    800057ce:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800057d2:	00024517          	auipc	a0,0x24
    800057d6:	95650513          	addi	a0,a0,-1706 # 80029128 <disk+0x2128>
    800057da:	00001097          	auipc	ra,0x1
    800057de:	d6e080e7          	jalr	-658(ra) # 80006548 <acquire>
  for(int i = 0; i < 3; i++){
    800057e2:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800057e4:	44a1                	li	s1,8
      disk.free[i] = 0;
    800057e6:	00022c17          	auipc	s8,0x22
    800057ea:	81ac0c13          	addi	s8,s8,-2022 # 80027000 <disk>
    800057ee:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    800057f0:	4b0d                	li	s6,3
    800057f2:	a0ad                	j	8000585c <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    800057f4:	00fc0733          	add	a4,s8,a5
    800057f8:	975e                	add	a4,a4,s7
    800057fa:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800057fe:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005800:	0207c563          	bltz	a5,8000582a <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005804:	2905                	addiw	s2,s2,1
    80005806:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    80005808:	19690c63          	beq	s2,s6,800059a0 <virtio_disk_rw+0x1fe>
    idx[i] = alloc_desc();
    8000580c:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    8000580e:	00024717          	auipc	a4,0x24
    80005812:	80a70713          	addi	a4,a4,-2038 # 80029018 <disk+0x2018>
    80005816:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005818:	00074683          	lbu	a3,0(a4)
    8000581c:	fee1                	bnez	a3,800057f4 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    8000581e:	2785                	addiw	a5,a5,1
    80005820:	0705                	addi	a4,a4,1
    80005822:	fe979be3          	bne	a5,s1,80005818 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    80005826:	57fd                	li	a5,-1
    80005828:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    8000582a:	01205d63          	blez	s2,80005844 <virtio_disk_rw+0xa2>
    8000582e:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80005830:	000a2503          	lw	a0,0(s4)
    80005834:	00000097          	auipc	ra,0x0
    80005838:	d92080e7          	jalr	-622(ra) # 800055c6 <free_desc>
      for(int j = 0; j < i; j++)
    8000583c:	2d85                	addiw	s11,s11,1
    8000583e:	0a11                	addi	s4,s4,4
    80005840:	ff2d98e3          	bne	s11,s2,80005830 <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005844:	00024597          	auipc	a1,0x24
    80005848:	8e458593          	addi	a1,a1,-1820 # 80029128 <disk+0x2128>
    8000584c:	00023517          	auipc	a0,0x23
    80005850:	7cc50513          	addi	a0,a0,1996 # 80029018 <disk+0x2018>
    80005854:	ffffc097          	auipc	ra,0xffffc
    80005858:	cd8080e7          	jalr	-808(ra) # 8000152c <sleep>
  for(int i = 0; i < 3; i++){
    8000585c:	f8040a13          	addi	s4,s0,-128
{
    80005860:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80005862:	894e                	mv	s2,s3
    80005864:	b765                	j	8000580c <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005866:	00023697          	auipc	a3,0x23
    8000586a:	79a6b683          	ld	a3,1946(a3) # 80029000 <disk+0x2000>
    8000586e:	96ba                	add	a3,a3,a4
    80005870:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005874:	00021817          	auipc	a6,0x21
    80005878:	78c80813          	addi	a6,a6,1932 # 80027000 <disk>
    8000587c:	00023697          	auipc	a3,0x23
    80005880:	78468693          	addi	a3,a3,1924 # 80029000 <disk+0x2000>
    80005884:	6290                	ld	a2,0(a3)
    80005886:	963a                	add	a2,a2,a4
    80005888:	00c65583          	lhu	a1,12(a2)
    8000588c:	0015e593          	ori	a1,a1,1
    80005890:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    80005894:	f8842603          	lw	a2,-120(s0)
    80005898:	628c                	ld	a1,0(a3)
    8000589a:	972e                	add	a4,a4,a1
    8000589c:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800058a0:	20050593          	addi	a1,a0,512
    800058a4:	0592                	slli	a1,a1,0x4
    800058a6:	95c2                	add	a1,a1,a6
    800058a8:	577d                	li	a4,-1
    800058aa:	02e58823          	sb	a4,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800058ae:	00461713          	slli	a4,a2,0x4
    800058b2:	6290                	ld	a2,0(a3)
    800058b4:	963a                	add	a2,a2,a4
    800058b6:	03078793          	addi	a5,a5,48
    800058ba:	97c2                	add	a5,a5,a6
    800058bc:	e21c                	sd	a5,0(a2)
  disk.desc[idx[2]].len = 1;
    800058be:	629c                	ld	a5,0(a3)
    800058c0:	97ba                	add	a5,a5,a4
    800058c2:	4605                	li	a2,1
    800058c4:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800058c6:	629c                	ld	a5,0(a3)
    800058c8:	97ba                	add	a5,a5,a4
    800058ca:	4809                	li	a6,2
    800058cc:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    800058d0:	629c                	ld	a5,0(a3)
    800058d2:	97ba                	add	a5,a5,a4
    800058d4:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800058d8:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    800058dc:	0355b423          	sd	s5,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800058e0:	6698                	ld	a4,8(a3)
    800058e2:	00275783          	lhu	a5,2(a4)
    800058e6:	8b9d                	andi	a5,a5,7
    800058e8:	0786                	slli	a5,a5,0x1
    800058ea:	973e                	add	a4,a4,a5
    800058ec:	00a71223          	sh	a0,4(a4)

  __sync_synchronize();
    800058f0:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800058f4:	6698                	ld	a4,8(a3)
    800058f6:	00275783          	lhu	a5,2(a4)
    800058fa:	2785                	addiw	a5,a5,1
    800058fc:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005900:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005904:	100017b7          	lui	a5,0x10001
    80005908:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8000590c:	004aa783          	lw	a5,4(s5)
    80005910:	02c79163          	bne	a5,a2,80005932 <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    80005914:	00024917          	auipc	s2,0x24
    80005918:	81490913          	addi	s2,s2,-2028 # 80029128 <disk+0x2128>
  while(b->disk == 1) {
    8000591c:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    8000591e:	85ca                	mv	a1,s2
    80005920:	8556                	mv	a0,s5
    80005922:	ffffc097          	auipc	ra,0xffffc
    80005926:	c0a080e7          	jalr	-1014(ra) # 8000152c <sleep>
  while(b->disk == 1) {
    8000592a:	004aa783          	lw	a5,4(s5)
    8000592e:	fe9788e3          	beq	a5,s1,8000591e <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    80005932:	f8042903          	lw	s2,-128(s0)
    80005936:	20090713          	addi	a4,s2,512
    8000593a:	0712                	slli	a4,a4,0x4
    8000593c:	00021797          	auipc	a5,0x21
    80005940:	6c478793          	addi	a5,a5,1732 # 80027000 <disk>
    80005944:	97ba                	add	a5,a5,a4
    80005946:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    8000594a:	00023997          	auipc	s3,0x23
    8000594e:	6b698993          	addi	s3,s3,1718 # 80029000 <disk+0x2000>
    80005952:	00491713          	slli	a4,s2,0x4
    80005956:	0009b783          	ld	a5,0(s3)
    8000595a:	97ba                	add	a5,a5,a4
    8000595c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005960:	854a                	mv	a0,s2
    80005962:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005966:	00000097          	auipc	ra,0x0
    8000596a:	c60080e7          	jalr	-928(ra) # 800055c6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000596e:	8885                	andi	s1,s1,1
    80005970:	f0ed                	bnez	s1,80005952 <virtio_disk_rw+0x1b0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005972:	00023517          	auipc	a0,0x23
    80005976:	7b650513          	addi	a0,a0,1974 # 80029128 <disk+0x2128>
    8000597a:	00001097          	auipc	ra,0x1
    8000597e:	c82080e7          	jalr	-894(ra) # 800065fc <release>
}
    80005982:	70e6                	ld	ra,120(sp)
    80005984:	7446                	ld	s0,112(sp)
    80005986:	74a6                	ld	s1,104(sp)
    80005988:	7906                	ld	s2,96(sp)
    8000598a:	69e6                	ld	s3,88(sp)
    8000598c:	6a46                	ld	s4,80(sp)
    8000598e:	6aa6                	ld	s5,72(sp)
    80005990:	6b06                	ld	s6,64(sp)
    80005992:	7be2                	ld	s7,56(sp)
    80005994:	7c42                	ld	s8,48(sp)
    80005996:	7ca2                	ld	s9,40(sp)
    80005998:	7d02                	ld	s10,32(sp)
    8000599a:	6de2                	ld	s11,24(sp)
    8000599c:	6109                	addi	sp,sp,128
    8000599e:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800059a0:	f8042503          	lw	a0,-128(s0)
    800059a4:	20050793          	addi	a5,a0,512
    800059a8:	0792                	slli	a5,a5,0x4
  if(write)
    800059aa:	00021817          	auipc	a6,0x21
    800059ae:	65680813          	addi	a6,a6,1622 # 80027000 <disk>
    800059b2:	00f80733          	add	a4,a6,a5
    800059b6:	01a036b3          	snez	a3,s10
    800059ba:	0ad72423          	sw	a3,168(a4)
  buf0->reserved = 0;
    800059be:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    800059c2:	0b973823          	sd	s9,176(a4)
  disk.desc[idx[0]].addr = (uint64) buf0;
    800059c6:	7679                	lui	a2,0xffffe
    800059c8:	963e                	add	a2,a2,a5
    800059ca:	00023697          	auipc	a3,0x23
    800059ce:	63668693          	addi	a3,a3,1590 # 80029000 <disk+0x2000>
    800059d2:	6298                	ld	a4,0(a3)
    800059d4:	9732                	add	a4,a4,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800059d6:	0a878593          	addi	a1,a5,168
    800059da:	95c2                	add	a1,a1,a6
  disk.desc[idx[0]].addr = (uint64) buf0;
    800059dc:	e30c                	sd	a1,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800059de:	6298                	ld	a4,0(a3)
    800059e0:	9732                	add	a4,a4,a2
    800059e2:	45c1                	li	a1,16
    800059e4:	c70c                	sw	a1,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800059e6:	6298                	ld	a4,0(a3)
    800059e8:	9732                	add	a4,a4,a2
    800059ea:	4585                	li	a1,1
    800059ec:	00b71623          	sh	a1,12(a4)
  disk.desc[idx[0]].next = idx[1];
    800059f0:	f8442703          	lw	a4,-124(s0)
    800059f4:	628c                	ld	a1,0(a3)
    800059f6:	962e                	add	a2,a2,a1
    800059f8:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffcbdce>
  disk.desc[idx[1]].addr = (uint64) b->data;
    800059fc:	0712                	slli	a4,a4,0x4
    800059fe:	6290                	ld	a2,0(a3)
    80005a00:	963a                	add	a2,a2,a4
    80005a02:	058a8593          	addi	a1,s5,88
    80005a06:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005a08:	6294                	ld	a3,0(a3)
    80005a0a:	96ba                	add	a3,a3,a4
    80005a0c:	40000613          	li	a2,1024
    80005a10:	c690                	sw	a2,8(a3)
  if(write)
    80005a12:	e40d1ae3          	bnez	s10,80005866 <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80005a16:	00023697          	auipc	a3,0x23
    80005a1a:	5ea6b683          	ld	a3,1514(a3) # 80029000 <disk+0x2000>
    80005a1e:	96ba                	add	a3,a3,a4
    80005a20:	4609                	li	a2,2
    80005a22:	00c69623          	sh	a2,12(a3)
    80005a26:	b5b9                	j	80005874 <virtio_disk_rw+0xd2>

0000000080005a28 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005a28:	1101                	addi	sp,sp,-32
    80005a2a:	ec06                	sd	ra,24(sp)
    80005a2c:	e822                	sd	s0,16(sp)
    80005a2e:	e426                	sd	s1,8(sp)
    80005a30:	e04a                	sd	s2,0(sp)
    80005a32:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005a34:	00023517          	auipc	a0,0x23
    80005a38:	6f450513          	addi	a0,a0,1780 # 80029128 <disk+0x2128>
    80005a3c:	00001097          	auipc	ra,0x1
    80005a40:	b0c080e7          	jalr	-1268(ra) # 80006548 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005a44:	10001737          	lui	a4,0x10001
    80005a48:	533c                	lw	a5,96(a4)
    80005a4a:	8b8d                	andi	a5,a5,3
    80005a4c:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005a4e:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005a52:	00023797          	auipc	a5,0x23
    80005a56:	5ae78793          	addi	a5,a5,1454 # 80029000 <disk+0x2000>
    80005a5a:	6b94                	ld	a3,16(a5)
    80005a5c:	0207d703          	lhu	a4,32(a5)
    80005a60:	0026d783          	lhu	a5,2(a3)
    80005a64:	06f70163          	beq	a4,a5,80005ac6 <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005a68:	00021917          	auipc	s2,0x21
    80005a6c:	59890913          	addi	s2,s2,1432 # 80027000 <disk>
    80005a70:	00023497          	auipc	s1,0x23
    80005a74:	59048493          	addi	s1,s1,1424 # 80029000 <disk+0x2000>
    __sync_synchronize();
    80005a78:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005a7c:	6898                	ld	a4,16(s1)
    80005a7e:	0204d783          	lhu	a5,32(s1)
    80005a82:	8b9d                	andi	a5,a5,7
    80005a84:	078e                	slli	a5,a5,0x3
    80005a86:	97ba                	add	a5,a5,a4
    80005a88:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005a8a:	20078713          	addi	a4,a5,512
    80005a8e:	0712                	slli	a4,a4,0x4
    80005a90:	974a                	add	a4,a4,s2
    80005a92:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    80005a96:	e731                	bnez	a4,80005ae2 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005a98:	20078793          	addi	a5,a5,512
    80005a9c:	0792                	slli	a5,a5,0x4
    80005a9e:	97ca                	add	a5,a5,s2
    80005aa0:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005aa2:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005aa6:	ffffc097          	auipc	ra,0xffffc
    80005aaa:	c12080e7          	jalr	-1006(ra) # 800016b8 <wakeup>

    disk.used_idx += 1;
    80005aae:	0204d783          	lhu	a5,32(s1)
    80005ab2:	2785                	addiw	a5,a5,1
    80005ab4:	17c2                	slli	a5,a5,0x30
    80005ab6:	93c1                	srli	a5,a5,0x30
    80005ab8:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005abc:	6898                	ld	a4,16(s1)
    80005abe:	00275703          	lhu	a4,2(a4)
    80005ac2:	faf71be3          	bne	a4,a5,80005a78 <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    80005ac6:	00023517          	auipc	a0,0x23
    80005aca:	66250513          	addi	a0,a0,1634 # 80029128 <disk+0x2128>
    80005ace:	00001097          	auipc	ra,0x1
    80005ad2:	b2e080e7          	jalr	-1234(ra) # 800065fc <release>
}
    80005ad6:	60e2                	ld	ra,24(sp)
    80005ad8:	6442                	ld	s0,16(sp)
    80005ada:	64a2                	ld	s1,8(sp)
    80005adc:	6902                	ld	s2,0(sp)
    80005ade:	6105                	addi	sp,sp,32
    80005ae0:	8082                	ret
      panic("virtio_disk_intr status");
    80005ae2:	00003517          	auipc	a0,0x3
    80005ae6:	c6e50513          	addi	a0,a0,-914 # 80008750 <syscalls+0x3c0>
    80005aea:	00000097          	auipc	ra,0x0
    80005aee:	526080e7          	jalr	1318(ra) # 80006010 <panic>

0000000080005af2 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005af2:	1141                	addi	sp,sp,-16
    80005af4:	e422                	sd	s0,8(sp)
    80005af6:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005af8:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005afc:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005b00:	0037979b          	slliw	a5,a5,0x3
    80005b04:	02004737          	lui	a4,0x2004
    80005b08:	97ba                	add	a5,a5,a4
    80005b0a:	0200c737          	lui	a4,0x200c
    80005b0e:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005b12:	000f4637          	lui	a2,0xf4
    80005b16:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005b1a:	9732                	add	a4,a4,a2
    80005b1c:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005b1e:	00259693          	slli	a3,a1,0x2
    80005b22:	96ae                	add	a3,a3,a1
    80005b24:	068e                	slli	a3,a3,0x3
    80005b26:	00024717          	auipc	a4,0x24
    80005b2a:	4da70713          	addi	a4,a4,1242 # 8002a000 <timer_scratch>
    80005b2e:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005b30:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005b32:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005b34:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005b38:	00000797          	auipc	a5,0x0
    80005b3c:	9c878793          	addi	a5,a5,-1592 # 80005500 <timervec>
    80005b40:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005b44:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005b48:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005b4c:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005b50:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005b54:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005b58:	30479073          	csrw	mie,a5
}
    80005b5c:	6422                	ld	s0,8(sp)
    80005b5e:	0141                	addi	sp,sp,16
    80005b60:	8082                	ret

0000000080005b62 <start>:
{
    80005b62:	1141                	addi	sp,sp,-16
    80005b64:	e406                	sd	ra,8(sp)
    80005b66:	e022                	sd	s0,0(sp)
    80005b68:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005b6a:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005b6e:	7779                	lui	a4,0xffffe
    80005b70:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffcc5bf>
    80005b74:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005b76:	6705                	lui	a4,0x1
    80005b78:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005b7c:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005b7e:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005b82:	ffffa797          	auipc	a5,0xffffa
    80005b86:	79e78793          	addi	a5,a5,1950 # 80000320 <main>
    80005b8a:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005b8e:	4781                	li	a5,0
    80005b90:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005b94:	67c1                	lui	a5,0x10
    80005b96:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005b98:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005b9c:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005ba0:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005ba4:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005ba8:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005bac:	57fd                	li	a5,-1
    80005bae:	83a9                	srli	a5,a5,0xa
    80005bb0:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005bb4:	47bd                	li	a5,15
    80005bb6:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005bba:	00000097          	auipc	ra,0x0
    80005bbe:	f38080e7          	jalr	-200(ra) # 80005af2 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005bc2:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005bc6:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005bc8:	823e                	mv	tp,a5
  asm volatile("mret");
    80005bca:	30200073          	mret
}
    80005bce:	60a2                	ld	ra,8(sp)
    80005bd0:	6402                	ld	s0,0(sp)
    80005bd2:	0141                	addi	sp,sp,16
    80005bd4:	8082                	ret

0000000080005bd6 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005bd6:	715d                	addi	sp,sp,-80
    80005bd8:	e486                	sd	ra,72(sp)
    80005bda:	e0a2                	sd	s0,64(sp)
    80005bdc:	fc26                	sd	s1,56(sp)
    80005bde:	f84a                	sd	s2,48(sp)
    80005be0:	f44e                	sd	s3,40(sp)
    80005be2:	f052                	sd	s4,32(sp)
    80005be4:	ec56                	sd	s5,24(sp)
    80005be6:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005be8:	04c05763          	blez	a2,80005c36 <consolewrite+0x60>
    80005bec:	8a2a                	mv	s4,a0
    80005bee:	84ae                	mv	s1,a1
    80005bf0:	89b2                	mv	s3,a2
    80005bf2:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005bf4:	5afd                	li	s5,-1
    80005bf6:	4685                	li	a3,1
    80005bf8:	8626                	mv	a2,s1
    80005bfa:	85d2                	mv	a1,s4
    80005bfc:	fbf40513          	addi	a0,s0,-65
    80005c00:	ffffc097          	auipc	ra,0xffffc
    80005c04:	d62080e7          	jalr	-670(ra) # 80001962 <either_copyin>
    80005c08:	01550d63          	beq	a0,s5,80005c22 <consolewrite+0x4c>
      break;
    uartputc(c);
    80005c0c:	fbf44503          	lbu	a0,-65(s0)
    80005c10:	00000097          	auipc	ra,0x0
    80005c14:	77e080e7          	jalr	1918(ra) # 8000638e <uartputc>
  for(i = 0; i < n; i++){
    80005c18:	2905                	addiw	s2,s2,1
    80005c1a:	0485                	addi	s1,s1,1
    80005c1c:	fd299de3          	bne	s3,s2,80005bf6 <consolewrite+0x20>
    80005c20:	894e                	mv	s2,s3
  }

  return i;
}
    80005c22:	854a                	mv	a0,s2
    80005c24:	60a6                	ld	ra,72(sp)
    80005c26:	6406                	ld	s0,64(sp)
    80005c28:	74e2                	ld	s1,56(sp)
    80005c2a:	7942                	ld	s2,48(sp)
    80005c2c:	79a2                	ld	s3,40(sp)
    80005c2e:	7a02                	ld	s4,32(sp)
    80005c30:	6ae2                	ld	s5,24(sp)
    80005c32:	6161                	addi	sp,sp,80
    80005c34:	8082                	ret
  for(i = 0; i < n; i++){
    80005c36:	4901                	li	s2,0
    80005c38:	b7ed                	j	80005c22 <consolewrite+0x4c>

0000000080005c3a <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005c3a:	7159                	addi	sp,sp,-112
    80005c3c:	f486                	sd	ra,104(sp)
    80005c3e:	f0a2                	sd	s0,96(sp)
    80005c40:	eca6                	sd	s1,88(sp)
    80005c42:	e8ca                	sd	s2,80(sp)
    80005c44:	e4ce                	sd	s3,72(sp)
    80005c46:	e0d2                	sd	s4,64(sp)
    80005c48:	fc56                	sd	s5,56(sp)
    80005c4a:	f85a                	sd	s6,48(sp)
    80005c4c:	f45e                	sd	s7,40(sp)
    80005c4e:	f062                	sd	s8,32(sp)
    80005c50:	ec66                	sd	s9,24(sp)
    80005c52:	e86a                	sd	s10,16(sp)
    80005c54:	1880                	addi	s0,sp,112
    80005c56:	8aaa                	mv	s5,a0
    80005c58:	8a2e                	mv	s4,a1
    80005c5a:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005c5c:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005c60:	0002c517          	auipc	a0,0x2c
    80005c64:	4e050513          	addi	a0,a0,1248 # 80032140 <cons>
    80005c68:	00001097          	auipc	ra,0x1
    80005c6c:	8e0080e7          	jalr	-1824(ra) # 80006548 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005c70:	0002c497          	auipc	s1,0x2c
    80005c74:	4d048493          	addi	s1,s1,1232 # 80032140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005c78:	0002c917          	auipc	s2,0x2c
    80005c7c:	56090913          	addi	s2,s2,1376 # 800321d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005c80:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005c82:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005c84:	4ca9                	li	s9,10
  while(n > 0){
    80005c86:	07305863          	blez	s3,80005cf6 <consoleread+0xbc>
    while(cons.r == cons.w){
    80005c8a:	0984a783          	lw	a5,152(s1)
    80005c8e:	09c4a703          	lw	a4,156(s1)
    80005c92:	02f71463          	bne	a4,a5,80005cba <consoleread+0x80>
      if(myproc()->killed){
    80005c96:	ffffb097          	auipc	ra,0xffffb
    80005c9a:	194080e7          	jalr	404(ra) # 80000e2a <myproc>
    80005c9e:	551c                	lw	a5,40(a0)
    80005ca0:	e7b5                	bnez	a5,80005d0c <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    80005ca2:	85a6                	mv	a1,s1
    80005ca4:	854a                	mv	a0,s2
    80005ca6:	ffffc097          	auipc	ra,0xffffc
    80005caa:	886080e7          	jalr	-1914(ra) # 8000152c <sleep>
    while(cons.r == cons.w){
    80005cae:	0984a783          	lw	a5,152(s1)
    80005cb2:	09c4a703          	lw	a4,156(s1)
    80005cb6:	fef700e3          	beq	a4,a5,80005c96 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005cba:	0017871b          	addiw	a4,a5,1
    80005cbe:	08e4ac23          	sw	a4,152(s1)
    80005cc2:	07f7f713          	andi	a4,a5,127
    80005cc6:	9726                	add	a4,a4,s1
    80005cc8:	01874703          	lbu	a4,24(a4)
    80005ccc:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80005cd0:	077d0563          	beq	s10,s7,80005d3a <consoleread+0x100>
    cbuf = c;
    80005cd4:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005cd8:	4685                	li	a3,1
    80005cda:	f9f40613          	addi	a2,s0,-97
    80005cde:	85d2                	mv	a1,s4
    80005ce0:	8556                	mv	a0,s5
    80005ce2:	ffffc097          	auipc	ra,0xffffc
    80005ce6:	c2a080e7          	jalr	-982(ra) # 8000190c <either_copyout>
    80005cea:	01850663          	beq	a0,s8,80005cf6 <consoleread+0xbc>
    dst++;
    80005cee:	0a05                	addi	s4,s4,1
    --n;
    80005cf0:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80005cf2:	f99d1ae3          	bne	s10,s9,80005c86 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005cf6:	0002c517          	auipc	a0,0x2c
    80005cfa:	44a50513          	addi	a0,a0,1098 # 80032140 <cons>
    80005cfe:	00001097          	auipc	ra,0x1
    80005d02:	8fe080e7          	jalr	-1794(ra) # 800065fc <release>

  return target - n;
    80005d06:	413b053b          	subw	a0,s6,s3
    80005d0a:	a811                	j	80005d1e <consoleread+0xe4>
        release(&cons.lock);
    80005d0c:	0002c517          	auipc	a0,0x2c
    80005d10:	43450513          	addi	a0,a0,1076 # 80032140 <cons>
    80005d14:	00001097          	auipc	ra,0x1
    80005d18:	8e8080e7          	jalr	-1816(ra) # 800065fc <release>
        return -1;
    80005d1c:	557d                	li	a0,-1
}
    80005d1e:	70a6                	ld	ra,104(sp)
    80005d20:	7406                	ld	s0,96(sp)
    80005d22:	64e6                	ld	s1,88(sp)
    80005d24:	6946                	ld	s2,80(sp)
    80005d26:	69a6                	ld	s3,72(sp)
    80005d28:	6a06                	ld	s4,64(sp)
    80005d2a:	7ae2                	ld	s5,56(sp)
    80005d2c:	7b42                	ld	s6,48(sp)
    80005d2e:	7ba2                	ld	s7,40(sp)
    80005d30:	7c02                	ld	s8,32(sp)
    80005d32:	6ce2                	ld	s9,24(sp)
    80005d34:	6d42                	ld	s10,16(sp)
    80005d36:	6165                	addi	sp,sp,112
    80005d38:	8082                	ret
      if(n < target){
    80005d3a:	0009871b          	sext.w	a4,s3
    80005d3e:	fb677ce3          	bgeu	a4,s6,80005cf6 <consoleread+0xbc>
        cons.r--;
    80005d42:	0002c717          	auipc	a4,0x2c
    80005d46:	48f72b23          	sw	a5,1174(a4) # 800321d8 <cons+0x98>
    80005d4a:	b775                	j	80005cf6 <consoleread+0xbc>

0000000080005d4c <consputc>:
{
    80005d4c:	1141                	addi	sp,sp,-16
    80005d4e:	e406                	sd	ra,8(sp)
    80005d50:	e022                	sd	s0,0(sp)
    80005d52:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005d54:	10000793          	li	a5,256
    80005d58:	00f50a63          	beq	a0,a5,80005d6c <consputc+0x20>
    uartputc_sync(c);
    80005d5c:	00000097          	auipc	ra,0x0
    80005d60:	560080e7          	jalr	1376(ra) # 800062bc <uartputc_sync>
}
    80005d64:	60a2                	ld	ra,8(sp)
    80005d66:	6402                	ld	s0,0(sp)
    80005d68:	0141                	addi	sp,sp,16
    80005d6a:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005d6c:	4521                	li	a0,8
    80005d6e:	00000097          	auipc	ra,0x0
    80005d72:	54e080e7          	jalr	1358(ra) # 800062bc <uartputc_sync>
    80005d76:	02000513          	li	a0,32
    80005d7a:	00000097          	auipc	ra,0x0
    80005d7e:	542080e7          	jalr	1346(ra) # 800062bc <uartputc_sync>
    80005d82:	4521                	li	a0,8
    80005d84:	00000097          	auipc	ra,0x0
    80005d88:	538080e7          	jalr	1336(ra) # 800062bc <uartputc_sync>
    80005d8c:	bfe1                	j	80005d64 <consputc+0x18>

0000000080005d8e <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005d8e:	1101                	addi	sp,sp,-32
    80005d90:	ec06                	sd	ra,24(sp)
    80005d92:	e822                	sd	s0,16(sp)
    80005d94:	e426                	sd	s1,8(sp)
    80005d96:	e04a                	sd	s2,0(sp)
    80005d98:	1000                	addi	s0,sp,32
    80005d9a:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005d9c:	0002c517          	auipc	a0,0x2c
    80005da0:	3a450513          	addi	a0,a0,932 # 80032140 <cons>
    80005da4:	00000097          	auipc	ra,0x0
    80005da8:	7a4080e7          	jalr	1956(ra) # 80006548 <acquire>

  switch(c){
    80005dac:	47d5                	li	a5,21
    80005dae:	0af48663          	beq	s1,a5,80005e5a <consoleintr+0xcc>
    80005db2:	0297ca63          	blt	a5,s1,80005de6 <consoleintr+0x58>
    80005db6:	47a1                	li	a5,8
    80005db8:	0ef48763          	beq	s1,a5,80005ea6 <consoleintr+0x118>
    80005dbc:	47c1                	li	a5,16
    80005dbe:	10f49a63          	bne	s1,a5,80005ed2 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005dc2:	ffffc097          	auipc	ra,0xffffc
    80005dc6:	bf6080e7          	jalr	-1034(ra) # 800019b8 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005dca:	0002c517          	auipc	a0,0x2c
    80005dce:	37650513          	addi	a0,a0,886 # 80032140 <cons>
    80005dd2:	00001097          	auipc	ra,0x1
    80005dd6:	82a080e7          	jalr	-2006(ra) # 800065fc <release>
}
    80005dda:	60e2                	ld	ra,24(sp)
    80005ddc:	6442                	ld	s0,16(sp)
    80005dde:	64a2                	ld	s1,8(sp)
    80005de0:	6902                	ld	s2,0(sp)
    80005de2:	6105                	addi	sp,sp,32
    80005de4:	8082                	ret
  switch(c){
    80005de6:	07f00793          	li	a5,127
    80005dea:	0af48e63          	beq	s1,a5,80005ea6 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005dee:	0002c717          	auipc	a4,0x2c
    80005df2:	35270713          	addi	a4,a4,850 # 80032140 <cons>
    80005df6:	0a072783          	lw	a5,160(a4)
    80005dfa:	09872703          	lw	a4,152(a4)
    80005dfe:	9f99                	subw	a5,a5,a4
    80005e00:	07f00713          	li	a4,127
    80005e04:	fcf763e3          	bltu	a4,a5,80005dca <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005e08:	47b5                	li	a5,13
    80005e0a:	0cf48763          	beq	s1,a5,80005ed8 <consoleintr+0x14a>
      consputc(c);
    80005e0e:	8526                	mv	a0,s1
    80005e10:	00000097          	auipc	ra,0x0
    80005e14:	f3c080e7          	jalr	-196(ra) # 80005d4c <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005e18:	0002c797          	auipc	a5,0x2c
    80005e1c:	32878793          	addi	a5,a5,808 # 80032140 <cons>
    80005e20:	0a07a703          	lw	a4,160(a5)
    80005e24:	0017069b          	addiw	a3,a4,1
    80005e28:	0006861b          	sext.w	a2,a3
    80005e2c:	0ad7a023          	sw	a3,160(a5)
    80005e30:	07f77713          	andi	a4,a4,127
    80005e34:	97ba                	add	a5,a5,a4
    80005e36:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005e3a:	47a9                	li	a5,10
    80005e3c:	0cf48563          	beq	s1,a5,80005f06 <consoleintr+0x178>
    80005e40:	4791                	li	a5,4
    80005e42:	0cf48263          	beq	s1,a5,80005f06 <consoleintr+0x178>
    80005e46:	0002c797          	auipc	a5,0x2c
    80005e4a:	3927a783          	lw	a5,914(a5) # 800321d8 <cons+0x98>
    80005e4e:	0807879b          	addiw	a5,a5,128
    80005e52:	f6f61ce3          	bne	a2,a5,80005dca <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005e56:	863e                	mv	a2,a5
    80005e58:	a07d                	j	80005f06 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005e5a:	0002c717          	auipc	a4,0x2c
    80005e5e:	2e670713          	addi	a4,a4,742 # 80032140 <cons>
    80005e62:	0a072783          	lw	a5,160(a4)
    80005e66:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005e6a:	0002c497          	auipc	s1,0x2c
    80005e6e:	2d648493          	addi	s1,s1,726 # 80032140 <cons>
    while(cons.e != cons.w &&
    80005e72:	4929                	li	s2,10
    80005e74:	f4f70be3          	beq	a4,a5,80005dca <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005e78:	37fd                	addiw	a5,a5,-1
    80005e7a:	07f7f713          	andi	a4,a5,127
    80005e7e:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005e80:	01874703          	lbu	a4,24(a4)
    80005e84:	f52703e3          	beq	a4,s2,80005dca <consoleintr+0x3c>
      cons.e--;
    80005e88:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005e8c:	10000513          	li	a0,256
    80005e90:	00000097          	auipc	ra,0x0
    80005e94:	ebc080e7          	jalr	-324(ra) # 80005d4c <consputc>
    while(cons.e != cons.w &&
    80005e98:	0a04a783          	lw	a5,160(s1)
    80005e9c:	09c4a703          	lw	a4,156(s1)
    80005ea0:	fcf71ce3          	bne	a4,a5,80005e78 <consoleintr+0xea>
    80005ea4:	b71d                	j	80005dca <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005ea6:	0002c717          	auipc	a4,0x2c
    80005eaa:	29a70713          	addi	a4,a4,666 # 80032140 <cons>
    80005eae:	0a072783          	lw	a5,160(a4)
    80005eb2:	09c72703          	lw	a4,156(a4)
    80005eb6:	f0f70ae3          	beq	a4,a5,80005dca <consoleintr+0x3c>
      cons.e--;
    80005eba:	37fd                	addiw	a5,a5,-1
    80005ebc:	0002c717          	auipc	a4,0x2c
    80005ec0:	32f72223          	sw	a5,804(a4) # 800321e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005ec4:	10000513          	li	a0,256
    80005ec8:	00000097          	auipc	ra,0x0
    80005ecc:	e84080e7          	jalr	-380(ra) # 80005d4c <consputc>
    80005ed0:	bded                	j	80005dca <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005ed2:	ee048ce3          	beqz	s1,80005dca <consoleintr+0x3c>
    80005ed6:	bf21                	j	80005dee <consoleintr+0x60>
      consputc(c);
    80005ed8:	4529                	li	a0,10
    80005eda:	00000097          	auipc	ra,0x0
    80005ede:	e72080e7          	jalr	-398(ra) # 80005d4c <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005ee2:	0002c797          	auipc	a5,0x2c
    80005ee6:	25e78793          	addi	a5,a5,606 # 80032140 <cons>
    80005eea:	0a07a703          	lw	a4,160(a5)
    80005eee:	0017069b          	addiw	a3,a4,1
    80005ef2:	0006861b          	sext.w	a2,a3
    80005ef6:	0ad7a023          	sw	a3,160(a5)
    80005efa:	07f77713          	andi	a4,a4,127
    80005efe:	97ba                	add	a5,a5,a4
    80005f00:	4729                	li	a4,10
    80005f02:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005f06:	0002c797          	auipc	a5,0x2c
    80005f0a:	2cc7ab23          	sw	a2,726(a5) # 800321dc <cons+0x9c>
        wakeup(&cons.r);
    80005f0e:	0002c517          	auipc	a0,0x2c
    80005f12:	2ca50513          	addi	a0,a0,714 # 800321d8 <cons+0x98>
    80005f16:	ffffb097          	auipc	ra,0xffffb
    80005f1a:	7a2080e7          	jalr	1954(ra) # 800016b8 <wakeup>
    80005f1e:	b575                	j	80005dca <consoleintr+0x3c>

0000000080005f20 <consoleinit>:

void
consoleinit(void)
{
    80005f20:	1141                	addi	sp,sp,-16
    80005f22:	e406                	sd	ra,8(sp)
    80005f24:	e022                	sd	s0,0(sp)
    80005f26:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005f28:	00003597          	auipc	a1,0x3
    80005f2c:	84058593          	addi	a1,a1,-1984 # 80008768 <syscalls+0x3d8>
    80005f30:	0002c517          	auipc	a0,0x2c
    80005f34:	21050513          	addi	a0,a0,528 # 80032140 <cons>
    80005f38:	00000097          	auipc	ra,0x0
    80005f3c:	580080e7          	jalr	1408(ra) # 800064b8 <initlock>

  uartinit();
    80005f40:	00000097          	auipc	ra,0x0
    80005f44:	32c080e7          	jalr	812(ra) # 8000626c <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005f48:	0001f797          	auipc	a5,0x1f
    80005f4c:	18078793          	addi	a5,a5,384 # 800250c8 <devsw>
    80005f50:	00000717          	auipc	a4,0x0
    80005f54:	cea70713          	addi	a4,a4,-790 # 80005c3a <consoleread>
    80005f58:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005f5a:	00000717          	auipc	a4,0x0
    80005f5e:	c7c70713          	addi	a4,a4,-900 # 80005bd6 <consolewrite>
    80005f62:	ef98                	sd	a4,24(a5)
}
    80005f64:	60a2                	ld	ra,8(sp)
    80005f66:	6402                	ld	s0,0(sp)
    80005f68:	0141                	addi	sp,sp,16
    80005f6a:	8082                	ret

0000000080005f6c <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005f6c:	7179                	addi	sp,sp,-48
    80005f6e:	f406                	sd	ra,40(sp)
    80005f70:	f022                	sd	s0,32(sp)
    80005f72:	ec26                	sd	s1,24(sp)
    80005f74:	e84a                	sd	s2,16(sp)
    80005f76:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005f78:	c219                	beqz	a2,80005f7e <printint+0x12>
    80005f7a:	08054763          	bltz	a0,80006008 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005f7e:	2501                	sext.w	a0,a0
    80005f80:	4881                	li	a7,0
    80005f82:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005f86:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005f88:	2581                	sext.w	a1,a1
    80005f8a:	00003617          	auipc	a2,0x3
    80005f8e:	80e60613          	addi	a2,a2,-2034 # 80008798 <digits>
    80005f92:	883a                	mv	a6,a4
    80005f94:	2705                	addiw	a4,a4,1
    80005f96:	02b577bb          	remuw	a5,a0,a1
    80005f9a:	1782                	slli	a5,a5,0x20
    80005f9c:	9381                	srli	a5,a5,0x20
    80005f9e:	97b2                	add	a5,a5,a2
    80005fa0:	0007c783          	lbu	a5,0(a5)
    80005fa4:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005fa8:	0005079b          	sext.w	a5,a0
    80005fac:	02b5553b          	divuw	a0,a0,a1
    80005fb0:	0685                	addi	a3,a3,1
    80005fb2:	feb7f0e3          	bgeu	a5,a1,80005f92 <printint+0x26>

  if(sign)
    80005fb6:	00088c63          	beqz	a7,80005fce <printint+0x62>
    buf[i++] = '-';
    80005fba:	fe070793          	addi	a5,a4,-32
    80005fbe:	00878733          	add	a4,a5,s0
    80005fc2:	02d00793          	li	a5,45
    80005fc6:	fef70823          	sb	a5,-16(a4)
    80005fca:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005fce:	02e05763          	blez	a4,80005ffc <printint+0x90>
    80005fd2:	fd040793          	addi	a5,s0,-48
    80005fd6:	00e784b3          	add	s1,a5,a4
    80005fda:	fff78913          	addi	s2,a5,-1
    80005fde:	993a                	add	s2,s2,a4
    80005fe0:	377d                	addiw	a4,a4,-1
    80005fe2:	1702                	slli	a4,a4,0x20
    80005fe4:	9301                	srli	a4,a4,0x20
    80005fe6:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005fea:	fff4c503          	lbu	a0,-1(s1)
    80005fee:	00000097          	auipc	ra,0x0
    80005ff2:	d5e080e7          	jalr	-674(ra) # 80005d4c <consputc>
  while(--i >= 0)
    80005ff6:	14fd                	addi	s1,s1,-1
    80005ff8:	ff2499e3          	bne	s1,s2,80005fea <printint+0x7e>
}
    80005ffc:	70a2                	ld	ra,40(sp)
    80005ffe:	7402                	ld	s0,32(sp)
    80006000:	64e2                	ld	s1,24(sp)
    80006002:	6942                	ld	s2,16(sp)
    80006004:	6145                	addi	sp,sp,48
    80006006:	8082                	ret
    x = -xx;
    80006008:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    8000600c:	4885                	li	a7,1
    x = -xx;
    8000600e:	bf95                	j	80005f82 <printint+0x16>

0000000080006010 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80006010:	1101                	addi	sp,sp,-32
    80006012:	ec06                	sd	ra,24(sp)
    80006014:	e822                	sd	s0,16(sp)
    80006016:	e426                	sd	s1,8(sp)
    80006018:	1000                	addi	s0,sp,32
    8000601a:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000601c:	0002c797          	auipc	a5,0x2c
    80006020:	1e07a223          	sw	zero,484(a5) # 80032200 <pr+0x18>
  printf("panic: ");
    80006024:	00002517          	auipc	a0,0x2
    80006028:	74c50513          	addi	a0,a0,1868 # 80008770 <syscalls+0x3e0>
    8000602c:	00000097          	auipc	ra,0x0
    80006030:	02e080e7          	jalr	46(ra) # 8000605a <printf>
  printf(s);
    80006034:	8526                	mv	a0,s1
    80006036:	00000097          	auipc	ra,0x0
    8000603a:	024080e7          	jalr	36(ra) # 8000605a <printf>
  printf("\n");
    8000603e:	00002517          	auipc	a0,0x2
    80006042:	00a50513          	addi	a0,a0,10 # 80008048 <etext+0x48>
    80006046:	00000097          	auipc	ra,0x0
    8000604a:	014080e7          	jalr	20(ra) # 8000605a <printf>
  panicked = 1; // freeze uart output from other CPUs
    8000604e:	4785                	li	a5,1
    80006050:	00003717          	auipc	a4,0x3
    80006054:	fcf72623          	sw	a5,-52(a4) # 8000901c <panicked>
  for(;;)
    80006058:	a001                	j	80006058 <panic+0x48>

000000008000605a <printf>:
{
    8000605a:	7131                	addi	sp,sp,-192
    8000605c:	fc86                	sd	ra,120(sp)
    8000605e:	f8a2                	sd	s0,112(sp)
    80006060:	f4a6                	sd	s1,104(sp)
    80006062:	f0ca                	sd	s2,96(sp)
    80006064:	ecce                	sd	s3,88(sp)
    80006066:	e8d2                	sd	s4,80(sp)
    80006068:	e4d6                	sd	s5,72(sp)
    8000606a:	e0da                	sd	s6,64(sp)
    8000606c:	fc5e                	sd	s7,56(sp)
    8000606e:	f862                	sd	s8,48(sp)
    80006070:	f466                	sd	s9,40(sp)
    80006072:	f06a                	sd	s10,32(sp)
    80006074:	ec6e                	sd	s11,24(sp)
    80006076:	0100                	addi	s0,sp,128
    80006078:	8a2a                	mv	s4,a0
    8000607a:	e40c                	sd	a1,8(s0)
    8000607c:	e810                	sd	a2,16(s0)
    8000607e:	ec14                	sd	a3,24(s0)
    80006080:	f018                	sd	a4,32(s0)
    80006082:	f41c                	sd	a5,40(s0)
    80006084:	03043823          	sd	a6,48(s0)
    80006088:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    8000608c:	0002cd97          	auipc	s11,0x2c
    80006090:	174dad83          	lw	s11,372(s11) # 80032200 <pr+0x18>
  if(locking)
    80006094:	020d9b63          	bnez	s11,800060ca <printf+0x70>
  if (fmt == 0)
    80006098:	040a0263          	beqz	s4,800060dc <printf+0x82>
  va_start(ap, fmt);
    8000609c:	00840793          	addi	a5,s0,8
    800060a0:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800060a4:	000a4503          	lbu	a0,0(s4)
    800060a8:	14050f63          	beqz	a0,80006206 <printf+0x1ac>
    800060ac:	4981                	li	s3,0
    if(c != '%'){
    800060ae:	02500a93          	li	s5,37
    switch(c){
    800060b2:	07000b93          	li	s7,112
  consputc('x');
    800060b6:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800060b8:	00002b17          	auipc	s6,0x2
    800060bc:	6e0b0b13          	addi	s6,s6,1760 # 80008798 <digits>
    switch(c){
    800060c0:	07300c93          	li	s9,115
    800060c4:	06400c13          	li	s8,100
    800060c8:	a82d                	j	80006102 <printf+0xa8>
    acquire(&pr.lock);
    800060ca:	0002c517          	auipc	a0,0x2c
    800060ce:	11e50513          	addi	a0,a0,286 # 800321e8 <pr>
    800060d2:	00000097          	auipc	ra,0x0
    800060d6:	476080e7          	jalr	1142(ra) # 80006548 <acquire>
    800060da:	bf7d                	j	80006098 <printf+0x3e>
    panic("null fmt");
    800060dc:	00002517          	auipc	a0,0x2
    800060e0:	6a450513          	addi	a0,a0,1700 # 80008780 <syscalls+0x3f0>
    800060e4:	00000097          	auipc	ra,0x0
    800060e8:	f2c080e7          	jalr	-212(ra) # 80006010 <panic>
      consputc(c);
    800060ec:	00000097          	auipc	ra,0x0
    800060f0:	c60080e7          	jalr	-928(ra) # 80005d4c <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800060f4:	2985                	addiw	s3,s3,1
    800060f6:	013a07b3          	add	a5,s4,s3
    800060fa:	0007c503          	lbu	a0,0(a5)
    800060fe:	10050463          	beqz	a0,80006206 <printf+0x1ac>
    if(c != '%'){
    80006102:	ff5515e3          	bne	a0,s5,800060ec <printf+0x92>
    c = fmt[++i] & 0xff;
    80006106:	2985                	addiw	s3,s3,1
    80006108:	013a07b3          	add	a5,s4,s3
    8000610c:	0007c783          	lbu	a5,0(a5)
    80006110:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80006114:	cbed                	beqz	a5,80006206 <printf+0x1ac>
    switch(c){
    80006116:	05778a63          	beq	a5,s7,8000616a <printf+0x110>
    8000611a:	02fbf663          	bgeu	s7,a5,80006146 <printf+0xec>
    8000611e:	09978863          	beq	a5,s9,800061ae <printf+0x154>
    80006122:	07800713          	li	a4,120
    80006126:	0ce79563          	bne	a5,a4,800061f0 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    8000612a:	f8843783          	ld	a5,-120(s0)
    8000612e:	00878713          	addi	a4,a5,8
    80006132:	f8e43423          	sd	a4,-120(s0)
    80006136:	4605                	li	a2,1
    80006138:	85ea                	mv	a1,s10
    8000613a:	4388                	lw	a0,0(a5)
    8000613c:	00000097          	auipc	ra,0x0
    80006140:	e30080e7          	jalr	-464(ra) # 80005f6c <printint>
      break;
    80006144:	bf45                	j	800060f4 <printf+0x9a>
    switch(c){
    80006146:	09578f63          	beq	a5,s5,800061e4 <printf+0x18a>
    8000614a:	0b879363          	bne	a5,s8,800061f0 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    8000614e:	f8843783          	ld	a5,-120(s0)
    80006152:	00878713          	addi	a4,a5,8
    80006156:	f8e43423          	sd	a4,-120(s0)
    8000615a:	4605                	li	a2,1
    8000615c:	45a9                	li	a1,10
    8000615e:	4388                	lw	a0,0(a5)
    80006160:	00000097          	auipc	ra,0x0
    80006164:	e0c080e7          	jalr	-500(ra) # 80005f6c <printint>
      break;
    80006168:	b771                	j	800060f4 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    8000616a:	f8843783          	ld	a5,-120(s0)
    8000616e:	00878713          	addi	a4,a5,8
    80006172:	f8e43423          	sd	a4,-120(s0)
    80006176:	0007b903          	ld	s2,0(a5)
  consputc('0');
    8000617a:	03000513          	li	a0,48
    8000617e:	00000097          	auipc	ra,0x0
    80006182:	bce080e7          	jalr	-1074(ra) # 80005d4c <consputc>
  consputc('x');
    80006186:	07800513          	li	a0,120
    8000618a:	00000097          	auipc	ra,0x0
    8000618e:	bc2080e7          	jalr	-1086(ra) # 80005d4c <consputc>
    80006192:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006194:	03c95793          	srli	a5,s2,0x3c
    80006198:	97da                	add	a5,a5,s6
    8000619a:	0007c503          	lbu	a0,0(a5)
    8000619e:	00000097          	auipc	ra,0x0
    800061a2:	bae080e7          	jalr	-1106(ra) # 80005d4c <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800061a6:	0912                	slli	s2,s2,0x4
    800061a8:	34fd                	addiw	s1,s1,-1
    800061aa:	f4ed                	bnez	s1,80006194 <printf+0x13a>
    800061ac:	b7a1                	j	800060f4 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    800061ae:	f8843783          	ld	a5,-120(s0)
    800061b2:	00878713          	addi	a4,a5,8
    800061b6:	f8e43423          	sd	a4,-120(s0)
    800061ba:	6384                	ld	s1,0(a5)
    800061bc:	cc89                	beqz	s1,800061d6 <printf+0x17c>
      for(; *s; s++)
    800061be:	0004c503          	lbu	a0,0(s1)
    800061c2:	d90d                	beqz	a0,800060f4 <printf+0x9a>
        consputc(*s);
    800061c4:	00000097          	auipc	ra,0x0
    800061c8:	b88080e7          	jalr	-1144(ra) # 80005d4c <consputc>
      for(; *s; s++)
    800061cc:	0485                	addi	s1,s1,1
    800061ce:	0004c503          	lbu	a0,0(s1)
    800061d2:	f96d                	bnez	a0,800061c4 <printf+0x16a>
    800061d4:	b705                	j	800060f4 <printf+0x9a>
        s = "(null)";
    800061d6:	00002497          	auipc	s1,0x2
    800061da:	5a248493          	addi	s1,s1,1442 # 80008778 <syscalls+0x3e8>
      for(; *s; s++)
    800061de:	02800513          	li	a0,40
    800061e2:	b7cd                	j	800061c4 <printf+0x16a>
      consputc('%');
    800061e4:	8556                	mv	a0,s5
    800061e6:	00000097          	auipc	ra,0x0
    800061ea:	b66080e7          	jalr	-1178(ra) # 80005d4c <consputc>
      break;
    800061ee:	b719                	j	800060f4 <printf+0x9a>
      consputc('%');
    800061f0:	8556                	mv	a0,s5
    800061f2:	00000097          	auipc	ra,0x0
    800061f6:	b5a080e7          	jalr	-1190(ra) # 80005d4c <consputc>
      consputc(c);
    800061fa:	8526                	mv	a0,s1
    800061fc:	00000097          	auipc	ra,0x0
    80006200:	b50080e7          	jalr	-1200(ra) # 80005d4c <consputc>
      break;
    80006204:	bdc5                	j	800060f4 <printf+0x9a>
  if(locking)
    80006206:	020d9163          	bnez	s11,80006228 <printf+0x1ce>
}
    8000620a:	70e6                	ld	ra,120(sp)
    8000620c:	7446                	ld	s0,112(sp)
    8000620e:	74a6                	ld	s1,104(sp)
    80006210:	7906                	ld	s2,96(sp)
    80006212:	69e6                	ld	s3,88(sp)
    80006214:	6a46                	ld	s4,80(sp)
    80006216:	6aa6                	ld	s5,72(sp)
    80006218:	6b06                	ld	s6,64(sp)
    8000621a:	7be2                	ld	s7,56(sp)
    8000621c:	7c42                	ld	s8,48(sp)
    8000621e:	7ca2                	ld	s9,40(sp)
    80006220:	7d02                	ld	s10,32(sp)
    80006222:	6de2                	ld	s11,24(sp)
    80006224:	6129                	addi	sp,sp,192
    80006226:	8082                	ret
    release(&pr.lock);
    80006228:	0002c517          	auipc	a0,0x2c
    8000622c:	fc050513          	addi	a0,a0,-64 # 800321e8 <pr>
    80006230:	00000097          	auipc	ra,0x0
    80006234:	3cc080e7          	jalr	972(ra) # 800065fc <release>
}
    80006238:	bfc9                	j	8000620a <printf+0x1b0>

000000008000623a <printfinit>:
    ;
}

void
printfinit(void)
{
    8000623a:	1101                	addi	sp,sp,-32
    8000623c:	ec06                	sd	ra,24(sp)
    8000623e:	e822                	sd	s0,16(sp)
    80006240:	e426                	sd	s1,8(sp)
    80006242:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006244:	0002c497          	auipc	s1,0x2c
    80006248:	fa448493          	addi	s1,s1,-92 # 800321e8 <pr>
    8000624c:	00002597          	auipc	a1,0x2
    80006250:	54458593          	addi	a1,a1,1348 # 80008790 <syscalls+0x400>
    80006254:	8526                	mv	a0,s1
    80006256:	00000097          	auipc	ra,0x0
    8000625a:	262080e7          	jalr	610(ra) # 800064b8 <initlock>
  pr.locking = 1;
    8000625e:	4785                	li	a5,1
    80006260:	cc9c                	sw	a5,24(s1)
}
    80006262:	60e2                	ld	ra,24(sp)
    80006264:	6442                	ld	s0,16(sp)
    80006266:	64a2                	ld	s1,8(sp)
    80006268:	6105                	addi	sp,sp,32
    8000626a:	8082                	ret

000000008000626c <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000626c:	1141                	addi	sp,sp,-16
    8000626e:	e406                	sd	ra,8(sp)
    80006270:	e022                	sd	s0,0(sp)
    80006272:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006274:	100007b7          	lui	a5,0x10000
    80006278:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000627c:	f8000713          	li	a4,-128
    80006280:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006284:	470d                	li	a4,3
    80006286:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    8000628a:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000628e:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006292:	469d                	li	a3,7
    80006294:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006298:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000629c:	00002597          	auipc	a1,0x2
    800062a0:	51458593          	addi	a1,a1,1300 # 800087b0 <digits+0x18>
    800062a4:	0002c517          	auipc	a0,0x2c
    800062a8:	f6450513          	addi	a0,a0,-156 # 80032208 <uart_tx_lock>
    800062ac:	00000097          	auipc	ra,0x0
    800062b0:	20c080e7          	jalr	524(ra) # 800064b8 <initlock>
}
    800062b4:	60a2                	ld	ra,8(sp)
    800062b6:	6402                	ld	s0,0(sp)
    800062b8:	0141                	addi	sp,sp,16
    800062ba:	8082                	ret

00000000800062bc <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800062bc:	1101                	addi	sp,sp,-32
    800062be:	ec06                	sd	ra,24(sp)
    800062c0:	e822                	sd	s0,16(sp)
    800062c2:	e426                	sd	s1,8(sp)
    800062c4:	1000                	addi	s0,sp,32
    800062c6:	84aa                	mv	s1,a0
  push_off();
    800062c8:	00000097          	auipc	ra,0x0
    800062cc:	234080e7          	jalr	564(ra) # 800064fc <push_off>

  if(panicked){
    800062d0:	00003797          	auipc	a5,0x3
    800062d4:	d4c7a783          	lw	a5,-692(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800062d8:	10000737          	lui	a4,0x10000
  if(panicked){
    800062dc:	c391                	beqz	a5,800062e0 <uartputc_sync+0x24>
    for(;;)
    800062de:	a001                	j	800062de <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800062e0:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    800062e4:	0207f793          	andi	a5,a5,32
    800062e8:	dfe5                	beqz	a5,800062e0 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    800062ea:	0ff4f513          	zext.b	a0,s1
    800062ee:	100007b7          	lui	a5,0x10000
    800062f2:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    800062f6:	00000097          	auipc	ra,0x0
    800062fa:	2a6080e7          	jalr	678(ra) # 8000659c <pop_off>
}
    800062fe:	60e2                	ld	ra,24(sp)
    80006300:	6442                	ld	s0,16(sp)
    80006302:	64a2                	ld	s1,8(sp)
    80006304:	6105                	addi	sp,sp,32
    80006306:	8082                	ret

0000000080006308 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006308:	00003797          	auipc	a5,0x3
    8000630c:	d187b783          	ld	a5,-744(a5) # 80009020 <uart_tx_r>
    80006310:	00003717          	auipc	a4,0x3
    80006314:	d1873703          	ld	a4,-744(a4) # 80009028 <uart_tx_w>
    80006318:	06f70a63          	beq	a4,a5,8000638c <uartstart+0x84>
{
    8000631c:	7139                	addi	sp,sp,-64
    8000631e:	fc06                	sd	ra,56(sp)
    80006320:	f822                	sd	s0,48(sp)
    80006322:	f426                	sd	s1,40(sp)
    80006324:	f04a                	sd	s2,32(sp)
    80006326:	ec4e                	sd	s3,24(sp)
    80006328:	e852                	sd	s4,16(sp)
    8000632a:	e456                	sd	s5,8(sp)
    8000632c:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000632e:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006332:	0002ca17          	auipc	s4,0x2c
    80006336:	ed6a0a13          	addi	s4,s4,-298 # 80032208 <uart_tx_lock>
    uart_tx_r += 1;
    8000633a:	00003497          	auipc	s1,0x3
    8000633e:	ce648493          	addi	s1,s1,-794 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80006342:	00003997          	auipc	s3,0x3
    80006346:	ce698993          	addi	s3,s3,-794 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000634a:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    8000634e:	02077713          	andi	a4,a4,32
    80006352:	c705                	beqz	a4,8000637a <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006354:	01f7f713          	andi	a4,a5,31
    80006358:	9752                	add	a4,a4,s4
    8000635a:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    8000635e:	0785                	addi	a5,a5,1
    80006360:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006362:	8526                	mv	a0,s1
    80006364:	ffffb097          	auipc	ra,0xffffb
    80006368:	354080e7          	jalr	852(ra) # 800016b8 <wakeup>
    
    WriteReg(THR, c);
    8000636c:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006370:	609c                	ld	a5,0(s1)
    80006372:	0009b703          	ld	a4,0(s3)
    80006376:	fcf71ae3          	bne	a4,a5,8000634a <uartstart+0x42>
  }
}
    8000637a:	70e2                	ld	ra,56(sp)
    8000637c:	7442                	ld	s0,48(sp)
    8000637e:	74a2                	ld	s1,40(sp)
    80006380:	7902                	ld	s2,32(sp)
    80006382:	69e2                	ld	s3,24(sp)
    80006384:	6a42                	ld	s4,16(sp)
    80006386:	6aa2                	ld	s5,8(sp)
    80006388:	6121                	addi	sp,sp,64
    8000638a:	8082                	ret
    8000638c:	8082                	ret

000000008000638e <uartputc>:
{
    8000638e:	7179                	addi	sp,sp,-48
    80006390:	f406                	sd	ra,40(sp)
    80006392:	f022                	sd	s0,32(sp)
    80006394:	ec26                	sd	s1,24(sp)
    80006396:	e84a                	sd	s2,16(sp)
    80006398:	e44e                	sd	s3,8(sp)
    8000639a:	e052                	sd	s4,0(sp)
    8000639c:	1800                	addi	s0,sp,48
    8000639e:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800063a0:	0002c517          	auipc	a0,0x2c
    800063a4:	e6850513          	addi	a0,a0,-408 # 80032208 <uart_tx_lock>
    800063a8:	00000097          	auipc	ra,0x0
    800063ac:	1a0080e7          	jalr	416(ra) # 80006548 <acquire>
  if(panicked){
    800063b0:	00003797          	auipc	a5,0x3
    800063b4:	c6c7a783          	lw	a5,-916(a5) # 8000901c <panicked>
    800063b8:	c391                	beqz	a5,800063bc <uartputc+0x2e>
    for(;;)
    800063ba:	a001                	j	800063ba <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800063bc:	00003717          	auipc	a4,0x3
    800063c0:	c6c73703          	ld	a4,-916(a4) # 80009028 <uart_tx_w>
    800063c4:	00003797          	auipc	a5,0x3
    800063c8:	c5c7b783          	ld	a5,-932(a5) # 80009020 <uart_tx_r>
    800063cc:	02078793          	addi	a5,a5,32
    800063d0:	02e79b63          	bne	a5,a4,80006406 <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    800063d4:	0002c997          	auipc	s3,0x2c
    800063d8:	e3498993          	addi	s3,s3,-460 # 80032208 <uart_tx_lock>
    800063dc:	00003497          	auipc	s1,0x3
    800063e0:	c4448493          	addi	s1,s1,-956 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800063e4:	00003917          	auipc	s2,0x3
    800063e8:	c4490913          	addi	s2,s2,-956 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    800063ec:	85ce                	mv	a1,s3
    800063ee:	8526                	mv	a0,s1
    800063f0:	ffffb097          	auipc	ra,0xffffb
    800063f4:	13c080e7          	jalr	316(ra) # 8000152c <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800063f8:	00093703          	ld	a4,0(s2)
    800063fc:	609c                	ld	a5,0(s1)
    800063fe:	02078793          	addi	a5,a5,32
    80006402:	fee785e3          	beq	a5,a4,800063ec <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006406:	0002c497          	auipc	s1,0x2c
    8000640a:	e0248493          	addi	s1,s1,-510 # 80032208 <uart_tx_lock>
    8000640e:	01f77793          	andi	a5,a4,31
    80006412:	97a6                	add	a5,a5,s1
    80006414:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    80006418:	0705                	addi	a4,a4,1
    8000641a:	00003797          	auipc	a5,0x3
    8000641e:	c0e7b723          	sd	a4,-1010(a5) # 80009028 <uart_tx_w>
      uartstart();
    80006422:	00000097          	auipc	ra,0x0
    80006426:	ee6080e7          	jalr	-282(ra) # 80006308 <uartstart>
      release(&uart_tx_lock);
    8000642a:	8526                	mv	a0,s1
    8000642c:	00000097          	auipc	ra,0x0
    80006430:	1d0080e7          	jalr	464(ra) # 800065fc <release>
}
    80006434:	70a2                	ld	ra,40(sp)
    80006436:	7402                	ld	s0,32(sp)
    80006438:	64e2                	ld	s1,24(sp)
    8000643a:	6942                	ld	s2,16(sp)
    8000643c:	69a2                	ld	s3,8(sp)
    8000643e:	6a02                	ld	s4,0(sp)
    80006440:	6145                	addi	sp,sp,48
    80006442:	8082                	ret

0000000080006444 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006444:	1141                	addi	sp,sp,-16
    80006446:	e422                	sd	s0,8(sp)
    80006448:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000644a:	100007b7          	lui	a5,0x10000
    8000644e:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006452:	8b85                	andi	a5,a5,1
    80006454:	cb81                	beqz	a5,80006464 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    80006456:	100007b7          	lui	a5,0x10000
    8000645a:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000645e:	6422                	ld	s0,8(sp)
    80006460:	0141                	addi	sp,sp,16
    80006462:	8082                	ret
    return -1;
    80006464:	557d                	li	a0,-1
    80006466:	bfe5                	j	8000645e <uartgetc+0x1a>

0000000080006468 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006468:	1101                	addi	sp,sp,-32
    8000646a:	ec06                	sd	ra,24(sp)
    8000646c:	e822                	sd	s0,16(sp)
    8000646e:	e426                	sd	s1,8(sp)
    80006470:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006472:	54fd                	li	s1,-1
    80006474:	a029                	j	8000647e <uartintr+0x16>
      break;
    consoleintr(c);
    80006476:	00000097          	auipc	ra,0x0
    8000647a:	918080e7          	jalr	-1768(ra) # 80005d8e <consoleintr>
    int c = uartgetc();
    8000647e:	00000097          	auipc	ra,0x0
    80006482:	fc6080e7          	jalr	-58(ra) # 80006444 <uartgetc>
    if(c == -1)
    80006486:	fe9518e3          	bne	a0,s1,80006476 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000648a:	0002c497          	auipc	s1,0x2c
    8000648e:	d7e48493          	addi	s1,s1,-642 # 80032208 <uart_tx_lock>
    80006492:	8526                	mv	a0,s1
    80006494:	00000097          	auipc	ra,0x0
    80006498:	0b4080e7          	jalr	180(ra) # 80006548 <acquire>
  uartstart();
    8000649c:	00000097          	auipc	ra,0x0
    800064a0:	e6c080e7          	jalr	-404(ra) # 80006308 <uartstart>
  release(&uart_tx_lock);
    800064a4:	8526                	mv	a0,s1
    800064a6:	00000097          	auipc	ra,0x0
    800064aa:	156080e7          	jalr	342(ra) # 800065fc <release>
}
    800064ae:	60e2                	ld	ra,24(sp)
    800064b0:	6442                	ld	s0,16(sp)
    800064b2:	64a2                	ld	s1,8(sp)
    800064b4:	6105                	addi	sp,sp,32
    800064b6:	8082                	ret

00000000800064b8 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800064b8:	1141                	addi	sp,sp,-16
    800064ba:	e422                	sd	s0,8(sp)
    800064bc:	0800                	addi	s0,sp,16
  lk->name = name;
    800064be:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800064c0:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800064c4:	00053823          	sd	zero,16(a0)
}
    800064c8:	6422                	ld	s0,8(sp)
    800064ca:	0141                	addi	sp,sp,16
    800064cc:	8082                	ret

00000000800064ce <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800064ce:	411c                	lw	a5,0(a0)
    800064d0:	e399                	bnez	a5,800064d6 <holding+0x8>
    800064d2:	4501                	li	a0,0
  return r;
}
    800064d4:	8082                	ret
{
    800064d6:	1101                	addi	sp,sp,-32
    800064d8:	ec06                	sd	ra,24(sp)
    800064da:	e822                	sd	s0,16(sp)
    800064dc:	e426                	sd	s1,8(sp)
    800064de:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800064e0:	6904                	ld	s1,16(a0)
    800064e2:	ffffb097          	auipc	ra,0xffffb
    800064e6:	92c080e7          	jalr	-1748(ra) # 80000e0e <mycpu>
    800064ea:	40a48533          	sub	a0,s1,a0
    800064ee:	00153513          	seqz	a0,a0
}
    800064f2:	60e2                	ld	ra,24(sp)
    800064f4:	6442                	ld	s0,16(sp)
    800064f6:	64a2                	ld	s1,8(sp)
    800064f8:	6105                	addi	sp,sp,32
    800064fa:	8082                	ret

00000000800064fc <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800064fc:	1101                	addi	sp,sp,-32
    800064fe:	ec06                	sd	ra,24(sp)
    80006500:	e822                	sd	s0,16(sp)
    80006502:	e426                	sd	s1,8(sp)
    80006504:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006506:	100024f3          	csrr	s1,sstatus
    8000650a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000650e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006510:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006514:	ffffb097          	auipc	ra,0xffffb
    80006518:	8fa080e7          	jalr	-1798(ra) # 80000e0e <mycpu>
    8000651c:	5d3c                	lw	a5,120(a0)
    8000651e:	cf89                	beqz	a5,80006538 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006520:	ffffb097          	auipc	ra,0xffffb
    80006524:	8ee080e7          	jalr	-1810(ra) # 80000e0e <mycpu>
    80006528:	5d3c                	lw	a5,120(a0)
    8000652a:	2785                	addiw	a5,a5,1
    8000652c:	dd3c                	sw	a5,120(a0)
}
    8000652e:	60e2                	ld	ra,24(sp)
    80006530:	6442                	ld	s0,16(sp)
    80006532:	64a2                	ld	s1,8(sp)
    80006534:	6105                	addi	sp,sp,32
    80006536:	8082                	ret
    mycpu()->intena = old;
    80006538:	ffffb097          	auipc	ra,0xffffb
    8000653c:	8d6080e7          	jalr	-1834(ra) # 80000e0e <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006540:	8085                	srli	s1,s1,0x1
    80006542:	8885                	andi	s1,s1,1
    80006544:	dd64                	sw	s1,124(a0)
    80006546:	bfe9                	j	80006520 <push_off+0x24>

0000000080006548 <acquire>:
{
    80006548:	1101                	addi	sp,sp,-32
    8000654a:	ec06                	sd	ra,24(sp)
    8000654c:	e822                	sd	s0,16(sp)
    8000654e:	e426                	sd	s1,8(sp)
    80006550:	1000                	addi	s0,sp,32
    80006552:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006554:	00000097          	auipc	ra,0x0
    80006558:	fa8080e7          	jalr	-88(ra) # 800064fc <push_off>
  if(holding(lk))
    8000655c:	8526                	mv	a0,s1
    8000655e:	00000097          	auipc	ra,0x0
    80006562:	f70080e7          	jalr	-144(ra) # 800064ce <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006566:	4705                	li	a4,1
  if(holding(lk))
    80006568:	e115                	bnez	a0,8000658c <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000656a:	87ba                	mv	a5,a4
    8000656c:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006570:	2781                	sext.w	a5,a5
    80006572:	ffe5                	bnez	a5,8000656a <acquire+0x22>
  __sync_synchronize();
    80006574:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006578:	ffffb097          	auipc	ra,0xffffb
    8000657c:	896080e7          	jalr	-1898(ra) # 80000e0e <mycpu>
    80006580:	e888                	sd	a0,16(s1)
}
    80006582:	60e2                	ld	ra,24(sp)
    80006584:	6442                	ld	s0,16(sp)
    80006586:	64a2                	ld	s1,8(sp)
    80006588:	6105                	addi	sp,sp,32
    8000658a:	8082                	ret
    panic("acquire");
    8000658c:	00002517          	auipc	a0,0x2
    80006590:	22c50513          	addi	a0,a0,556 # 800087b8 <digits+0x20>
    80006594:	00000097          	auipc	ra,0x0
    80006598:	a7c080e7          	jalr	-1412(ra) # 80006010 <panic>

000000008000659c <pop_off>:

void
pop_off(void)
{
    8000659c:	1141                	addi	sp,sp,-16
    8000659e:	e406                	sd	ra,8(sp)
    800065a0:	e022                	sd	s0,0(sp)
    800065a2:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800065a4:	ffffb097          	auipc	ra,0xffffb
    800065a8:	86a080e7          	jalr	-1942(ra) # 80000e0e <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800065ac:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800065b0:	8b89                	andi	a5,a5,2
  if(intr_get())
    800065b2:	e78d                	bnez	a5,800065dc <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800065b4:	5d3c                	lw	a5,120(a0)
    800065b6:	02f05b63          	blez	a5,800065ec <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800065ba:	37fd                	addiw	a5,a5,-1
    800065bc:	0007871b          	sext.w	a4,a5
    800065c0:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800065c2:	eb09                	bnez	a4,800065d4 <pop_off+0x38>
    800065c4:	5d7c                	lw	a5,124(a0)
    800065c6:	c799                	beqz	a5,800065d4 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800065c8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800065cc:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800065d0:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800065d4:	60a2                	ld	ra,8(sp)
    800065d6:	6402                	ld	s0,0(sp)
    800065d8:	0141                	addi	sp,sp,16
    800065da:	8082                	ret
    panic("pop_off - interruptible");
    800065dc:	00002517          	auipc	a0,0x2
    800065e0:	1e450513          	addi	a0,a0,484 # 800087c0 <digits+0x28>
    800065e4:	00000097          	auipc	ra,0x0
    800065e8:	a2c080e7          	jalr	-1492(ra) # 80006010 <panic>
    panic("pop_off");
    800065ec:	00002517          	auipc	a0,0x2
    800065f0:	1ec50513          	addi	a0,a0,492 # 800087d8 <digits+0x40>
    800065f4:	00000097          	auipc	ra,0x0
    800065f8:	a1c080e7          	jalr	-1508(ra) # 80006010 <panic>

00000000800065fc <release>:
{
    800065fc:	1101                	addi	sp,sp,-32
    800065fe:	ec06                	sd	ra,24(sp)
    80006600:	e822                	sd	s0,16(sp)
    80006602:	e426                	sd	s1,8(sp)
    80006604:	1000                	addi	s0,sp,32
    80006606:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006608:	00000097          	auipc	ra,0x0
    8000660c:	ec6080e7          	jalr	-314(ra) # 800064ce <holding>
    80006610:	c115                	beqz	a0,80006634 <release+0x38>
  lk->cpu = 0;
    80006612:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006616:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    8000661a:	0f50000f          	fence	iorw,ow
    8000661e:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006622:	00000097          	auipc	ra,0x0
    80006626:	f7a080e7          	jalr	-134(ra) # 8000659c <pop_off>
}
    8000662a:	60e2                	ld	ra,24(sp)
    8000662c:	6442                	ld	s0,16(sp)
    8000662e:	64a2                	ld	s1,8(sp)
    80006630:	6105                	addi	sp,sp,32
    80006632:	8082                	ret
    panic("release");
    80006634:	00002517          	auipc	a0,0x2
    80006638:	1ac50513          	addi	a0,a0,428 # 800087e0 <digits+0x48>
    8000663c:	00000097          	auipc	ra,0x0
    80006640:	9d4080e7          	jalr	-1580(ra) # 80006010 <panic>
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
