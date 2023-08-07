
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	8f013103          	ld	sp,-1808(sp) # 800098f0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	6ac060ef          	jal	ra,800066c2 <start>

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
    80000030:	00027797          	auipc	a5,0x27
    80000034:	55078793          	addi	a5,a5,1360 # 80027580 <end>
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
    80000050:	0000a917          	auipc	s2,0xa
    80000054:	00090913          	mv	s2,s2
    80000058:	854a                	mv	a0,s2
    8000005a:	00007097          	auipc	ra,0x7
    8000005e:	04e080e7          	jalr	78(ra) # 800070a8 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2) # 8000a068 <kmem+0x18>
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00007097          	auipc	ra,0x7
    80000072:	0ee080e7          	jalr	238(ra) # 8000715c <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00009517          	auipc	a0,0x9
    80000086:	f8e50513          	addi	a0,a0,-114 # 80009010 <etext+0x10>
    8000008a:	00007097          	auipc	ra,0x7
    8000008e:	ae6080e7          	jalr	-1306(ra) # 80006b70 <panic>

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
    800000e6:	00009597          	auipc	a1,0x9
    800000ea:	f3258593          	addi	a1,a1,-206 # 80009018 <etext+0x18>
    800000ee:	0000a517          	auipc	a0,0xa
    800000f2:	f6250513          	addi	a0,a0,-158 # 8000a050 <kmem>
    800000f6:	00007097          	auipc	ra,0x7
    800000fa:	f22080e7          	jalr	-222(ra) # 80007018 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	slli	a1,a1,0x1b
    80000102:	00027517          	auipc	a0,0x27
    80000106:	47e50513          	addi	a0,a0,1150 # 80027580 <end>
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
    80000124:	0000a497          	auipc	s1,0xa
    80000128:	f2c48493          	addi	s1,s1,-212 # 8000a050 <kmem>
    8000012c:	8526                	mv	a0,s1
    8000012e:	00007097          	auipc	ra,0x7
    80000132:	f7a080e7          	jalr	-134(ra) # 800070a8 <acquire>
  r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
  if(r)
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
    kmem.freelist = r->next;
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	0000a517          	auipc	a0,0xa
    80000140:	f1450513          	addi	a0,a0,-236 # 8000a050 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000146:	00007097          	auipc	ra,0x7
    8000014a:	016080e7          	jalr	22(ra) # 8000715c <release>

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
    80000168:	0000a517          	auipc	a0,0xa
    8000016c:	ee850513          	addi	a0,a0,-280 # 8000a050 <kmem>
    80000170:	00007097          	auipc	ra,0x7
    80000174:	fec080e7          	jalr	-20(ra) # 8000715c <release>
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
    800001ee:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffd7a81>
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
    80000320:	1101                	addi	sp,sp,-32
    80000322:	ec06                	sd	ra,24(sp)
    80000324:	e822                	sd	s0,16(sp)
    80000326:	e426                	sd	s1,8(sp)
    80000328:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    8000032a:	00001097          	auipc	ra,0x1
    8000032e:	b46080e7          	jalr	-1210(ra) # 80000e70 <cpuid>
    kcsaninit();
#endif
    __sync_synchronize();
    started = 1;
  } else {
    while(lockfree_read4((int *) &started) == 0)
    80000332:	0000a497          	auipc	s1,0xa
    80000336:	cce48493          	addi	s1,s1,-818 # 8000a000 <started>
  if(cpuid() == 0){
    8000033a:	c531                	beqz	a0,80000386 <main+0x66>
    while(lockfree_read4((int *) &started) == 0)
    8000033c:	8526                	mv	a0,s1
    8000033e:	00007097          	auipc	ra,0x7
    80000342:	e7c080e7          	jalr	-388(ra) # 800071ba <lockfree_read4>
    80000346:	d97d                	beqz	a0,8000033c <main+0x1c>
      ;
    __sync_synchronize();
    80000348:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000034c:	00001097          	auipc	ra,0x1
    80000350:	b24080e7          	jalr	-1244(ra) # 80000e70 <cpuid>
    80000354:	85aa                	mv	a1,a0
    80000356:	00009517          	auipc	a0,0x9
    8000035a:	ce250513          	addi	a0,a0,-798 # 80009038 <etext+0x38>
    8000035e:	00007097          	auipc	ra,0x7
    80000362:	85c080e7          	jalr	-1956(ra) # 80006bba <printf>
    kvminithart();    // turn on paging
    80000366:	00000097          	auipc	ra,0x0
    8000036a:	0e8080e7          	jalr	232(ra) # 8000044e <kvminithart>
    trapinithart();   // install kernel trap vector
    8000036e:	00001097          	auipc	ra,0x1
    80000372:	784080e7          	jalr	1924(ra) # 80001af2 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000376:	00005097          	auipc	ra,0x5
    8000037a:	dfe080e7          	jalr	-514(ra) # 80005174 <plicinithart>
  }

  scheduler();        
    8000037e:	00001097          	auipc	ra,0x1
    80000382:	030080e7          	jalr	48(ra) # 800013ae <scheduler>
    consoleinit();
    80000386:	00006097          	auipc	ra,0x6
    8000038a:	6fa080e7          	jalr	1786(ra) # 80006a80 <consoleinit>
    printfinit();
    8000038e:	00007097          	auipc	ra,0x7
    80000392:	a0c080e7          	jalr	-1524(ra) # 80006d9a <printfinit>
    printf("\n");
    80000396:	00009517          	auipc	a0,0x9
    8000039a:	cb250513          	addi	a0,a0,-846 # 80009048 <etext+0x48>
    8000039e:	00007097          	auipc	ra,0x7
    800003a2:	81c080e7          	jalr	-2020(ra) # 80006bba <printf>
    printf("xv6 kernel is booting\n");
    800003a6:	00009517          	auipc	a0,0x9
    800003aa:	c7a50513          	addi	a0,a0,-902 # 80009020 <etext+0x20>
    800003ae:	00007097          	auipc	ra,0x7
    800003b2:	80c080e7          	jalr	-2036(ra) # 80006bba <printf>
    printf("\n");
    800003b6:	00009517          	auipc	a0,0x9
    800003ba:	c9250513          	addi	a0,a0,-878 # 80009048 <etext+0x48>
    800003be:	00006097          	auipc	ra,0x6
    800003c2:	7fc080e7          	jalr	2044(ra) # 80006bba <printf>
    kinit();         // physical page allocator
    800003c6:	00000097          	auipc	ra,0x0
    800003ca:	d18080e7          	jalr	-744(ra) # 800000de <kinit>
    kvminit();       // create kernel page table
    800003ce:	00000097          	auipc	ra,0x0
    800003d2:	362080e7          	jalr	866(ra) # 80000730 <kvminit>
    kvminithart();   // turn on paging
    800003d6:	00000097          	auipc	ra,0x0
    800003da:	078080e7          	jalr	120(ra) # 8000044e <kvminithart>
    procinit();      // process table
    800003de:	00001097          	auipc	ra,0x1
    800003e2:	9e4080e7          	jalr	-1564(ra) # 80000dc2 <procinit>
    trapinit();      // trap vectors
    800003e6:	00001097          	auipc	ra,0x1
    800003ea:	6e4080e7          	jalr	1764(ra) # 80001aca <trapinit>
    trapinithart();  // install kernel trap vector
    800003ee:	00001097          	auipc	ra,0x1
    800003f2:	704080e7          	jalr	1796(ra) # 80001af2 <trapinithart>
    plicinit();      // set up interrupt controller
    800003f6:	00005097          	auipc	ra,0x5
    800003fa:	d54080e7          	jalr	-684(ra) # 8000514a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003fe:	00005097          	auipc	ra,0x5
    80000402:	d76080e7          	jalr	-650(ra) # 80005174 <plicinithart>
    binit();         // buffer cache
    80000406:	00002097          	auipc	ra,0x2
    8000040a:	e5e080e7          	jalr	-418(ra) # 80002264 <binit>
    iinit();         // inode table
    8000040e:	00002097          	auipc	ra,0x2
    80000412:	4ec080e7          	jalr	1260(ra) # 800028fa <iinit>
    fileinit();      // file table
    80000416:	00003097          	auipc	ra,0x3
    8000041a:	49e080e7          	jalr	1182(ra) # 800038b4 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000041e:	00005097          	auipc	ra,0x5
    80000422:	e7c080e7          	jalr	-388(ra) # 8000529a <virtio_disk_init>
    pci_init();
    80000426:	00006097          	auipc	ra,0x6
    8000042a:	1a0080e7          	jalr	416(ra) # 800065c6 <pci_init>
    sockinit();
    8000042e:	00006097          	auipc	ra,0x6
    80000432:	d8c080e7          	jalr	-628(ra) # 800061ba <sockinit>
    userinit();      // first user process
    80000436:	00001097          	auipc	ra,0x1
    8000043a:	d3e080e7          	jalr	-706(ra) # 80001174 <userinit>
    __sync_synchronize();
    8000043e:	0ff0000f          	fence
    started = 1;
    80000442:	4785                	li	a5,1
    80000444:	0000a717          	auipc	a4,0xa
    80000448:	baf72e23          	sw	a5,-1092(a4) # 8000a000 <started>
    8000044c:	bf0d                	j	8000037e <main+0x5e>

000000008000044e <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000044e:	1141                	addi	sp,sp,-16
    80000450:	e422                	sd	s0,8(sp)
    80000452:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000454:	0000a797          	auipc	a5,0xa
    80000458:	bb47b783          	ld	a5,-1100(a5) # 8000a008 <kernel_pagetable>
    8000045c:	83b1                	srli	a5,a5,0xc
    8000045e:	577d                	li	a4,-1
    80000460:	177e                	slli	a4,a4,0x3f
    80000462:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    80000464:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000468:	12000073          	sfence.vma
  sfence_vma();
}
    8000046c:	6422                	ld	s0,8(sp)
    8000046e:	0141                	addi	sp,sp,16
    80000470:	8082                	ret

0000000080000472 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000472:	7139                	addi	sp,sp,-64
    80000474:	fc06                	sd	ra,56(sp)
    80000476:	f822                	sd	s0,48(sp)
    80000478:	f426                	sd	s1,40(sp)
    8000047a:	f04a                	sd	s2,32(sp)
    8000047c:	ec4e                	sd	s3,24(sp)
    8000047e:	e852                	sd	s4,16(sp)
    80000480:	e456                	sd	s5,8(sp)
    80000482:	e05a                	sd	s6,0(sp)
    80000484:	0080                	addi	s0,sp,64
    80000486:	84aa                	mv	s1,a0
    80000488:	89ae                	mv	s3,a1
    8000048a:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000048c:	57fd                	li	a5,-1
    8000048e:	83e9                	srli	a5,a5,0x1a
    80000490:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000492:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000494:	04b7f263          	bgeu	a5,a1,800004d8 <walk+0x66>
    panic("walk");
    80000498:	00009517          	auipc	a0,0x9
    8000049c:	bb850513          	addi	a0,a0,-1096 # 80009050 <etext+0x50>
    800004a0:	00006097          	auipc	ra,0x6
    800004a4:	6d0080e7          	jalr	1744(ra) # 80006b70 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800004a8:	060a8663          	beqz	s5,80000514 <walk+0xa2>
    800004ac:	00000097          	auipc	ra,0x0
    800004b0:	c6e080e7          	jalr	-914(ra) # 8000011a <kalloc>
    800004b4:	84aa                	mv	s1,a0
    800004b6:	c529                	beqz	a0,80000500 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004b8:	6605                	lui	a2,0x1
    800004ba:	4581                	li	a1,0
    800004bc:	00000097          	auipc	ra,0x0
    800004c0:	cbe080e7          	jalr	-834(ra) # 8000017a <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004c4:	00c4d793          	srli	a5,s1,0xc
    800004c8:	07aa                	slli	a5,a5,0xa
    800004ca:	0017e793          	ori	a5,a5,1
    800004ce:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004d2:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffd7a77>
    800004d4:	036a0063          	beq	s4,s6,800004f4 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004d8:	0149d933          	srl	s2,s3,s4
    800004dc:	1ff97913          	andi	s2,s2,511
    800004e0:	090e                	slli	s2,s2,0x3
    800004e2:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004e4:	00093483          	ld	s1,0(s2)
    800004e8:	0014f793          	andi	a5,s1,1
    800004ec:	dfd5                	beqz	a5,800004a8 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004ee:	80a9                	srli	s1,s1,0xa
    800004f0:	04b2                	slli	s1,s1,0xc
    800004f2:	b7c5                	j	800004d2 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004f4:	00c9d513          	srli	a0,s3,0xc
    800004f8:	1ff57513          	andi	a0,a0,511
    800004fc:	050e                	slli	a0,a0,0x3
    800004fe:	9526                	add	a0,a0,s1
}
    80000500:	70e2                	ld	ra,56(sp)
    80000502:	7442                	ld	s0,48(sp)
    80000504:	74a2                	ld	s1,40(sp)
    80000506:	7902                	ld	s2,32(sp)
    80000508:	69e2                	ld	s3,24(sp)
    8000050a:	6a42                	ld	s4,16(sp)
    8000050c:	6aa2                	ld	s5,8(sp)
    8000050e:	6b02                	ld	s6,0(sp)
    80000510:	6121                	addi	sp,sp,64
    80000512:	8082                	ret
        return 0;
    80000514:	4501                	li	a0,0
    80000516:	b7ed                	j	80000500 <walk+0x8e>

0000000080000518 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000518:	57fd                	li	a5,-1
    8000051a:	83e9                	srli	a5,a5,0x1a
    8000051c:	00b7f463          	bgeu	a5,a1,80000524 <walkaddr+0xc>
    return 0;
    80000520:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000522:	8082                	ret
{
    80000524:	1141                	addi	sp,sp,-16
    80000526:	e406                	sd	ra,8(sp)
    80000528:	e022                	sd	s0,0(sp)
    8000052a:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000052c:	4601                	li	a2,0
    8000052e:	00000097          	auipc	ra,0x0
    80000532:	f44080e7          	jalr	-188(ra) # 80000472 <walk>
  if(pte == 0)
    80000536:	c105                	beqz	a0,80000556 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000538:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000053a:	0117f693          	andi	a3,a5,17
    8000053e:	4745                	li	a4,17
    return 0;
    80000540:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000542:	00e68663          	beq	a3,a4,8000054e <walkaddr+0x36>
}
    80000546:	60a2                	ld	ra,8(sp)
    80000548:	6402                	ld	s0,0(sp)
    8000054a:	0141                	addi	sp,sp,16
    8000054c:	8082                	ret
  pa = PTE2PA(*pte);
    8000054e:	83a9                	srli	a5,a5,0xa
    80000550:	00c79513          	slli	a0,a5,0xc
  return pa;
    80000554:	bfcd                	j	80000546 <walkaddr+0x2e>
    return 0;
    80000556:	4501                	li	a0,0
    80000558:	b7fd                	j	80000546 <walkaddr+0x2e>

000000008000055a <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000055a:	715d                	addi	sp,sp,-80
    8000055c:	e486                	sd	ra,72(sp)
    8000055e:	e0a2                	sd	s0,64(sp)
    80000560:	fc26                	sd	s1,56(sp)
    80000562:	f84a                	sd	s2,48(sp)
    80000564:	f44e                	sd	s3,40(sp)
    80000566:	f052                	sd	s4,32(sp)
    80000568:	ec56                	sd	s5,24(sp)
    8000056a:	e85a                	sd	s6,16(sp)
    8000056c:	e45e                	sd	s7,8(sp)
    8000056e:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80000570:	c639                	beqz	a2,800005be <mappages+0x64>
    80000572:	8aaa                	mv	s5,a0
    80000574:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000576:	777d                	lui	a4,0xfffff
    80000578:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    8000057c:	fff58993          	addi	s3,a1,-1
    80000580:	99b2                	add	s3,s3,a2
    80000582:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80000586:	893e                	mv	s2,a5
    80000588:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000058c:	6b85                	lui	s7,0x1
    8000058e:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    80000592:	4605                	li	a2,1
    80000594:	85ca                	mv	a1,s2
    80000596:	8556                	mv	a0,s5
    80000598:	00000097          	auipc	ra,0x0
    8000059c:	eda080e7          	jalr	-294(ra) # 80000472 <walk>
    800005a0:	cd1d                	beqz	a0,800005de <mappages+0x84>
    if(*pte & PTE_V)
    800005a2:	611c                	ld	a5,0(a0)
    800005a4:	8b85                	andi	a5,a5,1
    800005a6:	e785                	bnez	a5,800005ce <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005a8:	80b1                	srli	s1,s1,0xc
    800005aa:	04aa                	slli	s1,s1,0xa
    800005ac:	0164e4b3          	or	s1,s1,s6
    800005b0:	0014e493          	ori	s1,s1,1
    800005b4:	e104                	sd	s1,0(a0)
    if(a == last)
    800005b6:	05390063          	beq	s2,s3,800005f6 <mappages+0x9c>
    a += PGSIZE;
    800005ba:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005bc:	bfc9                	j	8000058e <mappages+0x34>
    panic("mappages: size");
    800005be:	00009517          	auipc	a0,0x9
    800005c2:	a9a50513          	addi	a0,a0,-1382 # 80009058 <etext+0x58>
    800005c6:	00006097          	auipc	ra,0x6
    800005ca:	5aa080e7          	jalr	1450(ra) # 80006b70 <panic>
      panic("mappages: remap");
    800005ce:	00009517          	auipc	a0,0x9
    800005d2:	a9a50513          	addi	a0,a0,-1382 # 80009068 <etext+0x68>
    800005d6:	00006097          	auipc	ra,0x6
    800005da:	59a080e7          	jalr	1434(ra) # 80006b70 <panic>
      return -1;
    800005de:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800005e0:	60a6                	ld	ra,72(sp)
    800005e2:	6406                	ld	s0,64(sp)
    800005e4:	74e2                	ld	s1,56(sp)
    800005e6:	7942                	ld	s2,48(sp)
    800005e8:	79a2                	ld	s3,40(sp)
    800005ea:	7a02                	ld	s4,32(sp)
    800005ec:	6ae2                	ld	s5,24(sp)
    800005ee:	6b42                	ld	s6,16(sp)
    800005f0:	6ba2                	ld	s7,8(sp)
    800005f2:	6161                	addi	sp,sp,80
    800005f4:	8082                	ret
  return 0;
    800005f6:	4501                	li	a0,0
    800005f8:	b7e5                	j	800005e0 <mappages+0x86>

00000000800005fa <kvmmap>:
{
    800005fa:	1141                	addi	sp,sp,-16
    800005fc:	e406                	sd	ra,8(sp)
    800005fe:	e022                	sd	s0,0(sp)
    80000600:	0800                	addi	s0,sp,16
    80000602:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000604:	86b2                	mv	a3,a2
    80000606:	863e                	mv	a2,a5
    80000608:	00000097          	auipc	ra,0x0
    8000060c:	f52080e7          	jalr	-174(ra) # 8000055a <mappages>
    80000610:	e509                	bnez	a0,8000061a <kvmmap+0x20>
}
    80000612:	60a2                	ld	ra,8(sp)
    80000614:	6402                	ld	s0,0(sp)
    80000616:	0141                	addi	sp,sp,16
    80000618:	8082                	ret
    panic("kvmmap");
    8000061a:	00009517          	auipc	a0,0x9
    8000061e:	a5e50513          	addi	a0,a0,-1442 # 80009078 <etext+0x78>
    80000622:	00006097          	auipc	ra,0x6
    80000626:	54e080e7          	jalr	1358(ra) # 80006b70 <panic>

000000008000062a <kvmmake>:
{
    8000062a:	1101                	addi	sp,sp,-32
    8000062c:	ec06                	sd	ra,24(sp)
    8000062e:	e822                	sd	s0,16(sp)
    80000630:	e426                	sd	s1,8(sp)
    80000632:	e04a                	sd	s2,0(sp)
    80000634:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000636:	00000097          	auipc	ra,0x0
    8000063a:	ae4080e7          	jalr	-1308(ra) # 8000011a <kalloc>
    8000063e:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000640:	6605                	lui	a2,0x1
    80000642:	4581                	li	a1,0
    80000644:	00000097          	auipc	ra,0x0
    80000648:	b36080e7          	jalr	-1226(ra) # 8000017a <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000064c:	4719                	li	a4,6
    8000064e:	6685                	lui	a3,0x1
    80000650:	10000637          	lui	a2,0x10000
    80000654:	100005b7          	lui	a1,0x10000
    80000658:	8526                	mv	a0,s1
    8000065a:	00000097          	auipc	ra,0x0
    8000065e:	fa0080e7          	jalr	-96(ra) # 800005fa <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000662:	4719                	li	a4,6
    80000664:	6685                	lui	a3,0x1
    80000666:	10001637          	lui	a2,0x10001
    8000066a:	100015b7          	lui	a1,0x10001
    8000066e:	8526                	mv	a0,s1
    80000670:	00000097          	auipc	ra,0x0
    80000674:	f8a080e7          	jalr	-118(ra) # 800005fa <kvmmap>
  kvmmap(kpgtbl, 0x30000000L, 0x30000000L, 0x10000000, PTE_R | PTE_W);
    80000678:	4719                	li	a4,6
    8000067a:	100006b7          	lui	a3,0x10000
    8000067e:	30000637          	lui	a2,0x30000
    80000682:	300005b7          	lui	a1,0x30000
    80000686:	8526                	mv	a0,s1
    80000688:	00000097          	auipc	ra,0x0
    8000068c:	f72080e7          	jalr	-142(ra) # 800005fa <kvmmap>
  kvmmap(kpgtbl, 0x40000000L, 0x40000000L, 0x20000, PTE_R | PTE_W);
    80000690:	4719                	li	a4,6
    80000692:	000206b7          	lui	a3,0x20
    80000696:	40000637          	lui	a2,0x40000
    8000069a:	400005b7          	lui	a1,0x40000
    8000069e:	8526                	mv	a0,s1
    800006a0:	00000097          	auipc	ra,0x0
    800006a4:	f5a080e7          	jalr	-166(ra) # 800005fa <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800006a8:	4719                	li	a4,6
    800006aa:	004006b7          	lui	a3,0x400
    800006ae:	0c000637          	lui	a2,0xc000
    800006b2:	0c0005b7          	lui	a1,0xc000
    800006b6:	8526                	mv	a0,s1
    800006b8:	00000097          	auipc	ra,0x0
    800006bc:	f42080e7          	jalr	-190(ra) # 800005fa <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800006c0:	00009917          	auipc	s2,0x9
    800006c4:	94090913          	addi	s2,s2,-1728 # 80009000 <etext>
    800006c8:	4729                	li	a4,10
    800006ca:	80009697          	auipc	a3,0x80009
    800006ce:	93668693          	addi	a3,a3,-1738 # 9000 <_entry-0x7fff7000>
    800006d2:	4605                	li	a2,1
    800006d4:	067e                	slli	a2,a2,0x1f
    800006d6:	85b2                	mv	a1,a2
    800006d8:	8526                	mv	a0,s1
    800006da:	00000097          	auipc	ra,0x0
    800006de:	f20080e7          	jalr	-224(ra) # 800005fa <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006e2:	4719                	li	a4,6
    800006e4:	46c5                	li	a3,17
    800006e6:	06ee                	slli	a3,a3,0x1b
    800006e8:	412686b3          	sub	a3,a3,s2
    800006ec:	864a                	mv	a2,s2
    800006ee:	85ca                	mv	a1,s2
    800006f0:	8526                	mv	a0,s1
    800006f2:	00000097          	auipc	ra,0x0
    800006f6:	f08080e7          	jalr	-248(ra) # 800005fa <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006fa:	4729                	li	a4,10
    800006fc:	6685                	lui	a3,0x1
    800006fe:	00008617          	auipc	a2,0x8
    80000702:	90260613          	addi	a2,a2,-1790 # 80008000 <_trampoline>
    80000706:	040005b7          	lui	a1,0x4000
    8000070a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000070c:	05b2                	slli	a1,a1,0xc
    8000070e:	8526                	mv	a0,s1
    80000710:	00000097          	auipc	ra,0x0
    80000714:	eea080e7          	jalr	-278(ra) # 800005fa <kvmmap>
  proc_mapstacks(kpgtbl);
    80000718:	8526                	mv	a0,s1
    8000071a:	00000097          	auipc	ra,0x0
    8000071e:	614080e7          	jalr	1556(ra) # 80000d2e <proc_mapstacks>
}
    80000722:	8526                	mv	a0,s1
    80000724:	60e2                	ld	ra,24(sp)
    80000726:	6442                	ld	s0,16(sp)
    80000728:	64a2                	ld	s1,8(sp)
    8000072a:	6902                	ld	s2,0(sp)
    8000072c:	6105                	addi	sp,sp,32
    8000072e:	8082                	ret

0000000080000730 <kvminit>:
{
    80000730:	1141                	addi	sp,sp,-16
    80000732:	e406                	sd	ra,8(sp)
    80000734:	e022                	sd	s0,0(sp)
    80000736:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000738:	00000097          	auipc	ra,0x0
    8000073c:	ef2080e7          	jalr	-270(ra) # 8000062a <kvmmake>
    80000740:	0000a797          	auipc	a5,0xa
    80000744:	8ca7b423          	sd	a0,-1848(a5) # 8000a008 <kernel_pagetable>
}
    80000748:	60a2                	ld	ra,8(sp)
    8000074a:	6402                	ld	s0,0(sp)
    8000074c:	0141                	addi	sp,sp,16
    8000074e:	8082                	ret

0000000080000750 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000750:	715d                	addi	sp,sp,-80
    80000752:	e486                	sd	ra,72(sp)
    80000754:	e0a2                	sd	s0,64(sp)
    80000756:	fc26                	sd	s1,56(sp)
    80000758:	f84a                	sd	s2,48(sp)
    8000075a:	f44e                	sd	s3,40(sp)
    8000075c:	f052                	sd	s4,32(sp)
    8000075e:	ec56                	sd	s5,24(sp)
    80000760:	e85a                	sd	s6,16(sp)
    80000762:	e45e                	sd	s7,8(sp)
    80000764:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000766:	03459793          	slli	a5,a1,0x34
    8000076a:	e795                	bnez	a5,80000796 <uvmunmap+0x46>
    8000076c:	8a2a                	mv	s4,a0
    8000076e:	892e                	mv	s2,a1
    80000770:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000772:	0632                	slli	a2,a2,0xc
    80000774:	00b609b3          	add	s3,a2,a1
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0) {
      printf("va=%p pte=%p\n", a, *pte);
      panic("uvmunmap: not mapped");
    }
    if(PTE_FLAGS(*pte) == PTE_V)
    80000778:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000077a:	6b05                	lui	s6,0x1
    8000077c:	0735eb63          	bltu	a1,s3,800007f2 <uvmunmap+0xa2>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000780:	60a6                	ld	ra,72(sp)
    80000782:	6406                	ld	s0,64(sp)
    80000784:	74e2                	ld	s1,56(sp)
    80000786:	7942                	ld	s2,48(sp)
    80000788:	79a2                	ld	s3,40(sp)
    8000078a:	7a02                	ld	s4,32(sp)
    8000078c:	6ae2                	ld	s5,24(sp)
    8000078e:	6b42                	ld	s6,16(sp)
    80000790:	6ba2                	ld	s7,8(sp)
    80000792:	6161                	addi	sp,sp,80
    80000794:	8082                	ret
    panic("uvmunmap: not aligned");
    80000796:	00009517          	auipc	a0,0x9
    8000079a:	8ea50513          	addi	a0,a0,-1814 # 80009080 <etext+0x80>
    8000079e:	00006097          	auipc	ra,0x6
    800007a2:	3d2080e7          	jalr	978(ra) # 80006b70 <panic>
      panic("uvmunmap: walk");
    800007a6:	00009517          	auipc	a0,0x9
    800007aa:	8f250513          	addi	a0,a0,-1806 # 80009098 <etext+0x98>
    800007ae:	00006097          	auipc	ra,0x6
    800007b2:	3c2080e7          	jalr	962(ra) # 80006b70 <panic>
      printf("va=%p pte=%p\n", a, *pte);
    800007b6:	85ca                	mv	a1,s2
    800007b8:	00009517          	auipc	a0,0x9
    800007bc:	8f050513          	addi	a0,a0,-1808 # 800090a8 <etext+0xa8>
    800007c0:	00006097          	auipc	ra,0x6
    800007c4:	3fa080e7          	jalr	1018(ra) # 80006bba <printf>
      panic("uvmunmap: not mapped");
    800007c8:	00009517          	auipc	a0,0x9
    800007cc:	8f050513          	addi	a0,a0,-1808 # 800090b8 <etext+0xb8>
    800007d0:	00006097          	auipc	ra,0x6
    800007d4:	3a0080e7          	jalr	928(ra) # 80006b70 <panic>
      panic("uvmunmap: not a leaf");
    800007d8:	00009517          	auipc	a0,0x9
    800007dc:	8f850513          	addi	a0,a0,-1800 # 800090d0 <etext+0xd0>
    800007e0:	00006097          	auipc	ra,0x6
    800007e4:	390080e7          	jalr	912(ra) # 80006b70 <panic>
    *pte = 0;
    800007e8:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007ec:	995a                	add	s2,s2,s6
    800007ee:	f93979e3          	bgeu	s2,s3,80000780 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007f2:	4601                	li	a2,0
    800007f4:	85ca                	mv	a1,s2
    800007f6:	8552                	mv	a0,s4
    800007f8:	00000097          	auipc	ra,0x0
    800007fc:	c7a080e7          	jalr	-902(ra) # 80000472 <walk>
    80000800:	84aa                	mv	s1,a0
    80000802:	d155                	beqz	a0,800007a6 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0) {
    80000804:	6110                	ld	a2,0(a0)
    80000806:	00167793          	andi	a5,a2,1
    8000080a:	d7d5                	beqz	a5,800007b6 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    8000080c:	3ff67793          	andi	a5,a2,1023
    80000810:	fd7784e3          	beq	a5,s7,800007d8 <uvmunmap+0x88>
    if(do_free){
    80000814:	fc0a8ae3          	beqz	s5,800007e8 <uvmunmap+0x98>
      uint64 pa = PTE2PA(*pte);
    80000818:	8229                	srli	a2,a2,0xa
      kfree((void*)pa);
    8000081a:	00c61513          	slli	a0,a2,0xc
    8000081e:	fffff097          	auipc	ra,0xfffff
    80000822:	7fe080e7          	jalr	2046(ra) # 8000001c <kfree>
    80000826:	b7c9                	j	800007e8 <uvmunmap+0x98>

0000000080000828 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80000828:	1101                	addi	sp,sp,-32
    8000082a:	ec06                	sd	ra,24(sp)
    8000082c:	e822                	sd	s0,16(sp)
    8000082e:	e426                	sd	s1,8(sp)
    80000830:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000832:	00000097          	auipc	ra,0x0
    80000836:	8e8080e7          	jalr	-1816(ra) # 8000011a <kalloc>
    8000083a:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000083c:	c519                	beqz	a0,8000084a <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000083e:	6605                	lui	a2,0x1
    80000840:	4581                	li	a1,0
    80000842:	00000097          	auipc	ra,0x0
    80000846:	938080e7          	jalr	-1736(ra) # 8000017a <memset>
  return pagetable;
}
    8000084a:	8526                	mv	a0,s1
    8000084c:	60e2                	ld	ra,24(sp)
    8000084e:	6442                	ld	s0,16(sp)
    80000850:	64a2                	ld	s1,8(sp)
    80000852:	6105                	addi	sp,sp,32
    80000854:	8082                	ret

0000000080000856 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    80000856:	7179                	addi	sp,sp,-48
    80000858:	f406                	sd	ra,40(sp)
    8000085a:	f022                	sd	s0,32(sp)
    8000085c:	ec26                	sd	s1,24(sp)
    8000085e:	e84a                	sd	s2,16(sp)
    80000860:	e44e                	sd	s3,8(sp)
    80000862:	e052                	sd	s4,0(sp)
    80000864:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000866:	6785                	lui	a5,0x1
    80000868:	04f67863          	bgeu	a2,a5,800008b8 <uvminit+0x62>
    8000086c:	8a2a                	mv	s4,a0
    8000086e:	89ae                	mv	s3,a1
    80000870:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80000872:	00000097          	auipc	ra,0x0
    80000876:	8a8080e7          	jalr	-1880(ra) # 8000011a <kalloc>
    8000087a:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000087c:	6605                	lui	a2,0x1
    8000087e:	4581                	li	a1,0
    80000880:	00000097          	auipc	ra,0x0
    80000884:	8fa080e7          	jalr	-1798(ra) # 8000017a <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000888:	4779                	li	a4,30
    8000088a:	86ca                	mv	a3,s2
    8000088c:	6605                	lui	a2,0x1
    8000088e:	4581                	li	a1,0
    80000890:	8552                	mv	a0,s4
    80000892:	00000097          	auipc	ra,0x0
    80000896:	cc8080e7          	jalr	-824(ra) # 8000055a <mappages>
  memmove(mem, src, sz);
    8000089a:	8626                	mv	a2,s1
    8000089c:	85ce                	mv	a1,s3
    8000089e:	854a                	mv	a0,s2
    800008a0:	00000097          	auipc	ra,0x0
    800008a4:	936080e7          	jalr	-1738(ra) # 800001d6 <memmove>
}
    800008a8:	70a2                	ld	ra,40(sp)
    800008aa:	7402                	ld	s0,32(sp)
    800008ac:	64e2                	ld	s1,24(sp)
    800008ae:	6942                	ld	s2,16(sp)
    800008b0:	69a2                	ld	s3,8(sp)
    800008b2:	6a02                	ld	s4,0(sp)
    800008b4:	6145                	addi	sp,sp,48
    800008b6:	8082                	ret
    panic("inituvm: more than a page");
    800008b8:	00009517          	auipc	a0,0x9
    800008bc:	83050513          	addi	a0,a0,-2000 # 800090e8 <etext+0xe8>
    800008c0:	00006097          	auipc	ra,0x6
    800008c4:	2b0080e7          	jalr	688(ra) # 80006b70 <panic>

00000000800008c8 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800008c8:	1101                	addi	sp,sp,-32
    800008ca:	ec06                	sd	ra,24(sp)
    800008cc:	e822                	sd	s0,16(sp)
    800008ce:	e426                	sd	s1,8(sp)
    800008d0:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800008d2:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800008d4:	00b67d63          	bgeu	a2,a1,800008ee <uvmdealloc+0x26>
    800008d8:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800008da:	6785                	lui	a5,0x1
    800008dc:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008de:	00f60733          	add	a4,a2,a5
    800008e2:	76fd                	lui	a3,0xfffff
    800008e4:	8f75                	and	a4,a4,a3
    800008e6:	97ae                	add	a5,a5,a1
    800008e8:	8ff5                	and	a5,a5,a3
    800008ea:	00f76863          	bltu	a4,a5,800008fa <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800008ee:	8526                	mv	a0,s1
    800008f0:	60e2                	ld	ra,24(sp)
    800008f2:	6442                	ld	s0,16(sp)
    800008f4:	64a2                	ld	s1,8(sp)
    800008f6:	6105                	addi	sp,sp,32
    800008f8:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008fa:	8f99                	sub	a5,a5,a4
    800008fc:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008fe:	4685                	li	a3,1
    80000900:	0007861b          	sext.w	a2,a5
    80000904:	85ba                	mv	a1,a4
    80000906:	00000097          	auipc	ra,0x0
    8000090a:	e4a080e7          	jalr	-438(ra) # 80000750 <uvmunmap>
    8000090e:	b7c5                	j	800008ee <uvmdealloc+0x26>

0000000080000910 <uvmalloc>:
  if(newsz < oldsz)
    80000910:	0ab66163          	bltu	a2,a1,800009b2 <uvmalloc+0xa2>
{
    80000914:	7139                	addi	sp,sp,-64
    80000916:	fc06                	sd	ra,56(sp)
    80000918:	f822                	sd	s0,48(sp)
    8000091a:	f426                	sd	s1,40(sp)
    8000091c:	f04a                	sd	s2,32(sp)
    8000091e:	ec4e                	sd	s3,24(sp)
    80000920:	e852                	sd	s4,16(sp)
    80000922:	e456                	sd	s5,8(sp)
    80000924:	0080                	addi	s0,sp,64
    80000926:	8aaa                	mv	s5,a0
    80000928:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    8000092a:	6785                	lui	a5,0x1
    8000092c:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000092e:	95be                	add	a1,a1,a5
    80000930:	77fd                	lui	a5,0xfffff
    80000932:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000936:	08c9f063          	bgeu	s3,a2,800009b6 <uvmalloc+0xa6>
    8000093a:	894e                	mv	s2,s3
    mem = kalloc();
    8000093c:	fffff097          	auipc	ra,0xfffff
    80000940:	7de080e7          	jalr	2014(ra) # 8000011a <kalloc>
    80000944:	84aa                	mv	s1,a0
    if(mem == 0){
    80000946:	c51d                	beqz	a0,80000974 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80000948:	6605                	lui	a2,0x1
    8000094a:	4581                	li	a1,0
    8000094c:	00000097          	auipc	ra,0x0
    80000950:	82e080e7          	jalr	-2002(ra) # 8000017a <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80000954:	4779                	li	a4,30
    80000956:	86a6                	mv	a3,s1
    80000958:	6605                	lui	a2,0x1
    8000095a:	85ca                	mv	a1,s2
    8000095c:	8556                	mv	a0,s5
    8000095e:	00000097          	auipc	ra,0x0
    80000962:	bfc080e7          	jalr	-1028(ra) # 8000055a <mappages>
    80000966:	e905                	bnez	a0,80000996 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000968:	6785                	lui	a5,0x1
    8000096a:	993e                	add	s2,s2,a5
    8000096c:	fd4968e3          	bltu	s2,s4,8000093c <uvmalloc+0x2c>
  return newsz;
    80000970:	8552                	mv	a0,s4
    80000972:	a809                	j	80000984 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80000974:	864e                	mv	a2,s3
    80000976:	85ca                	mv	a1,s2
    80000978:	8556                	mv	a0,s5
    8000097a:	00000097          	auipc	ra,0x0
    8000097e:	f4e080e7          	jalr	-178(ra) # 800008c8 <uvmdealloc>
      return 0;
    80000982:	4501                	li	a0,0
}
    80000984:	70e2                	ld	ra,56(sp)
    80000986:	7442                	ld	s0,48(sp)
    80000988:	74a2                	ld	s1,40(sp)
    8000098a:	7902                	ld	s2,32(sp)
    8000098c:	69e2                	ld	s3,24(sp)
    8000098e:	6a42                	ld	s4,16(sp)
    80000990:	6aa2                	ld	s5,8(sp)
    80000992:	6121                	addi	sp,sp,64
    80000994:	8082                	ret
      kfree(mem);
    80000996:	8526                	mv	a0,s1
    80000998:	fffff097          	auipc	ra,0xfffff
    8000099c:	684080e7          	jalr	1668(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800009a0:	864e                	mv	a2,s3
    800009a2:	85ca                	mv	a1,s2
    800009a4:	8556                	mv	a0,s5
    800009a6:	00000097          	auipc	ra,0x0
    800009aa:	f22080e7          	jalr	-222(ra) # 800008c8 <uvmdealloc>
      return 0;
    800009ae:	4501                	li	a0,0
    800009b0:	bfd1                	j	80000984 <uvmalloc+0x74>
    return oldsz;
    800009b2:	852e                	mv	a0,a1
}
    800009b4:	8082                	ret
  return newsz;
    800009b6:	8532                	mv	a0,a2
    800009b8:	b7f1                	j	80000984 <uvmalloc+0x74>

00000000800009ba <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800009ba:	7179                	addi	sp,sp,-48
    800009bc:	f406                	sd	ra,40(sp)
    800009be:	f022                	sd	s0,32(sp)
    800009c0:	ec26                	sd	s1,24(sp)
    800009c2:	e84a                	sd	s2,16(sp)
    800009c4:	e44e                	sd	s3,8(sp)
    800009c6:	e052                	sd	s4,0(sp)
    800009c8:	1800                	addi	s0,sp,48
    800009ca:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800009cc:	84aa                	mv	s1,a0
    800009ce:	6905                	lui	s2,0x1
    800009d0:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009d2:	4985                	li	s3,1
    800009d4:	a829                	j	800009ee <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800009d6:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800009d8:	00c79513          	slli	a0,a5,0xc
    800009dc:	00000097          	auipc	ra,0x0
    800009e0:	fde080e7          	jalr	-34(ra) # 800009ba <freewalk>
      pagetable[i] = 0;
    800009e4:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800009e8:	04a1                	addi	s1,s1,8
    800009ea:	03248163          	beq	s1,s2,80000a0c <freewalk+0x52>
    pte_t pte = pagetable[i];
    800009ee:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009f0:	00f7f713          	andi	a4,a5,15
    800009f4:	ff3701e3          	beq	a4,s3,800009d6 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009f8:	8b85                	andi	a5,a5,1
    800009fa:	d7fd                	beqz	a5,800009e8 <freewalk+0x2e>
      panic("freewalk: leaf");
    800009fc:	00008517          	auipc	a0,0x8
    80000a00:	70c50513          	addi	a0,a0,1804 # 80009108 <etext+0x108>
    80000a04:	00006097          	auipc	ra,0x6
    80000a08:	16c080e7          	jalr	364(ra) # 80006b70 <panic>
    }
  }
  kfree((void*)pagetable);
    80000a0c:	8552                	mv	a0,s4
    80000a0e:	fffff097          	auipc	ra,0xfffff
    80000a12:	60e080e7          	jalr	1550(ra) # 8000001c <kfree>
}
    80000a16:	70a2                	ld	ra,40(sp)
    80000a18:	7402                	ld	s0,32(sp)
    80000a1a:	64e2                	ld	s1,24(sp)
    80000a1c:	6942                	ld	s2,16(sp)
    80000a1e:	69a2                	ld	s3,8(sp)
    80000a20:	6a02                	ld	s4,0(sp)
    80000a22:	6145                	addi	sp,sp,48
    80000a24:	8082                	ret

0000000080000a26 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000a26:	1101                	addi	sp,sp,-32
    80000a28:	ec06                	sd	ra,24(sp)
    80000a2a:	e822                	sd	s0,16(sp)
    80000a2c:	e426                	sd	s1,8(sp)
    80000a2e:	1000                	addi	s0,sp,32
    80000a30:	84aa                	mv	s1,a0
  if(sz > 0)
    80000a32:	e999                	bnez	a1,80000a48 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000a34:	8526                	mv	a0,s1
    80000a36:	00000097          	auipc	ra,0x0
    80000a3a:	f84080e7          	jalr	-124(ra) # 800009ba <freewalk>
}
    80000a3e:	60e2                	ld	ra,24(sp)
    80000a40:	6442                	ld	s0,16(sp)
    80000a42:	64a2                	ld	s1,8(sp)
    80000a44:	6105                	addi	sp,sp,32
    80000a46:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000a48:	6785                	lui	a5,0x1
    80000a4a:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000a4c:	95be                	add	a1,a1,a5
    80000a4e:	4685                	li	a3,1
    80000a50:	00c5d613          	srli	a2,a1,0xc
    80000a54:	4581                	li	a1,0
    80000a56:	00000097          	auipc	ra,0x0
    80000a5a:	cfa080e7          	jalr	-774(ra) # 80000750 <uvmunmap>
    80000a5e:	bfd9                	j	80000a34 <uvmfree+0xe>

0000000080000a60 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a60:	c679                	beqz	a2,80000b2e <uvmcopy+0xce>
{
    80000a62:	715d                	addi	sp,sp,-80
    80000a64:	e486                	sd	ra,72(sp)
    80000a66:	e0a2                	sd	s0,64(sp)
    80000a68:	fc26                	sd	s1,56(sp)
    80000a6a:	f84a                	sd	s2,48(sp)
    80000a6c:	f44e                	sd	s3,40(sp)
    80000a6e:	f052                	sd	s4,32(sp)
    80000a70:	ec56                	sd	s5,24(sp)
    80000a72:	e85a                	sd	s6,16(sp)
    80000a74:	e45e                	sd	s7,8(sp)
    80000a76:	0880                	addi	s0,sp,80
    80000a78:	8b2a                	mv	s6,a0
    80000a7a:	8aae                	mv	s5,a1
    80000a7c:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a7e:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a80:	4601                	li	a2,0
    80000a82:	85ce                	mv	a1,s3
    80000a84:	855a                	mv	a0,s6
    80000a86:	00000097          	auipc	ra,0x0
    80000a8a:	9ec080e7          	jalr	-1556(ra) # 80000472 <walk>
    80000a8e:	c531                	beqz	a0,80000ada <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a90:	6118                	ld	a4,0(a0)
    80000a92:	00177793          	andi	a5,a4,1
    80000a96:	cbb1                	beqz	a5,80000aea <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a98:	00a75593          	srli	a1,a4,0xa
    80000a9c:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000aa0:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000aa4:	fffff097          	auipc	ra,0xfffff
    80000aa8:	676080e7          	jalr	1654(ra) # 8000011a <kalloc>
    80000aac:	892a                	mv	s2,a0
    80000aae:	c939                	beqz	a0,80000b04 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000ab0:	6605                	lui	a2,0x1
    80000ab2:	85de                	mv	a1,s7
    80000ab4:	fffff097          	auipc	ra,0xfffff
    80000ab8:	722080e7          	jalr	1826(ra) # 800001d6 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000abc:	8726                	mv	a4,s1
    80000abe:	86ca                	mv	a3,s2
    80000ac0:	6605                	lui	a2,0x1
    80000ac2:	85ce                	mv	a1,s3
    80000ac4:	8556                	mv	a0,s5
    80000ac6:	00000097          	auipc	ra,0x0
    80000aca:	a94080e7          	jalr	-1388(ra) # 8000055a <mappages>
    80000ace:	e515                	bnez	a0,80000afa <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000ad0:	6785                	lui	a5,0x1
    80000ad2:	99be                	add	s3,s3,a5
    80000ad4:	fb49e6e3          	bltu	s3,s4,80000a80 <uvmcopy+0x20>
    80000ad8:	a081                	j	80000b18 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000ada:	00008517          	auipc	a0,0x8
    80000ade:	63e50513          	addi	a0,a0,1598 # 80009118 <etext+0x118>
    80000ae2:	00006097          	auipc	ra,0x6
    80000ae6:	08e080e7          	jalr	142(ra) # 80006b70 <panic>
      panic("uvmcopy: page not present");
    80000aea:	00008517          	auipc	a0,0x8
    80000aee:	64e50513          	addi	a0,a0,1614 # 80009138 <etext+0x138>
    80000af2:	00006097          	auipc	ra,0x6
    80000af6:	07e080e7          	jalr	126(ra) # 80006b70 <panic>
      kfree(mem);
    80000afa:	854a                	mv	a0,s2
    80000afc:	fffff097          	auipc	ra,0xfffff
    80000b00:	520080e7          	jalr	1312(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000b04:	4685                	li	a3,1
    80000b06:	00c9d613          	srli	a2,s3,0xc
    80000b0a:	4581                	li	a1,0
    80000b0c:	8556                	mv	a0,s5
    80000b0e:	00000097          	auipc	ra,0x0
    80000b12:	c42080e7          	jalr	-958(ra) # 80000750 <uvmunmap>
  return -1;
    80000b16:	557d                	li	a0,-1
}
    80000b18:	60a6                	ld	ra,72(sp)
    80000b1a:	6406                	ld	s0,64(sp)
    80000b1c:	74e2                	ld	s1,56(sp)
    80000b1e:	7942                	ld	s2,48(sp)
    80000b20:	79a2                	ld	s3,40(sp)
    80000b22:	7a02                	ld	s4,32(sp)
    80000b24:	6ae2                	ld	s5,24(sp)
    80000b26:	6b42                	ld	s6,16(sp)
    80000b28:	6ba2                	ld	s7,8(sp)
    80000b2a:	6161                	addi	sp,sp,80
    80000b2c:	8082                	ret
  return 0;
    80000b2e:	4501                	li	a0,0
}
    80000b30:	8082                	ret

0000000080000b32 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000b32:	1141                	addi	sp,sp,-16
    80000b34:	e406                	sd	ra,8(sp)
    80000b36:	e022                	sd	s0,0(sp)
    80000b38:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000b3a:	4601                	li	a2,0
    80000b3c:	00000097          	auipc	ra,0x0
    80000b40:	936080e7          	jalr	-1738(ra) # 80000472 <walk>
  if(pte == 0)
    80000b44:	c901                	beqz	a0,80000b54 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b46:	611c                	ld	a5,0(a0)
    80000b48:	9bbd                	andi	a5,a5,-17
    80000b4a:	e11c                	sd	a5,0(a0)
}
    80000b4c:	60a2                	ld	ra,8(sp)
    80000b4e:	6402                	ld	s0,0(sp)
    80000b50:	0141                	addi	sp,sp,16
    80000b52:	8082                	ret
    panic("uvmclear");
    80000b54:	00008517          	auipc	a0,0x8
    80000b58:	60450513          	addi	a0,a0,1540 # 80009158 <etext+0x158>
    80000b5c:	00006097          	auipc	ra,0x6
    80000b60:	014080e7          	jalr	20(ra) # 80006b70 <panic>

0000000080000b64 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b64:	c6bd                	beqz	a3,80000bd2 <copyout+0x6e>
{
    80000b66:	715d                	addi	sp,sp,-80
    80000b68:	e486                	sd	ra,72(sp)
    80000b6a:	e0a2                	sd	s0,64(sp)
    80000b6c:	fc26                	sd	s1,56(sp)
    80000b6e:	f84a                	sd	s2,48(sp)
    80000b70:	f44e                	sd	s3,40(sp)
    80000b72:	f052                	sd	s4,32(sp)
    80000b74:	ec56                	sd	s5,24(sp)
    80000b76:	e85a                	sd	s6,16(sp)
    80000b78:	e45e                	sd	s7,8(sp)
    80000b7a:	e062                	sd	s8,0(sp)
    80000b7c:	0880                	addi	s0,sp,80
    80000b7e:	8b2a                	mv	s6,a0
    80000b80:	8c2e                	mv	s8,a1
    80000b82:	8a32                	mv	s4,a2
    80000b84:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b86:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b88:	6a85                	lui	s5,0x1
    80000b8a:	a015                	j	80000bae <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b8c:	9562                	add	a0,a0,s8
    80000b8e:	0004861b          	sext.w	a2,s1
    80000b92:	85d2                	mv	a1,s4
    80000b94:	41250533          	sub	a0,a0,s2
    80000b98:	fffff097          	auipc	ra,0xfffff
    80000b9c:	63e080e7          	jalr	1598(ra) # 800001d6 <memmove>

    len -= n;
    80000ba0:	409989b3          	sub	s3,s3,s1
    src += n;
    80000ba4:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000ba6:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000baa:	02098263          	beqz	s3,80000bce <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000bae:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bb2:	85ca                	mv	a1,s2
    80000bb4:	855a                	mv	a0,s6
    80000bb6:	00000097          	auipc	ra,0x0
    80000bba:	962080e7          	jalr	-1694(ra) # 80000518 <walkaddr>
    if(pa0 == 0)
    80000bbe:	cd01                	beqz	a0,80000bd6 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000bc0:	418904b3          	sub	s1,s2,s8
    80000bc4:	94d6                	add	s1,s1,s5
    80000bc6:	fc99f3e3          	bgeu	s3,s1,80000b8c <copyout+0x28>
    80000bca:	84ce                	mv	s1,s3
    80000bcc:	b7c1                	j	80000b8c <copyout+0x28>
  }
  return 0;
    80000bce:	4501                	li	a0,0
    80000bd0:	a021                	j	80000bd8 <copyout+0x74>
    80000bd2:	4501                	li	a0,0
}
    80000bd4:	8082                	ret
      return -1;
    80000bd6:	557d                	li	a0,-1
}
    80000bd8:	60a6                	ld	ra,72(sp)
    80000bda:	6406                	ld	s0,64(sp)
    80000bdc:	74e2                	ld	s1,56(sp)
    80000bde:	7942                	ld	s2,48(sp)
    80000be0:	79a2                	ld	s3,40(sp)
    80000be2:	7a02                	ld	s4,32(sp)
    80000be4:	6ae2                	ld	s5,24(sp)
    80000be6:	6b42                	ld	s6,16(sp)
    80000be8:	6ba2                	ld	s7,8(sp)
    80000bea:	6c02                	ld	s8,0(sp)
    80000bec:	6161                	addi	sp,sp,80
    80000bee:	8082                	ret

0000000080000bf0 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;
  
  while(len > 0){
    80000bf0:	caa5                	beqz	a3,80000c60 <copyin+0x70>
{
    80000bf2:	715d                	addi	sp,sp,-80
    80000bf4:	e486                	sd	ra,72(sp)
    80000bf6:	e0a2                	sd	s0,64(sp)
    80000bf8:	fc26                	sd	s1,56(sp)
    80000bfa:	f84a                	sd	s2,48(sp)
    80000bfc:	f44e                	sd	s3,40(sp)
    80000bfe:	f052                	sd	s4,32(sp)
    80000c00:	ec56                	sd	s5,24(sp)
    80000c02:	e85a                	sd	s6,16(sp)
    80000c04:	e45e                	sd	s7,8(sp)
    80000c06:	e062                	sd	s8,0(sp)
    80000c08:	0880                	addi	s0,sp,80
    80000c0a:	8b2a                	mv	s6,a0
    80000c0c:	8a2e                	mv	s4,a1
    80000c0e:	8c32                	mv	s8,a2
    80000c10:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000c12:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c14:	6a85                	lui	s5,0x1
    80000c16:	a01d                	j	80000c3c <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c18:	018505b3          	add	a1,a0,s8
    80000c1c:	0004861b          	sext.w	a2,s1
    80000c20:	412585b3          	sub	a1,a1,s2
    80000c24:	8552                	mv	a0,s4
    80000c26:	fffff097          	auipc	ra,0xfffff
    80000c2a:	5b0080e7          	jalr	1456(ra) # 800001d6 <memmove>

    len -= n;
    80000c2e:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000c32:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000c34:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c38:	02098263          	beqz	s3,80000c5c <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000c3c:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c40:	85ca                	mv	a1,s2
    80000c42:	855a                	mv	a0,s6
    80000c44:	00000097          	auipc	ra,0x0
    80000c48:	8d4080e7          	jalr	-1836(ra) # 80000518 <walkaddr>
    if(pa0 == 0)
    80000c4c:	cd01                	beqz	a0,80000c64 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000c4e:	418904b3          	sub	s1,s2,s8
    80000c52:	94d6                	add	s1,s1,s5
    80000c54:	fc99f2e3          	bgeu	s3,s1,80000c18 <copyin+0x28>
    80000c58:	84ce                	mv	s1,s3
    80000c5a:	bf7d                	j	80000c18 <copyin+0x28>
  }
  return 0;
    80000c5c:	4501                	li	a0,0
    80000c5e:	a021                	j	80000c66 <copyin+0x76>
    80000c60:	4501                	li	a0,0
}
    80000c62:	8082                	ret
      return -1;
    80000c64:	557d                	li	a0,-1
}
    80000c66:	60a6                	ld	ra,72(sp)
    80000c68:	6406                	ld	s0,64(sp)
    80000c6a:	74e2                	ld	s1,56(sp)
    80000c6c:	7942                	ld	s2,48(sp)
    80000c6e:	79a2                	ld	s3,40(sp)
    80000c70:	7a02                	ld	s4,32(sp)
    80000c72:	6ae2                	ld	s5,24(sp)
    80000c74:	6b42                	ld	s6,16(sp)
    80000c76:	6ba2                	ld	s7,8(sp)
    80000c78:	6c02                	ld	s8,0(sp)
    80000c7a:	6161                	addi	sp,sp,80
    80000c7c:	8082                	ret

0000000080000c7e <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c7e:	c2dd                	beqz	a3,80000d24 <copyinstr+0xa6>
{
    80000c80:	715d                	addi	sp,sp,-80
    80000c82:	e486                	sd	ra,72(sp)
    80000c84:	e0a2                	sd	s0,64(sp)
    80000c86:	fc26                	sd	s1,56(sp)
    80000c88:	f84a                	sd	s2,48(sp)
    80000c8a:	f44e                	sd	s3,40(sp)
    80000c8c:	f052                	sd	s4,32(sp)
    80000c8e:	ec56                	sd	s5,24(sp)
    80000c90:	e85a                	sd	s6,16(sp)
    80000c92:	e45e                	sd	s7,8(sp)
    80000c94:	0880                	addi	s0,sp,80
    80000c96:	8a2a                	mv	s4,a0
    80000c98:	8b2e                	mv	s6,a1
    80000c9a:	8bb2                	mv	s7,a2
    80000c9c:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c9e:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000ca0:	6985                	lui	s3,0x1
    80000ca2:	a02d                	j	80000ccc <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000ca4:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000ca8:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000caa:	37fd                	addiw	a5,a5,-1
    80000cac:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000cb0:	60a6                	ld	ra,72(sp)
    80000cb2:	6406                	ld	s0,64(sp)
    80000cb4:	74e2                	ld	s1,56(sp)
    80000cb6:	7942                	ld	s2,48(sp)
    80000cb8:	79a2                	ld	s3,40(sp)
    80000cba:	7a02                	ld	s4,32(sp)
    80000cbc:	6ae2                	ld	s5,24(sp)
    80000cbe:	6b42                	ld	s6,16(sp)
    80000cc0:	6ba2                	ld	s7,8(sp)
    80000cc2:	6161                	addi	sp,sp,80
    80000cc4:	8082                	ret
    srcva = va0 + PGSIZE;
    80000cc6:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000cca:	c8a9                	beqz	s1,80000d1c <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80000ccc:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000cd0:	85ca                	mv	a1,s2
    80000cd2:	8552                	mv	a0,s4
    80000cd4:	00000097          	auipc	ra,0x0
    80000cd8:	844080e7          	jalr	-1980(ra) # 80000518 <walkaddr>
    if(pa0 == 0)
    80000cdc:	c131                	beqz	a0,80000d20 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000cde:	417906b3          	sub	a3,s2,s7
    80000ce2:	96ce                	add	a3,a3,s3
    80000ce4:	00d4f363          	bgeu	s1,a3,80000cea <copyinstr+0x6c>
    80000ce8:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000cea:	955e                	add	a0,a0,s7
    80000cec:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000cf0:	daf9                	beqz	a3,80000cc6 <copyinstr+0x48>
    80000cf2:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000cf4:	41650633          	sub	a2,a0,s6
    80000cf8:	fff48593          	addi	a1,s1,-1
    80000cfc:	95da                	add	a1,a1,s6
    while(n > 0){
    80000cfe:	96da                	add	a3,a3,s6
      if(*p == '\0'){
    80000d00:	00f60733          	add	a4,a2,a5
    80000d04:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd7a80>
    80000d08:	df51                	beqz	a4,80000ca4 <copyinstr+0x26>
        *dst = *p;
    80000d0a:	00e78023          	sb	a4,0(a5)
      --max;
    80000d0e:	40f584b3          	sub	s1,a1,a5
      dst++;
    80000d12:	0785                	addi	a5,a5,1
    while(n > 0){
    80000d14:	fed796e3          	bne	a5,a3,80000d00 <copyinstr+0x82>
      dst++;
    80000d18:	8b3e                	mv	s6,a5
    80000d1a:	b775                	j	80000cc6 <copyinstr+0x48>
    80000d1c:	4781                	li	a5,0
    80000d1e:	b771                	j	80000caa <copyinstr+0x2c>
      return -1;
    80000d20:	557d                	li	a0,-1
    80000d22:	b779                	j	80000cb0 <copyinstr+0x32>
  int got_null = 0;
    80000d24:	4781                	li	a5,0
  if(got_null){
    80000d26:	37fd                	addiw	a5,a5,-1
    80000d28:	0007851b          	sext.w	a0,a5
}
    80000d2c:	8082                	ret

0000000080000d2e <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000d2e:	7139                	addi	sp,sp,-64
    80000d30:	fc06                	sd	ra,56(sp)
    80000d32:	f822                	sd	s0,48(sp)
    80000d34:	f426                	sd	s1,40(sp)
    80000d36:	f04a                	sd	s2,32(sp)
    80000d38:	ec4e                	sd	s3,24(sp)
    80000d3a:	e852                	sd	s4,16(sp)
    80000d3c:	e456                	sd	s5,8(sp)
    80000d3e:	e05a                	sd	s6,0(sp)
    80000d40:	0080                	addi	s0,sp,64
    80000d42:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d44:	00009497          	auipc	s1,0x9
    80000d48:	75c48493          	addi	s1,s1,1884 # 8000a4a0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d4c:	8b26                	mv	s6,s1
    80000d4e:	00008a97          	auipc	s5,0x8
    80000d52:	2b2a8a93          	addi	s5,s5,690 # 80009000 <etext>
    80000d56:	01000937          	lui	s2,0x1000
    80000d5a:	197d                	addi	s2,s2,-1 # ffffff <_entry-0x7f000001>
    80000d5c:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d5e:	0000fa17          	auipc	s4,0xf
    80000d62:	142a0a13          	addi	s4,s4,322 # 8000fea0 <tickslock>
    char *pa = kalloc();
    80000d66:	fffff097          	auipc	ra,0xfffff
    80000d6a:	3b4080e7          	jalr	948(ra) # 8000011a <kalloc>
    80000d6e:	862a                	mv	a2,a0
    if(pa == 0)
    80000d70:	c129                	beqz	a0,80000db2 <proc_mapstacks+0x84>
    uint64 va = KSTACK((int) (p - proc));
    80000d72:	416485b3          	sub	a1,s1,s6
    80000d76:	858d                	srai	a1,a1,0x3
    80000d78:	000ab783          	ld	a5,0(s5)
    80000d7c:	02f585b3          	mul	a1,a1,a5
    80000d80:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d84:	4719                	li	a4,6
    80000d86:	6685                	lui	a3,0x1
    80000d88:	40b905b3          	sub	a1,s2,a1
    80000d8c:	854e                	mv	a0,s3
    80000d8e:	00000097          	auipc	ra,0x0
    80000d92:	86c080e7          	jalr	-1940(ra) # 800005fa <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d96:	16848493          	addi	s1,s1,360
    80000d9a:	fd4496e3          	bne	s1,s4,80000d66 <proc_mapstacks+0x38>
  }
}
    80000d9e:	70e2                	ld	ra,56(sp)
    80000da0:	7442                	ld	s0,48(sp)
    80000da2:	74a2                	ld	s1,40(sp)
    80000da4:	7902                	ld	s2,32(sp)
    80000da6:	69e2                	ld	s3,24(sp)
    80000da8:	6a42                	ld	s4,16(sp)
    80000daa:	6aa2                	ld	s5,8(sp)
    80000dac:	6b02                	ld	s6,0(sp)
    80000dae:	6121                	addi	sp,sp,64
    80000db0:	8082                	ret
      panic("kalloc");
    80000db2:	00008517          	auipc	a0,0x8
    80000db6:	3b650513          	addi	a0,a0,950 # 80009168 <etext+0x168>
    80000dba:	00006097          	auipc	ra,0x6
    80000dbe:	db6080e7          	jalr	-586(ra) # 80006b70 <panic>

0000000080000dc2 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000dc2:	7139                	addi	sp,sp,-64
    80000dc4:	fc06                	sd	ra,56(sp)
    80000dc6:	f822                	sd	s0,48(sp)
    80000dc8:	f426                	sd	s1,40(sp)
    80000dca:	f04a                	sd	s2,32(sp)
    80000dcc:	ec4e                	sd	s3,24(sp)
    80000dce:	e852                	sd	s4,16(sp)
    80000dd0:	e456                	sd	s5,8(sp)
    80000dd2:	e05a                	sd	s6,0(sp)
    80000dd4:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000dd6:	00008597          	auipc	a1,0x8
    80000dda:	39a58593          	addi	a1,a1,922 # 80009170 <etext+0x170>
    80000dde:	00009517          	auipc	a0,0x9
    80000de2:	29250513          	addi	a0,a0,658 # 8000a070 <pid_lock>
    80000de6:	00006097          	auipc	ra,0x6
    80000dea:	232080e7          	jalr	562(ra) # 80007018 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000dee:	00008597          	auipc	a1,0x8
    80000df2:	38a58593          	addi	a1,a1,906 # 80009178 <etext+0x178>
    80000df6:	00009517          	auipc	a0,0x9
    80000dfa:	29250513          	addi	a0,a0,658 # 8000a088 <wait_lock>
    80000dfe:	00006097          	auipc	ra,0x6
    80000e02:	21a080e7          	jalr	538(ra) # 80007018 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e06:	00009497          	auipc	s1,0x9
    80000e0a:	69a48493          	addi	s1,s1,1690 # 8000a4a0 <proc>
      initlock(&p->lock, "proc");
    80000e0e:	00008b17          	auipc	s6,0x8
    80000e12:	37ab0b13          	addi	s6,s6,890 # 80009188 <etext+0x188>
      p->kstack = KSTACK((int) (p - proc));
    80000e16:	8aa6                	mv	s5,s1
    80000e18:	00008a17          	auipc	s4,0x8
    80000e1c:	1e8a0a13          	addi	s4,s4,488 # 80009000 <etext>
    80000e20:	01000937          	lui	s2,0x1000
    80000e24:	197d                	addi	s2,s2,-1 # ffffff <_entry-0x7f000001>
    80000e26:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e28:	0000f997          	auipc	s3,0xf
    80000e2c:	07898993          	addi	s3,s3,120 # 8000fea0 <tickslock>
      initlock(&p->lock, "proc");
    80000e30:	85da                	mv	a1,s6
    80000e32:	8526                	mv	a0,s1
    80000e34:	00006097          	auipc	ra,0x6
    80000e38:	1e4080e7          	jalr	484(ra) # 80007018 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000e3c:	415487b3          	sub	a5,s1,s5
    80000e40:	878d                	srai	a5,a5,0x3
    80000e42:	000a3703          	ld	a4,0(s4)
    80000e46:	02e787b3          	mul	a5,a5,a4
    80000e4a:	00d7979b          	slliw	a5,a5,0xd
    80000e4e:	40f907b3          	sub	a5,s2,a5
    80000e52:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e54:	16848493          	addi	s1,s1,360
    80000e58:	fd349ce3          	bne	s1,s3,80000e30 <procinit+0x6e>
  }
}
    80000e5c:	70e2                	ld	ra,56(sp)
    80000e5e:	7442                	ld	s0,48(sp)
    80000e60:	74a2                	ld	s1,40(sp)
    80000e62:	7902                	ld	s2,32(sp)
    80000e64:	69e2                	ld	s3,24(sp)
    80000e66:	6a42                	ld	s4,16(sp)
    80000e68:	6aa2                	ld	s5,8(sp)
    80000e6a:	6b02                	ld	s6,0(sp)
    80000e6c:	6121                	addi	sp,sp,64
    80000e6e:	8082                	ret

0000000080000e70 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e70:	1141                	addi	sp,sp,-16
    80000e72:	e422                	sd	s0,8(sp)
    80000e74:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e76:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e78:	2501                	sext.w	a0,a0
    80000e7a:	6422                	ld	s0,8(sp)
    80000e7c:	0141                	addi	sp,sp,16
    80000e7e:	8082                	ret

0000000080000e80 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e80:	1141                	addi	sp,sp,-16
    80000e82:	e422                	sd	s0,8(sp)
    80000e84:	0800                	addi	s0,sp,16
    80000e86:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e88:	2781                	sext.w	a5,a5
    80000e8a:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e8c:	00009517          	auipc	a0,0x9
    80000e90:	21450513          	addi	a0,a0,532 # 8000a0a0 <cpus>
    80000e94:	953e                	add	a0,a0,a5
    80000e96:	6422                	ld	s0,8(sp)
    80000e98:	0141                	addi	sp,sp,16
    80000e9a:	8082                	ret

0000000080000e9c <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000e9c:	1101                	addi	sp,sp,-32
    80000e9e:	ec06                	sd	ra,24(sp)
    80000ea0:	e822                	sd	s0,16(sp)
    80000ea2:	e426                	sd	s1,8(sp)
    80000ea4:	1000                	addi	s0,sp,32
  push_off();
    80000ea6:	00006097          	auipc	ra,0x6
    80000eaa:	1b6080e7          	jalr	438(ra) # 8000705c <push_off>
    80000eae:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000eb0:	2781                	sext.w	a5,a5
    80000eb2:	079e                	slli	a5,a5,0x7
    80000eb4:	00009717          	auipc	a4,0x9
    80000eb8:	1bc70713          	addi	a4,a4,444 # 8000a070 <pid_lock>
    80000ebc:	97ba                	add	a5,a5,a4
    80000ebe:	7b84                	ld	s1,48(a5)
  pop_off();
    80000ec0:	00006097          	auipc	ra,0x6
    80000ec4:	23c080e7          	jalr	572(ra) # 800070fc <pop_off>
  return p;
}
    80000ec8:	8526                	mv	a0,s1
    80000eca:	60e2                	ld	ra,24(sp)
    80000ecc:	6442                	ld	s0,16(sp)
    80000ece:	64a2                	ld	s1,8(sp)
    80000ed0:	6105                	addi	sp,sp,32
    80000ed2:	8082                	ret

0000000080000ed4 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000ed4:	1141                	addi	sp,sp,-16
    80000ed6:	e406                	sd	ra,8(sp)
    80000ed8:	e022                	sd	s0,0(sp)
    80000eda:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000edc:	00000097          	auipc	ra,0x0
    80000ee0:	fc0080e7          	jalr	-64(ra) # 80000e9c <myproc>
    80000ee4:	00006097          	auipc	ra,0x6
    80000ee8:	278080e7          	jalr	632(ra) # 8000715c <release>

  if (first) {
    80000eec:	00009797          	auipc	a5,0x9
    80000ef0:	9a47a783          	lw	a5,-1628(a5) # 80009890 <first.1>
    80000ef4:	eb89                	bnez	a5,80000f06 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000ef6:	00001097          	auipc	ra,0x1
    80000efa:	c14080e7          	jalr	-1004(ra) # 80001b0a <usertrapret>
}
    80000efe:	60a2                	ld	ra,8(sp)
    80000f00:	6402                	ld	s0,0(sp)
    80000f02:	0141                	addi	sp,sp,16
    80000f04:	8082                	ret
    first = 0;
    80000f06:	00009797          	auipc	a5,0x9
    80000f0a:	9807a523          	sw	zero,-1654(a5) # 80009890 <first.1>
    fsinit(ROOTDEV);
    80000f0e:	4505                	li	a0,1
    80000f10:	00002097          	auipc	ra,0x2
    80000f14:	96a080e7          	jalr	-1686(ra) # 8000287a <fsinit>
    80000f18:	bff9                	j	80000ef6 <forkret+0x22>

0000000080000f1a <allocpid>:
allocpid() {
    80000f1a:	1101                	addi	sp,sp,-32
    80000f1c:	ec06                	sd	ra,24(sp)
    80000f1e:	e822                	sd	s0,16(sp)
    80000f20:	e426                	sd	s1,8(sp)
    80000f22:	e04a                	sd	s2,0(sp)
    80000f24:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000f26:	00009917          	auipc	s2,0x9
    80000f2a:	14a90913          	addi	s2,s2,330 # 8000a070 <pid_lock>
    80000f2e:	854a                	mv	a0,s2
    80000f30:	00006097          	auipc	ra,0x6
    80000f34:	178080e7          	jalr	376(ra) # 800070a8 <acquire>
  pid = nextpid;
    80000f38:	00009797          	auipc	a5,0x9
    80000f3c:	95c78793          	addi	a5,a5,-1700 # 80009894 <nextpid>
    80000f40:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f42:	0014871b          	addiw	a4,s1,1
    80000f46:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f48:	854a                	mv	a0,s2
    80000f4a:	00006097          	auipc	ra,0x6
    80000f4e:	212080e7          	jalr	530(ra) # 8000715c <release>
}
    80000f52:	8526                	mv	a0,s1
    80000f54:	60e2                	ld	ra,24(sp)
    80000f56:	6442                	ld	s0,16(sp)
    80000f58:	64a2                	ld	s1,8(sp)
    80000f5a:	6902                	ld	s2,0(sp)
    80000f5c:	6105                	addi	sp,sp,32
    80000f5e:	8082                	ret

0000000080000f60 <proc_pagetable>:
{
    80000f60:	1101                	addi	sp,sp,-32
    80000f62:	ec06                	sd	ra,24(sp)
    80000f64:	e822                	sd	s0,16(sp)
    80000f66:	e426                	sd	s1,8(sp)
    80000f68:	e04a                	sd	s2,0(sp)
    80000f6a:	1000                	addi	s0,sp,32
    80000f6c:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f6e:	00000097          	auipc	ra,0x0
    80000f72:	8ba080e7          	jalr	-1862(ra) # 80000828 <uvmcreate>
    80000f76:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f78:	c121                	beqz	a0,80000fb8 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f7a:	4729                	li	a4,10
    80000f7c:	00007697          	auipc	a3,0x7
    80000f80:	08468693          	addi	a3,a3,132 # 80008000 <_trampoline>
    80000f84:	6605                	lui	a2,0x1
    80000f86:	040005b7          	lui	a1,0x4000
    80000f8a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f8c:	05b2                	slli	a1,a1,0xc
    80000f8e:	fffff097          	auipc	ra,0xfffff
    80000f92:	5cc080e7          	jalr	1484(ra) # 8000055a <mappages>
    80000f96:	02054863          	bltz	a0,80000fc6 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f9a:	4719                	li	a4,6
    80000f9c:	05893683          	ld	a3,88(s2)
    80000fa0:	6605                	lui	a2,0x1
    80000fa2:	020005b7          	lui	a1,0x2000
    80000fa6:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000fa8:	05b6                	slli	a1,a1,0xd
    80000faa:	8526                	mv	a0,s1
    80000fac:	fffff097          	auipc	ra,0xfffff
    80000fb0:	5ae080e7          	jalr	1454(ra) # 8000055a <mappages>
    80000fb4:	02054163          	bltz	a0,80000fd6 <proc_pagetable+0x76>
}
    80000fb8:	8526                	mv	a0,s1
    80000fba:	60e2                	ld	ra,24(sp)
    80000fbc:	6442                	ld	s0,16(sp)
    80000fbe:	64a2                	ld	s1,8(sp)
    80000fc0:	6902                	ld	s2,0(sp)
    80000fc2:	6105                	addi	sp,sp,32
    80000fc4:	8082                	ret
    uvmfree(pagetable, 0);
    80000fc6:	4581                	li	a1,0
    80000fc8:	8526                	mv	a0,s1
    80000fca:	00000097          	auipc	ra,0x0
    80000fce:	a5c080e7          	jalr	-1444(ra) # 80000a26 <uvmfree>
    return 0;
    80000fd2:	4481                	li	s1,0
    80000fd4:	b7d5                	j	80000fb8 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fd6:	4681                	li	a3,0
    80000fd8:	4605                	li	a2,1
    80000fda:	040005b7          	lui	a1,0x4000
    80000fde:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fe0:	05b2                	slli	a1,a1,0xc
    80000fe2:	8526                	mv	a0,s1
    80000fe4:	fffff097          	auipc	ra,0xfffff
    80000fe8:	76c080e7          	jalr	1900(ra) # 80000750 <uvmunmap>
    uvmfree(pagetable, 0);
    80000fec:	4581                	li	a1,0
    80000fee:	8526                	mv	a0,s1
    80000ff0:	00000097          	auipc	ra,0x0
    80000ff4:	a36080e7          	jalr	-1482(ra) # 80000a26 <uvmfree>
    return 0;
    80000ff8:	4481                	li	s1,0
    80000ffa:	bf7d                	j	80000fb8 <proc_pagetable+0x58>

0000000080000ffc <proc_freepagetable>:
{
    80000ffc:	1101                	addi	sp,sp,-32
    80000ffe:	ec06                	sd	ra,24(sp)
    80001000:	e822                	sd	s0,16(sp)
    80001002:	e426                	sd	s1,8(sp)
    80001004:	e04a                	sd	s2,0(sp)
    80001006:	1000                	addi	s0,sp,32
    80001008:	84aa                	mv	s1,a0
    8000100a:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000100c:	4681                	li	a3,0
    8000100e:	4605                	li	a2,1
    80001010:	040005b7          	lui	a1,0x4000
    80001014:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001016:	05b2                	slli	a1,a1,0xc
    80001018:	fffff097          	auipc	ra,0xfffff
    8000101c:	738080e7          	jalr	1848(ra) # 80000750 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001020:	4681                	li	a3,0
    80001022:	4605                	li	a2,1
    80001024:	020005b7          	lui	a1,0x2000
    80001028:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    8000102a:	05b6                	slli	a1,a1,0xd
    8000102c:	8526                	mv	a0,s1
    8000102e:	fffff097          	auipc	ra,0xfffff
    80001032:	722080e7          	jalr	1826(ra) # 80000750 <uvmunmap>
  uvmfree(pagetable, sz);
    80001036:	85ca                	mv	a1,s2
    80001038:	8526                	mv	a0,s1
    8000103a:	00000097          	auipc	ra,0x0
    8000103e:	9ec080e7          	jalr	-1556(ra) # 80000a26 <uvmfree>
}
    80001042:	60e2                	ld	ra,24(sp)
    80001044:	6442                	ld	s0,16(sp)
    80001046:	64a2                	ld	s1,8(sp)
    80001048:	6902                	ld	s2,0(sp)
    8000104a:	6105                	addi	sp,sp,32
    8000104c:	8082                	ret

000000008000104e <freeproc>:
{
    8000104e:	1101                	addi	sp,sp,-32
    80001050:	ec06                	sd	ra,24(sp)
    80001052:	e822                	sd	s0,16(sp)
    80001054:	e426                	sd	s1,8(sp)
    80001056:	1000                	addi	s0,sp,32
    80001058:	84aa                	mv	s1,a0
  if(p->trapframe)
    8000105a:	6d28                	ld	a0,88(a0)
    8000105c:	c509                	beqz	a0,80001066 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000105e:	fffff097          	auipc	ra,0xfffff
    80001062:	fbe080e7          	jalr	-66(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001066:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    8000106a:	68a8                	ld	a0,80(s1)
    8000106c:	c511                	beqz	a0,80001078 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    8000106e:	64ac                	ld	a1,72(s1)
    80001070:	00000097          	auipc	ra,0x0
    80001074:	f8c080e7          	jalr	-116(ra) # 80000ffc <proc_freepagetable>
  p->pagetable = 0;
    80001078:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    8000107c:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001080:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001084:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001088:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    8000108c:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001090:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001094:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001098:	0004ac23          	sw	zero,24(s1)
}
    8000109c:	60e2                	ld	ra,24(sp)
    8000109e:	6442                	ld	s0,16(sp)
    800010a0:	64a2                	ld	s1,8(sp)
    800010a2:	6105                	addi	sp,sp,32
    800010a4:	8082                	ret

00000000800010a6 <allocproc>:
{
    800010a6:	1101                	addi	sp,sp,-32
    800010a8:	ec06                	sd	ra,24(sp)
    800010aa:	e822                	sd	s0,16(sp)
    800010ac:	e426                	sd	s1,8(sp)
    800010ae:	e04a                	sd	s2,0(sp)
    800010b0:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800010b2:	00009497          	auipc	s1,0x9
    800010b6:	3ee48493          	addi	s1,s1,1006 # 8000a4a0 <proc>
    800010ba:	0000f917          	auipc	s2,0xf
    800010be:	de690913          	addi	s2,s2,-538 # 8000fea0 <tickslock>
    acquire(&p->lock);
    800010c2:	8526                	mv	a0,s1
    800010c4:	00006097          	auipc	ra,0x6
    800010c8:	fe4080e7          	jalr	-28(ra) # 800070a8 <acquire>
    if(p->state == UNUSED) {
    800010cc:	4c9c                	lw	a5,24(s1)
    800010ce:	cf81                	beqz	a5,800010e6 <allocproc+0x40>
      release(&p->lock);
    800010d0:	8526                	mv	a0,s1
    800010d2:	00006097          	auipc	ra,0x6
    800010d6:	08a080e7          	jalr	138(ra) # 8000715c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800010da:	16848493          	addi	s1,s1,360
    800010de:	ff2492e3          	bne	s1,s2,800010c2 <allocproc+0x1c>
  return 0;
    800010e2:	4481                	li	s1,0
    800010e4:	a889                	j	80001136 <allocproc+0x90>
  p->pid = allocpid();
    800010e6:	00000097          	auipc	ra,0x0
    800010ea:	e34080e7          	jalr	-460(ra) # 80000f1a <allocpid>
    800010ee:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010f0:	4785                	li	a5,1
    800010f2:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010f4:	fffff097          	auipc	ra,0xfffff
    800010f8:	026080e7          	jalr	38(ra) # 8000011a <kalloc>
    800010fc:	892a                	mv	s2,a0
    800010fe:	eca8                	sd	a0,88(s1)
    80001100:	c131                	beqz	a0,80001144 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001102:	8526                	mv	a0,s1
    80001104:	00000097          	auipc	ra,0x0
    80001108:	e5c080e7          	jalr	-420(ra) # 80000f60 <proc_pagetable>
    8000110c:	892a                	mv	s2,a0
    8000110e:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001110:	c531                	beqz	a0,8000115c <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001112:	07000613          	li	a2,112
    80001116:	4581                	li	a1,0
    80001118:	06048513          	addi	a0,s1,96
    8000111c:	fffff097          	auipc	ra,0xfffff
    80001120:	05e080e7          	jalr	94(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    80001124:	00000797          	auipc	a5,0x0
    80001128:	db078793          	addi	a5,a5,-592 # 80000ed4 <forkret>
    8000112c:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    8000112e:	60bc                	ld	a5,64(s1)
    80001130:	6705                	lui	a4,0x1
    80001132:	97ba                	add	a5,a5,a4
    80001134:	f4bc                	sd	a5,104(s1)
}
    80001136:	8526                	mv	a0,s1
    80001138:	60e2                	ld	ra,24(sp)
    8000113a:	6442                	ld	s0,16(sp)
    8000113c:	64a2                	ld	s1,8(sp)
    8000113e:	6902                	ld	s2,0(sp)
    80001140:	6105                	addi	sp,sp,32
    80001142:	8082                	ret
    freeproc(p);
    80001144:	8526                	mv	a0,s1
    80001146:	00000097          	auipc	ra,0x0
    8000114a:	f08080e7          	jalr	-248(ra) # 8000104e <freeproc>
    release(&p->lock);
    8000114e:	8526                	mv	a0,s1
    80001150:	00006097          	auipc	ra,0x6
    80001154:	00c080e7          	jalr	12(ra) # 8000715c <release>
    return 0;
    80001158:	84ca                	mv	s1,s2
    8000115a:	bff1                	j	80001136 <allocproc+0x90>
    freeproc(p);
    8000115c:	8526                	mv	a0,s1
    8000115e:	00000097          	auipc	ra,0x0
    80001162:	ef0080e7          	jalr	-272(ra) # 8000104e <freeproc>
    release(&p->lock);
    80001166:	8526                	mv	a0,s1
    80001168:	00006097          	auipc	ra,0x6
    8000116c:	ff4080e7          	jalr	-12(ra) # 8000715c <release>
    return 0;
    80001170:	84ca                	mv	s1,s2
    80001172:	b7d1                	j	80001136 <allocproc+0x90>

0000000080001174 <userinit>:
{
    80001174:	1101                	addi	sp,sp,-32
    80001176:	ec06                	sd	ra,24(sp)
    80001178:	e822                	sd	s0,16(sp)
    8000117a:	e426                	sd	s1,8(sp)
    8000117c:	1000                	addi	s0,sp,32
  p = allocproc();
    8000117e:	00000097          	auipc	ra,0x0
    80001182:	f28080e7          	jalr	-216(ra) # 800010a6 <allocproc>
    80001186:	84aa                	mv	s1,a0
  initproc = p;
    80001188:	00009797          	auipc	a5,0x9
    8000118c:	e8a7b423          	sd	a0,-376(a5) # 8000a010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001190:	03400613          	li	a2,52
    80001194:	00008597          	auipc	a1,0x8
    80001198:	71c58593          	addi	a1,a1,1820 # 800098b0 <initcode>
    8000119c:	6928                	ld	a0,80(a0)
    8000119e:	fffff097          	auipc	ra,0xfffff
    800011a2:	6b8080e7          	jalr	1720(ra) # 80000856 <uvminit>
  p->sz = PGSIZE;
    800011a6:	6785                	lui	a5,0x1
    800011a8:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800011aa:	6cb8                	ld	a4,88(s1)
    800011ac:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800011b0:	6cb8                	ld	a4,88(s1)
    800011b2:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800011b4:	4641                	li	a2,16
    800011b6:	00008597          	auipc	a1,0x8
    800011ba:	fda58593          	addi	a1,a1,-38 # 80009190 <etext+0x190>
    800011be:	15848513          	addi	a0,s1,344
    800011c2:	fffff097          	auipc	ra,0xfffff
    800011c6:	102080e7          	jalr	258(ra) # 800002c4 <safestrcpy>
  p->cwd = namei("/");
    800011ca:	00008517          	auipc	a0,0x8
    800011ce:	fd650513          	addi	a0,a0,-42 # 800091a0 <etext+0x1a0>
    800011d2:	00002097          	auipc	ra,0x2
    800011d6:	0de080e7          	jalr	222(ra) # 800032b0 <namei>
    800011da:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800011de:	478d                	li	a5,3
    800011e0:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011e2:	8526                	mv	a0,s1
    800011e4:	00006097          	auipc	ra,0x6
    800011e8:	f78080e7          	jalr	-136(ra) # 8000715c <release>
}
    800011ec:	60e2                	ld	ra,24(sp)
    800011ee:	6442                	ld	s0,16(sp)
    800011f0:	64a2                	ld	s1,8(sp)
    800011f2:	6105                	addi	sp,sp,32
    800011f4:	8082                	ret

00000000800011f6 <growproc>:
{
    800011f6:	1101                	addi	sp,sp,-32
    800011f8:	ec06                	sd	ra,24(sp)
    800011fa:	e822                	sd	s0,16(sp)
    800011fc:	e426                	sd	s1,8(sp)
    800011fe:	e04a                	sd	s2,0(sp)
    80001200:	1000                	addi	s0,sp,32
    80001202:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001204:	00000097          	auipc	ra,0x0
    80001208:	c98080e7          	jalr	-872(ra) # 80000e9c <myproc>
    8000120c:	892a                	mv	s2,a0
  sz = p->sz;
    8000120e:	652c                	ld	a1,72(a0)
    80001210:	0005879b          	sext.w	a5,a1
  if(n > 0){
    80001214:	00904f63          	bgtz	s1,80001232 <growproc+0x3c>
  } else if(n < 0){
    80001218:	0204cd63          	bltz	s1,80001252 <growproc+0x5c>
  p->sz = sz;
    8000121c:	1782                	slli	a5,a5,0x20
    8000121e:	9381                	srli	a5,a5,0x20
    80001220:	04f93423          	sd	a5,72(s2)
  return 0;
    80001224:	4501                	li	a0,0
}
    80001226:	60e2                	ld	ra,24(sp)
    80001228:	6442                	ld	s0,16(sp)
    8000122a:	64a2                	ld	s1,8(sp)
    8000122c:	6902                	ld	s2,0(sp)
    8000122e:	6105                	addi	sp,sp,32
    80001230:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001232:	00f4863b          	addw	a2,s1,a5
    80001236:	1602                	slli	a2,a2,0x20
    80001238:	9201                	srli	a2,a2,0x20
    8000123a:	1582                	slli	a1,a1,0x20
    8000123c:	9181                	srli	a1,a1,0x20
    8000123e:	6928                	ld	a0,80(a0)
    80001240:	fffff097          	auipc	ra,0xfffff
    80001244:	6d0080e7          	jalr	1744(ra) # 80000910 <uvmalloc>
    80001248:	0005079b          	sext.w	a5,a0
    8000124c:	fbe1                	bnez	a5,8000121c <growproc+0x26>
      return -1;
    8000124e:	557d                	li	a0,-1
    80001250:	bfd9                	j	80001226 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001252:	00f4863b          	addw	a2,s1,a5
    80001256:	1602                	slli	a2,a2,0x20
    80001258:	9201                	srli	a2,a2,0x20
    8000125a:	1582                	slli	a1,a1,0x20
    8000125c:	9181                	srli	a1,a1,0x20
    8000125e:	6928                	ld	a0,80(a0)
    80001260:	fffff097          	auipc	ra,0xfffff
    80001264:	668080e7          	jalr	1640(ra) # 800008c8 <uvmdealloc>
    80001268:	0005079b          	sext.w	a5,a0
    8000126c:	bf45                	j	8000121c <growproc+0x26>

000000008000126e <fork>:
{
    8000126e:	7139                	addi	sp,sp,-64
    80001270:	fc06                	sd	ra,56(sp)
    80001272:	f822                	sd	s0,48(sp)
    80001274:	f426                	sd	s1,40(sp)
    80001276:	f04a                	sd	s2,32(sp)
    80001278:	ec4e                	sd	s3,24(sp)
    8000127a:	e852                	sd	s4,16(sp)
    8000127c:	e456                	sd	s5,8(sp)
    8000127e:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001280:	00000097          	auipc	ra,0x0
    80001284:	c1c080e7          	jalr	-996(ra) # 80000e9c <myproc>
    80001288:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    8000128a:	00000097          	auipc	ra,0x0
    8000128e:	e1c080e7          	jalr	-484(ra) # 800010a6 <allocproc>
    80001292:	10050c63          	beqz	a0,800013aa <fork+0x13c>
    80001296:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001298:	048ab603          	ld	a2,72(s5)
    8000129c:	692c                	ld	a1,80(a0)
    8000129e:	050ab503          	ld	a0,80(s5)
    800012a2:	fffff097          	auipc	ra,0xfffff
    800012a6:	7be080e7          	jalr	1982(ra) # 80000a60 <uvmcopy>
    800012aa:	04054863          	bltz	a0,800012fa <fork+0x8c>
  np->sz = p->sz;
    800012ae:	048ab783          	ld	a5,72(s5)
    800012b2:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    800012b6:	058ab683          	ld	a3,88(s5)
    800012ba:	87b6                	mv	a5,a3
    800012bc:	058a3703          	ld	a4,88(s4)
    800012c0:	12068693          	addi	a3,a3,288
    800012c4:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012c8:	6788                	ld	a0,8(a5)
    800012ca:	6b8c                	ld	a1,16(a5)
    800012cc:	6f90                	ld	a2,24(a5)
    800012ce:	01073023          	sd	a6,0(a4)
    800012d2:	e708                	sd	a0,8(a4)
    800012d4:	eb0c                	sd	a1,16(a4)
    800012d6:	ef10                	sd	a2,24(a4)
    800012d8:	02078793          	addi	a5,a5,32
    800012dc:	02070713          	addi	a4,a4,32
    800012e0:	fed792e3          	bne	a5,a3,800012c4 <fork+0x56>
  np->trapframe->a0 = 0;
    800012e4:	058a3783          	ld	a5,88(s4)
    800012e8:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800012ec:	0d0a8493          	addi	s1,s5,208
    800012f0:	0d0a0913          	addi	s2,s4,208
    800012f4:	150a8993          	addi	s3,s5,336
    800012f8:	a00d                	j	8000131a <fork+0xac>
    freeproc(np);
    800012fa:	8552                	mv	a0,s4
    800012fc:	00000097          	auipc	ra,0x0
    80001300:	d52080e7          	jalr	-686(ra) # 8000104e <freeproc>
    release(&np->lock);
    80001304:	8552                	mv	a0,s4
    80001306:	00006097          	auipc	ra,0x6
    8000130a:	e56080e7          	jalr	-426(ra) # 8000715c <release>
    return -1;
    8000130e:	597d                	li	s2,-1
    80001310:	a059                	j	80001396 <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    80001312:	04a1                	addi	s1,s1,8
    80001314:	0921                	addi	s2,s2,8
    80001316:	01348b63          	beq	s1,s3,8000132c <fork+0xbe>
    if(p->ofile[i])
    8000131a:	6088                	ld	a0,0(s1)
    8000131c:	d97d                	beqz	a0,80001312 <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    8000131e:	00002097          	auipc	ra,0x2
    80001322:	628080e7          	jalr	1576(ra) # 80003946 <filedup>
    80001326:	00a93023          	sd	a0,0(s2)
    8000132a:	b7e5                	j	80001312 <fork+0xa4>
  np->cwd = idup(p->cwd);
    8000132c:	150ab503          	ld	a0,336(s5)
    80001330:	00001097          	auipc	ra,0x1
    80001334:	786080e7          	jalr	1926(ra) # 80002ab6 <idup>
    80001338:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000133c:	4641                	li	a2,16
    8000133e:	158a8593          	addi	a1,s5,344
    80001342:	158a0513          	addi	a0,s4,344
    80001346:	fffff097          	auipc	ra,0xfffff
    8000134a:	f7e080e7          	jalr	-130(ra) # 800002c4 <safestrcpy>
  pid = np->pid;
    8000134e:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001352:	8552                	mv	a0,s4
    80001354:	00006097          	auipc	ra,0x6
    80001358:	e08080e7          	jalr	-504(ra) # 8000715c <release>
  acquire(&wait_lock);
    8000135c:	00009497          	auipc	s1,0x9
    80001360:	d2c48493          	addi	s1,s1,-724 # 8000a088 <wait_lock>
    80001364:	8526                	mv	a0,s1
    80001366:	00006097          	auipc	ra,0x6
    8000136a:	d42080e7          	jalr	-702(ra) # 800070a8 <acquire>
  np->parent = p;
    8000136e:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001372:	8526                	mv	a0,s1
    80001374:	00006097          	auipc	ra,0x6
    80001378:	de8080e7          	jalr	-536(ra) # 8000715c <release>
  acquire(&np->lock);
    8000137c:	8552                	mv	a0,s4
    8000137e:	00006097          	auipc	ra,0x6
    80001382:	d2a080e7          	jalr	-726(ra) # 800070a8 <acquire>
  np->state = RUNNABLE;
    80001386:	478d                	li	a5,3
    80001388:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    8000138c:	8552                	mv	a0,s4
    8000138e:	00006097          	auipc	ra,0x6
    80001392:	dce080e7          	jalr	-562(ra) # 8000715c <release>
}
    80001396:	854a                	mv	a0,s2
    80001398:	70e2                	ld	ra,56(sp)
    8000139a:	7442                	ld	s0,48(sp)
    8000139c:	74a2                	ld	s1,40(sp)
    8000139e:	7902                	ld	s2,32(sp)
    800013a0:	69e2                	ld	s3,24(sp)
    800013a2:	6a42                	ld	s4,16(sp)
    800013a4:	6aa2                	ld	s5,8(sp)
    800013a6:	6121                	addi	sp,sp,64
    800013a8:	8082                	ret
    return -1;
    800013aa:	597d                	li	s2,-1
    800013ac:	b7ed                	j	80001396 <fork+0x128>

00000000800013ae <scheduler>:
{
    800013ae:	7139                	addi	sp,sp,-64
    800013b0:	fc06                	sd	ra,56(sp)
    800013b2:	f822                	sd	s0,48(sp)
    800013b4:	f426                	sd	s1,40(sp)
    800013b6:	f04a                	sd	s2,32(sp)
    800013b8:	ec4e                	sd	s3,24(sp)
    800013ba:	e852                	sd	s4,16(sp)
    800013bc:	e456                	sd	s5,8(sp)
    800013be:	e05a                	sd	s6,0(sp)
    800013c0:	0080                	addi	s0,sp,64
    800013c2:	8792                	mv	a5,tp
  int id = r_tp();
    800013c4:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013c6:	00779a93          	slli	s5,a5,0x7
    800013ca:	00009717          	auipc	a4,0x9
    800013ce:	ca670713          	addi	a4,a4,-858 # 8000a070 <pid_lock>
    800013d2:	9756                	add	a4,a4,s5
    800013d4:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013d8:	00009717          	auipc	a4,0x9
    800013dc:	cd070713          	addi	a4,a4,-816 # 8000a0a8 <cpus+0x8>
    800013e0:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800013e2:	498d                	li	s3,3
        p->state = RUNNING;
    800013e4:	4b11                	li	s6,4
        c->proc = p;
    800013e6:	079e                	slli	a5,a5,0x7
    800013e8:	00009a17          	auipc	s4,0x9
    800013ec:	c88a0a13          	addi	s4,s4,-888 # 8000a070 <pid_lock>
    800013f0:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013f2:	0000f917          	auipc	s2,0xf
    800013f6:	aae90913          	addi	s2,s2,-1362 # 8000fea0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013fa:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013fe:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001402:	10079073          	csrw	sstatus,a5
    80001406:	00009497          	auipc	s1,0x9
    8000140a:	09a48493          	addi	s1,s1,154 # 8000a4a0 <proc>
    8000140e:	a811                	j	80001422 <scheduler+0x74>
      release(&p->lock);
    80001410:	8526                	mv	a0,s1
    80001412:	00006097          	auipc	ra,0x6
    80001416:	d4a080e7          	jalr	-694(ra) # 8000715c <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000141a:	16848493          	addi	s1,s1,360
    8000141e:	fd248ee3          	beq	s1,s2,800013fa <scheduler+0x4c>
      acquire(&p->lock);
    80001422:	8526                	mv	a0,s1
    80001424:	00006097          	auipc	ra,0x6
    80001428:	c84080e7          	jalr	-892(ra) # 800070a8 <acquire>
      if(p->state == RUNNABLE) {
    8000142c:	4c9c                	lw	a5,24(s1)
    8000142e:	ff3791e3          	bne	a5,s3,80001410 <scheduler+0x62>
        p->state = RUNNING;
    80001432:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001436:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000143a:	06048593          	addi	a1,s1,96
    8000143e:	8556                	mv	a0,s5
    80001440:	00000097          	auipc	ra,0x0
    80001444:	620080e7          	jalr	1568(ra) # 80001a60 <swtch>
        c->proc = 0;
    80001448:	020a3823          	sd	zero,48(s4)
    8000144c:	b7d1                	j	80001410 <scheduler+0x62>

000000008000144e <sched>:
{
    8000144e:	7179                	addi	sp,sp,-48
    80001450:	f406                	sd	ra,40(sp)
    80001452:	f022                	sd	s0,32(sp)
    80001454:	ec26                	sd	s1,24(sp)
    80001456:	e84a                	sd	s2,16(sp)
    80001458:	e44e                	sd	s3,8(sp)
    8000145a:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000145c:	00000097          	auipc	ra,0x0
    80001460:	a40080e7          	jalr	-1472(ra) # 80000e9c <myproc>
    80001464:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001466:	00006097          	auipc	ra,0x6
    8000146a:	bc8080e7          	jalr	-1080(ra) # 8000702e <holding>
    8000146e:	c93d                	beqz	a0,800014e4 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001470:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001472:	2781                	sext.w	a5,a5
    80001474:	079e                	slli	a5,a5,0x7
    80001476:	00009717          	auipc	a4,0x9
    8000147a:	bfa70713          	addi	a4,a4,-1030 # 8000a070 <pid_lock>
    8000147e:	97ba                	add	a5,a5,a4
    80001480:	0a87a703          	lw	a4,168(a5)
    80001484:	4785                	li	a5,1
    80001486:	06f71763          	bne	a4,a5,800014f4 <sched+0xa6>
  if(p->state == RUNNING)
    8000148a:	4c98                	lw	a4,24(s1)
    8000148c:	4791                	li	a5,4
    8000148e:	06f70b63          	beq	a4,a5,80001504 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001492:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001496:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001498:	efb5                	bnez	a5,80001514 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000149a:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000149c:	00009917          	auipc	s2,0x9
    800014a0:	bd490913          	addi	s2,s2,-1068 # 8000a070 <pid_lock>
    800014a4:	2781                	sext.w	a5,a5
    800014a6:	079e                	slli	a5,a5,0x7
    800014a8:	97ca                	add	a5,a5,s2
    800014aa:	0ac7a983          	lw	s3,172(a5)
    800014ae:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800014b0:	2781                	sext.w	a5,a5
    800014b2:	079e                	slli	a5,a5,0x7
    800014b4:	00009597          	auipc	a1,0x9
    800014b8:	bf458593          	addi	a1,a1,-1036 # 8000a0a8 <cpus+0x8>
    800014bc:	95be                	add	a1,a1,a5
    800014be:	06048513          	addi	a0,s1,96
    800014c2:	00000097          	auipc	ra,0x0
    800014c6:	59e080e7          	jalr	1438(ra) # 80001a60 <swtch>
    800014ca:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014cc:	2781                	sext.w	a5,a5
    800014ce:	079e                	slli	a5,a5,0x7
    800014d0:	993e                	add	s2,s2,a5
    800014d2:	0b392623          	sw	s3,172(s2)
}
    800014d6:	70a2                	ld	ra,40(sp)
    800014d8:	7402                	ld	s0,32(sp)
    800014da:	64e2                	ld	s1,24(sp)
    800014dc:	6942                	ld	s2,16(sp)
    800014de:	69a2                	ld	s3,8(sp)
    800014e0:	6145                	addi	sp,sp,48
    800014e2:	8082                	ret
    panic("sched p->lock");
    800014e4:	00008517          	auipc	a0,0x8
    800014e8:	cc450513          	addi	a0,a0,-828 # 800091a8 <etext+0x1a8>
    800014ec:	00005097          	auipc	ra,0x5
    800014f0:	684080e7          	jalr	1668(ra) # 80006b70 <panic>
    panic("sched locks");
    800014f4:	00008517          	auipc	a0,0x8
    800014f8:	cc450513          	addi	a0,a0,-828 # 800091b8 <etext+0x1b8>
    800014fc:	00005097          	auipc	ra,0x5
    80001500:	674080e7          	jalr	1652(ra) # 80006b70 <panic>
    panic("sched running");
    80001504:	00008517          	auipc	a0,0x8
    80001508:	cc450513          	addi	a0,a0,-828 # 800091c8 <etext+0x1c8>
    8000150c:	00005097          	auipc	ra,0x5
    80001510:	664080e7          	jalr	1636(ra) # 80006b70 <panic>
    panic("sched interruptible");
    80001514:	00008517          	auipc	a0,0x8
    80001518:	cc450513          	addi	a0,a0,-828 # 800091d8 <etext+0x1d8>
    8000151c:	00005097          	auipc	ra,0x5
    80001520:	654080e7          	jalr	1620(ra) # 80006b70 <panic>

0000000080001524 <yield>:
{
    80001524:	1101                	addi	sp,sp,-32
    80001526:	ec06                	sd	ra,24(sp)
    80001528:	e822                	sd	s0,16(sp)
    8000152a:	e426                	sd	s1,8(sp)
    8000152c:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000152e:	00000097          	auipc	ra,0x0
    80001532:	96e080e7          	jalr	-1682(ra) # 80000e9c <myproc>
    80001536:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001538:	00006097          	auipc	ra,0x6
    8000153c:	b70080e7          	jalr	-1168(ra) # 800070a8 <acquire>
  p->state = RUNNABLE;
    80001540:	478d                	li	a5,3
    80001542:	cc9c                	sw	a5,24(s1)
  sched();
    80001544:	00000097          	auipc	ra,0x0
    80001548:	f0a080e7          	jalr	-246(ra) # 8000144e <sched>
  release(&p->lock);
    8000154c:	8526                	mv	a0,s1
    8000154e:	00006097          	auipc	ra,0x6
    80001552:	c0e080e7          	jalr	-1010(ra) # 8000715c <release>
}
    80001556:	60e2                	ld	ra,24(sp)
    80001558:	6442                	ld	s0,16(sp)
    8000155a:	64a2                	ld	s1,8(sp)
    8000155c:	6105                	addi	sp,sp,32
    8000155e:	8082                	ret

0000000080001560 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001560:	7179                	addi	sp,sp,-48
    80001562:	f406                	sd	ra,40(sp)
    80001564:	f022                	sd	s0,32(sp)
    80001566:	ec26                	sd	s1,24(sp)
    80001568:	e84a                	sd	s2,16(sp)
    8000156a:	e44e                	sd	s3,8(sp)
    8000156c:	1800                	addi	s0,sp,48
    8000156e:	89aa                	mv	s3,a0
    80001570:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001572:	00000097          	auipc	ra,0x0
    80001576:	92a080e7          	jalr	-1750(ra) # 80000e9c <myproc>
    8000157a:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000157c:	00006097          	auipc	ra,0x6
    80001580:	b2c080e7          	jalr	-1236(ra) # 800070a8 <acquire>
  release(lk);
    80001584:	854a                	mv	a0,s2
    80001586:	00006097          	auipc	ra,0x6
    8000158a:	bd6080e7          	jalr	-1066(ra) # 8000715c <release>

  // Go to sleep.
  p->chan = chan;
    8000158e:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001592:	4789                	li	a5,2
    80001594:	cc9c                	sw	a5,24(s1)

  sched();
    80001596:	00000097          	auipc	ra,0x0
    8000159a:	eb8080e7          	jalr	-328(ra) # 8000144e <sched>

  // Tidy up.
  p->chan = 0;
    8000159e:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800015a2:	8526                	mv	a0,s1
    800015a4:	00006097          	auipc	ra,0x6
    800015a8:	bb8080e7          	jalr	-1096(ra) # 8000715c <release>
  acquire(lk);
    800015ac:	854a                	mv	a0,s2
    800015ae:	00006097          	auipc	ra,0x6
    800015b2:	afa080e7          	jalr	-1286(ra) # 800070a8 <acquire>
}
    800015b6:	70a2                	ld	ra,40(sp)
    800015b8:	7402                	ld	s0,32(sp)
    800015ba:	64e2                	ld	s1,24(sp)
    800015bc:	6942                	ld	s2,16(sp)
    800015be:	69a2                	ld	s3,8(sp)
    800015c0:	6145                	addi	sp,sp,48
    800015c2:	8082                	ret

00000000800015c4 <wait>:
{
    800015c4:	715d                	addi	sp,sp,-80
    800015c6:	e486                	sd	ra,72(sp)
    800015c8:	e0a2                	sd	s0,64(sp)
    800015ca:	fc26                	sd	s1,56(sp)
    800015cc:	f84a                	sd	s2,48(sp)
    800015ce:	f44e                	sd	s3,40(sp)
    800015d0:	f052                	sd	s4,32(sp)
    800015d2:	ec56                	sd	s5,24(sp)
    800015d4:	e85a                	sd	s6,16(sp)
    800015d6:	e45e                	sd	s7,8(sp)
    800015d8:	e062                	sd	s8,0(sp)
    800015da:	0880                	addi	s0,sp,80
    800015dc:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015de:	00000097          	auipc	ra,0x0
    800015e2:	8be080e7          	jalr	-1858(ra) # 80000e9c <myproc>
    800015e6:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015e8:	00009517          	auipc	a0,0x9
    800015ec:	aa050513          	addi	a0,a0,-1376 # 8000a088 <wait_lock>
    800015f0:	00006097          	auipc	ra,0x6
    800015f4:	ab8080e7          	jalr	-1352(ra) # 800070a8 <acquire>
    havekids = 0;
    800015f8:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800015fa:	4a15                	li	s4,5
        havekids = 1;
    800015fc:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    800015fe:	0000f997          	auipc	s3,0xf
    80001602:	8a298993          	addi	s3,s3,-1886 # 8000fea0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001606:	00009c17          	auipc	s8,0x9
    8000160a:	a82c0c13          	addi	s8,s8,-1406 # 8000a088 <wait_lock>
    havekids = 0;
    8000160e:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    80001610:	00009497          	auipc	s1,0x9
    80001614:	e9048493          	addi	s1,s1,-368 # 8000a4a0 <proc>
    80001618:	a0bd                	j	80001686 <wait+0xc2>
          pid = np->pid;
    8000161a:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    8000161e:	000b0e63          	beqz	s6,8000163a <wait+0x76>
    80001622:	4691                	li	a3,4
    80001624:	02c48613          	addi	a2,s1,44
    80001628:	85da                	mv	a1,s6
    8000162a:	05093503          	ld	a0,80(s2)
    8000162e:	fffff097          	auipc	ra,0xfffff
    80001632:	536080e7          	jalr	1334(ra) # 80000b64 <copyout>
    80001636:	02054563          	bltz	a0,80001660 <wait+0x9c>
          freeproc(np);
    8000163a:	8526                	mv	a0,s1
    8000163c:	00000097          	auipc	ra,0x0
    80001640:	a12080e7          	jalr	-1518(ra) # 8000104e <freeproc>
          release(&np->lock);
    80001644:	8526                	mv	a0,s1
    80001646:	00006097          	auipc	ra,0x6
    8000164a:	b16080e7          	jalr	-1258(ra) # 8000715c <release>
          release(&wait_lock);
    8000164e:	00009517          	auipc	a0,0x9
    80001652:	a3a50513          	addi	a0,a0,-1478 # 8000a088 <wait_lock>
    80001656:	00006097          	auipc	ra,0x6
    8000165a:	b06080e7          	jalr	-1274(ra) # 8000715c <release>
          return pid;
    8000165e:	a09d                	j	800016c4 <wait+0x100>
            release(&np->lock);
    80001660:	8526                	mv	a0,s1
    80001662:	00006097          	auipc	ra,0x6
    80001666:	afa080e7          	jalr	-1286(ra) # 8000715c <release>
            release(&wait_lock);
    8000166a:	00009517          	auipc	a0,0x9
    8000166e:	a1e50513          	addi	a0,a0,-1506 # 8000a088 <wait_lock>
    80001672:	00006097          	auipc	ra,0x6
    80001676:	aea080e7          	jalr	-1302(ra) # 8000715c <release>
            return -1;
    8000167a:	59fd                	li	s3,-1
    8000167c:	a0a1                	j	800016c4 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    8000167e:	16848493          	addi	s1,s1,360
    80001682:	03348463          	beq	s1,s3,800016aa <wait+0xe6>
      if(np->parent == p){
    80001686:	7c9c                	ld	a5,56(s1)
    80001688:	ff279be3          	bne	a5,s2,8000167e <wait+0xba>
        acquire(&np->lock);
    8000168c:	8526                	mv	a0,s1
    8000168e:	00006097          	auipc	ra,0x6
    80001692:	a1a080e7          	jalr	-1510(ra) # 800070a8 <acquire>
        if(np->state == ZOMBIE){
    80001696:	4c9c                	lw	a5,24(s1)
    80001698:	f94781e3          	beq	a5,s4,8000161a <wait+0x56>
        release(&np->lock);
    8000169c:	8526                	mv	a0,s1
    8000169e:	00006097          	auipc	ra,0x6
    800016a2:	abe080e7          	jalr	-1346(ra) # 8000715c <release>
        havekids = 1;
    800016a6:	8756                	mv	a4,s5
    800016a8:	bfd9                	j	8000167e <wait+0xba>
    if(!havekids || p->killed){
    800016aa:	c701                	beqz	a4,800016b2 <wait+0xee>
    800016ac:	02892783          	lw	a5,40(s2)
    800016b0:	c79d                	beqz	a5,800016de <wait+0x11a>
      release(&wait_lock);
    800016b2:	00009517          	auipc	a0,0x9
    800016b6:	9d650513          	addi	a0,a0,-1578 # 8000a088 <wait_lock>
    800016ba:	00006097          	auipc	ra,0x6
    800016be:	aa2080e7          	jalr	-1374(ra) # 8000715c <release>
      return -1;
    800016c2:	59fd                	li	s3,-1
}
    800016c4:	854e                	mv	a0,s3
    800016c6:	60a6                	ld	ra,72(sp)
    800016c8:	6406                	ld	s0,64(sp)
    800016ca:	74e2                	ld	s1,56(sp)
    800016cc:	7942                	ld	s2,48(sp)
    800016ce:	79a2                	ld	s3,40(sp)
    800016d0:	7a02                	ld	s4,32(sp)
    800016d2:	6ae2                	ld	s5,24(sp)
    800016d4:	6b42                	ld	s6,16(sp)
    800016d6:	6ba2                	ld	s7,8(sp)
    800016d8:	6c02                	ld	s8,0(sp)
    800016da:	6161                	addi	sp,sp,80
    800016dc:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016de:	85e2                	mv	a1,s8
    800016e0:	854a                	mv	a0,s2
    800016e2:	00000097          	auipc	ra,0x0
    800016e6:	e7e080e7          	jalr	-386(ra) # 80001560 <sleep>
    havekids = 0;
    800016ea:	b715                	j	8000160e <wait+0x4a>

00000000800016ec <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800016ec:	7139                	addi	sp,sp,-64
    800016ee:	fc06                	sd	ra,56(sp)
    800016f0:	f822                	sd	s0,48(sp)
    800016f2:	f426                	sd	s1,40(sp)
    800016f4:	f04a                	sd	s2,32(sp)
    800016f6:	ec4e                	sd	s3,24(sp)
    800016f8:	e852                	sd	s4,16(sp)
    800016fa:	e456                	sd	s5,8(sp)
    800016fc:	0080                	addi	s0,sp,64
    800016fe:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001700:	00009497          	auipc	s1,0x9
    80001704:	da048493          	addi	s1,s1,-608 # 8000a4a0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001708:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000170a:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000170c:	0000e917          	auipc	s2,0xe
    80001710:	79490913          	addi	s2,s2,1940 # 8000fea0 <tickslock>
    80001714:	a811                	j	80001728 <wakeup+0x3c>
      }
      release(&p->lock);
    80001716:	8526                	mv	a0,s1
    80001718:	00006097          	auipc	ra,0x6
    8000171c:	a44080e7          	jalr	-1468(ra) # 8000715c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001720:	16848493          	addi	s1,s1,360
    80001724:	03248663          	beq	s1,s2,80001750 <wakeup+0x64>
    if(p != myproc()){
    80001728:	fffff097          	auipc	ra,0xfffff
    8000172c:	774080e7          	jalr	1908(ra) # 80000e9c <myproc>
    80001730:	fea488e3          	beq	s1,a0,80001720 <wakeup+0x34>
      acquire(&p->lock);
    80001734:	8526                	mv	a0,s1
    80001736:	00006097          	auipc	ra,0x6
    8000173a:	972080e7          	jalr	-1678(ra) # 800070a8 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000173e:	4c9c                	lw	a5,24(s1)
    80001740:	fd379be3          	bne	a5,s3,80001716 <wakeup+0x2a>
    80001744:	709c                	ld	a5,32(s1)
    80001746:	fd4798e3          	bne	a5,s4,80001716 <wakeup+0x2a>
        p->state = RUNNABLE;
    8000174a:	0154ac23          	sw	s5,24(s1)
    8000174e:	b7e1                	j	80001716 <wakeup+0x2a>
    }
  }
}
    80001750:	70e2                	ld	ra,56(sp)
    80001752:	7442                	ld	s0,48(sp)
    80001754:	74a2                	ld	s1,40(sp)
    80001756:	7902                	ld	s2,32(sp)
    80001758:	69e2                	ld	s3,24(sp)
    8000175a:	6a42                	ld	s4,16(sp)
    8000175c:	6aa2                	ld	s5,8(sp)
    8000175e:	6121                	addi	sp,sp,64
    80001760:	8082                	ret

0000000080001762 <reparent>:
{
    80001762:	7179                	addi	sp,sp,-48
    80001764:	f406                	sd	ra,40(sp)
    80001766:	f022                	sd	s0,32(sp)
    80001768:	ec26                	sd	s1,24(sp)
    8000176a:	e84a                	sd	s2,16(sp)
    8000176c:	e44e                	sd	s3,8(sp)
    8000176e:	e052                	sd	s4,0(sp)
    80001770:	1800                	addi	s0,sp,48
    80001772:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001774:	00009497          	auipc	s1,0x9
    80001778:	d2c48493          	addi	s1,s1,-724 # 8000a4a0 <proc>
      pp->parent = initproc;
    8000177c:	00009a17          	auipc	s4,0x9
    80001780:	894a0a13          	addi	s4,s4,-1900 # 8000a010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001784:	0000e997          	auipc	s3,0xe
    80001788:	71c98993          	addi	s3,s3,1820 # 8000fea0 <tickslock>
    8000178c:	a029                	j	80001796 <reparent+0x34>
    8000178e:	16848493          	addi	s1,s1,360
    80001792:	01348d63          	beq	s1,s3,800017ac <reparent+0x4a>
    if(pp->parent == p){
    80001796:	7c9c                	ld	a5,56(s1)
    80001798:	ff279be3          	bne	a5,s2,8000178e <reparent+0x2c>
      pp->parent = initproc;
    8000179c:	000a3503          	ld	a0,0(s4)
    800017a0:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800017a2:	00000097          	auipc	ra,0x0
    800017a6:	f4a080e7          	jalr	-182(ra) # 800016ec <wakeup>
    800017aa:	b7d5                	j	8000178e <reparent+0x2c>
}
    800017ac:	70a2                	ld	ra,40(sp)
    800017ae:	7402                	ld	s0,32(sp)
    800017b0:	64e2                	ld	s1,24(sp)
    800017b2:	6942                	ld	s2,16(sp)
    800017b4:	69a2                	ld	s3,8(sp)
    800017b6:	6a02                	ld	s4,0(sp)
    800017b8:	6145                	addi	sp,sp,48
    800017ba:	8082                	ret

00000000800017bc <exit>:
{
    800017bc:	7179                	addi	sp,sp,-48
    800017be:	f406                	sd	ra,40(sp)
    800017c0:	f022                	sd	s0,32(sp)
    800017c2:	ec26                	sd	s1,24(sp)
    800017c4:	e84a                	sd	s2,16(sp)
    800017c6:	e44e                	sd	s3,8(sp)
    800017c8:	e052                	sd	s4,0(sp)
    800017ca:	1800                	addi	s0,sp,48
    800017cc:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800017ce:	fffff097          	auipc	ra,0xfffff
    800017d2:	6ce080e7          	jalr	1742(ra) # 80000e9c <myproc>
    800017d6:	89aa                	mv	s3,a0
  if(p == initproc)
    800017d8:	00009797          	auipc	a5,0x9
    800017dc:	8387b783          	ld	a5,-1992(a5) # 8000a010 <initproc>
    800017e0:	0d050493          	addi	s1,a0,208
    800017e4:	15050913          	addi	s2,a0,336
    800017e8:	02a79363          	bne	a5,a0,8000180e <exit+0x52>
    panic("init exiting");
    800017ec:	00008517          	auipc	a0,0x8
    800017f0:	a0450513          	addi	a0,a0,-1532 # 800091f0 <etext+0x1f0>
    800017f4:	00005097          	auipc	ra,0x5
    800017f8:	37c080e7          	jalr	892(ra) # 80006b70 <panic>
      fileclose(f);
    800017fc:	00002097          	auipc	ra,0x2
    80001800:	19c080e7          	jalr	412(ra) # 80003998 <fileclose>
      p->ofile[fd] = 0;
    80001804:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001808:	04a1                	addi	s1,s1,8
    8000180a:	01248563          	beq	s1,s2,80001814 <exit+0x58>
    if(p->ofile[fd]){
    8000180e:	6088                	ld	a0,0(s1)
    80001810:	f575                	bnez	a0,800017fc <exit+0x40>
    80001812:	bfdd                	j	80001808 <exit+0x4c>
  begin_op();
    80001814:	00002097          	auipc	ra,0x2
    80001818:	cbc080e7          	jalr	-836(ra) # 800034d0 <begin_op>
  iput(p->cwd);
    8000181c:	1509b503          	ld	a0,336(s3)
    80001820:	00001097          	auipc	ra,0x1
    80001824:	48e080e7          	jalr	1166(ra) # 80002cae <iput>
  end_op();
    80001828:	00002097          	auipc	ra,0x2
    8000182c:	d26080e7          	jalr	-730(ra) # 8000354e <end_op>
  p->cwd = 0;
    80001830:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001834:	00009497          	auipc	s1,0x9
    80001838:	85448493          	addi	s1,s1,-1964 # 8000a088 <wait_lock>
    8000183c:	8526                	mv	a0,s1
    8000183e:	00006097          	auipc	ra,0x6
    80001842:	86a080e7          	jalr	-1942(ra) # 800070a8 <acquire>
  reparent(p);
    80001846:	854e                	mv	a0,s3
    80001848:	00000097          	auipc	ra,0x0
    8000184c:	f1a080e7          	jalr	-230(ra) # 80001762 <reparent>
  wakeup(p->parent);
    80001850:	0389b503          	ld	a0,56(s3)
    80001854:	00000097          	auipc	ra,0x0
    80001858:	e98080e7          	jalr	-360(ra) # 800016ec <wakeup>
  acquire(&p->lock);
    8000185c:	854e                	mv	a0,s3
    8000185e:	00006097          	auipc	ra,0x6
    80001862:	84a080e7          	jalr	-1974(ra) # 800070a8 <acquire>
  p->xstate = status;
    80001866:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000186a:	4795                	li	a5,5
    8000186c:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001870:	8526                	mv	a0,s1
    80001872:	00006097          	auipc	ra,0x6
    80001876:	8ea080e7          	jalr	-1814(ra) # 8000715c <release>
  sched();
    8000187a:	00000097          	auipc	ra,0x0
    8000187e:	bd4080e7          	jalr	-1068(ra) # 8000144e <sched>
  panic("zombie exit");
    80001882:	00008517          	auipc	a0,0x8
    80001886:	97e50513          	addi	a0,a0,-1666 # 80009200 <etext+0x200>
    8000188a:	00005097          	auipc	ra,0x5
    8000188e:	2e6080e7          	jalr	742(ra) # 80006b70 <panic>

0000000080001892 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001892:	7179                	addi	sp,sp,-48
    80001894:	f406                	sd	ra,40(sp)
    80001896:	f022                	sd	s0,32(sp)
    80001898:	ec26                	sd	s1,24(sp)
    8000189a:	e84a                	sd	s2,16(sp)
    8000189c:	e44e                	sd	s3,8(sp)
    8000189e:	1800                	addi	s0,sp,48
    800018a0:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800018a2:	00009497          	auipc	s1,0x9
    800018a6:	bfe48493          	addi	s1,s1,-1026 # 8000a4a0 <proc>
    800018aa:	0000e997          	auipc	s3,0xe
    800018ae:	5f698993          	addi	s3,s3,1526 # 8000fea0 <tickslock>
    acquire(&p->lock);
    800018b2:	8526                	mv	a0,s1
    800018b4:	00005097          	auipc	ra,0x5
    800018b8:	7f4080e7          	jalr	2036(ra) # 800070a8 <acquire>
    if(p->pid == pid){
    800018bc:	589c                	lw	a5,48(s1)
    800018be:	01278d63          	beq	a5,s2,800018d8 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800018c2:	8526                	mv	a0,s1
    800018c4:	00006097          	auipc	ra,0x6
    800018c8:	898080e7          	jalr	-1896(ra) # 8000715c <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800018cc:	16848493          	addi	s1,s1,360
    800018d0:	ff3491e3          	bne	s1,s3,800018b2 <kill+0x20>
  }
  return -1;
    800018d4:	557d                	li	a0,-1
    800018d6:	a829                	j	800018f0 <kill+0x5e>
      p->killed = 1;
    800018d8:	4785                	li	a5,1
    800018da:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800018dc:	4c98                	lw	a4,24(s1)
    800018de:	4789                	li	a5,2
    800018e0:	00f70f63          	beq	a4,a5,800018fe <kill+0x6c>
      release(&p->lock);
    800018e4:	8526                	mv	a0,s1
    800018e6:	00006097          	auipc	ra,0x6
    800018ea:	876080e7          	jalr	-1930(ra) # 8000715c <release>
      return 0;
    800018ee:	4501                	li	a0,0
}
    800018f0:	70a2                	ld	ra,40(sp)
    800018f2:	7402                	ld	s0,32(sp)
    800018f4:	64e2                	ld	s1,24(sp)
    800018f6:	6942                	ld	s2,16(sp)
    800018f8:	69a2                	ld	s3,8(sp)
    800018fa:	6145                	addi	sp,sp,48
    800018fc:	8082                	ret
        p->state = RUNNABLE;
    800018fe:	478d                	li	a5,3
    80001900:	cc9c                	sw	a5,24(s1)
    80001902:	b7cd                	j	800018e4 <kill+0x52>

0000000080001904 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001904:	7179                	addi	sp,sp,-48
    80001906:	f406                	sd	ra,40(sp)
    80001908:	f022                	sd	s0,32(sp)
    8000190a:	ec26                	sd	s1,24(sp)
    8000190c:	e84a                	sd	s2,16(sp)
    8000190e:	e44e                	sd	s3,8(sp)
    80001910:	e052                	sd	s4,0(sp)
    80001912:	1800                	addi	s0,sp,48
    80001914:	84aa                	mv	s1,a0
    80001916:	892e                	mv	s2,a1
    80001918:	89b2                	mv	s3,a2
    8000191a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000191c:	fffff097          	auipc	ra,0xfffff
    80001920:	580080e7          	jalr	1408(ra) # 80000e9c <myproc>
  if(user_dst){
    80001924:	c08d                	beqz	s1,80001946 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001926:	86d2                	mv	a3,s4
    80001928:	864e                	mv	a2,s3
    8000192a:	85ca                	mv	a1,s2
    8000192c:	6928                	ld	a0,80(a0)
    8000192e:	fffff097          	auipc	ra,0xfffff
    80001932:	236080e7          	jalr	566(ra) # 80000b64 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001936:	70a2                	ld	ra,40(sp)
    80001938:	7402                	ld	s0,32(sp)
    8000193a:	64e2                	ld	s1,24(sp)
    8000193c:	6942                	ld	s2,16(sp)
    8000193e:	69a2                	ld	s3,8(sp)
    80001940:	6a02                	ld	s4,0(sp)
    80001942:	6145                	addi	sp,sp,48
    80001944:	8082                	ret
    memmove((char *)dst, src, len);
    80001946:	000a061b          	sext.w	a2,s4
    8000194a:	85ce                	mv	a1,s3
    8000194c:	854a                	mv	a0,s2
    8000194e:	fffff097          	auipc	ra,0xfffff
    80001952:	888080e7          	jalr	-1912(ra) # 800001d6 <memmove>
    return 0;
    80001956:	8526                	mv	a0,s1
    80001958:	bff9                	j	80001936 <either_copyout+0x32>

000000008000195a <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000195a:	7179                	addi	sp,sp,-48
    8000195c:	f406                	sd	ra,40(sp)
    8000195e:	f022                	sd	s0,32(sp)
    80001960:	ec26                	sd	s1,24(sp)
    80001962:	e84a                	sd	s2,16(sp)
    80001964:	e44e                	sd	s3,8(sp)
    80001966:	e052                	sd	s4,0(sp)
    80001968:	1800                	addi	s0,sp,48
    8000196a:	892a                	mv	s2,a0
    8000196c:	84ae                	mv	s1,a1
    8000196e:	89b2                	mv	s3,a2
    80001970:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001972:	fffff097          	auipc	ra,0xfffff
    80001976:	52a080e7          	jalr	1322(ra) # 80000e9c <myproc>
  if(user_src){
    8000197a:	c08d                	beqz	s1,8000199c <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    8000197c:	86d2                	mv	a3,s4
    8000197e:	864e                	mv	a2,s3
    80001980:	85ca                	mv	a1,s2
    80001982:	6928                	ld	a0,80(a0)
    80001984:	fffff097          	auipc	ra,0xfffff
    80001988:	26c080e7          	jalr	620(ra) # 80000bf0 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    8000198c:	70a2                	ld	ra,40(sp)
    8000198e:	7402                	ld	s0,32(sp)
    80001990:	64e2                	ld	s1,24(sp)
    80001992:	6942                	ld	s2,16(sp)
    80001994:	69a2                	ld	s3,8(sp)
    80001996:	6a02                	ld	s4,0(sp)
    80001998:	6145                	addi	sp,sp,48
    8000199a:	8082                	ret
    memmove(dst, (char*)src, len);
    8000199c:	000a061b          	sext.w	a2,s4
    800019a0:	85ce                	mv	a1,s3
    800019a2:	854a                	mv	a0,s2
    800019a4:	fffff097          	auipc	ra,0xfffff
    800019a8:	832080e7          	jalr	-1998(ra) # 800001d6 <memmove>
    return 0;
    800019ac:	8526                	mv	a0,s1
    800019ae:	bff9                	j	8000198c <either_copyin+0x32>

00000000800019b0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800019b0:	715d                	addi	sp,sp,-80
    800019b2:	e486                	sd	ra,72(sp)
    800019b4:	e0a2                	sd	s0,64(sp)
    800019b6:	fc26                	sd	s1,56(sp)
    800019b8:	f84a                	sd	s2,48(sp)
    800019ba:	f44e                	sd	s3,40(sp)
    800019bc:	f052                	sd	s4,32(sp)
    800019be:	ec56                	sd	s5,24(sp)
    800019c0:	e85a                	sd	s6,16(sp)
    800019c2:	e45e                	sd	s7,8(sp)
    800019c4:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800019c6:	00007517          	auipc	a0,0x7
    800019ca:	68250513          	addi	a0,a0,1666 # 80009048 <etext+0x48>
    800019ce:	00005097          	auipc	ra,0x5
    800019d2:	1ec080e7          	jalr	492(ra) # 80006bba <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019d6:	00009497          	auipc	s1,0x9
    800019da:	c2248493          	addi	s1,s1,-990 # 8000a5f8 <proc+0x158>
    800019de:	0000e917          	auipc	s2,0xe
    800019e2:	61a90913          	addi	s2,s2,1562 # 8000fff8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019e6:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800019e8:	00008997          	auipc	s3,0x8
    800019ec:	82898993          	addi	s3,s3,-2008 # 80009210 <etext+0x210>
    printf("%d %s %s", p->pid, state, p->name);
    800019f0:	00008a97          	auipc	s5,0x8
    800019f4:	828a8a93          	addi	s5,s5,-2008 # 80009218 <etext+0x218>
    printf("\n");
    800019f8:	00007a17          	auipc	s4,0x7
    800019fc:	650a0a13          	addi	s4,s4,1616 # 80009048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a00:	00008b97          	auipc	s7,0x8
    80001a04:	850b8b93          	addi	s7,s7,-1968 # 80009250 <states.0>
    80001a08:	a00d                	j	80001a2a <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a0a:	ed86a583          	lw	a1,-296(a3)
    80001a0e:	8556                	mv	a0,s5
    80001a10:	00005097          	auipc	ra,0x5
    80001a14:	1aa080e7          	jalr	426(ra) # 80006bba <printf>
    printf("\n");
    80001a18:	8552                	mv	a0,s4
    80001a1a:	00005097          	auipc	ra,0x5
    80001a1e:	1a0080e7          	jalr	416(ra) # 80006bba <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a22:	16848493          	addi	s1,s1,360
    80001a26:	03248263          	beq	s1,s2,80001a4a <procdump+0x9a>
    if(p->state == UNUSED)
    80001a2a:	86a6                	mv	a3,s1
    80001a2c:	ec04a783          	lw	a5,-320(s1)
    80001a30:	dbed                	beqz	a5,80001a22 <procdump+0x72>
      state = "???";
    80001a32:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a34:	fcfb6be3          	bltu	s6,a5,80001a0a <procdump+0x5a>
    80001a38:	02079713          	slli	a4,a5,0x20
    80001a3c:	01d75793          	srli	a5,a4,0x1d
    80001a40:	97de                	add	a5,a5,s7
    80001a42:	6390                	ld	a2,0(a5)
    80001a44:	f279                	bnez	a2,80001a0a <procdump+0x5a>
      state = "???";
    80001a46:	864e                	mv	a2,s3
    80001a48:	b7c9                	j	80001a0a <procdump+0x5a>
  }
}
    80001a4a:	60a6                	ld	ra,72(sp)
    80001a4c:	6406                	ld	s0,64(sp)
    80001a4e:	74e2                	ld	s1,56(sp)
    80001a50:	7942                	ld	s2,48(sp)
    80001a52:	79a2                	ld	s3,40(sp)
    80001a54:	7a02                	ld	s4,32(sp)
    80001a56:	6ae2                	ld	s5,24(sp)
    80001a58:	6b42                	ld	s6,16(sp)
    80001a5a:	6ba2                	ld	s7,8(sp)
    80001a5c:	6161                	addi	sp,sp,80
    80001a5e:	8082                	ret

0000000080001a60 <swtch>:
    80001a60:	00153023          	sd	ra,0(a0)
    80001a64:	00253423          	sd	sp,8(a0)
    80001a68:	e900                	sd	s0,16(a0)
    80001a6a:	ed04                	sd	s1,24(a0)
    80001a6c:	03253023          	sd	s2,32(a0)
    80001a70:	03353423          	sd	s3,40(a0)
    80001a74:	03453823          	sd	s4,48(a0)
    80001a78:	03553c23          	sd	s5,56(a0)
    80001a7c:	05653023          	sd	s6,64(a0)
    80001a80:	05753423          	sd	s7,72(a0)
    80001a84:	05853823          	sd	s8,80(a0)
    80001a88:	05953c23          	sd	s9,88(a0)
    80001a8c:	07a53023          	sd	s10,96(a0)
    80001a90:	07b53423          	sd	s11,104(a0)
    80001a94:	0005b083          	ld	ra,0(a1)
    80001a98:	0085b103          	ld	sp,8(a1)
    80001a9c:	6980                	ld	s0,16(a1)
    80001a9e:	6d84                	ld	s1,24(a1)
    80001aa0:	0205b903          	ld	s2,32(a1)
    80001aa4:	0285b983          	ld	s3,40(a1)
    80001aa8:	0305ba03          	ld	s4,48(a1)
    80001aac:	0385ba83          	ld	s5,56(a1)
    80001ab0:	0405bb03          	ld	s6,64(a1)
    80001ab4:	0485bb83          	ld	s7,72(a1)
    80001ab8:	0505bc03          	ld	s8,80(a1)
    80001abc:	0585bc83          	ld	s9,88(a1)
    80001ac0:	0605bd03          	ld	s10,96(a1)
    80001ac4:	0685bd83          	ld	s11,104(a1)
    80001ac8:	8082                	ret

0000000080001aca <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001aca:	1141                	addi	sp,sp,-16
    80001acc:	e406                	sd	ra,8(sp)
    80001ace:	e022                	sd	s0,0(sp)
    80001ad0:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001ad2:	00007597          	auipc	a1,0x7
    80001ad6:	7ae58593          	addi	a1,a1,1966 # 80009280 <states.0+0x30>
    80001ada:	0000e517          	auipc	a0,0xe
    80001ade:	3c650513          	addi	a0,a0,966 # 8000fea0 <tickslock>
    80001ae2:	00005097          	auipc	ra,0x5
    80001ae6:	536080e7          	jalr	1334(ra) # 80007018 <initlock>
}
    80001aea:	60a2                	ld	ra,8(sp)
    80001aec:	6402                	ld	s0,0(sp)
    80001aee:	0141                	addi	sp,sp,16
    80001af0:	8082                	ret

0000000080001af2 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001af2:	1141                	addi	sp,sp,-16
    80001af4:	e422                	sd	s0,8(sp)
    80001af6:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001af8:	00003797          	auipc	a5,0x3
    80001afc:	59878793          	addi	a5,a5,1432 # 80005090 <kernelvec>
    80001b00:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b04:	6422                	ld	s0,8(sp)
    80001b06:	0141                	addi	sp,sp,16
    80001b08:	8082                	ret

0000000080001b0a <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b0a:	1141                	addi	sp,sp,-16
    80001b0c:	e406                	sd	ra,8(sp)
    80001b0e:	e022                	sd	s0,0(sp)
    80001b10:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b12:	fffff097          	auipc	ra,0xfffff
    80001b16:	38a080e7          	jalr	906(ra) # 80000e9c <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b1a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b1e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b20:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001b24:	00006697          	auipc	a3,0x6
    80001b28:	4dc68693          	addi	a3,a3,1244 # 80008000 <_trampoline>
    80001b2c:	00006717          	auipc	a4,0x6
    80001b30:	4d470713          	addi	a4,a4,1236 # 80008000 <_trampoline>
    80001b34:	8f15                	sub	a4,a4,a3
    80001b36:	040007b7          	lui	a5,0x4000
    80001b3a:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001b3c:	07b2                	slli	a5,a5,0xc
    80001b3e:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b40:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b44:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b46:	18002673          	csrr	a2,satp
    80001b4a:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b4c:	6d30                	ld	a2,88(a0)
    80001b4e:	6138                	ld	a4,64(a0)
    80001b50:	6585                	lui	a1,0x1
    80001b52:	972e                	add	a4,a4,a1
    80001b54:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b56:	6d38                	ld	a4,88(a0)
    80001b58:	00000617          	auipc	a2,0x0
    80001b5c:	14a60613          	addi	a2,a2,330 # 80001ca2 <usertrap>
    80001b60:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b62:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b64:	8612                	mv	a2,tp
    80001b66:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b68:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b6c:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b70:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b74:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001b78:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b7a:	6f18                	ld	a4,24(a4)
    80001b7c:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b80:	692c                	ld	a1,80(a0)
    80001b82:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001b84:	00006717          	auipc	a4,0x6
    80001b88:	50c70713          	addi	a4,a4,1292 # 80008090 <userret>
    80001b8c:	8f15                	sub	a4,a4,a3
    80001b8e:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001b90:	577d                	li	a4,-1
    80001b92:	177e                	slli	a4,a4,0x3f
    80001b94:	8dd9                	or	a1,a1,a4
    80001b96:	02000537          	lui	a0,0x2000
    80001b9a:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001b9c:	0536                	slli	a0,a0,0xd
    80001b9e:	9782                	jalr	a5
}
    80001ba0:	60a2                	ld	ra,8(sp)
    80001ba2:	6402                	ld	s0,0(sp)
    80001ba4:	0141                	addi	sp,sp,16
    80001ba6:	8082                	ret

0000000080001ba8 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001ba8:	1101                	addi	sp,sp,-32
    80001baa:	ec06                	sd	ra,24(sp)
    80001bac:	e822                	sd	s0,16(sp)
    80001bae:	e426                	sd	s1,8(sp)
    80001bb0:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001bb2:	0000e497          	auipc	s1,0xe
    80001bb6:	2ee48493          	addi	s1,s1,750 # 8000fea0 <tickslock>
    80001bba:	8526                	mv	a0,s1
    80001bbc:	00005097          	auipc	ra,0x5
    80001bc0:	4ec080e7          	jalr	1260(ra) # 800070a8 <acquire>
  ticks++;
    80001bc4:	00008517          	auipc	a0,0x8
    80001bc8:	45450513          	addi	a0,a0,1108 # 8000a018 <ticks>
    80001bcc:	411c                	lw	a5,0(a0)
    80001bce:	2785                	addiw	a5,a5,1
    80001bd0:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001bd2:	00000097          	auipc	ra,0x0
    80001bd6:	b1a080e7          	jalr	-1254(ra) # 800016ec <wakeup>
  release(&tickslock);
    80001bda:	8526                	mv	a0,s1
    80001bdc:	00005097          	auipc	ra,0x5
    80001be0:	580080e7          	jalr	1408(ra) # 8000715c <release>
}
    80001be4:	60e2                	ld	ra,24(sp)
    80001be6:	6442                	ld	s0,16(sp)
    80001be8:	64a2                	ld	s1,8(sp)
    80001bea:	6105                	addi	sp,sp,32
    80001bec:	8082                	ret

0000000080001bee <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001bee:	1101                	addi	sp,sp,-32
    80001bf0:	ec06                	sd	ra,24(sp)
    80001bf2:	e822                	sd	s0,16(sp)
    80001bf4:	e426                	sd	s1,8(sp)
    80001bf6:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001bf8:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001bfc:	00074d63          	bltz	a4,80001c16 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001c00:	57fd                	li	a5,-1
    80001c02:	17fe                	slli	a5,a5,0x3f
    80001c04:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001c06:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c08:	06f70c63          	beq	a4,a5,80001c80 <devintr+0x92>
  }
}
    80001c0c:	60e2                	ld	ra,24(sp)
    80001c0e:	6442                	ld	s0,16(sp)
    80001c10:	64a2                	ld	s1,8(sp)
    80001c12:	6105                	addi	sp,sp,32
    80001c14:	8082                	ret
     (scause & 0xff) == 9){
    80001c16:	0ff77793          	zext.b	a5,a4
  if((scause & 0x8000000000000000L) &&
    80001c1a:	46a5                	li	a3,9
    80001c1c:	fed792e3          	bne	a5,a3,80001c00 <devintr+0x12>
    int irq = plic_claim();
    80001c20:	00003097          	auipc	ra,0x3
    80001c24:	592080e7          	jalr	1426(ra) # 800051b2 <plic_claim>
    80001c28:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c2a:	47a9                	li	a5,10
    80001c2c:	02f50563          	beq	a0,a5,80001c56 <devintr+0x68>
    } else if(irq == VIRTIO0_IRQ){
    80001c30:	4785                	li	a5,1
    80001c32:	02f50d63          	beq	a0,a5,80001c6c <devintr+0x7e>
    else if(irq == E1000_IRQ){
    80001c36:	02100793          	li	a5,33
    80001c3a:	02f50e63          	beq	a0,a5,80001c76 <devintr+0x88>
    return 1;
    80001c3e:	4505                	li	a0,1
    else if(irq){
    80001c40:	d4f1                	beqz	s1,80001c0c <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c42:	85a6                	mv	a1,s1
    80001c44:	00007517          	auipc	a0,0x7
    80001c48:	64450513          	addi	a0,a0,1604 # 80009288 <states.0+0x38>
    80001c4c:	00005097          	auipc	ra,0x5
    80001c50:	f6e080e7          	jalr	-146(ra) # 80006bba <printf>
    80001c54:	a029                	j	80001c5e <devintr+0x70>
      uartintr();
    80001c56:	00005097          	auipc	ra,0x5
    80001c5a:	372080e7          	jalr	882(ra) # 80006fc8 <uartintr>
      plic_complete(irq);
    80001c5e:	8526                	mv	a0,s1
    80001c60:	00003097          	auipc	ra,0x3
    80001c64:	576080e7          	jalr	1398(ra) # 800051d6 <plic_complete>
    return 1;
    80001c68:	4505                	li	a0,1
    80001c6a:	b74d                	j	80001c0c <devintr+0x1e>
      virtio_disk_intr();
    80001c6c:	00004097          	auipc	ra,0x4
    80001c70:	9f6080e7          	jalr	-1546(ra) # 80005662 <virtio_disk_intr>
    80001c74:	b7ed                	j	80001c5e <devintr+0x70>
      e1000_intr();
    80001c76:	00004097          	auipc	ra,0x4
    80001c7a:	d30080e7          	jalr	-720(ra) # 800059a6 <e1000_intr>
    80001c7e:	b7c5                	j	80001c5e <devintr+0x70>
    if(cpuid() == 0){
    80001c80:	fffff097          	auipc	ra,0xfffff
    80001c84:	1f0080e7          	jalr	496(ra) # 80000e70 <cpuid>
    80001c88:	c901                	beqz	a0,80001c98 <devintr+0xaa>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001c8a:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001c8e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001c90:	14479073          	csrw	sip,a5
    return 2;
    80001c94:	4509                	li	a0,2
    80001c96:	bf9d                	j	80001c0c <devintr+0x1e>
      clockintr();
    80001c98:	00000097          	auipc	ra,0x0
    80001c9c:	f10080e7          	jalr	-240(ra) # 80001ba8 <clockintr>
    80001ca0:	b7ed                	j	80001c8a <devintr+0x9c>

0000000080001ca2 <usertrap>:
{
    80001ca2:	1101                	addi	sp,sp,-32
    80001ca4:	ec06                	sd	ra,24(sp)
    80001ca6:	e822                	sd	s0,16(sp)
    80001ca8:	e426                	sd	s1,8(sp)
    80001caa:	e04a                	sd	s2,0(sp)
    80001cac:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cae:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001cb2:	1007f793          	andi	a5,a5,256
    80001cb6:	e3b9                	bnez	a5,80001cfc <usertrap+0x5a>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cb8:	00003797          	auipc	a5,0x3
    80001cbc:	3d878793          	addi	a5,a5,984 # 80005090 <kernelvec>
    80001cc0:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001cc4:	fffff097          	auipc	ra,0xfffff
    80001cc8:	1d8080e7          	jalr	472(ra) # 80000e9c <myproc>
    80001ccc:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001cce:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001cd0:	14102773          	csrr	a4,sepc
    80001cd4:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cd6:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001cda:	47a1                	li	a5,8
    80001cdc:	02f70863          	beq	a4,a5,80001d0c <usertrap+0x6a>
  } else if((which_dev = devintr()) != 0){
    80001ce0:	00000097          	auipc	ra,0x0
    80001ce4:	f0e080e7          	jalr	-242(ra) # 80001bee <devintr>
    80001ce8:	892a                	mv	s2,a0
    80001cea:	c551                	beqz	a0,80001d76 <usertrap+0xd4>
  if(lockfree_read4(&p->killed))
    80001cec:	02848513          	addi	a0,s1,40
    80001cf0:	00005097          	auipc	ra,0x5
    80001cf4:	4ca080e7          	jalr	1226(ra) # 800071ba <lockfree_read4>
    80001cf8:	cd21                	beqz	a0,80001d50 <usertrap+0xae>
    80001cfa:	a0b1                	j	80001d46 <usertrap+0xa4>
    panic("usertrap: not from user mode");
    80001cfc:	00007517          	auipc	a0,0x7
    80001d00:	5ac50513          	addi	a0,a0,1452 # 800092a8 <states.0+0x58>
    80001d04:	00005097          	auipc	ra,0x5
    80001d08:	e6c080e7          	jalr	-404(ra) # 80006b70 <panic>
    if(lockfree_read4(&p->killed))
    80001d0c:	02850513          	addi	a0,a0,40
    80001d10:	00005097          	auipc	ra,0x5
    80001d14:	4aa080e7          	jalr	1194(ra) # 800071ba <lockfree_read4>
    80001d18:	e929                	bnez	a0,80001d6a <usertrap+0xc8>
    p->trapframe->epc += 4;
    80001d1a:	6cb8                	ld	a4,88(s1)
    80001d1c:	6f1c                	ld	a5,24(a4)
    80001d1e:	0791                	addi	a5,a5,4
    80001d20:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d22:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d26:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d2a:	10079073          	csrw	sstatus,a5
    syscall();
    80001d2e:	00000097          	auipc	ra,0x0
    80001d32:	2c8080e7          	jalr	712(ra) # 80001ff6 <syscall>
  if(lockfree_read4(&p->killed))
    80001d36:	02848513          	addi	a0,s1,40
    80001d3a:	00005097          	auipc	ra,0x5
    80001d3e:	480080e7          	jalr	1152(ra) # 800071ba <lockfree_read4>
    80001d42:	c911                	beqz	a0,80001d56 <usertrap+0xb4>
    80001d44:	4901                	li	s2,0
    exit(-1);
    80001d46:	557d                	li	a0,-1
    80001d48:	00000097          	auipc	ra,0x0
    80001d4c:	a74080e7          	jalr	-1420(ra) # 800017bc <exit>
  if(which_dev == 2)
    80001d50:	4789                	li	a5,2
    80001d52:	04f90c63          	beq	s2,a5,80001daa <usertrap+0x108>
  usertrapret();
    80001d56:	00000097          	auipc	ra,0x0
    80001d5a:	db4080e7          	jalr	-588(ra) # 80001b0a <usertrapret>
}
    80001d5e:	60e2                	ld	ra,24(sp)
    80001d60:	6442                	ld	s0,16(sp)
    80001d62:	64a2                	ld	s1,8(sp)
    80001d64:	6902                	ld	s2,0(sp)
    80001d66:	6105                	addi	sp,sp,32
    80001d68:	8082                	ret
      exit(-1);
    80001d6a:	557d                	li	a0,-1
    80001d6c:	00000097          	auipc	ra,0x0
    80001d70:	a50080e7          	jalr	-1456(ra) # 800017bc <exit>
    80001d74:	b75d                	j	80001d1a <usertrap+0x78>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d76:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001d7a:	5890                	lw	a2,48(s1)
    80001d7c:	00007517          	auipc	a0,0x7
    80001d80:	54c50513          	addi	a0,a0,1356 # 800092c8 <states.0+0x78>
    80001d84:	00005097          	auipc	ra,0x5
    80001d88:	e36080e7          	jalr	-458(ra) # 80006bba <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d8c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d90:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d94:	00007517          	auipc	a0,0x7
    80001d98:	56450513          	addi	a0,a0,1380 # 800092f8 <states.0+0xa8>
    80001d9c:	00005097          	auipc	ra,0x5
    80001da0:	e1e080e7          	jalr	-482(ra) # 80006bba <printf>
    p->killed = 1;
    80001da4:	4785                	li	a5,1
    80001da6:	d49c                	sw	a5,40(s1)
    80001da8:	b779                	j	80001d36 <usertrap+0x94>
    yield();
    80001daa:	fffff097          	auipc	ra,0xfffff
    80001dae:	77a080e7          	jalr	1914(ra) # 80001524 <yield>
    80001db2:	b755                	j	80001d56 <usertrap+0xb4>

0000000080001db4 <kerneltrap>:
{
    80001db4:	7179                	addi	sp,sp,-48
    80001db6:	f406                	sd	ra,40(sp)
    80001db8:	f022                	sd	s0,32(sp)
    80001dba:	ec26                	sd	s1,24(sp)
    80001dbc:	e84a                	sd	s2,16(sp)
    80001dbe:	e44e                	sd	s3,8(sp)
    80001dc0:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001dc2:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dc6:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001dca:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001dce:	1004f793          	andi	a5,s1,256
    80001dd2:	cb85                	beqz	a5,80001e02 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dd4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001dd8:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001dda:	ef85                	bnez	a5,80001e12 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001ddc:	00000097          	auipc	ra,0x0
    80001de0:	e12080e7          	jalr	-494(ra) # 80001bee <devintr>
    80001de4:	cd1d                	beqz	a0,80001e22 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001de6:	4789                	li	a5,2
    80001de8:	06f50a63          	beq	a0,a5,80001e5c <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001dec:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001df0:	10049073          	csrw	sstatus,s1
}
    80001df4:	70a2                	ld	ra,40(sp)
    80001df6:	7402                	ld	s0,32(sp)
    80001df8:	64e2                	ld	s1,24(sp)
    80001dfa:	6942                	ld	s2,16(sp)
    80001dfc:	69a2                	ld	s3,8(sp)
    80001dfe:	6145                	addi	sp,sp,48
    80001e00:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e02:	00007517          	auipc	a0,0x7
    80001e06:	51650513          	addi	a0,a0,1302 # 80009318 <states.0+0xc8>
    80001e0a:	00005097          	auipc	ra,0x5
    80001e0e:	d66080e7          	jalr	-666(ra) # 80006b70 <panic>
    panic("kerneltrap: interrupts enabled");
    80001e12:	00007517          	auipc	a0,0x7
    80001e16:	52e50513          	addi	a0,a0,1326 # 80009340 <states.0+0xf0>
    80001e1a:	00005097          	auipc	ra,0x5
    80001e1e:	d56080e7          	jalr	-682(ra) # 80006b70 <panic>
    printf("scause %p\n", scause);
    80001e22:	85ce                	mv	a1,s3
    80001e24:	00007517          	auipc	a0,0x7
    80001e28:	53c50513          	addi	a0,a0,1340 # 80009360 <states.0+0x110>
    80001e2c:	00005097          	auipc	ra,0x5
    80001e30:	d8e080e7          	jalr	-626(ra) # 80006bba <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e34:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e38:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e3c:	00007517          	auipc	a0,0x7
    80001e40:	53450513          	addi	a0,a0,1332 # 80009370 <states.0+0x120>
    80001e44:	00005097          	auipc	ra,0x5
    80001e48:	d76080e7          	jalr	-650(ra) # 80006bba <printf>
    panic("kerneltrap");
    80001e4c:	00007517          	auipc	a0,0x7
    80001e50:	53c50513          	addi	a0,a0,1340 # 80009388 <states.0+0x138>
    80001e54:	00005097          	auipc	ra,0x5
    80001e58:	d1c080e7          	jalr	-740(ra) # 80006b70 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e5c:	fffff097          	auipc	ra,0xfffff
    80001e60:	040080e7          	jalr	64(ra) # 80000e9c <myproc>
    80001e64:	d541                	beqz	a0,80001dec <kerneltrap+0x38>
    80001e66:	fffff097          	auipc	ra,0xfffff
    80001e6a:	036080e7          	jalr	54(ra) # 80000e9c <myproc>
    80001e6e:	4d18                	lw	a4,24(a0)
    80001e70:	4791                	li	a5,4
    80001e72:	f6f71de3          	bne	a4,a5,80001dec <kerneltrap+0x38>
    yield();
    80001e76:	fffff097          	auipc	ra,0xfffff
    80001e7a:	6ae080e7          	jalr	1710(ra) # 80001524 <yield>
    80001e7e:	b7bd                	j	80001dec <kerneltrap+0x38>

0000000080001e80 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001e80:	1101                	addi	sp,sp,-32
    80001e82:	ec06                	sd	ra,24(sp)
    80001e84:	e822                	sd	s0,16(sp)
    80001e86:	e426                	sd	s1,8(sp)
    80001e88:	1000                	addi	s0,sp,32
    80001e8a:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001e8c:	fffff097          	auipc	ra,0xfffff
    80001e90:	010080e7          	jalr	16(ra) # 80000e9c <myproc>
  switch (n) {
    80001e94:	4795                	li	a5,5
    80001e96:	0497e163          	bltu	a5,s1,80001ed8 <argraw+0x58>
    80001e9a:	048a                	slli	s1,s1,0x2
    80001e9c:	00007717          	auipc	a4,0x7
    80001ea0:	52470713          	addi	a4,a4,1316 # 800093c0 <states.0+0x170>
    80001ea4:	94ba                	add	s1,s1,a4
    80001ea6:	409c                	lw	a5,0(s1)
    80001ea8:	97ba                	add	a5,a5,a4
    80001eaa:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001eac:	6d3c                	ld	a5,88(a0)
    80001eae:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001eb0:	60e2                	ld	ra,24(sp)
    80001eb2:	6442                	ld	s0,16(sp)
    80001eb4:	64a2                	ld	s1,8(sp)
    80001eb6:	6105                	addi	sp,sp,32
    80001eb8:	8082                	ret
    return p->trapframe->a1;
    80001eba:	6d3c                	ld	a5,88(a0)
    80001ebc:	7fa8                	ld	a0,120(a5)
    80001ebe:	bfcd                	j	80001eb0 <argraw+0x30>
    return p->trapframe->a2;
    80001ec0:	6d3c                	ld	a5,88(a0)
    80001ec2:	63c8                	ld	a0,128(a5)
    80001ec4:	b7f5                	j	80001eb0 <argraw+0x30>
    return p->trapframe->a3;
    80001ec6:	6d3c                	ld	a5,88(a0)
    80001ec8:	67c8                	ld	a0,136(a5)
    80001eca:	b7dd                	j	80001eb0 <argraw+0x30>
    return p->trapframe->a4;
    80001ecc:	6d3c                	ld	a5,88(a0)
    80001ece:	6bc8                	ld	a0,144(a5)
    80001ed0:	b7c5                	j	80001eb0 <argraw+0x30>
    return p->trapframe->a5;
    80001ed2:	6d3c                	ld	a5,88(a0)
    80001ed4:	6fc8                	ld	a0,152(a5)
    80001ed6:	bfe9                	j	80001eb0 <argraw+0x30>
  panic("argraw");
    80001ed8:	00007517          	auipc	a0,0x7
    80001edc:	4c050513          	addi	a0,a0,1216 # 80009398 <states.0+0x148>
    80001ee0:	00005097          	auipc	ra,0x5
    80001ee4:	c90080e7          	jalr	-880(ra) # 80006b70 <panic>

0000000080001ee8 <fetchaddr>:
{
    80001ee8:	1101                	addi	sp,sp,-32
    80001eea:	ec06                	sd	ra,24(sp)
    80001eec:	e822                	sd	s0,16(sp)
    80001eee:	e426                	sd	s1,8(sp)
    80001ef0:	e04a                	sd	s2,0(sp)
    80001ef2:	1000                	addi	s0,sp,32
    80001ef4:	84aa                	mv	s1,a0
    80001ef6:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001ef8:	fffff097          	auipc	ra,0xfffff
    80001efc:	fa4080e7          	jalr	-92(ra) # 80000e9c <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001f00:	653c                	ld	a5,72(a0)
    80001f02:	02f4f863          	bgeu	s1,a5,80001f32 <fetchaddr+0x4a>
    80001f06:	00848713          	addi	a4,s1,8
    80001f0a:	02e7e663          	bltu	a5,a4,80001f36 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f0e:	46a1                	li	a3,8
    80001f10:	8626                	mv	a2,s1
    80001f12:	85ca                	mv	a1,s2
    80001f14:	6928                	ld	a0,80(a0)
    80001f16:	fffff097          	auipc	ra,0xfffff
    80001f1a:	cda080e7          	jalr	-806(ra) # 80000bf0 <copyin>
    80001f1e:	00a03533          	snez	a0,a0
    80001f22:	40a00533          	neg	a0,a0
}
    80001f26:	60e2                	ld	ra,24(sp)
    80001f28:	6442                	ld	s0,16(sp)
    80001f2a:	64a2                	ld	s1,8(sp)
    80001f2c:	6902                	ld	s2,0(sp)
    80001f2e:	6105                	addi	sp,sp,32
    80001f30:	8082                	ret
    return -1;
    80001f32:	557d                	li	a0,-1
    80001f34:	bfcd                	j	80001f26 <fetchaddr+0x3e>
    80001f36:	557d                	li	a0,-1
    80001f38:	b7fd                	j	80001f26 <fetchaddr+0x3e>

0000000080001f3a <fetchstr>:
{
    80001f3a:	7179                	addi	sp,sp,-48
    80001f3c:	f406                	sd	ra,40(sp)
    80001f3e:	f022                	sd	s0,32(sp)
    80001f40:	ec26                	sd	s1,24(sp)
    80001f42:	e84a                	sd	s2,16(sp)
    80001f44:	e44e                	sd	s3,8(sp)
    80001f46:	1800                	addi	s0,sp,48
    80001f48:	892a                	mv	s2,a0
    80001f4a:	84ae                	mv	s1,a1
    80001f4c:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f4e:	fffff097          	auipc	ra,0xfffff
    80001f52:	f4e080e7          	jalr	-178(ra) # 80000e9c <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001f56:	86ce                	mv	a3,s3
    80001f58:	864a                	mv	a2,s2
    80001f5a:	85a6                	mv	a1,s1
    80001f5c:	6928                	ld	a0,80(a0)
    80001f5e:	fffff097          	auipc	ra,0xfffff
    80001f62:	d20080e7          	jalr	-736(ra) # 80000c7e <copyinstr>
  if(err < 0)
    80001f66:	00054763          	bltz	a0,80001f74 <fetchstr+0x3a>
  return strlen(buf);
    80001f6a:	8526                	mv	a0,s1
    80001f6c:	ffffe097          	auipc	ra,0xffffe
    80001f70:	38a080e7          	jalr	906(ra) # 800002f6 <strlen>
}
    80001f74:	70a2                	ld	ra,40(sp)
    80001f76:	7402                	ld	s0,32(sp)
    80001f78:	64e2                	ld	s1,24(sp)
    80001f7a:	6942                	ld	s2,16(sp)
    80001f7c:	69a2                	ld	s3,8(sp)
    80001f7e:	6145                	addi	sp,sp,48
    80001f80:	8082                	ret

0000000080001f82 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001f82:	1101                	addi	sp,sp,-32
    80001f84:	ec06                	sd	ra,24(sp)
    80001f86:	e822                	sd	s0,16(sp)
    80001f88:	e426                	sd	s1,8(sp)
    80001f8a:	1000                	addi	s0,sp,32
    80001f8c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f8e:	00000097          	auipc	ra,0x0
    80001f92:	ef2080e7          	jalr	-270(ra) # 80001e80 <argraw>
    80001f96:	c088                	sw	a0,0(s1)
  return 0;
}
    80001f98:	4501                	li	a0,0
    80001f9a:	60e2                	ld	ra,24(sp)
    80001f9c:	6442                	ld	s0,16(sp)
    80001f9e:	64a2                	ld	s1,8(sp)
    80001fa0:	6105                	addi	sp,sp,32
    80001fa2:	8082                	ret

0000000080001fa4 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80001fa4:	1101                	addi	sp,sp,-32
    80001fa6:	ec06                	sd	ra,24(sp)
    80001fa8:	e822                	sd	s0,16(sp)
    80001faa:	e426                	sd	s1,8(sp)
    80001fac:	1000                	addi	s0,sp,32
    80001fae:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fb0:	00000097          	auipc	ra,0x0
    80001fb4:	ed0080e7          	jalr	-304(ra) # 80001e80 <argraw>
    80001fb8:	e088                	sd	a0,0(s1)
  return 0;
}
    80001fba:	4501                	li	a0,0
    80001fbc:	60e2                	ld	ra,24(sp)
    80001fbe:	6442                	ld	s0,16(sp)
    80001fc0:	64a2                	ld	s1,8(sp)
    80001fc2:	6105                	addi	sp,sp,32
    80001fc4:	8082                	ret

0000000080001fc6 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001fc6:	1101                	addi	sp,sp,-32
    80001fc8:	ec06                	sd	ra,24(sp)
    80001fca:	e822                	sd	s0,16(sp)
    80001fcc:	e426                	sd	s1,8(sp)
    80001fce:	e04a                	sd	s2,0(sp)
    80001fd0:	1000                	addi	s0,sp,32
    80001fd2:	84ae                	mv	s1,a1
    80001fd4:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001fd6:	00000097          	auipc	ra,0x0
    80001fda:	eaa080e7          	jalr	-342(ra) # 80001e80 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80001fde:	864a                	mv	a2,s2
    80001fe0:	85a6                	mv	a1,s1
    80001fe2:	00000097          	auipc	ra,0x0
    80001fe6:	f58080e7          	jalr	-168(ra) # 80001f3a <fetchstr>
}
    80001fea:	60e2                	ld	ra,24(sp)
    80001fec:	6442                	ld	s0,16(sp)
    80001fee:	64a2                	ld	s1,8(sp)
    80001ff0:	6902                	ld	s2,0(sp)
    80001ff2:	6105                	addi	sp,sp,32
    80001ff4:	8082                	ret

0000000080001ff6 <syscall>:



void
syscall(void)
{
    80001ff6:	1101                	addi	sp,sp,-32
    80001ff8:	ec06                	sd	ra,24(sp)
    80001ffa:	e822                	sd	s0,16(sp)
    80001ffc:	e426                	sd	s1,8(sp)
    80001ffe:	e04a                	sd	s2,0(sp)
    80002000:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002002:	fffff097          	auipc	ra,0xfffff
    80002006:	e9a080e7          	jalr	-358(ra) # 80000e9c <myproc>
    8000200a:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    8000200c:	05853903          	ld	s2,88(a0)
    80002010:	0a893783          	ld	a5,168(s2)
    80002014:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002018:	37fd                	addiw	a5,a5,-1
    8000201a:	4771                	li	a4,28
    8000201c:	00f76f63          	bltu	a4,a5,8000203a <syscall+0x44>
    80002020:	00369713          	slli	a4,a3,0x3
    80002024:	00007797          	auipc	a5,0x7
    80002028:	3b478793          	addi	a5,a5,948 # 800093d8 <syscalls>
    8000202c:	97ba                	add	a5,a5,a4
    8000202e:	639c                	ld	a5,0(a5)
    80002030:	c789                	beqz	a5,8000203a <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002032:	9782                	jalr	a5
    80002034:	06a93823          	sd	a0,112(s2)
    80002038:	a839                	j	80002056 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    8000203a:	15848613          	addi	a2,s1,344
    8000203e:	588c                	lw	a1,48(s1)
    80002040:	00007517          	auipc	a0,0x7
    80002044:	36050513          	addi	a0,a0,864 # 800093a0 <states.0+0x150>
    80002048:	00005097          	auipc	ra,0x5
    8000204c:	b72080e7          	jalr	-1166(ra) # 80006bba <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002050:	6cbc                	ld	a5,88(s1)
    80002052:	577d                	li	a4,-1
    80002054:	fbb8                	sd	a4,112(a5)
  }
}
    80002056:	60e2                	ld	ra,24(sp)
    80002058:	6442                	ld	s0,16(sp)
    8000205a:	64a2                	ld	s1,8(sp)
    8000205c:	6902                	ld	s2,0(sp)
    8000205e:	6105                	addi	sp,sp,32
    80002060:	8082                	ret

0000000080002062 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002062:	1101                	addi	sp,sp,-32
    80002064:	ec06                	sd	ra,24(sp)
    80002066:	e822                	sd	s0,16(sp)
    80002068:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    8000206a:	fec40593          	addi	a1,s0,-20
    8000206e:	4501                	li	a0,0
    80002070:	00000097          	auipc	ra,0x0
    80002074:	f12080e7          	jalr	-238(ra) # 80001f82 <argint>
    return -1;
    80002078:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    8000207a:	00054963          	bltz	a0,8000208c <sys_exit+0x2a>
  exit(n);
    8000207e:	fec42503          	lw	a0,-20(s0)
    80002082:	fffff097          	auipc	ra,0xfffff
    80002086:	73a080e7          	jalr	1850(ra) # 800017bc <exit>
  return 0;  // not reached
    8000208a:	4781                	li	a5,0
}
    8000208c:	853e                	mv	a0,a5
    8000208e:	60e2                	ld	ra,24(sp)
    80002090:	6442                	ld	s0,16(sp)
    80002092:	6105                	addi	sp,sp,32
    80002094:	8082                	ret

0000000080002096 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002096:	1141                	addi	sp,sp,-16
    80002098:	e406                	sd	ra,8(sp)
    8000209a:	e022                	sd	s0,0(sp)
    8000209c:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000209e:	fffff097          	auipc	ra,0xfffff
    800020a2:	dfe080e7          	jalr	-514(ra) # 80000e9c <myproc>
}
    800020a6:	5908                	lw	a0,48(a0)
    800020a8:	60a2                	ld	ra,8(sp)
    800020aa:	6402                	ld	s0,0(sp)
    800020ac:	0141                	addi	sp,sp,16
    800020ae:	8082                	ret

00000000800020b0 <sys_fork>:

uint64
sys_fork(void)
{
    800020b0:	1141                	addi	sp,sp,-16
    800020b2:	e406                	sd	ra,8(sp)
    800020b4:	e022                	sd	s0,0(sp)
    800020b6:	0800                	addi	s0,sp,16
  return fork();
    800020b8:	fffff097          	auipc	ra,0xfffff
    800020bc:	1b6080e7          	jalr	438(ra) # 8000126e <fork>
}
    800020c0:	60a2                	ld	ra,8(sp)
    800020c2:	6402                	ld	s0,0(sp)
    800020c4:	0141                	addi	sp,sp,16
    800020c6:	8082                	ret

00000000800020c8 <sys_wait>:

uint64
sys_wait(void)
{
    800020c8:	1101                	addi	sp,sp,-32
    800020ca:	ec06                	sd	ra,24(sp)
    800020cc:	e822                	sd	s0,16(sp)
    800020ce:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    800020d0:	fe840593          	addi	a1,s0,-24
    800020d4:	4501                	li	a0,0
    800020d6:	00000097          	auipc	ra,0x0
    800020da:	ece080e7          	jalr	-306(ra) # 80001fa4 <argaddr>
    800020de:	87aa                	mv	a5,a0
    return -1;
    800020e0:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    800020e2:	0007c863          	bltz	a5,800020f2 <sys_wait+0x2a>
  return wait(p);
    800020e6:	fe843503          	ld	a0,-24(s0)
    800020ea:	fffff097          	auipc	ra,0xfffff
    800020ee:	4da080e7          	jalr	1242(ra) # 800015c4 <wait>
}
    800020f2:	60e2                	ld	ra,24(sp)
    800020f4:	6442                	ld	s0,16(sp)
    800020f6:	6105                	addi	sp,sp,32
    800020f8:	8082                	ret

00000000800020fa <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800020fa:	7179                	addi	sp,sp,-48
    800020fc:	f406                	sd	ra,40(sp)
    800020fe:	f022                	sd	s0,32(sp)
    80002100:	ec26                	sd	s1,24(sp)
    80002102:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002104:	fdc40593          	addi	a1,s0,-36
    80002108:	4501                	li	a0,0
    8000210a:	00000097          	auipc	ra,0x0
    8000210e:	e78080e7          	jalr	-392(ra) # 80001f82 <argint>
    80002112:	87aa                	mv	a5,a0
    return -1;
    80002114:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002116:	0207c063          	bltz	a5,80002136 <sys_sbrk+0x3c>
  addr = myproc()->sz;
    8000211a:	fffff097          	auipc	ra,0xfffff
    8000211e:	d82080e7          	jalr	-638(ra) # 80000e9c <myproc>
    80002122:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002124:	fdc42503          	lw	a0,-36(s0)
    80002128:	fffff097          	auipc	ra,0xfffff
    8000212c:	0ce080e7          	jalr	206(ra) # 800011f6 <growproc>
    80002130:	00054863          	bltz	a0,80002140 <sys_sbrk+0x46>
    return -1;
  return addr;
    80002134:	8526                	mv	a0,s1
}
    80002136:	70a2                	ld	ra,40(sp)
    80002138:	7402                	ld	s0,32(sp)
    8000213a:	64e2                	ld	s1,24(sp)
    8000213c:	6145                	addi	sp,sp,48
    8000213e:	8082                	ret
    return -1;
    80002140:	557d                	li	a0,-1
    80002142:	bfd5                	j	80002136 <sys_sbrk+0x3c>

0000000080002144 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002144:	7139                	addi	sp,sp,-64
    80002146:	fc06                	sd	ra,56(sp)
    80002148:	f822                	sd	s0,48(sp)
    8000214a:	f426                	sd	s1,40(sp)
    8000214c:	f04a                	sd	s2,32(sp)
    8000214e:	ec4e                	sd	s3,24(sp)
    80002150:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002152:	fcc40593          	addi	a1,s0,-52
    80002156:	4501                	li	a0,0
    80002158:	00000097          	auipc	ra,0x0
    8000215c:	e2a080e7          	jalr	-470(ra) # 80001f82 <argint>
    return -1;
    80002160:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002162:	06054563          	bltz	a0,800021cc <sys_sleep+0x88>
  acquire(&tickslock);
    80002166:	0000e517          	auipc	a0,0xe
    8000216a:	d3a50513          	addi	a0,a0,-710 # 8000fea0 <tickslock>
    8000216e:	00005097          	auipc	ra,0x5
    80002172:	f3a080e7          	jalr	-198(ra) # 800070a8 <acquire>
  ticks0 = ticks;
    80002176:	00008917          	auipc	s2,0x8
    8000217a:	ea292903          	lw	s2,-350(s2) # 8000a018 <ticks>
  while(ticks - ticks0 < n){
    8000217e:	fcc42783          	lw	a5,-52(s0)
    80002182:	cf85                	beqz	a5,800021ba <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002184:	0000e997          	auipc	s3,0xe
    80002188:	d1c98993          	addi	s3,s3,-740 # 8000fea0 <tickslock>
    8000218c:	00008497          	auipc	s1,0x8
    80002190:	e8c48493          	addi	s1,s1,-372 # 8000a018 <ticks>
    if(myproc()->killed){
    80002194:	fffff097          	auipc	ra,0xfffff
    80002198:	d08080e7          	jalr	-760(ra) # 80000e9c <myproc>
    8000219c:	551c                	lw	a5,40(a0)
    8000219e:	ef9d                	bnez	a5,800021dc <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800021a0:	85ce                	mv	a1,s3
    800021a2:	8526                	mv	a0,s1
    800021a4:	fffff097          	auipc	ra,0xfffff
    800021a8:	3bc080e7          	jalr	956(ra) # 80001560 <sleep>
  while(ticks - ticks0 < n){
    800021ac:	409c                	lw	a5,0(s1)
    800021ae:	412787bb          	subw	a5,a5,s2
    800021b2:	fcc42703          	lw	a4,-52(s0)
    800021b6:	fce7efe3          	bltu	a5,a4,80002194 <sys_sleep+0x50>
  }
  release(&tickslock);
    800021ba:	0000e517          	auipc	a0,0xe
    800021be:	ce650513          	addi	a0,a0,-794 # 8000fea0 <tickslock>
    800021c2:	00005097          	auipc	ra,0x5
    800021c6:	f9a080e7          	jalr	-102(ra) # 8000715c <release>
  return 0;
    800021ca:	4781                	li	a5,0
}
    800021cc:	853e                	mv	a0,a5
    800021ce:	70e2                	ld	ra,56(sp)
    800021d0:	7442                	ld	s0,48(sp)
    800021d2:	74a2                	ld	s1,40(sp)
    800021d4:	7902                	ld	s2,32(sp)
    800021d6:	69e2                	ld	s3,24(sp)
    800021d8:	6121                	addi	sp,sp,64
    800021da:	8082                	ret
      release(&tickslock);
    800021dc:	0000e517          	auipc	a0,0xe
    800021e0:	cc450513          	addi	a0,a0,-828 # 8000fea0 <tickslock>
    800021e4:	00005097          	auipc	ra,0x5
    800021e8:	f78080e7          	jalr	-136(ra) # 8000715c <release>
      return -1;
    800021ec:	57fd                	li	a5,-1
    800021ee:	bff9                	j	800021cc <sys_sleep+0x88>

00000000800021f0 <sys_kill>:

uint64
sys_kill(void)
{
    800021f0:	1101                	addi	sp,sp,-32
    800021f2:	ec06                	sd	ra,24(sp)
    800021f4:	e822                	sd	s0,16(sp)
    800021f6:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    800021f8:	fec40593          	addi	a1,s0,-20
    800021fc:	4501                	li	a0,0
    800021fe:	00000097          	auipc	ra,0x0
    80002202:	d84080e7          	jalr	-636(ra) # 80001f82 <argint>
    80002206:	87aa                	mv	a5,a0
    return -1;
    80002208:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    8000220a:	0007c863          	bltz	a5,8000221a <sys_kill+0x2a>
  return kill(pid);
    8000220e:	fec42503          	lw	a0,-20(s0)
    80002212:	fffff097          	auipc	ra,0xfffff
    80002216:	680080e7          	jalr	1664(ra) # 80001892 <kill>
}
    8000221a:	60e2                	ld	ra,24(sp)
    8000221c:	6442                	ld	s0,16(sp)
    8000221e:	6105                	addi	sp,sp,32
    80002220:	8082                	ret

0000000080002222 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002222:	1101                	addi	sp,sp,-32
    80002224:	ec06                	sd	ra,24(sp)
    80002226:	e822                	sd	s0,16(sp)
    80002228:	e426                	sd	s1,8(sp)
    8000222a:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000222c:	0000e517          	auipc	a0,0xe
    80002230:	c7450513          	addi	a0,a0,-908 # 8000fea0 <tickslock>
    80002234:	00005097          	auipc	ra,0x5
    80002238:	e74080e7          	jalr	-396(ra) # 800070a8 <acquire>
  xticks = ticks;
    8000223c:	00008497          	auipc	s1,0x8
    80002240:	ddc4a483          	lw	s1,-548(s1) # 8000a018 <ticks>
  release(&tickslock);
    80002244:	0000e517          	auipc	a0,0xe
    80002248:	c5c50513          	addi	a0,a0,-932 # 8000fea0 <tickslock>
    8000224c:	00005097          	auipc	ra,0x5
    80002250:	f10080e7          	jalr	-240(ra) # 8000715c <release>
  return xticks;
}
    80002254:	02049513          	slli	a0,s1,0x20
    80002258:	9101                	srli	a0,a0,0x20
    8000225a:	60e2                	ld	ra,24(sp)
    8000225c:	6442                	ld	s0,16(sp)
    8000225e:	64a2                	ld	s1,8(sp)
    80002260:	6105                	addi	sp,sp,32
    80002262:	8082                	ret

0000000080002264 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002264:	7179                	addi	sp,sp,-48
    80002266:	f406                	sd	ra,40(sp)
    80002268:	f022                	sd	s0,32(sp)
    8000226a:	ec26                	sd	s1,24(sp)
    8000226c:	e84a                	sd	s2,16(sp)
    8000226e:	e44e                	sd	s3,8(sp)
    80002270:	e052                	sd	s4,0(sp)
    80002272:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002274:	00007597          	auipc	a1,0x7
    80002278:	25458593          	addi	a1,a1,596 # 800094c8 <syscalls+0xf0>
    8000227c:	0000e517          	auipc	a0,0xe
    80002280:	c3c50513          	addi	a0,a0,-964 # 8000feb8 <bcache>
    80002284:	00005097          	auipc	ra,0x5
    80002288:	d94080e7          	jalr	-620(ra) # 80007018 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000228c:	00016797          	auipc	a5,0x16
    80002290:	c2c78793          	addi	a5,a5,-980 # 80017eb8 <bcache+0x8000>
    80002294:	00016717          	auipc	a4,0x16
    80002298:	e8c70713          	addi	a4,a4,-372 # 80018120 <bcache+0x8268>
    8000229c:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800022a0:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800022a4:	0000e497          	auipc	s1,0xe
    800022a8:	c2c48493          	addi	s1,s1,-980 # 8000fed0 <bcache+0x18>
    b->next = bcache.head.next;
    800022ac:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800022ae:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800022b0:	00007a17          	auipc	s4,0x7
    800022b4:	220a0a13          	addi	s4,s4,544 # 800094d0 <syscalls+0xf8>
    b->next = bcache.head.next;
    800022b8:	2b893783          	ld	a5,696(s2)
    800022bc:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800022be:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800022c2:	85d2                	mv	a1,s4
    800022c4:	01048513          	addi	a0,s1,16
    800022c8:	00001097          	auipc	ra,0x1
    800022cc:	4c2080e7          	jalr	1218(ra) # 8000378a <initsleeplock>
    bcache.head.next->prev = b;
    800022d0:	2b893783          	ld	a5,696(s2)
    800022d4:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800022d6:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800022da:	45848493          	addi	s1,s1,1112
    800022de:	fd349de3          	bne	s1,s3,800022b8 <binit+0x54>
  }
}
    800022e2:	70a2                	ld	ra,40(sp)
    800022e4:	7402                	ld	s0,32(sp)
    800022e6:	64e2                	ld	s1,24(sp)
    800022e8:	6942                	ld	s2,16(sp)
    800022ea:	69a2                	ld	s3,8(sp)
    800022ec:	6a02                	ld	s4,0(sp)
    800022ee:	6145                	addi	sp,sp,48
    800022f0:	8082                	ret

00000000800022f2 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800022f2:	7179                	addi	sp,sp,-48
    800022f4:	f406                	sd	ra,40(sp)
    800022f6:	f022                	sd	s0,32(sp)
    800022f8:	ec26                	sd	s1,24(sp)
    800022fa:	e84a                	sd	s2,16(sp)
    800022fc:	e44e                	sd	s3,8(sp)
    800022fe:	1800                	addi	s0,sp,48
    80002300:	892a                	mv	s2,a0
    80002302:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002304:	0000e517          	auipc	a0,0xe
    80002308:	bb450513          	addi	a0,a0,-1100 # 8000feb8 <bcache>
    8000230c:	00005097          	auipc	ra,0x5
    80002310:	d9c080e7          	jalr	-612(ra) # 800070a8 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002314:	00016497          	auipc	s1,0x16
    80002318:	e5c4b483          	ld	s1,-420(s1) # 80018170 <bcache+0x82b8>
    8000231c:	00016797          	auipc	a5,0x16
    80002320:	e0478793          	addi	a5,a5,-508 # 80018120 <bcache+0x8268>
    80002324:	02f48f63          	beq	s1,a5,80002362 <bread+0x70>
    80002328:	873e                	mv	a4,a5
    8000232a:	a021                	j	80002332 <bread+0x40>
    8000232c:	68a4                	ld	s1,80(s1)
    8000232e:	02e48a63          	beq	s1,a4,80002362 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002332:	449c                	lw	a5,8(s1)
    80002334:	ff279ce3          	bne	a5,s2,8000232c <bread+0x3a>
    80002338:	44dc                	lw	a5,12(s1)
    8000233a:	ff3799e3          	bne	a5,s3,8000232c <bread+0x3a>
      b->refcnt++;
    8000233e:	40bc                	lw	a5,64(s1)
    80002340:	2785                	addiw	a5,a5,1
    80002342:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002344:	0000e517          	auipc	a0,0xe
    80002348:	b7450513          	addi	a0,a0,-1164 # 8000feb8 <bcache>
    8000234c:	00005097          	auipc	ra,0x5
    80002350:	e10080e7          	jalr	-496(ra) # 8000715c <release>
      acquiresleep(&b->lock);
    80002354:	01048513          	addi	a0,s1,16
    80002358:	00001097          	auipc	ra,0x1
    8000235c:	46c080e7          	jalr	1132(ra) # 800037c4 <acquiresleep>
      return b;
    80002360:	a8b9                	j	800023be <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002362:	00016497          	auipc	s1,0x16
    80002366:	e064b483          	ld	s1,-506(s1) # 80018168 <bcache+0x82b0>
    8000236a:	00016797          	auipc	a5,0x16
    8000236e:	db678793          	addi	a5,a5,-586 # 80018120 <bcache+0x8268>
    80002372:	00f48863          	beq	s1,a5,80002382 <bread+0x90>
    80002376:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002378:	40bc                	lw	a5,64(s1)
    8000237a:	cf81                	beqz	a5,80002392 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000237c:	64a4                	ld	s1,72(s1)
    8000237e:	fee49de3          	bne	s1,a4,80002378 <bread+0x86>
  panic("bget: no buffers");
    80002382:	00007517          	auipc	a0,0x7
    80002386:	15650513          	addi	a0,a0,342 # 800094d8 <syscalls+0x100>
    8000238a:	00004097          	auipc	ra,0x4
    8000238e:	7e6080e7          	jalr	2022(ra) # 80006b70 <panic>
      b->dev = dev;
    80002392:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002396:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    8000239a:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000239e:	4785                	li	a5,1
    800023a0:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800023a2:	0000e517          	auipc	a0,0xe
    800023a6:	b1650513          	addi	a0,a0,-1258 # 8000feb8 <bcache>
    800023aa:	00005097          	auipc	ra,0x5
    800023ae:	db2080e7          	jalr	-590(ra) # 8000715c <release>
      acquiresleep(&b->lock);
    800023b2:	01048513          	addi	a0,s1,16
    800023b6:	00001097          	auipc	ra,0x1
    800023ba:	40e080e7          	jalr	1038(ra) # 800037c4 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800023be:	409c                	lw	a5,0(s1)
    800023c0:	cb89                	beqz	a5,800023d2 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800023c2:	8526                	mv	a0,s1
    800023c4:	70a2                	ld	ra,40(sp)
    800023c6:	7402                	ld	s0,32(sp)
    800023c8:	64e2                	ld	s1,24(sp)
    800023ca:	6942                	ld	s2,16(sp)
    800023cc:	69a2                	ld	s3,8(sp)
    800023ce:	6145                	addi	sp,sp,48
    800023d0:	8082                	ret
    virtio_disk_rw(b, 0);
    800023d2:	4581                	li	a1,0
    800023d4:	8526                	mv	a0,s1
    800023d6:	00003097          	auipc	ra,0x3
    800023da:	006080e7          	jalr	6(ra) # 800053dc <virtio_disk_rw>
    b->valid = 1;
    800023de:	4785                	li	a5,1
    800023e0:	c09c                	sw	a5,0(s1)
  return b;
    800023e2:	b7c5                	j	800023c2 <bread+0xd0>

00000000800023e4 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800023e4:	1101                	addi	sp,sp,-32
    800023e6:	ec06                	sd	ra,24(sp)
    800023e8:	e822                	sd	s0,16(sp)
    800023ea:	e426                	sd	s1,8(sp)
    800023ec:	1000                	addi	s0,sp,32
    800023ee:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800023f0:	0541                	addi	a0,a0,16
    800023f2:	00001097          	auipc	ra,0x1
    800023f6:	46c080e7          	jalr	1132(ra) # 8000385e <holdingsleep>
    800023fa:	cd01                	beqz	a0,80002412 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800023fc:	4585                	li	a1,1
    800023fe:	8526                	mv	a0,s1
    80002400:	00003097          	auipc	ra,0x3
    80002404:	fdc080e7          	jalr	-36(ra) # 800053dc <virtio_disk_rw>
}
    80002408:	60e2                	ld	ra,24(sp)
    8000240a:	6442                	ld	s0,16(sp)
    8000240c:	64a2                	ld	s1,8(sp)
    8000240e:	6105                	addi	sp,sp,32
    80002410:	8082                	ret
    panic("bwrite");
    80002412:	00007517          	auipc	a0,0x7
    80002416:	0de50513          	addi	a0,a0,222 # 800094f0 <syscalls+0x118>
    8000241a:	00004097          	auipc	ra,0x4
    8000241e:	756080e7          	jalr	1878(ra) # 80006b70 <panic>

0000000080002422 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002422:	1101                	addi	sp,sp,-32
    80002424:	ec06                	sd	ra,24(sp)
    80002426:	e822                	sd	s0,16(sp)
    80002428:	e426                	sd	s1,8(sp)
    8000242a:	e04a                	sd	s2,0(sp)
    8000242c:	1000                	addi	s0,sp,32
    8000242e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002430:	01050913          	addi	s2,a0,16
    80002434:	854a                	mv	a0,s2
    80002436:	00001097          	auipc	ra,0x1
    8000243a:	428080e7          	jalr	1064(ra) # 8000385e <holdingsleep>
    8000243e:	c92d                	beqz	a0,800024b0 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002440:	854a                	mv	a0,s2
    80002442:	00001097          	auipc	ra,0x1
    80002446:	3d8080e7          	jalr	984(ra) # 8000381a <releasesleep>

  acquire(&bcache.lock);
    8000244a:	0000e517          	auipc	a0,0xe
    8000244e:	a6e50513          	addi	a0,a0,-1426 # 8000feb8 <bcache>
    80002452:	00005097          	auipc	ra,0x5
    80002456:	c56080e7          	jalr	-938(ra) # 800070a8 <acquire>
  b->refcnt--;
    8000245a:	40bc                	lw	a5,64(s1)
    8000245c:	37fd                	addiw	a5,a5,-1
    8000245e:	0007871b          	sext.w	a4,a5
    80002462:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002464:	eb05                	bnez	a4,80002494 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002466:	68bc                	ld	a5,80(s1)
    80002468:	64b8                	ld	a4,72(s1)
    8000246a:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    8000246c:	64bc                	ld	a5,72(s1)
    8000246e:	68b8                	ld	a4,80(s1)
    80002470:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002472:	00016797          	auipc	a5,0x16
    80002476:	a4678793          	addi	a5,a5,-1466 # 80017eb8 <bcache+0x8000>
    8000247a:	2b87b703          	ld	a4,696(a5)
    8000247e:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002480:	00016717          	auipc	a4,0x16
    80002484:	ca070713          	addi	a4,a4,-864 # 80018120 <bcache+0x8268>
    80002488:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000248a:	2b87b703          	ld	a4,696(a5)
    8000248e:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002490:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002494:	0000e517          	auipc	a0,0xe
    80002498:	a2450513          	addi	a0,a0,-1500 # 8000feb8 <bcache>
    8000249c:	00005097          	auipc	ra,0x5
    800024a0:	cc0080e7          	jalr	-832(ra) # 8000715c <release>
}
    800024a4:	60e2                	ld	ra,24(sp)
    800024a6:	6442                	ld	s0,16(sp)
    800024a8:	64a2                	ld	s1,8(sp)
    800024aa:	6902                	ld	s2,0(sp)
    800024ac:	6105                	addi	sp,sp,32
    800024ae:	8082                	ret
    panic("brelse");
    800024b0:	00007517          	auipc	a0,0x7
    800024b4:	04850513          	addi	a0,a0,72 # 800094f8 <syscalls+0x120>
    800024b8:	00004097          	auipc	ra,0x4
    800024bc:	6b8080e7          	jalr	1720(ra) # 80006b70 <panic>

00000000800024c0 <bpin>:

void
bpin(struct buf *b) {
    800024c0:	1101                	addi	sp,sp,-32
    800024c2:	ec06                	sd	ra,24(sp)
    800024c4:	e822                	sd	s0,16(sp)
    800024c6:	e426                	sd	s1,8(sp)
    800024c8:	1000                	addi	s0,sp,32
    800024ca:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800024cc:	0000e517          	auipc	a0,0xe
    800024d0:	9ec50513          	addi	a0,a0,-1556 # 8000feb8 <bcache>
    800024d4:	00005097          	auipc	ra,0x5
    800024d8:	bd4080e7          	jalr	-1068(ra) # 800070a8 <acquire>
  b->refcnt++;
    800024dc:	40bc                	lw	a5,64(s1)
    800024de:	2785                	addiw	a5,a5,1
    800024e0:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800024e2:	0000e517          	auipc	a0,0xe
    800024e6:	9d650513          	addi	a0,a0,-1578 # 8000feb8 <bcache>
    800024ea:	00005097          	auipc	ra,0x5
    800024ee:	c72080e7          	jalr	-910(ra) # 8000715c <release>
}
    800024f2:	60e2                	ld	ra,24(sp)
    800024f4:	6442                	ld	s0,16(sp)
    800024f6:	64a2                	ld	s1,8(sp)
    800024f8:	6105                	addi	sp,sp,32
    800024fa:	8082                	ret

00000000800024fc <bunpin>:

void
bunpin(struct buf *b) {
    800024fc:	1101                	addi	sp,sp,-32
    800024fe:	ec06                	sd	ra,24(sp)
    80002500:	e822                	sd	s0,16(sp)
    80002502:	e426                	sd	s1,8(sp)
    80002504:	1000                	addi	s0,sp,32
    80002506:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002508:	0000e517          	auipc	a0,0xe
    8000250c:	9b050513          	addi	a0,a0,-1616 # 8000feb8 <bcache>
    80002510:	00005097          	auipc	ra,0x5
    80002514:	b98080e7          	jalr	-1128(ra) # 800070a8 <acquire>
  b->refcnt--;
    80002518:	40bc                	lw	a5,64(s1)
    8000251a:	37fd                	addiw	a5,a5,-1
    8000251c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000251e:	0000e517          	auipc	a0,0xe
    80002522:	99a50513          	addi	a0,a0,-1638 # 8000feb8 <bcache>
    80002526:	00005097          	auipc	ra,0x5
    8000252a:	c36080e7          	jalr	-970(ra) # 8000715c <release>
}
    8000252e:	60e2                	ld	ra,24(sp)
    80002530:	6442                	ld	s0,16(sp)
    80002532:	64a2                	ld	s1,8(sp)
    80002534:	6105                	addi	sp,sp,32
    80002536:	8082                	ret

0000000080002538 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002538:	1101                	addi	sp,sp,-32
    8000253a:	ec06                	sd	ra,24(sp)
    8000253c:	e822                	sd	s0,16(sp)
    8000253e:	e426                	sd	s1,8(sp)
    80002540:	e04a                	sd	s2,0(sp)
    80002542:	1000                	addi	s0,sp,32
    80002544:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002546:	00d5d59b          	srliw	a1,a1,0xd
    8000254a:	00016797          	auipc	a5,0x16
    8000254e:	04a7a783          	lw	a5,74(a5) # 80018594 <sb+0x1c>
    80002552:	9dbd                	addw	a1,a1,a5
    80002554:	00000097          	auipc	ra,0x0
    80002558:	d9e080e7          	jalr	-610(ra) # 800022f2 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000255c:	0074f713          	andi	a4,s1,7
    80002560:	4785                	li	a5,1
    80002562:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002566:	14ce                	slli	s1,s1,0x33
    80002568:	90d9                	srli	s1,s1,0x36
    8000256a:	00950733          	add	a4,a0,s1
    8000256e:	05874703          	lbu	a4,88(a4)
    80002572:	00e7f6b3          	and	a3,a5,a4
    80002576:	c69d                	beqz	a3,800025a4 <bfree+0x6c>
    80002578:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000257a:	94aa                	add	s1,s1,a0
    8000257c:	fff7c793          	not	a5,a5
    80002580:	8f7d                	and	a4,a4,a5
    80002582:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002586:	00001097          	auipc	ra,0x1
    8000258a:	120080e7          	jalr	288(ra) # 800036a6 <log_write>
  brelse(bp);
    8000258e:	854a                	mv	a0,s2
    80002590:	00000097          	auipc	ra,0x0
    80002594:	e92080e7          	jalr	-366(ra) # 80002422 <brelse>
}
    80002598:	60e2                	ld	ra,24(sp)
    8000259a:	6442                	ld	s0,16(sp)
    8000259c:	64a2                	ld	s1,8(sp)
    8000259e:	6902                	ld	s2,0(sp)
    800025a0:	6105                	addi	sp,sp,32
    800025a2:	8082                	ret
    panic("freeing free block");
    800025a4:	00007517          	auipc	a0,0x7
    800025a8:	f5c50513          	addi	a0,a0,-164 # 80009500 <syscalls+0x128>
    800025ac:	00004097          	auipc	ra,0x4
    800025b0:	5c4080e7          	jalr	1476(ra) # 80006b70 <panic>

00000000800025b4 <balloc>:
{
    800025b4:	711d                	addi	sp,sp,-96
    800025b6:	ec86                	sd	ra,88(sp)
    800025b8:	e8a2                	sd	s0,80(sp)
    800025ba:	e4a6                	sd	s1,72(sp)
    800025bc:	e0ca                	sd	s2,64(sp)
    800025be:	fc4e                	sd	s3,56(sp)
    800025c0:	f852                	sd	s4,48(sp)
    800025c2:	f456                	sd	s5,40(sp)
    800025c4:	f05a                	sd	s6,32(sp)
    800025c6:	ec5e                	sd	s7,24(sp)
    800025c8:	e862                	sd	s8,16(sp)
    800025ca:	e466                	sd	s9,8(sp)
    800025cc:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800025ce:	00016797          	auipc	a5,0x16
    800025d2:	fae7a783          	lw	a5,-82(a5) # 8001857c <sb+0x4>
    800025d6:	cbc1                	beqz	a5,80002666 <balloc+0xb2>
    800025d8:	8baa                	mv	s7,a0
    800025da:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800025dc:	00016b17          	auipc	s6,0x16
    800025e0:	f9cb0b13          	addi	s6,s6,-100 # 80018578 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025e4:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800025e6:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025e8:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800025ea:	6c89                	lui	s9,0x2
    800025ec:	a831                	j	80002608 <balloc+0x54>
    brelse(bp);
    800025ee:	854a                	mv	a0,s2
    800025f0:	00000097          	auipc	ra,0x0
    800025f4:	e32080e7          	jalr	-462(ra) # 80002422 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800025f8:	015c87bb          	addw	a5,s9,s5
    800025fc:	00078a9b          	sext.w	s5,a5
    80002600:	004b2703          	lw	a4,4(s6)
    80002604:	06eaf163          	bgeu	s5,a4,80002666 <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    80002608:	41fad79b          	sraiw	a5,s5,0x1f
    8000260c:	0137d79b          	srliw	a5,a5,0x13
    80002610:	015787bb          	addw	a5,a5,s5
    80002614:	40d7d79b          	sraiw	a5,a5,0xd
    80002618:	01cb2583          	lw	a1,28(s6)
    8000261c:	9dbd                	addw	a1,a1,a5
    8000261e:	855e                	mv	a0,s7
    80002620:	00000097          	auipc	ra,0x0
    80002624:	cd2080e7          	jalr	-814(ra) # 800022f2 <bread>
    80002628:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000262a:	004b2503          	lw	a0,4(s6)
    8000262e:	000a849b          	sext.w	s1,s5
    80002632:	8762                	mv	a4,s8
    80002634:	faa4fde3          	bgeu	s1,a0,800025ee <balloc+0x3a>
      m = 1 << (bi % 8);
    80002638:	00777693          	andi	a3,a4,7
    8000263c:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002640:	41f7579b          	sraiw	a5,a4,0x1f
    80002644:	01d7d79b          	srliw	a5,a5,0x1d
    80002648:	9fb9                	addw	a5,a5,a4
    8000264a:	4037d79b          	sraiw	a5,a5,0x3
    8000264e:	00f90633          	add	a2,s2,a5
    80002652:	05864603          	lbu	a2,88(a2)
    80002656:	00c6f5b3          	and	a1,a3,a2
    8000265a:	cd91                	beqz	a1,80002676 <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000265c:	2705                	addiw	a4,a4,1
    8000265e:	2485                	addiw	s1,s1,1
    80002660:	fd471ae3          	bne	a4,s4,80002634 <balloc+0x80>
    80002664:	b769                	j	800025ee <balloc+0x3a>
  panic("balloc: out of blocks");
    80002666:	00007517          	auipc	a0,0x7
    8000266a:	eb250513          	addi	a0,a0,-334 # 80009518 <syscalls+0x140>
    8000266e:	00004097          	auipc	ra,0x4
    80002672:	502080e7          	jalr	1282(ra) # 80006b70 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002676:	97ca                	add	a5,a5,s2
    80002678:	8e55                	or	a2,a2,a3
    8000267a:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    8000267e:	854a                	mv	a0,s2
    80002680:	00001097          	auipc	ra,0x1
    80002684:	026080e7          	jalr	38(ra) # 800036a6 <log_write>
        brelse(bp);
    80002688:	854a                	mv	a0,s2
    8000268a:	00000097          	auipc	ra,0x0
    8000268e:	d98080e7          	jalr	-616(ra) # 80002422 <brelse>
  bp = bread(dev, bno);
    80002692:	85a6                	mv	a1,s1
    80002694:	855e                	mv	a0,s7
    80002696:	00000097          	auipc	ra,0x0
    8000269a:	c5c080e7          	jalr	-932(ra) # 800022f2 <bread>
    8000269e:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800026a0:	40000613          	li	a2,1024
    800026a4:	4581                	li	a1,0
    800026a6:	05850513          	addi	a0,a0,88
    800026aa:	ffffe097          	auipc	ra,0xffffe
    800026ae:	ad0080e7          	jalr	-1328(ra) # 8000017a <memset>
  log_write(bp);
    800026b2:	854a                	mv	a0,s2
    800026b4:	00001097          	auipc	ra,0x1
    800026b8:	ff2080e7          	jalr	-14(ra) # 800036a6 <log_write>
  brelse(bp);
    800026bc:	854a                	mv	a0,s2
    800026be:	00000097          	auipc	ra,0x0
    800026c2:	d64080e7          	jalr	-668(ra) # 80002422 <brelse>
}
    800026c6:	8526                	mv	a0,s1
    800026c8:	60e6                	ld	ra,88(sp)
    800026ca:	6446                	ld	s0,80(sp)
    800026cc:	64a6                	ld	s1,72(sp)
    800026ce:	6906                	ld	s2,64(sp)
    800026d0:	79e2                	ld	s3,56(sp)
    800026d2:	7a42                	ld	s4,48(sp)
    800026d4:	7aa2                	ld	s5,40(sp)
    800026d6:	7b02                	ld	s6,32(sp)
    800026d8:	6be2                	ld	s7,24(sp)
    800026da:	6c42                	ld	s8,16(sp)
    800026dc:	6ca2                	ld	s9,8(sp)
    800026de:	6125                	addi	sp,sp,96
    800026e0:	8082                	ret

00000000800026e2 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800026e2:	7179                	addi	sp,sp,-48
    800026e4:	f406                	sd	ra,40(sp)
    800026e6:	f022                	sd	s0,32(sp)
    800026e8:	ec26                	sd	s1,24(sp)
    800026ea:	e84a                	sd	s2,16(sp)
    800026ec:	e44e                	sd	s3,8(sp)
    800026ee:	e052                	sd	s4,0(sp)
    800026f0:	1800                	addi	s0,sp,48
    800026f2:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800026f4:	47ad                	li	a5,11
    800026f6:	04b7fe63          	bgeu	a5,a1,80002752 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800026fa:	ff45849b          	addiw	s1,a1,-12
    800026fe:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002702:	0ff00793          	li	a5,255
    80002706:	0ae7e463          	bltu	a5,a4,800027ae <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    8000270a:	08052583          	lw	a1,128(a0)
    8000270e:	c5b5                	beqz	a1,8000277a <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002710:	00092503          	lw	a0,0(s2)
    80002714:	00000097          	auipc	ra,0x0
    80002718:	bde080e7          	jalr	-1058(ra) # 800022f2 <bread>
    8000271c:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000271e:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002722:	02049713          	slli	a4,s1,0x20
    80002726:	01e75593          	srli	a1,a4,0x1e
    8000272a:	00b784b3          	add	s1,a5,a1
    8000272e:	0004a983          	lw	s3,0(s1)
    80002732:	04098e63          	beqz	s3,8000278e <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80002736:	8552                	mv	a0,s4
    80002738:	00000097          	auipc	ra,0x0
    8000273c:	cea080e7          	jalr	-790(ra) # 80002422 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002740:	854e                	mv	a0,s3
    80002742:	70a2                	ld	ra,40(sp)
    80002744:	7402                	ld	s0,32(sp)
    80002746:	64e2                	ld	s1,24(sp)
    80002748:	6942                	ld	s2,16(sp)
    8000274a:	69a2                	ld	s3,8(sp)
    8000274c:	6a02                	ld	s4,0(sp)
    8000274e:	6145                	addi	sp,sp,48
    80002750:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002752:	02059793          	slli	a5,a1,0x20
    80002756:	01e7d593          	srli	a1,a5,0x1e
    8000275a:	00b504b3          	add	s1,a0,a1
    8000275e:	0504a983          	lw	s3,80(s1)
    80002762:	fc099fe3          	bnez	s3,80002740 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002766:	4108                	lw	a0,0(a0)
    80002768:	00000097          	auipc	ra,0x0
    8000276c:	e4c080e7          	jalr	-436(ra) # 800025b4 <balloc>
    80002770:	0005099b          	sext.w	s3,a0
    80002774:	0534a823          	sw	s3,80(s1)
    80002778:	b7e1                	j	80002740 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    8000277a:	4108                	lw	a0,0(a0)
    8000277c:	00000097          	auipc	ra,0x0
    80002780:	e38080e7          	jalr	-456(ra) # 800025b4 <balloc>
    80002784:	0005059b          	sext.w	a1,a0
    80002788:	08b92023          	sw	a1,128(s2)
    8000278c:	b751                	j	80002710 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    8000278e:	00092503          	lw	a0,0(s2)
    80002792:	00000097          	auipc	ra,0x0
    80002796:	e22080e7          	jalr	-478(ra) # 800025b4 <balloc>
    8000279a:	0005099b          	sext.w	s3,a0
    8000279e:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800027a2:	8552                	mv	a0,s4
    800027a4:	00001097          	auipc	ra,0x1
    800027a8:	f02080e7          	jalr	-254(ra) # 800036a6 <log_write>
    800027ac:	b769                	j	80002736 <bmap+0x54>
  panic("bmap: out of range");
    800027ae:	00007517          	auipc	a0,0x7
    800027b2:	d8250513          	addi	a0,a0,-638 # 80009530 <syscalls+0x158>
    800027b6:	00004097          	auipc	ra,0x4
    800027ba:	3ba080e7          	jalr	954(ra) # 80006b70 <panic>

00000000800027be <iget>:
{
    800027be:	7179                	addi	sp,sp,-48
    800027c0:	f406                	sd	ra,40(sp)
    800027c2:	f022                	sd	s0,32(sp)
    800027c4:	ec26                	sd	s1,24(sp)
    800027c6:	e84a                	sd	s2,16(sp)
    800027c8:	e44e                	sd	s3,8(sp)
    800027ca:	e052                	sd	s4,0(sp)
    800027cc:	1800                	addi	s0,sp,48
    800027ce:	89aa                	mv	s3,a0
    800027d0:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800027d2:	00016517          	auipc	a0,0x16
    800027d6:	dc650513          	addi	a0,a0,-570 # 80018598 <itable>
    800027da:	00005097          	auipc	ra,0x5
    800027de:	8ce080e7          	jalr	-1842(ra) # 800070a8 <acquire>
  empty = 0;
    800027e2:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800027e4:	00016497          	auipc	s1,0x16
    800027e8:	dcc48493          	addi	s1,s1,-564 # 800185b0 <itable+0x18>
    800027ec:	00018697          	auipc	a3,0x18
    800027f0:	85468693          	addi	a3,a3,-1964 # 8001a040 <log>
    800027f4:	a039                	j	80002802 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800027f6:	02090b63          	beqz	s2,8000282c <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800027fa:	08848493          	addi	s1,s1,136
    800027fe:	02d48a63          	beq	s1,a3,80002832 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002802:	449c                	lw	a5,8(s1)
    80002804:	fef059e3          	blez	a5,800027f6 <iget+0x38>
    80002808:	4098                	lw	a4,0(s1)
    8000280a:	ff3716e3          	bne	a4,s3,800027f6 <iget+0x38>
    8000280e:	40d8                	lw	a4,4(s1)
    80002810:	ff4713e3          	bne	a4,s4,800027f6 <iget+0x38>
      ip->ref++;
    80002814:	2785                	addiw	a5,a5,1
    80002816:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002818:	00016517          	auipc	a0,0x16
    8000281c:	d8050513          	addi	a0,a0,-640 # 80018598 <itable>
    80002820:	00005097          	auipc	ra,0x5
    80002824:	93c080e7          	jalr	-1732(ra) # 8000715c <release>
      return ip;
    80002828:	8926                	mv	s2,s1
    8000282a:	a03d                	j	80002858 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000282c:	f7f9                	bnez	a5,800027fa <iget+0x3c>
    8000282e:	8926                	mv	s2,s1
    80002830:	b7e9                	j	800027fa <iget+0x3c>
  if(empty == 0)
    80002832:	02090c63          	beqz	s2,8000286a <iget+0xac>
  ip->dev = dev;
    80002836:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000283a:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000283e:	4785                	li	a5,1
    80002840:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002844:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002848:	00016517          	auipc	a0,0x16
    8000284c:	d5050513          	addi	a0,a0,-688 # 80018598 <itable>
    80002850:	00005097          	auipc	ra,0x5
    80002854:	90c080e7          	jalr	-1780(ra) # 8000715c <release>
}
    80002858:	854a                	mv	a0,s2
    8000285a:	70a2                	ld	ra,40(sp)
    8000285c:	7402                	ld	s0,32(sp)
    8000285e:	64e2                	ld	s1,24(sp)
    80002860:	6942                	ld	s2,16(sp)
    80002862:	69a2                	ld	s3,8(sp)
    80002864:	6a02                	ld	s4,0(sp)
    80002866:	6145                	addi	sp,sp,48
    80002868:	8082                	ret
    panic("iget: no inodes");
    8000286a:	00007517          	auipc	a0,0x7
    8000286e:	cde50513          	addi	a0,a0,-802 # 80009548 <syscalls+0x170>
    80002872:	00004097          	auipc	ra,0x4
    80002876:	2fe080e7          	jalr	766(ra) # 80006b70 <panic>

000000008000287a <fsinit>:
fsinit(int dev) {
    8000287a:	7179                	addi	sp,sp,-48
    8000287c:	f406                	sd	ra,40(sp)
    8000287e:	f022                	sd	s0,32(sp)
    80002880:	ec26                	sd	s1,24(sp)
    80002882:	e84a                	sd	s2,16(sp)
    80002884:	e44e                	sd	s3,8(sp)
    80002886:	1800                	addi	s0,sp,48
    80002888:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000288a:	4585                	li	a1,1
    8000288c:	00000097          	auipc	ra,0x0
    80002890:	a66080e7          	jalr	-1434(ra) # 800022f2 <bread>
    80002894:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002896:	00016997          	auipc	s3,0x16
    8000289a:	ce298993          	addi	s3,s3,-798 # 80018578 <sb>
    8000289e:	02000613          	li	a2,32
    800028a2:	05850593          	addi	a1,a0,88
    800028a6:	854e                	mv	a0,s3
    800028a8:	ffffe097          	auipc	ra,0xffffe
    800028ac:	92e080e7          	jalr	-1746(ra) # 800001d6 <memmove>
  brelse(bp);
    800028b0:	8526                	mv	a0,s1
    800028b2:	00000097          	auipc	ra,0x0
    800028b6:	b70080e7          	jalr	-1168(ra) # 80002422 <brelse>
  if(sb.magic != FSMAGIC)
    800028ba:	0009a703          	lw	a4,0(s3)
    800028be:	102037b7          	lui	a5,0x10203
    800028c2:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800028c6:	02f71263          	bne	a4,a5,800028ea <fsinit+0x70>
  initlog(dev, &sb);
    800028ca:	00016597          	auipc	a1,0x16
    800028ce:	cae58593          	addi	a1,a1,-850 # 80018578 <sb>
    800028d2:	854a                	mv	a0,s2
    800028d4:	00001097          	auipc	ra,0x1
    800028d8:	b56080e7          	jalr	-1194(ra) # 8000342a <initlog>
}
    800028dc:	70a2                	ld	ra,40(sp)
    800028de:	7402                	ld	s0,32(sp)
    800028e0:	64e2                	ld	s1,24(sp)
    800028e2:	6942                	ld	s2,16(sp)
    800028e4:	69a2                	ld	s3,8(sp)
    800028e6:	6145                	addi	sp,sp,48
    800028e8:	8082                	ret
    panic("invalid file system");
    800028ea:	00007517          	auipc	a0,0x7
    800028ee:	c6e50513          	addi	a0,a0,-914 # 80009558 <syscalls+0x180>
    800028f2:	00004097          	auipc	ra,0x4
    800028f6:	27e080e7          	jalr	638(ra) # 80006b70 <panic>

00000000800028fa <iinit>:
{
    800028fa:	7179                	addi	sp,sp,-48
    800028fc:	f406                	sd	ra,40(sp)
    800028fe:	f022                	sd	s0,32(sp)
    80002900:	ec26                	sd	s1,24(sp)
    80002902:	e84a                	sd	s2,16(sp)
    80002904:	e44e                	sd	s3,8(sp)
    80002906:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002908:	00007597          	auipc	a1,0x7
    8000290c:	c6858593          	addi	a1,a1,-920 # 80009570 <syscalls+0x198>
    80002910:	00016517          	auipc	a0,0x16
    80002914:	c8850513          	addi	a0,a0,-888 # 80018598 <itable>
    80002918:	00004097          	auipc	ra,0x4
    8000291c:	700080e7          	jalr	1792(ra) # 80007018 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002920:	00016497          	auipc	s1,0x16
    80002924:	ca048493          	addi	s1,s1,-864 # 800185c0 <itable+0x28>
    80002928:	00017997          	auipc	s3,0x17
    8000292c:	72898993          	addi	s3,s3,1832 # 8001a050 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002930:	00007917          	auipc	s2,0x7
    80002934:	c4890913          	addi	s2,s2,-952 # 80009578 <syscalls+0x1a0>
    80002938:	85ca                	mv	a1,s2
    8000293a:	8526                	mv	a0,s1
    8000293c:	00001097          	auipc	ra,0x1
    80002940:	e4e080e7          	jalr	-434(ra) # 8000378a <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002944:	08848493          	addi	s1,s1,136
    80002948:	ff3498e3          	bne	s1,s3,80002938 <iinit+0x3e>
}
    8000294c:	70a2                	ld	ra,40(sp)
    8000294e:	7402                	ld	s0,32(sp)
    80002950:	64e2                	ld	s1,24(sp)
    80002952:	6942                	ld	s2,16(sp)
    80002954:	69a2                	ld	s3,8(sp)
    80002956:	6145                	addi	sp,sp,48
    80002958:	8082                	ret

000000008000295a <ialloc>:
{
    8000295a:	715d                	addi	sp,sp,-80
    8000295c:	e486                	sd	ra,72(sp)
    8000295e:	e0a2                	sd	s0,64(sp)
    80002960:	fc26                	sd	s1,56(sp)
    80002962:	f84a                	sd	s2,48(sp)
    80002964:	f44e                	sd	s3,40(sp)
    80002966:	f052                	sd	s4,32(sp)
    80002968:	ec56                	sd	s5,24(sp)
    8000296a:	e85a                	sd	s6,16(sp)
    8000296c:	e45e                	sd	s7,8(sp)
    8000296e:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002970:	00016717          	auipc	a4,0x16
    80002974:	c1472703          	lw	a4,-1004(a4) # 80018584 <sb+0xc>
    80002978:	4785                	li	a5,1
    8000297a:	04e7fa63          	bgeu	a5,a4,800029ce <ialloc+0x74>
    8000297e:	8aaa                	mv	s5,a0
    80002980:	8bae                	mv	s7,a1
    80002982:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002984:	00016a17          	auipc	s4,0x16
    80002988:	bf4a0a13          	addi	s4,s4,-1036 # 80018578 <sb>
    8000298c:	00048b1b          	sext.w	s6,s1
    80002990:	0044d593          	srli	a1,s1,0x4
    80002994:	018a2783          	lw	a5,24(s4)
    80002998:	9dbd                	addw	a1,a1,a5
    8000299a:	8556                	mv	a0,s5
    8000299c:	00000097          	auipc	ra,0x0
    800029a0:	956080e7          	jalr	-1706(ra) # 800022f2 <bread>
    800029a4:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800029a6:	05850993          	addi	s3,a0,88
    800029aa:	00f4f793          	andi	a5,s1,15
    800029ae:	079a                	slli	a5,a5,0x6
    800029b0:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800029b2:	00099783          	lh	a5,0(s3)
    800029b6:	c785                	beqz	a5,800029de <ialloc+0x84>
    brelse(bp);
    800029b8:	00000097          	auipc	ra,0x0
    800029bc:	a6a080e7          	jalr	-1430(ra) # 80002422 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800029c0:	0485                	addi	s1,s1,1
    800029c2:	00ca2703          	lw	a4,12(s4)
    800029c6:	0004879b          	sext.w	a5,s1
    800029ca:	fce7e1e3          	bltu	a5,a4,8000298c <ialloc+0x32>
  panic("ialloc: no inodes");
    800029ce:	00007517          	auipc	a0,0x7
    800029d2:	bb250513          	addi	a0,a0,-1102 # 80009580 <syscalls+0x1a8>
    800029d6:	00004097          	auipc	ra,0x4
    800029da:	19a080e7          	jalr	410(ra) # 80006b70 <panic>
      memset(dip, 0, sizeof(*dip));
    800029de:	04000613          	li	a2,64
    800029e2:	4581                	li	a1,0
    800029e4:	854e                	mv	a0,s3
    800029e6:	ffffd097          	auipc	ra,0xffffd
    800029ea:	794080e7          	jalr	1940(ra) # 8000017a <memset>
      dip->type = type;
    800029ee:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800029f2:	854a                	mv	a0,s2
    800029f4:	00001097          	auipc	ra,0x1
    800029f8:	cb2080e7          	jalr	-846(ra) # 800036a6 <log_write>
      brelse(bp);
    800029fc:	854a                	mv	a0,s2
    800029fe:	00000097          	auipc	ra,0x0
    80002a02:	a24080e7          	jalr	-1500(ra) # 80002422 <brelse>
      return iget(dev, inum);
    80002a06:	85da                	mv	a1,s6
    80002a08:	8556                	mv	a0,s5
    80002a0a:	00000097          	auipc	ra,0x0
    80002a0e:	db4080e7          	jalr	-588(ra) # 800027be <iget>
}
    80002a12:	60a6                	ld	ra,72(sp)
    80002a14:	6406                	ld	s0,64(sp)
    80002a16:	74e2                	ld	s1,56(sp)
    80002a18:	7942                	ld	s2,48(sp)
    80002a1a:	79a2                	ld	s3,40(sp)
    80002a1c:	7a02                	ld	s4,32(sp)
    80002a1e:	6ae2                	ld	s5,24(sp)
    80002a20:	6b42                	ld	s6,16(sp)
    80002a22:	6ba2                	ld	s7,8(sp)
    80002a24:	6161                	addi	sp,sp,80
    80002a26:	8082                	ret

0000000080002a28 <iupdate>:
{
    80002a28:	1101                	addi	sp,sp,-32
    80002a2a:	ec06                	sd	ra,24(sp)
    80002a2c:	e822                	sd	s0,16(sp)
    80002a2e:	e426                	sd	s1,8(sp)
    80002a30:	e04a                	sd	s2,0(sp)
    80002a32:	1000                	addi	s0,sp,32
    80002a34:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002a36:	415c                	lw	a5,4(a0)
    80002a38:	0047d79b          	srliw	a5,a5,0x4
    80002a3c:	00016597          	auipc	a1,0x16
    80002a40:	b545a583          	lw	a1,-1196(a1) # 80018590 <sb+0x18>
    80002a44:	9dbd                	addw	a1,a1,a5
    80002a46:	4108                	lw	a0,0(a0)
    80002a48:	00000097          	auipc	ra,0x0
    80002a4c:	8aa080e7          	jalr	-1878(ra) # 800022f2 <bread>
    80002a50:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002a52:	05850793          	addi	a5,a0,88
    80002a56:	40d8                	lw	a4,4(s1)
    80002a58:	8b3d                	andi	a4,a4,15
    80002a5a:	071a                	slli	a4,a4,0x6
    80002a5c:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002a5e:	04449703          	lh	a4,68(s1)
    80002a62:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002a66:	04649703          	lh	a4,70(s1)
    80002a6a:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002a6e:	04849703          	lh	a4,72(s1)
    80002a72:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002a76:	04a49703          	lh	a4,74(s1)
    80002a7a:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002a7e:	44f8                	lw	a4,76(s1)
    80002a80:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002a82:	03400613          	li	a2,52
    80002a86:	05048593          	addi	a1,s1,80
    80002a8a:	00c78513          	addi	a0,a5,12
    80002a8e:	ffffd097          	auipc	ra,0xffffd
    80002a92:	748080e7          	jalr	1864(ra) # 800001d6 <memmove>
  log_write(bp);
    80002a96:	854a                	mv	a0,s2
    80002a98:	00001097          	auipc	ra,0x1
    80002a9c:	c0e080e7          	jalr	-1010(ra) # 800036a6 <log_write>
  brelse(bp);
    80002aa0:	854a                	mv	a0,s2
    80002aa2:	00000097          	auipc	ra,0x0
    80002aa6:	980080e7          	jalr	-1664(ra) # 80002422 <brelse>
}
    80002aaa:	60e2                	ld	ra,24(sp)
    80002aac:	6442                	ld	s0,16(sp)
    80002aae:	64a2                	ld	s1,8(sp)
    80002ab0:	6902                	ld	s2,0(sp)
    80002ab2:	6105                	addi	sp,sp,32
    80002ab4:	8082                	ret

0000000080002ab6 <idup>:
{
    80002ab6:	1101                	addi	sp,sp,-32
    80002ab8:	ec06                	sd	ra,24(sp)
    80002aba:	e822                	sd	s0,16(sp)
    80002abc:	e426                	sd	s1,8(sp)
    80002abe:	1000                	addi	s0,sp,32
    80002ac0:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002ac2:	00016517          	auipc	a0,0x16
    80002ac6:	ad650513          	addi	a0,a0,-1322 # 80018598 <itable>
    80002aca:	00004097          	auipc	ra,0x4
    80002ace:	5de080e7          	jalr	1502(ra) # 800070a8 <acquire>
  ip->ref++;
    80002ad2:	449c                	lw	a5,8(s1)
    80002ad4:	2785                	addiw	a5,a5,1
    80002ad6:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002ad8:	00016517          	auipc	a0,0x16
    80002adc:	ac050513          	addi	a0,a0,-1344 # 80018598 <itable>
    80002ae0:	00004097          	auipc	ra,0x4
    80002ae4:	67c080e7          	jalr	1660(ra) # 8000715c <release>
}
    80002ae8:	8526                	mv	a0,s1
    80002aea:	60e2                	ld	ra,24(sp)
    80002aec:	6442                	ld	s0,16(sp)
    80002aee:	64a2                	ld	s1,8(sp)
    80002af0:	6105                	addi	sp,sp,32
    80002af2:	8082                	ret

0000000080002af4 <ilock>:
{
    80002af4:	1101                	addi	sp,sp,-32
    80002af6:	ec06                	sd	ra,24(sp)
    80002af8:	e822                	sd	s0,16(sp)
    80002afa:	e426                	sd	s1,8(sp)
    80002afc:	e04a                	sd	s2,0(sp)
    80002afe:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002b00:	c115                	beqz	a0,80002b24 <ilock+0x30>
    80002b02:	84aa                	mv	s1,a0
    80002b04:	451c                	lw	a5,8(a0)
    80002b06:	00f05f63          	blez	a5,80002b24 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002b0a:	0541                	addi	a0,a0,16
    80002b0c:	00001097          	auipc	ra,0x1
    80002b10:	cb8080e7          	jalr	-840(ra) # 800037c4 <acquiresleep>
  if(ip->valid == 0){
    80002b14:	40bc                	lw	a5,64(s1)
    80002b16:	cf99                	beqz	a5,80002b34 <ilock+0x40>
}
    80002b18:	60e2                	ld	ra,24(sp)
    80002b1a:	6442                	ld	s0,16(sp)
    80002b1c:	64a2                	ld	s1,8(sp)
    80002b1e:	6902                	ld	s2,0(sp)
    80002b20:	6105                	addi	sp,sp,32
    80002b22:	8082                	ret
    panic("ilock");
    80002b24:	00007517          	auipc	a0,0x7
    80002b28:	a7450513          	addi	a0,a0,-1420 # 80009598 <syscalls+0x1c0>
    80002b2c:	00004097          	auipc	ra,0x4
    80002b30:	044080e7          	jalr	68(ra) # 80006b70 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b34:	40dc                	lw	a5,4(s1)
    80002b36:	0047d79b          	srliw	a5,a5,0x4
    80002b3a:	00016597          	auipc	a1,0x16
    80002b3e:	a565a583          	lw	a1,-1450(a1) # 80018590 <sb+0x18>
    80002b42:	9dbd                	addw	a1,a1,a5
    80002b44:	4088                	lw	a0,0(s1)
    80002b46:	fffff097          	auipc	ra,0xfffff
    80002b4a:	7ac080e7          	jalr	1964(ra) # 800022f2 <bread>
    80002b4e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b50:	05850593          	addi	a1,a0,88
    80002b54:	40dc                	lw	a5,4(s1)
    80002b56:	8bbd                	andi	a5,a5,15
    80002b58:	079a                	slli	a5,a5,0x6
    80002b5a:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002b5c:	00059783          	lh	a5,0(a1)
    80002b60:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002b64:	00259783          	lh	a5,2(a1)
    80002b68:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002b6c:	00459783          	lh	a5,4(a1)
    80002b70:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002b74:	00659783          	lh	a5,6(a1)
    80002b78:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002b7c:	459c                	lw	a5,8(a1)
    80002b7e:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002b80:	03400613          	li	a2,52
    80002b84:	05b1                	addi	a1,a1,12
    80002b86:	05048513          	addi	a0,s1,80
    80002b8a:	ffffd097          	auipc	ra,0xffffd
    80002b8e:	64c080e7          	jalr	1612(ra) # 800001d6 <memmove>
    brelse(bp);
    80002b92:	854a                	mv	a0,s2
    80002b94:	00000097          	auipc	ra,0x0
    80002b98:	88e080e7          	jalr	-1906(ra) # 80002422 <brelse>
    ip->valid = 1;
    80002b9c:	4785                	li	a5,1
    80002b9e:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002ba0:	04449783          	lh	a5,68(s1)
    80002ba4:	fbb5                	bnez	a5,80002b18 <ilock+0x24>
      panic("ilock: no type");
    80002ba6:	00007517          	auipc	a0,0x7
    80002baa:	9fa50513          	addi	a0,a0,-1542 # 800095a0 <syscalls+0x1c8>
    80002bae:	00004097          	auipc	ra,0x4
    80002bb2:	fc2080e7          	jalr	-62(ra) # 80006b70 <panic>

0000000080002bb6 <iunlock>:
{
    80002bb6:	1101                	addi	sp,sp,-32
    80002bb8:	ec06                	sd	ra,24(sp)
    80002bba:	e822                	sd	s0,16(sp)
    80002bbc:	e426                	sd	s1,8(sp)
    80002bbe:	e04a                	sd	s2,0(sp)
    80002bc0:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002bc2:	c905                	beqz	a0,80002bf2 <iunlock+0x3c>
    80002bc4:	84aa                	mv	s1,a0
    80002bc6:	01050913          	addi	s2,a0,16
    80002bca:	854a                	mv	a0,s2
    80002bcc:	00001097          	auipc	ra,0x1
    80002bd0:	c92080e7          	jalr	-878(ra) # 8000385e <holdingsleep>
    80002bd4:	cd19                	beqz	a0,80002bf2 <iunlock+0x3c>
    80002bd6:	449c                	lw	a5,8(s1)
    80002bd8:	00f05d63          	blez	a5,80002bf2 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002bdc:	854a                	mv	a0,s2
    80002bde:	00001097          	auipc	ra,0x1
    80002be2:	c3c080e7          	jalr	-964(ra) # 8000381a <releasesleep>
}
    80002be6:	60e2                	ld	ra,24(sp)
    80002be8:	6442                	ld	s0,16(sp)
    80002bea:	64a2                	ld	s1,8(sp)
    80002bec:	6902                	ld	s2,0(sp)
    80002bee:	6105                	addi	sp,sp,32
    80002bf0:	8082                	ret
    panic("iunlock");
    80002bf2:	00007517          	auipc	a0,0x7
    80002bf6:	9be50513          	addi	a0,a0,-1602 # 800095b0 <syscalls+0x1d8>
    80002bfa:	00004097          	auipc	ra,0x4
    80002bfe:	f76080e7          	jalr	-138(ra) # 80006b70 <panic>

0000000080002c02 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002c02:	7179                	addi	sp,sp,-48
    80002c04:	f406                	sd	ra,40(sp)
    80002c06:	f022                	sd	s0,32(sp)
    80002c08:	ec26                	sd	s1,24(sp)
    80002c0a:	e84a                	sd	s2,16(sp)
    80002c0c:	e44e                	sd	s3,8(sp)
    80002c0e:	e052                	sd	s4,0(sp)
    80002c10:	1800                	addi	s0,sp,48
    80002c12:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002c14:	05050493          	addi	s1,a0,80
    80002c18:	08050913          	addi	s2,a0,128
    80002c1c:	a021                	j	80002c24 <itrunc+0x22>
    80002c1e:	0491                	addi	s1,s1,4
    80002c20:	01248d63          	beq	s1,s2,80002c3a <itrunc+0x38>
    if(ip->addrs[i]){
    80002c24:	408c                	lw	a1,0(s1)
    80002c26:	dde5                	beqz	a1,80002c1e <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002c28:	0009a503          	lw	a0,0(s3)
    80002c2c:	00000097          	auipc	ra,0x0
    80002c30:	90c080e7          	jalr	-1780(ra) # 80002538 <bfree>
      ip->addrs[i] = 0;
    80002c34:	0004a023          	sw	zero,0(s1)
    80002c38:	b7dd                	j	80002c1e <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002c3a:	0809a583          	lw	a1,128(s3)
    80002c3e:	e185                	bnez	a1,80002c5e <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002c40:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002c44:	854e                	mv	a0,s3
    80002c46:	00000097          	auipc	ra,0x0
    80002c4a:	de2080e7          	jalr	-542(ra) # 80002a28 <iupdate>
}
    80002c4e:	70a2                	ld	ra,40(sp)
    80002c50:	7402                	ld	s0,32(sp)
    80002c52:	64e2                	ld	s1,24(sp)
    80002c54:	6942                	ld	s2,16(sp)
    80002c56:	69a2                	ld	s3,8(sp)
    80002c58:	6a02                	ld	s4,0(sp)
    80002c5a:	6145                	addi	sp,sp,48
    80002c5c:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002c5e:	0009a503          	lw	a0,0(s3)
    80002c62:	fffff097          	auipc	ra,0xfffff
    80002c66:	690080e7          	jalr	1680(ra) # 800022f2 <bread>
    80002c6a:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002c6c:	05850493          	addi	s1,a0,88
    80002c70:	45850913          	addi	s2,a0,1112
    80002c74:	a021                	j	80002c7c <itrunc+0x7a>
    80002c76:	0491                	addi	s1,s1,4
    80002c78:	01248b63          	beq	s1,s2,80002c8e <itrunc+0x8c>
      if(a[j])
    80002c7c:	408c                	lw	a1,0(s1)
    80002c7e:	dde5                	beqz	a1,80002c76 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002c80:	0009a503          	lw	a0,0(s3)
    80002c84:	00000097          	auipc	ra,0x0
    80002c88:	8b4080e7          	jalr	-1868(ra) # 80002538 <bfree>
    80002c8c:	b7ed                	j	80002c76 <itrunc+0x74>
    brelse(bp);
    80002c8e:	8552                	mv	a0,s4
    80002c90:	fffff097          	auipc	ra,0xfffff
    80002c94:	792080e7          	jalr	1938(ra) # 80002422 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002c98:	0809a583          	lw	a1,128(s3)
    80002c9c:	0009a503          	lw	a0,0(s3)
    80002ca0:	00000097          	auipc	ra,0x0
    80002ca4:	898080e7          	jalr	-1896(ra) # 80002538 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002ca8:	0809a023          	sw	zero,128(s3)
    80002cac:	bf51                	j	80002c40 <itrunc+0x3e>

0000000080002cae <iput>:
{
    80002cae:	1101                	addi	sp,sp,-32
    80002cb0:	ec06                	sd	ra,24(sp)
    80002cb2:	e822                	sd	s0,16(sp)
    80002cb4:	e426                	sd	s1,8(sp)
    80002cb6:	e04a                	sd	s2,0(sp)
    80002cb8:	1000                	addi	s0,sp,32
    80002cba:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002cbc:	00016517          	auipc	a0,0x16
    80002cc0:	8dc50513          	addi	a0,a0,-1828 # 80018598 <itable>
    80002cc4:	00004097          	auipc	ra,0x4
    80002cc8:	3e4080e7          	jalr	996(ra) # 800070a8 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002ccc:	4498                	lw	a4,8(s1)
    80002cce:	4785                	li	a5,1
    80002cd0:	02f70363          	beq	a4,a5,80002cf6 <iput+0x48>
  ip->ref--;
    80002cd4:	449c                	lw	a5,8(s1)
    80002cd6:	37fd                	addiw	a5,a5,-1
    80002cd8:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002cda:	00016517          	auipc	a0,0x16
    80002cde:	8be50513          	addi	a0,a0,-1858 # 80018598 <itable>
    80002ce2:	00004097          	auipc	ra,0x4
    80002ce6:	47a080e7          	jalr	1146(ra) # 8000715c <release>
}
    80002cea:	60e2                	ld	ra,24(sp)
    80002cec:	6442                	ld	s0,16(sp)
    80002cee:	64a2                	ld	s1,8(sp)
    80002cf0:	6902                	ld	s2,0(sp)
    80002cf2:	6105                	addi	sp,sp,32
    80002cf4:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002cf6:	40bc                	lw	a5,64(s1)
    80002cf8:	dff1                	beqz	a5,80002cd4 <iput+0x26>
    80002cfa:	04a49783          	lh	a5,74(s1)
    80002cfe:	fbf9                	bnez	a5,80002cd4 <iput+0x26>
    acquiresleep(&ip->lock);
    80002d00:	01048913          	addi	s2,s1,16
    80002d04:	854a                	mv	a0,s2
    80002d06:	00001097          	auipc	ra,0x1
    80002d0a:	abe080e7          	jalr	-1346(ra) # 800037c4 <acquiresleep>
    release(&itable.lock);
    80002d0e:	00016517          	auipc	a0,0x16
    80002d12:	88a50513          	addi	a0,a0,-1910 # 80018598 <itable>
    80002d16:	00004097          	auipc	ra,0x4
    80002d1a:	446080e7          	jalr	1094(ra) # 8000715c <release>
    itrunc(ip);
    80002d1e:	8526                	mv	a0,s1
    80002d20:	00000097          	auipc	ra,0x0
    80002d24:	ee2080e7          	jalr	-286(ra) # 80002c02 <itrunc>
    ip->type = 0;
    80002d28:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002d2c:	8526                	mv	a0,s1
    80002d2e:	00000097          	auipc	ra,0x0
    80002d32:	cfa080e7          	jalr	-774(ra) # 80002a28 <iupdate>
    ip->valid = 0;
    80002d36:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002d3a:	854a                	mv	a0,s2
    80002d3c:	00001097          	auipc	ra,0x1
    80002d40:	ade080e7          	jalr	-1314(ra) # 8000381a <releasesleep>
    acquire(&itable.lock);
    80002d44:	00016517          	auipc	a0,0x16
    80002d48:	85450513          	addi	a0,a0,-1964 # 80018598 <itable>
    80002d4c:	00004097          	auipc	ra,0x4
    80002d50:	35c080e7          	jalr	860(ra) # 800070a8 <acquire>
    80002d54:	b741                	j	80002cd4 <iput+0x26>

0000000080002d56 <iunlockput>:
{
    80002d56:	1101                	addi	sp,sp,-32
    80002d58:	ec06                	sd	ra,24(sp)
    80002d5a:	e822                	sd	s0,16(sp)
    80002d5c:	e426                	sd	s1,8(sp)
    80002d5e:	1000                	addi	s0,sp,32
    80002d60:	84aa                	mv	s1,a0
  iunlock(ip);
    80002d62:	00000097          	auipc	ra,0x0
    80002d66:	e54080e7          	jalr	-428(ra) # 80002bb6 <iunlock>
  iput(ip);
    80002d6a:	8526                	mv	a0,s1
    80002d6c:	00000097          	auipc	ra,0x0
    80002d70:	f42080e7          	jalr	-190(ra) # 80002cae <iput>
}
    80002d74:	60e2                	ld	ra,24(sp)
    80002d76:	6442                	ld	s0,16(sp)
    80002d78:	64a2                	ld	s1,8(sp)
    80002d7a:	6105                	addi	sp,sp,32
    80002d7c:	8082                	ret

0000000080002d7e <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002d7e:	1141                	addi	sp,sp,-16
    80002d80:	e422                	sd	s0,8(sp)
    80002d82:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002d84:	411c                	lw	a5,0(a0)
    80002d86:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002d88:	415c                	lw	a5,4(a0)
    80002d8a:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002d8c:	04451783          	lh	a5,68(a0)
    80002d90:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002d94:	04a51783          	lh	a5,74(a0)
    80002d98:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002d9c:	04c56783          	lwu	a5,76(a0)
    80002da0:	e99c                	sd	a5,16(a1)
}
    80002da2:	6422                	ld	s0,8(sp)
    80002da4:	0141                	addi	sp,sp,16
    80002da6:	8082                	ret

0000000080002da8 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002da8:	457c                	lw	a5,76(a0)
    80002daa:	0ed7e963          	bltu	a5,a3,80002e9c <readi+0xf4>
{
    80002dae:	7159                	addi	sp,sp,-112
    80002db0:	f486                	sd	ra,104(sp)
    80002db2:	f0a2                	sd	s0,96(sp)
    80002db4:	eca6                	sd	s1,88(sp)
    80002db6:	e8ca                	sd	s2,80(sp)
    80002db8:	e4ce                	sd	s3,72(sp)
    80002dba:	e0d2                	sd	s4,64(sp)
    80002dbc:	fc56                	sd	s5,56(sp)
    80002dbe:	f85a                	sd	s6,48(sp)
    80002dc0:	f45e                	sd	s7,40(sp)
    80002dc2:	f062                	sd	s8,32(sp)
    80002dc4:	ec66                	sd	s9,24(sp)
    80002dc6:	e86a                	sd	s10,16(sp)
    80002dc8:	e46e                	sd	s11,8(sp)
    80002dca:	1880                	addi	s0,sp,112
    80002dcc:	8baa                	mv	s7,a0
    80002dce:	8c2e                	mv	s8,a1
    80002dd0:	8ab2                	mv	s5,a2
    80002dd2:	84b6                	mv	s1,a3
    80002dd4:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002dd6:	9f35                	addw	a4,a4,a3
    return 0;
    80002dd8:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002dda:	0ad76063          	bltu	a4,a3,80002e7a <readi+0xd2>
  if(off + n > ip->size)
    80002dde:	00e7f463          	bgeu	a5,a4,80002de6 <readi+0x3e>
    n = ip->size - off;
    80002de2:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002de6:	0a0b0963          	beqz	s6,80002e98 <readi+0xf0>
    80002dea:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002dec:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002df0:	5cfd                	li	s9,-1
    80002df2:	a82d                	j	80002e2c <readi+0x84>
    80002df4:	020a1d93          	slli	s11,s4,0x20
    80002df8:	020ddd93          	srli	s11,s11,0x20
    80002dfc:	05890613          	addi	a2,s2,88
    80002e00:	86ee                	mv	a3,s11
    80002e02:	963a                	add	a2,a2,a4
    80002e04:	85d6                	mv	a1,s5
    80002e06:	8562                	mv	a0,s8
    80002e08:	fffff097          	auipc	ra,0xfffff
    80002e0c:	afc080e7          	jalr	-1284(ra) # 80001904 <either_copyout>
    80002e10:	05950d63          	beq	a0,s9,80002e6a <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002e14:	854a                	mv	a0,s2
    80002e16:	fffff097          	auipc	ra,0xfffff
    80002e1a:	60c080e7          	jalr	1548(ra) # 80002422 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e1e:	013a09bb          	addw	s3,s4,s3
    80002e22:	009a04bb          	addw	s1,s4,s1
    80002e26:	9aee                	add	s5,s5,s11
    80002e28:	0569f763          	bgeu	s3,s6,80002e76 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002e2c:	000ba903          	lw	s2,0(s7)
    80002e30:	00a4d59b          	srliw	a1,s1,0xa
    80002e34:	855e                	mv	a0,s7
    80002e36:	00000097          	auipc	ra,0x0
    80002e3a:	8ac080e7          	jalr	-1876(ra) # 800026e2 <bmap>
    80002e3e:	0005059b          	sext.w	a1,a0
    80002e42:	854a                	mv	a0,s2
    80002e44:	fffff097          	auipc	ra,0xfffff
    80002e48:	4ae080e7          	jalr	1198(ra) # 800022f2 <bread>
    80002e4c:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e4e:	3ff4f713          	andi	a4,s1,1023
    80002e52:	40ed07bb          	subw	a5,s10,a4
    80002e56:	413b06bb          	subw	a3,s6,s3
    80002e5a:	8a3e                	mv	s4,a5
    80002e5c:	2781                	sext.w	a5,a5
    80002e5e:	0006861b          	sext.w	a2,a3
    80002e62:	f8f679e3          	bgeu	a2,a5,80002df4 <readi+0x4c>
    80002e66:	8a36                	mv	s4,a3
    80002e68:	b771                	j	80002df4 <readi+0x4c>
      brelse(bp);
    80002e6a:	854a                	mv	a0,s2
    80002e6c:	fffff097          	auipc	ra,0xfffff
    80002e70:	5b6080e7          	jalr	1462(ra) # 80002422 <brelse>
      tot = -1;
    80002e74:	59fd                	li	s3,-1
  }
  return tot;
    80002e76:	0009851b          	sext.w	a0,s3
}
    80002e7a:	70a6                	ld	ra,104(sp)
    80002e7c:	7406                	ld	s0,96(sp)
    80002e7e:	64e6                	ld	s1,88(sp)
    80002e80:	6946                	ld	s2,80(sp)
    80002e82:	69a6                	ld	s3,72(sp)
    80002e84:	6a06                	ld	s4,64(sp)
    80002e86:	7ae2                	ld	s5,56(sp)
    80002e88:	7b42                	ld	s6,48(sp)
    80002e8a:	7ba2                	ld	s7,40(sp)
    80002e8c:	7c02                	ld	s8,32(sp)
    80002e8e:	6ce2                	ld	s9,24(sp)
    80002e90:	6d42                	ld	s10,16(sp)
    80002e92:	6da2                	ld	s11,8(sp)
    80002e94:	6165                	addi	sp,sp,112
    80002e96:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e98:	89da                	mv	s3,s6
    80002e9a:	bff1                	j	80002e76 <readi+0xce>
    return 0;
    80002e9c:	4501                	li	a0,0
}
    80002e9e:	8082                	ret

0000000080002ea0 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002ea0:	457c                	lw	a5,76(a0)
    80002ea2:	10d7e863          	bltu	a5,a3,80002fb2 <writei+0x112>
{
    80002ea6:	7159                	addi	sp,sp,-112
    80002ea8:	f486                	sd	ra,104(sp)
    80002eaa:	f0a2                	sd	s0,96(sp)
    80002eac:	eca6                	sd	s1,88(sp)
    80002eae:	e8ca                	sd	s2,80(sp)
    80002eb0:	e4ce                	sd	s3,72(sp)
    80002eb2:	e0d2                	sd	s4,64(sp)
    80002eb4:	fc56                	sd	s5,56(sp)
    80002eb6:	f85a                	sd	s6,48(sp)
    80002eb8:	f45e                	sd	s7,40(sp)
    80002eba:	f062                	sd	s8,32(sp)
    80002ebc:	ec66                	sd	s9,24(sp)
    80002ebe:	e86a                	sd	s10,16(sp)
    80002ec0:	e46e                	sd	s11,8(sp)
    80002ec2:	1880                	addi	s0,sp,112
    80002ec4:	8b2a                	mv	s6,a0
    80002ec6:	8c2e                	mv	s8,a1
    80002ec8:	8ab2                	mv	s5,a2
    80002eca:	8936                	mv	s2,a3
    80002ecc:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80002ece:	00e687bb          	addw	a5,a3,a4
    80002ed2:	0ed7e263          	bltu	a5,a3,80002fb6 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002ed6:	00043737          	lui	a4,0x43
    80002eda:	0ef76063          	bltu	a4,a5,80002fba <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002ede:	0c0b8863          	beqz	s7,80002fae <writei+0x10e>
    80002ee2:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ee4:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002ee8:	5cfd                	li	s9,-1
    80002eea:	a091                	j	80002f2e <writei+0x8e>
    80002eec:	02099d93          	slli	s11,s3,0x20
    80002ef0:	020ddd93          	srli	s11,s11,0x20
    80002ef4:	05848513          	addi	a0,s1,88
    80002ef8:	86ee                	mv	a3,s11
    80002efa:	8656                	mv	a2,s5
    80002efc:	85e2                	mv	a1,s8
    80002efe:	953a                	add	a0,a0,a4
    80002f00:	fffff097          	auipc	ra,0xfffff
    80002f04:	a5a080e7          	jalr	-1446(ra) # 8000195a <either_copyin>
    80002f08:	07950263          	beq	a0,s9,80002f6c <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002f0c:	8526                	mv	a0,s1
    80002f0e:	00000097          	auipc	ra,0x0
    80002f12:	798080e7          	jalr	1944(ra) # 800036a6 <log_write>
    brelse(bp);
    80002f16:	8526                	mv	a0,s1
    80002f18:	fffff097          	auipc	ra,0xfffff
    80002f1c:	50a080e7          	jalr	1290(ra) # 80002422 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f20:	01498a3b          	addw	s4,s3,s4
    80002f24:	0129893b          	addw	s2,s3,s2
    80002f28:	9aee                	add	s5,s5,s11
    80002f2a:	057a7663          	bgeu	s4,s7,80002f76 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002f2e:	000b2483          	lw	s1,0(s6)
    80002f32:	00a9559b          	srliw	a1,s2,0xa
    80002f36:	855a                	mv	a0,s6
    80002f38:	fffff097          	auipc	ra,0xfffff
    80002f3c:	7aa080e7          	jalr	1962(ra) # 800026e2 <bmap>
    80002f40:	0005059b          	sext.w	a1,a0
    80002f44:	8526                	mv	a0,s1
    80002f46:	fffff097          	auipc	ra,0xfffff
    80002f4a:	3ac080e7          	jalr	940(ra) # 800022f2 <bread>
    80002f4e:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f50:	3ff97713          	andi	a4,s2,1023
    80002f54:	40ed07bb          	subw	a5,s10,a4
    80002f58:	414b86bb          	subw	a3,s7,s4
    80002f5c:	89be                	mv	s3,a5
    80002f5e:	2781                	sext.w	a5,a5
    80002f60:	0006861b          	sext.w	a2,a3
    80002f64:	f8f674e3          	bgeu	a2,a5,80002eec <writei+0x4c>
    80002f68:	89b6                	mv	s3,a3
    80002f6a:	b749                	j	80002eec <writei+0x4c>
      brelse(bp);
    80002f6c:	8526                	mv	a0,s1
    80002f6e:	fffff097          	auipc	ra,0xfffff
    80002f72:	4b4080e7          	jalr	1204(ra) # 80002422 <brelse>
  }

  if(off > ip->size)
    80002f76:	04cb2783          	lw	a5,76(s6)
    80002f7a:	0127f463          	bgeu	a5,s2,80002f82 <writei+0xe2>
    ip->size = off;
    80002f7e:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002f82:	855a                	mv	a0,s6
    80002f84:	00000097          	auipc	ra,0x0
    80002f88:	aa4080e7          	jalr	-1372(ra) # 80002a28 <iupdate>

  return tot;
    80002f8c:	000a051b          	sext.w	a0,s4
}
    80002f90:	70a6                	ld	ra,104(sp)
    80002f92:	7406                	ld	s0,96(sp)
    80002f94:	64e6                	ld	s1,88(sp)
    80002f96:	6946                	ld	s2,80(sp)
    80002f98:	69a6                	ld	s3,72(sp)
    80002f9a:	6a06                	ld	s4,64(sp)
    80002f9c:	7ae2                	ld	s5,56(sp)
    80002f9e:	7b42                	ld	s6,48(sp)
    80002fa0:	7ba2                	ld	s7,40(sp)
    80002fa2:	7c02                	ld	s8,32(sp)
    80002fa4:	6ce2                	ld	s9,24(sp)
    80002fa6:	6d42                	ld	s10,16(sp)
    80002fa8:	6da2                	ld	s11,8(sp)
    80002faa:	6165                	addi	sp,sp,112
    80002fac:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fae:	8a5e                	mv	s4,s7
    80002fb0:	bfc9                	j	80002f82 <writei+0xe2>
    return -1;
    80002fb2:	557d                	li	a0,-1
}
    80002fb4:	8082                	ret
    return -1;
    80002fb6:	557d                	li	a0,-1
    80002fb8:	bfe1                	j	80002f90 <writei+0xf0>
    return -1;
    80002fba:	557d                	li	a0,-1
    80002fbc:	bfd1                	j	80002f90 <writei+0xf0>

0000000080002fbe <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002fbe:	1141                	addi	sp,sp,-16
    80002fc0:	e406                	sd	ra,8(sp)
    80002fc2:	e022                	sd	s0,0(sp)
    80002fc4:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002fc6:	4639                	li	a2,14
    80002fc8:	ffffd097          	auipc	ra,0xffffd
    80002fcc:	282080e7          	jalr	642(ra) # 8000024a <strncmp>
}
    80002fd0:	60a2                	ld	ra,8(sp)
    80002fd2:	6402                	ld	s0,0(sp)
    80002fd4:	0141                	addi	sp,sp,16
    80002fd6:	8082                	ret

0000000080002fd8 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002fd8:	7139                	addi	sp,sp,-64
    80002fda:	fc06                	sd	ra,56(sp)
    80002fdc:	f822                	sd	s0,48(sp)
    80002fde:	f426                	sd	s1,40(sp)
    80002fe0:	f04a                	sd	s2,32(sp)
    80002fe2:	ec4e                	sd	s3,24(sp)
    80002fe4:	e852                	sd	s4,16(sp)
    80002fe6:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002fe8:	04451703          	lh	a4,68(a0)
    80002fec:	4785                	li	a5,1
    80002fee:	00f71a63          	bne	a4,a5,80003002 <dirlookup+0x2a>
    80002ff2:	892a                	mv	s2,a0
    80002ff4:	89ae                	mv	s3,a1
    80002ff6:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002ff8:	457c                	lw	a5,76(a0)
    80002ffa:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002ffc:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002ffe:	e79d                	bnez	a5,8000302c <dirlookup+0x54>
    80003000:	a8a5                	j	80003078 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003002:	00006517          	auipc	a0,0x6
    80003006:	5b650513          	addi	a0,a0,1462 # 800095b8 <syscalls+0x1e0>
    8000300a:	00004097          	auipc	ra,0x4
    8000300e:	b66080e7          	jalr	-1178(ra) # 80006b70 <panic>
      panic("dirlookup read");
    80003012:	00006517          	auipc	a0,0x6
    80003016:	5be50513          	addi	a0,a0,1470 # 800095d0 <syscalls+0x1f8>
    8000301a:	00004097          	auipc	ra,0x4
    8000301e:	b56080e7          	jalr	-1194(ra) # 80006b70 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003022:	24c1                	addiw	s1,s1,16
    80003024:	04c92783          	lw	a5,76(s2)
    80003028:	04f4f763          	bgeu	s1,a5,80003076 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000302c:	4741                	li	a4,16
    8000302e:	86a6                	mv	a3,s1
    80003030:	fc040613          	addi	a2,s0,-64
    80003034:	4581                	li	a1,0
    80003036:	854a                	mv	a0,s2
    80003038:	00000097          	auipc	ra,0x0
    8000303c:	d70080e7          	jalr	-656(ra) # 80002da8 <readi>
    80003040:	47c1                	li	a5,16
    80003042:	fcf518e3          	bne	a0,a5,80003012 <dirlookup+0x3a>
    if(de.inum == 0)
    80003046:	fc045783          	lhu	a5,-64(s0)
    8000304a:	dfe1                	beqz	a5,80003022 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    8000304c:	fc240593          	addi	a1,s0,-62
    80003050:	854e                	mv	a0,s3
    80003052:	00000097          	auipc	ra,0x0
    80003056:	f6c080e7          	jalr	-148(ra) # 80002fbe <namecmp>
    8000305a:	f561                	bnez	a0,80003022 <dirlookup+0x4a>
      if(poff)
    8000305c:	000a0463          	beqz	s4,80003064 <dirlookup+0x8c>
        *poff = off;
    80003060:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003064:	fc045583          	lhu	a1,-64(s0)
    80003068:	00092503          	lw	a0,0(s2)
    8000306c:	fffff097          	auipc	ra,0xfffff
    80003070:	752080e7          	jalr	1874(ra) # 800027be <iget>
    80003074:	a011                	j	80003078 <dirlookup+0xa0>
  return 0;
    80003076:	4501                	li	a0,0
}
    80003078:	70e2                	ld	ra,56(sp)
    8000307a:	7442                	ld	s0,48(sp)
    8000307c:	74a2                	ld	s1,40(sp)
    8000307e:	7902                	ld	s2,32(sp)
    80003080:	69e2                	ld	s3,24(sp)
    80003082:	6a42                	ld	s4,16(sp)
    80003084:	6121                	addi	sp,sp,64
    80003086:	8082                	ret

0000000080003088 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003088:	711d                	addi	sp,sp,-96
    8000308a:	ec86                	sd	ra,88(sp)
    8000308c:	e8a2                	sd	s0,80(sp)
    8000308e:	e4a6                	sd	s1,72(sp)
    80003090:	e0ca                	sd	s2,64(sp)
    80003092:	fc4e                	sd	s3,56(sp)
    80003094:	f852                	sd	s4,48(sp)
    80003096:	f456                	sd	s5,40(sp)
    80003098:	f05a                	sd	s6,32(sp)
    8000309a:	ec5e                	sd	s7,24(sp)
    8000309c:	e862                	sd	s8,16(sp)
    8000309e:	e466                	sd	s9,8(sp)
    800030a0:	e06a                	sd	s10,0(sp)
    800030a2:	1080                	addi	s0,sp,96
    800030a4:	84aa                	mv	s1,a0
    800030a6:	8b2e                	mv	s6,a1
    800030a8:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800030aa:	00054703          	lbu	a4,0(a0)
    800030ae:	02f00793          	li	a5,47
    800030b2:	02f70363          	beq	a4,a5,800030d8 <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800030b6:	ffffe097          	auipc	ra,0xffffe
    800030ba:	de6080e7          	jalr	-538(ra) # 80000e9c <myproc>
    800030be:	15053503          	ld	a0,336(a0)
    800030c2:	00000097          	auipc	ra,0x0
    800030c6:	9f4080e7          	jalr	-1548(ra) # 80002ab6 <idup>
    800030ca:	8a2a                	mv	s4,a0
  while(*path == '/')
    800030cc:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800030d0:	4cb5                	li	s9,13
  len = path - s;
    800030d2:	4b81                	li	s7,0

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800030d4:	4c05                	li	s8,1
    800030d6:	a87d                	j	80003194 <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    800030d8:	4585                	li	a1,1
    800030da:	4505                	li	a0,1
    800030dc:	fffff097          	auipc	ra,0xfffff
    800030e0:	6e2080e7          	jalr	1762(ra) # 800027be <iget>
    800030e4:	8a2a                	mv	s4,a0
    800030e6:	b7dd                	j	800030cc <namex+0x44>
      iunlockput(ip);
    800030e8:	8552                	mv	a0,s4
    800030ea:	00000097          	auipc	ra,0x0
    800030ee:	c6c080e7          	jalr	-916(ra) # 80002d56 <iunlockput>
      return 0;
    800030f2:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800030f4:	8552                	mv	a0,s4
    800030f6:	60e6                	ld	ra,88(sp)
    800030f8:	6446                	ld	s0,80(sp)
    800030fa:	64a6                	ld	s1,72(sp)
    800030fc:	6906                	ld	s2,64(sp)
    800030fe:	79e2                	ld	s3,56(sp)
    80003100:	7a42                	ld	s4,48(sp)
    80003102:	7aa2                	ld	s5,40(sp)
    80003104:	7b02                	ld	s6,32(sp)
    80003106:	6be2                	ld	s7,24(sp)
    80003108:	6c42                	ld	s8,16(sp)
    8000310a:	6ca2                	ld	s9,8(sp)
    8000310c:	6d02                	ld	s10,0(sp)
    8000310e:	6125                	addi	sp,sp,96
    80003110:	8082                	ret
      iunlock(ip);
    80003112:	8552                	mv	a0,s4
    80003114:	00000097          	auipc	ra,0x0
    80003118:	aa2080e7          	jalr	-1374(ra) # 80002bb6 <iunlock>
      return ip;
    8000311c:	bfe1                	j	800030f4 <namex+0x6c>
      iunlockput(ip);
    8000311e:	8552                	mv	a0,s4
    80003120:	00000097          	auipc	ra,0x0
    80003124:	c36080e7          	jalr	-970(ra) # 80002d56 <iunlockput>
      return 0;
    80003128:	8a4e                	mv	s4,s3
    8000312a:	b7e9                	j	800030f4 <namex+0x6c>
  len = path - s;
    8000312c:	40998633          	sub	a2,s3,s1
    80003130:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80003134:	09acd863          	bge	s9,s10,800031c4 <namex+0x13c>
    memmove(name, s, DIRSIZ);
    80003138:	4639                	li	a2,14
    8000313a:	85a6                	mv	a1,s1
    8000313c:	8556                	mv	a0,s5
    8000313e:	ffffd097          	auipc	ra,0xffffd
    80003142:	098080e7          	jalr	152(ra) # 800001d6 <memmove>
    80003146:	84ce                	mv	s1,s3
  while(*path == '/')
    80003148:	0004c783          	lbu	a5,0(s1)
    8000314c:	01279763          	bne	a5,s2,8000315a <namex+0xd2>
    path++;
    80003150:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003152:	0004c783          	lbu	a5,0(s1)
    80003156:	ff278de3          	beq	a5,s2,80003150 <namex+0xc8>
    ilock(ip);
    8000315a:	8552                	mv	a0,s4
    8000315c:	00000097          	auipc	ra,0x0
    80003160:	998080e7          	jalr	-1640(ra) # 80002af4 <ilock>
    if(ip->type != T_DIR){
    80003164:	044a1783          	lh	a5,68(s4)
    80003168:	f98790e3          	bne	a5,s8,800030e8 <namex+0x60>
    if(nameiparent && *path == '\0'){
    8000316c:	000b0563          	beqz	s6,80003176 <namex+0xee>
    80003170:	0004c783          	lbu	a5,0(s1)
    80003174:	dfd9                	beqz	a5,80003112 <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003176:	865e                	mv	a2,s7
    80003178:	85d6                	mv	a1,s5
    8000317a:	8552                	mv	a0,s4
    8000317c:	00000097          	auipc	ra,0x0
    80003180:	e5c080e7          	jalr	-420(ra) # 80002fd8 <dirlookup>
    80003184:	89aa                	mv	s3,a0
    80003186:	dd41                	beqz	a0,8000311e <namex+0x96>
    iunlockput(ip);
    80003188:	8552                	mv	a0,s4
    8000318a:	00000097          	auipc	ra,0x0
    8000318e:	bcc080e7          	jalr	-1076(ra) # 80002d56 <iunlockput>
    ip = next;
    80003192:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003194:	0004c783          	lbu	a5,0(s1)
    80003198:	01279763          	bne	a5,s2,800031a6 <namex+0x11e>
    path++;
    8000319c:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000319e:	0004c783          	lbu	a5,0(s1)
    800031a2:	ff278de3          	beq	a5,s2,8000319c <namex+0x114>
  if(*path == 0)
    800031a6:	cb9d                	beqz	a5,800031dc <namex+0x154>
  while(*path != '/' && *path != 0)
    800031a8:	0004c783          	lbu	a5,0(s1)
    800031ac:	89a6                	mv	s3,s1
  len = path - s;
    800031ae:	8d5e                	mv	s10,s7
    800031b0:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    800031b2:	01278963          	beq	a5,s2,800031c4 <namex+0x13c>
    800031b6:	dbbd                	beqz	a5,8000312c <namex+0xa4>
    path++;
    800031b8:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800031ba:	0009c783          	lbu	a5,0(s3)
    800031be:	ff279ce3          	bne	a5,s2,800031b6 <namex+0x12e>
    800031c2:	b7ad                	j	8000312c <namex+0xa4>
    memmove(name, s, len);
    800031c4:	2601                	sext.w	a2,a2
    800031c6:	85a6                	mv	a1,s1
    800031c8:	8556                	mv	a0,s5
    800031ca:	ffffd097          	auipc	ra,0xffffd
    800031ce:	00c080e7          	jalr	12(ra) # 800001d6 <memmove>
    name[len] = 0;
    800031d2:	9d56                	add	s10,s10,s5
    800031d4:	000d0023          	sb	zero,0(s10)
    800031d8:	84ce                	mv	s1,s3
    800031da:	b7bd                	j	80003148 <namex+0xc0>
  if(nameiparent){
    800031dc:	f00b0ce3          	beqz	s6,800030f4 <namex+0x6c>
    iput(ip);
    800031e0:	8552                	mv	a0,s4
    800031e2:	00000097          	auipc	ra,0x0
    800031e6:	acc080e7          	jalr	-1332(ra) # 80002cae <iput>
    return 0;
    800031ea:	4a01                	li	s4,0
    800031ec:	b721                	j	800030f4 <namex+0x6c>

00000000800031ee <dirlink>:
{
    800031ee:	7139                	addi	sp,sp,-64
    800031f0:	fc06                	sd	ra,56(sp)
    800031f2:	f822                	sd	s0,48(sp)
    800031f4:	f426                	sd	s1,40(sp)
    800031f6:	f04a                	sd	s2,32(sp)
    800031f8:	ec4e                	sd	s3,24(sp)
    800031fa:	e852                	sd	s4,16(sp)
    800031fc:	0080                	addi	s0,sp,64
    800031fe:	892a                	mv	s2,a0
    80003200:	8a2e                	mv	s4,a1
    80003202:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003204:	4601                	li	a2,0
    80003206:	00000097          	auipc	ra,0x0
    8000320a:	dd2080e7          	jalr	-558(ra) # 80002fd8 <dirlookup>
    8000320e:	e93d                	bnez	a0,80003284 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003210:	04c92483          	lw	s1,76(s2)
    80003214:	c49d                	beqz	s1,80003242 <dirlink+0x54>
    80003216:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003218:	4741                	li	a4,16
    8000321a:	86a6                	mv	a3,s1
    8000321c:	fc040613          	addi	a2,s0,-64
    80003220:	4581                	li	a1,0
    80003222:	854a                	mv	a0,s2
    80003224:	00000097          	auipc	ra,0x0
    80003228:	b84080e7          	jalr	-1148(ra) # 80002da8 <readi>
    8000322c:	47c1                	li	a5,16
    8000322e:	06f51163          	bne	a0,a5,80003290 <dirlink+0xa2>
    if(de.inum == 0)
    80003232:	fc045783          	lhu	a5,-64(s0)
    80003236:	c791                	beqz	a5,80003242 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003238:	24c1                	addiw	s1,s1,16
    8000323a:	04c92783          	lw	a5,76(s2)
    8000323e:	fcf4ede3          	bltu	s1,a5,80003218 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003242:	4639                	li	a2,14
    80003244:	85d2                	mv	a1,s4
    80003246:	fc240513          	addi	a0,s0,-62
    8000324a:	ffffd097          	auipc	ra,0xffffd
    8000324e:	03c080e7          	jalr	60(ra) # 80000286 <strncpy>
  de.inum = inum;
    80003252:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003256:	4741                	li	a4,16
    80003258:	86a6                	mv	a3,s1
    8000325a:	fc040613          	addi	a2,s0,-64
    8000325e:	4581                	li	a1,0
    80003260:	854a                	mv	a0,s2
    80003262:	00000097          	auipc	ra,0x0
    80003266:	c3e080e7          	jalr	-962(ra) # 80002ea0 <writei>
    8000326a:	872a                	mv	a4,a0
    8000326c:	47c1                	li	a5,16
  return 0;
    8000326e:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003270:	02f71863          	bne	a4,a5,800032a0 <dirlink+0xb2>
}
    80003274:	70e2                	ld	ra,56(sp)
    80003276:	7442                	ld	s0,48(sp)
    80003278:	74a2                	ld	s1,40(sp)
    8000327a:	7902                	ld	s2,32(sp)
    8000327c:	69e2                	ld	s3,24(sp)
    8000327e:	6a42                	ld	s4,16(sp)
    80003280:	6121                	addi	sp,sp,64
    80003282:	8082                	ret
    iput(ip);
    80003284:	00000097          	auipc	ra,0x0
    80003288:	a2a080e7          	jalr	-1494(ra) # 80002cae <iput>
    return -1;
    8000328c:	557d                	li	a0,-1
    8000328e:	b7dd                	j	80003274 <dirlink+0x86>
      panic("dirlink read");
    80003290:	00006517          	auipc	a0,0x6
    80003294:	35050513          	addi	a0,a0,848 # 800095e0 <syscalls+0x208>
    80003298:	00004097          	auipc	ra,0x4
    8000329c:	8d8080e7          	jalr	-1832(ra) # 80006b70 <panic>
    panic("dirlink");
    800032a0:	00006517          	auipc	a0,0x6
    800032a4:	45050513          	addi	a0,a0,1104 # 800096f0 <syscalls+0x318>
    800032a8:	00004097          	auipc	ra,0x4
    800032ac:	8c8080e7          	jalr	-1848(ra) # 80006b70 <panic>

00000000800032b0 <namei>:

struct inode*
namei(char *path)
{
    800032b0:	1101                	addi	sp,sp,-32
    800032b2:	ec06                	sd	ra,24(sp)
    800032b4:	e822                	sd	s0,16(sp)
    800032b6:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800032b8:	fe040613          	addi	a2,s0,-32
    800032bc:	4581                	li	a1,0
    800032be:	00000097          	auipc	ra,0x0
    800032c2:	dca080e7          	jalr	-566(ra) # 80003088 <namex>
}
    800032c6:	60e2                	ld	ra,24(sp)
    800032c8:	6442                	ld	s0,16(sp)
    800032ca:	6105                	addi	sp,sp,32
    800032cc:	8082                	ret

00000000800032ce <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800032ce:	1141                	addi	sp,sp,-16
    800032d0:	e406                	sd	ra,8(sp)
    800032d2:	e022                	sd	s0,0(sp)
    800032d4:	0800                	addi	s0,sp,16
    800032d6:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800032d8:	4585                	li	a1,1
    800032da:	00000097          	auipc	ra,0x0
    800032de:	dae080e7          	jalr	-594(ra) # 80003088 <namex>
}
    800032e2:	60a2                	ld	ra,8(sp)
    800032e4:	6402                	ld	s0,0(sp)
    800032e6:	0141                	addi	sp,sp,16
    800032e8:	8082                	ret

00000000800032ea <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800032ea:	1101                	addi	sp,sp,-32
    800032ec:	ec06                	sd	ra,24(sp)
    800032ee:	e822                	sd	s0,16(sp)
    800032f0:	e426                	sd	s1,8(sp)
    800032f2:	e04a                	sd	s2,0(sp)
    800032f4:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800032f6:	00017917          	auipc	s2,0x17
    800032fa:	d4a90913          	addi	s2,s2,-694 # 8001a040 <log>
    800032fe:	01892583          	lw	a1,24(s2)
    80003302:	02892503          	lw	a0,40(s2)
    80003306:	fffff097          	auipc	ra,0xfffff
    8000330a:	fec080e7          	jalr	-20(ra) # 800022f2 <bread>
    8000330e:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003310:	02c92683          	lw	a3,44(s2)
    80003314:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003316:	02d05863          	blez	a3,80003346 <write_head+0x5c>
    8000331a:	00017797          	auipc	a5,0x17
    8000331e:	d5678793          	addi	a5,a5,-682 # 8001a070 <log+0x30>
    80003322:	05c50713          	addi	a4,a0,92
    80003326:	36fd                	addiw	a3,a3,-1
    80003328:	02069613          	slli	a2,a3,0x20
    8000332c:	01e65693          	srli	a3,a2,0x1e
    80003330:	00017617          	auipc	a2,0x17
    80003334:	d4460613          	addi	a2,a2,-700 # 8001a074 <log+0x34>
    80003338:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    8000333a:	4390                	lw	a2,0(a5)
    8000333c:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000333e:	0791                	addi	a5,a5,4
    80003340:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    80003342:	fed79ce3          	bne	a5,a3,8000333a <write_head+0x50>
  }
  bwrite(buf);
    80003346:	8526                	mv	a0,s1
    80003348:	fffff097          	auipc	ra,0xfffff
    8000334c:	09c080e7          	jalr	156(ra) # 800023e4 <bwrite>
  brelse(buf);
    80003350:	8526                	mv	a0,s1
    80003352:	fffff097          	auipc	ra,0xfffff
    80003356:	0d0080e7          	jalr	208(ra) # 80002422 <brelse>
}
    8000335a:	60e2                	ld	ra,24(sp)
    8000335c:	6442                	ld	s0,16(sp)
    8000335e:	64a2                	ld	s1,8(sp)
    80003360:	6902                	ld	s2,0(sp)
    80003362:	6105                	addi	sp,sp,32
    80003364:	8082                	ret

0000000080003366 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003366:	00017797          	auipc	a5,0x17
    8000336a:	d067a783          	lw	a5,-762(a5) # 8001a06c <log+0x2c>
    8000336e:	0af05d63          	blez	a5,80003428 <install_trans+0xc2>
{
    80003372:	7139                	addi	sp,sp,-64
    80003374:	fc06                	sd	ra,56(sp)
    80003376:	f822                	sd	s0,48(sp)
    80003378:	f426                	sd	s1,40(sp)
    8000337a:	f04a                	sd	s2,32(sp)
    8000337c:	ec4e                	sd	s3,24(sp)
    8000337e:	e852                	sd	s4,16(sp)
    80003380:	e456                	sd	s5,8(sp)
    80003382:	e05a                	sd	s6,0(sp)
    80003384:	0080                	addi	s0,sp,64
    80003386:	8b2a                	mv	s6,a0
    80003388:	00017a97          	auipc	s5,0x17
    8000338c:	ce8a8a93          	addi	s5,s5,-792 # 8001a070 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003390:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003392:	00017997          	auipc	s3,0x17
    80003396:	cae98993          	addi	s3,s3,-850 # 8001a040 <log>
    8000339a:	a00d                	j	800033bc <install_trans+0x56>
    brelse(lbuf);
    8000339c:	854a                	mv	a0,s2
    8000339e:	fffff097          	auipc	ra,0xfffff
    800033a2:	084080e7          	jalr	132(ra) # 80002422 <brelse>
    brelse(dbuf);
    800033a6:	8526                	mv	a0,s1
    800033a8:	fffff097          	auipc	ra,0xfffff
    800033ac:	07a080e7          	jalr	122(ra) # 80002422 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800033b0:	2a05                	addiw	s4,s4,1
    800033b2:	0a91                	addi	s5,s5,4
    800033b4:	02c9a783          	lw	a5,44(s3)
    800033b8:	04fa5e63          	bge	s4,a5,80003414 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800033bc:	0189a583          	lw	a1,24(s3)
    800033c0:	014585bb          	addw	a1,a1,s4
    800033c4:	2585                	addiw	a1,a1,1
    800033c6:	0289a503          	lw	a0,40(s3)
    800033ca:	fffff097          	auipc	ra,0xfffff
    800033ce:	f28080e7          	jalr	-216(ra) # 800022f2 <bread>
    800033d2:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800033d4:	000aa583          	lw	a1,0(s5)
    800033d8:	0289a503          	lw	a0,40(s3)
    800033dc:	fffff097          	auipc	ra,0xfffff
    800033e0:	f16080e7          	jalr	-234(ra) # 800022f2 <bread>
    800033e4:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800033e6:	40000613          	li	a2,1024
    800033ea:	05890593          	addi	a1,s2,88
    800033ee:	05850513          	addi	a0,a0,88
    800033f2:	ffffd097          	auipc	ra,0xffffd
    800033f6:	de4080e7          	jalr	-540(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    800033fa:	8526                	mv	a0,s1
    800033fc:	fffff097          	auipc	ra,0xfffff
    80003400:	fe8080e7          	jalr	-24(ra) # 800023e4 <bwrite>
    if(recovering == 0)
    80003404:	f80b1ce3          	bnez	s6,8000339c <install_trans+0x36>
      bunpin(dbuf);
    80003408:	8526                	mv	a0,s1
    8000340a:	fffff097          	auipc	ra,0xfffff
    8000340e:	0f2080e7          	jalr	242(ra) # 800024fc <bunpin>
    80003412:	b769                	j	8000339c <install_trans+0x36>
}
    80003414:	70e2                	ld	ra,56(sp)
    80003416:	7442                	ld	s0,48(sp)
    80003418:	74a2                	ld	s1,40(sp)
    8000341a:	7902                	ld	s2,32(sp)
    8000341c:	69e2                	ld	s3,24(sp)
    8000341e:	6a42                	ld	s4,16(sp)
    80003420:	6aa2                	ld	s5,8(sp)
    80003422:	6b02                	ld	s6,0(sp)
    80003424:	6121                	addi	sp,sp,64
    80003426:	8082                	ret
    80003428:	8082                	ret

000000008000342a <initlog>:
{
    8000342a:	7179                	addi	sp,sp,-48
    8000342c:	f406                	sd	ra,40(sp)
    8000342e:	f022                	sd	s0,32(sp)
    80003430:	ec26                	sd	s1,24(sp)
    80003432:	e84a                	sd	s2,16(sp)
    80003434:	e44e                	sd	s3,8(sp)
    80003436:	1800                	addi	s0,sp,48
    80003438:	892a                	mv	s2,a0
    8000343a:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000343c:	00017497          	auipc	s1,0x17
    80003440:	c0448493          	addi	s1,s1,-1020 # 8001a040 <log>
    80003444:	00006597          	auipc	a1,0x6
    80003448:	1ac58593          	addi	a1,a1,428 # 800095f0 <syscalls+0x218>
    8000344c:	8526                	mv	a0,s1
    8000344e:	00004097          	auipc	ra,0x4
    80003452:	bca080e7          	jalr	-1078(ra) # 80007018 <initlock>
  log.start = sb->logstart;
    80003456:	0149a583          	lw	a1,20(s3)
    8000345a:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000345c:	0109a783          	lw	a5,16(s3)
    80003460:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003462:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003466:	854a                	mv	a0,s2
    80003468:	fffff097          	auipc	ra,0xfffff
    8000346c:	e8a080e7          	jalr	-374(ra) # 800022f2 <bread>
  log.lh.n = lh->n;
    80003470:	4d34                	lw	a3,88(a0)
    80003472:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003474:	02d05663          	blez	a3,800034a0 <initlog+0x76>
    80003478:	05c50793          	addi	a5,a0,92
    8000347c:	00017717          	auipc	a4,0x17
    80003480:	bf470713          	addi	a4,a4,-1036 # 8001a070 <log+0x30>
    80003484:	36fd                	addiw	a3,a3,-1
    80003486:	02069613          	slli	a2,a3,0x20
    8000348a:	01e65693          	srli	a3,a2,0x1e
    8000348e:	06050613          	addi	a2,a0,96
    80003492:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80003494:	4390                	lw	a2,0(a5)
    80003496:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003498:	0791                	addi	a5,a5,4
    8000349a:	0711                	addi	a4,a4,4
    8000349c:	fed79ce3          	bne	a5,a3,80003494 <initlog+0x6a>
  brelse(buf);
    800034a0:	fffff097          	auipc	ra,0xfffff
    800034a4:	f82080e7          	jalr	-126(ra) # 80002422 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800034a8:	4505                	li	a0,1
    800034aa:	00000097          	auipc	ra,0x0
    800034ae:	ebc080e7          	jalr	-324(ra) # 80003366 <install_trans>
  log.lh.n = 0;
    800034b2:	00017797          	auipc	a5,0x17
    800034b6:	ba07ad23          	sw	zero,-1094(a5) # 8001a06c <log+0x2c>
  write_head(); // clear the log
    800034ba:	00000097          	auipc	ra,0x0
    800034be:	e30080e7          	jalr	-464(ra) # 800032ea <write_head>
}
    800034c2:	70a2                	ld	ra,40(sp)
    800034c4:	7402                	ld	s0,32(sp)
    800034c6:	64e2                	ld	s1,24(sp)
    800034c8:	6942                	ld	s2,16(sp)
    800034ca:	69a2                	ld	s3,8(sp)
    800034cc:	6145                	addi	sp,sp,48
    800034ce:	8082                	ret

00000000800034d0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800034d0:	1101                	addi	sp,sp,-32
    800034d2:	ec06                	sd	ra,24(sp)
    800034d4:	e822                	sd	s0,16(sp)
    800034d6:	e426                	sd	s1,8(sp)
    800034d8:	e04a                	sd	s2,0(sp)
    800034da:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800034dc:	00017517          	auipc	a0,0x17
    800034e0:	b6450513          	addi	a0,a0,-1180 # 8001a040 <log>
    800034e4:	00004097          	auipc	ra,0x4
    800034e8:	bc4080e7          	jalr	-1084(ra) # 800070a8 <acquire>
  while(1){
    if(log.committing){
    800034ec:	00017497          	auipc	s1,0x17
    800034f0:	b5448493          	addi	s1,s1,-1196 # 8001a040 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800034f4:	4979                	li	s2,30
    800034f6:	a039                	j	80003504 <begin_op+0x34>
      sleep(&log, &log.lock);
    800034f8:	85a6                	mv	a1,s1
    800034fa:	8526                	mv	a0,s1
    800034fc:	ffffe097          	auipc	ra,0xffffe
    80003500:	064080e7          	jalr	100(ra) # 80001560 <sleep>
    if(log.committing){
    80003504:	50dc                	lw	a5,36(s1)
    80003506:	fbed                	bnez	a5,800034f8 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003508:	5098                	lw	a4,32(s1)
    8000350a:	2705                	addiw	a4,a4,1
    8000350c:	0007069b          	sext.w	a3,a4
    80003510:	0027179b          	slliw	a5,a4,0x2
    80003514:	9fb9                	addw	a5,a5,a4
    80003516:	0017979b          	slliw	a5,a5,0x1
    8000351a:	54d8                	lw	a4,44(s1)
    8000351c:	9fb9                	addw	a5,a5,a4
    8000351e:	00f95963          	bge	s2,a5,80003530 <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003522:	85a6                	mv	a1,s1
    80003524:	8526                	mv	a0,s1
    80003526:	ffffe097          	auipc	ra,0xffffe
    8000352a:	03a080e7          	jalr	58(ra) # 80001560 <sleep>
    8000352e:	bfd9                	j	80003504 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003530:	00017517          	auipc	a0,0x17
    80003534:	b1050513          	addi	a0,a0,-1264 # 8001a040 <log>
    80003538:	d114                	sw	a3,32(a0)
      release(&log.lock);
    8000353a:	00004097          	auipc	ra,0x4
    8000353e:	c22080e7          	jalr	-990(ra) # 8000715c <release>
      break;
    }
  }
}
    80003542:	60e2                	ld	ra,24(sp)
    80003544:	6442                	ld	s0,16(sp)
    80003546:	64a2                	ld	s1,8(sp)
    80003548:	6902                	ld	s2,0(sp)
    8000354a:	6105                	addi	sp,sp,32
    8000354c:	8082                	ret

000000008000354e <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000354e:	7139                	addi	sp,sp,-64
    80003550:	fc06                	sd	ra,56(sp)
    80003552:	f822                	sd	s0,48(sp)
    80003554:	f426                	sd	s1,40(sp)
    80003556:	f04a                	sd	s2,32(sp)
    80003558:	ec4e                	sd	s3,24(sp)
    8000355a:	e852                	sd	s4,16(sp)
    8000355c:	e456                	sd	s5,8(sp)
    8000355e:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003560:	00017497          	auipc	s1,0x17
    80003564:	ae048493          	addi	s1,s1,-1312 # 8001a040 <log>
    80003568:	8526                	mv	a0,s1
    8000356a:	00004097          	auipc	ra,0x4
    8000356e:	b3e080e7          	jalr	-1218(ra) # 800070a8 <acquire>
  log.outstanding -= 1;
    80003572:	509c                	lw	a5,32(s1)
    80003574:	37fd                	addiw	a5,a5,-1
    80003576:	0007891b          	sext.w	s2,a5
    8000357a:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000357c:	50dc                	lw	a5,36(s1)
    8000357e:	e7b9                	bnez	a5,800035cc <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003580:	04091e63          	bnez	s2,800035dc <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80003584:	00017497          	auipc	s1,0x17
    80003588:	abc48493          	addi	s1,s1,-1348 # 8001a040 <log>
    8000358c:	4785                	li	a5,1
    8000358e:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003590:	8526                	mv	a0,s1
    80003592:	00004097          	auipc	ra,0x4
    80003596:	bca080e7          	jalr	-1078(ra) # 8000715c <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000359a:	54dc                	lw	a5,44(s1)
    8000359c:	06f04763          	bgtz	a5,8000360a <end_op+0xbc>
    acquire(&log.lock);
    800035a0:	00017497          	auipc	s1,0x17
    800035a4:	aa048493          	addi	s1,s1,-1376 # 8001a040 <log>
    800035a8:	8526                	mv	a0,s1
    800035aa:	00004097          	auipc	ra,0x4
    800035ae:	afe080e7          	jalr	-1282(ra) # 800070a8 <acquire>
    log.committing = 0;
    800035b2:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800035b6:	8526                	mv	a0,s1
    800035b8:	ffffe097          	auipc	ra,0xffffe
    800035bc:	134080e7          	jalr	308(ra) # 800016ec <wakeup>
    release(&log.lock);
    800035c0:	8526                	mv	a0,s1
    800035c2:	00004097          	auipc	ra,0x4
    800035c6:	b9a080e7          	jalr	-1126(ra) # 8000715c <release>
}
    800035ca:	a03d                	j	800035f8 <end_op+0xaa>
    panic("log.committing");
    800035cc:	00006517          	auipc	a0,0x6
    800035d0:	02c50513          	addi	a0,a0,44 # 800095f8 <syscalls+0x220>
    800035d4:	00003097          	auipc	ra,0x3
    800035d8:	59c080e7          	jalr	1436(ra) # 80006b70 <panic>
    wakeup(&log);
    800035dc:	00017497          	auipc	s1,0x17
    800035e0:	a6448493          	addi	s1,s1,-1436 # 8001a040 <log>
    800035e4:	8526                	mv	a0,s1
    800035e6:	ffffe097          	auipc	ra,0xffffe
    800035ea:	106080e7          	jalr	262(ra) # 800016ec <wakeup>
  release(&log.lock);
    800035ee:	8526                	mv	a0,s1
    800035f0:	00004097          	auipc	ra,0x4
    800035f4:	b6c080e7          	jalr	-1172(ra) # 8000715c <release>
}
    800035f8:	70e2                	ld	ra,56(sp)
    800035fa:	7442                	ld	s0,48(sp)
    800035fc:	74a2                	ld	s1,40(sp)
    800035fe:	7902                	ld	s2,32(sp)
    80003600:	69e2                	ld	s3,24(sp)
    80003602:	6a42                	ld	s4,16(sp)
    80003604:	6aa2                	ld	s5,8(sp)
    80003606:	6121                	addi	sp,sp,64
    80003608:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    8000360a:	00017a97          	auipc	s5,0x17
    8000360e:	a66a8a93          	addi	s5,s5,-1434 # 8001a070 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003612:	00017a17          	auipc	s4,0x17
    80003616:	a2ea0a13          	addi	s4,s4,-1490 # 8001a040 <log>
    8000361a:	018a2583          	lw	a1,24(s4)
    8000361e:	012585bb          	addw	a1,a1,s2
    80003622:	2585                	addiw	a1,a1,1
    80003624:	028a2503          	lw	a0,40(s4)
    80003628:	fffff097          	auipc	ra,0xfffff
    8000362c:	cca080e7          	jalr	-822(ra) # 800022f2 <bread>
    80003630:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003632:	000aa583          	lw	a1,0(s5)
    80003636:	028a2503          	lw	a0,40(s4)
    8000363a:	fffff097          	auipc	ra,0xfffff
    8000363e:	cb8080e7          	jalr	-840(ra) # 800022f2 <bread>
    80003642:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003644:	40000613          	li	a2,1024
    80003648:	05850593          	addi	a1,a0,88
    8000364c:	05848513          	addi	a0,s1,88
    80003650:	ffffd097          	auipc	ra,0xffffd
    80003654:	b86080e7          	jalr	-1146(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    80003658:	8526                	mv	a0,s1
    8000365a:	fffff097          	auipc	ra,0xfffff
    8000365e:	d8a080e7          	jalr	-630(ra) # 800023e4 <bwrite>
    brelse(from);
    80003662:	854e                	mv	a0,s3
    80003664:	fffff097          	auipc	ra,0xfffff
    80003668:	dbe080e7          	jalr	-578(ra) # 80002422 <brelse>
    brelse(to);
    8000366c:	8526                	mv	a0,s1
    8000366e:	fffff097          	auipc	ra,0xfffff
    80003672:	db4080e7          	jalr	-588(ra) # 80002422 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003676:	2905                	addiw	s2,s2,1
    80003678:	0a91                	addi	s5,s5,4
    8000367a:	02ca2783          	lw	a5,44(s4)
    8000367e:	f8f94ee3          	blt	s2,a5,8000361a <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003682:	00000097          	auipc	ra,0x0
    80003686:	c68080e7          	jalr	-920(ra) # 800032ea <write_head>
    install_trans(0); // Now install writes to home locations
    8000368a:	4501                	li	a0,0
    8000368c:	00000097          	auipc	ra,0x0
    80003690:	cda080e7          	jalr	-806(ra) # 80003366 <install_trans>
    log.lh.n = 0;
    80003694:	00017797          	auipc	a5,0x17
    80003698:	9c07ac23          	sw	zero,-1576(a5) # 8001a06c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000369c:	00000097          	auipc	ra,0x0
    800036a0:	c4e080e7          	jalr	-946(ra) # 800032ea <write_head>
    800036a4:	bdf5                	j	800035a0 <end_op+0x52>

00000000800036a6 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800036a6:	1101                	addi	sp,sp,-32
    800036a8:	ec06                	sd	ra,24(sp)
    800036aa:	e822                	sd	s0,16(sp)
    800036ac:	e426                	sd	s1,8(sp)
    800036ae:	e04a                	sd	s2,0(sp)
    800036b0:	1000                	addi	s0,sp,32
    800036b2:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800036b4:	00017917          	auipc	s2,0x17
    800036b8:	98c90913          	addi	s2,s2,-1652 # 8001a040 <log>
    800036bc:	854a                	mv	a0,s2
    800036be:	00004097          	auipc	ra,0x4
    800036c2:	9ea080e7          	jalr	-1558(ra) # 800070a8 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800036c6:	02c92603          	lw	a2,44(s2)
    800036ca:	47f5                	li	a5,29
    800036cc:	06c7c563          	blt	a5,a2,80003736 <log_write+0x90>
    800036d0:	00017797          	auipc	a5,0x17
    800036d4:	98c7a783          	lw	a5,-1652(a5) # 8001a05c <log+0x1c>
    800036d8:	37fd                	addiw	a5,a5,-1
    800036da:	04f65e63          	bge	a2,a5,80003736 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800036de:	00017797          	auipc	a5,0x17
    800036e2:	9827a783          	lw	a5,-1662(a5) # 8001a060 <log+0x20>
    800036e6:	06f05063          	blez	a5,80003746 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800036ea:	4781                	li	a5,0
    800036ec:	06c05563          	blez	a2,80003756 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800036f0:	44cc                	lw	a1,12(s1)
    800036f2:	00017717          	auipc	a4,0x17
    800036f6:	97e70713          	addi	a4,a4,-1666 # 8001a070 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800036fa:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800036fc:	4314                	lw	a3,0(a4)
    800036fe:	04b68c63          	beq	a3,a1,80003756 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003702:	2785                	addiw	a5,a5,1
    80003704:	0711                	addi	a4,a4,4
    80003706:	fef61be3          	bne	a2,a5,800036fc <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000370a:	0621                	addi	a2,a2,8
    8000370c:	060a                	slli	a2,a2,0x2
    8000370e:	00017797          	auipc	a5,0x17
    80003712:	93278793          	addi	a5,a5,-1742 # 8001a040 <log>
    80003716:	97b2                	add	a5,a5,a2
    80003718:	44d8                	lw	a4,12(s1)
    8000371a:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000371c:	8526                	mv	a0,s1
    8000371e:	fffff097          	auipc	ra,0xfffff
    80003722:	da2080e7          	jalr	-606(ra) # 800024c0 <bpin>
    log.lh.n++;
    80003726:	00017717          	auipc	a4,0x17
    8000372a:	91a70713          	addi	a4,a4,-1766 # 8001a040 <log>
    8000372e:	575c                	lw	a5,44(a4)
    80003730:	2785                	addiw	a5,a5,1
    80003732:	d75c                	sw	a5,44(a4)
    80003734:	a82d                	j	8000376e <log_write+0xc8>
    panic("too big a transaction");
    80003736:	00006517          	auipc	a0,0x6
    8000373a:	ed250513          	addi	a0,a0,-302 # 80009608 <syscalls+0x230>
    8000373e:	00003097          	auipc	ra,0x3
    80003742:	432080e7          	jalr	1074(ra) # 80006b70 <panic>
    panic("log_write outside of trans");
    80003746:	00006517          	auipc	a0,0x6
    8000374a:	eda50513          	addi	a0,a0,-294 # 80009620 <syscalls+0x248>
    8000374e:	00003097          	auipc	ra,0x3
    80003752:	422080e7          	jalr	1058(ra) # 80006b70 <panic>
  log.lh.block[i] = b->blockno;
    80003756:	00878693          	addi	a3,a5,8
    8000375a:	068a                	slli	a3,a3,0x2
    8000375c:	00017717          	auipc	a4,0x17
    80003760:	8e470713          	addi	a4,a4,-1820 # 8001a040 <log>
    80003764:	9736                	add	a4,a4,a3
    80003766:	44d4                	lw	a3,12(s1)
    80003768:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000376a:	faf609e3          	beq	a2,a5,8000371c <log_write+0x76>
  }
  release(&log.lock);
    8000376e:	00017517          	auipc	a0,0x17
    80003772:	8d250513          	addi	a0,a0,-1838 # 8001a040 <log>
    80003776:	00004097          	auipc	ra,0x4
    8000377a:	9e6080e7          	jalr	-1562(ra) # 8000715c <release>
}
    8000377e:	60e2                	ld	ra,24(sp)
    80003780:	6442                	ld	s0,16(sp)
    80003782:	64a2                	ld	s1,8(sp)
    80003784:	6902                	ld	s2,0(sp)
    80003786:	6105                	addi	sp,sp,32
    80003788:	8082                	ret

000000008000378a <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000378a:	1101                	addi	sp,sp,-32
    8000378c:	ec06                	sd	ra,24(sp)
    8000378e:	e822                	sd	s0,16(sp)
    80003790:	e426                	sd	s1,8(sp)
    80003792:	e04a                	sd	s2,0(sp)
    80003794:	1000                	addi	s0,sp,32
    80003796:	84aa                	mv	s1,a0
    80003798:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000379a:	00006597          	auipc	a1,0x6
    8000379e:	ea658593          	addi	a1,a1,-346 # 80009640 <syscalls+0x268>
    800037a2:	0521                	addi	a0,a0,8
    800037a4:	00004097          	auipc	ra,0x4
    800037a8:	874080e7          	jalr	-1932(ra) # 80007018 <initlock>
  lk->name = name;
    800037ac:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800037b0:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800037b4:	0204a423          	sw	zero,40(s1)
}
    800037b8:	60e2                	ld	ra,24(sp)
    800037ba:	6442                	ld	s0,16(sp)
    800037bc:	64a2                	ld	s1,8(sp)
    800037be:	6902                	ld	s2,0(sp)
    800037c0:	6105                	addi	sp,sp,32
    800037c2:	8082                	ret

00000000800037c4 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800037c4:	1101                	addi	sp,sp,-32
    800037c6:	ec06                	sd	ra,24(sp)
    800037c8:	e822                	sd	s0,16(sp)
    800037ca:	e426                	sd	s1,8(sp)
    800037cc:	e04a                	sd	s2,0(sp)
    800037ce:	1000                	addi	s0,sp,32
    800037d0:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800037d2:	00850913          	addi	s2,a0,8
    800037d6:	854a                	mv	a0,s2
    800037d8:	00004097          	auipc	ra,0x4
    800037dc:	8d0080e7          	jalr	-1840(ra) # 800070a8 <acquire>
  while (lk->locked) {
    800037e0:	409c                	lw	a5,0(s1)
    800037e2:	cb89                	beqz	a5,800037f4 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800037e4:	85ca                	mv	a1,s2
    800037e6:	8526                	mv	a0,s1
    800037e8:	ffffe097          	auipc	ra,0xffffe
    800037ec:	d78080e7          	jalr	-648(ra) # 80001560 <sleep>
  while (lk->locked) {
    800037f0:	409c                	lw	a5,0(s1)
    800037f2:	fbed                	bnez	a5,800037e4 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800037f4:	4785                	li	a5,1
    800037f6:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800037f8:	ffffd097          	auipc	ra,0xffffd
    800037fc:	6a4080e7          	jalr	1700(ra) # 80000e9c <myproc>
    80003800:	591c                	lw	a5,48(a0)
    80003802:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003804:	854a                	mv	a0,s2
    80003806:	00004097          	auipc	ra,0x4
    8000380a:	956080e7          	jalr	-1706(ra) # 8000715c <release>
}
    8000380e:	60e2                	ld	ra,24(sp)
    80003810:	6442                	ld	s0,16(sp)
    80003812:	64a2                	ld	s1,8(sp)
    80003814:	6902                	ld	s2,0(sp)
    80003816:	6105                	addi	sp,sp,32
    80003818:	8082                	ret

000000008000381a <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000381a:	1101                	addi	sp,sp,-32
    8000381c:	ec06                	sd	ra,24(sp)
    8000381e:	e822                	sd	s0,16(sp)
    80003820:	e426                	sd	s1,8(sp)
    80003822:	e04a                	sd	s2,0(sp)
    80003824:	1000                	addi	s0,sp,32
    80003826:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003828:	00850913          	addi	s2,a0,8
    8000382c:	854a                	mv	a0,s2
    8000382e:	00004097          	auipc	ra,0x4
    80003832:	87a080e7          	jalr	-1926(ra) # 800070a8 <acquire>
  lk->locked = 0;
    80003836:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000383a:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000383e:	8526                	mv	a0,s1
    80003840:	ffffe097          	auipc	ra,0xffffe
    80003844:	eac080e7          	jalr	-340(ra) # 800016ec <wakeup>
  release(&lk->lk);
    80003848:	854a                	mv	a0,s2
    8000384a:	00004097          	auipc	ra,0x4
    8000384e:	912080e7          	jalr	-1774(ra) # 8000715c <release>
}
    80003852:	60e2                	ld	ra,24(sp)
    80003854:	6442                	ld	s0,16(sp)
    80003856:	64a2                	ld	s1,8(sp)
    80003858:	6902                	ld	s2,0(sp)
    8000385a:	6105                	addi	sp,sp,32
    8000385c:	8082                	ret

000000008000385e <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000385e:	7179                	addi	sp,sp,-48
    80003860:	f406                	sd	ra,40(sp)
    80003862:	f022                	sd	s0,32(sp)
    80003864:	ec26                	sd	s1,24(sp)
    80003866:	e84a                	sd	s2,16(sp)
    80003868:	e44e                	sd	s3,8(sp)
    8000386a:	1800                	addi	s0,sp,48
    8000386c:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000386e:	00850913          	addi	s2,a0,8
    80003872:	854a                	mv	a0,s2
    80003874:	00004097          	auipc	ra,0x4
    80003878:	834080e7          	jalr	-1996(ra) # 800070a8 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000387c:	409c                	lw	a5,0(s1)
    8000387e:	ef99                	bnez	a5,8000389c <holdingsleep+0x3e>
    80003880:	4481                	li	s1,0
  release(&lk->lk);
    80003882:	854a                	mv	a0,s2
    80003884:	00004097          	auipc	ra,0x4
    80003888:	8d8080e7          	jalr	-1832(ra) # 8000715c <release>
  return r;
}
    8000388c:	8526                	mv	a0,s1
    8000388e:	70a2                	ld	ra,40(sp)
    80003890:	7402                	ld	s0,32(sp)
    80003892:	64e2                	ld	s1,24(sp)
    80003894:	6942                	ld	s2,16(sp)
    80003896:	69a2                	ld	s3,8(sp)
    80003898:	6145                	addi	sp,sp,48
    8000389a:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    8000389c:	0284a983          	lw	s3,40(s1)
    800038a0:	ffffd097          	auipc	ra,0xffffd
    800038a4:	5fc080e7          	jalr	1532(ra) # 80000e9c <myproc>
    800038a8:	5904                	lw	s1,48(a0)
    800038aa:	413484b3          	sub	s1,s1,s3
    800038ae:	0014b493          	seqz	s1,s1
    800038b2:	bfc1                	j	80003882 <holdingsleep+0x24>

00000000800038b4 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800038b4:	1141                	addi	sp,sp,-16
    800038b6:	e406                	sd	ra,8(sp)
    800038b8:	e022                	sd	s0,0(sp)
    800038ba:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800038bc:	00006597          	auipc	a1,0x6
    800038c0:	d9458593          	addi	a1,a1,-620 # 80009650 <syscalls+0x278>
    800038c4:	00017517          	auipc	a0,0x17
    800038c8:	8c450513          	addi	a0,a0,-1852 # 8001a188 <ftable>
    800038cc:	00003097          	auipc	ra,0x3
    800038d0:	74c080e7          	jalr	1868(ra) # 80007018 <initlock>
}
    800038d4:	60a2                	ld	ra,8(sp)
    800038d6:	6402                	ld	s0,0(sp)
    800038d8:	0141                	addi	sp,sp,16
    800038da:	8082                	ret

00000000800038dc <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800038dc:	1101                	addi	sp,sp,-32
    800038de:	ec06                	sd	ra,24(sp)
    800038e0:	e822                	sd	s0,16(sp)
    800038e2:	e426                	sd	s1,8(sp)
    800038e4:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800038e6:	00017517          	auipc	a0,0x17
    800038ea:	8a250513          	addi	a0,a0,-1886 # 8001a188 <ftable>
    800038ee:	00003097          	auipc	ra,0x3
    800038f2:	7ba080e7          	jalr	1978(ra) # 800070a8 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800038f6:	00017497          	auipc	s1,0x17
    800038fa:	8aa48493          	addi	s1,s1,-1878 # 8001a1a0 <ftable+0x18>
    800038fe:	00018717          	auipc	a4,0x18
    80003902:	b6270713          	addi	a4,a4,-1182 # 8001b460 <ftable+0x12d8>
    if(f->ref == 0){
    80003906:	40dc                	lw	a5,4(s1)
    80003908:	cf99                	beqz	a5,80003926 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000390a:	03048493          	addi	s1,s1,48
    8000390e:	fee49ce3          	bne	s1,a4,80003906 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003912:	00017517          	auipc	a0,0x17
    80003916:	87650513          	addi	a0,a0,-1930 # 8001a188 <ftable>
    8000391a:	00004097          	auipc	ra,0x4
    8000391e:	842080e7          	jalr	-1982(ra) # 8000715c <release>
  return 0;
    80003922:	4481                	li	s1,0
    80003924:	a819                	j	8000393a <filealloc+0x5e>
      f->ref = 1;
    80003926:	4785                	li	a5,1
    80003928:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    8000392a:	00017517          	auipc	a0,0x17
    8000392e:	85e50513          	addi	a0,a0,-1954 # 8001a188 <ftable>
    80003932:	00004097          	auipc	ra,0x4
    80003936:	82a080e7          	jalr	-2006(ra) # 8000715c <release>
}
    8000393a:	8526                	mv	a0,s1
    8000393c:	60e2                	ld	ra,24(sp)
    8000393e:	6442                	ld	s0,16(sp)
    80003940:	64a2                	ld	s1,8(sp)
    80003942:	6105                	addi	sp,sp,32
    80003944:	8082                	ret

0000000080003946 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003946:	1101                	addi	sp,sp,-32
    80003948:	ec06                	sd	ra,24(sp)
    8000394a:	e822                	sd	s0,16(sp)
    8000394c:	e426                	sd	s1,8(sp)
    8000394e:	1000                	addi	s0,sp,32
    80003950:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003952:	00017517          	auipc	a0,0x17
    80003956:	83650513          	addi	a0,a0,-1994 # 8001a188 <ftable>
    8000395a:	00003097          	auipc	ra,0x3
    8000395e:	74e080e7          	jalr	1870(ra) # 800070a8 <acquire>
  if(f->ref < 1)
    80003962:	40dc                	lw	a5,4(s1)
    80003964:	02f05263          	blez	a5,80003988 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003968:	2785                	addiw	a5,a5,1
    8000396a:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    8000396c:	00017517          	auipc	a0,0x17
    80003970:	81c50513          	addi	a0,a0,-2020 # 8001a188 <ftable>
    80003974:	00003097          	auipc	ra,0x3
    80003978:	7e8080e7          	jalr	2024(ra) # 8000715c <release>
  return f;
}
    8000397c:	8526                	mv	a0,s1
    8000397e:	60e2                	ld	ra,24(sp)
    80003980:	6442                	ld	s0,16(sp)
    80003982:	64a2                	ld	s1,8(sp)
    80003984:	6105                	addi	sp,sp,32
    80003986:	8082                	ret
    panic("filedup");
    80003988:	00006517          	auipc	a0,0x6
    8000398c:	cd050513          	addi	a0,a0,-816 # 80009658 <syscalls+0x280>
    80003990:	00003097          	auipc	ra,0x3
    80003994:	1e0080e7          	jalr	480(ra) # 80006b70 <panic>

0000000080003998 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003998:	7139                	addi	sp,sp,-64
    8000399a:	fc06                	sd	ra,56(sp)
    8000399c:	f822                	sd	s0,48(sp)
    8000399e:	f426                	sd	s1,40(sp)
    800039a0:	f04a                	sd	s2,32(sp)
    800039a2:	ec4e                	sd	s3,24(sp)
    800039a4:	e852                	sd	s4,16(sp)
    800039a6:	e456                	sd	s5,8(sp)
    800039a8:	e05a                	sd	s6,0(sp)
    800039aa:	0080                	addi	s0,sp,64
    800039ac:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800039ae:	00016517          	auipc	a0,0x16
    800039b2:	7da50513          	addi	a0,a0,2010 # 8001a188 <ftable>
    800039b6:	00003097          	auipc	ra,0x3
    800039ba:	6f2080e7          	jalr	1778(ra) # 800070a8 <acquire>
  if(f->ref < 1)
    800039be:	40dc                	lw	a5,4(s1)
    800039c0:	04f05f63          	blez	a5,80003a1e <fileclose+0x86>
    panic("fileclose");
  if(--f->ref > 0){
    800039c4:	37fd                	addiw	a5,a5,-1
    800039c6:	0007871b          	sext.w	a4,a5
    800039ca:	c0dc                	sw	a5,4(s1)
    800039cc:	06e04163          	bgtz	a4,80003a2e <fileclose+0x96>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800039d0:	0004a903          	lw	s2,0(s1)
    800039d4:	0094ca83          	lbu	s5,9(s1)
    800039d8:	0104ba03          	ld	s4,16(s1)
    800039dc:	0184b983          	ld	s3,24(s1)
    800039e0:	0204bb03          	ld	s6,32(s1)
  f->ref = 0;
    800039e4:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800039e8:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800039ec:	00016517          	auipc	a0,0x16
    800039f0:	79c50513          	addi	a0,a0,1948 # 8001a188 <ftable>
    800039f4:	00003097          	auipc	ra,0x3
    800039f8:	768080e7          	jalr	1896(ra) # 8000715c <release>

  if(ff.type == FD_PIPE){
    800039fc:	4785                	li	a5,1
    800039fe:	04f90a63          	beq	s2,a5,80003a52 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003a02:	ffe9079b          	addiw	a5,s2,-2
    80003a06:	4705                	li	a4,1
    80003a08:	04f77c63          	bgeu	a4,a5,80003a60 <fileclose+0xc8>
    begin_op();
    iput(ff.ip);
    end_op();
  }
#ifdef LAB_NET
  else if(ff.type == FD_SOCK){
    80003a0c:	4791                	li	a5,4
    80003a0e:	02f91863          	bne	s2,a5,80003a3e <fileclose+0xa6>
    sockclose(ff.sock);
    80003a12:	855a                	mv	a0,s6
    80003a14:	00003097          	auipc	ra,0x3
    80003a18:	8f4080e7          	jalr	-1804(ra) # 80006308 <sockclose>
    80003a1c:	a00d                	j	80003a3e <fileclose+0xa6>
    panic("fileclose");
    80003a1e:	00006517          	auipc	a0,0x6
    80003a22:	c4250513          	addi	a0,a0,-958 # 80009660 <syscalls+0x288>
    80003a26:	00003097          	auipc	ra,0x3
    80003a2a:	14a080e7          	jalr	330(ra) # 80006b70 <panic>
    release(&ftable.lock);
    80003a2e:	00016517          	auipc	a0,0x16
    80003a32:	75a50513          	addi	a0,a0,1882 # 8001a188 <ftable>
    80003a36:	00003097          	auipc	ra,0x3
    80003a3a:	726080e7          	jalr	1830(ra) # 8000715c <release>
  }
#endif
}
    80003a3e:	70e2                	ld	ra,56(sp)
    80003a40:	7442                	ld	s0,48(sp)
    80003a42:	74a2                	ld	s1,40(sp)
    80003a44:	7902                	ld	s2,32(sp)
    80003a46:	69e2                	ld	s3,24(sp)
    80003a48:	6a42                	ld	s4,16(sp)
    80003a4a:	6aa2                	ld	s5,8(sp)
    80003a4c:	6b02                	ld	s6,0(sp)
    80003a4e:	6121                	addi	sp,sp,64
    80003a50:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003a52:	85d6                	mv	a1,s5
    80003a54:	8552                	mv	a0,s4
    80003a56:	00000097          	auipc	ra,0x0
    80003a5a:	37c080e7          	jalr	892(ra) # 80003dd2 <pipeclose>
    80003a5e:	b7c5                	j	80003a3e <fileclose+0xa6>
    begin_op();
    80003a60:	00000097          	auipc	ra,0x0
    80003a64:	a70080e7          	jalr	-1424(ra) # 800034d0 <begin_op>
    iput(ff.ip);
    80003a68:	854e                	mv	a0,s3
    80003a6a:	fffff097          	auipc	ra,0xfffff
    80003a6e:	244080e7          	jalr	580(ra) # 80002cae <iput>
    end_op();
    80003a72:	00000097          	auipc	ra,0x0
    80003a76:	adc080e7          	jalr	-1316(ra) # 8000354e <end_op>
    80003a7a:	b7d1                	j	80003a3e <fileclose+0xa6>

0000000080003a7c <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003a7c:	715d                	addi	sp,sp,-80
    80003a7e:	e486                	sd	ra,72(sp)
    80003a80:	e0a2                	sd	s0,64(sp)
    80003a82:	fc26                	sd	s1,56(sp)
    80003a84:	f84a                	sd	s2,48(sp)
    80003a86:	f44e                	sd	s3,40(sp)
    80003a88:	0880                	addi	s0,sp,80
    80003a8a:	84aa                	mv	s1,a0
    80003a8c:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003a8e:	ffffd097          	auipc	ra,0xffffd
    80003a92:	40e080e7          	jalr	1038(ra) # 80000e9c <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003a96:	409c                	lw	a5,0(s1)
    80003a98:	37f9                	addiw	a5,a5,-2
    80003a9a:	4705                	li	a4,1
    80003a9c:	04f76763          	bltu	a4,a5,80003aea <filestat+0x6e>
    80003aa0:	892a                	mv	s2,a0
    ilock(f->ip);
    80003aa2:	6c88                	ld	a0,24(s1)
    80003aa4:	fffff097          	auipc	ra,0xfffff
    80003aa8:	050080e7          	jalr	80(ra) # 80002af4 <ilock>
    stati(f->ip, &st);
    80003aac:	fb840593          	addi	a1,s0,-72
    80003ab0:	6c88                	ld	a0,24(s1)
    80003ab2:	fffff097          	auipc	ra,0xfffff
    80003ab6:	2cc080e7          	jalr	716(ra) # 80002d7e <stati>
    iunlock(f->ip);
    80003aba:	6c88                	ld	a0,24(s1)
    80003abc:	fffff097          	auipc	ra,0xfffff
    80003ac0:	0fa080e7          	jalr	250(ra) # 80002bb6 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003ac4:	46e1                	li	a3,24
    80003ac6:	fb840613          	addi	a2,s0,-72
    80003aca:	85ce                	mv	a1,s3
    80003acc:	05093503          	ld	a0,80(s2)
    80003ad0:	ffffd097          	auipc	ra,0xffffd
    80003ad4:	094080e7          	jalr	148(ra) # 80000b64 <copyout>
    80003ad8:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003adc:	60a6                	ld	ra,72(sp)
    80003ade:	6406                	ld	s0,64(sp)
    80003ae0:	74e2                	ld	s1,56(sp)
    80003ae2:	7942                	ld	s2,48(sp)
    80003ae4:	79a2                	ld	s3,40(sp)
    80003ae6:	6161                	addi	sp,sp,80
    80003ae8:	8082                	ret
  return -1;
    80003aea:	557d                	li	a0,-1
    80003aec:	bfc5                	j	80003adc <filestat+0x60>

0000000080003aee <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003aee:	7179                	addi	sp,sp,-48
    80003af0:	f406                	sd	ra,40(sp)
    80003af2:	f022                	sd	s0,32(sp)
    80003af4:	ec26                	sd	s1,24(sp)
    80003af6:	e84a                	sd	s2,16(sp)
    80003af8:	e44e                	sd	s3,8(sp)
    80003afa:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003afc:	00854783          	lbu	a5,8(a0)
    80003b00:	cfc5                	beqz	a5,80003bb8 <fileread+0xca>
    80003b02:	84aa                	mv	s1,a0
    80003b04:	89ae                	mv	s3,a1
    80003b06:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003b08:	411c                	lw	a5,0(a0)
    80003b0a:	4705                	li	a4,1
    80003b0c:	02e78963          	beq	a5,a4,80003b3e <fileread+0x50>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003b10:	470d                	li	a4,3
    80003b12:	02e78d63          	beq	a5,a4,80003b4c <fileread+0x5e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003b16:	4709                	li	a4,2
    80003b18:	04e78e63          	beq	a5,a4,80003b74 <fileread+0x86>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
  }
#ifdef LAB_NET
  else if(f->type == FD_SOCK){
    80003b1c:	4711                	li	a4,4
    80003b1e:	08e79563          	bne	a5,a4,80003ba8 <fileread+0xba>
    r = sockread(f->sock, addr, n);
    80003b22:	7108                	ld	a0,32(a0)
    80003b24:	00003097          	auipc	ra,0x3
    80003b28:	874080e7          	jalr	-1932(ra) # 80006398 <sockread>
    80003b2c:	892a                	mv	s2,a0
  else {
    panic("fileread");
  }

  return r;
}
    80003b2e:	854a                	mv	a0,s2
    80003b30:	70a2                	ld	ra,40(sp)
    80003b32:	7402                	ld	s0,32(sp)
    80003b34:	64e2                	ld	s1,24(sp)
    80003b36:	6942                	ld	s2,16(sp)
    80003b38:	69a2                	ld	s3,8(sp)
    80003b3a:	6145                	addi	sp,sp,48
    80003b3c:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003b3e:	6908                	ld	a0,16(a0)
    80003b40:	00000097          	auipc	ra,0x0
    80003b44:	3f4080e7          	jalr	1012(ra) # 80003f34 <piperead>
    80003b48:	892a                	mv	s2,a0
    80003b4a:	b7d5                	j	80003b2e <fileread+0x40>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003b4c:	02c51783          	lh	a5,44(a0)
    80003b50:	03079693          	slli	a3,a5,0x30
    80003b54:	92c1                	srli	a3,a3,0x30
    80003b56:	4725                	li	a4,9
    80003b58:	06d76263          	bltu	a4,a3,80003bbc <fileread+0xce>
    80003b5c:	0792                	slli	a5,a5,0x4
    80003b5e:	00016717          	auipc	a4,0x16
    80003b62:	58a70713          	addi	a4,a4,1418 # 8001a0e8 <devsw>
    80003b66:	97ba                	add	a5,a5,a4
    80003b68:	639c                	ld	a5,0(a5)
    80003b6a:	cbb9                	beqz	a5,80003bc0 <fileread+0xd2>
    r = devsw[f->major].read(1, addr, n);
    80003b6c:	4505                	li	a0,1
    80003b6e:	9782                	jalr	a5
    80003b70:	892a                	mv	s2,a0
    80003b72:	bf75                	j	80003b2e <fileread+0x40>
    ilock(f->ip);
    80003b74:	6d08                	ld	a0,24(a0)
    80003b76:	fffff097          	auipc	ra,0xfffff
    80003b7a:	f7e080e7          	jalr	-130(ra) # 80002af4 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003b7e:	874a                	mv	a4,s2
    80003b80:	5494                	lw	a3,40(s1)
    80003b82:	864e                	mv	a2,s3
    80003b84:	4585                	li	a1,1
    80003b86:	6c88                	ld	a0,24(s1)
    80003b88:	fffff097          	auipc	ra,0xfffff
    80003b8c:	220080e7          	jalr	544(ra) # 80002da8 <readi>
    80003b90:	892a                	mv	s2,a0
    80003b92:	00a05563          	blez	a0,80003b9c <fileread+0xae>
      f->off += r;
    80003b96:	549c                	lw	a5,40(s1)
    80003b98:	9fa9                	addw	a5,a5,a0
    80003b9a:	d49c                	sw	a5,40(s1)
    iunlock(f->ip);
    80003b9c:	6c88                	ld	a0,24(s1)
    80003b9e:	fffff097          	auipc	ra,0xfffff
    80003ba2:	018080e7          	jalr	24(ra) # 80002bb6 <iunlock>
    80003ba6:	b761                	j	80003b2e <fileread+0x40>
    panic("fileread");
    80003ba8:	00006517          	auipc	a0,0x6
    80003bac:	ac850513          	addi	a0,a0,-1336 # 80009670 <syscalls+0x298>
    80003bb0:	00003097          	auipc	ra,0x3
    80003bb4:	fc0080e7          	jalr	-64(ra) # 80006b70 <panic>
    return -1;
    80003bb8:	597d                	li	s2,-1
    80003bba:	bf95                	j	80003b2e <fileread+0x40>
      return -1;
    80003bbc:	597d                	li	s2,-1
    80003bbe:	bf85                	j	80003b2e <fileread+0x40>
    80003bc0:	597d                	li	s2,-1
    80003bc2:	b7b5                	j	80003b2e <fileread+0x40>

0000000080003bc4 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003bc4:	00954783          	lbu	a5,9(a0)
    80003bc8:	12078263          	beqz	a5,80003cec <filewrite+0x128>
{
    80003bcc:	715d                	addi	sp,sp,-80
    80003bce:	e486                	sd	ra,72(sp)
    80003bd0:	e0a2                	sd	s0,64(sp)
    80003bd2:	fc26                	sd	s1,56(sp)
    80003bd4:	f84a                	sd	s2,48(sp)
    80003bd6:	f44e                	sd	s3,40(sp)
    80003bd8:	f052                	sd	s4,32(sp)
    80003bda:	ec56                	sd	s5,24(sp)
    80003bdc:	e85a                	sd	s6,16(sp)
    80003bde:	e45e                	sd	s7,8(sp)
    80003be0:	e062                	sd	s8,0(sp)
    80003be2:	0880                	addi	s0,sp,80
    80003be4:	84aa                	mv	s1,a0
    80003be6:	8aae                	mv	s5,a1
    80003be8:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003bea:	411c                	lw	a5,0(a0)
    80003bec:	4705                	li	a4,1
    80003bee:	02e78c63          	beq	a5,a4,80003c26 <filewrite+0x62>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003bf2:	470d                	li	a4,3
    80003bf4:	02e78f63          	beq	a5,a4,80003c32 <filewrite+0x6e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003bf8:	4709                	li	a4,2
    80003bfa:	04e78f63          	beq	a5,a4,80003c58 <filewrite+0x94>
      i += r;
    }
    ret = (i == n ? n : -1);
  }
#ifdef LAB_NET
  else if(f->type == FD_SOCK){
    80003bfe:	4711                	li	a4,4
    80003c00:	0ce79e63          	bne	a5,a4,80003cdc <filewrite+0x118>
    ret = sockwrite(f->sock, addr, n);
    80003c04:	7108                	ld	a0,32(a0)
    80003c06:	00003097          	auipc	ra,0x3
    80003c0a:	864080e7          	jalr	-1948(ra) # 8000646a <sockwrite>
  else {
    panic("filewrite");
  }

  return ret;
}
    80003c0e:	60a6                	ld	ra,72(sp)
    80003c10:	6406                	ld	s0,64(sp)
    80003c12:	74e2                	ld	s1,56(sp)
    80003c14:	7942                	ld	s2,48(sp)
    80003c16:	79a2                	ld	s3,40(sp)
    80003c18:	7a02                	ld	s4,32(sp)
    80003c1a:	6ae2                	ld	s5,24(sp)
    80003c1c:	6b42                	ld	s6,16(sp)
    80003c1e:	6ba2                	ld	s7,8(sp)
    80003c20:	6c02                	ld	s8,0(sp)
    80003c22:	6161                	addi	sp,sp,80
    80003c24:	8082                	ret
    ret = pipewrite(f->pipe, addr, n);
    80003c26:	6908                	ld	a0,16(a0)
    80003c28:	00000097          	auipc	ra,0x0
    80003c2c:	21a080e7          	jalr	538(ra) # 80003e42 <pipewrite>
    80003c30:	bff9                	j	80003c0e <filewrite+0x4a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003c32:	02c51783          	lh	a5,44(a0)
    80003c36:	03079693          	slli	a3,a5,0x30
    80003c3a:	92c1                	srli	a3,a3,0x30
    80003c3c:	4725                	li	a4,9
    80003c3e:	0ad76963          	bltu	a4,a3,80003cf0 <filewrite+0x12c>
    80003c42:	0792                	slli	a5,a5,0x4
    80003c44:	00016717          	auipc	a4,0x16
    80003c48:	4a470713          	addi	a4,a4,1188 # 8001a0e8 <devsw>
    80003c4c:	97ba                	add	a5,a5,a4
    80003c4e:	679c                	ld	a5,8(a5)
    80003c50:	c3d5                	beqz	a5,80003cf4 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003c52:	4505                	li	a0,1
    80003c54:	9782                	jalr	a5
    80003c56:	bf65                	j	80003c0e <filewrite+0x4a>
    while(i < n){
    80003c58:	06c05c63          	blez	a2,80003cd0 <filewrite+0x10c>
    int i = 0;
    80003c5c:	4981                	li	s3,0
    80003c5e:	6b85                	lui	s7,0x1
    80003c60:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003c64:	6c05                	lui	s8,0x1
    80003c66:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003c6a:	a899                	j	80003cc0 <filewrite+0xfc>
    80003c6c:	00090b1b          	sext.w	s6,s2
      begin_op();
    80003c70:	00000097          	auipc	ra,0x0
    80003c74:	860080e7          	jalr	-1952(ra) # 800034d0 <begin_op>
      ilock(f->ip);
    80003c78:	6c88                	ld	a0,24(s1)
    80003c7a:	fffff097          	auipc	ra,0xfffff
    80003c7e:	e7a080e7          	jalr	-390(ra) # 80002af4 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003c82:	875a                	mv	a4,s6
    80003c84:	5494                	lw	a3,40(s1)
    80003c86:	01598633          	add	a2,s3,s5
    80003c8a:	4585                	li	a1,1
    80003c8c:	6c88                	ld	a0,24(s1)
    80003c8e:	fffff097          	auipc	ra,0xfffff
    80003c92:	212080e7          	jalr	530(ra) # 80002ea0 <writei>
    80003c96:	892a                	mv	s2,a0
    80003c98:	00a05563          	blez	a0,80003ca2 <filewrite+0xde>
        f->off += r;
    80003c9c:	549c                	lw	a5,40(s1)
    80003c9e:	9fa9                	addw	a5,a5,a0
    80003ca0:	d49c                	sw	a5,40(s1)
      iunlock(f->ip);
    80003ca2:	6c88                	ld	a0,24(s1)
    80003ca4:	fffff097          	auipc	ra,0xfffff
    80003ca8:	f12080e7          	jalr	-238(ra) # 80002bb6 <iunlock>
      end_op();
    80003cac:	00000097          	auipc	ra,0x0
    80003cb0:	8a2080e7          	jalr	-1886(ra) # 8000354e <end_op>
      if(r != n1){
    80003cb4:	012b1f63          	bne	s6,s2,80003cd2 <filewrite+0x10e>
      i += r;
    80003cb8:	013909bb          	addw	s3,s2,s3
    while(i < n){
    80003cbc:	0149db63          	bge	s3,s4,80003cd2 <filewrite+0x10e>
      int n1 = n - i;
    80003cc0:	413a093b          	subw	s2,s4,s3
    80003cc4:	0009079b          	sext.w	a5,s2
    80003cc8:	fafbd2e3          	bge	s7,a5,80003c6c <filewrite+0xa8>
    80003ccc:	8962                	mv	s2,s8
    80003cce:	bf79                	j	80003c6c <filewrite+0xa8>
    int i = 0;
    80003cd0:	4981                	li	s3,0
    ret = (i == n ? n : -1);
    80003cd2:	8552                	mv	a0,s4
    80003cd4:	f33a0de3          	beq	s4,s3,80003c0e <filewrite+0x4a>
    80003cd8:	557d                	li	a0,-1
    80003cda:	bf15                	j	80003c0e <filewrite+0x4a>
    panic("filewrite");
    80003cdc:	00006517          	auipc	a0,0x6
    80003ce0:	9a450513          	addi	a0,a0,-1628 # 80009680 <syscalls+0x2a8>
    80003ce4:	00003097          	auipc	ra,0x3
    80003ce8:	e8c080e7          	jalr	-372(ra) # 80006b70 <panic>
    return -1;
    80003cec:	557d                	li	a0,-1
}
    80003cee:	8082                	ret
      return -1;
    80003cf0:	557d                	li	a0,-1
    80003cf2:	bf31                	j	80003c0e <filewrite+0x4a>
    80003cf4:	557d                	li	a0,-1
    80003cf6:	bf21                	j	80003c0e <filewrite+0x4a>

0000000080003cf8 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003cf8:	7179                	addi	sp,sp,-48
    80003cfa:	f406                	sd	ra,40(sp)
    80003cfc:	f022                	sd	s0,32(sp)
    80003cfe:	ec26                	sd	s1,24(sp)
    80003d00:	e84a                	sd	s2,16(sp)
    80003d02:	e44e                	sd	s3,8(sp)
    80003d04:	e052                	sd	s4,0(sp)
    80003d06:	1800                	addi	s0,sp,48
    80003d08:	84aa                	mv	s1,a0
    80003d0a:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003d0c:	0005b023          	sd	zero,0(a1)
    80003d10:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003d14:	00000097          	auipc	ra,0x0
    80003d18:	bc8080e7          	jalr	-1080(ra) # 800038dc <filealloc>
    80003d1c:	e088                	sd	a0,0(s1)
    80003d1e:	c551                	beqz	a0,80003daa <pipealloc+0xb2>
    80003d20:	00000097          	auipc	ra,0x0
    80003d24:	bbc080e7          	jalr	-1092(ra) # 800038dc <filealloc>
    80003d28:	00aa3023          	sd	a0,0(s4)
    80003d2c:	c92d                	beqz	a0,80003d9e <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003d2e:	ffffc097          	auipc	ra,0xffffc
    80003d32:	3ec080e7          	jalr	1004(ra) # 8000011a <kalloc>
    80003d36:	892a                	mv	s2,a0
    80003d38:	c125                	beqz	a0,80003d98 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003d3a:	4985                	li	s3,1
    80003d3c:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003d40:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003d44:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003d48:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003d4c:	00006597          	auipc	a1,0x6
    80003d50:	94458593          	addi	a1,a1,-1724 # 80009690 <syscalls+0x2b8>
    80003d54:	00003097          	auipc	ra,0x3
    80003d58:	2c4080e7          	jalr	708(ra) # 80007018 <initlock>
  (*f0)->type = FD_PIPE;
    80003d5c:	609c                	ld	a5,0(s1)
    80003d5e:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003d62:	609c                	ld	a5,0(s1)
    80003d64:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003d68:	609c                	ld	a5,0(s1)
    80003d6a:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003d6e:	609c                	ld	a5,0(s1)
    80003d70:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003d74:	000a3783          	ld	a5,0(s4)
    80003d78:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003d7c:	000a3783          	ld	a5,0(s4)
    80003d80:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003d84:	000a3783          	ld	a5,0(s4)
    80003d88:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003d8c:	000a3783          	ld	a5,0(s4)
    80003d90:	0127b823          	sd	s2,16(a5)
  return 0;
    80003d94:	4501                	li	a0,0
    80003d96:	a025                	j	80003dbe <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003d98:	6088                	ld	a0,0(s1)
    80003d9a:	e501                	bnez	a0,80003da2 <pipealloc+0xaa>
    80003d9c:	a039                	j	80003daa <pipealloc+0xb2>
    80003d9e:	6088                	ld	a0,0(s1)
    80003da0:	c51d                	beqz	a0,80003dce <pipealloc+0xd6>
    fileclose(*f0);
    80003da2:	00000097          	auipc	ra,0x0
    80003da6:	bf6080e7          	jalr	-1034(ra) # 80003998 <fileclose>
  if(*f1)
    80003daa:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003dae:	557d                	li	a0,-1
  if(*f1)
    80003db0:	c799                	beqz	a5,80003dbe <pipealloc+0xc6>
    fileclose(*f1);
    80003db2:	853e                	mv	a0,a5
    80003db4:	00000097          	auipc	ra,0x0
    80003db8:	be4080e7          	jalr	-1052(ra) # 80003998 <fileclose>
  return -1;
    80003dbc:	557d                	li	a0,-1
}
    80003dbe:	70a2                	ld	ra,40(sp)
    80003dc0:	7402                	ld	s0,32(sp)
    80003dc2:	64e2                	ld	s1,24(sp)
    80003dc4:	6942                	ld	s2,16(sp)
    80003dc6:	69a2                	ld	s3,8(sp)
    80003dc8:	6a02                	ld	s4,0(sp)
    80003dca:	6145                	addi	sp,sp,48
    80003dcc:	8082                	ret
  return -1;
    80003dce:	557d                	li	a0,-1
    80003dd0:	b7fd                	j	80003dbe <pipealloc+0xc6>

0000000080003dd2 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003dd2:	1101                	addi	sp,sp,-32
    80003dd4:	ec06                	sd	ra,24(sp)
    80003dd6:	e822                	sd	s0,16(sp)
    80003dd8:	e426                	sd	s1,8(sp)
    80003dda:	e04a                	sd	s2,0(sp)
    80003ddc:	1000                	addi	s0,sp,32
    80003dde:	84aa                	mv	s1,a0
    80003de0:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003de2:	00003097          	auipc	ra,0x3
    80003de6:	2c6080e7          	jalr	710(ra) # 800070a8 <acquire>
  if(writable){
    80003dea:	02090d63          	beqz	s2,80003e24 <pipeclose+0x52>
    pi->writeopen = 0;
    80003dee:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003df2:	21848513          	addi	a0,s1,536
    80003df6:	ffffe097          	auipc	ra,0xffffe
    80003dfa:	8f6080e7          	jalr	-1802(ra) # 800016ec <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003dfe:	2204b783          	ld	a5,544(s1)
    80003e02:	eb95                	bnez	a5,80003e36 <pipeclose+0x64>
    release(&pi->lock);
    80003e04:	8526                	mv	a0,s1
    80003e06:	00003097          	auipc	ra,0x3
    80003e0a:	356080e7          	jalr	854(ra) # 8000715c <release>
    kfree((char*)pi);
    80003e0e:	8526                	mv	a0,s1
    80003e10:	ffffc097          	auipc	ra,0xffffc
    80003e14:	20c080e7          	jalr	524(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003e18:	60e2                	ld	ra,24(sp)
    80003e1a:	6442                	ld	s0,16(sp)
    80003e1c:	64a2                	ld	s1,8(sp)
    80003e1e:	6902                	ld	s2,0(sp)
    80003e20:	6105                	addi	sp,sp,32
    80003e22:	8082                	ret
    pi->readopen = 0;
    80003e24:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003e28:	21c48513          	addi	a0,s1,540
    80003e2c:	ffffe097          	auipc	ra,0xffffe
    80003e30:	8c0080e7          	jalr	-1856(ra) # 800016ec <wakeup>
    80003e34:	b7e9                	j	80003dfe <pipeclose+0x2c>
    release(&pi->lock);
    80003e36:	8526                	mv	a0,s1
    80003e38:	00003097          	auipc	ra,0x3
    80003e3c:	324080e7          	jalr	804(ra) # 8000715c <release>
}
    80003e40:	bfe1                	j	80003e18 <pipeclose+0x46>

0000000080003e42 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003e42:	711d                	addi	sp,sp,-96
    80003e44:	ec86                	sd	ra,88(sp)
    80003e46:	e8a2                	sd	s0,80(sp)
    80003e48:	e4a6                	sd	s1,72(sp)
    80003e4a:	e0ca                	sd	s2,64(sp)
    80003e4c:	fc4e                	sd	s3,56(sp)
    80003e4e:	f852                	sd	s4,48(sp)
    80003e50:	f456                	sd	s5,40(sp)
    80003e52:	f05a                	sd	s6,32(sp)
    80003e54:	ec5e                	sd	s7,24(sp)
    80003e56:	e862                	sd	s8,16(sp)
    80003e58:	1080                	addi	s0,sp,96
    80003e5a:	84aa                	mv	s1,a0
    80003e5c:	8aae                	mv	s5,a1
    80003e5e:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003e60:	ffffd097          	auipc	ra,0xffffd
    80003e64:	03c080e7          	jalr	60(ra) # 80000e9c <myproc>
    80003e68:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003e6a:	8526                	mv	a0,s1
    80003e6c:	00003097          	auipc	ra,0x3
    80003e70:	23c080e7          	jalr	572(ra) # 800070a8 <acquire>
  while(i < n){
    80003e74:	0b405363          	blez	s4,80003f1a <pipewrite+0xd8>
  int i = 0;
    80003e78:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003e7a:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003e7c:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003e80:	21c48b93          	addi	s7,s1,540
    80003e84:	a089                	j	80003ec6 <pipewrite+0x84>
      release(&pi->lock);
    80003e86:	8526                	mv	a0,s1
    80003e88:	00003097          	auipc	ra,0x3
    80003e8c:	2d4080e7          	jalr	724(ra) # 8000715c <release>
      return -1;
    80003e90:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003e92:	854a                	mv	a0,s2
    80003e94:	60e6                	ld	ra,88(sp)
    80003e96:	6446                	ld	s0,80(sp)
    80003e98:	64a6                	ld	s1,72(sp)
    80003e9a:	6906                	ld	s2,64(sp)
    80003e9c:	79e2                	ld	s3,56(sp)
    80003e9e:	7a42                	ld	s4,48(sp)
    80003ea0:	7aa2                	ld	s5,40(sp)
    80003ea2:	7b02                	ld	s6,32(sp)
    80003ea4:	6be2                	ld	s7,24(sp)
    80003ea6:	6c42                	ld	s8,16(sp)
    80003ea8:	6125                	addi	sp,sp,96
    80003eaa:	8082                	ret
      wakeup(&pi->nread);
    80003eac:	8562                	mv	a0,s8
    80003eae:	ffffe097          	auipc	ra,0xffffe
    80003eb2:	83e080e7          	jalr	-1986(ra) # 800016ec <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003eb6:	85a6                	mv	a1,s1
    80003eb8:	855e                	mv	a0,s7
    80003eba:	ffffd097          	auipc	ra,0xffffd
    80003ebe:	6a6080e7          	jalr	1702(ra) # 80001560 <sleep>
  while(i < n){
    80003ec2:	05495d63          	bge	s2,s4,80003f1c <pipewrite+0xda>
    if(pi->readopen == 0 || pr->killed){
    80003ec6:	2204a783          	lw	a5,544(s1)
    80003eca:	dfd5                	beqz	a5,80003e86 <pipewrite+0x44>
    80003ecc:	0289a783          	lw	a5,40(s3)
    80003ed0:	fbdd                	bnez	a5,80003e86 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003ed2:	2184a783          	lw	a5,536(s1)
    80003ed6:	21c4a703          	lw	a4,540(s1)
    80003eda:	2007879b          	addiw	a5,a5,512
    80003ede:	fcf707e3          	beq	a4,a5,80003eac <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003ee2:	4685                	li	a3,1
    80003ee4:	01590633          	add	a2,s2,s5
    80003ee8:	faf40593          	addi	a1,s0,-81
    80003eec:	0509b503          	ld	a0,80(s3)
    80003ef0:	ffffd097          	auipc	ra,0xffffd
    80003ef4:	d00080e7          	jalr	-768(ra) # 80000bf0 <copyin>
    80003ef8:	03650263          	beq	a0,s6,80003f1c <pipewrite+0xda>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003efc:	21c4a783          	lw	a5,540(s1)
    80003f00:	0017871b          	addiw	a4,a5,1
    80003f04:	20e4ae23          	sw	a4,540(s1)
    80003f08:	1ff7f793          	andi	a5,a5,511
    80003f0c:	97a6                	add	a5,a5,s1
    80003f0e:	faf44703          	lbu	a4,-81(s0)
    80003f12:	00e78c23          	sb	a4,24(a5)
      i++;
    80003f16:	2905                	addiw	s2,s2,1
    80003f18:	b76d                	j	80003ec2 <pipewrite+0x80>
  int i = 0;
    80003f1a:	4901                	li	s2,0
  wakeup(&pi->nread);
    80003f1c:	21848513          	addi	a0,s1,536
    80003f20:	ffffd097          	auipc	ra,0xffffd
    80003f24:	7cc080e7          	jalr	1996(ra) # 800016ec <wakeup>
  release(&pi->lock);
    80003f28:	8526                	mv	a0,s1
    80003f2a:	00003097          	auipc	ra,0x3
    80003f2e:	232080e7          	jalr	562(ra) # 8000715c <release>
  return i;
    80003f32:	b785                	j	80003e92 <pipewrite+0x50>

0000000080003f34 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003f34:	715d                	addi	sp,sp,-80
    80003f36:	e486                	sd	ra,72(sp)
    80003f38:	e0a2                	sd	s0,64(sp)
    80003f3a:	fc26                	sd	s1,56(sp)
    80003f3c:	f84a                	sd	s2,48(sp)
    80003f3e:	f44e                	sd	s3,40(sp)
    80003f40:	f052                	sd	s4,32(sp)
    80003f42:	ec56                	sd	s5,24(sp)
    80003f44:	e85a                	sd	s6,16(sp)
    80003f46:	0880                	addi	s0,sp,80
    80003f48:	84aa                	mv	s1,a0
    80003f4a:	892e                	mv	s2,a1
    80003f4c:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003f4e:	ffffd097          	auipc	ra,0xffffd
    80003f52:	f4e080e7          	jalr	-178(ra) # 80000e9c <myproc>
    80003f56:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003f58:	8526                	mv	a0,s1
    80003f5a:	00003097          	auipc	ra,0x3
    80003f5e:	14e080e7          	jalr	334(ra) # 800070a8 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f62:	2184a703          	lw	a4,536(s1)
    80003f66:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003f6a:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f6e:	02f71463          	bne	a4,a5,80003f96 <piperead+0x62>
    80003f72:	2244a783          	lw	a5,548(s1)
    80003f76:	c385                	beqz	a5,80003f96 <piperead+0x62>
    if(pr->killed){
    80003f78:	028a2783          	lw	a5,40(s4)
    80003f7c:	ebc9                	bnez	a5,8000400e <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003f7e:	85a6                	mv	a1,s1
    80003f80:	854e                	mv	a0,s3
    80003f82:	ffffd097          	auipc	ra,0xffffd
    80003f86:	5de080e7          	jalr	1502(ra) # 80001560 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f8a:	2184a703          	lw	a4,536(s1)
    80003f8e:	21c4a783          	lw	a5,540(s1)
    80003f92:	fef700e3          	beq	a4,a5,80003f72 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003f96:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003f98:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003f9a:	05505463          	blez	s5,80003fe2 <piperead+0xae>
    if(pi->nread == pi->nwrite)
    80003f9e:	2184a783          	lw	a5,536(s1)
    80003fa2:	21c4a703          	lw	a4,540(s1)
    80003fa6:	02f70e63          	beq	a4,a5,80003fe2 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003faa:	0017871b          	addiw	a4,a5,1
    80003fae:	20e4ac23          	sw	a4,536(s1)
    80003fb2:	1ff7f793          	andi	a5,a5,511
    80003fb6:	97a6                	add	a5,a5,s1
    80003fb8:	0187c783          	lbu	a5,24(a5)
    80003fbc:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003fc0:	4685                	li	a3,1
    80003fc2:	fbf40613          	addi	a2,s0,-65
    80003fc6:	85ca                	mv	a1,s2
    80003fc8:	050a3503          	ld	a0,80(s4)
    80003fcc:	ffffd097          	auipc	ra,0xffffd
    80003fd0:	b98080e7          	jalr	-1128(ra) # 80000b64 <copyout>
    80003fd4:	01650763          	beq	a0,s6,80003fe2 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003fd8:	2985                	addiw	s3,s3,1
    80003fda:	0905                	addi	s2,s2,1
    80003fdc:	fd3a91e3          	bne	s5,s3,80003f9e <piperead+0x6a>
    80003fe0:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003fe2:	21c48513          	addi	a0,s1,540
    80003fe6:	ffffd097          	auipc	ra,0xffffd
    80003fea:	706080e7          	jalr	1798(ra) # 800016ec <wakeup>
  release(&pi->lock);
    80003fee:	8526                	mv	a0,s1
    80003ff0:	00003097          	auipc	ra,0x3
    80003ff4:	16c080e7          	jalr	364(ra) # 8000715c <release>
  return i;
}
    80003ff8:	854e                	mv	a0,s3
    80003ffa:	60a6                	ld	ra,72(sp)
    80003ffc:	6406                	ld	s0,64(sp)
    80003ffe:	74e2                	ld	s1,56(sp)
    80004000:	7942                	ld	s2,48(sp)
    80004002:	79a2                	ld	s3,40(sp)
    80004004:	7a02                	ld	s4,32(sp)
    80004006:	6ae2                	ld	s5,24(sp)
    80004008:	6b42                	ld	s6,16(sp)
    8000400a:	6161                	addi	sp,sp,80
    8000400c:	8082                	ret
      release(&pi->lock);
    8000400e:	8526                	mv	a0,s1
    80004010:	00003097          	auipc	ra,0x3
    80004014:	14c080e7          	jalr	332(ra) # 8000715c <release>
      return -1;
    80004018:	59fd                	li	s3,-1
    8000401a:	bff9                	j	80003ff8 <piperead+0xc4>

000000008000401c <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    8000401c:	de010113          	addi	sp,sp,-544
    80004020:	20113c23          	sd	ra,536(sp)
    80004024:	20813823          	sd	s0,528(sp)
    80004028:	20913423          	sd	s1,520(sp)
    8000402c:	21213023          	sd	s2,512(sp)
    80004030:	ffce                	sd	s3,504(sp)
    80004032:	fbd2                	sd	s4,496(sp)
    80004034:	f7d6                	sd	s5,488(sp)
    80004036:	f3da                	sd	s6,480(sp)
    80004038:	efde                	sd	s7,472(sp)
    8000403a:	ebe2                	sd	s8,464(sp)
    8000403c:	e7e6                	sd	s9,456(sp)
    8000403e:	e3ea                	sd	s10,448(sp)
    80004040:	ff6e                	sd	s11,440(sp)
    80004042:	1400                	addi	s0,sp,544
    80004044:	892a                	mv	s2,a0
    80004046:	dea43423          	sd	a0,-536(s0)
    8000404a:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000404e:	ffffd097          	auipc	ra,0xffffd
    80004052:	e4e080e7          	jalr	-434(ra) # 80000e9c <myproc>
    80004056:	84aa                	mv	s1,a0

  begin_op();
    80004058:	fffff097          	auipc	ra,0xfffff
    8000405c:	478080e7          	jalr	1144(ra) # 800034d0 <begin_op>

  if((ip = namei(path)) == 0){
    80004060:	854a                	mv	a0,s2
    80004062:	fffff097          	auipc	ra,0xfffff
    80004066:	24e080e7          	jalr	590(ra) # 800032b0 <namei>
    8000406a:	c93d                	beqz	a0,800040e0 <exec+0xc4>
    8000406c:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000406e:	fffff097          	auipc	ra,0xfffff
    80004072:	a86080e7          	jalr	-1402(ra) # 80002af4 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004076:	04000713          	li	a4,64
    8000407a:	4681                	li	a3,0
    8000407c:	e5040613          	addi	a2,s0,-432
    80004080:	4581                	li	a1,0
    80004082:	8556                	mv	a0,s5
    80004084:	fffff097          	auipc	ra,0xfffff
    80004088:	d24080e7          	jalr	-732(ra) # 80002da8 <readi>
    8000408c:	04000793          	li	a5,64
    80004090:	00f51a63          	bne	a0,a5,800040a4 <exec+0x88>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004094:	e5042703          	lw	a4,-432(s0)
    80004098:	464c47b7          	lui	a5,0x464c4
    8000409c:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800040a0:	04f70663          	beq	a4,a5,800040ec <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800040a4:	8556                	mv	a0,s5
    800040a6:	fffff097          	auipc	ra,0xfffff
    800040aa:	cb0080e7          	jalr	-848(ra) # 80002d56 <iunlockput>
    end_op();
    800040ae:	fffff097          	auipc	ra,0xfffff
    800040b2:	4a0080e7          	jalr	1184(ra) # 8000354e <end_op>
  }
  return -1;
    800040b6:	557d                	li	a0,-1
}
    800040b8:	21813083          	ld	ra,536(sp)
    800040bc:	21013403          	ld	s0,528(sp)
    800040c0:	20813483          	ld	s1,520(sp)
    800040c4:	20013903          	ld	s2,512(sp)
    800040c8:	79fe                	ld	s3,504(sp)
    800040ca:	7a5e                	ld	s4,496(sp)
    800040cc:	7abe                	ld	s5,488(sp)
    800040ce:	7b1e                	ld	s6,480(sp)
    800040d0:	6bfe                	ld	s7,472(sp)
    800040d2:	6c5e                	ld	s8,464(sp)
    800040d4:	6cbe                	ld	s9,456(sp)
    800040d6:	6d1e                	ld	s10,448(sp)
    800040d8:	7dfa                	ld	s11,440(sp)
    800040da:	22010113          	addi	sp,sp,544
    800040de:	8082                	ret
    end_op();
    800040e0:	fffff097          	auipc	ra,0xfffff
    800040e4:	46e080e7          	jalr	1134(ra) # 8000354e <end_op>
    return -1;
    800040e8:	557d                	li	a0,-1
    800040ea:	b7f9                	j	800040b8 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    800040ec:	8526                	mv	a0,s1
    800040ee:	ffffd097          	auipc	ra,0xffffd
    800040f2:	e72080e7          	jalr	-398(ra) # 80000f60 <proc_pagetable>
    800040f6:	8b2a                	mv	s6,a0
    800040f8:	d555                	beqz	a0,800040a4 <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800040fa:	e7042783          	lw	a5,-400(s0)
    800040fe:	e8845703          	lhu	a4,-376(s0)
    80004102:	c735                	beqz	a4,8000416e <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004104:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004106:	e0043423          	sd	zero,-504(s0)
    if((ph.vaddr % PGSIZE) != 0)
    8000410a:	6a05                	lui	s4,0x1
    8000410c:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80004110:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    80004114:	6d85                	lui	s11,0x1
    80004116:	7d7d                	lui	s10,0xfffff
    80004118:	ac1d                	j	8000434e <exec+0x332>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    8000411a:	00005517          	auipc	a0,0x5
    8000411e:	57e50513          	addi	a0,a0,1406 # 80009698 <syscalls+0x2c0>
    80004122:	00003097          	auipc	ra,0x3
    80004126:	a4e080e7          	jalr	-1458(ra) # 80006b70 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000412a:	874a                	mv	a4,s2
    8000412c:	009c86bb          	addw	a3,s9,s1
    80004130:	4581                	li	a1,0
    80004132:	8556                	mv	a0,s5
    80004134:	fffff097          	auipc	ra,0xfffff
    80004138:	c74080e7          	jalr	-908(ra) # 80002da8 <readi>
    8000413c:	2501                	sext.w	a0,a0
    8000413e:	1aa91863          	bne	s2,a0,800042ee <exec+0x2d2>
  for(i = 0; i < sz; i += PGSIZE){
    80004142:	009d84bb          	addw	s1,s11,s1
    80004146:	013d09bb          	addw	s3,s10,s3
    8000414a:	1f74f263          	bgeu	s1,s7,8000432e <exec+0x312>
    pa = walkaddr(pagetable, va + i);
    8000414e:	02049593          	slli	a1,s1,0x20
    80004152:	9181                	srli	a1,a1,0x20
    80004154:	95e2                	add	a1,a1,s8
    80004156:	855a                	mv	a0,s6
    80004158:	ffffc097          	auipc	ra,0xffffc
    8000415c:	3c0080e7          	jalr	960(ra) # 80000518 <walkaddr>
    80004160:	862a                	mv	a2,a0
    if(pa == 0)
    80004162:	dd45                	beqz	a0,8000411a <exec+0xfe>
      n = PGSIZE;
    80004164:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    80004166:	fd49f2e3          	bgeu	s3,s4,8000412a <exec+0x10e>
      n = sz - i;
    8000416a:	894e                	mv	s2,s3
    8000416c:	bf7d                	j	8000412a <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000416e:	4481                	li	s1,0
  iunlockput(ip);
    80004170:	8556                	mv	a0,s5
    80004172:	fffff097          	auipc	ra,0xfffff
    80004176:	be4080e7          	jalr	-1052(ra) # 80002d56 <iunlockput>
  end_op();
    8000417a:	fffff097          	auipc	ra,0xfffff
    8000417e:	3d4080e7          	jalr	980(ra) # 8000354e <end_op>
  p = myproc();
    80004182:	ffffd097          	auipc	ra,0xffffd
    80004186:	d1a080e7          	jalr	-742(ra) # 80000e9c <myproc>
    8000418a:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    8000418c:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004190:	6785                	lui	a5,0x1
    80004192:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80004194:	97a6                	add	a5,a5,s1
    80004196:	777d                	lui	a4,0xfffff
    80004198:	8ff9                	and	a5,a5,a4
    8000419a:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000419e:	6609                	lui	a2,0x2
    800041a0:	963e                	add	a2,a2,a5
    800041a2:	85be                	mv	a1,a5
    800041a4:	855a                	mv	a0,s6
    800041a6:	ffffc097          	auipc	ra,0xffffc
    800041aa:	76a080e7          	jalr	1898(ra) # 80000910 <uvmalloc>
    800041ae:	8c2a                	mv	s8,a0
  ip = 0;
    800041b0:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800041b2:	12050e63          	beqz	a0,800042ee <exec+0x2d2>
  uvmclear(pagetable, sz-2*PGSIZE);
    800041b6:	75f9                	lui	a1,0xffffe
    800041b8:	95aa                	add	a1,a1,a0
    800041ba:	855a                	mv	a0,s6
    800041bc:	ffffd097          	auipc	ra,0xffffd
    800041c0:	976080e7          	jalr	-1674(ra) # 80000b32 <uvmclear>
  stackbase = sp - PGSIZE;
    800041c4:	7afd                	lui	s5,0xfffff
    800041c6:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    800041c8:	df043783          	ld	a5,-528(s0)
    800041cc:	6388                	ld	a0,0(a5)
    800041ce:	c925                	beqz	a0,8000423e <exec+0x222>
    800041d0:	e9040993          	addi	s3,s0,-368
    800041d4:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    800041d8:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800041da:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800041dc:	ffffc097          	auipc	ra,0xffffc
    800041e0:	11a080e7          	jalr	282(ra) # 800002f6 <strlen>
    800041e4:	0015079b          	addiw	a5,a0,1
    800041e8:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800041ec:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800041f0:	13596363          	bltu	s2,s5,80004316 <exec+0x2fa>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800041f4:	df043d83          	ld	s11,-528(s0)
    800041f8:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    800041fc:	8552                	mv	a0,s4
    800041fe:	ffffc097          	auipc	ra,0xffffc
    80004202:	0f8080e7          	jalr	248(ra) # 800002f6 <strlen>
    80004206:	0015069b          	addiw	a3,a0,1
    8000420a:	8652                	mv	a2,s4
    8000420c:	85ca                	mv	a1,s2
    8000420e:	855a                	mv	a0,s6
    80004210:	ffffd097          	auipc	ra,0xffffd
    80004214:	954080e7          	jalr	-1708(ra) # 80000b64 <copyout>
    80004218:	10054363          	bltz	a0,8000431e <exec+0x302>
    ustack[argc] = sp;
    8000421c:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004220:	0485                	addi	s1,s1,1
    80004222:	008d8793          	addi	a5,s11,8
    80004226:	def43823          	sd	a5,-528(s0)
    8000422a:	008db503          	ld	a0,8(s11)
    8000422e:	c911                	beqz	a0,80004242 <exec+0x226>
    if(argc >= MAXARG)
    80004230:	09a1                	addi	s3,s3,8
    80004232:	fb3c95e3          	bne	s9,s3,800041dc <exec+0x1c0>
  sz = sz1;
    80004236:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000423a:	4a81                	li	s5,0
    8000423c:	a84d                	j	800042ee <exec+0x2d2>
  sp = sz;
    8000423e:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004240:	4481                	li	s1,0
  ustack[argc] = 0;
    80004242:	00349793          	slli	a5,s1,0x3
    80004246:	f9078793          	addi	a5,a5,-112
    8000424a:	97a2                	add	a5,a5,s0
    8000424c:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004250:	00148693          	addi	a3,s1,1
    80004254:	068e                	slli	a3,a3,0x3
    80004256:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000425a:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    8000425e:	01597663          	bgeu	s2,s5,8000426a <exec+0x24e>
  sz = sz1;
    80004262:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004266:	4a81                	li	s5,0
    80004268:	a059                	j	800042ee <exec+0x2d2>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000426a:	e9040613          	addi	a2,s0,-368
    8000426e:	85ca                	mv	a1,s2
    80004270:	855a                	mv	a0,s6
    80004272:	ffffd097          	auipc	ra,0xffffd
    80004276:	8f2080e7          	jalr	-1806(ra) # 80000b64 <copyout>
    8000427a:	0a054663          	bltz	a0,80004326 <exec+0x30a>
  p->trapframe->a1 = sp;
    8000427e:	058bb783          	ld	a5,88(s7)
    80004282:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004286:	de843783          	ld	a5,-536(s0)
    8000428a:	0007c703          	lbu	a4,0(a5)
    8000428e:	cf11                	beqz	a4,800042aa <exec+0x28e>
    80004290:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004292:	02f00693          	li	a3,47
    80004296:	a039                	j	800042a4 <exec+0x288>
      last = s+1;
    80004298:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    8000429c:	0785                	addi	a5,a5,1
    8000429e:	fff7c703          	lbu	a4,-1(a5)
    800042a2:	c701                	beqz	a4,800042aa <exec+0x28e>
    if(*s == '/')
    800042a4:	fed71ce3          	bne	a4,a3,8000429c <exec+0x280>
    800042a8:	bfc5                	j	80004298 <exec+0x27c>
  safestrcpy(p->name, last, sizeof(p->name));
    800042aa:	4641                	li	a2,16
    800042ac:	de843583          	ld	a1,-536(s0)
    800042b0:	158b8513          	addi	a0,s7,344
    800042b4:	ffffc097          	auipc	ra,0xffffc
    800042b8:	010080e7          	jalr	16(ra) # 800002c4 <safestrcpy>
  oldpagetable = p->pagetable;
    800042bc:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    800042c0:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    800042c4:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800042c8:	058bb783          	ld	a5,88(s7)
    800042cc:	e6843703          	ld	a4,-408(s0)
    800042d0:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800042d2:	058bb783          	ld	a5,88(s7)
    800042d6:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800042da:	85ea                	mv	a1,s10
    800042dc:	ffffd097          	auipc	ra,0xffffd
    800042e0:	d20080e7          	jalr	-736(ra) # 80000ffc <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800042e4:	0004851b          	sext.w	a0,s1
    800042e8:	bbc1                	j	800040b8 <exec+0x9c>
    800042ea:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    800042ee:	df843583          	ld	a1,-520(s0)
    800042f2:	855a                	mv	a0,s6
    800042f4:	ffffd097          	auipc	ra,0xffffd
    800042f8:	d08080e7          	jalr	-760(ra) # 80000ffc <proc_freepagetable>
  if(ip){
    800042fc:	da0a94e3          	bnez	s5,800040a4 <exec+0x88>
  return -1;
    80004300:	557d                	li	a0,-1
    80004302:	bb5d                	j	800040b8 <exec+0x9c>
    80004304:	de943c23          	sd	s1,-520(s0)
    80004308:	b7dd                	j	800042ee <exec+0x2d2>
    8000430a:	de943c23          	sd	s1,-520(s0)
    8000430e:	b7c5                	j	800042ee <exec+0x2d2>
    80004310:	de943c23          	sd	s1,-520(s0)
    80004314:	bfe9                	j	800042ee <exec+0x2d2>
  sz = sz1;
    80004316:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000431a:	4a81                	li	s5,0
    8000431c:	bfc9                	j	800042ee <exec+0x2d2>
  sz = sz1;
    8000431e:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004322:	4a81                	li	s5,0
    80004324:	b7e9                	j	800042ee <exec+0x2d2>
  sz = sz1;
    80004326:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000432a:	4a81                	li	s5,0
    8000432c:	b7c9                	j	800042ee <exec+0x2d2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000432e:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004332:	e0843783          	ld	a5,-504(s0)
    80004336:	0017869b          	addiw	a3,a5,1
    8000433a:	e0d43423          	sd	a3,-504(s0)
    8000433e:	e0043783          	ld	a5,-512(s0)
    80004342:	0387879b          	addiw	a5,a5,56
    80004346:	e8845703          	lhu	a4,-376(s0)
    8000434a:	e2e6d3e3          	bge	a3,a4,80004170 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000434e:	2781                	sext.w	a5,a5
    80004350:	e0f43023          	sd	a5,-512(s0)
    80004354:	03800713          	li	a4,56
    80004358:	86be                	mv	a3,a5
    8000435a:	e1840613          	addi	a2,s0,-488
    8000435e:	4581                	li	a1,0
    80004360:	8556                	mv	a0,s5
    80004362:	fffff097          	auipc	ra,0xfffff
    80004366:	a46080e7          	jalr	-1466(ra) # 80002da8 <readi>
    8000436a:	03800793          	li	a5,56
    8000436e:	f6f51ee3          	bne	a0,a5,800042ea <exec+0x2ce>
    if(ph.type != ELF_PROG_LOAD)
    80004372:	e1842783          	lw	a5,-488(s0)
    80004376:	4705                	li	a4,1
    80004378:	fae79de3          	bne	a5,a4,80004332 <exec+0x316>
    if(ph.memsz < ph.filesz)
    8000437c:	e4043603          	ld	a2,-448(s0)
    80004380:	e3843783          	ld	a5,-456(s0)
    80004384:	f8f660e3          	bltu	a2,a5,80004304 <exec+0x2e8>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004388:	e2843783          	ld	a5,-472(s0)
    8000438c:	963e                	add	a2,a2,a5
    8000438e:	f6f66ee3          	bltu	a2,a5,8000430a <exec+0x2ee>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004392:	85a6                	mv	a1,s1
    80004394:	855a                	mv	a0,s6
    80004396:	ffffc097          	auipc	ra,0xffffc
    8000439a:	57a080e7          	jalr	1402(ra) # 80000910 <uvmalloc>
    8000439e:	dea43c23          	sd	a0,-520(s0)
    800043a2:	d53d                	beqz	a0,80004310 <exec+0x2f4>
    if((ph.vaddr % PGSIZE) != 0)
    800043a4:	e2843c03          	ld	s8,-472(s0)
    800043a8:	de043783          	ld	a5,-544(s0)
    800043ac:	00fc77b3          	and	a5,s8,a5
    800043b0:	ff9d                	bnez	a5,800042ee <exec+0x2d2>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800043b2:	e2042c83          	lw	s9,-480(s0)
    800043b6:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800043ba:	f60b8ae3          	beqz	s7,8000432e <exec+0x312>
    800043be:	89de                	mv	s3,s7
    800043c0:	4481                	li	s1,0
    800043c2:	b371                	j	8000414e <exec+0x132>

00000000800043c4 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800043c4:	7179                	addi	sp,sp,-48
    800043c6:	f406                	sd	ra,40(sp)
    800043c8:	f022                	sd	s0,32(sp)
    800043ca:	ec26                	sd	s1,24(sp)
    800043cc:	e84a                	sd	s2,16(sp)
    800043ce:	1800                	addi	s0,sp,48
    800043d0:	892e                	mv	s2,a1
    800043d2:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    800043d4:	fdc40593          	addi	a1,s0,-36
    800043d8:	ffffe097          	auipc	ra,0xffffe
    800043dc:	baa080e7          	jalr	-1110(ra) # 80001f82 <argint>
    800043e0:	04054063          	bltz	a0,80004420 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800043e4:	fdc42703          	lw	a4,-36(s0)
    800043e8:	47bd                	li	a5,15
    800043ea:	02e7ed63          	bltu	a5,a4,80004424 <argfd+0x60>
    800043ee:	ffffd097          	auipc	ra,0xffffd
    800043f2:	aae080e7          	jalr	-1362(ra) # 80000e9c <myproc>
    800043f6:	fdc42703          	lw	a4,-36(s0)
    800043fa:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7ffd7a9a>
    800043fe:	078e                	slli	a5,a5,0x3
    80004400:	953e                	add	a0,a0,a5
    80004402:	611c                	ld	a5,0(a0)
    80004404:	c395                	beqz	a5,80004428 <argfd+0x64>
    return -1;
  if(pfd)
    80004406:	00090463          	beqz	s2,8000440e <argfd+0x4a>
    *pfd = fd;
    8000440a:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000440e:	4501                	li	a0,0
  if(pf)
    80004410:	c091                	beqz	s1,80004414 <argfd+0x50>
    *pf = f;
    80004412:	e09c                	sd	a5,0(s1)
}
    80004414:	70a2                	ld	ra,40(sp)
    80004416:	7402                	ld	s0,32(sp)
    80004418:	64e2                	ld	s1,24(sp)
    8000441a:	6942                	ld	s2,16(sp)
    8000441c:	6145                	addi	sp,sp,48
    8000441e:	8082                	ret
    return -1;
    80004420:	557d                	li	a0,-1
    80004422:	bfcd                	j	80004414 <argfd+0x50>
    return -1;
    80004424:	557d                	li	a0,-1
    80004426:	b7fd                	j	80004414 <argfd+0x50>
    80004428:	557d                	li	a0,-1
    8000442a:	b7ed                	j	80004414 <argfd+0x50>

000000008000442c <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000442c:	1101                	addi	sp,sp,-32
    8000442e:	ec06                	sd	ra,24(sp)
    80004430:	e822                	sd	s0,16(sp)
    80004432:	e426                	sd	s1,8(sp)
    80004434:	1000                	addi	s0,sp,32
    80004436:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004438:	ffffd097          	auipc	ra,0xffffd
    8000443c:	a64080e7          	jalr	-1436(ra) # 80000e9c <myproc>
    80004440:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004442:	0d050793          	addi	a5,a0,208
    80004446:	4501                	li	a0,0
    80004448:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000444a:	6398                	ld	a4,0(a5)
    8000444c:	cb19                	beqz	a4,80004462 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    8000444e:	2505                	addiw	a0,a0,1
    80004450:	07a1                	addi	a5,a5,8
    80004452:	fed51ce3          	bne	a0,a3,8000444a <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004456:	557d                	li	a0,-1
}
    80004458:	60e2                	ld	ra,24(sp)
    8000445a:	6442                	ld	s0,16(sp)
    8000445c:	64a2                	ld	s1,8(sp)
    8000445e:	6105                	addi	sp,sp,32
    80004460:	8082                	ret
      p->ofile[fd] = f;
    80004462:	01a50793          	addi	a5,a0,26
    80004466:	078e                	slli	a5,a5,0x3
    80004468:	963e                	add	a2,a2,a5
    8000446a:	e204                	sd	s1,0(a2)
      return fd;
    8000446c:	b7f5                	j	80004458 <fdalloc+0x2c>

000000008000446e <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000446e:	715d                	addi	sp,sp,-80
    80004470:	e486                	sd	ra,72(sp)
    80004472:	e0a2                	sd	s0,64(sp)
    80004474:	fc26                	sd	s1,56(sp)
    80004476:	f84a                	sd	s2,48(sp)
    80004478:	f44e                	sd	s3,40(sp)
    8000447a:	f052                	sd	s4,32(sp)
    8000447c:	ec56                	sd	s5,24(sp)
    8000447e:	0880                	addi	s0,sp,80
    80004480:	89ae                	mv	s3,a1
    80004482:	8ab2                	mv	s5,a2
    80004484:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004486:	fb040593          	addi	a1,s0,-80
    8000448a:	fffff097          	auipc	ra,0xfffff
    8000448e:	e44080e7          	jalr	-444(ra) # 800032ce <nameiparent>
    80004492:	892a                	mv	s2,a0
    80004494:	12050e63          	beqz	a0,800045d0 <create+0x162>
    return 0;

  ilock(dp);
    80004498:	ffffe097          	auipc	ra,0xffffe
    8000449c:	65c080e7          	jalr	1628(ra) # 80002af4 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800044a0:	4601                	li	a2,0
    800044a2:	fb040593          	addi	a1,s0,-80
    800044a6:	854a                	mv	a0,s2
    800044a8:	fffff097          	auipc	ra,0xfffff
    800044ac:	b30080e7          	jalr	-1232(ra) # 80002fd8 <dirlookup>
    800044b0:	84aa                	mv	s1,a0
    800044b2:	c921                	beqz	a0,80004502 <create+0x94>
    iunlockput(dp);
    800044b4:	854a                	mv	a0,s2
    800044b6:	fffff097          	auipc	ra,0xfffff
    800044ba:	8a0080e7          	jalr	-1888(ra) # 80002d56 <iunlockput>
    ilock(ip);
    800044be:	8526                	mv	a0,s1
    800044c0:	ffffe097          	auipc	ra,0xffffe
    800044c4:	634080e7          	jalr	1588(ra) # 80002af4 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800044c8:	2981                	sext.w	s3,s3
    800044ca:	4789                	li	a5,2
    800044cc:	02f99463          	bne	s3,a5,800044f4 <create+0x86>
    800044d0:	0444d783          	lhu	a5,68(s1)
    800044d4:	37f9                	addiw	a5,a5,-2
    800044d6:	17c2                	slli	a5,a5,0x30
    800044d8:	93c1                	srli	a5,a5,0x30
    800044da:	4705                	li	a4,1
    800044dc:	00f76c63          	bltu	a4,a5,800044f4 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800044e0:	8526                	mv	a0,s1
    800044e2:	60a6                	ld	ra,72(sp)
    800044e4:	6406                	ld	s0,64(sp)
    800044e6:	74e2                	ld	s1,56(sp)
    800044e8:	7942                	ld	s2,48(sp)
    800044ea:	79a2                	ld	s3,40(sp)
    800044ec:	7a02                	ld	s4,32(sp)
    800044ee:	6ae2                	ld	s5,24(sp)
    800044f0:	6161                	addi	sp,sp,80
    800044f2:	8082                	ret
    iunlockput(ip);
    800044f4:	8526                	mv	a0,s1
    800044f6:	fffff097          	auipc	ra,0xfffff
    800044fa:	860080e7          	jalr	-1952(ra) # 80002d56 <iunlockput>
    return 0;
    800044fe:	4481                	li	s1,0
    80004500:	b7c5                	j	800044e0 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004502:	85ce                	mv	a1,s3
    80004504:	00092503          	lw	a0,0(s2)
    80004508:	ffffe097          	auipc	ra,0xffffe
    8000450c:	452080e7          	jalr	1106(ra) # 8000295a <ialloc>
    80004510:	84aa                	mv	s1,a0
    80004512:	c521                	beqz	a0,8000455a <create+0xec>
  ilock(ip);
    80004514:	ffffe097          	auipc	ra,0xffffe
    80004518:	5e0080e7          	jalr	1504(ra) # 80002af4 <ilock>
  ip->major = major;
    8000451c:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80004520:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80004524:	4a05                	li	s4,1
    80004526:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    8000452a:	8526                	mv	a0,s1
    8000452c:	ffffe097          	auipc	ra,0xffffe
    80004530:	4fc080e7          	jalr	1276(ra) # 80002a28 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004534:	2981                	sext.w	s3,s3
    80004536:	03498a63          	beq	s3,s4,8000456a <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    8000453a:	40d0                	lw	a2,4(s1)
    8000453c:	fb040593          	addi	a1,s0,-80
    80004540:	854a                	mv	a0,s2
    80004542:	fffff097          	auipc	ra,0xfffff
    80004546:	cac080e7          	jalr	-852(ra) # 800031ee <dirlink>
    8000454a:	06054b63          	bltz	a0,800045c0 <create+0x152>
  iunlockput(dp);
    8000454e:	854a                	mv	a0,s2
    80004550:	fffff097          	auipc	ra,0xfffff
    80004554:	806080e7          	jalr	-2042(ra) # 80002d56 <iunlockput>
  return ip;
    80004558:	b761                	j	800044e0 <create+0x72>
    panic("create: ialloc");
    8000455a:	00005517          	auipc	a0,0x5
    8000455e:	15e50513          	addi	a0,a0,350 # 800096b8 <syscalls+0x2e0>
    80004562:	00002097          	auipc	ra,0x2
    80004566:	60e080e7          	jalr	1550(ra) # 80006b70 <panic>
    dp->nlink++;  // for ".."
    8000456a:	04a95783          	lhu	a5,74(s2)
    8000456e:	2785                	addiw	a5,a5,1
    80004570:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80004574:	854a                	mv	a0,s2
    80004576:	ffffe097          	auipc	ra,0xffffe
    8000457a:	4b2080e7          	jalr	1202(ra) # 80002a28 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000457e:	40d0                	lw	a2,4(s1)
    80004580:	00005597          	auipc	a1,0x5
    80004584:	14858593          	addi	a1,a1,328 # 800096c8 <syscalls+0x2f0>
    80004588:	8526                	mv	a0,s1
    8000458a:	fffff097          	auipc	ra,0xfffff
    8000458e:	c64080e7          	jalr	-924(ra) # 800031ee <dirlink>
    80004592:	00054f63          	bltz	a0,800045b0 <create+0x142>
    80004596:	00492603          	lw	a2,4(s2)
    8000459a:	00005597          	auipc	a1,0x5
    8000459e:	13658593          	addi	a1,a1,310 # 800096d0 <syscalls+0x2f8>
    800045a2:	8526                	mv	a0,s1
    800045a4:	fffff097          	auipc	ra,0xfffff
    800045a8:	c4a080e7          	jalr	-950(ra) # 800031ee <dirlink>
    800045ac:	f80557e3          	bgez	a0,8000453a <create+0xcc>
      panic("create dots");
    800045b0:	00005517          	auipc	a0,0x5
    800045b4:	12850513          	addi	a0,a0,296 # 800096d8 <syscalls+0x300>
    800045b8:	00002097          	auipc	ra,0x2
    800045bc:	5b8080e7          	jalr	1464(ra) # 80006b70 <panic>
    panic("create: dirlink");
    800045c0:	00005517          	auipc	a0,0x5
    800045c4:	12850513          	addi	a0,a0,296 # 800096e8 <syscalls+0x310>
    800045c8:	00002097          	auipc	ra,0x2
    800045cc:	5a8080e7          	jalr	1448(ra) # 80006b70 <panic>
    return 0;
    800045d0:	84aa                	mv	s1,a0
    800045d2:	b739                	j	800044e0 <create+0x72>

00000000800045d4 <sys_dup>:
{
    800045d4:	7179                	addi	sp,sp,-48
    800045d6:	f406                	sd	ra,40(sp)
    800045d8:	f022                	sd	s0,32(sp)
    800045da:	ec26                	sd	s1,24(sp)
    800045dc:	e84a                	sd	s2,16(sp)
    800045de:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800045e0:	fd840613          	addi	a2,s0,-40
    800045e4:	4581                	li	a1,0
    800045e6:	4501                	li	a0,0
    800045e8:	00000097          	auipc	ra,0x0
    800045ec:	ddc080e7          	jalr	-548(ra) # 800043c4 <argfd>
    return -1;
    800045f0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800045f2:	02054363          	bltz	a0,80004618 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    800045f6:	fd843903          	ld	s2,-40(s0)
    800045fa:	854a                	mv	a0,s2
    800045fc:	00000097          	auipc	ra,0x0
    80004600:	e30080e7          	jalr	-464(ra) # 8000442c <fdalloc>
    80004604:	84aa                	mv	s1,a0
    return -1;
    80004606:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004608:	00054863          	bltz	a0,80004618 <sys_dup+0x44>
  filedup(f);
    8000460c:	854a                	mv	a0,s2
    8000460e:	fffff097          	auipc	ra,0xfffff
    80004612:	338080e7          	jalr	824(ra) # 80003946 <filedup>
  return fd;
    80004616:	87a6                	mv	a5,s1
}
    80004618:	853e                	mv	a0,a5
    8000461a:	70a2                	ld	ra,40(sp)
    8000461c:	7402                	ld	s0,32(sp)
    8000461e:	64e2                	ld	s1,24(sp)
    80004620:	6942                	ld	s2,16(sp)
    80004622:	6145                	addi	sp,sp,48
    80004624:	8082                	ret

0000000080004626 <sys_read>:
{
    80004626:	7179                	addi	sp,sp,-48
    80004628:	f406                	sd	ra,40(sp)
    8000462a:	f022                	sd	s0,32(sp)
    8000462c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000462e:	fe840613          	addi	a2,s0,-24
    80004632:	4581                	li	a1,0
    80004634:	4501                	li	a0,0
    80004636:	00000097          	auipc	ra,0x0
    8000463a:	d8e080e7          	jalr	-626(ra) # 800043c4 <argfd>
    return -1;
    8000463e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004640:	04054163          	bltz	a0,80004682 <sys_read+0x5c>
    80004644:	fe440593          	addi	a1,s0,-28
    80004648:	4509                	li	a0,2
    8000464a:	ffffe097          	auipc	ra,0xffffe
    8000464e:	938080e7          	jalr	-1736(ra) # 80001f82 <argint>
    return -1;
    80004652:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004654:	02054763          	bltz	a0,80004682 <sys_read+0x5c>
    80004658:	fd840593          	addi	a1,s0,-40
    8000465c:	4505                	li	a0,1
    8000465e:	ffffe097          	auipc	ra,0xffffe
    80004662:	946080e7          	jalr	-1722(ra) # 80001fa4 <argaddr>
    return -1;
    80004666:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004668:	00054d63          	bltz	a0,80004682 <sys_read+0x5c>
  return fileread(f, p, n);
    8000466c:	fe442603          	lw	a2,-28(s0)
    80004670:	fd843583          	ld	a1,-40(s0)
    80004674:	fe843503          	ld	a0,-24(s0)
    80004678:	fffff097          	auipc	ra,0xfffff
    8000467c:	476080e7          	jalr	1142(ra) # 80003aee <fileread>
    80004680:	87aa                	mv	a5,a0
}
    80004682:	853e                	mv	a0,a5
    80004684:	70a2                	ld	ra,40(sp)
    80004686:	7402                	ld	s0,32(sp)
    80004688:	6145                	addi	sp,sp,48
    8000468a:	8082                	ret

000000008000468c <sys_write>:
{
    8000468c:	7179                	addi	sp,sp,-48
    8000468e:	f406                	sd	ra,40(sp)
    80004690:	f022                	sd	s0,32(sp)
    80004692:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004694:	fe840613          	addi	a2,s0,-24
    80004698:	4581                	li	a1,0
    8000469a:	4501                	li	a0,0
    8000469c:	00000097          	auipc	ra,0x0
    800046a0:	d28080e7          	jalr	-728(ra) # 800043c4 <argfd>
    return -1;
    800046a4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046a6:	04054163          	bltz	a0,800046e8 <sys_write+0x5c>
    800046aa:	fe440593          	addi	a1,s0,-28
    800046ae:	4509                	li	a0,2
    800046b0:	ffffe097          	auipc	ra,0xffffe
    800046b4:	8d2080e7          	jalr	-1838(ra) # 80001f82 <argint>
    return -1;
    800046b8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046ba:	02054763          	bltz	a0,800046e8 <sys_write+0x5c>
    800046be:	fd840593          	addi	a1,s0,-40
    800046c2:	4505                	li	a0,1
    800046c4:	ffffe097          	auipc	ra,0xffffe
    800046c8:	8e0080e7          	jalr	-1824(ra) # 80001fa4 <argaddr>
    return -1;
    800046cc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046ce:	00054d63          	bltz	a0,800046e8 <sys_write+0x5c>
  return filewrite(f, p, n);
    800046d2:	fe442603          	lw	a2,-28(s0)
    800046d6:	fd843583          	ld	a1,-40(s0)
    800046da:	fe843503          	ld	a0,-24(s0)
    800046de:	fffff097          	auipc	ra,0xfffff
    800046e2:	4e6080e7          	jalr	1254(ra) # 80003bc4 <filewrite>
    800046e6:	87aa                	mv	a5,a0
}
    800046e8:	853e                	mv	a0,a5
    800046ea:	70a2                	ld	ra,40(sp)
    800046ec:	7402                	ld	s0,32(sp)
    800046ee:	6145                	addi	sp,sp,48
    800046f0:	8082                	ret

00000000800046f2 <sys_close>:
{
    800046f2:	1101                	addi	sp,sp,-32
    800046f4:	ec06                	sd	ra,24(sp)
    800046f6:	e822                	sd	s0,16(sp)
    800046f8:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800046fa:	fe040613          	addi	a2,s0,-32
    800046fe:	fec40593          	addi	a1,s0,-20
    80004702:	4501                	li	a0,0
    80004704:	00000097          	auipc	ra,0x0
    80004708:	cc0080e7          	jalr	-832(ra) # 800043c4 <argfd>
    return -1;
    8000470c:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000470e:	02054463          	bltz	a0,80004736 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004712:	ffffc097          	auipc	ra,0xffffc
    80004716:	78a080e7          	jalr	1930(ra) # 80000e9c <myproc>
    8000471a:	fec42783          	lw	a5,-20(s0)
    8000471e:	07e9                	addi	a5,a5,26
    80004720:	078e                	slli	a5,a5,0x3
    80004722:	953e                	add	a0,a0,a5
    80004724:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004728:	fe043503          	ld	a0,-32(s0)
    8000472c:	fffff097          	auipc	ra,0xfffff
    80004730:	26c080e7          	jalr	620(ra) # 80003998 <fileclose>
  return 0;
    80004734:	4781                	li	a5,0
}
    80004736:	853e                	mv	a0,a5
    80004738:	60e2                	ld	ra,24(sp)
    8000473a:	6442                	ld	s0,16(sp)
    8000473c:	6105                	addi	sp,sp,32
    8000473e:	8082                	ret

0000000080004740 <sys_fstat>:
{
    80004740:	1101                	addi	sp,sp,-32
    80004742:	ec06                	sd	ra,24(sp)
    80004744:	e822                	sd	s0,16(sp)
    80004746:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004748:	fe840613          	addi	a2,s0,-24
    8000474c:	4581                	li	a1,0
    8000474e:	4501                	li	a0,0
    80004750:	00000097          	auipc	ra,0x0
    80004754:	c74080e7          	jalr	-908(ra) # 800043c4 <argfd>
    return -1;
    80004758:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000475a:	02054563          	bltz	a0,80004784 <sys_fstat+0x44>
    8000475e:	fe040593          	addi	a1,s0,-32
    80004762:	4505                	li	a0,1
    80004764:	ffffe097          	auipc	ra,0xffffe
    80004768:	840080e7          	jalr	-1984(ra) # 80001fa4 <argaddr>
    return -1;
    8000476c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000476e:	00054b63          	bltz	a0,80004784 <sys_fstat+0x44>
  return filestat(f, st);
    80004772:	fe043583          	ld	a1,-32(s0)
    80004776:	fe843503          	ld	a0,-24(s0)
    8000477a:	fffff097          	auipc	ra,0xfffff
    8000477e:	302080e7          	jalr	770(ra) # 80003a7c <filestat>
    80004782:	87aa                	mv	a5,a0
}
    80004784:	853e                	mv	a0,a5
    80004786:	60e2                	ld	ra,24(sp)
    80004788:	6442                	ld	s0,16(sp)
    8000478a:	6105                	addi	sp,sp,32
    8000478c:	8082                	ret

000000008000478e <sys_link>:
{
    8000478e:	7169                	addi	sp,sp,-304
    80004790:	f606                	sd	ra,296(sp)
    80004792:	f222                	sd	s0,288(sp)
    80004794:	ee26                	sd	s1,280(sp)
    80004796:	ea4a                	sd	s2,272(sp)
    80004798:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000479a:	08000613          	li	a2,128
    8000479e:	ed040593          	addi	a1,s0,-304
    800047a2:	4501                	li	a0,0
    800047a4:	ffffe097          	auipc	ra,0xffffe
    800047a8:	822080e7          	jalr	-2014(ra) # 80001fc6 <argstr>
    return -1;
    800047ac:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047ae:	10054e63          	bltz	a0,800048ca <sys_link+0x13c>
    800047b2:	08000613          	li	a2,128
    800047b6:	f5040593          	addi	a1,s0,-176
    800047ba:	4505                	li	a0,1
    800047bc:	ffffe097          	auipc	ra,0xffffe
    800047c0:	80a080e7          	jalr	-2038(ra) # 80001fc6 <argstr>
    return -1;
    800047c4:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047c6:	10054263          	bltz	a0,800048ca <sys_link+0x13c>
  begin_op();
    800047ca:	fffff097          	auipc	ra,0xfffff
    800047ce:	d06080e7          	jalr	-762(ra) # 800034d0 <begin_op>
  if((ip = namei(old)) == 0){
    800047d2:	ed040513          	addi	a0,s0,-304
    800047d6:	fffff097          	auipc	ra,0xfffff
    800047da:	ada080e7          	jalr	-1318(ra) # 800032b0 <namei>
    800047de:	84aa                	mv	s1,a0
    800047e0:	c551                	beqz	a0,8000486c <sys_link+0xde>
  ilock(ip);
    800047e2:	ffffe097          	auipc	ra,0xffffe
    800047e6:	312080e7          	jalr	786(ra) # 80002af4 <ilock>
  if(ip->type == T_DIR){
    800047ea:	04449703          	lh	a4,68(s1)
    800047ee:	4785                	li	a5,1
    800047f0:	08f70463          	beq	a4,a5,80004878 <sys_link+0xea>
  ip->nlink++;
    800047f4:	04a4d783          	lhu	a5,74(s1)
    800047f8:	2785                	addiw	a5,a5,1
    800047fa:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800047fe:	8526                	mv	a0,s1
    80004800:	ffffe097          	auipc	ra,0xffffe
    80004804:	228080e7          	jalr	552(ra) # 80002a28 <iupdate>
  iunlock(ip);
    80004808:	8526                	mv	a0,s1
    8000480a:	ffffe097          	auipc	ra,0xffffe
    8000480e:	3ac080e7          	jalr	940(ra) # 80002bb6 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004812:	fd040593          	addi	a1,s0,-48
    80004816:	f5040513          	addi	a0,s0,-176
    8000481a:	fffff097          	auipc	ra,0xfffff
    8000481e:	ab4080e7          	jalr	-1356(ra) # 800032ce <nameiparent>
    80004822:	892a                	mv	s2,a0
    80004824:	c935                	beqz	a0,80004898 <sys_link+0x10a>
  ilock(dp);
    80004826:	ffffe097          	auipc	ra,0xffffe
    8000482a:	2ce080e7          	jalr	718(ra) # 80002af4 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    8000482e:	00092703          	lw	a4,0(s2)
    80004832:	409c                	lw	a5,0(s1)
    80004834:	04f71d63          	bne	a4,a5,8000488e <sys_link+0x100>
    80004838:	40d0                	lw	a2,4(s1)
    8000483a:	fd040593          	addi	a1,s0,-48
    8000483e:	854a                	mv	a0,s2
    80004840:	fffff097          	auipc	ra,0xfffff
    80004844:	9ae080e7          	jalr	-1618(ra) # 800031ee <dirlink>
    80004848:	04054363          	bltz	a0,8000488e <sys_link+0x100>
  iunlockput(dp);
    8000484c:	854a                	mv	a0,s2
    8000484e:	ffffe097          	auipc	ra,0xffffe
    80004852:	508080e7          	jalr	1288(ra) # 80002d56 <iunlockput>
  iput(ip);
    80004856:	8526                	mv	a0,s1
    80004858:	ffffe097          	auipc	ra,0xffffe
    8000485c:	456080e7          	jalr	1110(ra) # 80002cae <iput>
  end_op();
    80004860:	fffff097          	auipc	ra,0xfffff
    80004864:	cee080e7          	jalr	-786(ra) # 8000354e <end_op>
  return 0;
    80004868:	4781                	li	a5,0
    8000486a:	a085                	j	800048ca <sys_link+0x13c>
    end_op();
    8000486c:	fffff097          	auipc	ra,0xfffff
    80004870:	ce2080e7          	jalr	-798(ra) # 8000354e <end_op>
    return -1;
    80004874:	57fd                	li	a5,-1
    80004876:	a891                	j	800048ca <sys_link+0x13c>
    iunlockput(ip);
    80004878:	8526                	mv	a0,s1
    8000487a:	ffffe097          	auipc	ra,0xffffe
    8000487e:	4dc080e7          	jalr	1244(ra) # 80002d56 <iunlockput>
    end_op();
    80004882:	fffff097          	auipc	ra,0xfffff
    80004886:	ccc080e7          	jalr	-820(ra) # 8000354e <end_op>
    return -1;
    8000488a:	57fd                	li	a5,-1
    8000488c:	a83d                	j	800048ca <sys_link+0x13c>
    iunlockput(dp);
    8000488e:	854a                	mv	a0,s2
    80004890:	ffffe097          	auipc	ra,0xffffe
    80004894:	4c6080e7          	jalr	1222(ra) # 80002d56 <iunlockput>
  ilock(ip);
    80004898:	8526                	mv	a0,s1
    8000489a:	ffffe097          	auipc	ra,0xffffe
    8000489e:	25a080e7          	jalr	602(ra) # 80002af4 <ilock>
  ip->nlink--;
    800048a2:	04a4d783          	lhu	a5,74(s1)
    800048a6:	37fd                	addiw	a5,a5,-1
    800048a8:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800048ac:	8526                	mv	a0,s1
    800048ae:	ffffe097          	auipc	ra,0xffffe
    800048b2:	17a080e7          	jalr	378(ra) # 80002a28 <iupdate>
  iunlockput(ip);
    800048b6:	8526                	mv	a0,s1
    800048b8:	ffffe097          	auipc	ra,0xffffe
    800048bc:	49e080e7          	jalr	1182(ra) # 80002d56 <iunlockput>
  end_op();
    800048c0:	fffff097          	auipc	ra,0xfffff
    800048c4:	c8e080e7          	jalr	-882(ra) # 8000354e <end_op>
  return -1;
    800048c8:	57fd                	li	a5,-1
}
    800048ca:	853e                	mv	a0,a5
    800048cc:	70b2                	ld	ra,296(sp)
    800048ce:	7412                	ld	s0,288(sp)
    800048d0:	64f2                	ld	s1,280(sp)
    800048d2:	6952                	ld	s2,272(sp)
    800048d4:	6155                	addi	sp,sp,304
    800048d6:	8082                	ret

00000000800048d8 <sys_unlink>:
{
    800048d8:	7151                	addi	sp,sp,-240
    800048da:	f586                	sd	ra,232(sp)
    800048dc:	f1a2                	sd	s0,224(sp)
    800048de:	eda6                	sd	s1,216(sp)
    800048e0:	e9ca                	sd	s2,208(sp)
    800048e2:	e5ce                	sd	s3,200(sp)
    800048e4:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800048e6:	08000613          	li	a2,128
    800048ea:	f3040593          	addi	a1,s0,-208
    800048ee:	4501                	li	a0,0
    800048f0:	ffffd097          	auipc	ra,0xffffd
    800048f4:	6d6080e7          	jalr	1750(ra) # 80001fc6 <argstr>
    800048f8:	18054163          	bltz	a0,80004a7a <sys_unlink+0x1a2>
  begin_op();
    800048fc:	fffff097          	auipc	ra,0xfffff
    80004900:	bd4080e7          	jalr	-1068(ra) # 800034d0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004904:	fb040593          	addi	a1,s0,-80
    80004908:	f3040513          	addi	a0,s0,-208
    8000490c:	fffff097          	auipc	ra,0xfffff
    80004910:	9c2080e7          	jalr	-1598(ra) # 800032ce <nameiparent>
    80004914:	84aa                	mv	s1,a0
    80004916:	c979                	beqz	a0,800049ec <sys_unlink+0x114>
  ilock(dp);
    80004918:	ffffe097          	auipc	ra,0xffffe
    8000491c:	1dc080e7          	jalr	476(ra) # 80002af4 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004920:	00005597          	auipc	a1,0x5
    80004924:	da858593          	addi	a1,a1,-600 # 800096c8 <syscalls+0x2f0>
    80004928:	fb040513          	addi	a0,s0,-80
    8000492c:	ffffe097          	auipc	ra,0xffffe
    80004930:	692080e7          	jalr	1682(ra) # 80002fbe <namecmp>
    80004934:	14050a63          	beqz	a0,80004a88 <sys_unlink+0x1b0>
    80004938:	00005597          	auipc	a1,0x5
    8000493c:	d9858593          	addi	a1,a1,-616 # 800096d0 <syscalls+0x2f8>
    80004940:	fb040513          	addi	a0,s0,-80
    80004944:	ffffe097          	auipc	ra,0xffffe
    80004948:	67a080e7          	jalr	1658(ra) # 80002fbe <namecmp>
    8000494c:	12050e63          	beqz	a0,80004a88 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004950:	f2c40613          	addi	a2,s0,-212
    80004954:	fb040593          	addi	a1,s0,-80
    80004958:	8526                	mv	a0,s1
    8000495a:	ffffe097          	auipc	ra,0xffffe
    8000495e:	67e080e7          	jalr	1662(ra) # 80002fd8 <dirlookup>
    80004962:	892a                	mv	s2,a0
    80004964:	12050263          	beqz	a0,80004a88 <sys_unlink+0x1b0>
  ilock(ip);
    80004968:	ffffe097          	auipc	ra,0xffffe
    8000496c:	18c080e7          	jalr	396(ra) # 80002af4 <ilock>
  if(ip->nlink < 1)
    80004970:	04a91783          	lh	a5,74(s2)
    80004974:	08f05263          	blez	a5,800049f8 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004978:	04491703          	lh	a4,68(s2)
    8000497c:	4785                	li	a5,1
    8000497e:	08f70563          	beq	a4,a5,80004a08 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004982:	4641                	li	a2,16
    80004984:	4581                	li	a1,0
    80004986:	fc040513          	addi	a0,s0,-64
    8000498a:	ffffb097          	auipc	ra,0xffffb
    8000498e:	7f0080e7          	jalr	2032(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004992:	4741                	li	a4,16
    80004994:	f2c42683          	lw	a3,-212(s0)
    80004998:	fc040613          	addi	a2,s0,-64
    8000499c:	4581                	li	a1,0
    8000499e:	8526                	mv	a0,s1
    800049a0:	ffffe097          	auipc	ra,0xffffe
    800049a4:	500080e7          	jalr	1280(ra) # 80002ea0 <writei>
    800049a8:	47c1                	li	a5,16
    800049aa:	0af51563          	bne	a0,a5,80004a54 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    800049ae:	04491703          	lh	a4,68(s2)
    800049b2:	4785                	li	a5,1
    800049b4:	0af70863          	beq	a4,a5,80004a64 <sys_unlink+0x18c>
  iunlockput(dp);
    800049b8:	8526                	mv	a0,s1
    800049ba:	ffffe097          	auipc	ra,0xffffe
    800049be:	39c080e7          	jalr	924(ra) # 80002d56 <iunlockput>
  ip->nlink--;
    800049c2:	04a95783          	lhu	a5,74(s2)
    800049c6:	37fd                	addiw	a5,a5,-1
    800049c8:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800049cc:	854a                	mv	a0,s2
    800049ce:	ffffe097          	auipc	ra,0xffffe
    800049d2:	05a080e7          	jalr	90(ra) # 80002a28 <iupdate>
  iunlockput(ip);
    800049d6:	854a                	mv	a0,s2
    800049d8:	ffffe097          	auipc	ra,0xffffe
    800049dc:	37e080e7          	jalr	894(ra) # 80002d56 <iunlockput>
  end_op();
    800049e0:	fffff097          	auipc	ra,0xfffff
    800049e4:	b6e080e7          	jalr	-1170(ra) # 8000354e <end_op>
  return 0;
    800049e8:	4501                	li	a0,0
    800049ea:	a84d                	j	80004a9c <sys_unlink+0x1c4>
    end_op();
    800049ec:	fffff097          	auipc	ra,0xfffff
    800049f0:	b62080e7          	jalr	-1182(ra) # 8000354e <end_op>
    return -1;
    800049f4:	557d                	li	a0,-1
    800049f6:	a05d                	j	80004a9c <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    800049f8:	00005517          	auipc	a0,0x5
    800049fc:	d0050513          	addi	a0,a0,-768 # 800096f8 <syscalls+0x320>
    80004a00:	00002097          	auipc	ra,0x2
    80004a04:	170080e7          	jalr	368(ra) # 80006b70 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a08:	04c92703          	lw	a4,76(s2)
    80004a0c:	02000793          	li	a5,32
    80004a10:	f6e7f9e3          	bgeu	a5,a4,80004982 <sys_unlink+0xaa>
    80004a14:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a18:	4741                	li	a4,16
    80004a1a:	86ce                	mv	a3,s3
    80004a1c:	f1840613          	addi	a2,s0,-232
    80004a20:	4581                	li	a1,0
    80004a22:	854a                	mv	a0,s2
    80004a24:	ffffe097          	auipc	ra,0xffffe
    80004a28:	384080e7          	jalr	900(ra) # 80002da8 <readi>
    80004a2c:	47c1                	li	a5,16
    80004a2e:	00f51b63          	bne	a0,a5,80004a44 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004a32:	f1845783          	lhu	a5,-232(s0)
    80004a36:	e7a1                	bnez	a5,80004a7e <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a38:	29c1                	addiw	s3,s3,16
    80004a3a:	04c92783          	lw	a5,76(s2)
    80004a3e:	fcf9ede3          	bltu	s3,a5,80004a18 <sys_unlink+0x140>
    80004a42:	b781                	j	80004982 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004a44:	00005517          	auipc	a0,0x5
    80004a48:	ccc50513          	addi	a0,a0,-820 # 80009710 <syscalls+0x338>
    80004a4c:	00002097          	auipc	ra,0x2
    80004a50:	124080e7          	jalr	292(ra) # 80006b70 <panic>
    panic("unlink: writei");
    80004a54:	00005517          	auipc	a0,0x5
    80004a58:	cd450513          	addi	a0,a0,-812 # 80009728 <syscalls+0x350>
    80004a5c:	00002097          	auipc	ra,0x2
    80004a60:	114080e7          	jalr	276(ra) # 80006b70 <panic>
    dp->nlink--;
    80004a64:	04a4d783          	lhu	a5,74(s1)
    80004a68:	37fd                	addiw	a5,a5,-1
    80004a6a:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004a6e:	8526                	mv	a0,s1
    80004a70:	ffffe097          	auipc	ra,0xffffe
    80004a74:	fb8080e7          	jalr	-72(ra) # 80002a28 <iupdate>
    80004a78:	b781                	j	800049b8 <sys_unlink+0xe0>
    return -1;
    80004a7a:	557d                	li	a0,-1
    80004a7c:	a005                	j	80004a9c <sys_unlink+0x1c4>
    iunlockput(ip);
    80004a7e:	854a                	mv	a0,s2
    80004a80:	ffffe097          	auipc	ra,0xffffe
    80004a84:	2d6080e7          	jalr	726(ra) # 80002d56 <iunlockput>
  iunlockput(dp);
    80004a88:	8526                	mv	a0,s1
    80004a8a:	ffffe097          	auipc	ra,0xffffe
    80004a8e:	2cc080e7          	jalr	716(ra) # 80002d56 <iunlockput>
  end_op();
    80004a92:	fffff097          	auipc	ra,0xfffff
    80004a96:	abc080e7          	jalr	-1348(ra) # 8000354e <end_op>
  return -1;
    80004a9a:	557d                	li	a0,-1
}
    80004a9c:	70ae                	ld	ra,232(sp)
    80004a9e:	740e                	ld	s0,224(sp)
    80004aa0:	64ee                	ld	s1,216(sp)
    80004aa2:	694e                	ld	s2,208(sp)
    80004aa4:	69ae                	ld	s3,200(sp)
    80004aa6:	616d                	addi	sp,sp,240
    80004aa8:	8082                	ret

0000000080004aaa <sys_open>:

uint64
sys_open(void)
{
    80004aaa:	7131                	addi	sp,sp,-192
    80004aac:	fd06                	sd	ra,184(sp)
    80004aae:	f922                	sd	s0,176(sp)
    80004ab0:	f526                	sd	s1,168(sp)
    80004ab2:	f14a                	sd	s2,160(sp)
    80004ab4:	ed4e                	sd	s3,152(sp)
    80004ab6:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004ab8:	08000613          	li	a2,128
    80004abc:	f5040593          	addi	a1,s0,-176
    80004ac0:	4501                	li	a0,0
    80004ac2:	ffffd097          	auipc	ra,0xffffd
    80004ac6:	504080e7          	jalr	1284(ra) # 80001fc6 <argstr>
    return -1;
    80004aca:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004acc:	0c054163          	bltz	a0,80004b8e <sys_open+0xe4>
    80004ad0:	f4c40593          	addi	a1,s0,-180
    80004ad4:	4505                	li	a0,1
    80004ad6:	ffffd097          	auipc	ra,0xffffd
    80004ada:	4ac080e7          	jalr	1196(ra) # 80001f82 <argint>
    80004ade:	0a054863          	bltz	a0,80004b8e <sys_open+0xe4>

  begin_op();
    80004ae2:	fffff097          	auipc	ra,0xfffff
    80004ae6:	9ee080e7          	jalr	-1554(ra) # 800034d0 <begin_op>

  if(omode & O_CREATE){
    80004aea:	f4c42783          	lw	a5,-180(s0)
    80004aee:	2007f793          	andi	a5,a5,512
    80004af2:	cbdd                	beqz	a5,80004ba8 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004af4:	4681                	li	a3,0
    80004af6:	4601                	li	a2,0
    80004af8:	4589                	li	a1,2
    80004afa:	f5040513          	addi	a0,s0,-176
    80004afe:	00000097          	auipc	ra,0x0
    80004b02:	970080e7          	jalr	-1680(ra) # 8000446e <create>
    80004b06:	892a                	mv	s2,a0
    if(ip == 0){
    80004b08:	c959                	beqz	a0,80004b9e <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004b0a:	04491703          	lh	a4,68(s2)
    80004b0e:	478d                	li	a5,3
    80004b10:	00f71763          	bne	a4,a5,80004b1e <sys_open+0x74>
    80004b14:	04695703          	lhu	a4,70(s2)
    80004b18:	47a5                	li	a5,9
    80004b1a:	0ce7ec63          	bltu	a5,a4,80004bf2 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004b1e:	fffff097          	auipc	ra,0xfffff
    80004b22:	dbe080e7          	jalr	-578(ra) # 800038dc <filealloc>
    80004b26:	89aa                	mv	s3,a0
    80004b28:	10050263          	beqz	a0,80004c2c <sys_open+0x182>
    80004b2c:	00000097          	auipc	ra,0x0
    80004b30:	900080e7          	jalr	-1792(ra) # 8000442c <fdalloc>
    80004b34:	84aa                	mv	s1,a0
    80004b36:	0e054663          	bltz	a0,80004c22 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004b3a:	04491703          	lh	a4,68(s2)
    80004b3e:	478d                	li	a5,3
    80004b40:	0cf70463          	beq	a4,a5,80004c08 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004b44:	4789                	li	a5,2
    80004b46:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004b4a:	0209a423          	sw	zero,40(s3)
  }
  f->ip = ip;
    80004b4e:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004b52:	f4c42783          	lw	a5,-180(s0)
    80004b56:	0017c713          	xori	a4,a5,1
    80004b5a:	8b05                	andi	a4,a4,1
    80004b5c:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004b60:	0037f713          	andi	a4,a5,3
    80004b64:	00e03733          	snez	a4,a4
    80004b68:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004b6c:	4007f793          	andi	a5,a5,1024
    80004b70:	c791                	beqz	a5,80004b7c <sys_open+0xd2>
    80004b72:	04491703          	lh	a4,68(s2)
    80004b76:	4789                	li	a5,2
    80004b78:	08f70f63          	beq	a4,a5,80004c16 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004b7c:	854a                	mv	a0,s2
    80004b7e:	ffffe097          	auipc	ra,0xffffe
    80004b82:	038080e7          	jalr	56(ra) # 80002bb6 <iunlock>
  end_op();
    80004b86:	fffff097          	auipc	ra,0xfffff
    80004b8a:	9c8080e7          	jalr	-1592(ra) # 8000354e <end_op>

  return fd;
}
    80004b8e:	8526                	mv	a0,s1
    80004b90:	70ea                	ld	ra,184(sp)
    80004b92:	744a                	ld	s0,176(sp)
    80004b94:	74aa                	ld	s1,168(sp)
    80004b96:	790a                	ld	s2,160(sp)
    80004b98:	69ea                	ld	s3,152(sp)
    80004b9a:	6129                	addi	sp,sp,192
    80004b9c:	8082                	ret
      end_op();
    80004b9e:	fffff097          	auipc	ra,0xfffff
    80004ba2:	9b0080e7          	jalr	-1616(ra) # 8000354e <end_op>
      return -1;
    80004ba6:	b7e5                	j	80004b8e <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004ba8:	f5040513          	addi	a0,s0,-176
    80004bac:	ffffe097          	auipc	ra,0xffffe
    80004bb0:	704080e7          	jalr	1796(ra) # 800032b0 <namei>
    80004bb4:	892a                	mv	s2,a0
    80004bb6:	c905                	beqz	a0,80004be6 <sys_open+0x13c>
    ilock(ip);
    80004bb8:	ffffe097          	auipc	ra,0xffffe
    80004bbc:	f3c080e7          	jalr	-196(ra) # 80002af4 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004bc0:	04491703          	lh	a4,68(s2)
    80004bc4:	4785                	li	a5,1
    80004bc6:	f4f712e3          	bne	a4,a5,80004b0a <sys_open+0x60>
    80004bca:	f4c42783          	lw	a5,-180(s0)
    80004bce:	dba1                	beqz	a5,80004b1e <sys_open+0x74>
      iunlockput(ip);
    80004bd0:	854a                	mv	a0,s2
    80004bd2:	ffffe097          	auipc	ra,0xffffe
    80004bd6:	184080e7          	jalr	388(ra) # 80002d56 <iunlockput>
      end_op();
    80004bda:	fffff097          	auipc	ra,0xfffff
    80004bde:	974080e7          	jalr	-1676(ra) # 8000354e <end_op>
      return -1;
    80004be2:	54fd                	li	s1,-1
    80004be4:	b76d                	j	80004b8e <sys_open+0xe4>
      end_op();
    80004be6:	fffff097          	auipc	ra,0xfffff
    80004bea:	968080e7          	jalr	-1688(ra) # 8000354e <end_op>
      return -1;
    80004bee:	54fd                	li	s1,-1
    80004bf0:	bf79                	j	80004b8e <sys_open+0xe4>
    iunlockput(ip);
    80004bf2:	854a                	mv	a0,s2
    80004bf4:	ffffe097          	auipc	ra,0xffffe
    80004bf8:	162080e7          	jalr	354(ra) # 80002d56 <iunlockput>
    end_op();
    80004bfc:	fffff097          	auipc	ra,0xfffff
    80004c00:	952080e7          	jalr	-1710(ra) # 8000354e <end_op>
    return -1;
    80004c04:	54fd                	li	s1,-1
    80004c06:	b761                	j	80004b8e <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004c08:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004c0c:	04691783          	lh	a5,70(s2)
    80004c10:	02f99623          	sh	a5,44(s3)
    80004c14:	bf2d                	j	80004b4e <sys_open+0xa4>
    itrunc(ip);
    80004c16:	854a                	mv	a0,s2
    80004c18:	ffffe097          	auipc	ra,0xffffe
    80004c1c:	fea080e7          	jalr	-22(ra) # 80002c02 <itrunc>
    80004c20:	bfb1                	j	80004b7c <sys_open+0xd2>
      fileclose(f);
    80004c22:	854e                	mv	a0,s3
    80004c24:	fffff097          	auipc	ra,0xfffff
    80004c28:	d74080e7          	jalr	-652(ra) # 80003998 <fileclose>
    iunlockput(ip);
    80004c2c:	854a                	mv	a0,s2
    80004c2e:	ffffe097          	auipc	ra,0xffffe
    80004c32:	128080e7          	jalr	296(ra) # 80002d56 <iunlockput>
    end_op();
    80004c36:	fffff097          	auipc	ra,0xfffff
    80004c3a:	918080e7          	jalr	-1768(ra) # 8000354e <end_op>
    return -1;
    80004c3e:	54fd                	li	s1,-1
    80004c40:	b7b9                	j	80004b8e <sys_open+0xe4>

0000000080004c42 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004c42:	7175                	addi	sp,sp,-144
    80004c44:	e506                	sd	ra,136(sp)
    80004c46:	e122                	sd	s0,128(sp)
    80004c48:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004c4a:	fffff097          	auipc	ra,0xfffff
    80004c4e:	886080e7          	jalr	-1914(ra) # 800034d0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004c52:	08000613          	li	a2,128
    80004c56:	f7040593          	addi	a1,s0,-144
    80004c5a:	4501                	li	a0,0
    80004c5c:	ffffd097          	auipc	ra,0xffffd
    80004c60:	36a080e7          	jalr	874(ra) # 80001fc6 <argstr>
    80004c64:	02054963          	bltz	a0,80004c96 <sys_mkdir+0x54>
    80004c68:	4681                	li	a3,0
    80004c6a:	4601                	li	a2,0
    80004c6c:	4585                	li	a1,1
    80004c6e:	f7040513          	addi	a0,s0,-144
    80004c72:	fffff097          	auipc	ra,0xfffff
    80004c76:	7fc080e7          	jalr	2044(ra) # 8000446e <create>
    80004c7a:	cd11                	beqz	a0,80004c96 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004c7c:	ffffe097          	auipc	ra,0xffffe
    80004c80:	0da080e7          	jalr	218(ra) # 80002d56 <iunlockput>
  end_op();
    80004c84:	fffff097          	auipc	ra,0xfffff
    80004c88:	8ca080e7          	jalr	-1846(ra) # 8000354e <end_op>
  return 0;
    80004c8c:	4501                	li	a0,0
}
    80004c8e:	60aa                	ld	ra,136(sp)
    80004c90:	640a                	ld	s0,128(sp)
    80004c92:	6149                	addi	sp,sp,144
    80004c94:	8082                	ret
    end_op();
    80004c96:	fffff097          	auipc	ra,0xfffff
    80004c9a:	8b8080e7          	jalr	-1864(ra) # 8000354e <end_op>
    return -1;
    80004c9e:	557d                	li	a0,-1
    80004ca0:	b7fd                	j	80004c8e <sys_mkdir+0x4c>

0000000080004ca2 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004ca2:	7135                	addi	sp,sp,-160
    80004ca4:	ed06                	sd	ra,152(sp)
    80004ca6:	e922                	sd	s0,144(sp)
    80004ca8:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004caa:	fffff097          	auipc	ra,0xfffff
    80004cae:	826080e7          	jalr	-2010(ra) # 800034d0 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004cb2:	08000613          	li	a2,128
    80004cb6:	f7040593          	addi	a1,s0,-144
    80004cba:	4501                	li	a0,0
    80004cbc:	ffffd097          	auipc	ra,0xffffd
    80004cc0:	30a080e7          	jalr	778(ra) # 80001fc6 <argstr>
    80004cc4:	04054a63          	bltz	a0,80004d18 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004cc8:	f6c40593          	addi	a1,s0,-148
    80004ccc:	4505                	li	a0,1
    80004cce:	ffffd097          	auipc	ra,0xffffd
    80004cd2:	2b4080e7          	jalr	692(ra) # 80001f82 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004cd6:	04054163          	bltz	a0,80004d18 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004cda:	f6840593          	addi	a1,s0,-152
    80004cde:	4509                	li	a0,2
    80004ce0:	ffffd097          	auipc	ra,0xffffd
    80004ce4:	2a2080e7          	jalr	674(ra) # 80001f82 <argint>
     argint(1, &major) < 0 ||
    80004ce8:	02054863          	bltz	a0,80004d18 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004cec:	f6841683          	lh	a3,-152(s0)
    80004cf0:	f6c41603          	lh	a2,-148(s0)
    80004cf4:	458d                	li	a1,3
    80004cf6:	f7040513          	addi	a0,s0,-144
    80004cfa:	fffff097          	auipc	ra,0xfffff
    80004cfe:	774080e7          	jalr	1908(ra) # 8000446e <create>
     argint(2, &minor) < 0 ||
    80004d02:	c919                	beqz	a0,80004d18 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d04:	ffffe097          	auipc	ra,0xffffe
    80004d08:	052080e7          	jalr	82(ra) # 80002d56 <iunlockput>
  end_op();
    80004d0c:	fffff097          	auipc	ra,0xfffff
    80004d10:	842080e7          	jalr	-1982(ra) # 8000354e <end_op>
  return 0;
    80004d14:	4501                	li	a0,0
    80004d16:	a031                	j	80004d22 <sys_mknod+0x80>
    end_op();
    80004d18:	fffff097          	auipc	ra,0xfffff
    80004d1c:	836080e7          	jalr	-1994(ra) # 8000354e <end_op>
    return -1;
    80004d20:	557d                	li	a0,-1
}
    80004d22:	60ea                	ld	ra,152(sp)
    80004d24:	644a                	ld	s0,144(sp)
    80004d26:	610d                	addi	sp,sp,160
    80004d28:	8082                	ret

0000000080004d2a <sys_chdir>:

uint64
sys_chdir(void)
{
    80004d2a:	7135                	addi	sp,sp,-160
    80004d2c:	ed06                	sd	ra,152(sp)
    80004d2e:	e922                	sd	s0,144(sp)
    80004d30:	e526                	sd	s1,136(sp)
    80004d32:	e14a                	sd	s2,128(sp)
    80004d34:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004d36:	ffffc097          	auipc	ra,0xffffc
    80004d3a:	166080e7          	jalr	358(ra) # 80000e9c <myproc>
    80004d3e:	892a                	mv	s2,a0
  
  begin_op();
    80004d40:	ffffe097          	auipc	ra,0xffffe
    80004d44:	790080e7          	jalr	1936(ra) # 800034d0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004d48:	08000613          	li	a2,128
    80004d4c:	f6040593          	addi	a1,s0,-160
    80004d50:	4501                	li	a0,0
    80004d52:	ffffd097          	auipc	ra,0xffffd
    80004d56:	274080e7          	jalr	628(ra) # 80001fc6 <argstr>
    80004d5a:	04054b63          	bltz	a0,80004db0 <sys_chdir+0x86>
    80004d5e:	f6040513          	addi	a0,s0,-160
    80004d62:	ffffe097          	auipc	ra,0xffffe
    80004d66:	54e080e7          	jalr	1358(ra) # 800032b0 <namei>
    80004d6a:	84aa                	mv	s1,a0
    80004d6c:	c131                	beqz	a0,80004db0 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004d6e:	ffffe097          	auipc	ra,0xffffe
    80004d72:	d86080e7          	jalr	-634(ra) # 80002af4 <ilock>
  if(ip->type != T_DIR){
    80004d76:	04449703          	lh	a4,68(s1)
    80004d7a:	4785                	li	a5,1
    80004d7c:	04f71063          	bne	a4,a5,80004dbc <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004d80:	8526                	mv	a0,s1
    80004d82:	ffffe097          	auipc	ra,0xffffe
    80004d86:	e34080e7          	jalr	-460(ra) # 80002bb6 <iunlock>
  iput(p->cwd);
    80004d8a:	15093503          	ld	a0,336(s2)
    80004d8e:	ffffe097          	auipc	ra,0xffffe
    80004d92:	f20080e7          	jalr	-224(ra) # 80002cae <iput>
  end_op();
    80004d96:	ffffe097          	auipc	ra,0xffffe
    80004d9a:	7b8080e7          	jalr	1976(ra) # 8000354e <end_op>
  p->cwd = ip;
    80004d9e:	14993823          	sd	s1,336(s2)
  return 0;
    80004da2:	4501                	li	a0,0
}
    80004da4:	60ea                	ld	ra,152(sp)
    80004da6:	644a                	ld	s0,144(sp)
    80004da8:	64aa                	ld	s1,136(sp)
    80004daa:	690a                	ld	s2,128(sp)
    80004dac:	610d                	addi	sp,sp,160
    80004dae:	8082                	ret
    end_op();
    80004db0:	ffffe097          	auipc	ra,0xffffe
    80004db4:	79e080e7          	jalr	1950(ra) # 8000354e <end_op>
    return -1;
    80004db8:	557d                	li	a0,-1
    80004dba:	b7ed                	j	80004da4 <sys_chdir+0x7a>
    iunlockput(ip);
    80004dbc:	8526                	mv	a0,s1
    80004dbe:	ffffe097          	auipc	ra,0xffffe
    80004dc2:	f98080e7          	jalr	-104(ra) # 80002d56 <iunlockput>
    end_op();
    80004dc6:	ffffe097          	auipc	ra,0xffffe
    80004dca:	788080e7          	jalr	1928(ra) # 8000354e <end_op>
    return -1;
    80004dce:	557d                	li	a0,-1
    80004dd0:	bfd1                	j	80004da4 <sys_chdir+0x7a>

0000000080004dd2 <sys_exec>:

uint64
sys_exec(void)
{
    80004dd2:	7145                	addi	sp,sp,-464
    80004dd4:	e786                	sd	ra,456(sp)
    80004dd6:	e3a2                	sd	s0,448(sp)
    80004dd8:	ff26                	sd	s1,440(sp)
    80004dda:	fb4a                	sd	s2,432(sp)
    80004ddc:	f74e                	sd	s3,424(sp)
    80004dde:	f352                	sd	s4,416(sp)
    80004de0:	ef56                	sd	s5,408(sp)
    80004de2:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004de4:	08000613          	li	a2,128
    80004de8:	f4040593          	addi	a1,s0,-192
    80004dec:	4501                	li	a0,0
    80004dee:	ffffd097          	auipc	ra,0xffffd
    80004df2:	1d8080e7          	jalr	472(ra) # 80001fc6 <argstr>
    return -1;
    80004df6:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004df8:	0c054b63          	bltz	a0,80004ece <sys_exec+0xfc>
    80004dfc:	e3840593          	addi	a1,s0,-456
    80004e00:	4505                	li	a0,1
    80004e02:	ffffd097          	auipc	ra,0xffffd
    80004e06:	1a2080e7          	jalr	418(ra) # 80001fa4 <argaddr>
    80004e0a:	0c054263          	bltz	a0,80004ece <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    80004e0e:	10000613          	li	a2,256
    80004e12:	4581                	li	a1,0
    80004e14:	e4040513          	addi	a0,s0,-448
    80004e18:	ffffb097          	auipc	ra,0xffffb
    80004e1c:	362080e7          	jalr	866(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004e20:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004e24:	89a6                	mv	s3,s1
    80004e26:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004e28:	02000a13          	li	s4,32
    80004e2c:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004e30:	00391513          	slli	a0,s2,0x3
    80004e34:	e3040593          	addi	a1,s0,-464
    80004e38:	e3843783          	ld	a5,-456(s0)
    80004e3c:	953e                	add	a0,a0,a5
    80004e3e:	ffffd097          	auipc	ra,0xffffd
    80004e42:	0aa080e7          	jalr	170(ra) # 80001ee8 <fetchaddr>
    80004e46:	02054a63          	bltz	a0,80004e7a <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80004e4a:	e3043783          	ld	a5,-464(s0)
    80004e4e:	c3b9                	beqz	a5,80004e94 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004e50:	ffffb097          	auipc	ra,0xffffb
    80004e54:	2ca080e7          	jalr	714(ra) # 8000011a <kalloc>
    80004e58:	85aa                	mv	a1,a0
    80004e5a:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004e5e:	cd11                	beqz	a0,80004e7a <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004e60:	6605                	lui	a2,0x1
    80004e62:	e3043503          	ld	a0,-464(s0)
    80004e66:	ffffd097          	auipc	ra,0xffffd
    80004e6a:	0d4080e7          	jalr	212(ra) # 80001f3a <fetchstr>
    80004e6e:	00054663          	bltz	a0,80004e7a <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80004e72:	0905                	addi	s2,s2,1
    80004e74:	09a1                	addi	s3,s3,8
    80004e76:	fb491be3          	bne	s2,s4,80004e2c <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e7a:	f4040913          	addi	s2,s0,-192
    80004e7e:	6088                	ld	a0,0(s1)
    80004e80:	c531                	beqz	a0,80004ecc <sys_exec+0xfa>
    kfree(argv[i]);
    80004e82:	ffffb097          	auipc	ra,0xffffb
    80004e86:	19a080e7          	jalr	410(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e8a:	04a1                	addi	s1,s1,8
    80004e8c:	ff2499e3          	bne	s1,s2,80004e7e <sys_exec+0xac>
  return -1;
    80004e90:	597d                	li	s2,-1
    80004e92:	a835                	j	80004ece <sys_exec+0xfc>
      argv[i] = 0;
    80004e94:	0a8e                	slli	s5,s5,0x3
    80004e96:	fc0a8793          	addi	a5,s5,-64 # ffffffffffffefc0 <end+0xffffffff7ffd7a40>
    80004e9a:	00878ab3          	add	s5,a5,s0
    80004e9e:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004ea2:	e4040593          	addi	a1,s0,-448
    80004ea6:	f4040513          	addi	a0,s0,-192
    80004eaa:	fffff097          	auipc	ra,0xfffff
    80004eae:	172080e7          	jalr	370(ra) # 8000401c <exec>
    80004eb2:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004eb4:	f4040993          	addi	s3,s0,-192
    80004eb8:	6088                	ld	a0,0(s1)
    80004eba:	c911                	beqz	a0,80004ece <sys_exec+0xfc>
    kfree(argv[i]);
    80004ebc:	ffffb097          	auipc	ra,0xffffb
    80004ec0:	160080e7          	jalr	352(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ec4:	04a1                	addi	s1,s1,8
    80004ec6:	ff3499e3          	bne	s1,s3,80004eb8 <sys_exec+0xe6>
    80004eca:	a011                	j	80004ece <sys_exec+0xfc>
  return -1;
    80004ecc:	597d                	li	s2,-1
}
    80004ece:	854a                	mv	a0,s2
    80004ed0:	60be                	ld	ra,456(sp)
    80004ed2:	641e                	ld	s0,448(sp)
    80004ed4:	74fa                	ld	s1,440(sp)
    80004ed6:	795a                	ld	s2,432(sp)
    80004ed8:	79ba                	ld	s3,424(sp)
    80004eda:	7a1a                	ld	s4,416(sp)
    80004edc:	6afa                	ld	s5,408(sp)
    80004ede:	6179                	addi	sp,sp,464
    80004ee0:	8082                	ret

0000000080004ee2 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004ee2:	7139                	addi	sp,sp,-64
    80004ee4:	fc06                	sd	ra,56(sp)
    80004ee6:	f822                	sd	s0,48(sp)
    80004ee8:	f426                	sd	s1,40(sp)
    80004eea:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004eec:	ffffc097          	auipc	ra,0xffffc
    80004ef0:	fb0080e7          	jalr	-80(ra) # 80000e9c <myproc>
    80004ef4:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80004ef6:	fd840593          	addi	a1,s0,-40
    80004efa:	4501                	li	a0,0
    80004efc:	ffffd097          	auipc	ra,0xffffd
    80004f00:	0a8080e7          	jalr	168(ra) # 80001fa4 <argaddr>
    return -1;
    80004f04:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80004f06:	0e054063          	bltz	a0,80004fe6 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80004f0a:	fc840593          	addi	a1,s0,-56
    80004f0e:	fd040513          	addi	a0,s0,-48
    80004f12:	fffff097          	auipc	ra,0xfffff
    80004f16:	de6080e7          	jalr	-538(ra) # 80003cf8 <pipealloc>
    return -1;
    80004f1a:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004f1c:	0c054563          	bltz	a0,80004fe6 <sys_pipe+0x104>
  fd0 = -1;
    80004f20:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004f24:	fd043503          	ld	a0,-48(s0)
    80004f28:	fffff097          	auipc	ra,0xfffff
    80004f2c:	504080e7          	jalr	1284(ra) # 8000442c <fdalloc>
    80004f30:	fca42223          	sw	a0,-60(s0)
    80004f34:	08054c63          	bltz	a0,80004fcc <sys_pipe+0xea>
    80004f38:	fc843503          	ld	a0,-56(s0)
    80004f3c:	fffff097          	auipc	ra,0xfffff
    80004f40:	4f0080e7          	jalr	1264(ra) # 8000442c <fdalloc>
    80004f44:	fca42023          	sw	a0,-64(s0)
    80004f48:	06054963          	bltz	a0,80004fba <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004f4c:	4691                	li	a3,4
    80004f4e:	fc440613          	addi	a2,s0,-60
    80004f52:	fd843583          	ld	a1,-40(s0)
    80004f56:	68a8                	ld	a0,80(s1)
    80004f58:	ffffc097          	auipc	ra,0xffffc
    80004f5c:	c0c080e7          	jalr	-1012(ra) # 80000b64 <copyout>
    80004f60:	02054063          	bltz	a0,80004f80 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004f64:	4691                	li	a3,4
    80004f66:	fc040613          	addi	a2,s0,-64
    80004f6a:	fd843583          	ld	a1,-40(s0)
    80004f6e:	0591                	addi	a1,a1,4
    80004f70:	68a8                	ld	a0,80(s1)
    80004f72:	ffffc097          	auipc	ra,0xffffc
    80004f76:	bf2080e7          	jalr	-1038(ra) # 80000b64 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004f7a:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004f7c:	06055563          	bgez	a0,80004fe6 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80004f80:	fc442783          	lw	a5,-60(s0)
    80004f84:	07e9                	addi	a5,a5,26
    80004f86:	078e                	slli	a5,a5,0x3
    80004f88:	97a6                	add	a5,a5,s1
    80004f8a:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004f8e:	fc042783          	lw	a5,-64(s0)
    80004f92:	07e9                	addi	a5,a5,26
    80004f94:	078e                	slli	a5,a5,0x3
    80004f96:	00f48533          	add	a0,s1,a5
    80004f9a:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80004f9e:	fd043503          	ld	a0,-48(s0)
    80004fa2:	fffff097          	auipc	ra,0xfffff
    80004fa6:	9f6080e7          	jalr	-1546(ra) # 80003998 <fileclose>
    fileclose(wf);
    80004faa:	fc843503          	ld	a0,-56(s0)
    80004fae:	fffff097          	auipc	ra,0xfffff
    80004fb2:	9ea080e7          	jalr	-1558(ra) # 80003998 <fileclose>
    return -1;
    80004fb6:	57fd                	li	a5,-1
    80004fb8:	a03d                	j	80004fe6 <sys_pipe+0x104>
    if(fd0 >= 0)
    80004fba:	fc442783          	lw	a5,-60(s0)
    80004fbe:	0007c763          	bltz	a5,80004fcc <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80004fc2:	07e9                	addi	a5,a5,26
    80004fc4:	078e                	slli	a5,a5,0x3
    80004fc6:	97a6                	add	a5,a5,s1
    80004fc8:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80004fcc:	fd043503          	ld	a0,-48(s0)
    80004fd0:	fffff097          	auipc	ra,0xfffff
    80004fd4:	9c8080e7          	jalr	-1592(ra) # 80003998 <fileclose>
    fileclose(wf);
    80004fd8:	fc843503          	ld	a0,-56(s0)
    80004fdc:	fffff097          	auipc	ra,0xfffff
    80004fe0:	9bc080e7          	jalr	-1604(ra) # 80003998 <fileclose>
    return -1;
    80004fe4:	57fd                	li	a5,-1
}
    80004fe6:	853e                	mv	a0,a5
    80004fe8:	70e2                	ld	ra,56(sp)
    80004fea:	7442                	ld	s0,48(sp)
    80004fec:	74a2                	ld	s1,40(sp)
    80004fee:	6121                	addi	sp,sp,64
    80004ff0:	8082                	ret

0000000080004ff2 <sys_connect>:


#ifdef LAB_NET
int
sys_connect(void)
{
    80004ff2:	7179                	addi	sp,sp,-48
    80004ff4:	f406                	sd	ra,40(sp)
    80004ff6:	f022                	sd	s0,32(sp)
    80004ff8:	1800                	addi	s0,sp,48
  int fd;
  uint32 raddr;
  uint32 rport;
  uint32 lport;

  if (argint(0, (int*)&raddr) < 0 ||
    80004ffa:	fe440593          	addi	a1,s0,-28
    80004ffe:	4501                	li	a0,0
    80005000:	ffffd097          	auipc	ra,0xffffd
    80005004:	f82080e7          	jalr	-126(ra) # 80001f82 <argint>
    80005008:	06054663          	bltz	a0,80005074 <sys_connect+0x82>
      argint(1, (int*)&lport) < 0 ||
    8000500c:	fdc40593          	addi	a1,s0,-36
    80005010:	4505                	li	a0,1
    80005012:	ffffd097          	auipc	ra,0xffffd
    80005016:	f70080e7          	jalr	-144(ra) # 80001f82 <argint>
  if (argint(0, (int*)&raddr) < 0 ||
    8000501a:	04054f63          	bltz	a0,80005078 <sys_connect+0x86>
      argint(2, (int*)&rport) < 0) {
    8000501e:	fe040593          	addi	a1,s0,-32
    80005022:	4509                	li	a0,2
    80005024:	ffffd097          	auipc	ra,0xffffd
    80005028:	f5e080e7          	jalr	-162(ra) # 80001f82 <argint>
      argint(1, (int*)&lport) < 0 ||
    8000502c:	04054863          	bltz	a0,8000507c <sys_connect+0x8a>
    return -1;
  }

  if(sockalloc(&f, raddr, lport, rport) < 0)
    80005030:	fe045683          	lhu	a3,-32(s0)
    80005034:	fdc45603          	lhu	a2,-36(s0)
    80005038:	fe442583          	lw	a1,-28(s0)
    8000503c:	fe840513          	addi	a0,s0,-24
    80005040:	00001097          	auipc	ra,0x1
    80005044:	1a2080e7          	jalr	418(ra) # 800061e2 <sockalloc>
    80005048:	02054c63          	bltz	a0,80005080 <sys_connect+0x8e>
    return -1;
  if((fd=fdalloc(f)) < 0){
    8000504c:	fe843503          	ld	a0,-24(s0)
    80005050:	fffff097          	auipc	ra,0xfffff
    80005054:	3dc080e7          	jalr	988(ra) # 8000442c <fdalloc>
    80005058:	00054663          	bltz	a0,80005064 <sys_connect+0x72>
    fileclose(f);
    return -1;
  }

  return fd;
}
    8000505c:	70a2                	ld	ra,40(sp)
    8000505e:	7402                	ld	s0,32(sp)
    80005060:	6145                	addi	sp,sp,48
    80005062:	8082                	ret
    fileclose(f);
    80005064:	fe843503          	ld	a0,-24(s0)
    80005068:	fffff097          	auipc	ra,0xfffff
    8000506c:	930080e7          	jalr	-1744(ra) # 80003998 <fileclose>
    return -1;
    80005070:	557d                	li	a0,-1
    80005072:	b7ed                	j	8000505c <sys_connect+0x6a>
    return -1;
    80005074:	557d                	li	a0,-1
    80005076:	b7dd                	j	8000505c <sys_connect+0x6a>
    80005078:	557d                	li	a0,-1
    8000507a:	b7cd                	j	8000505c <sys_connect+0x6a>
    8000507c:	557d                	li	a0,-1
    8000507e:	bff9                	j	8000505c <sys_connect+0x6a>
    return -1;
    80005080:	557d                	li	a0,-1
    80005082:	bfe9                	j	8000505c <sys_connect+0x6a>
	...

0000000080005090 <kernelvec>:
    80005090:	7111                	addi	sp,sp,-256
    80005092:	e006                	sd	ra,0(sp)
    80005094:	e40a                	sd	sp,8(sp)
    80005096:	e80e                	sd	gp,16(sp)
    80005098:	ec12                	sd	tp,24(sp)
    8000509a:	f016                	sd	t0,32(sp)
    8000509c:	f41a                	sd	t1,40(sp)
    8000509e:	f81e                	sd	t2,48(sp)
    800050a0:	fc22                	sd	s0,56(sp)
    800050a2:	e0a6                	sd	s1,64(sp)
    800050a4:	e4aa                	sd	a0,72(sp)
    800050a6:	e8ae                	sd	a1,80(sp)
    800050a8:	ecb2                	sd	a2,88(sp)
    800050aa:	f0b6                	sd	a3,96(sp)
    800050ac:	f4ba                	sd	a4,104(sp)
    800050ae:	f8be                	sd	a5,112(sp)
    800050b0:	fcc2                	sd	a6,120(sp)
    800050b2:	e146                	sd	a7,128(sp)
    800050b4:	e54a                	sd	s2,136(sp)
    800050b6:	e94e                	sd	s3,144(sp)
    800050b8:	ed52                	sd	s4,152(sp)
    800050ba:	f156                	sd	s5,160(sp)
    800050bc:	f55a                	sd	s6,168(sp)
    800050be:	f95e                	sd	s7,176(sp)
    800050c0:	fd62                	sd	s8,184(sp)
    800050c2:	e1e6                	sd	s9,192(sp)
    800050c4:	e5ea                	sd	s10,200(sp)
    800050c6:	e9ee                	sd	s11,208(sp)
    800050c8:	edf2                	sd	t3,216(sp)
    800050ca:	f1f6                	sd	t4,224(sp)
    800050cc:	f5fa                	sd	t5,232(sp)
    800050ce:	f9fe                	sd	t6,240(sp)
    800050d0:	ce5fc0ef          	jal	ra,80001db4 <kerneltrap>
    800050d4:	6082                	ld	ra,0(sp)
    800050d6:	6122                	ld	sp,8(sp)
    800050d8:	61c2                	ld	gp,16(sp)
    800050da:	7282                	ld	t0,32(sp)
    800050dc:	7322                	ld	t1,40(sp)
    800050de:	73c2                	ld	t2,48(sp)
    800050e0:	7462                	ld	s0,56(sp)
    800050e2:	6486                	ld	s1,64(sp)
    800050e4:	6526                	ld	a0,72(sp)
    800050e6:	65c6                	ld	a1,80(sp)
    800050e8:	6666                	ld	a2,88(sp)
    800050ea:	7686                	ld	a3,96(sp)
    800050ec:	7726                	ld	a4,104(sp)
    800050ee:	77c6                	ld	a5,112(sp)
    800050f0:	7866                	ld	a6,120(sp)
    800050f2:	688a                	ld	a7,128(sp)
    800050f4:	692a                	ld	s2,136(sp)
    800050f6:	69ca                	ld	s3,144(sp)
    800050f8:	6a6a                	ld	s4,152(sp)
    800050fa:	7a8a                	ld	s5,160(sp)
    800050fc:	7b2a                	ld	s6,168(sp)
    800050fe:	7bca                	ld	s7,176(sp)
    80005100:	7c6a                	ld	s8,184(sp)
    80005102:	6c8e                	ld	s9,192(sp)
    80005104:	6d2e                	ld	s10,200(sp)
    80005106:	6dce                	ld	s11,208(sp)
    80005108:	6e6e                	ld	t3,216(sp)
    8000510a:	7e8e                	ld	t4,224(sp)
    8000510c:	7f2e                	ld	t5,232(sp)
    8000510e:	7fce                	ld	t6,240(sp)
    80005110:	6111                	addi	sp,sp,256
    80005112:	10200073          	sret
    80005116:	00000013          	nop
    8000511a:	00000013          	nop
    8000511e:	0001                	nop

0000000080005120 <timervec>:
    80005120:	34051573          	csrrw	a0,mscratch,a0
    80005124:	e10c                	sd	a1,0(a0)
    80005126:	e510                	sd	a2,8(a0)
    80005128:	e914                	sd	a3,16(a0)
    8000512a:	6d0c                	ld	a1,24(a0)
    8000512c:	7110                	ld	a2,32(a0)
    8000512e:	6194                	ld	a3,0(a1)
    80005130:	96b2                	add	a3,a3,a2
    80005132:	e194                	sd	a3,0(a1)
    80005134:	4589                	li	a1,2
    80005136:	14459073          	csrw	sip,a1
    8000513a:	6914                	ld	a3,16(a0)
    8000513c:	6510                	ld	a2,8(a0)
    8000513e:	610c                	ld	a1,0(a0)
    80005140:	34051573          	csrrw	a0,mscratch,a0
    80005144:	30200073          	mret
	...

000000008000514a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000514a:	1141                	addi	sp,sp,-16
    8000514c:	e422                	sd	s0,8(sp)
    8000514e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005150:	0c0007b7          	lui	a5,0xc000
    80005154:	4705                	li	a4,1
    80005156:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005158:	c3d8                	sw	a4,4(a5)
    8000515a:	0791                	addi	a5,a5,4 # c000004 <_entry-0x73fffffc>
  
#ifdef LAB_NET
  // PCIE IRQs are 32 to 35
  for(int irq = 1; irq < 0x35; irq++){
    *(uint32*)(PLIC + irq*4) = 1;
    8000515c:	4685                	li	a3,1
  for(int irq = 1; irq < 0x35; irq++){
    8000515e:	0c000737          	lui	a4,0xc000
    80005162:	0d470713          	addi	a4,a4,212 # c0000d4 <_entry-0x73ffff2c>
    *(uint32*)(PLIC + irq*4) = 1;
    80005166:	c394                	sw	a3,0(a5)
  for(int irq = 1; irq < 0x35; irq++){
    80005168:	0791                	addi	a5,a5,4
    8000516a:	fee79ee3          	bne	a5,a4,80005166 <plicinit+0x1c>
  }
#endif  
}
    8000516e:	6422                	ld	s0,8(sp)
    80005170:	0141                	addi	sp,sp,16
    80005172:	8082                	ret

0000000080005174 <plicinithart>:

void
plicinithart(void)
{
    80005174:	1141                	addi	sp,sp,-16
    80005176:	e406                	sd	ra,8(sp)
    80005178:	e022                	sd	s0,0(sp)
    8000517a:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000517c:	ffffc097          	auipc	ra,0xffffc
    80005180:	cf4080e7          	jalr	-780(ra) # 80000e70 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005184:	0085171b          	slliw	a4,a0,0x8
    80005188:	0c0027b7          	lui	a5,0xc002
    8000518c:	97ba                	add	a5,a5,a4
    8000518e:	40200713          	li	a4,1026
    80005192:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

#ifdef LAB_NET
  // hack to get at next 32 IRQs for e1000
  *(uint32*)(PLIC_SENABLE(hart)+4) = 0xffffffff;
    80005196:	577d                	li	a4,-1
    80005198:	08e7a223          	sw	a4,132(a5)
#endif
  
  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    8000519c:	00d5151b          	slliw	a0,a0,0xd
    800051a0:	0c2017b7          	lui	a5,0xc201
    800051a4:	97aa                	add	a5,a5,a0
    800051a6:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800051aa:	60a2                	ld	ra,8(sp)
    800051ac:	6402                	ld	s0,0(sp)
    800051ae:	0141                	addi	sp,sp,16
    800051b0:	8082                	ret

00000000800051b2 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800051b2:	1141                	addi	sp,sp,-16
    800051b4:	e406                	sd	ra,8(sp)
    800051b6:	e022                	sd	s0,0(sp)
    800051b8:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800051ba:	ffffc097          	auipc	ra,0xffffc
    800051be:	cb6080e7          	jalr	-842(ra) # 80000e70 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800051c2:	00d5151b          	slliw	a0,a0,0xd
    800051c6:	0c2017b7          	lui	a5,0xc201
    800051ca:	97aa                	add	a5,a5,a0
  return irq;
}
    800051cc:	43c8                	lw	a0,4(a5)
    800051ce:	60a2                	ld	ra,8(sp)
    800051d0:	6402                	ld	s0,0(sp)
    800051d2:	0141                	addi	sp,sp,16
    800051d4:	8082                	ret

00000000800051d6 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800051d6:	1101                	addi	sp,sp,-32
    800051d8:	ec06                	sd	ra,24(sp)
    800051da:	e822                	sd	s0,16(sp)
    800051dc:	e426                	sd	s1,8(sp)
    800051de:	1000                	addi	s0,sp,32
    800051e0:	84aa                	mv	s1,a0
  int hart = cpuid();
    800051e2:	ffffc097          	auipc	ra,0xffffc
    800051e6:	c8e080e7          	jalr	-882(ra) # 80000e70 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800051ea:	00d5151b          	slliw	a0,a0,0xd
    800051ee:	0c2017b7          	lui	a5,0xc201
    800051f2:	97aa                	add	a5,a5,a0
    800051f4:	c3c4                	sw	s1,4(a5)
}
    800051f6:	60e2                	ld	ra,24(sp)
    800051f8:	6442                	ld	s0,16(sp)
    800051fa:	64a2                	ld	s1,8(sp)
    800051fc:	6105                	addi	sp,sp,32
    800051fe:	8082                	ret

0000000080005200 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005200:	1141                	addi	sp,sp,-16
    80005202:	e406                	sd	ra,8(sp)
    80005204:	e022                	sd	s0,0(sp)
    80005206:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005208:	479d                	li	a5,7
    8000520a:	06a7c863          	blt	a5,a0,8000527a <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    8000520e:	00017717          	auipc	a4,0x17
    80005212:	df270713          	addi	a4,a4,-526 # 8001c000 <disk>
    80005216:	972a                	add	a4,a4,a0
    80005218:	6789                	lui	a5,0x2
    8000521a:	97ba                	add	a5,a5,a4
    8000521c:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005220:	e7ad                	bnez	a5,8000528a <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005222:	00451793          	slli	a5,a0,0x4
    80005226:	00019717          	auipc	a4,0x19
    8000522a:	dda70713          	addi	a4,a4,-550 # 8001e000 <disk+0x2000>
    8000522e:	6314                	ld	a3,0(a4)
    80005230:	96be                	add	a3,a3,a5
    80005232:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005236:	6314                	ld	a3,0(a4)
    80005238:	96be                	add	a3,a3,a5
    8000523a:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    8000523e:	6314                	ld	a3,0(a4)
    80005240:	96be                	add	a3,a3,a5
    80005242:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    80005246:	6318                	ld	a4,0(a4)
    80005248:	97ba                	add	a5,a5,a4
    8000524a:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    8000524e:	00017717          	auipc	a4,0x17
    80005252:	db270713          	addi	a4,a4,-590 # 8001c000 <disk>
    80005256:	972a                	add	a4,a4,a0
    80005258:	6789                	lui	a5,0x2
    8000525a:	97ba                	add	a5,a5,a4
    8000525c:	4705                	li	a4,1
    8000525e:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    80005262:	00019517          	auipc	a0,0x19
    80005266:	db650513          	addi	a0,a0,-586 # 8001e018 <disk+0x2018>
    8000526a:	ffffc097          	auipc	ra,0xffffc
    8000526e:	482080e7          	jalr	1154(ra) # 800016ec <wakeup>
}
    80005272:	60a2                	ld	ra,8(sp)
    80005274:	6402                	ld	s0,0(sp)
    80005276:	0141                	addi	sp,sp,16
    80005278:	8082                	ret
    panic("free_desc 1");
    8000527a:	00004517          	auipc	a0,0x4
    8000527e:	4be50513          	addi	a0,a0,1214 # 80009738 <syscalls+0x360>
    80005282:	00002097          	auipc	ra,0x2
    80005286:	8ee080e7          	jalr	-1810(ra) # 80006b70 <panic>
    panic("free_desc 2");
    8000528a:	00004517          	auipc	a0,0x4
    8000528e:	4be50513          	addi	a0,a0,1214 # 80009748 <syscalls+0x370>
    80005292:	00002097          	auipc	ra,0x2
    80005296:	8de080e7          	jalr	-1826(ra) # 80006b70 <panic>

000000008000529a <virtio_disk_init>:
{
    8000529a:	1101                	addi	sp,sp,-32
    8000529c:	ec06                	sd	ra,24(sp)
    8000529e:	e822                	sd	s0,16(sp)
    800052a0:	e426                	sd	s1,8(sp)
    800052a2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800052a4:	00004597          	auipc	a1,0x4
    800052a8:	4b458593          	addi	a1,a1,1204 # 80009758 <syscalls+0x380>
    800052ac:	00019517          	auipc	a0,0x19
    800052b0:	e7c50513          	addi	a0,a0,-388 # 8001e128 <disk+0x2128>
    800052b4:	00002097          	auipc	ra,0x2
    800052b8:	d64080e7          	jalr	-668(ra) # 80007018 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052bc:	100017b7          	lui	a5,0x10001
    800052c0:	4398                	lw	a4,0(a5)
    800052c2:	2701                	sext.w	a4,a4
    800052c4:	747277b7          	lui	a5,0x74727
    800052c8:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800052cc:	0ef71063          	bne	a4,a5,800053ac <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800052d0:	100017b7          	lui	a5,0x10001
    800052d4:	43dc                	lw	a5,4(a5)
    800052d6:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052d8:	4705                	li	a4,1
    800052da:	0ce79963          	bne	a5,a4,800053ac <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052de:	100017b7          	lui	a5,0x10001
    800052e2:	479c                	lw	a5,8(a5)
    800052e4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800052e6:	4709                	li	a4,2
    800052e8:	0ce79263          	bne	a5,a4,800053ac <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800052ec:	100017b7          	lui	a5,0x10001
    800052f0:	47d8                	lw	a4,12(a5)
    800052f2:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052f4:	554d47b7          	lui	a5,0x554d4
    800052f8:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800052fc:	0af71863          	bne	a4,a5,800053ac <virtio_disk_init+0x112>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005300:	100017b7          	lui	a5,0x10001
    80005304:	4705                	li	a4,1
    80005306:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005308:	470d                	li	a4,3
    8000530a:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000530c:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000530e:	c7ffe6b7          	lui	a3,0xc7ffe
    80005312:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fd71df>
    80005316:	8f75                	and	a4,a4,a3
    80005318:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000531a:	472d                	li	a4,11
    8000531c:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000531e:	473d                	li	a4,15
    80005320:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005322:	6705                	lui	a4,0x1
    80005324:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005326:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000532a:	5bdc                	lw	a5,52(a5)
    8000532c:	2781                	sext.w	a5,a5
  if(max == 0)
    8000532e:	c7d9                	beqz	a5,800053bc <virtio_disk_init+0x122>
  if(max < NUM)
    80005330:	471d                	li	a4,7
    80005332:	08f77d63          	bgeu	a4,a5,800053cc <virtio_disk_init+0x132>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005336:	100014b7          	lui	s1,0x10001
    8000533a:	47a1                	li	a5,8
    8000533c:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    8000533e:	6609                	lui	a2,0x2
    80005340:	4581                	li	a1,0
    80005342:	00017517          	auipc	a0,0x17
    80005346:	cbe50513          	addi	a0,a0,-834 # 8001c000 <disk>
    8000534a:	ffffb097          	auipc	ra,0xffffb
    8000534e:	e30080e7          	jalr	-464(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005352:	00017717          	auipc	a4,0x17
    80005356:	cae70713          	addi	a4,a4,-850 # 8001c000 <disk>
    8000535a:	00c75793          	srli	a5,a4,0xc
    8000535e:	2781                	sext.w	a5,a5
    80005360:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    80005362:	00019797          	auipc	a5,0x19
    80005366:	c9e78793          	addi	a5,a5,-866 # 8001e000 <disk+0x2000>
    8000536a:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    8000536c:	00017717          	auipc	a4,0x17
    80005370:	d1470713          	addi	a4,a4,-748 # 8001c080 <disk+0x80>
    80005374:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80005376:	00018717          	auipc	a4,0x18
    8000537a:	c8a70713          	addi	a4,a4,-886 # 8001d000 <disk+0x1000>
    8000537e:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005380:	4705                	li	a4,1
    80005382:	00e78c23          	sb	a4,24(a5)
    80005386:	00e78ca3          	sb	a4,25(a5)
    8000538a:	00e78d23          	sb	a4,26(a5)
    8000538e:	00e78da3          	sb	a4,27(a5)
    80005392:	00e78e23          	sb	a4,28(a5)
    80005396:	00e78ea3          	sb	a4,29(a5)
    8000539a:	00e78f23          	sb	a4,30(a5)
    8000539e:	00e78fa3          	sb	a4,31(a5)
}
    800053a2:	60e2                	ld	ra,24(sp)
    800053a4:	6442                	ld	s0,16(sp)
    800053a6:	64a2                	ld	s1,8(sp)
    800053a8:	6105                	addi	sp,sp,32
    800053aa:	8082                	ret
    panic("could not find virtio disk");
    800053ac:	00004517          	auipc	a0,0x4
    800053b0:	3bc50513          	addi	a0,a0,956 # 80009768 <syscalls+0x390>
    800053b4:	00001097          	auipc	ra,0x1
    800053b8:	7bc080e7          	jalr	1980(ra) # 80006b70 <panic>
    panic("virtio disk has no queue 0");
    800053bc:	00004517          	auipc	a0,0x4
    800053c0:	3cc50513          	addi	a0,a0,972 # 80009788 <syscalls+0x3b0>
    800053c4:	00001097          	auipc	ra,0x1
    800053c8:	7ac080e7          	jalr	1964(ra) # 80006b70 <panic>
    panic("virtio disk max queue too short");
    800053cc:	00004517          	auipc	a0,0x4
    800053d0:	3dc50513          	addi	a0,a0,988 # 800097a8 <syscalls+0x3d0>
    800053d4:	00001097          	auipc	ra,0x1
    800053d8:	79c080e7          	jalr	1948(ra) # 80006b70 <panic>

00000000800053dc <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800053dc:	7119                	addi	sp,sp,-128
    800053de:	fc86                	sd	ra,120(sp)
    800053e0:	f8a2                	sd	s0,112(sp)
    800053e2:	f4a6                	sd	s1,104(sp)
    800053e4:	f0ca                	sd	s2,96(sp)
    800053e6:	ecce                	sd	s3,88(sp)
    800053e8:	e8d2                	sd	s4,80(sp)
    800053ea:	e4d6                	sd	s5,72(sp)
    800053ec:	e0da                	sd	s6,64(sp)
    800053ee:	fc5e                	sd	s7,56(sp)
    800053f0:	f862                	sd	s8,48(sp)
    800053f2:	f466                	sd	s9,40(sp)
    800053f4:	f06a                	sd	s10,32(sp)
    800053f6:	ec6e                	sd	s11,24(sp)
    800053f8:	0100                	addi	s0,sp,128
    800053fa:	8aaa                	mv	s5,a0
    800053fc:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800053fe:	00c52c83          	lw	s9,12(a0)
    80005402:	001c9c9b          	slliw	s9,s9,0x1
    80005406:	1c82                	slli	s9,s9,0x20
    80005408:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    8000540c:	00019517          	auipc	a0,0x19
    80005410:	d1c50513          	addi	a0,a0,-740 # 8001e128 <disk+0x2128>
    80005414:	00002097          	auipc	ra,0x2
    80005418:	c94080e7          	jalr	-876(ra) # 800070a8 <acquire>
  for(int i = 0; i < 3; i++){
    8000541c:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    8000541e:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005420:	00017c17          	auipc	s8,0x17
    80005424:	be0c0c13          	addi	s8,s8,-1056 # 8001c000 <disk>
    80005428:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    8000542a:	4b0d                	li	s6,3
    8000542c:	a0ad                	j	80005496 <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    8000542e:	00fc0733          	add	a4,s8,a5
    80005432:	975e                	add	a4,a4,s7
    80005434:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005438:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    8000543a:	0207c563          	bltz	a5,80005464 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    8000543e:	2905                	addiw	s2,s2,1
    80005440:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    80005442:	19690c63          	beq	s2,s6,800055da <virtio_disk_rw+0x1fe>
    idx[i] = alloc_desc();
    80005446:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005448:	00019717          	auipc	a4,0x19
    8000544c:	bd070713          	addi	a4,a4,-1072 # 8001e018 <disk+0x2018>
    80005450:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005452:	00074683          	lbu	a3,0(a4)
    80005456:	fee1                	bnez	a3,8000542e <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005458:	2785                	addiw	a5,a5,1
    8000545a:	0705                	addi	a4,a4,1
    8000545c:	fe979be3          	bne	a5,s1,80005452 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    80005460:	57fd                	li	a5,-1
    80005462:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005464:	01205d63          	blez	s2,8000547e <virtio_disk_rw+0xa2>
    80005468:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    8000546a:	000a2503          	lw	a0,0(s4)
    8000546e:	00000097          	auipc	ra,0x0
    80005472:	d92080e7          	jalr	-622(ra) # 80005200 <free_desc>
      for(int j = 0; j < i; j++)
    80005476:	2d85                	addiw	s11,s11,1
    80005478:	0a11                	addi	s4,s4,4
    8000547a:	ff2d98e3          	bne	s11,s2,8000546a <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000547e:	00019597          	auipc	a1,0x19
    80005482:	caa58593          	addi	a1,a1,-854 # 8001e128 <disk+0x2128>
    80005486:	00019517          	auipc	a0,0x19
    8000548a:	b9250513          	addi	a0,a0,-1134 # 8001e018 <disk+0x2018>
    8000548e:	ffffc097          	auipc	ra,0xffffc
    80005492:	0d2080e7          	jalr	210(ra) # 80001560 <sleep>
  for(int i = 0; i < 3; i++){
    80005496:	f8040a13          	addi	s4,s0,-128
{
    8000549a:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    8000549c:	894e                	mv	s2,s3
    8000549e:	b765                	j	80005446 <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800054a0:	00019697          	auipc	a3,0x19
    800054a4:	b606b683          	ld	a3,-1184(a3) # 8001e000 <disk+0x2000>
    800054a8:	96ba                	add	a3,a3,a4
    800054aa:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800054ae:	00017817          	auipc	a6,0x17
    800054b2:	b5280813          	addi	a6,a6,-1198 # 8001c000 <disk>
    800054b6:	00019697          	auipc	a3,0x19
    800054ba:	b4a68693          	addi	a3,a3,-1206 # 8001e000 <disk+0x2000>
    800054be:	6290                	ld	a2,0(a3)
    800054c0:	963a                	add	a2,a2,a4
    800054c2:	00c65583          	lhu	a1,12(a2)
    800054c6:	0015e593          	ori	a1,a1,1
    800054ca:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    800054ce:	f8842603          	lw	a2,-120(s0)
    800054d2:	628c                	ld	a1,0(a3)
    800054d4:	972e                	add	a4,a4,a1
    800054d6:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800054da:	20050593          	addi	a1,a0,512
    800054de:	0592                	slli	a1,a1,0x4
    800054e0:	95c2                	add	a1,a1,a6
    800054e2:	577d                	li	a4,-1
    800054e4:	02e58823          	sb	a4,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800054e8:	00461713          	slli	a4,a2,0x4
    800054ec:	6290                	ld	a2,0(a3)
    800054ee:	963a                	add	a2,a2,a4
    800054f0:	03078793          	addi	a5,a5,48
    800054f4:	97c2                	add	a5,a5,a6
    800054f6:	e21c                	sd	a5,0(a2)
  disk.desc[idx[2]].len = 1;
    800054f8:	629c                	ld	a5,0(a3)
    800054fa:	97ba                	add	a5,a5,a4
    800054fc:	4605                	li	a2,1
    800054fe:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005500:	629c                	ld	a5,0(a3)
    80005502:	97ba                	add	a5,a5,a4
    80005504:	4809                	li	a6,2
    80005506:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    8000550a:	629c                	ld	a5,0(a3)
    8000550c:	97ba                	add	a5,a5,a4
    8000550e:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005512:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    80005516:	0355b423          	sd	s5,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000551a:	6698                	ld	a4,8(a3)
    8000551c:	00275783          	lhu	a5,2(a4)
    80005520:	8b9d                	andi	a5,a5,7
    80005522:	0786                	slli	a5,a5,0x1
    80005524:	973e                	add	a4,a4,a5
    80005526:	00a71223          	sh	a0,4(a4)

  __sync_synchronize();
    8000552a:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000552e:	6698                	ld	a4,8(a3)
    80005530:	00275783          	lhu	a5,2(a4)
    80005534:	2785                	addiw	a5,a5,1
    80005536:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    8000553a:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000553e:	100017b7          	lui	a5,0x10001
    80005542:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005546:	004aa783          	lw	a5,4(s5)
    8000554a:	02c79163          	bne	a5,a2,8000556c <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    8000554e:	00019917          	auipc	s2,0x19
    80005552:	bda90913          	addi	s2,s2,-1062 # 8001e128 <disk+0x2128>
  while(b->disk == 1) {
    80005556:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005558:	85ca                	mv	a1,s2
    8000555a:	8556                	mv	a0,s5
    8000555c:	ffffc097          	auipc	ra,0xffffc
    80005560:	004080e7          	jalr	4(ra) # 80001560 <sleep>
  while(b->disk == 1) {
    80005564:	004aa783          	lw	a5,4(s5)
    80005568:	fe9788e3          	beq	a5,s1,80005558 <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    8000556c:	f8042903          	lw	s2,-128(s0)
    80005570:	20090713          	addi	a4,s2,512
    80005574:	0712                	slli	a4,a4,0x4
    80005576:	00017797          	auipc	a5,0x17
    8000557a:	a8a78793          	addi	a5,a5,-1398 # 8001c000 <disk>
    8000557e:	97ba                	add	a5,a5,a4
    80005580:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005584:	00019997          	auipc	s3,0x19
    80005588:	a7c98993          	addi	s3,s3,-1412 # 8001e000 <disk+0x2000>
    8000558c:	00491713          	slli	a4,s2,0x4
    80005590:	0009b783          	ld	a5,0(s3)
    80005594:	97ba                	add	a5,a5,a4
    80005596:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000559a:	854a                	mv	a0,s2
    8000559c:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800055a0:	00000097          	auipc	ra,0x0
    800055a4:	c60080e7          	jalr	-928(ra) # 80005200 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800055a8:	8885                	andi	s1,s1,1
    800055aa:	f0ed                	bnez	s1,8000558c <virtio_disk_rw+0x1b0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800055ac:	00019517          	auipc	a0,0x19
    800055b0:	b7c50513          	addi	a0,a0,-1156 # 8001e128 <disk+0x2128>
    800055b4:	00002097          	auipc	ra,0x2
    800055b8:	ba8080e7          	jalr	-1112(ra) # 8000715c <release>
}
    800055bc:	70e6                	ld	ra,120(sp)
    800055be:	7446                	ld	s0,112(sp)
    800055c0:	74a6                	ld	s1,104(sp)
    800055c2:	7906                	ld	s2,96(sp)
    800055c4:	69e6                	ld	s3,88(sp)
    800055c6:	6a46                	ld	s4,80(sp)
    800055c8:	6aa6                	ld	s5,72(sp)
    800055ca:	6b06                	ld	s6,64(sp)
    800055cc:	7be2                	ld	s7,56(sp)
    800055ce:	7c42                	ld	s8,48(sp)
    800055d0:	7ca2                	ld	s9,40(sp)
    800055d2:	7d02                	ld	s10,32(sp)
    800055d4:	6de2                	ld	s11,24(sp)
    800055d6:	6109                	addi	sp,sp,128
    800055d8:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800055da:	f8042503          	lw	a0,-128(s0)
    800055de:	20050793          	addi	a5,a0,512
    800055e2:	0792                	slli	a5,a5,0x4
  if(write)
    800055e4:	00017817          	auipc	a6,0x17
    800055e8:	a1c80813          	addi	a6,a6,-1508 # 8001c000 <disk>
    800055ec:	00f80733          	add	a4,a6,a5
    800055f0:	01a036b3          	snez	a3,s10
    800055f4:	0ad72423          	sw	a3,168(a4)
  buf0->reserved = 0;
    800055f8:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    800055fc:	0b973823          	sd	s9,176(a4)
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005600:	7679                	lui	a2,0xffffe
    80005602:	963e                	add	a2,a2,a5
    80005604:	00019697          	auipc	a3,0x19
    80005608:	9fc68693          	addi	a3,a3,-1540 # 8001e000 <disk+0x2000>
    8000560c:	6298                	ld	a4,0(a3)
    8000560e:	9732                	add	a4,a4,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005610:	0a878593          	addi	a1,a5,168
    80005614:	95c2                	add	a1,a1,a6
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005616:	e30c                	sd	a1,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005618:	6298                	ld	a4,0(a3)
    8000561a:	9732                	add	a4,a4,a2
    8000561c:	45c1                	li	a1,16
    8000561e:	c70c                	sw	a1,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005620:	6298                	ld	a4,0(a3)
    80005622:	9732                	add	a4,a4,a2
    80005624:	4585                	li	a1,1
    80005626:	00b71623          	sh	a1,12(a4)
  disk.desc[idx[0]].next = idx[1];
    8000562a:	f8442703          	lw	a4,-124(s0)
    8000562e:	628c                	ld	a1,0(a3)
    80005630:	962e                	add	a2,a2,a1
    80005632:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd6a8e>
  disk.desc[idx[1]].addr = (uint64) b->data;
    80005636:	0712                	slli	a4,a4,0x4
    80005638:	6290                	ld	a2,0(a3)
    8000563a:	963a                	add	a2,a2,a4
    8000563c:	058a8593          	addi	a1,s5,88
    80005640:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005642:	6294                	ld	a3,0(a3)
    80005644:	96ba                	add	a3,a3,a4
    80005646:	40000613          	li	a2,1024
    8000564a:	c690                	sw	a2,8(a3)
  if(write)
    8000564c:	e40d1ae3          	bnez	s10,800054a0 <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80005650:	00019697          	auipc	a3,0x19
    80005654:	9b06b683          	ld	a3,-1616(a3) # 8001e000 <disk+0x2000>
    80005658:	96ba                	add	a3,a3,a4
    8000565a:	4609                	li	a2,2
    8000565c:	00c69623          	sh	a2,12(a3)
    80005660:	b5b9                	j	800054ae <virtio_disk_rw+0xd2>

0000000080005662 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005662:	1101                	addi	sp,sp,-32
    80005664:	ec06                	sd	ra,24(sp)
    80005666:	e822                	sd	s0,16(sp)
    80005668:	e426                	sd	s1,8(sp)
    8000566a:	e04a                	sd	s2,0(sp)
    8000566c:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000566e:	00019517          	auipc	a0,0x19
    80005672:	aba50513          	addi	a0,a0,-1350 # 8001e128 <disk+0x2128>
    80005676:	00002097          	auipc	ra,0x2
    8000567a:	a32080e7          	jalr	-1486(ra) # 800070a8 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    8000567e:	10001737          	lui	a4,0x10001
    80005682:	533c                	lw	a5,96(a4)
    80005684:	8b8d                	andi	a5,a5,3
    80005686:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005688:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    8000568c:	00019797          	auipc	a5,0x19
    80005690:	97478793          	addi	a5,a5,-1676 # 8001e000 <disk+0x2000>
    80005694:	6b94                	ld	a3,16(a5)
    80005696:	0207d703          	lhu	a4,32(a5)
    8000569a:	0026d783          	lhu	a5,2(a3)
    8000569e:	06f70163          	beq	a4,a5,80005700 <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800056a2:	00017917          	auipc	s2,0x17
    800056a6:	95e90913          	addi	s2,s2,-1698 # 8001c000 <disk>
    800056aa:	00019497          	auipc	s1,0x19
    800056ae:	95648493          	addi	s1,s1,-1706 # 8001e000 <disk+0x2000>
    __sync_synchronize();
    800056b2:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800056b6:	6898                	ld	a4,16(s1)
    800056b8:	0204d783          	lhu	a5,32(s1)
    800056bc:	8b9d                	andi	a5,a5,7
    800056be:	078e                	slli	a5,a5,0x3
    800056c0:	97ba                	add	a5,a5,a4
    800056c2:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800056c4:	20078713          	addi	a4,a5,512
    800056c8:	0712                	slli	a4,a4,0x4
    800056ca:	974a                	add	a4,a4,s2
    800056cc:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    800056d0:	e731                	bnez	a4,8000571c <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800056d2:	20078793          	addi	a5,a5,512
    800056d6:	0792                	slli	a5,a5,0x4
    800056d8:	97ca                	add	a5,a5,s2
    800056da:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    800056dc:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800056e0:	ffffc097          	auipc	ra,0xffffc
    800056e4:	00c080e7          	jalr	12(ra) # 800016ec <wakeup>

    disk.used_idx += 1;
    800056e8:	0204d783          	lhu	a5,32(s1)
    800056ec:	2785                	addiw	a5,a5,1
    800056ee:	17c2                	slli	a5,a5,0x30
    800056f0:	93c1                	srli	a5,a5,0x30
    800056f2:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800056f6:	6898                	ld	a4,16(s1)
    800056f8:	00275703          	lhu	a4,2(a4)
    800056fc:	faf71be3          	bne	a4,a5,800056b2 <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    80005700:	00019517          	auipc	a0,0x19
    80005704:	a2850513          	addi	a0,a0,-1496 # 8001e128 <disk+0x2128>
    80005708:	00002097          	auipc	ra,0x2
    8000570c:	a54080e7          	jalr	-1452(ra) # 8000715c <release>
}
    80005710:	60e2                	ld	ra,24(sp)
    80005712:	6442                	ld	s0,16(sp)
    80005714:	64a2                	ld	s1,8(sp)
    80005716:	6902                	ld	s2,0(sp)
    80005718:	6105                	addi	sp,sp,32
    8000571a:	8082                	ret
      panic("virtio_disk_intr status");
    8000571c:	00004517          	auipc	a0,0x4
    80005720:	0ac50513          	addi	a0,a0,172 # 800097c8 <syscalls+0x3f0>
    80005724:	00001097          	auipc	ra,0x1
    80005728:	44c080e7          	jalr	1100(ra) # 80006b70 <panic>

000000008000572c <e1000_init>:

// called by pci_init().
// xregs is the memory address at which the
// e1000's registers are mapped.
void e1000_init(uint32 *xregs)
{
    8000572c:	7179                	addi	sp,sp,-48
    8000572e:	f406                	sd	ra,40(sp)
    80005730:	f022                	sd	s0,32(sp)
    80005732:	ec26                	sd	s1,24(sp)
    80005734:	e84a                	sd	s2,16(sp)
    80005736:	e44e                	sd	s3,8(sp)
    80005738:	1800                	addi	s0,sp,48
    8000573a:	84aa                	mv	s1,a0
  int i;

  initlock(&e1000_lock, "e1000");
    8000573c:	00004597          	auipc	a1,0x4
    80005740:	0a458593          	addi	a1,a1,164 # 800097e0 <syscalls+0x408>
    80005744:	0001a517          	auipc	a0,0x1a
    80005748:	8bc50513          	addi	a0,a0,-1860 # 8001f000 <e1000_lock>
    8000574c:	00002097          	auipc	ra,0x2
    80005750:	8cc080e7          	jalr	-1844(ra) # 80007018 <initlock>

  regs = xregs;
    80005754:	00005797          	auipc	a5,0x5
    80005758:	8c97b623          	sd	s1,-1844(a5) # 8000a020 <regs>

  // Reset the device
  regs[E1000_IMS] = 0; // disable interrupts
    8000575c:	0c04a823          	sw	zero,208(s1)
  regs[E1000_CTL] |= E1000_CTL_RST;
    80005760:	409c                	lw	a5,0(s1)
    80005762:	00400737          	lui	a4,0x400
    80005766:	8fd9                	or	a5,a5,a4
    80005768:	c09c                	sw	a5,0(s1)
  regs[E1000_IMS] = 0; // redisable interrupts
    8000576a:	0c04a823          	sw	zero,208(s1)
  __sync_synchronize();
    8000576e:	0ff0000f          	fence

  // [E1000 14.5] Transmit initialization
  memset(tx_ring, 0, sizeof(tx_ring));
    80005772:	10000613          	li	a2,256
    80005776:	4581                	li	a1,0
    80005778:	0001a517          	auipc	a0,0x1a
    8000577c:	8a850513          	addi	a0,a0,-1880 # 8001f020 <tx_ring>
    80005780:	ffffb097          	auipc	ra,0xffffb
    80005784:	9fa080e7          	jalr	-1542(ra) # 8000017a <memset>
  for (i = 0; i < TX_RING_SIZE; i++)
    80005788:	0001a717          	auipc	a4,0x1a
    8000578c:	8a470713          	addi	a4,a4,-1884 # 8001f02c <tx_ring+0xc>
    80005790:	0001a797          	auipc	a5,0x1a
    80005794:	99078793          	addi	a5,a5,-1648 # 8001f120 <tx_mbufs>
    80005798:	0001a617          	auipc	a2,0x1a
    8000579c:	a0860613          	addi	a2,a2,-1528 # 8001f1a0 <rx_ring>
  {
    tx_ring[i].status = E1000_TXD_STAT_DD;
    800057a0:	4685                	li	a3,1
    800057a2:	00d70023          	sb	a3,0(a4)
    tx_mbufs[i] = 0;
    800057a6:	0007b023          	sd	zero,0(a5)
  for (i = 0; i < TX_RING_SIZE; i++)
    800057aa:	0741                	addi	a4,a4,16
    800057ac:	07a1                	addi	a5,a5,8
    800057ae:	fec79ae3          	bne	a5,a2,800057a2 <e1000_init+0x76>
  }
  regs[E1000_TDBAL] = (uint64)tx_ring;
    800057b2:	0001a717          	auipc	a4,0x1a
    800057b6:	86e70713          	addi	a4,a4,-1938 # 8001f020 <tx_ring>
    800057ba:	00005797          	auipc	a5,0x5
    800057be:	8667b783          	ld	a5,-1946(a5) # 8000a020 <regs>
    800057c2:	6691                	lui	a3,0x4
    800057c4:	97b6                	add	a5,a5,a3
    800057c6:	80e7a023          	sw	a4,-2048(a5)
  if (sizeof(tx_ring) % 128 != 0)
    panic("e1000");
  regs[E1000_TDLEN] = sizeof(tx_ring);
    800057ca:	10000713          	li	a4,256
    800057ce:	80e7a423          	sw	a4,-2040(a5)
  regs[E1000_TDH] = regs[E1000_TDT] = 0;
    800057d2:	8007ac23          	sw	zero,-2024(a5)
    800057d6:	8007a823          	sw	zero,-2032(a5)

  // [E1000 14.4] Receive initialization
  memset(rx_ring, 0, sizeof(rx_ring));
    800057da:	0001a917          	auipc	s2,0x1a
    800057de:	9c690913          	addi	s2,s2,-1594 # 8001f1a0 <rx_ring>
    800057e2:	10000613          	li	a2,256
    800057e6:	4581                	li	a1,0
    800057e8:	854a                	mv	a0,s2
    800057ea:	ffffb097          	auipc	ra,0xffffb
    800057ee:	990080e7          	jalr	-1648(ra) # 8000017a <memset>
  for (i = 0; i < RX_RING_SIZE; i++)
    800057f2:	0001a497          	auipc	s1,0x1a
    800057f6:	aae48493          	addi	s1,s1,-1362 # 8001f2a0 <rx_mbufs>
    800057fa:	0001a997          	auipc	s3,0x1a
    800057fe:	b2698993          	addi	s3,s3,-1242 # 8001f320 <lock>
  {
    rx_mbufs[i] = mbufalloc(0);
    80005802:	4501                	li	a0,0
    80005804:	00000097          	auipc	ra,0x0
    80005808:	412080e7          	jalr	1042(ra) # 80005c16 <mbufalloc>
    8000580c:	e088                	sd	a0,0(s1)
    if (!rx_mbufs[i])
    8000580e:	c945                	beqz	a0,800058be <e1000_init+0x192>
      panic("e1000");
    rx_ring[i].addr = (uint64)rx_mbufs[i]->head;
    80005810:	651c                	ld	a5,8(a0)
    80005812:	00f93023          	sd	a5,0(s2)
  for (i = 0; i < RX_RING_SIZE; i++)
    80005816:	04a1                	addi	s1,s1,8
    80005818:	0941                	addi	s2,s2,16
    8000581a:	ff3494e3          	bne	s1,s3,80005802 <e1000_init+0xd6>
  }
  regs[E1000_RDBAL] = (uint64)rx_ring;
    8000581e:	00005697          	auipc	a3,0x5
    80005822:	8026b683          	ld	a3,-2046(a3) # 8000a020 <regs>
    80005826:	0001a717          	auipc	a4,0x1a
    8000582a:	97a70713          	addi	a4,a4,-1670 # 8001f1a0 <rx_ring>
    8000582e:	678d                	lui	a5,0x3
    80005830:	97b6                	add	a5,a5,a3
    80005832:	80e7a023          	sw	a4,-2048(a5) # 2800 <_entry-0x7fffd800>
  if (sizeof(rx_ring) % 128 != 0)
    panic("e1000");
  regs[E1000_RDH] = 0;
    80005836:	8007a823          	sw	zero,-2032(a5)
  regs[E1000_RDT] = RX_RING_SIZE - 1;
    8000583a:	473d                	li	a4,15
    8000583c:	80e7ac23          	sw	a4,-2024(a5)
  regs[E1000_RDLEN] = sizeof(rx_ring);
    80005840:	10000713          	li	a4,256
    80005844:	80e7a423          	sw	a4,-2040(a5)

  // filter by qemu's MAC address, 52:54:00:12:34:56
  regs[E1000_RA] = 0x12005452;
    80005848:	6715                	lui	a4,0x5
    8000584a:	00e68633          	add	a2,a3,a4
    8000584e:	120057b7          	lui	a5,0x12005
    80005852:	45278793          	addi	a5,a5,1106 # 12005452 <_entry-0x6dffabae>
    80005856:	40f62023          	sw	a5,1024(a2)
  regs[E1000_RA + 1] = 0x5634 | (1 << 31);
    8000585a:	800057b7          	lui	a5,0x80005
    8000585e:	63478793          	addi	a5,a5,1588 # ffffffff80005634 <end+0xfffffffefffde0b4>
    80005862:	40f62223          	sw	a5,1028(a2)
  // multicast table
  for (int i = 0; i < 4096 / 32; i++)
    80005866:	20070793          	addi	a5,a4,512 # 5200 <_entry-0x7fffae00>
    8000586a:	97b6                	add	a5,a5,a3
    8000586c:	40070713          	addi	a4,a4,1024
    80005870:	9736                	add	a4,a4,a3
    regs[E1000_MTA + i] = 0;
    80005872:	0007a023          	sw	zero,0(a5)
  for (int i = 0; i < 4096 / 32; i++)
    80005876:	0791                	addi	a5,a5,4
    80005878:	fee79de3          	bne	a5,a4,80005872 <e1000_init+0x146>

  // transmitter control bits.
  regs[E1000_TCTL] = E1000_TCTL_EN |                 // enable
    8000587c:	000407b7          	lui	a5,0x40
    80005880:	10a78793          	addi	a5,a5,266 # 4010a <_entry-0x7ffbfef6>
    80005884:	40f6a023          	sw	a5,1024(a3)
                     E1000_TCTL_PSP |                // pad short packets
                     (0x10 << E1000_TCTL_CT_SHIFT) | // collision stuff
                     (0x40 << E1000_TCTL_COLD_SHIFT);
  regs[E1000_TIPG] = 10 | (8 << 10) | (6 << 20); // inter-pkt gap
    80005888:	006027b7          	lui	a5,0x602
    8000588c:	07a9                	addi	a5,a5,10 # 60200a <_entry-0x7f9fdff6>
    8000588e:	40f6a823          	sw	a5,1040(a3)

  // receiver control bits.
  regs[E1000_RCTL] = E1000_RCTL_EN |      // enable receiver
    80005892:	040087b7          	lui	a5,0x4008
    80005896:	0789                	addi	a5,a5,2 # 4008002 <_entry-0x7bff7ffe>
    80005898:	10f6a023          	sw	a5,256(a3)
                     E1000_RCTL_BAM |     // enable broadcast
                     E1000_RCTL_SZ_2048 | // 2048-byte rx buffers
                     E1000_RCTL_SECRC;    // strip CRC

  // ask e1000 for receive interrupts.
  regs[E1000_RDTR] = 0;       // interrupt after every received packet (no timer)
    8000589c:	678d                	lui	a5,0x3
    8000589e:	97b6                	add	a5,a5,a3
    800058a0:	8207a023          	sw	zero,-2016(a5) # 2820 <_entry-0x7fffd7e0>
  regs[E1000_RADV] = 0;       // interrupt after every packet (no timer)
    800058a4:	8207a623          	sw	zero,-2004(a5)
  regs[E1000_IMS] = (1 << 7); // RXDW -- Receiver Descriptor Write Back
    800058a8:	08000793          	li	a5,128
    800058ac:	0cf6a823          	sw	a5,208(a3)
}
    800058b0:	70a2                	ld	ra,40(sp)
    800058b2:	7402                	ld	s0,32(sp)
    800058b4:	64e2                	ld	s1,24(sp)
    800058b6:	6942                	ld	s2,16(sp)
    800058b8:	69a2                	ld	s3,8(sp)
    800058ba:	6145                	addi	sp,sp,48
    800058bc:	8082                	ret
      panic("e1000");
    800058be:	00004517          	auipc	a0,0x4
    800058c2:	f2250513          	addi	a0,a0,-222 # 800097e0 <syscalls+0x408>
    800058c6:	00001097          	auipc	ra,0x1
    800058ca:	2aa080e7          	jalr	682(ra) # 80006b70 <panic>

00000000800058ce <e1000_transmit>:

int e1000_transmit(struct mbuf *m)
{
    800058ce:	7179                	addi	sp,sp,-48
    800058d0:	f406                	sd	ra,40(sp)
    800058d2:	f022                	sd	s0,32(sp)
    800058d4:	ec26                	sd	s1,24(sp)
    800058d6:	e84a                	sd	s2,16(sp)
    800058d8:	e44e                	sd	s3,8(sp)
    800058da:	1800                	addi	s0,sp,48
    800058dc:	892a                	mv	s2,a0
  //
  // the mbuf contains an ethernet frame; program it into
  // the TX descriptor ring so that the e1000 sends it. Stash
  // a pointer so that it can be freed after sending.
  //
  acquire(&e1000_lock);
    800058de:	00019997          	auipc	s3,0x19
    800058e2:	72298993          	addi	s3,s3,1826 # 8001f000 <e1000_lock>
    800058e6:	854e                	mv	a0,s3
    800058e8:	00001097          	auipc	ra,0x1
    800058ec:	7c0080e7          	jalr	1984(ra) # 800070a8 <acquire>
  uint index = regs[E1000_TDT];
    800058f0:	00004797          	auipc	a5,0x4
    800058f4:	7307b783          	ld	a5,1840(a5) # 8000a020 <regs>
    800058f8:	6711                	lui	a4,0x4
    800058fa:	97ba                	add	a5,a5,a4
    800058fc:	8187a783          	lw	a5,-2024(a5)
    80005900:	0007849b          	sext.w	s1,a5
  if ((tx_ring[index].status & E1000_TXD_STAT_DD) == 0)
    80005904:	02079713          	slli	a4,a5,0x20
    80005908:	01c75793          	srli	a5,a4,0x1c
    8000590c:	99be                	add	s3,s3,a5
    8000590e:	02c9c783          	lbu	a5,44(s3)
    80005912:	8b85                	andi	a5,a5,1
    80005914:	cfbd                	beqz	a5,80005992 <e1000_transmit+0xc4>
  {
    release(&e1000_lock);
    return -1;
  }
  if (tx_mbufs[index])
    80005916:	02049793          	slli	a5,s1,0x20
    8000591a:	01d7d713          	srli	a4,a5,0x1d
    8000591e:	00019797          	auipc	a5,0x19
    80005922:	6e278793          	addi	a5,a5,1762 # 8001f000 <e1000_lock>
    80005926:	97ba                	add	a5,a5,a4
    80005928:	1207b503          	ld	a0,288(a5)
    8000592c:	c509                	beqz	a0,80005936 <e1000_transmit+0x68>
    mbuffree(tx_mbufs[index]);
    8000592e:	00000097          	auipc	ra,0x0
    80005932:	340080e7          	jalr	832(ra) # 80005c6e <mbuffree>
  tx_mbufs[index] = m;
    80005936:	00019517          	auipc	a0,0x19
    8000593a:	6ca50513          	addi	a0,a0,1738 # 8001f000 <e1000_lock>
    8000593e:	02049793          	slli	a5,s1,0x20
    80005942:	9381                	srli	a5,a5,0x20
    80005944:	00379713          	slli	a4,a5,0x3
    80005948:	972a                	add	a4,a4,a0
    8000594a:	13273023          	sd	s2,288(a4) # 4120 <_entry-0x7fffbee0>
  tx_ring[index].length = m->len;
    8000594e:	0792                	slli	a5,a5,0x4
    80005950:	97aa                	add	a5,a5,a0
    80005952:	01092703          	lw	a4,16(s2)
    80005956:	02e79423          	sh	a4,40(a5)
  tx_ring[index].addr = (uint64)m->head;
    8000595a:	00893703          	ld	a4,8(s2)
    8000595e:	f398                	sd	a4,32(a5)
  tx_ring[index].cmd = E1000_TXD_CMD_RS | E1000_TXD_CMD_EOP;
    80005960:	4725                	li	a4,9
    80005962:	02e785a3          	sb	a4,43(a5)
  regs[E1000_TDT] = (index + 1) % TX_RING_SIZE;
    80005966:	2485                	addiw	s1,s1,1
    80005968:	88bd                	andi	s1,s1,15
    8000596a:	00004797          	auipc	a5,0x4
    8000596e:	6b67b783          	ld	a5,1718(a5) # 8000a020 <regs>
    80005972:	6711                	lui	a4,0x4
    80005974:	97ba                	add	a5,a5,a4
    80005976:	8097ac23          	sw	s1,-2024(a5)
  release(&e1000_lock);
    8000597a:	00001097          	auipc	ra,0x1
    8000597e:	7e2080e7          	jalr	2018(ra) # 8000715c <release>
  return 0;
    80005982:	4501                	li	a0,0
}
    80005984:	70a2                	ld	ra,40(sp)
    80005986:	7402                	ld	s0,32(sp)
    80005988:	64e2                	ld	s1,24(sp)
    8000598a:	6942                	ld	s2,16(sp)
    8000598c:	69a2                	ld	s3,8(sp)
    8000598e:	6145                	addi	sp,sp,48
    80005990:	8082                	ret
    release(&e1000_lock);
    80005992:	00019517          	auipc	a0,0x19
    80005996:	66e50513          	addi	a0,a0,1646 # 8001f000 <e1000_lock>
    8000599a:	00001097          	auipc	ra,0x1
    8000599e:	7c2080e7          	jalr	1986(ra) # 8000715c <release>
    return -1;
    800059a2:	557d                	li	a0,-1
    800059a4:	b7c5                	j	80005984 <e1000_transmit+0xb6>

00000000800059a6 <e1000_intr>:
    index = RX_RING_SIZE;
  regs[E1000_RDT] = (index - 1) % RX_RING_SIZE;
}

void e1000_intr(void)
{
    800059a6:	7179                	addi	sp,sp,-48
    800059a8:	f406                	sd	ra,40(sp)
    800059aa:	f022                	sd	s0,32(sp)
    800059ac:	ec26                	sd	s1,24(sp)
    800059ae:	e84a                	sd	s2,16(sp)
    800059b0:	e44e                	sd	s3,8(sp)
    800059b2:	1800                	addi	s0,sp,48
  // tell the e1000 we've seen this interrupt;
  // without this the e1000 won't raise any
  // further interrupts.
  regs[E1000_ICR] = 0xffffffff;
    800059b4:	00004797          	auipc	a5,0x4
    800059b8:	66c7b783          	ld	a5,1644(a5) # 8000a020 <regs>
    800059bc:	577d                	li	a4,-1
    800059be:	0ce7a023          	sw	a4,192(a5)
  uint index = regs[E1000_RDT];
    800059c2:	670d                	lui	a4,0x3
    800059c4:	97ba                	add	a5,a5,a4
    800059c6:	8187a783          	lw	a5,-2024(a5)
  index = (index + 1) % RX_RING_SIZE;
    800059ca:	2785                	addiw	a5,a5,1
    800059cc:	00f7f913          	andi	s2,a5,15
  while (rx_ring[index].status & E1000_RXD_STAT_DD)
    800059d0:	00491793          	slli	a5,s2,0x4
    800059d4:	00019717          	auipc	a4,0x19
    800059d8:	62c70713          	addi	a4,a4,1580 # 8001f000 <e1000_lock>
    800059dc:	97ba                	add	a5,a5,a4
    800059de:	1ac7c783          	lbu	a5,428(a5)
    800059e2:	8b85                	andi	a5,a5,1
    800059e4:	cfb1                	beqz	a5,80005a40 <e1000_intr+0x9a>
    rx_mbufs[index]->len = rx_ring[index].length;
    800059e6:	89ba                	mv	s3,a4
    800059e8:	00391493          	slli	s1,s2,0x3
    800059ec:	94ce                	add	s1,s1,s3
    800059ee:	2a04b703          	ld	a4,672(s1)
    800059f2:	00491793          	slli	a5,s2,0x4
    800059f6:	97ce                	add	a5,a5,s3
    800059f8:	1a87d783          	lhu	a5,424(a5)
    800059fc:	cb1c                	sw	a5,16(a4)
    net_rx(rx_mbufs[index]);
    800059fe:	2a04b503          	ld	a0,672(s1)
    80005a02:	00000097          	auipc	ra,0x0
    80005a06:	3e6080e7          	jalr	998(ra) # 80005de8 <net_rx>
    if ((rx_mbufs[index] = mbufalloc(0)) == 0)
    80005a0a:	4501                	li	a0,0
    80005a0c:	00000097          	auipc	ra,0x0
    80005a10:	20a080e7          	jalr	522(ra) # 80005c16 <mbufalloc>
    80005a14:	2aa4b023          	sd	a0,672(s1)
    80005a18:	c929                	beqz	a0,80005a6a <e1000_intr+0xc4>
    rx_ring[index].addr = (uint64)rx_mbufs[index]->head;
    80005a1a:	00491793          	slli	a5,s2,0x4
    80005a1e:	97ce                	add	a5,a5,s3
    80005a20:	6518                	ld	a4,8(a0)
    80005a22:	1ae7b023          	sd	a4,416(a5)
    rx_ring[index].status = 0;
    80005a26:	1a078623          	sb	zero,428(a5)
    index = (index + 1) % RX_RING_SIZE;
    80005a2a:	0019079b          	addiw	a5,s2,1
    80005a2e:	00f7f913          	andi	s2,a5,15
  while (rx_ring[index].status & E1000_RXD_STAT_DD)
    80005a32:	00491793          	slli	a5,s2,0x4
    80005a36:	97ce                	add	a5,a5,s3
    80005a38:	1ac7c783          	lbu	a5,428(a5)
    80005a3c:	8b85                	andi	a5,a5,1
    80005a3e:	f7cd                	bnez	a5,800059e8 <e1000_intr+0x42>
  if (index == 0)
    80005a40:	00091363          	bnez	s2,80005a46 <e1000_intr+0xa0>
    index = RX_RING_SIZE;
    80005a44:	4941                	li	s2,16
  regs[E1000_RDT] = (index - 1) % RX_RING_SIZE;
    80005a46:	397d                	addiw	s2,s2,-1
    80005a48:	00f97913          	andi	s2,s2,15
    80005a4c:	00004797          	auipc	a5,0x4
    80005a50:	5d47b783          	ld	a5,1492(a5) # 8000a020 <regs>
    80005a54:	670d                	lui	a4,0x3
    80005a56:	97ba                	add	a5,a5,a4
    80005a58:	8127ac23          	sw	s2,-2024(a5)

  e1000_recv();
}
    80005a5c:	70a2                	ld	ra,40(sp)
    80005a5e:	7402                	ld	s0,32(sp)
    80005a60:	64e2                	ld	s1,24(sp)
    80005a62:	6942                	ld	s2,16(sp)
    80005a64:	69a2                	ld	s3,8(sp)
    80005a66:	6145                	addi	sp,sp,48
    80005a68:	8082                	ret
      panic("e1000");
    80005a6a:	00004517          	auipc	a0,0x4
    80005a6e:	d7650513          	addi	a0,a0,-650 # 800097e0 <syscalls+0x408>
    80005a72:	00001097          	auipc	ra,0x1
    80005a76:	0fe080e7          	jalr	254(ra) # 80006b70 <panic>

0000000080005a7a <in_cksum>:

// This code is lifted from FreeBSD's ping.c, and is copyright by the Regents
// of the University of California.
static unsigned short
in_cksum(const unsigned char *addr, int len)
{
    80005a7a:	1141                	addi	sp,sp,-16
    80005a7c:	e422                	sd	s0,8(sp)
    80005a7e:	0800                	addi	s0,sp,16
  /*
   * Our algorithm is simple, using a 32 bit accumulator (sum), we add
   * sequential 16 bit words to it, and at the end, fold back all the
   * carry bits from the top 16 bits into the lower 16 bits.
   */
  while (nleft > 1)  {
    80005a80:	4785                	li	a5,1
    80005a82:	04b7db63          	bge	a5,a1,80005ad8 <in_cksum+0x5e>
    80005a86:	ffe5861b          	addiw	a2,a1,-2
    80005a8a:	0016561b          	srliw	a2,a2,0x1
    80005a8e:	0016069b          	addiw	a3,a2,1
    80005a92:	02069793          	slli	a5,a3,0x20
    80005a96:	01f7d693          	srli	a3,a5,0x1f
    80005a9a:	96aa                	add	a3,a3,a0
  unsigned int sum = 0;
    80005a9c:	4781                	li	a5,0
    sum += *w++;
    80005a9e:	0509                	addi	a0,a0,2
    80005aa0:	ffe55703          	lhu	a4,-2(a0)
    80005aa4:	9fb9                	addw	a5,a5,a4
  while (nleft > 1)  {
    80005aa6:	fed51ce3          	bne	a0,a3,80005a9e <in_cksum+0x24>
    nleft -= 2;
    80005aaa:	35f9                	addiw	a1,a1,-2
    80005aac:	0016161b          	slliw	a2,a2,0x1
    80005ab0:	9d91                	subw	a1,a1,a2
  }

  /* mop up an odd byte, if necessary */
  if (nleft == 1) {
    80005ab2:	4705                	li	a4,1
    80005ab4:	02e58563          	beq	a1,a4,80005ade <in_cksum+0x64>
    *(unsigned char *)(&answer) = *(const unsigned char *)w;
    sum += answer;
  }

  /* add back carry outs from top 16 bits to low 16 bits */
  sum = (sum & 0xffff) + (sum >> 16);
    80005ab8:	03079713          	slli	a4,a5,0x30
    80005abc:	9341                	srli	a4,a4,0x30
    80005abe:	0107d79b          	srliw	a5,a5,0x10
    80005ac2:	9fb9                	addw	a5,a5,a4
  sum += (sum >> 16);
    80005ac4:	0107d51b          	srliw	a0,a5,0x10
    80005ac8:	9d3d                	addw	a0,a0,a5
  /* guaranteed now that the lower 16 bits of sum are correct */

  answer = ~sum; /* truncate to 16 bits */
    80005aca:	fff54513          	not	a0,a0
  return answer;
}
    80005ace:	1542                	slli	a0,a0,0x30
    80005ad0:	9141                	srli	a0,a0,0x30
    80005ad2:	6422                	ld	s0,8(sp)
    80005ad4:	0141                	addi	sp,sp,16
    80005ad6:	8082                	ret
  const unsigned short *w = (const unsigned short *)addr;
    80005ad8:	86aa                	mv	a3,a0
  unsigned int sum = 0;
    80005ada:	4781                	li	a5,0
    80005adc:	bfd9                	j	80005ab2 <in_cksum+0x38>
    *(unsigned char *)(&answer) = *(const unsigned char *)w;
    80005ade:	0006c703          	lbu	a4,0(a3)
    sum += answer;
    80005ae2:	9fb9                	addw	a5,a5,a4
    80005ae4:	bfd1                	j	80005ab8 <in_cksum+0x3e>

0000000080005ae6 <mbufpull>:
{
    80005ae6:	1141                	addi	sp,sp,-16
    80005ae8:	e422                	sd	s0,8(sp)
    80005aea:	0800                	addi	s0,sp,16
    80005aec:	87aa                	mv	a5,a0
  char *tmp = m->head;
    80005aee:	6508                	ld	a0,8(a0)
  if (m->len < len)
    80005af0:	4b98                	lw	a4,16(a5)
    80005af2:	00b76b63          	bltu	a4,a1,80005b08 <mbufpull+0x22>
  m->len -= len;
    80005af6:	9f0d                	subw	a4,a4,a1
    80005af8:	cb98                	sw	a4,16(a5)
  m->head += len;
    80005afa:	1582                	slli	a1,a1,0x20
    80005afc:	9181                	srli	a1,a1,0x20
    80005afe:	95aa                	add	a1,a1,a0
    80005b00:	e78c                	sd	a1,8(a5)
}
    80005b02:	6422                	ld	s0,8(sp)
    80005b04:	0141                	addi	sp,sp,16
    80005b06:	8082                	ret
    return 0;
    80005b08:	4501                	li	a0,0
    80005b0a:	bfe5                	j	80005b02 <mbufpull+0x1c>

0000000080005b0c <mbufpush>:
{
    80005b0c:	87aa                	mv	a5,a0
  m->head -= len;
    80005b0e:	02059713          	slli	a4,a1,0x20
    80005b12:	9301                	srli	a4,a4,0x20
    80005b14:	6508                	ld	a0,8(a0)
    80005b16:	8d19                	sub	a0,a0,a4
    80005b18:	e788                	sd	a0,8(a5)
  if (m->head < m->buf)
    80005b1a:	01478713          	addi	a4,a5,20
    80005b1e:	00e56663          	bltu	a0,a4,80005b2a <mbufpush+0x1e>
  m->len += len;
    80005b22:	4b98                	lw	a4,16(a5)
    80005b24:	9f2d                	addw	a4,a4,a1
    80005b26:	cb98                	sw	a4,16(a5)
}
    80005b28:	8082                	ret
{
    80005b2a:	1141                	addi	sp,sp,-16
    80005b2c:	e406                	sd	ra,8(sp)
    80005b2e:	e022                	sd	s0,0(sp)
    80005b30:	0800                	addi	s0,sp,16
    panic("mbufpush");
    80005b32:	00004517          	auipc	a0,0x4
    80005b36:	cb650513          	addi	a0,a0,-842 # 800097e8 <syscalls+0x410>
    80005b3a:	00001097          	auipc	ra,0x1
    80005b3e:	036080e7          	jalr	54(ra) # 80006b70 <panic>

0000000080005b42 <net_tx_eth>:

// sends an ethernet packet
static void
net_tx_eth(struct mbuf *m, uint16 ethtype)
{
    80005b42:	7179                	addi	sp,sp,-48
    80005b44:	f406                	sd	ra,40(sp)
    80005b46:	f022                	sd	s0,32(sp)
    80005b48:	ec26                	sd	s1,24(sp)
    80005b4a:	e84a                	sd	s2,16(sp)
    80005b4c:	e44e                	sd	s3,8(sp)
    80005b4e:	1800                	addi	s0,sp,48
    80005b50:	89aa                	mv	s3,a0
    80005b52:	892e                	mv	s2,a1
  struct eth *ethhdr;

  ethhdr = mbufpushhdr(m, *ethhdr);
    80005b54:	45b9                	li	a1,14
    80005b56:	00000097          	auipc	ra,0x0
    80005b5a:	fb6080e7          	jalr	-74(ra) # 80005b0c <mbufpush>
    80005b5e:	84aa                	mv	s1,a0
  memmove(ethhdr->shost, local_mac, ETHADDR_LEN);
    80005b60:	4619                	li	a2,6
    80005b62:	00004597          	auipc	a1,0x4
    80005b66:	d3e58593          	addi	a1,a1,-706 # 800098a0 <local_mac>
    80005b6a:	0519                	addi	a0,a0,6
    80005b6c:	ffffa097          	auipc	ra,0xffffa
    80005b70:	66a080e7          	jalr	1642(ra) # 800001d6 <memmove>
  // In a real networking stack, dhost would be set to the address discovered
  // through ARP. Because we don't support enough of the ARP protocol, set it
  // to broadcast instead.
  memmove(ethhdr->dhost, broadcast_mac, ETHADDR_LEN);
    80005b74:	4619                	li	a2,6
    80005b76:	00004597          	auipc	a1,0x4
    80005b7a:	d2258593          	addi	a1,a1,-734 # 80009898 <broadcast_mac>
    80005b7e:	8526                	mv	a0,s1
    80005b80:	ffffa097          	auipc	ra,0xffffa
    80005b84:	656080e7          	jalr	1622(ra) # 800001d6 <memmove>
// endianness support
//

static inline uint16 bswaps(uint16 val)
{
  return (((val & 0x00ffU) << 8) |
    80005b88:	0089579b          	srliw	a5,s2,0x8
  ethhdr->type = htons(ethtype);
    80005b8c:	00f48623          	sb	a5,12(s1)
    80005b90:	012486a3          	sb	s2,13(s1)
  if (e1000_transmit(m)) {
    80005b94:	854e                	mv	a0,s3
    80005b96:	00000097          	auipc	ra,0x0
    80005b9a:	d38080e7          	jalr	-712(ra) # 800058ce <e1000_transmit>
    80005b9e:	e901                	bnez	a0,80005bae <net_tx_eth+0x6c>
    mbuffree(m);
  }
}
    80005ba0:	70a2                	ld	ra,40(sp)
    80005ba2:	7402                	ld	s0,32(sp)
    80005ba4:	64e2                	ld	s1,24(sp)
    80005ba6:	6942                	ld	s2,16(sp)
    80005ba8:	69a2                	ld	s3,8(sp)
    80005baa:	6145                	addi	sp,sp,48
    80005bac:	8082                	ret
  kfree(m);
    80005bae:	854e                	mv	a0,s3
    80005bb0:	ffffa097          	auipc	ra,0xffffa
    80005bb4:	46c080e7          	jalr	1132(ra) # 8000001c <kfree>
}
    80005bb8:	b7e5                	j	80005ba0 <net_tx_eth+0x5e>

0000000080005bba <mbufput>:
{
    80005bba:	87aa                	mv	a5,a0
  char *tmp = m->head + m->len;
    80005bbc:	4918                	lw	a4,16(a0)
    80005bbe:	02071693          	slli	a3,a4,0x20
    80005bc2:	9281                	srli	a3,a3,0x20
    80005bc4:	6508                	ld	a0,8(a0)
    80005bc6:	9536                	add	a0,a0,a3
  m->len += len;
    80005bc8:	9f2d                	addw	a4,a4,a1
    80005bca:	0007069b          	sext.w	a3,a4
    80005bce:	cb98                	sw	a4,16(a5)
  if (m->len > MBUF_SIZE)
    80005bd0:	6785                	lui	a5,0x1
    80005bd2:	80078793          	addi	a5,a5,-2048 # 800 <_entry-0x7ffff800>
    80005bd6:	00d7e363          	bltu	a5,a3,80005bdc <mbufput+0x22>
}
    80005bda:	8082                	ret
{
    80005bdc:	1141                	addi	sp,sp,-16
    80005bde:	e406                	sd	ra,8(sp)
    80005be0:	e022                	sd	s0,0(sp)
    80005be2:	0800                	addi	s0,sp,16
    panic("mbufput");
    80005be4:	00004517          	auipc	a0,0x4
    80005be8:	c1450513          	addi	a0,a0,-1004 # 800097f8 <syscalls+0x420>
    80005bec:	00001097          	auipc	ra,0x1
    80005bf0:	f84080e7          	jalr	-124(ra) # 80006b70 <panic>

0000000080005bf4 <mbuftrim>:
{
    80005bf4:	1141                	addi	sp,sp,-16
    80005bf6:	e422                	sd	s0,8(sp)
    80005bf8:	0800                	addi	s0,sp,16
  if (len > m->len)
    80005bfa:	491c                	lw	a5,16(a0)
    80005bfc:	00b7eb63          	bltu	a5,a1,80005c12 <mbuftrim+0x1e>
  m->len -= len;
    80005c00:	9f8d                	subw	a5,a5,a1
    80005c02:	c91c                	sw	a5,16(a0)
  return m->head + m->len;
    80005c04:	1782                	slli	a5,a5,0x20
    80005c06:	9381                	srli	a5,a5,0x20
    80005c08:	6508                	ld	a0,8(a0)
    80005c0a:	953e                	add	a0,a0,a5
}
    80005c0c:	6422                	ld	s0,8(sp)
    80005c0e:	0141                	addi	sp,sp,16
    80005c10:	8082                	ret
    return 0;
    80005c12:	4501                	li	a0,0
    80005c14:	bfe5                	j	80005c0c <mbuftrim+0x18>

0000000080005c16 <mbufalloc>:
{
    80005c16:	1101                	addi	sp,sp,-32
    80005c18:	ec06                	sd	ra,24(sp)
    80005c1a:	e822                	sd	s0,16(sp)
    80005c1c:	e426                	sd	s1,8(sp)
    80005c1e:	e04a                	sd	s2,0(sp)
    80005c20:	1000                	addi	s0,sp,32
  if (headroom > MBUF_SIZE)
    80005c22:	6785                	lui	a5,0x1
    80005c24:	80078793          	addi	a5,a5,-2048 # 800 <_entry-0x7ffff800>
    return 0;
    80005c28:	4901                	li	s2,0
  if (headroom > MBUF_SIZE)
    80005c2a:	02a7eb63          	bltu	a5,a0,80005c60 <mbufalloc+0x4a>
    80005c2e:	84aa                	mv	s1,a0
  m = kalloc();
    80005c30:	ffffa097          	auipc	ra,0xffffa
    80005c34:	4ea080e7          	jalr	1258(ra) # 8000011a <kalloc>
    80005c38:	892a                	mv	s2,a0
  if (m == 0)
    80005c3a:	c11d                	beqz	a0,80005c60 <mbufalloc+0x4a>
  m->next = 0;
    80005c3c:	00053023          	sd	zero,0(a0)
  m->head = (char *)m->buf + headroom;
    80005c40:	0551                	addi	a0,a0,20
    80005c42:	1482                	slli	s1,s1,0x20
    80005c44:	9081                	srli	s1,s1,0x20
    80005c46:	94aa                	add	s1,s1,a0
    80005c48:	00993423          	sd	s1,8(s2)
  m->len = 0;
    80005c4c:	00092823          	sw	zero,16(s2)
  memset(m->buf, 0, sizeof(m->buf));
    80005c50:	6605                	lui	a2,0x1
    80005c52:	80060613          	addi	a2,a2,-2048 # 800 <_entry-0x7ffff800>
    80005c56:	4581                	li	a1,0
    80005c58:	ffffa097          	auipc	ra,0xffffa
    80005c5c:	522080e7          	jalr	1314(ra) # 8000017a <memset>
}
    80005c60:	854a                	mv	a0,s2
    80005c62:	60e2                	ld	ra,24(sp)
    80005c64:	6442                	ld	s0,16(sp)
    80005c66:	64a2                	ld	s1,8(sp)
    80005c68:	6902                	ld	s2,0(sp)
    80005c6a:	6105                	addi	sp,sp,32
    80005c6c:	8082                	ret

0000000080005c6e <mbuffree>:
{
    80005c6e:	1141                	addi	sp,sp,-16
    80005c70:	e406                	sd	ra,8(sp)
    80005c72:	e022                	sd	s0,0(sp)
    80005c74:	0800                	addi	s0,sp,16
  kfree(m);
    80005c76:	ffffa097          	auipc	ra,0xffffa
    80005c7a:	3a6080e7          	jalr	934(ra) # 8000001c <kfree>
}
    80005c7e:	60a2                	ld	ra,8(sp)
    80005c80:	6402                	ld	s0,0(sp)
    80005c82:	0141                	addi	sp,sp,16
    80005c84:	8082                	ret

0000000080005c86 <mbufq_pushtail>:
{
    80005c86:	1141                	addi	sp,sp,-16
    80005c88:	e422                	sd	s0,8(sp)
    80005c8a:	0800                	addi	s0,sp,16
  m->next = 0;
    80005c8c:	0005b023          	sd	zero,0(a1)
  if (!q->head){
    80005c90:	611c                	ld	a5,0(a0)
    80005c92:	c799                	beqz	a5,80005ca0 <mbufq_pushtail+0x1a>
  q->tail->next = m;
    80005c94:	651c                	ld	a5,8(a0)
    80005c96:	e38c                	sd	a1,0(a5)
  q->tail = m;
    80005c98:	e50c                	sd	a1,8(a0)
}
    80005c9a:	6422                	ld	s0,8(sp)
    80005c9c:	0141                	addi	sp,sp,16
    80005c9e:	8082                	ret
    q->head = q->tail = m;
    80005ca0:	e50c                	sd	a1,8(a0)
    80005ca2:	e10c                	sd	a1,0(a0)
    return;
    80005ca4:	bfdd                	j	80005c9a <mbufq_pushtail+0x14>

0000000080005ca6 <mbufq_pophead>:
{
    80005ca6:	1141                	addi	sp,sp,-16
    80005ca8:	e422                	sd	s0,8(sp)
    80005caa:	0800                	addi	s0,sp,16
    80005cac:	87aa                	mv	a5,a0
  struct mbuf *head = q->head;
    80005cae:	6108                	ld	a0,0(a0)
  if (!head)
    80005cb0:	c119                	beqz	a0,80005cb6 <mbufq_pophead+0x10>
  q->head = head->next;
    80005cb2:	6118                	ld	a4,0(a0)
    80005cb4:	e398                	sd	a4,0(a5)
}
    80005cb6:	6422                	ld	s0,8(sp)
    80005cb8:	0141                	addi	sp,sp,16
    80005cba:	8082                	ret

0000000080005cbc <mbufq_empty>:
{
    80005cbc:	1141                	addi	sp,sp,-16
    80005cbe:	e422                	sd	s0,8(sp)
    80005cc0:	0800                	addi	s0,sp,16
  return q->head == 0;
    80005cc2:	6108                	ld	a0,0(a0)
}
    80005cc4:	00153513          	seqz	a0,a0
    80005cc8:	6422                	ld	s0,8(sp)
    80005cca:	0141                	addi	sp,sp,16
    80005ccc:	8082                	ret

0000000080005cce <mbufq_init>:
{
    80005cce:	1141                	addi	sp,sp,-16
    80005cd0:	e422                	sd	s0,8(sp)
    80005cd2:	0800                	addi	s0,sp,16
  q->head = 0;
    80005cd4:	00053023          	sd	zero,0(a0)
}
    80005cd8:	6422                	ld	s0,8(sp)
    80005cda:	0141                	addi	sp,sp,16
    80005cdc:	8082                	ret

0000000080005cde <net_tx_udp>:

// sends a UDP packet
void
net_tx_udp(struct mbuf *m, uint32 dip,
           uint16 sport, uint16 dport)
{
    80005cde:	7179                	addi	sp,sp,-48
    80005ce0:	f406                	sd	ra,40(sp)
    80005ce2:	f022                	sd	s0,32(sp)
    80005ce4:	ec26                	sd	s1,24(sp)
    80005ce6:	e84a                	sd	s2,16(sp)
    80005ce8:	e44e                	sd	s3,8(sp)
    80005cea:	e052                	sd	s4,0(sp)
    80005cec:	1800                	addi	s0,sp,48
    80005cee:	89aa                	mv	s3,a0
    80005cf0:	892e                	mv	s2,a1
    80005cf2:	8a32                	mv	s4,a2
    80005cf4:	84b6                	mv	s1,a3
  struct udp *udphdr;

  // put the UDP header
  udphdr = mbufpushhdr(m, *udphdr);
    80005cf6:	45a1                	li	a1,8
    80005cf8:	00000097          	auipc	ra,0x0
    80005cfc:	e14080e7          	jalr	-492(ra) # 80005b0c <mbufpush>
    80005d00:	008a179b          	slliw	a5,s4,0x8
    80005d04:	008a5a1b          	srliw	s4,s4,0x8
    80005d08:	0147e7b3          	or	a5,a5,s4
  udphdr->sport = htons(sport);
    80005d0c:	00f51023          	sh	a5,0(a0)
    80005d10:	0084979b          	slliw	a5,s1,0x8
    80005d14:	0084d49b          	srliw	s1,s1,0x8
    80005d18:	8fc5                	or	a5,a5,s1
  udphdr->dport = htons(dport);
    80005d1a:	00f51123          	sh	a5,2(a0)
  udphdr->ulen = htons(m->len);
    80005d1e:	0109a783          	lw	a5,16(s3)
    80005d22:	0087971b          	slliw	a4,a5,0x8
    80005d26:	0107979b          	slliw	a5,a5,0x10
    80005d2a:	0107d79b          	srliw	a5,a5,0x10
    80005d2e:	0087d79b          	srliw	a5,a5,0x8
    80005d32:	8fd9                	or	a5,a5,a4
    80005d34:	00f51223          	sh	a5,4(a0)
  udphdr->sum = 0; // zero means no checksum is provided
    80005d38:	00051323          	sh	zero,6(a0)
  iphdr = mbufpushhdr(m, *iphdr);
    80005d3c:	45d1                	li	a1,20
    80005d3e:	854e                	mv	a0,s3
    80005d40:	00000097          	auipc	ra,0x0
    80005d44:	dcc080e7          	jalr	-564(ra) # 80005b0c <mbufpush>
    80005d48:	84aa                	mv	s1,a0
  memset(iphdr, 0, sizeof(*iphdr));
    80005d4a:	4651                	li	a2,20
    80005d4c:	4581                	li	a1,0
    80005d4e:	ffffa097          	auipc	ra,0xffffa
    80005d52:	42c080e7          	jalr	1068(ra) # 8000017a <memset>
  iphdr->ip_vhl = (4 << 4) | (20 >> 2);
    80005d56:	04500793          	li	a5,69
    80005d5a:	00f48023          	sb	a5,0(s1)
  iphdr->ip_p = proto;
    80005d5e:	47c5                	li	a5,17
    80005d60:	00f484a3          	sb	a5,9(s1)
  iphdr->ip_src = htonl(local_ip);
    80005d64:	0f0207b7          	lui	a5,0xf020
    80005d68:	07a9                	addi	a5,a5,10 # f02000a <_entry-0x70fdfff6>
    80005d6a:	c4dc                	sw	a5,12(s1)
          ((val & 0xff00U) >> 8));
}

static inline uint32 bswapl(uint32 val)
{
  return (((val & 0x000000ffUL) << 24) |
    80005d6c:	0189179b          	slliw	a5,s2,0x18
          ((val & 0x0000ff00UL) << 8) |
          ((val & 0x00ff0000UL) >> 8) |
          ((val & 0xff000000UL) >> 24));
    80005d70:	0189571b          	srliw	a4,s2,0x18
          ((val & 0x00ff0000UL) >> 8) |
    80005d74:	8fd9                	or	a5,a5,a4
          ((val & 0x0000ff00UL) << 8) |
    80005d76:	0089171b          	slliw	a4,s2,0x8
    80005d7a:	00ff06b7          	lui	a3,0xff0
    80005d7e:	8f75                	and	a4,a4,a3
          ((val & 0x00ff0000UL) >> 8) |
    80005d80:	8fd9                	or	a5,a5,a4
    80005d82:	0089591b          	srliw	s2,s2,0x8
    80005d86:	6741                	lui	a4,0x10
    80005d88:	f0070713          	addi	a4,a4,-256 # ff00 <_entry-0x7fff0100>
    80005d8c:	00e97933          	and	s2,s2,a4
    80005d90:	0127e7b3          	or	a5,a5,s2
  iphdr->ip_dst = htonl(dip);
    80005d94:	c89c                	sw	a5,16(s1)
  iphdr->ip_len = htons(m->len);
    80005d96:	0109a783          	lw	a5,16(s3)
  return (((val & 0x00ffU) << 8) |
    80005d9a:	0087971b          	slliw	a4,a5,0x8
    80005d9e:	0107979b          	slliw	a5,a5,0x10
    80005da2:	0107d79b          	srliw	a5,a5,0x10
    80005da6:	0087d79b          	srliw	a5,a5,0x8
    80005daa:	8fd9                	or	a5,a5,a4
    80005dac:	00f49123          	sh	a5,2(s1)
  iphdr->ip_ttl = 100;
    80005db0:	06400793          	li	a5,100
    80005db4:	00f48423          	sb	a5,8(s1)
  iphdr->ip_sum = in_cksum((unsigned char *)iphdr, sizeof(*iphdr));
    80005db8:	45d1                	li	a1,20
    80005dba:	8526                	mv	a0,s1
    80005dbc:	00000097          	auipc	ra,0x0
    80005dc0:	cbe080e7          	jalr	-834(ra) # 80005a7a <in_cksum>
    80005dc4:	00a49523          	sh	a0,10(s1)
  net_tx_eth(m, ETHTYPE_IP);
    80005dc8:	6585                	lui	a1,0x1
    80005dca:	80058593          	addi	a1,a1,-2048 # 800 <_entry-0x7ffff800>
    80005dce:	854e                	mv	a0,s3
    80005dd0:	00000097          	auipc	ra,0x0
    80005dd4:	d72080e7          	jalr	-654(ra) # 80005b42 <net_tx_eth>

  // now on to the IP layer
  net_tx_ip(m, IPPROTO_UDP, dip);
}
    80005dd8:	70a2                	ld	ra,40(sp)
    80005dda:	7402                	ld	s0,32(sp)
    80005ddc:	64e2                	ld	s1,24(sp)
    80005dde:	6942                	ld	s2,16(sp)
    80005de0:	69a2                	ld	s3,8(sp)
    80005de2:	6a02                	ld	s4,0(sp)
    80005de4:	6145                	addi	sp,sp,48
    80005de6:	8082                	ret

0000000080005de8 <net_rx>:
}

// called by e1000 driver's interrupt handler to deliver a packet to the
// networking stack
void net_rx(struct mbuf *m)
{
    80005de8:	715d                	addi	sp,sp,-80
    80005dea:	e486                	sd	ra,72(sp)
    80005dec:	e0a2                	sd	s0,64(sp)
    80005dee:	fc26                	sd	s1,56(sp)
    80005df0:	f84a                	sd	s2,48(sp)
    80005df2:	f44e                	sd	s3,40(sp)
    80005df4:	f052                	sd	s4,32(sp)
    80005df6:	ec56                	sd	s5,24(sp)
    80005df8:	0880                	addi	s0,sp,80
    80005dfa:	84aa                	mv	s1,a0
  struct eth *ethhdr;
  uint16 type;

  ethhdr = mbufpullhdr(m, *ethhdr);
    80005dfc:	45b9                	li	a1,14
    80005dfe:	00000097          	auipc	ra,0x0
    80005e02:	ce8080e7          	jalr	-792(ra) # 80005ae6 <mbufpull>
  if (!ethhdr) {
    80005e06:	c521                	beqz	a0,80005e4e <net_rx+0x66>
    mbuffree(m);
    return;
  }

  type = ntohs(ethhdr->type);
    80005e08:	00c54703          	lbu	a4,12(a0)
    80005e0c:	00d54783          	lbu	a5,13(a0)
    80005e10:	07a2                	slli	a5,a5,0x8
    80005e12:	8fd9                	or	a5,a5,a4
    80005e14:	0087971b          	slliw	a4,a5,0x8
    80005e18:	83a1                	srli	a5,a5,0x8
    80005e1a:	8fd9                	or	a5,a5,a4
    80005e1c:	17c2                	slli	a5,a5,0x30
    80005e1e:	93c1                	srli	a5,a5,0x30
  if (type == ETHTYPE_IP)
    80005e20:	8007871b          	addiw	a4,a5,-2048
    80005e24:	cb1d                	beqz	a4,80005e5a <net_rx+0x72>
    net_rx_ip(m);
  else if (type == ETHTYPE_ARP)
    80005e26:	2781                	sext.w	a5,a5
    80005e28:	6705                	lui	a4,0x1
    80005e2a:	80670713          	addi	a4,a4,-2042 # 806 <_entry-0x7ffff7fa>
    80005e2e:	16e78e63          	beq	a5,a4,80005faa <net_rx+0x1c2>
  kfree(m);
    80005e32:	8526                	mv	a0,s1
    80005e34:	ffffa097          	auipc	ra,0xffffa
    80005e38:	1e8080e7          	jalr	488(ra) # 8000001c <kfree>
    net_rx_arp(m);
  else
    mbuffree(m);
}
    80005e3c:	60a6                	ld	ra,72(sp)
    80005e3e:	6406                	ld	s0,64(sp)
    80005e40:	74e2                	ld	s1,56(sp)
    80005e42:	7942                	ld	s2,48(sp)
    80005e44:	79a2                	ld	s3,40(sp)
    80005e46:	7a02                	ld	s4,32(sp)
    80005e48:	6ae2                	ld	s5,24(sp)
    80005e4a:	6161                	addi	sp,sp,80
    80005e4c:	8082                	ret
  kfree(m);
    80005e4e:	8526                	mv	a0,s1
    80005e50:	ffffa097          	auipc	ra,0xffffa
    80005e54:	1cc080e7          	jalr	460(ra) # 8000001c <kfree>
}
    80005e58:	b7d5                	j	80005e3c <net_rx+0x54>
  iphdr = mbufpullhdr(m, *iphdr);
    80005e5a:	45d1                	li	a1,20
    80005e5c:	8526                	mv	a0,s1
    80005e5e:	00000097          	auipc	ra,0x0
    80005e62:	c88080e7          	jalr	-888(ra) # 80005ae6 <mbufpull>
    80005e66:	892a                	mv	s2,a0
  if (!iphdr)
    80005e68:	c535                	beqz	a0,80005ed4 <net_rx+0xec>
  if (iphdr->ip_vhl != ((4 << 4) | (20 >> 2)))
    80005e6a:	00054703          	lbu	a4,0(a0)
    80005e6e:	04500793          	li	a5,69
    80005e72:	06f71163          	bne	a4,a5,80005ed4 <net_rx+0xec>
  if (in_cksum((unsigned char *)iphdr, sizeof(*iphdr)))
    80005e76:	45d1                	li	a1,20
    80005e78:	00000097          	auipc	ra,0x0
    80005e7c:	c02080e7          	jalr	-1022(ra) # 80005a7a <in_cksum>
    80005e80:	e931                	bnez	a0,80005ed4 <net_rx+0xec>
    80005e82:	00695783          	lhu	a5,6(s2)
    80005e86:	0087971b          	slliw	a4,a5,0x8
    80005e8a:	83a1                	srli	a5,a5,0x8
    80005e8c:	8fd9                	or	a5,a5,a4
  if (htons(iphdr->ip_off) != 0)
    80005e8e:	17c2                	slli	a5,a5,0x30
    80005e90:	93c1                	srli	a5,a5,0x30
    80005e92:	e3a9                	bnez	a5,80005ed4 <net_rx+0xec>
  if (htonl(iphdr->ip_dst) != local_ip)
    80005e94:	01092703          	lw	a4,16(s2)
  return (((val & 0x000000ffUL) << 24) |
    80005e98:	0187179b          	slliw	a5,a4,0x18
          ((val & 0xff000000UL) >> 24));
    80005e9c:	0187569b          	srliw	a3,a4,0x18
          ((val & 0x00ff0000UL) >> 8) |
    80005ea0:	8fd5                	or	a5,a5,a3
          ((val & 0x0000ff00UL) << 8) |
    80005ea2:	0087169b          	slliw	a3,a4,0x8
    80005ea6:	00ff0637          	lui	a2,0xff0
    80005eaa:	8ef1                	and	a3,a3,a2
          ((val & 0x00ff0000UL) >> 8) |
    80005eac:	8fd5                	or	a5,a5,a3
    80005eae:	0087571b          	srliw	a4,a4,0x8
    80005eb2:	66c1                	lui	a3,0x10
    80005eb4:	f0068693          	addi	a3,a3,-256 # ff00 <_entry-0x7fff0100>
    80005eb8:	8f75                	and	a4,a4,a3
    80005eba:	8fd9                	or	a5,a5,a4
    80005ebc:	2781                	sext.w	a5,a5
    80005ebe:	0a000737          	lui	a4,0xa000
    80005ec2:	20f70713          	addi	a4,a4,527 # a00020f <_entry-0x75fffdf1>
    80005ec6:	00e79763          	bne	a5,a4,80005ed4 <net_rx+0xec>
  if (iphdr->ip_p != IPPROTO_UDP)
    80005eca:	00994703          	lbu	a4,9(s2)
    80005ece:	47c5                	li	a5,17
    80005ed0:	00f70863          	beq	a4,a5,80005ee0 <net_rx+0xf8>
  kfree(m);
    80005ed4:	8526                	mv	a0,s1
    80005ed6:	ffffa097          	auipc	ra,0xffffa
    80005eda:	146080e7          	jalr	326(ra) # 8000001c <kfree>
}
    80005ede:	bfb9                	j	80005e3c <net_rx+0x54>
  return (((val & 0x00ffU) << 8) |
    80005ee0:	00295783          	lhu	a5,2(s2)
    80005ee4:	0087971b          	slliw	a4,a5,0x8
    80005ee8:	83a1                	srli	a5,a5,0x8
    80005eea:	8fd9                	or	a5,a5,a4
    80005eec:	03079993          	slli	s3,a5,0x30
    80005ef0:	0309d993          	srli	s3,s3,0x30
  len = ntohs(iphdr->ip_len) - sizeof(*iphdr);
    80005ef4:	fec9879b          	addiw	a5,s3,-20
    80005ef8:	03079a13          	slli	s4,a5,0x30
    80005efc:	030a5a13          	srli	s4,s4,0x30
  udphdr = mbufpullhdr(m, *udphdr);
    80005f00:	45a1                	li	a1,8
    80005f02:	8526                	mv	a0,s1
    80005f04:	00000097          	auipc	ra,0x0
    80005f08:	be2080e7          	jalr	-1054(ra) # 80005ae6 <mbufpull>
    80005f0c:	8aaa                	mv	s5,a0
  if (!udphdr)
    80005f0e:	c51d                	beqz	a0,80005f3c <net_rx+0x154>
    80005f10:	00455783          	lhu	a5,4(a0)
    80005f14:	0087971b          	slliw	a4,a5,0x8
    80005f18:	83a1                	srli	a5,a5,0x8
    80005f1a:	8fd9                	or	a5,a5,a4
  if (ntohs(udphdr->ulen) != len)
    80005f1c:	2a01                	sext.w	s4,s4
    80005f1e:	17c2                	slli	a5,a5,0x30
    80005f20:	93c1                	srli	a5,a5,0x30
    80005f22:	00fa1d63          	bne	s4,a5,80005f3c <net_rx+0x154>
  len -= sizeof(*udphdr);
    80005f26:	fe49879b          	addiw	a5,s3,-28
  if (len > m->len)
    80005f2a:	0107979b          	slliw	a5,a5,0x10
    80005f2e:	0107d79b          	srliw	a5,a5,0x10
    80005f32:	0007871b          	sext.w	a4,a5
    80005f36:	488c                	lw	a1,16(s1)
    80005f38:	00e5f863          	bgeu	a1,a4,80005f48 <net_rx+0x160>
  kfree(m);
    80005f3c:	8526                	mv	a0,s1
    80005f3e:	ffffa097          	auipc	ra,0xffffa
    80005f42:	0de080e7          	jalr	222(ra) # 8000001c <kfree>
}
    80005f46:	bddd                	j	80005e3c <net_rx+0x54>
  mbuftrim(m, m->len - len);
    80005f48:	9d9d                	subw	a1,a1,a5
    80005f4a:	8526                	mv	a0,s1
    80005f4c:	00000097          	auipc	ra,0x0
    80005f50:	ca8080e7          	jalr	-856(ra) # 80005bf4 <mbuftrim>
  sip = ntohl(iphdr->ip_src);
    80005f54:	00c92783          	lw	a5,12(s2)
    80005f58:	000ad703          	lhu	a4,0(s5)
    80005f5c:	0087169b          	slliw	a3,a4,0x8
    80005f60:	8321                	srli	a4,a4,0x8
    80005f62:	8ed9                	or	a3,a3,a4
    80005f64:	002ad703          	lhu	a4,2(s5)
    80005f68:	0087161b          	slliw	a2,a4,0x8
    80005f6c:	8321                	srli	a4,a4,0x8
    80005f6e:	8e59                	or	a2,a2,a4
  return (((val & 0x000000ffUL) << 24) |
    80005f70:	0187959b          	slliw	a1,a5,0x18
          ((val & 0xff000000UL) >> 24));
    80005f74:	0187d71b          	srliw	a4,a5,0x18
          ((val & 0x00ff0000UL) >> 8) |
    80005f78:	8dd9                	or	a1,a1,a4
          ((val & 0x0000ff00UL) << 8) |
    80005f7a:	0087971b          	slliw	a4,a5,0x8
    80005f7e:	00ff0537          	lui	a0,0xff0
    80005f82:	8f69                	and	a4,a4,a0
          ((val & 0x00ff0000UL) >> 8) |
    80005f84:	8dd9                	or	a1,a1,a4
    80005f86:	0087d79b          	srliw	a5,a5,0x8
    80005f8a:	6741                	lui	a4,0x10
    80005f8c:	f0070713          	addi	a4,a4,-256 # ff00 <_entry-0x7fff0100>
    80005f90:	8ff9                	and	a5,a5,a4
    80005f92:	8ddd                	or	a1,a1,a5
  sockrecvudp(m, sip, dport, sport);
    80005f94:	16c2                	slli	a3,a3,0x30
    80005f96:	92c1                	srli	a3,a3,0x30
    80005f98:	1642                	slli	a2,a2,0x30
    80005f9a:	9241                	srli	a2,a2,0x30
    80005f9c:	2581                	sext.w	a1,a1
    80005f9e:	8526                	mv	a0,s1
    80005fa0:	00000097          	auipc	ra,0x0
    80005fa4:	55e080e7          	jalr	1374(ra) # 800064fe <sockrecvudp>
  return;
    80005fa8:	bd51                	j	80005e3c <net_rx+0x54>
  arphdr = mbufpullhdr(m, *arphdr);
    80005faa:	45f1                	li	a1,28
    80005fac:	8526                	mv	a0,s1
    80005fae:	00000097          	auipc	ra,0x0
    80005fb2:	b38080e7          	jalr	-1224(ra) # 80005ae6 <mbufpull>
    80005fb6:	892a                	mv	s2,a0
  if (!arphdr)
    80005fb8:	c179                	beqz	a0,8000607e <net_rx+0x296>
  if (ntohs(arphdr->hrd) != ARP_HRD_ETHER ||
    80005fba:	00054703          	lbu	a4,0(a0) # ff0000 <_entry-0x7f010000>
    80005fbe:	00154783          	lbu	a5,1(a0)
    80005fc2:	07a2                	slli	a5,a5,0x8
    80005fc4:	8fd9                	or	a5,a5,a4
  return (((val & 0x00ffU) << 8) |
    80005fc6:	0087971b          	slliw	a4,a5,0x8
    80005fca:	83a1                	srli	a5,a5,0x8
    80005fcc:	8fd9                	or	a5,a5,a4
    80005fce:	17c2                	slli	a5,a5,0x30
    80005fd0:	93c1                	srli	a5,a5,0x30
    80005fd2:	4705                	li	a4,1
    80005fd4:	0ae79563          	bne	a5,a4,8000607e <net_rx+0x296>
      ntohs(arphdr->pro) != ETHTYPE_IP ||
    80005fd8:	00254703          	lbu	a4,2(a0)
    80005fdc:	00354783          	lbu	a5,3(a0)
    80005fe0:	07a2                	slli	a5,a5,0x8
    80005fe2:	8fd9                	or	a5,a5,a4
    80005fe4:	0087971b          	slliw	a4,a5,0x8
    80005fe8:	83a1                	srli	a5,a5,0x8
    80005fea:	8fd9                	or	a5,a5,a4
  if (ntohs(arphdr->hrd) != ARP_HRD_ETHER ||
    80005fec:	0107979b          	slliw	a5,a5,0x10
    80005ff0:	0107d79b          	srliw	a5,a5,0x10
    80005ff4:	8007879b          	addiw	a5,a5,-2048
    80005ff8:	e3d9                	bnez	a5,8000607e <net_rx+0x296>
      ntohs(arphdr->pro) != ETHTYPE_IP ||
    80005ffa:	00454703          	lbu	a4,4(a0)
    80005ffe:	4799                	li	a5,6
    80006000:	06f71f63          	bne	a4,a5,8000607e <net_rx+0x296>
      arphdr->hln != ETHADDR_LEN ||
    80006004:	00554703          	lbu	a4,5(a0)
    80006008:	4791                	li	a5,4
    8000600a:	06f71a63          	bne	a4,a5,8000607e <net_rx+0x296>
  if (ntohs(arphdr->op) != ARP_OP_REQUEST || tip != local_ip)
    8000600e:	00654703          	lbu	a4,6(a0)
    80006012:	00754783          	lbu	a5,7(a0)
    80006016:	07a2                	slli	a5,a5,0x8
    80006018:	8fd9                	or	a5,a5,a4
    8000601a:	0087971b          	slliw	a4,a5,0x8
    8000601e:	83a1                	srli	a5,a5,0x8
    80006020:	8fd9                	or	a5,a5,a4
    80006022:	17c2                	slli	a5,a5,0x30
    80006024:	93c1                	srli	a5,a5,0x30
    80006026:	4705                	li	a4,1
    80006028:	04e79b63          	bne	a5,a4,8000607e <net_rx+0x296>
  tip = ntohl(arphdr->tip); // target IP address
    8000602c:	01854703          	lbu	a4,24(a0)
    80006030:	01954783          	lbu	a5,25(a0)
    80006034:	07a2                	slli	a5,a5,0x8
    80006036:	8fd9                	or	a5,a5,a4
    80006038:	01a54703          	lbu	a4,26(a0)
    8000603c:	0742                	slli	a4,a4,0x10
    8000603e:	8f5d                	or	a4,a4,a5
    80006040:	01b54783          	lbu	a5,27(a0)
    80006044:	07e2                	slli	a5,a5,0x18
    80006046:	8fd9                	or	a5,a5,a4
    80006048:	0007871b          	sext.w	a4,a5
  return (((val & 0x000000ffUL) << 24) |
    8000604c:	0187979b          	slliw	a5,a5,0x18
          ((val & 0xff000000UL) >> 24));
    80006050:	0187569b          	srliw	a3,a4,0x18
          ((val & 0x00ff0000UL) >> 8) |
    80006054:	8fd5                	or	a5,a5,a3
          ((val & 0x0000ff00UL) << 8) |
    80006056:	0087169b          	slliw	a3,a4,0x8
    8000605a:	00ff0637          	lui	a2,0xff0
    8000605e:	8ef1                	and	a3,a3,a2
          ((val & 0x00ff0000UL) >> 8) |
    80006060:	8fd5                	or	a5,a5,a3
    80006062:	0087571b          	srliw	a4,a4,0x8
    80006066:	66c1                	lui	a3,0x10
    80006068:	f0068693          	addi	a3,a3,-256 # ff00 <_entry-0x7fff0100>
    8000606c:	8f75                	and	a4,a4,a3
    8000606e:	8fd9                	or	a5,a5,a4
  if (ntohs(arphdr->op) != ARP_OP_REQUEST || tip != local_ip)
    80006070:	2781                	sext.w	a5,a5
    80006072:	0a000737          	lui	a4,0xa000
    80006076:	20f70713          	addi	a4,a4,527 # a00020f <_entry-0x75fffdf1>
    8000607a:	00e78863          	beq	a5,a4,8000608a <net_rx+0x2a2>
  kfree(m);
    8000607e:	8526                	mv	a0,s1
    80006080:	ffffa097          	auipc	ra,0xffffa
    80006084:	f9c080e7          	jalr	-100(ra) # 8000001c <kfree>
}
    80006088:	bb55                	j	80005e3c <net_rx+0x54>
  memmove(smac, arphdr->sha, ETHADDR_LEN); // sender's ethernet address
    8000608a:	4619                	li	a2,6
    8000608c:	00850593          	addi	a1,a0,8
    80006090:	fb840513          	addi	a0,s0,-72
    80006094:	ffffa097          	auipc	ra,0xffffa
    80006098:	142080e7          	jalr	322(ra) # 800001d6 <memmove>
  sip = ntohl(arphdr->sip); // sender's IP address (qemu's slirp)
    8000609c:	00e94703          	lbu	a4,14(s2)
    800060a0:	00f94783          	lbu	a5,15(s2)
    800060a4:	07a2                	slli	a5,a5,0x8
    800060a6:	8fd9                	or	a5,a5,a4
    800060a8:	01094703          	lbu	a4,16(s2)
    800060ac:	0742                	slli	a4,a4,0x10
    800060ae:	8f5d                	or	a4,a4,a5
    800060b0:	01194783          	lbu	a5,17(s2)
    800060b4:	07e2                	slli	a5,a5,0x18
    800060b6:	8fd9                	or	a5,a5,a4
    800060b8:	0007871b          	sext.w	a4,a5
  return (((val & 0x000000ffUL) << 24) |
    800060bc:	0187991b          	slliw	s2,a5,0x18
          ((val & 0xff000000UL) >> 24));
    800060c0:	0187579b          	srliw	a5,a4,0x18
          ((val & 0x00ff0000UL) >> 8) |
    800060c4:	00f96933          	or	s2,s2,a5
          ((val & 0x0000ff00UL) << 8) |
    800060c8:	0087179b          	slliw	a5,a4,0x8
    800060cc:	00ff06b7          	lui	a3,0xff0
    800060d0:	8ff5                	and	a5,a5,a3
          ((val & 0x00ff0000UL) >> 8) |
    800060d2:	00f96933          	or	s2,s2,a5
    800060d6:	0087579b          	srliw	a5,a4,0x8
    800060da:	6741                	lui	a4,0x10
    800060dc:	f0070713          	addi	a4,a4,-256 # ff00 <_entry-0x7fff0100>
    800060e0:	8ff9                	and	a5,a5,a4
    800060e2:	00f96933          	or	s2,s2,a5
    800060e6:	2901                	sext.w	s2,s2
  m = mbufalloc(MBUF_DEFAULT_HEADROOM);
    800060e8:	08000513          	li	a0,128
    800060ec:	00000097          	auipc	ra,0x0
    800060f0:	b2a080e7          	jalr	-1238(ra) # 80005c16 <mbufalloc>
    800060f4:	8a2a                	mv	s4,a0
  if (!m)
    800060f6:	d541                	beqz	a0,8000607e <net_rx+0x296>
  arphdr = mbufputhdr(m, *arphdr);
    800060f8:	45f1                	li	a1,28
    800060fa:	00000097          	auipc	ra,0x0
    800060fe:	ac0080e7          	jalr	-1344(ra) # 80005bba <mbufput>
    80006102:	89aa                	mv	s3,a0
  arphdr->hrd = htons(ARP_HRD_ETHER);
    80006104:	00050023          	sb	zero,0(a0)
    80006108:	4785                	li	a5,1
    8000610a:	00f500a3          	sb	a5,1(a0)
  arphdr->pro = htons(ETHTYPE_IP);
    8000610e:	47a1                	li	a5,8
    80006110:	00f50123          	sb	a5,2(a0)
    80006114:	000501a3          	sb	zero,3(a0)
  arphdr->hln = ETHADDR_LEN;
    80006118:	4799                	li	a5,6
    8000611a:	00f50223          	sb	a5,4(a0)
  arphdr->pln = sizeof(uint32);
    8000611e:	4791                	li	a5,4
    80006120:	00f502a3          	sb	a5,5(a0)
  arphdr->op = htons(op);
    80006124:	00050323          	sb	zero,6(a0)
    80006128:	4a89                	li	s5,2
    8000612a:	015503a3          	sb	s5,7(a0)
  memmove(arphdr->sha, local_mac, ETHADDR_LEN);
    8000612e:	4619                	li	a2,6
    80006130:	00003597          	auipc	a1,0x3
    80006134:	77058593          	addi	a1,a1,1904 # 800098a0 <local_mac>
    80006138:	0521                	addi	a0,a0,8
    8000613a:	ffffa097          	auipc	ra,0xffffa
    8000613e:	09c080e7          	jalr	156(ra) # 800001d6 <memmove>
  arphdr->sip = htonl(local_ip);
    80006142:	47a9                	li	a5,10
    80006144:	00f98723          	sb	a5,14(s3)
    80006148:	000987a3          	sb	zero,15(s3)
    8000614c:	01598823          	sb	s5,16(s3)
    80006150:	47bd                	li	a5,15
    80006152:	00f988a3          	sb	a5,17(s3)
  memmove(arphdr->tha, dmac, ETHADDR_LEN);
    80006156:	4619                	li	a2,6
    80006158:	fb840593          	addi	a1,s0,-72
    8000615c:	01298513          	addi	a0,s3,18
    80006160:	ffffa097          	auipc	ra,0xffffa
    80006164:	076080e7          	jalr	118(ra) # 800001d6 <memmove>
  return (((val & 0x000000ffUL) << 24) |
    80006168:	0189171b          	slliw	a4,s2,0x18
          ((val & 0xff000000UL) >> 24));
    8000616c:	0189579b          	srliw	a5,s2,0x18
          ((val & 0x00ff0000UL) >> 8) |
    80006170:	8f5d                	or	a4,a4,a5
          ((val & 0x0000ff00UL) << 8) |
    80006172:	0089179b          	slliw	a5,s2,0x8
    80006176:	00ff06b7          	lui	a3,0xff0
    8000617a:	8ff5                	and	a5,a5,a3
          ((val & 0x00ff0000UL) >> 8) |
    8000617c:	8f5d                	or	a4,a4,a5
    8000617e:	0089579b          	srliw	a5,s2,0x8
    80006182:	66c1                	lui	a3,0x10
    80006184:	f0068693          	addi	a3,a3,-256 # ff00 <_entry-0x7fff0100>
    80006188:	8ff5                	and	a5,a5,a3
    8000618a:	8fd9                	or	a5,a5,a4
  arphdr->tip = htonl(dip);
    8000618c:	00e98c23          	sb	a4,24(s3)
    80006190:	0087d71b          	srliw	a4,a5,0x8
    80006194:	00e98ca3          	sb	a4,25(s3)
    80006198:	0107d71b          	srliw	a4,a5,0x10
    8000619c:	00e98d23          	sb	a4,26(s3)
    800061a0:	0187d79b          	srliw	a5,a5,0x18
    800061a4:	00f98da3          	sb	a5,27(s3)
  net_tx_eth(m, ETHTYPE_ARP);
    800061a8:	6585                	lui	a1,0x1
    800061aa:	80658593          	addi	a1,a1,-2042 # 806 <_entry-0x7ffff7fa>
    800061ae:	8552                	mv	a0,s4
    800061b0:	00000097          	auipc	ra,0x0
    800061b4:	992080e7          	jalr	-1646(ra) # 80005b42 <net_tx_eth>
  return 0;
    800061b8:	b5d9                	j	8000607e <net_rx+0x296>

00000000800061ba <sockinit>:
static struct spinlock lock;
static struct sock *sockets;

void
sockinit(void)
{
    800061ba:	1141                	addi	sp,sp,-16
    800061bc:	e406                	sd	ra,8(sp)
    800061be:	e022                	sd	s0,0(sp)
    800061c0:	0800                	addi	s0,sp,16
  initlock(&lock, "socktbl");
    800061c2:	00003597          	auipc	a1,0x3
    800061c6:	63e58593          	addi	a1,a1,1598 # 80009800 <syscalls+0x428>
    800061ca:	00019517          	auipc	a0,0x19
    800061ce:	15650513          	addi	a0,a0,342 # 8001f320 <lock>
    800061d2:	00001097          	auipc	ra,0x1
    800061d6:	e46080e7          	jalr	-442(ra) # 80007018 <initlock>
}
    800061da:	60a2                	ld	ra,8(sp)
    800061dc:	6402                	ld	s0,0(sp)
    800061de:	0141                	addi	sp,sp,16
    800061e0:	8082                	ret

00000000800061e2 <sockalloc>:

int
sockalloc(struct file **f, uint32 raddr, uint16 lport, uint16 rport)
{
    800061e2:	7139                	addi	sp,sp,-64
    800061e4:	fc06                	sd	ra,56(sp)
    800061e6:	f822                	sd	s0,48(sp)
    800061e8:	f426                	sd	s1,40(sp)
    800061ea:	f04a                	sd	s2,32(sp)
    800061ec:	ec4e                	sd	s3,24(sp)
    800061ee:	e852                	sd	s4,16(sp)
    800061f0:	e456                	sd	s5,8(sp)
    800061f2:	0080                	addi	s0,sp,64
    800061f4:	892a                	mv	s2,a0
    800061f6:	84ae                	mv	s1,a1
    800061f8:	8a32                	mv	s4,a2
    800061fa:	89b6                	mv	s3,a3
  struct sock *si, *pos;

  si = 0;
  *f = 0;
    800061fc:	00053023          	sd	zero,0(a0)
  if ((*f = filealloc()) == 0)
    80006200:	ffffd097          	auipc	ra,0xffffd
    80006204:	6dc080e7          	jalr	1756(ra) # 800038dc <filealloc>
    80006208:	00a93023          	sd	a0,0(s2)
    8000620c:	c975                	beqz	a0,80006300 <sockalloc+0x11e>
    goto bad;
  if ((si = (struct sock*)kalloc()) == 0)
    8000620e:	ffffa097          	auipc	ra,0xffffa
    80006212:	f0c080e7          	jalr	-244(ra) # 8000011a <kalloc>
    80006216:	8aaa                	mv	s5,a0
    80006218:	c15d                	beqz	a0,800062be <sockalloc+0xdc>
    goto bad;

  // initialize objects
  si->raddr = raddr;
    8000621a:	c504                	sw	s1,8(a0)
  si->lport = lport;
    8000621c:	01451623          	sh	s4,12(a0)
  si->rport = rport;
    80006220:	01351723          	sh	s3,14(a0)
  initlock(&si->lock, "sock");
    80006224:	00003597          	auipc	a1,0x3
    80006228:	5e458593          	addi	a1,a1,1508 # 80009808 <syscalls+0x430>
    8000622c:	0541                	addi	a0,a0,16
    8000622e:	00001097          	auipc	ra,0x1
    80006232:	dea080e7          	jalr	-534(ra) # 80007018 <initlock>
  mbufq_init(&si->rxq);
    80006236:	028a8513          	addi	a0,s5,40
    8000623a:	00000097          	auipc	ra,0x0
    8000623e:	a94080e7          	jalr	-1388(ra) # 80005cce <mbufq_init>
  (*f)->type = FD_SOCK;
    80006242:	00093783          	ld	a5,0(s2)
    80006246:	4711                	li	a4,4
    80006248:	c398                	sw	a4,0(a5)
  (*f)->readable = 1;
    8000624a:	00093703          	ld	a4,0(s2)
    8000624e:	4785                	li	a5,1
    80006250:	00f70423          	sb	a5,8(a4)
  (*f)->writable = 1;
    80006254:	00093703          	ld	a4,0(s2)
    80006258:	00f704a3          	sb	a5,9(a4)
  (*f)->sock = si;
    8000625c:	00093783          	ld	a5,0(s2)
    80006260:	0357b023          	sd	s5,32(a5)

  // add to list of sockets
  acquire(&lock);
    80006264:	00019517          	auipc	a0,0x19
    80006268:	0bc50513          	addi	a0,a0,188 # 8001f320 <lock>
    8000626c:	00001097          	auipc	ra,0x1
    80006270:	e3c080e7          	jalr	-452(ra) # 800070a8 <acquire>
  pos = sockets;
    80006274:	00004597          	auipc	a1,0x4
    80006278:	db45b583          	ld	a1,-588(a1) # 8000a028 <sockets>
  while (pos) {
    8000627c:	c9b1                	beqz	a1,800062d0 <sockalloc+0xee>
  pos = sockets;
    8000627e:	87ae                	mv	a5,a1
    if (pos->raddr == raddr &&
    80006280:	000a061b          	sext.w	a2,s4
        pos->lport == lport &&
    80006284:	0009869b          	sext.w	a3,s3
    80006288:	a019                	j	8000628e <sockalloc+0xac>
	pos->rport == rport) {
      release(&lock);
      goto bad;
    }
    pos = pos->next;
    8000628a:	639c                	ld	a5,0(a5)
  while (pos) {
    8000628c:	c3b1                	beqz	a5,800062d0 <sockalloc+0xee>
    if (pos->raddr == raddr &&
    8000628e:	4798                	lw	a4,8(a5)
    80006290:	fe971de3          	bne	a4,s1,8000628a <sockalloc+0xa8>
    80006294:	00c7d703          	lhu	a4,12(a5)
    80006298:	fec719e3          	bne	a4,a2,8000628a <sockalloc+0xa8>
        pos->lport == lport &&
    8000629c:	00e7d703          	lhu	a4,14(a5)
    800062a0:	fed715e3          	bne	a4,a3,8000628a <sockalloc+0xa8>
      release(&lock);
    800062a4:	00019517          	auipc	a0,0x19
    800062a8:	07c50513          	addi	a0,a0,124 # 8001f320 <lock>
    800062ac:	00001097          	auipc	ra,0x1
    800062b0:	eb0080e7          	jalr	-336(ra) # 8000715c <release>
  release(&lock);
  return 0;

bad:
  if (si)
    kfree((char*)si);
    800062b4:	8556                	mv	a0,s5
    800062b6:	ffffa097          	auipc	ra,0xffffa
    800062ba:	d66080e7          	jalr	-666(ra) # 8000001c <kfree>
  if (*f)
    800062be:	00093503          	ld	a0,0(s2)
    800062c2:	c129                	beqz	a0,80006304 <sockalloc+0x122>
    fileclose(*f);
    800062c4:	ffffd097          	auipc	ra,0xffffd
    800062c8:	6d4080e7          	jalr	1748(ra) # 80003998 <fileclose>
  return -1;
    800062cc:	557d                	li	a0,-1
    800062ce:	a005                	j	800062ee <sockalloc+0x10c>
  si->next = sockets;
    800062d0:	00bab023          	sd	a1,0(s5)
  sockets = si;
    800062d4:	00004797          	auipc	a5,0x4
    800062d8:	d557ba23          	sd	s5,-684(a5) # 8000a028 <sockets>
  release(&lock);
    800062dc:	00019517          	auipc	a0,0x19
    800062e0:	04450513          	addi	a0,a0,68 # 8001f320 <lock>
    800062e4:	00001097          	auipc	ra,0x1
    800062e8:	e78080e7          	jalr	-392(ra) # 8000715c <release>
  return 0;
    800062ec:	4501                	li	a0,0
}
    800062ee:	70e2                	ld	ra,56(sp)
    800062f0:	7442                	ld	s0,48(sp)
    800062f2:	74a2                	ld	s1,40(sp)
    800062f4:	7902                	ld	s2,32(sp)
    800062f6:	69e2                	ld	s3,24(sp)
    800062f8:	6a42                	ld	s4,16(sp)
    800062fa:	6aa2                	ld	s5,8(sp)
    800062fc:	6121                	addi	sp,sp,64
    800062fe:	8082                	ret
  return -1;
    80006300:	557d                	li	a0,-1
    80006302:	b7f5                	j	800062ee <sockalloc+0x10c>
    80006304:	557d                	li	a0,-1
    80006306:	b7e5                	j	800062ee <sockalloc+0x10c>

0000000080006308 <sockclose>:

void
sockclose(struct sock *si)
{
    80006308:	1101                	addi	sp,sp,-32
    8000630a:	ec06                	sd	ra,24(sp)
    8000630c:	e822                	sd	s0,16(sp)
    8000630e:	e426                	sd	s1,8(sp)
    80006310:	e04a                	sd	s2,0(sp)
    80006312:	1000                	addi	s0,sp,32
    80006314:	892a                	mv	s2,a0
  struct sock **pos;
  struct mbuf *m;

  // remove from list of sockets
  acquire(&lock);
    80006316:	00019517          	auipc	a0,0x19
    8000631a:	00a50513          	addi	a0,a0,10 # 8001f320 <lock>
    8000631e:	00001097          	auipc	ra,0x1
    80006322:	d8a080e7          	jalr	-630(ra) # 800070a8 <acquire>
  pos = &sockets;
    80006326:	00004797          	auipc	a5,0x4
    8000632a:	d027b783          	ld	a5,-766(a5) # 8000a028 <sockets>
  while (*pos) {
    8000632e:	cb99                	beqz	a5,80006344 <sockclose+0x3c>
    if (*pos == si){
    80006330:	04f90463          	beq	s2,a5,80006378 <sockclose+0x70>
      *pos = si->next;
      break;
    }
    pos = &(*pos)->next;
    80006334:	873e                	mv	a4,a5
    80006336:	639c                	ld	a5,0(a5)
  while (*pos) {
    80006338:	c791                	beqz	a5,80006344 <sockclose+0x3c>
    if (*pos == si){
    8000633a:	fef91de3          	bne	s2,a5,80006334 <sockclose+0x2c>
      *pos = si->next;
    8000633e:	00093783          	ld	a5,0(s2)
    80006342:	e31c                	sd	a5,0(a4)
  }
  release(&lock);
    80006344:	00019517          	auipc	a0,0x19
    80006348:	fdc50513          	addi	a0,a0,-36 # 8001f320 <lock>
    8000634c:	00001097          	auipc	ra,0x1
    80006350:	e10080e7          	jalr	-496(ra) # 8000715c <release>

  // free any pending mbufs
  while (!mbufq_empty(&si->rxq)) {
    80006354:	02890493          	addi	s1,s2,40
    80006358:	8526                	mv	a0,s1
    8000635a:	00000097          	auipc	ra,0x0
    8000635e:	962080e7          	jalr	-1694(ra) # 80005cbc <mbufq_empty>
    80006362:	e105                	bnez	a0,80006382 <sockclose+0x7a>
    m = mbufq_pophead(&si->rxq);
    80006364:	8526                	mv	a0,s1
    80006366:	00000097          	auipc	ra,0x0
    8000636a:	940080e7          	jalr	-1728(ra) # 80005ca6 <mbufq_pophead>
    mbuffree(m);
    8000636e:	00000097          	auipc	ra,0x0
    80006372:	900080e7          	jalr	-1792(ra) # 80005c6e <mbuffree>
    80006376:	b7cd                	j	80006358 <sockclose+0x50>
  pos = &sockets;
    80006378:	00004717          	auipc	a4,0x4
    8000637c:	cb070713          	addi	a4,a4,-848 # 8000a028 <sockets>
    80006380:	bf7d                	j	8000633e <sockclose+0x36>
  }

  kfree((char*)si);
    80006382:	854a                	mv	a0,s2
    80006384:	ffffa097          	auipc	ra,0xffffa
    80006388:	c98080e7          	jalr	-872(ra) # 8000001c <kfree>
}
    8000638c:	60e2                	ld	ra,24(sp)
    8000638e:	6442                	ld	s0,16(sp)
    80006390:	64a2                	ld	s1,8(sp)
    80006392:	6902                	ld	s2,0(sp)
    80006394:	6105                	addi	sp,sp,32
    80006396:	8082                	ret

0000000080006398 <sockread>:

int
sockread(struct sock *si, uint64 addr, int n)
{
    80006398:	7139                	addi	sp,sp,-64
    8000639a:	fc06                	sd	ra,56(sp)
    8000639c:	f822                	sd	s0,48(sp)
    8000639e:	f426                	sd	s1,40(sp)
    800063a0:	f04a                	sd	s2,32(sp)
    800063a2:	ec4e                	sd	s3,24(sp)
    800063a4:	e852                	sd	s4,16(sp)
    800063a6:	e456                	sd	s5,8(sp)
    800063a8:	0080                	addi	s0,sp,64
    800063aa:	84aa                	mv	s1,a0
    800063ac:	8a2e                	mv	s4,a1
    800063ae:	8ab2                	mv	s5,a2
  struct proc *pr = myproc();
    800063b0:	ffffb097          	auipc	ra,0xffffb
    800063b4:	aec080e7          	jalr	-1300(ra) # 80000e9c <myproc>
    800063b8:	892a                	mv	s2,a0
  struct mbuf *m;
  int len;

  acquire(&si->lock);
    800063ba:	01048993          	addi	s3,s1,16
    800063be:	854e                	mv	a0,s3
    800063c0:	00001097          	auipc	ra,0x1
    800063c4:	ce8080e7          	jalr	-792(ra) # 800070a8 <acquire>
  while (mbufq_empty(&si->rxq) && !pr->killed) {
    800063c8:	02848493          	addi	s1,s1,40
    800063cc:	a039                	j	800063da <sockread+0x42>
    sleep(&si->rxq, &si->lock);
    800063ce:	85ce                	mv	a1,s3
    800063d0:	8526                	mv	a0,s1
    800063d2:	ffffb097          	auipc	ra,0xffffb
    800063d6:	18e080e7          	jalr	398(ra) # 80001560 <sleep>
  while (mbufq_empty(&si->rxq) && !pr->killed) {
    800063da:	8526                	mv	a0,s1
    800063dc:	00000097          	auipc	ra,0x0
    800063e0:	8e0080e7          	jalr	-1824(ra) # 80005cbc <mbufq_empty>
    800063e4:	c919                	beqz	a0,800063fa <sockread+0x62>
    800063e6:	02892783          	lw	a5,40(s2)
    800063ea:	d3f5                	beqz	a5,800063ce <sockread+0x36>
  }
  if (pr->killed) {
    release(&si->lock);
    800063ec:	854e                	mv	a0,s3
    800063ee:	00001097          	auipc	ra,0x1
    800063f2:	d6e080e7          	jalr	-658(ra) # 8000715c <release>
    return -1;
    800063f6:	59fd                	li	s3,-1
    800063f8:	a881                	j	80006448 <sockread+0xb0>
  if (pr->killed) {
    800063fa:	02892783          	lw	a5,40(s2)
    800063fe:	f7fd                	bnez	a5,800063ec <sockread+0x54>
  }
  m = mbufq_pophead(&si->rxq);
    80006400:	8526                	mv	a0,s1
    80006402:	00000097          	auipc	ra,0x0
    80006406:	8a4080e7          	jalr	-1884(ra) # 80005ca6 <mbufq_pophead>
    8000640a:	84aa                	mv	s1,a0
  release(&si->lock);
    8000640c:	854e                	mv	a0,s3
    8000640e:	00001097          	auipc	ra,0x1
    80006412:	d4e080e7          	jalr	-690(ra) # 8000715c <release>

  len = m->len;
  if (len > n)
    80006416:	489c                	lw	a5,16(s1)
    80006418:	89be                	mv	s3,a5
    8000641a:	2781                	sext.w	a5,a5
    8000641c:	00fad363          	bge	s5,a5,80006422 <sockread+0x8a>
    80006420:	89d6                	mv	s3,s5
    80006422:	2981                	sext.w	s3,s3
    len = n;
  if (copyout(pr->pagetable, addr, m->head, len) == -1) {
    80006424:	86ce                	mv	a3,s3
    80006426:	6490                	ld	a2,8(s1)
    80006428:	85d2                	mv	a1,s4
    8000642a:	05093503          	ld	a0,80(s2)
    8000642e:	ffffa097          	auipc	ra,0xffffa
    80006432:	736080e7          	jalr	1846(ra) # 80000b64 <copyout>
    80006436:	892a                	mv	s2,a0
    80006438:	57fd                	li	a5,-1
    8000643a:	02f50163          	beq	a0,a5,8000645c <sockread+0xc4>
    mbuffree(m);
    return -1;
  }
  mbuffree(m);
    8000643e:	8526                	mv	a0,s1
    80006440:	00000097          	auipc	ra,0x0
    80006444:	82e080e7          	jalr	-2002(ra) # 80005c6e <mbuffree>
  return len;
}
    80006448:	854e                	mv	a0,s3
    8000644a:	70e2                	ld	ra,56(sp)
    8000644c:	7442                	ld	s0,48(sp)
    8000644e:	74a2                	ld	s1,40(sp)
    80006450:	7902                	ld	s2,32(sp)
    80006452:	69e2                	ld	s3,24(sp)
    80006454:	6a42                	ld	s4,16(sp)
    80006456:	6aa2                	ld	s5,8(sp)
    80006458:	6121                	addi	sp,sp,64
    8000645a:	8082                	ret
    mbuffree(m);
    8000645c:	8526                	mv	a0,s1
    8000645e:	00000097          	auipc	ra,0x0
    80006462:	810080e7          	jalr	-2032(ra) # 80005c6e <mbuffree>
    return -1;
    80006466:	89ca                	mv	s3,s2
    80006468:	b7c5                	j	80006448 <sockread+0xb0>

000000008000646a <sockwrite>:

int
sockwrite(struct sock *si, uint64 addr, int n)
{
    8000646a:	7139                	addi	sp,sp,-64
    8000646c:	fc06                	sd	ra,56(sp)
    8000646e:	f822                	sd	s0,48(sp)
    80006470:	f426                	sd	s1,40(sp)
    80006472:	f04a                	sd	s2,32(sp)
    80006474:	ec4e                	sd	s3,24(sp)
    80006476:	e852                	sd	s4,16(sp)
    80006478:	e456                	sd	s5,8(sp)
    8000647a:	0080                	addi	s0,sp,64
    8000647c:	8aaa                	mv	s5,a0
    8000647e:	89ae                	mv	s3,a1
    80006480:	8932                	mv	s2,a2
  struct proc *pr = myproc();
    80006482:	ffffb097          	auipc	ra,0xffffb
    80006486:	a1a080e7          	jalr	-1510(ra) # 80000e9c <myproc>
    8000648a:	8a2a                	mv	s4,a0
  struct mbuf *m;

  m = mbufalloc(MBUF_DEFAULT_HEADROOM);
    8000648c:	08000513          	li	a0,128
    80006490:	fffff097          	auipc	ra,0xfffff
    80006494:	786080e7          	jalr	1926(ra) # 80005c16 <mbufalloc>
  if (!m)
    80006498:	c12d                	beqz	a0,800064fa <sockwrite+0x90>
    8000649a:	84aa                	mv	s1,a0
    return -1;

  if (copyin(pr->pagetable, mbufput(m, n), addr, n) == -1) {
    8000649c:	050a3a03          	ld	s4,80(s4)
    800064a0:	85ca                	mv	a1,s2
    800064a2:	fffff097          	auipc	ra,0xfffff
    800064a6:	718080e7          	jalr	1816(ra) # 80005bba <mbufput>
    800064aa:	85aa                	mv	a1,a0
    800064ac:	86ca                	mv	a3,s2
    800064ae:	864e                	mv	a2,s3
    800064b0:	8552                	mv	a0,s4
    800064b2:	ffffa097          	auipc	ra,0xffffa
    800064b6:	73e080e7          	jalr	1854(ra) # 80000bf0 <copyin>
    800064ba:	89aa                	mv	s3,a0
    800064bc:	57fd                	li	a5,-1
    800064be:	02f50863          	beq	a0,a5,800064ee <sockwrite+0x84>
    mbuffree(m);
    return -1;
  }
  net_tx_udp(m, si->raddr, si->lport, si->rport);
    800064c2:	00ead683          	lhu	a3,14(s5)
    800064c6:	00cad603          	lhu	a2,12(s5)
    800064ca:	008aa583          	lw	a1,8(s5)
    800064ce:	8526                	mv	a0,s1
    800064d0:	00000097          	auipc	ra,0x0
    800064d4:	80e080e7          	jalr	-2034(ra) # 80005cde <net_tx_udp>
  return n;
    800064d8:	89ca                	mv	s3,s2
}
    800064da:	854e                	mv	a0,s3
    800064dc:	70e2                	ld	ra,56(sp)
    800064de:	7442                	ld	s0,48(sp)
    800064e0:	74a2                	ld	s1,40(sp)
    800064e2:	7902                	ld	s2,32(sp)
    800064e4:	69e2                	ld	s3,24(sp)
    800064e6:	6a42                	ld	s4,16(sp)
    800064e8:	6aa2                	ld	s5,8(sp)
    800064ea:	6121                	addi	sp,sp,64
    800064ec:	8082                	ret
    mbuffree(m);
    800064ee:	8526                	mv	a0,s1
    800064f0:	fffff097          	auipc	ra,0xfffff
    800064f4:	77e080e7          	jalr	1918(ra) # 80005c6e <mbuffree>
    return -1;
    800064f8:	b7cd                	j	800064da <sockwrite+0x70>
    return -1;
    800064fa:	59fd                	li	s3,-1
    800064fc:	bff9                	j	800064da <sockwrite+0x70>

00000000800064fe <sockrecvudp>:

// called by protocol handler layer to deliver UDP packets
void
sockrecvudp(struct mbuf *m, uint32 raddr, uint16 lport, uint16 rport)
{
    800064fe:	7139                	addi	sp,sp,-64
    80006500:	fc06                	sd	ra,56(sp)
    80006502:	f822                	sd	s0,48(sp)
    80006504:	f426                	sd	s1,40(sp)
    80006506:	f04a                	sd	s2,32(sp)
    80006508:	ec4e                	sd	s3,24(sp)
    8000650a:	e852                	sd	s4,16(sp)
    8000650c:	e456                	sd	s5,8(sp)
    8000650e:	0080                	addi	s0,sp,64
    80006510:	8a2a                	mv	s4,a0
    80006512:	892e                	mv	s2,a1
    80006514:	89b2                	mv	s3,a2
    80006516:	8ab6                	mv	s5,a3
  // any sleeping reader. Free the mbuf if there are no sockets
  // registered to handle it.
  //
  struct sock *si;

  acquire(&lock);
    80006518:	00019517          	auipc	a0,0x19
    8000651c:	e0850513          	addi	a0,a0,-504 # 8001f320 <lock>
    80006520:	00001097          	auipc	ra,0x1
    80006524:	b88080e7          	jalr	-1144(ra) # 800070a8 <acquire>
  si = sockets;
    80006528:	00004497          	auipc	s1,0x4
    8000652c:	b004b483          	ld	s1,-1280(s1) # 8000a028 <sockets>
  while (si) {
    80006530:	c4ad                	beqz	s1,8000659a <sockrecvudp+0x9c>
    if (si->raddr == raddr && si->lport == lport && si->rport == rport)
    80006532:	0009871b          	sext.w	a4,s3
    80006536:	000a869b          	sext.w	a3,s5
    8000653a:	a019                	j	80006540 <sockrecvudp+0x42>
      goto found;
    si = si->next;
    8000653c:	6084                	ld	s1,0(s1)
  while (si) {
    8000653e:	ccb1                	beqz	s1,8000659a <sockrecvudp+0x9c>
    if (si->raddr == raddr && si->lport == lport && si->rport == rport)
    80006540:	449c                	lw	a5,8(s1)
    80006542:	ff279de3          	bne	a5,s2,8000653c <sockrecvudp+0x3e>
    80006546:	00c4d783          	lhu	a5,12(s1)
    8000654a:	fee799e3          	bne	a5,a4,8000653c <sockrecvudp+0x3e>
    8000654e:	00e4d783          	lhu	a5,14(s1)
    80006552:	fed795e3          	bne	a5,a3,8000653c <sockrecvudp+0x3e>
  release(&lock);
  mbuffree(m);
  return;

found:
  acquire(&si->lock);
    80006556:	01048913          	addi	s2,s1,16
    8000655a:	854a                	mv	a0,s2
    8000655c:	00001097          	auipc	ra,0x1
    80006560:	b4c080e7          	jalr	-1204(ra) # 800070a8 <acquire>
  mbufq_pushtail(&si->rxq, m);
    80006564:	02848493          	addi	s1,s1,40
    80006568:	85d2                	mv	a1,s4
    8000656a:	8526                	mv	a0,s1
    8000656c:	fffff097          	auipc	ra,0xfffff
    80006570:	71a080e7          	jalr	1818(ra) # 80005c86 <mbufq_pushtail>
  wakeup(&si->rxq);
    80006574:	8526                	mv	a0,s1
    80006576:	ffffb097          	auipc	ra,0xffffb
    8000657a:	176080e7          	jalr	374(ra) # 800016ec <wakeup>
  release(&si->lock);
    8000657e:	854a                	mv	a0,s2
    80006580:	00001097          	auipc	ra,0x1
    80006584:	bdc080e7          	jalr	-1060(ra) # 8000715c <release>
  release(&lock);
    80006588:	00019517          	auipc	a0,0x19
    8000658c:	d9850513          	addi	a0,a0,-616 # 8001f320 <lock>
    80006590:	00001097          	auipc	ra,0x1
    80006594:	bcc080e7          	jalr	-1076(ra) # 8000715c <release>
    80006598:	a831                	j	800065b4 <sockrecvudp+0xb6>
  release(&lock);
    8000659a:	00019517          	auipc	a0,0x19
    8000659e:	d8650513          	addi	a0,a0,-634 # 8001f320 <lock>
    800065a2:	00001097          	auipc	ra,0x1
    800065a6:	bba080e7          	jalr	-1094(ra) # 8000715c <release>
  mbuffree(m);
    800065aa:	8552                	mv	a0,s4
    800065ac:	fffff097          	auipc	ra,0xfffff
    800065b0:	6c2080e7          	jalr	1730(ra) # 80005c6e <mbuffree>
}
    800065b4:	70e2                	ld	ra,56(sp)
    800065b6:	7442                	ld	s0,48(sp)
    800065b8:	74a2                	ld	s1,40(sp)
    800065ba:	7902                	ld	s2,32(sp)
    800065bc:	69e2                	ld	s3,24(sp)
    800065be:	6a42                	ld	s4,16(sp)
    800065c0:	6aa2                	ld	s5,8(sp)
    800065c2:	6121                	addi	sp,sp,64
    800065c4:	8082                	ret

00000000800065c6 <pci_init>:
#include "proc.h"
#include "defs.h"

void
pci_init()
{
    800065c6:	715d                	addi	sp,sp,-80
    800065c8:	e486                	sd	ra,72(sp)
    800065ca:	e0a2                	sd	s0,64(sp)
    800065cc:	fc26                	sd	s1,56(sp)
    800065ce:	f84a                	sd	s2,48(sp)
    800065d0:	f44e                	sd	s3,40(sp)
    800065d2:	f052                	sd	s4,32(sp)
    800065d4:	ec56                	sd	s5,24(sp)
    800065d6:	e85a                	sd	s6,16(sp)
    800065d8:	e45e                	sd	s7,8(sp)
    800065da:	0880                	addi	s0,sp,80
    800065dc:	300004b7          	lui	s1,0x30000
    uint32 off = (bus << 16) | (dev << 11) | (func << 8) | (offset);
    volatile uint32 *base = ecam + off;
    uint32 id = base[0];
    
    // 100e:8086 is an e1000
    if(id == 0x100e8086){
    800065e0:	100e8937          	lui	s2,0x100e8
    800065e4:	08690913          	addi	s2,s2,134 # 100e8086 <_entry-0x6ff17f7a>
      // command and status register.
      // bit 0 : I/O access enable
      // bit 1 : memory access enable
      // bit 2 : enable mastering
      base[1] = 7;
    800065e8:	4b9d                	li	s7,7
      for(int i = 0; i < 6; i++){
        uint32 old = base[4+i];

        // writing all 1's to the BAR causes it to be
        // replaced with its size.
        base[4+i] = 0xffffffff;
    800065ea:	5afd                	li	s5,-1
        base[4+i] = old;
      }

      // tell the e1000 to reveal its registers at
      // physical address 0x40000000.
      base[4+0] = e1000_regs;
    800065ec:	40000b37          	lui	s6,0x40000
  for(int dev = 0; dev < 32; dev++){
    800065f0:	6a09                	lui	s4,0x2
    800065f2:	300409b7          	lui	s3,0x30040
    800065f6:	a819                	j	8000660c <pci_init+0x46>
      base[4+0] = e1000_regs;
    800065f8:	0166a823          	sw	s6,16(a3)

      e1000_init((uint32*)e1000_regs);
    800065fc:	855a                	mv	a0,s6
    800065fe:	fffff097          	auipc	ra,0xfffff
    80006602:	12e080e7          	jalr	302(ra) # 8000572c <e1000_init>
  for(int dev = 0; dev < 32; dev++){
    80006606:	94d2                	add	s1,s1,s4
    80006608:	03348a63          	beq	s1,s3,8000663c <pci_init+0x76>
    volatile uint32 *base = ecam + off;
    8000660c:	86a6                	mv	a3,s1
    uint32 id = base[0];
    8000660e:	409c                	lw	a5,0(s1)
    80006610:	2781                	sext.w	a5,a5
    if(id == 0x100e8086){
    80006612:	ff279ae3          	bne	a5,s2,80006606 <pci_init+0x40>
      base[1] = 7;
    80006616:	0174a223          	sw	s7,4(s1) # 30000004 <_entry-0x4ffffffc>
      __sync_synchronize();
    8000661a:	0ff0000f          	fence
      for(int i = 0; i < 6; i++){
    8000661e:	01048793          	addi	a5,s1,16
    80006622:	02848613          	addi	a2,s1,40
        uint32 old = base[4+i];
    80006626:	4398                	lw	a4,0(a5)
    80006628:	2701                	sext.w	a4,a4
        base[4+i] = 0xffffffff;
    8000662a:	0157a023          	sw	s5,0(a5)
        __sync_synchronize();
    8000662e:	0ff0000f          	fence
        base[4+i] = old;
    80006632:	c398                	sw	a4,0(a5)
      for(int i = 0; i < 6; i++){
    80006634:	0791                	addi	a5,a5,4
    80006636:	fec798e3          	bne	a5,a2,80006626 <pci_init+0x60>
    8000663a:	bf7d                	j	800065f8 <pci_init+0x32>
    }
  }
}
    8000663c:	60a6                	ld	ra,72(sp)
    8000663e:	6406                	ld	s0,64(sp)
    80006640:	74e2                	ld	s1,56(sp)
    80006642:	7942                	ld	s2,48(sp)
    80006644:	79a2                	ld	s3,40(sp)
    80006646:	7a02                	ld	s4,32(sp)
    80006648:	6ae2                	ld	s5,24(sp)
    8000664a:	6b42                	ld	s6,16(sp)
    8000664c:	6ba2                	ld	s7,8(sp)
    8000664e:	6161                	addi	sp,sp,80
    80006650:	8082                	ret

0000000080006652 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80006652:	1141                	addi	sp,sp,-16
    80006654:	e422                	sd	s0,8(sp)
    80006656:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80006658:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    8000665c:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80006660:	0037979b          	slliw	a5,a5,0x3
    80006664:	02004737          	lui	a4,0x2004
    80006668:	97ba                	add	a5,a5,a4
    8000666a:	0200c737          	lui	a4,0x200c
    8000666e:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80006672:	000f4637          	lui	a2,0xf4
    80006676:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    8000667a:	9732                	add	a4,a4,a2
    8000667c:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    8000667e:	00259693          	slli	a3,a1,0x2
    80006682:	96ae                	add	a3,a3,a1
    80006684:	068e                	slli	a3,a3,0x3
    80006686:	00019717          	auipc	a4,0x19
    8000668a:	cba70713          	addi	a4,a4,-838 # 8001f340 <timer_scratch>
    8000668e:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80006690:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80006692:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80006694:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80006698:	fffff797          	auipc	a5,0xfffff
    8000669c:	a8878793          	addi	a5,a5,-1400 # 80005120 <timervec>
    800066a0:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800066a4:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800066a8:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800066ac:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800066b0:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800066b4:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800066b8:	30479073          	csrw	mie,a5
}
    800066bc:	6422                	ld	s0,8(sp)
    800066be:	0141                	addi	sp,sp,16
    800066c0:	8082                	ret

00000000800066c2 <start>:
{
    800066c2:	1141                	addi	sp,sp,-16
    800066c4:	e406                	sd	ra,8(sp)
    800066c6:	e022                	sd	s0,0(sp)
    800066c8:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800066ca:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800066ce:	7779                	lui	a4,0xffffe
    800066d0:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd727f>
    800066d4:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800066d6:	6705                	lui	a4,0x1
    800066d8:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800066dc:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800066de:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800066e2:	ffffa797          	auipc	a5,0xffffa
    800066e6:	c3e78793          	addi	a5,a5,-962 # 80000320 <main>
    800066ea:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800066ee:	4781                	li	a5,0
    800066f0:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800066f4:	67c1                	lui	a5,0x10
    800066f6:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800066f8:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800066fc:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80006700:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80006704:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80006708:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    8000670c:	57fd                	li	a5,-1
    8000670e:	83a9                	srli	a5,a5,0xa
    80006710:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80006714:	47bd                	li	a5,15
    80006716:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    8000671a:	00000097          	auipc	ra,0x0
    8000671e:	f38080e7          	jalr	-200(ra) # 80006652 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80006722:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80006726:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80006728:	823e                	mv	tp,a5
  asm volatile("mret");
    8000672a:	30200073          	mret
}
    8000672e:	60a2                	ld	ra,8(sp)
    80006730:	6402                	ld	s0,0(sp)
    80006732:	0141                	addi	sp,sp,16
    80006734:	8082                	ret

0000000080006736 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80006736:	715d                	addi	sp,sp,-80
    80006738:	e486                	sd	ra,72(sp)
    8000673a:	e0a2                	sd	s0,64(sp)
    8000673c:	fc26                	sd	s1,56(sp)
    8000673e:	f84a                	sd	s2,48(sp)
    80006740:	f44e                	sd	s3,40(sp)
    80006742:	f052                	sd	s4,32(sp)
    80006744:	ec56                	sd	s5,24(sp)
    80006746:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80006748:	04c05763          	blez	a2,80006796 <consolewrite+0x60>
    8000674c:	8a2a                	mv	s4,a0
    8000674e:	84ae                	mv	s1,a1
    80006750:	89b2                	mv	s3,a2
    80006752:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80006754:	5afd                	li	s5,-1
    80006756:	4685                	li	a3,1
    80006758:	8626                	mv	a2,s1
    8000675a:	85d2                	mv	a1,s4
    8000675c:	fbf40513          	addi	a0,s0,-65
    80006760:	ffffb097          	auipc	ra,0xffffb
    80006764:	1fa080e7          	jalr	506(ra) # 8000195a <either_copyin>
    80006768:	01550d63          	beq	a0,s5,80006782 <consolewrite+0x4c>
      break;
    uartputc(c);
    8000676c:	fbf44503          	lbu	a0,-65(s0)
    80006770:	00000097          	auipc	ra,0x0
    80006774:	77e080e7          	jalr	1918(ra) # 80006eee <uartputc>
  for(i = 0; i < n; i++){
    80006778:	2905                	addiw	s2,s2,1
    8000677a:	0485                	addi	s1,s1,1
    8000677c:	fd299de3          	bne	s3,s2,80006756 <consolewrite+0x20>
    80006780:	894e                	mv	s2,s3
  }

  return i;
}
    80006782:	854a                	mv	a0,s2
    80006784:	60a6                	ld	ra,72(sp)
    80006786:	6406                	ld	s0,64(sp)
    80006788:	74e2                	ld	s1,56(sp)
    8000678a:	7942                	ld	s2,48(sp)
    8000678c:	79a2                	ld	s3,40(sp)
    8000678e:	7a02                	ld	s4,32(sp)
    80006790:	6ae2                	ld	s5,24(sp)
    80006792:	6161                	addi	sp,sp,80
    80006794:	8082                	ret
  for(i = 0; i < n; i++){
    80006796:	4901                	li	s2,0
    80006798:	b7ed                	j	80006782 <consolewrite+0x4c>

000000008000679a <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000679a:	7159                	addi	sp,sp,-112
    8000679c:	f486                	sd	ra,104(sp)
    8000679e:	f0a2                	sd	s0,96(sp)
    800067a0:	eca6                	sd	s1,88(sp)
    800067a2:	e8ca                	sd	s2,80(sp)
    800067a4:	e4ce                	sd	s3,72(sp)
    800067a6:	e0d2                	sd	s4,64(sp)
    800067a8:	fc56                	sd	s5,56(sp)
    800067aa:	f85a                	sd	s6,48(sp)
    800067ac:	f45e                	sd	s7,40(sp)
    800067ae:	f062                	sd	s8,32(sp)
    800067b0:	ec66                	sd	s9,24(sp)
    800067b2:	e86a                	sd	s10,16(sp)
    800067b4:	1880                	addi	s0,sp,112
    800067b6:	8aaa                	mv	s5,a0
    800067b8:	8a2e                	mv	s4,a1
    800067ba:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800067bc:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    800067c0:	00021517          	auipc	a0,0x21
    800067c4:	cc050513          	addi	a0,a0,-832 # 80027480 <cons>
    800067c8:	00001097          	auipc	ra,0x1
    800067cc:	8e0080e7          	jalr	-1824(ra) # 800070a8 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800067d0:	00021497          	auipc	s1,0x21
    800067d4:	cb048493          	addi	s1,s1,-848 # 80027480 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800067d8:	00021917          	auipc	s2,0x21
    800067dc:	d4090913          	addi	s2,s2,-704 # 80027518 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    800067e0:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800067e2:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800067e4:	4ca9                	li	s9,10
  while(n > 0){
    800067e6:	07305863          	blez	s3,80006856 <consoleread+0xbc>
    while(cons.r == cons.w){
    800067ea:	0984a783          	lw	a5,152(s1)
    800067ee:	09c4a703          	lw	a4,156(s1)
    800067f2:	02f71463          	bne	a4,a5,8000681a <consoleread+0x80>
      if(myproc()->killed){
    800067f6:	ffffa097          	auipc	ra,0xffffa
    800067fa:	6a6080e7          	jalr	1702(ra) # 80000e9c <myproc>
    800067fe:	551c                	lw	a5,40(a0)
    80006800:	e7b5                	bnez	a5,8000686c <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    80006802:	85a6                	mv	a1,s1
    80006804:	854a                	mv	a0,s2
    80006806:	ffffb097          	auipc	ra,0xffffb
    8000680a:	d5a080e7          	jalr	-678(ra) # 80001560 <sleep>
    while(cons.r == cons.w){
    8000680e:	0984a783          	lw	a5,152(s1)
    80006812:	09c4a703          	lw	a4,156(s1)
    80006816:	fef700e3          	beq	a4,a5,800067f6 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF];
    8000681a:	0017871b          	addiw	a4,a5,1
    8000681e:	08e4ac23          	sw	a4,152(s1)
    80006822:	07f7f713          	andi	a4,a5,127
    80006826:	9726                	add	a4,a4,s1
    80006828:	01874703          	lbu	a4,24(a4)
    8000682c:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80006830:	077d0563          	beq	s10,s7,8000689a <consoleread+0x100>
    cbuf = c;
    80006834:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80006838:	4685                	li	a3,1
    8000683a:	f9f40613          	addi	a2,s0,-97
    8000683e:	85d2                	mv	a1,s4
    80006840:	8556                	mv	a0,s5
    80006842:	ffffb097          	auipc	ra,0xffffb
    80006846:	0c2080e7          	jalr	194(ra) # 80001904 <either_copyout>
    8000684a:	01850663          	beq	a0,s8,80006856 <consoleread+0xbc>
    dst++;
    8000684e:	0a05                	addi	s4,s4,1 # 2001 <_entry-0x7fffdfff>
    --n;
    80006850:	39fd                	addiw	s3,s3,-1 # 3003ffff <_entry-0x4ffc0001>
    if(c == '\n'){
    80006852:	f99d1ae3          	bne	s10,s9,800067e6 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80006856:	00021517          	auipc	a0,0x21
    8000685a:	c2a50513          	addi	a0,a0,-982 # 80027480 <cons>
    8000685e:	00001097          	auipc	ra,0x1
    80006862:	8fe080e7          	jalr	-1794(ra) # 8000715c <release>

  return target - n;
    80006866:	413b053b          	subw	a0,s6,s3
    8000686a:	a811                	j	8000687e <consoleread+0xe4>
        release(&cons.lock);
    8000686c:	00021517          	auipc	a0,0x21
    80006870:	c1450513          	addi	a0,a0,-1004 # 80027480 <cons>
    80006874:	00001097          	auipc	ra,0x1
    80006878:	8e8080e7          	jalr	-1816(ra) # 8000715c <release>
        return -1;
    8000687c:	557d                	li	a0,-1
}
    8000687e:	70a6                	ld	ra,104(sp)
    80006880:	7406                	ld	s0,96(sp)
    80006882:	64e6                	ld	s1,88(sp)
    80006884:	6946                	ld	s2,80(sp)
    80006886:	69a6                	ld	s3,72(sp)
    80006888:	6a06                	ld	s4,64(sp)
    8000688a:	7ae2                	ld	s5,56(sp)
    8000688c:	7b42                	ld	s6,48(sp)
    8000688e:	7ba2                	ld	s7,40(sp)
    80006890:	7c02                	ld	s8,32(sp)
    80006892:	6ce2                	ld	s9,24(sp)
    80006894:	6d42                	ld	s10,16(sp)
    80006896:	6165                	addi	sp,sp,112
    80006898:	8082                	ret
      if(n < target){
    8000689a:	0009871b          	sext.w	a4,s3
    8000689e:	fb677ce3          	bgeu	a4,s6,80006856 <consoleread+0xbc>
        cons.r--;
    800068a2:	00021717          	auipc	a4,0x21
    800068a6:	c6f72b23          	sw	a5,-906(a4) # 80027518 <cons+0x98>
    800068aa:	b775                	j	80006856 <consoleread+0xbc>

00000000800068ac <consputc>:
{
    800068ac:	1141                	addi	sp,sp,-16
    800068ae:	e406                	sd	ra,8(sp)
    800068b0:	e022                	sd	s0,0(sp)
    800068b2:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    800068b4:	10000793          	li	a5,256
    800068b8:	00f50a63          	beq	a0,a5,800068cc <consputc+0x20>
    uartputc_sync(c);
    800068bc:	00000097          	auipc	ra,0x0
    800068c0:	560080e7          	jalr	1376(ra) # 80006e1c <uartputc_sync>
}
    800068c4:	60a2                	ld	ra,8(sp)
    800068c6:	6402                	ld	s0,0(sp)
    800068c8:	0141                	addi	sp,sp,16
    800068ca:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800068cc:	4521                	li	a0,8
    800068ce:	00000097          	auipc	ra,0x0
    800068d2:	54e080e7          	jalr	1358(ra) # 80006e1c <uartputc_sync>
    800068d6:	02000513          	li	a0,32
    800068da:	00000097          	auipc	ra,0x0
    800068de:	542080e7          	jalr	1346(ra) # 80006e1c <uartputc_sync>
    800068e2:	4521                	li	a0,8
    800068e4:	00000097          	auipc	ra,0x0
    800068e8:	538080e7          	jalr	1336(ra) # 80006e1c <uartputc_sync>
    800068ec:	bfe1                	j	800068c4 <consputc+0x18>

00000000800068ee <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800068ee:	1101                	addi	sp,sp,-32
    800068f0:	ec06                	sd	ra,24(sp)
    800068f2:	e822                	sd	s0,16(sp)
    800068f4:	e426                	sd	s1,8(sp)
    800068f6:	e04a                	sd	s2,0(sp)
    800068f8:	1000                	addi	s0,sp,32
    800068fa:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800068fc:	00021517          	auipc	a0,0x21
    80006900:	b8450513          	addi	a0,a0,-1148 # 80027480 <cons>
    80006904:	00000097          	auipc	ra,0x0
    80006908:	7a4080e7          	jalr	1956(ra) # 800070a8 <acquire>

  switch(c){
    8000690c:	47d5                	li	a5,21
    8000690e:	0af48663          	beq	s1,a5,800069ba <consoleintr+0xcc>
    80006912:	0297ca63          	blt	a5,s1,80006946 <consoleintr+0x58>
    80006916:	47a1                	li	a5,8
    80006918:	0ef48763          	beq	s1,a5,80006a06 <consoleintr+0x118>
    8000691c:	47c1                	li	a5,16
    8000691e:	10f49a63          	bne	s1,a5,80006a32 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80006922:	ffffb097          	auipc	ra,0xffffb
    80006926:	08e080e7          	jalr	142(ra) # 800019b0 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    8000692a:	00021517          	auipc	a0,0x21
    8000692e:	b5650513          	addi	a0,a0,-1194 # 80027480 <cons>
    80006932:	00001097          	auipc	ra,0x1
    80006936:	82a080e7          	jalr	-2006(ra) # 8000715c <release>
}
    8000693a:	60e2                	ld	ra,24(sp)
    8000693c:	6442                	ld	s0,16(sp)
    8000693e:	64a2                	ld	s1,8(sp)
    80006940:	6902                	ld	s2,0(sp)
    80006942:	6105                	addi	sp,sp,32
    80006944:	8082                	ret
  switch(c){
    80006946:	07f00793          	li	a5,127
    8000694a:	0af48e63          	beq	s1,a5,80006a06 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    8000694e:	00021717          	auipc	a4,0x21
    80006952:	b3270713          	addi	a4,a4,-1230 # 80027480 <cons>
    80006956:	0a072783          	lw	a5,160(a4)
    8000695a:	09872703          	lw	a4,152(a4)
    8000695e:	9f99                	subw	a5,a5,a4
    80006960:	07f00713          	li	a4,127
    80006964:	fcf763e3          	bltu	a4,a5,8000692a <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80006968:	47b5                	li	a5,13
    8000696a:	0cf48763          	beq	s1,a5,80006a38 <consoleintr+0x14a>
      consputc(c);
    8000696e:	8526                	mv	a0,s1
    80006970:	00000097          	auipc	ra,0x0
    80006974:	f3c080e7          	jalr	-196(ra) # 800068ac <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80006978:	00021797          	auipc	a5,0x21
    8000697c:	b0878793          	addi	a5,a5,-1272 # 80027480 <cons>
    80006980:	0a07a703          	lw	a4,160(a5)
    80006984:	0017069b          	addiw	a3,a4,1
    80006988:	0006861b          	sext.w	a2,a3
    8000698c:	0ad7a023          	sw	a3,160(a5)
    80006990:	07f77713          	andi	a4,a4,127
    80006994:	97ba                	add	a5,a5,a4
    80006996:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    8000699a:	47a9                	li	a5,10
    8000699c:	0cf48563          	beq	s1,a5,80006a66 <consoleintr+0x178>
    800069a0:	4791                	li	a5,4
    800069a2:	0cf48263          	beq	s1,a5,80006a66 <consoleintr+0x178>
    800069a6:	00021797          	auipc	a5,0x21
    800069aa:	b727a783          	lw	a5,-1166(a5) # 80027518 <cons+0x98>
    800069ae:	0807879b          	addiw	a5,a5,128
    800069b2:	f6f61ce3          	bne	a2,a5,8000692a <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    800069b6:	863e                	mv	a2,a5
    800069b8:	a07d                	j	80006a66 <consoleintr+0x178>
    while(cons.e != cons.w &&
    800069ba:	00021717          	auipc	a4,0x21
    800069be:	ac670713          	addi	a4,a4,-1338 # 80027480 <cons>
    800069c2:	0a072783          	lw	a5,160(a4)
    800069c6:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800069ca:	00021497          	auipc	s1,0x21
    800069ce:	ab648493          	addi	s1,s1,-1354 # 80027480 <cons>
    while(cons.e != cons.w &&
    800069d2:	4929                	li	s2,10
    800069d4:	f4f70be3          	beq	a4,a5,8000692a <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800069d8:	37fd                	addiw	a5,a5,-1
    800069da:	07f7f713          	andi	a4,a5,127
    800069de:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800069e0:	01874703          	lbu	a4,24(a4)
    800069e4:	f52703e3          	beq	a4,s2,8000692a <consoleintr+0x3c>
      cons.e--;
    800069e8:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800069ec:	10000513          	li	a0,256
    800069f0:	00000097          	auipc	ra,0x0
    800069f4:	ebc080e7          	jalr	-324(ra) # 800068ac <consputc>
    while(cons.e != cons.w &&
    800069f8:	0a04a783          	lw	a5,160(s1)
    800069fc:	09c4a703          	lw	a4,156(s1)
    80006a00:	fcf71ce3          	bne	a4,a5,800069d8 <consoleintr+0xea>
    80006a04:	b71d                	j	8000692a <consoleintr+0x3c>
    if(cons.e != cons.w){
    80006a06:	00021717          	auipc	a4,0x21
    80006a0a:	a7a70713          	addi	a4,a4,-1414 # 80027480 <cons>
    80006a0e:	0a072783          	lw	a5,160(a4)
    80006a12:	09c72703          	lw	a4,156(a4)
    80006a16:	f0f70ae3          	beq	a4,a5,8000692a <consoleintr+0x3c>
      cons.e--;
    80006a1a:	37fd                	addiw	a5,a5,-1
    80006a1c:	00021717          	auipc	a4,0x21
    80006a20:	b0f72223          	sw	a5,-1276(a4) # 80027520 <cons+0xa0>
      consputc(BACKSPACE);
    80006a24:	10000513          	li	a0,256
    80006a28:	00000097          	auipc	ra,0x0
    80006a2c:	e84080e7          	jalr	-380(ra) # 800068ac <consputc>
    80006a30:	bded                	j	8000692a <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80006a32:	ee048ce3          	beqz	s1,8000692a <consoleintr+0x3c>
    80006a36:	bf21                	j	8000694e <consoleintr+0x60>
      consputc(c);
    80006a38:	4529                	li	a0,10
    80006a3a:	00000097          	auipc	ra,0x0
    80006a3e:	e72080e7          	jalr	-398(ra) # 800068ac <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80006a42:	00021797          	auipc	a5,0x21
    80006a46:	a3e78793          	addi	a5,a5,-1474 # 80027480 <cons>
    80006a4a:	0a07a703          	lw	a4,160(a5)
    80006a4e:	0017069b          	addiw	a3,a4,1
    80006a52:	0006861b          	sext.w	a2,a3
    80006a56:	0ad7a023          	sw	a3,160(a5)
    80006a5a:	07f77713          	andi	a4,a4,127
    80006a5e:	97ba                	add	a5,a5,a4
    80006a60:	4729                	li	a4,10
    80006a62:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80006a66:	00021797          	auipc	a5,0x21
    80006a6a:	aac7ab23          	sw	a2,-1354(a5) # 8002751c <cons+0x9c>
        wakeup(&cons.r);
    80006a6e:	00021517          	auipc	a0,0x21
    80006a72:	aaa50513          	addi	a0,a0,-1366 # 80027518 <cons+0x98>
    80006a76:	ffffb097          	auipc	ra,0xffffb
    80006a7a:	c76080e7          	jalr	-906(ra) # 800016ec <wakeup>
    80006a7e:	b575                	j	8000692a <consoleintr+0x3c>

0000000080006a80 <consoleinit>:

void
consoleinit(void)
{
    80006a80:	1141                	addi	sp,sp,-16
    80006a82:	e406                	sd	ra,8(sp)
    80006a84:	e022                	sd	s0,0(sp)
    80006a86:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80006a88:	00003597          	auipc	a1,0x3
    80006a8c:	d8858593          	addi	a1,a1,-632 # 80009810 <syscalls+0x438>
    80006a90:	00021517          	auipc	a0,0x21
    80006a94:	9f050513          	addi	a0,a0,-1552 # 80027480 <cons>
    80006a98:	00000097          	auipc	ra,0x0
    80006a9c:	580080e7          	jalr	1408(ra) # 80007018 <initlock>

  uartinit();
    80006aa0:	00000097          	auipc	ra,0x0
    80006aa4:	32c080e7          	jalr	812(ra) # 80006dcc <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80006aa8:	00013797          	auipc	a5,0x13
    80006aac:	64078793          	addi	a5,a5,1600 # 8001a0e8 <devsw>
    80006ab0:	00000717          	auipc	a4,0x0
    80006ab4:	cea70713          	addi	a4,a4,-790 # 8000679a <consoleread>
    80006ab8:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80006aba:	00000717          	auipc	a4,0x0
    80006abe:	c7c70713          	addi	a4,a4,-900 # 80006736 <consolewrite>
    80006ac2:	ef98                	sd	a4,24(a5)
}
    80006ac4:	60a2                	ld	ra,8(sp)
    80006ac6:	6402                	ld	s0,0(sp)
    80006ac8:	0141                	addi	sp,sp,16
    80006aca:	8082                	ret

0000000080006acc <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80006acc:	7179                	addi	sp,sp,-48
    80006ace:	f406                	sd	ra,40(sp)
    80006ad0:	f022                	sd	s0,32(sp)
    80006ad2:	ec26                	sd	s1,24(sp)
    80006ad4:	e84a                	sd	s2,16(sp)
    80006ad6:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80006ad8:	c219                	beqz	a2,80006ade <printint+0x12>
    80006ada:	08054763          	bltz	a0,80006b68 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80006ade:	2501                	sext.w	a0,a0
    80006ae0:	4881                	li	a7,0
    80006ae2:	fd040693          	addi	a3,s0,-48

  i = 0;
    80006ae6:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80006ae8:	2581                	sext.w	a1,a1
    80006aea:	00003617          	auipc	a2,0x3
    80006aee:	d5660613          	addi	a2,a2,-682 # 80009840 <digits>
    80006af2:	883a                	mv	a6,a4
    80006af4:	2705                	addiw	a4,a4,1
    80006af6:	02b577bb          	remuw	a5,a0,a1
    80006afa:	1782                	slli	a5,a5,0x20
    80006afc:	9381                	srli	a5,a5,0x20
    80006afe:	97b2                	add	a5,a5,a2
    80006b00:	0007c783          	lbu	a5,0(a5)
    80006b04:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80006b08:	0005079b          	sext.w	a5,a0
    80006b0c:	02b5553b          	divuw	a0,a0,a1
    80006b10:	0685                	addi	a3,a3,1
    80006b12:	feb7f0e3          	bgeu	a5,a1,80006af2 <printint+0x26>

  if(sign)
    80006b16:	00088c63          	beqz	a7,80006b2e <printint+0x62>
    buf[i++] = '-';
    80006b1a:	fe070793          	addi	a5,a4,-32
    80006b1e:	00878733          	add	a4,a5,s0
    80006b22:	02d00793          	li	a5,45
    80006b26:	fef70823          	sb	a5,-16(a4)
    80006b2a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80006b2e:	02e05763          	blez	a4,80006b5c <printint+0x90>
    80006b32:	fd040793          	addi	a5,s0,-48
    80006b36:	00e784b3          	add	s1,a5,a4
    80006b3a:	fff78913          	addi	s2,a5,-1
    80006b3e:	993a                	add	s2,s2,a4
    80006b40:	377d                	addiw	a4,a4,-1
    80006b42:	1702                	slli	a4,a4,0x20
    80006b44:	9301                	srli	a4,a4,0x20
    80006b46:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80006b4a:	fff4c503          	lbu	a0,-1(s1)
    80006b4e:	00000097          	auipc	ra,0x0
    80006b52:	d5e080e7          	jalr	-674(ra) # 800068ac <consputc>
  while(--i >= 0)
    80006b56:	14fd                	addi	s1,s1,-1
    80006b58:	ff2499e3          	bne	s1,s2,80006b4a <printint+0x7e>
}
    80006b5c:	70a2                	ld	ra,40(sp)
    80006b5e:	7402                	ld	s0,32(sp)
    80006b60:	64e2                	ld	s1,24(sp)
    80006b62:	6942                	ld	s2,16(sp)
    80006b64:	6145                	addi	sp,sp,48
    80006b66:	8082                	ret
    x = -xx;
    80006b68:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80006b6c:	4885                	li	a7,1
    x = -xx;
    80006b6e:	bf95                	j	80006ae2 <printint+0x16>

0000000080006b70 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80006b70:	1101                	addi	sp,sp,-32
    80006b72:	ec06                	sd	ra,24(sp)
    80006b74:	e822                	sd	s0,16(sp)
    80006b76:	e426                	sd	s1,8(sp)
    80006b78:	1000                	addi	s0,sp,32
    80006b7a:	84aa                	mv	s1,a0
  pr.locking = 0;
    80006b7c:	00021797          	auipc	a5,0x21
    80006b80:	9c07a223          	sw	zero,-1596(a5) # 80027540 <pr+0x18>
  printf("panic: ");
    80006b84:	00003517          	auipc	a0,0x3
    80006b88:	c9450513          	addi	a0,a0,-876 # 80009818 <syscalls+0x440>
    80006b8c:	00000097          	auipc	ra,0x0
    80006b90:	02e080e7          	jalr	46(ra) # 80006bba <printf>
  printf(s);
    80006b94:	8526                	mv	a0,s1
    80006b96:	00000097          	auipc	ra,0x0
    80006b9a:	024080e7          	jalr	36(ra) # 80006bba <printf>
  printf("\n");
    80006b9e:	00002517          	auipc	a0,0x2
    80006ba2:	4aa50513          	addi	a0,a0,1194 # 80009048 <etext+0x48>
    80006ba6:	00000097          	auipc	ra,0x0
    80006baa:	014080e7          	jalr	20(ra) # 80006bba <printf>
  panicked = 1; // freeze uart output from other CPUs
    80006bae:	4785                	li	a5,1
    80006bb0:	00003717          	auipc	a4,0x3
    80006bb4:	48f72023          	sw	a5,1152(a4) # 8000a030 <panicked>
  for(;;)
    80006bb8:	a001                	j	80006bb8 <panic+0x48>

0000000080006bba <printf>:
{
    80006bba:	7131                	addi	sp,sp,-192
    80006bbc:	fc86                	sd	ra,120(sp)
    80006bbe:	f8a2                	sd	s0,112(sp)
    80006bc0:	f4a6                	sd	s1,104(sp)
    80006bc2:	f0ca                	sd	s2,96(sp)
    80006bc4:	ecce                	sd	s3,88(sp)
    80006bc6:	e8d2                	sd	s4,80(sp)
    80006bc8:	e4d6                	sd	s5,72(sp)
    80006bca:	e0da                	sd	s6,64(sp)
    80006bcc:	fc5e                	sd	s7,56(sp)
    80006bce:	f862                	sd	s8,48(sp)
    80006bd0:	f466                	sd	s9,40(sp)
    80006bd2:	f06a                	sd	s10,32(sp)
    80006bd4:	ec6e                	sd	s11,24(sp)
    80006bd6:	0100                	addi	s0,sp,128
    80006bd8:	8a2a                	mv	s4,a0
    80006bda:	e40c                	sd	a1,8(s0)
    80006bdc:	e810                	sd	a2,16(s0)
    80006bde:	ec14                	sd	a3,24(s0)
    80006be0:	f018                	sd	a4,32(s0)
    80006be2:	f41c                	sd	a5,40(s0)
    80006be4:	03043823          	sd	a6,48(s0)
    80006be8:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80006bec:	00021d97          	auipc	s11,0x21
    80006bf0:	954dad83          	lw	s11,-1708(s11) # 80027540 <pr+0x18>
  if(locking)
    80006bf4:	020d9b63          	bnez	s11,80006c2a <printf+0x70>
  if (fmt == 0)
    80006bf8:	040a0263          	beqz	s4,80006c3c <printf+0x82>
  va_start(ap, fmt);
    80006bfc:	00840793          	addi	a5,s0,8
    80006c00:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006c04:	000a4503          	lbu	a0,0(s4)
    80006c08:	14050f63          	beqz	a0,80006d66 <printf+0x1ac>
    80006c0c:	4981                	li	s3,0
    if(c != '%'){
    80006c0e:	02500a93          	li	s5,37
    switch(c){
    80006c12:	07000b93          	li	s7,112
  consputc('x');
    80006c16:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006c18:	00003b17          	auipc	s6,0x3
    80006c1c:	c28b0b13          	addi	s6,s6,-984 # 80009840 <digits>
    switch(c){
    80006c20:	07300c93          	li	s9,115
    80006c24:	06400c13          	li	s8,100
    80006c28:	a82d                	j	80006c62 <printf+0xa8>
    acquire(&pr.lock);
    80006c2a:	00021517          	auipc	a0,0x21
    80006c2e:	8fe50513          	addi	a0,a0,-1794 # 80027528 <pr>
    80006c32:	00000097          	auipc	ra,0x0
    80006c36:	476080e7          	jalr	1142(ra) # 800070a8 <acquire>
    80006c3a:	bf7d                	j	80006bf8 <printf+0x3e>
    panic("null fmt");
    80006c3c:	00003517          	auipc	a0,0x3
    80006c40:	bec50513          	addi	a0,a0,-1044 # 80009828 <syscalls+0x450>
    80006c44:	00000097          	auipc	ra,0x0
    80006c48:	f2c080e7          	jalr	-212(ra) # 80006b70 <panic>
      consputc(c);
    80006c4c:	00000097          	auipc	ra,0x0
    80006c50:	c60080e7          	jalr	-928(ra) # 800068ac <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006c54:	2985                	addiw	s3,s3,1
    80006c56:	013a07b3          	add	a5,s4,s3
    80006c5a:	0007c503          	lbu	a0,0(a5)
    80006c5e:	10050463          	beqz	a0,80006d66 <printf+0x1ac>
    if(c != '%'){
    80006c62:	ff5515e3          	bne	a0,s5,80006c4c <printf+0x92>
    c = fmt[++i] & 0xff;
    80006c66:	2985                	addiw	s3,s3,1
    80006c68:	013a07b3          	add	a5,s4,s3
    80006c6c:	0007c783          	lbu	a5,0(a5)
    80006c70:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80006c74:	cbed                	beqz	a5,80006d66 <printf+0x1ac>
    switch(c){
    80006c76:	05778a63          	beq	a5,s7,80006cca <printf+0x110>
    80006c7a:	02fbf663          	bgeu	s7,a5,80006ca6 <printf+0xec>
    80006c7e:	09978863          	beq	a5,s9,80006d0e <printf+0x154>
    80006c82:	07800713          	li	a4,120
    80006c86:	0ce79563          	bne	a5,a4,80006d50 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80006c8a:	f8843783          	ld	a5,-120(s0)
    80006c8e:	00878713          	addi	a4,a5,8
    80006c92:	f8e43423          	sd	a4,-120(s0)
    80006c96:	4605                	li	a2,1
    80006c98:	85ea                	mv	a1,s10
    80006c9a:	4388                	lw	a0,0(a5)
    80006c9c:	00000097          	auipc	ra,0x0
    80006ca0:	e30080e7          	jalr	-464(ra) # 80006acc <printint>
      break;
    80006ca4:	bf45                	j	80006c54 <printf+0x9a>
    switch(c){
    80006ca6:	09578f63          	beq	a5,s5,80006d44 <printf+0x18a>
    80006caa:	0b879363          	bne	a5,s8,80006d50 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80006cae:	f8843783          	ld	a5,-120(s0)
    80006cb2:	00878713          	addi	a4,a5,8
    80006cb6:	f8e43423          	sd	a4,-120(s0)
    80006cba:	4605                	li	a2,1
    80006cbc:	45a9                	li	a1,10
    80006cbe:	4388                	lw	a0,0(a5)
    80006cc0:	00000097          	auipc	ra,0x0
    80006cc4:	e0c080e7          	jalr	-500(ra) # 80006acc <printint>
      break;
    80006cc8:	b771                	j	80006c54 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80006cca:	f8843783          	ld	a5,-120(s0)
    80006cce:	00878713          	addi	a4,a5,8
    80006cd2:	f8e43423          	sd	a4,-120(s0)
    80006cd6:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80006cda:	03000513          	li	a0,48
    80006cde:	00000097          	auipc	ra,0x0
    80006ce2:	bce080e7          	jalr	-1074(ra) # 800068ac <consputc>
  consputc('x');
    80006ce6:	07800513          	li	a0,120
    80006cea:	00000097          	auipc	ra,0x0
    80006cee:	bc2080e7          	jalr	-1086(ra) # 800068ac <consputc>
    80006cf2:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006cf4:	03c95793          	srli	a5,s2,0x3c
    80006cf8:	97da                	add	a5,a5,s6
    80006cfa:	0007c503          	lbu	a0,0(a5)
    80006cfe:	00000097          	auipc	ra,0x0
    80006d02:	bae080e7          	jalr	-1106(ra) # 800068ac <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80006d06:	0912                	slli	s2,s2,0x4
    80006d08:	34fd                	addiw	s1,s1,-1
    80006d0a:	f4ed                	bnez	s1,80006cf4 <printf+0x13a>
    80006d0c:	b7a1                	j	80006c54 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80006d0e:	f8843783          	ld	a5,-120(s0)
    80006d12:	00878713          	addi	a4,a5,8
    80006d16:	f8e43423          	sd	a4,-120(s0)
    80006d1a:	6384                	ld	s1,0(a5)
    80006d1c:	cc89                	beqz	s1,80006d36 <printf+0x17c>
      for(; *s; s++)
    80006d1e:	0004c503          	lbu	a0,0(s1)
    80006d22:	d90d                	beqz	a0,80006c54 <printf+0x9a>
        consputc(*s);
    80006d24:	00000097          	auipc	ra,0x0
    80006d28:	b88080e7          	jalr	-1144(ra) # 800068ac <consputc>
      for(; *s; s++)
    80006d2c:	0485                	addi	s1,s1,1
    80006d2e:	0004c503          	lbu	a0,0(s1)
    80006d32:	f96d                	bnez	a0,80006d24 <printf+0x16a>
    80006d34:	b705                	j	80006c54 <printf+0x9a>
        s = "(null)";
    80006d36:	00003497          	auipc	s1,0x3
    80006d3a:	aea48493          	addi	s1,s1,-1302 # 80009820 <syscalls+0x448>
      for(; *s; s++)
    80006d3e:	02800513          	li	a0,40
    80006d42:	b7cd                	j	80006d24 <printf+0x16a>
      consputc('%');
    80006d44:	8556                	mv	a0,s5
    80006d46:	00000097          	auipc	ra,0x0
    80006d4a:	b66080e7          	jalr	-1178(ra) # 800068ac <consputc>
      break;
    80006d4e:	b719                	j	80006c54 <printf+0x9a>
      consputc('%');
    80006d50:	8556                	mv	a0,s5
    80006d52:	00000097          	auipc	ra,0x0
    80006d56:	b5a080e7          	jalr	-1190(ra) # 800068ac <consputc>
      consputc(c);
    80006d5a:	8526                	mv	a0,s1
    80006d5c:	00000097          	auipc	ra,0x0
    80006d60:	b50080e7          	jalr	-1200(ra) # 800068ac <consputc>
      break;
    80006d64:	bdc5                	j	80006c54 <printf+0x9a>
  if(locking)
    80006d66:	020d9163          	bnez	s11,80006d88 <printf+0x1ce>
}
    80006d6a:	70e6                	ld	ra,120(sp)
    80006d6c:	7446                	ld	s0,112(sp)
    80006d6e:	74a6                	ld	s1,104(sp)
    80006d70:	7906                	ld	s2,96(sp)
    80006d72:	69e6                	ld	s3,88(sp)
    80006d74:	6a46                	ld	s4,80(sp)
    80006d76:	6aa6                	ld	s5,72(sp)
    80006d78:	6b06                	ld	s6,64(sp)
    80006d7a:	7be2                	ld	s7,56(sp)
    80006d7c:	7c42                	ld	s8,48(sp)
    80006d7e:	7ca2                	ld	s9,40(sp)
    80006d80:	7d02                	ld	s10,32(sp)
    80006d82:	6de2                	ld	s11,24(sp)
    80006d84:	6129                	addi	sp,sp,192
    80006d86:	8082                	ret
    release(&pr.lock);
    80006d88:	00020517          	auipc	a0,0x20
    80006d8c:	7a050513          	addi	a0,a0,1952 # 80027528 <pr>
    80006d90:	00000097          	auipc	ra,0x0
    80006d94:	3cc080e7          	jalr	972(ra) # 8000715c <release>
}
    80006d98:	bfc9                	j	80006d6a <printf+0x1b0>

0000000080006d9a <printfinit>:
    ;
}

void
printfinit(void)
{
    80006d9a:	1101                	addi	sp,sp,-32
    80006d9c:	ec06                	sd	ra,24(sp)
    80006d9e:	e822                	sd	s0,16(sp)
    80006da0:	e426                	sd	s1,8(sp)
    80006da2:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006da4:	00020497          	auipc	s1,0x20
    80006da8:	78448493          	addi	s1,s1,1924 # 80027528 <pr>
    80006dac:	00003597          	auipc	a1,0x3
    80006db0:	a8c58593          	addi	a1,a1,-1396 # 80009838 <syscalls+0x460>
    80006db4:	8526                	mv	a0,s1
    80006db6:	00000097          	auipc	ra,0x0
    80006dba:	262080e7          	jalr	610(ra) # 80007018 <initlock>
  pr.locking = 1;
    80006dbe:	4785                	li	a5,1
    80006dc0:	cc9c                	sw	a5,24(s1)
}
    80006dc2:	60e2                	ld	ra,24(sp)
    80006dc4:	6442                	ld	s0,16(sp)
    80006dc6:	64a2                	ld	s1,8(sp)
    80006dc8:	6105                	addi	sp,sp,32
    80006dca:	8082                	ret

0000000080006dcc <uartinit>:

void uartstart();

void
uartinit(void)
{
    80006dcc:	1141                	addi	sp,sp,-16
    80006dce:	e406                	sd	ra,8(sp)
    80006dd0:	e022                	sd	s0,0(sp)
    80006dd2:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006dd4:	100007b7          	lui	a5,0x10000
    80006dd8:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80006ddc:	f8000713          	li	a4,-128
    80006de0:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006de4:	470d                	li	a4,3
    80006de6:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006dea:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80006dee:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006df2:	469d                	li	a3,7
    80006df4:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006df8:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80006dfc:	00003597          	auipc	a1,0x3
    80006e00:	a5c58593          	addi	a1,a1,-1444 # 80009858 <digits+0x18>
    80006e04:	00020517          	auipc	a0,0x20
    80006e08:	74450513          	addi	a0,a0,1860 # 80027548 <uart_tx_lock>
    80006e0c:	00000097          	auipc	ra,0x0
    80006e10:	20c080e7          	jalr	524(ra) # 80007018 <initlock>
}
    80006e14:	60a2                	ld	ra,8(sp)
    80006e16:	6402                	ld	s0,0(sp)
    80006e18:	0141                	addi	sp,sp,16
    80006e1a:	8082                	ret

0000000080006e1c <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80006e1c:	1101                	addi	sp,sp,-32
    80006e1e:	ec06                	sd	ra,24(sp)
    80006e20:	e822                	sd	s0,16(sp)
    80006e22:	e426                	sd	s1,8(sp)
    80006e24:	1000                	addi	s0,sp,32
    80006e26:	84aa                	mv	s1,a0
  push_off();
    80006e28:	00000097          	auipc	ra,0x0
    80006e2c:	234080e7          	jalr	564(ra) # 8000705c <push_off>

  if(panicked){
    80006e30:	00003797          	auipc	a5,0x3
    80006e34:	2007a783          	lw	a5,512(a5) # 8000a030 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006e38:	10000737          	lui	a4,0x10000
  if(panicked){
    80006e3c:	c391                	beqz	a5,80006e40 <uartputc_sync+0x24>
    for(;;)
    80006e3e:	a001                	j	80006e3e <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006e40:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006e44:	0207f793          	andi	a5,a5,32
    80006e48:	dfe5                	beqz	a5,80006e40 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006e4a:	0ff4f513          	zext.b	a0,s1
    80006e4e:	100007b7          	lui	a5,0x10000
    80006e52:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80006e56:	00000097          	auipc	ra,0x0
    80006e5a:	2a6080e7          	jalr	678(ra) # 800070fc <pop_off>
}
    80006e5e:	60e2                	ld	ra,24(sp)
    80006e60:	6442                	ld	s0,16(sp)
    80006e62:	64a2                	ld	s1,8(sp)
    80006e64:	6105                	addi	sp,sp,32
    80006e66:	8082                	ret

0000000080006e68 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006e68:	00003797          	auipc	a5,0x3
    80006e6c:	1d07b783          	ld	a5,464(a5) # 8000a038 <uart_tx_r>
    80006e70:	00003717          	auipc	a4,0x3
    80006e74:	1d073703          	ld	a4,464(a4) # 8000a040 <uart_tx_w>
    80006e78:	06f70a63          	beq	a4,a5,80006eec <uartstart+0x84>
{
    80006e7c:	7139                	addi	sp,sp,-64
    80006e7e:	fc06                	sd	ra,56(sp)
    80006e80:	f822                	sd	s0,48(sp)
    80006e82:	f426                	sd	s1,40(sp)
    80006e84:	f04a                	sd	s2,32(sp)
    80006e86:	ec4e                	sd	s3,24(sp)
    80006e88:	e852                	sd	s4,16(sp)
    80006e8a:	e456                	sd	s5,8(sp)
    80006e8c:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006e8e:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006e92:	00020a17          	auipc	s4,0x20
    80006e96:	6b6a0a13          	addi	s4,s4,1718 # 80027548 <uart_tx_lock>
    uart_tx_r += 1;
    80006e9a:	00003497          	auipc	s1,0x3
    80006e9e:	19e48493          	addi	s1,s1,414 # 8000a038 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80006ea2:	00003997          	auipc	s3,0x3
    80006ea6:	19e98993          	addi	s3,s3,414 # 8000a040 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006eaa:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80006eae:	02077713          	andi	a4,a4,32
    80006eb2:	c705                	beqz	a4,80006eda <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006eb4:	01f7f713          	andi	a4,a5,31
    80006eb8:	9752                	add	a4,a4,s4
    80006eba:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80006ebe:	0785                	addi	a5,a5,1
    80006ec0:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006ec2:	8526                	mv	a0,s1
    80006ec4:	ffffb097          	auipc	ra,0xffffb
    80006ec8:	828080e7          	jalr	-2008(ra) # 800016ec <wakeup>
    
    WriteReg(THR, c);
    80006ecc:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006ed0:	609c                	ld	a5,0(s1)
    80006ed2:	0009b703          	ld	a4,0(s3)
    80006ed6:	fcf71ae3          	bne	a4,a5,80006eaa <uartstart+0x42>
  }
}
    80006eda:	70e2                	ld	ra,56(sp)
    80006edc:	7442                	ld	s0,48(sp)
    80006ede:	74a2                	ld	s1,40(sp)
    80006ee0:	7902                	ld	s2,32(sp)
    80006ee2:	69e2                	ld	s3,24(sp)
    80006ee4:	6a42                	ld	s4,16(sp)
    80006ee6:	6aa2                	ld	s5,8(sp)
    80006ee8:	6121                	addi	sp,sp,64
    80006eea:	8082                	ret
    80006eec:	8082                	ret

0000000080006eee <uartputc>:
{
    80006eee:	7179                	addi	sp,sp,-48
    80006ef0:	f406                	sd	ra,40(sp)
    80006ef2:	f022                	sd	s0,32(sp)
    80006ef4:	ec26                	sd	s1,24(sp)
    80006ef6:	e84a                	sd	s2,16(sp)
    80006ef8:	e44e                	sd	s3,8(sp)
    80006efa:	e052                	sd	s4,0(sp)
    80006efc:	1800                	addi	s0,sp,48
    80006efe:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006f00:	00020517          	auipc	a0,0x20
    80006f04:	64850513          	addi	a0,a0,1608 # 80027548 <uart_tx_lock>
    80006f08:	00000097          	auipc	ra,0x0
    80006f0c:	1a0080e7          	jalr	416(ra) # 800070a8 <acquire>
  if(panicked){
    80006f10:	00003797          	auipc	a5,0x3
    80006f14:	1207a783          	lw	a5,288(a5) # 8000a030 <panicked>
    80006f18:	c391                	beqz	a5,80006f1c <uartputc+0x2e>
    for(;;)
    80006f1a:	a001                	j	80006f1a <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006f1c:	00003717          	auipc	a4,0x3
    80006f20:	12473703          	ld	a4,292(a4) # 8000a040 <uart_tx_w>
    80006f24:	00003797          	auipc	a5,0x3
    80006f28:	1147b783          	ld	a5,276(a5) # 8000a038 <uart_tx_r>
    80006f2c:	02078793          	addi	a5,a5,32
    80006f30:	02e79b63          	bne	a5,a4,80006f66 <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006f34:	00020997          	auipc	s3,0x20
    80006f38:	61498993          	addi	s3,s3,1556 # 80027548 <uart_tx_lock>
    80006f3c:	00003497          	auipc	s1,0x3
    80006f40:	0fc48493          	addi	s1,s1,252 # 8000a038 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006f44:	00003917          	auipc	s2,0x3
    80006f48:	0fc90913          	addi	s2,s2,252 # 8000a040 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006f4c:	85ce                	mv	a1,s3
    80006f4e:	8526                	mv	a0,s1
    80006f50:	ffffa097          	auipc	ra,0xffffa
    80006f54:	610080e7          	jalr	1552(ra) # 80001560 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006f58:	00093703          	ld	a4,0(s2)
    80006f5c:	609c                	ld	a5,0(s1)
    80006f5e:	02078793          	addi	a5,a5,32
    80006f62:	fee785e3          	beq	a5,a4,80006f4c <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006f66:	00020497          	auipc	s1,0x20
    80006f6a:	5e248493          	addi	s1,s1,1506 # 80027548 <uart_tx_lock>
    80006f6e:	01f77793          	andi	a5,a4,31
    80006f72:	97a6                	add	a5,a5,s1
    80006f74:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    80006f78:	0705                	addi	a4,a4,1
    80006f7a:	00003797          	auipc	a5,0x3
    80006f7e:	0ce7b323          	sd	a4,198(a5) # 8000a040 <uart_tx_w>
      uartstart();
    80006f82:	00000097          	auipc	ra,0x0
    80006f86:	ee6080e7          	jalr	-282(ra) # 80006e68 <uartstart>
      release(&uart_tx_lock);
    80006f8a:	8526                	mv	a0,s1
    80006f8c:	00000097          	auipc	ra,0x0
    80006f90:	1d0080e7          	jalr	464(ra) # 8000715c <release>
}
    80006f94:	70a2                	ld	ra,40(sp)
    80006f96:	7402                	ld	s0,32(sp)
    80006f98:	64e2                	ld	s1,24(sp)
    80006f9a:	6942                	ld	s2,16(sp)
    80006f9c:	69a2                	ld	s3,8(sp)
    80006f9e:	6a02                	ld	s4,0(sp)
    80006fa0:	6145                	addi	sp,sp,48
    80006fa2:	8082                	ret

0000000080006fa4 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006fa4:	1141                	addi	sp,sp,-16
    80006fa6:	e422                	sd	s0,8(sp)
    80006fa8:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006faa:	100007b7          	lui	a5,0x10000
    80006fae:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006fb2:	8b85                	andi	a5,a5,1
    80006fb4:	cb81                	beqz	a5,80006fc4 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    80006fb6:	100007b7          	lui	a5,0x10000
    80006fba:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80006fbe:	6422                	ld	s0,8(sp)
    80006fc0:	0141                	addi	sp,sp,16
    80006fc2:	8082                	ret
    return -1;
    80006fc4:	557d                	li	a0,-1
    80006fc6:	bfe5                	j	80006fbe <uartgetc+0x1a>

0000000080006fc8 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006fc8:	1101                	addi	sp,sp,-32
    80006fca:	ec06                	sd	ra,24(sp)
    80006fcc:	e822                	sd	s0,16(sp)
    80006fce:	e426                	sd	s1,8(sp)
    80006fd0:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006fd2:	54fd                	li	s1,-1
    80006fd4:	a029                	j	80006fde <uartintr+0x16>
      break;
    consoleintr(c);
    80006fd6:	00000097          	auipc	ra,0x0
    80006fda:	918080e7          	jalr	-1768(ra) # 800068ee <consoleintr>
    int c = uartgetc();
    80006fde:	00000097          	auipc	ra,0x0
    80006fe2:	fc6080e7          	jalr	-58(ra) # 80006fa4 <uartgetc>
    if(c == -1)
    80006fe6:	fe9518e3          	bne	a0,s1,80006fd6 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006fea:	00020497          	auipc	s1,0x20
    80006fee:	55e48493          	addi	s1,s1,1374 # 80027548 <uart_tx_lock>
    80006ff2:	8526                	mv	a0,s1
    80006ff4:	00000097          	auipc	ra,0x0
    80006ff8:	0b4080e7          	jalr	180(ra) # 800070a8 <acquire>
  uartstart();
    80006ffc:	00000097          	auipc	ra,0x0
    80007000:	e6c080e7          	jalr	-404(ra) # 80006e68 <uartstart>
  release(&uart_tx_lock);
    80007004:	8526                	mv	a0,s1
    80007006:	00000097          	auipc	ra,0x0
    8000700a:	156080e7          	jalr	342(ra) # 8000715c <release>
}
    8000700e:	60e2                	ld	ra,24(sp)
    80007010:	6442                	ld	s0,16(sp)
    80007012:	64a2                	ld	s1,8(sp)
    80007014:	6105                	addi	sp,sp,32
    80007016:	8082                	ret

0000000080007018 <initlock>:
}
#endif

void
initlock(struct spinlock *lk, char *name)
{
    80007018:	1141                	addi	sp,sp,-16
    8000701a:	e422                	sd	s0,8(sp)
    8000701c:	0800                	addi	s0,sp,16
  lk->name = name;
    8000701e:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80007020:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80007024:	00053823          	sd	zero,16(a0)
#ifdef LAB_LOCK
  lk->nts = 0;
  lk->n = 0;
  findslot(lk);
#endif  
}
    80007028:	6422                	ld	s0,8(sp)
    8000702a:	0141                	addi	sp,sp,16
    8000702c:	8082                	ret

000000008000702e <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000702e:	411c                	lw	a5,0(a0)
    80007030:	e399                	bnez	a5,80007036 <holding+0x8>
    80007032:	4501                	li	a0,0
  return r;
}
    80007034:	8082                	ret
{
    80007036:	1101                	addi	sp,sp,-32
    80007038:	ec06                	sd	ra,24(sp)
    8000703a:	e822                	sd	s0,16(sp)
    8000703c:	e426                	sd	s1,8(sp)
    8000703e:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80007040:	6904                	ld	s1,16(a0)
    80007042:	ffffa097          	auipc	ra,0xffffa
    80007046:	e3e080e7          	jalr	-450(ra) # 80000e80 <mycpu>
    8000704a:	40a48533          	sub	a0,s1,a0
    8000704e:	00153513          	seqz	a0,a0
}
    80007052:	60e2                	ld	ra,24(sp)
    80007054:	6442                	ld	s0,16(sp)
    80007056:	64a2                	ld	s1,8(sp)
    80007058:	6105                	addi	sp,sp,32
    8000705a:	8082                	ret

000000008000705c <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    8000705c:	1101                	addi	sp,sp,-32
    8000705e:	ec06                	sd	ra,24(sp)
    80007060:	e822                	sd	s0,16(sp)
    80007062:	e426                	sd	s1,8(sp)
    80007064:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80007066:	100024f3          	csrr	s1,sstatus
    8000706a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000706e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80007070:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80007074:	ffffa097          	auipc	ra,0xffffa
    80007078:	e0c080e7          	jalr	-500(ra) # 80000e80 <mycpu>
    8000707c:	5d3c                	lw	a5,120(a0)
    8000707e:	cf89                	beqz	a5,80007098 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80007080:	ffffa097          	auipc	ra,0xffffa
    80007084:	e00080e7          	jalr	-512(ra) # 80000e80 <mycpu>
    80007088:	5d3c                	lw	a5,120(a0)
    8000708a:	2785                	addiw	a5,a5,1
    8000708c:	dd3c                	sw	a5,120(a0)
}
    8000708e:	60e2                	ld	ra,24(sp)
    80007090:	6442                	ld	s0,16(sp)
    80007092:	64a2                	ld	s1,8(sp)
    80007094:	6105                	addi	sp,sp,32
    80007096:	8082                	ret
    mycpu()->intena = old;
    80007098:	ffffa097          	auipc	ra,0xffffa
    8000709c:	de8080e7          	jalr	-536(ra) # 80000e80 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800070a0:	8085                	srli	s1,s1,0x1
    800070a2:	8885                	andi	s1,s1,1
    800070a4:	dd64                	sw	s1,124(a0)
    800070a6:	bfe9                	j	80007080 <push_off+0x24>

00000000800070a8 <acquire>:
{
    800070a8:	1101                	addi	sp,sp,-32
    800070aa:	ec06                	sd	ra,24(sp)
    800070ac:	e822                	sd	s0,16(sp)
    800070ae:	e426                	sd	s1,8(sp)
    800070b0:	1000                	addi	s0,sp,32
    800070b2:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800070b4:	00000097          	auipc	ra,0x0
    800070b8:	fa8080e7          	jalr	-88(ra) # 8000705c <push_off>
  if(holding(lk))
    800070bc:	8526                	mv	a0,s1
    800070be:	00000097          	auipc	ra,0x0
    800070c2:	f70080e7          	jalr	-144(ra) # 8000702e <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    800070c6:	4705                	li	a4,1
  if(holding(lk))
    800070c8:	e115                	bnez	a0,800070ec <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    800070ca:	87ba                	mv	a5,a4
    800070cc:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800070d0:	2781                	sext.w	a5,a5
    800070d2:	ffe5                	bnez	a5,800070ca <acquire+0x22>
  __sync_synchronize();
    800070d4:	0ff0000f          	fence
  lk->cpu = mycpu();
    800070d8:	ffffa097          	auipc	ra,0xffffa
    800070dc:	da8080e7          	jalr	-600(ra) # 80000e80 <mycpu>
    800070e0:	e888                	sd	a0,16(s1)
}
    800070e2:	60e2                	ld	ra,24(sp)
    800070e4:	6442                	ld	s0,16(sp)
    800070e6:	64a2                	ld	s1,8(sp)
    800070e8:	6105                	addi	sp,sp,32
    800070ea:	8082                	ret
    panic("acquire");
    800070ec:	00002517          	auipc	a0,0x2
    800070f0:	77450513          	addi	a0,a0,1908 # 80009860 <digits+0x20>
    800070f4:	00000097          	auipc	ra,0x0
    800070f8:	a7c080e7          	jalr	-1412(ra) # 80006b70 <panic>

00000000800070fc <pop_off>:

void
pop_off(void)
{
    800070fc:	1141                	addi	sp,sp,-16
    800070fe:	e406                	sd	ra,8(sp)
    80007100:	e022                	sd	s0,0(sp)
    80007102:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80007104:	ffffa097          	auipc	ra,0xffffa
    80007108:	d7c080e7          	jalr	-644(ra) # 80000e80 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000710c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80007110:	8b89                	andi	a5,a5,2
  if(intr_get())
    80007112:	e78d                	bnez	a5,8000713c <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80007114:	5d3c                	lw	a5,120(a0)
    80007116:	02f05b63          	blez	a5,8000714c <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    8000711a:	37fd                	addiw	a5,a5,-1
    8000711c:	0007871b          	sext.w	a4,a5
    80007120:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80007122:	eb09                	bnez	a4,80007134 <pop_off+0x38>
    80007124:	5d7c                	lw	a5,124(a0)
    80007126:	c799                	beqz	a5,80007134 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80007128:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000712c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80007130:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80007134:	60a2                	ld	ra,8(sp)
    80007136:	6402                	ld	s0,0(sp)
    80007138:	0141                	addi	sp,sp,16
    8000713a:	8082                	ret
    panic("pop_off - interruptible");
    8000713c:	00002517          	auipc	a0,0x2
    80007140:	72c50513          	addi	a0,a0,1836 # 80009868 <digits+0x28>
    80007144:	00000097          	auipc	ra,0x0
    80007148:	a2c080e7          	jalr	-1492(ra) # 80006b70 <panic>
    panic("pop_off");
    8000714c:	00002517          	auipc	a0,0x2
    80007150:	73450513          	addi	a0,a0,1844 # 80009880 <digits+0x40>
    80007154:	00000097          	auipc	ra,0x0
    80007158:	a1c080e7          	jalr	-1508(ra) # 80006b70 <panic>

000000008000715c <release>:
{
    8000715c:	1101                	addi	sp,sp,-32
    8000715e:	ec06                	sd	ra,24(sp)
    80007160:	e822                	sd	s0,16(sp)
    80007162:	e426                	sd	s1,8(sp)
    80007164:	1000                	addi	s0,sp,32
    80007166:	84aa                	mv	s1,a0
  if(!holding(lk))
    80007168:	00000097          	auipc	ra,0x0
    8000716c:	ec6080e7          	jalr	-314(ra) # 8000702e <holding>
    80007170:	c115                	beqz	a0,80007194 <release+0x38>
  lk->cpu = 0;
    80007172:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80007176:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    8000717a:	0f50000f          	fence	iorw,ow
    8000717e:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80007182:	00000097          	auipc	ra,0x0
    80007186:	f7a080e7          	jalr	-134(ra) # 800070fc <pop_off>
}
    8000718a:	60e2                	ld	ra,24(sp)
    8000718c:	6442                	ld	s0,16(sp)
    8000718e:	64a2                	ld	s1,8(sp)
    80007190:	6105                	addi	sp,sp,32
    80007192:	8082                	ret
    panic("release");
    80007194:	00002517          	auipc	a0,0x2
    80007198:	6f450513          	addi	a0,a0,1780 # 80009888 <digits+0x48>
    8000719c:	00000097          	auipc	ra,0x0
    800071a0:	9d4080e7          	jalr	-1580(ra) # 80006b70 <panic>

00000000800071a4 <lockfree_read8>:

// Read a shared 64-bit value without holding a lock
uint64
lockfree_read8(uint64 *addr) {
    800071a4:	1141                	addi	sp,sp,-16
    800071a6:	e422                	sd	s0,8(sp)
    800071a8:	0800                	addi	s0,sp,16
  uint64 val;
  __atomic_load(addr, &val, __ATOMIC_SEQ_CST);
    800071aa:	0ff0000f          	fence
    800071ae:	6108                	ld	a0,0(a0)
    800071b0:	0ff0000f          	fence
  return val;
}
    800071b4:	6422                	ld	s0,8(sp)
    800071b6:	0141                	addi	sp,sp,16
    800071b8:	8082                	ret

00000000800071ba <lockfree_read4>:

// Read a shared 32-bit value without holding a lock
int
lockfree_read4(int *addr) {
    800071ba:	1141                	addi	sp,sp,-16
    800071bc:	e422                	sd	s0,8(sp)
    800071be:	0800                	addi	s0,sp,16
  uint32 val;
  __atomic_load(addr, &val, __ATOMIC_SEQ_CST);
    800071c0:	0ff0000f          	fence
    800071c4:	4108                	lw	a0,0(a0)
    800071c6:	0ff0000f          	fence
  return val;
}
    800071ca:	6422                	ld	s0,8(sp)
    800071cc:	0141                	addi	sp,sp,16
    800071ce:	8082                	ret
	...

0000000080008000 <_trampoline>:
    80008000:	14051573          	csrrw	a0,sscratch,a0
    80008004:	02153423          	sd	ra,40(a0)
    80008008:	02253823          	sd	sp,48(a0)
    8000800c:	02353c23          	sd	gp,56(a0)
    80008010:	04453023          	sd	tp,64(a0)
    80008014:	04553423          	sd	t0,72(a0)
    80008018:	04653823          	sd	t1,80(a0)
    8000801c:	04753c23          	sd	t2,88(a0)
    80008020:	f120                	sd	s0,96(a0)
    80008022:	f524                	sd	s1,104(a0)
    80008024:	fd2c                	sd	a1,120(a0)
    80008026:	e150                	sd	a2,128(a0)
    80008028:	e554                	sd	a3,136(a0)
    8000802a:	e958                	sd	a4,144(a0)
    8000802c:	ed5c                	sd	a5,152(a0)
    8000802e:	0b053023          	sd	a6,160(a0)
    80008032:	0b153423          	sd	a7,168(a0)
    80008036:	0b253823          	sd	s2,176(a0)
    8000803a:	0b353c23          	sd	s3,184(a0)
    8000803e:	0d453023          	sd	s4,192(a0)
    80008042:	0d553423          	sd	s5,200(a0)
    80008046:	0d653823          	sd	s6,208(a0)
    8000804a:	0d753c23          	sd	s7,216(a0)
    8000804e:	0f853023          	sd	s8,224(a0)
    80008052:	0f953423          	sd	s9,232(a0)
    80008056:	0fa53823          	sd	s10,240(a0)
    8000805a:	0fb53c23          	sd	s11,248(a0)
    8000805e:	11c53023          	sd	t3,256(a0)
    80008062:	11d53423          	sd	t4,264(a0)
    80008066:	11e53823          	sd	t5,272(a0)
    8000806a:	11f53c23          	sd	t6,280(a0)
    8000806e:	140022f3          	csrr	t0,sscratch
    80008072:	06553823          	sd	t0,112(a0)
    80008076:	00853103          	ld	sp,8(a0)
    8000807a:	02053203          	ld	tp,32(a0)
    8000807e:	01053283          	ld	t0,16(a0)
    80008082:	00053303          	ld	t1,0(a0)
    80008086:	18031073          	csrw	satp,t1
    8000808a:	12000073          	sfence.vma
    8000808e:	8282                	jr	t0

0000000080008090 <userret>:
    80008090:	18059073          	csrw	satp,a1
    80008094:	12000073          	sfence.vma
    80008098:	07053283          	ld	t0,112(a0)
    8000809c:	14029073          	csrw	sscratch,t0
    800080a0:	02853083          	ld	ra,40(a0)
    800080a4:	03053103          	ld	sp,48(a0)
    800080a8:	03853183          	ld	gp,56(a0)
    800080ac:	04053203          	ld	tp,64(a0)
    800080b0:	04853283          	ld	t0,72(a0)
    800080b4:	05053303          	ld	t1,80(a0)
    800080b8:	05853383          	ld	t2,88(a0)
    800080bc:	7120                	ld	s0,96(a0)
    800080be:	7524                	ld	s1,104(a0)
    800080c0:	7d2c                	ld	a1,120(a0)
    800080c2:	6150                	ld	a2,128(a0)
    800080c4:	6554                	ld	a3,136(a0)
    800080c6:	6958                	ld	a4,144(a0)
    800080c8:	6d5c                	ld	a5,152(a0)
    800080ca:	0a053803          	ld	a6,160(a0)
    800080ce:	0a853883          	ld	a7,168(a0)
    800080d2:	0b053903          	ld	s2,176(a0)
    800080d6:	0b853983          	ld	s3,184(a0)
    800080da:	0c053a03          	ld	s4,192(a0)
    800080de:	0c853a83          	ld	s5,200(a0)
    800080e2:	0d053b03          	ld	s6,208(a0)
    800080e6:	0d853b83          	ld	s7,216(a0)
    800080ea:	0e053c03          	ld	s8,224(a0)
    800080ee:	0e853c83          	ld	s9,232(a0)
    800080f2:	0f053d03          	ld	s10,240(a0)
    800080f6:	0f853d83          	ld	s11,248(a0)
    800080fa:	10053e03          	ld	t3,256(a0)
    800080fe:	10853e83          	ld	t4,264(a0)
    80008102:	11053f03          	ld	t5,272(a0)
    80008106:	11853f83          	ld	t6,280(a0)
    8000810a:	14051573          	csrrw	a0,sscratch,a0
    8000810e:	10200073          	sret
	...
