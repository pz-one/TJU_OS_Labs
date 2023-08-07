
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	9f013103          	ld	sp,-1552(sp) # 800089f0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	79c050ef          	jal	ra,800057b2 <start>

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
    8000004c:	17c080e7          	jalr	380(ra) # 800001c4 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	fe090913          	addi	s2,s2,-32 # 80009030 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	13e080e7          	jalr	318(ra) # 80006198 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	1de080e7          	jalr	478(ra) # 8000624c <release>
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
    8000008e:	bd6080e7          	jalr	-1066(ra) # 80005c60 <panic>

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
    800000fa:	012080e7          	jalr	18(ra) # 80006108 <initlock>
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
    80000132:	06a080e7          	jalr	106(ra) # 80006198 <acquire>
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
    8000014a:	106080e7          	jalr	262(ra) # 8000624c <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014e:	6605                	lui	a2,0x1
    80000150:	4595                	li	a1,5
    80000152:	8526                	mv	a0,s1
    80000154:	00000097          	auipc	ra,0x0
    80000158:	070080e7          	jalr	112(ra) # 800001c4 <memset>
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
    80000174:	0dc080e7          	jalr	220(ra) # 8000624c <release>
  if(r)
    80000178:	b7d5                	j	8000015c <kalloc+0x42>

000000008000017a <free_mem>:

//返回空闲空间的byte数
uint64
free_mem(void)
{
    8000017a:	1101                	addi	sp,sp,-32
    8000017c:	ec06                	sd	ra,24(sp)
    8000017e:	e822                	sd	s0,16(sp)
    80000180:	e426                	sd	s1,8(sp)
    80000182:	1000                	addi	s0,sp,32
  struct run *r;
  //nun用于存储空闲页数
  uint64 num = 0;
  //统计时对内存加锁
  acquire(&kmem.lock);
    80000184:	00009497          	auipc	s1,0x9
    80000188:	eac48493          	addi	s1,s1,-340 # 80009030 <kmem>
    8000018c:	8526                	mv	a0,s1
    8000018e:	00006097          	auipc	ra,0x6
    80000192:	00a080e7          	jalr	10(ra) # 80006198 <acquire>
  //r指针指向空闲表
  r = kmem.freelist;
    80000196:	6c9c                	ld	a5,24(s1)
  //遍历空闲表
  while (r)
    80000198:	c785                	beqz	a5,800001c0 <free_mem+0x46>
  uint64 num = 0;
    8000019a:	4481                	li	s1,0
  {
    num++;
    8000019c:	0485                	addi	s1,s1,1
    r = r->next;
    8000019e:	639c                	ld	a5,0(a5)
  while (r)
    800001a0:	fff5                	bnez	a5,8000019c <free_mem+0x22>
  }
  //统计完毕解锁
  release(&kmem.lock);
    800001a2:	00009517          	auipc	a0,0x9
    800001a6:	e8e50513          	addi	a0,a0,-370 # 80009030 <kmem>
    800001aa:	00006097          	auipc	ra,0x6
    800001ae:	0a2080e7          	jalr	162(ra) # 8000624c <release>
  return num * PGSIZE;
    800001b2:	00c49513          	slli	a0,s1,0xc
    800001b6:	60e2                	ld	ra,24(sp)
    800001b8:	6442                	ld	s0,16(sp)
    800001ba:	64a2                	ld	s1,8(sp)
    800001bc:	6105                	addi	sp,sp,32
    800001be:	8082                	ret
  uint64 num = 0;
    800001c0:	4481                	li	s1,0
    800001c2:	b7c5                	j	800001a2 <free_mem+0x28>

00000000800001c4 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    800001c4:	1141                	addi	sp,sp,-16
    800001c6:	e422                	sd	s0,8(sp)
    800001c8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    800001ca:	ca19                	beqz	a2,800001e0 <memset+0x1c>
    800001cc:	87aa                	mv	a5,a0
    800001ce:	1602                	slli	a2,a2,0x20
    800001d0:	9201                	srli	a2,a2,0x20
    800001d2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    800001d6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800001da:	0785                	addi	a5,a5,1
    800001dc:	fee79de3          	bne	a5,a4,800001d6 <memset+0x12>
  }
  return dst;
}
    800001e0:	6422                	ld	s0,8(sp)
    800001e2:	0141                	addi	sp,sp,16
    800001e4:	8082                	ret

00000000800001e6 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800001e6:	1141                	addi	sp,sp,-16
    800001e8:	e422                	sd	s0,8(sp)
    800001ea:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001ec:	ca05                	beqz	a2,8000021c <memcmp+0x36>
    800001ee:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800001f2:	1682                	slli	a3,a3,0x20
    800001f4:	9281                	srli	a3,a3,0x20
    800001f6:	0685                	addi	a3,a3,1
    800001f8:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001fa:	00054783          	lbu	a5,0(a0)
    800001fe:	0005c703          	lbu	a4,0(a1)
    80000202:	00e79863          	bne	a5,a4,80000212 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000206:	0505                	addi	a0,a0,1
    80000208:	0585                	addi	a1,a1,1
  while(n-- > 0){
    8000020a:	fed518e3          	bne	a0,a3,800001fa <memcmp+0x14>
  }

  return 0;
    8000020e:	4501                	li	a0,0
    80000210:	a019                	j	80000216 <memcmp+0x30>
      return *s1 - *s2;
    80000212:	40e7853b          	subw	a0,a5,a4
}
    80000216:	6422                	ld	s0,8(sp)
    80000218:	0141                	addi	sp,sp,16
    8000021a:	8082                	ret
  return 0;
    8000021c:	4501                	li	a0,0
    8000021e:	bfe5                	j	80000216 <memcmp+0x30>

0000000080000220 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000220:	1141                	addi	sp,sp,-16
    80000222:	e422                	sd	s0,8(sp)
    80000224:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000226:	c205                	beqz	a2,80000246 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000228:	02a5e263          	bltu	a1,a0,8000024c <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    8000022c:	1602                	slli	a2,a2,0x20
    8000022e:	9201                	srli	a2,a2,0x20
    80000230:	00c587b3          	add	a5,a1,a2
{
    80000234:	872a                	mv	a4,a0
      *d++ = *s++;
    80000236:	0585                	addi	a1,a1,1
    80000238:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffd8dc1>
    8000023a:	fff5c683          	lbu	a3,-1(a1)
    8000023e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000242:	fef59ae3          	bne	a1,a5,80000236 <memmove+0x16>

  return dst;
}
    80000246:	6422                	ld	s0,8(sp)
    80000248:	0141                	addi	sp,sp,16
    8000024a:	8082                	ret
  if(s < d && s + n > d){
    8000024c:	02061693          	slli	a3,a2,0x20
    80000250:	9281                	srli	a3,a3,0x20
    80000252:	00d58733          	add	a4,a1,a3
    80000256:	fce57be3          	bgeu	a0,a4,8000022c <memmove+0xc>
    d += n;
    8000025a:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    8000025c:	fff6079b          	addiw	a5,a2,-1
    80000260:	1782                	slli	a5,a5,0x20
    80000262:	9381                	srli	a5,a5,0x20
    80000264:	fff7c793          	not	a5,a5
    80000268:	97ba                	add	a5,a5,a4
      *--d = *--s;
    8000026a:	177d                	addi	a4,a4,-1
    8000026c:	16fd                	addi	a3,a3,-1
    8000026e:	00074603          	lbu	a2,0(a4)
    80000272:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000276:	fee79ae3          	bne	a5,a4,8000026a <memmove+0x4a>
    8000027a:	b7f1                	j	80000246 <memmove+0x26>

000000008000027c <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    8000027c:	1141                	addi	sp,sp,-16
    8000027e:	e406                	sd	ra,8(sp)
    80000280:	e022                	sd	s0,0(sp)
    80000282:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000284:	00000097          	auipc	ra,0x0
    80000288:	f9c080e7          	jalr	-100(ra) # 80000220 <memmove>
}
    8000028c:	60a2                	ld	ra,8(sp)
    8000028e:	6402                	ld	s0,0(sp)
    80000290:	0141                	addi	sp,sp,16
    80000292:	8082                	ret

0000000080000294 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000294:	1141                	addi	sp,sp,-16
    80000296:	e422                	sd	s0,8(sp)
    80000298:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000029a:	ce11                	beqz	a2,800002b6 <strncmp+0x22>
    8000029c:	00054783          	lbu	a5,0(a0)
    800002a0:	cf89                	beqz	a5,800002ba <strncmp+0x26>
    800002a2:	0005c703          	lbu	a4,0(a1)
    800002a6:	00f71a63          	bne	a4,a5,800002ba <strncmp+0x26>
    n--, p++, q++;
    800002aa:	367d                	addiw	a2,a2,-1
    800002ac:	0505                	addi	a0,a0,1
    800002ae:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    800002b0:	f675                	bnez	a2,8000029c <strncmp+0x8>
  if(n == 0)
    return 0;
    800002b2:	4501                	li	a0,0
    800002b4:	a809                	j	800002c6 <strncmp+0x32>
    800002b6:	4501                	li	a0,0
    800002b8:	a039                	j	800002c6 <strncmp+0x32>
  if(n == 0)
    800002ba:	ca09                	beqz	a2,800002cc <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    800002bc:	00054503          	lbu	a0,0(a0)
    800002c0:	0005c783          	lbu	a5,0(a1)
    800002c4:	9d1d                	subw	a0,a0,a5
}
    800002c6:	6422                	ld	s0,8(sp)
    800002c8:	0141                	addi	sp,sp,16
    800002ca:	8082                	ret
    return 0;
    800002cc:	4501                	li	a0,0
    800002ce:	bfe5                	j	800002c6 <strncmp+0x32>

00000000800002d0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800002d0:	1141                	addi	sp,sp,-16
    800002d2:	e422                	sd	s0,8(sp)
    800002d4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800002d6:	872a                	mv	a4,a0
    800002d8:	8832                	mv	a6,a2
    800002da:	367d                	addiw	a2,a2,-1
    800002dc:	01005963          	blez	a6,800002ee <strncpy+0x1e>
    800002e0:	0705                	addi	a4,a4,1
    800002e2:	0005c783          	lbu	a5,0(a1)
    800002e6:	fef70fa3          	sb	a5,-1(a4)
    800002ea:	0585                	addi	a1,a1,1
    800002ec:	f7f5                	bnez	a5,800002d8 <strncpy+0x8>
    ;
  while(n-- > 0)
    800002ee:	86ba                	mv	a3,a4
    800002f0:	00c05c63          	blez	a2,80000308 <strncpy+0x38>
    *s++ = 0;
    800002f4:	0685                	addi	a3,a3,1
    800002f6:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002fa:	40d707bb          	subw	a5,a4,a3
    800002fe:	37fd                	addiw	a5,a5,-1
    80000300:	010787bb          	addw	a5,a5,a6
    80000304:	fef048e3          	bgtz	a5,800002f4 <strncpy+0x24>
  return os;
}
    80000308:	6422                	ld	s0,8(sp)
    8000030a:	0141                	addi	sp,sp,16
    8000030c:	8082                	ret

000000008000030e <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    8000030e:	1141                	addi	sp,sp,-16
    80000310:	e422                	sd	s0,8(sp)
    80000312:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000314:	02c05363          	blez	a2,8000033a <safestrcpy+0x2c>
    80000318:	fff6069b          	addiw	a3,a2,-1
    8000031c:	1682                	slli	a3,a3,0x20
    8000031e:	9281                	srli	a3,a3,0x20
    80000320:	96ae                	add	a3,a3,a1
    80000322:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000324:	00d58963          	beq	a1,a3,80000336 <safestrcpy+0x28>
    80000328:	0585                	addi	a1,a1,1
    8000032a:	0785                	addi	a5,a5,1
    8000032c:	fff5c703          	lbu	a4,-1(a1)
    80000330:	fee78fa3          	sb	a4,-1(a5)
    80000334:	fb65                	bnez	a4,80000324 <safestrcpy+0x16>
    ;
  *s = 0;
    80000336:	00078023          	sb	zero,0(a5)
  return os;
}
    8000033a:	6422                	ld	s0,8(sp)
    8000033c:	0141                	addi	sp,sp,16
    8000033e:	8082                	ret

0000000080000340 <strlen>:

int
strlen(const char *s)
{
    80000340:	1141                	addi	sp,sp,-16
    80000342:	e422                	sd	s0,8(sp)
    80000344:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000346:	00054783          	lbu	a5,0(a0)
    8000034a:	cf91                	beqz	a5,80000366 <strlen+0x26>
    8000034c:	0505                	addi	a0,a0,1
    8000034e:	87aa                	mv	a5,a0
    80000350:	4685                	li	a3,1
    80000352:	9e89                	subw	a3,a3,a0
    80000354:	00f6853b          	addw	a0,a3,a5
    80000358:	0785                	addi	a5,a5,1
    8000035a:	fff7c703          	lbu	a4,-1(a5)
    8000035e:	fb7d                	bnez	a4,80000354 <strlen+0x14>
    ;
  return n;
}
    80000360:	6422                	ld	s0,8(sp)
    80000362:	0141                	addi	sp,sp,16
    80000364:	8082                	ret
  for(n = 0; s[n]; n++)
    80000366:	4501                	li	a0,0
    80000368:	bfe5                	j	80000360 <strlen+0x20>

000000008000036a <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    8000036a:	1141                	addi	sp,sp,-16
    8000036c:	e406                	sd	ra,8(sp)
    8000036e:	e022                	sd	s0,0(sp)
    80000370:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000372:	00001097          	auipc	ra,0x1
    80000376:	af0080e7          	jalr	-1296(ra) # 80000e62 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    8000037a:	00009717          	auipc	a4,0x9
    8000037e:	c8670713          	addi	a4,a4,-890 # 80009000 <started>
  if(cpuid() == 0){
    80000382:	c139                	beqz	a0,800003c8 <main+0x5e>
    while(started == 0)
    80000384:	431c                	lw	a5,0(a4)
    80000386:	2781                	sext.w	a5,a5
    80000388:	dff5                	beqz	a5,80000384 <main+0x1a>
      ;
    __sync_synchronize();
    8000038a:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000038e:	00001097          	auipc	ra,0x1
    80000392:	ad4080e7          	jalr	-1324(ra) # 80000e62 <cpuid>
    80000396:	85aa                	mv	a1,a0
    80000398:	00008517          	auipc	a0,0x8
    8000039c:	ca050513          	addi	a0,a0,-864 # 80008038 <etext+0x38>
    800003a0:	00006097          	auipc	ra,0x6
    800003a4:	90a080e7          	jalr	-1782(ra) # 80005caa <printf>
    kvminithart();    // turn on paging
    800003a8:	00000097          	auipc	ra,0x0
    800003ac:	0d8080e7          	jalr	216(ra) # 80000480 <kvminithart>
    trapinithart();   // install kernel trap vector
    800003b0:	00001097          	auipc	ra,0x1
    800003b4:	794080e7          	jalr	1940(ra) # 80001b44 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    800003b8:	00005097          	auipc	ra,0x5
    800003bc:	dd8080e7          	jalr	-552(ra) # 80005190 <plicinithart>
  }

  scheduler();        
    800003c0:	00001097          	auipc	ra,0x1
    800003c4:	fec080e7          	jalr	-20(ra) # 800013ac <scheduler>
    consoleinit();
    800003c8:	00005097          	auipc	ra,0x5
    800003cc:	7a8080e7          	jalr	1960(ra) # 80005b70 <consoleinit>
    printfinit();
    800003d0:	00006097          	auipc	ra,0x6
    800003d4:	aba080e7          	jalr	-1350(ra) # 80005e8a <printfinit>
    printf("\n");
    800003d8:	00008517          	auipc	a0,0x8
    800003dc:	c7050513          	addi	a0,a0,-912 # 80008048 <etext+0x48>
    800003e0:	00006097          	auipc	ra,0x6
    800003e4:	8ca080e7          	jalr	-1846(ra) # 80005caa <printf>
    printf("xv6 kernel is booting\n");
    800003e8:	00008517          	auipc	a0,0x8
    800003ec:	c3850513          	addi	a0,a0,-968 # 80008020 <etext+0x20>
    800003f0:	00006097          	auipc	ra,0x6
    800003f4:	8ba080e7          	jalr	-1862(ra) # 80005caa <printf>
    printf("\n");
    800003f8:	00008517          	auipc	a0,0x8
    800003fc:	c5050513          	addi	a0,a0,-944 # 80008048 <etext+0x48>
    80000400:	00006097          	auipc	ra,0x6
    80000404:	8aa080e7          	jalr	-1878(ra) # 80005caa <printf>
    kinit();         // physical page allocator
    80000408:	00000097          	auipc	ra,0x0
    8000040c:	cd6080e7          	jalr	-810(ra) # 800000de <kinit>
    kvminit();       // create kernel page table
    80000410:	00000097          	auipc	ra,0x0
    80000414:	322080e7          	jalr	802(ra) # 80000732 <kvminit>
    kvminithart();   // turn on paging
    80000418:	00000097          	auipc	ra,0x0
    8000041c:	068080e7          	jalr	104(ra) # 80000480 <kvminithart>
    procinit();      // process table
    80000420:	00001097          	auipc	ra,0x1
    80000424:	992080e7          	jalr	-1646(ra) # 80000db2 <procinit>
    trapinit();      // trap vectors
    80000428:	00001097          	auipc	ra,0x1
    8000042c:	6f4080e7          	jalr	1780(ra) # 80001b1c <trapinit>
    trapinithart();  // install kernel trap vector
    80000430:	00001097          	auipc	ra,0x1
    80000434:	714080e7          	jalr	1812(ra) # 80001b44 <trapinithart>
    plicinit();      // set up interrupt controller
    80000438:	00005097          	auipc	ra,0x5
    8000043c:	d42080e7          	jalr	-702(ra) # 8000517a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000440:	00005097          	auipc	ra,0x5
    80000444:	d50080e7          	jalr	-688(ra) # 80005190 <plicinithart>
    binit();         // buffer cache
    80000448:	00002097          	auipc	ra,0x2
    8000044c:	f12080e7          	jalr	-238(ra) # 8000235a <binit>
    iinit();         // inode table
    80000450:	00002097          	auipc	ra,0x2
    80000454:	5a0080e7          	jalr	1440(ra) # 800029f0 <iinit>
    fileinit();      // file table
    80000458:	00003097          	auipc	ra,0x3
    8000045c:	552080e7          	jalr	1362(ra) # 800039aa <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000460:	00005097          	auipc	ra,0x5
    80000464:	e50080e7          	jalr	-432(ra) # 800052b0 <virtio_disk_init>
    userinit();      // first user process
    80000468:	00001097          	auipc	ra,0x1
    8000046c:	cfe080e7          	jalr	-770(ra) # 80001166 <userinit>
    __sync_synchronize();
    80000470:	0ff0000f          	fence
    started = 1;
    80000474:	4785                	li	a5,1
    80000476:	00009717          	auipc	a4,0x9
    8000047a:	b8f72523          	sw	a5,-1142(a4) # 80009000 <started>
    8000047e:	b789                	j	800003c0 <main+0x56>

0000000080000480 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000480:	1141                	addi	sp,sp,-16
    80000482:	e422                	sd	s0,8(sp)
    80000484:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000486:	00009797          	auipc	a5,0x9
    8000048a:	b827b783          	ld	a5,-1150(a5) # 80009008 <kernel_pagetable>
    8000048e:	83b1                	srli	a5,a5,0xc
    80000490:	577d                	li	a4,-1
    80000492:	177e                	slli	a4,a4,0x3f
    80000494:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    80000496:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000049a:	12000073          	sfence.vma
  sfence_vma();
}
    8000049e:	6422                	ld	s0,8(sp)
    800004a0:	0141                	addi	sp,sp,16
    800004a2:	8082                	ret

00000000800004a4 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800004a4:	7139                	addi	sp,sp,-64
    800004a6:	fc06                	sd	ra,56(sp)
    800004a8:	f822                	sd	s0,48(sp)
    800004aa:	f426                	sd	s1,40(sp)
    800004ac:	f04a                	sd	s2,32(sp)
    800004ae:	ec4e                	sd	s3,24(sp)
    800004b0:	e852                	sd	s4,16(sp)
    800004b2:	e456                	sd	s5,8(sp)
    800004b4:	e05a                	sd	s6,0(sp)
    800004b6:	0080                	addi	s0,sp,64
    800004b8:	84aa                	mv	s1,a0
    800004ba:	89ae                	mv	s3,a1
    800004bc:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800004be:	57fd                	li	a5,-1
    800004c0:	83e9                	srli	a5,a5,0x1a
    800004c2:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800004c4:	4b31                	li	s6,12
  if(va >= MAXVA)
    800004c6:	04b7f263          	bgeu	a5,a1,8000050a <walk+0x66>
    panic("walk");
    800004ca:	00008517          	auipc	a0,0x8
    800004ce:	b8650513          	addi	a0,a0,-1146 # 80008050 <etext+0x50>
    800004d2:	00005097          	auipc	ra,0x5
    800004d6:	78e080e7          	jalr	1934(ra) # 80005c60 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800004da:	060a8663          	beqz	s5,80000546 <walk+0xa2>
    800004de:	00000097          	auipc	ra,0x0
    800004e2:	c3c080e7          	jalr	-964(ra) # 8000011a <kalloc>
    800004e6:	84aa                	mv	s1,a0
    800004e8:	c529                	beqz	a0,80000532 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004ea:	6605                	lui	a2,0x1
    800004ec:	4581                	li	a1,0
    800004ee:	00000097          	auipc	ra,0x0
    800004f2:	cd6080e7          	jalr	-810(ra) # 800001c4 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004f6:	00c4d793          	srli	a5,s1,0xc
    800004fa:	07aa                	slli	a5,a5,0xa
    800004fc:	0017e793          	ori	a5,a5,1
    80000500:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000504:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffd8db7>
    80000506:	036a0063          	beq	s4,s6,80000526 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    8000050a:	0149d933          	srl	s2,s3,s4
    8000050e:	1ff97913          	andi	s2,s2,511
    80000512:	090e                	slli	s2,s2,0x3
    80000514:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000516:	00093483          	ld	s1,0(s2)
    8000051a:	0014f793          	andi	a5,s1,1
    8000051e:	dfd5                	beqz	a5,800004da <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000520:	80a9                	srli	s1,s1,0xa
    80000522:	04b2                	slli	s1,s1,0xc
    80000524:	b7c5                	j	80000504 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80000526:	00c9d513          	srli	a0,s3,0xc
    8000052a:	1ff57513          	andi	a0,a0,511
    8000052e:	050e                	slli	a0,a0,0x3
    80000530:	9526                	add	a0,a0,s1
}
    80000532:	70e2                	ld	ra,56(sp)
    80000534:	7442                	ld	s0,48(sp)
    80000536:	74a2                	ld	s1,40(sp)
    80000538:	7902                	ld	s2,32(sp)
    8000053a:	69e2                	ld	s3,24(sp)
    8000053c:	6a42                	ld	s4,16(sp)
    8000053e:	6aa2                	ld	s5,8(sp)
    80000540:	6b02                	ld	s6,0(sp)
    80000542:	6121                	addi	sp,sp,64
    80000544:	8082                	ret
        return 0;
    80000546:	4501                	li	a0,0
    80000548:	b7ed                	j	80000532 <walk+0x8e>

000000008000054a <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000054a:	57fd                	li	a5,-1
    8000054c:	83e9                	srli	a5,a5,0x1a
    8000054e:	00b7f463          	bgeu	a5,a1,80000556 <walkaddr+0xc>
    return 0;
    80000552:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000554:	8082                	ret
{
    80000556:	1141                	addi	sp,sp,-16
    80000558:	e406                	sd	ra,8(sp)
    8000055a:	e022                	sd	s0,0(sp)
    8000055c:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000055e:	4601                	li	a2,0
    80000560:	00000097          	auipc	ra,0x0
    80000564:	f44080e7          	jalr	-188(ra) # 800004a4 <walk>
  if(pte == 0)
    80000568:	c105                	beqz	a0,80000588 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000056a:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000056c:	0117f693          	andi	a3,a5,17
    80000570:	4745                	li	a4,17
    return 0;
    80000572:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000574:	00e68663          	beq	a3,a4,80000580 <walkaddr+0x36>
}
    80000578:	60a2                	ld	ra,8(sp)
    8000057a:	6402                	ld	s0,0(sp)
    8000057c:	0141                	addi	sp,sp,16
    8000057e:	8082                	ret
  pa = PTE2PA(*pte);
    80000580:	83a9                	srli	a5,a5,0xa
    80000582:	00c79513          	slli	a0,a5,0xc
  return pa;
    80000586:	bfcd                	j	80000578 <walkaddr+0x2e>
    return 0;
    80000588:	4501                	li	a0,0
    8000058a:	b7fd                	j	80000578 <walkaddr+0x2e>

000000008000058c <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000058c:	715d                	addi	sp,sp,-80
    8000058e:	e486                	sd	ra,72(sp)
    80000590:	e0a2                	sd	s0,64(sp)
    80000592:	fc26                	sd	s1,56(sp)
    80000594:	f84a                	sd	s2,48(sp)
    80000596:	f44e                	sd	s3,40(sp)
    80000598:	f052                	sd	s4,32(sp)
    8000059a:	ec56                	sd	s5,24(sp)
    8000059c:	e85a                	sd	s6,16(sp)
    8000059e:	e45e                	sd	s7,8(sp)
    800005a0:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    800005a2:	c639                	beqz	a2,800005f0 <mappages+0x64>
    800005a4:	8aaa                	mv	s5,a0
    800005a6:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    800005a8:	777d                	lui	a4,0xfffff
    800005aa:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    800005ae:	fff58993          	addi	s3,a1,-1
    800005b2:	99b2                	add	s3,s3,a2
    800005b4:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    800005b8:	893e                	mv	s2,a5
    800005ba:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800005be:	6b85                	lui	s7,0x1
    800005c0:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800005c4:	4605                	li	a2,1
    800005c6:	85ca                	mv	a1,s2
    800005c8:	8556                	mv	a0,s5
    800005ca:	00000097          	auipc	ra,0x0
    800005ce:	eda080e7          	jalr	-294(ra) # 800004a4 <walk>
    800005d2:	cd1d                	beqz	a0,80000610 <mappages+0x84>
    if(*pte & PTE_V)
    800005d4:	611c                	ld	a5,0(a0)
    800005d6:	8b85                	andi	a5,a5,1
    800005d8:	e785                	bnez	a5,80000600 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005da:	80b1                	srli	s1,s1,0xc
    800005dc:	04aa                	slli	s1,s1,0xa
    800005de:	0164e4b3          	or	s1,s1,s6
    800005e2:	0014e493          	ori	s1,s1,1
    800005e6:	e104                	sd	s1,0(a0)
    if(a == last)
    800005e8:	05390063          	beq	s2,s3,80000628 <mappages+0x9c>
    a += PGSIZE;
    800005ec:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005ee:	bfc9                	j	800005c0 <mappages+0x34>
    panic("mappages: size");
    800005f0:	00008517          	auipc	a0,0x8
    800005f4:	a6850513          	addi	a0,a0,-1432 # 80008058 <etext+0x58>
    800005f8:	00005097          	auipc	ra,0x5
    800005fc:	668080e7          	jalr	1640(ra) # 80005c60 <panic>
      panic("mappages: remap");
    80000600:	00008517          	auipc	a0,0x8
    80000604:	a6850513          	addi	a0,a0,-1432 # 80008068 <etext+0x68>
    80000608:	00005097          	auipc	ra,0x5
    8000060c:	658080e7          	jalr	1624(ra) # 80005c60 <panic>
      return -1;
    80000610:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80000612:	60a6                	ld	ra,72(sp)
    80000614:	6406                	ld	s0,64(sp)
    80000616:	74e2                	ld	s1,56(sp)
    80000618:	7942                	ld	s2,48(sp)
    8000061a:	79a2                	ld	s3,40(sp)
    8000061c:	7a02                	ld	s4,32(sp)
    8000061e:	6ae2                	ld	s5,24(sp)
    80000620:	6b42                	ld	s6,16(sp)
    80000622:	6ba2                	ld	s7,8(sp)
    80000624:	6161                	addi	sp,sp,80
    80000626:	8082                	ret
  return 0;
    80000628:	4501                	li	a0,0
    8000062a:	b7e5                	j	80000612 <mappages+0x86>

000000008000062c <kvmmap>:
{
    8000062c:	1141                	addi	sp,sp,-16
    8000062e:	e406                	sd	ra,8(sp)
    80000630:	e022                	sd	s0,0(sp)
    80000632:	0800                	addi	s0,sp,16
    80000634:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000636:	86b2                	mv	a3,a2
    80000638:	863e                	mv	a2,a5
    8000063a:	00000097          	auipc	ra,0x0
    8000063e:	f52080e7          	jalr	-174(ra) # 8000058c <mappages>
    80000642:	e509                	bnez	a0,8000064c <kvmmap+0x20>
}
    80000644:	60a2                	ld	ra,8(sp)
    80000646:	6402                	ld	s0,0(sp)
    80000648:	0141                	addi	sp,sp,16
    8000064a:	8082                	ret
    panic("kvmmap");
    8000064c:	00008517          	auipc	a0,0x8
    80000650:	a2c50513          	addi	a0,a0,-1492 # 80008078 <etext+0x78>
    80000654:	00005097          	auipc	ra,0x5
    80000658:	60c080e7          	jalr	1548(ra) # 80005c60 <panic>

000000008000065c <kvmmake>:
{
    8000065c:	1101                	addi	sp,sp,-32
    8000065e:	ec06                	sd	ra,24(sp)
    80000660:	e822                	sd	s0,16(sp)
    80000662:	e426                	sd	s1,8(sp)
    80000664:	e04a                	sd	s2,0(sp)
    80000666:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000668:	00000097          	auipc	ra,0x0
    8000066c:	ab2080e7          	jalr	-1358(ra) # 8000011a <kalloc>
    80000670:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000672:	6605                	lui	a2,0x1
    80000674:	4581                	li	a1,0
    80000676:	00000097          	auipc	ra,0x0
    8000067a:	b4e080e7          	jalr	-1202(ra) # 800001c4 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000067e:	4719                	li	a4,6
    80000680:	6685                	lui	a3,0x1
    80000682:	10000637          	lui	a2,0x10000
    80000686:	100005b7          	lui	a1,0x10000
    8000068a:	8526                	mv	a0,s1
    8000068c:	00000097          	auipc	ra,0x0
    80000690:	fa0080e7          	jalr	-96(ra) # 8000062c <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000694:	4719                	li	a4,6
    80000696:	6685                	lui	a3,0x1
    80000698:	10001637          	lui	a2,0x10001
    8000069c:	100015b7          	lui	a1,0x10001
    800006a0:	8526                	mv	a0,s1
    800006a2:	00000097          	auipc	ra,0x0
    800006a6:	f8a080e7          	jalr	-118(ra) # 8000062c <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800006aa:	4719                	li	a4,6
    800006ac:	004006b7          	lui	a3,0x400
    800006b0:	0c000637          	lui	a2,0xc000
    800006b4:	0c0005b7          	lui	a1,0xc000
    800006b8:	8526                	mv	a0,s1
    800006ba:	00000097          	auipc	ra,0x0
    800006be:	f72080e7          	jalr	-142(ra) # 8000062c <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800006c2:	00008917          	auipc	s2,0x8
    800006c6:	93e90913          	addi	s2,s2,-1730 # 80008000 <etext>
    800006ca:	4729                	li	a4,10
    800006cc:	80008697          	auipc	a3,0x80008
    800006d0:	93468693          	addi	a3,a3,-1740 # 8000 <_entry-0x7fff8000>
    800006d4:	4605                	li	a2,1
    800006d6:	067e                	slli	a2,a2,0x1f
    800006d8:	85b2                	mv	a1,a2
    800006da:	8526                	mv	a0,s1
    800006dc:	00000097          	auipc	ra,0x0
    800006e0:	f50080e7          	jalr	-176(ra) # 8000062c <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006e4:	4719                	li	a4,6
    800006e6:	46c5                	li	a3,17
    800006e8:	06ee                	slli	a3,a3,0x1b
    800006ea:	412686b3          	sub	a3,a3,s2
    800006ee:	864a                	mv	a2,s2
    800006f0:	85ca                	mv	a1,s2
    800006f2:	8526                	mv	a0,s1
    800006f4:	00000097          	auipc	ra,0x0
    800006f8:	f38080e7          	jalr	-200(ra) # 8000062c <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006fc:	4729                	li	a4,10
    800006fe:	6685                	lui	a3,0x1
    80000700:	00007617          	auipc	a2,0x7
    80000704:	90060613          	addi	a2,a2,-1792 # 80007000 <_trampoline>
    80000708:	040005b7          	lui	a1,0x4000
    8000070c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000070e:	05b2                	slli	a1,a1,0xc
    80000710:	8526                	mv	a0,s1
    80000712:	00000097          	auipc	ra,0x0
    80000716:	f1a080e7          	jalr	-230(ra) # 8000062c <kvmmap>
  proc_mapstacks(kpgtbl);
    8000071a:	8526                	mv	a0,s1
    8000071c:	00000097          	auipc	ra,0x0
    80000720:	600080e7          	jalr	1536(ra) # 80000d1c <proc_mapstacks>
}
    80000724:	8526                	mv	a0,s1
    80000726:	60e2                	ld	ra,24(sp)
    80000728:	6442                	ld	s0,16(sp)
    8000072a:	64a2                	ld	s1,8(sp)
    8000072c:	6902                	ld	s2,0(sp)
    8000072e:	6105                	addi	sp,sp,32
    80000730:	8082                	ret

0000000080000732 <kvminit>:
{
    80000732:	1141                	addi	sp,sp,-16
    80000734:	e406                	sd	ra,8(sp)
    80000736:	e022                	sd	s0,0(sp)
    80000738:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000073a:	00000097          	auipc	ra,0x0
    8000073e:	f22080e7          	jalr	-222(ra) # 8000065c <kvmmake>
    80000742:	00009797          	auipc	a5,0x9
    80000746:	8ca7b323          	sd	a0,-1850(a5) # 80009008 <kernel_pagetable>
}
    8000074a:	60a2                	ld	ra,8(sp)
    8000074c:	6402                	ld	s0,0(sp)
    8000074e:	0141                	addi	sp,sp,16
    80000750:	8082                	ret

0000000080000752 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000752:	715d                	addi	sp,sp,-80
    80000754:	e486                	sd	ra,72(sp)
    80000756:	e0a2                	sd	s0,64(sp)
    80000758:	fc26                	sd	s1,56(sp)
    8000075a:	f84a                	sd	s2,48(sp)
    8000075c:	f44e                	sd	s3,40(sp)
    8000075e:	f052                	sd	s4,32(sp)
    80000760:	ec56                	sd	s5,24(sp)
    80000762:	e85a                	sd	s6,16(sp)
    80000764:	e45e                	sd	s7,8(sp)
    80000766:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000768:	03459793          	slli	a5,a1,0x34
    8000076c:	e795                	bnez	a5,80000798 <uvmunmap+0x46>
    8000076e:	8a2a                	mv	s4,a0
    80000770:	892e                	mv	s2,a1
    80000772:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000774:	0632                	slli	a2,a2,0xc
    80000776:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000077a:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000077c:	6b05                	lui	s6,0x1
    8000077e:	0735e263          	bltu	a1,s3,800007e2 <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000782:	60a6                	ld	ra,72(sp)
    80000784:	6406                	ld	s0,64(sp)
    80000786:	74e2                	ld	s1,56(sp)
    80000788:	7942                	ld	s2,48(sp)
    8000078a:	79a2                	ld	s3,40(sp)
    8000078c:	7a02                	ld	s4,32(sp)
    8000078e:	6ae2                	ld	s5,24(sp)
    80000790:	6b42                	ld	s6,16(sp)
    80000792:	6ba2                	ld	s7,8(sp)
    80000794:	6161                	addi	sp,sp,80
    80000796:	8082                	ret
    panic("uvmunmap: not aligned");
    80000798:	00008517          	auipc	a0,0x8
    8000079c:	8e850513          	addi	a0,a0,-1816 # 80008080 <etext+0x80>
    800007a0:	00005097          	auipc	ra,0x5
    800007a4:	4c0080e7          	jalr	1216(ra) # 80005c60 <panic>
      panic("uvmunmap: walk");
    800007a8:	00008517          	auipc	a0,0x8
    800007ac:	8f050513          	addi	a0,a0,-1808 # 80008098 <etext+0x98>
    800007b0:	00005097          	auipc	ra,0x5
    800007b4:	4b0080e7          	jalr	1200(ra) # 80005c60 <panic>
      panic("uvmunmap: not mapped");
    800007b8:	00008517          	auipc	a0,0x8
    800007bc:	8f050513          	addi	a0,a0,-1808 # 800080a8 <etext+0xa8>
    800007c0:	00005097          	auipc	ra,0x5
    800007c4:	4a0080e7          	jalr	1184(ra) # 80005c60 <panic>
      panic("uvmunmap: not a leaf");
    800007c8:	00008517          	auipc	a0,0x8
    800007cc:	8f850513          	addi	a0,a0,-1800 # 800080c0 <etext+0xc0>
    800007d0:	00005097          	auipc	ra,0x5
    800007d4:	490080e7          	jalr	1168(ra) # 80005c60 <panic>
    *pte = 0;
    800007d8:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007dc:	995a                	add	s2,s2,s6
    800007de:	fb3972e3          	bgeu	s2,s3,80000782 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007e2:	4601                	li	a2,0
    800007e4:	85ca                	mv	a1,s2
    800007e6:	8552                	mv	a0,s4
    800007e8:	00000097          	auipc	ra,0x0
    800007ec:	cbc080e7          	jalr	-836(ra) # 800004a4 <walk>
    800007f0:	84aa                	mv	s1,a0
    800007f2:	d95d                	beqz	a0,800007a8 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007f4:	6108                	ld	a0,0(a0)
    800007f6:	00157793          	andi	a5,a0,1
    800007fa:	dfdd                	beqz	a5,800007b8 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007fc:	3ff57793          	andi	a5,a0,1023
    80000800:	fd7784e3          	beq	a5,s7,800007c8 <uvmunmap+0x76>
    if(do_free){
    80000804:	fc0a8ae3          	beqz	s5,800007d8 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    80000808:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    8000080a:	0532                	slli	a0,a0,0xc
    8000080c:	00000097          	auipc	ra,0x0
    80000810:	810080e7          	jalr	-2032(ra) # 8000001c <kfree>
    80000814:	b7d1                	j	800007d8 <uvmunmap+0x86>

0000000080000816 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80000816:	1101                	addi	sp,sp,-32
    80000818:	ec06                	sd	ra,24(sp)
    8000081a:	e822                	sd	s0,16(sp)
    8000081c:	e426                	sd	s1,8(sp)
    8000081e:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000820:	00000097          	auipc	ra,0x0
    80000824:	8fa080e7          	jalr	-1798(ra) # 8000011a <kalloc>
    80000828:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000082a:	c519                	beqz	a0,80000838 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000082c:	6605                	lui	a2,0x1
    8000082e:	4581                	li	a1,0
    80000830:	00000097          	auipc	ra,0x0
    80000834:	994080e7          	jalr	-1644(ra) # 800001c4 <memset>
  return pagetable;
}
    80000838:	8526                	mv	a0,s1
    8000083a:	60e2                	ld	ra,24(sp)
    8000083c:	6442                	ld	s0,16(sp)
    8000083e:	64a2                	ld	s1,8(sp)
    80000840:	6105                	addi	sp,sp,32
    80000842:	8082                	ret

0000000080000844 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    80000844:	7179                	addi	sp,sp,-48
    80000846:	f406                	sd	ra,40(sp)
    80000848:	f022                	sd	s0,32(sp)
    8000084a:	ec26                	sd	s1,24(sp)
    8000084c:	e84a                	sd	s2,16(sp)
    8000084e:	e44e                	sd	s3,8(sp)
    80000850:	e052                	sd	s4,0(sp)
    80000852:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000854:	6785                	lui	a5,0x1
    80000856:	04f67863          	bgeu	a2,a5,800008a6 <uvminit+0x62>
    8000085a:	8a2a                	mv	s4,a0
    8000085c:	89ae                	mv	s3,a1
    8000085e:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80000860:	00000097          	auipc	ra,0x0
    80000864:	8ba080e7          	jalr	-1862(ra) # 8000011a <kalloc>
    80000868:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000086a:	6605                	lui	a2,0x1
    8000086c:	4581                	li	a1,0
    8000086e:	00000097          	auipc	ra,0x0
    80000872:	956080e7          	jalr	-1706(ra) # 800001c4 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000876:	4779                	li	a4,30
    80000878:	86ca                	mv	a3,s2
    8000087a:	6605                	lui	a2,0x1
    8000087c:	4581                	li	a1,0
    8000087e:	8552                	mv	a0,s4
    80000880:	00000097          	auipc	ra,0x0
    80000884:	d0c080e7          	jalr	-756(ra) # 8000058c <mappages>
  memmove(mem, src, sz);
    80000888:	8626                	mv	a2,s1
    8000088a:	85ce                	mv	a1,s3
    8000088c:	854a                	mv	a0,s2
    8000088e:	00000097          	auipc	ra,0x0
    80000892:	992080e7          	jalr	-1646(ra) # 80000220 <memmove>
}
    80000896:	70a2                	ld	ra,40(sp)
    80000898:	7402                	ld	s0,32(sp)
    8000089a:	64e2                	ld	s1,24(sp)
    8000089c:	6942                	ld	s2,16(sp)
    8000089e:	69a2                	ld	s3,8(sp)
    800008a0:	6a02                	ld	s4,0(sp)
    800008a2:	6145                	addi	sp,sp,48
    800008a4:	8082                	ret
    panic("inituvm: more than a page");
    800008a6:	00008517          	auipc	a0,0x8
    800008aa:	83250513          	addi	a0,a0,-1998 # 800080d8 <etext+0xd8>
    800008ae:	00005097          	auipc	ra,0x5
    800008b2:	3b2080e7          	jalr	946(ra) # 80005c60 <panic>

00000000800008b6 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800008b6:	1101                	addi	sp,sp,-32
    800008b8:	ec06                	sd	ra,24(sp)
    800008ba:	e822                	sd	s0,16(sp)
    800008bc:	e426                	sd	s1,8(sp)
    800008be:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800008c0:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800008c2:	00b67d63          	bgeu	a2,a1,800008dc <uvmdealloc+0x26>
    800008c6:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800008c8:	6785                	lui	a5,0x1
    800008ca:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008cc:	00f60733          	add	a4,a2,a5
    800008d0:	76fd                	lui	a3,0xfffff
    800008d2:	8f75                	and	a4,a4,a3
    800008d4:	97ae                	add	a5,a5,a1
    800008d6:	8ff5                	and	a5,a5,a3
    800008d8:	00f76863          	bltu	a4,a5,800008e8 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800008dc:	8526                	mv	a0,s1
    800008de:	60e2                	ld	ra,24(sp)
    800008e0:	6442                	ld	s0,16(sp)
    800008e2:	64a2                	ld	s1,8(sp)
    800008e4:	6105                	addi	sp,sp,32
    800008e6:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008e8:	8f99                	sub	a5,a5,a4
    800008ea:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008ec:	4685                	li	a3,1
    800008ee:	0007861b          	sext.w	a2,a5
    800008f2:	85ba                	mv	a1,a4
    800008f4:	00000097          	auipc	ra,0x0
    800008f8:	e5e080e7          	jalr	-418(ra) # 80000752 <uvmunmap>
    800008fc:	b7c5                	j	800008dc <uvmdealloc+0x26>

00000000800008fe <uvmalloc>:
  if(newsz < oldsz)
    800008fe:	0ab66163          	bltu	a2,a1,800009a0 <uvmalloc+0xa2>
{
    80000902:	7139                	addi	sp,sp,-64
    80000904:	fc06                	sd	ra,56(sp)
    80000906:	f822                	sd	s0,48(sp)
    80000908:	f426                	sd	s1,40(sp)
    8000090a:	f04a                	sd	s2,32(sp)
    8000090c:	ec4e                	sd	s3,24(sp)
    8000090e:	e852                	sd	s4,16(sp)
    80000910:	e456                	sd	s5,8(sp)
    80000912:	0080                	addi	s0,sp,64
    80000914:	8aaa                	mv	s5,a0
    80000916:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80000918:	6785                	lui	a5,0x1
    8000091a:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000091c:	95be                	add	a1,a1,a5
    8000091e:	77fd                	lui	a5,0xfffff
    80000920:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000924:	08c9f063          	bgeu	s3,a2,800009a4 <uvmalloc+0xa6>
    80000928:	894e                	mv	s2,s3
    mem = kalloc();
    8000092a:	fffff097          	auipc	ra,0xfffff
    8000092e:	7f0080e7          	jalr	2032(ra) # 8000011a <kalloc>
    80000932:	84aa                	mv	s1,a0
    if(mem == 0){
    80000934:	c51d                	beqz	a0,80000962 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80000936:	6605                	lui	a2,0x1
    80000938:	4581                	li	a1,0
    8000093a:	00000097          	auipc	ra,0x0
    8000093e:	88a080e7          	jalr	-1910(ra) # 800001c4 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80000942:	4779                	li	a4,30
    80000944:	86a6                	mv	a3,s1
    80000946:	6605                	lui	a2,0x1
    80000948:	85ca                	mv	a1,s2
    8000094a:	8556                	mv	a0,s5
    8000094c:	00000097          	auipc	ra,0x0
    80000950:	c40080e7          	jalr	-960(ra) # 8000058c <mappages>
    80000954:	e905                	bnez	a0,80000984 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000956:	6785                	lui	a5,0x1
    80000958:	993e                	add	s2,s2,a5
    8000095a:	fd4968e3          	bltu	s2,s4,8000092a <uvmalloc+0x2c>
  return newsz;
    8000095e:	8552                	mv	a0,s4
    80000960:	a809                	j	80000972 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80000962:	864e                	mv	a2,s3
    80000964:	85ca                	mv	a1,s2
    80000966:	8556                	mv	a0,s5
    80000968:	00000097          	auipc	ra,0x0
    8000096c:	f4e080e7          	jalr	-178(ra) # 800008b6 <uvmdealloc>
      return 0;
    80000970:	4501                	li	a0,0
}
    80000972:	70e2                	ld	ra,56(sp)
    80000974:	7442                	ld	s0,48(sp)
    80000976:	74a2                	ld	s1,40(sp)
    80000978:	7902                	ld	s2,32(sp)
    8000097a:	69e2                	ld	s3,24(sp)
    8000097c:	6a42                	ld	s4,16(sp)
    8000097e:	6aa2                	ld	s5,8(sp)
    80000980:	6121                	addi	sp,sp,64
    80000982:	8082                	ret
      kfree(mem);
    80000984:	8526                	mv	a0,s1
    80000986:	fffff097          	auipc	ra,0xfffff
    8000098a:	696080e7          	jalr	1686(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000098e:	864e                	mv	a2,s3
    80000990:	85ca                	mv	a1,s2
    80000992:	8556                	mv	a0,s5
    80000994:	00000097          	auipc	ra,0x0
    80000998:	f22080e7          	jalr	-222(ra) # 800008b6 <uvmdealloc>
      return 0;
    8000099c:	4501                	li	a0,0
    8000099e:	bfd1                	j	80000972 <uvmalloc+0x74>
    return oldsz;
    800009a0:	852e                	mv	a0,a1
}
    800009a2:	8082                	ret
  return newsz;
    800009a4:	8532                	mv	a0,a2
    800009a6:	b7f1                	j	80000972 <uvmalloc+0x74>

00000000800009a8 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800009a8:	7179                	addi	sp,sp,-48
    800009aa:	f406                	sd	ra,40(sp)
    800009ac:	f022                	sd	s0,32(sp)
    800009ae:	ec26                	sd	s1,24(sp)
    800009b0:	e84a                	sd	s2,16(sp)
    800009b2:	e44e                	sd	s3,8(sp)
    800009b4:	e052                	sd	s4,0(sp)
    800009b6:	1800                	addi	s0,sp,48
    800009b8:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800009ba:	84aa                	mv	s1,a0
    800009bc:	6905                	lui	s2,0x1
    800009be:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009c0:	4985                	li	s3,1
    800009c2:	a829                	j	800009dc <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800009c4:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800009c6:	00c79513          	slli	a0,a5,0xc
    800009ca:	00000097          	auipc	ra,0x0
    800009ce:	fde080e7          	jalr	-34(ra) # 800009a8 <freewalk>
      pagetable[i] = 0;
    800009d2:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800009d6:	04a1                	addi	s1,s1,8
    800009d8:	03248163          	beq	s1,s2,800009fa <freewalk+0x52>
    pte_t pte = pagetable[i];
    800009dc:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009de:	00f7f713          	andi	a4,a5,15
    800009e2:	ff3701e3          	beq	a4,s3,800009c4 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009e6:	8b85                	andi	a5,a5,1
    800009e8:	d7fd                	beqz	a5,800009d6 <freewalk+0x2e>
      panic("freewalk: leaf");
    800009ea:	00007517          	auipc	a0,0x7
    800009ee:	70e50513          	addi	a0,a0,1806 # 800080f8 <etext+0xf8>
    800009f2:	00005097          	auipc	ra,0x5
    800009f6:	26e080e7          	jalr	622(ra) # 80005c60 <panic>
    }
  }
  kfree((void*)pagetable);
    800009fa:	8552                	mv	a0,s4
    800009fc:	fffff097          	auipc	ra,0xfffff
    80000a00:	620080e7          	jalr	1568(ra) # 8000001c <kfree>
}
    80000a04:	70a2                	ld	ra,40(sp)
    80000a06:	7402                	ld	s0,32(sp)
    80000a08:	64e2                	ld	s1,24(sp)
    80000a0a:	6942                	ld	s2,16(sp)
    80000a0c:	69a2                	ld	s3,8(sp)
    80000a0e:	6a02                	ld	s4,0(sp)
    80000a10:	6145                	addi	sp,sp,48
    80000a12:	8082                	ret

0000000080000a14 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000a14:	1101                	addi	sp,sp,-32
    80000a16:	ec06                	sd	ra,24(sp)
    80000a18:	e822                	sd	s0,16(sp)
    80000a1a:	e426                	sd	s1,8(sp)
    80000a1c:	1000                	addi	s0,sp,32
    80000a1e:	84aa                	mv	s1,a0
  if(sz > 0)
    80000a20:	e999                	bnez	a1,80000a36 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000a22:	8526                	mv	a0,s1
    80000a24:	00000097          	auipc	ra,0x0
    80000a28:	f84080e7          	jalr	-124(ra) # 800009a8 <freewalk>
}
    80000a2c:	60e2                	ld	ra,24(sp)
    80000a2e:	6442                	ld	s0,16(sp)
    80000a30:	64a2                	ld	s1,8(sp)
    80000a32:	6105                	addi	sp,sp,32
    80000a34:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000a36:	6785                	lui	a5,0x1
    80000a38:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000a3a:	95be                	add	a1,a1,a5
    80000a3c:	4685                	li	a3,1
    80000a3e:	00c5d613          	srli	a2,a1,0xc
    80000a42:	4581                	li	a1,0
    80000a44:	00000097          	auipc	ra,0x0
    80000a48:	d0e080e7          	jalr	-754(ra) # 80000752 <uvmunmap>
    80000a4c:	bfd9                	j	80000a22 <uvmfree+0xe>

0000000080000a4e <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a4e:	c679                	beqz	a2,80000b1c <uvmcopy+0xce>
{
    80000a50:	715d                	addi	sp,sp,-80
    80000a52:	e486                	sd	ra,72(sp)
    80000a54:	e0a2                	sd	s0,64(sp)
    80000a56:	fc26                	sd	s1,56(sp)
    80000a58:	f84a                	sd	s2,48(sp)
    80000a5a:	f44e                	sd	s3,40(sp)
    80000a5c:	f052                	sd	s4,32(sp)
    80000a5e:	ec56                	sd	s5,24(sp)
    80000a60:	e85a                	sd	s6,16(sp)
    80000a62:	e45e                	sd	s7,8(sp)
    80000a64:	0880                	addi	s0,sp,80
    80000a66:	8b2a                	mv	s6,a0
    80000a68:	8aae                	mv	s5,a1
    80000a6a:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a6c:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a6e:	4601                	li	a2,0
    80000a70:	85ce                	mv	a1,s3
    80000a72:	855a                	mv	a0,s6
    80000a74:	00000097          	auipc	ra,0x0
    80000a78:	a30080e7          	jalr	-1488(ra) # 800004a4 <walk>
    80000a7c:	c531                	beqz	a0,80000ac8 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a7e:	6118                	ld	a4,0(a0)
    80000a80:	00177793          	andi	a5,a4,1
    80000a84:	cbb1                	beqz	a5,80000ad8 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a86:	00a75593          	srli	a1,a4,0xa
    80000a8a:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a8e:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a92:	fffff097          	auipc	ra,0xfffff
    80000a96:	688080e7          	jalr	1672(ra) # 8000011a <kalloc>
    80000a9a:	892a                	mv	s2,a0
    80000a9c:	c939                	beqz	a0,80000af2 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a9e:	6605                	lui	a2,0x1
    80000aa0:	85de                	mv	a1,s7
    80000aa2:	fffff097          	auipc	ra,0xfffff
    80000aa6:	77e080e7          	jalr	1918(ra) # 80000220 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000aaa:	8726                	mv	a4,s1
    80000aac:	86ca                	mv	a3,s2
    80000aae:	6605                	lui	a2,0x1
    80000ab0:	85ce                	mv	a1,s3
    80000ab2:	8556                	mv	a0,s5
    80000ab4:	00000097          	auipc	ra,0x0
    80000ab8:	ad8080e7          	jalr	-1320(ra) # 8000058c <mappages>
    80000abc:	e515                	bnez	a0,80000ae8 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000abe:	6785                	lui	a5,0x1
    80000ac0:	99be                	add	s3,s3,a5
    80000ac2:	fb49e6e3          	bltu	s3,s4,80000a6e <uvmcopy+0x20>
    80000ac6:	a081                	j	80000b06 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000ac8:	00007517          	auipc	a0,0x7
    80000acc:	64050513          	addi	a0,a0,1600 # 80008108 <etext+0x108>
    80000ad0:	00005097          	auipc	ra,0x5
    80000ad4:	190080e7          	jalr	400(ra) # 80005c60 <panic>
      panic("uvmcopy: page not present");
    80000ad8:	00007517          	auipc	a0,0x7
    80000adc:	65050513          	addi	a0,a0,1616 # 80008128 <etext+0x128>
    80000ae0:	00005097          	auipc	ra,0x5
    80000ae4:	180080e7          	jalr	384(ra) # 80005c60 <panic>
      kfree(mem);
    80000ae8:	854a                	mv	a0,s2
    80000aea:	fffff097          	auipc	ra,0xfffff
    80000aee:	532080e7          	jalr	1330(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000af2:	4685                	li	a3,1
    80000af4:	00c9d613          	srli	a2,s3,0xc
    80000af8:	4581                	li	a1,0
    80000afa:	8556                	mv	a0,s5
    80000afc:	00000097          	auipc	ra,0x0
    80000b00:	c56080e7          	jalr	-938(ra) # 80000752 <uvmunmap>
  return -1;
    80000b04:	557d                	li	a0,-1
}
    80000b06:	60a6                	ld	ra,72(sp)
    80000b08:	6406                	ld	s0,64(sp)
    80000b0a:	74e2                	ld	s1,56(sp)
    80000b0c:	7942                	ld	s2,48(sp)
    80000b0e:	79a2                	ld	s3,40(sp)
    80000b10:	7a02                	ld	s4,32(sp)
    80000b12:	6ae2                	ld	s5,24(sp)
    80000b14:	6b42                	ld	s6,16(sp)
    80000b16:	6ba2                	ld	s7,8(sp)
    80000b18:	6161                	addi	sp,sp,80
    80000b1a:	8082                	ret
  return 0;
    80000b1c:	4501                	li	a0,0
}
    80000b1e:	8082                	ret

0000000080000b20 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000b20:	1141                	addi	sp,sp,-16
    80000b22:	e406                	sd	ra,8(sp)
    80000b24:	e022                	sd	s0,0(sp)
    80000b26:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000b28:	4601                	li	a2,0
    80000b2a:	00000097          	auipc	ra,0x0
    80000b2e:	97a080e7          	jalr	-1670(ra) # 800004a4 <walk>
  if(pte == 0)
    80000b32:	c901                	beqz	a0,80000b42 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b34:	611c                	ld	a5,0(a0)
    80000b36:	9bbd                	andi	a5,a5,-17
    80000b38:	e11c                	sd	a5,0(a0)
}
    80000b3a:	60a2                	ld	ra,8(sp)
    80000b3c:	6402                	ld	s0,0(sp)
    80000b3e:	0141                	addi	sp,sp,16
    80000b40:	8082                	ret
    panic("uvmclear");
    80000b42:	00007517          	auipc	a0,0x7
    80000b46:	60650513          	addi	a0,a0,1542 # 80008148 <etext+0x148>
    80000b4a:	00005097          	auipc	ra,0x5
    80000b4e:	116080e7          	jalr	278(ra) # 80005c60 <panic>

0000000080000b52 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b52:	c6bd                	beqz	a3,80000bc0 <copyout+0x6e>
{
    80000b54:	715d                	addi	sp,sp,-80
    80000b56:	e486                	sd	ra,72(sp)
    80000b58:	e0a2                	sd	s0,64(sp)
    80000b5a:	fc26                	sd	s1,56(sp)
    80000b5c:	f84a                	sd	s2,48(sp)
    80000b5e:	f44e                	sd	s3,40(sp)
    80000b60:	f052                	sd	s4,32(sp)
    80000b62:	ec56                	sd	s5,24(sp)
    80000b64:	e85a                	sd	s6,16(sp)
    80000b66:	e45e                	sd	s7,8(sp)
    80000b68:	e062                	sd	s8,0(sp)
    80000b6a:	0880                	addi	s0,sp,80
    80000b6c:	8b2a                	mv	s6,a0
    80000b6e:	8c2e                	mv	s8,a1
    80000b70:	8a32                	mv	s4,a2
    80000b72:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b74:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b76:	6a85                	lui	s5,0x1
    80000b78:	a015                	j	80000b9c <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b7a:	9562                	add	a0,a0,s8
    80000b7c:	0004861b          	sext.w	a2,s1
    80000b80:	85d2                	mv	a1,s4
    80000b82:	41250533          	sub	a0,a0,s2
    80000b86:	fffff097          	auipc	ra,0xfffff
    80000b8a:	69a080e7          	jalr	1690(ra) # 80000220 <memmove>

    len -= n;
    80000b8e:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b92:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b94:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b98:	02098263          	beqz	s3,80000bbc <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b9c:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000ba0:	85ca                	mv	a1,s2
    80000ba2:	855a                	mv	a0,s6
    80000ba4:	00000097          	auipc	ra,0x0
    80000ba8:	9a6080e7          	jalr	-1626(ra) # 8000054a <walkaddr>
    if(pa0 == 0)
    80000bac:	cd01                	beqz	a0,80000bc4 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000bae:	418904b3          	sub	s1,s2,s8
    80000bb2:	94d6                	add	s1,s1,s5
    80000bb4:	fc99f3e3          	bgeu	s3,s1,80000b7a <copyout+0x28>
    80000bb8:	84ce                	mv	s1,s3
    80000bba:	b7c1                	j	80000b7a <copyout+0x28>
  }
  return 0;
    80000bbc:	4501                	li	a0,0
    80000bbe:	a021                	j	80000bc6 <copyout+0x74>
    80000bc0:	4501                	li	a0,0
}
    80000bc2:	8082                	ret
      return -1;
    80000bc4:	557d                	li	a0,-1
}
    80000bc6:	60a6                	ld	ra,72(sp)
    80000bc8:	6406                	ld	s0,64(sp)
    80000bca:	74e2                	ld	s1,56(sp)
    80000bcc:	7942                	ld	s2,48(sp)
    80000bce:	79a2                	ld	s3,40(sp)
    80000bd0:	7a02                	ld	s4,32(sp)
    80000bd2:	6ae2                	ld	s5,24(sp)
    80000bd4:	6b42                	ld	s6,16(sp)
    80000bd6:	6ba2                	ld	s7,8(sp)
    80000bd8:	6c02                	ld	s8,0(sp)
    80000bda:	6161                	addi	sp,sp,80
    80000bdc:	8082                	ret

0000000080000bde <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000bde:	caa5                	beqz	a3,80000c4e <copyin+0x70>
{
    80000be0:	715d                	addi	sp,sp,-80
    80000be2:	e486                	sd	ra,72(sp)
    80000be4:	e0a2                	sd	s0,64(sp)
    80000be6:	fc26                	sd	s1,56(sp)
    80000be8:	f84a                	sd	s2,48(sp)
    80000bea:	f44e                	sd	s3,40(sp)
    80000bec:	f052                	sd	s4,32(sp)
    80000bee:	ec56                	sd	s5,24(sp)
    80000bf0:	e85a                	sd	s6,16(sp)
    80000bf2:	e45e                	sd	s7,8(sp)
    80000bf4:	e062                	sd	s8,0(sp)
    80000bf6:	0880                	addi	s0,sp,80
    80000bf8:	8b2a                	mv	s6,a0
    80000bfa:	8a2e                	mv	s4,a1
    80000bfc:	8c32                	mv	s8,a2
    80000bfe:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000c00:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c02:	6a85                	lui	s5,0x1
    80000c04:	a01d                	j	80000c2a <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c06:	018505b3          	add	a1,a0,s8
    80000c0a:	0004861b          	sext.w	a2,s1
    80000c0e:	412585b3          	sub	a1,a1,s2
    80000c12:	8552                	mv	a0,s4
    80000c14:	fffff097          	auipc	ra,0xfffff
    80000c18:	60c080e7          	jalr	1548(ra) # 80000220 <memmove>

    len -= n;
    80000c1c:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000c20:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000c22:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c26:	02098263          	beqz	s3,80000c4a <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000c2a:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c2e:	85ca                	mv	a1,s2
    80000c30:	855a                	mv	a0,s6
    80000c32:	00000097          	auipc	ra,0x0
    80000c36:	918080e7          	jalr	-1768(ra) # 8000054a <walkaddr>
    if(pa0 == 0)
    80000c3a:	cd01                	beqz	a0,80000c52 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000c3c:	418904b3          	sub	s1,s2,s8
    80000c40:	94d6                	add	s1,s1,s5
    80000c42:	fc99f2e3          	bgeu	s3,s1,80000c06 <copyin+0x28>
    80000c46:	84ce                	mv	s1,s3
    80000c48:	bf7d                	j	80000c06 <copyin+0x28>
  }
  return 0;
    80000c4a:	4501                	li	a0,0
    80000c4c:	a021                	j	80000c54 <copyin+0x76>
    80000c4e:	4501                	li	a0,0
}
    80000c50:	8082                	ret
      return -1;
    80000c52:	557d                	li	a0,-1
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
    80000c66:	6c02                	ld	s8,0(sp)
    80000c68:	6161                	addi	sp,sp,80
    80000c6a:	8082                	ret

0000000080000c6c <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c6c:	c2dd                	beqz	a3,80000d12 <copyinstr+0xa6>
{
    80000c6e:	715d                	addi	sp,sp,-80
    80000c70:	e486                	sd	ra,72(sp)
    80000c72:	e0a2                	sd	s0,64(sp)
    80000c74:	fc26                	sd	s1,56(sp)
    80000c76:	f84a                	sd	s2,48(sp)
    80000c78:	f44e                	sd	s3,40(sp)
    80000c7a:	f052                	sd	s4,32(sp)
    80000c7c:	ec56                	sd	s5,24(sp)
    80000c7e:	e85a                	sd	s6,16(sp)
    80000c80:	e45e                	sd	s7,8(sp)
    80000c82:	0880                	addi	s0,sp,80
    80000c84:	8a2a                	mv	s4,a0
    80000c86:	8b2e                	mv	s6,a1
    80000c88:	8bb2                	mv	s7,a2
    80000c8a:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c8c:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c8e:	6985                	lui	s3,0x1
    80000c90:	a02d                	j	80000cba <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c92:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c96:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c98:	37fd                	addiw	a5,a5,-1
    80000c9a:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c9e:	60a6                	ld	ra,72(sp)
    80000ca0:	6406                	ld	s0,64(sp)
    80000ca2:	74e2                	ld	s1,56(sp)
    80000ca4:	7942                	ld	s2,48(sp)
    80000ca6:	79a2                	ld	s3,40(sp)
    80000ca8:	7a02                	ld	s4,32(sp)
    80000caa:	6ae2                	ld	s5,24(sp)
    80000cac:	6b42                	ld	s6,16(sp)
    80000cae:	6ba2                	ld	s7,8(sp)
    80000cb0:	6161                	addi	sp,sp,80
    80000cb2:	8082                	ret
    srcva = va0 + PGSIZE;
    80000cb4:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000cb8:	c8a9                	beqz	s1,80000d0a <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80000cba:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000cbe:	85ca                	mv	a1,s2
    80000cc0:	8552                	mv	a0,s4
    80000cc2:	00000097          	auipc	ra,0x0
    80000cc6:	888080e7          	jalr	-1912(ra) # 8000054a <walkaddr>
    if(pa0 == 0)
    80000cca:	c131                	beqz	a0,80000d0e <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000ccc:	417906b3          	sub	a3,s2,s7
    80000cd0:	96ce                	add	a3,a3,s3
    80000cd2:	00d4f363          	bgeu	s1,a3,80000cd8 <copyinstr+0x6c>
    80000cd6:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000cd8:	955e                	add	a0,a0,s7
    80000cda:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000cde:	daf9                	beqz	a3,80000cb4 <copyinstr+0x48>
    80000ce0:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000ce2:	41650633          	sub	a2,a0,s6
    80000ce6:	fff48593          	addi	a1,s1,-1
    80000cea:	95da                	add	a1,a1,s6
    while(n > 0){
    80000cec:	96da                	add	a3,a3,s6
      if(*p == '\0'){
    80000cee:	00f60733          	add	a4,a2,a5
    80000cf2:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd8dc0>
    80000cf6:	df51                	beqz	a4,80000c92 <copyinstr+0x26>
        *dst = *p;
    80000cf8:	00e78023          	sb	a4,0(a5)
      --max;
    80000cfc:	40f584b3          	sub	s1,a1,a5
      dst++;
    80000d00:	0785                	addi	a5,a5,1
    while(n > 0){
    80000d02:	fed796e3          	bne	a5,a3,80000cee <copyinstr+0x82>
      dst++;
    80000d06:	8b3e                	mv	s6,a5
    80000d08:	b775                	j	80000cb4 <copyinstr+0x48>
    80000d0a:	4781                	li	a5,0
    80000d0c:	b771                	j	80000c98 <copyinstr+0x2c>
      return -1;
    80000d0e:	557d                	li	a0,-1
    80000d10:	b779                	j	80000c9e <copyinstr+0x32>
  int got_null = 0;
    80000d12:	4781                	li	a5,0
  if(got_null){
    80000d14:	37fd                	addiw	a5,a5,-1
    80000d16:	0007851b          	sext.w	a0,a5
}
    80000d1a:	8082                	ret

0000000080000d1c <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000d1c:	7139                	addi	sp,sp,-64
    80000d1e:	fc06                	sd	ra,56(sp)
    80000d20:	f822                	sd	s0,48(sp)
    80000d22:	f426                	sd	s1,40(sp)
    80000d24:	f04a                	sd	s2,32(sp)
    80000d26:	ec4e                	sd	s3,24(sp)
    80000d28:	e852                	sd	s4,16(sp)
    80000d2a:	e456                	sd	s5,8(sp)
    80000d2c:	e05a                	sd	s6,0(sp)
    80000d2e:	0080                	addi	s0,sp,64
    80000d30:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d32:	00008497          	auipc	s1,0x8
    80000d36:	74e48493          	addi	s1,s1,1870 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d3a:	8b26                	mv	s6,s1
    80000d3c:	00007a97          	auipc	s5,0x7
    80000d40:	2c4a8a93          	addi	s5,s5,708 # 80008000 <etext>
    80000d44:	04000937          	lui	s2,0x4000
    80000d48:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000d4a:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d4c:	0000ea17          	auipc	s4,0xe
    80000d50:	334a0a13          	addi	s4,s4,820 # 8000f080 <tickslock>
    char *pa = kalloc();
    80000d54:	fffff097          	auipc	ra,0xfffff
    80000d58:	3c6080e7          	jalr	966(ra) # 8000011a <kalloc>
    80000d5c:	862a                	mv	a2,a0
    if(pa == 0)
    80000d5e:	c131                	beqz	a0,80000da2 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d60:	416485b3          	sub	a1,s1,s6
    80000d64:	8591                	srai	a1,a1,0x4
    80000d66:	000ab783          	ld	a5,0(s5)
    80000d6a:	02f585b3          	mul	a1,a1,a5
    80000d6e:	2585                	addiw	a1,a1,1
    80000d70:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d74:	4719                	li	a4,6
    80000d76:	6685                	lui	a3,0x1
    80000d78:	40b905b3          	sub	a1,s2,a1
    80000d7c:	854e                	mv	a0,s3
    80000d7e:	00000097          	auipc	ra,0x0
    80000d82:	8ae080e7          	jalr	-1874(ra) # 8000062c <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d86:	17048493          	addi	s1,s1,368
    80000d8a:	fd4495e3          	bne	s1,s4,80000d54 <proc_mapstacks+0x38>
  }
}
    80000d8e:	70e2                	ld	ra,56(sp)
    80000d90:	7442                	ld	s0,48(sp)
    80000d92:	74a2                	ld	s1,40(sp)
    80000d94:	7902                	ld	s2,32(sp)
    80000d96:	69e2                	ld	s3,24(sp)
    80000d98:	6a42                	ld	s4,16(sp)
    80000d9a:	6aa2                	ld	s5,8(sp)
    80000d9c:	6b02                	ld	s6,0(sp)
    80000d9e:	6121                	addi	sp,sp,64
    80000da0:	8082                	ret
      panic("kalloc");
    80000da2:	00007517          	auipc	a0,0x7
    80000da6:	3b650513          	addi	a0,a0,950 # 80008158 <etext+0x158>
    80000daa:	00005097          	auipc	ra,0x5
    80000dae:	eb6080e7          	jalr	-330(ra) # 80005c60 <panic>

0000000080000db2 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000db2:	7139                	addi	sp,sp,-64
    80000db4:	fc06                	sd	ra,56(sp)
    80000db6:	f822                	sd	s0,48(sp)
    80000db8:	f426                	sd	s1,40(sp)
    80000dba:	f04a                	sd	s2,32(sp)
    80000dbc:	ec4e                	sd	s3,24(sp)
    80000dbe:	e852                	sd	s4,16(sp)
    80000dc0:	e456                	sd	s5,8(sp)
    80000dc2:	e05a                	sd	s6,0(sp)
    80000dc4:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000dc6:	00007597          	auipc	a1,0x7
    80000dca:	39a58593          	addi	a1,a1,922 # 80008160 <etext+0x160>
    80000dce:	00008517          	auipc	a0,0x8
    80000dd2:	28250513          	addi	a0,a0,642 # 80009050 <pid_lock>
    80000dd6:	00005097          	auipc	ra,0x5
    80000dda:	332080e7          	jalr	818(ra) # 80006108 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000dde:	00007597          	auipc	a1,0x7
    80000de2:	38a58593          	addi	a1,a1,906 # 80008168 <etext+0x168>
    80000de6:	00008517          	auipc	a0,0x8
    80000dea:	28250513          	addi	a0,a0,642 # 80009068 <wait_lock>
    80000dee:	00005097          	auipc	ra,0x5
    80000df2:	31a080e7          	jalr	794(ra) # 80006108 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000df6:	00008497          	auipc	s1,0x8
    80000dfa:	68a48493          	addi	s1,s1,1674 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000dfe:	00007b17          	auipc	s6,0x7
    80000e02:	37ab0b13          	addi	s6,s6,890 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000e06:	8aa6                	mv	s5,s1
    80000e08:	00007a17          	auipc	s4,0x7
    80000e0c:	1f8a0a13          	addi	s4,s4,504 # 80008000 <etext>
    80000e10:	04000937          	lui	s2,0x4000
    80000e14:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000e16:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e18:	0000e997          	auipc	s3,0xe
    80000e1c:	26898993          	addi	s3,s3,616 # 8000f080 <tickslock>
      initlock(&p->lock, "proc");
    80000e20:	85da                	mv	a1,s6
    80000e22:	8526                	mv	a0,s1
    80000e24:	00005097          	auipc	ra,0x5
    80000e28:	2e4080e7          	jalr	740(ra) # 80006108 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000e2c:	415487b3          	sub	a5,s1,s5
    80000e30:	8791                	srai	a5,a5,0x4
    80000e32:	000a3703          	ld	a4,0(s4)
    80000e36:	02e787b3          	mul	a5,a5,a4
    80000e3a:	2785                	addiw	a5,a5,1
    80000e3c:	00d7979b          	slliw	a5,a5,0xd
    80000e40:	40f907b3          	sub	a5,s2,a5
    80000e44:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e46:	17048493          	addi	s1,s1,368
    80000e4a:	fd349be3          	bne	s1,s3,80000e20 <procinit+0x6e>
  }
}
    80000e4e:	70e2                	ld	ra,56(sp)
    80000e50:	7442                	ld	s0,48(sp)
    80000e52:	74a2                	ld	s1,40(sp)
    80000e54:	7902                	ld	s2,32(sp)
    80000e56:	69e2                	ld	s3,24(sp)
    80000e58:	6a42                	ld	s4,16(sp)
    80000e5a:	6aa2                	ld	s5,8(sp)
    80000e5c:	6b02                	ld	s6,0(sp)
    80000e5e:	6121                	addi	sp,sp,64
    80000e60:	8082                	ret

0000000080000e62 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e62:	1141                	addi	sp,sp,-16
    80000e64:	e422                	sd	s0,8(sp)
    80000e66:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e68:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e6a:	2501                	sext.w	a0,a0
    80000e6c:	6422                	ld	s0,8(sp)
    80000e6e:	0141                	addi	sp,sp,16
    80000e70:	8082                	ret

0000000080000e72 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e72:	1141                	addi	sp,sp,-16
    80000e74:	e422                	sd	s0,8(sp)
    80000e76:	0800                	addi	s0,sp,16
    80000e78:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e7a:	2781                	sext.w	a5,a5
    80000e7c:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e7e:	00008517          	auipc	a0,0x8
    80000e82:	20250513          	addi	a0,a0,514 # 80009080 <cpus>
    80000e86:	953e                	add	a0,a0,a5
    80000e88:	6422                	ld	s0,8(sp)
    80000e8a:	0141                	addi	sp,sp,16
    80000e8c:	8082                	ret

0000000080000e8e <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000e8e:	1101                	addi	sp,sp,-32
    80000e90:	ec06                	sd	ra,24(sp)
    80000e92:	e822                	sd	s0,16(sp)
    80000e94:	e426                	sd	s1,8(sp)
    80000e96:	1000                	addi	s0,sp,32
  push_off();
    80000e98:	00005097          	auipc	ra,0x5
    80000e9c:	2b4080e7          	jalr	692(ra) # 8000614c <push_off>
    80000ea0:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000ea2:	2781                	sext.w	a5,a5
    80000ea4:	079e                	slli	a5,a5,0x7
    80000ea6:	00008717          	auipc	a4,0x8
    80000eaa:	1aa70713          	addi	a4,a4,426 # 80009050 <pid_lock>
    80000eae:	97ba                	add	a5,a5,a4
    80000eb0:	7b84                	ld	s1,48(a5)
  pop_off();
    80000eb2:	00005097          	auipc	ra,0x5
    80000eb6:	33a080e7          	jalr	826(ra) # 800061ec <pop_off>
  return p;
}
    80000eba:	8526                	mv	a0,s1
    80000ebc:	60e2                	ld	ra,24(sp)
    80000ebe:	6442                	ld	s0,16(sp)
    80000ec0:	64a2                	ld	s1,8(sp)
    80000ec2:	6105                	addi	sp,sp,32
    80000ec4:	8082                	ret

0000000080000ec6 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000ec6:	1141                	addi	sp,sp,-16
    80000ec8:	e406                	sd	ra,8(sp)
    80000eca:	e022                	sd	s0,0(sp)
    80000ecc:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000ece:	00000097          	auipc	ra,0x0
    80000ed2:	fc0080e7          	jalr	-64(ra) # 80000e8e <myproc>
    80000ed6:	00005097          	auipc	ra,0x5
    80000eda:	376080e7          	jalr	886(ra) # 8000624c <release>

  if (first) {
    80000ede:	00008797          	auipc	a5,0x8
    80000ee2:	ac27a783          	lw	a5,-1342(a5) # 800089a0 <first.1>
    80000ee6:	eb89                	bnez	a5,80000ef8 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000ee8:	00001097          	auipc	ra,0x1
    80000eec:	c74080e7          	jalr	-908(ra) # 80001b5c <usertrapret>
}
    80000ef0:	60a2                	ld	ra,8(sp)
    80000ef2:	6402                	ld	s0,0(sp)
    80000ef4:	0141                	addi	sp,sp,16
    80000ef6:	8082                	ret
    first = 0;
    80000ef8:	00008797          	auipc	a5,0x8
    80000efc:	aa07a423          	sw	zero,-1368(a5) # 800089a0 <first.1>
    fsinit(ROOTDEV);
    80000f00:	4505                	li	a0,1
    80000f02:	00002097          	auipc	ra,0x2
    80000f06:	a6e080e7          	jalr	-1426(ra) # 80002970 <fsinit>
    80000f0a:	bff9                	j	80000ee8 <forkret+0x22>

0000000080000f0c <allocpid>:
allocpid() {
    80000f0c:	1101                	addi	sp,sp,-32
    80000f0e:	ec06                	sd	ra,24(sp)
    80000f10:	e822                	sd	s0,16(sp)
    80000f12:	e426                	sd	s1,8(sp)
    80000f14:	e04a                	sd	s2,0(sp)
    80000f16:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000f18:	00008917          	auipc	s2,0x8
    80000f1c:	13890913          	addi	s2,s2,312 # 80009050 <pid_lock>
    80000f20:	854a                	mv	a0,s2
    80000f22:	00005097          	auipc	ra,0x5
    80000f26:	276080e7          	jalr	630(ra) # 80006198 <acquire>
  pid = nextpid;
    80000f2a:	00008797          	auipc	a5,0x8
    80000f2e:	a7a78793          	addi	a5,a5,-1414 # 800089a4 <nextpid>
    80000f32:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f34:	0014871b          	addiw	a4,s1,1
    80000f38:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f3a:	854a                	mv	a0,s2
    80000f3c:	00005097          	auipc	ra,0x5
    80000f40:	310080e7          	jalr	784(ra) # 8000624c <release>
}
    80000f44:	8526                	mv	a0,s1
    80000f46:	60e2                	ld	ra,24(sp)
    80000f48:	6442                	ld	s0,16(sp)
    80000f4a:	64a2                	ld	s1,8(sp)
    80000f4c:	6902                	ld	s2,0(sp)
    80000f4e:	6105                	addi	sp,sp,32
    80000f50:	8082                	ret

0000000080000f52 <proc_pagetable>:
{
    80000f52:	1101                	addi	sp,sp,-32
    80000f54:	ec06                	sd	ra,24(sp)
    80000f56:	e822                	sd	s0,16(sp)
    80000f58:	e426                	sd	s1,8(sp)
    80000f5a:	e04a                	sd	s2,0(sp)
    80000f5c:	1000                	addi	s0,sp,32
    80000f5e:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f60:	00000097          	auipc	ra,0x0
    80000f64:	8b6080e7          	jalr	-1866(ra) # 80000816 <uvmcreate>
    80000f68:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f6a:	c121                	beqz	a0,80000faa <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f6c:	4729                	li	a4,10
    80000f6e:	00006697          	auipc	a3,0x6
    80000f72:	09268693          	addi	a3,a3,146 # 80007000 <_trampoline>
    80000f76:	6605                	lui	a2,0x1
    80000f78:	040005b7          	lui	a1,0x4000
    80000f7c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f7e:	05b2                	slli	a1,a1,0xc
    80000f80:	fffff097          	auipc	ra,0xfffff
    80000f84:	60c080e7          	jalr	1548(ra) # 8000058c <mappages>
    80000f88:	02054863          	bltz	a0,80000fb8 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f8c:	4719                	li	a4,6
    80000f8e:	05893683          	ld	a3,88(s2)
    80000f92:	6605                	lui	a2,0x1
    80000f94:	020005b7          	lui	a1,0x2000
    80000f98:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f9a:	05b6                	slli	a1,a1,0xd
    80000f9c:	8526                	mv	a0,s1
    80000f9e:	fffff097          	auipc	ra,0xfffff
    80000fa2:	5ee080e7          	jalr	1518(ra) # 8000058c <mappages>
    80000fa6:	02054163          	bltz	a0,80000fc8 <proc_pagetable+0x76>
}
    80000faa:	8526                	mv	a0,s1
    80000fac:	60e2                	ld	ra,24(sp)
    80000fae:	6442                	ld	s0,16(sp)
    80000fb0:	64a2                	ld	s1,8(sp)
    80000fb2:	6902                	ld	s2,0(sp)
    80000fb4:	6105                	addi	sp,sp,32
    80000fb6:	8082                	ret
    uvmfree(pagetable, 0);
    80000fb8:	4581                	li	a1,0
    80000fba:	8526                	mv	a0,s1
    80000fbc:	00000097          	auipc	ra,0x0
    80000fc0:	a58080e7          	jalr	-1448(ra) # 80000a14 <uvmfree>
    return 0;
    80000fc4:	4481                	li	s1,0
    80000fc6:	b7d5                	j	80000faa <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fc8:	4681                	li	a3,0
    80000fca:	4605                	li	a2,1
    80000fcc:	040005b7          	lui	a1,0x4000
    80000fd0:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fd2:	05b2                	slli	a1,a1,0xc
    80000fd4:	8526                	mv	a0,s1
    80000fd6:	fffff097          	auipc	ra,0xfffff
    80000fda:	77c080e7          	jalr	1916(ra) # 80000752 <uvmunmap>
    uvmfree(pagetable, 0);
    80000fde:	4581                	li	a1,0
    80000fe0:	8526                	mv	a0,s1
    80000fe2:	00000097          	auipc	ra,0x0
    80000fe6:	a32080e7          	jalr	-1486(ra) # 80000a14 <uvmfree>
    return 0;
    80000fea:	4481                	li	s1,0
    80000fec:	bf7d                	j	80000faa <proc_pagetable+0x58>

0000000080000fee <proc_freepagetable>:
{
    80000fee:	1101                	addi	sp,sp,-32
    80000ff0:	ec06                	sd	ra,24(sp)
    80000ff2:	e822                	sd	s0,16(sp)
    80000ff4:	e426                	sd	s1,8(sp)
    80000ff6:	e04a                	sd	s2,0(sp)
    80000ff8:	1000                	addi	s0,sp,32
    80000ffa:	84aa                	mv	s1,a0
    80000ffc:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000ffe:	4681                	li	a3,0
    80001000:	4605                	li	a2,1
    80001002:	040005b7          	lui	a1,0x4000
    80001006:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001008:	05b2                	slli	a1,a1,0xc
    8000100a:	fffff097          	auipc	ra,0xfffff
    8000100e:	748080e7          	jalr	1864(ra) # 80000752 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001012:	4681                	li	a3,0
    80001014:	4605                	li	a2,1
    80001016:	020005b7          	lui	a1,0x2000
    8000101a:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    8000101c:	05b6                	slli	a1,a1,0xd
    8000101e:	8526                	mv	a0,s1
    80001020:	fffff097          	auipc	ra,0xfffff
    80001024:	732080e7          	jalr	1842(ra) # 80000752 <uvmunmap>
  uvmfree(pagetable, sz);
    80001028:	85ca                	mv	a1,s2
    8000102a:	8526                	mv	a0,s1
    8000102c:	00000097          	auipc	ra,0x0
    80001030:	9e8080e7          	jalr	-1560(ra) # 80000a14 <uvmfree>
}
    80001034:	60e2                	ld	ra,24(sp)
    80001036:	6442                	ld	s0,16(sp)
    80001038:	64a2                	ld	s1,8(sp)
    8000103a:	6902                	ld	s2,0(sp)
    8000103c:	6105                	addi	sp,sp,32
    8000103e:	8082                	ret

0000000080001040 <freeproc>:
{
    80001040:	1101                	addi	sp,sp,-32
    80001042:	ec06                	sd	ra,24(sp)
    80001044:	e822                	sd	s0,16(sp)
    80001046:	e426                	sd	s1,8(sp)
    80001048:	1000                	addi	s0,sp,32
    8000104a:	84aa                	mv	s1,a0
  if(p->trapframe)
    8000104c:	6d28                	ld	a0,88(a0)
    8000104e:	c509                	beqz	a0,80001058 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001050:	fffff097          	auipc	ra,0xfffff
    80001054:	fcc080e7          	jalr	-52(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001058:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    8000105c:	68a8                	ld	a0,80(s1)
    8000105e:	c511                	beqz	a0,8000106a <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001060:	64ac                	ld	a1,72(s1)
    80001062:	00000097          	auipc	ra,0x0
    80001066:	f8c080e7          	jalr	-116(ra) # 80000fee <proc_freepagetable>
  p->pagetable = 0;
    8000106a:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    8000106e:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001072:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001076:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    8000107a:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    8000107e:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001082:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001086:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    8000108a:	0004ac23          	sw	zero,24(s1)
}
    8000108e:	60e2                	ld	ra,24(sp)
    80001090:	6442                	ld	s0,16(sp)
    80001092:	64a2                	ld	s1,8(sp)
    80001094:	6105                	addi	sp,sp,32
    80001096:	8082                	ret

0000000080001098 <allocproc>:
{
    80001098:	1101                	addi	sp,sp,-32
    8000109a:	ec06                	sd	ra,24(sp)
    8000109c:	e822                	sd	s0,16(sp)
    8000109e:	e426                	sd	s1,8(sp)
    800010a0:	e04a                	sd	s2,0(sp)
    800010a2:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800010a4:	00008497          	auipc	s1,0x8
    800010a8:	3dc48493          	addi	s1,s1,988 # 80009480 <proc>
    800010ac:	0000e917          	auipc	s2,0xe
    800010b0:	fd490913          	addi	s2,s2,-44 # 8000f080 <tickslock>
    acquire(&p->lock);
    800010b4:	8526                	mv	a0,s1
    800010b6:	00005097          	auipc	ra,0x5
    800010ba:	0e2080e7          	jalr	226(ra) # 80006198 <acquire>
    if(p->state == UNUSED) {
    800010be:	4c9c                	lw	a5,24(s1)
    800010c0:	cf81                	beqz	a5,800010d8 <allocproc+0x40>
      release(&p->lock);
    800010c2:	8526                	mv	a0,s1
    800010c4:	00005097          	auipc	ra,0x5
    800010c8:	188080e7          	jalr	392(ra) # 8000624c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800010cc:	17048493          	addi	s1,s1,368
    800010d0:	ff2492e3          	bne	s1,s2,800010b4 <allocproc+0x1c>
  return 0;
    800010d4:	4481                	li	s1,0
    800010d6:	a889                	j	80001128 <allocproc+0x90>
  p->pid = allocpid();
    800010d8:	00000097          	auipc	ra,0x0
    800010dc:	e34080e7          	jalr	-460(ra) # 80000f0c <allocpid>
    800010e0:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010e2:	4785                	li	a5,1
    800010e4:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010e6:	fffff097          	auipc	ra,0xfffff
    800010ea:	034080e7          	jalr	52(ra) # 8000011a <kalloc>
    800010ee:	892a                	mv	s2,a0
    800010f0:	eca8                	sd	a0,88(s1)
    800010f2:	c131                	beqz	a0,80001136 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800010f4:	8526                	mv	a0,s1
    800010f6:	00000097          	auipc	ra,0x0
    800010fa:	e5c080e7          	jalr	-420(ra) # 80000f52 <proc_pagetable>
    800010fe:	892a                	mv	s2,a0
    80001100:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001102:	c531                	beqz	a0,8000114e <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001104:	07000613          	li	a2,112
    80001108:	4581                	li	a1,0
    8000110a:	06048513          	addi	a0,s1,96
    8000110e:	fffff097          	auipc	ra,0xfffff
    80001112:	0b6080e7          	jalr	182(ra) # 800001c4 <memset>
  p->context.ra = (uint64)forkret;
    80001116:	00000797          	auipc	a5,0x0
    8000111a:	db078793          	addi	a5,a5,-592 # 80000ec6 <forkret>
    8000111e:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001120:	60bc                	ld	a5,64(s1)
    80001122:	6705                	lui	a4,0x1
    80001124:	97ba                	add	a5,a5,a4
    80001126:	f4bc                	sd	a5,104(s1)
}
    80001128:	8526                	mv	a0,s1
    8000112a:	60e2                	ld	ra,24(sp)
    8000112c:	6442                	ld	s0,16(sp)
    8000112e:	64a2                	ld	s1,8(sp)
    80001130:	6902                	ld	s2,0(sp)
    80001132:	6105                	addi	sp,sp,32
    80001134:	8082                	ret
    freeproc(p);
    80001136:	8526                	mv	a0,s1
    80001138:	00000097          	auipc	ra,0x0
    8000113c:	f08080e7          	jalr	-248(ra) # 80001040 <freeproc>
    release(&p->lock);
    80001140:	8526                	mv	a0,s1
    80001142:	00005097          	auipc	ra,0x5
    80001146:	10a080e7          	jalr	266(ra) # 8000624c <release>
    return 0;
    8000114a:	84ca                	mv	s1,s2
    8000114c:	bff1                	j	80001128 <allocproc+0x90>
    freeproc(p);
    8000114e:	8526                	mv	a0,s1
    80001150:	00000097          	auipc	ra,0x0
    80001154:	ef0080e7          	jalr	-272(ra) # 80001040 <freeproc>
    release(&p->lock);
    80001158:	8526                	mv	a0,s1
    8000115a:	00005097          	auipc	ra,0x5
    8000115e:	0f2080e7          	jalr	242(ra) # 8000624c <release>
    return 0;
    80001162:	84ca                	mv	s1,s2
    80001164:	b7d1                	j	80001128 <allocproc+0x90>

0000000080001166 <userinit>:
{
    80001166:	1101                	addi	sp,sp,-32
    80001168:	ec06                	sd	ra,24(sp)
    8000116a:	e822                	sd	s0,16(sp)
    8000116c:	e426                	sd	s1,8(sp)
    8000116e:	1000                	addi	s0,sp,32
  p = allocproc();
    80001170:	00000097          	auipc	ra,0x0
    80001174:	f28080e7          	jalr	-216(ra) # 80001098 <allocproc>
    80001178:	84aa                	mv	s1,a0
  initproc = p;
    8000117a:	00008797          	auipc	a5,0x8
    8000117e:	e8a7bb23          	sd	a0,-362(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001182:	03400613          	li	a2,52
    80001186:	00008597          	auipc	a1,0x8
    8000118a:	82a58593          	addi	a1,a1,-2006 # 800089b0 <initcode>
    8000118e:	6928                	ld	a0,80(a0)
    80001190:	fffff097          	auipc	ra,0xfffff
    80001194:	6b4080e7          	jalr	1716(ra) # 80000844 <uvminit>
  p->sz = PGSIZE;
    80001198:	6785                	lui	a5,0x1
    8000119a:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    8000119c:	6cb8                	ld	a4,88(s1)
    8000119e:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800011a2:	6cb8                	ld	a4,88(s1)
    800011a4:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800011a6:	4641                	li	a2,16
    800011a8:	00007597          	auipc	a1,0x7
    800011ac:	fd858593          	addi	a1,a1,-40 # 80008180 <etext+0x180>
    800011b0:	15848513          	addi	a0,s1,344
    800011b4:	fffff097          	auipc	ra,0xfffff
    800011b8:	15a080e7          	jalr	346(ra) # 8000030e <safestrcpy>
  p->cwd = namei("/");
    800011bc:	00007517          	auipc	a0,0x7
    800011c0:	fd450513          	addi	a0,a0,-44 # 80008190 <etext+0x190>
    800011c4:	00002097          	auipc	ra,0x2
    800011c8:	1e2080e7          	jalr	482(ra) # 800033a6 <namei>
    800011cc:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800011d0:	478d                	li	a5,3
    800011d2:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011d4:	8526                	mv	a0,s1
    800011d6:	00005097          	auipc	ra,0x5
    800011da:	076080e7          	jalr	118(ra) # 8000624c <release>
}
    800011de:	60e2                	ld	ra,24(sp)
    800011e0:	6442                	ld	s0,16(sp)
    800011e2:	64a2                	ld	s1,8(sp)
    800011e4:	6105                	addi	sp,sp,32
    800011e6:	8082                	ret

00000000800011e8 <growproc>:
{
    800011e8:	1101                	addi	sp,sp,-32
    800011ea:	ec06                	sd	ra,24(sp)
    800011ec:	e822                	sd	s0,16(sp)
    800011ee:	e426                	sd	s1,8(sp)
    800011f0:	e04a                	sd	s2,0(sp)
    800011f2:	1000                	addi	s0,sp,32
    800011f4:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800011f6:	00000097          	auipc	ra,0x0
    800011fa:	c98080e7          	jalr	-872(ra) # 80000e8e <myproc>
    800011fe:	892a                	mv	s2,a0
  sz = p->sz;
    80001200:	652c                	ld	a1,72(a0)
    80001202:	0005879b          	sext.w	a5,a1
  if(n > 0){
    80001206:	00904f63          	bgtz	s1,80001224 <growproc+0x3c>
  } else if(n < 0){
    8000120a:	0204cd63          	bltz	s1,80001244 <growproc+0x5c>
  p->sz = sz;
    8000120e:	1782                	slli	a5,a5,0x20
    80001210:	9381                	srli	a5,a5,0x20
    80001212:	04f93423          	sd	a5,72(s2)
  return 0;
    80001216:	4501                	li	a0,0
}
    80001218:	60e2                	ld	ra,24(sp)
    8000121a:	6442                	ld	s0,16(sp)
    8000121c:	64a2                	ld	s1,8(sp)
    8000121e:	6902                	ld	s2,0(sp)
    80001220:	6105                	addi	sp,sp,32
    80001222:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001224:	00f4863b          	addw	a2,s1,a5
    80001228:	1602                	slli	a2,a2,0x20
    8000122a:	9201                	srli	a2,a2,0x20
    8000122c:	1582                	slli	a1,a1,0x20
    8000122e:	9181                	srli	a1,a1,0x20
    80001230:	6928                	ld	a0,80(a0)
    80001232:	fffff097          	auipc	ra,0xfffff
    80001236:	6cc080e7          	jalr	1740(ra) # 800008fe <uvmalloc>
    8000123a:	0005079b          	sext.w	a5,a0
    8000123e:	fbe1                	bnez	a5,8000120e <growproc+0x26>
      return -1;
    80001240:	557d                	li	a0,-1
    80001242:	bfd9                	j	80001218 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001244:	00f4863b          	addw	a2,s1,a5
    80001248:	1602                	slli	a2,a2,0x20
    8000124a:	9201                	srli	a2,a2,0x20
    8000124c:	1582                	slli	a1,a1,0x20
    8000124e:	9181                	srli	a1,a1,0x20
    80001250:	6928                	ld	a0,80(a0)
    80001252:	fffff097          	auipc	ra,0xfffff
    80001256:	664080e7          	jalr	1636(ra) # 800008b6 <uvmdealloc>
    8000125a:	0005079b          	sext.w	a5,a0
    8000125e:	bf45                	j	8000120e <growproc+0x26>

0000000080001260 <fork>:
{
    80001260:	7139                	addi	sp,sp,-64
    80001262:	fc06                	sd	ra,56(sp)
    80001264:	f822                	sd	s0,48(sp)
    80001266:	f426                	sd	s1,40(sp)
    80001268:	f04a                	sd	s2,32(sp)
    8000126a:	ec4e                	sd	s3,24(sp)
    8000126c:	e852                	sd	s4,16(sp)
    8000126e:	e456                	sd	s5,8(sp)
    80001270:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001272:	00000097          	auipc	ra,0x0
    80001276:	c1c080e7          	jalr	-996(ra) # 80000e8e <myproc>
    8000127a:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    8000127c:	00000097          	auipc	ra,0x0
    80001280:	e1c080e7          	jalr	-484(ra) # 80001098 <allocproc>
    80001284:	12050263          	beqz	a0,800013a8 <fork+0x148>
    80001288:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000128a:	048ab603          	ld	a2,72(s5)
    8000128e:	692c                	ld	a1,80(a0)
    80001290:	050ab503          	ld	a0,80(s5)
    80001294:	fffff097          	auipc	ra,0xfffff
    80001298:	7ba080e7          	jalr	1978(ra) # 80000a4e <uvmcopy>
    8000129c:	04054e63          	bltz	a0,800012f8 <fork+0x98>
  np->sz = p->sz;
    800012a0:	048ab783          	ld	a5,72(s5)
    800012a4:	04f9b423          	sd	a5,72(s3)
  np->parent = p;
    800012a8:	0359bc23          	sd	s5,56(s3)
  np->trace_mask=p->trace_mask;
    800012ac:	168aa783          	lw	a5,360(s5)
    800012b0:	16f9a423          	sw	a5,360(s3)
  *(np->trapframe) = *(p->trapframe);
    800012b4:	058ab683          	ld	a3,88(s5)
    800012b8:	87b6                	mv	a5,a3
    800012ba:	0589b703          	ld	a4,88(s3)
    800012be:	12068693          	addi	a3,a3,288
    800012c2:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012c6:	6788                	ld	a0,8(a5)
    800012c8:	6b8c                	ld	a1,16(a5)
    800012ca:	6f90                	ld	a2,24(a5)
    800012cc:	01073023          	sd	a6,0(a4)
    800012d0:	e708                	sd	a0,8(a4)
    800012d2:	eb0c                	sd	a1,16(a4)
    800012d4:	ef10                	sd	a2,24(a4)
    800012d6:	02078793          	addi	a5,a5,32
    800012da:	02070713          	addi	a4,a4,32
    800012de:	fed792e3          	bne	a5,a3,800012c2 <fork+0x62>
  np->trapframe->a0 = 0;
    800012e2:	0589b783          	ld	a5,88(s3)
    800012e6:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800012ea:	0d0a8493          	addi	s1,s5,208
    800012ee:	0d098913          	addi	s2,s3,208
    800012f2:	150a8a13          	addi	s4,s5,336
    800012f6:	a00d                	j	80001318 <fork+0xb8>
    freeproc(np);
    800012f8:	854e                	mv	a0,s3
    800012fa:	00000097          	auipc	ra,0x0
    800012fe:	d46080e7          	jalr	-698(ra) # 80001040 <freeproc>
    release(&np->lock);
    80001302:	854e                	mv	a0,s3
    80001304:	00005097          	auipc	ra,0x5
    80001308:	f48080e7          	jalr	-184(ra) # 8000624c <release>
    return -1;
    8000130c:	597d                	li	s2,-1
    8000130e:	a059                	j	80001394 <fork+0x134>
  for(i = 0; i < NOFILE; i++)
    80001310:	04a1                	addi	s1,s1,8
    80001312:	0921                	addi	s2,s2,8
    80001314:	01448b63          	beq	s1,s4,8000132a <fork+0xca>
    if(p->ofile[i])
    80001318:	6088                	ld	a0,0(s1)
    8000131a:	d97d                	beqz	a0,80001310 <fork+0xb0>
      np->ofile[i] = filedup(p->ofile[i]);
    8000131c:	00002097          	auipc	ra,0x2
    80001320:	720080e7          	jalr	1824(ra) # 80003a3c <filedup>
    80001324:	00a93023          	sd	a0,0(s2)
    80001328:	b7e5                	j	80001310 <fork+0xb0>
  np->cwd = idup(p->cwd);
    8000132a:	150ab503          	ld	a0,336(s5)
    8000132e:	00002097          	auipc	ra,0x2
    80001332:	87e080e7          	jalr	-1922(ra) # 80002bac <idup>
    80001336:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000133a:	4641                	li	a2,16
    8000133c:	158a8593          	addi	a1,s5,344
    80001340:	15898513          	addi	a0,s3,344
    80001344:	fffff097          	auipc	ra,0xfffff
    80001348:	fca080e7          	jalr	-54(ra) # 8000030e <safestrcpy>
  pid = np->pid;
    8000134c:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    80001350:	854e                	mv	a0,s3
    80001352:	00005097          	auipc	ra,0x5
    80001356:	efa080e7          	jalr	-262(ra) # 8000624c <release>
  acquire(&wait_lock);
    8000135a:	00008497          	auipc	s1,0x8
    8000135e:	d0e48493          	addi	s1,s1,-754 # 80009068 <wait_lock>
    80001362:	8526                	mv	a0,s1
    80001364:	00005097          	auipc	ra,0x5
    80001368:	e34080e7          	jalr	-460(ra) # 80006198 <acquire>
  np->parent = p;
    8000136c:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    80001370:	8526                	mv	a0,s1
    80001372:	00005097          	auipc	ra,0x5
    80001376:	eda080e7          	jalr	-294(ra) # 8000624c <release>
  acquire(&np->lock);
    8000137a:	854e                	mv	a0,s3
    8000137c:	00005097          	auipc	ra,0x5
    80001380:	e1c080e7          	jalr	-484(ra) # 80006198 <acquire>
  np->state = RUNNABLE;
    80001384:	478d                	li	a5,3
    80001386:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    8000138a:	854e                	mv	a0,s3
    8000138c:	00005097          	auipc	ra,0x5
    80001390:	ec0080e7          	jalr	-320(ra) # 8000624c <release>
}
    80001394:	854a                	mv	a0,s2
    80001396:	70e2                	ld	ra,56(sp)
    80001398:	7442                	ld	s0,48(sp)
    8000139a:	74a2                	ld	s1,40(sp)
    8000139c:	7902                	ld	s2,32(sp)
    8000139e:	69e2                	ld	s3,24(sp)
    800013a0:	6a42                	ld	s4,16(sp)
    800013a2:	6aa2                	ld	s5,8(sp)
    800013a4:	6121                	addi	sp,sp,64
    800013a6:	8082                	ret
    return -1;
    800013a8:	597d                	li	s2,-1
    800013aa:	b7ed                	j	80001394 <fork+0x134>

00000000800013ac <scheduler>:
{
    800013ac:	7139                	addi	sp,sp,-64
    800013ae:	fc06                	sd	ra,56(sp)
    800013b0:	f822                	sd	s0,48(sp)
    800013b2:	f426                	sd	s1,40(sp)
    800013b4:	f04a                	sd	s2,32(sp)
    800013b6:	ec4e                	sd	s3,24(sp)
    800013b8:	e852                	sd	s4,16(sp)
    800013ba:	e456                	sd	s5,8(sp)
    800013bc:	e05a                	sd	s6,0(sp)
    800013be:	0080                	addi	s0,sp,64
    800013c0:	8792                	mv	a5,tp
  int id = r_tp();
    800013c2:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013c4:	00779a93          	slli	s5,a5,0x7
    800013c8:	00008717          	auipc	a4,0x8
    800013cc:	c8870713          	addi	a4,a4,-888 # 80009050 <pid_lock>
    800013d0:	9756                	add	a4,a4,s5
    800013d2:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013d6:	00008717          	auipc	a4,0x8
    800013da:	cb270713          	addi	a4,a4,-846 # 80009088 <cpus+0x8>
    800013de:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800013e0:	498d                	li	s3,3
        p->state = RUNNING;
    800013e2:	4b11                	li	s6,4
        c->proc = p;
    800013e4:	079e                	slli	a5,a5,0x7
    800013e6:	00008a17          	auipc	s4,0x8
    800013ea:	c6aa0a13          	addi	s4,s4,-918 # 80009050 <pid_lock>
    800013ee:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013f0:	0000e917          	auipc	s2,0xe
    800013f4:	c9090913          	addi	s2,s2,-880 # 8000f080 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013f8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013fc:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001400:	10079073          	csrw	sstatus,a5
    80001404:	00008497          	auipc	s1,0x8
    80001408:	07c48493          	addi	s1,s1,124 # 80009480 <proc>
    8000140c:	a811                	j	80001420 <scheduler+0x74>
      release(&p->lock);
    8000140e:	8526                	mv	a0,s1
    80001410:	00005097          	auipc	ra,0x5
    80001414:	e3c080e7          	jalr	-452(ra) # 8000624c <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001418:	17048493          	addi	s1,s1,368
    8000141c:	fd248ee3          	beq	s1,s2,800013f8 <scheduler+0x4c>
      acquire(&p->lock);
    80001420:	8526                	mv	a0,s1
    80001422:	00005097          	auipc	ra,0x5
    80001426:	d76080e7          	jalr	-650(ra) # 80006198 <acquire>
      if(p->state == RUNNABLE) {
    8000142a:	4c9c                	lw	a5,24(s1)
    8000142c:	ff3791e3          	bne	a5,s3,8000140e <scheduler+0x62>
        p->state = RUNNING;
    80001430:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001434:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001438:	06048593          	addi	a1,s1,96
    8000143c:	8556                	mv	a0,s5
    8000143e:	00000097          	auipc	ra,0x0
    80001442:	674080e7          	jalr	1652(ra) # 80001ab2 <swtch>
        c->proc = 0;
    80001446:	020a3823          	sd	zero,48(s4)
    8000144a:	b7d1                	j	8000140e <scheduler+0x62>

000000008000144c <sched>:
{
    8000144c:	7179                	addi	sp,sp,-48
    8000144e:	f406                	sd	ra,40(sp)
    80001450:	f022                	sd	s0,32(sp)
    80001452:	ec26                	sd	s1,24(sp)
    80001454:	e84a                	sd	s2,16(sp)
    80001456:	e44e                	sd	s3,8(sp)
    80001458:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000145a:	00000097          	auipc	ra,0x0
    8000145e:	a34080e7          	jalr	-1484(ra) # 80000e8e <myproc>
    80001462:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001464:	00005097          	auipc	ra,0x5
    80001468:	cba080e7          	jalr	-838(ra) # 8000611e <holding>
    8000146c:	c93d                	beqz	a0,800014e2 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000146e:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001470:	2781                	sext.w	a5,a5
    80001472:	079e                	slli	a5,a5,0x7
    80001474:	00008717          	auipc	a4,0x8
    80001478:	bdc70713          	addi	a4,a4,-1060 # 80009050 <pid_lock>
    8000147c:	97ba                	add	a5,a5,a4
    8000147e:	0a87a703          	lw	a4,168(a5)
    80001482:	4785                	li	a5,1
    80001484:	06f71763          	bne	a4,a5,800014f2 <sched+0xa6>
  if(p->state == RUNNING)
    80001488:	4c98                	lw	a4,24(s1)
    8000148a:	4791                	li	a5,4
    8000148c:	06f70b63          	beq	a4,a5,80001502 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001490:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001494:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001496:	efb5                	bnez	a5,80001512 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001498:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000149a:	00008917          	auipc	s2,0x8
    8000149e:	bb690913          	addi	s2,s2,-1098 # 80009050 <pid_lock>
    800014a2:	2781                	sext.w	a5,a5
    800014a4:	079e                	slli	a5,a5,0x7
    800014a6:	97ca                	add	a5,a5,s2
    800014a8:	0ac7a983          	lw	s3,172(a5)
    800014ac:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800014ae:	2781                	sext.w	a5,a5
    800014b0:	079e                	slli	a5,a5,0x7
    800014b2:	00008597          	auipc	a1,0x8
    800014b6:	bd658593          	addi	a1,a1,-1066 # 80009088 <cpus+0x8>
    800014ba:	95be                	add	a1,a1,a5
    800014bc:	06048513          	addi	a0,s1,96
    800014c0:	00000097          	auipc	ra,0x0
    800014c4:	5f2080e7          	jalr	1522(ra) # 80001ab2 <swtch>
    800014c8:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014ca:	2781                	sext.w	a5,a5
    800014cc:	079e                	slli	a5,a5,0x7
    800014ce:	993e                	add	s2,s2,a5
    800014d0:	0b392623          	sw	s3,172(s2)
}
    800014d4:	70a2                	ld	ra,40(sp)
    800014d6:	7402                	ld	s0,32(sp)
    800014d8:	64e2                	ld	s1,24(sp)
    800014da:	6942                	ld	s2,16(sp)
    800014dc:	69a2                	ld	s3,8(sp)
    800014de:	6145                	addi	sp,sp,48
    800014e0:	8082                	ret
    panic("sched p->lock");
    800014e2:	00007517          	auipc	a0,0x7
    800014e6:	cb650513          	addi	a0,a0,-842 # 80008198 <etext+0x198>
    800014ea:	00004097          	auipc	ra,0x4
    800014ee:	776080e7          	jalr	1910(ra) # 80005c60 <panic>
    panic("sched locks");
    800014f2:	00007517          	auipc	a0,0x7
    800014f6:	cb650513          	addi	a0,a0,-842 # 800081a8 <etext+0x1a8>
    800014fa:	00004097          	auipc	ra,0x4
    800014fe:	766080e7          	jalr	1894(ra) # 80005c60 <panic>
    panic("sched running");
    80001502:	00007517          	auipc	a0,0x7
    80001506:	cb650513          	addi	a0,a0,-842 # 800081b8 <etext+0x1b8>
    8000150a:	00004097          	auipc	ra,0x4
    8000150e:	756080e7          	jalr	1878(ra) # 80005c60 <panic>
    panic("sched interruptible");
    80001512:	00007517          	auipc	a0,0x7
    80001516:	cb650513          	addi	a0,a0,-842 # 800081c8 <etext+0x1c8>
    8000151a:	00004097          	auipc	ra,0x4
    8000151e:	746080e7          	jalr	1862(ra) # 80005c60 <panic>

0000000080001522 <yield>:
{
    80001522:	1101                	addi	sp,sp,-32
    80001524:	ec06                	sd	ra,24(sp)
    80001526:	e822                	sd	s0,16(sp)
    80001528:	e426                	sd	s1,8(sp)
    8000152a:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000152c:	00000097          	auipc	ra,0x0
    80001530:	962080e7          	jalr	-1694(ra) # 80000e8e <myproc>
    80001534:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001536:	00005097          	auipc	ra,0x5
    8000153a:	c62080e7          	jalr	-926(ra) # 80006198 <acquire>
  p->state = RUNNABLE;
    8000153e:	478d                	li	a5,3
    80001540:	cc9c                	sw	a5,24(s1)
  sched();
    80001542:	00000097          	auipc	ra,0x0
    80001546:	f0a080e7          	jalr	-246(ra) # 8000144c <sched>
  release(&p->lock);
    8000154a:	8526                	mv	a0,s1
    8000154c:	00005097          	auipc	ra,0x5
    80001550:	d00080e7          	jalr	-768(ra) # 8000624c <release>
}
    80001554:	60e2                	ld	ra,24(sp)
    80001556:	6442                	ld	s0,16(sp)
    80001558:	64a2                	ld	s1,8(sp)
    8000155a:	6105                	addi	sp,sp,32
    8000155c:	8082                	ret

000000008000155e <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000155e:	7179                	addi	sp,sp,-48
    80001560:	f406                	sd	ra,40(sp)
    80001562:	f022                	sd	s0,32(sp)
    80001564:	ec26                	sd	s1,24(sp)
    80001566:	e84a                	sd	s2,16(sp)
    80001568:	e44e                	sd	s3,8(sp)
    8000156a:	1800                	addi	s0,sp,48
    8000156c:	89aa                	mv	s3,a0
    8000156e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001570:	00000097          	auipc	ra,0x0
    80001574:	91e080e7          	jalr	-1762(ra) # 80000e8e <myproc>
    80001578:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000157a:	00005097          	auipc	ra,0x5
    8000157e:	c1e080e7          	jalr	-994(ra) # 80006198 <acquire>
  release(lk);
    80001582:	854a                	mv	a0,s2
    80001584:	00005097          	auipc	ra,0x5
    80001588:	cc8080e7          	jalr	-824(ra) # 8000624c <release>

  // Go to sleep.
  p->chan = chan;
    8000158c:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001590:	4789                	li	a5,2
    80001592:	cc9c                	sw	a5,24(s1)

  sched();
    80001594:	00000097          	auipc	ra,0x0
    80001598:	eb8080e7          	jalr	-328(ra) # 8000144c <sched>

  // Tidy up.
  p->chan = 0;
    8000159c:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800015a0:	8526                	mv	a0,s1
    800015a2:	00005097          	auipc	ra,0x5
    800015a6:	caa080e7          	jalr	-854(ra) # 8000624c <release>
  acquire(lk);
    800015aa:	854a                	mv	a0,s2
    800015ac:	00005097          	auipc	ra,0x5
    800015b0:	bec080e7          	jalr	-1044(ra) # 80006198 <acquire>
}
    800015b4:	70a2                	ld	ra,40(sp)
    800015b6:	7402                	ld	s0,32(sp)
    800015b8:	64e2                	ld	s1,24(sp)
    800015ba:	6942                	ld	s2,16(sp)
    800015bc:	69a2                	ld	s3,8(sp)
    800015be:	6145                	addi	sp,sp,48
    800015c0:	8082                	ret

00000000800015c2 <wait>:
{
    800015c2:	715d                	addi	sp,sp,-80
    800015c4:	e486                	sd	ra,72(sp)
    800015c6:	e0a2                	sd	s0,64(sp)
    800015c8:	fc26                	sd	s1,56(sp)
    800015ca:	f84a                	sd	s2,48(sp)
    800015cc:	f44e                	sd	s3,40(sp)
    800015ce:	f052                	sd	s4,32(sp)
    800015d0:	ec56                	sd	s5,24(sp)
    800015d2:	e85a                	sd	s6,16(sp)
    800015d4:	e45e                	sd	s7,8(sp)
    800015d6:	e062                	sd	s8,0(sp)
    800015d8:	0880                	addi	s0,sp,80
    800015da:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015dc:	00000097          	auipc	ra,0x0
    800015e0:	8b2080e7          	jalr	-1870(ra) # 80000e8e <myproc>
    800015e4:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015e6:	00008517          	auipc	a0,0x8
    800015ea:	a8250513          	addi	a0,a0,-1406 # 80009068 <wait_lock>
    800015ee:	00005097          	auipc	ra,0x5
    800015f2:	baa080e7          	jalr	-1110(ra) # 80006198 <acquire>
    havekids = 0;
    800015f6:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800015f8:	4a15                	li	s4,5
        havekids = 1;
    800015fa:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    800015fc:	0000e997          	auipc	s3,0xe
    80001600:	a8498993          	addi	s3,s3,-1404 # 8000f080 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001604:	00008c17          	auipc	s8,0x8
    80001608:	a64c0c13          	addi	s8,s8,-1436 # 80009068 <wait_lock>
    havekids = 0;
    8000160c:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    8000160e:	00008497          	auipc	s1,0x8
    80001612:	e7248493          	addi	s1,s1,-398 # 80009480 <proc>
    80001616:	a0bd                	j	80001684 <wait+0xc2>
          pid = np->pid;
    80001618:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    8000161c:	000b0e63          	beqz	s6,80001638 <wait+0x76>
    80001620:	4691                	li	a3,4
    80001622:	02c48613          	addi	a2,s1,44
    80001626:	85da                	mv	a1,s6
    80001628:	05093503          	ld	a0,80(s2)
    8000162c:	fffff097          	auipc	ra,0xfffff
    80001630:	526080e7          	jalr	1318(ra) # 80000b52 <copyout>
    80001634:	02054563          	bltz	a0,8000165e <wait+0x9c>
          freeproc(np);
    80001638:	8526                	mv	a0,s1
    8000163a:	00000097          	auipc	ra,0x0
    8000163e:	a06080e7          	jalr	-1530(ra) # 80001040 <freeproc>
          release(&np->lock);
    80001642:	8526                	mv	a0,s1
    80001644:	00005097          	auipc	ra,0x5
    80001648:	c08080e7          	jalr	-1016(ra) # 8000624c <release>
          release(&wait_lock);
    8000164c:	00008517          	auipc	a0,0x8
    80001650:	a1c50513          	addi	a0,a0,-1508 # 80009068 <wait_lock>
    80001654:	00005097          	auipc	ra,0x5
    80001658:	bf8080e7          	jalr	-1032(ra) # 8000624c <release>
          return pid;
    8000165c:	a09d                	j	800016c2 <wait+0x100>
            release(&np->lock);
    8000165e:	8526                	mv	a0,s1
    80001660:	00005097          	auipc	ra,0x5
    80001664:	bec080e7          	jalr	-1044(ra) # 8000624c <release>
            release(&wait_lock);
    80001668:	00008517          	auipc	a0,0x8
    8000166c:	a0050513          	addi	a0,a0,-1536 # 80009068 <wait_lock>
    80001670:	00005097          	auipc	ra,0x5
    80001674:	bdc080e7          	jalr	-1060(ra) # 8000624c <release>
            return -1;
    80001678:	59fd                	li	s3,-1
    8000167a:	a0a1                	j	800016c2 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    8000167c:	17048493          	addi	s1,s1,368
    80001680:	03348463          	beq	s1,s3,800016a8 <wait+0xe6>
      if(np->parent == p){
    80001684:	7c9c                	ld	a5,56(s1)
    80001686:	ff279be3          	bne	a5,s2,8000167c <wait+0xba>
        acquire(&np->lock);
    8000168a:	8526                	mv	a0,s1
    8000168c:	00005097          	auipc	ra,0x5
    80001690:	b0c080e7          	jalr	-1268(ra) # 80006198 <acquire>
        if(np->state == ZOMBIE){
    80001694:	4c9c                	lw	a5,24(s1)
    80001696:	f94781e3          	beq	a5,s4,80001618 <wait+0x56>
        release(&np->lock);
    8000169a:	8526                	mv	a0,s1
    8000169c:	00005097          	auipc	ra,0x5
    800016a0:	bb0080e7          	jalr	-1104(ra) # 8000624c <release>
        havekids = 1;
    800016a4:	8756                	mv	a4,s5
    800016a6:	bfd9                	j	8000167c <wait+0xba>
    if(!havekids || p->killed){
    800016a8:	c701                	beqz	a4,800016b0 <wait+0xee>
    800016aa:	02892783          	lw	a5,40(s2)
    800016ae:	c79d                	beqz	a5,800016dc <wait+0x11a>
      release(&wait_lock);
    800016b0:	00008517          	auipc	a0,0x8
    800016b4:	9b850513          	addi	a0,a0,-1608 # 80009068 <wait_lock>
    800016b8:	00005097          	auipc	ra,0x5
    800016bc:	b94080e7          	jalr	-1132(ra) # 8000624c <release>
      return -1;
    800016c0:	59fd                	li	s3,-1
}
    800016c2:	854e                	mv	a0,s3
    800016c4:	60a6                	ld	ra,72(sp)
    800016c6:	6406                	ld	s0,64(sp)
    800016c8:	74e2                	ld	s1,56(sp)
    800016ca:	7942                	ld	s2,48(sp)
    800016cc:	79a2                	ld	s3,40(sp)
    800016ce:	7a02                	ld	s4,32(sp)
    800016d0:	6ae2                	ld	s5,24(sp)
    800016d2:	6b42                	ld	s6,16(sp)
    800016d4:	6ba2                	ld	s7,8(sp)
    800016d6:	6c02                	ld	s8,0(sp)
    800016d8:	6161                	addi	sp,sp,80
    800016da:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016dc:	85e2                	mv	a1,s8
    800016de:	854a                	mv	a0,s2
    800016e0:	00000097          	auipc	ra,0x0
    800016e4:	e7e080e7          	jalr	-386(ra) # 8000155e <sleep>
    havekids = 0;
    800016e8:	b715                	j	8000160c <wait+0x4a>

00000000800016ea <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800016ea:	7139                	addi	sp,sp,-64
    800016ec:	fc06                	sd	ra,56(sp)
    800016ee:	f822                	sd	s0,48(sp)
    800016f0:	f426                	sd	s1,40(sp)
    800016f2:	f04a                	sd	s2,32(sp)
    800016f4:	ec4e                	sd	s3,24(sp)
    800016f6:	e852                	sd	s4,16(sp)
    800016f8:	e456                	sd	s5,8(sp)
    800016fa:	0080                	addi	s0,sp,64
    800016fc:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800016fe:	00008497          	auipc	s1,0x8
    80001702:	d8248493          	addi	s1,s1,-638 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001706:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001708:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000170a:	0000e917          	auipc	s2,0xe
    8000170e:	97690913          	addi	s2,s2,-1674 # 8000f080 <tickslock>
    80001712:	a811                	j	80001726 <wakeup+0x3c>
      }
      release(&p->lock);
    80001714:	8526                	mv	a0,s1
    80001716:	00005097          	auipc	ra,0x5
    8000171a:	b36080e7          	jalr	-1226(ra) # 8000624c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000171e:	17048493          	addi	s1,s1,368
    80001722:	03248663          	beq	s1,s2,8000174e <wakeup+0x64>
    if(p != myproc()){
    80001726:	fffff097          	auipc	ra,0xfffff
    8000172a:	768080e7          	jalr	1896(ra) # 80000e8e <myproc>
    8000172e:	fea488e3          	beq	s1,a0,8000171e <wakeup+0x34>
      acquire(&p->lock);
    80001732:	8526                	mv	a0,s1
    80001734:	00005097          	auipc	ra,0x5
    80001738:	a64080e7          	jalr	-1436(ra) # 80006198 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000173c:	4c9c                	lw	a5,24(s1)
    8000173e:	fd379be3          	bne	a5,s3,80001714 <wakeup+0x2a>
    80001742:	709c                	ld	a5,32(s1)
    80001744:	fd4798e3          	bne	a5,s4,80001714 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001748:	0154ac23          	sw	s5,24(s1)
    8000174c:	b7e1                	j	80001714 <wakeup+0x2a>
    }
  }
}
    8000174e:	70e2                	ld	ra,56(sp)
    80001750:	7442                	ld	s0,48(sp)
    80001752:	74a2                	ld	s1,40(sp)
    80001754:	7902                	ld	s2,32(sp)
    80001756:	69e2                	ld	s3,24(sp)
    80001758:	6a42                	ld	s4,16(sp)
    8000175a:	6aa2                	ld	s5,8(sp)
    8000175c:	6121                	addi	sp,sp,64
    8000175e:	8082                	ret

0000000080001760 <reparent>:
{
    80001760:	7179                	addi	sp,sp,-48
    80001762:	f406                	sd	ra,40(sp)
    80001764:	f022                	sd	s0,32(sp)
    80001766:	ec26                	sd	s1,24(sp)
    80001768:	e84a                	sd	s2,16(sp)
    8000176a:	e44e                	sd	s3,8(sp)
    8000176c:	e052                	sd	s4,0(sp)
    8000176e:	1800                	addi	s0,sp,48
    80001770:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001772:	00008497          	auipc	s1,0x8
    80001776:	d0e48493          	addi	s1,s1,-754 # 80009480 <proc>
      pp->parent = initproc;
    8000177a:	00008a17          	auipc	s4,0x8
    8000177e:	896a0a13          	addi	s4,s4,-1898 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001782:	0000e997          	auipc	s3,0xe
    80001786:	8fe98993          	addi	s3,s3,-1794 # 8000f080 <tickslock>
    8000178a:	a029                	j	80001794 <reparent+0x34>
    8000178c:	17048493          	addi	s1,s1,368
    80001790:	01348d63          	beq	s1,s3,800017aa <reparent+0x4a>
    if(pp->parent == p){
    80001794:	7c9c                	ld	a5,56(s1)
    80001796:	ff279be3          	bne	a5,s2,8000178c <reparent+0x2c>
      pp->parent = initproc;
    8000179a:	000a3503          	ld	a0,0(s4)
    8000179e:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800017a0:	00000097          	auipc	ra,0x0
    800017a4:	f4a080e7          	jalr	-182(ra) # 800016ea <wakeup>
    800017a8:	b7d5                	j	8000178c <reparent+0x2c>
}
    800017aa:	70a2                	ld	ra,40(sp)
    800017ac:	7402                	ld	s0,32(sp)
    800017ae:	64e2                	ld	s1,24(sp)
    800017b0:	6942                	ld	s2,16(sp)
    800017b2:	69a2                	ld	s3,8(sp)
    800017b4:	6a02                	ld	s4,0(sp)
    800017b6:	6145                	addi	sp,sp,48
    800017b8:	8082                	ret

00000000800017ba <exit>:
{
    800017ba:	7179                	addi	sp,sp,-48
    800017bc:	f406                	sd	ra,40(sp)
    800017be:	f022                	sd	s0,32(sp)
    800017c0:	ec26                	sd	s1,24(sp)
    800017c2:	e84a                	sd	s2,16(sp)
    800017c4:	e44e                	sd	s3,8(sp)
    800017c6:	e052                	sd	s4,0(sp)
    800017c8:	1800                	addi	s0,sp,48
    800017ca:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800017cc:	fffff097          	auipc	ra,0xfffff
    800017d0:	6c2080e7          	jalr	1730(ra) # 80000e8e <myproc>
    800017d4:	89aa                	mv	s3,a0
  if(p == initproc)
    800017d6:	00008797          	auipc	a5,0x8
    800017da:	83a7b783          	ld	a5,-1990(a5) # 80009010 <initproc>
    800017de:	0d050493          	addi	s1,a0,208
    800017e2:	15050913          	addi	s2,a0,336
    800017e6:	02a79363          	bne	a5,a0,8000180c <exit+0x52>
    panic("init exiting");
    800017ea:	00007517          	auipc	a0,0x7
    800017ee:	9f650513          	addi	a0,a0,-1546 # 800081e0 <etext+0x1e0>
    800017f2:	00004097          	auipc	ra,0x4
    800017f6:	46e080e7          	jalr	1134(ra) # 80005c60 <panic>
      fileclose(f);
    800017fa:	00002097          	auipc	ra,0x2
    800017fe:	294080e7          	jalr	660(ra) # 80003a8e <fileclose>
      p->ofile[fd] = 0;
    80001802:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001806:	04a1                	addi	s1,s1,8
    80001808:	01248563          	beq	s1,s2,80001812 <exit+0x58>
    if(p->ofile[fd]){
    8000180c:	6088                	ld	a0,0(s1)
    8000180e:	f575                	bnez	a0,800017fa <exit+0x40>
    80001810:	bfdd                	j	80001806 <exit+0x4c>
  begin_op();
    80001812:	00002097          	auipc	ra,0x2
    80001816:	db4080e7          	jalr	-588(ra) # 800035c6 <begin_op>
  iput(p->cwd);
    8000181a:	1509b503          	ld	a0,336(s3)
    8000181e:	00001097          	auipc	ra,0x1
    80001822:	586080e7          	jalr	1414(ra) # 80002da4 <iput>
  end_op();
    80001826:	00002097          	auipc	ra,0x2
    8000182a:	e1e080e7          	jalr	-482(ra) # 80003644 <end_op>
  p->cwd = 0;
    8000182e:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001832:	00008497          	auipc	s1,0x8
    80001836:	83648493          	addi	s1,s1,-1994 # 80009068 <wait_lock>
    8000183a:	8526                	mv	a0,s1
    8000183c:	00005097          	auipc	ra,0x5
    80001840:	95c080e7          	jalr	-1700(ra) # 80006198 <acquire>
  reparent(p);
    80001844:	854e                	mv	a0,s3
    80001846:	00000097          	auipc	ra,0x0
    8000184a:	f1a080e7          	jalr	-230(ra) # 80001760 <reparent>
  wakeup(p->parent);
    8000184e:	0389b503          	ld	a0,56(s3)
    80001852:	00000097          	auipc	ra,0x0
    80001856:	e98080e7          	jalr	-360(ra) # 800016ea <wakeup>
  acquire(&p->lock);
    8000185a:	854e                	mv	a0,s3
    8000185c:	00005097          	auipc	ra,0x5
    80001860:	93c080e7          	jalr	-1732(ra) # 80006198 <acquire>
  p->xstate = status;
    80001864:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001868:	4795                	li	a5,5
    8000186a:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000186e:	8526                	mv	a0,s1
    80001870:	00005097          	auipc	ra,0x5
    80001874:	9dc080e7          	jalr	-1572(ra) # 8000624c <release>
  sched();
    80001878:	00000097          	auipc	ra,0x0
    8000187c:	bd4080e7          	jalr	-1068(ra) # 8000144c <sched>
  panic("zombie exit");
    80001880:	00007517          	auipc	a0,0x7
    80001884:	97050513          	addi	a0,a0,-1680 # 800081f0 <etext+0x1f0>
    80001888:	00004097          	auipc	ra,0x4
    8000188c:	3d8080e7          	jalr	984(ra) # 80005c60 <panic>

0000000080001890 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001890:	7179                	addi	sp,sp,-48
    80001892:	f406                	sd	ra,40(sp)
    80001894:	f022                	sd	s0,32(sp)
    80001896:	ec26                	sd	s1,24(sp)
    80001898:	e84a                	sd	s2,16(sp)
    8000189a:	e44e                	sd	s3,8(sp)
    8000189c:	1800                	addi	s0,sp,48
    8000189e:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800018a0:	00008497          	auipc	s1,0x8
    800018a4:	be048493          	addi	s1,s1,-1056 # 80009480 <proc>
    800018a8:	0000d997          	auipc	s3,0xd
    800018ac:	7d898993          	addi	s3,s3,2008 # 8000f080 <tickslock>
    acquire(&p->lock);
    800018b0:	8526                	mv	a0,s1
    800018b2:	00005097          	auipc	ra,0x5
    800018b6:	8e6080e7          	jalr	-1818(ra) # 80006198 <acquire>
    if(p->pid == pid){
    800018ba:	589c                	lw	a5,48(s1)
    800018bc:	01278d63          	beq	a5,s2,800018d6 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800018c0:	8526                	mv	a0,s1
    800018c2:	00005097          	auipc	ra,0x5
    800018c6:	98a080e7          	jalr	-1654(ra) # 8000624c <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800018ca:	17048493          	addi	s1,s1,368
    800018ce:	ff3491e3          	bne	s1,s3,800018b0 <kill+0x20>
  }
  return -1;
    800018d2:	557d                	li	a0,-1
    800018d4:	a829                	j	800018ee <kill+0x5e>
      p->killed = 1;
    800018d6:	4785                	li	a5,1
    800018d8:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800018da:	4c98                	lw	a4,24(s1)
    800018dc:	4789                	li	a5,2
    800018de:	00f70f63          	beq	a4,a5,800018fc <kill+0x6c>
      release(&p->lock);
    800018e2:	8526                	mv	a0,s1
    800018e4:	00005097          	auipc	ra,0x5
    800018e8:	968080e7          	jalr	-1688(ra) # 8000624c <release>
      return 0;
    800018ec:	4501                	li	a0,0
}
    800018ee:	70a2                	ld	ra,40(sp)
    800018f0:	7402                	ld	s0,32(sp)
    800018f2:	64e2                	ld	s1,24(sp)
    800018f4:	6942                	ld	s2,16(sp)
    800018f6:	69a2                	ld	s3,8(sp)
    800018f8:	6145                	addi	sp,sp,48
    800018fa:	8082                	ret
        p->state = RUNNABLE;
    800018fc:	478d                	li	a5,3
    800018fe:	cc9c                	sw	a5,24(s1)
    80001900:	b7cd                	j	800018e2 <kill+0x52>

0000000080001902 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001902:	7179                	addi	sp,sp,-48
    80001904:	f406                	sd	ra,40(sp)
    80001906:	f022                	sd	s0,32(sp)
    80001908:	ec26                	sd	s1,24(sp)
    8000190a:	e84a                	sd	s2,16(sp)
    8000190c:	e44e                	sd	s3,8(sp)
    8000190e:	e052                	sd	s4,0(sp)
    80001910:	1800                	addi	s0,sp,48
    80001912:	84aa                	mv	s1,a0
    80001914:	892e                	mv	s2,a1
    80001916:	89b2                	mv	s3,a2
    80001918:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000191a:	fffff097          	auipc	ra,0xfffff
    8000191e:	574080e7          	jalr	1396(ra) # 80000e8e <myproc>
  if(user_dst){
    80001922:	c08d                	beqz	s1,80001944 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001924:	86d2                	mv	a3,s4
    80001926:	864e                	mv	a2,s3
    80001928:	85ca                	mv	a1,s2
    8000192a:	6928                	ld	a0,80(a0)
    8000192c:	fffff097          	auipc	ra,0xfffff
    80001930:	226080e7          	jalr	550(ra) # 80000b52 <copyout>
  } else {
    memmove((char *)dst, src, len);
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
    memmove((char *)dst, src, len);
    80001944:	000a061b          	sext.w	a2,s4
    80001948:	85ce                	mv	a1,s3
    8000194a:	854a                	mv	a0,s2
    8000194c:	fffff097          	auipc	ra,0xfffff
    80001950:	8d4080e7          	jalr	-1836(ra) # 80000220 <memmove>
    return 0;
    80001954:	8526                	mv	a0,s1
    80001956:	bff9                	j	80001934 <either_copyout+0x32>

0000000080001958 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001958:	7179                	addi	sp,sp,-48
    8000195a:	f406                	sd	ra,40(sp)
    8000195c:	f022                	sd	s0,32(sp)
    8000195e:	ec26                	sd	s1,24(sp)
    80001960:	e84a                	sd	s2,16(sp)
    80001962:	e44e                	sd	s3,8(sp)
    80001964:	e052                	sd	s4,0(sp)
    80001966:	1800                	addi	s0,sp,48
    80001968:	892a                	mv	s2,a0
    8000196a:	84ae                	mv	s1,a1
    8000196c:	89b2                	mv	s3,a2
    8000196e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001970:	fffff097          	auipc	ra,0xfffff
    80001974:	51e080e7          	jalr	1310(ra) # 80000e8e <myproc>
  if(user_src){
    80001978:	c08d                	beqz	s1,8000199a <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    8000197a:	86d2                	mv	a3,s4
    8000197c:	864e                	mv	a2,s3
    8000197e:	85ca                	mv	a1,s2
    80001980:	6928                	ld	a0,80(a0)
    80001982:	fffff097          	auipc	ra,0xfffff
    80001986:	25c080e7          	jalr	604(ra) # 80000bde <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    8000198a:	70a2                	ld	ra,40(sp)
    8000198c:	7402                	ld	s0,32(sp)
    8000198e:	64e2                	ld	s1,24(sp)
    80001990:	6942                	ld	s2,16(sp)
    80001992:	69a2                	ld	s3,8(sp)
    80001994:	6a02                	ld	s4,0(sp)
    80001996:	6145                	addi	sp,sp,48
    80001998:	8082                	ret
    memmove(dst, (char*)src, len);
    8000199a:	000a061b          	sext.w	a2,s4
    8000199e:	85ce                	mv	a1,s3
    800019a0:	854a                	mv	a0,s2
    800019a2:	fffff097          	auipc	ra,0xfffff
    800019a6:	87e080e7          	jalr	-1922(ra) # 80000220 <memmove>
    return 0;
    800019aa:	8526                	mv	a0,s1
    800019ac:	bff9                	j	8000198a <either_copyin+0x32>

00000000800019ae <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800019ae:	715d                	addi	sp,sp,-80
    800019b0:	e486                	sd	ra,72(sp)
    800019b2:	e0a2                	sd	s0,64(sp)
    800019b4:	fc26                	sd	s1,56(sp)
    800019b6:	f84a                	sd	s2,48(sp)
    800019b8:	f44e                	sd	s3,40(sp)
    800019ba:	f052                	sd	s4,32(sp)
    800019bc:	ec56                	sd	s5,24(sp)
    800019be:	e85a                	sd	s6,16(sp)
    800019c0:	e45e                	sd	s7,8(sp)
    800019c2:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800019c4:	00006517          	auipc	a0,0x6
    800019c8:	68450513          	addi	a0,a0,1668 # 80008048 <etext+0x48>
    800019cc:	00004097          	auipc	ra,0x4
    800019d0:	2de080e7          	jalr	734(ra) # 80005caa <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019d4:	00008497          	auipc	s1,0x8
    800019d8:	c0448493          	addi	s1,s1,-1020 # 800095d8 <proc+0x158>
    800019dc:	0000d917          	auipc	s2,0xd
    800019e0:	7fc90913          	addi	s2,s2,2044 # 8000f1d8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019e4:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800019e6:	00007997          	auipc	s3,0x7
    800019ea:	81a98993          	addi	s3,s3,-2022 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    800019ee:	00007a97          	auipc	s5,0x7
    800019f2:	81aa8a93          	addi	s5,s5,-2022 # 80008208 <etext+0x208>
    printf("\n");
    800019f6:	00006a17          	auipc	s4,0x6
    800019fa:	652a0a13          	addi	s4,s4,1618 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019fe:	00007b97          	auipc	s7,0x7
    80001a02:	842b8b93          	addi	s7,s7,-1982 # 80008240 <states.0>
    80001a06:	a00d                	j	80001a28 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a08:	ed86a583          	lw	a1,-296(a3)
    80001a0c:	8556                	mv	a0,s5
    80001a0e:	00004097          	auipc	ra,0x4
    80001a12:	29c080e7          	jalr	668(ra) # 80005caa <printf>
    printf("\n");
    80001a16:	8552                	mv	a0,s4
    80001a18:	00004097          	auipc	ra,0x4
    80001a1c:	292080e7          	jalr	658(ra) # 80005caa <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a20:	17048493          	addi	s1,s1,368
    80001a24:	03248263          	beq	s1,s2,80001a48 <procdump+0x9a>
    if(p->state == UNUSED)
    80001a28:	86a6                	mv	a3,s1
    80001a2a:	ec04a783          	lw	a5,-320(s1)
    80001a2e:	dbed                	beqz	a5,80001a20 <procdump+0x72>
      state = "???";
    80001a30:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a32:	fcfb6be3          	bltu	s6,a5,80001a08 <procdump+0x5a>
    80001a36:	02079713          	slli	a4,a5,0x20
    80001a3a:	01d75793          	srli	a5,a4,0x1d
    80001a3e:	97de                	add	a5,a5,s7
    80001a40:	6390                	ld	a2,0(a5)
    80001a42:	f279                	bnez	a2,80001a08 <procdump+0x5a>
      state = "???";
    80001a44:	864e                	mv	a2,s3
    80001a46:	b7c9                	j	80001a08 <procdump+0x5a>
  }
}
    80001a48:	60a6                	ld	ra,72(sp)
    80001a4a:	6406                	ld	s0,64(sp)
    80001a4c:	74e2                	ld	s1,56(sp)
    80001a4e:	7942                	ld	s2,48(sp)
    80001a50:	79a2                	ld	s3,40(sp)
    80001a52:	7a02                	ld	s4,32(sp)
    80001a54:	6ae2                	ld	s5,24(sp)
    80001a56:	6b42                	ld	s6,16(sp)
    80001a58:	6ba2                	ld	s7,8(sp)
    80001a5a:	6161                	addi	sp,sp,80
    80001a5c:	8082                	ret

0000000080001a5e <nproc>:

//返回非禁用的进程数
uint64
nproc(void)
{
    80001a5e:	7179                	addi	sp,sp,-48
    80001a60:	f406                	sd	ra,40(sp)
    80001a62:	f022                	sd	s0,32(sp)
    80001a64:	ec26                	sd	s1,24(sp)
    80001a66:	e84a                	sd	s2,16(sp)
    80001a68:	e44e                	sd	s3,8(sp)
    80001a6a:	1800                	addi	s0,sp,48
  struct proc *p;
  uint64 num = 0;
    80001a6c:	4901                	li	s2,0
  //遍历proc表，逐个确认state
  for (p = proc; p < &proc[NPROC]; p++)
    80001a6e:	00008497          	auipc	s1,0x8
    80001a72:	a1248493          	addi	s1,s1,-1518 # 80009480 <proc>
    80001a76:	0000d997          	auipc	s3,0xd
    80001a7a:	60a98993          	addi	s3,s3,1546 # 8000f080 <tickslock>
  {
    acquire(&p->lock);
    80001a7e:	8526                	mv	a0,s1
    80001a80:	00004097          	auipc	ra,0x4
    80001a84:	718080e7          	jalr	1816(ra) # 80006198 <acquire>
    if (p->state != UNUSED)
    80001a88:	4c9c                	lw	a5,24(s1)
      num++;
    80001a8a:	00f037b3          	snez	a5,a5
    80001a8e:	993e                	add	s2,s2,a5
    release(&p->lock);
    80001a90:	8526                	mv	a0,s1
    80001a92:	00004097          	auipc	ra,0x4
    80001a96:	7ba080e7          	jalr	1978(ra) # 8000624c <release>
  for (p = proc; p < &proc[NPROC]; p++)
    80001a9a:	17048493          	addi	s1,s1,368
    80001a9e:	ff3490e3          	bne	s1,s3,80001a7e <nproc+0x20>
  }
  return num;
    80001aa2:	854a                	mv	a0,s2
    80001aa4:	70a2                	ld	ra,40(sp)
    80001aa6:	7402                	ld	s0,32(sp)
    80001aa8:	64e2                	ld	s1,24(sp)
    80001aaa:	6942                	ld	s2,16(sp)
    80001aac:	69a2                	ld	s3,8(sp)
    80001aae:	6145                	addi	sp,sp,48
    80001ab0:	8082                	ret

0000000080001ab2 <swtch>:
    80001ab2:	00153023          	sd	ra,0(a0)
    80001ab6:	00253423          	sd	sp,8(a0)
    80001aba:	e900                	sd	s0,16(a0)
    80001abc:	ed04                	sd	s1,24(a0)
    80001abe:	03253023          	sd	s2,32(a0)
    80001ac2:	03353423          	sd	s3,40(a0)
    80001ac6:	03453823          	sd	s4,48(a0)
    80001aca:	03553c23          	sd	s5,56(a0)
    80001ace:	05653023          	sd	s6,64(a0)
    80001ad2:	05753423          	sd	s7,72(a0)
    80001ad6:	05853823          	sd	s8,80(a0)
    80001ada:	05953c23          	sd	s9,88(a0)
    80001ade:	07a53023          	sd	s10,96(a0)
    80001ae2:	07b53423          	sd	s11,104(a0)
    80001ae6:	0005b083          	ld	ra,0(a1)
    80001aea:	0085b103          	ld	sp,8(a1)
    80001aee:	6980                	ld	s0,16(a1)
    80001af0:	6d84                	ld	s1,24(a1)
    80001af2:	0205b903          	ld	s2,32(a1)
    80001af6:	0285b983          	ld	s3,40(a1)
    80001afa:	0305ba03          	ld	s4,48(a1)
    80001afe:	0385ba83          	ld	s5,56(a1)
    80001b02:	0405bb03          	ld	s6,64(a1)
    80001b06:	0485bb83          	ld	s7,72(a1)
    80001b0a:	0505bc03          	ld	s8,80(a1)
    80001b0e:	0585bc83          	ld	s9,88(a1)
    80001b12:	0605bd03          	ld	s10,96(a1)
    80001b16:	0685bd83          	ld	s11,104(a1)
    80001b1a:	8082                	ret

0000000080001b1c <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001b1c:	1141                	addi	sp,sp,-16
    80001b1e:	e406                	sd	ra,8(sp)
    80001b20:	e022                	sd	s0,0(sp)
    80001b22:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001b24:	00006597          	auipc	a1,0x6
    80001b28:	74c58593          	addi	a1,a1,1868 # 80008270 <states.0+0x30>
    80001b2c:	0000d517          	auipc	a0,0xd
    80001b30:	55450513          	addi	a0,a0,1364 # 8000f080 <tickslock>
    80001b34:	00004097          	auipc	ra,0x4
    80001b38:	5d4080e7          	jalr	1492(ra) # 80006108 <initlock>
}
    80001b3c:	60a2                	ld	ra,8(sp)
    80001b3e:	6402                	ld	s0,0(sp)
    80001b40:	0141                	addi	sp,sp,16
    80001b42:	8082                	ret

0000000080001b44 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001b44:	1141                	addi	sp,sp,-16
    80001b46:	e422                	sd	s0,8(sp)
    80001b48:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b4a:	00003797          	auipc	a5,0x3
    80001b4e:	57678793          	addi	a5,a5,1398 # 800050c0 <kernelvec>
    80001b52:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b56:	6422                	ld	s0,8(sp)
    80001b58:	0141                	addi	sp,sp,16
    80001b5a:	8082                	ret

0000000080001b5c <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b5c:	1141                	addi	sp,sp,-16
    80001b5e:	e406                	sd	ra,8(sp)
    80001b60:	e022                	sd	s0,0(sp)
    80001b62:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b64:	fffff097          	auipc	ra,0xfffff
    80001b68:	32a080e7          	jalr	810(ra) # 80000e8e <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b6c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b70:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b72:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001b76:	00005697          	auipc	a3,0x5
    80001b7a:	48a68693          	addi	a3,a3,1162 # 80007000 <_trampoline>
    80001b7e:	00005717          	auipc	a4,0x5
    80001b82:	48270713          	addi	a4,a4,1154 # 80007000 <_trampoline>
    80001b86:	8f15                	sub	a4,a4,a3
    80001b88:	040007b7          	lui	a5,0x4000
    80001b8c:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001b8e:	07b2                	slli	a5,a5,0xc
    80001b90:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b92:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b96:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b98:	18002673          	csrr	a2,satp
    80001b9c:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b9e:	6d30                	ld	a2,88(a0)
    80001ba0:	6138                	ld	a4,64(a0)
    80001ba2:	6585                	lui	a1,0x1
    80001ba4:	972e                	add	a4,a4,a1
    80001ba6:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001ba8:	6d38                	ld	a4,88(a0)
    80001baa:	00000617          	auipc	a2,0x0
    80001bae:	13860613          	addi	a2,a2,312 # 80001ce2 <usertrap>
    80001bb2:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001bb4:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001bb6:	8612                	mv	a2,tp
    80001bb8:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bba:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001bbe:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001bc2:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bc6:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001bca:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001bcc:	6f18                	ld	a4,24(a4)
    80001bce:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001bd2:	692c                	ld	a1,80(a0)
    80001bd4:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001bd6:	00005717          	auipc	a4,0x5
    80001bda:	4ba70713          	addi	a4,a4,1210 # 80007090 <userret>
    80001bde:	8f15                	sub	a4,a4,a3
    80001be0:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001be2:	577d                	li	a4,-1
    80001be4:	177e                	slli	a4,a4,0x3f
    80001be6:	8dd9                	or	a1,a1,a4
    80001be8:	02000537          	lui	a0,0x2000
    80001bec:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001bee:	0536                	slli	a0,a0,0xd
    80001bf0:	9782                	jalr	a5
}
    80001bf2:	60a2                	ld	ra,8(sp)
    80001bf4:	6402                	ld	s0,0(sp)
    80001bf6:	0141                	addi	sp,sp,16
    80001bf8:	8082                	ret

0000000080001bfa <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001bfa:	1101                	addi	sp,sp,-32
    80001bfc:	ec06                	sd	ra,24(sp)
    80001bfe:	e822                	sd	s0,16(sp)
    80001c00:	e426                	sd	s1,8(sp)
    80001c02:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001c04:	0000d497          	auipc	s1,0xd
    80001c08:	47c48493          	addi	s1,s1,1148 # 8000f080 <tickslock>
    80001c0c:	8526                	mv	a0,s1
    80001c0e:	00004097          	auipc	ra,0x4
    80001c12:	58a080e7          	jalr	1418(ra) # 80006198 <acquire>
  ticks++;
    80001c16:	00007517          	auipc	a0,0x7
    80001c1a:	40250513          	addi	a0,a0,1026 # 80009018 <ticks>
    80001c1e:	411c                	lw	a5,0(a0)
    80001c20:	2785                	addiw	a5,a5,1
    80001c22:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c24:	00000097          	auipc	ra,0x0
    80001c28:	ac6080e7          	jalr	-1338(ra) # 800016ea <wakeup>
  release(&tickslock);
    80001c2c:	8526                	mv	a0,s1
    80001c2e:	00004097          	auipc	ra,0x4
    80001c32:	61e080e7          	jalr	1566(ra) # 8000624c <release>
}
    80001c36:	60e2                	ld	ra,24(sp)
    80001c38:	6442                	ld	s0,16(sp)
    80001c3a:	64a2                	ld	s1,8(sp)
    80001c3c:	6105                	addi	sp,sp,32
    80001c3e:	8082                	ret

0000000080001c40 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001c40:	1101                	addi	sp,sp,-32
    80001c42:	ec06                	sd	ra,24(sp)
    80001c44:	e822                	sd	s0,16(sp)
    80001c46:	e426                	sd	s1,8(sp)
    80001c48:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c4a:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001c4e:	00074d63          	bltz	a4,80001c68 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001c52:	57fd                	li	a5,-1
    80001c54:	17fe                	slli	a5,a5,0x3f
    80001c56:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001c58:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c5a:	06f70363          	beq	a4,a5,80001cc0 <devintr+0x80>
  }
}
    80001c5e:	60e2                	ld	ra,24(sp)
    80001c60:	6442                	ld	s0,16(sp)
    80001c62:	64a2                	ld	s1,8(sp)
    80001c64:	6105                	addi	sp,sp,32
    80001c66:	8082                	ret
     (scause & 0xff) == 9){
    80001c68:	0ff77793          	zext.b	a5,a4
  if((scause & 0x8000000000000000L) &&
    80001c6c:	46a5                	li	a3,9
    80001c6e:	fed792e3          	bne	a5,a3,80001c52 <devintr+0x12>
    int irq = plic_claim();
    80001c72:	00003097          	auipc	ra,0x3
    80001c76:	556080e7          	jalr	1366(ra) # 800051c8 <plic_claim>
    80001c7a:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c7c:	47a9                	li	a5,10
    80001c7e:	02f50763          	beq	a0,a5,80001cac <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001c82:	4785                	li	a5,1
    80001c84:	02f50963          	beq	a0,a5,80001cb6 <devintr+0x76>
    return 1;
    80001c88:	4505                	li	a0,1
    } else if(irq){
    80001c8a:	d8f1                	beqz	s1,80001c5e <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c8c:	85a6                	mv	a1,s1
    80001c8e:	00006517          	auipc	a0,0x6
    80001c92:	5ea50513          	addi	a0,a0,1514 # 80008278 <states.0+0x38>
    80001c96:	00004097          	auipc	ra,0x4
    80001c9a:	014080e7          	jalr	20(ra) # 80005caa <printf>
      plic_complete(irq);
    80001c9e:	8526                	mv	a0,s1
    80001ca0:	00003097          	auipc	ra,0x3
    80001ca4:	54c080e7          	jalr	1356(ra) # 800051ec <plic_complete>
    return 1;
    80001ca8:	4505                	li	a0,1
    80001caa:	bf55                	j	80001c5e <devintr+0x1e>
      uartintr();
    80001cac:	00004097          	auipc	ra,0x4
    80001cb0:	40c080e7          	jalr	1036(ra) # 800060b8 <uartintr>
    80001cb4:	b7ed                	j	80001c9e <devintr+0x5e>
      virtio_disk_intr();
    80001cb6:	00004097          	auipc	ra,0x4
    80001cba:	9c2080e7          	jalr	-1598(ra) # 80005678 <virtio_disk_intr>
    80001cbe:	b7c5                	j	80001c9e <devintr+0x5e>
    if(cpuid() == 0){
    80001cc0:	fffff097          	auipc	ra,0xfffff
    80001cc4:	1a2080e7          	jalr	418(ra) # 80000e62 <cpuid>
    80001cc8:	c901                	beqz	a0,80001cd8 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001cca:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001cce:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001cd0:	14479073          	csrw	sip,a5
    return 2;
    80001cd4:	4509                	li	a0,2
    80001cd6:	b761                	j	80001c5e <devintr+0x1e>
      clockintr();
    80001cd8:	00000097          	auipc	ra,0x0
    80001cdc:	f22080e7          	jalr	-222(ra) # 80001bfa <clockintr>
    80001ce0:	b7ed                	j	80001cca <devintr+0x8a>

0000000080001ce2 <usertrap>:
{
    80001ce2:	1101                	addi	sp,sp,-32
    80001ce4:	ec06                	sd	ra,24(sp)
    80001ce6:	e822                	sd	s0,16(sp)
    80001ce8:	e426                	sd	s1,8(sp)
    80001cea:	e04a                	sd	s2,0(sp)
    80001cec:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cee:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001cf2:	1007f793          	andi	a5,a5,256
    80001cf6:	e3ad                	bnez	a5,80001d58 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cf8:	00003797          	auipc	a5,0x3
    80001cfc:	3c878793          	addi	a5,a5,968 # 800050c0 <kernelvec>
    80001d00:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001d04:	fffff097          	auipc	ra,0xfffff
    80001d08:	18a080e7          	jalr	394(ra) # 80000e8e <myproc>
    80001d0c:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001d0e:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d10:	14102773          	csrr	a4,sepc
    80001d14:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d16:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001d1a:	47a1                	li	a5,8
    80001d1c:	04f71c63          	bne	a4,a5,80001d74 <usertrap+0x92>
    if(p->killed)
    80001d20:	551c                	lw	a5,40(a0)
    80001d22:	e3b9                	bnez	a5,80001d68 <usertrap+0x86>
    p->trapframe->epc += 4;
    80001d24:	6cb8                	ld	a4,88(s1)
    80001d26:	6f1c                	ld	a5,24(a4)
    80001d28:	0791                	addi	a5,a5,4
    80001d2a:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d2c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d30:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d34:	10079073          	csrw	sstatus,a5
    syscall();
    80001d38:	00000097          	auipc	ra,0x0
    80001d3c:	2e0080e7          	jalr	736(ra) # 80002018 <syscall>
  if(p->killed)
    80001d40:	549c                	lw	a5,40(s1)
    80001d42:	ebc1                	bnez	a5,80001dd2 <usertrap+0xf0>
  usertrapret();
    80001d44:	00000097          	auipc	ra,0x0
    80001d48:	e18080e7          	jalr	-488(ra) # 80001b5c <usertrapret>
}
    80001d4c:	60e2                	ld	ra,24(sp)
    80001d4e:	6442                	ld	s0,16(sp)
    80001d50:	64a2                	ld	s1,8(sp)
    80001d52:	6902                	ld	s2,0(sp)
    80001d54:	6105                	addi	sp,sp,32
    80001d56:	8082                	ret
    panic("usertrap: not from user mode");
    80001d58:	00006517          	auipc	a0,0x6
    80001d5c:	54050513          	addi	a0,a0,1344 # 80008298 <states.0+0x58>
    80001d60:	00004097          	auipc	ra,0x4
    80001d64:	f00080e7          	jalr	-256(ra) # 80005c60 <panic>
      exit(-1);
    80001d68:	557d                	li	a0,-1
    80001d6a:	00000097          	auipc	ra,0x0
    80001d6e:	a50080e7          	jalr	-1456(ra) # 800017ba <exit>
    80001d72:	bf4d                	j	80001d24 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001d74:	00000097          	auipc	ra,0x0
    80001d78:	ecc080e7          	jalr	-308(ra) # 80001c40 <devintr>
    80001d7c:	892a                	mv	s2,a0
    80001d7e:	c501                	beqz	a0,80001d86 <usertrap+0xa4>
  if(p->killed)
    80001d80:	549c                	lw	a5,40(s1)
    80001d82:	c3a1                	beqz	a5,80001dc2 <usertrap+0xe0>
    80001d84:	a815                	j	80001db8 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d86:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001d8a:	5890                	lw	a2,48(s1)
    80001d8c:	00006517          	auipc	a0,0x6
    80001d90:	52c50513          	addi	a0,a0,1324 # 800082b8 <states.0+0x78>
    80001d94:	00004097          	auipc	ra,0x4
    80001d98:	f16080e7          	jalr	-234(ra) # 80005caa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d9c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001da0:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001da4:	00006517          	auipc	a0,0x6
    80001da8:	54450513          	addi	a0,a0,1348 # 800082e8 <states.0+0xa8>
    80001dac:	00004097          	auipc	ra,0x4
    80001db0:	efe080e7          	jalr	-258(ra) # 80005caa <printf>
    p->killed = 1;
    80001db4:	4785                	li	a5,1
    80001db6:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001db8:	557d                	li	a0,-1
    80001dba:	00000097          	auipc	ra,0x0
    80001dbe:	a00080e7          	jalr	-1536(ra) # 800017ba <exit>
  if(which_dev == 2)
    80001dc2:	4789                	li	a5,2
    80001dc4:	f8f910e3          	bne	s2,a5,80001d44 <usertrap+0x62>
    yield();
    80001dc8:	fffff097          	auipc	ra,0xfffff
    80001dcc:	75a080e7          	jalr	1882(ra) # 80001522 <yield>
    80001dd0:	bf95                	j	80001d44 <usertrap+0x62>
  int which_dev = 0;
    80001dd2:	4901                	li	s2,0
    80001dd4:	b7d5                	j	80001db8 <usertrap+0xd6>

0000000080001dd6 <kerneltrap>:
{
    80001dd6:	7179                	addi	sp,sp,-48
    80001dd8:	f406                	sd	ra,40(sp)
    80001dda:	f022                	sd	s0,32(sp)
    80001ddc:	ec26                	sd	s1,24(sp)
    80001dde:	e84a                	sd	s2,16(sp)
    80001de0:	e44e                	sd	s3,8(sp)
    80001de2:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001de4:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001de8:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001dec:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001df0:	1004f793          	andi	a5,s1,256
    80001df4:	cb85                	beqz	a5,80001e24 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001df6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001dfa:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001dfc:	ef85                	bnez	a5,80001e34 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001dfe:	00000097          	auipc	ra,0x0
    80001e02:	e42080e7          	jalr	-446(ra) # 80001c40 <devintr>
    80001e06:	cd1d                	beqz	a0,80001e44 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e08:	4789                	li	a5,2
    80001e0a:	06f50a63          	beq	a0,a5,80001e7e <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e0e:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e12:	10049073          	csrw	sstatus,s1
}
    80001e16:	70a2                	ld	ra,40(sp)
    80001e18:	7402                	ld	s0,32(sp)
    80001e1a:	64e2                	ld	s1,24(sp)
    80001e1c:	6942                	ld	s2,16(sp)
    80001e1e:	69a2                	ld	s3,8(sp)
    80001e20:	6145                	addi	sp,sp,48
    80001e22:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e24:	00006517          	auipc	a0,0x6
    80001e28:	4e450513          	addi	a0,a0,1252 # 80008308 <states.0+0xc8>
    80001e2c:	00004097          	auipc	ra,0x4
    80001e30:	e34080e7          	jalr	-460(ra) # 80005c60 <panic>
    panic("kerneltrap: interrupts enabled");
    80001e34:	00006517          	auipc	a0,0x6
    80001e38:	4fc50513          	addi	a0,a0,1276 # 80008330 <states.0+0xf0>
    80001e3c:	00004097          	auipc	ra,0x4
    80001e40:	e24080e7          	jalr	-476(ra) # 80005c60 <panic>
    printf("scause %p\n", scause);
    80001e44:	85ce                	mv	a1,s3
    80001e46:	00006517          	auipc	a0,0x6
    80001e4a:	50a50513          	addi	a0,a0,1290 # 80008350 <states.0+0x110>
    80001e4e:	00004097          	auipc	ra,0x4
    80001e52:	e5c080e7          	jalr	-420(ra) # 80005caa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e56:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e5a:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e5e:	00006517          	auipc	a0,0x6
    80001e62:	50250513          	addi	a0,a0,1282 # 80008360 <states.0+0x120>
    80001e66:	00004097          	auipc	ra,0x4
    80001e6a:	e44080e7          	jalr	-444(ra) # 80005caa <printf>
    panic("kerneltrap");
    80001e6e:	00006517          	auipc	a0,0x6
    80001e72:	50a50513          	addi	a0,a0,1290 # 80008378 <states.0+0x138>
    80001e76:	00004097          	auipc	ra,0x4
    80001e7a:	dea080e7          	jalr	-534(ra) # 80005c60 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e7e:	fffff097          	auipc	ra,0xfffff
    80001e82:	010080e7          	jalr	16(ra) # 80000e8e <myproc>
    80001e86:	d541                	beqz	a0,80001e0e <kerneltrap+0x38>
    80001e88:	fffff097          	auipc	ra,0xfffff
    80001e8c:	006080e7          	jalr	6(ra) # 80000e8e <myproc>
    80001e90:	4d18                	lw	a4,24(a0)
    80001e92:	4791                	li	a5,4
    80001e94:	f6f71de3          	bne	a4,a5,80001e0e <kerneltrap+0x38>
    yield();
    80001e98:	fffff097          	auipc	ra,0xfffff
    80001e9c:	68a080e7          	jalr	1674(ra) # 80001522 <yield>
    80001ea0:	b7bd                	j	80001e0e <kerneltrap+0x38>

0000000080001ea2 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001ea2:	1101                	addi	sp,sp,-32
    80001ea4:	ec06                	sd	ra,24(sp)
    80001ea6:	e822                	sd	s0,16(sp)
    80001ea8:	e426                	sd	s1,8(sp)
    80001eaa:	1000                	addi	s0,sp,32
    80001eac:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001eae:	fffff097          	auipc	ra,0xfffff
    80001eb2:	fe0080e7          	jalr	-32(ra) # 80000e8e <myproc>
  switch (n) {
    80001eb6:	4795                	li	a5,5
    80001eb8:	0497e163          	bltu	a5,s1,80001efa <argraw+0x58>
    80001ebc:	048a                	slli	s1,s1,0x2
    80001ebe:	00006717          	auipc	a4,0x6
    80001ec2:	5ba70713          	addi	a4,a4,1466 # 80008478 <states.0+0x238>
    80001ec6:	94ba                	add	s1,s1,a4
    80001ec8:	409c                	lw	a5,0(s1)
    80001eca:	97ba                	add	a5,a5,a4
    80001ecc:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001ece:	6d3c                	ld	a5,88(a0)
    80001ed0:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001ed2:	60e2                	ld	ra,24(sp)
    80001ed4:	6442                	ld	s0,16(sp)
    80001ed6:	64a2                	ld	s1,8(sp)
    80001ed8:	6105                	addi	sp,sp,32
    80001eda:	8082                	ret
    return p->trapframe->a1;
    80001edc:	6d3c                	ld	a5,88(a0)
    80001ede:	7fa8                	ld	a0,120(a5)
    80001ee0:	bfcd                	j	80001ed2 <argraw+0x30>
    return p->trapframe->a2;
    80001ee2:	6d3c                	ld	a5,88(a0)
    80001ee4:	63c8                	ld	a0,128(a5)
    80001ee6:	b7f5                	j	80001ed2 <argraw+0x30>
    return p->trapframe->a3;
    80001ee8:	6d3c                	ld	a5,88(a0)
    80001eea:	67c8                	ld	a0,136(a5)
    80001eec:	b7dd                	j	80001ed2 <argraw+0x30>
    return p->trapframe->a4;
    80001eee:	6d3c                	ld	a5,88(a0)
    80001ef0:	6bc8                	ld	a0,144(a5)
    80001ef2:	b7c5                	j	80001ed2 <argraw+0x30>
    return p->trapframe->a5;
    80001ef4:	6d3c                	ld	a5,88(a0)
    80001ef6:	6fc8                	ld	a0,152(a5)
    80001ef8:	bfe9                	j	80001ed2 <argraw+0x30>
  panic("argraw");
    80001efa:	00006517          	auipc	a0,0x6
    80001efe:	48e50513          	addi	a0,a0,1166 # 80008388 <states.0+0x148>
    80001f02:	00004097          	auipc	ra,0x4
    80001f06:	d5e080e7          	jalr	-674(ra) # 80005c60 <panic>

0000000080001f0a <fetchaddr>:
{
    80001f0a:	1101                	addi	sp,sp,-32
    80001f0c:	ec06                	sd	ra,24(sp)
    80001f0e:	e822                	sd	s0,16(sp)
    80001f10:	e426                	sd	s1,8(sp)
    80001f12:	e04a                	sd	s2,0(sp)
    80001f14:	1000                	addi	s0,sp,32
    80001f16:	84aa                	mv	s1,a0
    80001f18:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f1a:	fffff097          	auipc	ra,0xfffff
    80001f1e:	f74080e7          	jalr	-140(ra) # 80000e8e <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001f22:	653c                	ld	a5,72(a0)
    80001f24:	02f4f863          	bgeu	s1,a5,80001f54 <fetchaddr+0x4a>
    80001f28:	00848713          	addi	a4,s1,8
    80001f2c:	02e7e663          	bltu	a5,a4,80001f58 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f30:	46a1                	li	a3,8
    80001f32:	8626                	mv	a2,s1
    80001f34:	85ca                	mv	a1,s2
    80001f36:	6928                	ld	a0,80(a0)
    80001f38:	fffff097          	auipc	ra,0xfffff
    80001f3c:	ca6080e7          	jalr	-858(ra) # 80000bde <copyin>
    80001f40:	00a03533          	snez	a0,a0
    80001f44:	40a00533          	neg	a0,a0
}
    80001f48:	60e2                	ld	ra,24(sp)
    80001f4a:	6442                	ld	s0,16(sp)
    80001f4c:	64a2                	ld	s1,8(sp)
    80001f4e:	6902                	ld	s2,0(sp)
    80001f50:	6105                	addi	sp,sp,32
    80001f52:	8082                	ret
    return -1;
    80001f54:	557d                	li	a0,-1
    80001f56:	bfcd                	j	80001f48 <fetchaddr+0x3e>
    80001f58:	557d                	li	a0,-1
    80001f5a:	b7fd                	j	80001f48 <fetchaddr+0x3e>

0000000080001f5c <fetchstr>:
{
    80001f5c:	7179                	addi	sp,sp,-48
    80001f5e:	f406                	sd	ra,40(sp)
    80001f60:	f022                	sd	s0,32(sp)
    80001f62:	ec26                	sd	s1,24(sp)
    80001f64:	e84a                	sd	s2,16(sp)
    80001f66:	e44e                	sd	s3,8(sp)
    80001f68:	1800                	addi	s0,sp,48
    80001f6a:	892a                	mv	s2,a0
    80001f6c:	84ae                	mv	s1,a1
    80001f6e:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f70:	fffff097          	auipc	ra,0xfffff
    80001f74:	f1e080e7          	jalr	-226(ra) # 80000e8e <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001f78:	86ce                	mv	a3,s3
    80001f7a:	864a                	mv	a2,s2
    80001f7c:	85a6                	mv	a1,s1
    80001f7e:	6928                	ld	a0,80(a0)
    80001f80:	fffff097          	auipc	ra,0xfffff
    80001f84:	cec080e7          	jalr	-788(ra) # 80000c6c <copyinstr>
  if(err < 0)
    80001f88:	00054763          	bltz	a0,80001f96 <fetchstr+0x3a>
  return strlen(buf);
    80001f8c:	8526                	mv	a0,s1
    80001f8e:	ffffe097          	auipc	ra,0xffffe
    80001f92:	3b2080e7          	jalr	946(ra) # 80000340 <strlen>
}
    80001f96:	70a2                	ld	ra,40(sp)
    80001f98:	7402                	ld	s0,32(sp)
    80001f9a:	64e2                	ld	s1,24(sp)
    80001f9c:	6942                	ld	s2,16(sp)
    80001f9e:	69a2                	ld	s3,8(sp)
    80001fa0:	6145                	addi	sp,sp,48
    80001fa2:	8082                	ret

0000000080001fa4 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001fa4:	1101                	addi	sp,sp,-32
    80001fa6:	ec06                	sd	ra,24(sp)
    80001fa8:	e822                	sd	s0,16(sp)
    80001faa:	e426                	sd	s1,8(sp)
    80001fac:	1000                	addi	s0,sp,32
    80001fae:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fb0:	00000097          	auipc	ra,0x0
    80001fb4:	ef2080e7          	jalr	-270(ra) # 80001ea2 <argraw>
    80001fb8:	c088                	sw	a0,0(s1)
  return 0;
}
    80001fba:	4501                	li	a0,0
    80001fbc:	60e2                	ld	ra,24(sp)
    80001fbe:	6442                	ld	s0,16(sp)
    80001fc0:	64a2                	ld	s1,8(sp)
    80001fc2:	6105                	addi	sp,sp,32
    80001fc4:	8082                	ret

0000000080001fc6 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80001fc6:	1101                	addi	sp,sp,-32
    80001fc8:	ec06                	sd	ra,24(sp)
    80001fca:	e822                	sd	s0,16(sp)
    80001fcc:	e426                	sd	s1,8(sp)
    80001fce:	1000                	addi	s0,sp,32
    80001fd0:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fd2:	00000097          	auipc	ra,0x0
    80001fd6:	ed0080e7          	jalr	-304(ra) # 80001ea2 <argraw>
    80001fda:	e088                	sd	a0,0(s1)
  return 0;
}
    80001fdc:	4501                	li	a0,0
    80001fde:	60e2                	ld	ra,24(sp)
    80001fe0:	6442                	ld	s0,16(sp)
    80001fe2:	64a2                	ld	s1,8(sp)
    80001fe4:	6105                	addi	sp,sp,32
    80001fe6:	8082                	ret

0000000080001fe8 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001fe8:	1101                	addi	sp,sp,-32
    80001fea:	ec06                	sd	ra,24(sp)
    80001fec:	e822                	sd	s0,16(sp)
    80001fee:	e426                	sd	s1,8(sp)
    80001ff0:	e04a                	sd	s2,0(sp)
    80001ff2:	1000                	addi	s0,sp,32
    80001ff4:	84ae                	mv	s1,a1
    80001ff6:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001ff8:	00000097          	auipc	ra,0x0
    80001ffc:	eaa080e7          	jalr	-342(ra) # 80001ea2 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002000:	864a                	mv	a2,s2
    80002002:	85a6                	mv	a1,s1
    80002004:	00000097          	auipc	ra,0x0
    80002008:	f58080e7          	jalr	-168(ra) # 80001f5c <fetchstr>
}
    8000200c:	60e2                	ld	ra,24(sp)
    8000200e:	6442                	ld	s0,16(sp)
    80002010:	64a2                	ld	s1,8(sp)
    80002012:	6902                	ld	s2,0(sp)
    80002014:	6105                	addi	sp,sp,32
    80002016:	8082                	ret

0000000080002018 <syscall>:
  "mkdir", "close", "trace", "sysinfo",
};

void
syscall(void)
{
    80002018:	7179                	addi	sp,sp,-48
    8000201a:	f406                	sd	ra,40(sp)
    8000201c:	f022                	sd	s0,32(sp)
    8000201e:	ec26                	sd	s1,24(sp)
    80002020:	e84a                	sd	s2,16(sp)
    80002022:	e44e                	sd	s3,8(sp)
    80002024:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    80002026:	fffff097          	auipc	ra,0xfffff
    8000202a:	e68080e7          	jalr	-408(ra) # 80000e8e <myproc>
    8000202e:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002030:	05853983          	ld	s3,88(a0)
    80002034:	0a89b783          	ld	a5,168(s3)
    80002038:	0007891b          	sext.w	s2,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000203c:	37fd                	addiw	a5,a5,-1
    8000203e:	4759                	li	a4,22
    80002040:	00f76f63          	bltu	a4,a5,8000205e <syscall+0x46>
    80002044:	00391713          	slli	a4,s2,0x3
    80002048:	00006797          	auipc	a5,0x6
    8000204c:	44878793          	addi	a5,a5,1096 # 80008490 <syscalls>
    80002050:	97ba                	add	a5,a5,a4
    80002052:	639c                	ld	a5,0(a5)
    80002054:	c789                	beqz	a5,8000205e <syscall+0x46>
    p->trapframe->a0 = syscalls[num]();
    80002056:	9782                	jalr	a5
    80002058:	06a9b823          	sd	a0,112(s3)
    8000205c:	a005                	j	8000207c <syscall+0x64>
  } else {
    printf("%d %s: unknown sys call %d\n",
    8000205e:	86ca                	mv	a3,s2
    80002060:	15848613          	addi	a2,s1,344
    80002064:	588c                	lw	a1,48(s1)
    80002066:	00006517          	auipc	a0,0x6
    8000206a:	32a50513          	addi	a0,a0,810 # 80008390 <states.0+0x150>
    8000206e:	00004097          	auipc	ra,0x4
    80002072:	c3c080e7          	jalr	-964(ra) # 80005caa <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002076:	6cbc                	ld	a5,88(s1)
    80002078:	577d                	li	a4,-1
    8000207a:	fbb8                	sd	a4,112(a5)
  }
    //start  从a7读取系统调用的编号，将1<<num与进程的tracemask比较，相等则打印
  if((1 << num) & p->trace_mask) 
    8000207c:	1684a783          	lw	a5,360(s1)
    80002080:	4127d7bb          	sraw	a5,a5,s2
    80002084:	8b85                	andi	a5,a5,1
    80002086:	eb81                	bnez	a5,80002096 <syscall+0x7e>
  {
      printf("%d: syscall %s -> %d\n", p->pid, syscall_names[num], p->trapframe->a0);
  }
    //end
}
    80002088:	70a2                	ld	ra,40(sp)
    8000208a:	7402                	ld	s0,32(sp)
    8000208c:	64e2                	ld	s1,24(sp)
    8000208e:	6942                	ld	s2,16(sp)
    80002090:	69a2                	ld	s3,8(sp)
    80002092:	6145                	addi	sp,sp,48
    80002094:	8082                	ret
      printf("%d: syscall %s -> %d\n", p->pid, syscall_names[num], p->trapframe->a0);
    80002096:	6cb8                	ld	a4,88(s1)
    80002098:	090e                	slli	s2,s2,0x3
    8000209a:	00006797          	auipc	a5,0x6
    8000209e:	3f678793          	addi	a5,a5,1014 # 80008490 <syscalls>
    800020a2:	97ca                	add	a5,a5,s2
    800020a4:	7b34                	ld	a3,112(a4)
    800020a6:	63f0                	ld	a2,192(a5)
    800020a8:	588c                	lw	a1,48(s1)
    800020aa:	00006517          	auipc	a0,0x6
    800020ae:	30650513          	addi	a0,a0,774 # 800083b0 <states.0+0x170>
    800020b2:	00004097          	auipc	ra,0x4
    800020b6:	bf8080e7          	jalr	-1032(ra) # 80005caa <printf>
}
    800020ba:	b7f9                	j	80002088 <syscall+0x70>

00000000800020bc <sys_exit>:
#include "proc.h"
#include "sysinfo.h"

uint64
sys_exit(void)
{
    800020bc:	1101                	addi	sp,sp,-32
    800020be:	ec06                	sd	ra,24(sp)
    800020c0:	e822                	sd	s0,16(sp)
    800020c2:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    800020c4:	fec40593          	addi	a1,s0,-20
    800020c8:	4501                	li	a0,0
    800020ca:	00000097          	auipc	ra,0x0
    800020ce:	eda080e7          	jalr	-294(ra) # 80001fa4 <argint>
    return -1;
    800020d2:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800020d4:	00054963          	bltz	a0,800020e6 <sys_exit+0x2a>
  exit(n);
    800020d8:	fec42503          	lw	a0,-20(s0)
    800020dc:	fffff097          	auipc	ra,0xfffff
    800020e0:	6de080e7          	jalr	1758(ra) # 800017ba <exit>
  return 0;  // not reached
    800020e4:	4781                	li	a5,0
}
    800020e6:	853e                	mv	a0,a5
    800020e8:	60e2                	ld	ra,24(sp)
    800020ea:	6442                	ld	s0,16(sp)
    800020ec:	6105                	addi	sp,sp,32
    800020ee:	8082                	ret

00000000800020f0 <sys_getpid>:

uint64
sys_getpid(void)
{
    800020f0:	1141                	addi	sp,sp,-16
    800020f2:	e406                	sd	ra,8(sp)
    800020f4:	e022                	sd	s0,0(sp)
    800020f6:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800020f8:	fffff097          	auipc	ra,0xfffff
    800020fc:	d96080e7          	jalr	-618(ra) # 80000e8e <myproc>
}
    80002100:	5908                	lw	a0,48(a0)
    80002102:	60a2                	ld	ra,8(sp)
    80002104:	6402                	ld	s0,0(sp)
    80002106:	0141                	addi	sp,sp,16
    80002108:	8082                	ret

000000008000210a <sys_fork>:

uint64
sys_fork(void)
{
    8000210a:	1141                	addi	sp,sp,-16
    8000210c:	e406                	sd	ra,8(sp)
    8000210e:	e022                	sd	s0,0(sp)
    80002110:	0800                	addi	s0,sp,16
  return fork();
    80002112:	fffff097          	auipc	ra,0xfffff
    80002116:	14e080e7          	jalr	334(ra) # 80001260 <fork>
}
    8000211a:	60a2                	ld	ra,8(sp)
    8000211c:	6402                	ld	s0,0(sp)
    8000211e:	0141                	addi	sp,sp,16
    80002120:	8082                	ret

0000000080002122 <sys_wait>:

uint64
sys_wait(void)
{
    80002122:	1101                	addi	sp,sp,-32
    80002124:	ec06                	sd	ra,24(sp)
    80002126:	e822                	sd	s0,16(sp)
    80002128:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    8000212a:	fe840593          	addi	a1,s0,-24
    8000212e:	4501                	li	a0,0
    80002130:	00000097          	auipc	ra,0x0
    80002134:	e96080e7          	jalr	-362(ra) # 80001fc6 <argaddr>
    80002138:	87aa                	mv	a5,a0
    return -1;
    8000213a:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    8000213c:	0007c863          	bltz	a5,8000214c <sys_wait+0x2a>
  return wait(p);
    80002140:	fe843503          	ld	a0,-24(s0)
    80002144:	fffff097          	auipc	ra,0xfffff
    80002148:	47e080e7          	jalr	1150(ra) # 800015c2 <wait>
}
    8000214c:	60e2                	ld	ra,24(sp)
    8000214e:	6442                	ld	s0,16(sp)
    80002150:	6105                	addi	sp,sp,32
    80002152:	8082                	ret

0000000080002154 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002154:	7179                	addi	sp,sp,-48
    80002156:	f406                	sd	ra,40(sp)
    80002158:	f022                	sd	s0,32(sp)
    8000215a:	ec26                	sd	s1,24(sp)
    8000215c:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    8000215e:	fdc40593          	addi	a1,s0,-36
    80002162:	4501                	li	a0,0
    80002164:	00000097          	auipc	ra,0x0
    80002168:	e40080e7          	jalr	-448(ra) # 80001fa4 <argint>
    8000216c:	87aa                	mv	a5,a0
    return -1;
    8000216e:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002170:	0207c063          	bltz	a5,80002190 <sys_sbrk+0x3c>
  addr = myproc()->sz;
    80002174:	fffff097          	auipc	ra,0xfffff
    80002178:	d1a080e7          	jalr	-742(ra) # 80000e8e <myproc>
    8000217c:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    8000217e:	fdc42503          	lw	a0,-36(s0)
    80002182:	fffff097          	auipc	ra,0xfffff
    80002186:	066080e7          	jalr	102(ra) # 800011e8 <growproc>
    8000218a:	00054863          	bltz	a0,8000219a <sys_sbrk+0x46>
    return -1;
  return addr;
    8000218e:	8526                	mv	a0,s1
}
    80002190:	70a2                	ld	ra,40(sp)
    80002192:	7402                	ld	s0,32(sp)
    80002194:	64e2                	ld	s1,24(sp)
    80002196:	6145                	addi	sp,sp,48
    80002198:	8082                	ret
    return -1;
    8000219a:	557d                	li	a0,-1
    8000219c:	bfd5                	j	80002190 <sys_sbrk+0x3c>

000000008000219e <sys_sleep>:

uint64
sys_sleep(void)
{
    8000219e:	7139                	addi	sp,sp,-64
    800021a0:	fc06                	sd	ra,56(sp)
    800021a2:	f822                	sd	s0,48(sp)
    800021a4:	f426                	sd	s1,40(sp)
    800021a6:	f04a                	sd	s2,32(sp)
    800021a8:	ec4e                	sd	s3,24(sp)
    800021aa:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    800021ac:	fcc40593          	addi	a1,s0,-52
    800021b0:	4501                	li	a0,0
    800021b2:	00000097          	auipc	ra,0x0
    800021b6:	df2080e7          	jalr	-526(ra) # 80001fa4 <argint>
    return -1;
    800021ba:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800021bc:	06054563          	bltz	a0,80002226 <sys_sleep+0x88>
  acquire(&tickslock);
    800021c0:	0000d517          	auipc	a0,0xd
    800021c4:	ec050513          	addi	a0,a0,-320 # 8000f080 <tickslock>
    800021c8:	00004097          	auipc	ra,0x4
    800021cc:	fd0080e7          	jalr	-48(ra) # 80006198 <acquire>
  ticks0 = ticks;
    800021d0:	00007917          	auipc	s2,0x7
    800021d4:	e4892903          	lw	s2,-440(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    800021d8:	fcc42783          	lw	a5,-52(s0)
    800021dc:	cf85                	beqz	a5,80002214 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800021de:	0000d997          	auipc	s3,0xd
    800021e2:	ea298993          	addi	s3,s3,-350 # 8000f080 <tickslock>
    800021e6:	00007497          	auipc	s1,0x7
    800021ea:	e3248493          	addi	s1,s1,-462 # 80009018 <ticks>
    if(myproc()->killed){
    800021ee:	fffff097          	auipc	ra,0xfffff
    800021f2:	ca0080e7          	jalr	-864(ra) # 80000e8e <myproc>
    800021f6:	551c                	lw	a5,40(a0)
    800021f8:	ef9d                	bnez	a5,80002236 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800021fa:	85ce                	mv	a1,s3
    800021fc:	8526                	mv	a0,s1
    800021fe:	fffff097          	auipc	ra,0xfffff
    80002202:	360080e7          	jalr	864(ra) # 8000155e <sleep>
  while(ticks - ticks0 < n){
    80002206:	409c                	lw	a5,0(s1)
    80002208:	412787bb          	subw	a5,a5,s2
    8000220c:	fcc42703          	lw	a4,-52(s0)
    80002210:	fce7efe3          	bltu	a5,a4,800021ee <sys_sleep+0x50>
  }
  release(&tickslock);
    80002214:	0000d517          	auipc	a0,0xd
    80002218:	e6c50513          	addi	a0,a0,-404 # 8000f080 <tickslock>
    8000221c:	00004097          	auipc	ra,0x4
    80002220:	030080e7          	jalr	48(ra) # 8000624c <release>
  return 0;
    80002224:	4781                	li	a5,0
}
    80002226:	853e                	mv	a0,a5
    80002228:	70e2                	ld	ra,56(sp)
    8000222a:	7442                	ld	s0,48(sp)
    8000222c:	74a2                	ld	s1,40(sp)
    8000222e:	7902                	ld	s2,32(sp)
    80002230:	69e2                	ld	s3,24(sp)
    80002232:	6121                	addi	sp,sp,64
    80002234:	8082                	ret
      release(&tickslock);
    80002236:	0000d517          	auipc	a0,0xd
    8000223a:	e4a50513          	addi	a0,a0,-438 # 8000f080 <tickslock>
    8000223e:	00004097          	auipc	ra,0x4
    80002242:	00e080e7          	jalr	14(ra) # 8000624c <release>
      return -1;
    80002246:	57fd                	li	a5,-1
    80002248:	bff9                	j	80002226 <sys_sleep+0x88>

000000008000224a <sys_kill>:

uint64
sys_kill(void)
{
    8000224a:	1101                	addi	sp,sp,-32
    8000224c:	ec06                	sd	ra,24(sp)
    8000224e:	e822                	sd	s0,16(sp)
    80002250:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002252:	fec40593          	addi	a1,s0,-20
    80002256:	4501                	li	a0,0
    80002258:	00000097          	auipc	ra,0x0
    8000225c:	d4c080e7          	jalr	-692(ra) # 80001fa4 <argint>
    80002260:	87aa                	mv	a5,a0
    return -1;
    80002262:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002264:	0007c863          	bltz	a5,80002274 <sys_kill+0x2a>
  return kill(pid);
    80002268:	fec42503          	lw	a0,-20(s0)
    8000226c:	fffff097          	auipc	ra,0xfffff
    80002270:	624080e7          	jalr	1572(ra) # 80001890 <kill>
}
    80002274:	60e2                	ld	ra,24(sp)
    80002276:	6442                	ld	s0,16(sp)
    80002278:	6105                	addi	sp,sp,32
    8000227a:	8082                	ret

000000008000227c <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000227c:	1101                	addi	sp,sp,-32
    8000227e:	ec06                	sd	ra,24(sp)
    80002280:	e822                	sd	s0,16(sp)
    80002282:	e426                	sd	s1,8(sp)
    80002284:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002286:	0000d517          	auipc	a0,0xd
    8000228a:	dfa50513          	addi	a0,a0,-518 # 8000f080 <tickslock>
    8000228e:	00004097          	auipc	ra,0x4
    80002292:	f0a080e7          	jalr	-246(ra) # 80006198 <acquire>
  xticks = ticks;
    80002296:	00007497          	auipc	s1,0x7
    8000229a:	d824a483          	lw	s1,-638(s1) # 80009018 <ticks>
  release(&tickslock);
    8000229e:	0000d517          	auipc	a0,0xd
    800022a2:	de250513          	addi	a0,a0,-542 # 8000f080 <tickslock>
    800022a6:	00004097          	auipc	ra,0x4
    800022aa:	fa6080e7          	jalr	-90(ra) # 8000624c <release>
  return xticks;
}
    800022ae:	02049513          	slli	a0,s1,0x20
    800022b2:	9101                	srli	a0,a0,0x20
    800022b4:	60e2                	ld	ra,24(sp)
    800022b6:	6442                	ld	s0,16(sp)
    800022b8:	64a2                	ld	s1,8(sp)
    800022ba:	6105                	addi	sp,sp,32
    800022bc:	8082                	ret

00000000800022be <sys_trace>:

uint64
sys_trace(void)
{
    800022be:	1101                	addi	sp,sp,-32
    800022c0:	ec06                	sd	ra,24(sp)
    800022c2:	e822                	sd	s0,16(sp)
    800022c4:	1000                	addi	s0,sp,32
  int trace_mask;
  // 取 a0 寄存器中的值返回给 mask
  if(argint(0, &trace_mask) < 0)
    800022c6:	fec40593          	addi	a1,s0,-20
    800022ca:	4501                	li	a0,0
    800022cc:	00000097          	auipc	ra,0x0
    800022d0:	cd8080e7          	jalr	-808(ra) # 80001fa4 <argint>
    return -1;
    800022d4:	57fd                	li	a5,-1
  if(argint(0, &trace_mask) < 0)
    800022d6:	00054b63          	bltz	a0,800022ec <sys_trace+0x2e>

  // 把 mask 传给现有进程的 mask
  myproc()->trace_mask = trace_mask;
    800022da:	fffff097          	auipc	ra,0xfffff
    800022de:	bb4080e7          	jalr	-1100(ra) # 80000e8e <myproc>
    800022e2:	fec42783          	lw	a5,-20(s0)
    800022e6:	16f52423          	sw	a5,360(a0)
  return 0;
    800022ea:	4781                	li	a5,0
}
    800022ec:	853e                	mv	a0,a5
    800022ee:	60e2                	ld	ra,24(sp)
    800022f0:	6442                	ld	s0,16(sp)
    800022f2:	6105                	addi	sp,sp,32
    800022f4:	8082                	ret

00000000800022f6 <sys_sysinfo>:

uint64
sys_sysinfo(void)
{
    800022f6:	7139                	addi	sp,sp,-64
    800022f8:	fc06                	sd	ra,56(sp)
    800022fa:	f822                	sd	s0,48(sp)
    800022fc:	f426                	sd	s1,40(sp)
    800022fe:	0080                	addi	s0,sp,64
//addr是临时申请的一个空间，用于copyout
  uint64 addr;
  struct sysinfo info;  
  struct proc *p = myproc();
    80002300:	fffff097          	auipc	ra,0xfffff
    80002304:	b8e080e7          	jalr	-1138(ra) # 80000e8e <myproc>
    80002308:	84aa                	mv	s1,a0

  if (argaddr(0, &addr) < 0)
    8000230a:	fd840593          	addi	a1,s0,-40
    8000230e:	4501                	li	a0,0
    80002310:	00000097          	auipc	ra,0x0
    80002314:	cb6080e7          	jalr	-842(ra) # 80001fc6 <argaddr>
	  return -1;
    80002318:	57fd                	li	a5,-1
  if (argaddr(0, &addr) < 0)
    8000231a:	02054a63          	bltz	a0,8000234e <sys_sysinfo+0x58>
  info.freemem = free_mem();
    8000231e:	ffffe097          	auipc	ra,0xffffe
    80002322:	e5c080e7          	jalr	-420(ra) # 8000017a <free_mem>
    80002326:	fca43423          	sd	a0,-56(s0)
  info.nproc = nproc();
    8000232a:	fffff097          	auipc	ra,0xfffff
    8000232e:	734080e7          	jalr	1844(ra) # 80001a5e <nproc>
    80002332:	fca43823          	sd	a0,-48(s0)

  if (copyout(p->pagetable, addr, (char *)&info, sizeof(info)) < 0)
    80002336:	46c1                	li	a3,16
    80002338:	fc840613          	addi	a2,s0,-56
    8000233c:	fd843583          	ld	a1,-40(s0)
    80002340:	68a8                	ld	a0,80(s1)
    80002342:	fffff097          	auipc	ra,0xfffff
    80002346:	810080e7          	jalr	-2032(ra) # 80000b52 <copyout>
    8000234a:	43f55793          	srai	a5,a0,0x3f
    return -1;

  return 0;
    8000234e:	853e                	mv	a0,a5
    80002350:	70e2                	ld	ra,56(sp)
    80002352:	7442                	ld	s0,48(sp)
    80002354:	74a2                	ld	s1,40(sp)
    80002356:	6121                	addi	sp,sp,64
    80002358:	8082                	ret

000000008000235a <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000235a:	7179                	addi	sp,sp,-48
    8000235c:	f406                	sd	ra,40(sp)
    8000235e:	f022                	sd	s0,32(sp)
    80002360:	ec26                	sd	s1,24(sp)
    80002362:	e84a                	sd	s2,16(sp)
    80002364:	e44e                	sd	s3,8(sp)
    80002366:	e052                	sd	s4,0(sp)
    80002368:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000236a:	00006597          	auipc	a1,0x6
    8000236e:	2a658593          	addi	a1,a1,678 # 80008610 <syscall_names+0xc0>
    80002372:	0000d517          	auipc	a0,0xd
    80002376:	d2650513          	addi	a0,a0,-730 # 8000f098 <bcache>
    8000237a:	00004097          	auipc	ra,0x4
    8000237e:	d8e080e7          	jalr	-626(ra) # 80006108 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002382:	00015797          	auipc	a5,0x15
    80002386:	d1678793          	addi	a5,a5,-746 # 80017098 <bcache+0x8000>
    8000238a:	00015717          	auipc	a4,0x15
    8000238e:	f7670713          	addi	a4,a4,-138 # 80017300 <bcache+0x8268>
    80002392:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002396:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000239a:	0000d497          	auipc	s1,0xd
    8000239e:	d1648493          	addi	s1,s1,-746 # 8000f0b0 <bcache+0x18>
    b->next = bcache.head.next;
    800023a2:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800023a4:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800023a6:	00006a17          	auipc	s4,0x6
    800023aa:	272a0a13          	addi	s4,s4,626 # 80008618 <syscall_names+0xc8>
    b->next = bcache.head.next;
    800023ae:	2b893783          	ld	a5,696(s2)
    800023b2:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800023b4:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800023b8:	85d2                	mv	a1,s4
    800023ba:	01048513          	addi	a0,s1,16
    800023be:	00001097          	auipc	ra,0x1
    800023c2:	4c2080e7          	jalr	1218(ra) # 80003880 <initsleeplock>
    bcache.head.next->prev = b;
    800023c6:	2b893783          	ld	a5,696(s2)
    800023ca:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800023cc:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023d0:	45848493          	addi	s1,s1,1112
    800023d4:	fd349de3          	bne	s1,s3,800023ae <binit+0x54>
  }
}
    800023d8:	70a2                	ld	ra,40(sp)
    800023da:	7402                	ld	s0,32(sp)
    800023dc:	64e2                	ld	s1,24(sp)
    800023de:	6942                	ld	s2,16(sp)
    800023e0:	69a2                	ld	s3,8(sp)
    800023e2:	6a02                	ld	s4,0(sp)
    800023e4:	6145                	addi	sp,sp,48
    800023e6:	8082                	ret

00000000800023e8 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800023e8:	7179                	addi	sp,sp,-48
    800023ea:	f406                	sd	ra,40(sp)
    800023ec:	f022                	sd	s0,32(sp)
    800023ee:	ec26                	sd	s1,24(sp)
    800023f0:	e84a                	sd	s2,16(sp)
    800023f2:	e44e                	sd	s3,8(sp)
    800023f4:	1800                	addi	s0,sp,48
    800023f6:	892a                	mv	s2,a0
    800023f8:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800023fa:	0000d517          	auipc	a0,0xd
    800023fe:	c9e50513          	addi	a0,a0,-866 # 8000f098 <bcache>
    80002402:	00004097          	auipc	ra,0x4
    80002406:	d96080e7          	jalr	-618(ra) # 80006198 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000240a:	00015497          	auipc	s1,0x15
    8000240e:	f464b483          	ld	s1,-186(s1) # 80017350 <bcache+0x82b8>
    80002412:	00015797          	auipc	a5,0x15
    80002416:	eee78793          	addi	a5,a5,-274 # 80017300 <bcache+0x8268>
    8000241a:	02f48f63          	beq	s1,a5,80002458 <bread+0x70>
    8000241e:	873e                	mv	a4,a5
    80002420:	a021                	j	80002428 <bread+0x40>
    80002422:	68a4                	ld	s1,80(s1)
    80002424:	02e48a63          	beq	s1,a4,80002458 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002428:	449c                	lw	a5,8(s1)
    8000242a:	ff279ce3          	bne	a5,s2,80002422 <bread+0x3a>
    8000242e:	44dc                	lw	a5,12(s1)
    80002430:	ff3799e3          	bne	a5,s3,80002422 <bread+0x3a>
      b->refcnt++;
    80002434:	40bc                	lw	a5,64(s1)
    80002436:	2785                	addiw	a5,a5,1
    80002438:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000243a:	0000d517          	auipc	a0,0xd
    8000243e:	c5e50513          	addi	a0,a0,-930 # 8000f098 <bcache>
    80002442:	00004097          	auipc	ra,0x4
    80002446:	e0a080e7          	jalr	-502(ra) # 8000624c <release>
      acquiresleep(&b->lock);
    8000244a:	01048513          	addi	a0,s1,16
    8000244e:	00001097          	auipc	ra,0x1
    80002452:	46c080e7          	jalr	1132(ra) # 800038ba <acquiresleep>
      return b;
    80002456:	a8b9                	j	800024b4 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002458:	00015497          	auipc	s1,0x15
    8000245c:	ef04b483          	ld	s1,-272(s1) # 80017348 <bcache+0x82b0>
    80002460:	00015797          	auipc	a5,0x15
    80002464:	ea078793          	addi	a5,a5,-352 # 80017300 <bcache+0x8268>
    80002468:	00f48863          	beq	s1,a5,80002478 <bread+0x90>
    8000246c:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000246e:	40bc                	lw	a5,64(s1)
    80002470:	cf81                	beqz	a5,80002488 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002472:	64a4                	ld	s1,72(s1)
    80002474:	fee49de3          	bne	s1,a4,8000246e <bread+0x86>
  panic("bget: no buffers");
    80002478:	00006517          	auipc	a0,0x6
    8000247c:	1a850513          	addi	a0,a0,424 # 80008620 <syscall_names+0xd0>
    80002480:	00003097          	auipc	ra,0x3
    80002484:	7e0080e7          	jalr	2016(ra) # 80005c60 <panic>
      b->dev = dev;
    80002488:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000248c:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002490:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002494:	4785                	li	a5,1
    80002496:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002498:	0000d517          	auipc	a0,0xd
    8000249c:	c0050513          	addi	a0,a0,-1024 # 8000f098 <bcache>
    800024a0:	00004097          	auipc	ra,0x4
    800024a4:	dac080e7          	jalr	-596(ra) # 8000624c <release>
      acquiresleep(&b->lock);
    800024a8:	01048513          	addi	a0,s1,16
    800024ac:	00001097          	auipc	ra,0x1
    800024b0:	40e080e7          	jalr	1038(ra) # 800038ba <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800024b4:	409c                	lw	a5,0(s1)
    800024b6:	cb89                	beqz	a5,800024c8 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800024b8:	8526                	mv	a0,s1
    800024ba:	70a2                	ld	ra,40(sp)
    800024bc:	7402                	ld	s0,32(sp)
    800024be:	64e2                	ld	s1,24(sp)
    800024c0:	6942                	ld	s2,16(sp)
    800024c2:	69a2                	ld	s3,8(sp)
    800024c4:	6145                	addi	sp,sp,48
    800024c6:	8082                	ret
    virtio_disk_rw(b, 0);
    800024c8:	4581                	li	a1,0
    800024ca:	8526                	mv	a0,s1
    800024cc:	00003097          	auipc	ra,0x3
    800024d0:	f26080e7          	jalr	-218(ra) # 800053f2 <virtio_disk_rw>
    b->valid = 1;
    800024d4:	4785                	li	a5,1
    800024d6:	c09c                	sw	a5,0(s1)
  return b;
    800024d8:	b7c5                	j	800024b8 <bread+0xd0>

00000000800024da <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800024da:	1101                	addi	sp,sp,-32
    800024dc:	ec06                	sd	ra,24(sp)
    800024de:	e822                	sd	s0,16(sp)
    800024e0:	e426                	sd	s1,8(sp)
    800024e2:	1000                	addi	s0,sp,32
    800024e4:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024e6:	0541                	addi	a0,a0,16
    800024e8:	00001097          	auipc	ra,0x1
    800024ec:	46c080e7          	jalr	1132(ra) # 80003954 <holdingsleep>
    800024f0:	cd01                	beqz	a0,80002508 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800024f2:	4585                	li	a1,1
    800024f4:	8526                	mv	a0,s1
    800024f6:	00003097          	auipc	ra,0x3
    800024fa:	efc080e7          	jalr	-260(ra) # 800053f2 <virtio_disk_rw>
}
    800024fe:	60e2                	ld	ra,24(sp)
    80002500:	6442                	ld	s0,16(sp)
    80002502:	64a2                	ld	s1,8(sp)
    80002504:	6105                	addi	sp,sp,32
    80002506:	8082                	ret
    panic("bwrite");
    80002508:	00006517          	auipc	a0,0x6
    8000250c:	13050513          	addi	a0,a0,304 # 80008638 <syscall_names+0xe8>
    80002510:	00003097          	auipc	ra,0x3
    80002514:	750080e7          	jalr	1872(ra) # 80005c60 <panic>

0000000080002518 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002518:	1101                	addi	sp,sp,-32
    8000251a:	ec06                	sd	ra,24(sp)
    8000251c:	e822                	sd	s0,16(sp)
    8000251e:	e426                	sd	s1,8(sp)
    80002520:	e04a                	sd	s2,0(sp)
    80002522:	1000                	addi	s0,sp,32
    80002524:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002526:	01050913          	addi	s2,a0,16
    8000252a:	854a                	mv	a0,s2
    8000252c:	00001097          	auipc	ra,0x1
    80002530:	428080e7          	jalr	1064(ra) # 80003954 <holdingsleep>
    80002534:	c92d                	beqz	a0,800025a6 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002536:	854a                	mv	a0,s2
    80002538:	00001097          	auipc	ra,0x1
    8000253c:	3d8080e7          	jalr	984(ra) # 80003910 <releasesleep>

  acquire(&bcache.lock);
    80002540:	0000d517          	auipc	a0,0xd
    80002544:	b5850513          	addi	a0,a0,-1192 # 8000f098 <bcache>
    80002548:	00004097          	auipc	ra,0x4
    8000254c:	c50080e7          	jalr	-944(ra) # 80006198 <acquire>
  b->refcnt--;
    80002550:	40bc                	lw	a5,64(s1)
    80002552:	37fd                	addiw	a5,a5,-1
    80002554:	0007871b          	sext.w	a4,a5
    80002558:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000255a:	eb05                	bnez	a4,8000258a <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000255c:	68bc                	ld	a5,80(s1)
    8000255e:	64b8                	ld	a4,72(s1)
    80002560:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002562:	64bc                	ld	a5,72(s1)
    80002564:	68b8                	ld	a4,80(s1)
    80002566:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002568:	00015797          	auipc	a5,0x15
    8000256c:	b3078793          	addi	a5,a5,-1232 # 80017098 <bcache+0x8000>
    80002570:	2b87b703          	ld	a4,696(a5)
    80002574:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002576:	00015717          	auipc	a4,0x15
    8000257a:	d8a70713          	addi	a4,a4,-630 # 80017300 <bcache+0x8268>
    8000257e:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002580:	2b87b703          	ld	a4,696(a5)
    80002584:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002586:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000258a:	0000d517          	auipc	a0,0xd
    8000258e:	b0e50513          	addi	a0,a0,-1266 # 8000f098 <bcache>
    80002592:	00004097          	auipc	ra,0x4
    80002596:	cba080e7          	jalr	-838(ra) # 8000624c <release>
}
    8000259a:	60e2                	ld	ra,24(sp)
    8000259c:	6442                	ld	s0,16(sp)
    8000259e:	64a2                	ld	s1,8(sp)
    800025a0:	6902                	ld	s2,0(sp)
    800025a2:	6105                	addi	sp,sp,32
    800025a4:	8082                	ret
    panic("brelse");
    800025a6:	00006517          	auipc	a0,0x6
    800025aa:	09a50513          	addi	a0,a0,154 # 80008640 <syscall_names+0xf0>
    800025ae:	00003097          	auipc	ra,0x3
    800025b2:	6b2080e7          	jalr	1714(ra) # 80005c60 <panic>

00000000800025b6 <bpin>:

void
bpin(struct buf *b) {
    800025b6:	1101                	addi	sp,sp,-32
    800025b8:	ec06                	sd	ra,24(sp)
    800025ba:	e822                	sd	s0,16(sp)
    800025bc:	e426                	sd	s1,8(sp)
    800025be:	1000                	addi	s0,sp,32
    800025c0:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025c2:	0000d517          	auipc	a0,0xd
    800025c6:	ad650513          	addi	a0,a0,-1322 # 8000f098 <bcache>
    800025ca:	00004097          	auipc	ra,0x4
    800025ce:	bce080e7          	jalr	-1074(ra) # 80006198 <acquire>
  b->refcnt++;
    800025d2:	40bc                	lw	a5,64(s1)
    800025d4:	2785                	addiw	a5,a5,1
    800025d6:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025d8:	0000d517          	auipc	a0,0xd
    800025dc:	ac050513          	addi	a0,a0,-1344 # 8000f098 <bcache>
    800025e0:	00004097          	auipc	ra,0x4
    800025e4:	c6c080e7          	jalr	-916(ra) # 8000624c <release>
}
    800025e8:	60e2                	ld	ra,24(sp)
    800025ea:	6442                	ld	s0,16(sp)
    800025ec:	64a2                	ld	s1,8(sp)
    800025ee:	6105                	addi	sp,sp,32
    800025f0:	8082                	ret

00000000800025f2 <bunpin>:

void
bunpin(struct buf *b) {
    800025f2:	1101                	addi	sp,sp,-32
    800025f4:	ec06                	sd	ra,24(sp)
    800025f6:	e822                	sd	s0,16(sp)
    800025f8:	e426                	sd	s1,8(sp)
    800025fa:	1000                	addi	s0,sp,32
    800025fc:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025fe:	0000d517          	auipc	a0,0xd
    80002602:	a9a50513          	addi	a0,a0,-1382 # 8000f098 <bcache>
    80002606:	00004097          	auipc	ra,0x4
    8000260a:	b92080e7          	jalr	-1134(ra) # 80006198 <acquire>
  b->refcnt--;
    8000260e:	40bc                	lw	a5,64(s1)
    80002610:	37fd                	addiw	a5,a5,-1
    80002612:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002614:	0000d517          	auipc	a0,0xd
    80002618:	a8450513          	addi	a0,a0,-1404 # 8000f098 <bcache>
    8000261c:	00004097          	auipc	ra,0x4
    80002620:	c30080e7          	jalr	-976(ra) # 8000624c <release>
}
    80002624:	60e2                	ld	ra,24(sp)
    80002626:	6442                	ld	s0,16(sp)
    80002628:	64a2                	ld	s1,8(sp)
    8000262a:	6105                	addi	sp,sp,32
    8000262c:	8082                	ret

000000008000262e <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000262e:	1101                	addi	sp,sp,-32
    80002630:	ec06                	sd	ra,24(sp)
    80002632:	e822                	sd	s0,16(sp)
    80002634:	e426                	sd	s1,8(sp)
    80002636:	e04a                	sd	s2,0(sp)
    80002638:	1000                	addi	s0,sp,32
    8000263a:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000263c:	00d5d59b          	srliw	a1,a1,0xd
    80002640:	00015797          	auipc	a5,0x15
    80002644:	1347a783          	lw	a5,308(a5) # 80017774 <sb+0x1c>
    80002648:	9dbd                	addw	a1,a1,a5
    8000264a:	00000097          	auipc	ra,0x0
    8000264e:	d9e080e7          	jalr	-610(ra) # 800023e8 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002652:	0074f713          	andi	a4,s1,7
    80002656:	4785                	li	a5,1
    80002658:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000265c:	14ce                	slli	s1,s1,0x33
    8000265e:	90d9                	srli	s1,s1,0x36
    80002660:	00950733          	add	a4,a0,s1
    80002664:	05874703          	lbu	a4,88(a4)
    80002668:	00e7f6b3          	and	a3,a5,a4
    8000266c:	c69d                	beqz	a3,8000269a <bfree+0x6c>
    8000266e:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002670:	94aa                	add	s1,s1,a0
    80002672:	fff7c793          	not	a5,a5
    80002676:	8f7d                	and	a4,a4,a5
    80002678:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000267c:	00001097          	auipc	ra,0x1
    80002680:	120080e7          	jalr	288(ra) # 8000379c <log_write>
  brelse(bp);
    80002684:	854a                	mv	a0,s2
    80002686:	00000097          	auipc	ra,0x0
    8000268a:	e92080e7          	jalr	-366(ra) # 80002518 <brelse>
}
    8000268e:	60e2                	ld	ra,24(sp)
    80002690:	6442                	ld	s0,16(sp)
    80002692:	64a2                	ld	s1,8(sp)
    80002694:	6902                	ld	s2,0(sp)
    80002696:	6105                	addi	sp,sp,32
    80002698:	8082                	ret
    panic("freeing free block");
    8000269a:	00006517          	auipc	a0,0x6
    8000269e:	fae50513          	addi	a0,a0,-82 # 80008648 <syscall_names+0xf8>
    800026a2:	00003097          	auipc	ra,0x3
    800026a6:	5be080e7          	jalr	1470(ra) # 80005c60 <panic>

00000000800026aa <balloc>:
{
    800026aa:	711d                	addi	sp,sp,-96
    800026ac:	ec86                	sd	ra,88(sp)
    800026ae:	e8a2                	sd	s0,80(sp)
    800026b0:	e4a6                	sd	s1,72(sp)
    800026b2:	e0ca                	sd	s2,64(sp)
    800026b4:	fc4e                	sd	s3,56(sp)
    800026b6:	f852                	sd	s4,48(sp)
    800026b8:	f456                	sd	s5,40(sp)
    800026ba:	f05a                	sd	s6,32(sp)
    800026bc:	ec5e                	sd	s7,24(sp)
    800026be:	e862                	sd	s8,16(sp)
    800026c0:	e466                	sd	s9,8(sp)
    800026c2:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800026c4:	00015797          	auipc	a5,0x15
    800026c8:	0987a783          	lw	a5,152(a5) # 8001775c <sb+0x4>
    800026cc:	cbc1                	beqz	a5,8000275c <balloc+0xb2>
    800026ce:	8baa                	mv	s7,a0
    800026d0:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800026d2:	00015b17          	auipc	s6,0x15
    800026d6:	086b0b13          	addi	s6,s6,134 # 80017758 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026da:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800026dc:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026de:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800026e0:	6c89                	lui	s9,0x2
    800026e2:	a831                	j	800026fe <balloc+0x54>
    brelse(bp);
    800026e4:	854a                	mv	a0,s2
    800026e6:	00000097          	auipc	ra,0x0
    800026ea:	e32080e7          	jalr	-462(ra) # 80002518 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800026ee:	015c87bb          	addw	a5,s9,s5
    800026f2:	00078a9b          	sext.w	s5,a5
    800026f6:	004b2703          	lw	a4,4(s6)
    800026fa:	06eaf163          	bgeu	s5,a4,8000275c <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    800026fe:	41fad79b          	sraiw	a5,s5,0x1f
    80002702:	0137d79b          	srliw	a5,a5,0x13
    80002706:	015787bb          	addw	a5,a5,s5
    8000270a:	40d7d79b          	sraiw	a5,a5,0xd
    8000270e:	01cb2583          	lw	a1,28(s6)
    80002712:	9dbd                	addw	a1,a1,a5
    80002714:	855e                	mv	a0,s7
    80002716:	00000097          	auipc	ra,0x0
    8000271a:	cd2080e7          	jalr	-814(ra) # 800023e8 <bread>
    8000271e:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002720:	004b2503          	lw	a0,4(s6)
    80002724:	000a849b          	sext.w	s1,s5
    80002728:	8762                	mv	a4,s8
    8000272a:	faa4fde3          	bgeu	s1,a0,800026e4 <balloc+0x3a>
      m = 1 << (bi % 8);
    8000272e:	00777693          	andi	a3,a4,7
    80002732:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002736:	41f7579b          	sraiw	a5,a4,0x1f
    8000273a:	01d7d79b          	srliw	a5,a5,0x1d
    8000273e:	9fb9                	addw	a5,a5,a4
    80002740:	4037d79b          	sraiw	a5,a5,0x3
    80002744:	00f90633          	add	a2,s2,a5
    80002748:	05864603          	lbu	a2,88(a2)
    8000274c:	00c6f5b3          	and	a1,a3,a2
    80002750:	cd91                	beqz	a1,8000276c <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002752:	2705                	addiw	a4,a4,1
    80002754:	2485                	addiw	s1,s1,1
    80002756:	fd471ae3          	bne	a4,s4,8000272a <balloc+0x80>
    8000275a:	b769                	j	800026e4 <balloc+0x3a>
  panic("balloc: out of blocks");
    8000275c:	00006517          	auipc	a0,0x6
    80002760:	f0450513          	addi	a0,a0,-252 # 80008660 <syscall_names+0x110>
    80002764:	00003097          	auipc	ra,0x3
    80002768:	4fc080e7          	jalr	1276(ra) # 80005c60 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000276c:	97ca                	add	a5,a5,s2
    8000276e:	8e55                	or	a2,a2,a3
    80002770:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002774:	854a                	mv	a0,s2
    80002776:	00001097          	auipc	ra,0x1
    8000277a:	026080e7          	jalr	38(ra) # 8000379c <log_write>
        brelse(bp);
    8000277e:	854a                	mv	a0,s2
    80002780:	00000097          	auipc	ra,0x0
    80002784:	d98080e7          	jalr	-616(ra) # 80002518 <brelse>
  bp = bread(dev, bno);
    80002788:	85a6                	mv	a1,s1
    8000278a:	855e                	mv	a0,s7
    8000278c:	00000097          	auipc	ra,0x0
    80002790:	c5c080e7          	jalr	-932(ra) # 800023e8 <bread>
    80002794:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002796:	40000613          	li	a2,1024
    8000279a:	4581                	li	a1,0
    8000279c:	05850513          	addi	a0,a0,88
    800027a0:	ffffe097          	auipc	ra,0xffffe
    800027a4:	a24080e7          	jalr	-1500(ra) # 800001c4 <memset>
  log_write(bp);
    800027a8:	854a                	mv	a0,s2
    800027aa:	00001097          	auipc	ra,0x1
    800027ae:	ff2080e7          	jalr	-14(ra) # 8000379c <log_write>
  brelse(bp);
    800027b2:	854a                	mv	a0,s2
    800027b4:	00000097          	auipc	ra,0x0
    800027b8:	d64080e7          	jalr	-668(ra) # 80002518 <brelse>
}
    800027bc:	8526                	mv	a0,s1
    800027be:	60e6                	ld	ra,88(sp)
    800027c0:	6446                	ld	s0,80(sp)
    800027c2:	64a6                	ld	s1,72(sp)
    800027c4:	6906                	ld	s2,64(sp)
    800027c6:	79e2                	ld	s3,56(sp)
    800027c8:	7a42                	ld	s4,48(sp)
    800027ca:	7aa2                	ld	s5,40(sp)
    800027cc:	7b02                	ld	s6,32(sp)
    800027ce:	6be2                	ld	s7,24(sp)
    800027d0:	6c42                	ld	s8,16(sp)
    800027d2:	6ca2                	ld	s9,8(sp)
    800027d4:	6125                	addi	sp,sp,96
    800027d6:	8082                	ret

00000000800027d8 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800027d8:	7179                	addi	sp,sp,-48
    800027da:	f406                	sd	ra,40(sp)
    800027dc:	f022                	sd	s0,32(sp)
    800027de:	ec26                	sd	s1,24(sp)
    800027e0:	e84a                	sd	s2,16(sp)
    800027e2:	e44e                	sd	s3,8(sp)
    800027e4:	e052                	sd	s4,0(sp)
    800027e6:	1800                	addi	s0,sp,48
    800027e8:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800027ea:	47ad                	li	a5,11
    800027ec:	04b7fe63          	bgeu	a5,a1,80002848 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800027f0:	ff45849b          	addiw	s1,a1,-12
    800027f4:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800027f8:	0ff00793          	li	a5,255
    800027fc:	0ae7e463          	bltu	a5,a4,800028a4 <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002800:	08052583          	lw	a1,128(a0)
    80002804:	c5b5                	beqz	a1,80002870 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002806:	00092503          	lw	a0,0(s2)
    8000280a:	00000097          	auipc	ra,0x0
    8000280e:	bde080e7          	jalr	-1058(ra) # 800023e8 <bread>
    80002812:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002814:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002818:	02049713          	slli	a4,s1,0x20
    8000281c:	01e75593          	srli	a1,a4,0x1e
    80002820:	00b784b3          	add	s1,a5,a1
    80002824:	0004a983          	lw	s3,0(s1)
    80002828:	04098e63          	beqz	s3,80002884 <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    8000282c:	8552                	mv	a0,s4
    8000282e:	00000097          	auipc	ra,0x0
    80002832:	cea080e7          	jalr	-790(ra) # 80002518 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002836:	854e                	mv	a0,s3
    80002838:	70a2                	ld	ra,40(sp)
    8000283a:	7402                	ld	s0,32(sp)
    8000283c:	64e2                	ld	s1,24(sp)
    8000283e:	6942                	ld	s2,16(sp)
    80002840:	69a2                	ld	s3,8(sp)
    80002842:	6a02                	ld	s4,0(sp)
    80002844:	6145                	addi	sp,sp,48
    80002846:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002848:	02059793          	slli	a5,a1,0x20
    8000284c:	01e7d593          	srli	a1,a5,0x1e
    80002850:	00b504b3          	add	s1,a0,a1
    80002854:	0504a983          	lw	s3,80(s1)
    80002858:	fc099fe3          	bnez	s3,80002836 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    8000285c:	4108                	lw	a0,0(a0)
    8000285e:	00000097          	auipc	ra,0x0
    80002862:	e4c080e7          	jalr	-436(ra) # 800026aa <balloc>
    80002866:	0005099b          	sext.w	s3,a0
    8000286a:	0534a823          	sw	s3,80(s1)
    8000286e:	b7e1                	j	80002836 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002870:	4108                	lw	a0,0(a0)
    80002872:	00000097          	auipc	ra,0x0
    80002876:	e38080e7          	jalr	-456(ra) # 800026aa <balloc>
    8000287a:	0005059b          	sext.w	a1,a0
    8000287e:	08b92023          	sw	a1,128(s2)
    80002882:	b751                	j	80002806 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002884:	00092503          	lw	a0,0(s2)
    80002888:	00000097          	auipc	ra,0x0
    8000288c:	e22080e7          	jalr	-478(ra) # 800026aa <balloc>
    80002890:	0005099b          	sext.w	s3,a0
    80002894:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002898:	8552                	mv	a0,s4
    8000289a:	00001097          	auipc	ra,0x1
    8000289e:	f02080e7          	jalr	-254(ra) # 8000379c <log_write>
    800028a2:	b769                	j	8000282c <bmap+0x54>
  panic("bmap: out of range");
    800028a4:	00006517          	auipc	a0,0x6
    800028a8:	dd450513          	addi	a0,a0,-556 # 80008678 <syscall_names+0x128>
    800028ac:	00003097          	auipc	ra,0x3
    800028b0:	3b4080e7          	jalr	948(ra) # 80005c60 <panic>

00000000800028b4 <iget>:
{
    800028b4:	7179                	addi	sp,sp,-48
    800028b6:	f406                	sd	ra,40(sp)
    800028b8:	f022                	sd	s0,32(sp)
    800028ba:	ec26                	sd	s1,24(sp)
    800028bc:	e84a                	sd	s2,16(sp)
    800028be:	e44e                	sd	s3,8(sp)
    800028c0:	e052                	sd	s4,0(sp)
    800028c2:	1800                	addi	s0,sp,48
    800028c4:	89aa                	mv	s3,a0
    800028c6:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800028c8:	00015517          	auipc	a0,0x15
    800028cc:	eb050513          	addi	a0,a0,-336 # 80017778 <itable>
    800028d0:	00004097          	auipc	ra,0x4
    800028d4:	8c8080e7          	jalr	-1848(ra) # 80006198 <acquire>
  empty = 0;
    800028d8:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028da:	00015497          	auipc	s1,0x15
    800028de:	eb648493          	addi	s1,s1,-330 # 80017790 <itable+0x18>
    800028e2:	00017697          	auipc	a3,0x17
    800028e6:	93e68693          	addi	a3,a3,-1730 # 80019220 <log>
    800028ea:	a039                	j	800028f8 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028ec:	02090b63          	beqz	s2,80002922 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028f0:	08848493          	addi	s1,s1,136
    800028f4:	02d48a63          	beq	s1,a3,80002928 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800028f8:	449c                	lw	a5,8(s1)
    800028fa:	fef059e3          	blez	a5,800028ec <iget+0x38>
    800028fe:	4098                	lw	a4,0(s1)
    80002900:	ff3716e3          	bne	a4,s3,800028ec <iget+0x38>
    80002904:	40d8                	lw	a4,4(s1)
    80002906:	ff4713e3          	bne	a4,s4,800028ec <iget+0x38>
      ip->ref++;
    8000290a:	2785                	addiw	a5,a5,1
    8000290c:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000290e:	00015517          	auipc	a0,0x15
    80002912:	e6a50513          	addi	a0,a0,-406 # 80017778 <itable>
    80002916:	00004097          	auipc	ra,0x4
    8000291a:	936080e7          	jalr	-1738(ra) # 8000624c <release>
      return ip;
    8000291e:	8926                	mv	s2,s1
    80002920:	a03d                	j	8000294e <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002922:	f7f9                	bnez	a5,800028f0 <iget+0x3c>
    80002924:	8926                	mv	s2,s1
    80002926:	b7e9                	j	800028f0 <iget+0x3c>
  if(empty == 0)
    80002928:	02090c63          	beqz	s2,80002960 <iget+0xac>
  ip->dev = dev;
    8000292c:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002930:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002934:	4785                	li	a5,1
    80002936:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000293a:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000293e:	00015517          	auipc	a0,0x15
    80002942:	e3a50513          	addi	a0,a0,-454 # 80017778 <itable>
    80002946:	00004097          	auipc	ra,0x4
    8000294a:	906080e7          	jalr	-1786(ra) # 8000624c <release>
}
    8000294e:	854a                	mv	a0,s2
    80002950:	70a2                	ld	ra,40(sp)
    80002952:	7402                	ld	s0,32(sp)
    80002954:	64e2                	ld	s1,24(sp)
    80002956:	6942                	ld	s2,16(sp)
    80002958:	69a2                	ld	s3,8(sp)
    8000295a:	6a02                	ld	s4,0(sp)
    8000295c:	6145                	addi	sp,sp,48
    8000295e:	8082                	ret
    panic("iget: no inodes");
    80002960:	00006517          	auipc	a0,0x6
    80002964:	d3050513          	addi	a0,a0,-720 # 80008690 <syscall_names+0x140>
    80002968:	00003097          	auipc	ra,0x3
    8000296c:	2f8080e7          	jalr	760(ra) # 80005c60 <panic>

0000000080002970 <fsinit>:
fsinit(int dev) {
    80002970:	7179                	addi	sp,sp,-48
    80002972:	f406                	sd	ra,40(sp)
    80002974:	f022                	sd	s0,32(sp)
    80002976:	ec26                	sd	s1,24(sp)
    80002978:	e84a                	sd	s2,16(sp)
    8000297a:	e44e                	sd	s3,8(sp)
    8000297c:	1800                	addi	s0,sp,48
    8000297e:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002980:	4585                	li	a1,1
    80002982:	00000097          	auipc	ra,0x0
    80002986:	a66080e7          	jalr	-1434(ra) # 800023e8 <bread>
    8000298a:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000298c:	00015997          	auipc	s3,0x15
    80002990:	dcc98993          	addi	s3,s3,-564 # 80017758 <sb>
    80002994:	02000613          	li	a2,32
    80002998:	05850593          	addi	a1,a0,88
    8000299c:	854e                	mv	a0,s3
    8000299e:	ffffe097          	auipc	ra,0xffffe
    800029a2:	882080e7          	jalr	-1918(ra) # 80000220 <memmove>
  brelse(bp);
    800029a6:	8526                	mv	a0,s1
    800029a8:	00000097          	auipc	ra,0x0
    800029ac:	b70080e7          	jalr	-1168(ra) # 80002518 <brelse>
  if(sb.magic != FSMAGIC)
    800029b0:	0009a703          	lw	a4,0(s3)
    800029b4:	102037b7          	lui	a5,0x10203
    800029b8:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800029bc:	02f71263          	bne	a4,a5,800029e0 <fsinit+0x70>
  initlog(dev, &sb);
    800029c0:	00015597          	auipc	a1,0x15
    800029c4:	d9858593          	addi	a1,a1,-616 # 80017758 <sb>
    800029c8:	854a                	mv	a0,s2
    800029ca:	00001097          	auipc	ra,0x1
    800029ce:	b56080e7          	jalr	-1194(ra) # 80003520 <initlog>
}
    800029d2:	70a2                	ld	ra,40(sp)
    800029d4:	7402                	ld	s0,32(sp)
    800029d6:	64e2                	ld	s1,24(sp)
    800029d8:	6942                	ld	s2,16(sp)
    800029da:	69a2                	ld	s3,8(sp)
    800029dc:	6145                	addi	sp,sp,48
    800029de:	8082                	ret
    panic("invalid file system");
    800029e0:	00006517          	auipc	a0,0x6
    800029e4:	cc050513          	addi	a0,a0,-832 # 800086a0 <syscall_names+0x150>
    800029e8:	00003097          	auipc	ra,0x3
    800029ec:	278080e7          	jalr	632(ra) # 80005c60 <panic>

00000000800029f0 <iinit>:
{
    800029f0:	7179                	addi	sp,sp,-48
    800029f2:	f406                	sd	ra,40(sp)
    800029f4:	f022                	sd	s0,32(sp)
    800029f6:	ec26                	sd	s1,24(sp)
    800029f8:	e84a                	sd	s2,16(sp)
    800029fa:	e44e                	sd	s3,8(sp)
    800029fc:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800029fe:	00006597          	auipc	a1,0x6
    80002a02:	cba58593          	addi	a1,a1,-838 # 800086b8 <syscall_names+0x168>
    80002a06:	00015517          	auipc	a0,0x15
    80002a0a:	d7250513          	addi	a0,a0,-654 # 80017778 <itable>
    80002a0e:	00003097          	auipc	ra,0x3
    80002a12:	6fa080e7          	jalr	1786(ra) # 80006108 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002a16:	00015497          	auipc	s1,0x15
    80002a1a:	d8a48493          	addi	s1,s1,-630 # 800177a0 <itable+0x28>
    80002a1e:	00017997          	auipc	s3,0x17
    80002a22:	81298993          	addi	s3,s3,-2030 # 80019230 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002a26:	00006917          	auipc	s2,0x6
    80002a2a:	c9a90913          	addi	s2,s2,-870 # 800086c0 <syscall_names+0x170>
    80002a2e:	85ca                	mv	a1,s2
    80002a30:	8526                	mv	a0,s1
    80002a32:	00001097          	auipc	ra,0x1
    80002a36:	e4e080e7          	jalr	-434(ra) # 80003880 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002a3a:	08848493          	addi	s1,s1,136
    80002a3e:	ff3498e3          	bne	s1,s3,80002a2e <iinit+0x3e>
}
    80002a42:	70a2                	ld	ra,40(sp)
    80002a44:	7402                	ld	s0,32(sp)
    80002a46:	64e2                	ld	s1,24(sp)
    80002a48:	6942                	ld	s2,16(sp)
    80002a4a:	69a2                	ld	s3,8(sp)
    80002a4c:	6145                	addi	sp,sp,48
    80002a4e:	8082                	ret

0000000080002a50 <ialloc>:
{
    80002a50:	715d                	addi	sp,sp,-80
    80002a52:	e486                	sd	ra,72(sp)
    80002a54:	e0a2                	sd	s0,64(sp)
    80002a56:	fc26                	sd	s1,56(sp)
    80002a58:	f84a                	sd	s2,48(sp)
    80002a5a:	f44e                	sd	s3,40(sp)
    80002a5c:	f052                	sd	s4,32(sp)
    80002a5e:	ec56                	sd	s5,24(sp)
    80002a60:	e85a                	sd	s6,16(sp)
    80002a62:	e45e                	sd	s7,8(sp)
    80002a64:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a66:	00015717          	auipc	a4,0x15
    80002a6a:	cfe72703          	lw	a4,-770(a4) # 80017764 <sb+0xc>
    80002a6e:	4785                	li	a5,1
    80002a70:	04e7fa63          	bgeu	a5,a4,80002ac4 <ialloc+0x74>
    80002a74:	8aaa                	mv	s5,a0
    80002a76:	8bae                	mv	s7,a1
    80002a78:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002a7a:	00015a17          	auipc	s4,0x15
    80002a7e:	cdea0a13          	addi	s4,s4,-802 # 80017758 <sb>
    80002a82:	00048b1b          	sext.w	s6,s1
    80002a86:	0044d593          	srli	a1,s1,0x4
    80002a8a:	018a2783          	lw	a5,24(s4)
    80002a8e:	9dbd                	addw	a1,a1,a5
    80002a90:	8556                	mv	a0,s5
    80002a92:	00000097          	auipc	ra,0x0
    80002a96:	956080e7          	jalr	-1706(ra) # 800023e8 <bread>
    80002a9a:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002a9c:	05850993          	addi	s3,a0,88
    80002aa0:	00f4f793          	andi	a5,s1,15
    80002aa4:	079a                	slli	a5,a5,0x6
    80002aa6:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002aa8:	00099783          	lh	a5,0(s3)
    80002aac:	c785                	beqz	a5,80002ad4 <ialloc+0x84>
    brelse(bp);
    80002aae:	00000097          	auipc	ra,0x0
    80002ab2:	a6a080e7          	jalr	-1430(ra) # 80002518 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002ab6:	0485                	addi	s1,s1,1
    80002ab8:	00ca2703          	lw	a4,12(s4)
    80002abc:	0004879b          	sext.w	a5,s1
    80002ac0:	fce7e1e3          	bltu	a5,a4,80002a82 <ialloc+0x32>
  panic("ialloc: no inodes");
    80002ac4:	00006517          	auipc	a0,0x6
    80002ac8:	c0450513          	addi	a0,a0,-1020 # 800086c8 <syscall_names+0x178>
    80002acc:	00003097          	auipc	ra,0x3
    80002ad0:	194080e7          	jalr	404(ra) # 80005c60 <panic>
      memset(dip, 0, sizeof(*dip));
    80002ad4:	04000613          	li	a2,64
    80002ad8:	4581                	li	a1,0
    80002ada:	854e                	mv	a0,s3
    80002adc:	ffffd097          	auipc	ra,0xffffd
    80002ae0:	6e8080e7          	jalr	1768(ra) # 800001c4 <memset>
      dip->type = type;
    80002ae4:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002ae8:	854a                	mv	a0,s2
    80002aea:	00001097          	auipc	ra,0x1
    80002aee:	cb2080e7          	jalr	-846(ra) # 8000379c <log_write>
      brelse(bp);
    80002af2:	854a                	mv	a0,s2
    80002af4:	00000097          	auipc	ra,0x0
    80002af8:	a24080e7          	jalr	-1500(ra) # 80002518 <brelse>
      return iget(dev, inum);
    80002afc:	85da                	mv	a1,s6
    80002afe:	8556                	mv	a0,s5
    80002b00:	00000097          	auipc	ra,0x0
    80002b04:	db4080e7          	jalr	-588(ra) # 800028b4 <iget>
}
    80002b08:	60a6                	ld	ra,72(sp)
    80002b0a:	6406                	ld	s0,64(sp)
    80002b0c:	74e2                	ld	s1,56(sp)
    80002b0e:	7942                	ld	s2,48(sp)
    80002b10:	79a2                	ld	s3,40(sp)
    80002b12:	7a02                	ld	s4,32(sp)
    80002b14:	6ae2                	ld	s5,24(sp)
    80002b16:	6b42                	ld	s6,16(sp)
    80002b18:	6ba2                	ld	s7,8(sp)
    80002b1a:	6161                	addi	sp,sp,80
    80002b1c:	8082                	ret

0000000080002b1e <iupdate>:
{
    80002b1e:	1101                	addi	sp,sp,-32
    80002b20:	ec06                	sd	ra,24(sp)
    80002b22:	e822                	sd	s0,16(sp)
    80002b24:	e426                	sd	s1,8(sp)
    80002b26:	e04a                	sd	s2,0(sp)
    80002b28:	1000                	addi	s0,sp,32
    80002b2a:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b2c:	415c                	lw	a5,4(a0)
    80002b2e:	0047d79b          	srliw	a5,a5,0x4
    80002b32:	00015597          	auipc	a1,0x15
    80002b36:	c3e5a583          	lw	a1,-962(a1) # 80017770 <sb+0x18>
    80002b3a:	9dbd                	addw	a1,a1,a5
    80002b3c:	4108                	lw	a0,0(a0)
    80002b3e:	00000097          	auipc	ra,0x0
    80002b42:	8aa080e7          	jalr	-1878(ra) # 800023e8 <bread>
    80002b46:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b48:	05850793          	addi	a5,a0,88
    80002b4c:	40d8                	lw	a4,4(s1)
    80002b4e:	8b3d                	andi	a4,a4,15
    80002b50:	071a                	slli	a4,a4,0x6
    80002b52:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002b54:	04449703          	lh	a4,68(s1)
    80002b58:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002b5c:	04649703          	lh	a4,70(s1)
    80002b60:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002b64:	04849703          	lh	a4,72(s1)
    80002b68:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002b6c:	04a49703          	lh	a4,74(s1)
    80002b70:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002b74:	44f8                	lw	a4,76(s1)
    80002b76:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002b78:	03400613          	li	a2,52
    80002b7c:	05048593          	addi	a1,s1,80
    80002b80:	00c78513          	addi	a0,a5,12
    80002b84:	ffffd097          	auipc	ra,0xffffd
    80002b88:	69c080e7          	jalr	1692(ra) # 80000220 <memmove>
  log_write(bp);
    80002b8c:	854a                	mv	a0,s2
    80002b8e:	00001097          	auipc	ra,0x1
    80002b92:	c0e080e7          	jalr	-1010(ra) # 8000379c <log_write>
  brelse(bp);
    80002b96:	854a                	mv	a0,s2
    80002b98:	00000097          	auipc	ra,0x0
    80002b9c:	980080e7          	jalr	-1664(ra) # 80002518 <brelse>
}
    80002ba0:	60e2                	ld	ra,24(sp)
    80002ba2:	6442                	ld	s0,16(sp)
    80002ba4:	64a2                	ld	s1,8(sp)
    80002ba6:	6902                	ld	s2,0(sp)
    80002ba8:	6105                	addi	sp,sp,32
    80002baa:	8082                	ret

0000000080002bac <idup>:
{
    80002bac:	1101                	addi	sp,sp,-32
    80002bae:	ec06                	sd	ra,24(sp)
    80002bb0:	e822                	sd	s0,16(sp)
    80002bb2:	e426                	sd	s1,8(sp)
    80002bb4:	1000                	addi	s0,sp,32
    80002bb6:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002bb8:	00015517          	auipc	a0,0x15
    80002bbc:	bc050513          	addi	a0,a0,-1088 # 80017778 <itable>
    80002bc0:	00003097          	auipc	ra,0x3
    80002bc4:	5d8080e7          	jalr	1496(ra) # 80006198 <acquire>
  ip->ref++;
    80002bc8:	449c                	lw	a5,8(s1)
    80002bca:	2785                	addiw	a5,a5,1
    80002bcc:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002bce:	00015517          	auipc	a0,0x15
    80002bd2:	baa50513          	addi	a0,a0,-1110 # 80017778 <itable>
    80002bd6:	00003097          	auipc	ra,0x3
    80002bda:	676080e7          	jalr	1654(ra) # 8000624c <release>
}
    80002bde:	8526                	mv	a0,s1
    80002be0:	60e2                	ld	ra,24(sp)
    80002be2:	6442                	ld	s0,16(sp)
    80002be4:	64a2                	ld	s1,8(sp)
    80002be6:	6105                	addi	sp,sp,32
    80002be8:	8082                	ret

0000000080002bea <ilock>:
{
    80002bea:	1101                	addi	sp,sp,-32
    80002bec:	ec06                	sd	ra,24(sp)
    80002bee:	e822                	sd	s0,16(sp)
    80002bf0:	e426                	sd	s1,8(sp)
    80002bf2:	e04a                	sd	s2,0(sp)
    80002bf4:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002bf6:	c115                	beqz	a0,80002c1a <ilock+0x30>
    80002bf8:	84aa                	mv	s1,a0
    80002bfa:	451c                	lw	a5,8(a0)
    80002bfc:	00f05f63          	blez	a5,80002c1a <ilock+0x30>
  acquiresleep(&ip->lock);
    80002c00:	0541                	addi	a0,a0,16
    80002c02:	00001097          	auipc	ra,0x1
    80002c06:	cb8080e7          	jalr	-840(ra) # 800038ba <acquiresleep>
  if(ip->valid == 0){
    80002c0a:	40bc                	lw	a5,64(s1)
    80002c0c:	cf99                	beqz	a5,80002c2a <ilock+0x40>
}
    80002c0e:	60e2                	ld	ra,24(sp)
    80002c10:	6442                	ld	s0,16(sp)
    80002c12:	64a2                	ld	s1,8(sp)
    80002c14:	6902                	ld	s2,0(sp)
    80002c16:	6105                	addi	sp,sp,32
    80002c18:	8082                	ret
    panic("ilock");
    80002c1a:	00006517          	auipc	a0,0x6
    80002c1e:	ac650513          	addi	a0,a0,-1338 # 800086e0 <syscall_names+0x190>
    80002c22:	00003097          	auipc	ra,0x3
    80002c26:	03e080e7          	jalr	62(ra) # 80005c60 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c2a:	40dc                	lw	a5,4(s1)
    80002c2c:	0047d79b          	srliw	a5,a5,0x4
    80002c30:	00015597          	auipc	a1,0x15
    80002c34:	b405a583          	lw	a1,-1216(a1) # 80017770 <sb+0x18>
    80002c38:	9dbd                	addw	a1,a1,a5
    80002c3a:	4088                	lw	a0,0(s1)
    80002c3c:	fffff097          	auipc	ra,0xfffff
    80002c40:	7ac080e7          	jalr	1964(ra) # 800023e8 <bread>
    80002c44:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c46:	05850593          	addi	a1,a0,88
    80002c4a:	40dc                	lw	a5,4(s1)
    80002c4c:	8bbd                	andi	a5,a5,15
    80002c4e:	079a                	slli	a5,a5,0x6
    80002c50:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002c52:	00059783          	lh	a5,0(a1)
    80002c56:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c5a:	00259783          	lh	a5,2(a1)
    80002c5e:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c62:	00459783          	lh	a5,4(a1)
    80002c66:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002c6a:	00659783          	lh	a5,6(a1)
    80002c6e:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002c72:	459c                	lw	a5,8(a1)
    80002c74:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002c76:	03400613          	li	a2,52
    80002c7a:	05b1                	addi	a1,a1,12
    80002c7c:	05048513          	addi	a0,s1,80
    80002c80:	ffffd097          	auipc	ra,0xffffd
    80002c84:	5a0080e7          	jalr	1440(ra) # 80000220 <memmove>
    brelse(bp);
    80002c88:	854a                	mv	a0,s2
    80002c8a:	00000097          	auipc	ra,0x0
    80002c8e:	88e080e7          	jalr	-1906(ra) # 80002518 <brelse>
    ip->valid = 1;
    80002c92:	4785                	li	a5,1
    80002c94:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002c96:	04449783          	lh	a5,68(s1)
    80002c9a:	fbb5                	bnez	a5,80002c0e <ilock+0x24>
      panic("ilock: no type");
    80002c9c:	00006517          	auipc	a0,0x6
    80002ca0:	a4c50513          	addi	a0,a0,-1460 # 800086e8 <syscall_names+0x198>
    80002ca4:	00003097          	auipc	ra,0x3
    80002ca8:	fbc080e7          	jalr	-68(ra) # 80005c60 <panic>

0000000080002cac <iunlock>:
{
    80002cac:	1101                	addi	sp,sp,-32
    80002cae:	ec06                	sd	ra,24(sp)
    80002cb0:	e822                	sd	s0,16(sp)
    80002cb2:	e426                	sd	s1,8(sp)
    80002cb4:	e04a                	sd	s2,0(sp)
    80002cb6:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002cb8:	c905                	beqz	a0,80002ce8 <iunlock+0x3c>
    80002cba:	84aa                	mv	s1,a0
    80002cbc:	01050913          	addi	s2,a0,16
    80002cc0:	854a                	mv	a0,s2
    80002cc2:	00001097          	auipc	ra,0x1
    80002cc6:	c92080e7          	jalr	-878(ra) # 80003954 <holdingsleep>
    80002cca:	cd19                	beqz	a0,80002ce8 <iunlock+0x3c>
    80002ccc:	449c                	lw	a5,8(s1)
    80002cce:	00f05d63          	blez	a5,80002ce8 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002cd2:	854a                	mv	a0,s2
    80002cd4:	00001097          	auipc	ra,0x1
    80002cd8:	c3c080e7          	jalr	-964(ra) # 80003910 <releasesleep>
}
    80002cdc:	60e2                	ld	ra,24(sp)
    80002cde:	6442                	ld	s0,16(sp)
    80002ce0:	64a2                	ld	s1,8(sp)
    80002ce2:	6902                	ld	s2,0(sp)
    80002ce4:	6105                	addi	sp,sp,32
    80002ce6:	8082                	ret
    panic("iunlock");
    80002ce8:	00006517          	auipc	a0,0x6
    80002cec:	a1050513          	addi	a0,a0,-1520 # 800086f8 <syscall_names+0x1a8>
    80002cf0:	00003097          	auipc	ra,0x3
    80002cf4:	f70080e7          	jalr	-144(ra) # 80005c60 <panic>

0000000080002cf8 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002cf8:	7179                	addi	sp,sp,-48
    80002cfa:	f406                	sd	ra,40(sp)
    80002cfc:	f022                	sd	s0,32(sp)
    80002cfe:	ec26                	sd	s1,24(sp)
    80002d00:	e84a                	sd	s2,16(sp)
    80002d02:	e44e                	sd	s3,8(sp)
    80002d04:	e052                	sd	s4,0(sp)
    80002d06:	1800                	addi	s0,sp,48
    80002d08:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002d0a:	05050493          	addi	s1,a0,80
    80002d0e:	08050913          	addi	s2,a0,128
    80002d12:	a021                	j	80002d1a <itrunc+0x22>
    80002d14:	0491                	addi	s1,s1,4
    80002d16:	01248d63          	beq	s1,s2,80002d30 <itrunc+0x38>
    if(ip->addrs[i]){
    80002d1a:	408c                	lw	a1,0(s1)
    80002d1c:	dde5                	beqz	a1,80002d14 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002d1e:	0009a503          	lw	a0,0(s3)
    80002d22:	00000097          	auipc	ra,0x0
    80002d26:	90c080e7          	jalr	-1780(ra) # 8000262e <bfree>
      ip->addrs[i] = 0;
    80002d2a:	0004a023          	sw	zero,0(s1)
    80002d2e:	b7dd                	j	80002d14 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002d30:	0809a583          	lw	a1,128(s3)
    80002d34:	e185                	bnez	a1,80002d54 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002d36:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002d3a:	854e                	mv	a0,s3
    80002d3c:	00000097          	auipc	ra,0x0
    80002d40:	de2080e7          	jalr	-542(ra) # 80002b1e <iupdate>
}
    80002d44:	70a2                	ld	ra,40(sp)
    80002d46:	7402                	ld	s0,32(sp)
    80002d48:	64e2                	ld	s1,24(sp)
    80002d4a:	6942                	ld	s2,16(sp)
    80002d4c:	69a2                	ld	s3,8(sp)
    80002d4e:	6a02                	ld	s4,0(sp)
    80002d50:	6145                	addi	sp,sp,48
    80002d52:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d54:	0009a503          	lw	a0,0(s3)
    80002d58:	fffff097          	auipc	ra,0xfffff
    80002d5c:	690080e7          	jalr	1680(ra) # 800023e8 <bread>
    80002d60:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002d62:	05850493          	addi	s1,a0,88
    80002d66:	45850913          	addi	s2,a0,1112
    80002d6a:	a021                	j	80002d72 <itrunc+0x7a>
    80002d6c:	0491                	addi	s1,s1,4
    80002d6e:	01248b63          	beq	s1,s2,80002d84 <itrunc+0x8c>
      if(a[j])
    80002d72:	408c                	lw	a1,0(s1)
    80002d74:	dde5                	beqz	a1,80002d6c <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002d76:	0009a503          	lw	a0,0(s3)
    80002d7a:	00000097          	auipc	ra,0x0
    80002d7e:	8b4080e7          	jalr	-1868(ra) # 8000262e <bfree>
    80002d82:	b7ed                	j	80002d6c <itrunc+0x74>
    brelse(bp);
    80002d84:	8552                	mv	a0,s4
    80002d86:	fffff097          	auipc	ra,0xfffff
    80002d8a:	792080e7          	jalr	1938(ra) # 80002518 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002d8e:	0809a583          	lw	a1,128(s3)
    80002d92:	0009a503          	lw	a0,0(s3)
    80002d96:	00000097          	auipc	ra,0x0
    80002d9a:	898080e7          	jalr	-1896(ra) # 8000262e <bfree>
    ip->addrs[NDIRECT] = 0;
    80002d9e:	0809a023          	sw	zero,128(s3)
    80002da2:	bf51                	j	80002d36 <itrunc+0x3e>

0000000080002da4 <iput>:
{
    80002da4:	1101                	addi	sp,sp,-32
    80002da6:	ec06                	sd	ra,24(sp)
    80002da8:	e822                	sd	s0,16(sp)
    80002daa:	e426                	sd	s1,8(sp)
    80002dac:	e04a                	sd	s2,0(sp)
    80002dae:	1000                	addi	s0,sp,32
    80002db0:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002db2:	00015517          	auipc	a0,0x15
    80002db6:	9c650513          	addi	a0,a0,-1594 # 80017778 <itable>
    80002dba:	00003097          	auipc	ra,0x3
    80002dbe:	3de080e7          	jalr	990(ra) # 80006198 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002dc2:	4498                	lw	a4,8(s1)
    80002dc4:	4785                	li	a5,1
    80002dc6:	02f70363          	beq	a4,a5,80002dec <iput+0x48>
  ip->ref--;
    80002dca:	449c                	lw	a5,8(s1)
    80002dcc:	37fd                	addiw	a5,a5,-1
    80002dce:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002dd0:	00015517          	auipc	a0,0x15
    80002dd4:	9a850513          	addi	a0,a0,-1624 # 80017778 <itable>
    80002dd8:	00003097          	auipc	ra,0x3
    80002ddc:	474080e7          	jalr	1140(ra) # 8000624c <release>
}
    80002de0:	60e2                	ld	ra,24(sp)
    80002de2:	6442                	ld	s0,16(sp)
    80002de4:	64a2                	ld	s1,8(sp)
    80002de6:	6902                	ld	s2,0(sp)
    80002de8:	6105                	addi	sp,sp,32
    80002dea:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002dec:	40bc                	lw	a5,64(s1)
    80002dee:	dff1                	beqz	a5,80002dca <iput+0x26>
    80002df0:	04a49783          	lh	a5,74(s1)
    80002df4:	fbf9                	bnez	a5,80002dca <iput+0x26>
    acquiresleep(&ip->lock);
    80002df6:	01048913          	addi	s2,s1,16
    80002dfa:	854a                	mv	a0,s2
    80002dfc:	00001097          	auipc	ra,0x1
    80002e00:	abe080e7          	jalr	-1346(ra) # 800038ba <acquiresleep>
    release(&itable.lock);
    80002e04:	00015517          	auipc	a0,0x15
    80002e08:	97450513          	addi	a0,a0,-1676 # 80017778 <itable>
    80002e0c:	00003097          	auipc	ra,0x3
    80002e10:	440080e7          	jalr	1088(ra) # 8000624c <release>
    itrunc(ip);
    80002e14:	8526                	mv	a0,s1
    80002e16:	00000097          	auipc	ra,0x0
    80002e1a:	ee2080e7          	jalr	-286(ra) # 80002cf8 <itrunc>
    ip->type = 0;
    80002e1e:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002e22:	8526                	mv	a0,s1
    80002e24:	00000097          	auipc	ra,0x0
    80002e28:	cfa080e7          	jalr	-774(ra) # 80002b1e <iupdate>
    ip->valid = 0;
    80002e2c:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e30:	854a                	mv	a0,s2
    80002e32:	00001097          	auipc	ra,0x1
    80002e36:	ade080e7          	jalr	-1314(ra) # 80003910 <releasesleep>
    acquire(&itable.lock);
    80002e3a:	00015517          	auipc	a0,0x15
    80002e3e:	93e50513          	addi	a0,a0,-1730 # 80017778 <itable>
    80002e42:	00003097          	auipc	ra,0x3
    80002e46:	356080e7          	jalr	854(ra) # 80006198 <acquire>
    80002e4a:	b741                	j	80002dca <iput+0x26>

0000000080002e4c <iunlockput>:
{
    80002e4c:	1101                	addi	sp,sp,-32
    80002e4e:	ec06                	sd	ra,24(sp)
    80002e50:	e822                	sd	s0,16(sp)
    80002e52:	e426                	sd	s1,8(sp)
    80002e54:	1000                	addi	s0,sp,32
    80002e56:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e58:	00000097          	auipc	ra,0x0
    80002e5c:	e54080e7          	jalr	-428(ra) # 80002cac <iunlock>
  iput(ip);
    80002e60:	8526                	mv	a0,s1
    80002e62:	00000097          	auipc	ra,0x0
    80002e66:	f42080e7          	jalr	-190(ra) # 80002da4 <iput>
}
    80002e6a:	60e2                	ld	ra,24(sp)
    80002e6c:	6442                	ld	s0,16(sp)
    80002e6e:	64a2                	ld	s1,8(sp)
    80002e70:	6105                	addi	sp,sp,32
    80002e72:	8082                	ret

0000000080002e74 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002e74:	1141                	addi	sp,sp,-16
    80002e76:	e422                	sd	s0,8(sp)
    80002e78:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002e7a:	411c                	lw	a5,0(a0)
    80002e7c:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002e7e:	415c                	lw	a5,4(a0)
    80002e80:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002e82:	04451783          	lh	a5,68(a0)
    80002e86:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002e8a:	04a51783          	lh	a5,74(a0)
    80002e8e:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002e92:	04c56783          	lwu	a5,76(a0)
    80002e96:	e99c                	sd	a5,16(a1)
}
    80002e98:	6422                	ld	s0,8(sp)
    80002e9a:	0141                	addi	sp,sp,16
    80002e9c:	8082                	ret

0000000080002e9e <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e9e:	457c                	lw	a5,76(a0)
    80002ea0:	0ed7e963          	bltu	a5,a3,80002f92 <readi+0xf4>
{
    80002ea4:	7159                	addi	sp,sp,-112
    80002ea6:	f486                	sd	ra,104(sp)
    80002ea8:	f0a2                	sd	s0,96(sp)
    80002eaa:	eca6                	sd	s1,88(sp)
    80002eac:	e8ca                	sd	s2,80(sp)
    80002eae:	e4ce                	sd	s3,72(sp)
    80002eb0:	e0d2                	sd	s4,64(sp)
    80002eb2:	fc56                	sd	s5,56(sp)
    80002eb4:	f85a                	sd	s6,48(sp)
    80002eb6:	f45e                	sd	s7,40(sp)
    80002eb8:	f062                	sd	s8,32(sp)
    80002eba:	ec66                	sd	s9,24(sp)
    80002ebc:	e86a                	sd	s10,16(sp)
    80002ebe:	e46e                	sd	s11,8(sp)
    80002ec0:	1880                	addi	s0,sp,112
    80002ec2:	8baa                	mv	s7,a0
    80002ec4:	8c2e                	mv	s8,a1
    80002ec6:	8ab2                	mv	s5,a2
    80002ec8:	84b6                	mv	s1,a3
    80002eca:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002ecc:	9f35                	addw	a4,a4,a3
    return 0;
    80002ece:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002ed0:	0ad76063          	bltu	a4,a3,80002f70 <readi+0xd2>
  if(off + n > ip->size)
    80002ed4:	00e7f463          	bgeu	a5,a4,80002edc <readi+0x3e>
    n = ip->size - off;
    80002ed8:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002edc:	0a0b0963          	beqz	s6,80002f8e <readi+0xf0>
    80002ee0:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ee2:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002ee6:	5cfd                	li	s9,-1
    80002ee8:	a82d                	j	80002f22 <readi+0x84>
    80002eea:	020a1d93          	slli	s11,s4,0x20
    80002eee:	020ddd93          	srli	s11,s11,0x20
    80002ef2:	05890613          	addi	a2,s2,88
    80002ef6:	86ee                	mv	a3,s11
    80002ef8:	963a                	add	a2,a2,a4
    80002efa:	85d6                	mv	a1,s5
    80002efc:	8562                	mv	a0,s8
    80002efe:	fffff097          	auipc	ra,0xfffff
    80002f02:	a04080e7          	jalr	-1532(ra) # 80001902 <either_copyout>
    80002f06:	05950d63          	beq	a0,s9,80002f60 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002f0a:	854a                	mv	a0,s2
    80002f0c:	fffff097          	auipc	ra,0xfffff
    80002f10:	60c080e7          	jalr	1548(ra) # 80002518 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f14:	013a09bb          	addw	s3,s4,s3
    80002f18:	009a04bb          	addw	s1,s4,s1
    80002f1c:	9aee                	add	s5,s5,s11
    80002f1e:	0569f763          	bgeu	s3,s6,80002f6c <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002f22:	000ba903          	lw	s2,0(s7)
    80002f26:	00a4d59b          	srliw	a1,s1,0xa
    80002f2a:	855e                	mv	a0,s7
    80002f2c:	00000097          	auipc	ra,0x0
    80002f30:	8ac080e7          	jalr	-1876(ra) # 800027d8 <bmap>
    80002f34:	0005059b          	sext.w	a1,a0
    80002f38:	854a                	mv	a0,s2
    80002f3a:	fffff097          	auipc	ra,0xfffff
    80002f3e:	4ae080e7          	jalr	1198(ra) # 800023e8 <bread>
    80002f42:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f44:	3ff4f713          	andi	a4,s1,1023
    80002f48:	40ed07bb          	subw	a5,s10,a4
    80002f4c:	413b06bb          	subw	a3,s6,s3
    80002f50:	8a3e                	mv	s4,a5
    80002f52:	2781                	sext.w	a5,a5
    80002f54:	0006861b          	sext.w	a2,a3
    80002f58:	f8f679e3          	bgeu	a2,a5,80002eea <readi+0x4c>
    80002f5c:	8a36                	mv	s4,a3
    80002f5e:	b771                	j	80002eea <readi+0x4c>
      brelse(bp);
    80002f60:	854a                	mv	a0,s2
    80002f62:	fffff097          	auipc	ra,0xfffff
    80002f66:	5b6080e7          	jalr	1462(ra) # 80002518 <brelse>
      tot = -1;
    80002f6a:	59fd                	li	s3,-1
  }
  return tot;
    80002f6c:	0009851b          	sext.w	a0,s3
}
    80002f70:	70a6                	ld	ra,104(sp)
    80002f72:	7406                	ld	s0,96(sp)
    80002f74:	64e6                	ld	s1,88(sp)
    80002f76:	6946                	ld	s2,80(sp)
    80002f78:	69a6                	ld	s3,72(sp)
    80002f7a:	6a06                	ld	s4,64(sp)
    80002f7c:	7ae2                	ld	s5,56(sp)
    80002f7e:	7b42                	ld	s6,48(sp)
    80002f80:	7ba2                	ld	s7,40(sp)
    80002f82:	7c02                	ld	s8,32(sp)
    80002f84:	6ce2                	ld	s9,24(sp)
    80002f86:	6d42                	ld	s10,16(sp)
    80002f88:	6da2                	ld	s11,8(sp)
    80002f8a:	6165                	addi	sp,sp,112
    80002f8c:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f8e:	89da                	mv	s3,s6
    80002f90:	bff1                	j	80002f6c <readi+0xce>
    return 0;
    80002f92:	4501                	li	a0,0
}
    80002f94:	8082                	ret

0000000080002f96 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f96:	457c                	lw	a5,76(a0)
    80002f98:	10d7e863          	bltu	a5,a3,800030a8 <writei+0x112>
{
    80002f9c:	7159                	addi	sp,sp,-112
    80002f9e:	f486                	sd	ra,104(sp)
    80002fa0:	f0a2                	sd	s0,96(sp)
    80002fa2:	eca6                	sd	s1,88(sp)
    80002fa4:	e8ca                	sd	s2,80(sp)
    80002fa6:	e4ce                	sd	s3,72(sp)
    80002fa8:	e0d2                	sd	s4,64(sp)
    80002faa:	fc56                	sd	s5,56(sp)
    80002fac:	f85a                	sd	s6,48(sp)
    80002fae:	f45e                	sd	s7,40(sp)
    80002fb0:	f062                	sd	s8,32(sp)
    80002fb2:	ec66                	sd	s9,24(sp)
    80002fb4:	e86a                	sd	s10,16(sp)
    80002fb6:	e46e                	sd	s11,8(sp)
    80002fb8:	1880                	addi	s0,sp,112
    80002fba:	8b2a                	mv	s6,a0
    80002fbc:	8c2e                	mv	s8,a1
    80002fbe:	8ab2                	mv	s5,a2
    80002fc0:	8936                	mv	s2,a3
    80002fc2:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80002fc4:	00e687bb          	addw	a5,a3,a4
    80002fc8:	0ed7e263          	bltu	a5,a3,800030ac <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002fcc:	00043737          	lui	a4,0x43
    80002fd0:	0ef76063          	bltu	a4,a5,800030b0 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fd4:	0c0b8863          	beqz	s7,800030a4 <writei+0x10e>
    80002fd8:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fda:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002fde:	5cfd                	li	s9,-1
    80002fe0:	a091                	j	80003024 <writei+0x8e>
    80002fe2:	02099d93          	slli	s11,s3,0x20
    80002fe6:	020ddd93          	srli	s11,s11,0x20
    80002fea:	05848513          	addi	a0,s1,88
    80002fee:	86ee                	mv	a3,s11
    80002ff0:	8656                	mv	a2,s5
    80002ff2:	85e2                	mv	a1,s8
    80002ff4:	953a                	add	a0,a0,a4
    80002ff6:	fffff097          	auipc	ra,0xfffff
    80002ffa:	962080e7          	jalr	-1694(ra) # 80001958 <either_copyin>
    80002ffe:	07950263          	beq	a0,s9,80003062 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003002:	8526                	mv	a0,s1
    80003004:	00000097          	auipc	ra,0x0
    80003008:	798080e7          	jalr	1944(ra) # 8000379c <log_write>
    brelse(bp);
    8000300c:	8526                	mv	a0,s1
    8000300e:	fffff097          	auipc	ra,0xfffff
    80003012:	50a080e7          	jalr	1290(ra) # 80002518 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003016:	01498a3b          	addw	s4,s3,s4
    8000301a:	0129893b          	addw	s2,s3,s2
    8000301e:	9aee                	add	s5,s5,s11
    80003020:	057a7663          	bgeu	s4,s7,8000306c <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003024:	000b2483          	lw	s1,0(s6)
    80003028:	00a9559b          	srliw	a1,s2,0xa
    8000302c:	855a                	mv	a0,s6
    8000302e:	fffff097          	auipc	ra,0xfffff
    80003032:	7aa080e7          	jalr	1962(ra) # 800027d8 <bmap>
    80003036:	0005059b          	sext.w	a1,a0
    8000303a:	8526                	mv	a0,s1
    8000303c:	fffff097          	auipc	ra,0xfffff
    80003040:	3ac080e7          	jalr	940(ra) # 800023e8 <bread>
    80003044:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003046:	3ff97713          	andi	a4,s2,1023
    8000304a:	40ed07bb          	subw	a5,s10,a4
    8000304e:	414b86bb          	subw	a3,s7,s4
    80003052:	89be                	mv	s3,a5
    80003054:	2781                	sext.w	a5,a5
    80003056:	0006861b          	sext.w	a2,a3
    8000305a:	f8f674e3          	bgeu	a2,a5,80002fe2 <writei+0x4c>
    8000305e:	89b6                	mv	s3,a3
    80003060:	b749                	j	80002fe2 <writei+0x4c>
      brelse(bp);
    80003062:	8526                	mv	a0,s1
    80003064:	fffff097          	auipc	ra,0xfffff
    80003068:	4b4080e7          	jalr	1204(ra) # 80002518 <brelse>
  }

  if(off > ip->size)
    8000306c:	04cb2783          	lw	a5,76(s6)
    80003070:	0127f463          	bgeu	a5,s2,80003078 <writei+0xe2>
    ip->size = off;
    80003074:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003078:	855a                	mv	a0,s6
    8000307a:	00000097          	auipc	ra,0x0
    8000307e:	aa4080e7          	jalr	-1372(ra) # 80002b1e <iupdate>

  return tot;
    80003082:	000a051b          	sext.w	a0,s4
}
    80003086:	70a6                	ld	ra,104(sp)
    80003088:	7406                	ld	s0,96(sp)
    8000308a:	64e6                	ld	s1,88(sp)
    8000308c:	6946                	ld	s2,80(sp)
    8000308e:	69a6                	ld	s3,72(sp)
    80003090:	6a06                	ld	s4,64(sp)
    80003092:	7ae2                	ld	s5,56(sp)
    80003094:	7b42                	ld	s6,48(sp)
    80003096:	7ba2                	ld	s7,40(sp)
    80003098:	7c02                	ld	s8,32(sp)
    8000309a:	6ce2                	ld	s9,24(sp)
    8000309c:	6d42                	ld	s10,16(sp)
    8000309e:	6da2                	ld	s11,8(sp)
    800030a0:	6165                	addi	sp,sp,112
    800030a2:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030a4:	8a5e                	mv	s4,s7
    800030a6:	bfc9                	j	80003078 <writei+0xe2>
    return -1;
    800030a8:	557d                	li	a0,-1
}
    800030aa:	8082                	ret
    return -1;
    800030ac:	557d                	li	a0,-1
    800030ae:	bfe1                	j	80003086 <writei+0xf0>
    return -1;
    800030b0:	557d                	li	a0,-1
    800030b2:	bfd1                	j	80003086 <writei+0xf0>

00000000800030b4 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800030b4:	1141                	addi	sp,sp,-16
    800030b6:	e406                	sd	ra,8(sp)
    800030b8:	e022                	sd	s0,0(sp)
    800030ba:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800030bc:	4639                	li	a2,14
    800030be:	ffffd097          	auipc	ra,0xffffd
    800030c2:	1d6080e7          	jalr	470(ra) # 80000294 <strncmp>
}
    800030c6:	60a2                	ld	ra,8(sp)
    800030c8:	6402                	ld	s0,0(sp)
    800030ca:	0141                	addi	sp,sp,16
    800030cc:	8082                	ret

00000000800030ce <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800030ce:	7139                	addi	sp,sp,-64
    800030d0:	fc06                	sd	ra,56(sp)
    800030d2:	f822                	sd	s0,48(sp)
    800030d4:	f426                	sd	s1,40(sp)
    800030d6:	f04a                	sd	s2,32(sp)
    800030d8:	ec4e                	sd	s3,24(sp)
    800030da:	e852                	sd	s4,16(sp)
    800030dc:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800030de:	04451703          	lh	a4,68(a0)
    800030e2:	4785                	li	a5,1
    800030e4:	00f71a63          	bne	a4,a5,800030f8 <dirlookup+0x2a>
    800030e8:	892a                	mv	s2,a0
    800030ea:	89ae                	mv	s3,a1
    800030ec:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800030ee:	457c                	lw	a5,76(a0)
    800030f0:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800030f2:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030f4:	e79d                	bnez	a5,80003122 <dirlookup+0x54>
    800030f6:	a8a5                	j	8000316e <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800030f8:	00005517          	auipc	a0,0x5
    800030fc:	60850513          	addi	a0,a0,1544 # 80008700 <syscall_names+0x1b0>
    80003100:	00003097          	auipc	ra,0x3
    80003104:	b60080e7          	jalr	-1184(ra) # 80005c60 <panic>
      panic("dirlookup read");
    80003108:	00005517          	auipc	a0,0x5
    8000310c:	61050513          	addi	a0,a0,1552 # 80008718 <syscall_names+0x1c8>
    80003110:	00003097          	auipc	ra,0x3
    80003114:	b50080e7          	jalr	-1200(ra) # 80005c60 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003118:	24c1                	addiw	s1,s1,16
    8000311a:	04c92783          	lw	a5,76(s2)
    8000311e:	04f4f763          	bgeu	s1,a5,8000316c <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003122:	4741                	li	a4,16
    80003124:	86a6                	mv	a3,s1
    80003126:	fc040613          	addi	a2,s0,-64
    8000312a:	4581                	li	a1,0
    8000312c:	854a                	mv	a0,s2
    8000312e:	00000097          	auipc	ra,0x0
    80003132:	d70080e7          	jalr	-656(ra) # 80002e9e <readi>
    80003136:	47c1                	li	a5,16
    80003138:	fcf518e3          	bne	a0,a5,80003108 <dirlookup+0x3a>
    if(de.inum == 0)
    8000313c:	fc045783          	lhu	a5,-64(s0)
    80003140:	dfe1                	beqz	a5,80003118 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003142:	fc240593          	addi	a1,s0,-62
    80003146:	854e                	mv	a0,s3
    80003148:	00000097          	auipc	ra,0x0
    8000314c:	f6c080e7          	jalr	-148(ra) # 800030b4 <namecmp>
    80003150:	f561                	bnez	a0,80003118 <dirlookup+0x4a>
      if(poff)
    80003152:	000a0463          	beqz	s4,8000315a <dirlookup+0x8c>
        *poff = off;
    80003156:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000315a:	fc045583          	lhu	a1,-64(s0)
    8000315e:	00092503          	lw	a0,0(s2)
    80003162:	fffff097          	auipc	ra,0xfffff
    80003166:	752080e7          	jalr	1874(ra) # 800028b4 <iget>
    8000316a:	a011                	j	8000316e <dirlookup+0xa0>
  return 0;
    8000316c:	4501                	li	a0,0
}
    8000316e:	70e2                	ld	ra,56(sp)
    80003170:	7442                	ld	s0,48(sp)
    80003172:	74a2                	ld	s1,40(sp)
    80003174:	7902                	ld	s2,32(sp)
    80003176:	69e2                	ld	s3,24(sp)
    80003178:	6a42                	ld	s4,16(sp)
    8000317a:	6121                	addi	sp,sp,64
    8000317c:	8082                	ret

000000008000317e <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000317e:	711d                	addi	sp,sp,-96
    80003180:	ec86                	sd	ra,88(sp)
    80003182:	e8a2                	sd	s0,80(sp)
    80003184:	e4a6                	sd	s1,72(sp)
    80003186:	e0ca                	sd	s2,64(sp)
    80003188:	fc4e                	sd	s3,56(sp)
    8000318a:	f852                	sd	s4,48(sp)
    8000318c:	f456                	sd	s5,40(sp)
    8000318e:	f05a                	sd	s6,32(sp)
    80003190:	ec5e                	sd	s7,24(sp)
    80003192:	e862                	sd	s8,16(sp)
    80003194:	e466                	sd	s9,8(sp)
    80003196:	e06a                	sd	s10,0(sp)
    80003198:	1080                	addi	s0,sp,96
    8000319a:	84aa                	mv	s1,a0
    8000319c:	8b2e                	mv	s6,a1
    8000319e:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800031a0:	00054703          	lbu	a4,0(a0)
    800031a4:	02f00793          	li	a5,47
    800031a8:	02f70363          	beq	a4,a5,800031ce <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800031ac:	ffffe097          	auipc	ra,0xffffe
    800031b0:	ce2080e7          	jalr	-798(ra) # 80000e8e <myproc>
    800031b4:	15053503          	ld	a0,336(a0)
    800031b8:	00000097          	auipc	ra,0x0
    800031bc:	9f4080e7          	jalr	-1548(ra) # 80002bac <idup>
    800031c0:	8a2a                	mv	s4,a0
  while(*path == '/')
    800031c2:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800031c6:	4cb5                	li	s9,13
  len = path - s;
    800031c8:	4b81                	li	s7,0

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800031ca:	4c05                	li	s8,1
    800031cc:	a87d                	j	8000328a <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    800031ce:	4585                	li	a1,1
    800031d0:	4505                	li	a0,1
    800031d2:	fffff097          	auipc	ra,0xfffff
    800031d6:	6e2080e7          	jalr	1762(ra) # 800028b4 <iget>
    800031da:	8a2a                	mv	s4,a0
    800031dc:	b7dd                	j	800031c2 <namex+0x44>
      iunlockput(ip);
    800031de:	8552                	mv	a0,s4
    800031e0:	00000097          	auipc	ra,0x0
    800031e4:	c6c080e7          	jalr	-916(ra) # 80002e4c <iunlockput>
      return 0;
    800031e8:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800031ea:	8552                	mv	a0,s4
    800031ec:	60e6                	ld	ra,88(sp)
    800031ee:	6446                	ld	s0,80(sp)
    800031f0:	64a6                	ld	s1,72(sp)
    800031f2:	6906                	ld	s2,64(sp)
    800031f4:	79e2                	ld	s3,56(sp)
    800031f6:	7a42                	ld	s4,48(sp)
    800031f8:	7aa2                	ld	s5,40(sp)
    800031fa:	7b02                	ld	s6,32(sp)
    800031fc:	6be2                	ld	s7,24(sp)
    800031fe:	6c42                	ld	s8,16(sp)
    80003200:	6ca2                	ld	s9,8(sp)
    80003202:	6d02                	ld	s10,0(sp)
    80003204:	6125                	addi	sp,sp,96
    80003206:	8082                	ret
      iunlock(ip);
    80003208:	8552                	mv	a0,s4
    8000320a:	00000097          	auipc	ra,0x0
    8000320e:	aa2080e7          	jalr	-1374(ra) # 80002cac <iunlock>
      return ip;
    80003212:	bfe1                	j	800031ea <namex+0x6c>
      iunlockput(ip);
    80003214:	8552                	mv	a0,s4
    80003216:	00000097          	auipc	ra,0x0
    8000321a:	c36080e7          	jalr	-970(ra) # 80002e4c <iunlockput>
      return 0;
    8000321e:	8a4e                	mv	s4,s3
    80003220:	b7e9                	j	800031ea <namex+0x6c>
  len = path - s;
    80003222:	40998633          	sub	a2,s3,s1
    80003226:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    8000322a:	09acd863          	bge	s9,s10,800032ba <namex+0x13c>
    memmove(name, s, DIRSIZ);
    8000322e:	4639                	li	a2,14
    80003230:	85a6                	mv	a1,s1
    80003232:	8556                	mv	a0,s5
    80003234:	ffffd097          	auipc	ra,0xffffd
    80003238:	fec080e7          	jalr	-20(ra) # 80000220 <memmove>
    8000323c:	84ce                	mv	s1,s3
  while(*path == '/')
    8000323e:	0004c783          	lbu	a5,0(s1)
    80003242:	01279763          	bne	a5,s2,80003250 <namex+0xd2>
    path++;
    80003246:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003248:	0004c783          	lbu	a5,0(s1)
    8000324c:	ff278de3          	beq	a5,s2,80003246 <namex+0xc8>
    ilock(ip);
    80003250:	8552                	mv	a0,s4
    80003252:	00000097          	auipc	ra,0x0
    80003256:	998080e7          	jalr	-1640(ra) # 80002bea <ilock>
    if(ip->type != T_DIR){
    8000325a:	044a1783          	lh	a5,68(s4)
    8000325e:	f98790e3          	bne	a5,s8,800031de <namex+0x60>
    if(nameiparent && *path == '\0'){
    80003262:	000b0563          	beqz	s6,8000326c <namex+0xee>
    80003266:	0004c783          	lbu	a5,0(s1)
    8000326a:	dfd9                	beqz	a5,80003208 <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000326c:	865e                	mv	a2,s7
    8000326e:	85d6                	mv	a1,s5
    80003270:	8552                	mv	a0,s4
    80003272:	00000097          	auipc	ra,0x0
    80003276:	e5c080e7          	jalr	-420(ra) # 800030ce <dirlookup>
    8000327a:	89aa                	mv	s3,a0
    8000327c:	dd41                	beqz	a0,80003214 <namex+0x96>
    iunlockput(ip);
    8000327e:	8552                	mv	a0,s4
    80003280:	00000097          	auipc	ra,0x0
    80003284:	bcc080e7          	jalr	-1076(ra) # 80002e4c <iunlockput>
    ip = next;
    80003288:	8a4e                	mv	s4,s3
  while(*path == '/')
    8000328a:	0004c783          	lbu	a5,0(s1)
    8000328e:	01279763          	bne	a5,s2,8000329c <namex+0x11e>
    path++;
    80003292:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003294:	0004c783          	lbu	a5,0(s1)
    80003298:	ff278de3          	beq	a5,s2,80003292 <namex+0x114>
  if(*path == 0)
    8000329c:	cb9d                	beqz	a5,800032d2 <namex+0x154>
  while(*path != '/' && *path != 0)
    8000329e:	0004c783          	lbu	a5,0(s1)
    800032a2:	89a6                	mv	s3,s1
  len = path - s;
    800032a4:	8d5e                	mv	s10,s7
    800032a6:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    800032a8:	01278963          	beq	a5,s2,800032ba <namex+0x13c>
    800032ac:	dbbd                	beqz	a5,80003222 <namex+0xa4>
    path++;
    800032ae:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800032b0:	0009c783          	lbu	a5,0(s3)
    800032b4:	ff279ce3          	bne	a5,s2,800032ac <namex+0x12e>
    800032b8:	b7ad                	j	80003222 <namex+0xa4>
    memmove(name, s, len);
    800032ba:	2601                	sext.w	a2,a2
    800032bc:	85a6                	mv	a1,s1
    800032be:	8556                	mv	a0,s5
    800032c0:	ffffd097          	auipc	ra,0xffffd
    800032c4:	f60080e7          	jalr	-160(ra) # 80000220 <memmove>
    name[len] = 0;
    800032c8:	9d56                	add	s10,s10,s5
    800032ca:	000d0023          	sb	zero,0(s10)
    800032ce:	84ce                	mv	s1,s3
    800032d0:	b7bd                	j	8000323e <namex+0xc0>
  if(nameiparent){
    800032d2:	f00b0ce3          	beqz	s6,800031ea <namex+0x6c>
    iput(ip);
    800032d6:	8552                	mv	a0,s4
    800032d8:	00000097          	auipc	ra,0x0
    800032dc:	acc080e7          	jalr	-1332(ra) # 80002da4 <iput>
    return 0;
    800032e0:	4a01                	li	s4,0
    800032e2:	b721                	j	800031ea <namex+0x6c>

00000000800032e4 <dirlink>:
{
    800032e4:	7139                	addi	sp,sp,-64
    800032e6:	fc06                	sd	ra,56(sp)
    800032e8:	f822                	sd	s0,48(sp)
    800032ea:	f426                	sd	s1,40(sp)
    800032ec:	f04a                	sd	s2,32(sp)
    800032ee:	ec4e                	sd	s3,24(sp)
    800032f0:	e852                	sd	s4,16(sp)
    800032f2:	0080                	addi	s0,sp,64
    800032f4:	892a                	mv	s2,a0
    800032f6:	8a2e                	mv	s4,a1
    800032f8:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800032fa:	4601                	li	a2,0
    800032fc:	00000097          	auipc	ra,0x0
    80003300:	dd2080e7          	jalr	-558(ra) # 800030ce <dirlookup>
    80003304:	e93d                	bnez	a0,8000337a <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003306:	04c92483          	lw	s1,76(s2)
    8000330a:	c49d                	beqz	s1,80003338 <dirlink+0x54>
    8000330c:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000330e:	4741                	li	a4,16
    80003310:	86a6                	mv	a3,s1
    80003312:	fc040613          	addi	a2,s0,-64
    80003316:	4581                	li	a1,0
    80003318:	854a                	mv	a0,s2
    8000331a:	00000097          	auipc	ra,0x0
    8000331e:	b84080e7          	jalr	-1148(ra) # 80002e9e <readi>
    80003322:	47c1                	li	a5,16
    80003324:	06f51163          	bne	a0,a5,80003386 <dirlink+0xa2>
    if(de.inum == 0)
    80003328:	fc045783          	lhu	a5,-64(s0)
    8000332c:	c791                	beqz	a5,80003338 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000332e:	24c1                	addiw	s1,s1,16
    80003330:	04c92783          	lw	a5,76(s2)
    80003334:	fcf4ede3          	bltu	s1,a5,8000330e <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003338:	4639                	li	a2,14
    8000333a:	85d2                	mv	a1,s4
    8000333c:	fc240513          	addi	a0,s0,-62
    80003340:	ffffd097          	auipc	ra,0xffffd
    80003344:	f90080e7          	jalr	-112(ra) # 800002d0 <strncpy>
  de.inum = inum;
    80003348:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000334c:	4741                	li	a4,16
    8000334e:	86a6                	mv	a3,s1
    80003350:	fc040613          	addi	a2,s0,-64
    80003354:	4581                	li	a1,0
    80003356:	854a                	mv	a0,s2
    80003358:	00000097          	auipc	ra,0x0
    8000335c:	c3e080e7          	jalr	-962(ra) # 80002f96 <writei>
    80003360:	872a                	mv	a4,a0
    80003362:	47c1                	li	a5,16
  return 0;
    80003364:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003366:	02f71863          	bne	a4,a5,80003396 <dirlink+0xb2>
}
    8000336a:	70e2                	ld	ra,56(sp)
    8000336c:	7442                	ld	s0,48(sp)
    8000336e:	74a2                	ld	s1,40(sp)
    80003370:	7902                	ld	s2,32(sp)
    80003372:	69e2                	ld	s3,24(sp)
    80003374:	6a42                	ld	s4,16(sp)
    80003376:	6121                	addi	sp,sp,64
    80003378:	8082                	ret
    iput(ip);
    8000337a:	00000097          	auipc	ra,0x0
    8000337e:	a2a080e7          	jalr	-1494(ra) # 80002da4 <iput>
    return -1;
    80003382:	557d                	li	a0,-1
    80003384:	b7dd                	j	8000336a <dirlink+0x86>
      panic("dirlink read");
    80003386:	00005517          	auipc	a0,0x5
    8000338a:	3a250513          	addi	a0,a0,930 # 80008728 <syscall_names+0x1d8>
    8000338e:	00003097          	auipc	ra,0x3
    80003392:	8d2080e7          	jalr	-1838(ra) # 80005c60 <panic>
    panic("dirlink");
    80003396:	00005517          	auipc	a0,0x5
    8000339a:	49a50513          	addi	a0,a0,1178 # 80008830 <syscall_names+0x2e0>
    8000339e:	00003097          	auipc	ra,0x3
    800033a2:	8c2080e7          	jalr	-1854(ra) # 80005c60 <panic>

00000000800033a6 <namei>:

struct inode*
namei(char *path)
{
    800033a6:	1101                	addi	sp,sp,-32
    800033a8:	ec06                	sd	ra,24(sp)
    800033aa:	e822                	sd	s0,16(sp)
    800033ac:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800033ae:	fe040613          	addi	a2,s0,-32
    800033b2:	4581                	li	a1,0
    800033b4:	00000097          	auipc	ra,0x0
    800033b8:	dca080e7          	jalr	-566(ra) # 8000317e <namex>
}
    800033bc:	60e2                	ld	ra,24(sp)
    800033be:	6442                	ld	s0,16(sp)
    800033c0:	6105                	addi	sp,sp,32
    800033c2:	8082                	ret

00000000800033c4 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800033c4:	1141                	addi	sp,sp,-16
    800033c6:	e406                	sd	ra,8(sp)
    800033c8:	e022                	sd	s0,0(sp)
    800033ca:	0800                	addi	s0,sp,16
    800033cc:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800033ce:	4585                	li	a1,1
    800033d0:	00000097          	auipc	ra,0x0
    800033d4:	dae080e7          	jalr	-594(ra) # 8000317e <namex>
}
    800033d8:	60a2                	ld	ra,8(sp)
    800033da:	6402                	ld	s0,0(sp)
    800033dc:	0141                	addi	sp,sp,16
    800033de:	8082                	ret

00000000800033e0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800033e0:	1101                	addi	sp,sp,-32
    800033e2:	ec06                	sd	ra,24(sp)
    800033e4:	e822                	sd	s0,16(sp)
    800033e6:	e426                	sd	s1,8(sp)
    800033e8:	e04a                	sd	s2,0(sp)
    800033ea:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800033ec:	00016917          	auipc	s2,0x16
    800033f0:	e3490913          	addi	s2,s2,-460 # 80019220 <log>
    800033f4:	01892583          	lw	a1,24(s2)
    800033f8:	02892503          	lw	a0,40(s2)
    800033fc:	fffff097          	auipc	ra,0xfffff
    80003400:	fec080e7          	jalr	-20(ra) # 800023e8 <bread>
    80003404:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003406:	02c92683          	lw	a3,44(s2)
    8000340a:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000340c:	02d05863          	blez	a3,8000343c <write_head+0x5c>
    80003410:	00016797          	auipc	a5,0x16
    80003414:	e4078793          	addi	a5,a5,-448 # 80019250 <log+0x30>
    80003418:	05c50713          	addi	a4,a0,92
    8000341c:	36fd                	addiw	a3,a3,-1
    8000341e:	02069613          	slli	a2,a3,0x20
    80003422:	01e65693          	srli	a3,a2,0x1e
    80003426:	00016617          	auipc	a2,0x16
    8000342a:	e2e60613          	addi	a2,a2,-466 # 80019254 <log+0x34>
    8000342e:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003430:	4390                	lw	a2,0(a5)
    80003432:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003434:	0791                	addi	a5,a5,4
    80003436:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    80003438:	fed79ce3          	bne	a5,a3,80003430 <write_head+0x50>
  }
  bwrite(buf);
    8000343c:	8526                	mv	a0,s1
    8000343e:	fffff097          	auipc	ra,0xfffff
    80003442:	09c080e7          	jalr	156(ra) # 800024da <bwrite>
  brelse(buf);
    80003446:	8526                	mv	a0,s1
    80003448:	fffff097          	auipc	ra,0xfffff
    8000344c:	0d0080e7          	jalr	208(ra) # 80002518 <brelse>
}
    80003450:	60e2                	ld	ra,24(sp)
    80003452:	6442                	ld	s0,16(sp)
    80003454:	64a2                	ld	s1,8(sp)
    80003456:	6902                	ld	s2,0(sp)
    80003458:	6105                	addi	sp,sp,32
    8000345a:	8082                	ret

000000008000345c <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000345c:	00016797          	auipc	a5,0x16
    80003460:	df07a783          	lw	a5,-528(a5) # 8001924c <log+0x2c>
    80003464:	0af05d63          	blez	a5,8000351e <install_trans+0xc2>
{
    80003468:	7139                	addi	sp,sp,-64
    8000346a:	fc06                	sd	ra,56(sp)
    8000346c:	f822                	sd	s0,48(sp)
    8000346e:	f426                	sd	s1,40(sp)
    80003470:	f04a                	sd	s2,32(sp)
    80003472:	ec4e                	sd	s3,24(sp)
    80003474:	e852                	sd	s4,16(sp)
    80003476:	e456                	sd	s5,8(sp)
    80003478:	e05a                	sd	s6,0(sp)
    8000347a:	0080                	addi	s0,sp,64
    8000347c:	8b2a                	mv	s6,a0
    8000347e:	00016a97          	auipc	s5,0x16
    80003482:	dd2a8a93          	addi	s5,s5,-558 # 80019250 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003486:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003488:	00016997          	auipc	s3,0x16
    8000348c:	d9898993          	addi	s3,s3,-616 # 80019220 <log>
    80003490:	a00d                	j	800034b2 <install_trans+0x56>
    brelse(lbuf);
    80003492:	854a                	mv	a0,s2
    80003494:	fffff097          	auipc	ra,0xfffff
    80003498:	084080e7          	jalr	132(ra) # 80002518 <brelse>
    brelse(dbuf);
    8000349c:	8526                	mv	a0,s1
    8000349e:	fffff097          	auipc	ra,0xfffff
    800034a2:	07a080e7          	jalr	122(ra) # 80002518 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034a6:	2a05                	addiw	s4,s4,1
    800034a8:	0a91                	addi	s5,s5,4
    800034aa:	02c9a783          	lw	a5,44(s3)
    800034ae:	04fa5e63          	bge	s4,a5,8000350a <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034b2:	0189a583          	lw	a1,24(s3)
    800034b6:	014585bb          	addw	a1,a1,s4
    800034ba:	2585                	addiw	a1,a1,1
    800034bc:	0289a503          	lw	a0,40(s3)
    800034c0:	fffff097          	auipc	ra,0xfffff
    800034c4:	f28080e7          	jalr	-216(ra) # 800023e8 <bread>
    800034c8:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800034ca:	000aa583          	lw	a1,0(s5)
    800034ce:	0289a503          	lw	a0,40(s3)
    800034d2:	fffff097          	auipc	ra,0xfffff
    800034d6:	f16080e7          	jalr	-234(ra) # 800023e8 <bread>
    800034da:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800034dc:	40000613          	li	a2,1024
    800034e0:	05890593          	addi	a1,s2,88
    800034e4:	05850513          	addi	a0,a0,88
    800034e8:	ffffd097          	auipc	ra,0xffffd
    800034ec:	d38080e7          	jalr	-712(ra) # 80000220 <memmove>
    bwrite(dbuf);  // write dst to disk
    800034f0:	8526                	mv	a0,s1
    800034f2:	fffff097          	auipc	ra,0xfffff
    800034f6:	fe8080e7          	jalr	-24(ra) # 800024da <bwrite>
    if(recovering == 0)
    800034fa:	f80b1ce3          	bnez	s6,80003492 <install_trans+0x36>
      bunpin(dbuf);
    800034fe:	8526                	mv	a0,s1
    80003500:	fffff097          	auipc	ra,0xfffff
    80003504:	0f2080e7          	jalr	242(ra) # 800025f2 <bunpin>
    80003508:	b769                	j	80003492 <install_trans+0x36>
}
    8000350a:	70e2                	ld	ra,56(sp)
    8000350c:	7442                	ld	s0,48(sp)
    8000350e:	74a2                	ld	s1,40(sp)
    80003510:	7902                	ld	s2,32(sp)
    80003512:	69e2                	ld	s3,24(sp)
    80003514:	6a42                	ld	s4,16(sp)
    80003516:	6aa2                	ld	s5,8(sp)
    80003518:	6b02                	ld	s6,0(sp)
    8000351a:	6121                	addi	sp,sp,64
    8000351c:	8082                	ret
    8000351e:	8082                	ret

0000000080003520 <initlog>:
{
    80003520:	7179                	addi	sp,sp,-48
    80003522:	f406                	sd	ra,40(sp)
    80003524:	f022                	sd	s0,32(sp)
    80003526:	ec26                	sd	s1,24(sp)
    80003528:	e84a                	sd	s2,16(sp)
    8000352a:	e44e                	sd	s3,8(sp)
    8000352c:	1800                	addi	s0,sp,48
    8000352e:	892a                	mv	s2,a0
    80003530:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003532:	00016497          	auipc	s1,0x16
    80003536:	cee48493          	addi	s1,s1,-786 # 80019220 <log>
    8000353a:	00005597          	auipc	a1,0x5
    8000353e:	1fe58593          	addi	a1,a1,510 # 80008738 <syscall_names+0x1e8>
    80003542:	8526                	mv	a0,s1
    80003544:	00003097          	auipc	ra,0x3
    80003548:	bc4080e7          	jalr	-1084(ra) # 80006108 <initlock>
  log.start = sb->logstart;
    8000354c:	0149a583          	lw	a1,20(s3)
    80003550:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003552:	0109a783          	lw	a5,16(s3)
    80003556:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003558:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000355c:	854a                	mv	a0,s2
    8000355e:	fffff097          	auipc	ra,0xfffff
    80003562:	e8a080e7          	jalr	-374(ra) # 800023e8 <bread>
  log.lh.n = lh->n;
    80003566:	4d34                	lw	a3,88(a0)
    80003568:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000356a:	02d05663          	blez	a3,80003596 <initlog+0x76>
    8000356e:	05c50793          	addi	a5,a0,92
    80003572:	00016717          	auipc	a4,0x16
    80003576:	cde70713          	addi	a4,a4,-802 # 80019250 <log+0x30>
    8000357a:	36fd                	addiw	a3,a3,-1
    8000357c:	02069613          	slli	a2,a3,0x20
    80003580:	01e65693          	srli	a3,a2,0x1e
    80003584:	06050613          	addi	a2,a0,96
    80003588:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    8000358a:	4390                	lw	a2,0(a5)
    8000358c:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000358e:	0791                	addi	a5,a5,4
    80003590:	0711                	addi	a4,a4,4
    80003592:	fed79ce3          	bne	a5,a3,8000358a <initlog+0x6a>
  brelse(buf);
    80003596:	fffff097          	auipc	ra,0xfffff
    8000359a:	f82080e7          	jalr	-126(ra) # 80002518 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000359e:	4505                	li	a0,1
    800035a0:	00000097          	auipc	ra,0x0
    800035a4:	ebc080e7          	jalr	-324(ra) # 8000345c <install_trans>
  log.lh.n = 0;
    800035a8:	00016797          	auipc	a5,0x16
    800035ac:	ca07a223          	sw	zero,-860(a5) # 8001924c <log+0x2c>
  write_head(); // clear the log
    800035b0:	00000097          	auipc	ra,0x0
    800035b4:	e30080e7          	jalr	-464(ra) # 800033e0 <write_head>
}
    800035b8:	70a2                	ld	ra,40(sp)
    800035ba:	7402                	ld	s0,32(sp)
    800035bc:	64e2                	ld	s1,24(sp)
    800035be:	6942                	ld	s2,16(sp)
    800035c0:	69a2                	ld	s3,8(sp)
    800035c2:	6145                	addi	sp,sp,48
    800035c4:	8082                	ret

00000000800035c6 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800035c6:	1101                	addi	sp,sp,-32
    800035c8:	ec06                	sd	ra,24(sp)
    800035ca:	e822                	sd	s0,16(sp)
    800035cc:	e426                	sd	s1,8(sp)
    800035ce:	e04a                	sd	s2,0(sp)
    800035d0:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800035d2:	00016517          	auipc	a0,0x16
    800035d6:	c4e50513          	addi	a0,a0,-946 # 80019220 <log>
    800035da:	00003097          	auipc	ra,0x3
    800035de:	bbe080e7          	jalr	-1090(ra) # 80006198 <acquire>
  while(1){
    if(log.committing){
    800035e2:	00016497          	auipc	s1,0x16
    800035e6:	c3e48493          	addi	s1,s1,-962 # 80019220 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035ea:	4979                	li	s2,30
    800035ec:	a039                	j	800035fa <begin_op+0x34>
      sleep(&log, &log.lock);
    800035ee:	85a6                	mv	a1,s1
    800035f0:	8526                	mv	a0,s1
    800035f2:	ffffe097          	auipc	ra,0xffffe
    800035f6:	f6c080e7          	jalr	-148(ra) # 8000155e <sleep>
    if(log.committing){
    800035fa:	50dc                	lw	a5,36(s1)
    800035fc:	fbed                	bnez	a5,800035ee <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035fe:	5098                	lw	a4,32(s1)
    80003600:	2705                	addiw	a4,a4,1
    80003602:	0007069b          	sext.w	a3,a4
    80003606:	0027179b          	slliw	a5,a4,0x2
    8000360a:	9fb9                	addw	a5,a5,a4
    8000360c:	0017979b          	slliw	a5,a5,0x1
    80003610:	54d8                	lw	a4,44(s1)
    80003612:	9fb9                	addw	a5,a5,a4
    80003614:	00f95963          	bge	s2,a5,80003626 <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003618:	85a6                	mv	a1,s1
    8000361a:	8526                	mv	a0,s1
    8000361c:	ffffe097          	auipc	ra,0xffffe
    80003620:	f42080e7          	jalr	-190(ra) # 8000155e <sleep>
    80003624:	bfd9                	j	800035fa <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003626:	00016517          	auipc	a0,0x16
    8000362a:	bfa50513          	addi	a0,a0,-1030 # 80019220 <log>
    8000362e:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003630:	00003097          	auipc	ra,0x3
    80003634:	c1c080e7          	jalr	-996(ra) # 8000624c <release>
      break;
    }
  }
}
    80003638:	60e2                	ld	ra,24(sp)
    8000363a:	6442                	ld	s0,16(sp)
    8000363c:	64a2                	ld	s1,8(sp)
    8000363e:	6902                	ld	s2,0(sp)
    80003640:	6105                	addi	sp,sp,32
    80003642:	8082                	ret

0000000080003644 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003644:	7139                	addi	sp,sp,-64
    80003646:	fc06                	sd	ra,56(sp)
    80003648:	f822                	sd	s0,48(sp)
    8000364a:	f426                	sd	s1,40(sp)
    8000364c:	f04a                	sd	s2,32(sp)
    8000364e:	ec4e                	sd	s3,24(sp)
    80003650:	e852                	sd	s4,16(sp)
    80003652:	e456                	sd	s5,8(sp)
    80003654:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003656:	00016497          	auipc	s1,0x16
    8000365a:	bca48493          	addi	s1,s1,-1078 # 80019220 <log>
    8000365e:	8526                	mv	a0,s1
    80003660:	00003097          	auipc	ra,0x3
    80003664:	b38080e7          	jalr	-1224(ra) # 80006198 <acquire>
  log.outstanding -= 1;
    80003668:	509c                	lw	a5,32(s1)
    8000366a:	37fd                	addiw	a5,a5,-1
    8000366c:	0007891b          	sext.w	s2,a5
    80003670:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003672:	50dc                	lw	a5,36(s1)
    80003674:	e7b9                	bnez	a5,800036c2 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003676:	04091e63          	bnez	s2,800036d2 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    8000367a:	00016497          	auipc	s1,0x16
    8000367e:	ba648493          	addi	s1,s1,-1114 # 80019220 <log>
    80003682:	4785                	li	a5,1
    80003684:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003686:	8526                	mv	a0,s1
    80003688:	00003097          	auipc	ra,0x3
    8000368c:	bc4080e7          	jalr	-1084(ra) # 8000624c <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003690:	54dc                	lw	a5,44(s1)
    80003692:	06f04763          	bgtz	a5,80003700 <end_op+0xbc>
    acquire(&log.lock);
    80003696:	00016497          	auipc	s1,0x16
    8000369a:	b8a48493          	addi	s1,s1,-1142 # 80019220 <log>
    8000369e:	8526                	mv	a0,s1
    800036a0:	00003097          	auipc	ra,0x3
    800036a4:	af8080e7          	jalr	-1288(ra) # 80006198 <acquire>
    log.committing = 0;
    800036a8:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800036ac:	8526                	mv	a0,s1
    800036ae:	ffffe097          	auipc	ra,0xffffe
    800036b2:	03c080e7          	jalr	60(ra) # 800016ea <wakeup>
    release(&log.lock);
    800036b6:	8526                	mv	a0,s1
    800036b8:	00003097          	auipc	ra,0x3
    800036bc:	b94080e7          	jalr	-1132(ra) # 8000624c <release>
}
    800036c0:	a03d                	j	800036ee <end_op+0xaa>
    panic("log.committing");
    800036c2:	00005517          	auipc	a0,0x5
    800036c6:	07e50513          	addi	a0,a0,126 # 80008740 <syscall_names+0x1f0>
    800036ca:	00002097          	auipc	ra,0x2
    800036ce:	596080e7          	jalr	1430(ra) # 80005c60 <panic>
    wakeup(&log);
    800036d2:	00016497          	auipc	s1,0x16
    800036d6:	b4e48493          	addi	s1,s1,-1202 # 80019220 <log>
    800036da:	8526                	mv	a0,s1
    800036dc:	ffffe097          	auipc	ra,0xffffe
    800036e0:	00e080e7          	jalr	14(ra) # 800016ea <wakeup>
  release(&log.lock);
    800036e4:	8526                	mv	a0,s1
    800036e6:	00003097          	auipc	ra,0x3
    800036ea:	b66080e7          	jalr	-1178(ra) # 8000624c <release>
}
    800036ee:	70e2                	ld	ra,56(sp)
    800036f0:	7442                	ld	s0,48(sp)
    800036f2:	74a2                	ld	s1,40(sp)
    800036f4:	7902                	ld	s2,32(sp)
    800036f6:	69e2                	ld	s3,24(sp)
    800036f8:	6a42                	ld	s4,16(sp)
    800036fa:	6aa2                	ld	s5,8(sp)
    800036fc:	6121                	addi	sp,sp,64
    800036fe:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80003700:	00016a97          	auipc	s5,0x16
    80003704:	b50a8a93          	addi	s5,s5,-1200 # 80019250 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003708:	00016a17          	auipc	s4,0x16
    8000370c:	b18a0a13          	addi	s4,s4,-1256 # 80019220 <log>
    80003710:	018a2583          	lw	a1,24(s4)
    80003714:	012585bb          	addw	a1,a1,s2
    80003718:	2585                	addiw	a1,a1,1
    8000371a:	028a2503          	lw	a0,40(s4)
    8000371e:	fffff097          	auipc	ra,0xfffff
    80003722:	cca080e7          	jalr	-822(ra) # 800023e8 <bread>
    80003726:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003728:	000aa583          	lw	a1,0(s5)
    8000372c:	028a2503          	lw	a0,40(s4)
    80003730:	fffff097          	auipc	ra,0xfffff
    80003734:	cb8080e7          	jalr	-840(ra) # 800023e8 <bread>
    80003738:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000373a:	40000613          	li	a2,1024
    8000373e:	05850593          	addi	a1,a0,88
    80003742:	05848513          	addi	a0,s1,88
    80003746:	ffffd097          	auipc	ra,0xffffd
    8000374a:	ada080e7          	jalr	-1318(ra) # 80000220 <memmove>
    bwrite(to);  // write the log
    8000374e:	8526                	mv	a0,s1
    80003750:	fffff097          	auipc	ra,0xfffff
    80003754:	d8a080e7          	jalr	-630(ra) # 800024da <bwrite>
    brelse(from);
    80003758:	854e                	mv	a0,s3
    8000375a:	fffff097          	auipc	ra,0xfffff
    8000375e:	dbe080e7          	jalr	-578(ra) # 80002518 <brelse>
    brelse(to);
    80003762:	8526                	mv	a0,s1
    80003764:	fffff097          	auipc	ra,0xfffff
    80003768:	db4080e7          	jalr	-588(ra) # 80002518 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000376c:	2905                	addiw	s2,s2,1
    8000376e:	0a91                	addi	s5,s5,4
    80003770:	02ca2783          	lw	a5,44(s4)
    80003774:	f8f94ee3          	blt	s2,a5,80003710 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003778:	00000097          	auipc	ra,0x0
    8000377c:	c68080e7          	jalr	-920(ra) # 800033e0 <write_head>
    install_trans(0); // Now install writes to home locations
    80003780:	4501                	li	a0,0
    80003782:	00000097          	auipc	ra,0x0
    80003786:	cda080e7          	jalr	-806(ra) # 8000345c <install_trans>
    log.lh.n = 0;
    8000378a:	00016797          	auipc	a5,0x16
    8000378e:	ac07a123          	sw	zero,-1342(a5) # 8001924c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003792:	00000097          	auipc	ra,0x0
    80003796:	c4e080e7          	jalr	-946(ra) # 800033e0 <write_head>
    8000379a:	bdf5                	j	80003696 <end_op+0x52>

000000008000379c <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000379c:	1101                	addi	sp,sp,-32
    8000379e:	ec06                	sd	ra,24(sp)
    800037a0:	e822                	sd	s0,16(sp)
    800037a2:	e426                	sd	s1,8(sp)
    800037a4:	e04a                	sd	s2,0(sp)
    800037a6:	1000                	addi	s0,sp,32
    800037a8:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800037aa:	00016917          	auipc	s2,0x16
    800037ae:	a7690913          	addi	s2,s2,-1418 # 80019220 <log>
    800037b2:	854a                	mv	a0,s2
    800037b4:	00003097          	auipc	ra,0x3
    800037b8:	9e4080e7          	jalr	-1564(ra) # 80006198 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800037bc:	02c92603          	lw	a2,44(s2)
    800037c0:	47f5                	li	a5,29
    800037c2:	06c7c563          	blt	a5,a2,8000382c <log_write+0x90>
    800037c6:	00016797          	auipc	a5,0x16
    800037ca:	a767a783          	lw	a5,-1418(a5) # 8001923c <log+0x1c>
    800037ce:	37fd                	addiw	a5,a5,-1
    800037d0:	04f65e63          	bge	a2,a5,8000382c <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800037d4:	00016797          	auipc	a5,0x16
    800037d8:	a6c7a783          	lw	a5,-1428(a5) # 80019240 <log+0x20>
    800037dc:	06f05063          	blez	a5,8000383c <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800037e0:	4781                	li	a5,0
    800037e2:	06c05563          	blez	a2,8000384c <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037e6:	44cc                	lw	a1,12(s1)
    800037e8:	00016717          	auipc	a4,0x16
    800037ec:	a6870713          	addi	a4,a4,-1432 # 80019250 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800037f0:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037f2:	4314                	lw	a3,0(a4)
    800037f4:	04b68c63          	beq	a3,a1,8000384c <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800037f8:	2785                	addiw	a5,a5,1
    800037fa:	0711                	addi	a4,a4,4
    800037fc:	fef61be3          	bne	a2,a5,800037f2 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003800:	0621                	addi	a2,a2,8
    80003802:	060a                	slli	a2,a2,0x2
    80003804:	00016797          	auipc	a5,0x16
    80003808:	a1c78793          	addi	a5,a5,-1508 # 80019220 <log>
    8000380c:	97b2                	add	a5,a5,a2
    8000380e:	44d8                	lw	a4,12(s1)
    80003810:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003812:	8526                	mv	a0,s1
    80003814:	fffff097          	auipc	ra,0xfffff
    80003818:	da2080e7          	jalr	-606(ra) # 800025b6 <bpin>
    log.lh.n++;
    8000381c:	00016717          	auipc	a4,0x16
    80003820:	a0470713          	addi	a4,a4,-1532 # 80019220 <log>
    80003824:	575c                	lw	a5,44(a4)
    80003826:	2785                	addiw	a5,a5,1
    80003828:	d75c                	sw	a5,44(a4)
    8000382a:	a82d                	j	80003864 <log_write+0xc8>
    panic("too big a transaction");
    8000382c:	00005517          	auipc	a0,0x5
    80003830:	f2450513          	addi	a0,a0,-220 # 80008750 <syscall_names+0x200>
    80003834:	00002097          	auipc	ra,0x2
    80003838:	42c080e7          	jalr	1068(ra) # 80005c60 <panic>
    panic("log_write outside of trans");
    8000383c:	00005517          	auipc	a0,0x5
    80003840:	f2c50513          	addi	a0,a0,-212 # 80008768 <syscall_names+0x218>
    80003844:	00002097          	auipc	ra,0x2
    80003848:	41c080e7          	jalr	1052(ra) # 80005c60 <panic>
  log.lh.block[i] = b->blockno;
    8000384c:	00878693          	addi	a3,a5,8
    80003850:	068a                	slli	a3,a3,0x2
    80003852:	00016717          	auipc	a4,0x16
    80003856:	9ce70713          	addi	a4,a4,-1586 # 80019220 <log>
    8000385a:	9736                	add	a4,a4,a3
    8000385c:	44d4                	lw	a3,12(s1)
    8000385e:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003860:	faf609e3          	beq	a2,a5,80003812 <log_write+0x76>
  }
  release(&log.lock);
    80003864:	00016517          	auipc	a0,0x16
    80003868:	9bc50513          	addi	a0,a0,-1604 # 80019220 <log>
    8000386c:	00003097          	auipc	ra,0x3
    80003870:	9e0080e7          	jalr	-1568(ra) # 8000624c <release>
}
    80003874:	60e2                	ld	ra,24(sp)
    80003876:	6442                	ld	s0,16(sp)
    80003878:	64a2                	ld	s1,8(sp)
    8000387a:	6902                	ld	s2,0(sp)
    8000387c:	6105                	addi	sp,sp,32
    8000387e:	8082                	ret

0000000080003880 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003880:	1101                	addi	sp,sp,-32
    80003882:	ec06                	sd	ra,24(sp)
    80003884:	e822                	sd	s0,16(sp)
    80003886:	e426                	sd	s1,8(sp)
    80003888:	e04a                	sd	s2,0(sp)
    8000388a:	1000                	addi	s0,sp,32
    8000388c:	84aa                	mv	s1,a0
    8000388e:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003890:	00005597          	auipc	a1,0x5
    80003894:	ef858593          	addi	a1,a1,-264 # 80008788 <syscall_names+0x238>
    80003898:	0521                	addi	a0,a0,8
    8000389a:	00003097          	auipc	ra,0x3
    8000389e:	86e080e7          	jalr	-1938(ra) # 80006108 <initlock>
  lk->name = name;
    800038a2:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800038a6:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038aa:	0204a423          	sw	zero,40(s1)
}
    800038ae:	60e2                	ld	ra,24(sp)
    800038b0:	6442                	ld	s0,16(sp)
    800038b2:	64a2                	ld	s1,8(sp)
    800038b4:	6902                	ld	s2,0(sp)
    800038b6:	6105                	addi	sp,sp,32
    800038b8:	8082                	ret

00000000800038ba <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800038ba:	1101                	addi	sp,sp,-32
    800038bc:	ec06                	sd	ra,24(sp)
    800038be:	e822                	sd	s0,16(sp)
    800038c0:	e426                	sd	s1,8(sp)
    800038c2:	e04a                	sd	s2,0(sp)
    800038c4:	1000                	addi	s0,sp,32
    800038c6:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038c8:	00850913          	addi	s2,a0,8
    800038cc:	854a                	mv	a0,s2
    800038ce:	00003097          	auipc	ra,0x3
    800038d2:	8ca080e7          	jalr	-1846(ra) # 80006198 <acquire>
  while (lk->locked) {
    800038d6:	409c                	lw	a5,0(s1)
    800038d8:	cb89                	beqz	a5,800038ea <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800038da:	85ca                	mv	a1,s2
    800038dc:	8526                	mv	a0,s1
    800038de:	ffffe097          	auipc	ra,0xffffe
    800038e2:	c80080e7          	jalr	-896(ra) # 8000155e <sleep>
  while (lk->locked) {
    800038e6:	409c                	lw	a5,0(s1)
    800038e8:	fbed                	bnez	a5,800038da <acquiresleep+0x20>
  }
  lk->locked = 1;
    800038ea:	4785                	li	a5,1
    800038ec:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800038ee:	ffffd097          	auipc	ra,0xffffd
    800038f2:	5a0080e7          	jalr	1440(ra) # 80000e8e <myproc>
    800038f6:	591c                	lw	a5,48(a0)
    800038f8:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800038fa:	854a                	mv	a0,s2
    800038fc:	00003097          	auipc	ra,0x3
    80003900:	950080e7          	jalr	-1712(ra) # 8000624c <release>
}
    80003904:	60e2                	ld	ra,24(sp)
    80003906:	6442                	ld	s0,16(sp)
    80003908:	64a2                	ld	s1,8(sp)
    8000390a:	6902                	ld	s2,0(sp)
    8000390c:	6105                	addi	sp,sp,32
    8000390e:	8082                	ret

0000000080003910 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003910:	1101                	addi	sp,sp,-32
    80003912:	ec06                	sd	ra,24(sp)
    80003914:	e822                	sd	s0,16(sp)
    80003916:	e426                	sd	s1,8(sp)
    80003918:	e04a                	sd	s2,0(sp)
    8000391a:	1000                	addi	s0,sp,32
    8000391c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000391e:	00850913          	addi	s2,a0,8
    80003922:	854a                	mv	a0,s2
    80003924:	00003097          	auipc	ra,0x3
    80003928:	874080e7          	jalr	-1932(ra) # 80006198 <acquire>
  lk->locked = 0;
    8000392c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003930:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003934:	8526                	mv	a0,s1
    80003936:	ffffe097          	auipc	ra,0xffffe
    8000393a:	db4080e7          	jalr	-588(ra) # 800016ea <wakeup>
  release(&lk->lk);
    8000393e:	854a                	mv	a0,s2
    80003940:	00003097          	auipc	ra,0x3
    80003944:	90c080e7          	jalr	-1780(ra) # 8000624c <release>
}
    80003948:	60e2                	ld	ra,24(sp)
    8000394a:	6442                	ld	s0,16(sp)
    8000394c:	64a2                	ld	s1,8(sp)
    8000394e:	6902                	ld	s2,0(sp)
    80003950:	6105                	addi	sp,sp,32
    80003952:	8082                	ret

0000000080003954 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003954:	7179                	addi	sp,sp,-48
    80003956:	f406                	sd	ra,40(sp)
    80003958:	f022                	sd	s0,32(sp)
    8000395a:	ec26                	sd	s1,24(sp)
    8000395c:	e84a                	sd	s2,16(sp)
    8000395e:	e44e                	sd	s3,8(sp)
    80003960:	1800                	addi	s0,sp,48
    80003962:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003964:	00850913          	addi	s2,a0,8
    80003968:	854a                	mv	a0,s2
    8000396a:	00003097          	auipc	ra,0x3
    8000396e:	82e080e7          	jalr	-2002(ra) # 80006198 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003972:	409c                	lw	a5,0(s1)
    80003974:	ef99                	bnez	a5,80003992 <holdingsleep+0x3e>
    80003976:	4481                	li	s1,0
  release(&lk->lk);
    80003978:	854a                	mv	a0,s2
    8000397a:	00003097          	auipc	ra,0x3
    8000397e:	8d2080e7          	jalr	-1838(ra) # 8000624c <release>
  return r;
}
    80003982:	8526                	mv	a0,s1
    80003984:	70a2                	ld	ra,40(sp)
    80003986:	7402                	ld	s0,32(sp)
    80003988:	64e2                	ld	s1,24(sp)
    8000398a:	6942                	ld	s2,16(sp)
    8000398c:	69a2                	ld	s3,8(sp)
    8000398e:	6145                	addi	sp,sp,48
    80003990:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003992:	0284a983          	lw	s3,40(s1)
    80003996:	ffffd097          	auipc	ra,0xffffd
    8000399a:	4f8080e7          	jalr	1272(ra) # 80000e8e <myproc>
    8000399e:	5904                	lw	s1,48(a0)
    800039a0:	413484b3          	sub	s1,s1,s3
    800039a4:	0014b493          	seqz	s1,s1
    800039a8:	bfc1                	j	80003978 <holdingsleep+0x24>

00000000800039aa <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800039aa:	1141                	addi	sp,sp,-16
    800039ac:	e406                	sd	ra,8(sp)
    800039ae:	e022                	sd	s0,0(sp)
    800039b0:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800039b2:	00005597          	auipc	a1,0x5
    800039b6:	de658593          	addi	a1,a1,-538 # 80008798 <syscall_names+0x248>
    800039ba:	00016517          	auipc	a0,0x16
    800039be:	9ae50513          	addi	a0,a0,-1618 # 80019368 <ftable>
    800039c2:	00002097          	auipc	ra,0x2
    800039c6:	746080e7          	jalr	1862(ra) # 80006108 <initlock>
}
    800039ca:	60a2                	ld	ra,8(sp)
    800039cc:	6402                	ld	s0,0(sp)
    800039ce:	0141                	addi	sp,sp,16
    800039d0:	8082                	ret

00000000800039d2 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800039d2:	1101                	addi	sp,sp,-32
    800039d4:	ec06                	sd	ra,24(sp)
    800039d6:	e822                	sd	s0,16(sp)
    800039d8:	e426                	sd	s1,8(sp)
    800039da:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800039dc:	00016517          	auipc	a0,0x16
    800039e0:	98c50513          	addi	a0,a0,-1652 # 80019368 <ftable>
    800039e4:	00002097          	auipc	ra,0x2
    800039e8:	7b4080e7          	jalr	1972(ra) # 80006198 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039ec:	00016497          	auipc	s1,0x16
    800039f0:	99448493          	addi	s1,s1,-1644 # 80019380 <ftable+0x18>
    800039f4:	00017717          	auipc	a4,0x17
    800039f8:	92c70713          	addi	a4,a4,-1748 # 8001a320 <ftable+0xfb8>
    if(f->ref == 0){
    800039fc:	40dc                	lw	a5,4(s1)
    800039fe:	cf99                	beqz	a5,80003a1c <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a00:	02848493          	addi	s1,s1,40
    80003a04:	fee49ce3          	bne	s1,a4,800039fc <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003a08:	00016517          	auipc	a0,0x16
    80003a0c:	96050513          	addi	a0,a0,-1696 # 80019368 <ftable>
    80003a10:	00003097          	auipc	ra,0x3
    80003a14:	83c080e7          	jalr	-1988(ra) # 8000624c <release>
  return 0;
    80003a18:	4481                	li	s1,0
    80003a1a:	a819                	j	80003a30 <filealloc+0x5e>
      f->ref = 1;
    80003a1c:	4785                	li	a5,1
    80003a1e:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003a20:	00016517          	auipc	a0,0x16
    80003a24:	94850513          	addi	a0,a0,-1720 # 80019368 <ftable>
    80003a28:	00003097          	auipc	ra,0x3
    80003a2c:	824080e7          	jalr	-2012(ra) # 8000624c <release>
}
    80003a30:	8526                	mv	a0,s1
    80003a32:	60e2                	ld	ra,24(sp)
    80003a34:	6442                	ld	s0,16(sp)
    80003a36:	64a2                	ld	s1,8(sp)
    80003a38:	6105                	addi	sp,sp,32
    80003a3a:	8082                	ret

0000000080003a3c <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003a3c:	1101                	addi	sp,sp,-32
    80003a3e:	ec06                	sd	ra,24(sp)
    80003a40:	e822                	sd	s0,16(sp)
    80003a42:	e426                	sd	s1,8(sp)
    80003a44:	1000                	addi	s0,sp,32
    80003a46:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a48:	00016517          	auipc	a0,0x16
    80003a4c:	92050513          	addi	a0,a0,-1760 # 80019368 <ftable>
    80003a50:	00002097          	auipc	ra,0x2
    80003a54:	748080e7          	jalr	1864(ra) # 80006198 <acquire>
  if(f->ref < 1)
    80003a58:	40dc                	lw	a5,4(s1)
    80003a5a:	02f05263          	blez	a5,80003a7e <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a5e:	2785                	addiw	a5,a5,1
    80003a60:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a62:	00016517          	auipc	a0,0x16
    80003a66:	90650513          	addi	a0,a0,-1786 # 80019368 <ftable>
    80003a6a:	00002097          	auipc	ra,0x2
    80003a6e:	7e2080e7          	jalr	2018(ra) # 8000624c <release>
  return f;
}
    80003a72:	8526                	mv	a0,s1
    80003a74:	60e2                	ld	ra,24(sp)
    80003a76:	6442                	ld	s0,16(sp)
    80003a78:	64a2                	ld	s1,8(sp)
    80003a7a:	6105                	addi	sp,sp,32
    80003a7c:	8082                	ret
    panic("filedup");
    80003a7e:	00005517          	auipc	a0,0x5
    80003a82:	d2250513          	addi	a0,a0,-734 # 800087a0 <syscall_names+0x250>
    80003a86:	00002097          	auipc	ra,0x2
    80003a8a:	1da080e7          	jalr	474(ra) # 80005c60 <panic>

0000000080003a8e <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003a8e:	7139                	addi	sp,sp,-64
    80003a90:	fc06                	sd	ra,56(sp)
    80003a92:	f822                	sd	s0,48(sp)
    80003a94:	f426                	sd	s1,40(sp)
    80003a96:	f04a                	sd	s2,32(sp)
    80003a98:	ec4e                	sd	s3,24(sp)
    80003a9a:	e852                	sd	s4,16(sp)
    80003a9c:	e456                	sd	s5,8(sp)
    80003a9e:	0080                	addi	s0,sp,64
    80003aa0:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003aa2:	00016517          	auipc	a0,0x16
    80003aa6:	8c650513          	addi	a0,a0,-1850 # 80019368 <ftable>
    80003aaa:	00002097          	auipc	ra,0x2
    80003aae:	6ee080e7          	jalr	1774(ra) # 80006198 <acquire>
  if(f->ref < 1)
    80003ab2:	40dc                	lw	a5,4(s1)
    80003ab4:	06f05163          	blez	a5,80003b16 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003ab8:	37fd                	addiw	a5,a5,-1
    80003aba:	0007871b          	sext.w	a4,a5
    80003abe:	c0dc                	sw	a5,4(s1)
    80003ac0:	06e04363          	bgtz	a4,80003b26 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003ac4:	0004a903          	lw	s2,0(s1)
    80003ac8:	0094ca83          	lbu	s5,9(s1)
    80003acc:	0104ba03          	ld	s4,16(s1)
    80003ad0:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003ad4:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003ad8:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003adc:	00016517          	auipc	a0,0x16
    80003ae0:	88c50513          	addi	a0,a0,-1908 # 80019368 <ftable>
    80003ae4:	00002097          	auipc	ra,0x2
    80003ae8:	768080e7          	jalr	1896(ra) # 8000624c <release>

  if(ff.type == FD_PIPE){
    80003aec:	4785                	li	a5,1
    80003aee:	04f90d63          	beq	s2,a5,80003b48 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003af2:	3979                	addiw	s2,s2,-2
    80003af4:	4785                	li	a5,1
    80003af6:	0527e063          	bltu	a5,s2,80003b36 <fileclose+0xa8>
    begin_op();
    80003afa:	00000097          	auipc	ra,0x0
    80003afe:	acc080e7          	jalr	-1332(ra) # 800035c6 <begin_op>
    iput(ff.ip);
    80003b02:	854e                	mv	a0,s3
    80003b04:	fffff097          	auipc	ra,0xfffff
    80003b08:	2a0080e7          	jalr	672(ra) # 80002da4 <iput>
    end_op();
    80003b0c:	00000097          	auipc	ra,0x0
    80003b10:	b38080e7          	jalr	-1224(ra) # 80003644 <end_op>
    80003b14:	a00d                	j	80003b36 <fileclose+0xa8>
    panic("fileclose");
    80003b16:	00005517          	auipc	a0,0x5
    80003b1a:	c9250513          	addi	a0,a0,-878 # 800087a8 <syscall_names+0x258>
    80003b1e:	00002097          	auipc	ra,0x2
    80003b22:	142080e7          	jalr	322(ra) # 80005c60 <panic>
    release(&ftable.lock);
    80003b26:	00016517          	auipc	a0,0x16
    80003b2a:	84250513          	addi	a0,a0,-1982 # 80019368 <ftable>
    80003b2e:	00002097          	auipc	ra,0x2
    80003b32:	71e080e7          	jalr	1822(ra) # 8000624c <release>
  }
}
    80003b36:	70e2                	ld	ra,56(sp)
    80003b38:	7442                	ld	s0,48(sp)
    80003b3a:	74a2                	ld	s1,40(sp)
    80003b3c:	7902                	ld	s2,32(sp)
    80003b3e:	69e2                	ld	s3,24(sp)
    80003b40:	6a42                	ld	s4,16(sp)
    80003b42:	6aa2                	ld	s5,8(sp)
    80003b44:	6121                	addi	sp,sp,64
    80003b46:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b48:	85d6                	mv	a1,s5
    80003b4a:	8552                	mv	a0,s4
    80003b4c:	00000097          	auipc	ra,0x0
    80003b50:	34c080e7          	jalr	844(ra) # 80003e98 <pipeclose>
    80003b54:	b7cd                	j	80003b36 <fileclose+0xa8>

0000000080003b56 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003b56:	715d                	addi	sp,sp,-80
    80003b58:	e486                	sd	ra,72(sp)
    80003b5a:	e0a2                	sd	s0,64(sp)
    80003b5c:	fc26                	sd	s1,56(sp)
    80003b5e:	f84a                	sd	s2,48(sp)
    80003b60:	f44e                	sd	s3,40(sp)
    80003b62:	0880                	addi	s0,sp,80
    80003b64:	84aa                	mv	s1,a0
    80003b66:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b68:	ffffd097          	auipc	ra,0xffffd
    80003b6c:	326080e7          	jalr	806(ra) # 80000e8e <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003b70:	409c                	lw	a5,0(s1)
    80003b72:	37f9                	addiw	a5,a5,-2
    80003b74:	4705                	li	a4,1
    80003b76:	04f76763          	bltu	a4,a5,80003bc4 <filestat+0x6e>
    80003b7a:	892a                	mv	s2,a0
    ilock(f->ip);
    80003b7c:	6c88                	ld	a0,24(s1)
    80003b7e:	fffff097          	auipc	ra,0xfffff
    80003b82:	06c080e7          	jalr	108(ra) # 80002bea <ilock>
    stati(f->ip, &st);
    80003b86:	fb840593          	addi	a1,s0,-72
    80003b8a:	6c88                	ld	a0,24(s1)
    80003b8c:	fffff097          	auipc	ra,0xfffff
    80003b90:	2e8080e7          	jalr	744(ra) # 80002e74 <stati>
    iunlock(f->ip);
    80003b94:	6c88                	ld	a0,24(s1)
    80003b96:	fffff097          	auipc	ra,0xfffff
    80003b9a:	116080e7          	jalr	278(ra) # 80002cac <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003b9e:	46e1                	li	a3,24
    80003ba0:	fb840613          	addi	a2,s0,-72
    80003ba4:	85ce                	mv	a1,s3
    80003ba6:	05093503          	ld	a0,80(s2)
    80003baa:	ffffd097          	auipc	ra,0xffffd
    80003bae:	fa8080e7          	jalr	-88(ra) # 80000b52 <copyout>
    80003bb2:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003bb6:	60a6                	ld	ra,72(sp)
    80003bb8:	6406                	ld	s0,64(sp)
    80003bba:	74e2                	ld	s1,56(sp)
    80003bbc:	7942                	ld	s2,48(sp)
    80003bbe:	79a2                	ld	s3,40(sp)
    80003bc0:	6161                	addi	sp,sp,80
    80003bc2:	8082                	ret
  return -1;
    80003bc4:	557d                	li	a0,-1
    80003bc6:	bfc5                	j	80003bb6 <filestat+0x60>

0000000080003bc8 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003bc8:	7179                	addi	sp,sp,-48
    80003bca:	f406                	sd	ra,40(sp)
    80003bcc:	f022                	sd	s0,32(sp)
    80003bce:	ec26                	sd	s1,24(sp)
    80003bd0:	e84a                	sd	s2,16(sp)
    80003bd2:	e44e                	sd	s3,8(sp)
    80003bd4:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003bd6:	00854783          	lbu	a5,8(a0)
    80003bda:	c3d5                	beqz	a5,80003c7e <fileread+0xb6>
    80003bdc:	84aa                	mv	s1,a0
    80003bde:	89ae                	mv	s3,a1
    80003be0:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003be2:	411c                	lw	a5,0(a0)
    80003be4:	4705                	li	a4,1
    80003be6:	04e78963          	beq	a5,a4,80003c38 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003bea:	470d                	li	a4,3
    80003bec:	04e78d63          	beq	a5,a4,80003c46 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003bf0:	4709                	li	a4,2
    80003bf2:	06e79e63          	bne	a5,a4,80003c6e <fileread+0xa6>
    ilock(f->ip);
    80003bf6:	6d08                	ld	a0,24(a0)
    80003bf8:	fffff097          	auipc	ra,0xfffff
    80003bfc:	ff2080e7          	jalr	-14(ra) # 80002bea <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003c00:	874a                	mv	a4,s2
    80003c02:	5094                	lw	a3,32(s1)
    80003c04:	864e                	mv	a2,s3
    80003c06:	4585                	li	a1,1
    80003c08:	6c88                	ld	a0,24(s1)
    80003c0a:	fffff097          	auipc	ra,0xfffff
    80003c0e:	294080e7          	jalr	660(ra) # 80002e9e <readi>
    80003c12:	892a                	mv	s2,a0
    80003c14:	00a05563          	blez	a0,80003c1e <fileread+0x56>
      f->off += r;
    80003c18:	509c                	lw	a5,32(s1)
    80003c1a:	9fa9                	addw	a5,a5,a0
    80003c1c:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003c1e:	6c88                	ld	a0,24(s1)
    80003c20:	fffff097          	auipc	ra,0xfffff
    80003c24:	08c080e7          	jalr	140(ra) # 80002cac <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003c28:	854a                	mv	a0,s2
    80003c2a:	70a2                	ld	ra,40(sp)
    80003c2c:	7402                	ld	s0,32(sp)
    80003c2e:	64e2                	ld	s1,24(sp)
    80003c30:	6942                	ld	s2,16(sp)
    80003c32:	69a2                	ld	s3,8(sp)
    80003c34:	6145                	addi	sp,sp,48
    80003c36:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c38:	6908                	ld	a0,16(a0)
    80003c3a:	00000097          	auipc	ra,0x0
    80003c3e:	3c0080e7          	jalr	960(ra) # 80003ffa <piperead>
    80003c42:	892a                	mv	s2,a0
    80003c44:	b7d5                	j	80003c28 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003c46:	02451783          	lh	a5,36(a0)
    80003c4a:	03079693          	slli	a3,a5,0x30
    80003c4e:	92c1                	srli	a3,a3,0x30
    80003c50:	4725                	li	a4,9
    80003c52:	02d76863          	bltu	a4,a3,80003c82 <fileread+0xba>
    80003c56:	0792                	slli	a5,a5,0x4
    80003c58:	00015717          	auipc	a4,0x15
    80003c5c:	67070713          	addi	a4,a4,1648 # 800192c8 <devsw>
    80003c60:	97ba                	add	a5,a5,a4
    80003c62:	639c                	ld	a5,0(a5)
    80003c64:	c38d                	beqz	a5,80003c86 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003c66:	4505                	li	a0,1
    80003c68:	9782                	jalr	a5
    80003c6a:	892a                	mv	s2,a0
    80003c6c:	bf75                	j	80003c28 <fileread+0x60>
    panic("fileread");
    80003c6e:	00005517          	auipc	a0,0x5
    80003c72:	b4a50513          	addi	a0,a0,-1206 # 800087b8 <syscall_names+0x268>
    80003c76:	00002097          	auipc	ra,0x2
    80003c7a:	fea080e7          	jalr	-22(ra) # 80005c60 <panic>
    return -1;
    80003c7e:	597d                	li	s2,-1
    80003c80:	b765                	j	80003c28 <fileread+0x60>
      return -1;
    80003c82:	597d                	li	s2,-1
    80003c84:	b755                	j	80003c28 <fileread+0x60>
    80003c86:	597d                	li	s2,-1
    80003c88:	b745                	j	80003c28 <fileread+0x60>

0000000080003c8a <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003c8a:	715d                	addi	sp,sp,-80
    80003c8c:	e486                	sd	ra,72(sp)
    80003c8e:	e0a2                	sd	s0,64(sp)
    80003c90:	fc26                	sd	s1,56(sp)
    80003c92:	f84a                	sd	s2,48(sp)
    80003c94:	f44e                	sd	s3,40(sp)
    80003c96:	f052                	sd	s4,32(sp)
    80003c98:	ec56                	sd	s5,24(sp)
    80003c9a:	e85a                	sd	s6,16(sp)
    80003c9c:	e45e                	sd	s7,8(sp)
    80003c9e:	e062                	sd	s8,0(sp)
    80003ca0:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003ca2:	00954783          	lbu	a5,9(a0)
    80003ca6:	10078663          	beqz	a5,80003db2 <filewrite+0x128>
    80003caa:	892a                	mv	s2,a0
    80003cac:	8b2e                	mv	s6,a1
    80003cae:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003cb0:	411c                	lw	a5,0(a0)
    80003cb2:	4705                	li	a4,1
    80003cb4:	02e78263          	beq	a5,a4,80003cd8 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003cb8:	470d                	li	a4,3
    80003cba:	02e78663          	beq	a5,a4,80003ce6 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003cbe:	4709                	li	a4,2
    80003cc0:	0ee79163          	bne	a5,a4,80003da2 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003cc4:	0ac05d63          	blez	a2,80003d7e <filewrite+0xf4>
    int i = 0;
    80003cc8:	4981                	li	s3,0
    80003cca:	6b85                	lui	s7,0x1
    80003ccc:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003cd0:	6c05                	lui	s8,0x1
    80003cd2:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003cd6:	a861                	j	80003d6e <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003cd8:	6908                	ld	a0,16(a0)
    80003cda:	00000097          	auipc	ra,0x0
    80003cde:	22e080e7          	jalr	558(ra) # 80003f08 <pipewrite>
    80003ce2:	8a2a                	mv	s4,a0
    80003ce4:	a045                	j	80003d84 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003ce6:	02451783          	lh	a5,36(a0)
    80003cea:	03079693          	slli	a3,a5,0x30
    80003cee:	92c1                	srli	a3,a3,0x30
    80003cf0:	4725                	li	a4,9
    80003cf2:	0cd76263          	bltu	a4,a3,80003db6 <filewrite+0x12c>
    80003cf6:	0792                	slli	a5,a5,0x4
    80003cf8:	00015717          	auipc	a4,0x15
    80003cfc:	5d070713          	addi	a4,a4,1488 # 800192c8 <devsw>
    80003d00:	97ba                	add	a5,a5,a4
    80003d02:	679c                	ld	a5,8(a5)
    80003d04:	cbdd                	beqz	a5,80003dba <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003d06:	4505                	li	a0,1
    80003d08:	9782                	jalr	a5
    80003d0a:	8a2a                	mv	s4,a0
    80003d0c:	a8a5                	j	80003d84 <filewrite+0xfa>
    80003d0e:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003d12:	00000097          	auipc	ra,0x0
    80003d16:	8b4080e7          	jalr	-1868(ra) # 800035c6 <begin_op>
      ilock(f->ip);
    80003d1a:	01893503          	ld	a0,24(s2)
    80003d1e:	fffff097          	auipc	ra,0xfffff
    80003d22:	ecc080e7          	jalr	-308(ra) # 80002bea <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d26:	8756                	mv	a4,s5
    80003d28:	02092683          	lw	a3,32(s2)
    80003d2c:	01698633          	add	a2,s3,s6
    80003d30:	4585                	li	a1,1
    80003d32:	01893503          	ld	a0,24(s2)
    80003d36:	fffff097          	auipc	ra,0xfffff
    80003d3a:	260080e7          	jalr	608(ra) # 80002f96 <writei>
    80003d3e:	84aa                	mv	s1,a0
    80003d40:	00a05763          	blez	a0,80003d4e <filewrite+0xc4>
        f->off += r;
    80003d44:	02092783          	lw	a5,32(s2)
    80003d48:	9fa9                	addw	a5,a5,a0
    80003d4a:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003d4e:	01893503          	ld	a0,24(s2)
    80003d52:	fffff097          	auipc	ra,0xfffff
    80003d56:	f5a080e7          	jalr	-166(ra) # 80002cac <iunlock>
      end_op();
    80003d5a:	00000097          	auipc	ra,0x0
    80003d5e:	8ea080e7          	jalr	-1814(ra) # 80003644 <end_op>

      if(r != n1){
    80003d62:	009a9f63          	bne	s5,s1,80003d80 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003d66:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003d6a:	0149db63          	bge	s3,s4,80003d80 <filewrite+0xf6>
      int n1 = n - i;
    80003d6e:	413a04bb          	subw	s1,s4,s3
    80003d72:	0004879b          	sext.w	a5,s1
    80003d76:	f8fbdce3          	bge	s7,a5,80003d0e <filewrite+0x84>
    80003d7a:	84e2                	mv	s1,s8
    80003d7c:	bf49                	j	80003d0e <filewrite+0x84>
    int i = 0;
    80003d7e:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003d80:	013a1f63          	bne	s4,s3,80003d9e <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003d84:	8552                	mv	a0,s4
    80003d86:	60a6                	ld	ra,72(sp)
    80003d88:	6406                	ld	s0,64(sp)
    80003d8a:	74e2                	ld	s1,56(sp)
    80003d8c:	7942                	ld	s2,48(sp)
    80003d8e:	79a2                	ld	s3,40(sp)
    80003d90:	7a02                	ld	s4,32(sp)
    80003d92:	6ae2                	ld	s5,24(sp)
    80003d94:	6b42                	ld	s6,16(sp)
    80003d96:	6ba2                	ld	s7,8(sp)
    80003d98:	6c02                	ld	s8,0(sp)
    80003d9a:	6161                	addi	sp,sp,80
    80003d9c:	8082                	ret
    ret = (i == n ? n : -1);
    80003d9e:	5a7d                	li	s4,-1
    80003da0:	b7d5                	j	80003d84 <filewrite+0xfa>
    panic("filewrite");
    80003da2:	00005517          	auipc	a0,0x5
    80003da6:	a2650513          	addi	a0,a0,-1498 # 800087c8 <syscall_names+0x278>
    80003daa:	00002097          	auipc	ra,0x2
    80003dae:	eb6080e7          	jalr	-330(ra) # 80005c60 <panic>
    return -1;
    80003db2:	5a7d                	li	s4,-1
    80003db4:	bfc1                	j	80003d84 <filewrite+0xfa>
      return -1;
    80003db6:	5a7d                	li	s4,-1
    80003db8:	b7f1                	j	80003d84 <filewrite+0xfa>
    80003dba:	5a7d                	li	s4,-1
    80003dbc:	b7e1                	j	80003d84 <filewrite+0xfa>

0000000080003dbe <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003dbe:	7179                	addi	sp,sp,-48
    80003dc0:	f406                	sd	ra,40(sp)
    80003dc2:	f022                	sd	s0,32(sp)
    80003dc4:	ec26                	sd	s1,24(sp)
    80003dc6:	e84a                	sd	s2,16(sp)
    80003dc8:	e44e                	sd	s3,8(sp)
    80003dca:	e052                	sd	s4,0(sp)
    80003dcc:	1800                	addi	s0,sp,48
    80003dce:	84aa                	mv	s1,a0
    80003dd0:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003dd2:	0005b023          	sd	zero,0(a1)
    80003dd6:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003dda:	00000097          	auipc	ra,0x0
    80003dde:	bf8080e7          	jalr	-1032(ra) # 800039d2 <filealloc>
    80003de2:	e088                	sd	a0,0(s1)
    80003de4:	c551                	beqz	a0,80003e70 <pipealloc+0xb2>
    80003de6:	00000097          	auipc	ra,0x0
    80003dea:	bec080e7          	jalr	-1044(ra) # 800039d2 <filealloc>
    80003dee:	00aa3023          	sd	a0,0(s4)
    80003df2:	c92d                	beqz	a0,80003e64 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003df4:	ffffc097          	auipc	ra,0xffffc
    80003df8:	326080e7          	jalr	806(ra) # 8000011a <kalloc>
    80003dfc:	892a                	mv	s2,a0
    80003dfe:	c125                	beqz	a0,80003e5e <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003e00:	4985                	li	s3,1
    80003e02:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003e06:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003e0a:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e0e:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e12:	00004597          	auipc	a1,0x4
    80003e16:	5ce58593          	addi	a1,a1,1486 # 800083e0 <states.0+0x1a0>
    80003e1a:	00002097          	auipc	ra,0x2
    80003e1e:	2ee080e7          	jalr	750(ra) # 80006108 <initlock>
  (*f0)->type = FD_PIPE;
    80003e22:	609c                	ld	a5,0(s1)
    80003e24:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e28:	609c                	ld	a5,0(s1)
    80003e2a:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e2e:	609c                	ld	a5,0(s1)
    80003e30:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e34:	609c                	ld	a5,0(s1)
    80003e36:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003e3a:	000a3783          	ld	a5,0(s4)
    80003e3e:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003e42:	000a3783          	ld	a5,0(s4)
    80003e46:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003e4a:	000a3783          	ld	a5,0(s4)
    80003e4e:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e52:	000a3783          	ld	a5,0(s4)
    80003e56:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e5a:	4501                	li	a0,0
    80003e5c:	a025                	j	80003e84 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003e5e:	6088                	ld	a0,0(s1)
    80003e60:	e501                	bnez	a0,80003e68 <pipealloc+0xaa>
    80003e62:	a039                	j	80003e70 <pipealloc+0xb2>
    80003e64:	6088                	ld	a0,0(s1)
    80003e66:	c51d                	beqz	a0,80003e94 <pipealloc+0xd6>
    fileclose(*f0);
    80003e68:	00000097          	auipc	ra,0x0
    80003e6c:	c26080e7          	jalr	-986(ra) # 80003a8e <fileclose>
  if(*f1)
    80003e70:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003e74:	557d                	li	a0,-1
  if(*f1)
    80003e76:	c799                	beqz	a5,80003e84 <pipealloc+0xc6>
    fileclose(*f1);
    80003e78:	853e                	mv	a0,a5
    80003e7a:	00000097          	auipc	ra,0x0
    80003e7e:	c14080e7          	jalr	-1004(ra) # 80003a8e <fileclose>
  return -1;
    80003e82:	557d                	li	a0,-1
}
    80003e84:	70a2                	ld	ra,40(sp)
    80003e86:	7402                	ld	s0,32(sp)
    80003e88:	64e2                	ld	s1,24(sp)
    80003e8a:	6942                	ld	s2,16(sp)
    80003e8c:	69a2                	ld	s3,8(sp)
    80003e8e:	6a02                	ld	s4,0(sp)
    80003e90:	6145                	addi	sp,sp,48
    80003e92:	8082                	ret
  return -1;
    80003e94:	557d                	li	a0,-1
    80003e96:	b7fd                	j	80003e84 <pipealloc+0xc6>

0000000080003e98 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003e98:	1101                	addi	sp,sp,-32
    80003e9a:	ec06                	sd	ra,24(sp)
    80003e9c:	e822                	sd	s0,16(sp)
    80003e9e:	e426                	sd	s1,8(sp)
    80003ea0:	e04a                	sd	s2,0(sp)
    80003ea2:	1000                	addi	s0,sp,32
    80003ea4:	84aa                	mv	s1,a0
    80003ea6:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003ea8:	00002097          	auipc	ra,0x2
    80003eac:	2f0080e7          	jalr	752(ra) # 80006198 <acquire>
  if(writable){
    80003eb0:	02090d63          	beqz	s2,80003eea <pipeclose+0x52>
    pi->writeopen = 0;
    80003eb4:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003eb8:	21848513          	addi	a0,s1,536
    80003ebc:	ffffe097          	auipc	ra,0xffffe
    80003ec0:	82e080e7          	jalr	-2002(ra) # 800016ea <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003ec4:	2204b783          	ld	a5,544(s1)
    80003ec8:	eb95                	bnez	a5,80003efc <pipeclose+0x64>
    release(&pi->lock);
    80003eca:	8526                	mv	a0,s1
    80003ecc:	00002097          	auipc	ra,0x2
    80003ed0:	380080e7          	jalr	896(ra) # 8000624c <release>
    kfree((char*)pi);
    80003ed4:	8526                	mv	a0,s1
    80003ed6:	ffffc097          	auipc	ra,0xffffc
    80003eda:	146080e7          	jalr	326(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003ede:	60e2                	ld	ra,24(sp)
    80003ee0:	6442                	ld	s0,16(sp)
    80003ee2:	64a2                	ld	s1,8(sp)
    80003ee4:	6902                	ld	s2,0(sp)
    80003ee6:	6105                	addi	sp,sp,32
    80003ee8:	8082                	ret
    pi->readopen = 0;
    80003eea:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003eee:	21c48513          	addi	a0,s1,540
    80003ef2:	ffffd097          	auipc	ra,0xffffd
    80003ef6:	7f8080e7          	jalr	2040(ra) # 800016ea <wakeup>
    80003efa:	b7e9                	j	80003ec4 <pipeclose+0x2c>
    release(&pi->lock);
    80003efc:	8526                	mv	a0,s1
    80003efe:	00002097          	auipc	ra,0x2
    80003f02:	34e080e7          	jalr	846(ra) # 8000624c <release>
}
    80003f06:	bfe1                	j	80003ede <pipeclose+0x46>

0000000080003f08 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003f08:	711d                	addi	sp,sp,-96
    80003f0a:	ec86                	sd	ra,88(sp)
    80003f0c:	e8a2                	sd	s0,80(sp)
    80003f0e:	e4a6                	sd	s1,72(sp)
    80003f10:	e0ca                	sd	s2,64(sp)
    80003f12:	fc4e                	sd	s3,56(sp)
    80003f14:	f852                	sd	s4,48(sp)
    80003f16:	f456                	sd	s5,40(sp)
    80003f18:	f05a                	sd	s6,32(sp)
    80003f1a:	ec5e                	sd	s7,24(sp)
    80003f1c:	e862                	sd	s8,16(sp)
    80003f1e:	1080                	addi	s0,sp,96
    80003f20:	84aa                	mv	s1,a0
    80003f22:	8aae                	mv	s5,a1
    80003f24:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003f26:	ffffd097          	auipc	ra,0xffffd
    80003f2a:	f68080e7          	jalr	-152(ra) # 80000e8e <myproc>
    80003f2e:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003f30:	8526                	mv	a0,s1
    80003f32:	00002097          	auipc	ra,0x2
    80003f36:	266080e7          	jalr	614(ra) # 80006198 <acquire>
  while(i < n){
    80003f3a:	0b405363          	blez	s4,80003fe0 <pipewrite+0xd8>
  int i = 0;
    80003f3e:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f40:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003f42:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003f46:	21c48b93          	addi	s7,s1,540
    80003f4a:	a089                	j	80003f8c <pipewrite+0x84>
      release(&pi->lock);
    80003f4c:	8526                	mv	a0,s1
    80003f4e:	00002097          	auipc	ra,0x2
    80003f52:	2fe080e7          	jalr	766(ra) # 8000624c <release>
      return -1;
    80003f56:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f58:	854a                	mv	a0,s2
    80003f5a:	60e6                	ld	ra,88(sp)
    80003f5c:	6446                	ld	s0,80(sp)
    80003f5e:	64a6                	ld	s1,72(sp)
    80003f60:	6906                	ld	s2,64(sp)
    80003f62:	79e2                	ld	s3,56(sp)
    80003f64:	7a42                	ld	s4,48(sp)
    80003f66:	7aa2                	ld	s5,40(sp)
    80003f68:	7b02                	ld	s6,32(sp)
    80003f6a:	6be2                	ld	s7,24(sp)
    80003f6c:	6c42                	ld	s8,16(sp)
    80003f6e:	6125                	addi	sp,sp,96
    80003f70:	8082                	ret
      wakeup(&pi->nread);
    80003f72:	8562                	mv	a0,s8
    80003f74:	ffffd097          	auipc	ra,0xffffd
    80003f78:	776080e7          	jalr	1910(ra) # 800016ea <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003f7c:	85a6                	mv	a1,s1
    80003f7e:	855e                	mv	a0,s7
    80003f80:	ffffd097          	auipc	ra,0xffffd
    80003f84:	5de080e7          	jalr	1502(ra) # 8000155e <sleep>
  while(i < n){
    80003f88:	05495d63          	bge	s2,s4,80003fe2 <pipewrite+0xda>
    if(pi->readopen == 0 || pr->killed){
    80003f8c:	2204a783          	lw	a5,544(s1)
    80003f90:	dfd5                	beqz	a5,80003f4c <pipewrite+0x44>
    80003f92:	0289a783          	lw	a5,40(s3)
    80003f96:	fbdd                	bnez	a5,80003f4c <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003f98:	2184a783          	lw	a5,536(s1)
    80003f9c:	21c4a703          	lw	a4,540(s1)
    80003fa0:	2007879b          	addiw	a5,a5,512
    80003fa4:	fcf707e3          	beq	a4,a5,80003f72 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003fa8:	4685                	li	a3,1
    80003faa:	01590633          	add	a2,s2,s5
    80003fae:	faf40593          	addi	a1,s0,-81
    80003fb2:	0509b503          	ld	a0,80(s3)
    80003fb6:	ffffd097          	auipc	ra,0xffffd
    80003fba:	c28080e7          	jalr	-984(ra) # 80000bde <copyin>
    80003fbe:	03650263          	beq	a0,s6,80003fe2 <pipewrite+0xda>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003fc2:	21c4a783          	lw	a5,540(s1)
    80003fc6:	0017871b          	addiw	a4,a5,1
    80003fca:	20e4ae23          	sw	a4,540(s1)
    80003fce:	1ff7f793          	andi	a5,a5,511
    80003fd2:	97a6                	add	a5,a5,s1
    80003fd4:	faf44703          	lbu	a4,-81(s0)
    80003fd8:	00e78c23          	sb	a4,24(a5)
      i++;
    80003fdc:	2905                	addiw	s2,s2,1
    80003fde:	b76d                	j	80003f88 <pipewrite+0x80>
  int i = 0;
    80003fe0:	4901                	li	s2,0
  wakeup(&pi->nread);
    80003fe2:	21848513          	addi	a0,s1,536
    80003fe6:	ffffd097          	auipc	ra,0xffffd
    80003fea:	704080e7          	jalr	1796(ra) # 800016ea <wakeup>
  release(&pi->lock);
    80003fee:	8526                	mv	a0,s1
    80003ff0:	00002097          	auipc	ra,0x2
    80003ff4:	25c080e7          	jalr	604(ra) # 8000624c <release>
  return i;
    80003ff8:	b785                	j	80003f58 <pipewrite+0x50>

0000000080003ffa <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003ffa:	715d                	addi	sp,sp,-80
    80003ffc:	e486                	sd	ra,72(sp)
    80003ffe:	e0a2                	sd	s0,64(sp)
    80004000:	fc26                	sd	s1,56(sp)
    80004002:	f84a                	sd	s2,48(sp)
    80004004:	f44e                	sd	s3,40(sp)
    80004006:	f052                	sd	s4,32(sp)
    80004008:	ec56                	sd	s5,24(sp)
    8000400a:	e85a                	sd	s6,16(sp)
    8000400c:	0880                	addi	s0,sp,80
    8000400e:	84aa                	mv	s1,a0
    80004010:	892e                	mv	s2,a1
    80004012:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004014:	ffffd097          	auipc	ra,0xffffd
    80004018:	e7a080e7          	jalr	-390(ra) # 80000e8e <myproc>
    8000401c:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000401e:	8526                	mv	a0,s1
    80004020:	00002097          	auipc	ra,0x2
    80004024:	178080e7          	jalr	376(ra) # 80006198 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004028:	2184a703          	lw	a4,536(s1)
    8000402c:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004030:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004034:	02f71463          	bne	a4,a5,8000405c <piperead+0x62>
    80004038:	2244a783          	lw	a5,548(s1)
    8000403c:	c385                	beqz	a5,8000405c <piperead+0x62>
    if(pr->killed){
    8000403e:	028a2783          	lw	a5,40(s4)
    80004042:	ebc9                	bnez	a5,800040d4 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004044:	85a6                	mv	a1,s1
    80004046:	854e                	mv	a0,s3
    80004048:	ffffd097          	auipc	ra,0xffffd
    8000404c:	516080e7          	jalr	1302(ra) # 8000155e <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004050:	2184a703          	lw	a4,536(s1)
    80004054:	21c4a783          	lw	a5,540(s1)
    80004058:	fef700e3          	beq	a4,a5,80004038 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000405c:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000405e:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004060:	05505463          	blez	s5,800040a8 <piperead+0xae>
    if(pi->nread == pi->nwrite)
    80004064:	2184a783          	lw	a5,536(s1)
    80004068:	21c4a703          	lw	a4,540(s1)
    8000406c:	02f70e63          	beq	a4,a5,800040a8 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004070:	0017871b          	addiw	a4,a5,1
    80004074:	20e4ac23          	sw	a4,536(s1)
    80004078:	1ff7f793          	andi	a5,a5,511
    8000407c:	97a6                	add	a5,a5,s1
    8000407e:	0187c783          	lbu	a5,24(a5)
    80004082:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004086:	4685                	li	a3,1
    80004088:	fbf40613          	addi	a2,s0,-65
    8000408c:	85ca                	mv	a1,s2
    8000408e:	050a3503          	ld	a0,80(s4)
    80004092:	ffffd097          	auipc	ra,0xffffd
    80004096:	ac0080e7          	jalr	-1344(ra) # 80000b52 <copyout>
    8000409a:	01650763          	beq	a0,s6,800040a8 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000409e:	2985                	addiw	s3,s3,1
    800040a0:	0905                	addi	s2,s2,1
    800040a2:	fd3a91e3          	bne	s5,s3,80004064 <piperead+0x6a>
    800040a6:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800040a8:	21c48513          	addi	a0,s1,540
    800040ac:	ffffd097          	auipc	ra,0xffffd
    800040b0:	63e080e7          	jalr	1598(ra) # 800016ea <wakeup>
  release(&pi->lock);
    800040b4:	8526                	mv	a0,s1
    800040b6:	00002097          	auipc	ra,0x2
    800040ba:	196080e7          	jalr	406(ra) # 8000624c <release>
  return i;
}
    800040be:	854e                	mv	a0,s3
    800040c0:	60a6                	ld	ra,72(sp)
    800040c2:	6406                	ld	s0,64(sp)
    800040c4:	74e2                	ld	s1,56(sp)
    800040c6:	7942                	ld	s2,48(sp)
    800040c8:	79a2                	ld	s3,40(sp)
    800040ca:	7a02                	ld	s4,32(sp)
    800040cc:	6ae2                	ld	s5,24(sp)
    800040ce:	6b42                	ld	s6,16(sp)
    800040d0:	6161                	addi	sp,sp,80
    800040d2:	8082                	ret
      release(&pi->lock);
    800040d4:	8526                	mv	a0,s1
    800040d6:	00002097          	auipc	ra,0x2
    800040da:	176080e7          	jalr	374(ra) # 8000624c <release>
      return -1;
    800040de:	59fd                	li	s3,-1
    800040e0:	bff9                	j	800040be <piperead+0xc4>

00000000800040e2 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800040e2:	de010113          	addi	sp,sp,-544
    800040e6:	20113c23          	sd	ra,536(sp)
    800040ea:	20813823          	sd	s0,528(sp)
    800040ee:	20913423          	sd	s1,520(sp)
    800040f2:	21213023          	sd	s2,512(sp)
    800040f6:	ffce                	sd	s3,504(sp)
    800040f8:	fbd2                	sd	s4,496(sp)
    800040fa:	f7d6                	sd	s5,488(sp)
    800040fc:	f3da                	sd	s6,480(sp)
    800040fe:	efde                	sd	s7,472(sp)
    80004100:	ebe2                	sd	s8,464(sp)
    80004102:	e7e6                	sd	s9,456(sp)
    80004104:	e3ea                	sd	s10,448(sp)
    80004106:	ff6e                	sd	s11,440(sp)
    80004108:	1400                	addi	s0,sp,544
    8000410a:	892a                	mv	s2,a0
    8000410c:	dea43423          	sd	a0,-536(s0)
    80004110:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004114:	ffffd097          	auipc	ra,0xffffd
    80004118:	d7a080e7          	jalr	-646(ra) # 80000e8e <myproc>
    8000411c:	84aa                	mv	s1,a0

  begin_op();
    8000411e:	fffff097          	auipc	ra,0xfffff
    80004122:	4a8080e7          	jalr	1192(ra) # 800035c6 <begin_op>

  if((ip = namei(path)) == 0){
    80004126:	854a                	mv	a0,s2
    80004128:	fffff097          	auipc	ra,0xfffff
    8000412c:	27e080e7          	jalr	638(ra) # 800033a6 <namei>
    80004130:	c93d                	beqz	a0,800041a6 <exec+0xc4>
    80004132:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004134:	fffff097          	auipc	ra,0xfffff
    80004138:	ab6080e7          	jalr	-1354(ra) # 80002bea <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000413c:	04000713          	li	a4,64
    80004140:	4681                	li	a3,0
    80004142:	e5040613          	addi	a2,s0,-432
    80004146:	4581                	li	a1,0
    80004148:	8556                	mv	a0,s5
    8000414a:	fffff097          	auipc	ra,0xfffff
    8000414e:	d54080e7          	jalr	-684(ra) # 80002e9e <readi>
    80004152:	04000793          	li	a5,64
    80004156:	00f51a63          	bne	a0,a5,8000416a <exec+0x88>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    8000415a:	e5042703          	lw	a4,-432(s0)
    8000415e:	464c47b7          	lui	a5,0x464c4
    80004162:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004166:	04f70663          	beq	a4,a5,800041b2 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000416a:	8556                	mv	a0,s5
    8000416c:	fffff097          	auipc	ra,0xfffff
    80004170:	ce0080e7          	jalr	-800(ra) # 80002e4c <iunlockput>
    end_op();
    80004174:	fffff097          	auipc	ra,0xfffff
    80004178:	4d0080e7          	jalr	1232(ra) # 80003644 <end_op>
  }
  return -1;
    8000417c:	557d                	li	a0,-1
}
    8000417e:	21813083          	ld	ra,536(sp)
    80004182:	21013403          	ld	s0,528(sp)
    80004186:	20813483          	ld	s1,520(sp)
    8000418a:	20013903          	ld	s2,512(sp)
    8000418e:	79fe                	ld	s3,504(sp)
    80004190:	7a5e                	ld	s4,496(sp)
    80004192:	7abe                	ld	s5,488(sp)
    80004194:	7b1e                	ld	s6,480(sp)
    80004196:	6bfe                	ld	s7,472(sp)
    80004198:	6c5e                	ld	s8,464(sp)
    8000419a:	6cbe                	ld	s9,456(sp)
    8000419c:	6d1e                	ld	s10,448(sp)
    8000419e:	7dfa                	ld	s11,440(sp)
    800041a0:	22010113          	addi	sp,sp,544
    800041a4:	8082                	ret
    end_op();
    800041a6:	fffff097          	auipc	ra,0xfffff
    800041aa:	49e080e7          	jalr	1182(ra) # 80003644 <end_op>
    return -1;
    800041ae:	557d                	li	a0,-1
    800041b0:	b7f9                	j	8000417e <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    800041b2:	8526                	mv	a0,s1
    800041b4:	ffffd097          	auipc	ra,0xffffd
    800041b8:	d9e080e7          	jalr	-610(ra) # 80000f52 <proc_pagetable>
    800041bc:	8b2a                	mv	s6,a0
    800041be:	d555                	beqz	a0,8000416a <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041c0:	e7042783          	lw	a5,-400(s0)
    800041c4:	e8845703          	lhu	a4,-376(s0)
    800041c8:	c735                	beqz	a4,80004234 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800041ca:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041cc:	e0043423          	sd	zero,-504(s0)
    if((ph.vaddr % PGSIZE) != 0)
    800041d0:	6a05                	lui	s4,0x1
    800041d2:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    800041d6:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    800041da:	6d85                	lui	s11,0x1
    800041dc:	7d7d                	lui	s10,0xfffff
    800041de:	ac1d                	j	80004414 <exec+0x332>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800041e0:	00004517          	auipc	a0,0x4
    800041e4:	5f850513          	addi	a0,a0,1528 # 800087d8 <syscall_names+0x288>
    800041e8:	00002097          	auipc	ra,0x2
    800041ec:	a78080e7          	jalr	-1416(ra) # 80005c60 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800041f0:	874a                	mv	a4,s2
    800041f2:	009c86bb          	addw	a3,s9,s1
    800041f6:	4581                	li	a1,0
    800041f8:	8556                	mv	a0,s5
    800041fa:	fffff097          	auipc	ra,0xfffff
    800041fe:	ca4080e7          	jalr	-860(ra) # 80002e9e <readi>
    80004202:	2501                	sext.w	a0,a0
    80004204:	1aa91863          	bne	s2,a0,800043b4 <exec+0x2d2>
  for(i = 0; i < sz; i += PGSIZE){
    80004208:	009d84bb          	addw	s1,s11,s1
    8000420c:	013d09bb          	addw	s3,s10,s3
    80004210:	1f74f263          	bgeu	s1,s7,800043f4 <exec+0x312>
    pa = walkaddr(pagetable, va + i);
    80004214:	02049593          	slli	a1,s1,0x20
    80004218:	9181                	srli	a1,a1,0x20
    8000421a:	95e2                	add	a1,a1,s8
    8000421c:	855a                	mv	a0,s6
    8000421e:	ffffc097          	auipc	ra,0xffffc
    80004222:	32c080e7          	jalr	812(ra) # 8000054a <walkaddr>
    80004226:	862a                	mv	a2,a0
    if(pa == 0)
    80004228:	dd45                	beqz	a0,800041e0 <exec+0xfe>
      n = PGSIZE;
    8000422a:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    8000422c:	fd49f2e3          	bgeu	s3,s4,800041f0 <exec+0x10e>
      n = sz - i;
    80004230:	894e                	mv	s2,s3
    80004232:	bf7d                	j	800041f0 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004234:	4481                	li	s1,0
  iunlockput(ip);
    80004236:	8556                	mv	a0,s5
    80004238:	fffff097          	auipc	ra,0xfffff
    8000423c:	c14080e7          	jalr	-1004(ra) # 80002e4c <iunlockput>
  end_op();
    80004240:	fffff097          	auipc	ra,0xfffff
    80004244:	404080e7          	jalr	1028(ra) # 80003644 <end_op>
  p = myproc();
    80004248:	ffffd097          	auipc	ra,0xffffd
    8000424c:	c46080e7          	jalr	-954(ra) # 80000e8e <myproc>
    80004250:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80004252:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004256:	6785                	lui	a5,0x1
    80004258:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000425a:	97a6                	add	a5,a5,s1
    8000425c:	777d                	lui	a4,0xfffff
    8000425e:	8ff9                	and	a5,a5,a4
    80004260:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004264:	6609                	lui	a2,0x2
    80004266:	963e                	add	a2,a2,a5
    80004268:	85be                	mv	a1,a5
    8000426a:	855a                	mv	a0,s6
    8000426c:	ffffc097          	auipc	ra,0xffffc
    80004270:	692080e7          	jalr	1682(ra) # 800008fe <uvmalloc>
    80004274:	8c2a                	mv	s8,a0
  ip = 0;
    80004276:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004278:	12050e63          	beqz	a0,800043b4 <exec+0x2d2>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000427c:	75f9                	lui	a1,0xffffe
    8000427e:	95aa                	add	a1,a1,a0
    80004280:	855a                	mv	a0,s6
    80004282:	ffffd097          	auipc	ra,0xffffd
    80004286:	89e080e7          	jalr	-1890(ra) # 80000b20 <uvmclear>
  stackbase = sp - PGSIZE;
    8000428a:	7afd                	lui	s5,0xfffff
    8000428c:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    8000428e:	df043783          	ld	a5,-528(s0)
    80004292:	6388                	ld	a0,0(a5)
    80004294:	c925                	beqz	a0,80004304 <exec+0x222>
    80004296:	e9040993          	addi	s3,s0,-368
    8000429a:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    8000429e:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800042a0:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800042a2:	ffffc097          	auipc	ra,0xffffc
    800042a6:	09e080e7          	jalr	158(ra) # 80000340 <strlen>
    800042aa:	0015079b          	addiw	a5,a0,1
    800042ae:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800042b2:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800042b6:	13596363          	bltu	s2,s5,800043dc <exec+0x2fa>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800042ba:	df043d83          	ld	s11,-528(s0)
    800042be:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    800042c2:	8552                	mv	a0,s4
    800042c4:	ffffc097          	auipc	ra,0xffffc
    800042c8:	07c080e7          	jalr	124(ra) # 80000340 <strlen>
    800042cc:	0015069b          	addiw	a3,a0,1
    800042d0:	8652                	mv	a2,s4
    800042d2:	85ca                	mv	a1,s2
    800042d4:	855a                	mv	a0,s6
    800042d6:	ffffd097          	auipc	ra,0xffffd
    800042da:	87c080e7          	jalr	-1924(ra) # 80000b52 <copyout>
    800042de:	10054363          	bltz	a0,800043e4 <exec+0x302>
    ustack[argc] = sp;
    800042e2:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800042e6:	0485                	addi	s1,s1,1
    800042e8:	008d8793          	addi	a5,s11,8
    800042ec:	def43823          	sd	a5,-528(s0)
    800042f0:	008db503          	ld	a0,8(s11)
    800042f4:	c911                	beqz	a0,80004308 <exec+0x226>
    if(argc >= MAXARG)
    800042f6:	09a1                	addi	s3,s3,8
    800042f8:	fb3c95e3          	bne	s9,s3,800042a2 <exec+0x1c0>
  sz = sz1;
    800042fc:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004300:	4a81                	li	s5,0
    80004302:	a84d                	j	800043b4 <exec+0x2d2>
  sp = sz;
    80004304:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004306:	4481                	li	s1,0
  ustack[argc] = 0;
    80004308:	00349793          	slli	a5,s1,0x3
    8000430c:	f9078793          	addi	a5,a5,-112
    80004310:	97a2                	add	a5,a5,s0
    80004312:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004316:	00148693          	addi	a3,s1,1
    8000431a:	068e                	slli	a3,a3,0x3
    8000431c:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004320:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004324:	01597663          	bgeu	s2,s5,80004330 <exec+0x24e>
  sz = sz1;
    80004328:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000432c:	4a81                	li	s5,0
    8000432e:	a059                	j	800043b4 <exec+0x2d2>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004330:	e9040613          	addi	a2,s0,-368
    80004334:	85ca                	mv	a1,s2
    80004336:	855a                	mv	a0,s6
    80004338:	ffffd097          	auipc	ra,0xffffd
    8000433c:	81a080e7          	jalr	-2022(ra) # 80000b52 <copyout>
    80004340:	0a054663          	bltz	a0,800043ec <exec+0x30a>
  p->trapframe->a1 = sp;
    80004344:	058bb783          	ld	a5,88(s7)
    80004348:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000434c:	de843783          	ld	a5,-536(s0)
    80004350:	0007c703          	lbu	a4,0(a5)
    80004354:	cf11                	beqz	a4,80004370 <exec+0x28e>
    80004356:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004358:	02f00693          	li	a3,47
    8000435c:	a039                	j	8000436a <exec+0x288>
      last = s+1;
    8000435e:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80004362:	0785                	addi	a5,a5,1
    80004364:	fff7c703          	lbu	a4,-1(a5)
    80004368:	c701                	beqz	a4,80004370 <exec+0x28e>
    if(*s == '/')
    8000436a:	fed71ce3          	bne	a4,a3,80004362 <exec+0x280>
    8000436e:	bfc5                	j	8000435e <exec+0x27c>
  safestrcpy(p->name, last, sizeof(p->name));
    80004370:	4641                	li	a2,16
    80004372:	de843583          	ld	a1,-536(s0)
    80004376:	158b8513          	addi	a0,s7,344
    8000437a:	ffffc097          	auipc	ra,0xffffc
    8000437e:	f94080e7          	jalr	-108(ra) # 8000030e <safestrcpy>
  oldpagetable = p->pagetable;
    80004382:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80004386:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    8000438a:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000438e:	058bb783          	ld	a5,88(s7)
    80004392:	e6843703          	ld	a4,-408(s0)
    80004396:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004398:	058bb783          	ld	a5,88(s7)
    8000439c:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800043a0:	85ea                	mv	a1,s10
    800043a2:	ffffd097          	auipc	ra,0xffffd
    800043a6:	c4c080e7          	jalr	-948(ra) # 80000fee <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800043aa:	0004851b          	sext.w	a0,s1
    800043ae:	bbc1                	j	8000417e <exec+0x9c>
    800043b0:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    800043b4:	df843583          	ld	a1,-520(s0)
    800043b8:	855a                	mv	a0,s6
    800043ba:	ffffd097          	auipc	ra,0xffffd
    800043be:	c34080e7          	jalr	-972(ra) # 80000fee <proc_freepagetable>
  if(ip){
    800043c2:	da0a94e3          	bnez	s5,8000416a <exec+0x88>
  return -1;
    800043c6:	557d                	li	a0,-1
    800043c8:	bb5d                	j	8000417e <exec+0x9c>
    800043ca:	de943c23          	sd	s1,-520(s0)
    800043ce:	b7dd                	j	800043b4 <exec+0x2d2>
    800043d0:	de943c23          	sd	s1,-520(s0)
    800043d4:	b7c5                	j	800043b4 <exec+0x2d2>
    800043d6:	de943c23          	sd	s1,-520(s0)
    800043da:	bfe9                	j	800043b4 <exec+0x2d2>
  sz = sz1;
    800043dc:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800043e0:	4a81                	li	s5,0
    800043e2:	bfc9                	j	800043b4 <exec+0x2d2>
  sz = sz1;
    800043e4:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800043e8:	4a81                	li	s5,0
    800043ea:	b7e9                	j	800043b4 <exec+0x2d2>
  sz = sz1;
    800043ec:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800043f0:	4a81                	li	s5,0
    800043f2:	b7c9                	j	800043b4 <exec+0x2d2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800043f4:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043f8:	e0843783          	ld	a5,-504(s0)
    800043fc:	0017869b          	addiw	a3,a5,1
    80004400:	e0d43423          	sd	a3,-504(s0)
    80004404:	e0043783          	ld	a5,-512(s0)
    80004408:	0387879b          	addiw	a5,a5,56
    8000440c:	e8845703          	lhu	a4,-376(s0)
    80004410:	e2e6d3e3          	bge	a3,a4,80004236 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004414:	2781                	sext.w	a5,a5
    80004416:	e0f43023          	sd	a5,-512(s0)
    8000441a:	03800713          	li	a4,56
    8000441e:	86be                	mv	a3,a5
    80004420:	e1840613          	addi	a2,s0,-488
    80004424:	4581                	li	a1,0
    80004426:	8556                	mv	a0,s5
    80004428:	fffff097          	auipc	ra,0xfffff
    8000442c:	a76080e7          	jalr	-1418(ra) # 80002e9e <readi>
    80004430:	03800793          	li	a5,56
    80004434:	f6f51ee3          	bne	a0,a5,800043b0 <exec+0x2ce>
    if(ph.type != ELF_PROG_LOAD)
    80004438:	e1842783          	lw	a5,-488(s0)
    8000443c:	4705                	li	a4,1
    8000443e:	fae79de3          	bne	a5,a4,800043f8 <exec+0x316>
    if(ph.memsz < ph.filesz)
    80004442:	e4043603          	ld	a2,-448(s0)
    80004446:	e3843783          	ld	a5,-456(s0)
    8000444a:	f8f660e3          	bltu	a2,a5,800043ca <exec+0x2e8>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000444e:	e2843783          	ld	a5,-472(s0)
    80004452:	963e                	add	a2,a2,a5
    80004454:	f6f66ee3          	bltu	a2,a5,800043d0 <exec+0x2ee>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004458:	85a6                	mv	a1,s1
    8000445a:	855a                	mv	a0,s6
    8000445c:	ffffc097          	auipc	ra,0xffffc
    80004460:	4a2080e7          	jalr	1186(ra) # 800008fe <uvmalloc>
    80004464:	dea43c23          	sd	a0,-520(s0)
    80004468:	d53d                	beqz	a0,800043d6 <exec+0x2f4>
    if((ph.vaddr % PGSIZE) != 0)
    8000446a:	e2843c03          	ld	s8,-472(s0)
    8000446e:	de043783          	ld	a5,-544(s0)
    80004472:	00fc77b3          	and	a5,s8,a5
    80004476:	ff9d                	bnez	a5,800043b4 <exec+0x2d2>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004478:	e2042c83          	lw	s9,-480(s0)
    8000447c:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004480:	f60b8ae3          	beqz	s7,800043f4 <exec+0x312>
    80004484:	89de                	mv	s3,s7
    80004486:	4481                	li	s1,0
    80004488:	b371                	j	80004214 <exec+0x132>

000000008000448a <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000448a:	7179                	addi	sp,sp,-48
    8000448c:	f406                	sd	ra,40(sp)
    8000448e:	f022                	sd	s0,32(sp)
    80004490:	ec26                	sd	s1,24(sp)
    80004492:	e84a                	sd	s2,16(sp)
    80004494:	1800                	addi	s0,sp,48
    80004496:	892e                	mv	s2,a1
    80004498:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    8000449a:	fdc40593          	addi	a1,s0,-36
    8000449e:	ffffe097          	auipc	ra,0xffffe
    800044a2:	b06080e7          	jalr	-1274(ra) # 80001fa4 <argint>
    800044a6:	04054063          	bltz	a0,800044e6 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800044aa:	fdc42703          	lw	a4,-36(s0)
    800044ae:	47bd                	li	a5,15
    800044b0:	02e7ed63          	bltu	a5,a4,800044ea <argfd+0x60>
    800044b4:	ffffd097          	auipc	ra,0xffffd
    800044b8:	9da080e7          	jalr	-1574(ra) # 80000e8e <myproc>
    800044bc:	fdc42703          	lw	a4,-36(s0)
    800044c0:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7ffd8dda>
    800044c4:	078e                	slli	a5,a5,0x3
    800044c6:	953e                	add	a0,a0,a5
    800044c8:	611c                	ld	a5,0(a0)
    800044ca:	c395                	beqz	a5,800044ee <argfd+0x64>
    return -1;
  if(pfd)
    800044cc:	00090463          	beqz	s2,800044d4 <argfd+0x4a>
    *pfd = fd;
    800044d0:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800044d4:	4501                	li	a0,0
  if(pf)
    800044d6:	c091                	beqz	s1,800044da <argfd+0x50>
    *pf = f;
    800044d8:	e09c                	sd	a5,0(s1)
}
    800044da:	70a2                	ld	ra,40(sp)
    800044dc:	7402                	ld	s0,32(sp)
    800044de:	64e2                	ld	s1,24(sp)
    800044e0:	6942                	ld	s2,16(sp)
    800044e2:	6145                	addi	sp,sp,48
    800044e4:	8082                	ret
    return -1;
    800044e6:	557d                	li	a0,-1
    800044e8:	bfcd                	j	800044da <argfd+0x50>
    return -1;
    800044ea:	557d                	li	a0,-1
    800044ec:	b7fd                	j	800044da <argfd+0x50>
    800044ee:	557d                	li	a0,-1
    800044f0:	b7ed                	j	800044da <argfd+0x50>

00000000800044f2 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800044f2:	1101                	addi	sp,sp,-32
    800044f4:	ec06                	sd	ra,24(sp)
    800044f6:	e822                	sd	s0,16(sp)
    800044f8:	e426                	sd	s1,8(sp)
    800044fa:	1000                	addi	s0,sp,32
    800044fc:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800044fe:	ffffd097          	auipc	ra,0xffffd
    80004502:	990080e7          	jalr	-1648(ra) # 80000e8e <myproc>
    80004506:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004508:	0d050793          	addi	a5,a0,208
    8000450c:	4501                	li	a0,0
    8000450e:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004510:	6398                	ld	a4,0(a5)
    80004512:	cb19                	beqz	a4,80004528 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004514:	2505                	addiw	a0,a0,1
    80004516:	07a1                	addi	a5,a5,8
    80004518:	fed51ce3          	bne	a0,a3,80004510 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000451c:	557d                	li	a0,-1
}
    8000451e:	60e2                	ld	ra,24(sp)
    80004520:	6442                	ld	s0,16(sp)
    80004522:	64a2                	ld	s1,8(sp)
    80004524:	6105                	addi	sp,sp,32
    80004526:	8082                	ret
      p->ofile[fd] = f;
    80004528:	01a50793          	addi	a5,a0,26
    8000452c:	078e                	slli	a5,a5,0x3
    8000452e:	963e                	add	a2,a2,a5
    80004530:	e204                	sd	s1,0(a2)
      return fd;
    80004532:	b7f5                	j	8000451e <fdalloc+0x2c>

0000000080004534 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004534:	715d                	addi	sp,sp,-80
    80004536:	e486                	sd	ra,72(sp)
    80004538:	e0a2                	sd	s0,64(sp)
    8000453a:	fc26                	sd	s1,56(sp)
    8000453c:	f84a                	sd	s2,48(sp)
    8000453e:	f44e                	sd	s3,40(sp)
    80004540:	f052                	sd	s4,32(sp)
    80004542:	ec56                	sd	s5,24(sp)
    80004544:	0880                	addi	s0,sp,80
    80004546:	89ae                	mv	s3,a1
    80004548:	8ab2                	mv	s5,a2
    8000454a:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000454c:	fb040593          	addi	a1,s0,-80
    80004550:	fffff097          	auipc	ra,0xfffff
    80004554:	e74080e7          	jalr	-396(ra) # 800033c4 <nameiparent>
    80004558:	892a                	mv	s2,a0
    8000455a:	12050e63          	beqz	a0,80004696 <create+0x162>
    return 0;

  ilock(dp);
    8000455e:	ffffe097          	auipc	ra,0xffffe
    80004562:	68c080e7          	jalr	1676(ra) # 80002bea <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004566:	4601                	li	a2,0
    80004568:	fb040593          	addi	a1,s0,-80
    8000456c:	854a                	mv	a0,s2
    8000456e:	fffff097          	auipc	ra,0xfffff
    80004572:	b60080e7          	jalr	-1184(ra) # 800030ce <dirlookup>
    80004576:	84aa                	mv	s1,a0
    80004578:	c921                	beqz	a0,800045c8 <create+0x94>
    iunlockput(dp);
    8000457a:	854a                	mv	a0,s2
    8000457c:	fffff097          	auipc	ra,0xfffff
    80004580:	8d0080e7          	jalr	-1840(ra) # 80002e4c <iunlockput>
    ilock(ip);
    80004584:	8526                	mv	a0,s1
    80004586:	ffffe097          	auipc	ra,0xffffe
    8000458a:	664080e7          	jalr	1636(ra) # 80002bea <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000458e:	2981                	sext.w	s3,s3
    80004590:	4789                	li	a5,2
    80004592:	02f99463          	bne	s3,a5,800045ba <create+0x86>
    80004596:	0444d783          	lhu	a5,68(s1)
    8000459a:	37f9                	addiw	a5,a5,-2
    8000459c:	17c2                	slli	a5,a5,0x30
    8000459e:	93c1                	srli	a5,a5,0x30
    800045a0:	4705                	li	a4,1
    800045a2:	00f76c63          	bltu	a4,a5,800045ba <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800045a6:	8526                	mv	a0,s1
    800045a8:	60a6                	ld	ra,72(sp)
    800045aa:	6406                	ld	s0,64(sp)
    800045ac:	74e2                	ld	s1,56(sp)
    800045ae:	7942                	ld	s2,48(sp)
    800045b0:	79a2                	ld	s3,40(sp)
    800045b2:	7a02                	ld	s4,32(sp)
    800045b4:	6ae2                	ld	s5,24(sp)
    800045b6:	6161                	addi	sp,sp,80
    800045b8:	8082                	ret
    iunlockput(ip);
    800045ba:	8526                	mv	a0,s1
    800045bc:	fffff097          	auipc	ra,0xfffff
    800045c0:	890080e7          	jalr	-1904(ra) # 80002e4c <iunlockput>
    return 0;
    800045c4:	4481                	li	s1,0
    800045c6:	b7c5                	j	800045a6 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    800045c8:	85ce                	mv	a1,s3
    800045ca:	00092503          	lw	a0,0(s2)
    800045ce:	ffffe097          	auipc	ra,0xffffe
    800045d2:	482080e7          	jalr	1154(ra) # 80002a50 <ialloc>
    800045d6:	84aa                	mv	s1,a0
    800045d8:	c521                	beqz	a0,80004620 <create+0xec>
  ilock(ip);
    800045da:	ffffe097          	auipc	ra,0xffffe
    800045de:	610080e7          	jalr	1552(ra) # 80002bea <ilock>
  ip->major = major;
    800045e2:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    800045e6:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    800045ea:	4a05                	li	s4,1
    800045ec:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    800045f0:	8526                	mv	a0,s1
    800045f2:	ffffe097          	auipc	ra,0xffffe
    800045f6:	52c080e7          	jalr	1324(ra) # 80002b1e <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800045fa:	2981                	sext.w	s3,s3
    800045fc:	03498a63          	beq	s3,s4,80004630 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    80004600:	40d0                	lw	a2,4(s1)
    80004602:	fb040593          	addi	a1,s0,-80
    80004606:	854a                	mv	a0,s2
    80004608:	fffff097          	auipc	ra,0xfffff
    8000460c:	cdc080e7          	jalr	-804(ra) # 800032e4 <dirlink>
    80004610:	06054b63          	bltz	a0,80004686 <create+0x152>
  iunlockput(dp);
    80004614:	854a                	mv	a0,s2
    80004616:	fffff097          	auipc	ra,0xfffff
    8000461a:	836080e7          	jalr	-1994(ra) # 80002e4c <iunlockput>
  return ip;
    8000461e:	b761                	j	800045a6 <create+0x72>
    panic("create: ialloc");
    80004620:	00004517          	auipc	a0,0x4
    80004624:	1d850513          	addi	a0,a0,472 # 800087f8 <syscall_names+0x2a8>
    80004628:	00001097          	auipc	ra,0x1
    8000462c:	638080e7          	jalr	1592(ra) # 80005c60 <panic>
    dp->nlink++;  // for ".."
    80004630:	04a95783          	lhu	a5,74(s2)
    80004634:	2785                	addiw	a5,a5,1
    80004636:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    8000463a:	854a                	mv	a0,s2
    8000463c:	ffffe097          	auipc	ra,0xffffe
    80004640:	4e2080e7          	jalr	1250(ra) # 80002b1e <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004644:	40d0                	lw	a2,4(s1)
    80004646:	00004597          	auipc	a1,0x4
    8000464a:	1c258593          	addi	a1,a1,450 # 80008808 <syscall_names+0x2b8>
    8000464e:	8526                	mv	a0,s1
    80004650:	fffff097          	auipc	ra,0xfffff
    80004654:	c94080e7          	jalr	-876(ra) # 800032e4 <dirlink>
    80004658:	00054f63          	bltz	a0,80004676 <create+0x142>
    8000465c:	00492603          	lw	a2,4(s2)
    80004660:	00004597          	auipc	a1,0x4
    80004664:	1b058593          	addi	a1,a1,432 # 80008810 <syscall_names+0x2c0>
    80004668:	8526                	mv	a0,s1
    8000466a:	fffff097          	auipc	ra,0xfffff
    8000466e:	c7a080e7          	jalr	-902(ra) # 800032e4 <dirlink>
    80004672:	f80557e3          	bgez	a0,80004600 <create+0xcc>
      panic("create dots");
    80004676:	00004517          	auipc	a0,0x4
    8000467a:	1a250513          	addi	a0,a0,418 # 80008818 <syscall_names+0x2c8>
    8000467e:	00001097          	auipc	ra,0x1
    80004682:	5e2080e7          	jalr	1506(ra) # 80005c60 <panic>
    panic("create: dirlink");
    80004686:	00004517          	auipc	a0,0x4
    8000468a:	1a250513          	addi	a0,a0,418 # 80008828 <syscall_names+0x2d8>
    8000468e:	00001097          	auipc	ra,0x1
    80004692:	5d2080e7          	jalr	1490(ra) # 80005c60 <panic>
    return 0;
    80004696:	84aa                	mv	s1,a0
    80004698:	b739                	j	800045a6 <create+0x72>

000000008000469a <sys_dup>:
{
    8000469a:	7179                	addi	sp,sp,-48
    8000469c:	f406                	sd	ra,40(sp)
    8000469e:	f022                	sd	s0,32(sp)
    800046a0:	ec26                	sd	s1,24(sp)
    800046a2:	e84a                	sd	s2,16(sp)
    800046a4:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800046a6:	fd840613          	addi	a2,s0,-40
    800046aa:	4581                	li	a1,0
    800046ac:	4501                	li	a0,0
    800046ae:	00000097          	auipc	ra,0x0
    800046b2:	ddc080e7          	jalr	-548(ra) # 8000448a <argfd>
    return -1;
    800046b6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800046b8:	02054363          	bltz	a0,800046de <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    800046bc:	fd843903          	ld	s2,-40(s0)
    800046c0:	854a                	mv	a0,s2
    800046c2:	00000097          	auipc	ra,0x0
    800046c6:	e30080e7          	jalr	-464(ra) # 800044f2 <fdalloc>
    800046ca:	84aa                	mv	s1,a0
    return -1;
    800046cc:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800046ce:	00054863          	bltz	a0,800046de <sys_dup+0x44>
  filedup(f);
    800046d2:	854a                	mv	a0,s2
    800046d4:	fffff097          	auipc	ra,0xfffff
    800046d8:	368080e7          	jalr	872(ra) # 80003a3c <filedup>
  return fd;
    800046dc:	87a6                	mv	a5,s1
}
    800046de:	853e                	mv	a0,a5
    800046e0:	70a2                	ld	ra,40(sp)
    800046e2:	7402                	ld	s0,32(sp)
    800046e4:	64e2                	ld	s1,24(sp)
    800046e6:	6942                	ld	s2,16(sp)
    800046e8:	6145                	addi	sp,sp,48
    800046ea:	8082                	ret

00000000800046ec <sys_read>:
{
    800046ec:	7179                	addi	sp,sp,-48
    800046ee:	f406                	sd	ra,40(sp)
    800046f0:	f022                	sd	s0,32(sp)
    800046f2:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046f4:	fe840613          	addi	a2,s0,-24
    800046f8:	4581                	li	a1,0
    800046fa:	4501                	li	a0,0
    800046fc:	00000097          	auipc	ra,0x0
    80004700:	d8e080e7          	jalr	-626(ra) # 8000448a <argfd>
    return -1;
    80004704:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004706:	04054163          	bltz	a0,80004748 <sys_read+0x5c>
    8000470a:	fe440593          	addi	a1,s0,-28
    8000470e:	4509                	li	a0,2
    80004710:	ffffe097          	auipc	ra,0xffffe
    80004714:	894080e7          	jalr	-1900(ra) # 80001fa4 <argint>
    return -1;
    80004718:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000471a:	02054763          	bltz	a0,80004748 <sys_read+0x5c>
    8000471e:	fd840593          	addi	a1,s0,-40
    80004722:	4505                	li	a0,1
    80004724:	ffffe097          	auipc	ra,0xffffe
    80004728:	8a2080e7          	jalr	-1886(ra) # 80001fc6 <argaddr>
    return -1;
    8000472c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000472e:	00054d63          	bltz	a0,80004748 <sys_read+0x5c>
  return fileread(f, p, n);
    80004732:	fe442603          	lw	a2,-28(s0)
    80004736:	fd843583          	ld	a1,-40(s0)
    8000473a:	fe843503          	ld	a0,-24(s0)
    8000473e:	fffff097          	auipc	ra,0xfffff
    80004742:	48a080e7          	jalr	1162(ra) # 80003bc8 <fileread>
    80004746:	87aa                	mv	a5,a0
}
    80004748:	853e                	mv	a0,a5
    8000474a:	70a2                	ld	ra,40(sp)
    8000474c:	7402                	ld	s0,32(sp)
    8000474e:	6145                	addi	sp,sp,48
    80004750:	8082                	ret

0000000080004752 <sys_write>:
{
    80004752:	7179                	addi	sp,sp,-48
    80004754:	f406                	sd	ra,40(sp)
    80004756:	f022                	sd	s0,32(sp)
    80004758:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000475a:	fe840613          	addi	a2,s0,-24
    8000475e:	4581                	li	a1,0
    80004760:	4501                	li	a0,0
    80004762:	00000097          	auipc	ra,0x0
    80004766:	d28080e7          	jalr	-728(ra) # 8000448a <argfd>
    return -1;
    8000476a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000476c:	04054163          	bltz	a0,800047ae <sys_write+0x5c>
    80004770:	fe440593          	addi	a1,s0,-28
    80004774:	4509                	li	a0,2
    80004776:	ffffe097          	auipc	ra,0xffffe
    8000477a:	82e080e7          	jalr	-2002(ra) # 80001fa4 <argint>
    return -1;
    8000477e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004780:	02054763          	bltz	a0,800047ae <sys_write+0x5c>
    80004784:	fd840593          	addi	a1,s0,-40
    80004788:	4505                	li	a0,1
    8000478a:	ffffe097          	auipc	ra,0xffffe
    8000478e:	83c080e7          	jalr	-1988(ra) # 80001fc6 <argaddr>
    return -1;
    80004792:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004794:	00054d63          	bltz	a0,800047ae <sys_write+0x5c>
  return filewrite(f, p, n);
    80004798:	fe442603          	lw	a2,-28(s0)
    8000479c:	fd843583          	ld	a1,-40(s0)
    800047a0:	fe843503          	ld	a0,-24(s0)
    800047a4:	fffff097          	auipc	ra,0xfffff
    800047a8:	4e6080e7          	jalr	1254(ra) # 80003c8a <filewrite>
    800047ac:	87aa                	mv	a5,a0
}
    800047ae:	853e                	mv	a0,a5
    800047b0:	70a2                	ld	ra,40(sp)
    800047b2:	7402                	ld	s0,32(sp)
    800047b4:	6145                	addi	sp,sp,48
    800047b6:	8082                	ret

00000000800047b8 <sys_close>:
{
    800047b8:	1101                	addi	sp,sp,-32
    800047ba:	ec06                	sd	ra,24(sp)
    800047bc:	e822                	sd	s0,16(sp)
    800047be:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800047c0:	fe040613          	addi	a2,s0,-32
    800047c4:	fec40593          	addi	a1,s0,-20
    800047c8:	4501                	li	a0,0
    800047ca:	00000097          	auipc	ra,0x0
    800047ce:	cc0080e7          	jalr	-832(ra) # 8000448a <argfd>
    return -1;
    800047d2:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800047d4:	02054463          	bltz	a0,800047fc <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800047d8:	ffffc097          	auipc	ra,0xffffc
    800047dc:	6b6080e7          	jalr	1718(ra) # 80000e8e <myproc>
    800047e0:	fec42783          	lw	a5,-20(s0)
    800047e4:	07e9                	addi	a5,a5,26
    800047e6:	078e                	slli	a5,a5,0x3
    800047e8:	953e                	add	a0,a0,a5
    800047ea:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800047ee:	fe043503          	ld	a0,-32(s0)
    800047f2:	fffff097          	auipc	ra,0xfffff
    800047f6:	29c080e7          	jalr	668(ra) # 80003a8e <fileclose>
  return 0;
    800047fa:	4781                	li	a5,0
}
    800047fc:	853e                	mv	a0,a5
    800047fe:	60e2                	ld	ra,24(sp)
    80004800:	6442                	ld	s0,16(sp)
    80004802:	6105                	addi	sp,sp,32
    80004804:	8082                	ret

0000000080004806 <sys_fstat>:
{
    80004806:	1101                	addi	sp,sp,-32
    80004808:	ec06                	sd	ra,24(sp)
    8000480a:	e822                	sd	s0,16(sp)
    8000480c:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000480e:	fe840613          	addi	a2,s0,-24
    80004812:	4581                	li	a1,0
    80004814:	4501                	li	a0,0
    80004816:	00000097          	auipc	ra,0x0
    8000481a:	c74080e7          	jalr	-908(ra) # 8000448a <argfd>
    return -1;
    8000481e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004820:	02054563          	bltz	a0,8000484a <sys_fstat+0x44>
    80004824:	fe040593          	addi	a1,s0,-32
    80004828:	4505                	li	a0,1
    8000482a:	ffffd097          	auipc	ra,0xffffd
    8000482e:	79c080e7          	jalr	1948(ra) # 80001fc6 <argaddr>
    return -1;
    80004832:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004834:	00054b63          	bltz	a0,8000484a <sys_fstat+0x44>
  return filestat(f, st);
    80004838:	fe043583          	ld	a1,-32(s0)
    8000483c:	fe843503          	ld	a0,-24(s0)
    80004840:	fffff097          	auipc	ra,0xfffff
    80004844:	316080e7          	jalr	790(ra) # 80003b56 <filestat>
    80004848:	87aa                	mv	a5,a0
}
    8000484a:	853e                	mv	a0,a5
    8000484c:	60e2                	ld	ra,24(sp)
    8000484e:	6442                	ld	s0,16(sp)
    80004850:	6105                	addi	sp,sp,32
    80004852:	8082                	ret

0000000080004854 <sys_link>:
{
    80004854:	7169                	addi	sp,sp,-304
    80004856:	f606                	sd	ra,296(sp)
    80004858:	f222                	sd	s0,288(sp)
    8000485a:	ee26                	sd	s1,280(sp)
    8000485c:	ea4a                	sd	s2,272(sp)
    8000485e:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004860:	08000613          	li	a2,128
    80004864:	ed040593          	addi	a1,s0,-304
    80004868:	4501                	li	a0,0
    8000486a:	ffffd097          	auipc	ra,0xffffd
    8000486e:	77e080e7          	jalr	1918(ra) # 80001fe8 <argstr>
    return -1;
    80004872:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004874:	10054e63          	bltz	a0,80004990 <sys_link+0x13c>
    80004878:	08000613          	li	a2,128
    8000487c:	f5040593          	addi	a1,s0,-176
    80004880:	4505                	li	a0,1
    80004882:	ffffd097          	auipc	ra,0xffffd
    80004886:	766080e7          	jalr	1894(ra) # 80001fe8 <argstr>
    return -1;
    8000488a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000488c:	10054263          	bltz	a0,80004990 <sys_link+0x13c>
  begin_op();
    80004890:	fffff097          	auipc	ra,0xfffff
    80004894:	d36080e7          	jalr	-714(ra) # 800035c6 <begin_op>
  if((ip = namei(old)) == 0){
    80004898:	ed040513          	addi	a0,s0,-304
    8000489c:	fffff097          	auipc	ra,0xfffff
    800048a0:	b0a080e7          	jalr	-1270(ra) # 800033a6 <namei>
    800048a4:	84aa                	mv	s1,a0
    800048a6:	c551                	beqz	a0,80004932 <sys_link+0xde>
  ilock(ip);
    800048a8:	ffffe097          	auipc	ra,0xffffe
    800048ac:	342080e7          	jalr	834(ra) # 80002bea <ilock>
  if(ip->type == T_DIR){
    800048b0:	04449703          	lh	a4,68(s1)
    800048b4:	4785                	li	a5,1
    800048b6:	08f70463          	beq	a4,a5,8000493e <sys_link+0xea>
  ip->nlink++;
    800048ba:	04a4d783          	lhu	a5,74(s1)
    800048be:	2785                	addiw	a5,a5,1
    800048c0:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800048c4:	8526                	mv	a0,s1
    800048c6:	ffffe097          	auipc	ra,0xffffe
    800048ca:	258080e7          	jalr	600(ra) # 80002b1e <iupdate>
  iunlock(ip);
    800048ce:	8526                	mv	a0,s1
    800048d0:	ffffe097          	auipc	ra,0xffffe
    800048d4:	3dc080e7          	jalr	988(ra) # 80002cac <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800048d8:	fd040593          	addi	a1,s0,-48
    800048dc:	f5040513          	addi	a0,s0,-176
    800048e0:	fffff097          	auipc	ra,0xfffff
    800048e4:	ae4080e7          	jalr	-1308(ra) # 800033c4 <nameiparent>
    800048e8:	892a                	mv	s2,a0
    800048ea:	c935                	beqz	a0,8000495e <sys_link+0x10a>
  ilock(dp);
    800048ec:	ffffe097          	auipc	ra,0xffffe
    800048f0:	2fe080e7          	jalr	766(ra) # 80002bea <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800048f4:	00092703          	lw	a4,0(s2)
    800048f8:	409c                	lw	a5,0(s1)
    800048fa:	04f71d63          	bne	a4,a5,80004954 <sys_link+0x100>
    800048fe:	40d0                	lw	a2,4(s1)
    80004900:	fd040593          	addi	a1,s0,-48
    80004904:	854a                	mv	a0,s2
    80004906:	fffff097          	auipc	ra,0xfffff
    8000490a:	9de080e7          	jalr	-1570(ra) # 800032e4 <dirlink>
    8000490e:	04054363          	bltz	a0,80004954 <sys_link+0x100>
  iunlockput(dp);
    80004912:	854a                	mv	a0,s2
    80004914:	ffffe097          	auipc	ra,0xffffe
    80004918:	538080e7          	jalr	1336(ra) # 80002e4c <iunlockput>
  iput(ip);
    8000491c:	8526                	mv	a0,s1
    8000491e:	ffffe097          	auipc	ra,0xffffe
    80004922:	486080e7          	jalr	1158(ra) # 80002da4 <iput>
  end_op();
    80004926:	fffff097          	auipc	ra,0xfffff
    8000492a:	d1e080e7          	jalr	-738(ra) # 80003644 <end_op>
  return 0;
    8000492e:	4781                	li	a5,0
    80004930:	a085                	j	80004990 <sys_link+0x13c>
    end_op();
    80004932:	fffff097          	auipc	ra,0xfffff
    80004936:	d12080e7          	jalr	-750(ra) # 80003644 <end_op>
    return -1;
    8000493a:	57fd                	li	a5,-1
    8000493c:	a891                	j	80004990 <sys_link+0x13c>
    iunlockput(ip);
    8000493e:	8526                	mv	a0,s1
    80004940:	ffffe097          	auipc	ra,0xffffe
    80004944:	50c080e7          	jalr	1292(ra) # 80002e4c <iunlockput>
    end_op();
    80004948:	fffff097          	auipc	ra,0xfffff
    8000494c:	cfc080e7          	jalr	-772(ra) # 80003644 <end_op>
    return -1;
    80004950:	57fd                	li	a5,-1
    80004952:	a83d                	j	80004990 <sys_link+0x13c>
    iunlockput(dp);
    80004954:	854a                	mv	a0,s2
    80004956:	ffffe097          	auipc	ra,0xffffe
    8000495a:	4f6080e7          	jalr	1270(ra) # 80002e4c <iunlockput>
  ilock(ip);
    8000495e:	8526                	mv	a0,s1
    80004960:	ffffe097          	auipc	ra,0xffffe
    80004964:	28a080e7          	jalr	650(ra) # 80002bea <ilock>
  ip->nlink--;
    80004968:	04a4d783          	lhu	a5,74(s1)
    8000496c:	37fd                	addiw	a5,a5,-1
    8000496e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004972:	8526                	mv	a0,s1
    80004974:	ffffe097          	auipc	ra,0xffffe
    80004978:	1aa080e7          	jalr	426(ra) # 80002b1e <iupdate>
  iunlockput(ip);
    8000497c:	8526                	mv	a0,s1
    8000497e:	ffffe097          	auipc	ra,0xffffe
    80004982:	4ce080e7          	jalr	1230(ra) # 80002e4c <iunlockput>
  end_op();
    80004986:	fffff097          	auipc	ra,0xfffff
    8000498a:	cbe080e7          	jalr	-834(ra) # 80003644 <end_op>
  return -1;
    8000498e:	57fd                	li	a5,-1
}
    80004990:	853e                	mv	a0,a5
    80004992:	70b2                	ld	ra,296(sp)
    80004994:	7412                	ld	s0,288(sp)
    80004996:	64f2                	ld	s1,280(sp)
    80004998:	6952                	ld	s2,272(sp)
    8000499a:	6155                	addi	sp,sp,304
    8000499c:	8082                	ret

000000008000499e <sys_unlink>:
{
    8000499e:	7151                	addi	sp,sp,-240
    800049a0:	f586                	sd	ra,232(sp)
    800049a2:	f1a2                	sd	s0,224(sp)
    800049a4:	eda6                	sd	s1,216(sp)
    800049a6:	e9ca                	sd	s2,208(sp)
    800049a8:	e5ce                	sd	s3,200(sp)
    800049aa:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800049ac:	08000613          	li	a2,128
    800049b0:	f3040593          	addi	a1,s0,-208
    800049b4:	4501                	li	a0,0
    800049b6:	ffffd097          	auipc	ra,0xffffd
    800049ba:	632080e7          	jalr	1586(ra) # 80001fe8 <argstr>
    800049be:	18054163          	bltz	a0,80004b40 <sys_unlink+0x1a2>
  begin_op();
    800049c2:	fffff097          	auipc	ra,0xfffff
    800049c6:	c04080e7          	jalr	-1020(ra) # 800035c6 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800049ca:	fb040593          	addi	a1,s0,-80
    800049ce:	f3040513          	addi	a0,s0,-208
    800049d2:	fffff097          	auipc	ra,0xfffff
    800049d6:	9f2080e7          	jalr	-1550(ra) # 800033c4 <nameiparent>
    800049da:	84aa                	mv	s1,a0
    800049dc:	c979                	beqz	a0,80004ab2 <sys_unlink+0x114>
  ilock(dp);
    800049de:	ffffe097          	auipc	ra,0xffffe
    800049e2:	20c080e7          	jalr	524(ra) # 80002bea <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800049e6:	00004597          	auipc	a1,0x4
    800049ea:	e2258593          	addi	a1,a1,-478 # 80008808 <syscall_names+0x2b8>
    800049ee:	fb040513          	addi	a0,s0,-80
    800049f2:	ffffe097          	auipc	ra,0xffffe
    800049f6:	6c2080e7          	jalr	1730(ra) # 800030b4 <namecmp>
    800049fa:	14050a63          	beqz	a0,80004b4e <sys_unlink+0x1b0>
    800049fe:	00004597          	auipc	a1,0x4
    80004a02:	e1258593          	addi	a1,a1,-494 # 80008810 <syscall_names+0x2c0>
    80004a06:	fb040513          	addi	a0,s0,-80
    80004a0a:	ffffe097          	auipc	ra,0xffffe
    80004a0e:	6aa080e7          	jalr	1706(ra) # 800030b4 <namecmp>
    80004a12:	12050e63          	beqz	a0,80004b4e <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004a16:	f2c40613          	addi	a2,s0,-212
    80004a1a:	fb040593          	addi	a1,s0,-80
    80004a1e:	8526                	mv	a0,s1
    80004a20:	ffffe097          	auipc	ra,0xffffe
    80004a24:	6ae080e7          	jalr	1710(ra) # 800030ce <dirlookup>
    80004a28:	892a                	mv	s2,a0
    80004a2a:	12050263          	beqz	a0,80004b4e <sys_unlink+0x1b0>
  ilock(ip);
    80004a2e:	ffffe097          	auipc	ra,0xffffe
    80004a32:	1bc080e7          	jalr	444(ra) # 80002bea <ilock>
  if(ip->nlink < 1)
    80004a36:	04a91783          	lh	a5,74(s2)
    80004a3a:	08f05263          	blez	a5,80004abe <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004a3e:	04491703          	lh	a4,68(s2)
    80004a42:	4785                	li	a5,1
    80004a44:	08f70563          	beq	a4,a5,80004ace <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004a48:	4641                	li	a2,16
    80004a4a:	4581                	li	a1,0
    80004a4c:	fc040513          	addi	a0,s0,-64
    80004a50:	ffffb097          	auipc	ra,0xffffb
    80004a54:	774080e7          	jalr	1908(ra) # 800001c4 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a58:	4741                	li	a4,16
    80004a5a:	f2c42683          	lw	a3,-212(s0)
    80004a5e:	fc040613          	addi	a2,s0,-64
    80004a62:	4581                	li	a1,0
    80004a64:	8526                	mv	a0,s1
    80004a66:	ffffe097          	auipc	ra,0xffffe
    80004a6a:	530080e7          	jalr	1328(ra) # 80002f96 <writei>
    80004a6e:	47c1                	li	a5,16
    80004a70:	0af51563          	bne	a0,a5,80004b1a <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004a74:	04491703          	lh	a4,68(s2)
    80004a78:	4785                	li	a5,1
    80004a7a:	0af70863          	beq	a4,a5,80004b2a <sys_unlink+0x18c>
  iunlockput(dp);
    80004a7e:	8526                	mv	a0,s1
    80004a80:	ffffe097          	auipc	ra,0xffffe
    80004a84:	3cc080e7          	jalr	972(ra) # 80002e4c <iunlockput>
  ip->nlink--;
    80004a88:	04a95783          	lhu	a5,74(s2)
    80004a8c:	37fd                	addiw	a5,a5,-1
    80004a8e:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004a92:	854a                	mv	a0,s2
    80004a94:	ffffe097          	auipc	ra,0xffffe
    80004a98:	08a080e7          	jalr	138(ra) # 80002b1e <iupdate>
  iunlockput(ip);
    80004a9c:	854a                	mv	a0,s2
    80004a9e:	ffffe097          	auipc	ra,0xffffe
    80004aa2:	3ae080e7          	jalr	942(ra) # 80002e4c <iunlockput>
  end_op();
    80004aa6:	fffff097          	auipc	ra,0xfffff
    80004aaa:	b9e080e7          	jalr	-1122(ra) # 80003644 <end_op>
  return 0;
    80004aae:	4501                	li	a0,0
    80004ab0:	a84d                	j	80004b62 <sys_unlink+0x1c4>
    end_op();
    80004ab2:	fffff097          	auipc	ra,0xfffff
    80004ab6:	b92080e7          	jalr	-1134(ra) # 80003644 <end_op>
    return -1;
    80004aba:	557d                	li	a0,-1
    80004abc:	a05d                	j	80004b62 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004abe:	00004517          	auipc	a0,0x4
    80004ac2:	d7a50513          	addi	a0,a0,-646 # 80008838 <syscall_names+0x2e8>
    80004ac6:	00001097          	auipc	ra,0x1
    80004aca:	19a080e7          	jalr	410(ra) # 80005c60 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004ace:	04c92703          	lw	a4,76(s2)
    80004ad2:	02000793          	li	a5,32
    80004ad6:	f6e7f9e3          	bgeu	a5,a4,80004a48 <sys_unlink+0xaa>
    80004ada:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004ade:	4741                	li	a4,16
    80004ae0:	86ce                	mv	a3,s3
    80004ae2:	f1840613          	addi	a2,s0,-232
    80004ae6:	4581                	li	a1,0
    80004ae8:	854a                	mv	a0,s2
    80004aea:	ffffe097          	auipc	ra,0xffffe
    80004aee:	3b4080e7          	jalr	948(ra) # 80002e9e <readi>
    80004af2:	47c1                	li	a5,16
    80004af4:	00f51b63          	bne	a0,a5,80004b0a <sys_unlink+0x16c>
    if(de.inum != 0)
    80004af8:	f1845783          	lhu	a5,-232(s0)
    80004afc:	e7a1                	bnez	a5,80004b44 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004afe:	29c1                	addiw	s3,s3,16
    80004b00:	04c92783          	lw	a5,76(s2)
    80004b04:	fcf9ede3          	bltu	s3,a5,80004ade <sys_unlink+0x140>
    80004b08:	b781                	j	80004a48 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004b0a:	00004517          	auipc	a0,0x4
    80004b0e:	d4650513          	addi	a0,a0,-698 # 80008850 <syscall_names+0x300>
    80004b12:	00001097          	auipc	ra,0x1
    80004b16:	14e080e7          	jalr	334(ra) # 80005c60 <panic>
    panic("unlink: writei");
    80004b1a:	00004517          	auipc	a0,0x4
    80004b1e:	d4e50513          	addi	a0,a0,-690 # 80008868 <syscall_names+0x318>
    80004b22:	00001097          	auipc	ra,0x1
    80004b26:	13e080e7          	jalr	318(ra) # 80005c60 <panic>
    dp->nlink--;
    80004b2a:	04a4d783          	lhu	a5,74(s1)
    80004b2e:	37fd                	addiw	a5,a5,-1
    80004b30:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004b34:	8526                	mv	a0,s1
    80004b36:	ffffe097          	auipc	ra,0xffffe
    80004b3a:	fe8080e7          	jalr	-24(ra) # 80002b1e <iupdate>
    80004b3e:	b781                	j	80004a7e <sys_unlink+0xe0>
    return -1;
    80004b40:	557d                	li	a0,-1
    80004b42:	a005                	j	80004b62 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004b44:	854a                	mv	a0,s2
    80004b46:	ffffe097          	auipc	ra,0xffffe
    80004b4a:	306080e7          	jalr	774(ra) # 80002e4c <iunlockput>
  iunlockput(dp);
    80004b4e:	8526                	mv	a0,s1
    80004b50:	ffffe097          	auipc	ra,0xffffe
    80004b54:	2fc080e7          	jalr	764(ra) # 80002e4c <iunlockput>
  end_op();
    80004b58:	fffff097          	auipc	ra,0xfffff
    80004b5c:	aec080e7          	jalr	-1300(ra) # 80003644 <end_op>
  return -1;
    80004b60:	557d                	li	a0,-1
}
    80004b62:	70ae                	ld	ra,232(sp)
    80004b64:	740e                	ld	s0,224(sp)
    80004b66:	64ee                	ld	s1,216(sp)
    80004b68:	694e                	ld	s2,208(sp)
    80004b6a:	69ae                	ld	s3,200(sp)
    80004b6c:	616d                	addi	sp,sp,240
    80004b6e:	8082                	ret

0000000080004b70 <sys_open>:

uint64
sys_open(void)
{
    80004b70:	7131                	addi	sp,sp,-192
    80004b72:	fd06                	sd	ra,184(sp)
    80004b74:	f922                	sd	s0,176(sp)
    80004b76:	f526                	sd	s1,168(sp)
    80004b78:	f14a                	sd	s2,160(sp)
    80004b7a:	ed4e                	sd	s3,152(sp)
    80004b7c:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b7e:	08000613          	li	a2,128
    80004b82:	f5040593          	addi	a1,s0,-176
    80004b86:	4501                	li	a0,0
    80004b88:	ffffd097          	auipc	ra,0xffffd
    80004b8c:	460080e7          	jalr	1120(ra) # 80001fe8 <argstr>
    return -1;
    80004b90:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b92:	0c054163          	bltz	a0,80004c54 <sys_open+0xe4>
    80004b96:	f4c40593          	addi	a1,s0,-180
    80004b9a:	4505                	li	a0,1
    80004b9c:	ffffd097          	auipc	ra,0xffffd
    80004ba0:	408080e7          	jalr	1032(ra) # 80001fa4 <argint>
    80004ba4:	0a054863          	bltz	a0,80004c54 <sys_open+0xe4>

  begin_op();
    80004ba8:	fffff097          	auipc	ra,0xfffff
    80004bac:	a1e080e7          	jalr	-1506(ra) # 800035c6 <begin_op>

  if(omode & O_CREATE){
    80004bb0:	f4c42783          	lw	a5,-180(s0)
    80004bb4:	2007f793          	andi	a5,a5,512
    80004bb8:	cbdd                	beqz	a5,80004c6e <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004bba:	4681                	li	a3,0
    80004bbc:	4601                	li	a2,0
    80004bbe:	4589                	li	a1,2
    80004bc0:	f5040513          	addi	a0,s0,-176
    80004bc4:	00000097          	auipc	ra,0x0
    80004bc8:	970080e7          	jalr	-1680(ra) # 80004534 <create>
    80004bcc:	892a                	mv	s2,a0
    if(ip == 0){
    80004bce:	c959                	beqz	a0,80004c64 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004bd0:	04491703          	lh	a4,68(s2)
    80004bd4:	478d                	li	a5,3
    80004bd6:	00f71763          	bne	a4,a5,80004be4 <sys_open+0x74>
    80004bda:	04695703          	lhu	a4,70(s2)
    80004bde:	47a5                	li	a5,9
    80004be0:	0ce7ec63          	bltu	a5,a4,80004cb8 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004be4:	fffff097          	auipc	ra,0xfffff
    80004be8:	dee080e7          	jalr	-530(ra) # 800039d2 <filealloc>
    80004bec:	89aa                	mv	s3,a0
    80004bee:	10050263          	beqz	a0,80004cf2 <sys_open+0x182>
    80004bf2:	00000097          	auipc	ra,0x0
    80004bf6:	900080e7          	jalr	-1792(ra) # 800044f2 <fdalloc>
    80004bfa:	84aa                	mv	s1,a0
    80004bfc:	0e054663          	bltz	a0,80004ce8 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004c00:	04491703          	lh	a4,68(s2)
    80004c04:	478d                	li	a5,3
    80004c06:	0cf70463          	beq	a4,a5,80004cce <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004c0a:	4789                	li	a5,2
    80004c0c:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004c10:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004c14:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004c18:	f4c42783          	lw	a5,-180(s0)
    80004c1c:	0017c713          	xori	a4,a5,1
    80004c20:	8b05                	andi	a4,a4,1
    80004c22:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004c26:	0037f713          	andi	a4,a5,3
    80004c2a:	00e03733          	snez	a4,a4
    80004c2e:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004c32:	4007f793          	andi	a5,a5,1024
    80004c36:	c791                	beqz	a5,80004c42 <sys_open+0xd2>
    80004c38:	04491703          	lh	a4,68(s2)
    80004c3c:	4789                	li	a5,2
    80004c3e:	08f70f63          	beq	a4,a5,80004cdc <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004c42:	854a                	mv	a0,s2
    80004c44:	ffffe097          	auipc	ra,0xffffe
    80004c48:	068080e7          	jalr	104(ra) # 80002cac <iunlock>
  end_op();
    80004c4c:	fffff097          	auipc	ra,0xfffff
    80004c50:	9f8080e7          	jalr	-1544(ra) # 80003644 <end_op>

  return fd;
}
    80004c54:	8526                	mv	a0,s1
    80004c56:	70ea                	ld	ra,184(sp)
    80004c58:	744a                	ld	s0,176(sp)
    80004c5a:	74aa                	ld	s1,168(sp)
    80004c5c:	790a                	ld	s2,160(sp)
    80004c5e:	69ea                	ld	s3,152(sp)
    80004c60:	6129                	addi	sp,sp,192
    80004c62:	8082                	ret
      end_op();
    80004c64:	fffff097          	auipc	ra,0xfffff
    80004c68:	9e0080e7          	jalr	-1568(ra) # 80003644 <end_op>
      return -1;
    80004c6c:	b7e5                	j	80004c54 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004c6e:	f5040513          	addi	a0,s0,-176
    80004c72:	ffffe097          	auipc	ra,0xffffe
    80004c76:	734080e7          	jalr	1844(ra) # 800033a6 <namei>
    80004c7a:	892a                	mv	s2,a0
    80004c7c:	c905                	beqz	a0,80004cac <sys_open+0x13c>
    ilock(ip);
    80004c7e:	ffffe097          	auipc	ra,0xffffe
    80004c82:	f6c080e7          	jalr	-148(ra) # 80002bea <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004c86:	04491703          	lh	a4,68(s2)
    80004c8a:	4785                	li	a5,1
    80004c8c:	f4f712e3          	bne	a4,a5,80004bd0 <sys_open+0x60>
    80004c90:	f4c42783          	lw	a5,-180(s0)
    80004c94:	dba1                	beqz	a5,80004be4 <sys_open+0x74>
      iunlockput(ip);
    80004c96:	854a                	mv	a0,s2
    80004c98:	ffffe097          	auipc	ra,0xffffe
    80004c9c:	1b4080e7          	jalr	436(ra) # 80002e4c <iunlockput>
      end_op();
    80004ca0:	fffff097          	auipc	ra,0xfffff
    80004ca4:	9a4080e7          	jalr	-1628(ra) # 80003644 <end_op>
      return -1;
    80004ca8:	54fd                	li	s1,-1
    80004caa:	b76d                	j	80004c54 <sys_open+0xe4>
      end_op();
    80004cac:	fffff097          	auipc	ra,0xfffff
    80004cb0:	998080e7          	jalr	-1640(ra) # 80003644 <end_op>
      return -1;
    80004cb4:	54fd                	li	s1,-1
    80004cb6:	bf79                	j	80004c54 <sys_open+0xe4>
    iunlockput(ip);
    80004cb8:	854a                	mv	a0,s2
    80004cba:	ffffe097          	auipc	ra,0xffffe
    80004cbe:	192080e7          	jalr	402(ra) # 80002e4c <iunlockput>
    end_op();
    80004cc2:	fffff097          	auipc	ra,0xfffff
    80004cc6:	982080e7          	jalr	-1662(ra) # 80003644 <end_op>
    return -1;
    80004cca:	54fd                	li	s1,-1
    80004ccc:	b761                	j	80004c54 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004cce:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004cd2:	04691783          	lh	a5,70(s2)
    80004cd6:	02f99223          	sh	a5,36(s3)
    80004cda:	bf2d                	j	80004c14 <sys_open+0xa4>
    itrunc(ip);
    80004cdc:	854a                	mv	a0,s2
    80004cde:	ffffe097          	auipc	ra,0xffffe
    80004ce2:	01a080e7          	jalr	26(ra) # 80002cf8 <itrunc>
    80004ce6:	bfb1                	j	80004c42 <sys_open+0xd2>
      fileclose(f);
    80004ce8:	854e                	mv	a0,s3
    80004cea:	fffff097          	auipc	ra,0xfffff
    80004cee:	da4080e7          	jalr	-604(ra) # 80003a8e <fileclose>
    iunlockput(ip);
    80004cf2:	854a                	mv	a0,s2
    80004cf4:	ffffe097          	auipc	ra,0xffffe
    80004cf8:	158080e7          	jalr	344(ra) # 80002e4c <iunlockput>
    end_op();
    80004cfc:	fffff097          	auipc	ra,0xfffff
    80004d00:	948080e7          	jalr	-1720(ra) # 80003644 <end_op>
    return -1;
    80004d04:	54fd                	li	s1,-1
    80004d06:	b7b9                	j	80004c54 <sys_open+0xe4>

0000000080004d08 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004d08:	7175                	addi	sp,sp,-144
    80004d0a:	e506                	sd	ra,136(sp)
    80004d0c:	e122                	sd	s0,128(sp)
    80004d0e:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004d10:	fffff097          	auipc	ra,0xfffff
    80004d14:	8b6080e7          	jalr	-1866(ra) # 800035c6 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004d18:	08000613          	li	a2,128
    80004d1c:	f7040593          	addi	a1,s0,-144
    80004d20:	4501                	li	a0,0
    80004d22:	ffffd097          	auipc	ra,0xffffd
    80004d26:	2c6080e7          	jalr	710(ra) # 80001fe8 <argstr>
    80004d2a:	02054963          	bltz	a0,80004d5c <sys_mkdir+0x54>
    80004d2e:	4681                	li	a3,0
    80004d30:	4601                	li	a2,0
    80004d32:	4585                	li	a1,1
    80004d34:	f7040513          	addi	a0,s0,-144
    80004d38:	fffff097          	auipc	ra,0xfffff
    80004d3c:	7fc080e7          	jalr	2044(ra) # 80004534 <create>
    80004d40:	cd11                	beqz	a0,80004d5c <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d42:	ffffe097          	auipc	ra,0xffffe
    80004d46:	10a080e7          	jalr	266(ra) # 80002e4c <iunlockput>
  end_op();
    80004d4a:	fffff097          	auipc	ra,0xfffff
    80004d4e:	8fa080e7          	jalr	-1798(ra) # 80003644 <end_op>
  return 0;
    80004d52:	4501                	li	a0,0
}
    80004d54:	60aa                	ld	ra,136(sp)
    80004d56:	640a                	ld	s0,128(sp)
    80004d58:	6149                	addi	sp,sp,144
    80004d5a:	8082                	ret
    end_op();
    80004d5c:	fffff097          	auipc	ra,0xfffff
    80004d60:	8e8080e7          	jalr	-1816(ra) # 80003644 <end_op>
    return -1;
    80004d64:	557d                	li	a0,-1
    80004d66:	b7fd                	j	80004d54 <sys_mkdir+0x4c>

0000000080004d68 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004d68:	7135                	addi	sp,sp,-160
    80004d6a:	ed06                	sd	ra,152(sp)
    80004d6c:	e922                	sd	s0,144(sp)
    80004d6e:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004d70:	fffff097          	auipc	ra,0xfffff
    80004d74:	856080e7          	jalr	-1962(ra) # 800035c6 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d78:	08000613          	li	a2,128
    80004d7c:	f7040593          	addi	a1,s0,-144
    80004d80:	4501                	li	a0,0
    80004d82:	ffffd097          	auipc	ra,0xffffd
    80004d86:	266080e7          	jalr	614(ra) # 80001fe8 <argstr>
    80004d8a:	04054a63          	bltz	a0,80004dde <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004d8e:	f6c40593          	addi	a1,s0,-148
    80004d92:	4505                	li	a0,1
    80004d94:	ffffd097          	auipc	ra,0xffffd
    80004d98:	210080e7          	jalr	528(ra) # 80001fa4 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d9c:	04054163          	bltz	a0,80004dde <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004da0:	f6840593          	addi	a1,s0,-152
    80004da4:	4509                	li	a0,2
    80004da6:	ffffd097          	auipc	ra,0xffffd
    80004daa:	1fe080e7          	jalr	510(ra) # 80001fa4 <argint>
     argint(1, &major) < 0 ||
    80004dae:	02054863          	bltz	a0,80004dde <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004db2:	f6841683          	lh	a3,-152(s0)
    80004db6:	f6c41603          	lh	a2,-148(s0)
    80004dba:	458d                	li	a1,3
    80004dbc:	f7040513          	addi	a0,s0,-144
    80004dc0:	fffff097          	auipc	ra,0xfffff
    80004dc4:	774080e7          	jalr	1908(ra) # 80004534 <create>
     argint(2, &minor) < 0 ||
    80004dc8:	c919                	beqz	a0,80004dde <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004dca:	ffffe097          	auipc	ra,0xffffe
    80004dce:	082080e7          	jalr	130(ra) # 80002e4c <iunlockput>
  end_op();
    80004dd2:	fffff097          	auipc	ra,0xfffff
    80004dd6:	872080e7          	jalr	-1934(ra) # 80003644 <end_op>
  return 0;
    80004dda:	4501                	li	a0,0
    80004ddc:	a031                	j	80004de8 <sys_mknod+0x80>
    end_op();
    80004dde:	fffff097          	auipc	ra,0xfffff
    80004de2:	866080e7          	jalr	-1946(ra) # 80003644 <end_op>
    return -1;
    80004de6:	557d                	li	a0,-1
}
    80004de8:	60ea                	ld	ra,152(sp)
    80004dea:	644a                	ld	s0,144(sp)
    80004dec:	610d                	addi	sp,sp,160
    80004dee:	8082                	ret

0000000080004df0 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004df0:	7135                	addi	sp,sp,-160
    80004df2:	ed06                	sd	ra,152(sp)
    80004df4:	e922                	sd	s0,144(sp)
    80004df6:	e526                	sd	s1,136(sp)
    80004df8:	e14a                	sd	s2,128(sp)
    80004dfa:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004dfc:	ffffc097          	auipc	ra,0xffffc
    80004e00:	092080e7          	jalr	146(ra) # 80000e8e <myproc>
    80004e04:	892a                	mv	s2,a0
  
  begin_op();
    80004e06:	ffffe097          	auipc	ra,0xffffe
    80004e0a:	7c0080e7          	jalr	1984(ra) # 800035c6 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004e0e:	08000613          	li	a2,128
    80004e12:	f6040593          	addi	a1,s0,-160
    80004e16:	4501                	li	a0,0
    80004e18:	ffffd097          	auipc	ra,0xffffd
    80004e1c:	1d0080e7          	jalr	464(ra) # 80001fe8 <argstr>
    80004e20:	04054b63          	bltz	a0,80004e76 <sys_chdir+0x86>
    80004e24:	f6040513          	addi	a0,s0,-160
    80004e28:	ffffe097          	auipc	ra,0xffffe
    80004e2c:	57e080e7          	jalr	1406(ra) # 800033a6 <namei>
    80004e30:	84aa                	mv	s1,a0
    80004e32:	c131                	beqz	a0,80004e76 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004e34:	ffffe097          	auipc	ra,0xffffe
    80004e38:	db6080e7          	jalr	-586(ra) # 80002bea <ilock>
  if(ip->type != T_DIR){
    80004e3c:	04449703          	lh	a4,68(s1)
    80004e40:	4785                	li	a5,1
    80004e42:	04f71063          	bne	a4,a5,80004e82 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004e46:	8526                	mv	a0,s1
    80004e48:	ffffe097          	auipc	ra,0xffffe
    80004e4c:	e64080e7          	jalr	-412(ra) # 80002cac <iunlock>
  iput(p->cwd);
    80004e50:	15093503          	ld	a0,336(s2)
    80004e54:	ffffe097          	auipc	ra,0xffffe
    80004e58:	f50080e7          	jalr	-176(ra) # 80002da4 <iput>
  end_op();
    80004e5c:	ffffe097          	auipc	ra,0xffffe
    80004e60:	7e8080e7          	jalr	2024(ra) # 80003644 <end_op>
  p->cwd = ip;
    80004e64:	14993823          	sd	s1,336(s2)
  return 0;
    80004e68:	4501                	li	a0,0
}
    80004e6a:	60ea                	ld	ra,152(sp)
    80004e6c:	644a                	ld	s0,144(sp)
    80004e6e:	64aa                	ld	s1,136(sp)
    80004e70:	690a                	ld	s2,128(sp)
    80004e72:	610d                	addi	sp,sp,160
    80004e74:	8082                	ret
    end_op();
    80004e76:	ffffe097          	auipc	ra,0xffffe
    80004e7a:	7ce080e7          	jalr	1998(ra) # 80003644 <end_op>
    return -1;
    80004e7e:	557d                	li	a0,-1
    80004e80:	b7ed                	j	80004e6a <sys_chdir+0x7a>
    iunlockput(ip);
    80004e82:	8526                	mv	a0,s1
    80004e84:	ffffe097          	auipc	ra,0xffffe
    80004e88:	fc8080e7          	jalr	-56(ra) # 80002e4c <iunlockput>
    end_op();
    80004e8c:	ffffe097          	auipc	ra,0xffffe
    80004e90:	7b8080e7          	jalr	1976(ra) # 80003644 <end_op>
    return -1;
    80004e94:	557d                	li	a0,-1
    80004e96:	bfd1                	j	80004e6a <sys_chdir+0x7a>

0000000080004e98 <sys_exec>:

uint64
sys_exec(void)
{
    80004e98:	7145                	addi	sp,sp,-464
    80004e9a:	e786                	sd	ra,456(sp)
    80004e9c:	e3a2                	sd	s0,448(sp)
    80004e9e:	ff26                	sd	s1,440(sp)
    80004ea0:	fb4a                	sd	s2,432(sp)
    80004ea2:	f74e                	sd	s3,424(sp)
    80004ea4:	f352                	sd	s4,416(sp)
    80004ea6:	ef56                	sd	s5,408(sp)
    80004ea8:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004eaa:	08000613          	li	a2,128
    80004eae:	f4040593          	addi	a1,s0,-192
    80004eb2:	4501                	li	a0,0
    80004eb4:	ffffd097          	auipc	ra,0xffffd
    80004eb8:	134080e7          	jalr	308(ra) # 80001fe8 <argstr>
    return -1;
    80004ebc:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004ebe:	0c054b63          	bltz	a0,80004f94 <sys_exec+0xfc>
    80004ec2:	e3840593          	addi	a1,s0,-456
    80004ec6:	4505                	li	a0,1
    80004ec8:	ffffd097          	auipc	ra,0xffffd
    80004ecc:	0fe080e7          	jalr	254(ra) # 80001fc6 <argaddr>
    80004ed0:	0c054263          	bltz	a0,80004f94 <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    80004ed4:	10000613          	li	a2,256
    80004ed8:	4581                	li	a1,0
    80004eda:	e4040513          	addi	a0,s0,-448
    80004ede:	ffffb097          	auipc	ra,0xffffb
    80004ee2:	2e6080e7          	jalr	742(ra) # 800001c4 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004ee6:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004eea:	89a6                	mv	s3,s1
    80004eec:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004eee:	02000a13          	li	s4,32
    80004ef2:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004ef6:	00391513          	slli	a0,s2,0x3
    80004efa:	e3040593          	addi	a1,s0,-464
    80004efe:	e3843783          	ld	a5,-456(s0)
    80004f02:	953e                	add	a0,a0,a5
    80004f04:	ffffd097          	auipc	ra,0xffffd
    80004f08:	006080e7          	jalr	6(ra) # 80001f0a <fetchaddr>
    80004f0c:	02054a63          	bltz	a0,80004f40 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80004f10:	e3043783          	ld	a5,-464(s0)
    80004f14:	c3b9                	beqz	a5,80004f5a <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004f16:	ffffb097          	auipc	ra,0xffffb
    80004f1a:	204080e7          	jalr	516(ra) # 8000011a <kalloc>
    80004f1e:	85aa                	mv	a1,a0
    80004f20:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004f24:	cd11                	beqz	a0,80004f40 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004f26:	6605                	lui	a2,0x1
    80004f28:	e3043503          	ld	a0,-464(s0)
    80004f2c:	ffffd097          	auipc	ra,0xffffd
    80004f30:	030080e7          	jalr	48(ra) # 80001f5c <fetchstr>
    80004f34:	00054663          	bltz	a0,80004f40 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80004f38:	0905                	addi	s2,s2,1
    80004f3a:	09a1                	addi	s3,s3,8
    80004f3c:	fb491be3          	bne	s2,s4,80004ef2 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f40:	f4040913          	addi	s2,s0,-192
    80004f44:	6088                	ld	a0,0(s1)
    80004f46:	c531                	beqz	a0,80004f92 <sys_exec+0xfa>
    kfree(argv[i]);
    80004f48:	ffffb097          	auipc	ra,0xffffb
    80004f4c:	0d4080e7          	jalr	212(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f50:	04a1                	addi	s1,s1,8
    80004f52:	ff2499e3          	bne	s1,s2,80004f44 <sys_exec+0xac>
  return -1;
    80004f56:	597d                	li	s2,-1
    80004f58:	a835                	j	80004f94 <sys_exec+0xfc>
      argv[i] = 0;
    80004f5a:	0a8e                	slli	s5,s5,0x3
    80004f5c:	fc0a8793          	addi	a5,s5,-64 # ffffffffffffefc0 <end+0xffffffff7ffd8d80>
    80004f60:	00878ab3          	add	s5,a5,s0
    80004f64:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004f68:	e4040593          	addi	a1,s0,-448
    80004f6c:	f4040513          	addi	a0,s0,-192
    80004f70:	fffff097          	auipc	ra,0xfffff
    80004f74:	172080e7          	jalr	370(ra) # 800040e2 <exec>
    80004f78:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f7a:	f4040993          	addi	s3,s0,-192
    80004f7e:	6088                	ld	a0,0(s1)
    80004f80:	c911                	beqz	a0,80004f94 <sys_exec+0xfc>
    kfree(argv[i]);
    80004f82:	ffffb097          	auipc	ra,0xffffb
    80004f86:	09a080e7          	jalr	154(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f8a:	04a1                	addi	s1,s1,8
    80004f8c:	ff3499e3          	bne	s1,s3,80004f7e <sys_exec+0xe6>
    80004f90:	a011                	j	80004f94 <sys_exec+0xfc>
  return -1;
    80004f92:	597d                	li	s2,-1
}
    80004f94:	854a                	mv	a0,s2
    80004f96:	60be                	ld	ra,456(sp)
    80004f98:	641e                	ld	s0,448(sp)
    80004f9a:	74fa                	ld	s1,440(sp)
    80004f9c:	795a                	ld	s2,432(sp)
    80004f9e:	79ba                	ld	s3,424(sp)
    80004fa0:	7a1a                	ld	s4,416(sp)
    80004fa2:	6afa                	ld	s5,408(sp)
    80004fa4:	6179                	addi	sp,sp,464
    80004fa6:	8082                	ret

0000000080004fa8 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004fa8:	7139                	addi	sp,sp,-64
    80004faa:	fc06                	sd	ra,56(sp)
    80004fac:	f822                	sd	s0,48(sp)
    80004fae:	f426                	sd	s1,40(sp)
    80004fb0:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004fb2:	ffffc097          	auipc	ra,0xffffc
    80004fb6:	edc080e7          	jalr	-292(ra) # 80000e8e <myproc>
    80004fba:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80004fbc:	fd840593          	addi	a1,s0,-40
    80004fc0:	4501                	li	a0,0
    80004fc2:	ffffd097          	auipc	ra,0xffffd
    80004fc6:	004080e7          	jalr	4(ra) # 80001fc6 <argaddr>
    return -1;
    80004fca:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80004fcc:	0e054063          	bltz	a0,800050ac <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80004fd0:	fc840593          	addi	a1,s0,-56
    80004fd4:	fd040513          	addi	a0,s0,-48
    80004fd8:	fffff097          	auipc	ra,0xfffff
    80004fdc:	de6080e7          	jalr	-538(ra) # 80003dbe <pipealloc>
    return -1;
    80004fe0:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004fe2:	0c054563          	bltz	a0,800050ac <sys_pipe+0x104>
  fd0 = -1;
    80004fe6:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004fea:	fd043503          	ld	a0,-48(s0)
    80004fee:	fffff097          	auipc	ra,0xfffff
    80004ff2:	504080e7          	jalr	1284(ra) # 800044f2 <fdalloc>
    80004ff6:	fca42223          	sw	a0,-60(s0)
    80004ffa:	08054c63          	bltz	a0,80005092 <sys_pipe+0xea>
    80004ffe:	fc843503          	ld	a0,-56(s0)
    80005002:	fffff097          	auipc	ra,0xfffff
    80005006:	4f0080e7          	jalr	1264(ra) # 800044f2 <fdalloc>
    8000500a:	fca42023          	sw	a0,-64(s0)
    8000500e:	06054963          	bltz	a0,80005080 <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005012:	4691                	li	a3,4
    80005014:	fc440613          	addi	a2,s0,-60
    80005018:	fd843583          	ld	a1,-40(s0)
    8000501c:	68a8                	ld	a0,80(s1)
    8000501e:	ffffc097          	auipc	ra,0xffffc
    80005022:	b34080e7          	jalr	-1228(ra) # 80000b52 <copyout>
    80005026:	02054063          	bltz	a0,80005046 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000502a:	4691                	li	a3,4
    8000502c:	fc040613          	addi	a2,s0,-64
    80005030:	fd843583          	ld	a1,-40(s0)
    80005034:	0591                	addi	a1,a1,4
    80005036:	68a8                	ld	a0,80(s1)
    80005038:	ffffc097          	auipc	ra,0xffffc
    8000503c:	b1a080e7          	jalr	-1254(ra) # 80000b52 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005040:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005042:	06055563          	bgez	a0,800050ac <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005046:	fc442783          	lw	a5,-60(s0)
    8000504a:	07e9                	addi	a5,a5,26
    8000504c:	078e                	slli	a5,a5,0x3
    8000504e:	97a6                	add	a5,a5,s1
    80005050:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005054:	fc042783          	lw	a5,-64(s0)
    80005058:	07e9                	addi	a5,a5,26
    8000505a:	078e                	slli	a5,a5,0x3
    8000505c:	00f48533          	add	a0,s1,a5
    80005060:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005064:	fd043503          	ld	a0,-48(s0)
    80005068:	fffff097          	auipc	ra,0xfffff
    8000506c:	a26080e7          	jalr	-1498(ra) # 80003a8e <fileclose>
    fileclose(wf);
    80005070:	fc843503          	ld	a0,-56(s0)
    80005074:	fffff097          	auipc	ra,0xfffff
    80005078:	a1a080e7          	jalr	-1510(ra) # 80003a8e <fileclose>
    return -1;
    8000507c:	57fd                	li	a5,-1
    8000507e:	a03d                	j	800050ac <sys_pipe+0x104>
    if(fd0 >= 0)
    80005080:	fc442783          	lw	a5,-60(s0)
    80005084:	0007c763          	bltz	a5,80005092 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005088:	07e9                	addi	a5,a5,26
    8000508a:	078e                	slli	a5,a5,0x3
    8000508c:	97a6                	add	a5,a5,s1
    8000508e:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005092:	fd043503          	ld	a0,-48(s0)
    80005096:	fffff097          	auipc	ra,0xfffff
    8000509a:	9f8080e7          	jalr	-1544(ra) # 80003a8e <fileclose>
    fileclose(wf);
    8000509e:	fc843503          	ld	a0,-56(s0)
    800050a2:	fffff097          	auipc	ra,0xfffff
    800050a6:	9ec080e7          	jalr	-1556(ra) # 80003a8e <fileclose>
    return -1;
    800050aa:	57fd                	li	a5,-1
}
    800050ac:	853e                	mv	a0,a5
    800050ae:	70e2                	ld	ra,56(sp)
    800050b0:	7442                	ld	s0,48(sp)
    800050b2:	74a2                	ld	s1,40(sp)
    800050b4:	6121                	addi	sp,sp,64
    800050b6:	8082                	ret
	...

00000000800050c0 <kernelvec>:
    800050c0:	7111                	addi	sp,sp,-256
    800050c2:	e006                	sd	ra,0(sp)
    800050c4:	e40a                	sd	sp,8(sp)
    800050c6:	e80e                	sd	gp,16(sp)
    800050c8:	ec12                	sd	tp,24(sp)
    800050ca:	f016                	sd	t0,32(sp)
    800050cc:	f41a                	sd	t1,40(sp)
    800050ce:	f81e                	sd	t2,48(sp)
    800050d0:	fc22                	sd	s0,56(sp)
    800050d2:	e0a6                	sd	s1,64(sp)
    800050d4:	e4aa                	sd	a0,72(sp)
    800050d6:	e8ae                	sd	a1,80(sp)
    800050d8:	ecb2                	sd	a2,88(sp)
    800050da:	f0b6                	sd	a3,96(sp)
    800050dc:	f4ba                	sd	a4,104(sp)
    800050de:	f8be                	sd	a5,112(sp)
    800050e0:	fcc2                	sd	a6,120(sp)
    800050e2:	e146                	sd	a7,128(sp)
    800050e4:	e54a                	sd	s2,136(sp)
    800050e6:	e94e                	sd	s3,144(sp)
    800050e8:	ed52                	sd	s4,152(sp)
    800050ea:	f156                	sd	s5,160(sp)
    800050ec:	f55a                	sd	s6,168(sp)
    800050ee:	f95e                	sd	s7,176(sp)
    800050f0:	fd62                	sd	s8,184(sp)
    800050f2:	e1e6                	sd	s9,192(sp)
    800050f4:	e5ea                	sd	s10,200(sp)
    800050f6:	e9ee                	sd	s11,208(sp)
    800050f8:	edf2                	sd	t3,216(sp)
    800050fa:	f1f6                	sd	t4,224(sp)
    800050fc:	f5fa                	sd	t5,232(sp)
    800050fe:	f9fe                	sd	t6,240(sp)
    80005100:	cd7fc0ef          	jal	ra,80001dd6 <kerneltrap>
    80005104:	6082                	ld	ra,0(sp)
    80005106:	6122                	ld	sp,8(sp)
    80005108:	61c2                	ld	gp,16(sp)
    8000510a:	7282                	ld	t0,32(sp)
    8000510c:	7322                	ld	t1,40(sp)
    8000510e:	73c2                	ld	t2,48(sp)
    80005110:	7462                	ld	s0,56(sp)
    80005112:	6486                	ld	s1,64(sp)
    80005114:	6526                	ld	a0,72(sp)
    80005116:	65c6                	ld	a1,80(sp)
    80005118:	6666                	ld	a2,88(sp)
    8000511a:	7686                	ld	a3,96(sp)
    8000511c:	7726                	ld	a4,104(sp)
    8000511e:	77c6                	ld	a5,112(sp)
    80005120:	7866                	ld	a6,120(sp)
    80005122:	688a                	ld	a7,128(sp)
    80005124:	692a                	ld	s2,136(sp)
    80005126:	69ca                	ld	s3,144(sp)
    80005128:	6a6a                	ld	s4,152(sp)
    8000512a:	7a8a                	ld	s5,160(sp)
    8000512c:	7b2a                	ld	s6,168(sp)
    8000512e:	7bca                	ld	s7,176(sp)
    80005130:	7c6a                	ld	s8,184(sp)
    80005132:	6c8e                	ld	s9,192(sp)
    80005134:	6d2e                	ld	s10,200(sp)
    80005136:	6dce                	ld	s11,208(sp)
    80005138:	6e6e                	ld	t3,216(sp)
    8000513a:	7e8e                	ld	t4,224(sp)
    8000513c:	7f2e                	ld	t5,232(sp)
    8000513e:	7fce                	ld	t6,240(sp)
    80005140:	6111                	addi	sp,sp,256
    80005142:	10200073          	sret
    80005146:	00000013          	nop
    8000514a:	00000013          	nop
    8000514e:	0001                	nop

0000000080005150 <timervec>:
    80005150:	34051573          	csrrw	a0,mscratch,a0
    80005154:	e10c                	sd	a1,0(a0)
    80005156:	e510                	sd	a2,8(a0)
    80005158:	e914                	sd	a3,16(a0)
    8000515a:	6d0c                	ld	a1,24(a0)
    8000515c:	7110                	ld	a2,32(a0)
    8000515e:	6194                	ld	a3,0(a1)
    80005160:	96b2                	add	a3,a3,a2
    80005162:	e194                	sd	a3,0(a1)
    80005164:	4589                	li	a1,2
    80005166:	14459073          	csrw	sip,a1
    8000516a:	6914                	ld	a3,16(a0)
    8000516c:	6510                	ld	a2,8(a0)
    8000516e:	610c                	ld	a1,0(a0)
    80005170:	34051573          	csrrw	a0,mscratch,a0
    80005174:	30200073          	mret
	...

000000008000517a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000517a:	1141                	addi	sp,sp,-16
    8000517c:	e422                	sd	s0,8(sp)
    8000517e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005180:	0c0007b7          	lui	a5,0xc000
    80005184:	4705                	li	a4,1
    80005186:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005188:	c3d8                	sw	a4,4(a5)
}
    8000518a:	6422                	ld	s0,8(sp)
    8000518c:	0141                	addi	sp,sp,16
    8000518e:	8082                	ret

0000000080005190 <plicinithart>:

void
plicinithart(void)
{
    80005190:	1141                	addi	sp,sp,-16
    80005192:	e406                	sd	ra,8(sp)
    80005194:	e022                	sd	s0,0(sp)
    80005196:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005198:	ffffc097          	auipc	ra,0xffffc
    8000519c:	cca080e7          	jalr	-822(ra) # 80000e62 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800051a0:	0085171b          	slliw	a4,a0,0x8
    800051a4:	0c0027b7          	lui	a5,0xc002
    800051a8:	97ba                	add	a5,a5,a4
    800051aa:	40200713          	li	a4,1026
    800051ae:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800051b2:	00d5151b          	slliw	a0,a0,0xd
    800051b6:	0c2017b7          	lui	a5,0xc201
    800051ba:	97aa                	add	a5,a5,a0
    800051bc:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800051c0:	60a2                	ld	ra,8(sp)
    800051c2:	6402                	ld	s0,0(sp)
    800051c4:	0141                	addi	sp,sp,16
    800051c6:	8082                	ret

00000000800051c8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800051c8:	1141                	addi	sp,sp,-16
    800051ca:	e406                	sd	ra,8(sp)
    800051cc:	e022                	sd	s0,0(sp)
    800051ce:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800051d0:	ffffc097          	auipc	ra,0xffffc
    800051d4:	c92080e7          	jalr	-878(ra) # 80000e62 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800051d8:	00d5151b          	slliw	a0,a0,0xd
    800051dc:	0c2017b7          	lui	a5,0xc201
    800051e0:	97aa                	add	a5,a5,a0
  return irq;
}
    800051e2:	43c8                	lw	a0,4(a5)
    800051e4:	60a2                	ld	ra,8(sp)
    800051e6:	6402                	ld	s0,0(sp)
    800051e8:	0141                	addi	sp,sp,16
    800051ea:	8082                	ret

00000000800051ec <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800051ec:	1101                	addi	sp,sp,-32
    800051ee:	ec06                	sd	ra,24(sp)
    800051f0:	e822                	sd	s0,16(sp)
    800051f2:	e426                	sd	s1,8(sp)
    800051f4:	1000                	addi	s0,sp,32
    800051f6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800051f8:	ffffc097          	auipc	ra,0xffffc
    800051fc:	c6a080e7          	jalr	-918(ra) # 80000e62 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005200:	00d5151b          	slliw	a0,a0,0xd
    80005204:	0c2017b7          	lui	a5,0xc201
    80005208:	97aa                	add	a5,a5,a0
    8000520a:	c3c4                	sw	s1,4(a5)
}
    8000520c:	60e2                	ld	ra,24(sp)
    8000520e:	6442                	ld	s0,16(sp)
    80005210:	64a2                	ld	s1,8(sp)
    80005212:	6105                	addi	sp,sp,32
    80005214:	8082                	ret

0000000080005216 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005216:	1141                	addi	sp,sp,-16
    80005218:	e406                	sd	ra,8(sp)
    8000521a:	e022                	sd	s0,0(sp)
    8000521c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000521e:	479d                	li	a5,7
    80005220:	06a7c863          	blt	a5,a0,80005290 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    80005224:	00016717          	auipc	a4,0x16
    80005228:	ddc70713          	addi	a4,a4,-548 # 8001b000 <disk>
    8000522c:	972a                	add	a4,a4,a0
    8000522e:	6789                	lui	a5,0x2
    80005230:	97ba                	add	a5,a5,a4
    80005232:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005236:	e7ad                	bnez	a5,800052a0 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005238:	00451793          	slli	a5,a0,0x4
    8000523c:	00018717          	auipc	a4,0x18
    80005240:	dc470713          	addi	a4,a4,-572 # 8001d000 <disk+0x2000>
    80005244:	6314                	ld	a3,0(a4)
    80005246:	96be                	add	a3,a3,a5
    80005248:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    8000524c:	6314                	ld	a3,0(a4)
    8000524e:	96be                	add	a3,a3,a5
    80005250:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005254:	6314                	ld	a3,0(a4)
    80005256:	96be                	add	a3,a3,a5
    80005258:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000525c:	6318                	ld	a4,0(a4)
    8000525e:	97ba                	add	a5,a5,a4
    80005260:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005264:	00016717          	auipc	a4,0x16
    80005268:	d9c70713          	addi	a4,a4,-612 # 8001b000 <disk>
    8000526c:	972a                	add	a4,a4,a0
    8000526e:	6789                	lui	a5,0x2
    80005270:	97ba                	add	a5,a5,a4
    80005272:	4705                	li	a4,1
    80005274:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    80005278:	00018517          	auipc	a0,0x18
    8000527c:	da050513          	addi	a0,a0,-608 # 8001d018 <disk+0x2018>
    80005280:	ffffc097          	auipc	ra,0xffffc
    80005284:	46a080e7          	jalr	1130(ra) # 800016ea <wakeup>
}
    80005288:	60a2                	ld	ra,8(sp)
    8000528a:	6402                	ld	s0,0(sp)
    8000528c:	0141                	addi	sp,sp,16
    8000528e:	8082                	ret
    panic("free_desc 1");
    80005290:	00003517          	auipc	a0,0x3
    80005294:	5e850513          	addi	a0,a0,1512 # 80008878 <syscall_names+0x328>
    80005298:	00001097          	auipc	ra,0x1
    8000529c:	9c8080e7          	jalr	-1592(ra) # 80005c60 <panic>
    panic("free_desc 2");
    800052a0:	00003517          	auipc	a0,0x3
    800052a4:	5e850513          	addi	a0,a0,1512 # 80008888 <syscall_names+0x338>
    800052a8:	00001097          	auipc	ra,0x1
    800052ac:	9b8080e7          	jalr	-1608(ra) # 80005c60 <panic>

00000000800052b0 <virtio_disk_init>:
{
    800052b0:	1101                	addi	sp,sp,-32
    800052b2:	ec06                	sd	ra,24(sp)
    800052b4:	e822                	sd	s0,16(sp)
    800052b6:	e426                	sd	s1,8(sp)
    800052b8:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800052ba:	00003597          	auipc	a1,0x3
    800052be:	5de58593          	addi	a1,a1,1502 # 80008898 <syscall_names+0x348>
    800052c2:	00018517          	auipc	a0,0x18
    800052c6:	e6650513          	addi	a0,a0,-410 # 8001d128 <disk+0x2128>
    800052ca:	00001097          	auipc	ra,0x1
    800052ce:	e3e080e7          	jalr	-450(ra) # 80006108 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052d2:	100017b7          	lui	a5,0x10001
    800052d6:	4398                	lw	a4,0(a5)
    800052d8:	2701                	sext.w	a4,a4
    800052da:	747277b7          	lui	a5,0x74727
    800052de:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800052e2:	0ef71063          	bne	a4,a5,800053c2 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800052e6:	100017b7          	lui	a5,0x10001
    800052ea:	43dc                	lw	a5,4(a5)
    800052ec:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052ee:	4705                	li	a4,1
    800052f0:	0ce79963          	bne	a5,a4,800053c2 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052f4:	100017b7          	lui	a5,0x10001
    800052f8:	479c                	lw	a5,8(a5)
    800052fa:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800052fc:	4709                	li	a4,2
    800052fe:	0ce79263          	bne	a5,a4,800053c2 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005302:	100017b7          	lui	a5,0x10001
    80005306:	47d8                	lw	a4,12(a5)
    80005308:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000530a:	554d47b7          	lui	a5,0x554d4
    8000530e:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005312:	0af71863          	bne	a4,a5,800053c2 <virtio_disk_init+0x112>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005316:	100017b7          	lui	a5,0x10001
    8000531a:	4705                	li	a4,1
    8000531c:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000531e:	470d                	li	a4,3
    80005320:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005322:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005324:	c7ffe6b7          	lui	a3,0xc7ffe
    80005328:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
    8000532c:	8f75                	and	a4,a4,a3
    8000532e:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005330:	472d                	li	a4,11
    80005332:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005334:	473d                	li	a4,15
    80005336:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005338:	6705                	lui	a4,0x1
    8000533a:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000533c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005340:	5bdc                	lw	a5,52(a5)
    80005342:	2781                	sext.w	a5,a5
  if(max == 0)
    80005344:	c7d9                	beqz	a5,800053d2 <virtio_disk_init+0x122>
  if(max < NUM)
    80005346:	471d                	li	a4,7
    80005348:	08f77d63          	bgeu	a4,a5,800053e2 <virtio_disk_init+0x132>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000534c:	100014b7          	lui	s1,0x10001
    80005350:	47a1                	li	a5,8
    80005352:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005354:	6609                	lui	a2,0x2
    80005356:	4581                	li	a1,0
    80005358:	00016517          	auipc	a0,0x16
    8000535c:	ca850513          	addi	a0,a0,-856 # 8001b000 <disk>
    80005360:	ffffb097          	auipc	ra,0xffffb
    80005364:	e64080e7          	jalr	-412(ra) # 800001c4 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005368:	00016717          	auipc	a4,0x16
    8000536c:	c9870713          	addi	a4,a4,-872 # 8001b000 <disk>
    80005370:	00c75793          	srli	a5,a4,0xc
    80005374:	2781                	sext.w	a5,a5
    80005376:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    80005378:	00018797          	auipc	a5,0x18
    8000537c:	c8878793          	addi	a5,a5,-888 # 8001d000 <disk+0x2000>
    80005380:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005382:	00016717          	auipc	a4,0x16
    80005386:	cfe70713          	addi	a4,a4,-770 # 8001b080 <disk+0x80>
    8000538a:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    8000538c:	00017717          	auipc	a4,0x17
    80005390:	c7470713          	addi	a4,a4,-908 # 8001c000 <disk+0x1000>
    80005394:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005396:	4705                	li	a4,1
    80005398:	00e78c23          	sb	a4,24(a5)
    8000539c:	00e78ca3          	sb	a4,25(a5)
    800053a0:	00e78d23          	sb	a4,26(a5)
    800053a4:	00e78da3          	sb	a4,27(a5)
    800053a8:	00e78e23          	sb	a4,28(a5)
    800053ac:	00e78ea3          	sb	a4,29(a5)
    800053b0:	00e78f23          	sb	a4,30(a5)
    800053b4:	00e78fa3          	sb	a4,31(a5)
}
    800053b8:	60e2                	ld	ra,24(sp)
    800053ba:	6442                	ld	s0,16(sp)
    800053bc:	64a2                	ld	s1,8(sp)
    800053be:	6105                	addi	sp,sp,32
    800053c0:	8082                	ret
    panic("could not find virtio disk");
    800053c2:	00003517          	auipc	a0,0x3
    800053c6:	4e650513          	addi	a0,a0,1254 # 800088a8 <syscall_names+0x358>
    800053ca:	00001097          	auipc	ra,0x1
    800053ce:	896080e7          	jalr	-1898(ra) # 80005c60 <panic>
    panic("virtio disk has no queue 0");
    800053d2:	00003517          	auipc	a0,0x3
    800053d6:	4f650513          	addi	a0,a0,1270 # 800088c8 <syscall_names+0x378>
    800053da:	00001097          	auipc	ra,0x1
    800053de:	886080e7          	jalr	-1914(ra) # 80005c60 <panic>
    panic("virtio disk max queue too short");
    800053e2:	00003517          	auipc	a0,0x3
    800053e6:	50650513          	addi	a0,a0,1286 # 800088e8 <syscall_names+0x398>
    800053ea:	00001097          	auipc	ra,0x1
    800053ee:	876080e7          	jalr	-1930(ra) # 80005c60 <panic>

00000000800053f2 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800053f2:	7119                	addi	sp,sp,-128
    800053f4:	fc86                	sd	ra,120(sp)
    800053f6:	f8a2                	sd	s0,112(sp)
    800053f8:	f4a6                	sd	s1,104(sp)
    800053fa:	f0ca                	sd	s2,96(sp)
    800053fc:	ecce                	sd	s3,88(sp)
    800053fe:	e8d2                	sd	s4,80(sp)
    80005400:	e4d6                	sd	s5,72(sp)
    80005402:	e0da                	sd	s6,64(sp)
    80005404:	fc5e                	sd	s7,56(sp)
    80005406:	f862                	sd	s8,48(sp)
    80005408:	f466                	sd	s9,40(sp)
    8000540a:	f06a                	sd	s10,32(sp)
    8000540c:	ec6e                	sd	s11,24(sp)
    8000540e:	0100                	addi	s0,sp,128
    80005410:	8aaa                	mv	s5,a0
    80005412:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005414:	00c52c83          	lw	s9,12(a0)
    80005418:	001c9c9b          	slliw	s9,s9,0x1
    8000541c:	1c82                	slli	s9,s9,0x20
    8000541e:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005422:	00018517          	auipc	a0,0x18
    80005426:	d0650513          	addi	a0,a0,-762 # 8001d128 <disk+0x2128>
    8000542a:	00001097          	auipc	ra,0x1
    8000542e:	d6e080e7          	jalr	-658(ra) # 80006198 <acquire>
  for(int i = 0; i < 3; i++){
    80005432:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005434:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005436:	00016c17          	auipc	s8,0x16
    8000543a:	bcac0c13          	addi	s8,s8,-1078 # 8001b000 <disk>
    8000543e:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    80005440:	4b0d                	li	s6,3
    80005442:	a0ad                	j	800054ac <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    80005444:	00fc0733          	add	a4,s8,a5
    80005448:	975e                	add	a4,a4,s7
    8000544a:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    8000544e:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005450:	0207c563          	bltz	a5,8000547a <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005454:	2905                	addiw	s2,s2,1
    80005456:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    80005458:	19690c63          	beq	s2,s6,800055f0 <virtio_disk_rw+0x1fe>
    idx[i] = alloc_desc();
    8000545c:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    8000545e:	00018717          	auipc	a4,0x18
    80005462:	bba70713          	addi	a4,a4,-1094 # 8001d018 <disk+0x2018>
    80005466:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005468:	00074683          	lbu	a3,0(a4)
    8000546c:	fee1                	bnez	a3,80005444 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    8000546e:	2785                	addiw	a5,a5,1
    80005470:	0705                	addi	a4,a4,1
    80005472:	fe979be3          	bne	a5,s1,80005468 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    80005476:	57fd                	li	a5,-1
    80005478:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    8000547a:	01205d63          	blez	s2,80005494 <virtio_disk_rw+0xa2>
    8000547e:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80005480:	000a2503          	lw	a0,0(s4)
    80005484:	00000097          	auipc	ra,0x0
    80005488:	d92080e7          	jalr	-622(ra) # 80005216 <free_desc>
      for(int j = 0; j < i; j++)
    8000548c:	2d85                	addiw	s11,s11,1
    8000548e:	0a11                	addi	s4,s4,4
    80005490:	ff2d98e3          	bne	s11,s2,80005480 <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005494:	00018597          	auipc	a1,0x18
    80005498:	c9458593          	addi	a1,a1,-876 # 8001d128 <disk+0x2128>
    8000549c:	00018517          	auipc	a0,0x18
    800054a0:	b7c50513          	addi	a0,a0,-1156 # 8001d018 <disk+0x2018>
    800054a4:	ffffc097          	auipc	ra,0xffffc
    800054a8:	0ba080e7          	jalr	186(ra) # 8000155e <sleep>
  for(int i = 0; i < 3; i++){
    800054ac:	f8040a13          	addi	s4,s0,-128
{
    800054b0:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    800054b2:	894e                	mv	s2,s3
    800054b4:	b765                	j	8000545c <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800054b6:	00018697          	auipc	a3,0x18
    800054ba:	b4a6b683          	ld	a3,-1206(a3) # 8001d000 <disk+0x2000>
    800054be:	96ba                	add	a3,a3,a4
    800054c0:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800054c4:	00016817          	auipc	a6,0x16
    800054c8:	b3c80813          	addi	a6,a6,-1220 # 8001b000 <disk>
    800054cc:	00018697          	auipc	a3,0x18
    800054d0:	b3468693          	addi	a3,a3,-1228 # 8001d000 <disk+0x2000>
    800054d4:	6290                	ld	a2,0(a3)
    800054d6:	963a                	add	a2,a2,a4
    800054d8:	00c65583          	lhu	a1,12(a2)
    800054dc:	0015e593          	ori	a1,a1,1
    800054e0:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    800054e4:	f8842603          	lw	a2,-120(s0)
    800054e8:	628c                	ld	a1,0(a3)
    800054ea:	972e                	add	a4,a4,a1
    800054ec:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800054f0:	20050593          	addi	a1,a0,512
    800054f4:	0592                	slli	a1,a1,0x4
    800054f6:	95c2                	add	a1,a1,a6
    800054f8:	577d                	li	a4,-1
    800054fa:	02e58823          	sb	a4,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800054fe:	00461713          	slli	a4,a2,0x4
    80005502:	6290                	ld	a2,0(a3)
    80005504:	963a                	add	a2,a2,a4
    80005506:	03078793          	addi	a5,a5,48
    8000550a:	97c2                	add	a5,a5,a6
    8000550c:	e21c                	sd	a5,0(a2)
  disk.desc[idx[2]].len = 1;
    8000550e:	629c                	ld	a5,0(a3)
    80005510:	97ba                	add	a5,a5,a4
    80005512:	4605                	li	a2,1
    80005514:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005516:	629c                	ld	a5,0(a3)
    80005518:	97ba                	add	a5,a5,a4
    8000551a:	4809                	li	a6,2
    8000551c:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005520:	629c                	ld	a5,0(a3)
    80005522:	97ba                	add	a5,a5,a4
    80005524:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005528:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    8000552c:	0355b423          	sd	s5,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005530:	6698                	ld	a4,8(a3)
    80005532:	00275783          	lhu	a5,2(a4)
    80005536:	8b9d                	andi	a5,a5,7
    80005538:	0786                	slli	a5,a5,0x1
    8000553a:	973e                	add	a4,a4,a5
    8000553c:	00a71223          	sh	a0,4(a4)

  __sync_synchronize();
    80005540:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005544:	6698                	ld	a4,8(a3)
    80005546:	00275783          	lhu	a5,2(a4)
    8000554a:	2785                	addiw	a5,a5,1
    8000554c:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005550:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005554:	100017b7          	lui	a5,0x10001
    80005558:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8000555c:	004aa783          	lw	a5,4(s5)
    80005560:	02c79163          	bne	a5,a2,80005582 <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    80005564:	00018917          	auipc	s2,0x18
    80005568:	bc490913          	addi	s2,s2,-1084 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    8000556c:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    8000556e:	85ca                	mv	a1,s2
    80005570:	8556                	mv	a0,s5
    80005572:	ffffc097          	auipc	ra,0xffffc
    80005576:	fec080e7          	jalr	-20(ra) # 8000155e <sleep>
  while(b->disk == 1) {
    8000557a:	004aa783          	lw	a5,4(s5)
    8000557e:	fe9788e3          	beq	a5,s1,8000556e <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    80005582:	f8042903          	lw	s2,-128(s0)
    80005586:	20090713          	addi	a4,s2,512
    8000558a:	0712                	slli	a4,a4,0x4
    8000558c:	00016797          	auipc	a5,0x16
    80005590:	a7478793          	addi	a5,a5,-1420 # 8001b000 <disk>
    80005594:	97ba                	add	a5,a5,a4
    80005596:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    8000559a:	00018997          	auipc	s3,0x18
    8000559e:	a6698993          	addi	s3,s3,-1434 # 8001d000 <disk+0x2000>
    800055a2:	00491713          	slli	a4,s2,0x4
    800055a6:	0009b783          	ld	a5,0(s3)
    800055aa:	97ba                	add	a5,a5,a4
    800055ac:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800055b0:	854a                	mv	a0,s2
    800055b2:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800055b6:	00000097          	auipc	ra,0x0
    800055ba:	c60080e7          	jalr	-928(ra) # 80005216 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800055be:	8885                	andi	s1,s1,1
    800055c0:	f0ed                	bnez	s1,800055a2 <virtio_disk_rw+0x1b0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800055c2:	00018517          	auipc	a0,0x18
    800055c6:	b6650513          	addi	a0,a0,-1178 # 8001d128 <disk+0x2128>
    800055ca:	00001097          	auipc	ra,0x1
    800055ce:	c82080e7          	jalr	-894(ra) # 8000624c <release>
}
    800055d2:	70e6                	ld	ra,120(sp)
    800055d4:	7446                	ld	s0,112(sp)
    800055d6:	74a6                	ld	s1,104(sp)
    800055d8:	7906                	ld	s2,96(sp)
    800055da:	69e6                	ld	s3,88(sp)
    800055dc:	6a46                	ld	s4,80(sp)
    800055de:	6aa6                	ld	s5,72(sp)
    800055e0:	6b06                	ld	s6,64(sp)
    800055e2:	7be2                	ld	s7,56(sp)
    800055e4:	7c42                	ld	s8,48(sp)
    800055e6:	7ca2                	ld	s9,40(sp)
    800055e8:	7d02                	ld	s10,32(sp)
    800055ea:	6de2                	ld	s11,24(sp)
    800055ec:	6109                	addi	sp,sp,128
    800055ee:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800055f0:	f8042503          	lw	a0,-128(s0)
    800055f4:	20050793          	addi	a5,a0,512
    800055f8:	0792                	slli	a5,a5,0x4
  if(write)
    800055fa:	00016817          	auipc	a6,0x16
    800055fe:	a0680813          	addi	a6,a6,-1530 # 8001b000 <disk>
    80005602:	00f80733          	add	a4,a6,a5
    80005606:	01a036b3          	snez	a3,s10
    8000560a:	0ad72423          	sw	a3,168(a4)
  buf0->reserved = 0;
    8000560e:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80005612:	0b973823          	sd	s9,176(a4)
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005616:	7679                	lui	a2,0xffffe
    80005618:	963e                	add	a2,a2,a5
    8000561a:	00018697          	auipc	a3,0x18
    8000561e:	9e668693          	addi	a3,a3,-1562 # 8001d000 <disk+0x2000>
    80005622:	6298                	ld	a4,0(a3)
    80005624:	9732                	add	a4,a4,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005626:	0a878593          	addi	a1,a5,168
    8000562a:	95c2                	add	a1,a1,a6
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000562c:	e30c                	sd	a1,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000562e:	6298                	ld	a4,0(a3)
    80005630:	9732                	add	a4,a4,a2
    80005632:	45c1                	li	a1,16
    80005634:	c70c                	sw	a1,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005636:	6298                	ld	a4,0(a3)
    80005638:	9732                	add	a4,a4,a2
    8000563a:	4585                	li	a1,1
    8000563c:	00b71623          	sh	a1,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005640:	f8442703          	lw	a4,-124(s0)
    80005644:	628c                	ld	a1,0(a3)
    80005646:	962e                	add	a2,a2,a1
    80005648:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd7dce>
  disk.desc[idx[1]].addr = (uint64) b->data;
    8000564c:	0712                	slli	a4,a4,0x4
    8000564e:	6290                	ld	a2,0(a3)
    80005650:	963a                	add	a2,a2,a4
    80005652:	058a8593          	addi	a1,s5,88
    80005656:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005658:	6294                	ld	a3,0(a3)
    8000565a:	96ba                	add	a3,a3,a4
    8000565c:	40000613          	li	a2,1024
    80005660:	c690                	sw	a2,8(a3)
  if(write)
    80005662:	e40d1ae3          	bnez	s10,800054b6 <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80005666:	00018697          	auipc	a3,0x18
    8000566a:	99a6b683          	ld	a3,-1638(a3) # 8001d000 <disk+0x2000>
    8000566e:	96ba                	add	a3,a3,a4
    80005670:	4609                	li	a2,2
    80005672:	00c69623          	sh	a2,12(a3)
    80005676:	b5b9                	j	800054c4 <virtio_disk_rw+0xd2>

0000000080005678 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005678:	1101                	addi	sp,sp,-32
    8000567a:	ec06                	sd	ra,24(sp)
    8000567c:	e822                	sd	s0,16(sp)
    8000567e:	e426                	sd	s1,8(sp)
    80005680:	e04a                	sd	s2,0(sp)
    80005682:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005684:	00018517          	auipc	a0,0x18
    80005688:	aa450513          	addi	a0,a0,-1372 # 8001d128 <disk+0x2128>
    8000568c:	00001097          	auipc	ra,0x1
    80005690:	b0c080e7          	jalr	-1268(ra) # 80006198 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005694:	10001737          	lui	a4,0x10001
    80005698:	533c                	lw	a5,96(a4)
    8000569a:	8b8d                	andi	a5,a5,3
    8000569c:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    8000569e:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800056a2:	00018797          	auipc	a5,0x18
    800056a6:	95e78793          	addi	a5,a5,-1698 # 8001d000 <disk+0x2000>
    800056aa:	6b94                	ld	a3,16(a5)
    800056ac:	0207d703          	lhu	a4,32(a5)
    800056b0:	0026d783          	lhu	a5,2(a3)
    800056b4:	06f70163          	beq	a4,a5,80005716 <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800056b8:	00016917          	auipc	s2,0x16
    800056bc:	94890913          	addi	s2,s2,-1720 # 8001b000 <disk>
    800056c0:	00018497          	auipc	s1,0x18
    800056c4:	94048493          	addi	s1,s1,-1728 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    800056c8:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800056cc:	6898                	ld	a4,16(s1)
    800056ce:	0204d783          	lhu	a5,32(s1)
    800056d2:	8b9d                	andi	a5,a5,7
    800056d4:	078e                	slli	a5,a5,0x3
    800056d6:	97ba                	add	a5,a5,a4
    800056d8:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800056da:	20078713          	addi	a4,a5,512
    800056de:	0712                	slli	a4,a4,0x4
    800056e0:	974a                	add	a4,a4,s2
    800056e2:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    800056e6:	e731                	bnez	a4,80005732 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800056e8:	20078793          	addi	a5,a5,512
    800056ec:	0792                	slli	a5,a5,0x4
    800056ee:	97ca                	add	a5,a5,s2
    800056f0:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    800056f2:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800056f6:	ffffc097          	auipc	ra,0xffffc
    800056fa:	ff4080e7          	jalr	-12(ra) # 800016ea <wakeup>

    disk.used_idx += 1;
    800056fe:	0204d783          	lhu	a5,32(s1)
    80005702:	2785                	addiw	a5,a5,1
    80005704:	17c2                	slli	a5,a5,0x30
    80005706:	93c1                	srli	a5,a5,0x30
    80005708:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    8000570c:	6898                	ld	a4,16(s1)
    8000570e:	00275703          	lhu	a4,2(a4)
    80005712:	faf71be3          	bne	a4,a5,800056c8 <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    80005716:	00018517          	auipc	a0,0x18
    8000571a:	a1250513          	addi	a0,a0,-1518 # 8001d128 <disk+0x2128>
    8000571e:	00001097          	auipc	ra,0x1
    80005722:	b2e080e7          	jalr	-1234(ra) # 8000624c <release>
}
    80005726:	60e2                	ld	ra,24(sp)
    80005728:	6442                	ld	s0,16(sp)
    8000572a:	64a2                	ld	s1,8(sp)
    8000572c:	6902                	ld	s2,0(sp)
    8000572e:	6105                	addi	sp,sp,32
    80005730:	8082                	ret
      panic("virtio_disk_intr status");
    80005732:	00003517          	auipc	a0,0x3
    80005736:	1d650513          	addi	a0,a0,470 # 80008908 <syscall_names+0x3b8>
    8000573a:	00000097          	auipc	ra,0x0
    8000573e:	526080e7          	jalr	1318(ra) # 80005c60 <panic>

0000000080005742 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005742:	1141                	addi	sp,sp,-16
    80005744:	e422                	sd	s0,8(sp)
    80005746:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005748:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    8000574c:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005750:	0037979b          	slliw	a5,a5,0x3
    80005754:	02004737          	lui	a4,0x2004
    80005758:	97ba                	add	a5,a5,a4
    8000575a:	0200c737          	lui	a4,0x200c
    8000575e:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005762:	000f4637          	lui	a2,0xf4
    80005766:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    8000576a:	9732                	add	a4,a4,a2
    8000576c:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    8000576e:	00259693          	slli	a3,a1,0x2
    80005772:	96ae                	add	a3,a3,a1
    80005774:	068e                	slli	a3,a3,0x3
    80005776:	00019717          	auipc	a4,0x19
    8000577a:	88a70713          	addi	a4,a4,-1910 # 8001e000 <timer_scratch>
    8000577e:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005780:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005782:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005784:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005788:	00000797          	auipc	a5,0x0
    8000578c:	9c878793          	addi	a5,a5,-1592 # 80005150 <timervec>
    80005790:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005794:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005798:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000579c:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800057a0:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800057a4:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800057a8:	30479073          	csrw	mie,a5
}
    800057ac:	6422                	ld	s0,8(sp)
    800057ae:	0141                	addi	sp,sp,16
    800057b0:	8082                	ret

00000000800057b2 <start>:
{
    800057b2:	1141                	addi	sp,sp,-16
    800057b4:	e406                	sd	ra,8(sp)
    800057b6:	e022                	sd	s0,0(sp)
    800057b8:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800057ba:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800057be:	7779                	lui	a4,0xffffe
    800057c0:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    800057c4:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800057c6:	6705                	lui	a4,0x1
    800057c8:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800057cc:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800057ce:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800057d2:	ffffb797          	auipc	a5,0xffffb
    800057d6:	b9878793          	addi	a5,a5,-1128 # 8000036a <main>
    800057da:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800057de:	4781                	li	a5,0
    800057e0:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800057e4:	67c1                	lui	a5,0x10
    800057e6:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800057e8:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800057ec:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800057f0:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800057f4:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800057f8:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800057fc:	57fd                	li	a5,-1
    800057fe:	83a9                	srli	a5,a5,0xa
    80005800:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005804:	47bd                	li	a5,15
    80005806:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    8000580a:	00000097          	auipc	ra,0x0
    8000580e:	f38080e7          	jalr	-200(ra) # 80005742 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005812:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005816:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005818:	823e                	mv	tp,a5
  asm volatile("mret");
    8000581a:	30200073          	mret
}
    8000581e:	60a2                	ld	ra,8(sp)
    80005820:	6402                	ld	s0,0(sp)
    80005822:	0141                	addi	sp,sp,16
    80005824:	8082                	ret

0000000080005826 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005826:	715d                	addi	sp,sp,-80
    80005828:	e486                	sd	ra,72(sp)
    8000582a:	e0a2                	sd	s0,64(sp)
    8000582c:	fc26                	sd	s1,56(sp)
    8000582e:	f84a                	sd	s2,48(sp)
    80005830:	f44e                	sd	s3,40(sp)
    80005832:	f052                	sd	s4,32(sp)
    80005834:	ec56                	sd	s5,24(sp)
    80005836:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005838:	04c05763          	blez	a2,80005886 <consolewrite+0x60>
    8000583c:	8a2a                	mv	s4,a0
    8000583e:	84ae                	mv	s1,a1
    80005840:	89b2                	mv	s3,a2
    80005842:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005844:	5afd                	li	s5,-1
    80005846:	4685                	li	a3,1
    80005848:	8626                	mv	a2,s1
    8000584a:	85d2                	mv	a1,s4
    8000584c:	fbf40513          	addi	a0,s0,-65
    80005850:	ffffc097          	auipc	ra,0xffffc
    80005854:	108080e7          	jalr	264(ra) # 80001958 <either_copyin>
    80005858:	01550d63          	beq	a0,s5,80005872 <consolewrite+0x4c>
      break;
    uartputc(c);
    8000585c:	fbf44503          	lbu	a0,-65(s0)
    80005860:	00000097          	auipc	ra,0x0
    80005864:	77e080e7          	jalr	1918(ra) # 80005fde <uartputc>
  for(i = 0; i < n; i++){
    80005868:	2905                	addiw	s2,s2,1
    8000586a:	0485                	addi	s1,s1,1
    8000586c:	fd299de3          	bne	s3,s2,80005846 <consolewrite+0x20>
    80005870:	894e                	mv	s2,s3
  }

  return i;
}
    80005872:	854a                	mv	a0,s2
    80005874:	60a6                	ld	ra,72(sp)
    80005876:	6406                	ld	s0,64(sp)
    80005878:	74e2                	ld	s1,56(sp)
    8000587a:	7942                	ld	s2,48(sp)
    8000587c:	79a2                	ld	s3,40(sp)
    8000587e:	7a02                	ld	s4,32(sp)
    80005880:	6ae2                	ld	s5,24(sp)
    80005882:	6161                	addi	sp,sp,80
    80005884:	8082                	ret
  for(i = 0; i < n; i++){
    80005886:	4901                	li	s2,0
    80005888:	b7ed                	j	80005872 <consolewrite+0x4c>

000000008000588a <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000588a:	7159                	addi	sp,sp,-112
    8000588c:	f486                	sd	ra,104(sp)
    8000588e:	f0a2                	sd	s0,96(sp)
    80005890:	eca6                	sd	s1,88(sp)
    80005892:	e8ca                	sd	s2,80(sp)
    80005894:	e4ce                	sd	s3,72(sp)
    80005896:	e0d2                	sd	s4,64(sp)
    80005898:	fc56                	sd	s5,56(sp)
    8000589a:	f85a                	sd	s6,48(sp)
    8000589c:	f45e                	sd	s7,40(sp)
    8000589e:	f062                	sd	s8,32(sp)
    800058a0:	ec66                	sd	s9,24(sp)
    800058a2:	e86a                	sd	s10,16(sp)
    800058a4:	1880                	addi	s0,sp,112
    800058a6:	8aaa                	mv	s5,a0
    800058a8:	8a2e                	mv	s4,a1
    800058aa:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800058ac:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    800058b0:	00021517          	auipc	a0,0x21
    800058b4:	89050513          	addi	a0,a0,-1904 # 80026140 <cons>
    800058b8:	00001097          	auipc	ra,0x1
    800058bc:	8e0080e7          	jalr	-1824(ra) # 80006198 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800058c0:	00021497          	auipc	s1,0x21
    800058c4:	88048493          	addi	s1,s1,-1920 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800058c8:	00021917          	auipc	s2,0x21
    800058cc:	91090913          	addi	s2,s2,-1776 # 800261d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    800058d0:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800058d2:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800058d4:	4ca9                	li	s9,10
  while(n > 0){
    800058d6:	07305863          	blez	s3,80005946 <consoleread+0xbc>
    while(cons.r == cons.w){
    800058da:	0984a783          	lw	a5,152(s1)
    800058de:	09c4a703          	lw	a4,156(s1)
    800058e2:	02f71463          	bne	a4,a5,8000590a <consoleread+0x80>
      if(myproc()->killed){
    800058e6:	ffffb097          	auipc	ra,0xffffb
    800058ea:	5a8080e7          	jalr	1448(ra) # 80000e8e <myproc>
    800058ee:	551c                	lw	a5,40(a0)
    800058f0:	e7b5                	bnez	a5,8000595c <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    800058f2:	85a6                	mv	a1,s1
    800058f4:	854a                	mv	a0,s2
    800058f6:	ffffc097          	auipc	ra,0xffffc
    800058fa:	c68080e7          	jalr	-920(ra) # 8000155e <sleep>
    while(cons.r == cons.w){
    800058fe:	0984a783          	lw	a5,152(s1)
    80005902:	09c4a703          	lw	a4,156(s1)
    80005906:	fef700e3          	beq	a4,a5,800058e6 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF];
    8000590a:	0017871b          	addiw	a4,a5,1
    8000590e:	08e4ac23          	sw	a4,152(s1)
    80005912:	07f7f713          	andi	a4,a5,127
    80005916:	9726                	add	a4,a4,s1
    80005918:	01874703          	lbu	a4,24(a4)
    8000591c:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80005920:	077d0563          	beq	s10,s7,8000598a <consoleread+0x100>
    cbuf = c;
    80005924:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005928:	4685                	li	a3,1
    8000592a:	f9f40613          	addi	a2,s0,-97
    8000592e:	85d2                	mv	a1,s4
    80005930:	8556                	mv	a0,s5
    80005932:	ffffc097          	auipc	ra,0xffffc
    80005936:	fd0080e7          	jalr	-48(ra) # 80001902 <either_copyout>
    8000593a:	01850663          	beq	a0,s8,80005946 <consoleread+0xbc>
    dst++;
    8000593e:	0a05                	addi	s4,s4,1
    --n;
    80005940:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80005942:	f99d1ae3          	bne	s10,s9,800058d6 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005946:	00020517          	auipc	a0,0x20
    8000594a:	7fa50513          	addi	a0,a0,2042 # 80026140 <cons>
    8000594e:	00001097          	auipc	ra,0x1
    80005952:	8fe080e7          	jalr	-1794(ra) # 8000624c <release>

  return target - n;
    80005956:	413b053b          	subw	a0,s6,s3
    8000595a:	a811                	j	8000596e <consoleread+0xe4>
        release(&cons.lock);
    8000595c:	00020517          	auipc	a0,0x20
    80005960:	7e450513          	addi	a0,a0,2020 # 80026140 <cons>
    80005964:	00001097          	auipc	ra,0x1
    80005968:	8e8080e7          	jalr	-1816(ra) # 8000624c <release>
        return -1;
    8000596c:	557d                	li	a0,-1
}
    8000596e:	70a6                	ld	ra,104(sp)
    80005970:	7406                	ld	s0,96(sp)
    80005972:	64e6                	ld	s1,88(sp)
    80005974:	6946                	ld	s2,80(sp)
    80005976:	69a6                	ld	s3,72(sp)
    80005978:	6a06                	ld	s4,64(sp)
    8000597a:	7ae2                	ld	s5,56(sp)
    8000597c:	7b42                	ld	s6,48(sp)
    8000597e:	7ba2                	ld	s7,40(sp)
    80005980:	7c02                	ld	s8,32(sp)
    80005982:	6ce2                	ld	s9,24(sp)
    80005984:	6d42                	ld	s10,16(sp)
    80005986:	6165                	addi	sp,sp,112
    80005988:	8082                	ret
      if(n < target){
    8000598a:	0009871b          	sext.w	a4,s3
    8000598e:	fb677ce3          	bgeu	a4,s6,80005946 <consoleread+0xbc>
        cons.r--;
    80005992:	00021717          	auipc	a4,0x21
    80005996:	84f72323          	sw	a5,-1978(a4) # 800261d8 <cons+0x98>
    8000599a:	b775                	j	80005946 <consoleread+0xbc>

000000008000599c <consputc>:
{
    8000599c:	1141                	addi	sp,sp,-16
    8000599e:	e406                	sd	ra,8(sp)
    800059a0:	e022                	sd	s0,0(sp)
    800059a2:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    800059a4:	10000793          	li	a5,256
    800059a8:	00f50a63          	beq	a0,a5,800059bc <consputc+0x20>
    uartputc_sync(c);
    800059ac:	00000097          	auipc	ra,0x0
    800059b0:	560080e7          	jalr	1376(ra) # 80005f0c <uartputc_sync>
}
    800059b4:	60a2                	ld	ra,8(sp)
    800059b6:	6402                	ld	s0,0(sp)
    800059b8:	0141                	addi	sp,sp,16
    800059ba:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800059bc:	4521                	li	a0,8
    800059be:	00000097          	auipc	ra,0x0
    800059c2:	54e080e7          	jalr	1358(ra) # 80005f0c <uartputc_sync>
    800059c6:	02000513          	li	a0,32
    800059ca:	00000097          	auipc	ra,0x0
    800059ce:	542080e7          	jalr	1346(ra) # 80005f0c <uartputc_sync>
    800059d2:	4521                	li	a0,8
    800059d4:	00000097          	auipc	ra,0x0
    800059d8:	538080e7          	jalr	1336(ra) # 80005f0c <uartputc_sync>
    800059dc:	bfe1                	j	800059b4 <consputc+0x18>

00000000800059de <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800059de:	1101                	addi	sp,sp,-32
    800059e0:	ec06                	sd	ra,24(sp)
    800059e2:	e822                	sd	s0,16(sp)
    800059e4:	e426                	sd	s1,8(sp)
    800059e6:	e04a                	sd	s2,0(sp)
    800059e8:	1000                	addi	s0,sp,32
    800059ea:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800059ec:	00020517          	auipc	a0,0x20
    800059f0:	75450513          	addi	a0,a0,1876 # 80026140 <cons>
    800059f4:	00000097          	auipc	ra,0x0
    800059f8:	7a4080e7          	jalr	1956(ra) # 80006198 <acquire>

  switch(c){
    800059fc:	47d5                	li	a5,21
    800059fe:	0af48663          	beq	s1,a5,80005aaa <consoleintr+0xcc>
    80005a02:	0297ca63          	blt	a5,s1,80005a36 <consoleintr+0x58>
    80005a06:	47a1                	li	a5,8
    80005a08:	0ef48763          	beq	s1,a5,80005af6 <consoleintr+0x118>
    80005a0c:	47c1                	li	a5,16
    80005a0e:	10f49a63          	bne	s1,a5,80005b22 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005a12:	ffffc097          	auipc	ra,0xffffc
    80005a16:	f9c080e7          	jalr	-100(ra) # 800019ae <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005a1a:	00020517          	auipc	a0,0x20
    80005a1e:	72650513          	addi	a0,a0,1830 # 80026140 <cons>
    80005a22:	00001097          	auipc	ra,0x1
    80005a26:	82a080e7          	jalr	-2006(ra) # 8000624c <release>
}
    80005a2a:	60e2                	ld	ra,24(sp)
    80005a2c:	6442                	ld	s0,16(sp)
    80005a2e:	64a2                	ld	s1,8(sp)
    80005a30:	6902                	ld	s2,0(sp)
    80005a32:	6105                	addi	sp,sp,32
    80005a34:	8082                	ret
  switch(c){
    80005a36:	07f00793          	li	a5,127
    80005a3a:	0af48e63          	beq	s1,a5,80005af6 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005a3e:	00020717          	auipc	a4,0x20
    80005a42:	70270713          	addi	a4,a4,1794 # 80026140 <cons>
    80005a46:	0a072783          	lw	a5,160(a4)
    80005a4a:	09872703          	lw	a4,152(a4)
    80005a4e:	9f99                	subw	a5,a5,a4
    80005a50:	07f00713          	li	a4,127
    80005a54:	fcf763e3          	bltu	a4,a5,80005a1a <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005a58:	47b5                	li	a5,13
    80005a5a:	0cf48763          	beq	s1,a5,80005b28 <consoleintr+0x14a>
      consputc(c);
    80005a5e:	8526                	mv	a0,s1
    80005a60:	00000097          	auipc	ra,0x0
    80005a64:	f3c080e7          	jalr	-196(ra) # 8000599c <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005a68:	00020797          	auipc	a5,0x20
    80005a6c:	6d878793          	addi	a5,a5,1752 # 80026140 <cons>
    80005a70:	0a07a703          	lw	a4,160(a5)
    80005a74:	0017069b          	addiw	a3,a4,1
    80005a78:	0006861b          	sext.w	a2,a3
    80005a7c:	0ad7a023          	sw	a3,160(a5)
    80005a80:	07f77713          	andi	a4,a4,127
    80005a84:	97ba                	add	a5,a5,a4
    80005a86:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005a8a:	47a9                	li	a5,10
    80005a8c:	0cf48563          	beq	s1,a5,80005b56 <consoleintr+0x178>
    80005a90:	4791                	li	a5,4
    80005a92:	0cf48263          	beq	s1,a5,80005b56 <consoleintr+0x178>
    80005a96:	00020797          	auipc	a5,0x20
    80005a9a:	7427a783          	lw	a5,1858(a5) # 800261d8 <cons+0x98>
    80005a9e:	0807879b          	addiw	a5,a5,128
    80005aa2:	f6f61ce3          	bne	a2,a5,80005a1a <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005aa6:	863e                	mv	a2,a5
    80005aa8:	a07d                	j	80005b56 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005aaa:	00020717          	auipc	a4,0x20
    80005aae:	69670713          	addi	a4,a4,1686 # 80026140 <cons>
    80005ab2:	0a072783          	lw	a5,160(a4)
    80005ab6:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005aba:	00020497          	auipc	s1,0x20
    80005abe:	68648493          	addi	s1,s1,1670 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005ac2:	4929                	li	s2,10
    80005ac4:	f4f70be3          	beq	a4,a5,80005a1a <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005ac8:	37fd                	addiw	a5,a5,-1
    80005aca:	07f7f713          	andi	a4,a5,127
    80005ace:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005ad0:	01874703          	lbu	a4,24(a4)
    80005ad4:	f52703e3          	beq	a4,s2,80005a1a <consoleintr+0x3c>
      cons.e--;
    80005ad8:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005adc:	10000513          	li	a0,256
    80005ae0:	00000097          	auipc	ra,0x0
    80005ae4:	ebc080e7          	jalr	-324(ra) # 8000599c <consputc>
    while(cons.e != cons.w &&
    80005ae8:	0a04a783          	lw	a5,160(s1)
    80005aec:	09c4a703          	lw	a4,156(s1)
    80005af0:	fcf71ce3          	bne	a4,a5,80005ac8 <consoleintr+0xea>
    80005af4:	b71d                	j	80005a1a <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005af6:	00020717          	auipc	a4,0x20
    80005afa:	64a70713          	addi	a4,a4,1610 # 80026140 <cons>
    80005afe:	0a072783          	lw	a5,160(a4)
    80005b02:	09c72703          	lw	a4,156(a4)
    80005b06:	f0f70ae3          	beq	a4,a5,80005a1a <consoleintr+0x3c>
      cons.e--;
    80005b0a:	37fd                	addiw	a5,a5,-1
    80005b0c:	00020717          	auipc	a4,0x20
    80005b10:	6cf72a23          	sw	a5,1748(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005b14:	10000513          	li	a0,256
    80005b18:	00000097          	auipc	ra,0x0
    80005b1c:	e84080e7          	jalr	-380(ra) # 8000599c <consputc>
    80005b20:	bded                	j	80005a1a <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005b22:	ee048ce3          	beqz	s1,80005a1a <consoleintr+0x3c>
    80005b26:	bf21                	j	80005a3e <consoleintr+0x60>
      consputc(c);
    80005b28:	4529                	li	a0,10
    80005b2a:	00000097          	auipc	ra,0x0
    80005b2e:	e72080e7          	jalr	-398(ra) # 8000599c <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005b32:	00020797          	auipc	a5,0x20
    80005b36:	60e78793          	addi	a5,a5,1550 # 80026140 <cons>
    80005b3a:	0a07a703          	lw	a4,160(a5)
    80005b3e:	0017069b          	addiw	a3,a4,1
    80005b42:	0006861b          	sext.w	a2,a3
    80005b46:	0ad7a023          	sw	a3,160(a5)
    80005b4a:	07f77713          	andi	a4,a4,127
    80005b4e:	97ba                	add	a5,a5,a4
    80005b50:	4729                	li	a4,10
    80005b52:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005b56:	00020797          	auipc	a5,0x20
    80005b5a:	68c7a323          	sw	a2,1670(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005b5e:	00020517          	auipc	a0,0x20
    80005b62:	67a50513          	addi	a0,a0,1658 # 800261d8 <cons+0x98>
    80005b66:	ffffc097          	auipc	ra,0xffffc
    80005b6a:	b84080e7          	jalr	-1148(ra) # 800016ea <wakeup>
    80005b6e:	b575                	j	80005a1a <consoleintr+0x3c>

0000000080005b70 <consoleinit>:

void
consoleinit(void)
{
    80005b70:	1141                	addi	sp,sp,-16
    80005b72:	e406                	sd	ra,8(sp)
    80005b74:	e022                	sd	s0,0(sp)
    80005b76:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005b78:	00003597          	auipc	a1,0x3
    80005b7c:	da858593          	addi	a1,a1,-600 # 80008920 <syscall_names+0x3d0>
    80005b80:	00020517          	auipc	a0,0x20
    80005b84:	5c050513          	addi	a0,a0,1472 # 80026140 <cons>
    80005b88:	00000097          	auipc	ra,0x0
    80005b8c:	580080e7          	jalr	1408(ra) # 80006108 <initlock>

  uartinit();
    80005b90:	00000097          	auipc	ra,0x0
    80005b94:	32c080e7          	jalr	812(ra) # 80005ebc <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005b98:	00013797          	auipc	a5,0x13
    80005b9c:	73078793          	addi	a5,a5,1840 # 800192c8 <devsw>
    80005ba0:	00000717          	auipc	a4,0x0
    80005ba4:	cea70713          	addi	a4,a4,-790 # 8000588a <consoleread>
    80005ba8:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005baa:	00000717          	auipc	a4,0x0
    80005bae:	c7c70713          	addi	a4,a4,-900 # 80005826 <consolewrite>
    80005bb2:	ef98                	sd	a4,24(a5)
}
    80005bb4:	60a2                	ld	ra,8(sp)
    80005bb6:	6402                	ld	s0,0(sp)
    80005bb8:	0141                	addi	sp,sp,16
    80005bba:	8082                	ret

0000000080005bbc <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005bbc:	7179                	addi	sp,sp,-48
    80005bbe:	f406                	sd	ra,40(sp)
    80005bc0:	f022                	sd	s0,32(sp)
    80005bc2:	ec26                	sd	s1,24(sp)
    80005bc4:	e84a                	sd	s2,16(sp)
    80005bc6:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005bc8:	c219                	beqz	a2,80005bce <printint+0x12>
    80005bca:	08054763          	bltz	a0,80005c58 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005bce:	2501                	sext.w	a0,a0
    80005bd0:	4881                	li	a7,0
    80005bd2:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005bd6:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005bd8:	2581                	sext.w	a1,a1
    80005bda:	00003617          	auipc	a2,0x3
    80005bde:	d7660613          	addi	a2,a2,-650 # 80008950 <digits>
    80005be2:	883a                	mv	a6,a4
    80005be4:	2705                	addiw	a4,a4,1
    80005be6:	02b577bb          	remuw	a5,a0,a1
    80005bea:	1782                	slli	a5,a5,0x20
    80005bec:	9381                	srli	a5,a5,0x20
    80005bee:	97b2                	add	a5,a5,a2
    80005bf0:	0007c783          	lbu	a5,0(a5)
    80005bf4:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005bf8:	0005079b          	sext.w	a5,a0
    80005bfc:	02b5553b          	divuw	a0,a0,a1
    80005c00:	0685                	addi	a3,a3,1
    80005c02:	feb7f0e3          	bgeu	a5,a1,80005be2 <printint+0x26>

  if(sign)
    80005c06:	00088c63          	beqz	a7,80005c1e <printint+0x62>
    buf[i++] = '-';
    80005c0a:	fe070793          	addi	a5,a4,-32
    80005c0e:	00878733          	add	a4,a5,s0
    80005c12:	02d00793          	li	a5,45
    80005c16:	fef70823          	sb	a5,-16(a4)
    80005c1a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005c1e:	02e05763          	blez	a4,80005c4c <printint+0x90>
    80005c22:	fd040793          	addi	a5,s0,-48
    80005c26:	00e784b3          	add	s1,a5,a4
    80005c2a:	fff78913          	addi	s2,a5,-1
    80005c2e:	993a                	add	s2,s2,a4
    80005c30:	377d                	addiw	a4,a4,-1
    80005c32:	1702                	slli	a4,a4,0x20
    80005c34:	9301                	srli	a4,a4,0x20
    80005c36:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005c3a:	fff4c503          	lbu	a0,-1(s1)
    80005c3e:	00000097          	auipc	ra,0x0
    80005c42:	d5e080e7          	jalr	-674(ra) # 8000599c <consputc>
  while(--i >= 0)
    80005c46:	14fd                	addi	s1,s1,-1
    80005c48:	ff2499e3          	bne	s1,s2,80005c3a <printint+0x7e>
}
    80005c4c:	70a2                	ld	ra,40(sp)
    80005c4e:	7402                	ld	s0,32(sp)
    80005c50:	64e2                	ld	s1,24(sp)
    80005c52:	6942                	ld	s2,16(sp)
    80005c54:	6145                	addi	sp,sp,48
    80005c56:	8082                	ret
    x = -xx;
    80005c58:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005c5c:	4885                	li	a7,1
    x = -xx;
    80005c5e:	bf95                	j	80005bd2 <printint+0x16>

0000000080005c60 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005c60:	1101                	addi	sp,sp,-32
    80005c62:	ec06                	sd	ra,24(sp)
    80005c64:	e822                	sd	s0,16(sp)
    80005c66:	e426                	sd	s1,8(sp)
    80005c68:	1000                	addi	s0,sp,32
    80005c6a:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005c6c:	00020797          	auipc	a5,0x20
    80005c70:	5807aa23          	sw	zero,1428(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005c74:	00003517          	auipc	a0,0x3
    80005c78:	cb450513          	addi	a0,a0,-844 # 80008928 <syscall_names+0x3d8>
    80005c7c:	00000097          	auipc	ra,0x0
    80005c80:	02e080e7          	jalr	46(ra) # 80005caa <printf>
  printf(s);
    80005c84:	8526                	mv	a0,s1
    80005c86:	00000097          	auipc	ra,0x0
    80005c8a:	024080e7          	jalr	36(ra) # 80005caa <printf>
  printf("\n");
    80005c8e:	00002517          	auipc	a0,0x2
    80005c92:	3ba50513          	addi	a0,a0,954 # 80008048 <etext+0x48>
    80005c96:	00000097          	auipc	ra,0x0
    80005c9a:	014080e7          	jalr	20(ra) # 80005caa <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005c9e:	4785                	li	a5,1
    80005ca0:	00003717          	auipc	a4,0x3
    80005ca4:	36f72e23          	sw	a5,892(a4) # 8000901c <panicked>
  for(;;)
    80005ca8:	a001                	j	80005ca8 <panic+0x48>

0000000080005caa <printf>:
{
    80005caa:	7131                	addi	sp,sp,-192
    80005cac:	fc86                	sd	ra,120(sp)
    80005cae:	f8a2                	sd	s0,112(sp)
    80005cb0:	f4a6                	sd	s1,104(sp)
    80005cb2:	f0ca                	sd	s2,96(sp)
    80005cb4:	ecce                	sd	s3,88(sp)
    80005cb6:	e8d2                	sd	s4,80(sp)
    80005cb8:	e4d6                	sd	s5,72(sp)
    80005cba:	e0da                	sd	s6,64(sp)
    80005cbc:	fc5e                	sd	s7,56(sp)
    80005cbe:	f862                	sd	s8,48(sp)
    80005cc0:	f466                	sd	s9,40(sp)
    80005cc2:	f06a                	sd	s10,32(sp)
    80005cc4:	ec6e                	sd	s11,24(sp)
    80005cc6:	0100                	addi	s0,sp,128
    80005cc8:	8a2a                	mv	s4,a0
    80005cca:	e40c                	sd	a1,8(s0)
    80005ccc:	e810                	sd	a2,16(s0)
    80005cce:	ec14                	sd	a3,24(s0)
    80005cd0:	f018                	sd	a4,32(s0)
    80005cd2:	f41c                	sd	a5,40(s0)
    80005cd4:	03043823          	sd	a6,48(s0)
    80005cd8:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005cdc:	00020d97          	auipc	s11,0x20
    80005ce0:	524dad83          	lw	s11,1316(s11) # 80026200 <pr+0x18>
  if(locking)
    80005ce4:	020d9b63          	bnez	s11,80005d1a <printf+0x70>
  if (fmt == 0)
    80005ce8:	040a0263          	beqz	s4,80005d2c <printf+0x82>
  va_start(ap, fmt);
    80005cec:	00840793          	addi	a5,s0,8
    80005cf0:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005cf4:	000a4503          	lbu	a0,0(s4)
    80005cf8:	14050f63          	beqz	a0,80005e56 <printf+0x1ac>
    80005cfc:	4981                	li	s3,0
    if(c != '%'){
    80005cfe:	02500a93          	li	s5,37
    switch(c){
    80005d02:	07000b93          	li	s7,112
  consputc('x');
    80005d06:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005d08:	00003b17          	auipc	s6,0x3
    80005d0c:	c48b0b13          	addi	s6,s6,-952 # 80008950 <digits>
    switch(c){
    80005d10:	07300c93          	li	s9,115
    80005d14:	06400c13          	li	s8,100
    80005d18:	a82d                	j	80005d52 <printf+0xa8>
    acquire(&pr.lock);
    80005d1a:	00020517          	auipc	a0,0x20
    80005d1e:	4ce50513          	addi	a0,a0,1230 # 800261e8 <pr>
    80005d22:	00000097          	auipc	ra,0x0
    80005d26:	476080e7          	jalr	1142(ra) # 80006198 <acquire>
    80005d2a:	bf7d                	j	80005ce8 <printf+0x3e>
    panic("null fmt");
    80005d2c:	00003517          	auipc	a0,0x3
    80005d30:	c0c50513          	addi	a0,a0,-1012 # 80008938 <syscall_names+0x3e8>
    80005d34:	00000097          	auipc	ra,0x0
    80005d38:	f2c080e7          	jalr	-212(ra) # 80005c60 <panic>
      consputc(c);
    80005d3c:	00000097          	auipc	ra,0x0
    80005d40:	c60080e7          	jalr	-928(ra) # 8000599c <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d44:	2985                	addiw	s3,s3,1
    80005d46:	013a07b3          	add	a5,s4,s3
    80005d4a:	0007c503          	lbu	a0,0(a5)
    80005d4e:	10050463          	beqz	a0,80005e56 <printf+0x1ac>
    if(c != '%'){
    80005d52:	ff5515e3          	bne	a0,s5,80005d3c <printf+0x92>
    c = fmt[++i] & 0xff;
    80005d56:	2985                	addiw	s3,s3,1
    80005d58:	013a07b3          	add	a5,s4,s3
    80005d5c:	0007c783          	lbu	a5,0(a5)
    80005d60:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005d64:	cbed                	beqz	a5,80005e56 <printf+0x1ac>
    switch(c){
    80005d66:	05778a63          	beq	a5,s7,80005dba <printf+0x110>
    80005d6a:	02fbf663          	bgeu	s7,a5,80005d96 <printf+0xec>
    80005d6e:	09978863          	beq	a5,s9,80005dfe <printf+0x154>
    80005d72:	07800713          	li	a4,120
    80005d76:	0ce79563          	bne	a5,a4,80005e40 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005d7a:	f8843783          	ld	a5,-120(s0)
    80005d7e:	00878713          	addi	a4,a5,8
    80005d82:	f8e43423          	sd	a4,-120(s0)
    80005d86:	4605                	li	a2,1
    80005d88:	85ea                	mv	a1,s10
    80005d8a:	4388                	lw	a0,0(a5)
    80005d8c:	00000097          	auipc	ra,0x0
    80005d90:	e30080e7          	jalr	-464(ra) # 80005bbc <printint>
      break;
    80005d94:	bf45                	j	80005d44 <printf+0x9a>
    switch(c){
    80005d96:	09578f63          	beq	a5,s5,80005e34 <printf+0x18a>
    80005d9a:	0b879363          	bne	a5,s8,80005e40 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005d9e:	f8843783          	ld	a5,-120(s0)
    80005da2:	00878713          	addi	a4,a5,8
    80005da6:	f8e43423          	sd	a4,-120(s0)
    80005daa:	4605                	li	a2,1
    80005dac:	45a9                	li	a1,10
    80005dae:	4388                	lw	a0,0(a5)
    80005db0:	00000097          	auipc	ra,0x0
    80005db4:	e0c080e7          	jalr	-500(ra) # 80005bbc <printint>
      break;
    80005db8:	b771                	j	80005d44 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005dba:	f8843783          	ld	a5,-120(s0)
    80005dbe:	00878713          	addi	a4,a5,8
    80005dc2:	f8e43423          	sd	a4,-120(s0)
    80005dc6:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005dca:	03000513          	li	a0,48
    80005dce:	00000097          	auipc	ra,0x0
    80005dd2:	bce080e7          	jalr	-1074(ra) # 8000599c <consputc>
  consputc('x');
    80005dd6:	07800513          	li	a0,120
    80005dda:	00000097          	auipc	ra,0x0
    80005dde:	bc2080e7          	jalr	-1086(ra) # 8000599c <consputc>
    80005de2:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005de4:	03c95793          	srli	a5,s2,0x3c
    80005de8:	97da                	add	a5,a5,s6
    80005dea:	0007c503          	lbu	a0,0(a5)
    80005dee:	00000097          	auipc	ra,0x0
    80005df2:	bae080e7          	jalr	-1106(ra) # 8000599c <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005df6:	0912                	slli	s2,s2,0x4
    80005df8:	34fd                	addiw	s1,s1,-1
    80005dfa:	f4ed                	bnez	s1,80005de4 <printf+0x13a>
    80005dfc:	b7a1                	j	80005d44 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005dfe:	f8843783          	ld	a5,-120(s0)
    80005e02:	00878713          	addi	a4,a5,8
    80005e06:	f8e43423          	sd	a4,-120(s0)
    80005e0a:	6384                	ld	s1,0(a5)
    80005e0c:	cc89                	beqz	s1,80005e26 <printf+0x17c>
      for(; *s; s++)
    80005e0e:	0004c503          	lbu	a0,0(s1)
    80005e12:	d90d                	beqz	a0,80005d44 <printf+0x9a>
        consputc(*s);
    80005e14:	00000097          	auipc	ra,0x0
    80005e18:	b88080e7          	jalr	-1144(ra) # 8000599c <consputc>
      for(; *s; s++)
    80005e1c:	0485                	addi	s1,s1,1
    80005e1e:	0004c503          	lbu	a0,0(s1)
    80005e22:	f96d                	bnez	a0,80005e14 <printf+0x16a>
    80005e24:	b705                	j	80005d44 <printf+0x9a>
        s = "(null)";
    80005e26:	00003497          	auipc	s1,0x3
    80005e2a:	b0a48493          	addi	s1,s1,-1270 # 80008930 <syscall_names+0x3e0>
      for(; *s; s++)
    80005e2e:	02800513          	li	a0,40
    80005e32:	b7cd                	j	80005e14 <printf+0x16a>
      consputc('%');
    80005e34:	8556                	mv	a0,s5
    80005e36:	00000097          	auipc	ra,0x0
    80005e3a:	b66080e7          	jalr	-1178(ra) # 8000599c <consputc>
      break;
    80005e3e:	b719                	j	80005d44 <printf+0x9a>
      consputc('%');
    80005e40:	8556                	mv	a0,s5
    80005e42:	00000097          	auipc	ra,0x0
    80005e46:	b5a080e7          	jalr	-1190(ra) # 8000599c <consputc>
      consputc(c);
    80005e4a:	8526                	mv	a0,s1
    80005e4c:	00000097          	auipc	ra,0x0
    80005e50:	b50080e7          	jalr	-1200(ra) # 8000599c <consputc>
      break;
    80005e54:	bdc5                	j	80005d44 <printf+0x9a>
  if(locking)
    80005e56:	020d9163          	bnez	s11,80005e78 <printf+0x1ce>
}
    80005e5a:	70e6                	ld	ra,120(sp)
    80005e5c:	7446                	ld	s0,112(sp)
    80005e5e:	74a6                	ld	s1,104(sp)
    80005e60:	7906                	ld	s2,96(sp)
    80005e62:	69e6                	ld	s3,88(sp)
    80005e64:	6a46                	ld	s4,80(sp)
    80005e66:	6aa6                	ld	s5,72(sp)
    80005e68:	6b06                	ld	s6,64(sp)
    80005e6a:	7be2                	ld	s7,56(sp)
    80005e6c:	7c42                	ld	s8,48(sp)
    80005e6e:	7ca2                	ld	s9,40(sp)
    80005e70:	7d02                	ld	s10,32(sp)
    80005e72:	6de2                	ld	s11,24(sp)
    80005e74:	6129                	addi	sp,sp,192
    80005e76:	8082                	ret
    release(&pr.lock);
    80005e78:	00020517          	auipc	a0,0x20
    80005e7c:	37050513          	addi	a0,a0,880 # 800261e8 <pr>
    80005e80:	00000097          	auipc	ra,0x0
    80005e84:	3cc080e7          	jalr	972(ra) # 8000624c <release>
}
    80005e88:	bfc9                	j	80005e5a <printf+0x1b0>

0000000080005e8a <printfinit>:
    ;
}

void
printfinit(void)
{
    80005e8a:	1101                	addi	sp,sp,-32
    80005e8c:	ec06                	sd	ra,24(sp)
    80005e8e:	e822                	sd	s0,16(sp)
    80005e90:	e426                	sd	s1,8(sp)
    80005e92:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005e94:	00020497          	auipc	s1,0x20
    80005e98:	35448493          	addi	s1,s1,852 # 800261e8 <pr>
    80005e9c:	00003597          	auipc	a1,0x3
    80005ea0:	aac58593          	addi	a1,a1,-1364 # 80008948 <syscall_names+0x3f8>
    80005ea4:	8526                	mv	a0,s1
    80005ea6:	00000097          	auipc	ra,0x0
    80005eaa:	262080e7          	jalr	610(ra) # 80006108 <initlock>
  pr.locking = 1;
    80005eae:	4785                	li	a5,1
    80005eb0:	cc9c                	sw	a5,24(s1)
}
    80005eb2:	60e2                	ld	ra,24(sp)
    80005eb4:	6442                	ld	s0,16(sp)
    80005eb6:	64a2                	ld	s1,8(sp)
    80005eb8:	6105                	addi	sp,sp,32
    80005eba:	8082                	ret

0000000080005ebc <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005ebc:	1141                	addi	sp,sp,-16
    80005ebe:	e406                	sd	ra,8(sp)
    80005ec0:	e022                	sd	s0,0(sp)
    80005ec2:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005ec4:	100007b7          	lui	a5,0x10000
    80005ec8:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005ecc:	f8000713          	li	a4,-128
    80005ed0:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005ed4:	470d                	li	a4,3
    80005ed6:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005eda:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005ede:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005ee2:	469d                	li	a3,7
    80005ee4:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005ee8:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005eec:	00003597          	auipc	a1,0x3
    80005ef0:	a7c58593          	addi	a1,a1,-1412 # 80008968 <digits+0x18>
    80005ef4:	00020517          	auipc	a0,0x20
    80005ef8:	31450513          	addi	a0,a0,788 # 80026208 <uart_tx_lock>
    80005efc:	00000097          	auipc	ra,0x0
    80005f00:	20c080e7          	jalr	524(ra) # 80006108 <initlock>
}
    80005f04:	60a2                	ld	ra,8(sp)
    80005f06:	6402                	ld	s0,0(sp)
    80005f08:	0141                	addi	sp,sp,16
    80005f0a:	8082                	ret

0000000080005f0c <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005f0c:	1101                	addi	sp,sp,-32
    80005f0e:	ec06                	sd	ra,24(sp)
    80005f10:	e822                	sd	s0,16(sp)
    80005f12:	e426                	sd	s1,8(sp)
    80005f14:	1000                	addi	s0,sp,32
    80005f16:	84aa                	mv	s1,a0
  push_off();
    80005f18:	00000097          	auipc	ra,0x0
    80005f1c:	234080e7          	jalr	564(ra) # 8000614c <push_off>

  if(panicked){
    80005f20:	00003797          	auipc	a5,0x3
    80005f24:	0fc7a783          	lw	a5,252(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f28:	10000737          	lui	a4,0x10000
  if(panicked){
    80005f2c:	c391                	beqz	a5,80005f30 <uartputc_sync+0x24>
    for(;;)
    80005f2e:	a001                	j	80005f2e <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f30:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005f34:	0207f793          	andi	a5,a5,32
    80005f38:	dfe5                	beqz	a5,80005f30 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005f3a:	0ff4f513          	zext.b	a0,s1
    80005f3e:	100007b7          	lui	a5,0x10000
    80005f42:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005f46:	00000097          	auipc	ra,0x0
    80005f4a:	2a6080e7          	jalr	678(ra) # 800061ec <pop_off>
}
    80005f4e:	60e2                	ld	ra,24(sp)
    80005f50:	6442                	ld	s0,16(sp)
    80005f52:	64a2                	ld	s1,8(sp)
    80005f54:	6105                	addi	sp,sp,32
    80005f56:	8082                	ret

0000000080005f58 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005f58:	00003797          	auipc	a5,0x3
    80005f5c:	0c87b783          	ld	a5,200(a5) # 80009020 <uart_tx_r>
    80005f60:	00003717          	auipc	a4,0x3
    80005f64:	0c873703          	ld	a4,200(a4) # 80009028 <uart_tx_w>
    80005f68:	06f70a63          	beq	a4,a5,80005fdc <uartstart+0x84>
{
    80005f6c:	7139                	addi	sp,sp,-64
    80005f6e:	fc06                	sd	ra,56(sp)
    80005f70:	f822                	sd	s0,48(sp)
    80005f72:	f426                	sd	s1,40(sp)
    80005f74:	f04a                	sd	s2,32(sp)
    80005f76:	ec4e                	sd	s3,24(sp)
    80005f78:	e852                	sd	s4,16(sp)
    80005f7a:	e456                	sd	s5,8(sp)
    80005f7c:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005f7e:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005f82:	00020a17          	auipc	s4,0x20
    80005f86:	286a0a13          	addi	s4,s4,646 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    80005f8a:	00003497          	auipc	s1,0x3
    80005f8e:	09648493          	addi	s1,s1,150 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005f92:	00003997          	auipc	s3,0x3
    80005f96:	09698993          	addi	s3,s3,150 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005f9a:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005f9e:	02077713          	andi	a4,a4,32
    80005fa2:	c705                	beqz	a4,80005fca <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005fa4:	01f7f713          	andi	a4,a5,31
    80005fa8:	9752                	add	a4,a4,s4
    80005faa:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80005fae:	0785                	addi	a5,a5,1
    80005fb0:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80005fb2:	8526                	mv	a0,s1
    80005fb4:	ffffb097          	auipc	ra,0xffffb
    80005fb8:	736080e7          	jalr	1846(ra) # 800016ea <wakeup>
    
    WriteReg(THR, c);
    80005fbc:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80005fc0:	609c                	ld	a5,0(s1)
    80005fc2:	0009b703          	ld	a4,0(s3)
    80005fc6:	fcf71ae3          	bne	a4,a5,80005f9a <uartstart+0x42>
  }
}
    80005fca:	70e2                	ld	ra,56(sp)
    80005fcc:	7442                	ld	s0,48(sp)
    80005fce:	74a2                	ld	s1,40(sp)
    80005fd0:	7902                	ld	s2,32(sp)
    80005fd2:	69e2                	ld	s3,24(sp)
    80005fd4:	6a42                	ld	s4,16(sp)
    80005fd6:	6aa2                	ld	s5,8(sp)
    80005fd8:	6121                	addi	sp,sp,64
    80005fda:	8082                	ret
    80005fdc:	8082                	ret

0000000080005fde <uartputc>:
{
    80005fde:	7179                	addi	sp,sp,-48
    80005fe0:	f406                	sd	ra,40(sp)
    80005fe2:	f022                	sd	s0,32(sp)
    80005fe4:	ec26                	sd	s1,24(sp)
    80005fe6:	e84a                	sd	s2,16(sp)
    80005fe8:	e44e                	sd	s3,8(sp)
    80005fea:	e052                	sd	s4,0(sp)
    80005fec:	1800                	addi	s0,sp,48
    80005fee:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80005ff0:	00020517          	auipc	a0,0x20
    80005ff4:	21850513          	addi	a0,a0,536 # 80026208 <uart_tx_lock>
    80005ff8:	00000097          	auipc	ra,0x0
    80005ffc:	1a0080e7          	jalr	416(ra) # 80006198 <acquire>
  if(panicked){
    80006000:	00003797          	auipc	a5,0x3
    80006004:	01c7a783          	lw	a5,28(a5) # 8000901c <panicked>
    80006008:	c391                	beqz	a5,8000600c <uartputc+0x2e>
    for(;;)
    8000600a:	a001                	j	8000600a <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000600c:	00003717          	auipc	a4,0x3
    80006010:	01c73703          	ld	a4,28(a4) # 80009028 <uart_tx_w>
    80006014:	00003797          	auipc	a5,0x3
    80006018:	00c7b783          	ld	a5,12(a5) # 80009020 <uart_tx_r>
    8000601c:	02078793          	addi	a5,a5,32
    80006020:	02e79b63          	bne	a5,a4,80006056 <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006024:	00020997          	auipc	s3,0x20
    80006028:	1e498993          	addi	s3,s3,484 # 80026208 <uart_tx_lock>
    8000602c:	00003497          	auipc	s1,0x3
    80006030:	ff448493          	addi	s1,s1,-12 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006034:	00003917          	auipc	s2,0x3
    80006038:	ff490913          	addi	s2,s2,-12 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000603c:	85ce                	mv	a1,s3
    8000603e:	8526                	mv	a0,s1
    80006040:	ffffb097          	auipc	ra,0xffffb
    80006044:	51e080e7          	jalr	1310(ra) # 8000155e <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006048:	00093703          	ld	a4,0(s2)
    8000604c:	609c                	ld	a5,0(s1)
    8000604e:	02078793          	addi	a5,a5,32
    80006052:	fee785e3          	beq	a5,a4,8000603c <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006056:	00020497          	auipc	s1,0x20
    8000605a:	1b248493          	addi	s1,s1,434 # 80026208 <uart_tx_lock>
    8000605e:	01f77793          	andi	a5,a4,31
    80006062:	97a6                	add	a5,a5,s1
    80006064:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    80006068:	0705                	addi	a4,a4,1
    8000606a:	00003797          	auipc	a5,0x3
    8000606e:	fae7bf23          	sd	a4,-66(a5) # 80009028 <uart_tx_w>
      uartstart();
    80006072:	00000097          	auipc	ra,0x0
    80006076:	ee6080e7          	jalr	-282(ra) # 80005f58 <uartstart>
      release(&uart_tx_lock);
    8000607a:	8526                	mv	a0,s1
    8000607c:	00000097          	auipc	ra,0x0
    80006080:	1d0080e7          	jalr	464(ra) # 8000624c <release>
}
    80006084:	70a2                	ld	ra,40(sp)
    80006086:	7402                	ld	s0,32(sp)
    80006088:	64e2                	ld	s1,24(sp)
    8000608a:	6942                	ld	s2,16(sp)
    8000608c:	69a2                	ld	s3,8(sp)
    8000608e:	6a02                	ld	s4,0(sp)
    80006090:	6145                	addi	sp,sp,48
    80006092:	8082                	ret

0000000080006094 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006094:	1141                	addi	sp,sp,-16
    80006096:	e422                	sd	s0,8(sp)
    80006098:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000609a:	100007b7          	lui	a5,0x10000
    8000609e:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800060a2:	8b85                	andi	a5,a5,1
    800060a4:	cb81                	beqz	a5,800060b4 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    800060a6:	100007b7          	lui	a5,0x10000
    800060aa:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800060ae:	6422                	ld	s0,8(sp)
    800060b0:	0141                	addi	sp,sp,16
    800060b2:	8082                	ret
    return -1;
    800060b4:	557d                	li	a0,-1
    800060b6:	bfe5                	j	800060ae <uartgetc+0x1a>

00000000800060b8 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    800060b8:	1101                	addi	sp,sp,-32
    800060ba:	ec06                	sd	ra,24(sp)
    800060bc:	e822                	sd	s0,16(sp)
    800060be:	e426                	sd	s1,8(sp)
    800060c0:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800060c2:	54fd                	li	s1,-1
    800060c4:	a029                	j	800060ce <uartintr+0x16>
      break;
    consoleintr(c);
    800060c6:	00000097          	auipc	ra,0x0
    800060ca:	918080e7          	jalr	-1768(ra) # 800059de <consoleintr>
    int c = uartgetc();
    800060ce:	00000097          	auipc	ra,0x0
    800060d2:	fc6080e7          	jalr	-58(ra) # 80006094 <uartgetc>
    if(c == -1)
    800060d6:	fe9518e3          	bne	a0,s1,800060c6 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800060da:	00020497          	auipc	s1,0x20
    800060de:	12e48493          	addi	s1,s1,302 # 80026208 <uart_tx_lock>
    800060e2:	8526                	mv	a0,s1
    800060e4:	00000097          	auipc	ra,0x0
    800060e8:	0b4080e7          	jalr	180(ra) # 80006198 <acquire>
  uartstart();
    800060ec:	00000097          	auipc	ra,0x0
    800060f0:	e6c080e7          	jalr	-404(ra) # 80005f58 <uartstart>
  release(&uart_tx_lock);
    800060f4:	8526                	mv	a0,s1
    800060f6:	00000097          	auipc	ra,0x0
    800060fa:	156080e7          	jalr	342(ra) # 8000624c <release>
}
    800060fe:	60e2                	ld	ra,24(sp)
    80006100:	6442                	ld	s0,16(sp)
    80006102:	64a2                	ld	s1,8(sp)
    80006104:	6105                	addi	sp,sp,32
    80006106:	8082                	ret

0000000080006108 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006108:	1141                	addi	sp,sp,-16
    8000610a:	e422                	sd	s0,8(sp)
    8000610c:	0800                	addi	s0,sp,16
  lk->name = name;
    8000610e:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006110:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006114:	00053823          	sd	zero,16(a0)
}
    80006118:	6422                	ld	s0,8(sp)
    8000611a:	0141                	addi	sp,sp,16
    8000611c:	8082                	ret

000000008000611e <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000611e:	411c                	lw	a5,0(a0)
    80006120:	e399                	bnez	a5,80006126 <holding+0x8>
    80006122:	4501                	li	a0,0
  return r;
}
    80006124:	8082                	ret
{
    80006126:	1101                	addi	sp,sp,-32
    80006128:	ec06                	sd	ra,24(sp)
    8000612a:	e822                	sd	s0,16(sp)
    8000612c:	e426                	sd	s1,8(sp)
    8000612e:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006130:	6904                	ld	s1,16(a0)
    80006132:	ffffb097          	auipc	ra,0xffffb
    80006136:	d40080e7          	jalr	-704(ra) # 80000e72 <mycpu>
    8000613a:	40a48533          	sub	a0,s1,a0
    8000613e:	00153513          	seqz	a0,a0
}
    80006142:	60e2                	ld	ra,24(sp)
    80006144:	6442                	ld	s0,16(sp)
    80006146:	64a2                	ld	s1,8(sp)
    80006148:	6105                	addi	sp,sp,32
    8000614a:	8082                	ret

000000008000614c <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    8000614c:	1101                	addi	sp,sp,-32
    8000614e:	ec06                	sd	ra,24(sp)
    80006150:	e822                	sd	s0,16(sp)
    80006152:	e426                	sd	s1,8(sp)
    80006154:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006156:	100024f3          	csrr	s1,sstatus
    8000615a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000615e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006160:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006164:	ffffb097          	auipc	ra,0xffffb
    80006168:	d0e080e7          	jalr	-754(ra) # 80000e72 <mycpu>
    8000616c:	5d3c                	lw	a5,120(a0)
    8000616e:	cf89                	beqz	a5,80006188 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006170:	ffffb097          	auipc	ra,0xffffb
    80006174:	d02080e7          	jalr	-766(ra) # 80000e72 <mycpu>
    80006178:	5d3c                	lw	a5,120(a0)
    8000617a:	2785                	addiw	a5,a5,1
    8000617c:	dd3c                	sw	a5,120(a0)
}
    8000617e:	60e2                	ld	ra,24(sp)
    80006180:	6442                	ld	s0,16(sp)
    80006182:	64a2                	ld	s1,8(sp)
    80006184:	6105                	addi	sp,sp,32
    80006186:	8082                	ret
    mycpu()->intena = old;
    80006188:	ffffb097          	auipc	ra,0xffffb
    8000618c:	cea080e7          	jalr	-790(ra) # 80000e72 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006190:	8085                	srli	s1,s1,0x1
    80006192:	8885                	andi	s1,s1,1
    80006194:	dd64                	sw	s1,124(a0)
    80006196:	bfe9                	j	80006170 <push_off+0x24>

0000000080006198 <acquire>:
{
    80006198:	1101                	addi	sp,sp,-32
    8000619a:	ec06                	sd	ra,24(sp)
    8000619c:	e822                	sd	s0,16(sp)
    8000619e:	e426                	sd	s1,8(sp)
    800061a0:	1000                	addi	s0,sp,32
    800061a2:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800061a4:	00000097          	auipc	ra,0x0
    800061a8:	fa8080e7          	jalr	-88(ra) # 8000614c <push_off>
  if(holding(lk))
    800061ac:	8526                	mv	a0,s1
    800061ae:	00000097          	auipc	ra,0x0
    800061b2:	f70080e7          	jalr	-144(ra) # 8000611e <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800061b6:	4705                	li	a4,1
  if(holding(lk))
    800061b8:	e115                	bnez	a0,800061dc <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800061ba:	87ba                	mv	a5,a4
    800061bc:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800061c0:	2781                	sext.w	a5,a5
    800061c2:	ffe5                	bnez	a5,800061ba <acquire+0x22>
  __sync_synchronize();
    800061c4:	0ff0000f          	fence
  lk->cpu = mycpu();
    800061c8:	ffffb097          	auipc	ra,0xffffb
    800061cc:	caa080e7          	jalr	-854(ra) # 80000e72 <mycpu>
    800061d0:	e888                	sd	a0,16(s1)
}
    800061d2:	60e2                	ld	ra,24(sp)
    800061d4:	6442                	ld	s0,16(sp)
    800061d6:	64a2                	ld	s1,8(sp)
    800061d8:	6105                	addi	sp,sp,32
    800061da:	8082                	ret
    panic("acquire");
    800061dc:	00002517          	auipc	a0,0x2
    800061e0:	79450513          	addi	a0,a0,1940 # 80008970 <digits+0x20>
    800061e4:	00000097          	auipc	ra,0x0
    800061e8:	a7c080e7          	jalr	-1412(ra) # 80005c60 <panic>

00000000800061ec <pop_off>:

void
pop_off(void)
{
    800061ec:	1141                	addi	sp,sp,-16
    800061ee:	e406                	sd	ra,8(sp)
    800061f0:	e022                	sd	s0,0(sp)
    800061f2:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800061f4:	ffffb097          	auipc	ra,0xffffb
    800061f8:	c7e080e7          	jalr	-898(ra) # 80000e72 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800061fc:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006200:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006202:	e78d                	bnez	a5,8000622c <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006204:	5d3c                	lw	a5,120(a0)
    80006206:	02f05b63          	blez	a5,8000623c <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    8000620a:	37fd                	addiw	a5,a5,-1
    8000620c:	0007871b          	sext.w	a4,a5
    80006210:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006212:	eb09                	bnez	a4,80006224 <pop_off+0x38>
    80006214:	5d7c                	lw	a5,124(a0)
    80006216:	c799                	beqz	a5,80006224 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006218:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000621c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006220:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006224:	60a2                	ld	ra,8(sp)
    80006226:	6402                	ld	s0,0(sp)
    80006228:	0141                	addi	sp,sp,16
    8000622a:	8082                	ret
    panic("pop_off - interruptible");
    8000622c:	00002517          	auipc	a0,0x2
    80006230:	74c50513          	addi	a0,a0,1868 # 80008978 <digits+0x28>
    80006234:	00000097          	auipc	ra,0x0
    80006238:	a2c080e7          	jalr	-1492(ra) # 80005c60 <panic>
    panic("pop_off");
    8000623c:	00002517          	auipc	a0,0x2
    80006240:	75450513          	addi	a0,a0,1876 # 80008990 <digits+0x40>
    80006244:	00000097          	auipc	ra,0x0
    80006248:	a1c080e7          	jalr	-1508(ra) # 80005c60 <panic>

000000008000624c <release>:
{
    8000624c:	1101                	addi	sp,sp,-32
    8000624e:	ec06                	sd	ra,24(sp)
    80006250:	e822                	sd	s0,16(sp)
    80006252:	e426                	sd	s1,8(sp)
    80006254:	1000                	addi	s0,sp,32
    80006256:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006258:	00000097          	auipc	ra,0x0
    8000625c:	ec6080e7          	jalr	-314(ra) # 8000611e <holding>
    80006260:	c115                	beqz	a0,80006284 <release+0x38>
  lk->cpu = 0;
    80006262:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006266:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    8000626a:	0f50000f          	fence	iorw,ow
    8000626e:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006272:	00000097          	auipc	ra,0x0
    80006276:	f7a080e7          	jalr	-134(ra) # 800061ec <pop_off>
}
    8000627a:	60e2                	ld	ra,24(sp)
    8000627c:	6442                	ld	s0,16(sp)
    8000627e:	64a2                	ld	s1,8(sp)
    80006280:	6105                	addi	sp,sp,32
    80006282:	8082                	ret
    panic("release");
    80006284:	00002517          	auipc	a0,0x2
    80006288:	71450513          	addi	a0,a0,1812 # 80008998 <digits+0x48>
    8000628c:	00000097          	auipc	ra,0x0
    80006290:	9d4080e7          	jalr	-1580(ra) # 80005c60 <panic>
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
