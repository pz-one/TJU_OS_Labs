
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
    80000016:	14d050ef          	jal	ra,80005962 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if (((uint64)pa % PGSIZE) != 0 || (char *)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebd9                	bnez	a5,800000c2 <kfree+0xa6>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00246797          	auipc	a5,0x246
    80000034:	21078793          	addi	a5,a5,528 # 80246240 <end>
    80000038:	08f56563          	bltu	a0,a5,800000c2 <kfree+0xa6>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	08f57163          	bgeu	a0,a5,800000c2 <kfree+0xa6>
    panic("kfree");

  acquire(&PGRefCount.lock);
    80000044:	00009517          	auipc	a0,0x9
    80000048:	00c50513          	addi	a0,a0,12 # 80009050 <PGRefCount>
    8000004c:	00006097          	auipc	ra,0x6
    80000050:	2fc080e7          	jalr	764(ra) # 80006348 <acquire>
  PGRefCount.PGCount[(uint64)pa / PGSIZE]--;
    80000054:	00c4d793          	srli	a5,s1,0xc
    80000058:	0791                	addi	a5,a5,4
    8000005a:	078a                	slli	a5,a5,0x2
    8000005c:	00009717          	auipc	a4,0x9
    80000060:	ff470713          	addi	a4,a4,-12 # 80009050 <PGRefCount>
    80000064:	97ba                	add	a5,a5,a4
    80000066:	4798                	lw	a4,8(a5)
    80000068:	377d                	addiw	a4,a4,-1
    8000006a:	0007069b          	sext.w	a3,a4
    8000006e:	c798                	sw	a4,8(a5)

  if (PGRefCount.PGCount[(uint64)pa / PGSIZE] != 0)
    80000070:	e2ad                	bnez	a3,800000d2 <kfree+0xb6>
  {
    release(&PGRefCount.lock);
    return;
  }
  release(&PGRefCount.lock);
    80000072:	00009517          	auipc	a0,0x9
    80000076:	fde50513          	addi	a0,a0,-34 # 80009050 <PGRefCount>
    8000007a:	00006097          	auipc	ra,0x6
    8000007e:	382080e7          	jalr	898(ra) # 800063fc <release>

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000082:	6605                	lui	a2,0x1
    80000084:	4585                	li	a1,1
    80000086:	8526                	mv	a0,s1
    80000088:	00000097          	auipc	ra,0x0
    8000008c:	236080e7          	jalr	566(ra) # 800002be <memset>

  r = (struct run *)pa;

  acquire(&kmem.lock);
    80000090:	00009917          	auipc	s2,0x9
    80000094:	fa090913          	addi	s2,s2,-96 # 80009030 <kmem>
    80000098:	854a                	mv	a0,s2
    8000009a:	00006097          	auipc	ra,0x6
    8000009e:	2ae080e7          	jalr	686(ra) # 80006348 <acquire>
  r->next = kmem.freelist;
    800000a2:	01893783          	ld	a5,24(s2)
    800000a6:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    800000a8:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    800000ac:	854a                	mv	a0,s2
    800000ae:	00006097          	auipc	ra,0x6
    800000b2:	34e080e7          	jalr	846(ra) # 800063fc <release>
}
    800000b6:	60e2                	ld	ra,24(sp)
    800000b8:	6442                	ld	s0,16(sp)
    800000ba:	64a2                	ld	s1,8(sp)
    800000bc:	6902                	ld	s2,0(sp)
    800000be:	6105                	addi	sp,sp,32
    800000c0:	8082                	ret
    panic("kfree");
    800000c2:	00008517          	auipc	a0,0x8
    800000c6:	f4e50513          	addi	a0,a0,-178 # 80008010 <etext+0x10>
    800000ca:	00006097          	auipc	ra,0x6
    800000ce:	d46080e7          	jalr	-698(ra) # 80005e10 <panic>
    release(&PGRefCount.lock);
    800000d2:	00009517          	auipc	a0,0x9
    800000d6:	f7e50513          	addi	a0,a0,-130 # 80009050 <PGRefCount>
    800000da:	00006097          	auipc	ra,0x6
    800000de:	322080e7          	jalr	802(ra) # 800063fc <release>
    return;
    800000e2:	bfd1                	j	800000b6 <kfree+0x9a>

00000000800000e4 <freerange>:
{
    800000e4:	7139                	addi	sp,sp,-64
    800000e6:	fc06                	sd	ra,56(sp)
    800000e8:	f822                	sd	s0,48(sp)
    800000ea:	f426                	sd	s1,40(sp)
    800000ec:	f04a                	sd	s2,32(sp)
    800000ee:	ec4e                	sd	s3,24(sp)
    800000f0:	e852                	sd	s4,16(sp)
    800000f2:	e456                	sd	s5,8(sp)
    800000f4:	e05a                	sd	s6,0(sp)
    800000f6:	0080                	addi	s0,sp,64
  p = (char *)PGROUNDUP((uint64)pa_start);
    800000f8:	6785                	lui	a5,0x1
    800000fa:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000fe:	953a                	add	a0,a0,a4
    80000100:	777d                	lui	a4,0xfffff
    80000102:	00e574b3          	and	s1,a0,a4
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000106:	97a6                	add	a5,a5,s1
    80000108:	02f5eb63          	bltu	a1,a5,8000013e <freerange+0x5a>
    8000010c:	892e                	mv	s2,a1
    PGRefCount.PGCount[(uint64)p / PGSIZE] = 1;
    8000010e:	00009b17          	auipc	s6,0x9
    80000112:	f42b0b13          	addi	s6,s6,-190 # 80009050 <PGRefCount>
    80000116:	4a85                	li	s5,1
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000118:	6a05                	lui	s4,0x1
    8000011a:	6989                	lui	s3,0x2
    PGRefCount.PGCount[(uint64)p / PGSIZE] = 1;
    8000011c:	00c4d793          	srli	a5,s1,0xc
    80000120:	0791                	addi	a5,a5,4
    80000122:	078a                	slli	a5,a5,0x2
    80000124:	97da                	add	a5,a5,s6
    80000126:	0157a423          	sw	s5,8(a5)
    kfree(p);
    8000012a:	8526                	mv	a0,s1
    8000012c:	00000097          	auipc	ra,0x0
    80000130:	ef0080e7          	jalr	-272(ra) # 8000001c <kfree>
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000134:	87a6                	mv	a5,s1
    80000136:	94d2                	add	s1,s1,s4
    80000138:	97ce                	add	a5,a5,s3
    8000013a:	fef971e3          	bgeu	s2,a5,8000011c <freerange+0x38>
}
    8000013e:	70e2                	ld	ra,56(sp)
    80000140:	7442                	ld	s0,48(sp)
    80000142:	74a2                	ld	s1,40(sp)
    80000144:	7902                	ld	s2,32(sp)
    80000146:	69e2                	ld	s3,24(sp)
    80000148:	6a42                	ld	s4,16(sp)
    8000014a:	6aa2                	ld	s5,8(sp)
    8000014c:	6b02                	ld	s6,0(sp)
    8000014e:	6121                	addi	sp,sp,64
    80000150:	8082                	ret

0000000080000152 <kinit>:
{
    80000152:	1141                	addi	sp,sp,-16
    80000154:	e406                	sd	ra,8(sp)
    80000156:	e022                	sd	s0,0(sp)
    80000158:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    8000015a:	00008597          	auipc	a1,0x8
    8000015e:	ebe58593          	addi	a1,a1,-322 # 80008018 <etext+0x18>
    80000162:	00009517          	auipc	a0,0x9
    80000166:	ece50513          	addi	a0,a0,-306 # 80009030 <kmem>
    8000016a:	00006097          	auipc	ra,0x6
    8000016e:	14e080e7          	jalr	334(ra) # 800062b8 <initlock>
  initlock(&PGRefCount.lock, "PGRefCount"); // 初始化PGRefCount锁
    80000172:	00008597          	auipc	a1,0x8
    80000176:	eae58593          	addi	a1,a1,-338 # 80008020 <etext+0x20>
    8000017a:	00009517          	auipc	a0,0x9
    8000017e:	ed650513          	addi	a0,a0,-298 # 80009050 <PGRefCount>
    80000182:	00006097          	auipc	ra,0x6
    80000186:	136080e7          	jalr	310(ra) # 800062b8 <initlock>
  freerange(end, (void *)PHYSTOP);
    8000018a:	45c5                	li	a1,17
    8000018c:	05ee                	slli	a1,a1,0x1b
    8000018e:	00246517          	auipc	a0,0x246
    80000192:	0b250513          	addi	a0,a0,178 # 80246240 <end>
    80000196:	00000097          	auipc	ra,0x0
    8000019a:	f4e080e7          	jalr	-178(ra) # 800000e4 <freerange>
}
    8000019e:	60a2                	ld	ra,8(sp)
    800001a0:	6402                	ld	s0,0(sp)
    800001a2:	0141                	addi	sp,sp,16
    800001a4:	8082                	ret

00000000800001a6 <kalloc>:

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *kalloc(void)
{
    800001a6:	1101                	addi	sp,sp,-32
    800001a8:	ec06                	sd	ra,24(sp)
    800001aa:	e822                	sd	s0,16(sp)
    800001ac:	e426                	sd	s1,8(sp)
    800001ae:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    800001b0:	00009497          	auipc	s1,0x9
    800001b4:	e8048493          	addi	s1,s1,-384 # 80009030 <kmem>
    800001b8:	8526                	mv	a0,s1
    800001ba:	00006097          	auipc	ra,0x6
    800001be:	18e080e7          	jalr	398(ra) # 80006348 <acquire>
  r = kmem.freelist;
    800001c2:	6c84                	ld	s1,24(s1)
  if (r)
    800001c4:	ccb9                	beqz	s1,80000222 <kalloc+0x7c>
    kmem.freelist = r->next;
    800001c6:	609c                	ld	a5,0(s1)
    800001c8:	00009517          	auipc	a0,0x9
    800001cc:	e6850513          	addi	a0,a0,-408 # 80009030 <kmem>
    800001d0:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    800001d2:	00006097          	auipc	ra,0x6
    800001d6:	22a080e7          	jalr	554(ra) # 800063fc <release>

  // pgcount初值赋为1
  if (r)
  {
    acquire(&PGRefCount.lock);
    800001da:	00009517          	auipc	a0,0x9
    800001de:	e7650513          	addi	a0,a0,-394 # 80009050 <PGRefCount>
    800001e2:	00006097          	auipc	ra,0x6
    800001e6:	166080e7          	jalr	358(ra) # 80006348 <acquire>
    PGRefCount.PGCount[(uint64)r / PGSIZE] = 1;
    800001ea:	00009517          	auipc	a0,0x9
    800001ee:	e6650513          	addi	a0,a0,-410 # 80009050 <PGRefCount>
    800001f2:	00c4d793          	srli	a5,s1,0xc
    800001f6:	0791                	addi	a5,a5,4
    800001f8:	078a                	slli	a5,a5,0x2
    800001fa:	97aa                	add	a5,a5,a0
    800001fc:	4705                	li	a4,1
    800001fe:	c798                	sw	a4,8(a5)
    release(&PGRefCount.lock);
    80000200:	00006097          	auipc	ra,0x6
    80000204:	1fc080e7          	jalr	508(ra) # 800063fc <release>
  }

  if (r)
    memset((char *)r, 5, PGSIZE); // fill with junk
    80000208:	6605                	lui	a2,0x1
    8000020a:	4595                	li	a1,5
    8000020c:	8526                	mv	a0,s1
    8000020e:	00000097          	auipc	ra,0x0
    80000212:	0b0080e7          	jalr	176(ra) # 800002be <memset>
  return (void *)r;
}
    80000216:	8526                	mv	a0,s1
    80000218:	60e2                	ld	ra,24(sp)
    8000021a:	6442                	ld	s0,16(sp)
    8000021c:	64a2                	ld	s1,8(sp)
    8000021e:	6105                	addi	sp,sp,32
    80000220:	8082                	ret
  release(&kmem.lock);
    80000222:	00009517          	auipc	a0,0x9
    80000226:	e0e50513          	addi	a0,a0,-498 # 80009030 <kmem>
    8000022a:	00006097          	auipc	ra,0x6
    8000022e:	1d2080e7          	jalr	466(ra) # 800063fc <release>
  if (r)
    80000232:	b7d5                	j	80000216 <kalloc+0x70>

0000000080000234 <AddPGRefCount>:

int AddPGRefCount(void *pa)
{
  if (((uint64)pa % PGSIZE))
    80000234:	03451793          	slli	a5,a0,0x34
    80000238:	efb1                	bnez	a5,80000294 <AddPGRefCount+0x60>
{
    8000023a:	1101                	addi	sp,sp,-32
    8000023c:	ec06                	sd	ra,24(sp)
    8000023e:	e822                	sd	s0,16(sp)
    80000240:	e426                	sd	s1,8(sp)
    80000242:	1000                	addi	s0,sp,32
    80000244:	84aa                	mv	s1,a0
  {
    return -1;
  }
  if ((char *)pa < end || (uint64)pa >= PHYSTOP)
    80000246:	00246797          	auipc	a5,0x246
    8000024a:	ffa78793          	addi	a5,a5,-6 # 80246240 <end>
    8000024e:	04f56563          	bltu	a0,a5,80000298 <AddPGRefCount+0x64>
    80000252:	47c5                	li	a5,17
    80000254:	07ee                	slli	a5,a5,0x1b
    80000256:	04f57363          	bgeu	a0,a5,8000029c <AddPGRefCount+0x68>
  {
    return -1;
  }
  acquire(&PGRefCount.lock);
    8000025a:	00009517          	auipc	a0,0x9
    8000025e:	df650513          	addi	a0,a0,-522 # 80009050 <PGRefCount>
    80000262:	00006097          	auipc	ra,0x6
    80000266:	0e6080e7          	jalr	230(ra) # 80006348 <acquire>
  PGRefCount.PGCount[(uint64)pa / PGSIZE]++;
    8000026a:	80b1                	srli	s1,s1,0xc
    8000026c:	00009517          	auipc	a0,0x9
    80000270:	de450513          	addi	a0,a0,-540 # 80009050 <PGRefCount>
    80000274:	0491                	addi	s1,s1,4
    80000276:	048a                	slli	s1,s1,0x2
    80000278:	94aa                	add	s1,s1,a0
    8000027a:	449c                	lw	a5,8(s1)
    8000027c:	2785                	addiw	a5,a5,1
    8000027e:	c49c                	sw	a5,8(s1)
  release(&PGRefCount.lock);
    80000280:	00006097          	auipc	ra,0x6
    80000284:	17c080e7          	jalr	380(ra) # 800063fc <release>
  return 0;
    80000288:	4501                	li	a0,0
}
    8000028a:	60e2                	ld	ra,24(sp)
    8000028c:	6442                	ld	s0,16(sp)
    8000028e:	64a2                	ld	s1,8(sp)
    80000290:	6105                	addi	sp,sp,32
    80000292:	8082                	ret
    return -1;
    80000294:	557d                	li	a0,-1
}
    80000296:	8082                	ret
    return -1;
    80000298:	557d                	li	a0,-1
    8000029a:	bfc5                	j	8000028a <AddPGRefCount+0x56>
    8000029c:	557d                	li	a0,-1
    8000029e:	b7f5                	j	8000028a <AddPGRefCount+0x56>

00000000800002a0 <GetPGRefCount>:

int GetPGRefCount(void *pa)
{
    800002a0:	1141                	addi	sp,sp,-16
    800002a2:	e422                	sd	s0,8(sp)
    800002a4:	0800                	addi	s0,sp,16
  return PGRefCount.PGCount[(uint64)pa / PGSIZE];
    800002a6:	8131                	srli	a0,a0,0xc
    800002a8:	0511                	addi	a0,a0,4
    800002aa:	050a                	slli	a0,a0,0x2
    800002ac:	00009797          	auipc	a5,0x9
    800002b0:	da478793          	addi	a5,a5,-604 # 80009050 <PGRefCount>
    800002b4:	97aa                	add	a5,a5,a0
}
    800002b6:	4788                	lw	a0,8(a5)
    800002b8:	6422                	ld	s0,8(sp)
    800002ba:	0141                	addi	sp,sp,16
    800002bc:	8082                	ret

00000000800002be <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    800002be:	1141                	addi	sp,sp,-16
    800002c0:	e422                	sd	s0,8(sp)
    800002c2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    800002c4:	ca19                	beqz	a2,800002da <memset+0x1c>
    800002c6:	87aa                	mv	a5,a0
    800002c8:	1602                	slli	a2,a2,0x20
    800002ca:	9201                	srli	a2,a2,0x20
    800002cc:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    800002d0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800002d4:	0785                	addi	a5,a5,1
    800002d6:	fee79de3          	bne	a5,a4,800002d0 <memset+0x12>
  }
  return dst;
}
    800002da:	6422                	ld	s0,8(sp)
    800002dc:	0141                	addi	sp,sp,16
    800002de:	8082                	ret

00000000800002e0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800002e0:	1141                	addi	sp,sp,-16
    800002e2:	e422                	sd	s0,8(sp)
    800002e4:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800002e6:	ca05                	beqz	a2,80000316 <memcmp+0x36>
    800002e8:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800002ec:	1682                	slli	a3,a3,0x20
    800002ee:	9281                	srli	a3,a3,0x20
    800002f0:	0685                	addi	a3,a3,1
    800002f2:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800002f4:	00054783          	lbu	a5,0(a0)
    800002f8:	0005c703          	lbu	a4,0(a1)
    800002fc:	00e79863          	bne	a5,a4,8000030c <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000300:	0505                	addi	a0,a0,1
    80000302:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000304:	fed518e3          	bne	a0,a3,800002f4 <memcmp+0x14>
  }

  return 0;
    80000308:	4501                	li	a0,0
    8000030a:	a019                	j	80000310 <memcmp+0x30>
      return *s1 - *s2;
    8000030c:	40e7853b          	subw	a0,a5,a4
}
    80000310:	6422                	ld	s0,8(sp)
    80000312:	0141                	addi	sp,sp,16
    80000314:	8082                	ret
  return 0;
    80000316:	4501                	li	a0,0
    80000318:	bfe5                	j	80000310 <memcmp+0x30>

000000008000031a <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    8000031a:	1141                	addi	sp,sp,-16
    8000031c:	e422                	sd	s0,8(sp)
    8000031e:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000320:	c205                	beqz	a2,80000340 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000322:	02a5e263          	bltu	a1,a0,80000346 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000326:	1602                	slli	a2,a2,0x20
    80000328:	9201                	srli	a2,a2,0x20
    8000032a:	00c587b3          	add	a5,a1,a2
{
    8000032e:	872a                	mv	a4,a0
      *d++ = *s++;
    80000330:	0585                	addi	a1,a1,1
    80000332:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7fdb8dc1>
    80000334:	fff5c683          	lbu	a3,-1(a1)
    80000338:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    8000033c:	fef59ae3          	bne	a1,a5,80000330 <memmove+0x16>

  return dst;
}
    80000340:	6422                	ld	s0,8(sp)
    80000342:	0141                	addi	sp,sp,16
    80000344:	8082                	ret
  if(s < d && s + n > d){
    80000346:	02061693          	slli	a3,a2,0x20
    8000034a:	9281                	srli	a3,a3,0x20
    8000034c:	00d58733          	add	a4,a1,a3
    80000350:	fce57be3          	bgeu	a0,a4,80000326 <memmove+0xc>
    d += n;
    80000354:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000356:	fff6079b          	addiw	a5,a2,-1
    8000035a:	1782                	slli	a5,a5,0x20
    8000035c:	9381                	srli	a5,a5,0x20
    8000035e:	fff7c793          	not	a5,a5
    80000362:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000364:	177d                	addi	a4,a4,-1
    80000366:	16fd                	addi	a3,a3,-1
    80000368:	00074603          	lbu	a2,0(a4)
    8000036c:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000370:	fee79ae3          	bne	a5,a4,80000364 <memmove+0x4a>
    80000374:	b7f1                	j	80000340 <memmove+0x26>

0000000080000376 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000376:	1141                	addi	sp,sp,-16
    80000378:	e406                	sd	ra,8(sp)
    8000037a:	e022                	sd	s0,0(sp)
    8000037c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000037e:	00000097          	auipc	ra,0x0
    80000382:	f9c080e7          	jalr	-100(ra) # 8000031a <memmove>
}
    80000386:	60a2                	ld	ra,8(sp)
    80000388:	6402                	ld	s0,0(sp)
    8000038a:	0141                	addi	sp,sp,16
    8000038c:	8082                	ret

000000008000038e <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000038e:	1141                	addi	sp,sp,-16
    80000390:	e422                	sd	s0,8(sp)
    80000392:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000394:	ce11                	beqz	a2,800003b0 <strncmp+0x22>
    80000396:	00054783          	lbu	a5,0(a0)
    8000039a:	cf89                	beqz	a5,800003b4 <strncmp+0x26>
    8000039c:	0005c703          	lbu	a4,0(a1)
    800003a0:	00f71a63          	bne	a4,a5,800003b4 <strncmp+0x26>
    n--, p++, q++;
    800003a4:	367d                	addiw	a2,a2,-1
    800003a6:	0505                	addi	a0,a0,1
    800003a8:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    800003aa:	f675                	bnez	a2,80000396 <strncmp+0x8>
  if(n == 0)
    return 0;
    800003ac:	4501                	li	a0,0
    800003ae:	a809                	j	800003c0 <strncmp+0x32>
    800003b0:	4501                	li	a0,0
    800003b2:	a039                	j	800003c0 <strncmp+0x32>
  if(n == 0)
    800003b4:	ca09                	beqz	a2,800003c6 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    800003b6:	00054503          	lbu	a0,0(a0)
    800003ba:	0005c783          	lbu	a5,0(a1)
    800003be:	9d1d                	subw	a0,a0,a5
}
    800003c0:	6422                	ld	s0,8(sp)
    800003c2:	0141                	addi	sp,sp,16
    800003c4:	8082                	ret
    return 0;
    800003c6:	4501                	li	a0,0
    800003c8:	bfe5                	j	800003c0 <strncmp+0x32>

00000000800003ca <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800003ca:	1141                	addi	sp,sp,-16
    800003cc:	e422                	sd	s0,8(sp)
    800003ce:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800003d0:	872a                	mv	a4,a0
    800003d2:	8832                	mv	a6,a2
    800003d4:	367d                	addiw	a2,a2,-1
    800003d6:	01005963          	blez	a6,800003e8 <strncpy+0x1e>
    800003da:	0705                	addi	a4,a4,1
    800003dc:	0005c783          	lbu	a5,0(a1)
    800003e0:	fef70fa3          	sb	a5,-1(a4)
    800003e4:	0585                	addi	a1,a1,1
    800003e6:	f7f5                	bnez	a5,800003d2 <strncpy+0x8>
    ;
  while(n-- > 0)
    800003e8:	86ba                	mv	a3,a4
    800003ea:	00c05c63          	blez	a2,80000402 <strncpy+0x38>
    *s++ = 0;
    800003ee:	0685                	addi	a3,a3,1
    800003f0:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800003f4:	40d707bb          	subw	a5,a4,a3
    800003f8:	37fd                	addiw	a5,a5,-1
    800003fa:	010787bb          	addw	a5,a5,a6
    800003fe:	fef048e3          	bgtz	a5,800003ee <strncpy+0x24>
  return os;
}
    80000402:	6422                	ld	s0,8(sp)
    80000404:	0141                	addi	sp,sp,16
    80000406:	8082                	ret

0000000080000408 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000408:	1141                	addi	sp,sp,-16
    8000040a:	e422                	sd	s0,8(sp)
    8000040c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    8000040e:	02c05363          	blez	a2,80000434 <safestrcpy+0x2c>
    80000412:	fff6069b          	addiw	a3,a2,-1
    80000416:	1682                	slli	a3,a3,0x20
    80000418:	9281                	srli	a3,a3,0x20
    8000041a:	96ae                	add	a3,a3,a1
    8000041c:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    8000041e:	00d58963          	beq	a1,a3,80000430 <safestrcpy+0x28>
    80000422:	0585                	addi	a1,a1,1
    80000424:	0785                	addi	a5,a5,1
    80000426:	fff5c703          	lbu	a4,-1(a1)
    8000042a:	fee78fa3          	sb	a4,-1(a5)
    8000042e:	fb65                	bnez	a4,8000041e <safestrcpy+0x16>
    ;
  *s = 0;
    80000430:	00078023          	sb	zero,0(a5)
  return os;
}
    80000434:	6422                	ld	s0,8(sp)
    80000436:	0141                	addi	sp,sp,16
    80000438:	8082                	ret

000000008000043a <strlen>:

int
strlen(const char *s)
{
    8000043a:	1141                	addi	sp,sp,-16
    8000043c:	e422                	sd	s0,8(sp)
    8000043e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000440:	00054783          	lbu	a5,0(a0)
    80000444:	cf91                	beqz	a5,80000460 <strlen+0x26>
    80000446:	0505                	addi	a0,a0,1
    80000448:	87aa                	mv	a5,a0
    8000044a:	4685                	li	a3,1
    8000044c:	9e89                	subw	a3,a3,a0
    8000044e:	00f6853b          	addw	a0,a3,a5
    80000452:	0785                	addi	a5,a5,1
    80000454:	fff7c703          	lbu	a4,-1(a5)
    80000458:	fb7d                	bnez	a4,8000044e <strlen+0x14>
    ;
  return n;
}
    8000045a:	6422                	ld	s0,8(sp)
    8000045c:	0141                	addi	sp,sp,16
    8000045e:	8082                	ret
  for(n = 0; s[n]; n++)
    80000460:	4501                	li	a0,0
    80000462:	bfe5                	j	8000045a <strlen+0x20>

0000000080000464 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000464:	1141                	addi	sp,sp,-16
    80000466:	e406                	sd	ra,8(sp)
    80000468:	e022                	sd	s0,0(sp)
    8000046a:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000046c:	00001097          	auipc	ra,0x1
    80000470:	b06080e7          	jalr	-1274(ra) # 80000f72 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000474:	00009717          	auipc	a4,0x9
    80000478:	b8c70713          	addi	a4,a4,-1140 # 80009000 <started>
  if(cpuid() == 0){
    8000047c:	c139                	beqz	a0,800004c2 <main+0x5e>
    while(started == 0)
    8000047e:	431c                	lw	a5,0(a4)
    80000480:	2781                	sext.w	a5,a5
    80000482:	dff5                	beqz	a5,8000047e <main+0x1a>
      ;
    __sync_synchronize();
    80000484:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000488:	00001097          	auipc	ra,0x1
    8000048c:	aea080e7          	jalr	-1302(ra) # 80000f72 <cpuid>
    80000490:	85aa                	mv	a1,a0
    80000492:	00008517          	auipc	a0,0x8
    80000496:	bb650513          	addi	a0,a0,-1098 # 80008048 <etext+0x48>
    8000049a:	00006097          	auipc	ra,0x6
    8000049e:	9c0080e7          	jalr	-1600(ra) # 80005e5a <printf>
    kvminithart();    // turn on paging
    800004a2:	00000097          	auipc	ra,0x0
    800004a6:	0d8080e7          	jalr	216(ra) # 8000057a <kvminithart>
    trapinithart();   // install kernel trap vector
    800004aa:	00002097          	auipc	ra,0x2
    800004ae:	8c8080e7          	jalr	-1848(ra) # 80001d72 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    800004b2:	00005097          	auipc	ra,0x5
    800004b6:	e8e080e7          	jalr	-370(ra) # 80005340 <plicinithart>
  }

  scheduler();        
    800004ba:	00001097          	auipc	ra,0x1
    800004be:	ff6080e7          	jalr	-10(ra) # 800014b0 <scheduler>
    consoleinit();
    800004c2:	00006097          	auipc	ra,0x6
    800004c6:	85e080e7          	jalr	-1954(ra) # 80005d20 <consoleinit>
    printfinit();
    800004ca:	00006097          	auipc	ra,0x6
    800004ce:	b70080e7          	jalr	-1168(ra) # 8000603a <printfinit>
    printf("\n");
    800004d2:	00008517          	auipc	a0,0x8
    800004d6:	b8650513          	addi	a0,a0,-1146 # 80008058 <etext+0x58>
    800004da:	00006097          	auipc	ra,0x6
    800004de:	980080e7          	jalr	-1664(ra) # 80005e5a <printf>
    printf("xv6 kernel is booting\n");
    800004e2:	00008517          	auipc	a0,0x8
    800004e6:	b4e50513          	addi	a0,a0,-1202 # 80008030 <etext+0x30>
    800004ea:	00006097          	auipc	ra,0x6
    800004ee:	970080e7          	jalr	-1680(ra) # 80005e5a <printf>
    printf("\n");
    800004f2:	00008517          	auipc	a0,0x8
    800004f6:	b6650513          	addi	a0,a0,-1178 # 80008058 <etext+0x58>
    800004fa:	00006097          	auipc	ra,0x6
    800004fe:	960080e7          	jalr	-1696(ra) # 80005e5a <printf>
    kinit();         // physical page allocator
    80000502:	00000097          	auipc	ra,0x0
    80000506:	c50080e7          	jalr	-944(ra) # 80000152 <kinit>
    kvminit();       // create kernel page table
    8000050a:	00000097          	auipc	ra,0x0
    8000050e:	322080e7          	jalr	802(ra) # 8000082c <kvminit>
    kvminithart();   // turn on paging
    80000512:	00000097          	auipc	ra,0x0
    80000516:	068080e7          	jalr	104(ra) # 8000057a <kvminithart>
    procinit();      // process table
    8000051a:	00001097          	auipc	ra,0x1
    8000051e:	9a8080e7          	jalr	-1624(ra) # 80000ec2 <procinit>
    trapinit();      // trap vectors
    80000522:	00002097          	auipc	ra,0x2
    80000526:	828080e7          	jalr	-2008(ra) # 80001d4a <trapinit>
    trapinithart();  // install kernel trap vector
    8000052a:	00002097          	auipc	ra,0x2
    8000052e:	848080e7          	jalr	-1976(ra) # 80001d72 <trapinithart>
    plicinit();      // set up interrupt controller
    80000532:	00005097          	auipc	ra,0x5
    80000536:	df8080e7          	jalr	-520(ra) # 8000532a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000053a:	00005097          	auipc	ra,0x5
    8000053e:	e06080e7          	jalr	-506(ra) # 80005340 <plicinithart>
    binit();         // buffer cache
    80000542:	00002097          	auipc	ra,0x2
    80000546:	fce080e7          	jalr	-50(ra) # 80002510 <binit>
    iinit();         // inode table
    8000054a:	00002097          	auipc	ra,0x2
    8000054e:	65c080e7          	jalr	1628(ra) # 80002ba6 <iinit>
    fileinit();      // file table
    80000552:	00003097          	auipc	ra,0x3
    80000556:	60e080e7          	jalr	1550(ra) # 80003b60 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000055a:	00005097          	auipc	ra,0x5
    8000055e:	f06080e7          	jalr	-250(ra) # 80005460 <virtio_disk_init>
    userinit();      // first user process
    80000562:	00001097          	auipc	ra,0x1
    80000566:	d14080e7          	jalr	-748(ra) # 80001276 <userinit>
    __sync_synchronize();
    8000056a:	0ff0000f          	fence
    started = 1;
    8000056e:	4785                	li	a5,1
    80000570:	00009717          	auipc	a4,0x9
    80000574:	a8f72823          	sw	a5,-1392(a4) # 80009000 <started>
    80000578:	b789                	j	800004ba <main+0x56>

000000008000057a <kvminithart>:
}

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void kvminithart()
{
    8000057a:	1141                	addi	sp,sp,-16
    8000057c:	e422                	sd	s0,8(sp)
    8000057e:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000580:	00009797          	auipc	a5,0x9
    80000584:	a887b783          	ld	a5,-1400(a5) # 80009008 <kernel_pagetable>
    80000588:	83b1                	srli	a5,a5,0xc
    8000058a:	577d                	li	a4,-1
    8000058c:	177e                	slli	a4,a4,0x3f
    8000058e:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    80000590:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000594:	12000073          	sfence.vma
  sfence_vma();
}
    80000598:	6422                	ld	s0,8(sp)
    8000059a:	0141                	addi	sp,sp,16
    8000059c:	8082                	ret

000000008000059e <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000059e:	7139                	addi	sp,sp,-64
    800005a0:	fc06                	sd	ra,56(sp)
    800005a2:	f822                	sd	s0,48(sp)
    800005a4:	f426                	sd	s1,40(sp)
    800005a6:	f04a                	sd	s2,32(sp)
    800005a8:	ec4e                	sd	s3,24(sp)
    800005aa:	e852                	sd	s4,16(sp)
    800005ac:	e456                	sd	s5,8(sp)
    800005ae:	e05a                	sd	s6,0(sp)
    800005b0:	0080                	addi	s0,sp,64
    800005b2:	84aa                	mv	s1,a0
    800005b4:	89ae                	mv	s3,a1
    800005b6:	8ab2                	mv	s5,a2
  if (va >= MAXVA)
    800005b8:	57fd                	li	a5,-1
    800005ba:	83e9                	srli	a5,a5,0x1a
    800005bc:	4a79                	li	s4,30
    panic("walk");

  for (int level = 2; level > 0; level--)
    800005be:	4b31                	li	s6,12
  if (va >= MAXVA)
    800005c0:	04b7f263          	bgeu	a5,a1,80000604 <walk+0x66>
    panic("walk");
    800005c4:	00008517          	auipc	a0,0x8
    800005c8:	a9c50513          	addi	a0,a0,-1380 # 80008060 <etext+0x60>
    800005cc:	00006097          	auipc	ra,0x6
    800005d0:	844080e7          	jalr	-1980(ra) # 80005e10 <panic>
    {
      pagetable = (pagetable_t)PTE2PA(*pte);
    }
    else
    {
      if (!alloc || (pagetable = (pde_t *)kalloc()) == 0)
    800005d4:	060a8663          	beqz	s5,80000640 <walk+0xa2>
    800005d8:	00000097          	auipc	ra,0x0
    800005dc:	bce080e7          	jalr	-1074(ra) # 800001a6 <kalloc>
    800005e0:	84aa                	mv	s1,a0
    800005e2:	c529                	beqz	a0,8000062c <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800005e4:	6605                	lui	a2,0x1
    800005e6:	4581                	li	a1,0
    800005e8:	00000097          	auipc	ra,0x0
    800005ec:	cd6080e7          	jalr	-810(ra) # 800002be <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800005f0:	00c4d793          	srli	a5,s1,0xc
    800005f4:	07aa                	slli	a5,a5,0xa
    800005f6:	0017e793          	ori	a5,a5,1
    800005fa:	00f93023          	sd	a5,0(s2)
  for (int level = 2; level > 0; level--)
    800005fe:	3a5d                	addiw	s4,s4,-9 # ff7 <_entry-0x7ffff009>
    80000600:	036a0063          	beq	s4,s6,80000620 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80000604:	0149d933          	srl	s2,s3,s4
    80000608:	1ff97913          	andi	s2,s2,511
    8000060c:	090e                	slli	s2,s2,0x3
    8000060e:	9926                	add	s2,s2,s1
    if (*pte & PTE_V)
    80000610:	00093483          	ld	s1,0(s2)
    80000614:	0014f793          	andi	a5,s1,1
    80000618:	dfd5                	beqz	a5,800005d4 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000061a:	80a9                	srli	s1,s1,0xa
    8000061c:	04b2                	slli	s1,s1,0xc
    8000061e:	b7c5                	j	800005fe <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80000620:	00c9d513          	srli	a0,s3,0xc
    80000624:	1ff57513          	andi	a0,a0,511
    80000628:	050e                	slli	a0,a0,0x3
    8000062a:	9526                	add	a0,a0,s1
}
    8000062c:	70e2                	ld	ra,56(sp)
    8000062e:	7442                	ld	s0,48(sp)
    80000630:	74a2                	ld	s1,40(sp)
    80000632:	7902                	ld	s2,32(sp)
    80000634:	69e2                	ld	s3,24(sp)
    80000636:	6a42                	ld	s4,16(sp)
    80000638:	6aa2                	ld	s5,8(sp)
    8000063a:	6b02                	ld	s6,0(sp)
    8000063c:	6121                	addi	sp,sp,64
    8000063e:	8082                	ret
        return 0;
    80000640:	4501                	li	a0,0
    80000642:	b7ed                	j	8000062c <walk+0x8e>

0000000080000644 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if (va >= MAXVA)
    80000644:	57fd                	li	a5,-1
    80000646:	83e9                	srli	a5,a5,0x1a
    80000648:	00b7f463          	bgeu	a5,a1,80000650 <walkaddr+0xc>
    return 0;
    8000064c:	4501                	li	a0,0
    return 0;
  if ((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000064e:	8082                	ret
{
    80000650:	1141                	addi	sp,sp,-16
    80000652:	e406                	sd	ra,8(sp)
    80000654:	e022                	sd	s0,0(sp)
    80000656:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000658:	4601                	li	a2,0
    8000065a:	00000097          	auipc	ra,0x0
    8000065e:	f44080e7          	jalr	-188(ra) # 8000059e <walk>
  if (pte == 0)
    80000662:	c105                	beqz	a0,80000682 <walkaddr+0x3e>
  if ((*pte & PTE_V) == 0)
    80000664:	611c                	ld	a5,0(a0)
  if ((*pte & PTE_U) == 0)
    80000666:	0117f693          	andi	a3,a5,17
    8000066a:	4745                	li	a4,17
    return 0;
    8000066c:	4501                	li	a0,0
  if ((*pte & PTE_U) == 0)
    8000066e:	00e68663          	beq	a3,a4,8000067a <walkaddr+0x36>
}
    80000672:	60a2                	ld	ra,8(sp)
    80000674:	6402                	ld	s0,0(sp)
    80000676:	0141                	addi	sp,sp,16
    80000678:	8082                	ret
  pa = PTE2PA(*pte);
    8000067a:	83a9                	srli	a5,a5,0xa
    8000067c:	00c79513          	slli	a0,a5,0xc
  return pa;
    80000680:	bfcd                	j	80000672 <walkaddr+0x2e>
    return 0;
    80000682:	4501                	li	a0,0
    80000684:	b7fd                	j	80000672 <walkaddr+0x2e>

0000000080000686 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000686:	715d                	addi	sp,sp,-80
    80000688:	e486                	sd	ra,72(sp)
    8000068a:	e0a2                	sd	s0,64(sp)
    8000068c:	fc26                	sd	s1,56(sp)
    8000068e:	f84a                	sd	s2,48(sp)
    80000690:	f44e                	sd	s3,40(sp)
    80000692:	f052                	sd	s4,32(sp)
    80000694:	ec56                	sd	s5,24(sp)
    80000696:	e85a                	sd	s6,16(sp)
    80000698:	e45e                	sd	s7,8(sp)
    8000069a:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if (size == 0)
    8000069c:	c639                	beqz	a2,800006ea <mappages+0x64>
    8000069e:	8aaa                	mv	s5,a0
    800006a0:	8b3a                	mv	s6,a4
    panic("mappages: size");

  a = PGROUNDDOWN(va);
    800006a2:	777d                	lui	a4,0xfffff
    800006a4:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    800006a8:	fff58993          	addi	s3,a1,-1
    800006ac:	99b2                	add	s3,s3,a2
    800006ae:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    800006b2:	893e                	mv	s2,a5
    800006b4:	40f68a33          	sub	s4,a3,a5
    if (*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if (a == last)
      break;
    a += PGSIZE;
    800006b8:	6b85                	lui	s7,0x1
    800006ba:	012a04b3          	add	s1,s4,s2
    if ((pte = walk(pagetable, a, 1)) == 0)
    800006be:	4605                	li	a2,1
    800006c0:	85ca                	mv	a1,s2
    800006c2:	8556                	mv	a0,s5
    800006c4:	00000097          	auipc	ra,0x0
    800006c8:	eda080e7          	jalr	-294(ra) # 8000059e <walk>
    800006cc:	cd1d                	beqz	a0,8000070a <mappages+0x84>
    if (*pte & PTE_V)
    800006ce:	611c                	ld	a5,0(a0)
    800006d0:	8b85                	andi	a5,a5,1
    800006d2:	e785                	bnez	a5,800006fa <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800006d4:	80b1                	srli	s1,s1,0xc
    800006d6:	04aa                	slli	s1,s1,0xa
    800006d8:	0164e4b3          	or	s1,s1,s6
    800006dc:	0014e493          	ori	s1,s1,1
    800006e0:	e104                	sd	s1,0(a0)
    if (a == last)
    800006e2:	05390063          	beq	s2,s3,80000722 <mappages+0x9c>
    a += PGSIZE;
    800006e6:	995e                	add	s2,s2,s7
    if ((pte = walk(pagetable, a, 1)) == 0)
    800006e8:	bfc9                	j	800006ba <mappages+0x34>
    panic("mappages: size");
    800006ea:	00008517          	auipc	a0,0x8
    800006ee:	97e50513          	addi	a0,a0,-1666 # 80008068 <etext+0x68>
    800006f2:	00005097          	auipc	ra,0x5
    800006f6:	71e080e7          	jalr	1822(ra) # 80005e10 <panic>
      panic("mappages: remap");
    800006fa:	00008517          	auipc	a0,0x8
    800006fe:	97e50513          	addi	a0,a0,-1666 # 80008078 <etext+0x78>
    80000702:	00005097          	auipc	ra,0x5
    80000706:	70e080e7          	jalr	1806(ra) # 80005e10 <panic>
      return -1;
    8000070a:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    8000070c:	60a6                	ld	ra,72(sp)
    8000070e:	6406                	ld	s0,64(sp)
    80000710:	74e2                	ld	s1,56(sp)
    80000712:	7942                	ld	s2,48(sp)
    80000714:	79a2                	ld	s3,40(sp)
    80000716:	7a02                	ld	s4,32(sp)
    80000718:	6ae2                	ld	s5,24(sp)
    8000071a:	6b42                	ld	s6,16(sp)
    8000071c:	6ba2                	ld	s7,8(sp)
    8000071e:	6161                	addi	sp,sp,80
    80000720:	8082                	ret
  return 0;
    80000722:	4501                	li	a0,0
    80000724:	b7e5                	j	8000070c <mappages+0x86>

0000000080000726 <kvmmap>:
{
    80000726:	1141                	addi	sp,sp,-16
    80000728:	e406                	sd	ra,8(sp)
    8000072a:	e022                	sd	s0,0(sp)
    8000072c:	0800                	addi	s0,sp,16
    8000072e:	87b6                	mv	a5,a3
  if (mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000730:	86b2                	mv	a3,a2
    80000732:	863e                	mv	a2,a5
    80000734:	00000097          	auipc	ra,0x0
    80000738:	f52080e7          	jalr	-174(ra) # 80000686 <mappages>
    8000073c:	e509                	bnez	a0,80000746 <kvmmap+0x20>
}
    8000073e:	60a2                	ld	ra,8(sp)
    80000740:	6402                	ld	s0,0(sp)
    80000742:	0141                	addi	sp,sp,16
    80000744:	8082                	ret
    panic("kvmmap");
    80000746:	00008517          	auipc	a0,0x8
    8000074a:	94250513          	addi	a0,a0,-1726 # 80008088 <etext+0x88>
    8000074e:	00005097          	auipc	ra,0x5
    80000752:	6c2080e7          	jalr	1730(ra) # 80005e10 <panic>

0000000080000756 <kvmmake>:
{
    80000756:	1101                	addi	sp,sp,-32
    80000758:	ec06                	sd	ra,24(sp)
    8000075a:	e822                	sd	s0,16(sp)
    8000075c:	e426                	sd	s1,8(sp)
    8000075e:	e04a                	sd	s2,0(sp)
    80000760:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t)kalloc();
    80000762:	00000097          	auipc	ra,0x0
    80000766:	a44080e7          	jalr	-1468(ra) # 800001a6 <kalloc>
    8000076a:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000076c:	6605                	lui	a2,0x1
    8000076e:	4581                	li	a1,0
    80000770:	00000097          	auipc	ra,0x0
    80000774:	b4e080e7          	jalr	-1202(ra) # 800002be <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000778:	4719                	li	a4,6
    8000077a:	6685                	lui	a3,0x1
    8000077c:	10000637          	lui	a2,0x10000
    80000780:	100005b7          	lui	a1,0x10000
    80000784:	8526                	mv	a0,s1
    80000786:	00000097          	auipc	ra,0x0
    8000078a:	fa0080e7          	jalr	-96(ra) # 80000726 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000078e:	4719                	li	a4,6
    80000790:	6685                	lui	a3,0x1
    80000792:	10001637          	lui	a2,0x10001
    80000796:	100015b7          	lui	a1,0x10001
    8000079a:	8526                	mv	a0,s1
    8000079c:	00000097          	auipc	ra,0x0
    800007a0:	f8a080e7          	jalr	-118(ra) # 80000726 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800007a4:	4719                	li	a4,6
    800007a6:	004006b7          	lui	a3,0x400
    800007aa:	0c000637          	lui	a2,0xc000
    800007ae:	0c0005b7          	lui	a1,0xc000
    800007b2:	8526                	mv	a0,s1
    800007b4:	00000097          	auipc	ra,0x0
    800007b8:	f72080e7          	jalr	-142(ra) # 80000726 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext - KERNBASE, PTE_R | PTE_X);
    800007bc:	00008917          	auipc	s2,0x8
    800007c0:	84490913          	addi	s2,s2,-1980 # 80008000 <etext>
    800007c4:	4729                	li	a4,10
    800007c6:	80008697          	auipc	a3,0x80008
    800007ca:	83a68693          	addi	a3,a3,-1990 # 8000 <_entry-0x7fff8000>
    800007ce:	4605                	li	a2,1
    800007d0:	067e                	slli	a2,a2,0x1f
    800007d2:	85b2                	mv	a1,a2
    800007d4:	8526                	mv	a0,s1
    800007d6:	00000097          	auipc	ra,0x0
    800007da:	f50080e7          	jalr	-176(ra) # 80000726 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP - (uint64)etext, PTE_R | PTE_W);
    800007de:	4719                	li	a4,6
    800007e0:	46c5                	li	a3,17
    800007e2:	06ee                	slli	a3,a3,0x1b
    800007e4:	412686b3          	sub	a3,a3,s2
    800007e8:	864a                	mv	a2,s2
    800007ea:	85ca                	mv	a1,s2
    800007ec:	8526                	mv	a0,s1
    800007ee:	00000097          	auipc	ra,0x0
    800007f2:	f38080e7          	jalr	-200(ra) # 80000726 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800007f6:	4729                	li	a4,10
    800007f8:	6685                	lui	a3,0x1
    800007fa:	00007617          	auipc	a2,0x7
    800007fe:	80660613          	addi	a2,a2,-2042 # 80007000 <_trampoline>
    80000802:	040005b7          	lui	a1,0x4000
    80000806:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000808:	05b2                	slli	a1,a1,0xc
    8000080a:	8526                	mv	a0,s1
    8000080c:	00000097          	auipc	ra,0x0
    80000810:	f1a080e7          	jalr	-230(ra) # 80000726 <kvmmap>
  proc_mapstacks(kpgtbl);
    80000814:	8526                	mv	a0,s1
    80000816:	00000097          	auipc	ra,0x0
    8000081a:	616080e7          	jalr	1558(ra) # 80000e2c <proc_mapstacks>
}
    8000081e:	8526                	mv	a0,s1
    80000820:	60e2                	ld	ra,24(sp)
    80000822:	6442                	ld	s0,16(sp)
    80000824:	64a2                	ld	s1,8(sp)
    80000826:	6902                	ld	s2,0(sp)
    80000828:	6105                	addi	sp,sp,32
    8000082a:	8082                	ret

000000008000082c <kvminit>:
{
    8000082c:	1141                	addi	sp,sp,-16
    8000082e:	e406                	sd	ra,8(sp)
    80000830:	e022                	sd	s0,0(sp)
    80000832:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000834:	00000097          	auipc	ra,0x0
    80000838:	f22080e7          	jalr	-222(ra) # 80000756 <kvmmake>
    8000083c:	00008797          	auipc	a5,0x8
    80000840:	7ca7b623          	sd	a0,1996(a5) # 80009008 <kernel_pagetable>
}
    80000844:	60a2                	ld	ra,8(sp)
    80000846:	6402                	ld	s0,0(sp)
    80000848:	0141                	addi	sp,sp,16
    8000084a:	8082                	ret

000000008000084c <uvmunmap>:

// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000084c:	715d                	addi	sp,sp,-80
    8000084e:	e486                	sd	ra,72(sp)
    80000850:	e0a2                	sd	s0,64(sp)
    80000852:	fc26                	sd	s1,56(sp)
    80000854:	f84a                	sd	s2,48(sp)
    80000856:	f44e                	sd	s3,40(sp)
    80000858:	f052                	sd	s4,32(sp)
    8000085a:	ec56                	sd	s5,24(sp)
    8000085c:	e85a                	sd	s6,16(sp)
    8000085e:	e45e                	sd	s7,8(sp)
    80000860:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if ((va % PGSIZE) != 0)
    80000862:	03459793          	slli	a5,a1,0x34
    80000866:	e795                	bnez	a5,80000892 <uvmunmap+0x46>
    80000868:	8a2a                	mv	s4,a0
    8000086a:	892e                	mv	s2,a1
    8000086c:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
    8000086e:	0632                	slli	a2,a2,0xc
    80000870:	00b609b3          	add	s3,a2,a1
  {
    if ((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if ((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if (PTE_FLAGS(*pte) == PTE_V)
    80000874:	4b85                	li	s7,1
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
    80000876:	6b05                	lui	s6,0x1
    80000878:	0735e263          	bltu	a1,s3,800008dc <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void *)pa);
    }
    *pte = 0;
  }
}
    8000087c:	60a6                	ld	ra,72(sp)
    8000087e:	6406                	ld	s0,64(sp)
    80000880:	74e2                	ld	s1,56(sp)
    80000882:	7942                	ld	s2,48(sp)
    80000884:	79a2                	ld	s3,40(sp)
    80000886:	7a02                	ld	s4,32(sp)
    80000888:	6ae2                	ld	s5,24(sp)
    8000088a:	6b42                	ld	s6,16(sp)
    8000088c:	6ba2                	ld	s7,8(sp)
    8000088e:	6161                	addi	sp,sp,80
    80000890:	8082                	ret
    panic("uvmunmap: not aligned");
    80000892:	00007517          	auipc	a0,0x7
    80000896:	7fe50513          	addi	a0,a0,2046 # 80008090 <etext+0x90>
    8000089a:	00005097          	auipc	ra,0x5
    8000089e:	576080e7          	jalr	1398(ra) # 80005e10 <panic>
      panic("uvmunmap: walk");
    800008a2:	00008517          	auipc	a0,0x8
    800008a6:	80650513          	addi	a0,a0,-2042 # 800080a8 <etext+0xa8>
    800008aa:	00005097          	auipc	ra,0x5
    800008ae:	566080e7          	jalr	1382(ra) # 80005e10 <panic>
      panic("uvmunmap: not mapped");
    800008b2:	00008517          	auipc	a0,0x8
    800008b6:	80650513          	addi	a0,a0,-2042 # 800080b8 <etext+0xb8>
    800008ba:	00005097          	auipc	ra,0x5
    800008be:	556080e7          	jalr	1366(ra) # 80005e10 <panic>
      panic("uvmunmap: not a leaf");
    800008c2:	00008517          	auipc	a0,0x8
    800008c6:	80e50513          	addi	a0,a0,-2034 # 800080d0 <etext+0xd0>
    800008ca:	00005097          	auipc	ra,0x5
    800008ce:	546080e7          	jalr	1350(ra) # 80005e10 <panic>
    *pte = 0;
    800008d2:	0004b023          	sd	zero,0(s1)
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
    800008d6:	995a                	add	s2,s2,s6
    800008d8:	fb3972e3          	bgeu	s2,s3,8000087c <uvmunmap+0x30>
    if ((pte = walk(pagetable, a, 0)) == 0)
    800008dc:	4601                	li	a2,0
    800008de:	85ca                	mv	a1,s2
    800008e0:	8552                	mv	a0,s4
    800008e2:	00000097          	auipc	ra,0x0
    800008e6:	cbc080e7          	jalr	-836(ra) # 8000059e <walk>
    800008ea:	84aa                	mv	s1,a0
    800008ec:	d95d                	beqz	a0,800008a2 <uvmunmap+0x56>
    if ((*pte & PTE_V) == 0)
    800008ee:	6108                	ld	a0,0(a0)
    800008f0:	00157793          	andi	a5,a0,1
    800008f4:	dfdd                	beqz	a5,800008b2 <uvmunmap+0x66>
    if (PTE_FLAGS(*pte) == PTE_V)
    800008f6:	3ff57793          	andi	a5,a0,1023
    800008fa:	fd7784e3          	beq	a5,s7,800008c2 <uvmunmap+0x76>
    if (do_free)
    800008fe:	fc0a8ae3          	beqz	s5,800008d2 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    80000902:	8129                	srli	a0,a0,0xa
      kfree((void *)pa);
    80000904:	0532                	slli	a0,a0,0xc
    80000906:	fffff097          	auipc	ra,0xfffff
    8000090a:	716080e7          	jalr	1814(ra) # 8000001c <kfree>
    8000090e:	b7d1                	j	800008d2 <uvmunmap+0x86>

0000000080000910 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80000910:	1101                	addi	sp,sp,-32
    80000912:	ec06                	sd	ra,24(sp)
    80000914:	e822                	sd	s0,16(sp)
    80000916:	e426                	sd	s1,8(sp)
    80000918:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t)kalloc();
    8000091a:	00000097          	auipc	ra,0x0
    8000091e:	88c080e7          	jalr	-1908(ra) # 800001a6 <kalloc>
    80000922:	84aa                	mv	s1,a0
  if (pagetable == 0)
    80000924:	c519                	beqz	a0,80000932 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000926:	6605                	lui	a2,0x1
    80000928:	4581                	li	a1,0
    8000092a:	00000097          	auipc	ra,0x0
    8000092e:	994080e7          	jalr	-1644(ra) # 800002be <memset>
  return pagetable;
}
    80000932:	8526                	mv	a0,s1
    80000934:	60e2                	ld	ra,24(sp)
    80000936:	6442                	ld	s0,16(sp)
    80000938:	64a2                	ld	s1,8(sp)
    8000093a:	6105                	addi	sp,sp,32
    8000093c:	8082                	ret

000000008000093e <uvminit>:

// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    8000093e:	7179                	addi	sp,sp,-48
    80000940:	f406                	sd	ra,40(sp)
    80000942:	f022                	sd	s0,32(sp)
    80000944:	ec26                	sd	s1,24(sp)
    80000946:	e84a                	sd	s2,16(sp)
    80000948:	e44e                	sd	s3,8(sp)
    8000094a:	e052                	sd	s4,0(sp)
    8000094c:	1800                	addi	s0,sp,48
  char *mem;

  if (sz >= PGSIZE)
    8000094e:	6785                	lui	a5,0x1
    80000950:	04f67863          	bgeu	a2,a5,800009a0 <uvminit+0x62>
    80000954:	8a2a                	mv	s4,a0
    80000956:	89ae                	mv	s3,a1
    80000958:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    8000095a:	00000097          	auipc	ra,0x0
    8000095e:	84c080e7          	jalr	-1972(ra) # 800001a6 <kalloc>
    80000962:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000964:	6605                	lui	a2,0x1
    80000966:	4581                	li	a1,0
    80000968:	00000097          	auipc	ra,0x0
    8000096c:	956080e7          	jalr	-1706(ra) # 800002be <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W | PTE_R | PTE_X | PTE_U);
    80000970:	4779                	li	a4,30
    80000972:	86ca                	mv	a3,s2
    80000974:	6605                	lui	a2,0x1
    80000976:	4581                	li	a1,0
    80000978:	8552                	mv	a0,s4
    8000097a:	00000097          	auipc	ra,0x0
    8000097e:	d0c080e7          	jalr	-756(ra) # 80000686 <mappages>
  memmove(mem, src, sz);
    80000982:	8626                	mv	a2,s1
    80000984:	85ce                	mv	a1,s3
    80000986:	854a                	mv	a0,s2
    80000988:	00000097          	auipc	ra,0x0
    8000098c:	992080e7          	jalr	-1646(ra) # 8000031a <memmove>
}
    80000990:	70a2                	ld	ra,40(sp)
    80000992:	7402                	ld	s0,32(sp)
    80000994:	64e2                	ld	s1,24(sp)
    80000996:	6942                	ld	s2,16(sp)
    80000998:	69a2                	ld	s3,8(sp)
    8000099a:	6a02                	ld	s4,0(sp)
    8000099c:	6145                	addi	sp,sp,48
    8000099e:	8082                	ret
    panic("inituvm: more than a page");
    800009a0:	00007517          	auipc	a0,0x7
    800009a4:	74850513          	addi	a0,a0,1864 # 800080e8 <etext+0xe8>
    800009a8:	00005097          	auipc	ra,0x5
    800009ac:	468080e7          	jalr	1128(ra) # 80005e10 <panic>

00000000800009b0 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800009b0:	1101                	addi	sp,sp,-32
    800009b2:	ec06                	sd	ra,24(sp)
    800009b4:	e822                	sd	s0,16(sp)
    800009b6:	e426                	sd	s1,8(sp)
    800009b8:	1000                	addi	s0,sp,32
  if (newsz >= oldsz)
    return oldsz;
    800009ba:	84ae                	mv	s1,a1
  if (newsz >= oldsz)
    800009bc:	00b67d63          	bgeu	a2,a1,800009d6 <uvmdealloc+0x26>
    800009c0:	84b2                	mv	s1,a2

  if (PGROUNDUP(newsz) < PGROUNDUP(oldsz))
    800009c2:	6785                	lui	a5,0x1
    800009c4:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800009c6:	00f60733          	add	a4,a2,a5
    800009ca:	76fd                	lui	a3,0xfffff
    800009cc:	8f75                	and	a4,a4,a3
    800009ce:	97ae                	add	a5,a5,a1
    800009d0:	8ff5                	and	a5,a5,a3
    800009d2:	00f76863          	bltu	a4,a5,800009e2 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800009d6:	8526                	mv	a0,s1
    800009d8:	60e2                	ld	ra,24(sp)
    800009da:	6442                	ld	s0,16(sp)
    800009dc:	64a2                	ld	s1,8(sp)
    800009de:	6105                	addi	sp,sp,32
    800009e0:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800009e2:	8f99                	sub	a5,a5,a4
    800009e4:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800009e6:	4685                	li	a3,1
    800009e8:	0007861b          	sext.w	a2,a5
    800009ec:	85ba                	mv	a1,a4
    800009ee:	00000097          	auipc	ra,0x0
    800009f2:	e5e080e7          	jalr	-418(ra) # 8000084c <uvmunmap>
    800009f6:	b7c5                	j	800009d6 <uvmdealloc+0x26>

00000000800009f8 <uvmalloc>:
  if (newsz < oldsz)
    800009f8:	0ab66163          	bltu	a2,a1,80000a9a <uvmalloc+0xa2>
{
    800009fc:	7139                	addi	sp,sp,-64
    800009fe:	fc06                	sd	ra,56(sp)
    80000a00:	f822                	sd	s0,48(sp)
    80000a02:	f426                	sd	s1,40(sp)
    80000a04:	f04a                	sd	s2,32(sp)
    80000a06:	ec4e                	sd	s3,24(sp)
    80000a08:	e852                	sd	s4,16(sp)
    80000a0a:	e456                	sd	s5,8(sp)
    80000a0c:	0080                	addi	s0,sp,64
    80000a0e:	8aaa                	mv	s5,a0
    80000a10:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80000a12:	6785                	lui	a5,0x1
    80000a14:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000a16:	95be                	add	a1,a1,a5
    80000a18:	77fd                	lui	a5,0xfffff
    80000a1a:	00f5f9b3          	and	s3,a1,a5
  for (a = oldsz; a < newsz; a += PGSIZE)
    80000a1e:	08c9f063          	bgeu	s3,a2,80000a9e <uvmalloc+0xa6>
    80000a22:	894e                	mv	s2,s3
    mem = kalloc();
    80000a24:	fffff097          	auipc	ra,0xfffff
    80000a28:	782080e7          	jalr	1922(ra) # 800001a6 <kalloc>
    80000a2c:	84aa                	mv	s1,a0
    if (mem == 0)
    80000a2e:	c51d                	beqz	a0,80000a5c <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80000a30:	6605                	lui	a2,0x1
    80000a32:	4581                	li	a1,0
    80000a34:	00000097          	auipc	ra,0x0
    80000a38:	88a080e7          	jalr	-1910(ra) # 800002be <memset>
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W | PTE_X | PTE_R | PTE_U) != 0)
    80000a3c:	4779                	li	a4,30
    80000a3e:	86a6                	mv	a3,s1
    80000a40:	6605                	lui	a2,0x1
    80000a42:	85ca                	mv	a1,s2
    80000a44:	8556                	mv	a0,s5
    80000a46:	00000097          	auipc	ra,0x0
    80000a4a:	c40080e7          	jalr	-960(ra) # 80000686 <mappages>
    80000a4e:	e905                	bnez	a0,80000a7e <uvmalloc+0x86>
  for (a = oldsz; a < newsz; a += PGSIZE)
    80000a50:	6785                	lui	a5,0x1
    80000a52:	993e                	add	s2,s2,a5
    80000a54:	fd4968e3          	bltu	s2,s4,80000a24 <uvmalloc+0x2c>
  return newsz;
    80000a58:	8552                	mv	a0,s4
    80000a5a:	a809                	j	80000a6c <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80000a5c:	864e                	mv	a2,s3
    80000a5e:	85ca                	mv	a1,s2
    80000a60:	8556                	mv	a0,s5
    80000a62:	00000097          	auipc	ra,0x0
    80000a66:	f4e080e7          	jalr	-178(ra) # 800009b0 <uvmdealloc>
      return 0;
    80000a6a:	4501                	li	a0,0
}
    80000a6c:	70e2                	ld	ra,56(sp)
    80000a6e:	7442                	ld	s0,48(sp)
    80000a70:	74a2                	ld	s1,40(sp)
    80000a72:	7902                	ld	s2,32(sp)
    80000a74:	69e2                	ld	s3,24(sp)
    80000a76:	6a42                	ld	s4,16(sp)
    80000a78:	6aa2                	ld	s5,8(sp)
    80000a7a:	6121                	addi	sp,sp,64
    80000a7c:	8082                	ret
      kfree(mem);
    80000a7e:	8526                	mv	a0,s1
    80000a80:	fffff097          	auipc	ra,0xfffff
    80000a84:	59c080e7          	jalr	1436(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000a88:	864e                	mv	a2,s3
    80000a8a:	85ca                	mv	a1,s2
    80000a8c:	8556                	mv	a0,s5
    80000a8e:	00000097          	auipc	ra,0x0
    80000a92:	f22080e7          	jalr	-222(ra) # 800009b0 <uvmdealloc>
      return 0;
    80000a96:	4501                	li	a0,0
    80000a98:	bfd1                	j	80000a6c <uvmalloc+0x74>
    return oldsz;
    80000a9a:	852e                	mv	a0,a1
}
    80000a9c:	8082                	ret
  return newsz;
    80000a9e:	8532                	mv	a0,a2
    80000aa0:	b7f1                	j	80000a6c <uvmalloc+0x74>

0000000080000aa2 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void freewalk(pagetable_t pagetable)
{
    80000aa2:	7179                	addi	sp,sp,-48
    80000aa4:	f406                	sd	ra,40(sp)
    80000aa6:	f022                	sd	s0,32(sp)
    80000aa8:	ec26                	sd	s1,24(sp)
    80000aaa:	e84a                	sd	s2,16(sp)
    80000aac:	e44e                	sd	s3,8(sp)
    80000aae:	e052                	sd	s4,0(sp)
    80000ab0:	1800                	addi	s0,sp,48
    80000ab2:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for (int i = 0; i < 512; i++)
    80000ab4:	84aa                	mv	s1,a0
    80000ab6:	6905                	lui	s2,0x1
    80000ab8:	992a                	add	s2,s2,a0
  {
    pte_t pte = pagetable[i];
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0)
    80000aba:	4985                	li	s3,1
    80000abc:	a829                	j	80000ad6 <freewalk+0x34>
    {
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000abe:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000ac0:	00c79513          	slli	a0,a5,0xc
    80000ac4:	00000097          	auipc	ra,0x0
    80000ac8:	fde080e7          	jalr	-34(ra) # 80000aa2 <freewalk>
      pagetable[i] = 0;
    80000acc:	0004b023          	sd	zero,0(s1)
  for (int i = 0; i < 512; i++)
    80000ad0:	04a1                	addi	s1,s1,8
    80000ad2:	03248163          	beq	s1,s2,80000af4 <freewalk+0x52>
    pte_t pte = pagetable[i];
    80000ad6:	609c                	ld	a5,0(s1)
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0)
    80000ad8:	00f7f713          	andi	a4,a5,15
    80000adc:	ff3701e3          	beq	a4,s3,80000abe <freewalk+0x1c>
    }
    else if (pte & PTE_V)
    80000ae0:	8b85                	andi	a5,a5,1
    80000ae2:	d7fd                	beqz	a5,80000ad0 <freewalk+0x2e>
    {
      panic("freewalk: leaf");
    80000ae4:	00007517          	auipc	a0,0x7
    80000ae8:	62450513          	addi	a0,a0,1572 # 80008108 <etext+0x108>
    80000aec:	00005097          	auipc	ra,0x5
    80000af0:	324080e7          	jalr	804(ra) # 80005e10 <panic>
    }
  }
  kfree((void *)pagetable);
    80000af4:	8552                	mv	a0,s4
    80000af6:	fffff097          	auipc	ra,0xfffff
    80000afa:	526080e7          	jalr	1318(ra) # 8000001c <kfree>
}
    80000afe:	70a2                	ld	ra,40(sp)
    80000b00:	7402                	ld	s0,32(sp)
    80000b02:	64e2                	ld	s1,24(sp)
    80000b04:	6942                	ld	s2,16(sp)
    80000b06:	69a2                	ld	s3,8(sp)
    80000b08:	6a02                	ld	s4,0(sp)
    80000b0a:	6145                	addi	sp,sp,48
    80000b0c:	8082                	ret

0000000080000b0e <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000b0e:	1101                	addi	sp,sp,-32
    80000b10:	ec06                	sd	ra,24(sp)
    80000b12:	e822                	sd	s0,16(sp)
    80000b14:	e426                	sd	s1,8(sp)
    80000b16:	1000                	addi	s0,sp,32
    80000b18:	84aa                	mv	s1,a0
  if (sz > 0)
    80000b1a:	e999                	bnez	a1,80000b30 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
  freewalk(pagetable);
    80000b1c:	8526                	mv	a0,s1
    80000b1e:	00000097          	auipc	ra,0x0
    80000b22:	f84080e7          	jalr	-124(ra) # 80000aa2 <freewalk>
}
    80000b26:	60e2                	ld	ra,24(sp)
    80000b28:	6442                	ld	s0,16(sp)
    80000b2a:	64a2                	ld	s1,8(sp)
    80000b2c:	6105                	addi	sp,sp,32
    80000b2e:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    80000b30:	6785                	lui	a5,0x1
    80000b32:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000b34:	95be                	add	a1,a1,a5
    80000b36:	4685                	li	a3,1
    80000b38:	00c5d613          	srli	a2,a1,0xc
    80000b3c:	4581                	li	a1,0
    80000b3e:	00000097          	auipc	ra,0x0
    80000b42:	d0e080e7          	jalr	-754(ra) # 8000084c <uvmunmap>
    80000b46:	bfd9                	j	80000b1c <uvmfree+0xe>

0000000080000b48 <uvmcopy>:
{
  pte_t *pte;
  uint64 pa, i;
  uint flags;

  for (i = 0; i < sz; i += PGSIZE)
    80000b48:	ca5d                	beqz	a2,80000bfe <uvmcopy+0xb6>
{
    80000b4a:	7139                	addi	sp,sp,-64
    80000b4c:	fc06                	sd	ra,56(sp)
    80000b4e:	f822                	sd	s0,48(sp)
    80000b50:	f426                	sd	s1,40(sp)
    80000b52:	f04a                	sd	s2,32(sp)
    80000b54:	ec4e                	sd	s3,24(sp)
    80000b56:	e852                	sd	s4,16(sp)
    80000b58:	e456                	sd	s5,8(sp)
    80000b5a:	0080                	addi	s0,sp,64
    80000b5c:	8aaa                	mv	s5,a0
    80000b5e:	89ae                	mv	s3,a1
    80000b60:	8a32                	mv	s4,a2
  for (i = 0; i < sz; i += PGSIZE)
    80000b62:	4901                	li	s2,0
  {
    if ((pte = walk(old, i, 0)) == 0)
    80000b64:	4601                	li	a2,0
    80000b66:	85ca                	mv	a1,s2
    80000b68:	8556                	mv	a0,s5
    80000b6a:	00000097          	auipc	ra,0x0
    80000b6e:	a34080e7          	jalr	-1484(ra) # 8000059e <walk>
    80000b72:	c139                	beqz	a0,80000bb8 <uvmcopy+0x70>
      panic("uvmcopy: pte should exist");
    if ((*pte & PTE_V) == 0)
    80000b74:	6118                	ld	a4,0(a0)
    80000b76:	00177793          	andi	a5,a4,1
    80000b7a:	c7b9                	beqz	a5,80000bc8 <uvmcopy+0x80>
      panic("uvmcopy: page not present");

    pa = PTE2PA(*pte);
    80000b7c:	00a75493          	srli	s1,a4,0xa
    80000b80:	04b2                	slli	s1,s1,0xc

    *pte = (*pte & ~PTE_W) | PTE_COW; // 将所有的pte的写权限都设置为0，PTE_COW设置为1
    80000b82:	efb77713          	andi	a4,a4,-261
    80000b86:	10076713          	ori	a4,a4,256
    80000b8a:	e118                	sd	a4,0(a0)

    flags = PTE_FLAGS(*pte);

    if (mappages(new, i, PGSIZE, pa, flags) != 0)
    80000b8c:	3fb77713          	andi	a4,a4,1019
    80000b90:	86a6                	mv	a3,s1
    80000b92:	6605                	lui	a2,0x1
    80000b94:	85ca                	mv	a1,s2
    80000b96:	854e                	mv	a0,s3
    80000b98:	00000097          	auipc	ra,0x0
    80000b9c:	aee080e7          	jalr	-1298(ra) # 80000686 <mappages>
    80000ba0:	ed05                	bnez	a0,80000bd8 <uvmcopy+0x90>
    {
      goto err;
    }

    // 索引计数加1
    if (AddPGRefCount((void *)pa))
    80000ba2:	8526                	mv	a0,s1
    80000ba4:	fffff097          	auipc	ra,0xfffff
    80000ba8:	690080e7          	jalr	1680(ra) # 80000234 <AddPGRefCount>
    80000bac:	e515                	bnez	a0,80000bd8 <uvmcopy+0x90>
  for (i = 0; i < sz; i += PGSIZE)
    80000bae:	6785                	lui	a5,0x1
    80000bb0:	993e                	add	s2,s2,a5
    80000bb2:	fb4969e3          	bltu	s2,s4,80000b64 <uvmcopy+0x1c>
    80000bb6:	a81d                	j	80000bec <uvmcopy+0xa4>
      panic("uvmcopy: pte should exist");
    80000bb8:	00007517          	auipc	a0,0x7
    80000bbc:	56050513          	addi	a0,a0,1376 # 80008118 <etext+0x118>
    80000bc0:	00005097          	auipc	ra,0x5
    80000bc4:	250080e7          	jalr	592(ra) # 80005e10 <panic>
      panic("uvmcopy: page not present");
    80000bc8:	00007517          	auipc	a0,0x7
    80000bcc:	57050513          	addi	a0,a0,1392 # 80008138 <etext+0x138>
    80000bd0:	00005097          	auipc	ra,0x5
    80000bd4:	240080e7          	jalr	576(ra) # 80005e10 <panic>
    }
  }
  return 0;

err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000bd8:	4685                	li	a3,1
    80000bda:	00c95613          	srli	a2,s2,0xc
    80000bde:	4581                	li	a1,0
    80000be0:	854e                	mv	a0,s3
    80000be2:	00000097          	auipc	ra,0x0
    80000be6:	c6a080e7          	jalr	-918(ra) # 8000084c <uvmunmap>
  return -1;
    80000bea:	557d                	li	a0,-1
}
    80000bec:	70e2                	ld	ra,56(sp)
    80000bee:	7442                	ld	s0,48(sp)
    80000bf0:	74a2                	ld	s1,40(sp)
    80000bf2:	7902                	ld	s2,32(sp)
    80000bf4:	69e2                	ld	s3,24(sp)
    80000bf6:	6a42                	ld	s4,16(sp)
    80000bf8:	6aa2                	ld	s5,8(sp)
    80000bfa:	6121                	addi	sp,sp,64
    80000bfc:	8082                	ret
  return 0;
    80000bfe:	4501                	li	a0,0
}
    80000c00:	8082                	ret

0000000080000c02 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void uvmclear(pagetable_t pagetable, uint64 va)
{
    80000c02:	1141                	addi	sp,sp,-16
    80000c04:	e406                	sd	ra,8(sp)
    80000c06:	e022                	sd	s0,0(sp)
    80000c08:	0800                	addi	s0,sp,16
  pte_t *pte;

  pte = walk(pagetable, va, 0);
    80000c0a:	4601                	li	a2,0
    80000c0c:	00000097          	auipc	ra,0x0
    80000c10:	992080e7          	jalr	-1646(ra) # 8000059e <walk>
  if (pte == 0)
    80000c14:	c901                	beqz	a0,80000c24 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000c16:	611c                	ld	a5,0(a0)
    80000c18:	9bbd                	andi	a5,a5,-17
    80000c1a:	e11c                	sd	a5,0(a0)
}
    80000c1c:	60a2                	ld	ra,8(sp)
    80000c1e:	6402                	ld	s0,0(sp)
    80000c20:	0141                	addi	sp,sp,16
    80000c22:	8082                	ret
    panic("uvmclear");
    80000c24:	00007517          	auipc	a0,0x7
    80000c28:	53450513          	addi	a0,a0,1332 # 80008158 <etext+0x158>
    80000c2c:	00005097          	auipc	ra,0x5
    80000c30:	1e4080e7          	jalr	484(ra) # 80005e10 <panic>

0000000080000c34 <copyout>:
// Return 0 on success, -1 on error.
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while (len > 0)
    80000c34:	cec1                	beqz	a3,80000ccc <copyout+0x98>
{
    80000c36:	711d                	addi	sp,sp,-96
    80000c38:	ec86                	sd	ra,88(sp)
    80000c3a:	e8a2                	sd	s0,80(sp)
    80000c3c:	e4a6                	sd	s1,72(sp)
    80000c3e:	e0ca                	sd	s2,64(sp)
    80000c40:	fc4e                	sd	s3,56(sp)
    80000c42:	f852                	sd	s4,48(sp)
    80000c44:	f456                	sd	s5,40(sp)
    80000c46:	f05a                	sd	s6,32(sp)
    80000c48:	ec5e                	sd	s7,24(sp)
    80000c4a:	e862                	sd	s8,16(sp)
    80000c4c:	e466                	sd	s9,8(sp)
    80000c4e:	e06a                	sd	s10,0(sp)
    80000c50:	1080                	addi	s0,sp,96
    80000c52:	8baa                	mv	s7,a0
    80000c54:	892e                	mv	s2,a1
    80000c56:	8b32                	mv	s6,a2
    80000c58:	8ab6                	mv	s5,a3
  {
    va0 = PGROUNDDOWN(dstva);
    80000c5a:	7d7d                	lui	s10,0xfffff
    pa0 = walkaddr(pagetable, va0);

    // 若是COW页，则要分配新的物理页再复制
    if (isCOWPG(pagetable, va0) == 1)
    80000c5c:	4c85                	li	s9,1
      pa0 = (uint64)allocCOWPG(pagetable, va0);
    }

    if (pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000c5e:	6c05                	lui	s8,0x1
    80000c60:	a815                	j	80000c94 <copyout+0x60>
      pa0 = (uint64)allocCOWPG(pagetable, va0);
    80000c62:	85ce                	mv	a1,s3
    80000c64:	855e                	mv	a0,s7
    80000c66:	00001097          	auipc	ra,0x1
    80000c6a:	ffe080e7          	jalr	-2(ra) # 80001c64 <allocCOWPG>
    80000c6e:	8a2a                	mv	s4,a0
    80000c70:	a099                	j	80000cb6 <copyout+0x82>
    if (n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000c72:	41390533          	sub	a0,s2,s3
    80000c76:	0004861b          	sext.w	a2,s1
    80000c7a:	85da                	mv	a1,s6
    80000c7c:	9552                	add	a0,a0,s4
    80000c7e:	fffff097          	auipc	ra,0xfffff
    80000c82:	69c080e7          	jalr	1692(ra) # 8000031a <memmove>

    len -= n;
    80000c86:	409a8ab3          	sub	s5,s5,s1
    src += n;
    80000c8a:	9b26                	add	s6,s6,s1
    dstva = va0 + PGSIZE;
    80000c8c:	01898933          	add	s2,s3,s8
  while (len > 0)
    80000c90:	020a8c63          	beqz	s5,80000cc8 <copyout+0x94>
    va0 = PGROUNDDOWN(dstva);
    80000c94:	01a979b3          	and	s3,s2,s10
    pa0 = walkaddr(pagetable, va0);
    80000c98:	85ce                	mv	a1,s3
    80000c9a:	855e                	mv	a0,s7
    80000c9c:	00000097          	auipc	ra,0x0
    80000ca0:	9a8080e7          	jalr	-1624(ra) # 80000644 <walkaddr>
    80000ca4:	8a2a                	mv	s4,a0
    if (isCOWPG(pagetable, va0) == 1)
    80000ca6:	85ce                	mv	a1,s3
    80000ca8:	855e                	mv	a0,s7
    80000caa:	00001097          	auipc	ra,0x1
    80000cae:	f80080e7          	jalr	-128(ra) # 80001c2a <isCOWPG>
    80000cb2:	fb9508e3          	beq	a0,s9,80000c62 <copyout+0x2e>
    if (pa0 == 0)
    80000cb6:	000a0d63          	beqz	s4,80000cd0 <copyout+0x9c>
    n = PGSIZE - (dstva - va0);
    80000cba:	412984b3          	sub	s1,s3,s2
    80000cbe:	94e2                	add	s1,s1,s8
    80000cc0:	fa9af9e3          	bgeu	s5,s1,80000c72 <copyout+0x3e>
    80000cc4:	84d6                	mv	s1,s5
    80000cc6:	b775                	j	80000c72 <copyout+0x3e>
  }
  return 0;
    80000cc8:	4501                	li	a0,0
    80000cca:	a021                	j	80000cd2 <copyout+0x9e>
    80000ccc:	4501                	li	a0,0
}
    80000cce:	8082                	ret
      return -1;
    80000cd0:	557d                	li	a0,-1
}
    80000cd2:	60e6                	ld	ra,88(sp)
    80000cd4:	6446                	ld	s0,80(sp)
    80000cd6:	64a6                	ld	s1,72(sp)
    80000cd8:	6906                	ld	s2,64(sp)
    80000cda:	79e2                	ld	s3,56(sp)
    80000cdc:	7a42                	ld	s4,48(sp)
    80000cde:	7aa2                	ld	s5,40(sp)
    80000ce0:	7b02                	ld	s6,32(sp)
    80000ce2:	6be2                	ld	s7,24(sp)
    80000ce4:	6c42                	ld	s8,16(sp)
    80000ce6:	6ca2                	ld	s9,8(sp)
    80000ce8:	6d02                	ld	s10,0(sp)
    80000cea:	6125                	addi	sp,sp,96
    80000cec:	8082                	ret

0000000080000cee <copyin>:
// Return 0 on success, -1 on error.
int copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while (len > 0)
    80000cee:	caa5                	beqz	a3,80000d5e <copyin+0x70>
{
    80000cf0:	715d                	addi	sp,sp,-80
    80000cf2:	e486                	sd	ra,72(sp)
    80000cf4:	e0a2                	sd	s0,64(sp)
    80000cf6:	fc26                	sd	s1,56(sp)
    80000cf8:	f84a                	sd	s2,48(sp)
    80000cfa:	f44e                	sd	s3,40(sp)
    80000cfc:	f052                	sd	s4,32(sp)
    80000cfe:	ec56                	sd	s5,24(sp)
    80000d00:	e85a                	sd	s6,16(sp)
    80000d02:	e45e                	sd	s7,8(sp)
    80000d04:	e062                	sd	s8,0(sp)
    80000d06:	0880                	addi	s0,sp,80
    80000d08:	8b2a                	mv	s6,a0
    80000d0a:	8a2e                	mv	s4,a1
    80000d0c:	8c32                	mv	s8,a2
    80000d0e:	89b6                	mv	s3,a3
  {
    va0 = PGROUNDDOWN(srcva);
    80000d10:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000d12:	6a85                	lui	s5,0x1
    80000d14:	a01d                	j	80000d3a <copyin+0x4c>
    if (n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000d16:	018505b3          	add	a1,a0,s8
    80000d1a:	0004861b          	sext.w	a2,s1
    80000d1e:	412585b3          	sub	a1,a1,s2
    80000d22:	8552                	mv	a0,s4
    80000d24:	fffff097          	auipc	ra,0xfffff
    80000d28:	5f6080e7          	jalr	1526(ra) # 8000031a <memmove>

    len -= n;
    80000d2c:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000d30:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000d32:	01590c33          	add	s8,s2,s5
  while (len > 0)
    80000d36:	02098263          	beqz	s3,80000d5a <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000d3a:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000d3e:	85ca                	mv	a1,s2
    80000d40:	855a                	mv	a0,s6
    80000d42:	00000097          	auipc	ra,0x0
    80000d46:	902080e7          	jalr	-1790(ra) # 80000644 <walkaddr>
    if (pa0 == 0)
    80000d4a:	cd01                	beqz	a0,80000d62 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000d4c:	418904b3          	sub	s1,s2,s8
    80000d50:	94d6                	add	s1,s1,s5
    80000d52:	fc99f2e3          	bgeu	s3,s1,80000d16 <copyin+0x28>
    80000d56:	84ce                	mv	s1,s3
    80000d58:	bf7d                	j	80000d16 <copyin+0x28>
  }
  return 0;
    80000d5a:	4501                	li	a0,0
    80000d5c:	a021                	j	80000d64 <copyin+0x76>
    80000d5e:	4501                	li	a0,0
}
    80000d60:	8082                	ret
      return -1;
    80000d62:	557d                	li	a0,-1
}
    80000d64:	60a6                	ld	ra,72(sp)
    80000d66:	6406                	ld	s0,64(sp)
    80000d68:	74e2                	ld	s1,56(sp)
    80000d6a:	7942                	ld	s2,48(sp)
    80000d6c:	79a2                	ld	s3,40(sp)
    80000d6e:	7a02                	ld	s4,32(sp)
    80000d70:	6ae2                	ld	s5,24(sp)
    80000d72:	6b42                	ld	s6,16(sp)
    80000d74:	6ba2                	ld	s7,8(sp)
    80000d76:	6c02                	ld	s8,0(sp)
    80000d78:	6161                	addi	sp,sp,80
    80000d7a:	8082                	ret

0000000080000d7c <copyinstr>:
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while (got_null == 0 && max > 0)
    80000d7c:	c2dd                	beqz	a3,80000e22 <copyinstr+0xa6>
{
    80000d7e:	715d                	addi	sp,sp,-80
    80000d80:	e486                	sd	ra,72(sp)
    80000d82:	e0a2                	sd	s0,64(sp)
    80000d84:	fc26                	sd	s1,56(sp)
    80000d86:	f84a                	sd	s2,48(sp)
    80000d88:	f44e                	sd	s3,40(sp)
    80000d8a:	f052                	sd	s4,32(sp)
    80000d8c:	ec56                	sd	s5,24(sp)
    80000d8e:	e85a                	sd	s6,16(sp)
    80000d90:	e45e                	sd	s7,8(sp)
    80000d92:	0880                	addi	s0,sp,80
    80000d94:	8a2a                	mv	s4,a0
    80000d96:	8b2e                	mv	s6,a1
    80000d98:	8bb2                	mv	s7,a2
    80000d9a:	84b6                	mv	s1,a3
  {
    va0 = PGROUNDDOWN(srcva);
    80000d9c:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000d9e:	6985                	lui	s3,0x1
    80000da0:	a02d                	j	80000dca <copyinstr+0x4e>
    char *p = (char *)(pa0 + (srcva - va0));
    while (n > 0)
    {
      if (*p == '\0')
      {
        *dst = '\0';
    80000da2:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000da6:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if (got_null)
    80000da8:	37fd                	addiw	a5,a5,-1
    80000daa:	0007851b          	sext.w	a0,a5
  }
  else
  {
    return -1;
  }
}
    80000dae:	60a6                	ld	ra,72(sp)
    80000db0:	6406                	ld	s0,64(sp)
    80000db2:	74e2                	ld	s1,56(sp)
    80000db4:	7942                	ld	s2,48(sp)
    80000db6:	79a2                	ld	s3,40(sp)
    80000db8:	7a02                	ld	s4,32(sp)
    80000dba:	6ae2                	ld	s5,24(sp)
    80000dbc:	6b42                	ld	s6,16(sp)
    80000dbe:	6ba2                	ld	s7,8(sp)
    80000dc0:	6161                	addi	sp,sp,80
    80000dc2:	8082                	ret
    srcva = va0 + PGSIZE;
    80000dc4:	01390bb3          	add	s7,s2,s3
  while (got_null == 0 && max > 0)
    80000dc8:	c8a9                	beqz	s1,80000e1a <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80000dca:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000dce:	85ca                	mv	a1,s2
    80000dd0:	8552                	mv	a0,s4
    80000dd2:	00000097          	auipc	ra,0x0
    80000dd6:	872080e7          	jalr	-1934(ra) # 80000644 <walkaddr>
    if (pa0 == 0)
    80000dda:	c131                	beqz	a0,80000e1e <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000ddc:	417906b3          	sub	a3,s2,s7
    80000de0:	96ce                	add	a3,a3,s3
    80000de2:	00d4f363          	bgeu	s1,a3,80000de8 <copyinstr+0x6c>
    80000de6:	86a6                	mv	a3,s1
    char *p = (char *)(pa0 + (srcva - va0));
    80000de8:	955e                	add	a0,a0,s7
    80000dea:	41250533          	sub	a0,a0,s2
    while (n > 0)
    80000dee:	daf9                	beqz	a3,80000dc4 <copyinstr+0x48>
    80000df0:	87da                	mv	a5,s6
      if (*p == '\0')
    80000df2:	41650633          	sub	a2,a0,s6
    80000df6:	fff48593          	addi	a1,s1,-1
    80000dfa:	95da                	add	a1,a1,s6
    while (n > 0)
    80000dfc:	96da                	add	a3,a3,s6
      if (*p == '\0')
    80000dfe:	00f60733          	add	a4,a2,a5
    80000e02:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7fdb8dc0>
    80000e06:	df51                	beqz	a4,80000da2 <copyinstr+0x26>
        *dst = *p;
    80000e08:	00e78023          	sb	a4,0(a5)
      --max;
    80000e0c:	40f584b3          	sub	s1,a1,a5
      dst++;
    80000e10:	0785                	addi	a5,a5,1
    while (n > 0)
    80000e12:	fed796e3          	bne	a5,a3,80000dfe <copyinstr+0x82>
      dst++;
    80000e16:	8b3e                	mv	s6,a5
    80000e18:	b775                	j	80000dc4 <copyinstr+0x48>
    80000e1a:	4781                	li	a5,0
    80000e1c:	b771                	j	80000da8 <copyinstr+0x2c>
      return -1;
    80000e1e:	557d                	li	a0,-1
    80000e20:	b779                	j	80000dae <copyinstr+0x32>
  int got_null = 0;
    80000e22:	4781                	li	a5,0
  if (got_null)
    80000e24:	37fd                	addiw	a5,a5,-1
    80000e26:	0007851b          	sext.w	a0,a5
}
    80000e2a:	8082                	ret

0000000080000e2c <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void proc_mapstacks(pagetable_t kpgtbl)
{
    80000e2c:	7139                	addi	sp,sp,-64
    80000e2e:	fc06                	sd	ra,56(sp)
    80000e30:	f822                	sd	s0,48(sp)
    80000e32:	f426                	sd	s1,40(sp)
    80000e34:	f04a                	sd	s2,32(sp)
    80000e36:	ec4e                	sd	s3,24(sp)
    80000e38:	e852                	sd	s4,16(sp)
    80000e3a:	e456                	sd	s5,8(sp)
    80000e3c:	e05a                	sd	s6,0(sp)
    80000e3e:	0080                	addi	s0,sp,64
    80000e40:	89aa                	mv	s3,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    80000e42:	00228497          	auipc	s1,0x228
    80000e46:	65648493          	addi	s1,s1,1622 # 80229498 <proc>
  {
    char *pa = kalloc();
    if (pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int)(p - proc));
    80000e4a:	8b26                	mv	s6,s1
    80000e4c:	00007a97          	auipc	s5,0x7
    80000e50:	1b4a8a93          	addi	s5,s5,436 # 80008000 <etext>
    80000e54:	04000937          	lui	s2,0x4000
    80000e58:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000e5a:	0932                	slli	s2,s2,0xc
  for (p = proc; p < &proc[NPROC]; p++)
    80000e5c:	0022ea17          	auipc	s4,0x22e
    80000e60:	03ca0a13          	addi	s4,s4,60 # 8022ee98 <tickslock>
    char *pa = kalloc();
    80000e64:	fffff097          	auipc	ra,0xfffff
    80000e68:	342080e7          	jalr	834(ra) # 800001a6 <kalloc>
    80000e6c:	862a                	mv	a2,a0
    if (pa == 0)
    80000e6e:	c131                	beqz	a0,80000eb2 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int)(p - proc));
    80000e70:	416485b3          	sub	a1,s1,s6
    80000e74:	858d                	srai	a1,a1,0x3
    80000e76:	000ab783          	ld	a5,0(s5)
    80000e7a:	02f585b3          	mul	a1,a1,a5
    80000e7e:	2585                	addiw	a1,a1,1
    80000e80:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000e84:	4719                	li	a4,6
    80000e86:	6685                	lui	a3,0x1
    80000e88:	40b905b3          	sub	a1,s2,a1
    80000e8c:	854e                	mv	a0,s3
    80000e8e:	00000097          	auipc	ra,0x0
    80000e92:	898080e7          	jalr	-1896(ra) # 80000726 <kvmmap>
  for (p = proc; p < &proc[NPROC]; p++)
    80000e96:	16848493          	addi	s1,s1,360
    80000e9a:	fd4495e3          	bne	s1,s4,80000e64 <proc_mapstacks+0x38>
  }
}
    80000e9e:	70e2                	ld	ra,56(sp)
    80000ea0:	7442                	ld	s0,48(sp)
    80000ea2:	74a2                	ld	s1,40(sp)
    80000ea4:	7902                	ld	s2,32(sp)
    80000ea6:	69e2                	ld	s3,24(sp)
    80000ea8:	6a42                	ld	s4,16(sp)
    80000eaa:	6aa2                	ld	s5,8(sp)
    80000eac:	6b02                	ld	s6,0(sp)
    80000eae:	6121                	addi	sp,sp,64
    80000eb0:	8082                	ret
      panic("kalloc");
    80000eb2:	00007517          	auipc	a0,0x7
    80000eb6:	2b650513          	addi	a0,a0,694 # 80008168 <etext+0x168>
    80000eba:	00005097          	auipc	ra,0x5
    80000ebe:	f56080e7          	jalr	-170(ra) # 80005e10 <panic>

0000000080000ec2 <procinit>:

// initialize the proc table at boot time.
void procinit(void)
{
    80000ec2:	7139                	addi	sp,sp,-64
    80000ec4:	fc06                	sd	ra,56(sp)
    80000ec6:	f822                	sd	s0,48(sp)
    80000ec8:	f426                	sd	s1,40(sp)
    80000eca:	f04a                	sd	s2,32(sp)
    80000ecc:	ec4e                	sd	s3,24(sp)
    80000ece:	e852                	sd	s4,16(sp)
    80000ed0:	e456                	sd	s5,8(sp)
    80000ed2:	e05a                	sd	s6,0(sp)
    80000ed4:	0080                	addi	s0,sp,64
  struct proc *p;

  initlock(&pid_lock, "nextpid");
    80000ed6:	00007597          	auipc	a1,0x7
    80000eda:	29a58593          	addi	a1,a1,666 # 80008170 <etext+0x170>
    80000ede:	00228517          	auipc	a0,0x228
    80000ee2:	18a50513          	addi	a0,a0,394 # 80229068 <pid_lock>
    80000ee6:	00005097          	auipc	ra,0x5
    80000eea:	3d2080e7          	jalr	978(ra) # 800062b8 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000eee:	00007597          	auipc	a1,0x7
    80000ef2:	28a58593          	addi	a1,a1,650 # 80008178 <etext+0x178>
    80000ef6:	00228517          	auipc	a0,0x228
    80000efa:	18a50513          	addi	a0,a0,394 # 80229080 <wait_lock>
    80000efe:	00005097          	auipc	ra,0x5
    80000f02:	3ba080e7          	jalr	954(ra) # 800062b8 <initlock>
  for (p = proc; p < &proc[NPROC]; p++)
    80000f06:	00228497          	auipc	s1,0x228
    80000f0a:	59248493          	addi	s1,s1,1426 # 80229498 <proc>
  {
    initlock(&p->lock, "proc");
    80000f0e:	00007b17          	auipc	s6,0x7
    80000f12:	27ab0b13          	addi	s6,s6,634 # 80008188 <etext+0x188>
    p->kstack = KSTACK((int)(p - proc));
    80000f16:	8aa6                	mv	s5,s1
    80000f18:	00007a17          	auipc	s4,0x7
    80000f1c:	0e8a0a13          	addi	s4,s4,232 # 80008000 <etext>
    80000f20:	04000937          	lui	s2,0x4000
    80000f24:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000f26:	0932                	slli	s2,s2,0xc
  for (p = proc; p < &proc[NPROC]; p++)
    80000f28:	0022e997          	auipc	s3,0x22e
    80000f2c:	f7098993          	addi	s3,s3,-144 # 8022ee98 <tickslock>
    initlock(&p->lock, "proc");
    80000f30:	85da                	mv	a1,s6
    80000f32:	8526                	mv	a0,s1
    80000f34:	00005097          	auipc	ra,0x5
    80000f38:	384080e7          	jalr	900(ra) # 800062b8 <initlock>
    p->kstack = KSTACK((int)(p - proc));
    80000f3c:	415487b3          	sub	a5,s1,s5
    80000f40:	878d                	srai	a5,a5,0x3
    80000f42:	000a3703          	ld	a4,0(s4)
    80000f46:	02e787b3          	mul	a5,a5,a4
    80000f4a:	2785                	addiw	a5,a5,1
    80000f4c:	00d7979b          	slliw	a5,a5,0xd
    80000f50:	40f907b3          	sub	a5,s2,a5
    80000f54:	e0bc                	sd	a5,64(s1)
  for (p = proc; p < &proc[NPROC]; p++)
    80000f56:	16848493          	addi	s1,s1,360
    80000f5a:	fd349be3          	bne	s1,s3,80000f30 <procinit+0x6e>
  }
}
    80000f5e:	70e2                	ld	ra,56(sp)
    80000f60:	7442                	ld	s0,48(sp)
    80000f62:	74a2                	ld	s1,40(sp)
    80000f64:	7902                	ld	s2,32(sp)
    80000f66:	69e2                	ld	s3,24(sp)
    80000f68:	6a42                	ld	s4,16(sp)
    80000f6a:	6aa2                	ld	s5,8(sp)
    80000f6c:	6b02                	ld	s6,0(sp)
    80000f6e:	6121                	addi	sp,sp,64
    80000f70:	8082                	ret

0000000080000f72 <cpuid>:

// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int cpuid()
{
    80000f72:	1141                	addi	sp,sp,-16
    80000f74:	e422                	sd	s0,8(sp)
    80000f76:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000f78:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000f7a:	2501                	sext.w	a0,a0
    80000f7c:	6422                	ld	s0,8(sp)
    80000f7e:	0141                	addi	sp,sp,16
    80000f80:	8082                	ret

0000000080000f82 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu *
mycpu(void)
{
    80000f82:	1141                	addi	sp,sp,-16
    80000f84:	e422                	sd	s0,8(sp)
    80000f86:	0800                	addi	s0,sp,16
    80000f88:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000f8a:	2781                	sext.w	a5,a5
    80000f8c:	079e                	slli	a5,a5,0x7
  return c;
}
    80000f8e:	00228517          	auipc	a0,0x228
    80000f92:	10a50513          	addi	a0,a0,266 # 80229098 <cpus>
    80000f96:	953e                	add	a0,a0,a5
    80000f98:	6422                	ld	s0,8(sp)
    80000f9a:	0141                	addi	sp,sp,16
    80000f9c:	8082                	ret

0000000080000f9e <myproc>:

// Return the current struct proc *, or zero if none.
struct proc *
myproc(void)
{
    80000f9e:	1101                	addi	sp,sp,-32
    80000fa0:	ec06                	sd	ra,24(sp)
    80000fa2:	e822                	sd	s0,16(sp)
    80000fa4:	e426                	sd	s1,8(sp)
    80000fa6:	1000                	addi	s0,sp,32
  push_off();
    80000fa8:	00005097          	auipc	ra,0x5
    80000fac:	354080e7          	jalr	852(ra) # 800062fc <push_off>
    80000fb0:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000fb2:	2781                	sext.w	a5,a5
    80000fb4:	079e                	slli	a5,a5,0x7
    80000fb6:	00228717          	auipc	a4,0x228
    80000fba:	0b270713          	addi	a4,a4,178 # 80229068 <pid_lock>
    80000fbe:	97ba                	add	a5,a5,a4
    80000fc0:	7b84                	ld	s1,48(a5)
  pop_off();
    80000fc2:	00005097          	auipc	ra,0x5
    80000fc6:	3da080e7          	jalr	986(ra) # 8000639c <pop_off>
  return p;
}
    80000fca:	8526                	mv	a0,s1
    80000fcc:	60e2                	ld	ra,24(sp)
    80000fce:	6442                	ld	s0,16(sp)
    80000fd0:	64a2                	ld	s1,8(sp)
    80000fd2:	6105                	addi	sp,sp,32
    80000fd4:	8082                	ret

0000000080000fd6 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void)
{
    80000fd6:	1141                	addi	sp,sp,-16
    80000fd8:	e406                	sd	ra,8(sp)
    80000fda:	e022                	sd	s0,0(sp)
    80000fdc:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000fde:	00000097          	auipc	ra,0x0
    80000fe2:	fc0080e7          	jalr	-64(ra) # 80000f9e <myproc>
    80000fe6:	00005097          	auipc	ra,0x5
    80000fea:	416080e7          	jalr	1046(ra) # 800063fc <release>

  if (first)
    80000fee:	00008797          	auipc	a5,0x8
    80000ff2:	8327a783          	lw	a5,-1998(a5) # 80008820 <first.1>
    80000ff6:	eb89                	bnez	a5,80001008 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000ff8:	00001097          	auipc	ra,0x1
    80000ffc:	d92080e7          	jalr	-622(ra) # 80001d8a <usertrapret>
}
    80001000:	60a2                	ld	ra,8(sp)
    80001002:	6402                	ld	s0,0(sp)
    80001004:	0141                	addi	sp,sp,16
    80001006:	8082                	ret
    first = 0;
    80001008:	00008797          	auipc	a5,0x8
    8000100c:	8007ac23          	sw	zero,-2024(a5) # 80008820 <first.1>
    fsinit(ROOTDEV);
    80001010:	4505                	li	a0,1
    80001012:	00002097          	auipc	ra,0x2
    80001016:	b14080e7          	jalr	-1260(ra) # 80002b26 <fsinit>
    8000101a:	bff9                	j	80000ff8 <forkret+0x22>

000000008000101c <allocpid>:
{
    8000101c:	1101                	addi	sp,sp,-32
    8000101e:	ec06                	sd	ra,24(sp)
    80001020:	e822                	sd	s0,16(sp)
    80001022:	e426                	sd	s1,8(sp)
    80001024:	e04a                	sd	s2,0(sp)
    80001026:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001028:	00228917          	auipc	s2,0x228
    8000102c:	04090913          	addi	s2,s2,64 # 80229068 <pid_lock>
    80001030:	854a                	mv	a0,s2
    80001032:	00005097          	auipc	ra,0x5
    80001036:	316080e7          	jalr	790(ra) # 80006348 <acquire>
  pid = nextpid;
    8000103a:	00007797          	auipc	a5,0x7
    8000103e:	7ea78793          	addi	a5,a5,2026 # 80008824 <nextpid>
    80001042:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001044:	0014871b          	addiw	a4,s1,1
    80001048:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    8000104a:	854a                	mv	a0,s2
    8000104c:	00005097          	auipc	ra,0x5
    80001050:	3b0080e7          	jalr	944(ra) # 800063fc <release>
}
    80001054:	8526                	mv	a0,s1
    80001056:	60e2                	ld	ra,24(sp)
    80001058:	6442                	ld	s0,16(sp)
    8000105a:	64a2                	ld	s1,8(sp)
    8000105c:	6902                	ld	s2,0(sp)
    8000105e:	6105                	addi	sp,sp,32
    80001060:	8082                	ret

0000000080001062 <proc_pagetable>:
{
    80001062:	1101                	addi	sp,sp,-32
    80001064:	ec06                	sd	ra,24(sp)
    80001066:	e822                	sd	s0,16(sp)
    80001068:	e426                	sd	s1,8(sp)
    8000106a:	e04a                	sd	s2,0(sp)
    8000106c:	1000                	addi	s0,sp,32
    8000106e:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001070:	00000097          	auipc	ra,0x0
    80001074:	8a0080e7          	jalr	-1888(ra) # 80000910 <uvmcreate>
    80001078:	84aa                	mv	s1,a0
  if (pagetable == 0)
    8000107a:	c121                	beqz	a0,800010ba <proc_pagetable+0x58>
  if (mappages(pagetable, TRAMPOLINE, PGSIZE,
    8000107c:	4729                	li	a4,10
    8000107e:	00006697          	auipc	a3,0x6
    80001082:	f8268693          	addi	a3,a3,-126 # 80007000 <_trampoline>
    80001086:	6605                	lui	a2,0x1
    80001088:	040005b7          	lui	a1,0x4000
    8000108c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000108e:	05b2                	slli	a1,a1,0xc
    80001090:	fffff097          	auipc	ra,0xfffff
    80001094:	5f6080e7          	jalr	1526(ra) # 80000686 <mappages>
    80001098:	02054863          	bltz	a0,800010c8 <proc_pagetable+0x66>
  if (mappages(pagetable, TRAPFRAME, PGSIZE,
    8000109c:	4719                	li	a4,6
    8000109e:	05893683          	ld	a3,88(s2)
    800010a2:	6605                	lui	a2,0x1
    800010a4:	020005b7          	lui	a1,0x2000
    800010a8:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800010aa:	05b6                	slli	a1,a1,0xd
    800010ac:	8526                	mv	a0,s1
    800010ae:	fffff097          	auipc	ra,0xfffff
    800010b2:	5d8080e7          	jalr	1496(ra) # 80000686 <mappages>
    800010b6:	02054163          	bltz	a0,800010d8 <proc_pagetable+0x76>
}
    800010ba:	8526                	mv	a0,s1
    800010bc:	60e2                	ld	ra,24(sp)
    800010be:	6442                	ld	s0,16(sp)
    800010c0:	64a2                	ld	s1,8(sp)
    800010c2:	6902                	ld	s2,0(sp)
    800010c4:	6105                	addi	sp,sp,32
    800010c6:	8082                	ret
    uvmfree(pagetable, 0);
    800010c8:	4581                	li	a1,0
    800010ca:	8526                	mv	a0,s1
    800010cc:	00000097          	auipc	ra,0x0
    800010d0:	a42080e7          	jalr	-1470(ra) # 80000b0e <uvmfree>
    return 0;
    800010d4:	4481                	li	s1,0
    800010d6:	b7d5                	j	800010ba <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010d8:	4681                	li	a3,0
    800010da:	4605                	li	a2,1
    800010dc:	040005b7          	lui	a1,0x4000
    800010e0:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800010e2:	05b2                	slli	a1,a1,0xc
    800010e4:	8526                	mv	a0,s1
    800010e6:	fffff097          	auipc	ra,0xfffff
    800010ea:	766080e7          	jalr	1894(ra) # 8000084c <uvmunmap>
    uvmfree(pagetable, 0);
    800010ee:	4581                	li	a1,0
    800010f0:	8526                	mv	a0,s1
    800010f2:	00000097          	auipc	ra,0x0
    800010f6:	a1c080e7          	jalr	-1508(ra) # 80000b0e <uvmfree>
    return 0;
    800010fa:	4481                	li	s1,0
    800010fc:	bf7d                	j	800010ba <proc_pagetable+0x58>

00000000800010fe <proc_freepagetable>:
{
    800010fe:	1101                	addi	sp,sp,-32
    80001100:	ec06                	sd	ra,24(sp)
    80001102:	e822                	sd	s0,16(sp)
    80001104:	e426                	sd	s1,8(sp)
    80001106:	e04a                	sd	s2,0(sp)
    80001108:	1000                	addi	s0,sp,32
    8000110a:	84aa                	mv	s1,a0
    8000110c:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000110e:	4681                	li	a3,0
    80001110:	4605                	li	a2,1
    80001112:	040005b7          	lui	a1,0x4000
    80001116:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001118:	05b2                	slli	a1,a1,0xc
    8000111a:	fffff097          	auipc	ra,0xfffff
    8000111e:	732080e7          	jalr	1842(ra) # 8000084c <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001122:	4681                	li	a3,0
    80001124:	4605                	li	a2,1
    80001126:	020005b7          	lui	a1,0x2000
    8000112a:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    8000112c:	05b6                	slli	a1,a1,0xd
    8000112e:	8526                	mv	a0,s1
    80001130:	fffff097          	auipc	ra,0xfffff
    80001134:	71c080e7          	jalr	1820(ra) # 8000084c <uvmunmap>
  uvmfree(pagetable, sz);
    80001138:	85ca                	mv	a1,s2
    8000113a:	8526                	mv	a0,s1
    8000113c:	00000097          	auipc	ra,0x0
    80001140:	9d2080e7          	jalr	-1582(ra) # 80000b0e <uvmfree>
}
    80001144:	60e2                	ld	ra,24(sp)
    80001146:	6442                	ld	s0,16(sp)
    80001148:	64a2                	ld	s1,8(sp)
    8000114a:	6902                	ld	s2,0(sp)
    8000114c:	6105                	addi	sp,sp,32
    8000114e:	8082                	ret

0000000080001150 <freeproc>:
{
    80001150:	1101                	addi	sp,sp,-32
    80001152:	ec06                	sd	ra,24(sp)
    80001154:	e822                	sd	s0,16(sp)
    80001156:	e426                	sd	s1,8(sp)
    80001158:	1000                	addi	s0,sp,32
    8000115a:	84aa                	mv	s1,a0
  if (p->trapframe)
    8000115c:	6d28                	ld	a0,88(a0)
    8000115e:	c509                	beqz	a0,80001168 <freeproc+0x18>
    kfree((void *)p->trapframe);
    80001160:	fffff097          	auipc	ra,0xfffff
    80001164:	ebc080e7          	jalr	-324(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001168:	0404bc23          	sd	zero,88(s1)
  if (p->pagetable)
    8000116c:	68a8                	ld	a0,80(s1)
    8000116e:	c511                	beqz	a0,8000117a <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001170:	64ac                	ld	a1,72(s1)
    80001172:	00000097          	auipc	ra,0x0
    80001176:	f8c080e7          	jalr	-116(ra) # 800010fe <proc_freepagetable>
  p->pagetable = 0;
    8000117a:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    8000117e:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001182:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001186:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    8000118a:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    8000118e:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001192:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001196:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    8000119a:	0004ac23          	sw	zero,24(s1)
}
    8000119e:	60e2                	ld	ra,24(sp)
    800011a0:	6442                	ld	s0,16(sp)
    800011a2:	64a2                	ld	s1,8(sp)
    800011a4:	6105                	addi	sp,sp,32
    800011a6:	8082                	ret

00000000800011a8 <allocproc>:
{
    800011a8:	1101                	addi	sp,sp,-32
    800011aa:	ec06                	sd	ra,24(sp)
    800011ac:	e822                	sd	s0,16(sp)
    800011ae:	e426                	sd	s1,8(sp)
    800011b0:	e04a                	sd	s2,0(sp)
    800011b2:	1000                	addi	s0,sp,32
  for (p = proc; p < &proc[NPROC]; p++)
    800011b4:	00228497          	auipc	s1,0x228
    800011b8:	2e448493          	addi	s1,s1,740 # 80229498 <proc>
    800011bc:	0022e917          	auipc	s2,0x22e
    800011c0:	cdc90913          	addi	s2,s2,-804 # 8022ee98 <tickslock>
    acquire(&p->lock);
    800011c4:	8526                	mv	a0,s1
    800011c6:	00005097          	auipc	ra,0x5
    800011ca:	182080e7          	jalr	386(ra) # 80006348 <acquire>
    if (p->state == UNUSED)
    800011ce:	4c9c                	lw	a5,24(s1)
    800011d0:	cf81                	beqz	a5,800011e8 <allocproc+0x40>
      release(&p->lock);
    800011d2:	8526                	mv	a0,s1
    800011d4:	00005097          	auipc	ra,0x5
    800011d8:	228080e7          	jalr	552(ra) # 800063fc <release>
  for (p = proc; p < &proc[NPROC]; p++)
    800011dc:	16848493          	addi	s1,s1,360
    800011e0:	ff2492e3          	bne	s1,s2,800011c4 <allocproc+0x1c>
  return 0;
    800011e4:	4481                	li	s1,0
    800011e6:	a889                	j	80001238 <allocproc+0x90>
  p->pid = allocpid();
    800011e8:	00000097          	auipc	ra,0x0
    800011ec:	e34080e7          	jalr	-460(ra) # 8000101c <allocpid>
    800011f0:	d888                	sw	a0,48(s1)
  p->state = USED;
    800011f2:	4785                	li	a5,1
    800011f4:	cc9c                	sw	a5,24(s1)
  if ((p->trapframe = (struct trapframe *)kalloc()) == 0)
    800011f6:	fffff097          	auipc	ra,0xfffff
    800011fa:	fb0080e7          	jalr	-80(ra) # 800001a6 <kalloc>
    800011fe:	892a                	mv	s2,a0
    80001200:	eca8                	sd	a0,88(s1)
    80001202:	c131                	beqz	a0,80001246 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001204:	8526                	mv	a0,s1
    80001206:	00000097          	auipc	ra,0x0
    8000120a:	e5c080e7          	jalr	-420(ra) # 80001062 <proc_pagetable>
    8000120e:	892a                	mv	s2,a0
    80001210:	e8a8                	sd	a0,80(s1)
  if (p->pagetable == 0)
    80001212:	c531                	beqz	a0,8000125e <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001214:	07000613          	li	a2,112
    80001218:	4581                	li	a1,0
    8000121a:	06048513          	addi	a0,s1,96
    8000121e:	fffff097          	auipc	ra,0xfffff
    80001222:	0a0080e7          	jalr	160(ra) # 800002be <memset>
  p->context.ra = (uint64)forkret;
    80001226:	00000797          	auipc	a5,0x0
    8000122a:	db078793          	addi	a5,a5,-592 # 80000fd6 <forkret>
    8000122e:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001230:	60bc                	ld	a5,64(s1)
    80001232:	6705                	lui	a4,0x1
    80001234:	97ba                	add	a5,a5,a4
    80001236:	f4bc                	sd	a5,104(s1)
}
    80001238:	8526                	mv	a0,s1
    8000123a:	60e2                	ld	ra,24(sp)
    8000123c:	6442                	ld	s0,16(sp)
    8000123e:	64a2                	ld	s1,8(sp)
    80001240:	6902                	ld	s2,0(sp)
    80001242:	6105                	addi	sp,sp,32
    80001244:	8082                	ret
    freeproc(p);
    80001246:	8526                	mv	a0,s1
    80001248:	00000097          	auipc	ra,0x0
    8000124c:	f08080e7          	jalr	-248(ra) # 80001150 <freeproc>
    release(&p->lock);
    80001250:	8526                	mv	a0,s1
    80001252:	00005097          	auipc	ra,0x5
    80001256:	1aa080e7          	jalr	426(ra) # 800063fc <release>
    return 0;
    8000125a:	84ca                	mv	s1,s2
    8000125c:	bff1                	j	80001238 <allocproc+0x90>
    freeproc(p);
    8000125e:	8526                	mv	a0,s1
    80001260:	00000097          	auipc	ra,0x0
    80001264:	ef0080e7          	jalr	-272(ra) # 80001150 <freeproc>
    release(&p->lock);
    80001268:	8526                	mv	a0,s1
    8000126a:	00005097          	auipc	ra,0x5
    8000126e:	192080e7          	jalr	402(ra) # 800063fc <release>
    return 0;
    80001272:	84ca                	mv	s1,s2
    80001274:	b7d1                	j	80001238 <allocproc+0x90>

0000000080001276 <userinit>:
{
    80001276:	1101                	addi	sp,sp,-32
    80001278:	ec06                	sd	ra,24(sp)
    8000127a:	e822                	sd	s0,16(sp)
    8000127c:	e426                	sd	s1,8(sp)
    8000127e:	1000                	addi	s0,sp,32
  p = allocproc();
    80001280:	00000097          	auipc	ra,0x0
    80001284:	f28080e7          	jalr	-216(ra) # 800011a8 <allocproc>
    80001288:	84aa                	mv	s1,a0
  initproc = p;
    8000128a:	00008797          	auipc	a5,0x8
    8000128e:	d8a7b323          	sd	a0,-634(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001292:	03400613          	li	a2,52
    80001296:	00007597          	auipc	a1,0x7
    8000129a:	59a58593          	addi	a1,a1,1434 # 80008830 <initcode>
    8000129e:	6928                	ld	a0,80(a0)
    800012a0:	fffff097          	auipc	ra,0xfffff
    800012a4:	69e080e7          	jalr	1694(ra) # 8000093e <uvminit>
  p->sz = PGSIZE;
    800012a8:	6785                	lui	a5,0x1
    800012aa:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;     // user program counter
    800012ac:	6cb8                	ld	a4,88(s1)
    800012ae:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE; // user stack pointer
    800012b2:	6cb8                	ld	a4,88(s1)
    800012b4:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800012b6:	4641                	li	a2,16
    800012b8:	00007597          	auipc	a1,0x7
    800012bc:	ed858593          	addi	a1,a1,-296 # 80008190 <etext+0x190>
    800012c0:	15848513          	addi	a0,s1,344
    800012c4:	fffff097          	auipc	ra,0xfffff
    800012c8:	144080e7          	jalr	324(ra) # 80000408 <safestrcpy>
  p->cwd = namei("/");
    800012cc:	00007517          	auipc	a0,0x7
    800012d0:	ed450513          	addi	a0,a0,-300 # 800081a0 <etext+0x1a0>
    800012d4:	00002097          	auipc	ra,0x2
    800012d8:	288080e7          	jalr	648(ra) # 8000355c <namei>
    800012dc:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800012e0:	478d                	li	a5,3
    800012e2:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800012e4:	8526                	mv	a0,s1
    800012e6:	00005097          	auipc	ra,0x5
    800012ea:	116080e7          	jalr	278(ra) # 800063fc <release>
}
    800012ee:	60e2                	ld	ra,24(sp)
    800012f0:	6442                	ld	s0,16(sp)
    800012f2:	64a2                	ld	s1,8(sp)
    800012f4:	6105                	addi	sp,sp,32
    800012f6:	8082                	ret

00000000800012f8 <growproc>:
{
    800012f8:	1101                	addi	sp,sp,-32
    800012fa:	ec06                	sd	ra,24(sp)
    800012fc:	e822                	sd	s0,16(sp)
    800012fe:	e426                	sd	s1,8(sp)
    80001300:	e04a                	sd	s2,0(sp)
    80001302:	1000                	addi	s0,sp,32
    80001304:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001306:	00000097          	auipc	ra,0x0
    8000130a:	c98080e7          	jalr	-872(ra) # 80000f9e <myproc>
    8000130e:	892a                	mv	s2,a0
  sz = p->sz;
    80001310:	652c                	ld	a1,72(a0)
    80001312:	0005879b          	sext.w	a5,a1
  if (n > 0)
    80001316:	00904f63          	bgtz	s1,80001334 <growproc+0x3c>
  else if (n < 0)
    8000131a:	0204cd63          	bltz	s1,80001354 <growproc+0x5c>
  p->sz = sz;
    8000131e:	1782                	slli	a5,a5,0x20
    80001320:	9381                	srli	a5,a5,0x20
    80001322:	04f93423          	sd	a5,72(s2)
  return 0;
    80001326:	4501                	li	a0,0
}
    80001328:	60e2                	ld	ra,24(sp)
    8000132a:	6442                	ld	s0,16(sp)
    8000132c:	64a2                	ld	s1,8(sp)
    8000132e:	6902                	ld	s2,0(sp)
    80001330:	6105                	addi	sp,sp,32
    80001332:	8082                	ret
    if ((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0)
    80001334:	00f4863b          	addw	a2,s1,a5
    80001338:	1602                	slli	a2,a2,0x20
    8000133a:	9201                	srli	a2,a2,0x20
    8000133c:	1582                	slli	a1,a1,0x20
    8000133e:	9181                	srli	a1,a1,0x20
    80001340:	6928                	ld	a0,80(a0)
    80001342:	fffff097          	auipc	ra,0xfffff
    80001346:	6b6080e7          	jalr	1718(ra) # 800009f8 <uvmalloc>
    8000134a:	0005079b          	sext.w	a5,a0
    8000134e:	fbe1                	bnez	a5,8000131e <growproc+0x26>
      return -1;
    80001350:	557d                	li	a0,-1
    80001352:	bfd9                	j	80001328 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001354:	00f4863b          	addw	a2,s1,a5
    80001358:	1602                	slli	a2,a2,0x20
    8000135a:	9201                	srli	a2,a2,0x20
    8000135c:	1582                	slli	a1,a1,0x20
    8000135e:	9181                	srli	a1,a1,0x20
    80001360:	6928                	ld	a0,80(a0)
    80001362:	fffff097          	auipc	ra,0xfffff
    80001366:	64e080e7          	jalr	1614(ra) # 800009b0 <uvmdealloc>
    8000136a:	0005079b          	sext.w	a5,a0
    8000136e:	bf45                	j	8000131e <growproc+0x26>

0000000080001370 <fork>:
{
    80001370:	7139                	addi	sp,sp,-64
    80001372:	fc06                	sd	ra,56(sp)
    80001374:	f822                	sd	s0,48(sp)
    80001376:	f426                	sd	s1,40(sp)
    80001378:	f04a                	sd	s2,32(sp)
    8000137a:	ec4e                	sd	s3,24(sp)
    8000137c:	e852                	sd	s4,16(sp)
    8000137e:	e456                	sd	s5,8(sp)
    80001380:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001382:	00000097          	auipc	ra,0x0
    80001386:	c1c080e7          	jalr	-996(ra) # 80000f9e <myproc>
    8000138a:	8aaa                	mv	s5,a0
  if ((np = allocproc()) == 0)
    8000138c:	00000097          	auipc	ra,0x0
    80001390:	e1c080e7          	jalr	-484(ra) # 800011a8 <allocproc>
    80001394:	10050c63          	beqz	a0,800014ac <fork+0x13c>
    80001398:	8a2a                	mv	s4,a0
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0)
    8000139a:	048ab603          	ld	a2,72(s5)
    8000139e:	692c                	ld	a1,80(a0)
    800013a0:	050ab503          	ld	a0,80(s5)
    800013a4:	fffff097          	auipc	ra,0xfffff
    800013a8:	7a4080e7          	jalr	1956(ra) # 80000b48 <uvmcopy>
    800013ac:	04054863          	bltz	a0,800013fc <fork+0x8c>
  np->sz = p->sz;
    800013b0:	048ab783          	ld	a5,72(s5)
    800013b4:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    800013b8:	058ab683          	ld	a3,88(s5)
    800013bc:	87b6                	mv	a5,a3
    800013be:	058a3703          	ld	a4,88(s4)
    800013c2:	12068693          	addi	a3,a3,288
    800013c6:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800013ca:	6788                	ld	a0,8(a5)
    800013cc:	6b8c                	ld	a1,16(a5)
    800013ce:	6f90                	ld	a2,24(a5)
    800013d0:	01073023          	sd	a6,0(a4)
    800013d4:	e708                	sd	a0,8(a4)
    800013d6:	eb0c                	sd	a1,16(a4)
    800013d8:	ef10                	sd	a2,24(a4)
    800013da:	02078793          	addi	a5,a5,32
    800013de:	02070713          	addi	a4,a4,32
    800013e2:	fed792e3          	bne	a5,a3,800013c6 <fork+0x56>
  np->trapframe->a0 = 0;
    800013e6:	058a3783          	ld	a5,88(s4)
    800013ea:	0607b823          	sd	zero,112(a5)
  for (i = 0; i < NOFILE; i++)
    800013ee:	0d0a8493          	addi	s1,s5,208
    800013f2:	0d0a0913          	addi	s2,s4,208
    800013f6:	150a8993          	addi	s3,s5,336
    800013fa:	a00d                	j	8000141c <fork+0xac>
    freeproc(np);
    800013fc:	8552                	mv	a0,s4
    800013fe:	00000097          	auipc	ra,0x0
    80001402:	d52080e7          	jalr	-686(ra) # 80001150 <freeproc>
    release(&np->lock);
    80001406:	8552                	mv	a0,s4
    80001408:	00005097          	auipc	ra,0x5
    8000140c:	ff4080e7          	jalr	-12(ra) # 800063fc <release>
    return -1;
    80001410:	597d                	li	s2,-1
    80001412:	a059                	j	80001498 <fork+0x128>
  for (i = 0; i < NOFILE; i++)
    80001414:	04a1                	addi	s1,s1,8
    80001416:	0921                	addi	s2,s2,8
    80001418:	01348b63          	beq	s1,s3,8000142e <fork+0xbe>
    if (p->ofile[i])
    8000141c:	6088                	ld	a0,0(s1)
    8000141e:	d97d                	beqz	a0,80001414 <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001420:	00002097          	auipc	ra,0x2
    80001424:	7d2080e7          	jalr	2002(ra) # 80003bf2 <filedup>
    80001428:	00a93023          	sd	a0,0(s2)
    8000142c:	b7e5                	j	80001414 <fork+0xa4>
  np->cwd = idup(p->cwd);
    8000142e:	150ab503          	ld	a0,336(s5)
    80001432:	00002097          	auipc	ra,0x2
    80001436:	930080e7          	jalr	-1744(ra) # 80002d62 <idup>
    8000143a:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000143e:	4641                	li	a2,16
    80001440:	158a8593          	addi	a1,s5,344
    80001444:	158a0513          	addi	a0,s4,344
    80001448:	fffff097          	auipc	ra,0xfffff
    8000144c:	fc0080e7          	jalr	-64(ra) # 80000408 <safestrcpy>
  pid = np->pid;
    80001450:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001454:	8552                	mv	a0,s4
    80001456:	00005097          	auipc	ra,0x5
    8000145a:	fa6080e7          	jalr	-90(ra) # 800063fc <release>
  acquire(&wait_lock);
    8000145e:	00228497          	auipc	s1,0x228
    80001462:	c2248493          	addi	s1,s1,-990 # 80229080 <wait_lock>
    80001466:	8526                	mv	a0,s1
    80001468:	00005097          	auipc	ra,0x5
    8000146c:	ee0080e7          	jalr	-288(ra) # 80006348 <acquire>
  np->parent = p;
    80001470:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001474:	8526                	mv	a0,s1
    80001476:	00005097          	auipc	ra,0x5
    8000147a:	f86080e7          	jalr	-122(ra) # 800063fc <release>
  acquire(&np->lock);
    8000147e:	8552                	mv	a0,s4
    80001480:	00005097          	auipc	ra,0x5
    80001484:	ec8080e7          	jalr	-312(ra) # 80006348 <acquire>
  np->state = RUNNABLE;
    80001488:	478d                	li	a5,3
    8000148a:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    8000148e:	8552                	mv	a0,s4
    80001490:	00005097          	auipc	ra,0x5
    80001494:	f6c080e7          	jalr	-148(ra) # 800063fc <release>
}
    80001498:	854a                	mv	a0,s2
    8000149a:	70e2                	ld	ra,56(sp)
    8000149c:	7442                	ld	s0,48(sp)
    8000149e:	74a2                	ld	s1,40(sp)
    800014a0:	7902                	ld	s2,32(sp)
    800014a2:	69e2                	ld	s3,24(sp)
    800014a4:	6a42                	ld	s4,16(sp)
    800014a6:	6aa2                	ld	s5,8(sp)
    800014a8:	6121                	addi	sp,sp,64
    800014aa:	8082                	ret
    return -1;
    800014ac:	597d                	li	s2,-1
    800014ae:	b7ed                	j	80001498 <fork+0x128>

00000000800014b0 <scheduler>:
{
    800014b0:	7139                	addi	sp,sp,-64
    800014b2:	fc06                	sd	ra,56(sp)
    800014b4:	f822                	sd	s0,48(sp)
    800014b6:	f426                	sd	s1,40(sp)
    800014b8:	f04a                	sd	s2,32(sp)
    800014ba:	ec4e                	sd	s3,24(sp)
    800014bc:	e852                	sd	s4,16(sp)
    800014be:	e456                	sd	s5,8(sp)
    800014c0:	e05a                	sd	s6,0(sp)
    800014c2:	0080                	addi	s0,sp,64
    800014c4:	8792                	mv	a5,tp
  int id = r_tp();
    800014c6:	2781                	sext.w	a5,a5
  c->proc = 0;
    800014c8:	00779a93          	slli	s5,a5,0x7
    800014cc:	00228717          	auipc	a4,0x228
    800014d0:	b9c70713          	addi	a4,a4,-1124 # 80229068 <pid_lock>
    800014d4:	9756                	add	a4,a4,s5
    800014d6:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800014da:	00228717          	auipc	a4,0x228
    800014de:	bc670713          	addi	a4,a4,-1082 # 802290a0 <cpus+0x8>
    800014e2:	9aba                	add	s5,s5,a4
      if (p->state == RUNNABLE)
    800014e4:	498d                	li	s3,3
        p->state = RUNNING;
    800014e6:	4b11                	li	s6,4
        c->proc = p;
    800014e8:	079e                	slli	a5,a5,0x7
    800014ea:	00228a17          	auipc	s4,0x228
    800014ee:	b7ea0a13          	addi	s4,s4,-1154 # 80229068 <pid_lock>
    800014f2:	9a3e                	add	s4,s4,a5
    for (p = proc; p < &proc[NPROC]; p++)
    800014f4:	0022e917          	auipc	s2,0x22e
    800014f8:	9a490913          	addi	s2,s2,-1628 # 8022ee98 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800014fc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001500:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001504:	10079073          	csrw	sstatus,a5
    80001508:	00228497          	auipc	s1,0x228
    8000150c:	f9048493          	addi	s1,s1,-112 # 80229498 <proc>
    80001510:	a811                	j	80001524 <scheduler+0x74>
      release(&p->lock);
    80001512:	8526                	mv	a0,s1
    80001514:	00005097          	auipc	ra,0x5
    80001518:	ee8080e7          	jalr	-280(ra) # 800063fc <release>
    for (p = proc; p < &proc[NPROC]; p++)
    8000151c:	16848493          	addi	s1,s1,360
    80001520:	fd248ee3          	beq	s1,s2,800014fc <scheduler+0x4c>
      acquire(&p->lock);
    80001524:	8526                	mv	a0,s1
    80001526:	00005097          	auipc	ra,0x5
    8000152a:	e22080e7          	jalr	-478(ra) # 80006348 <acquire>
      if (p->state == RUNNABLE)
    8000152e:	4c9c                	lw	a5,24(s1)
    80001530:	ff3791e3          	bne	a5,s3,80001512 <scheduler+0x62>
        p->state = RUNNING;
    80001534:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001538:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000153c:	06048593          	addi	a1,s1,96
    80001540:	8556                	mv	a0,s5
    80001542:	00000097          	auipc	ra,0x0
    80001546:	67e080e7          	jalr	1662(ra) # 80001bc0 <swtch>
        c->proc = 0;
    8000154a:	020a3823          	sd	zero,48(s4)
    8000154e:	b7d1                	j	80001512 <scheduler+0x62>

0000000080001550 <sched>:
{
    80001550:	7179                	addi	sp,sp,-48
    80001552:	f406                	sd	ra,40(sp)
    80001554:	f022                	sd	s0,32(sp)
    80001556:	ec26                	sd	s1,24(sp)
    80001558:	e84a                	sd	s2,16(sp)
    8000155a:	e44e                	sd	s3,8(sp)
    8000155c:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000155e:	00000097          	auipc	ra,0x0
    80001562:	a40080e7          	jalr	-1472(ra) # 80000f9e <myproc>
    80001566:	84aa                	mv	s1,a0
  if (!holding(&p->lock))
    80001568:	00005097          	auipc	ra,0x5
    8000156c:	d66080e7          	jalr	-666(ra) # 800062ce <holding>
    80001570:	c93d                	beqz	a0,800015e6 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001572:	8792                	mv	a5,tp
  if (mycpu()->noff != 1)
    80001574:	2781                	sext.w	a5,a5
    80001576:	079e                	slli	a5,a5,0x7
    80001578:	00228717          	auipc	a4,0x228
    8000157c:	af070713          	addi	a4,a4,-1296 # 80229068 <pid_lock>
    80001580:	97ba                	add	a5,a5,a4
    80001582:	0a87a703          	lw	a4,168(a5)
    80001586:	4785                	li	a5,1
    80001588:	06f71763          	bne	a4,a5,800015f6 <sched+0xa6>
  if (p->state == RUNNING)
    8000158c:	4c98                	lw	a4,24(s1)
    8000158e:	4791                	li	a5,4
    80001590:	06f70b63          	beq	a4,a5,80001606 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001594:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001598:	8b89                	andi	a5,a5,2
  if (intr_get())
    8000159a:	efb5                	bnez	a5,80001616 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000159c:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000159e:	00228917          	auipc	s2,0x228
    800015a2:	aca90913          	addi	s2,s2,-1334 # 80229068 <pid_lock>
    800015a6:	2781                	sext.w	a5,a5
    800015a8:	079e                	slli	a5,a5,0x7
    800015aa:	97ca                	add	a5,a5,s2
    800015ac:	0ac7a983          	lw	s3,172(a5)
    800015b0:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800015b2:	2781                	sext.w	a5,a5
    800015b4:	079e                	slli	a5,a5,0x7
    800015b6:	00228597          	auipc	a1,0x228
    800015ba:	aea58593          	addi	a1,a1,-1302 # 802290a0 <cpus+0x8>
    800015be:	95be                	add	a1,a1,a5
    800015c0:	06048513          	addi	a0,s1,96
    800015c4:	00000097          	auipc	ra,0x0
    800015c8:	5fc080e7          	jalr	1532(ra) # 80001bc0 <swtch>
    800015cc:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800015ce:	2781                	sext.w	a5,a5
    800015d0:	079e                	slli	a5,a5,0x7
    800015d2:	993e                	add	s2,s2,a5
    800015d4:	0b392623          	sw	s3,172(s2)
}
    800015d8:	70a2                	ld	ra,40(sp)
    800015da:	7402                	ld	s0,32(sp)
    800015dc:	64e2                	ld	s1,24(sp)
    800015de:	6942                	ld	s2,16(sp)
    800015e0:	69a2                	ld	s3,8(sp)
    800015e2:	6145                	addi	sp,sp,48
    800015e4:	8082                	ret
    panic("sched p->lock");
    800015e6:	00007517          	auipc	a0,0x7
    800015ea:	bc250513          	addi	a0,a0,-1086 # 800081a8 <etext+0x1a8>
    800015ee:	00005097          	auipc	ra,0x5
    800015f2:	822080e7          	jalr	-2014(ra) # 80005e10 <panic>
    panic("sched locks");
    800015f6:	00007517          	auipc	a0,0x7
    800015fa:	bc250513          	addi	a0,a0,-1086 # 800081b8 <etext+0x1b8>
    800015fe:	00005097          	auipc	ra,0x5
    80001602:	812080e7          	jalr	-2030(ra) # 80005e10 <panic>
    panic("sched running");
    80001606:	00007517          	auipc	a0,0x7
    8000160a:	bc250513          	addi	a0,a0,-1086 # 800081c8 <etext+0x1c8>
    8000160e:	00005097          	auipc	ra,0x5
    80001612:	802080e7          	jalr	-2046(ra) # 80005e10 <panic>
    panic("sched interruptible");
    80001616:	00007517          	auipc	a0,0x7
    8000161a:	bc250513          	addi	a0,a0,-1086 # 800081d8 <etext+0x1d8>
    8000161e:	00004097          	auipc	ra,0x4
    80001622:	7f2080e7          	jalr	2034(ra) # 80005e10 <panic>

0000000080001626 <yield>:
{
    80001626:	1101                	addi	sp,sp,-32
    80001628:	ec06                	sd	ra,24(sp)
    8000162a:	e822                	sd	s0,16(sp)
    8000162c:	e426                	sd	s1,8(sp)
    8000162e:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001630:	00000097          	auipc	ra,0x0
    80001634:	96e080e7          	jalr	-1682(ra) # 80000f9e <myproc>
    80001638:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000163a:	00005097          	auipc	ra,0x5
    8000163e:	d0e080e7          	jalr	-754(ra) # 80006348 <acquire>
  p->state = RUNNABLE;
    80001642:	478d                	li	a5,3
    80001644:	cc9c                	sw	a5,24(s1)
  sched();
    80001646:	00000097          	auipc	ra,0x0
    8000164a:	f0a080e7          	jalr	-246(ra) # 80001550 <sched>
  release(&p->lock);
    8000164e:	8526                	mv	a0,s1
    80001650:	00005097          	auipc	ra,0x5
    80001654:	dac080e7          	jalr	-596(ra) # 800063fc <release>
}
    80001658:	60e2                	ld	ra,24(sp)
    8000165a:	6442                	ld	s0,16(sp)
    8000165c:	64a2                	ld	s1,8(sp)
    8000165e:	6105                	addi	sp,sp,32
    80001660:	8082                	ret

0000000080001662 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
    80001662:	7179                	addi	sp,sp,-48
    80001664:	f406                	sd	ra,40(sp)
    80001666:	f022                	sd	s0,32(sp)
    80001668:	ec26                	sd	s1,24(sp)
    8000166a:	e84a                	sd	s2,16(sp)
    8000166c:	e44e                	sd	s3,8(sp)
    8000166e:	1800                	addi	s0,sp,48
    80001670:	89aa                	mv	s3,a0
    80001672:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001674:	00000097          	auipc	ra,0x0
    80001678:	92a080e7          	jalr	-1750(ra) # 80000f9e <myproc>
    8000167c:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock); // DOC: sleeplock1
    8000167e:	00005097          	auipc	ra,0x5
    80001682:	cca080e7          	jalr	-822(ra) # 80006348 <acquire>
  release(lk);
    80001686:	854a                	mv	a0,s2
    80001688:	00005097          	auipc	ra,0x5
    8000168c:	d74080e7          	jalr	-652(ra) # 800063fc <release>

  // Go to sleep.
  p->chan = chan;
    80001690:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001694:	4789                	li	a5,2
    80001696:	cc9c                	sw	a5,24(s1)

  sched();
    80001698:	00000097          	auipc	ra,0x0
    8000169c:	eb8080e7          	jalr	-328(ra) # 80001550 <sched>

  // Tidy up.
  p->chan = 0;
    800016a0:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800016a4:	8526                	mv	a0,s1
    800016a6:	00005097          	auipc	ra,0x5
    800016aa:	d56080e7          	jalr	-682(ra) # 800063fc <release>
  acquire(lk);
    800016ae:	854a                	mv	a0,s2
    800016b0:	00005097          	auipc	ra,0x5
    800016b4:	c98080e7          	jalr	-872(ra) # 80006348 <acquire>
}
    800016b8:	70a2                	ld	ra,40(sp)
    800016ba:	7402                	ld	s0,32(sp)
    800016bc:	64e2                	ld	s1,24(sp)
    800016be:	6942                	ld	s2,16(sp)
    800016c0:	69a2                	ld	s3,8(sp)
    800016c2:	6145                	addi	sp,sp,48
    800016c4:	8082                	ret

00000000800016c6 <wait>:
{
    800016c6:	715d                	addi	sp,sp,-80
    800016c8:	e486                	sd	ra,72(sp)
    800016ca:	e0a2                	sd	s0,64(sp)
    800016cc:	fc26                	sd	s1,56(sp)
    800016ce:	f84a                	sd	s2,48(sp)
    800016d0:	f44e                	sd	s3,40(sp)
    800016d2:	f052                	sd	s4,32(sp)
    800016d4:	ec56                	sd	s5,24(sp)
    800016d6:	e85a                	sd	s6,16(sp)
    800016d8:	e45e                	sd	s7,8(sp)
    800016da:	e062                	sd	s8,0(sp)
    800016dc:	0880                	addi	s0,sp,80
    800016de:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800016e0:	00000097          	auipc	ra,0x0
    800016e4:	8be080e7          	jalr	-1858(ra) # 80000f9e <myproc>
    800016e8:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800016ea:	00228517          	auipc	a0,0x228
    800016ee:	99650513          	addi	a0,a0,-1642 # 80229080 <wait_lock>
    800016f2:	00005097          	auipc	ra,0x5
    800016f6:	c56080e7          	jalr	-938(ra) # 80006348 <acquire>
    havekids = 0;
    800016fa:	4b81                	li	s7,0
        if (np->state == ZOMBIE)
    800016fc:	4a15                	li	s4,5
        havekids = 1;
    800016fe:	4a85                	li	s5,1
    for (np = proc; np < &proc[NPROC]; np++)
    80001700:	0022d997          	auipc	s3,0x22d
    80001704:	79898993          	addi	s3,s3,1944 # 8022ee98 <tickslock>
    sleep(p, &wait_lock); // DOC: wait-sleep
    80001708:	00228c17          	auipc	s8,0x228
    8000170c:	978c0c13          	addi	s8,s8,-1672 # 80229080 <wait_lock>
    havekids = 0;
    80001710:	875e                	mv	a4,s7
    for (np = proc; np < &proc[NPROC]; np++)
    80001712:	00228497          	auipc	s1,0x228
    80001716:	d8648493          	addi	s1,s1,-634 # 80229498 <proc>
    8000171a:	a0bd                	j	80001788 <wait+0xc2>
          pid = np->pid;
    8000171c:	0304a983          	lw	s3,48(s1)
          if (addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80001720:	000b0e63          	beqz	s6,8000173c <wait+0x76>
    80001724:	4691                	li	a3,4
    80001726:	02c48613          	addi	a2,s1,44
    8000172a:	85da                	mv	a1,s6
    8000172c:	05093503          	ld	a0,80(s2)
    80001730:	fffff097          	auipc	ra,0xfffff
    80001734:	504080e7          	jalr	1284(ra) # 80000c34 <copyout>
    80001738:	02054563          	bltz	a0,80001762 <wait+0x9c>
          freeproc(np);
    8000173c:	8526                	mv	a0,s1
    8000173e:	00000097          	auipc	ra,0x0
    80001742:	a12080e7          	jalr	-1518(ra) # 80001150 <freeproc>
          release(&np->lock);
    80001746:	8526                	mv	a0,s1
    80001748:	00005097          	auipc	ra,0x5
    8000174c:	cb4080e7          	jalr	-844(ra) # 800063fc <release>
          release(&wait_lock);
    80001750:	00228517          	auipc	a0,0x228
    80001754:	93050513          	addi	a0,a0,-1744 # 80229080 <wait_lock>
    80001758:	00005097          	auipc	ra,0x5
    8000175c:	ca4080e7          	jalr	-860(ra) # 800063fc <release>
          return pid;
    80001760:	a09d                	j	800017c6 <wait+0x100>
            release(&np->lock);
    80001762:	8526                	mv	a0,s1
    80001764:	00005097          	auipc	ra,0x5
    80001768:	c98080e7          	jalr	-872(ra) # 800063fc <release>
            release(&wait_lock);
    8000176c:	00228517          	auipc	a0,0x228
    80001770:	91450513          	addi	a0,a0,-1772 # 80229080 <wait_lock>
    80001774:	00005097          	auipc	ra,0x5
    80001778:	c88080e7          	jalr	-888(ra) # 800063fc <release>
            return -1;
    8000177c:	59fd                	li	s3,-1
    8000177e:	a0a1                	j	800017c6 <wait+0x100>
    for (np = proc; np < &proc[NPROC]; np++)
    80001780:	16848493          	addi	s1,s1,360
    80001784:	03348463          	beq	s1,s3,800017ac <wait+0xe6>
      if (np->parent == p)
    80001788:	7c9c                	ld	a5,56(s1)
    8000178a:	ff279be3          	bne	a5,s2,80001780 <wait+0xba>
        acquire(&np->lock);
    8000178e:	8526                	mv	a0,s1
    80001790:	00005097          	auipc	ra,0x5
    80001794:	bb8080e7          	jalr	-1096(ra) # 80006348 <acquire>
        if (np->state == ZOMBIE)
    80001798:	4c9c                	lw	a5,24(s1)
    8000179a:	f94781e3          	beq	a5,s4,8000171c <wait+0x56>
        release(&np->lock);
    8000179e:	8526                	mv	a0,s1
    800017a0:	00005097          	auipc	ra,0x5
    800017a4:	c5c080e7          	jalr	-932(ra) # 800063fc <release>
        havekids = 1;
    800017a8:	8756                	mv	a4,s5
    800017aa:	bfd9                	j	80001780 <wait+0xba>
    if (!havekids || p->killed)
    800017ac:	c701                	beqz	a4,800017b4 <wait+0xee>
    800017ae:	02892783          	lw	a5,40(s2)
    800017b2:	c79d                	beqz	a5,800017e0 <wait+0x11a>
      release(&wait_lock);
    800017b4:	00228517          	auipc	a0,0x228
    800017b8:	8cc50513          	addi	a0,a0,-1844 # 80229080 <wait_lock>
    800017bc:	00005097          	auipc	ra,0x5
    800017c0:	c40080e7          	jalr	-960(ra) # 800063fc <release>
      return -1;
    800017c4:	59fd                	li	s3,-1
}
    800017c6:	854e                	mv	a0,s3
    800017c8:	60a6                	ld	ra,72(sp)
    800017ca:	6406                	ld	s0,64(sp)
    800017cc:	74e2                	ld	s1,56(sp)
    800017ce:	7942                	ld	s2,48(sp)
    800017d0:	79a2                	ld	s3,40(sp)
    800017d2:	7a02                	ld	s4,32(sp)
    800017d4:	6ae2                	ld	s5,24(sp)
    800017d6:	6b42                	ld	s6,16(sp)
    800017d8:	6ba2                	ld	s7,8(sp)
    800017da:	6c02                	ld	s8,0(sp)
    800017dc:	6161                	addi	sp,sp,80
    800017de:	8082                	ret
    sleep(p, &wait_lock); // DOC: wait-sleep
    800017e0:	85e2                	mv	a1,s8
    800017e2:	854a                	mv	a0,s2
    800017e4:	00000097          	auipc	ra,0x0
    800017e8:	e7e080e7          	jalr	-386(ra) # 80001662 <sleep>
    havekids = 0;
    800017ec:	b715                	j	80001710 <wait+0x4a>

00000000800017ee <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan)
{
    800017ee:	7139                	addi	sp,sp,-64
    800017f0:	fc06                	sd	ra,56(sp)
    800017f2:	f822                	sd	s0,48(sp)
    800017f4:	f426                	sd	s1,40(sp)
    800017f6:	f04a                	sd	s2,32(sp)
    800017f8:	ec4e                	sd	s3,24(sp)
    800017fa:	e852                	sd	s4,16(sp)
    800017fc:	e456                	sd	s5,8(sp)
    800017fe:	0080                	addi	s0,sp,64
    80001800:	8a2a                	mv	s4,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    80001802:	00228497          	auipc	s1,0x228
    80001806:	c9648493          	addi	s1,s1,-874 # 80229498 <proc>
  {
    if (p != myproc())
    {
      acquire(&p->lock);
      if (p->state == SLEEPING && p->chan == chan)
    8000180a:	4989                	li	s3,2
      {
        p->state = RUNNABLE;
    8000180c:	4a8d                	li	s5,3
  for (p = proc; p < &proc[NPROC]; p++)
    8000180e:	0022d917          	auipc	s2,0x22d
    80001812:	68a90913          	addi	s2,s2,1674 # 8022ee98 <tickslock>
    80001816:	a811                	j	8000182a <wakeup+0x3c>
      }
      release(&p->lock);
    80001818:	8526                	mv	a0,s1
    8000181a:	00005097          	auipc	ra,0x5
    8000181e:	be2080e7          	jalr	-1054(ra) # 800063fc <release>
  for (p = proc; p < &proc[NPROC]; p++)
    80001822:	16848493          	addi	s1,s1,360
    80001826:	03248663          	beq	s1,s2,80001852 <wakeup+0x64>
    if (p != myproc())
    8000182a:	fffff097          	auipc	ra,0xfffff
    8000182e:	774080e7          	jalr	1908(ra) # 80000f9e <myproc>
    80001832:	fea488e3          	beq	s1,a0,80001822 <wakeup+0x34>
      acquire(&p->lock);
    80001836:	8526                	mv	a0,s1
    80001838:	00005097          	auipc	ra,0x5
    8000183c:	b10080e7          	jalr	-1264(ra) # 80006348 <acquire>
      if (p->state == SLEEPING && p->chan == chan)
    80001840:	4c9c                	lw	a5,24(s1)
    80001842:	fd379be3          	bne	a5,s3,80001818 <wakeup+0x2a>
    80001846:	709c                	ld	a5,32(s1)
    80001848:	fd4798e3          	bne	a5,s4,80001818 <wakeup+0x2a>
        p->state = RUNNABLE;
    8000184c:	0154ac23          	sw	s5,24(s1)
    80001850:	b7e1                	j	80001818 <wakeup+0x2a>
    }
  }
}
    80001852:	70e2                	ld	ra,56(sp)
    80001854:	7442                	ld	s0,48(sp)
    80001856:	74a2                	ld	s1,40(sp)
    80001858:	7902                	ld	s2,32(sp)
    8000185a:	69e2                	ld	s3,24(sp)
    8000185c:	6a42                	ld	s4,16(sp)
    8000185e:	6aa2                	ld	s5,8(sp)
    80001860:	6121                	addi	sp,sp,64
    80001862:	8082                	ret

0000000080001864 <reparent>:
{
    80001864:	7179                	addi	sp,sp,-48
    80001866:	f406                	sd	ra,40(sp)
    80001868:	f022                	sd	s0,32(sp)
    8000186a:	ec26                	sd	s1,24(sp)
    8000186c:	e84a                	sd	s2,16(sp)
    8000186e:	e44e                	sd	s3,8(sp)
    80001870:	e052                	sd	s4,0(sp)
    80001872:	1800                	addi	s0,sp,48
    80001874:	892a                	mv	s2,a0
  for (pp = proc; pp < &proc[NPROC]; pp++)
    80001876:	00228497          	auipc	s1,0x228
    8000187a:	c2248493          	addi	s1,s1,-990 # 80229498 <proc>
      pp->parent = initproc;
    8000187e:	00007a17          	auipc	s4,0x7
    80001882:	792a0a13          	addi	s4,s4,1938 # 80009010 <initproc>
  for (pp = proc; pp < &proc[NPROC]; pp++)
    80001886:	0022d997          	auipc	s3,0x22d
    8000188a:	61298993          	addi	s3,s3,1554 # 8022ee98 <tickslock>
    8000188e:	a029                	j	80001898 <reparent+0x34>
    80001890:	16848493          	addi	s1,s1,360
    80001894:	01348d63          	beq	s1,s3,800018ae <reparent+0x4a>
    if (pp->parent == p)
    80001898:	7c9c                	ld	a5,56(s1)
    8000189a:	ff279be3          	bne	a5,s2,80001890 <reparent+0x2c>
      pp->parent = initproc;
    8000189e:	000a3503          	ld	a0,0(s4)
    800018a2:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800018a4:	00000097          	auipc	ra,0x0
    800018a8:	f4a080e7          	jalr	-182(ra) # 800017ee <wakeup>
    800018ac:	b7d5                	j	80001890 <reparent+0x2c>
}
    800018ae:	70a2                	ld	ra,40(sp)
    800018b0:	7402                	ld	s0,32(sp)
    800018b2:	64e2                	ld	s1,24(sp)
    800018b4:	6942                	ld	s2,16(sp)
    800018b6:	69a2                	ld	s3,8(sp)
    800018b8:	6a02                	ld	s4,0(sp)
    800018ba:	6145                	addi	sp,sp,48
    800018bc:	8082                	ret

00000000800018be <exit>:
{
    800018be:	7179                	addi	sp,sp,-48
    800018c0:	f406                	sd	ra,40(sp)
    800018c2:	f022                	sd	s0,32(sp)
    800018c4:	ec26                	sd	s1,24(sp)
    800018c6:	e84a                	sd	s2,16(sp)
    800018c8:	e44e                	sd	s3,8(sp)
    800018ca:	e052                	sd	s4,0(sp)
    800018cc:	1800                	addi	s0,sp,48
    800018ce:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800018d0:	fffff097          	auipc	ra,0xfffff
    800018d4:	6ce080e7          	jalr	1742(ra) # 80000f9e <myproc>
    800018d8:	89aa                	mv	s3,a0
  if (p == initproc)
    800018da:	00007797          	auipc	a5,0x7
    800018de:	7367b783          	ld	a5,1846(a5) # 80009010 <initproc>
    800018e2:	0d050493          	addi	s1,a0,208
    800018e6:	15050913          	addi	s2,a0,336
    800018ea:	02a79363          	bne	a5,a0,80001910 <exit+0x52>
    panic("init exiting");
    800018ee:	00007517          	auipc	a0,0x7
    800018f2:	90250513          	addi	a0,a0,-1790 # 800081f0 <etext+0x1f0>
    800018f6:	00004097          	auipc	ra,0x4
    800018fa:	51a080e7          	jalr	1306(ra) # 80005e10 <panic>
      fileclose(f);
    800018fe:	00002097          	auipc	ra,0x2
    80001902:	346080e7          	jalr	838(ra) # 80003c44 <fileclose>
      p->ofile[fd] = 0;
    80001906:	0004b023          	sd	zero,0(s1)
  for (int fd = 0; fd < NOFILE; fd++)
    8000190a:	04a1                	addi	s1,s1,8
    8000190c:	01248563          	beq	s1,s2,80001916 <exit+0x58>
    if (p->ofile[fd])
    80001910:	6088                	ld	a0,0(s1)
    80001912:	f575                	bnez	a0,800018fe <exit+0x40>
    80001914:	bfdd                	j	8000190a <exit+0x4c>
  begin_op();
    80001916:	00002097          	auipc	ra,0x2
    8000191a:	e66080e7          	jalr	-410(ra) # 8000377c <begin_op>
  iput(p->cwd);
    8000191e:	1509b503          	ld	a0,336(s3)
    80001922:	00001097          	auipc	ra,0x1
    80001926:	638080e7          	jalr	1592(ra) # 80002f5a <iput>
  end_op();
    8000192a:	00002097          	auipc	ra,0x2
    8000192e:	ed0080e7          	jalr	-304(ra) # 800037fa <end_op>
  p->cwd = 0;
    80001932:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001936:	00227497          	auipc	s1,0x227
    8000193a:	74a48493          	addi	s1,s1,1866 # 80229080 <wait_lock>
    8000193e:	8526                	mv	a0,s1
    80001940:	00005097          	auipc	ra,0x5
    80001944:	a08080e7          	jalr	-1528(ra) # 80006348 <acquire>
  reparent(p);
    80001948:	854e                	mv	a0,s3
    8000194a:	00000097          	auipc	ra,0x0
    8000194e:	f1a080e7          	jalr	-230(ra) # 80001864 <reparent>
  wakeup(p->parent);
    80001952:	0389b503          	ld	a0,56(s3)
    80001956:	00000097          	auipc	ra,0x0
    8000195a:	e98080e7          	jalr	-360(ra) # 800017ee <wakeup>
  acquire(&p->lock);
    8000195e:	854e                	mv	a0,s3
    80001960:	00005097          	auipc	ra,0x5
    80001964:	9e8080e7          	jalr	-1560(ra) # 80006348 <acquire>
  p->xstate = status;
    80001968:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000196c:	4795                	li	a5,5
    8000196e:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001972:	8526                	mv	a0,s1
    80001974:	00005097          	auipc	ra,0x5
    80001978:	a88080e7          	jalr	-1400(ra) # 800063fc <release>
  sched();
    8000197c:	00000097          	auipc	ra,0x0
    80001980:	bd4080e7          	jalr	-1068(ra) # 80001550 <sched>
  panic("zombie exit");
    80001984:	00007517          	auipc	a0,0x7
    80001988:	87c50513          	addi	a0,a0,-1924 # 80008200 <etext+0x200>
    8000198c:	00004097          	auipc	ra,0x4
    80001990:	484080e7          	jalr	1156(ra) # 80005e10 <panic>

0000000080001994 <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid)
{
    80001994:	7179                	addi	sp,sp,-48
    80001996:	f406                	sd	ra,40(sp)
    80001998:	f022                	sd	s0,32(sp)
    8000199a:	ec26                	sd	s1,24(sp)
    8000199c:	e84a                	sd	s2,16(sp)
    8000199e:	e44e                	sd	s3,8(sp)
    800019a0:	1800                	addi	s0,sp,48
    800019a2:	892a                	mv	s2,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    800019a4:	00228497          	auipc	s1,0x228
    800019a8:	af448493          	addi	s1,s1,-1292 # 80229498 <proc>
    800019ac:	0022d997          	auipc	s3,0x22d
    800019b0:	4ec98993          	addi	s3,s3,1260 # 8022ee98 <tickslock>
  {
    acquire(&p->lock);
    800019b4:	8526                	mv	a0,s1
    800019b6:	00005097          	auipc	ra,0x5
    800019ba:	992080e7          	jalr	-1646(ra) # 80006348 <acquire>
    if (p->pid == pid)
    800019be:	589c                	lw	a5,48(s1)
    800019c0:	01278d63          	beq	a5,s2,800019da <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800019c4:	8526                	mv	a0,s1
    800019c6:	00005097          	auipc	ra,0x5
    800019ca:	a36080e7          	jalr	-1482(ra) # 800063fc <release>
  for (p = proc; p < &proc[NPROC]; p++)
    800019ce:	16848493          	addi	s1,s1,360
    800019d2:	ff3491e3          	bne	s1,s3,800019b4 <kill+0x20>
  }
  return -1;
    800019d6:	557d                	li	a0,-1
    800019d8:	a829                	j	800019f2 <kill+0x5e>
      p->killed = 1;
    800019da:	4785                	li	a5,1
    800019dc:	d49c                	sw	a5,40(s1)
      if (p->state == SLEEPING)
    800019de:	4c98                	lw	a4,24(s1)
    800019e0:	4789                	li	a5,2
    800019e2:	00f70f63          	beq	a4,a5,80001a00 <kill+0x6c>
      release(&p->lock);
    800019e6:	8526                	mv	a0,s1
    800019e8:	00005097          	auipc	ra,0x5
    800019ec:	a14080e7          	jalr	-1516(ra) # 800063fc <release>
      return 0;
    800019f0:	4501                	li	a0,0
}
    800019f2:	70a2                	ld	ra,40(sp)
    800019f4:	7402                	ld	s0,32(sp)
    800019f6:	64e2                	ld	s1,24(sp)
    800019f8:	6942                	ld	s2,16(sp)
    800019fa:	69a2                	ld	s3,8(sp)
    800019fc:	6145                	addi	sp,sp,48
    800019fe:	8082                	ret
        p->state = RUNNABLE;
    80001a00:	478d                	li	a5,3
    80001a02:	cc9c                	sw	a5,24(s1)
    80001a04:	b7cd                	j	800019e6 <kill+0x52>

0000000080001a06 <setkilled>:

void setkilled(struct proc *p)
{
    80001a06:	1101                	addi	sp,sp,-32
    80001a08:	ec06                	sd	ra,24(sp)
    80001a0a:	e822                	sd	s0,16(sp)
    80001a0c:	e426                	sd	s1,8(sp)
    80001a0e:	1000                	addi	s0,sp,32
    80001a10:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001a12:	00005097          	auipc	ra,0x5
    80001a16:	936080e7          	jalr	-1738(ra) # 80006348 <acquire>
  p->killed = 1;
    80001a1a:	4785                	li	a5,1
    80001a1c:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001a1e:	8526                	mv	a0,s1
    80001a20:	00005097          	auipc	ra,0x5
    80001a24:	9dc080e7          	jalr	-1572(ra) # 800063fc <release>
}
    80001a28:	60e2                	ld	ra,24(sp)
    80001a2a:	6442                	ld	s0,16(sp)
    80001a2c:	64a2                	ld	s1,8(sp)
    80001a2e:	6105                	addi	sp,sp,32
    80001a30:	8082                	ret

0000000080001a32 <killed>:

int killed(struct proc *p)
{
    80001a32:	1101                	addi	sp,sp,-32
    80001a34:	ec06                	sd	ra,24(sp)
    80001a36:	e822                	sd	s0,16(sp)
    80001a38:	e426                	sd	s1,8(sp)
    80001a3a:	e04a                	sd	s2,0(sp)
    80001a3c:	1000                	addi	s0,sp,32
    80001a3e:	84aa                	mv	s1,a0
  int k;

  acquire(&p->lock);
    80001a40:	00005097          	auipc	ra,0x5
    80001a44:	908080e7          	jalr	-1784(ra) # 80006348 <acquire>
  k = p->killed;
    80001a48:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001a4c:	8526                	mv	a0,s1
    80001a4e:	00005097          	auipc	ra,0x5
    80001a52:	9ae080e7          	jalr	-1618(ra) # 800063fc <release>
  return k;
}
    80001a56:	854a                	mv	a0,s2
    80001a58:	60e2                	ld	ra,24(sp)
    80001a5a:	6442                	ld	s0,16(sp)
    80001a5c:	64a2                	ld	s1,8(sp)
    80001a5e:	6902                	ld	s2,0(sp)
    80001a60:	6105                	addi	sp,sp,32
    80001a62:	8082                	ret

0000000080001a64 <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001a64:	7179                	addi	sp,sp,-48
    80001a66:	f406                	sd	ra,40(sp)
    80001a68:	f022                	sd	s0,32(sp)
    80001a6a:	ec26                	sd	s1,24(sp)
    80001a6c:	e84a                	sd	s2,16(sp)
    80001a6e:	e44e                	sd	s3,8(sp)
    80001a70:	e052                	sd	s4,0(sp)
    80001a72:	1800                	addi	s0,sp,48
    80001a74:	84aa                	mv	s1,a0
    80001a76:	892e                	mv	s2,a1
    80001a78:	89b2                	mv	s3,a2
    80001a7a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a7c:	fffff097          	auipc	ra,0xfffff
    80001a80:	522080e7          	jalr	1314(ra) # 80000f9e <myproc>
  if (user_dst)
    80001a84:	c08d                	beqz	s1,80001aa6 <either_copyout+0x42>
  {
    return copyout(p->pagetable, dst, src, len);
    80001a86:	86d2                	mv	a3,s4
    80001a88:	864e                	mv	a2,s3
    80001a8a:	85ca                	mv	a1,s2
    80001a8c:	6928                	ld	a0,80(a0)
    80001a8e:	fffff097          	auipc	ra,0xfffff
    80001a92:	1a6080e7          	jalr	422(ra) # 80000c34 <copyout>
  else
  {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001a96:	70a2                	ld	ra,40(sp)
    80001a98:	7402                	ld	s0,32(sp)
    80001a9a:	64e2                	ld	s1,24(sp)
    80001a9c:	6942                	ld	s2,16(sp)
    80001a9e:	69a2                	ld	s3,8(sp)
    80001aa0:	6a02                	ld	s4,0(sp)
    80001aa2:	6145                	addi	sp,sp,48
    80001aa4:	8082                	ret
    memmove((char *)dst, src, len);
    80001aa6:	000a061b          	sext.w	a2,s4
    80001aaa:	85ce                	mv	a1,s3
    80001aac:	854a                	mv	a0,s2
    80001aae:	fffff097          	auipc	ra,0xfffff
    80001ab2:	86c080e7          	jalr	-1940(ra) # 8000031a <memmove>
    return 0;
    80001ab6:	8526                	mv	a0,s1
    80001ab8:	bff9                	j	80001a96 <either_copyout+0x32>

0000000080001aba <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001aba:	7179                	addi	sp,sp,-48
    80001abc:	f406                	sd	ra,40(sp)
    80001abe:	f022                	sd	s0,32(sp)
    80001ac0:	ec26                	sd	s1,24(sp)
    80001ac2:	e84a                	sd	s2,16(sp)
    80001ac4:	e44e                	sd	s3,8(sp)
    80001ac6:	e052                	sd	s4,0(sp)
    80001ac8:	1800                	addi	s0,sp,48
    80001aca:	892a                	mv	s2,a0
    80001acc:	84ae                	mv	s1,a1
    80001ace:	89b2                	mv	s3,a2
    80001ad0:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001ad2:	fffff097          	auipc	ra,0xfffff
    80001ad6:	4cc080e7          	jalr	1228(ra) # 80000f9e <myproc>
  if (user_src)
    80001ada:	c08d                	beqz	s1,80001afc <either_copyin+0x42>
  {
    return copyin(p->pagetable, dst, src, len);
    80001adc:	86d2                	mv	a3,s4
    80001ade:	864e                	mv	a2,s3
    80001ae0:	85ca                	mv	a1,s2
    80001ae2:	6928                	ld	a0,80(a0)
    80001ae4:	fffff097          	auipc	ra,0xfffff
    80001ae8:	20a080e7          	jalr	522(ra) # 80000cee <copyin>
  else
  {
    memmove(dst, (char *)src, len);
    return 0;
  }
}
    80001aec:	70a2                	ld	ra,40(sp)
    80001aee:	7402                	ld	s0,32(sp)
    80001af0:	64e2                	ld	s1,24(sp)
    80001af2:	6942                	ld	s2,16(sp)
    80001af4:	69a2                	ld	s3,8(sp)
    80001af6:	6a02                	ld	s4,0(sp)
    80001af8:	6145                	addi	sp,sp,48
    80001afa:	8082                	ret
    memmove(dst, (char *)src, len);
    80001afc:	000a061b          	sext.w	a2,s4
    80001b00:	85ce                	mv	a1,s3
    80001b02:	854a                	mv	a0,s2
    80001b04:	fffff097          	auipc	ra,0xfffff
    80001b08:	816080e7          	jalr	-2026(ra) # 8000031a <memmove>
    return 0;
    80001b0c:	8526                	mv	a0,s1
    80001b0e:	bff9                	j	80001aec <either_copyin+0x32>

0000000080001b10 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
    80001b10:	715d                	addi	sp,sp,-80
    80001b12:	e486                	sd	ra,72(sp)
    80001b14:	e0a2                	sd	s0,64(sp)
    80001b16:	fc26                	sd	s1,56(sp)
    80001b18:	f84a                	sd	s2,48(sp)
    80001b1a:	f44e                	sd	s3,40(sp)
    80001b1c:	f052                	sd	s4,32(sp)
    80001b1e:	ec56                	sd	s5,24(sp)
    80001b20:	e85a                	sd	s6,16(sp)
    80001b22:	e45e                	sd	s7,8(sp)
    80001b24:	0880                	addi	s0,sp,80
      [RUNNING] "run   ",
      [ZOMBIE] "zombie"};
  struct proc *p;
  char *state;

  printf("\n");
    80001b26:	00006517          	auipc	a0,0x6
    80001b2a:	53250513          	addi	a0,a0,1330 # 80008058 <etext+0x58>
    80001b2e:	00004097          	auipc	ra,0x4
    80001b32:	32c080e7          	jalr	812(ra) # 80005e5a <printf>
  for (p = proc; p < &proc[NPROC]; p++)
    80001b36:	00228497          	auipc	s1,0x228
    80001b3a:	aba48493          	addi	s1,s1,-1350 # 802295f0 <proc+0x158>
    80001b3e:	0022d917          	auipc	s2,0x22d
    80001b42:	4b290913          	addi	s2,s2,1202 # 8022eff0 <bcache+0x140>
  {
    if (p->state == UNUSED)
      continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b46:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001b48:	00006997          	auipc	s3,0x6
    80001b4c:	6c898993          	addi	s3,s3,1736 # 80008210 <etext+0x210>
    printf("%d %s %s", p->pid, state, p->name);
    80001b50:	00006a97          	auipc	s5,0x6
    80001b54:	6c8a8a93          	addi	s5,s5,1736 # 80008218 <etext+0x218>
    printf("\n");
    80001b58:	00006a17          	auipc	s4,0x6
    80001b5c:	500a0a13          	addi	s4,s4,1280 # 80008058 <etext+0x58>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b60:	00006b97          	auipc	s7,0x6
    80001b64:	6f0b8b93          	addi	s7,s7,1776 # 80008250 <states.0>
    80001b68:	a00d                	j	80001b8a <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001b6a:	ed86a583          	lw	a1,-296(a3)
    80001b6e:	8556                	mv	a0,s5
    80001b70:	00004097          	auipc	ra,0x4
    80001b74:	2ea080e7          	jalr	746(ra) # 80005e5a <printf>
    printf("\n");
    80001b78:	8552                	mv	a0,s4
    80001b7a:	00004097          	auipc	ra,0x4
    80001b7e:	2e0080e7          	jalr	736(ra) # 80005e5a <printf>
  for (p = proc; p < &proc[NPROC]; p++)
    80001b82:	16848493          	addi	s1,s1,360
    80001b86:	03248263          	beq	s1,s2,80001baa <procdump+0x9a>
    if (p->state == UNUSED)
    80001b8a:	86a6                	mv	a3,s1
    80001b8c:	ec04a783          	lw	a5,-320(s1)
    80001b90:	dbed                	beqz	a5,80001b82 <procdump+0x72>
      state = "???";
    80001b92:	864e                	mv	a2,s3
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b94:	fcfb6be3          	bltu	s6,a5,80001b6a <procdump+0x5a>
    80001b98:	02079713          	slli	a4,a5,0x20
    80001b9c:	01d75793          	srli	a5,a4,0x1d
    80001ba0:	97de                	add	a5,a5,s7
    80001ba2:	6390                	ld	a2,0(a5)
    80001ba4:	f279                	bnez	a2,80001b6a <procdump+0x5a>
      state = "???";
    80001ba6:	864e                	mv	a2,s3
    80001ba8:	b7c9                	j	80001b6a <procdump+0x5a>
  }
}
    80001baa:	60a6                	ld	ra,72(sp)
    80001bac:	6406                	ld	s0,64(sp)
    80001bae:	74e2                	ld	s1,56(sp)
    80001bb0:	7942                	ld	s2,48(sp)
    80001bb2:	79a2                	ld	s3,40(sp)
    80001bb4:	7a02                	ld	s4,32(sp)
    80001bb6:	6ae2                	ld	s5,24(sp)
    80001bb8:	6b42                	ld	s6,16(sp)
    80001bba:	6ba2                	ld	s7,8(sp)
    80001bbc:	6161                	addi	sp,sp,80
    80001bbe:	8082                	ret

0000000080001bc0 <swtch>:
    80001bc0:	00153023          	sd	ra,0(a0)
    80001bc4:	00253423          	sd	sp,8(a0)
    80001bc8:	e900                	sd	s0,16(a0)
    80001bca:	ed04                	sd	s1,24(a0)
    80001bcc:	03253023          	sd	s2,32(a0)
    80001bd0:	03353423          	sd	s3,40(a0)
    80001bd4:	03453823          	sd	s4,48(a0)
    80001bd8:	03553c23          	sd	s5,56(a0)
    80001bdc:	05653023          	sd	s6,64(a0)
    80001be0:	05753423          	sd	s7,72(a0)
    80001be4:	05853823          	sd	s8,80(a0)
    80001be8:	05953c23          	sd	s9,88(a0)
    80001bec:	07a53023          	sd	s10,96(a0)
    80001bf0:	07b53423          	sd	s11,104(a0)
    80001bf4:	0005b083          	ld	ra,0(a1)
    80001bf8:	0085b103          	ld	sp,8(a1)
    80001bfc:	6980                	ld	s0,16(a1)
    80001bfe:	6d84                	ld	s1,24(a1)
    80001c00:	0205b903          	ld	s2,32(a1)
    80001c04:	0285b983          	ld	s3,40(a1)
    80001c08:	0305ba03          	ld	s4,48(a1)
    80001c0c:	0385ba83          	ld	s5,56(a1)
    80001c10:	0405bb03          	ld	s6,64(a1)
    80001c14:	0485bb83          	ld	s7,72(a1)
    80001c18:	0505bc03          	ld	s8,80(a1)
    80001c1c:	0585bc83          	ld	s9,88(a1)
    80001c20:	0605bd03          	ld	s10,96(a1)
    80001c24:	0685bd83          	ld	s11,104(a1)
    80001c28:	8082                	ret

0000000080001c2a <isCOWPG>:

extern int devintr();

int isCOWPG(pagetable_t pg, uint64 va)
{
  if (va > MAXVA)
    80001c2a:	4785                	li	a5,1
    80001c2c:	179a                	slli	a5,a5,0x26
    80001c2e:	00b7f463          	bgeu	a5,a1,80001c36 <isCOWPG+0xc>
    return -1;
    80001c32:	557d                	li	a0,-1
  if ((*pte & PTE_V) == 0)
    return 0;
  if ((*pte & PTE_COW))
    return 1;
  return 0;
}
    80001c34:	8082                	ret
{
    80001c36:	1141                	addi	sp,sp,-16
    80001c38:	e406                	sd	ra,8(sp)
    80001c3a:	e022                	sd	s0,0(sp)
    80001c3c:	0800                	addi	s0,sp,16
  pte_t *pte = walk(pg, va, 0);
    80001c3e:	4601                	li	a2,0
    80001c40:	fffff097          	auipc	ra,0xfffff
    80001c44:	95e080e7          	jalr	-1698(ra) # 8000059e <walk>
  if (pte == 0)
    80001c48:	cd01                	beqz	a0,80001c60 <isCOWPG+0x36>
  if ((*pte & PTE_COW))
    80001c4a:	6108                	ld	a0,0(a0)
    80001c4c:	10157513          	andi	a0,a0,257
    80001c50:	eff50513          	addi	a0,a0,-257
    return -1;
    80001c54:	00153513          	seqz	a0,a0
}
    80001c58:	60a2                	ld	ra,8(sp)
    80001c5a:	6402                	ld	s0,0(sp)
    80001c5c:	0141                	addi	sp,sp,16
    80001c5e:	8082                	ret
    return 0;
    80001c60:	4501                	li	a0,0
    80001c62:	bfdd                	j	80001c58 <isCOWPG+0x2e>

0000000080001c64 <allocCOWPG>:

void *allocCOWPG(pagetable_t pg, uint64 va)
{
    80001c64:	7139                	addi	sp,sp,-64
    80001c66:	fc06                	sd	ra,56(sp)
    80001c68:	f822                	sd	s0,48(sp)
    80001c6a:	f426                	sd	s1,40(sp)
    80001c6c:	f04a                	sd	s2,32(sp)
    80001c6e:	ec4e                	sd	s3,24(sp)
    80001c70:	e852                	sd	s4,16(sp)
    80001c72:	e456                	sd	s5,8(sp)
    80001c74:	0080                	addi	s0,sp,64
  va = PGROUNDDOWN(va);
    80001c76:	77fd                	lui	a5,0xfffff
    80001c78:	00f5f4b3          	and	s1,a1,a5
  if (va % PGSIZE != 0 || va > MAXVA)
    80001c7c:	4785                	li	a5,1
    80001c7e:	179a                	slli	a5,a5,0x26
    return 0;
    80001c80:	4901                	li	s2,0
  if (va % PGSIZE != 0 || va > MAXVA)
    80001c82:	0897e163          	bltu	a5,s1,80001d04 <allocCOWPG+0xa0>
    80001c86:	8aaa                	mv	s5,a0

  uint64 pa = walkaddr(pg, va);
    80001c88:	85a6                	mv	a1,s1
    80001c8a:	fffff097          	auipc	ra,0xfffff
    80001c8e:	9ba080e7          	jalr	-1606(ra) # 80000644 <walkaddr>
    80001c92:	89aa                	mv	s3,a0
  if (pa == 0)
    return 0;
    80001c94:	4901                	li	s2,0
  if (pa == 0)
    80001c96:	c53d                	beqz	a0,80001d04 <allocCOWPG+0xa0>

  pte_t *pte = walk(pg, va, 0);
    80001c98:	4601                	li	a2,0
    80001c9a:	85a6                	mv	a1,s1
    80001c9c:	8556                	mv	a0,s5
    80001c9e:	fffff097          	auipc	ra,0xfffff
    80001ca2:	900080e7          	jalr	-1792(ra) # 8000059e <walk>
    80001ca6:	8a2a                	mv	s4,a0
  if (pte == 0)
    80001ca8:	cd59                	beqz	a0,80001d46 <allocCOWPG+0xe2>
    return 0;

  int count = GetPGRefCount((void *)pa);
    80001caa:	854e                	mv	a0,s3
    80001cac:	ffffe097          	auipc	ra,0xffffe
    80001cb0:	5f4080e7          	jalr	1524(ra) # 800002a0 <GetPGRefCount>
  if (count == 1)
    80001cb4:	4785                	li	a5,1
    80001cb6:	06f50163          	beq	a0,a5,80001d18 <allocCOWPG+0xb4>
    return (void *)pa;
  }
  else
  {
    // 有多个进程在使用当前页，需要分配新的物理页
    char *mem = kalloc();
    80001cba:	ffffe097          	auipc	ra,0xffffe
    80001cbe:	4ec080e7          	jalr	1260(ra) # 800001a6 <kalloc>
    80001cc2:	892a                	mv	s2,a0
    if (mem == 0)
    80001cc4:	c121                	beqz	a0,80001d04 <allocCOWPG+0xa0>
      return 0;

    memmove(mem, (char *)pa, PGSIZE);
    80001cc6:	6605                	lui	a2,0x1
    80001cc8:	85ce                	mv	a1,s3
    80001cca:	ffffe097          	auipc	ra,0xffffe
    80001cce:	650080e7          	jalr	1616(ra) # 8000031a <memmove>

    // 清除有效位PTE_V，否则在mappagges中会出错
    *pte = (*pte) & ~PTE_V;
    80001cd2:	000a3703          	ld	a4,0(s4)
    80001cd6:	9b79                	andi	a4,a4,-2
    80001cd8:	00ea3023          	sd	a4,0(s4)

    if (mappages(pg, va, PGSIZE, (uint64)mem, (PTE_FLAGS(*pte) & ~PTE_COW) | PTE_W) != 0)
    80001cdc:	2fb77713          	andi	a4,a4,763
    80001ce0:	00476713          	ori	a4,a4,4
    80001ce4:	86ca                	mv	a3,s2
    80001ce6:	6605                	lui	a2,0x1
    80001ce8:	85a6                	mv	a1,s1
    80001cea:	8556                	mv	a0,s5
    80001cec:	fffff097          	auipc	ra,0xfffff
    80001cf0:	99a080e7          	jalr	-1638(ra) # 80000686 <mappages>
    80001cf4:	ed05                	bnez	a0,80001d2c <allocCOWPG+0xc8>
      kfree(mem);
      *pte = (*pte) | PTE_V;
      return 0;
    }

    kfree((void *)PGROUNDDOWN(pa));
    80001cf6:	757d                	lui	a0,0xfffff
    80001cf8:	00a9f533          	and	a0,s3,a0
    80001cfc:	ffffe097          	auipc	ra,0xffffe
    80001d00:	320080e7          	jalr	800(ra) # 8000001c <kfree>

    return (void *)mem;
  }
}
    80001d04:	854a                	mv	a0,s2
    80001d06:	70e2                	ld	ra,56(sp)
    80001d08:	7442                	ld	s0,48(sp)
    80001d0a:	74a2                	ld	s1,40(sp)
    80001d0c:	7902                	ld	s2,32(sp)
    80001d0e:	69e2                	ld	s3,24(sp)
    80001d10:	6a42                	ld	s4,16(sp)
    80001d12:	6aa2                	ld	s5,8(sp)
    80001d14:	6121                	addi	sp,sp,64
    80001d16:	8082                	ret
    *pte = (*pte & ~PTE_COW) | PTE_W;
    80001d18:	000a3783          	ld	a5,0(s4)
    80001d1c:	efb7f793          	andi	a5,a5,-261
    80001d20:	0047e793          	ori	a5,a5,4
    80001d24:	00fa3023          	sd	a5,0(s4)
    return (void *)pa;
    80001d28:	894e                	mv	s2,s3
    80001d2a:	bfe9                	j	80001d04 <allocCOWPG+0xa0>
      kfree(mem);
    80001d2c:	854a                	mv	a0,s2
    80001d2e:	ffffe097          	auipc	ra,0xffffe
    80001d32:	2ee080e7          	jalr	750(ra) # 8000001c <kfree>
      *pte = (*pte) | PTE_V;
    80001d36:	000a3783          	ld	a5,0(s4)
    80001d3a:	0017e793          	ori	a5,a5,1
    80001d3e:	00fa3023          	sd	a5,0(s4)
      return 0;
    80001d42:	4901                	li	s2,0
    80001d44:	b7c1                	j	80001d04 <allocCOWPG+0xa0>
    return 0;
    80001d46:	892a                	mv	s2,a0
    80001d48:	bf75                	j	80001d04 <allocCOWPG+0xa0>

0000000080001d4a <trapinit>:

void trapinit(void)
{
    80001d4a:	1141                	addi	sp,sp,-16
    80001d4c:	e406                	sd	ra,8(sp)
    80001d4e:	e022                	sd	s0,0(sp)
    80001d50:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001d52:	00006597          	auipc	a1,0x6
    80001d56:	52e58593          	addi	a1,a1,1326 # 80008280 <states.0+0x30>
    80001d5a:	0022d517          	auipc	a0,0x22d
    80001d5e:	13e50513          	addi	a0,a0,318 # 8022ee98 <tickslock>
    80001d62:	00004097          	auipc	ra,0x4
    80001d66:	556080e7          	jalr	1366(ra) # 800062b8 <initlock>
}
    80001d6a:	60a2                	ld	ra,8(sp)
    80001d6c:	6402                	ld	s0,0(sp)
    80001d6e:	0141                	addi	sp,sp,16
    80001d70:	8082                	ret

0000000080001d72 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void)
{
    80001d72:	1141                	addi	sp,sp,-16
    80001d74:	e422                	sd	s0,8(sp)
    80001d76:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d78:	00003797          	auipc	a5,0x3
    80001d7c:	4f878793          	addi	a5,a5,1272 # 80005270 <kernelvec>
    80001d80:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001d84:	6422                	ld	s0,8(sp)
    80001d86:	0141                	addi	sp,sp,16
    80001d88:	8082                	ret

0000000080001d8a <usertrapret>:

//
// return to user space
//
void usertrapret(void)
{
    80001d8a:	1141                	addi	sp,sp,-16
    80001d8c:	e406                	sd	ra,8(sp)
    80001d8e:	e022                	sd	s0,0(sp)
    80001d90:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001d92:	fffff097          	auipc	ra,0xfffff
    80001d96:	20c080e7          	jalr	524(ra) # 80000f9e <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d9a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001d9e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001da0:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001da4:	00005697          	auipc	a3,0x5
    80001da8:	25c68693          	addi	a3,a3,604 # 80007000 <_trampoline>
    80001dac:	00005717          	auipc	a4,0x5
    80001db0:	25470713          	addi	a4,a4,596 # 80007000 <_trampoline>
    80001db4:	8f15                	sub	a4,a4,a3
    80001db6:	040007b7          	lui	a5,0x4000
    80001dba:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001dbc:	07b2                	slli	a5,a5,0xc
    80001dbe:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001dc0:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001dc4:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001dc6:	18002673          	csrr	a2,satp
    80001dca:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001dcc:	6d30                	ld	a2,88(a0)
    80001dce:	6138                	ld	a4,64(a0)
    80001dd0:	6585                	lui	a1,0x1
    80001dd2:	972e                	add	a4,a4,a1
    80001dd4:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001dd6:	6d38                	ld	a4,88(a0)
    80001dd8:	00000617          	auipc	a2,0x0
    80001ddc:	13860613          	addi	a2,a2,312 # 80001f10 <usertrap>
    80001de0:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80001de2:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001de4:	8612                	mv	a2,tp
    80001de6:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001de8:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001dec:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001df0:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001df4:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001df8:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001dfa:	6f18                	ld	a4,24(a4)
    80001dfc:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001e00:	692c                	ld	a1,80(a0)
    80001e02:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001e04:	00005717          	auipc	a4,0x5
    80001e08:	28c70713          	addi	a4,a4,652 # 80007090 <userret>
    80001e0c:	8f15                	sub	a4,a4,a3
    80001e0e:	97ba                	add	a5,a5,a4
  ((void (*)(uint64, uint64))fn)(TRAPFRAME, satp);
    80001e10:	577d                	li	a4,-1
    80001e12:	177e                	slli	a4,a4,0x3f
    80001e14:	8dd9                	or	a1,a1,a4
    80001e16:	02000537          	lui	a0,0x2000
    80001e1a:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001e1c:	0536                	slli	a0,a0,0xd
    80001e1e:	9782                	jalr	a5
}
    80001e20:	60a2                	ld	ra,8(sp)
    80001e22:	6402                	ld	s0,0(sp)
    80001e24:	0141                	addi	sp,sp,16
    80001e26:	8082                	ret

0000000080001e28 <clockintr>:
  w_sepc(sepc);
  w_sstatus(sstatus);
}

void clockintr()
{
    80001e28:	1101                	addi	sp,sp,-32
    80001e2a:	ec06                	sd	ra,24(sp)
    80001e2c:	e822                	sd	s0,16(sp)
    80001e2e:	e426                	sd	s1,8(sp)
    80001e30:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001e32:	0022d497          	auipc	s1,0x22d
    80001e36:	06648493          	addi	s1,s1,102 # 8022ee98 <tickslock>
    80001e3a:	8526                	mv	a0,s1
    80001e3c:	00004097          	auipc	ra,0x4
    80001e40:	50c080e7          	jalr	1292(ra) # 80006348 <acquire>
  ticks++;
    80001e44:	00007517          	auipc	a0,0x7
    80001e48:	1d450513          	addi	a0,a0,468 # 80009018 <ticks>
    80001e4c:	411c                	lw	a5,0(a0)
    80001e4e:	2785                	addiw	a5,a5,1
    80001e50:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001e52:	00000097          	auipc	ra,0x0
    80001e56:	99c080e7          	jalr	-1636(ra) # 800017ee <wakeup>
  release(&tickslock);
    80001e5a:	8526                	mv	a0,s1
    80001e5c:	00004097          	auipc	ra,0x4
    80001e60:	5a0080e7          	jalr	1440(ra) # 800063fc <release>
}
    80001e64:	60e2                	ld	ra,24(sp)
    80001e66:	6442                	ld	s0,16(sp)
    80001e68:	64a2                	ld	s1,8(sp)
    80001e6a:	6105                	addi	sp,sp,32
    80001e6c:	8082                	ret

0000000080001e6e <devintr>:
// and handle it.
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int devintr()
{
    80001e6e:	1101                	addi	sp,sp,-32
    80001e70:	ec06                	sd	ra,24(sp)
    80001e72:	e822                	sd	s0,16(sp)
    80001e74:	e426                	sd	s1,8(sp)
    80001e76:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e78:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if ((scause & 0x8000000000000000L) &&
    80001e7c:	00074d63          	bltz	a4,80001e96 <devintr+0x28>
    if (irq)
      plic_complete(irq);

    return 1;
  }
  else if (scause == 0x8000000000000001L)
    80001e80:	57fd                	li	a5,-1
    80001e82:	17fe                	slli	a5,a5,0x3f
    80001e84:	0785                	addi	a5,a5,1

    return 2;
  }
  else
  {
    return 0;
    80001e86:	4501                	li	a0,0
  else if (scause == 0x8000000000000001L)
    80001e88:	06f70363          	beq	a4,a5,80001eee <devintr+0x80>
  }
}
    80001e8c:	60e2                	ld	ra,24(sp)
    80001e8e:	6442                	ld	s0,16(sp)
    80001e90:	64a2                	ld	s1,8(sp)
    80001e92:	6105                	addi	sp,sp,32
    80001e94:	8082                	ret
      (scause & 0xff) == 9)
    80001e96:	0ff77793          	zext.b	a5,a4
  if ((scause & 0x8000000000000000L) &&
    80001e9a:	46a5                	li	a3,9
    80001e9c:	fed792e3          	bne	a5,a3,80001e80 <devintr+0x12>
    int irq = plic_claim();
    80001ea0:	00003097          	auipc	ra,0x3
    80001ea4:	4d8080e7          	jalr	1240(ra) # 80005378 <plic_claim>
    80001ea8:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ)
    80001eaa:	47a9                	li	a5,10
    80001eac:	02f50763          	beq	a0,a5,80001eda <devintr+0x6c>
    else if (irq == VIRTIO0_IRQ)
    80001eb0:	4785                	li	a5,1
    80001eb2:	02f50963          	beq	a0,a5,80001ee4 <devintr+0x76>
    return 1;
    80001eb6:	4505                	li	a0,1
    else if (irq)
    80001eb8:	d8f1                	beqz	s1,80001e8c <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001eba:	85a6                	mv	a1,s1
    80001ebc:	00006517          	auipc	a0,0x6
    80001ec0:	3cc50513          	addi	a0,a0,972 # 80008288 <states.0+0x38>
    80001ec4:	00004097          	auipc	ra,0x4
    80001ec8:	f96080e7          	jalr	-106(ra) # 80005e5a <printf>
      plic_complete(irq);
    80001ecc:	8526                	mv	a0,s1
    80001ece:	00003097          	auipc	ra,0x3
    80001ed2:	4ce080e7          	jalr	1230(ra) # 8000539c <plic_complete>
    return 1;
    80001ed6:	4505                	li	a0,1
    80001ed8:	bf55                	j	80001e8c <devintr+0x1e>
      uartintr();
    80001eda:	00004097          	auipc	ra,0x4
    80001ede:	38e080e7          	jalr	910(ra) # 80006268 <uartintr>
    80001ee2:	b7ed                	j	80001ecc <devintr+0x5e>
      virtio_disk_intr();
    80001ee4:	00004097          	auipc	ra,0x4
    80001ee8:	944080e7          	jalr	-1724(ra) # 80005828 <virtio_disk_intr>
    80001eec:	b7c5                	j	80001ecc <devintr+0x5e>
    if (cpuid() == 0)
    80001eee:	fffff097          	auipc	ra,0xfffff
    80001ef2:	084080e7          	jalr	132(ra) # 80000f72 <cpuid>
    80001ef6:	c901                	beqz	a0,80001f06 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001ef8:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001efc:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001efe:	14479073          	csrw	sip,a5
    return 2;
    80001f02:	4509                	li	a0,2
    80001f04:	b761                	j	80001e8c <devintr+0x1e>
      clockintr();
    80001f06:	00000097          	auipc	ra,0x0
    80001f0a:	f22080e7          	jalr	-222(ra) # 80001e28 <clockintr>
    80001f0e:	b7ed                	j	80001ef8 <devintr+0x8a>

0000000080001f10 <usertrap>:
{
    80001f10:	1101                	addi	sp,sp,-32
    80001f12:	ec06                	sd	ra,24(sp)
    80001f14:	e822                	sd	s0,16(sp)
    80001f16:	e426                	sd	s1,8(sp)
    80001f18:	e04a                	sd	s2,0(sp)
    80001f1a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f1c:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0)
    80001f20:	1007f793          	andi	a5,a5,256
    80001f24:	e7b5                	bnez	a5,80001f90 <usertrap+0x80>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001f26:	00003797          	auipc	a5,0x3
    80001f2a:	34a78793          	addi	a5,a5,842 # 80005270 <kernelvec>
    80001f2e:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001f32:	fffff097          	auipc	ra,0xfffff
    80001f36:	06c080e7          	jalr	108(ra) # 80000f9e <myproc>
    80001f3a:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001f3c:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f3e:	14102773          	csrr	a4,sepc
    80001f42:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f44:	14202773          	csrr	a4,scause
  if (r_scause() == 8)
    80001f48:	47a1                	li	a5,8
    80001f4a:	04f70b63          	beq	a4,a5,80001fa0 <usertrap+0x90>
    80001f4e:	14202773          	csrr	a4,scause
  else if (r_scause() == 13 || r_scause() == 15)
    80001f52:	47b5                	li	a5,13
    80001f54:	00f70763          	beq	a4,a5,80001f62 <usertrap+0x52>
    80001f58:	14202773          	csrr	a4,scause
    80001f5c:	47bd                	li	a5,15
    80001f5e:	08f71963          	bne	a4,a5,80001ff0 <usertrap+0xe0>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f62:	14302973          	csrr	s2,stval
    if (va >= p->sz || isCOWPG(p->pagetable, va) != 1 || allocCOWPG(p->pagetable, va) == 0)
    80001f66:	64bc                	ld	a5,72(s1)
    80001f68:	06f96363          	bltu	s2,a5,80001fce <usertrap+0xbe>
      p->killed = 1;
    80001f6c:	4785                	li	a5,1
    80001f6e:	d49c                	sw	a5,40(s1)
  if (killed(p))
    80001f70:	8526                	mv	a0,s1
    80001f72:	00000097          	auipc	ra,0x0
    80001f76:	ac0080e7          	jalr	-1344(ra) # 80001a32 <killed>
    80001f7a:	e569                	bnez	a0,80002044 <usertrap+0x134>
  usertrapret();
    80001f7c:	00000097          	auipc	ra,0x0
    80001f80:	e0e080e7          	jalr	-498(ra) # 80001d8a <usertrapret>
}
    80001f84:	60e2                	ld	ra,24(sp)
    80001f86:	6442                	ld	s0,16(sp)
    80001f88:	64a2                	ld	s1,8(sp)
    80001f8a:	6902                	ld	s2,0(sp)
    80001f8c:	6105                	addi	sp,sp,32
    80001f8e:	8082                	ret
    panic("usertrap: not from user mode");
    80001f90:	00006517          	auipc	a0,0x6
    80001f94:	31850513          	addi	a0,a0,792 # 800082a8 <states.0+0x58>
    80001f98:	00004097          	auipc	ra,0x4
    80001f9c:	e78080e7          	jalr	-392(ra) # 80005e10 <panic>
    if (p->killed)
    80001fa0:	551c                	lw	a5,40(a0)
    80001fa2:	e385                	bnez	a5,80001fc2 <usertrap+0xb2>
    p->trapframe->epc += 4;
    80001fa4:	6cb8                	ld	a4,88(s1)
    80001fa6:	6f1c                	ld	a5,24(a4)
    80001fa8:	0791                	addi	a5,a5,4
    80001faa:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001fac:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001fb0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001fb4:	10079073          	csrw	sstatus,a5
    syscall();
    80001fb8:	00000097          	auipc	ra,0x0
    80001fbc:	2ea080e7          	jalr	746(ra) # 800022a2 <syscall>
    80001fc0:	bf45                	j	80001f70 <usertrap+0x60>
      exit(-1);
    80001fc2:	557d                	li	a0,-1
    80001fc4:	00000097          	auipc	ra,0x0
    80001fc8:	8fa080e7          	jalr	-1798(ra) # 800018be <exit>
    80001fcc:	bfe1                	j	80001fa4 <usertrap+0x94>
    if (va >= p->sz || isCOWPG(p->pagetable, va) != 1 || allocCOWPG(p->pagetable, va) == 0)
    80001fce:	85ca                	mv	a1,s2
    80001fd0:	68a8                	ld	a0,80(s1)
    80001fd2:	00000097          	auipc	ra,0x0
    80001fd6:	c58080e7          	jalr	-936(ra) # 80001c2a <isCOWPG>
    80001fda:	4785                	li	a5,1
    80001fdc:	f8f518e3          	bne	a0,a5,80001f6c <usertrap+0x5c>
    80001fe0:	85ca                	mv	a1,s2
    80001fe2:	68a8                	ld	a0,80(s1)
    80001fe4:	00000097          	auipc	ra,0x0
    80001fe8:	c80080e7          	jalr	-896(ra) # 80001c64 <allocCOWPG>
    80001fec:	f151                	bnez	a0,80001f70 <usertrap+0x60>
    80001fee:	bfbd                	j	80001f6c <usertrap+0x5c>
  else if ((which_dev = devintr()) != 0)
    80001ff0:	00000097          	auipc	ra,0x0
    80001ff4:	e7e080e7          	jalr	-386(ra) # 80001e6e <devintr>
    80001ff8:	892a                	mv	s2,a0
    80001ffa:	c901                	beqz	a0,8000200a <usertrap+0xfa>
  if (killed(p))
    80001ffc:	8526                	mv	a0,s1
    80001ffe:	00000097          	auipc	ra,0x0
    80002002:	a34080e7          	jalr	-1484(ra) # 80001a32 <killed>
    80002006:	c529                	beqz	a0,80002050 <usertrap+0x140>
    80002008:	a83d                	j	80002046 <usertrap+0x136>
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000200a:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    8000200e:	5890                	lw	a2,48(s1)
    80002010:	00006517          	auipc	a0,0x6
    80002014:	2b850513          	addi	a0,a0,696 # 800082c8 <states.0+0x78>
    80002018:	00004097          	auipc	ra,0x4
    8000201c:	e42080e7          	jalr	-446(ra) # 80005e5a <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002020:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002024:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002028:	00006517          	auipc	a0,0x6
    8000202c:	2d050513          	addi	a0,a0,720 # 800082f8 <states.0+0xa8>
    80002030:	00004097          	auipc	ra,0x4
    80002034:	e2a080e7          	jalr	-470(ra) # 80005e5a <printf>
    setkilled(p);
    80002038:	8526                	mv	a0,s1
    8000203a:	00000097          	auipc	ra,0x0
    8000203e:	9cc080e7          	jalr	-1588(ra) # 80001a06 <setkilled>
    80002042:	b73d                	j	80001f70 <usertrap+0x60>
  if (killed(p))
    80002044:	4901                	li	s2,0
    exit(-1);
    80002046:	557d                	li	a0,-1
    80002048:	00000097          	auipc	ra,0x0
    8000204c:	876080e7          	jalr	-1930(ra) # 800018be <exit>
  if (which_dev == 2)
    80002050:	4789                	li	a5,2
    80002052:	f2f915e3          	bne	s2,a5,80001f7c <usertrap+0x6c>
    yield();
    80002056:	fffff097          	auipc	ra,0xfffff
    8000205a:	5d0080e7          	jalr	1488(ra) # 80001626 <yield>
    8000205e:	bf39                	j	80001f7c <usertrap+0x6c>

0000000080002060 <kerneltrap>:
{
    80002060:	7179                	addi	sp,sp,-48
    80002062:	f406                	sd	ra,40(sp)
    80002064:	f022                	sd	s0,32(sp)
    80002066:	ec26                	sd	s1,24(sp)
    80002068:	e84a                	sd	s2,16(sp)
    8000206a:	e44e                	sd	s3,8(sp)
    8000206c:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000206e:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002072:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002076:	142029f3          	csrr	s3,scause
  if ((sstatus & SSTATUS_SPP) == 0)
    8000207a:	1004f793          	andi	a5,s1,256
    8000207e:	cb85                	beqz	a5,800020ae <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002080:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002084:	8b89                	andi	a5,a5,2
  if (intr_get() != 0)
    80002086:	ef85                	bnez	a5,800020be <kerneltrap+0x5e>
  if ((which_dev = devintr()) == 0)
    80002088:	00000097          	auipc	ra,0x0
    8000208c:	de6080e7          	jalr	-538(ra) # 80001e6e <devintr>
    80002090:	cd1d                	beqz	a0,800020ce <kerneltrap+0x6e>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002092:	4789                	li	a5,2
    80002094:	06f50a63          	beq	a0,a5,80002108 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002098:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000209c:	10049073          	csrw	sstatus,s1
}
    800020a0:	70a2                	ld	ra,40(sp)
    800020a2:	7402                	ld	s0,32(sp)
    800020a4:	64e2                	ld	s1,24(sp)
    800020a6:	6942                	ld	s2,16(sp)
    800020a8:	69a2                	ld	s3,8(sp)
    800020aa:	6145                	addi	sp,sp,48
    800020ac:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    800020ae:	00006517          	auipc	a0,0x6
    800020b2:	26a50513          	addi	a0,a0,618 # 80008318 <states.0+0xc8>
    800020b6:	00004097          	auipc	ra,0x4
    800020ba:	d5a080e7          	jalr	-678(ra) # 80005e10 <panic>
    panic("kerneltrap: interrupts enabled");
    800020be:	00006517          	auipc	a0,0x6
    800020c2:	28250513          	addi	a0,a0,642 # 80008340 <states.0+0xf0>
    800020c6:	00004097          	auipc	ra,0x4
    800020ca:	d4a080e7          	jalr	-694(ra) # 80005e10 <panic>
    printf("scause %p\n", scause);
    800020ce:	85ce                	mv	a1,s3
    800020d0:	00006517          	auipc	a0,0x6
    800020d4:	29050513          	addi	a0,a0,656 # 80008360 <states.0+0x110>
    800020d8:	00004097          	auipc	ra,0x4
    800020dc:	d82080e7          	jalr	-638(ra) # 80005e5a <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800020e0:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800020e4:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    800020e8:	00006517          	auipc	a0,0x6
    800020ec:	28850513          	addi	a0,a0,648 # 80008370 <states.0+0x120>
    800020f0:	00004097          	auipc	ra,0x4
    800020f4:	d6a080e7          	jalr	-662(ra) # 80005e5a <printf>
    panic("kerneltrap");
    800020f8:	00006517          	auipc	a0,0x6
    800020fc:	29050513          	addi	a0,a0,656 # 80008388 <states.0+0x138>
    80002100:	00004097          	auipc	ra,0x4
    80002104:	d10080e7          	jalr	-752(ra) # 80005e10 <panic>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002108:	fffff097          	auipc	ra,0xfffff
    8000210c:	e96080e7          	jalr	-362(ra) # 80000f9e <myproc>
    80002110:	d541                	beqz	a0,80002098 <kerneltrap+0x38>
    80002112:	fffff097          	auipc	ra,0xfffff
    80002116:	e8c080e7          	jalr	-372(ra) # 80000f9e <myproc>
    8000211a:	4d18                	lw	a4,24(a0)
    8000211c:	4791                	li	a5,4
    8000211e:	f6f71de3          	bne	a4,a5,80002098 <kerneltrap+0x38>
    yield();
    80002122:	fffff097          	auipc	ra,0xfffff
    80002126:	504080e7          	jalr	1284(ra) # 80001626 <yield>
    8000212a:	b7bd                	j	80002098 <kerneltrap+0x38>

000000008000212c <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    8000212c:	1101                	addi	sp,sp,-32
    8000212e:	ec06                	sd	ra,24(sp)
    80002130:	e822                	sd	s0,16(sp)
    80002132:	e426                	sd	s1,8(sp)
    80002134:	1000                	addi	s0,sp,32
    80002136:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002138:	fffff097          	auipc	ra,0xfffff
    8000213c:	e66080e7          	jalr	-410(ra) # 80000f9e <myproc>
  switch (n) {
    80002140:	4795                	li	a5,5
    80002142:	0497e163          	bltu	a5,s1,80002184 <argraw+0x58>
    80002146:	048a                	slli	s1,s1,0x2
    80002148:	00006717          	auipc	a4,0x6
    8000214c:	27870713          	addi	a4,a4,632 # 800083c0 <states.0+0x170>
    80002150:	94ba                	add	s1,s1,a4
    80002152:	409c                	lw	a5,0(s1)
    80002154:	97ba                	add	a5,a5,a4
    80002156:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002158:	6d3c                	ld	a5,88(a0)
    8000215a:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    8000215c:	60e2                	ld	ra,24(sp)
    8000215e:	6442                	ld	s0,16(sp)
    80002160:	64a2                	ld	s1,8(sp)
    80002162:	6105                	addi	sp,sp,32
    80002164:	8082                	ret
    return p->trapframe->a1;
    80002166:	6d3c                	ld	a5,88(a0)
    80002168:	7fa8                	ld	a0,120(a5)
    8000216a:	bfcd                	j	8000215c <argraw+0x30>
    return p->trapframe->a2;
    8000216c:	6d3c                	ld	a5,88(a0)
    8000216e:	63c8                	ld	a0,128(a5)
    80002170:	b7f5                	j	8000215c <argraw+0x30>
    return p->trapframe->a3;
    80002172:	6d3c                	ld	a5,88(a0)
    80002174:	67c8                	ld	a0,136(a5)
    80002176:	b7dd                	j	8000215c <argraw+0x30>
    return p->trapframe->a4;
    80002178:	6d3c                	ld	a5,88(a0)
    8000217a:	6bc8                	ld	a0,144(a5)
    8000217c:	b7c5                	j	8000215c <argraw+0x30>
    return p->trapframe->a5;
    8000217e:	6d3c                	ld	a5,88(a0)
    80002180:	6fc8                	ld	a0,152(a5)
    80002182:	bfe9                	j	8000215c <argraw+0x30>
  panic("argraw");
    80002184:	00006517          	auipc	a0,0x6
    80002188:	21450513          	addi	a0,a0,532 # 80008398 <states.0+0x148>
    8000218c:	00004097          	auipc	ra,0x4
    80002190:	c84080e7          	jalr	-892(ra) # 80005e10 <panic>

0000000080002194 <fetchaddr>:
{
    80002194:	1101                	addi	sp,sp,-32
    80002196:	ec06                	sd	ra,24(sp)
    80002198:	e822                	sd	s0,16(sp)
    8000219a:	e426                	sd	s1,8(sp)
    8000219c:	e04a                	sd	s2,0(sp)
    8000219e:	1000                	addi	s0,sp,32
    800021a0:	84aa                	mv	s1,a0
    800021a2:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800021a4:	fffff097          	auipc	ra,0xfffff
    800021a8:	dfa080e7          	jalr	-518(ra) # 80000f9e <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    800021ac:	653c                	ld	a5,72(a0)
    800021ae:	02f4f863          	bgeu	s1,a5,800021de <fetchaddr+0x4a>
    800021b2:	00848713          	addi	a4,s1,8
    800021b6:	02e7e663          	bltu	a5,a4,800021e2 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800021ba:	46a1                	li	a3,8
    800021bc:	8626                	mv	a2,s1
    800021be:	85ca                	mv	a1,s2
    800021c0:	6928                	ld	a0,80(a0)
    800021c2:	fffff097          	auipc	ra,0xfffff
    800021c6:	b2c080e7          	jalr	-1236(ra) # 80000cee <copyin>
    800021ca:	00a03533          	snez	a0,a0
    800021ce:	40a00533          	neg	a0,a0
}
    800021d2:	60e2                	ld	ra,24(sp)
    800021d4:	6442                	ld	s0,16(sp)
    800021d6:	64a2                	ld	s1,8(sp)
    800021d8:	6902                	ld	s2,0(sp)
    800021da:	6105                	addi	sp,sp,32
    800021dc:	8082                	ret
    return -1;
    800021de:	557d                	li	a0,-1
    800021e0:	bfcd                	j	800021d2 <fetchaddr+0x3e>
    800021e2:	557d                	li	a0,-1
    800021e4:	b7fd                	j	800021d2 <fetchaddr+0x3e>

00000000800021e6 <fetchstr>:
{
    800021e6:	7179                	addi	sp,sp,-48
    800021e8:	f406                	sd	ra,40(sp)
    800021ea:	f022                	sd	s0,32(sp)
    800021ec:	ec26                	sd	s1,24(sp)
    800021ee:	e84a                	sd	s2,16(sp)
    800021f0:	e44e                	sd	s3,8(sp)
    800021f2:	1800                	addi	s0,sp,48
    800021f4:	892a                	mv	s2,a0
    800021f6:	84ae                	mv	s1,a1
    800021f8:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800021fa:	fffff097          	auipc	ra,0xfffff
    800021fe:	da4080e7          	jalr	-604(ra) # 80000f9e <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002202:	86ce                	mv	a3,s3
    80002204:	864a                	mv	a2,s2
    80002206:	85a6                	mv	a1,s1
    80002208:	6928                	ld	a0,80(a0)
    8000220a:	fffff097          	auipc	ra,0xfffff
    8000220e:	b72080e7          	jalr	-1166(ra) # 80000d7c <copyinstr>
  if(err < 0)
    80002212:	00054763          	bltz	a0,80002220 <fetchstr+0x3a>
  return strlen(buf);
    80002216:	8526                	mv	a0,s1
    80002218:	ffffe097          	auipc	ra,0xffffe
    8000221c:	222080e7          	jalr	546(ra) # 8000043a <strlen>
}
    80002220:	70a2                	ld	ra,40(sp)
    80002222:	7402                	ld	s0,32(sp)
    80002224:	64e2                	ld	s1,24(sp)
    80002226:	6942                	ld	s2,16(sp)
    80002228:	69a2                	ld	s3,8(sp)
    8000222a:	6145                	addi	sp,sp,48
    8000222c:	8082                	ret

000000008000222e <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    8000222e:	1101                	addi	sp,sp,-32
    80002230:	ec06                	sd	ra,24(sp)
    80002232:	e822                	sd	s0,16(sp)
    80002234:	e426                	sd	s1,8(sp)
    80002236:	1000                	addi	s0,sp,32
    80002238:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000223a:	00000097          	auipc	ra,0x0
    8000223e:	ef2080e7          	jalr	-270(ra) # 8000212c <argraw>
    80002242:	c088                	sw	a0,0(s1)
  return 0;
}
    80002244:	4501                	li	a0,0
    80002246:	60e2                	ld	ra,24(sp)
    80002248:	6442                	ld	s0,16(sp)
    8000224a:	64a2                	ld	s1,8(sp)
    8000224c:	6105                	addi	sp,sp,32
    8000224e:	8082                	ret

0000000080002250 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002250:	1101                	addi	sp,sp,-32
    80002252:	ec06                	sd	ra,24(sp)
    80002254:	e822                	sd	s0,16(sp)
    80002256:	e426                	sd	s1,8(sp)
    80002258:	1000                	addi	s0,sp,32
    8000225a:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000225c:	00000097          	auipc	ra,0x0
    80002260:	ed0080e7          	jalr	-304(ra) # 8000212c <argraw>
    80002264:	e088                	sd	a0,0(s1)
  return 0;
}
    80002266:	4501                	li	a0,0
    80002268:	60e2                	ld	ra,24(sp)
    8000226a:	6442                	ld	s0,16(sp)
    8000226c:	64a2                	ld	s1,8(sp)
    8000226e:	6105                	addi	sp,sp,32
    80002270:	8082                	ret

0000000080002272 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002272:	1101                	addi	sp,sp,-32
    80002274:	ec06                	sd	ra,24(sp)
    80002276:	e822                	sd	s0,16(sp)
    80002278:	e426                	sd	s1,8(sp)
    8000227a:	e04a                	sd	s2,0(sp)
    8000227c:	1000                	addi	s0,sp,32
    8000227e:	84ae                	mv	s1,a1
    80002280:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002282:	00000097          	auipc	ra,0x0
    80002286:	eaa080e7          	jalr	-342(ra) # 8000212c <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    8000228a:	864a                	mv	a2,s2
    8000228c:	85a6                	mv	a1,s1
    8000228e:	00000097          	auipc	ra,0x0
    80002292:	f58080e7          	jalr	-168(ra) # 800021e6 <fetchstr>
}
    80002296:	60e2                	ld	ra,24(sp)
    80002298:	6442                	ld	s0,16(sp)
    8000229a:	64a2                	ld	s1,8(sp)
    8000229c:	6902                	ld	s2,0(sp)
    8000229e:	6105                	addi	sp,sp,32
    800022a0:	8082                	ret

00000000800022a2 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    800022a2:	1101                	addi	sp,sp,-32
    800022a4:	ec06                	sd	ra,24(sp)
    800022a6:	e822                	sd	s0,16(sp)
    800022a8:	e426                	sd	s1,8(sp)
    800022aa:	e04a                	sd	s2,0(sp)
    800022ac:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800022ae:	fffff097          	auipc	ra,0xfffff
    800022b2:	cf0080e7          	jalr	-784(ra) # 80000f9e <myproc>
    800022b6:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800022b8:	05853903          	ld	s2,88(a0)
    800022bc:	0a893783          	ld	a5,168(s2)
    800022c0:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800022c4:	37fd                	addiw	a5,a5,-1
    800022c6:	4751                	li	a4,20
    800022c8:	00f76f63          	bltu	a4,a5,800022e6 <syscall+0x44>
    800022cc:	00369713          	slli	a4,a3,0x3
    800022d0:	00006797          	auipc	a5,0x6
    800022d4:	10878793          	addi	a5,a5,264 # 800083d8 <syscalls>
    800022d8:	97ba                	add	a5,a5,a4
    800022da:	639c                	ld	a5,0(a5)
    800022dc:	c789                	beqz	a5,800022e6 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    800022de:	9782                	jalr	a5
    800022e0:	06a93823          	sd	a0,112(s2)
    800022e4:	a839                	j	80002302 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800022e6:	15848613          	addi	a2,s1,344
    800022ea:	588c                	lw	a1,48(s1)
    800022ec:	00006517          	auipc	a0,0x6
    800022f0:	0b450513          	addi	a0,a0,180 # 800083a0 <states.0+0x150>
    800022f4:	00004097          	auipc	ra,0x4
    800022f8:	b66080e7          	jalr	-1178(ra) # 80005e5a <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800022fc:	6cbc                	ld	a5,88(s1)
    800022fe:	577d                	li	a4,-1
    80002300:	fbb8                	sd	a4,112(a5)
  }
}
    80002302:	60e2                	ld	ra,24(sp)
    80002304:	6442                	ld	s0,16(sp)
    80002306:	64a2                	ld	s1,8(sp)
    80002308:	6902                	ld	s2,0(sp)
    8000230a:	6105                	addi	sp,sp,32
    8000230c:	8082                	ret

000000008000230e <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000230e:	1101                	addi	sp,sp,-32
    80002310:	ec06                	sd	ra,24(sp)
    80002312:	e822                	sd	s0,16(sp)
    80002314:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002316:	fec40593          	addi	a1,s0,-20
    8000231a:	4501                	li	a0,0
    8000231c:	00000097          	auipc	ra,0x0
    80002320:	f12080e7          	jalr	-238(ra) # 8000222e <argint>
    return -1;
    80002324:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002326:	00054963          	bltz	a0,80002338 <sys_exit+0x2a>
  exit(n);
    8000232a:	fec42503          	lw	a0,-20(s0)
    8000232e:	fffff097          	auipc	ra,0xfffff
    80002332:	590080e7          	jalr	1424(ra) # 800018be <exit>
  return 0;  // not reached
    80002336:	4781                	li	a5,0
}
    80002338:	853e                	mv	a0,a5
    8000233a:	60e2                	ld	ra,24(sp)
    8000233c:	6442                	ld	s0,16(sp)
    8000233e:	6105                	addi	sp,sp,32
    80002340:	8082                	ret

0000000080002342 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002342:	1141                	addi	sp,sp,-16
    80002344:	e406                	sd	ra,8(sp)
    80002346:	e022                	sd	s0,0(sp)
    80002348:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000234a:	fffff097          	auipc	ra,0xfffff
    8000234e:	c54080e7          	jalr	-940(ra) # 80000f9e <myproc>
}
    80002352:	5908                	lw	a0,48(a0)
    80002354:	60a2                	ld	ra,8(sp)
    80002356:	6402                	ld	s0,0(sp)
    80002358:	0141                	addi	sp,sp,16
    8000235a:	8082                	ret

000000008000235c <sys_fork>:

uint64
sys_fork(void)
{
    8000235c:	1141                	addi	sp,sp,-16
    8000235e:	e406                	sd	ra,8(sp)
    80002360:	e022                	sd	s0,0(sp)
    80002362:	0800                	addi	s0,sp,16
  return fork();
    80002364:	fffff097          	auipc	ra,0xfffff
    80002368:	00c080e7          	jalr	12(ra) # 80001370 <fork>
}
    8000236c:	60a2                	ld	ra,8(sp)
    8000236e:	6402                	ld	s0,0(sp)
    80002370:	0141                	addi	sp,sp,16
    80002372:	8082                	ret

0000000080002374 <sys_wait>:

uint64
sys_wait(void)
{
    80002374:	1101                	addi	sp,sp,-32
    80002376:	ec06                	sd	ra,24(sp)
    80002378:	e822                	sd	s0,16(sp)
    8000237a:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    8000237c:	fe840593          	addi	a1,s0,-24
    80002380:	4501                	li	a0,0
    80002382:	00000097          	auipc	ra,0x0
    80002386:	ece080e7          	jalr	-306(ra) # 80002250 <argaddr>
    8000238a:	87aa                	mv	a5,a0
    return -1;
    8000238c:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    8000238e:	0007c863          	bltz	a5,8000239e <sys_wait+0x2a>
  return wait(p);
    80002392:	fe843503          	ld	a0,-24(s0)
    80002396:	fffff097          	auipc	ra,0xfffff
    8000239a:	330080e7          	jalr	816(ra) # 800016c6 <wait>
}
    8000239e:	60e2                	ld	ra,24(sp)
    800023a0:	6442                	ld	s0,16(sp)
    800023a2:	6105                	addi	sp,sp,32
    800023a4:	8082                	ret

00000000800023a6 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800023a6:	7179                	addi	sp,sp,-48
    800023a8:	f406                	sd	ra,40(sp)
    800023aa:	f022                	sd	s0,32(sp)
    800023ac:	ec26                	sd	s1,24(sp)
    800023ae:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    800023b0:	fdc40593          	addi	a1,s0,-36
    800023b4:	4501                	li	a0,0
    800023b6:	00000097          	auipc	ra,0x0
    800023ba:	e78080e7          	jalr	-392(ra) # 8000222e <argint>
    800023be:	87aa                	mv	a5,a0
    return -1;
    800023c0:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    800023c2:	0207c063          	bltz	a5,800023e2 <sys_sbrk+0x3c>
  addr = myproc()->sz;
    800023c6:	fffff097          	auipc	ra,0xfffff
    800023ca:	bd8080e7          	jalr	-1064(ra) # 80000f9e <myproc>
    800023ce:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    800023d0:	fdc42503          	lw	a0,-36(s0)
    800023d4:	fffff097          	auipc	ra,0xfffff
    800023d8:	f24080e7          	jalr	-220(ra) # 800012f8 <growproc>
    800023dc:	00054863          	bltz	a0,800023ec <sys_sbrk+0x46>
    return -1;
  return addr;
    800023e0:	8526                	mv	a0,s1
}
    800023e2:	70a2                	ld	ra,40(sp)
    800023e4:	7402                	ld	s0,32(sp)
    800023e6:	64e2                	ld	s1,24(sp)
    800023e8:	6145                	addi	sp,sp,48
    800023ea:	8082                	ret
    return -1;
    800023ec:	557d                	li	a0,-1
    800023ee:	bfd5                	j	800023e2 <sys_sbrk+0x3c>

00000000800023f0 <sys_sleep>:

uint64
sys_sleep(void)
{
    800023f0:	7139                	addi	sp,sp,-64
    800023f2:	fc06                	sd	ra,56(sp)
    800023f4:	f822                	sd	s0,48(sp)
    800023f6:	f426                	sd	s1,40(sp)
    800023f8:	f04a                	sd	s2,32(sp)
    800023fa:	ec4e                	sd	s3,24(sp)
    800023fc:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    800023fe:	fcc40593          	addi	a1,s0,-52
    80002402:	4501                	li	a0,0
    80002404:	00000097          	auipc	ra,0x0
    80002408:	e2a080e7          	jalr	-470(ra) # 8000222e <argint>
    return -1;
    8000240c:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    8000240e:	06054563          	bltz	a0,80002478 <sys_sleep+0x88>
  acquire(&tickslock);
    80002412:	0022d517          	auipc	a0,0x22d
    80002416:	a8650513          	addi	a0,a0,-1402 # 8022ee98 <tickslock>
    8000241a:	00004097          	auipc	ra,0x4
    8000241e:	f2e080e7          	jalr	-210(ra) # 80006348 <acquire>
  ticks0 = ticks;
    80002422:	00007917          	auipc	s2,0x7
    80002426:	bf692903          	lw	s2,-1034(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    8000242a:	fcc42783          	lw	a5,-52(s0)
    8000242e:	cf85                	beqz	a5,80002466 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002430:	0022d997          	auipc	s3,0x22d
    80002434:	a6898993          	addi	s3,s3,-1432 # 8022ee98 <tickslock>
    80002438:	00007497          	auipc	s1,0x7
    8000243c:	be048493          	addi	s1,s1,-1056 # 80009018 <ticks>
    if(myproc()->killed){
    80002440:	fffff097          	auipc	ra,0xfffff
    80002444:	b5e080e7          	jalr	-1186(ra) # 80000f9e <myproc>
    80002448:	551c                	lw	a5,40(a0)
    8000244a:	ef9d                	bnez	a5,80002488 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    8000244c:	85ce                	mv	a1,s3
    8000244e:	8526                	mv	a0,s1
    80002450:	fffff097          	auipc	ra,0xfffff
    80002454:	212080e7          	jalr	530(ra) # 80001662 <sleep>
  while(ticks - ticks0 < n){
    80002458:	409c                	lw	a5,0(s1)
    8000245a:	412787bb          	subw	a5,a5,s2
    8000245e:	fcc42703          	lw	a4,-52(s0)
    80002462:	fce7efe3          	bltu	a5,a4,80002440 <sys_sleep+0x50>
  }
  release(&tickslock);
    80002466:	0022d517          	auipc	a0,0x22d
    8000246a:	a3250513          	addi	a0,a0,-1486 # 8022ee98 <tickslock>
    8000246e:	00004097          	auipc	ra,0x4
    80002472:	f8e080e7          	jalr	-114(ra) # 800063fc <release>
  return 0;
    80002476:	4781                	li	a5,0
}
    80002478:	853e                	mv	a0,a5
    8000247a:	70e2                	ld	ra,56(sp)
    8000247c:	7442                	ld	s0,48(sp)
    8000247e:	74a2                	ld	s1,40(sp)
    80002480:	7902                	ld	s2,32(sp)
    80002482:	69e2                	ld	s3,24(sp)
    80002484:	6121                	addi	sp,sp,64
    80002486:	8082                	ret
      release(&tickslock);
    80002488:	0022d517          	auipc	a0,0x22d
    8000248c:	a1050513          	addi	a0,a0,-1520 # 8022ee98 <tickslock>
    80002490:	00004097          	auipc	ra,0x4
    80002494:	f6c080e7          	jalr	-148(ra) # 800063fc <release>
      return -1;
    80002498:	57fd                	li	a5,-1
    8000249a:	bff9                	j	80002478 <sys_sleep+0x88>

000000008000249c <sys_kill>:

uint64
sys_kill(void)
{
    8000249c:	1101                	addi	sp,sp,-32
    8000249e:	ec06                	sd	ra,24(sp)
    800024a0:	e822                	sd	s0,16(sp)
    800024a2:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    800024a4:	fec40593          	addi	a1,s0,-20
    800024a8:	4501                	li	a0,0
    800024aa:	00000097          	auipc	ra,0x0
    800024ae:	d84080e7          	jalr	-636(ra) # 8000222e <argint>
    800024b2:	87aa                	mv	a5,a0
    return -1;
    800024b4:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    800024b6:	0007c863          	bltz	a5,800024c6 <sys_kill+0x2a>
  return kill(pid);
    800024ba:	fec42503          	lw	a0,-20(s0)
    800024be:	fffff097          	auipc	ra,0xfffff
    800024c2:	4d6080e7          	jalr	1238(ra) # 80001994 <kill>
}
    800024c6:	60e2                	ld	ra,24(sp)
    800024c8:	6442                	ld	s0,16(sp)
    800024ca:	6105                	addi	sp,sp,32
    800024cc:	8082                	ret

00000000800024ce <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800024ce:	1101                	addi	sp,sp,-32
    800024d0:	ec06                	sd	ra,24(sp)
    800024d2:	e822                	sd	s0,16(sp)
    800024d4:	e426                	sd	s1,8(sp)
    800024d6:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800024d8:	0022d517          	auipc	a0,0x22d
    800024dc:	9c050513          	addi	a0,a0,-1600 # 8022ee98 <tickslock>
    800024e0:	00004097          	auipc	ra,0x4
    800024e4:	e68080e7          	jalr	-408(ra) # 80006348 <acquire>
  xticks = ticks;
    800024e8:	00007497          	auipc	s1,0x7
    800024ec:	b304a483          	lw	s1,-1232(s1) # 80009018 <ticks>
  release(&tickslock);
    800024f0:	0022d517          	auipc	a0,0x22d
    800024f4:	9a850513          	addi	a0,a0,-1624 # 8022ee98 <tickslock>
    800024f8:	00004097          	auipc	ra,0x4
    800024fc:	f04080e7          	jalr	-252(ra) # 800063fc <release>
  return xticks;
}
    80002500:	02049513          	slli	a0,s1,0x20
    80002504:	9101                	srli	a0,a0,0x20
    80002506:	60e2                	ld	ra,24(sp)
    80002508:	6442                	ld	s0,16(sp)
    8000250a:	64a2                	ld	s1,8(sp)
    8000250c:	6105                	addi	sp,sp,32
    8000250e:	8082                	ret

0000000080002510 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002510:	7179                	addi	sp,sp,-48
    80002512:	f406                	sd	ra,40(sp)
    80002514:	f022                	sd	s0,32(sp)
    80002516:	ec26                	sd	s1,24(sp)
    80002518:	e84a                	sd	s2,16(sp)
    8000251a:	e44e                	sd	s3,8(sp)
    8000251c:	e052                	sd	s4,0(sp)
    8000251e:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002520:	00006597          	auipc	a1,0x6
    80002524:	f6858593          	addi	a1,a1,-152 # 80008488 <syscalls+0xb0>
    80002528:	0022d517          	auipc	a0,0x22d
    8000252c:	98850513          	addi	a0,a0,-1656 # 8022eeb0 <bcache>
    80002530:	00004097          	auipc	ra,0x4
    80002534:	d88080e7          	jalr	-632(ra) # 800062b8 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002538:	00235797          	auipc	a5,0x235
    8000253c:	97878793          	addi	a5,a5,-1672 # 80236eb0 <bcache+0x8000>
    80002540:	00235717          	auipc	a4,0x235
    80002544:	bd870713          	addi	a4,a4,-1064 # 80237118 <bcache+0x8268>
    80002548:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000254c:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002550:	0022d497          	auipc	s1,0x22d
    80002554:	97848493          	addi	s1,s1,-1672 # 8022eec8 <bcache+0x18>
    b->next = bcache.head.next;
    80002558:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000255a:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000255c:	00006a17          	auipc	s4,0x6
    80002560:	f34a0a13          	addi	s4,s4,-204 # 80008490 <syscalls+0xb8>
    b->next = bcache.head.next;
    80002564:	2b893783          	ld	a5,696(s2)
    80002568:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000256a:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000256e:	85d2                	mv	a1,s4
    80002570:	01048513          	addi	a0,s1,16
    80002574:	00001097          	auipc	ra,0x1
    80002578:	4c2080e7          	jalr	1218(ra) # 80003a36 <initsleeplock>
    bcache.head.next->prev = b;
    8000257c:	2b893783          	ld	a5,696(s2)
    80002580:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002582:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002586:	45848493          	addi	s1,s1,1112
    8000258a:	fd349de3          	bne	s1,s3,80002564 <binit+0x54>
  }
}
    8000258e:	70a2                	ld	ra,40(sp)
    80002590:	7402                	ld	s0,32(sp)
    80002592:	64e2                	ld	s1,24(sp)
    80002594:	6942                	ld	s2,16(sp)
    80002596:	69a2                	ld	s3,8(sp)
    80002598:	6a02                	ld	s4,0(sp)
    8000259a:	6145                	addi	sp,sp,48
    8000259c:	8082                	ret

000000008000259e <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000259e:	7179                	addi	sp,sp,-48
    800025a0:	f406                	sd	ra,40(sp)
    800025a2:	f022                	sd	s0,32(sp)
    800025a4:	ec26                	sd	s1,24(sp)
    800025a6:	e84a                	sd	s2,16(sp)
    800025a8:	e44e                	sd	s3,8(sp)
    800025aa:	1800                	addi	s0,sp,48
    800025ac:	892a                	mv	s2,a0
    800025ae:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800025b0:	0022d517          	auipc	a0,0x22d
    800025b4:	90050513          	addi	a0,a0,-1792 # 8022eeb0 <bcache>
    800025b8:	00004097          	auipc	ra,0x4
    800025bc:	d90080e7          	jalr	-624(ra) # 80006348 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800025c0:	00235497          	auipc	s1,0x235
    800025c4:	ba84b483          	ld	s1,-1112(s1) # 80237168 <bcache+0x82b8>
    800025c8:	00235797          	auipc	a5,0x235
    800025cc:	b5078793          	addi	a5,a5,-1200 # 80237118 <bcache+0x8268>
    800025d0:	02f48f63          	beq	s1,a5,8000260e <bread+0x70>
    800025d4:	873e                	mv	a4,a5
    800025d6:	a021                	j	800025de <bread+0x40>
    800025d8:	68a4                	ld	s1,80(s1)
    800025da:	02e48a63          	beq	s1,a4,8000260e <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800025de:	449c                	lw	a5,8(s1)
    800025e0:	ff279ce3          	bne	a5,s2,800025d8 <bread+0x3a>
    800025e4:	44dc                	lw	a5,12(s1)
    800025e6:	ff3799e3          	bne	a5,s3,800025d8 <bread+0x3a>
      b->refcnt++;
    800025ea:	40bc                	lw	a5,64(s1)
    800025ec:	2785                	addiw	a5,a5,1
    800025ee:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800025f0:	0022d517          	auipc	a0,0x22d
    800025f4:	8c050513          	addi	a0,a0,-1856 # 8022eeb0 <bcache>
    800025f8:	00004097          	auipc	ra,0x4
    800025fc:	e04080e7          	jalr	-508(ra) # 800063fc <release>
      acquiresleep(&b->lock);
    80002600:	01048513          	addi	a0,s1,16
    80002604:	00001097          	auipc	ra,0x1
    80002608:	46c080e7          	jalr	1132(ra) # 80003a70 <acquiresleep>
      return b;
    8000260c:	a8b9                	j	8000266a <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000260e:	00235497          	auipc	s1,0x235
    80002612:	b524b483          	ld	s1,-1198(s1) # 80237160 <bcache+0x82b0>
    80002616:	00235797          	auipc	a5,0x235
    8000261a:	b0278793          	addi	a5,a5,-1278 # 80237118 <bcache+0x8268>
    8000261e:	00f48863          	beq	s1,a5,8000262e <bread+0x90>
    80002622:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002624:	40bc                	lw	a5,64(s1)
    80002626:	cf81                	beqz	a5,8000263e <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002628:	64a4                	ld	s1,72(s1)
    8000262a:	fee49de3          	bne	s1,a4,80002624 <bread+0x86>
  panic("bget: no buffers");
    8000262e:	00006517          	auipc	a0,0x6
    80002632:	e6a50513          	addi	a0,a0,-406 # 80008498 <syscalls+0xc0>
    80002636:	00003097          	auipc	ra,0x3
    8000263a:	7da080e7          	jalr	2010(ra) # 80005e10 <panic>
      b->dev = dev;
    8000263e:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002642:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002646:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000264a:	4785                	li	a5,1
    8000264c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000264e:	0022d517          	auipc	a0,0x22d
    80002652:	86250513          	addi	a0,a0,-1950 # 8022eeb0 <bcache>
    80002656:	00004097          	auipc	ra,0x4
    8000265a:	da6080e7          	jalr	-602(ra) # 800063fc <release>
      acquiresleep(&b->lock);
    8000265e:	01048513          	addi	a0,s1,16
    80002662:	00001097          	auipc	ra,0x1
    80002666:	40e080e7          	jalr	1038(ra) # 80003a70 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000266a:	409c                	lw	a5,0(s1)
    8000266c:	cb89                	beqz	a5,8000267e <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000266e:	8526                	mv	a0,s1
    80002670:	70a2                	ld	ra,40(sp)
    80002672:	7402                	ld	s0,32(sp)
    80002674:	64e2                	ld	s1,24(sp)
    80002676:	6942                	ld	s2,16(sp)
    80002678:	69a2                	ld	s3,8(sp)
    8000267a:	6145                	addi	sp,sp,48
    8000267c:	8082                	ret
    virtio_disk_rw(b, 0);
    8000267e:	4581                	li	a1,0
    80002680:	8526                	mv	a0,s1
    80002682:	00003097          	auipc	ra,0x3
    80002686:	f20080e7          	jalr	-224(ra) # 800055a2 <virtio_disk_rw>
    b->valid = 1;
    8000268a:	4785                	li	a5,1
    8000268c:	c09c                	sw	a5,0(s1)
  return b;
    8000268e:	b7c5                	j	8000266e <bread+0xd0>

0000000080002690 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002690:	1101                	addi	sp,sp,-32
    80002692:	ec06                	sd	ra,24(sp)
    80002694:	e822                	sd	s0,16(sp)
    80002696:	e426                	sd	s1,8(sp)
    80002698:	1000                	addi	s0,sp,32
    8000269a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000269c:	0541                	addi	a0,a0,16
    8000269e:	00001097          	auipc	ra,0x1
    800026a2:	46c080e7          	jalr	1132(ra) # 80003b0a <holdingsleep>
    800026a6:	cd01                	beqz	a0,800026be <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800026a8:	4585                	li	a1,1
    800026aa:	8526                	mv	a0,s1
    800026ac:	00003097          	auipc	ra,0x3
    800026b0:	ef6080e7          	jalr	-266(ra) # 800055a2 <virtio_disk_rw>
}
    800026b4:	60e2                	ld	ra,24(sp)
    800026b6:	6442                	ld	s0,16(sp)
    800026b8:	64a2                	ld	s1,8(sp)
    800026ba:	6105                	addi	sp,sp,32
    800026bc:	8082                	ret
    panic("bwrite");
    800026be:	00006517          	auipc	a0,0x6
    800026c2:	df250513          	addi	a0,a0,-526 # 800084b0 <syscalls+0xd8>
    800026c6:	00003097          	auipc	ra,0x3
    800026ca:	74a080e7          	jalr	1866(ra) # 80005e10 <panic>

00000000800026ce <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800026ce:	1101                	addi	sp,sp,-32
    800026d0:	ec06                	sd	ra,24(sp)
    800026d2:	e822                	sd	s0,16(sp)
    800026d4:	e426                	sd	s1,8(sp)
    800026d6:	e04a                	sd	s2,0(sp)
    800026d8:	1000                	addi	s0,sp,32
    800026da:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800026dc:	01050913          	addi	s2,a0,16
    800026e0:	854a                	mv	a0,s2
    800026e2:	00001097          	auipc	ra,0x1
    800026e6:	428080e7          	jalr	1064(ra) # 80003b0a <holdingsleep>
    800026ea:	c92d                	beqz	a0,8000275c <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800026ec:	854a                	mv	a0,s2
    800026ee:	00001097          	auipc	ra,0x1
    800026f2:	3d8080e7          	jalr	984(ra) # 80003ac6 <releasesleep>

  acquire(&bcache.lock);
    800026f6:	0022c517          	auipc	a0,0x22c
    800026fa:	7ba50513          	addi	a0,a0,1978 # 8022eeb0 <bcache>
    800026fe:	00004097          	auipc	ra,0x4
    80002702:	c4a080e7          	jalr	-950(ra) # 80006348 <acquire>
  b->refcnt--;
    80002706:	40bc                	lw	a5,64(s1)
    80002708:	37fd                	addiw	a5,a5,-1
    8000270a:	0007871b          	sext.w	a4,a5
    8000270e:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002710:	eb05                	bnez	a4,80002740 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002712:	68bc                	ld	a5,80(s1)
    80002714:	64b8                	ld	a4,72(s1)
    80002716:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002718:	64bc                	ld	a5,72(s1)
    8000271a:	68b8                	ld	a4,80(s1)
    8000271c:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000271e:	00234797          	auipc	a5,0x234
    80002722:	79278793          	addi	a5,a5,1938 # 80236eb0 <bcache+0x8000>
    80002726:	2b87b703          	ld	a4,696(a5)
    8000272a:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000272c:	00235717          	auipc	a4,0x235
    80002730:	9ec70713          	addi	a4,a4,-1556 # 80237118 <bcache+0x8268>
    80002734:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002736:	2b87b703          	ld	a4,696(a5)
    8000273a:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000273c:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002740:	0022c517          	auipc	a0,0x22c
    80002744:	77050513          	addi	a0,a0,1904 # 8022eeb0 <bcache>
    80002748:	00004097          	auipc	ra,0x4
    8000274c:	cb4080e7          	jalr	-844(ra) # 800063fc <release>
}
    80002750:	60e2                	ld	ra,24(sp)
    80002752:	6442                	ld	s0,16(sp)
    80002754:	64a2                	ld	s1,8(sp)
    80002756:	6902                	ld	s2,0(sp)
    80002758:	6105                	addi	sp,sp,32
    8000275a:	8082                	ret
    panic("brelse");
    8000275c:	00006517          	auipc	a0,0x6
    80002760:	d5c50513          	addi	a0,a0,-676 # 800084b8 <syscalls+0xe0>
    80002764:	00003097          	auipc	ra,0x3
    80002768:	6ac080e7          	jalr	1708(ra) # 80005e10 <panic>

000000008000276c <bpin>:

void
bpin(struct buf *b) {
    8000276c:	1101                	addi	sp,sp,-32
    8000276e:	ec06                	sd	ra,24(sp)
    80002770:	e822                	sd	s0,16(sp)
    80002772:	e426                	sd	s1,8(sp)
    80002774:	1000                	addi	s0,sp,32
    80002776:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002778:	0022c517          	auipc	a0,0x22c
    8000277c:	73850513          	addi	a0,a0,1848 # 8022eeb0 <bcache>
    80002780:	00004097          	auipc	ra,0x4
    80002784:	bc8080e7          	jalr	-1080(ra) # 80006348 <acquire>
  b->refcnt++;
    80002788:	40bc                	lw	a5,64(s1)
    8000278a:	2785                	addiw	a5,a5,1
    8000278c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000278e:	0022c517          	auipc	a0,0x22c
    80002792:	72250513          	addi	a0,a0,1826 # 8022eeb0 <bcache>
    80002796:	00004097          	auipc	ra,0x4
    8000279a:	c66080e7          	jalr	-922(ra) # 800063fc <release>
}
    8000279e:	60e2                	ld	ra,24(sp)
    800027a0:	6442                	ld	s0,16(sp)
    800027a2:	64a2                	ld	s1,8(sp)
    800027a4:	6105                	addi	sp,sp,32
    800027a6:	8082                	ret

00000000800027a8 <bunpin>:

void
bunpin(struct buf *b) {
    800027a8:	1101                	addi	sp,sp,-32
    800027aa:	ec06                	sd	ra,24(sp)
    800027ac:	e822                	sd	s0,16(sp)
    800027ae:	e426                	sd	s1,8(sp)
    800027b0:	1000                	addi	s0,sp,32
    800027b2:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800027b4:	0022c517          	auipc	a0,0x22c
    800027b8:	6fc50513          	addi	a0,a0,1788 # 8022eeb0 <bcache>
    800027bc:	00004097          	auipc	ra,0x4
    800027c0:	b8c080e7          	jalr	-1140(ra) # 80006348 <acquire>
  b->refcnt--;
    800027c4:	40bc                	lw	a5,64(s1)
    800027c6:	37fd                	addiw	a5,a5,-1
    800027c8:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800027ca:	0022c517          	auipc	a0,0x22c
    800027ce:	6e650513          	addi	a0,a0,1766 # 8022eeb0 <bcache>
    800027d2:	00004097          	auipc	ra,0x4
    800027d6:	c2a080e7          	jalr	-982(ra) # 800063fc <release>
}
    800027da:	60e2                	ld	ra,24(sp)
    800027dc:	6442                	ld	s0,16(sp)
    800027de:	64a2                	ld	s1,8(sp)
    800027e0:	6105                	addi	sp,sp,32
    800027e2:	8082                	ret

00000000800027e4 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800027e4:	1101                	addi	sp,sp,-32
    800027e6:	ec06                	sd	ra,24(sp)
    800027e8:	e822                	sd	s0,16(sp)
    800027ea:	e426                	sd	s1,8(sp)
    800027ec:	e04a                	sd	s2,0(sp)
    800027ee:	1000                	addi	s0,sp,32
    800027f0:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800027f2:	00d5d59b          	srliw	a1,a1,0xd
    800027f6:	00235797          	auipc	a5,0x235
    800027fa:	d967a783          	lw	a5,-618(a5) # 8023758c <sb+0x1c>
    800027fe:	9dbd                	addw	a1,a1,a5
    80002800:	00000097          	auipc	ra,0x0
    80002804:	d9e080e7          	jalr	-610(ra) # 8000259e <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002808:	0074f713          	andi	a4,s1,7
    8000280c:	4785                	li	a5,1
    8000280e:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002812:	14ce                	slli	s1,s1,0x33
    80002814:	90d9                	srli	s1,s1,0x36
    80002816:	00950733          	add	a4,a0,s1
    8000281a:	05874703          	lbu	a4,88(a4)
    8000281e:	00e7f6b3          	and	a3,a5,a4
    80002822:	c69d                	beqz	a3,80002850 <bfree+0x6c>
    80002824:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002826:	94aa                	add	s1,s1,a0
    80002828:	fff7c793          	not	a5,a5
    8000282c:	8f7d                	and	a4,a4,a5
    8000282e:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002832:	00001097          	auipc	ra,0x1
    80002836:	120080e7          	jalr	288(ra) # 80003952 <log_write>
  brelse(bp);
    8000283a:	854a                	mv	a0,s2
    8000283c:	00000097          	auipc	ra,0x0
    80002840:	e92080e7          	jalr	-366(ra) # 800026ce <brelse>
}
    80002844:	60e2                	ld	ra,24(sp)
    80002846:	6442                	ld	s0,16(sp)
    80002848:	64a2                	ld	s1,8(sp)
    8000284a:	6902                	ld	s2,0(sp)
    8000284c:	6105                	addi	sp,sp,32
    8000284e:	8082                	ret
    panic("freeing free block");
    80002850:	00006517          	auipc	a0,0x6
    80002854:	c7050513          	addi	a0,a0,-912 # 800084c0 <syscalls+0xe8>
    80002858:	00003097          	auipc	ra,0x3
    8000285c:	5b8080e7          	jalr	1464(ra) # 80005e10 <panic>

0000000080002860 <balloc>:
{
    80002860:	711d                	addi	sp,sp,-96
    80002862:	ec86                	sd	ra,88(sp)
    80002864:	e8a2                	sd	s0,80(sp)
    80002866:	e4a6                	sd	s1,72(sp)
    80002868:	e0ca                	sd	s2,64(sp)
    8000286a:	fc4e                	sd	s3,56(sp)
    8000286c:	f852                	sd	s4,48(sp)
    8000286e:	f456                	sd	s5,40(sp)
    80002870:	f05a                	sd	s6,32(sp)
    80002872:	ec5e                	sd	s7,24(sp)
    80002874:	e862                	sd	s8,16(sp)
    80002876:	e466                	sd	s9,8(sp)
    80002878:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000287a:	00235797          	auipc	a5,0x235
    8000287e:	cfa7a783          	lw	a5,-774(a5) # 80237574 <sb+0x4>
    80002882:	cbc1                	beqz	a5,80002912 <balloc+0xb2>
    80002884:	8baa                	mv	s7,a0
    80002886:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002888:	00235b17          	auipc	s6,0x235
    8000288c:	ce8b0b13          	addi	s6,s6,-792 # 80237570 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002890:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002892:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002894:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002896:	6c89                	lui	s9,0x2
    80002898:	a831                	j	800028b4 <balloc+0x54>
    brelse(bp);
    8000289a:	854a                	mv	a0,s2
    8000289c:	00000097          	auipc	ra,0x0
    800028a0:	e32080e7          	jalr	-462(ra) # 800026ce <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800028a4:	015c87bb          	addw	a5,s9,s5
    800028a8:	00078a9b          	sext.w	s5,a5
    800028ac:	004b2703          	lw	a4,4(s6)
    800028b0:	06eaf163          	bgeu	s5,a4,80002912 <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    800028b4:	41fad79b          	sraiw	a5,s5,0x1f
    800028b8:	0137d79b          	srliw	a5,a5,0x13
    800028bc:	015787bb          	addw	a5,a5,s5
    800028c0:	40d7d79b          	sraiw	a5,a5,0xd
    800028c4:	01cb2583          	lw	a1,28(s6)
    800028c8:	9dbd                	addw	a1,a1,a5
    800028ca:	855e                	mv	a0,s7
    800028cc:	00000097          	auipc	ra,0x0
    800028d0:	cd2080e7          	jalr	-814(ra) # 8000259e <bread>
    800028d4:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800028d6:	004b2503          	lw	a0,4(s6)
    800028da:	000a849b          	sext.w	s1,s5
    800028de:	8762                	mv	a4,s8
    800028e0:	faa4fde3          	bgeu	s1,a0,8000289a <balloc+0x3a>
      m = 1 << (bi % 8);
    800028e4:	00777693          	andi	a3,a4,7
    800028e8:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800028ec:	41f7579b          	sraiw	a5,a4,0x1f
    800028f0:	01d7d79b          	srliw	a5,a5,0x1d
    800028f4:	9fb9                	addw	a5,a5,a4
    800028f6:	4037d79b          	sraiw	a5,a5,0x3
    800028fa:	00f90633          	add	a2,s2,a5
    800028fe:	05864603          	lbu	a2,88(a2)
    80002902:	00c6f5b3          	and	a1,a3,a2
    80002906:	cd91                	beqz	a1,80002922 <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002908:	2705                	addiw	a4,a4,1
    8000290a:	2485                	addiw	s1,s1,1
    8000290c:	fd471ae3          	bne	a4,s4,800028e0 <balloc+0x80>
    80002910:	b769                	j	8000289a <balloc+0x3a>
  panic("balloc: out of blocks");
    80002912:	00006517          	auipc	a0,0x6
    80002916:	bc650513          	addi	a0,a0,-1082 # 800084d8 <syscalls+0x100>
    8000291a:	00003097          	auipc	ra,0x3
    8000291e:	4f6080e7          	jalr	1270(ra) # 80005e10 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002922:	97ca                	add	a5,a5,s2
    80002924:	8e55                	or	a2,a2,a3
    80002926:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    8000292a:	854a                	mv	a0,s2
    8000292c:	00001097          	auipc	ra,0x1
    80002930:	026080e7          	jalr	38(ra) # 80003952 <log_write>
        brelse(bp);
    80002934:	854a                	mv	a0,s2
    80002936:	00000097          	auipc	ra,0x0
    8000293a:	d98080e7          	jalr	-616(ra) # 800026ce <brelse>
  bp = bread(dev, bno);
    8000293e:	85a6                	mv	a1,s1
    80002940:	855e                	mv	a0,s7
    80002942:	00000097          	auipc	ra,0x0
    80002946:	c5c080e7          	jalr	-932(ra) # 8000259e <bread>
    8000294a:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000294c:	40000613          	li	a2,1024
    80002950:	4581                	li	a1,0
    80002952:	05850513          	addi	a0,a0,88
    80002956:	ffffe097          	auipc	ra,0xffffe
    8000295a:	968080e7          	jalr	-1688(ra) # 800002be <memset>
  log_write(bp);
    8000295e:	854a                	mv	a0,s2
    80002960:	00001097          	auipc	ra,0x1
    80002964:	ff2080e7          	jalr	-14(ra) # 80003952 <log_write>
  brelse(bp);
    80002968:	854a                	mv	a0,s2
    8000296a:	00000097          	auipc	ra,0x0
    8000296e:	d64080e7          	jalr	-668(ra) # 800026ce <brelse>
}
    80002972:	8526                	mv	a0,s1
    80002974:	60e6                	ld	ra,88(sp)
    80002976:	6446                	ld	s0,80(sp)
    80002978:	64a6                	ld	s1,72(sp)
    8000297a:	6906                	ld	s2,64(sp)
    8000297c:	79e2                	ld	s3,56(sp)
    8000297e:	7a42                	ld	s4,48(sp)
    80002980:	7aa2                	ld	s5,40(sp)
    80002982:	7b02                	ld	s6,32(sp)
    80002984:	6be2                	ld	s7,24(sp)
    80002986:	6c42                	ld	s8,16(sp)
    80002988:	6ca2                	ld	s9,8(sp)
    8000298a:	6125                	addi	sp,sp,96
    8000298c:	8082                	ret

000000008000298e <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    8000298e:	7179                	addi	sp,sp,-48
    80002990:	f406                	sd	ra,40(sp)
    80002992:	f022                	sd	s0,32(sp)
    80002994:	ec26                	sd	s1,24(sp)
    80002996:	e84a                	sd	s2,16(sp)
    80002998:	e44e                	sd	s3,8(sp)
    8000299a:	e052                	sd	s4,0(sp)
    8000299c:	1800                	addi	s0,sp,48
    8000299e:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800029a0:	47ad                	li	a5,11
    800029a2:	04b7fe63          	bgeu	a5,a1,800029fe <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800029a6:	ff45849b          	addiw	s1,a1,-12
    800029aa:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800029ae:	0ff00793          	li	a5,255
    800029b2:	0ae7e463          	bltu	a5,a4,80002a5a <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800029b6:	08052583          	lw	a1,128(a0)
    800029ba:	c5b5                	beqz	a1,80002a26 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800029bc:	00092503          	lw	a0,0(s2)
    800029c0:	00000097          	auipc	ra,0x0
    800029c4:	bde080e7          	jalr	-1058(ra) # 8000259e <bread>
    800029c8:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800029ca:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800029ce:	02049713          	slli	a4,s1,0x20
    800029d2:	01e75593          	srli	a1,a4,0x1e
    800029d6:	00b784b3          	add	s1,a5,a1
    800029da:	0004a983          	lw	s3,0(s1)
    800029de:	04098e63          	beqz	s3,80002a3a <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800029e2:	8552                	mv	a0,s4
    800029e4:	00000097          	auipc	ra,0x0
    800029e8:	cea080e7          	jalr	-790(ra) # 800026ce <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800029ec:	854e                	mv	a0,s3
    800029ee:	70a2                	ld	ra,40(sp)
    800029f0:	7402                	ld	s0,32(sp)
    800029f2:	64e2                	ld	s1,24(sp)
    800029f4:	6942                	ld	s2,16(sp)
    800029f6:	69a2                	ld	s3,8(sp)
    800029f8:	6a02                	ld	s4,0(sp)
    800029fa:	6145                	addi	sp,sp,48
    800029fc:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    800029fe:	02059793          	slli	a5,a1,0x20
    80002a02:	01e7d593          	srli	a1,a5,0x1e
    80002a06:	00b504b3          	add	s1,a0,a1
    80002a0a:	0504a983          	lw	s3,80(s1)
    80002a0e:	fc099fe3          	bnez	s3,800029ec <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002a12:	4108                	lw	a0,0(a0)
    80002a14:	00000097          	auipc	ra,0x0
    80002a18:	e4c080e7          	jalr	-436(ra) # 80002860 <balloc>
    80002a1c:	0005099b          	sext.w	s3,a0
    80002a20:	0534a823          	sw	s3,80(s1)
    80002a24:	b7e1                	j	800029ec <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002a26:	4108                	lw	a0,0(a0)
    80002a28:	00000097          	auipc	ra,0x0
    80002a2c:	e38080e7          	jalr	-456(ra) # 80002860 <balloc>
    80002a30:	0005059b          	sext.w	a1,a0
    80002a34:	08b92023          	sw	a1,128(s2)
    80002a38:	b751                	j	800029bc <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002a3a:	00092503          	lw	a0,0(s2)
    80002a3e:	00000097          	auipc	ra,0x0
    80002a42:	e22080e7          	jalr	-478(ra) # 80002860 <balloc>
    80002a46:	0005099b          	sext.w	s3,a0
    80002a4a:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002a4e:	8552                	mv	a0,s4
    80002a50:	00001097          	auipc	ra,0x1
    80002a54:	f02080e7          	jalr	-254(ra) # 80003952 <log_write>
    80002a58:	b769                	j	800029e2 <bmap+0x54>
  panic("bmap: out of range");
    80002a5a:	00006517          	auipc	a0,0x6
    80002a5e:	a9650513          	addi	a0,a0,-1386 # 800084f0 <syscalls+0x118>
    80002a62:	00003097          	auipc	ra,0x3
    80002a66:	3ae080e7          	jalr	942(ra) # 80005e10 <panic>

0000000080002a6a <iget>:
{
    80002a6a:	7179                	addi	sp,sp,-48
    80002a6c:	f406                	sd	ra,40(sp)
    80002a6e:	f022                	sd	s0,32(sp)
    80002a70:	ec26                	sd	s1,24(sp)
    80002a72:	e84a                	sd	s2,16(sp)
    80002a74:	e44e                	sd	s3,8(sp)
    80002a76:	e052                	sd	s4,0(sp)
    80002a78:	1800                	addi	s0,sp,48
    80002a7a:	89aa                	mv	s3,a0
    80002a7c:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002a7e:	00235517          	auipc	a0,0x235
    80002a82:	b1250513          	addi	a0,a0,-1262 # 80237590 <itable>
    80002a86:	00004097          	auipc	ra,0x4
    80002a8a:	8c2080e7          	jalr	-1854(ra) # 80006348 <acquire>
  empty = 0;
    80002a8e:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a90:	00235497          	auipc	s1,0x235
    80002a94:	b1848493          	addi	s1,s1,-1256 # 802375a8 <itable+0x18>
    80002a98:	00236697          	auipc	a3,0x236
    80002a9c:	5a068693          	addi	a3,a3,1440 # 80239038 <log>
    80002aa0:	a039                	j	80002aae <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002aa2:	02090b63          	beqz	s2,80002ad8 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002aa6:	08848493          	addi	s1,s1,136
    80002aaa:	02d48a63          	beq	s1,a3,80002ade <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002aae:	449c                	lw	a5,8(s1)
    80002ab0:	fef059e3          	blez	a5,80002aa2 <iget+0x38>
    80002ab4:	4098                	lw	a4,0(s1)
    80002ab6:	ff3716e3          	bne	a4,s3,80002aa2 <iget+0x38>
    80002aba:	40d8                	lw	a4,4(s1)
    80002abc:	ff4713e3          	bne	a4,s4,80002aa2 <iget+0x38>
      ip->ref++;
    80002ac0:	2785                	addiw	a5,a5,1
    80002ac2:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002ac4:	00235517          	auipc	a0,0x235
    80002ac8:	acc50513          	addi	a0,a0,-1332 # 80237590 <itable>
    80002acc:	00004097          	auipc	ra,0x4
    80002ad0:	930080e7          	jalr	-1744(ra) # 800063fc <release>
      return ip;
    80002ad4:	8926                	mv	s2,s1
    80002ad6:	a03d                	j	80002b04 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002ad8:	f7f9                	bnez	a5,80002aa6 <iget+0x3c>
    80002ada:	8926                	mv	s2,s1
    80002adc:	b7e9                	j	80002aa6 <iget+0x3c>
  if(empty == 0)
    80002ade:	02090c63          	beqz	s2,80002b16 <iget+0xac>
  ip->dev = dev;
    80002ae2:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002ae6:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002aea:	4785                	li	a5,1
    80002aec:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002af0:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002af4:	00235517          	auipc	a0,0x235
    80002af8:	a9c50513          	addi	a0,a0,-1380 # 80237590 <itable>
    80002afc:	00004097          	auipc	ra,0x4
    80002b00:	900080e7          	jalr	-1792(ra) # 800063fc <release>
}
    80002b04:	854a                	mv	a0,s2
    80002b06:	70a2                	ld	ra,40(sp)
    80002b08:	7402                	ld	s0,32(sp)
    80002b0a:	64e2                	ld	s1,24(sp)
    80002b0c:	6942                	ld	s2,16(sp)
    80002b0e:	69a2                	ld	s3,8(sp)
    80002b10:	6a02                	ld	s4,0(sp)
    80002b12:	6145                	addi	sp,sp,48
    80002b14:	8082                	ret
    panic("iget: no inodes");
    80002b16:	00006517          	auipc	a0,0x6
    80002b1a:	9f250513          	addi	a0,a0,-1550 # 80008508 <syscalls+0x130>
    80002b1e:	00003097          	auipc	ra,0x3
    80002b22:	2f2080e7          	jalr	754(ra) # 80005e10 <panic>

0000000080002b26 <fsinit>:
fsinit(int dev) {
    80002b26:	7179                	addi	sp,sp,-48
    80002b28:	f406                	sd	ra,40(sp)
    80002b2a:	f022                	sd	s0,32(sp)
    80002b2c:	ec26                	sd	s1,24(sp)
    80002b2e:	e84a                	sd	s2,16(sp)
    80002b30:	e44e                	sd	s3,8(sp)
    80002b32:	1800                	addi	s0,sp,48
    80002b34:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002b36:	4585                	li	a1,1
    80002b38:	00000097          	auipc	ra,0x0
    80002b3c:	a66080e7          	jalr	-1434(ra) # 8000259e <bread>
    80002b40:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002b42:	00235997          	auipc	s3,0x235
    80002b46:	a2e98993          	addi	s3,s3,-1490 # 80237570 <sb>
    80002b4a:	02000613          	li	a2,32
    80002b4e:	05850593          	addi	a1,a0,88
    80002b52:	854e                	mv	a0,s3
    80002b54:	ffffd097          	auipc	ra,0xffffd
    80002b58:	7c6080e7          	jalr	1990(ra) # 8000031a <memmove>
  brelse(bp);
    80002b5c:	8526                	mv	a0,s1
    80002b5e:	00000097          	auipc	ra,0x0
    80002b62:	b70080e7          	jalr	-1168(ra) # 800026ce <brelse>
  if(sb.magic != FSMAGIC)
    80002b66:	0009a703          	lw	a4,0(s3)
    80002b6a:	102037b7          	lui	a5,0x10203
    80002b6e:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002b72:	02f71263          	bne	a4,a5,80002b96 <fsinit+0x70>
  initlog(dev, &sb);
    80002b76:	00235597          	auipc	a1,0x235
    80002b7a:	9fa58593          	addi	a1,a1,-1542 # 80237570 <sb>
    80002b7e:	854a                	mv	a0,s2
    80002b80:	00001097          	auipc	ra,0x1
    80002b84:	b56080e7          	jalr	-1194(ra) # 800036d6 <initlog>
}
    80002b88:	70a2                	ld	ra,40(sp)
    80002b8a:	7402                	ld	s0,32(sp)
    80002b8c:	64e2                	ld	s1,24(sp)
    80002b8e:	6942                	ld	s2,16(sp)
    80002b90:	69a2                	ld	s3,8(sp)
    80002b92:	6145                	addi	sp,sp,48
    80002b94:	8082                	ret
    panic("invalid file system");
    80002b96:	00006517          	auipc	a0,0x6
    80002b9a:	98250513          	addi	a0,a0,-1662 # 80008518 <syscalls+0x140>
    80002b9e:	00003097          	auipc	ra,0x3
    80002ba2:	272080e7          	jalr	626(ra) # 80005e10 <panic>

0000000080002ba6 <iinit>:
{
    80002ba6:	7179                	addi	sp,sp,-48
    80002ba8:	f406                	sd	ra,40(sp)
    80002baa:	f022                	sd	s0,32(sp)
    80002bac:	ec26                	sd	s1,24(sp)
    80002bae:	e84a                	sd	s2,16(sp)
    80002bb0:	e44e                	sd	s3,8(sp)
    80002bb2:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002bb4:	00006597          	auipc	a1,0x6
    80002bb8:	97c58593          	addi	a1,a1,-1668 # 80008530 <syscalls+0x158>
    80002bbc:	00235517          	auipc	a0,0x235
    80002bc0:	9d450513          	addi	a0,a0,-1580 # 80237590 <itable>
    80002bc4:	00003097          	auipc	ra,0x3
    80002bc8:	6f4080e7          	jalr	1780(ra) # 800062b8 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002bcc:	00235497          	auipc	s1,0x235
    80002bd0:	9ec48493          	addi	s1,s1,-1556 # 802375b8 <itable+0x28>
    80002bd4:	00236997          	auipc	s3,0x236
    80002bd8:	47498993          	addi	s3,s3,1140 # 80239048 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002bdc:	00006917          	auipc	s2,0x6
    80002be0:	95c90913          	addi	s2,s2,-1700 # 80008538 <syscalls+0x160>
    80002be4:	85ca                	mv	a1,s2
    80002be6:	8526                	mv	a0,s1
    80002be8:	00001097          	auipc	ra,0x1
    80002bec:	e4e080e7          	jalr	-434(ra) # 80003a36 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002bf0:	08848493          	addi	s1,s1,136
    80002bf4:	ff3498e3          	bne	s1,s3,80002be4 <iinit+0x3e>
}
    80002bf8:	70a2                	ld	ra,40(sp)
    80002bfa:	7402                	ld	s0,32(sp)
    80002bfc:	64e2                	ld	s1,24(sp)
    80002bfe:	6942                	ld	s2,16(sp)
    80002c00:	69a2                	ld	s3,8(sp)
    80002c02:	6145                	addi	sp,sp,48
    80002c04:	8082                	ret

0000000080002c06 <ialloc>:
{
    80002c06:	715d                	addi	sp,sp,-80
    80002c08:	e486                	sd	ra,72(sp)
    80002c0a:	e0a2                	sd	s0,64(sp)
    80002c0c:	fc26                	sd	s1,56(sp)
    80002c0e:	f84a                	sd	s2,48(sp)
    80002c10:	f44e                	sd	s3,40(sp)
    80002c12:	f052                	sd	s4,32(sp)
    80002c14:	ec56                	sd	s5,24(sp)
    80002c16:	e85a                	sd	s6,16(sp)
    80002c18:	e45e                	sd	s7,8(sp)
    80002c1a:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002c1c:	00235717          	auipc	a4,0x235
    80002c20:	96072703          	lw	a4,-1696(a4) # 8023757c <sb+0xc>
    80002c24:	4785                	li	a5,1
    80002c26:	04e7fa63          	bgeu	a5,a4,80002c7a <ialloc+0x74>
    80002c2a:	8aaa                	mv	s5,a0
    80002c2c:	8bae                	mv	s7,a1
    80002c2e:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002c30:	00235a17          	auipc	s4,0x235
    80002c34:	940a0a13          	addi	s4,s4,-1728 # 80237570 <sb>
    80002c38:	00048b1b          	sext.w	s6,s1
    80002c3c:	0044d593          	srli	a1,s1,0x4
    80002c40:	018a2783          	lw	a5,24(s4)
    80002c44:	9dbd                	addw	a1,a1,a5
    80002c46:	8556                	mv	a0,s5
    80002c48:	00000097          	auipc	ra,0x0
    80002c4c:	956080e7          	jalr	-1706(ra) # 8000259e <bread>
    80002c50:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002c52:	05850993          	addi	s3,a0,88
    80002c56:	00f4f793          	andi	a5,s1,15
    80002c5a:	079a                	slli	a5,a5,0x6
    80002c5c:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002c5e:	00099783          	lh	a5,0(s3)
    80002c62:	c785                	beqz	a5,80002c8a <ialloc+0x84>
    brelse(bp);
    80002c64:	00000097          	auipc	ra,0x0
    80002c68:	a6a080e7          	jalr	-1430(ra) # 800026ce <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002c6c:	0485                	addi	s1,s1,1
    80002c6e:	00ca2703          	lw	a4,12(s4)
    80002c72:	0004879b          	sext.w	a5,s1
    80002c76:	fce7e1e3          	bltu	a5,a4,80002c38 <ialloc+0x32>
  panic("ialloc: no inodes");
    80002c7a:	00006517          	auipc	a0,0x6
    80002c7e:	8c650513          	addi	a0,a0,-1850 # 80008540 <syscalls+0x168>
    80002c82:	00003097          	auipc	ra,0x3
    80002c86:	18e080e7          	jalr	398(ra) # 80005e10 <panic>
      memset(dip, 0, sizeof(*dip));
    80002c8a:	04000613          	li	a2,64
    80002c8e:	4581                	li	a1,0
    80002c90:	854e                	mv	a0,s3
    80002c92:	ffffd097          	auipc	ra,0xffffd
    80002c96:	62c080e7          	jalr	1580(ra) # 800002be <memset>
      dip->type = type;
    80002c9a:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002c9e:	854a                	mv	a0,s2
    80002ca0:	00001097          	auipc	ra,0x1
    80002ca4:	cb2080e7          	jalr	-846(ra) # 80003952 <log_write>
      brelse(bp);
    80002ca8:	854a                	mv	a0,s2
    80002caa:	00000097          	auipc	ra,0x0
    80002cae:	a24080e7          	jalr	-1500(ra) # 800026ce <brelse>
      return iget(dev, inum);
    80002cb2:	85da                	mv	a1,s6
    80002cb4:	8556                	mv	a0,s5
    80002cb6:	00000097          	auipc	ra,0x0
    80002cba:	db4080e7          	jalr	-588(ra) # 80002a6a <iget>
}
    80002cbe:	60a6                	ld	ra,72(sp)
    80002cc0:	6406                	ld	s0,64(sp)
    80002cc2:	74e2                	ld	s1,56(sp)
    80002cc4:	7942                	ld	s2,48(sp)
    80002cc6:	79a2                	ld	s3,40(sp)
    80002cc8:	7a02                	ld	s4,32(sp)
    80002cca:	6ae2                	ld	s5,24(sp)
    80002ccc:	6b42                	ld	s6,16(sp)
    80002cce:	6ba2                	ld	s7,8(sp)
    80002cd0:	6161                	addi	sp,sp,80
    80002cd2:	8082                	ret

0000000080002cd4 <iupdate>:
{
    80002cd4:	1101                	addi	sp,sp,-32
    80002cd6:	ec06                	sd	ra,24(sp)
    80002cd8:	e822                	sd	s0,16(sp)
    80002cda:	e426                	sd	s1,8(sp)
    80002cdc:	e04a                	sd	s2,0(sp)
    80002cde:	1000                	addi	s0,sp,32
    80002ce0:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002ce2:	415c                	lw	a5,4(a0)
    80002ce4:	0047d79b          	srliw	a5,a5,0x4
    80002ce8:	00235597          	auipc	a1,0x235
    80002cec:	8a05a583          	lw	a1,-1888(a1) # 80237588 <sb+0x18>
    80002cf0:	9dbd                	addw	a1,a1,a5
    80002cf2:	4108                	lw	a0,0(a0)
    80002cf4:	00000097          	auipc	ra,0x0
    80002cf8:	8aa080e7          	jalr	-1878(ra) # 8000259e <bread>
    80002cfc:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002cfe:	05850793          	addi	a5,a0,88
    80002d02:	40d8                	lw	a4,4(s1)
    80002d04:	8b3d                	andi	a4,a4,15
    80002d06:	071a                	slli	a4,a4,0x6
    80002d08:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002d0a:	04449703          	lh	a4,68(s1)
    80002d0e:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002d12:	04649703          	lh	a4,70(s1)
    80002d16:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002d1a:	04849703          	lh	a4,72(s1)
    80002d1e:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002d22:	04a49703          	lh	a4,74(s1)
    80002d26:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002d2a:	44f8                	lw	a4,76(s1)
    80002d2c:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002d2e:	03400613          	li	a2,52
    80002d32:	05048593          	addi	a1,s1,80
    80002d36:	00c78513          	addi	a0,a5,12
    80002d3a:	ffffd097          	auipc	ra,0xffffd
    80002d3e:	5e0080e7          	jalr	1504(ra) # 8000031a <memmove>
  log_write(bp);
    80002d42:	854a                	mv	a0,s2
    80002d44:	00001097          	auipc	ra,0x1
    80002d48:	c0e080e7          	jalr	-1010(ra) # 80003952 <log_write>
  brelse(bp);
    80002d4c:	854a                	mv	a0,s2
    80002d4e:	00000097          	auipc	ra,0x0
    80002d52:	980080e7          	jalr	-1664(ra) # 800026ce <brelse>
}
    80002d56:	60e2                	ld	ra,24(sp)
    80002d58:	6442                	ld	s0,16(sp)
    80002d5a:	64a2                	ld	s1,8(sp)
    80002d5c:	6902                	ld	s2,0(sp)
    80002d5e:	6105                	addi	sp,sp,32
    80002d60:	8082                	ret

0000000080002d62 <idup>:
{
    80002d62:	1101                	addi	sp,sp,-32
    80002d64:	ec06                	sd	ra,24(sp)
    80002d66:	e822                	sd	s0,16(sp)
    80002d68:	e426                	sd	s1,8(sp)
    80002d6a:	1000                	addi	s0,sp,32
    80002d6c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d6e:	00235517          	auipc	a0,0x235
    80002d72:	82250513          	addi	a0,a0,-2014 # 80237590 <itable>
    80002d76:	00003097          	auipc	ra,0x3
    80002d7a:	5d2080e7          	jalr	1490(ra) # 80006348 <acquire>
  ip->ref++;
    80002d7e:	449c                	lw	a5,8(s1)
    80002d80:	2785                	addiw	a5,a5,1
    80002d82:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d84:	00235517          	auipc	a0,0x235
    80002d88:	80c50513          	addi	a0,a0,-2036 # 80237590 <itable>
    80002d8c:	00003097          	auipc	ra,0x3
    80002d90:	670080e7          	jalr	1648(ra) # 800063fc <release>
}
    80002d94:	8526                	mv	a0,s1
    80002d96:	60e2                	ld	ra,24(sp)
    80002d98:	6442                	ld	s0,16(sp)
    80002d9a:	64a2                	ld	s1,8(sp)
    80002d9c:	6105                	addi	sp,sp,32
    80002d9e:	8082                	ret

0000000080002da0 <ilock>:
{
    80002da0:	1101                	addi	sp,sp,-32
    80002da2:	ec06                	sd	ra,24(sp)
    80002da4:	e822                	sd	s0,16(sp)
    80002da6:	e426                	sd	s1,8(sp)
    80002da8:	e04a                	sd	s2,0(sp)
    80002daa:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002dac:	c115                	beqz	a0,80002dd0 <ilock+0x30>
    80002dae:	84aa                	mv	s1,a0
    80002db0:	451c                	lw	a5,8(a0)
    80002db2:	00f05f63          	blez	a5,80002dd0 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002db6:	0541                	addi	a0,a0,16
    80002db8:	00001097          	auipc	ra,0x1
    80002dbc:	cb8080e7          	jalr	-840(ra) # 80003a70 <acquiresleep>
  if(ip->valid == 0){
    80002dc0:	40bc                	lw	a5,64(s1)
    80002dc2:	cf99                	beqz	a5,80002de0 <ilock+0x40>
}
    80002dc4:	60e2                	ld	ra,24(sp)
    80002dc6:	6442                	ld	s0,16(sp)
    80002dc8:	64a2                	ld	s1,8(sp)
    80002dca:	6902                	ld	s2,0(sp)
    80002dcc:	6105                	addi	sp,sp,32
    80002dce:	8082                	ret
    panic("ilock");
    80002dd0:	00005517          	auipc	a0,0x5
    80002dd4:	78850513          	addi	a0,a0,1928 # 80008558 <syscalls+0x180>
    80002dd8:	00003097          	auipc	ra,0x3
    80002ddc:	038080e7          	jalr	56(ra) # 80005e10 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002de0:	40dc                	lw	a5,4(s1)
    80002de2:	0047d79b          	srliw	a5,a5,0x4
    80002de6:	00234597          	auipc	a1,0x234
    80002dea:	7a25a583          	lw	a1,1954(a1) # 80237588 <sb+0x18>
    80002dee:	9dbd                	addw	a1,a1,a5
    80002df0:	4088                	lw	a0,0(s1)
    80002df2:	fffff097          	auipc	ra,0xfffff
    80002df6:	7ac080e7          	jalr	1964(ra) # 8000259e <bread>
    80002dfa:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002dfc:	05850593          	addi	a1,a0,88
    80002e00:	40dc                	lw	a5,4(s1)
    80002e02:	8bbd                	andi	a5,a5,15
    80002e04:	079a                	slli	a5,a5,0x6
    80002e06:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002e08:	00059783          	lh	a5,0(a1)
    80002e0c:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002e10:	00259783          	lh	a5,2(a1)
    80002e14:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002e18:	00459783          	lh	a5,4(a1)
    80002e1c:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002e20:	00659783          	lh	a5,6(a1)
    80002e24:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002e28:	459c                	lw	a5,8(a1)
    80002e2a:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002e2c:	03400613          	li	a2,52
    80002e30:	05b1                	addi	a1,a1,12
    80002e32:	05048513          	addi	a0,s1,80
    80002e36:	ffffd097          	auipc	ra,0xffffd
    80002e3a:	4e4080e7          	jalr	1252(ra) # 8000031a <memmove>
    brelse(bp);
    80002e3e:	854a                	mv	a0,s2
    80002e40:	00000097          	auipc	ra,0x0
    80002e44:	88e080e7          	jalr	-1906(ra) # 800026ce <brelse>
    ip->valid = 1;
    80002e48:	4785                	li	a5,1
    80002e4a:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002e4c:	04449783          	lh	a5,68(s1)
    80002e50:	fbb5                	bnez	a5,80002dc4 <ilock+0x24>
      panic("ilock: no type");
    80002e52:	00005517          	auipc	a0,0x5
    80002e56:	70e50513          	addi	a0,a0,1806 # 80008560 <syscalls+0x188>
    80002e5a:	00003097          	auipc	ra,0x3
    80002e5e:	fb6080e7          	jalr	-74(ra) # 80005e10 <panic>

0000000080002e62 <iunlock>:
{
    80002e62:	1101                	addi	sp,sp,-32
    80002e64:	ec06                	sd	ra,24(sp)
    80002e66:	e822                	sd	s0,16(sp)
    80002e68:	e426                	sd	s1,8(sp)
    80002e6a:	e04a                	sd	s2,0(sp)
    80002e6c:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002e6e:	c905                	beqz	a0,80002e9e <iunlock+0x3c>
    80002e70:	84aa                	mv	s1,a0
    80002e72:	01050913          	addi	s2,a0,16
    80002e76:	854a                	mv	a0,s2
    80002e78:	00001097          	auipc	ra,0x1
    80002e7c:	c92080e7          	jalr	-878(ra) # 80003b0a <holdingsleep>
    80002e80:	cd19                	beqz	a0,80002e9e <iunlock+0x3c>
    80002e82:	449c                	lw	a5,8(s1)
    80002e84:	00f05d63          	blez	a5,80002e9e <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002e88:	854a                	mv	a0,s2
    80002e8a:	00001097          	auipc	ra,0x1
    80002e8e:	c3c080e7          	jalr	-964(ra) # 80003ac6 <releasesleep>
}
    80002e92:	60e2                	ld	ra,24(sp)
    80002e94:	6442                	ld	s0,16(sp)
    80002e96:	64a2                	ld	s1,8(sp)
    80002e98:	6902                	ld	s2,0(sp)
    80002e9a:	6105                	addi	sp,sp,32
    80002e9c:	8082                	ret
    panic("iunlock");
    80002e9e:	00005517          	auipc	a0,0x5
    80002ea2:	6d250513          	addi	a0,a0,1746 # 80008570 <syscalls+0x198>
    80002ea6:	00003097          	auipc	ra,0x3
    80002eaa:	f6a080e7          	jalr	-150(ra) # 80005e10 <panic>

0000000080002eae <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002eae:	7179                	addi	sp,sp,-48
    80002eb0:	f406                	sd	ra,40(sp)
    80002eb2:	f022                	sd	s0,32(sp)
    80002eb4:	ec26                	sd	s1,24(sp)
    80002eb6:	e84a                	sd	s2,16(sp)
    80002eb8:	e44e                	sd	s3,8(sp)
    80002eba:	e052                	sd	s4,0(sp)
    80002ebc:	1800                	addi	s0,sp,48
    80002ebe:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002ec0:	05050493          	addi	s1,a0,80
    80002ec4:	08050913          	addi	s2,a0,128
    80002ec8:	a021                	j	80002ed0 <itrunc+0x22>
    80002eca:	0491                	addi	s1,s1,4
    80002ecc:	01248d63          	beq	s1,s2,80002ee6 <itrunc+0x38>
    if(ip->addrs[i]){
    80002ed0:	408c                	lw	a1,0(s1)
    80002ed2:	dde5                	beqz	a1,80002eca <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002ed4:	0009a503          	lw	a0,0(s3)
    80002ed8:	00000097          	auipc	ra,0x0
    80002edc:	90c080e7          	jalr	-1780(ra) # 800027e4 <bfree>
      ip->addrs[i] = 0;
    80002ee0:	0004a023          	sw	zero,0(s1)
    80002ee4:	b7dd                	j	80002eca <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002ee6:	0809a583          	lw	a1,128(s3)
    80002eea:	e185                	bnez	a1,80002f0a <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002eec:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002ef0:	854e                	mv	a0,s3
    80002ef2:	00000097          	auipc	ra,0x0
    80002ef6:	de2080e7          	jalr	-542(ra) # 80002cd4 <iupdate>
}
    80002efa:	70a2                	ld	ra,40(sp)
    80002efc:	7402                	ld	s0,32(sp)
    80002efe:	64e2                	ld	s1,24(sp)
    80002f00:	6942                	ld	s2,16(sp)
    80002f02:	69a2                	ld	s3,8(sp)
    80002f04:	6a02                	ld	s4,0(sp)
    80002f06:	6145                	addi	sp,sp,48
    80002f08:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002f0a:	0009a503          	lw	a0,0(s3)
    80002f0e:	fffff097          	auipc	ra,0xfffff
    80002f12:	690080e7          	jalr	1680(ra) # 8000259e <bread>
    80002f16:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002f18:	05850493          	addi	s1,a0,88
    80002f1c:	45850913          	addi	s2,a0,1112
    80002f20:	a021                	j	80002f28 <itrunc+0x7a>
    80002f22:	0491                	addi	s1,s1,4
    80002f24:	01248b63          	beq	s1,s2,80002f3a <itrunc+0x8c>
      if(a[j])
    80002f28:	408c                	lw	a1,0(s1)
    80002f2a:	dde5                	beqz	a1,80002f22 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002f2c:	0009a503          	lw	a0,0(s3)
    80002f30:	00000097          	auipc	ra,0x0
    80002f34:	8b4080e7          	jalr	-1868(ra) # 800027e4 <bfree>
    80002f38:	b7ed                	j	80002f22 <itrunc+0x74>
    brelse(bp);
    80002f3a:	8552                	mv	a0,s4
    80002f3c:	fffff097          	auipc	ra,0xfffff
    80002f40:	792080e7          	jalr	1938(ra) # 800026ce <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002f44:	0809a583          	lw	a1,128(s3)
    80002f48:	0009a503          	lw	a0,0(s3)
    80002f4c:	00000097          	auipc	ra,0x0
    80002f50:	898080e7          	jalr	-1896(ra) # 800027e4 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002f54:	0809a023          	sw	zero,128(s3)
    80002f58:	bf51                	j	80002eec <itrunc+0x3e>

0000000080002f5a <iput>:
{
    80002f5a:	1101                	addi	sp,sp,-32
    80002f5c:	ec06                	sd	ra,24(sp)
    80002f5e:	e822                	sd	s0,16(sp)
    80002f60:	e426                	sd	s1,8(sp)
    80002f62:	e04a                	sd	s2,0(sp)
    80002f64:	1000                	addi	s0,sp,32
    80002f66:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002f68:	00234517          	auipc	a0,0x234
    80002f6c:	62850513          	addi	a0,a0,1576 # 80237590 <itable>
    80002f70:	00003097          	auipc	ra,0x3
    80002f74:	3d8080e7          	jalr	984(ra) # 80006348 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f78:	4498                	lw	a4,8(s1)
    80002f7a:	4785                	li	a5,1
    80002f7c:	02f70363          	beq	a4,a5,80002fa2 <iput+0x48>
  ip->ref--;
    80002f80:	449c                	lw	a5,8(s1)
    80002f82:	37fd                	addiw	a5,a5,-1
    80002f84:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002f86:	00234517          	auipc	a0,0x234
    80002f8a:	60a50513          	addi	a0,a0,1546 # 80237590 <itable>
    80002f8e:	00003097          	auipc	ra,0x3
    80002f92:	46e080e7          	jalr	1134(ra) # 800063fc <release>
}
    80002f96:	60e2                	ld	ra,24(sp)
    80002f98:	6442                	ld	s0,16(sp)
    80002f9a:	64a2                	ld	s1,8(sp)
    80002f9c:	6902                	ld	s2,0(sp)
    80002f9e:	6105                	addi	sp,sp,32
    80002fa0:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002fa2:	40bc                	lw	a5,64(s1)
    80002fa4:	dff1                	beqz	a5,80002f80 <iput+0x26>
    80002fa6:	04a49783          	lh	a5,74(s1)
    80002faa:	fbf9                	bnez	a5,80002f80 <iput+0x26>
    acquiresleep(&ip->lock);
    80002fac:	01048913          	addi	s2,s1,16
    80002fb0:	854a                	mv	a0,s2
    80002fb2:	00001097          	auipc	ra,0x1
    80002fb6:	abe080e7          	jalr	-1346(ra) # 80003a70 <acquiresleep>
    release(&itable.lock);
    80002fba:	00234517          	auipc	a0,0x234
    80002fbe:	5d650513          	addi	a0,a0,1494 # 80237590 <itable>
    80002fc2:	00003097          	auipc	ra,0x3
    80002fc6:	43a080e7          	jalr	1082(ra) # 800063fc <release>
    itrunc(ip);
    80002fca:	8526                	mv	a0,s1
    80002fcc:	00000097          	auipc	ra,0x0
    80002fd0:	ee2080e7          	jalr	-286(ra) # 80002eae <itrunc>
    ip->type = 0;
    80002fd4:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002fd8:	8526                	mv	a0,s1
    80002fda:	00000097          	auipc	ra,0x0
    80002fde:	cfa080e7          	jalr	-774(ra) # 80002cd4 <iupdate>
    ip->valid = 0;
    80002fe2:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002fe6:	854a                	mv	a0,s2
    80002fe8:	00001097          	auipc	ra,0x1
    80002fec:	ade080e7          	jalr	-1314(ra) # 80003ac6 <releasesleep>
    acquire(&itable.lock);
    80002ff0:	00234517          	auipc	a0,0x234
    80002ff4:	5a050513          	addi	a0,a0,1440 # 80237590 <itable>
    80002ff8:	00003097          	auipc	ra,0x3
    80002ffc:	350080e7          	jalr	848(ra) # 80006348 <acquire>
    80003000:	b741                	j	80002f80 <iput+0x26>

0000000080003002 <iunlockput>:
{
    80003002:	1101                	addi	sp,sp,-32
    80003004:	ec06                	sd	ra,24(sp)
    80003006:	e822                	sd	s0,16(sp)
    80003008:	e426                	sd	s1,8(sp)
    8000300a:	1000                	addi	s0,sp,32
    8000300c:	84aa                	mv	s1,a0
  iunlock(ip);
    8000300e:	00000097          	auipc	ra,0x0
    80003012:	e54080e7          	jalr	-428(ra) # 80002e62 <iunlock>
  iput(ip);
    80003016:	8526                	mv	a0,s1
    80003018:	00000097          	auipc	ra,0x0
    8000301c:	f42080e7          	jalr	-190(ra) # 80002f5a <iput>
}
    80003020:	60e2                	ld	ra,24(sp)
    80003022:	6442                	ld	s0,16(sp)
    80003024:	64a2                	ld	s1,8(sp)
    80003026:	6105                	addi	sp,sp,32
    80003028:	8082                	ret

000000008000302a <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    8000302a:	1141                	addi	sp,sp,-16
    8000302c:	e422                	sd	s0,8(sp)
    8000302e:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003030:	411c                	lw	a5,0(a0)
    80003032:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003034:	415c                	lw	a5,4(a0)
    80003036:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003038:	04451783          	lh	a5,68(a0)
    8000303c:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003040:	04a51783          	lh	a5,74(a0)
    80003044:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003048:	04c56783          	lwu	a5,76(a0)
    8000304c:	e99c                	sd	a5,16(a1)
}
    8000304e:	6422                	ld	s0,8(sp)
    80003050:	0141                	addi	sp,sp,16
    80003052:	8082                	ret

0000000080003054 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003054:	457c                	lw	a5,76(a0)
    80003056:	0ed7e963          	bltu	a5,a3,80003148 <readi+0xf4>
{
    8000305a:	7159                	addi	sp,sp,-112
    8000305c:	f486                	sd	ra,104(sp)
    8000305e:	f0a2                	sd	s0,96(sp)
    80003060:	eca6                	sd	s1,88(sp)
    80003062:	e8ca                	sd	s2,80(sp)
    80003064:	e4ce                	sd	s3,72(sp)
    80003066:	e0d2                	sd	s4,64(sp)
    80003068:	fc56                	sd	s5,56(sp)
    8000306a:	f85a                	sd	s6,48(sp)
    8000306c:	f45e                	sd	s7,40(sp)
    8000306e:	f062                	sd	s8,32(sp)
    80003070:	ec66                	sd	s9,24(sp)
    80003072:	e86a                	sd	s10,16(sp)
    80003074:	e46e                	sd	s11,8(sp)
    80003076:	1880                	addi	s0,sp,112
    80003078:	8baa                	mv	s7,a0
    8000307a:	8c2e                	mv	s8,a1
    8000307c:	8ab2                	mv	s5,a2
    8000307e:	84b6                	mv	s1,a3
    80003080:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003082:	9f35                	addw	a4,a4,a3
    return 0;
    80003084:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003086:	0ad76063          	bltu	a4,a3,80003126 <readi+0xd2>
  if(off + n > ip->size)
    8000308a:	00e7f463          	bgeu	a5,a4,80003092 <readi+0x3e>
    n = ip->size - off;
    8000308e:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003092:	0a0b0963          	beqz	s6,80003144 <readi+0xf0>
    80003096:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003098:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    8000309c:	5cfd                	li	s9,-1
    8000309e:	a82d                	j	800030d8 <readi+0x84>
    800030a0:	020a1d93          	slli	s11,s4,0x20
    800030a4:	020ddd93          	srli	s11,s11,0x20
    800030a8:	05890613          	addi	a2,s2,88
    800030ac:	86ee                	mv	a3,s11
    800030ae:	963a                	add	a2,a2,a4
    800030b0:	85d6                	mv	a1,s5
    800030b2:	8562                	mv	a0,s8
    800030b4:	fffff097          	auipc	ra,0xfffff
    800030b8:	9b0080e7          	jalr	-1616(ra) # 80001a64 <either_copyout>
    800030bc:	05950d63          	beq	a0,s9,80003116 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800030c0:	854a                	mv	a0,s2
    800030c2:	fffff097          	auipc	ra,0xfffff
    800030c6:	60c080e7          	jalr	1548(ra) # 800026ce <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800030ca:	013a09bb          	addw	s3,s4,s3
    800030ce:	009a04bb          	addw	s1,s4,s1
    800030d2:	9aee                	add	s5,s5,s11
    800030d4:	0569f763          	bgeu	s3,s6,80003122 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    800030d8:	000ba903          	lw	s2,0(s7)
    800030dc:	00a4d59b          	srliw	a1,s1,0xa
    800030e0:	855e                	mv	a0,s7
    800030e2:	00000097          	auipc	ra,0x0
    800030e6:	8ac080e7          	jalr	-1876(ra) # 8000298e <bmap>
    800030ea:	0005059b          	sext.w	a1,a0
    800030ee:	854a                	mv	a0,s2
    800030f0:	fffff097          	auipc	ra,0xfffff
    800030f4:	4ae080e7          	jalr	1198(ra) # 8000259e <bread>
    800030f8:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800030fa:	3ff4f713          	andi	a4,s1,1023
    800030fe:	40ed07bb          	subw	a5,s10,a4
    80003102:	413b06bb          	subw	a3,s6,s3
    80003106:	8a3e                	mv	s4,a5
    80003108:	2781                	sext.w	a5,a5
    8000310a:	0006861b          	sext.w	a2,a3
    8000310e:	f8f679e3          	bgeu	a2,a5,800030a0 <readi+0x4c>
    80003112:	8a36                	mv	s4,a3
    80003114:	b771                	j	800030a0 <readi+0x4c>
      brelse(bp);
    80003116:	854a                	mv	a0,s2
    80003118:	fffff097          	auipc	ra,0xfffff
    8000311c:	5b6080e7          	jalr	1462(ra) # 800026ce <brelse>
      tot = -1;
    80003120:	59fd                	li	s3,-1
  }
  return tot;
    80003122:	0009851b          	sext.w	a0,s3
}
    80003126:	70a6                	ld	ra,104(sp)
    80003128:	7406                	ld	s0,96(sp)
    8000312a:	64e6                	ld	s1,88(sp)
    8000312c:	6946                	ld	s2,80(sp)
    8000312e:	69a6                	ld	s3,72(sp)
    80003130:	6a06                	ld	s4,64(sp)
    80003132:	7ae2                	ld	s5,56(sp)
    80003134:	7b42                	ld	s6,48(sp)
    80003136:	7ba2                	ld	s7,40(sp)
    80003138:	7c02                	ld	s8,32(sp)
    8000313a:	6ce2                	ld	s9,24(sp)
    8000313c:	6d42                	ld	s10,16(sp)
    8000313e:	6da2                	ld	s11,8(sp)
    80003140:	6165                	addi	sp,sp,112
    80003142:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003144:	89da                	mv	s3,s6
    80003146:	bff1                	j	80003122 <readi+0xce>
    return 0;
    80003148:	4501                	li	a0,0
}
    8000314a:	8082                	ret

000000008000314c <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000314c:	457c                	lw	a5,76(a0)
    8000314e:	10d7e863          	bltu	a5,a3,8000325e <writei+0x112>
{
    80003152:	7159                	addi	sp,sp,-112
    80003154:	f486                	sd	ra,104(sp)
    80003156:	f0a2                	sd	s0,96(sp)
    80003158:	eca6                	sd	s1,88(sp)
    8000315a:	e8ca                	sd	s2,80(sp)
    8000315c:	e4ce                	sd	s3,72(sp)
    8000315e:	e0d2                	sd	s4,64(sp)
    80003160:	fc56                	sd	s5,56(sp)
    80003162:	f85a                	sd	s6,48(sp)
    80003164:	f45e                	sd	s7,40(sp)
    80003166:	f062                	sd	s8,32(sp)
    80003168:	ec66                	sd	s9,24(sp)
    8000316a:	e86a                	sd	s10,16(sp)
    8000316c:	e46e                	sd	s11,8(sp)
    8000316e:	1880                	addi	s0,sp,112
    80003170:	8b2a                	mv	s6,a0
    80003172:	8c2e                	mv	s8,a1
    80003174:	8ab2                	mv	s5,a2
    80003176:	8936                	mv	s2,a3
    80003178:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    8000317a:	00e687bb          	addw	a5,a3,a4
    8000317e:	0ed7e263          	bltu	a5,a3,80003262 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003182:	00043737          	lui	a4,0x43
    80003186:	0ef76063          	bltu	a4,a5,80003266 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000318a:	0c0b8863          	beqz	s7,8000325a <writei+0x10e>
    8000318e:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003190:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003194:	5cfd                	li	s9,-1
    80003196:	a091                	j	800031da <writei+0x8e>
    80003198:	02099d93          	slli	s11,s3,0x20
    8000319c:	020ddd93          	srli	s11,s11,0x20
    800031a0:	05848513          	addi	a0,s1,88
    800031a4:	86ee                	mv	a3,s11
    800031a6:	8656                	mv	a2,s5
    800031a8:	85e2                	mv	a1,s8
    800031aa:	953a                	add	a0,a0,a4
    800031ac:	fffff097          	auipc	ra,0xfffff
    800031b0:	90e080e7          	jalr	-1778(ra) # 80001aba <either_copyin>
    800031b4:	07950263          	beq	a0,s9,80003218 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    800031b8:	8526                	mv	a0,s1
    800031ba:	00000097          	auipc	ra,0x0
    800031be:	798080e7          	jalr	1944(ra) # 80003952 <log_write>
    brelse(bp);
    800031c2:	8526                	mv	a0,s1
    800031c4:	fffff097          	auipc	ra,0xfffff
    800031c8:	50a080e7          	jalr	1290(ra) # 800026ce <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800031cc:	01498a3b          	addw	s4,s3,s4
    800031d0:	0129893b          	addw	s2,s3,s2
    800031d4:	9aee                	add	s5,s5,s11
    800031d6:	057a7663          	bgeu	s4,s7,80003222 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    800031da:	000b2483          	lw	s1,0(s6)
    800031de:	00a9559b          	srliw	a1,s2,0xa
    800031e2:	855a                	mv	a0,s6
    800031e4:	fffff097          	auipc	ra,0xfffff
    800031e8:	7aa080e7          	jalr	1962(ra) # 8000298e <bmap>
    800031ec:	0005059b          	sext.w	a1,a0
    800031f0:	8526                	mv	a0,s1
    800031f2:	fffff097          	auipc	ra,0xfffff
    800031f6:	3ac080e7          	jalr	940(ra) # 8000259e <bread>
    800031fa:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800031fc:	3ff97713          	andi	a4,s2,1023
    80003200:	40ed07bb          	subw	a5,s10,a4
    80003204:	414b86bb          	subw	a3,s7,s4
    80003208:	89be                	mv	s3,a5
    8000320a:	2781                	sext.w	a5,a5
    8000320c:	0006861b          	sext.w	a2,a3
    80003210:	f8f674e3          	bgeu	a2,a5,80003198 <writei+0x4c>
    80003214:	89b6                	mv	s3,a3
    80003216:	b749                	j	80003198 <writei+0x4c>
      brelse(bp);
    80003218:	8526                	mv	a0,s1
    8000321a:	fffff097          	auipc	ra,0xfffff
    8000321e:	4b4080e7          	jalr	1204(ra) # 800026ce <brelse>
  }

  if(off > ip->size)
    80003222:	04cb2783          	lw	a5,76(s6)
    80003226:	0127f463          	bgeu	a5,s2,8000322e <writei+0xe2>
    ip->size = off;
    8000322a:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000322e:	855a                	mv	a0,s6
    80003230:	00000097          	auipc	ra,0x0
    80003234:	aa4080e7          	jalr	-1372(ra) # 80002cd4 <iupdate>

  return tot;
    80003238:	000a051b          	sext.w	a0,s4
}
    8000323c:	70a6                	ld	ra,104(sp)
    8000323e:	7406                	ld	s0,96(sp)
    80003240:	64e6                	ld	s1,88(sp)
    80003242:	6946                	ld	s2,80(sp)
    80003244:	69a6                	ld	s3,72(sp)
    80003246:	6a06                	ld	s4,64(sp)
    80003248:	7ae2                	ld	s5,56(sp)
    8000324a:	7b42                	ld	s6,48(sp)
    8000324c:	7ba2                	ld	s7,40(sp)
    8000324e:	7c02                	ld	s8,32(sp)
    80003250:	6ce2                	ld	s9,24(sp)
    80003252:	6d42                	ld	s10,16(sp)
    80003254:	6da2                	ld	s11,8(sp)
    80003256:	6165                	addi	sp,sp,112
    80003258:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000325a:	8a5e                	mv	s4,s7
    8000325c:	bfc9                	j	8000322e <writei+0xe2>
    return -1;
    8000325e:	557d                	li	a0,-1
}
    80003260:	8082                	ret
    return -1;
    80003262:	557d                	li	a0,-1
    80003264:	bfe1                	j	8000323c <writei+0xf0>
    return -1;
    80003266:	557d                	li	a0,-1
    80003268:	bfd1                	j	8000323c <writei+0xf0>

000000008000326a <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000326a:	1141                	addi	sp,sp,-16
    8000326c:	e406                	sd	ra,8(sp)
    8000326e:	e022                	sd	s0,0(sp)
    80003270:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003272:	4639                	li	a2,14
    80003274:	ffffd097          	auipc	ra,0xffffd
    80003278:	11a080e7          	jalr	282(ra) # 8000038e <strncmp>
}
    8000327c:	60a2                	ld	ra,8(sp)
    8000327e:	6402                	ld	s0,0(sp)
    80003280:	0141                	addi	sp,sp,16
    80003282:	8082                	ret

0000000080003284 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003284:	7139                	addi	sp,sp,-64
    80003286:	fc06                	sd	ra,56(sp)
    80003288:	f822                	sd	s0,48(sp)
    8000328a:	f426                	sd	s1,40(sp)
    8000328c:	f04a                	sd	s2,32(sp)
    8000328e:	ec4e                	sd	s3,24(sp)
    80003290:	e852                	sd	s4,16(sp)
    80003292:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003294:	04451703          	lh	a4,68(a0)
    80003298:	4785                	li	a5,1
    8000329a:	00f71a63          	bne	a4,a5,800032ae <dirlookup+0x2a>
    8000329e:	892a                	mv	s2,a0
    800032a0:	89ae                	mv	s3,a1
    800032a2:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800032a4:	457c                	lw	a5,76(a0)
    800032a6:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800032a8:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032aa:	e79d                	bnez	a5,800032d8 <dirlookup+0x54>
    800032ac:	a8a5                	j	80003324 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800032ae:	00005517          	auipc	a0,0x5
    800032b2:	2ca50513          	addi	a0,a0,714 # 80008578 <syscalls+0x1a0>
    800032b6:	00003097          	auipc	ra,0x3
    800032ba:	b5a080e7          	jalr	-1190(ra) # 80005e10 <panic>
      panic("dirlookup read");
    800032be:	00005517          	auipc	a0,0x5
    800032c2:	2d250513          	addi	a0,a0,722 # 80008590 <syscalls+0x1b8>
    800032c6:	00003097          	auipc	ra,0x3
    800032ca:	b4a080e7          	jalr	-1206(ra) # 80005e10 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032ce:	24c1                	addiw	s1,s1,16
    800032d0:	04c92783          	lw	a5,76(s2)
    800032d4:	04f4f763          	bgeu	s1,a5,80003322 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032d8:	4741                	li	a4,16
    800032da:	86a6                	mv	a3,s1
    800032dc:	fc040613          	addi	a2,s0,-64
    800032e0:	4581                	li	a1,0
    800032e2:	854a                	mv	a0,s2
    800032e4:	00000097          	auipc	ra,0x0
    800032e8:	d70080e7          	jalr	-656(ra) # 80003054 <readi>
    800032ec:	47c1                	li	a5,16
    800032ee:	fcf518e3          	bne	a0,a5,800032be <dirlookup+0x3a>
    if(de.inum == 0)
    800032f2:	fc045783          	lhu	a5,-64(s0)
    800032f6:	dfe1                	beqz	a5,800032ce <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800032f8:	fc240593          	addi	a1,s0,-62
    800032fc:	854e                	mv	a0,s3
    800032fe:	00000097          	auipc	ra,0x0
    80003302:	f6c080e7          	jalr	-148(ra) # 8000326a <namecmp>
    80003306:	f561                	bnez	a0,800032ce <dirlookup+0x4a>
      if(poff)
    80003308:	000a0463          	beqz	s4,80003310 <dirlookup+0x8c>
        *poff = off;
    8000330c:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003310:	fc045583          	lhu	a1,-64(s0)
    80003314:	00092503          	lw	a0,0(s2)
    80003318:	fffff097          	auipc	ra,0xfffff
    8000331c:	752080e7          	jalr	1874(ra) # 80002a6a <iget>
    80003320:	a011                	j	80003324 <dirlookup+0xa0>
  return 0;
    80003322:	4501                	li	a0,0
}
    80003324:	70e2                	ld	ra,56(sp)
    80003326:	7442                	ld	s0,48(sp)
    80003328:	74a2                	ld	s1,40(sp)
    8000332a:	7902                	ld	s2,32(sp)
    8000332c:	69e2                	ld	s3,24(sp)
    8000332e:	6a42                	ld	s4,16(sp)
    80003330:	6121                	addi	sp,sp,64
    80003332:	8082                	ret

0000000080003334 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003334:	711d                	addi	sp,sp,-96
    80003336:	ec86                	sd	ra,88(sp)
    80003338:	e8a2                	sd	s0,80(sp)
    8000333a:	e4a6                	sd	s1,72(sp)
    8000333c:	e0ca                	sd	s2,64(sp)
    8000333e:	fc4e                	sd	s3,56(sp)
    80003340:	f852                	sd	s4,48(sp)
    80003342:	f456                	sd	s5,40(sp)
    80003344:	f05a                	sd	s6,32(sp)
    80003346:	ec5e                	sd	s7,24(sp)
    80003348:	e862                	sd	s8,16(sp)
    8000334a:	e466                	sd	s9,8(sp)
    8000334c:	e06a                	sd	s10,0(sp)
    8000334e:	1080                	addi	s0,sp,96
    80003350:	84aa                	mv	s1,a0
    80003352:	8b2e                	mv	s6,a1
    80003354:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003356:	00054703          	lbu	a4,0(a0)
    8000335a:	02f00793          	li	a5,47
    8000335e:	02f70363          	beq	a4,a5,80003384 <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003362:	ffffe097          	auipc	ra,0xffffe
    80003366:	c3c080e7          	jalr	-964(ra) # 80000f9e <myproc>
    8000336a:	15053503          	ld	a0,336(a0)
    8000336e:	00000097          	auipc	ra,0x0
    80003372:	9f4080e7          	jalr	-1548(ra) # 80002d62 <idup>
    80003376:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003378:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    8000337c:	4cb5                	li	s9,13
  len = path - s;
    8000337e:	4b81                	li	s7,0

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003380:	4c05                	li	s8,1
    80003382:	a87d                	j	80003440 <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    80003384:	4585                	li	a1,1
    80003386:	4505                	li	a0,1
    80003388:	fffff097          	auipc	ra,0xfffff
    8000338c:	6e2080e7          	jalr	1762(ra) # 80002a6a <iget>
    80003390:	8a2a                	mv	s4,a0
    80003392:	b7dd                	j	80003378 <namex+0x44>
      iunlockput(ip);
    80003394:	8552                	mv	a0,s4
    80003396:	00000097          	auipc	ra,0x0
    8000339a:	c6c080e7          	jalr	-916(ra) # 80003002 <iunlockput>
      return 0;
    8000339e:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800033a0:	8552                	mv	a0,s4
    800033a2:	60e6                	ld	ra,88(sp)
    800033a4:	6446                	ld	s0,80(sp)
    800033a6:	64a6                	ld	s1,72(sp)
    800033a8:	6906                	ld	s2,64(sp)
    800033aa:	79e2                	ld	s3,56(sp)
    800033ac:	7a42                	ld	s4,48(sp)
    800033ae:	7aa2                	ld	s5,40(sp)
    800033b0:	7b02                	ld	s6,32(sp)
    800033b2:	6be2                	ld	s7,24(sp)
    800033b4:	6c42                	ld	s8,16(sp)
    800033b6:	6ca2                	ld	s9,8(sp)
    800033b8:	6d02                	ld	s10,0(sp)
    800033ba:	6125                	addi	sp,sp,96
    800033bc:	8082                	ret
      iunlock(ip);
    800033be:	8552                	mv	a0,s4
    800033c0:	00000097          	auipc	ra,0x0
    800033c4:	aa2080e7          	jalr	-1374(ra) # 80002e62 <iunlock>
      return ip;
    800033c8:	bfe1                	j	800033a0 <namex+0x6c>
      iunlockput(ip);
    800033ca:	8552                	mv	a0,s4
    800033cc:	00000097          	auipc	ra,0x0
    800033d0:	c36080e7          	jalr	-970(ra) # 80003002 <iunlockput>
      return 0;
    800033d4:	8a4e                	mv	s4,s3
    800033d6:	b7e9                	j	800033a0 <namex+0x6c>
  len = path - s;
    800033d8:	40998633          	sub	a2,s3,s1
    800033dc:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    800033e0:	09acd863          	bge	s9,s10,80003470 <namex+0x13c>
    memmove(name, s, DIRSIZ);
    800033e4:	4639                	li	a2,14
    800033e6:	85a6                	mv	a1,s1
    800033e8:	8556                	mv	a0,s5
    800033ea:	ffffd097          	auipc	ra,0xffffd
    800033ee:	f30080e7          	jalr	-208(ra) # 8000031a <memmove>
    800033f2:	84ce                	mv	s1,s3
  while(*path == '/')
    800033f4:	0004c783          	lbu	a5,0(s1)
    800033f8:	01279763          	bne	a5,s2,80003406 <namex+0xd2>
    path++;
    800033fc:	0485                	addi	s1,s1,1
  while(*path == '/')
    800033fe:	0004c783          	lbu	a5,0(s1)
    80003402:	ff278de3          	beq	a5,s2,800033fc <namex+0xc8>
    ilock(ip);
    80003406:	8552                	mv	a0,s4
    80003408:	00000097          	auipc	ra,0x0
    8000340c:	998080e7          	jalr	-1640(ra) # 80002da0 <ilock>
    if(ip->type != T_DIR){
    80003410:	044a1783          	lh	a5,68(s4)
    80003414:	f98790e3          	bne	a5,s8,80003394 <namex+0x60>
    if(nameiparent && *path == '\0'){
    80003418:	000b0563          	beqz	s6,80003422 <namex+0xee>
    8000341c:	0004c783          	lbu	a5,0(s1)
    80003420:	dfd9                	beqz	a5,800033be <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003422:	865e                	mv	a2,s7
    80003424:	85d6                	mv	a1,s5
    80003426:	8552                	mv	a0,s4
    80003428:	00000097          	auipc	ra,0x0
    8000342c:	e5c080e7          	jalr	-420(ra) # 80003284 <dirlookup>
    80003430:	89aa                	mv	s3,a0
    80003432:	dd41                	beqz	a0,800033ca <namex+0x96>
    iunlockput(ip);
    80003434:	8552                	mv	a0,s4
    80003436:	00000097          	auipc	ra,0x0
    8000343a:	bcc080e7          	jalr	-1076(ra) # 80003002 <iunlockput>
    ip = next;
    8000343e:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003440:	0004c783          	lbu	a5,0(s1)
    80003444:	01279763          	bne	a5,s2,80003452 <namex+0x11e>
    path++;
    80003448:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000344a:	0004c783          	lbu	a5,0(s1)
    8000344e:	ff278de3          	beq	a5,s2,80003448 <namex+0x114>
  if(*path == 0)
    80003452:	cb9d                	beqz	a5,80003488 <namex+0x154>
  while(*path != '/' && *path != 0)
    80003454:	0004c783          	lbu	a5,0(s1)
    80003458:	89a6                	mv	s3,s1
  len = path - s;
    8000345a:	8d5e                	mv	s10,s7
    8000345c:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    8000345e:	01278963          	beq	a5,s2,80003470 <namex+0x13c>
    80003462:	dbbd                	beqz	a5,800033d8 <namex+0xa4>
    path++;
    80003464:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003466:	0009c783          	lbu	a5,0(s3)
    8000346a:	ff279ce3          	bne	a5,s2,80003462 <namex+0x12e>
    8000346e:	b7ad                	j	800033d8 <namex+0xa4>
    memmove(name, s, len);
    80003470:	2601                	sext.w	a2,a2
    80003472:	85a6                	mv	a1,s1
    80003474:	8556                	mv	a0,s5
    80003476:	ffffd097          	auipc	ra,0xffffd
    8000347a:	ea4080e7          	jalr	-348(ra) # 8000031a <memmove>
    name[len] = 0;
    8000347e:	9d56                	add	s10,s10,s5
    80003480:	000d0023          	sb	zero,0(s10) # fffffffffffff000 <end+0xffffffff7fdb8dc0>
    80003484:	84ce                	mv	s1,s3
    80003486:	b7bd                	j	800033f4 <namex+0xc0>
  if(nameiparent){
    80003488:	f00b0ce3          	beqz	s6,800033a0 <namex+0x6c>
    iput(ip);
    8000348c:	8552                	mv	a0,s4
    8000348e:	00000097          	auipc	ra,0x0
    80003492:	acc080e7          	jalr	-1332(ra) # 80002f5a <iput>
    return 0;
    80003496:	4a01                	li	s4,0
    80003498:	b721                	j	800033a0 <namex+0x6c>

000000008000349a <dirlink>:
{
    8000349a:	7139                	addi	sp,sp,-64
    8000349c:	fc06                	sd	ra,56(sp)
    8000349e:	f822                	sd	s0,48(sp)
    800034a0:	f426                	sd	s1,40(sp)
    800034a2:	f04a                	sd	s2,32(sp)
    800034a4:	ec4e                	sd	s3,24(sp)
    800034a6:	e852                	sd	s4,16(sp)
    800034a8:	0080                	addi	s0,sp,64
    800034aa:	892a                	mv	s2,a0
    800034ac:	8a2e                	mv	s4,a1
    800034ae:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800034b0:	4601                	li	a2,0
    800034b2:	00000097          	auipc	ra,0x0
    800034b6:	dd2080e7          	jalr	-558(ra) # 80003284 <dirlookup>
    800034ba:	e93d                	bnez	a0,80003530 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800034bc:	04c92483          	lw	s1,76(s2)
    800034c0:	c49d                	beqz	s1,800034ee <dirlink+0x54>
    800034c2:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800034c4:	4741                	li	a4,16
    800034c6:	86a6                	mv	a3,s1
    800034c8:	fc040613          	addi	a2,s0,-64
    800034cc:	4581                	li	a1,0
    800034ce:	854a                	mv	a0,s2
    800034d0:	00000097          	auipc	ra,0x0
    800034d4:	b84080e7          	jalr	-1148(ra) # 80003054 <readi>
    800034d8:	47c1                	li	a5,16
    800034da:	06f51163          	bne	a0,a5,8000353c <dirlink+0xa2>
    if(de.inum == 0)
    800034de:	fc045783          	lhu	a5,-64(s0)
    800034e2:	c791                	beqz	a5,800034ee <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800034e4:	24c1                	addiw	s1,s1,16
    800034e6:	04c92783          	lw	a5,76(s2)
    800034ea:	fcf4ede3          	bltu	s1,a5,800034c4 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800034ee:	4639                	li	a2,14
    800034f0:	85d2                	mv	a1,s4
    800034f2:	fc240513          	addi	a0,s0,-62
    800034f6:	ffffd097          	auipc	ra,0xffffd
    800034fa:	ed4080e7          	jalr	-300(ra) # 800003ca <strncpy>
  de.inum = inum;
    800034fe:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003502:	4741                	li	a4,16
    80003504:	86a6                	mv	a3,s1
    80003506:	fc040613          	addi	a2,s0,-64
    8000350a:	4581                	li	a1,0
    8000350c:	854a                	mv	a0,s2
    8000350e:	00000097          	auipc	ra,0x0
    80003512:	c3e080e7          	jalr	-962(ra) # 8000314c <writei>
    80003516:	872a                	mv	a4,a0
    80003518:	47c1                	li	a5,16
  return 0;
    8000351a:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000351c:	02f71863          	bne	a4,a5,8000354c <dirlink+0xb2>
}
    80003520:	70e2                	ld	ra,56(sp)
    80003522:	7442                	ld	s0,48(sp)
    80003524:	74a2                	ld	s1,40(sp)
    80003526:	7902                	ld	s2,32(sp)
    80003528:	69e2                	ld	s3,24(sp)
    8000352a:	6a42                	ld	s4,16(sp)
    8000352c:	6121                	addi	sp,sp,64
    8000352e:	8082                	ret
    iput(ip);
    80003530:	00000097          	auipc	ra,0x0
    80003534:	a2a080e7          	jalr	-1494(ra) # 80002f5a <iput>
    return -1;
    80003538:	557d                	li	a0,-1
    8000353a:	b7dd                	j	80003520 <dirlink+0x86>
      panic("dirlink read");
    8000353c:	00005517          	auipc	a0,0x5
    80003540:	06450513          	addi	a0,a0,100 # 800085a0 <syscalls+0x1c8>
    80003544:	00003097          	auipc	ra,0x3
    80003548:	8cc080e7          	jalr	-1844(ra) # 80005e10 <panic>
    panic("dirlink");
    8000354c:	00005517          	auipc	a0,0x5
    80003550:	16450513          	addi	a0,a0,356 # 800086b0 <syscalls+0x2d8>
    80003554:	00003097          	auipc	ra,0x3
    80003558:	8bc080e7          	jalr	-1860(ra) # 80005e10 <panic>

000000008000355c <namei>:

struct inode*
namei(char *path)
{
    8000355c:	1101                	addi	sp,sp,-32
    8000355e:	ec06                	sd	ra,24(sp)
    80003560:	e822                	sd	s0,16(sp)
    80003562:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003564:	fe040613          	addi	a2,s0,-32
    80003568:	4581                	li	a1,0
    8000356a:	00000097          	auipc	ra,0x0
    8000356e:	dca080e7          	jalr	-566(ra) # 80003334 <namex>
}
    80003572:	60e2                	ld	ra,24(sp)
    80003574:	6442                	ld	s0,16(sp)
    80003576:	6105                	addi	sp,sp,32
    80003578:	8082                	ret

000000008000357a <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000357a:	1141                	addi	sp,sp,-16
    8000357c:	e406                	sd	ra,8(sp)
    8000357e:	e022                	sd	s0,0(sp)
    80003580:	0800                	addi	s0,sp,16
    80003582:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003584:	4585                	li	a1,1
    80003586:	00000097          	auipc	ra,0x0
    8000358a:	dae080e7          	jalr	-594(ra) # 80003334 <namex>
}
    8000358e:	60a2                	ld	ra,8(sp)
    80003590:	6402                	ld	s0,0(sp)
    80003592:	0141                	addi	sp,sp,16
    80003594:	8082                	ret

0000000080003596 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003596:	1101                	addi	sp,sp,-32
    80003598:	ec06                	sd	ra,24(sp)
    8000359a:	e822                	sd	s0,16(sp)
    8000359c:	e426                	sd	s1,8(sp)
    8000359e:	e04a                	sd	s2,0(sp)
    800035a0:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800035a2:	00236917          	auipc	s2,0x236
    800035a6:	a9690913          	addi	s2,s2,-1386 # 80239038 <log>
    800035aa:	01892583          	lw	a1,24(s2)
    800035ae:	02892503          	lw	a0,40(s2)
    800035b2:	fffff097          	auipc	ra,0xfffff
    800035b6:	fec080e7          	jalr	-20(ra) # 8000259e <bread>
    800035ba:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800035bc:	02c92683          	lw	a3,44(s2)
    800035c0:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800035c2:	02d05863          	blez	a3,800035f2 <write_head+0x5c>
    800035c6:	00236797          	auipc	a5,0x236
    800035ca:	aa278793          	addi	a5,a5,-1374 # 80239068 <log+0x30>
    800035ce:	05c50713          	addi	a4,a0,92
    800035d2:	36fd                	addiw	a3,a3,-1
    800035d4:	02069613          	slli	a2,a3,0x20
    800035d8:	01e65693          	srli	a3,a2,0x1e
    800035dc:	00236617          	auipc	a2,0x236
    800035e0:	a9060613          	addi	a2,a2,-1392 # 8023906c <log+0x34>
    800035e4:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800035e6:	4390                	lw	a2,0(a5)
    800035e8:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800035ea:	0791                	addi	a5,a5,4
    800035ec:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    800035ee:	fed79ce3          	bne	a5,a3,800035e6 <write_head+0x50>
  }
  bwrite(buf);
    800035f2:	8526                	mv	a0,s1
    800035f4:	fffff097          	auipc	ra,0xfffff
    800035f8:	09c080e7          	jalr	156(ra) # 80002690 <bwrite>
  brelse(buf);
    800035fc:	8526                	mv	a0,s1
    800035fe:	fffff097          	auipc	ra,0xfffff
    80003602:	0d0080e7          	jalr	208(ra) # 800026ce <brelse>
}
    80003606:	60e2                	ld	ra,24(sp)
    80003608:	6442                	ld	s0,16(sp)
    8000360a:	64a2                	ld	s1,8(sp)
    8000360c:	6902                	ld	s2,0(sp)
    8000360e:	6105                	addi	sp,sp,32
    80003610:	8082                	ret

0000000080003612 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003612:	00236797          	auipc	a5,0x236
    80003616:	a527a783          	lw	a5,-1454(a5) # 80239064 <log+0x2c>
    8000361a:	0af05d63          	blez	a5,800036d4 <install_trans+0xc2>
{
    8000361e:	7139                	addi	sp,sp,-64
    80003620:	fc06                	sd	ra,56(sp)
    80003622:	f822                	sd	s0,48(sp)
    80003624:	f426                	sd	s1,40(sp)
    80003626:	f04a                	sd	s2,32(sp)
    80003628:	ec4e                	sd	s3,24(sp)
    8000362a:	e852                	sd	s4,16(sp)
    8000362c:	e456                	sd	s5,8(sp)
    8000362e:	e05a                	sd	s6,0(sp)
    80003630:	0080                	addi	s0,sp,64
    80003632:	8b2a                	mv	s6,a0
    80003634:	00236a97          	auipc	s5,0x236
    80003638:	a34a8a93          	addi	s5,s5,-1484 # 80239068 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000363c:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000363e:	00236997          	auipc	s3,0x236
    80003642:	9fa98993          	addi	s3,s3,-1542 # 80239038 <log>
    80003646:	a00d                	j	80003668 <install_trans+0x56>
    brelse(lbuf);
    80003648:	854a                	mv	a0,s2
    8000364a:	fffff097          	auipc	ra,0xfffff
    8000364e:	084080e7          	jalr	132(ra) # 800026ce <brelse>
    brelse(dbuf);
    80003652:	8526                	mv	a0,s1
    80003654:	fffff097          	auipc	ra,0xfffff
    80003658:	07a080e7          	jalr	122(ra) # 800026ce <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000365c:	2a05                	addiw	s4,s4,1
    8000365e:	0a91                	addi	s5,s5,4
    80003660:	02c9a783          	lw	a5,44(s3)
    80003664:	04fa5e63          	bge	s4,a5,800036c0 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003668:	0189a583          	lw	a1,24(s3)
    8000366c:	014585bb          	addw	a1,a1,s4
    80003670:	2585                	addiw	a1,a1,1
    80003672:	0289a503          	lw	a0,40(s3)
    80003676:	fffff097          	auipc	ra,0xfffff
    8000367a:	f28080e7          	jalr	-216(ra) # 8000259e <bread>
    8000367e:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003680:	000aa583          	lw	a1,0(s5)
    80003684:	0289a503          	lw	a0,40(s3)
    80003688:	fffff097          	auipc	ra,0xfffff
    8000368c:	f16080e7          	jalr	-234(ra) # 8000259e <bread>
    80003690:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003692:	40000613          	li	a2,1024
    80003696:	05890593          	addi	a1,s2,88
    8000369a:	05850513          	addi	a0,a0,88
    8000369e:	ffffd097          	auipc	ra,0xffffd
    800036a2:	c7c080e7          	jalr	-900(ra) # 8000031a <memmove>
    bwrite(dbuf);  // write dst to disk
    800036a6:	8526                	mv	a0,s1
    800036a8:	fffff097          	auipc	ra,0xfffff
    800036ac:	fe8080e7          	jalr	-24(ra) # 80002690 <bwrite>
    if(recovering == 0)
    800036b0:	f80b1ce3          	bnez	s6,80003648 <install_trans+0x36>
      bunpin(dbuf);
    800036b4:	8526                	mv	a0,s1
    800036b6:	fffff097          	auipc	ra,0xfffff
    800036ba:	0f2080e7          	jalr	242(ra) # 800027a8 <bunpin>
    800036be:	b769                	j	80003648 <install_trans+0x36>
}
    800036c0:	70e2                	ld	ra,56(sp)
    800036c2:	7442                	ld	s0,48(sp)
    800036c4:	74a2                	ld	s1,40(sp)
    800036c6:	7902                	ld	s2,32(sp)
    800036c8:	69e2                	ld	s3,24(sp)
    800036ca:	6a42                	ld	s4,16(sp)
    800036cc:	6aa2                	ld	s5,8(sp)
    800036ce:	6b02                	ld	s6,0(sp)
    800036d0:	6121                	addi	sp,sp,64
    800036d2:	8082                	ret
    800036d4:	8082                	ret

00000000800036d6 <initlog>:
{
    800036d6:	7179                	addi	sp,sp,-48
    800036d8:	f406                	sd	ra,40(sp)
    800036da:	f022                	sd	s0,32(sp)
    800036dc:	ec26                	sd	s1,24(sp)
    800036de:	e84a                	sd	s2,16(sp)
    800036e0:	e44e                	sd	s3,8(sp)
    800036e2:	1800                	addi	s0,sp,48
    800036e4:	892a                	mv	s2,a0
    800036e6:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800036e8:	00236497          	auipc	s1,0x236
    800036ec:	95048493          	addi	s1,s1,-1712 # 80239038 <log>
    800036f0:	00005597          	auipc	a1,0x5
    800036f4:	ec058593          	addi	a1,a1,-320 # 800085b0 <syscalls+0x1d8>
    800036f8:	8526                	mv	a0,s1
    800036fa:	00003097          	auipc	ra,0x3
    800036fe:	bbe080e7          	jalr	-1090(ra) # 800062b8 <initlock>
  log.start = sb->logstart;
    80003702:	0149a583          	lw	a1,20(s3)
    80003706:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003708:	0109a783          	lw	a5,16(s3)
    8000370c:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000370e:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003712:	854a                	mv	a0,s2
    80003714:	fffff097          	auipc	ra,0xfffff
    80003718:	e8a080e7          	jalr	-374(ra) # 8000259e <bread>
  log.lh.n = lh->n;
    8000371c:	4d34                	lw	a3,88(a0)
    8000371e:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003720:	02d05663          	blez	a3,8000374c <initlog+0x76>
    80003724:	05c50793          	addi	a5,a0,92
    80003728:	00236717          	auipc	a4,0x236
    8000372c:	94070713          	addi	a4,a4,-1728 # 80239068 <log+0x30>
    80003730:	36fd                	addiw	a3,a3,-1
    80003732:	02069613          	slli	a2,a3,0x20
    80003736:	01e65693          	srli	a3,a2,0x1e
    8000373a:	06050613          	addi	a2,a0,96
    8000373e:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80003740:	4390                	lw	a2,0(a5)
    80003742:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003744:	0791                	addi	a5,a5,4
    80003746:	0711                	addi	a4,a4,4
    80003748:	fed79ce3          	bne	a5,a3,80003740 <initlog+0x6a>
  brelse(buf);
    8000374c:	fffff097          	auipc	ra,0xfffff
    80003750:	f82080e7          	jalr	-126(ra) # 800026ce <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003754:	4505                	li	a0,1
    80003756:	00000097          	auipc	ra,0x0
    8000375a:	ebc080e7          	jalr	-324(ra) # 80003612 <install_trans>
  log.lh.n = 0;
    8000375e:	00236797          	auipc	a5,0x236
    80003762:	9007a323          	sw	zero,-1786(a5) # 80239064 <log+0x2c>
  write_head(); // clear the log
    80003766:	00000097          	auipc	ra,0x0
    8000376a:	e30080e7          	jalr	-464(ra) # 80003596 <write_head>
}
    8000376e:	70a2                	ld	ra,40(sp)
    80003770:	7402                	ld	s0,32(sp)
    80003772:	64e2                	ld	s1,24(sp)
    80003774:	6942                	ld	s2,16(sp)
    80003776:	69a2                	ld	s3,8(sp)
    80003778:	6145                	addi	sp,sp,48
    8000377a:	8082                	ret

000000008000377c <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000377c:	1101                	addi	sp,sp,-32
    8000377e:	ec06                	sd	ra,24(sp)
    80003780:	e822                	sd	s0,16(sp)
    80003782:	e426                	sd	s1,8(sp)
    80003784:	e04a                	sd	s2,0(sp)
    80003786:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003788:	00236517          	auipc	a0,0x236
    8000378c:	8b050513          	addi	a0,a0,-1872 # 80239038 <log>
    80003790:	00003097          	auipc	ra,0x3
    80003794:	bb8080e7          	jalr	-1096(ra) # 80006348 <acquire>
  while(1){
    if(log.committing){
    80003798:	00236497          	auipc	s1,0x236
    8000379c:	8a048493          	addi	s1,s1,-1888 # 80239038 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800037a0:	4979                	li	s2,30
    800037a2:	a039                	j	800037b0 <begin_op+0x34>
      sleep(&log, &log.lock);
    800037a4:	85a6                	mv	a1,s1
    800037a6:	8526                	mv	a0,s1
    800037a8:	ffffe097          	auipc	ra,0xffffe
    800037ac:	eba080e7          	jalr	-326(ra) # 80001662 <sleep>
    if(log.committing){
    800037b0:	50dc                	lw	a5,36(s1)
    800037b2:	fbed                	bnez	a5,800037a4 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800037b4:	5098                	lw	a4,32(s1)
    800037b6:	2705                	addiw	a4,a4,1
    800037b8:	0007069b          	sext.w	a3,a4
    800037bc:	0027179b          	slliw	a5,a4,0x2
    800037c0:	9fb9                	addw	a5,a5,a4
    800037c2:	0017979b          	slliw	a5,a5,0x1
    800037c6:	54d8                	lw	a4,44(s1)
    800037c8:	9fb9                	addw	a5,a5,a4
    800037ca:	00f95963          	bge	s2,a5,800037dc <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800037ce:	85a6                	mv	a1,s1
    800037d0:	8526                	mv	a0,s1
    800037d2:	ffffe097          	auipc	ra,0xffffe
    800037d6:	e90080e7          	jalr	-368(ra) # 80001662 <sleep>
    800037da:	bfd9                	j	800037b0 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800037dc:	00236517          	auipc	a0,0x236
    800037e0:	85c50513          	addi	a0,a0,-1956 # 80239038 <log>
    800037e4:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800037e6:	00003097          	auipc	ra,0x3
    800037ea:	c16080e7          	jalr	-1002(ra) # 800063fc <release>
      break;
    }
  }
}
    800037ee:	60e2                	ld	ra,24(sp)
    800037f0:	6442                	ld	s0,16(sp)
    800037f2:	64a2                	ld	s1,8(sp)
    800037f4:	6902                	ld	s2,0(sp)
    800037f6:	6105                	addi	sp,sp,32
    800037f8:	8082                	ret

00000000800037fa <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800037fa:	7139                	addi	sp,sp,-64
    800037fc:	fc06                	sd	ra,56(sp)
    800037fe:	f822                	sd	s0,48(sp)
    80003800:	f426                	sd	s1,40(sp)
    80003802:	f04a                	sd	s2,32(sp)
    80003804:	ec4e                	sd	s3,24(sp)
    80003806:	e852                	sd	s4,16(sp)
    80003808:	e456                	sd	s5,8(sp)
    8000380a:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000380c:	00236497          	auipc	s1,0x236
    80003810:	82c48493          	addi	s1,s1,-2004 # 80239038 <log>
    80003814:	8526                	mv	a0,s1
    80003816:	00003097          	auipc	ra,0x3
    8000381a:	b32080e7          	jalr	-1230(ra) # 80006348 <acquire>
  log.outstanding -= 1;
    8000381e:	509c                	lw	a5,32(s1)
    80003820:	37fd                	addiw	a5,a5,-1
    80003822:	0007891b          	sext.w	s2,a5
    80003826:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003828:	50dc                	lw	a5,36(s1)
    8000382a:	e7b9                	bnez	a5,80003878 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000382c:	04091e63          	bnez	s2,80003888 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80003830:	00236497          	auipc	s1,0x236
    80003834:	80848493          	addi	s1,s1,-2040 # 80239038 <log>
    80003838:	4785                	li	a5,1
    8000383a:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000383c:	8526                	mv	a0,s1
    8000383e:	00003097          	auipc	ra,0x3
    80003842:	bbe080e7          	jalr	-1090(ra) # 800063fc <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003846:	54dc                	lw	a5,44(s1)
    80003848:	06f04763          	bgtz	a5,800038b6 <end_op+0xbc>
    acquire(&log.lock);
    8000384c:	00235497          	auipc	s1,0x235
    80003850:	7ec48493          	addi	s1,s1,2028 # 80239038 <log>
    80003854:	8526                	mv	a0,s1
    80003856:	00003097          	auipc	ra,0x3
    8000385a:	af2080e7          	jalr	-1294(ra) # 80006348 <acquire>
    log.committing = 0;
    8000385e:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003862:	8526                	mv	a0,s1
    80003864:	ffffe097          	auipc	ra,0xffffe
    80003868:	f8a080e7          	jalr	-118(ra) # 800017ee <wakeup>
    release(&log.lock);
    8000386c:	8526                	mv	a0,s1
    8000386e:	00003097          	auipc	ra,0x3
    80003872:	b8e080e7          	jalr	-1138(ra) # 800063fc <release>
}
    80003876:	a03d                	j	800038a4 <end_op+0xaa>
    panic("log.committing");
    80003878:	00005517          	auipc	a0,0x5
    8000387c:	d4050513          	addi	a0,a0,-704 # 800085b8 <syscalls+0x1e0>
    80003880:	00002097          	auipc	ra,0x2
    80003884:	590080e7          	jalr	1424(ra) # 80005e10 <panic>
    wakeup(&log);
    80003888:	00235497          	auipc	s1,0x235
    8000388c:	7b048493          	addi	s1,s1,1968 # 80239038 <log>
    80003890:	8526                	mv	a0,s1
    80003892:	ffffe097          	auipc	ra,0xffffe
    80003896:	f5c080e7          	jalr	-164(ra) # 800017ee <wakeup>
  release(&log.lock);
    8000389a:	8526                	mv	a0,s1
    8000389c:	00003097          	auipc	ra,0x3
    800038a0:	b60080e7          	jalr	-1184(ra) # 800063fc <release>
}
    800038a4:	70e2                	ld	ra,56(sp)
    800038a6:	7442                	ld	s0,48(sp)
    800038a8:	74a2                	ld	s1,40(sp)
    800038aa:	7902                	ld	s2,32(sp)
    800038ac:	69e2                	ld	s3,24(sp)
    800038ae:	6a42                	ld	s4,16(sp)
    800038b0:	6aa2                	ld	s5,8(sp)
    800038b2:	6121                	addi	sp,sp,64
    800038b4:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800038b6:	00235a97          	auipc	s5,0x235
    800038ba:	7b2a8a93          	addi	s5,s5,1970 # 80239068 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800038be:	00235a17          	auipc	s4,0x235
    800038c2:	77aa0a13          	addi	s4,s4,1914 # 80239038 <log>
    800038c6:	018a2583          	lw	a1,24(s4)
    800038ca:	012585bb          	addw	a1,a1,s2
    800038ce:	2585                	addiw	a1,a1,1
    800038d0:	028a2503          	lw	a0,40(s4)
    800038d4:	fffff097          	auipc	ra,0xfffff
    800038d8:	cca080e7          	jalr	-822(ra) # 8000259e <bread>
    800038dc:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800038de:	000aa583          	lw	a1,0(s5)
    800038e2:	028a2503          	lw	a0,40(s4)
    800038e6:	fffff097          	auipc	ra,0xfffff
    800038ea:	cb8080e7          	jalr	-840(ra) # 8000259e <bread>
    800038ee:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800038f0:	40000613          	li	a2,1024
    800038f4:	05850593          	addi	a1,a0,88
    800038f8:	05848513          	addi	a0,s1,88
    800038fc:	ffffd097          	auipc	ra,0xffffd
    80003900:	a1e080e7          	jalr	-1506(ra) # 8000031a <memmove>
    bwrite(to);  // write the log
    80003904:	8526                	mv	a0,s1
    80003906:	fffff097          	auipc	ra,0xfffff
    8000390a:	d8a080e7          	jalr	-630(ra) # 80002690 <bwrite>
    brelse(from);
    8000390e:	854e                	mv	a0,s3
    80003910:	fffff097          	auipc	ra,0xfffff
    80003914:	dbe080e7          	jalr	-578(ra) # 800026ce <brelse>
    brelse(to);
    80003918:	8526                	mv	a0,s1
    8000391a:	fffff097          	auipc	ra,0xfffff
    8000391e:	db4080e7          	jalr	-588(ra) # 800026ce <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003922:	2905                	addiw	s2,s2,1
    80003924:	0a91                	addi	s5,s5,4
    80003926:	02ca2783          	lw	a5,44(s4)
    8000392a:	f8f94ee3          	blt	s2,a5,800038c6 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000392e:	00000097          	auipc	ra,0x0
    80003932:	c68080e7          	jalr	-920(ra) # 80003596 <write_head>
    install_trans(0); // Now install writes to home locations
    80003936:	4501                	li	a0,0
    80003938:	00000097          	auipc	ra,0x0
    8000393c:	cda080e7          	jalr	-806(ra) # 80003612 <install_trans>
    log.lh.n = 0;
    80003940:	00235797          	auipc	a5,0x235
    80003944:	7207a223          	sw	zero,1828(a5) # 80239064 <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003948:	00000097          	auipc	ra,0x0
    8000394c:	c4e080e7          	jalr	-946(ra) # 80003596 <write_head>
    80003950:	bdf5                	j	8000384c <end_op+0x52>

0000000080003952 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003952:	1101                	addi	sp,sp,-32
    80003954:	ec06                	sd	ra,24(sp)
    80003956:	e822                	sd	s0,16(sp)
    80003958:	e426                	sd	s1,8(sp)
    8000395a:	e04a                	sd	s2,0(sp)
    8000395c:	1000                	addi	s0,sp,32
    8000395e:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003960:	00235917          	auipc	s2,0x235
    80003964:	6d890913          	addi	s2,s2,1752 # 80239038 <log>
    80003968:	854a                	mv	a0,s2
    8000396a:	00003097          	auipc	ra,0x3
    8000396e:	9de080e7          	jalr	-1570(ra) # 80006348 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003972:	02c92603          	lw	a2,44(s2)
    80003976:	47f5                	li	a5,29
    80003978:	06c7c563          	blt	a5,a2,800039e2 <log_write+0x90>
    8000397c:	00235797          	auipc	a5,0x235
    80003980:	6d87a783          	lw	a5,1752(a5) # 80239054 <log+0x1c>
    80003984:	37fd                	addiw	a5,a5,-1
    80003986:	04f65e63          	bge	a2,a5,800039e2 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000398a:	00235797          	auipc	a5,0x235
    8000398e:	6ce7a783          	lw	a5,1742(a5) # 80239058 <log+0x20>
    80003992:	06f05063          	blez	a5,800039f2 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003996:	4781                	li	a5,0
    80003998:	06c05563          	blez	a2,80003a02 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000399c:	44cc                	lw	a1,12(s1)
    8000399e:	00235717          	auipc	a4,0x235
    800039a2:	6ca70713          	addi	a4,a4,1738 # 80239068 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800039a6:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800039a8:	4314                	lw	a3,0(a4)
    800039aa:	04b68c63          	beq	a3,a1,80003a02 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800039ae:	2785                	addiw	a5,a5,1
    800039b0:	0711                	addi	a4,a4,4
    800039b2:	fef61be3          	bne	a2,a5,800039a8 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800039b6:	0621                	addi	a2,a2,8
    800039b8:	060a                	slli	a2,a2,0x2
    800039ba:	00235797          	auipc	a5,0x235
    800039be:	67e78793          	addi	a5,a5,1662 # 80239038 <log>
    800039c2:	97b2                	add	a5,a5,a2
    800039c4:	44d8                	lw	a4,12(s1)
    800039c6:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800039c8:	8526                	mv	a0,s1
    800039ca:	fffff097          	auipc	ra,0xfffff
    800039ce:	da2080e7          	jalr	-606(ra) # 8000276c <bpin>
    log.lh.n++;
    800039d2:	00235717          	auipc	a4,0x235
    800039d6:	66670713          	addi	a4,a4,1638 # 80239038 <log>
    800039da:	575c                	lw	a5,44(a4)
    800039dc:	2785                	addiw	a5,a5,1
    800039de:	d75c                	sw	a5,44(a4)
    800039e0:	a82d                	j	80003a1a <log_write+0xc8>
    panic("too big a transaction");
    800039e2:	00005517          	auipc	a0,0x5
    800039e6:	be650513          	addi	a0,a0,-1050 # 800085c8 <syscalls+0x1f0>
    800039ea:	00002097          	auipc	ra,0x2
    800039ee:	426080e7          	jalr	1062(ra) # 80005e10 <panic>
    panic("log_write outside of trans");
    800039f2:	00005517          	auipc	a0,0x5
    800039f6:	bee50513          	addi	a0,a0,-1042 # 800085e0 <syscalls+0x208>
    800039fa:	00002097          	auipc	ra,0x2
    800039fe:	416080e7          	jalr	1046(ra) # 80005e10 <panic>
  log.lh.block[i] = b->blockno;
    80003a02:	00878693          	addi	a3,a5,8
    80003a06:	068a                	slli	a3,a3,0x2
    80003a08:	00235717          	auipc	a4,0x235
    80003a0c:	63070713          	addi	a4,a4,1584 # 80239038 <log>
    80003a10:	9736                	add	a4,a4,a3
    80003a12:	44d4                	lw	a3,12(s1)
    80003a14:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003a16:	faf609e3          	beq	a2,a5,800039c8 <log_write+0x76>
  }
  release(&log.lock);
    80003a1a:	00235517          	auipc	a0,0x235
    80003a1e:	61e50513          	addi	a0,a0,1566 # 80239038 <log>
    80003a22:	00003097          	auipc	ra,0x3
    80003a26:	9da080e7          	jalr	-1574(ra) # 800063fc <release>
}
    80003a2a:	60e2                	ld	ra,24(sp)
    80003a2c:	6442                	ld	s0,16(sp)
    80003a2e:	64a2                	ld	s1,8(sp)
    80003a30:	6902                	ld	s2,0(sp)
    80003a32:	6105                	addi	sp,sp,32
    80003a34:	8082                	ret

0000000080003a36 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003a36:	1101                	addi	sp,sp,-32
    80003a38:	ec06                	sd	ra,24(sp)
    80003a3a:	e822                	sd	s0,16(sp)
    80003a3c:	e426                	sd	s1,8(sp)
    80003a3e:	e04a                	sd	s2,0(sp)
    80003a40:	1000                	addi	s0,sp,32
    80003a42:	84aa                	mv	s1,a0
    80003a44:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003a46:	00005597          	auipc	a1,0x5
    80003a4a:	bba58593          	addi	a1,a1,-1094 # 80008600 <syscalls+0x228>
    80003a4e:	0521                	addi	a0,a0,8
    80003a50:	00003097          	auipc	ra,0x3
    80003a54:	868080e7          	jalr	-1944(ra) # 800062b8 <initlock>
  lk->name = name;
    80003a58:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003a5c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a60:	0204a423          	sw	zero,40(s1)
}
    80003a64:	60e2                	ld	ra,24(sp)
    80003a66:	6442                	ld	s0,16(sp)
    80003a68:	64a2                	ld	s1,8(sp)
    80003a6a:	6902                	ld	s2,0(sp)
    80003a6c:	6105                	addi	sp,sp,32
    80003a6e:	8082                	ret

0000000080003a70 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003a70:	1101                	addi	sp,sp,-32
    80003a72:	ec06                	sd	ra,24(sp)
    80003a74:	e822                	sd	s0,16(sp)
    80003a76:	e426                	sd	s1,8(sp)
    80003a78:	e04a                	sd	s2,0(sp)
    80003a7a:	1000                	addi	s0,sp,32
    80003a7c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a7e:	00850913          	addi	s2,a0,8
    80003a82:	854a                	mv	a0,s2
    80003a84:	00003097          	auipc	ra,0x3
    80003a88:	8c4080e7          	jalr	-1852(ra) # 80006348 <acquire>
  while (lk->locked) {
    80003a8c:	409c                	lw	a5,0(s1)
    80003a8e:	cb89                	beqz	a5,80003aa0 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003a90:	85ca                	mv	a1,s2
    80003a92:	8526                	mv	a0,s1
    80003a94:	ffffe097          	auipc	ra,0xffffe
    80003a98:	bce080e7          	jalr	-1074(ra) # 80001662 <sleep>
  while (lk->locked) {
    80003a9c:	409c                	lw	a5,0(s1)
    80003a9e:	fbed                	bnez	a5,80003a90 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003aa0:	4785                	li	a5,1
    80003aa2:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003aa4:	ffffd097          	auipc	ra,0xffffd
    80003aa8:	4fa080e7          	jalr	1274(ra) # 80000f9e <myproc>
    80003aac:	591c                	lw	a5,48(a0)
    80003aae:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003ab0:	854a                	mv	a0,s2
    80003ab2:	00003097          	auipc	ra,0x3
    80003ab6:	94a080e7          	jalr	-1718(ra) # 800063fc <release>
}
    80003aba:	60e2                	ld	ra,24(sp)
    80003abc:	6442                	ld	s0,16(sp)
    80003abe:	64a2                	ld	s1,8(sp)
    80003ac0:	6902                	ld	s2,0(sp)
    80003ac2:	6105                	addi	sp,sp,32
    80003ac4:	8082                	ret

0000000080003ac6 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003ac6:	1101                	addi	sp,sp,-32
    80003ac8:	ec06                	sd	ra,24(sp)
    80003aca:	e822                	sd	s0,16(sp)
    80003acc:	e426                	sd	s1,8(sp)
    80003ace:	e04a                	sd	s2,0(sp)
    80003ad0:	1000                	addi	s0,sp,32
    80003ad2:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003ad4:	00850913          	addi	s2,a0,8
    80003ad8:	854a                	mv	a0,s2
    80003ada:	00003097          	auipc	ra,0x3
    80003ade:	86e080e7          	jalr	-1938(ra) # 80006348 <acquire>
  lk->locked = 0;
    80003ae2:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003ae6:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003aea:	8526                	mv	a0,s1
    80003aec:	ffffe097          	auipc	ra,0xffffe
    80003af0:	d02080e7          	jalr	-766(ra) # 800017ee <wakeup>
  release(&lk->lk);
    80003af4:	854a                	mv	a0,s2
    80003af6:	00003097          	auipc	ra,0x3
    80003afa:	906080e7          	jalr	-1786(ra) # 800063fc <release>
}
    80003afe:	60e2                	ld	ra,24(sp)
    80003b00:	6442                	ld	s0,16(sp)
    80003b02:	64a2                	ld	s1,8(sp)
    80003b04:	6902                	ld	s2,0(sp)
    80003b06:	6105                	addi	sp,sp,32
    80003b08:	8082                	ret

0000000080003b0a <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003b0a:	7179                	addi	sp,sp,-48
    80003b0c:	f406                	sd	ra,40(sp)
    80003b0e:	f022                	sd	s0,32(sp)
    80003b10:	ec26                	sd	s1,24(sp)
    80003b12:	e84a                	sd	s2,16(sp)
    80003b14:	e44e                	sd	s3,8(sp)
    80003b16:	1800                	addi	s0,sp,48
    80003b18:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003b1a:	00850913          	addi	s2,a0,8
    80003b1e:	854a                	mv	a0,s2
    80003b20:	00003097          	auipc	ra,0x3
    80003b24:	828080e7          	jalr	-2008(ra) # 80006348 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003b28:	409c                	lw	a5,0(s1)
    80003b2a:	ef99                	bnez	a5,80003b48 <holdingsleep+0x3e>
    80003b2c:	4481                	li	s1,0
  release(&lk->lk);
    80003b2e:	854a                	mv	a0,s2
    80003b30:	00003097          	auipc	ra,0x3
    80003b34:	8cc080e7          	jalr	-1844(ra) # 800063fc <release>
  return r;
}
    80003b38:	8526                	mv	a0,s1
    80003b3a:	70a2                	ld	ra,40(sp)
    80003b3c:	7402                	ld	s0,32(sp)
    80003b3e:	64e2                	ld	s1,24(sp)
    80003b40:	6942                	ld	s2,16(sp)
    80003b42:	69a2                	ld	s3,8(sp)
    80003b44:	6145                	addi	sp,sp,48
    80003b46:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003b48:	0284a983          	lw	s3,40(s1)
    80003b4c:	ffffd097          	auipc	ra,0xffffd
    80003b50:	452080e7          	jalr	1106(ra) # 80000f9e <myproc>
    80003b54:	5904                	lw	s1,48(a0)
    80003b56:	413484b3          	sub	s1,s1,s3
    80003b5a:	0014b493          	seqz	s1,s1
    80003b5e:	bfc1                	j	80003b2e <holdingsleep+0x24>

0000000080003b60 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003b60:	1141                	addi	sp,sp,-16
    80003b62:	e406                	sd	ra,8(sp)
    80003b64:	e022                	sd	s0,0(sp)
    80003b66:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003b68:	00005597          	auipc	a1,0x5
    80003b6c:	aa858593          	addi	a1,a1,-1368 # 80008610 <syscalls+0x238>
    80003b70:	00235517          	auipc	a0,0x235
    80003b74:	61050513          	addi	a0,a0,1552 # 80239180 <ftable>
    80003b78:	00002097          	auipc	ra,0x2
    80003b7c:	740080e7          	jalr	1856(ra) # 800062b8 <initlock>
}
    80003b80:	60a2                	ld	ra,8(sp)
    80003b82:	6402                	ld	s0,0(sp)
    80003b84:	0141                	addi	sp,sp,16
    80003b86:	8082                	ret

0000000080003b88 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003b88:	1101                	addi	sp,sp,-32
    80003b8a:	ec06                	sd	ra,24(sp)
    80003b8c:	e822                	sd	s0,16(sp)
    80003b8e:	e426                	sd	s1,8(sp)
    80003b90:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003b92:	00235517          	auipc	a0,0x235
    80003b96:	5ee50513          	addi	a0,a0,1518 # 80239180 <ftable>
    80003b9a:	00002097          	auipc	ra,0x2
    80003b9e:	7ae080e7          	jalr	1966(ra) # 80006348 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003ba2:	00235497          	auipc	s1,0x235
    80003ba6:	5f648493          	addi	s1,s1,1526 # 80239198 <ftable+0x18>
    80003baa:	00236717          	auipc	a4,0x236
    80003bae:	58e70713          	addi	a4,a4,1422 # 8023a138 <ftable+0xfb8>
    if(f->ref == 0){
    80003bb2:	40dc                	lw	a5,4(s1)
    80003bb4:	cf99                	beqz	a5,80003bd2 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003bb6:	02848493          	addi	s1,s1,40
    80003bba:	fee49ce3          	bne	s1,a4,80003bb2 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003bbe:	00235517          	auipc	a0,0x235
    80003bc2:	5c250513          	addi	a0,a0,1474 # 80239180 <ftable>
    80003bc6:	00003097          	auipc	ra,0x3
    80003bca:	836080e7          	jalr	-1994(ra) # 800063fc <release>
  return 0;
    80003bce:	4481                	li	s1,0
    80003bd0:	a819                	j	80003be6 <filealloc+0x5e>
      f->ref = 1;
    80003bd2:	4785                	li	a5,1
    80003bd4:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003bd6:	00235517          	auipc	a0,0x235
    80003bda:	5aa50513          	addi	a0,a0,1450 # 80239180 <ftable>
    80003bde:	00003097          	auipc	ra,0x3
    80003be2:	81e080e7          	jalr	-2018(ra) # 800063fc <release>
}
    80003be6:	8526                	mv	a0,s1
    80003be8:	60e2                	ld	ra,24(sp)
    80003bea:	6442                	ld	s0,16(sp)
    80003bec:	64a2                	ld	s1,8(sp)
    80003bee:	6105                	addi	sp,sp,32
    80003bf0:	8082                	ret

0000000080003bf2 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003bf2:	1101                	addi	sp,sp,-32
    80003bf4:	ec06                	sd	ra,24(sp)
    80003bf6:	e822                	sd	s0,16(sp)
    80003bf8:	e426                	sd	s1,8(sp)
    80003bfa:	1000                	addi	s0,sp,32
    80003bfc:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003bfe:	00235517          	auipc	a0,0x235
    80003c02:	58250513          	addi	a0,a0,1410 # 80239180 <ftable>
    80003c06:	00002097          	auipc	ra,0x2
    80003c0a:	742080e7          	jalr	1858(ra) # 80006348 <acquire>
  if(f->ref < 1)
    80003c0e:	40dc                	lw	a5,4(s1)
    80003c10:	02f05263          	blez	a5,80003c34 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003c14:	2785                	addiw	a5,a5,1
    80003c16:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003c18:	00235517          	auipc	a0,0x235
    80003c1c:	56850513          	addi	a0,a0,1384 # 80239180 <ftable>
    80003c20:	00002097          	auipc	ra,0x2
    80003c24:	7dc080e7          	jalr	2012(ra) # 800063fc <release>
  return f;
}
    80003c28:	8526                	mv	a0,s1
    80003c2a:	60e2                	ld	ra,24(sp)
    80003c2c:	6442                	ld	s0,16(sp)
    80003c2e:	64a2                	ld	s1,8(sp)
    80003c30:	6105                	addi	sp,sp,32
    80003c32:	8082                	ret
    panic("filedup");
    80003c34:	00005517          	auipc	a0,0x5
    80003c38:	9e450513          	addi	a0,a0,-1564 # 80008618 <syscalls+0x240>
    80003c3c:	00002097          	auipc	ra,0x2
    80003c40:	1d4080e7          	jalr	468(ra) # 80005e10 <panic>

0000000080003c44 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003c44:	7139                	addi	sp,sp,-64
    80003c46:	fc06                	sd	ra,56(sp)
    80003c48:	f822                	sd	s0,48(sp)
    80003c4a:	f426                	sd	s1,40(sp)
    80003c4c:	f04a                	sd	s2,32(sp)
    80003c4e:	ec4e                	sd	s3,24(sp)
    80003c50:	e852                	sd	s4,16(sp)
    80003c52:	e456                	sd	s5,8(sp)
    80003c54:	0080                	addi	s0,sp,64
    80003c56:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003c58:	00235517          	auipc	a0,0x235
    80003c5c:	52850513          	addi	a0,a0,1320 # 80239180 <ftable>
    80003c60:	00002097          	auipc	ra,0x2
    80003c64:	6e8080e7          	jalr	1768(ra) # 80006348 <acquire>
  if(f->ref < 1)
    80003c68:	40dc                	lw	a5,4(s1)
    80003c6a:	06f05163          	blez	a5,80003ccc <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003c6e:	37fd                	addiw	a5,a5,-1
    80003c70:	0007871b          	sext.w	a4,a5
    80003c74:	c0dc                	sw	a5,4(s1)
    80003c76:	06e04363          	bgtz	a4,80003cdc <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003c7a:	0004a903          	lw	s2,0(s1)
    80003c7e:	0094ca83          	lbu	s5,9(s1)
    80003c82:	0104ba03          	ld	s4,16(s1)
    80003c86:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003c8a:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003c8e:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003c92:	00235517          	auipc	a0,0x235
    80003c96:	4ee50513          	addi	a0,a0,1262 # 80239180 <ftable>
    80003c9a:	00002097          	auipc	ra,0x2
    80003c9e:	762080e7          	jalr	1890(ra) # 800063fc <release>

  if(ff.type == FD_PIPE){
    80003ca2:	4785                	li	a5,1
    80003ca4:	04f90d63          	beq	s2,a5,80003cfe <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003ca8:	3979                	addiw	s2,s2,-2
    80003caa:	4785                	li	a5,1
    80003cac:	0527e063          	bltu	a5,s2,80003cec <fileclose+0xa8>
    begin_op();
    80003cb0:	00000097          	auipc	ra,0x0
    80003cb4:	acc080e7          	jalr	-1332(ra) # 8000377c <begin_op>
    iput(ff.ip);
    80003cb8:	854e                	mv	a0,s3
    80003cba:	fffff097          	auipc	ra,0xfffff
    80003cbe:	2a0080e7          	jalr	672(ra) # 80002f5a <iput>
    end_op();
    80003cc2:	00000097          	auipc	ra,0x0
    80003cc6:	b38080e7          	jalr	-1224(ra) # 800037fa <end_op>
    80003cca:	a00d                	j	80003cec <fileclose+0xa8>
    panic("fileclose");
    80003ccc:	00005517          	auipc	a0,0x5
    80003cd0:	95450513          	addi	a0,a0,-1708 # 80008620 <syscalls+0x248>
    80003cd4:	00002097          	auipc	ra,0x2
    80003cd8:	13c080e7          	jalr	316(ra) # 80005e10 <panic>
    release(&ftable.lock);
    80003cdc:	00235517          	auipc	a0,0x235
    80003ce0:	4a450513          	addi	a0,a0,1188 # 80239180 <ftable>
    80003ce4:	00002097          	auipc	ra,0x2
    80003ce8:	718080e7          	jalr	1816(ra) # 800063fc <release>
  }
}
    80003cec:	70e2                	ld	ra,56(sp)
    80003cee:	7442                	ld	s0,48(sp)
    80003cf0:	74a2                	ld	s1,40(sp)
    80003cf2:	7902                	ld	s2,32(sp)
    80003cf4:	69e2                	ld	s3,24(sp)
    80003cf6:	6a42                	ld	s4,16(sp)
    80003cf8:	6aa2                	ld	s5,8(sp)
    80003cfa:	6121                	addi	sp,sp,64
    80003cfc:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003cfe:	85d6                	mv	a1,s5
    80003d00:	8552                	mv	a0,s4
    80003d02:	00000097          	auipc	ra,0x0
    80003d06:	34c080e7          	jalr	844(ra) # 8000404e <pipeclose>
    80003d0a:	b7cd                	j	80003cec <fileclose+0xa8>

0000000080003d0c <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003d0c:	715d                	addi	sp,sp,-80
    80003d0e:	e486                	sd	ra,72(sp)
    80003d10:	e0a2                	sd	s0,64(sp)
    80003d12:	fc26                	sd	s1,56(sp)
    80003d14:	f84a                	sd	s2,48(sp)
    80003d16:	f44e                	sd	s3,40(sp)
    80003d18:	0880                	addi	s0,sp,80
    80003d1a:	84aa                	mv	s1,a0
    80003d1c:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003d1e:	ffffd097          	auipc	ra,0xffffd
    80003d22:	280080e7          	jalr	640(ra) # 80000f9e <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003d26:	409c                	lw	a5,0(s1)
    80003d28:	37f9                	addiw	a5,a5,-2
    80003d2a:	4705                	li	a4,1
    80003d2c:	04f76763          	bltu	a4,a5,80003d7a <filestat+0x6e>
    80003d30:	892a                	mv	s2,a0
    ilock(f->ip);
    80003d32:	6c88                	ld	a0,24(s1)
    80003d34:	fffff097          	auipc	ra,0xfffff
    80003d38:	06c080e7          	jalr	108(ra) # 80002da0 <ilock>
    stati(f->ip, &st);
    80003d3c:	fb840593          	addi	a1,s0,-72
    80003d40:	6c88                	ld	a0,24(s1)
    80003d42:	fffff097          	auipc	ra,0xfffff
    80003d46:	2e8080e7          	jalr	744(ra) # 8000302a <stati>
    iunlock(f->ip);
    80003d4a:	6c88                	ld	a0,24(s1)
    80003d4c:	fffff097          	auipc	ra,0xfffff
    80003d50:	116080e7          	jalr	278(ra) # 80002e62 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003d54:	46e1                	li	a3,24
    80003d56:	fb840613          	addi	a2,s0,-72
    80003d5a:	85ce                	mv	a1,s3
    80003d5c:	05093503          	ld	a0,80(s2)
    80003d60:	ffffd097          	auipc	ra,0xffffd
    80003d64:	ed4080e7          	jalr	-300(ra) # 80000c34 <copyout>
    80003d68:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003d6c:	60a6                	ld	ra,72(sp)
    80003d6e:	6406                	ld	s0,64(sp)
    80003d70:	74e2                	ld	s1,56(sp)
    80003d72:	7942                	ld	s2,48(sp)
    80003d74:	79a2                	ld	s3,40(sp)
    80003d76:	6161                	addi	sp,sp,80
    80003d78:	8082                	ret
  return -1;
    80003d7a:	557d                	li	a0,-1
    80003d7c:	bfc5                	j	80003d6c <filestat+0x60>

0000000080003d7e <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003d7e:	7179                	addi	sp,sp,-48
    80003d80:	f406                	sd	ra,40(sp)
    80003d82:	f022                	sd	s0,32(sp)
    80003d84:	ec26                	sd	s1,24(sp)
    80003d86:	e84a                	sd	s2,16(sp)
    80003d88:	e44e                	sd	s3,8(sp)
    80003d8a:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003d8c:	00854783          	lbu	a5,8(a0)
    80003d90:	c3d5                	beqz	a5,80003e34 <fileread+0xb6>
    80003d92:	84aa                	mv	s1,a0
    80003d94:	89ae                	mv	s3,a1
    80003d96:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d98:	411c                	lw	a5,0(a0)
    80003d9a:	4705                	li	a4,1
    80003d9c:	04e78963          	beq	a5,a4,80003dee <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003da0:	470d                	li	a4,3
    80003da2:	04e78d63          	beq	a5,a4,80003dfc <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003da6:	4709                	li	a4,2
    80003da8:	06e79e63          	bne	a5,a4,80003e24 <fileread+0xa6>
    ilock(f->ip);
    80003dac:	6d08                	ld	a0,24(a0)
    80003dae:	fffff097          	auipc	ra,0xfffff
    80003db2:	ff2080e7          	jalr	-14(ra) # 80002da0 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003db6:	874a                	mv	a4,s2
    80003db8:	5094                	lw	a3,32(s1)
    80003dba:	864e                	mv	a2,s3
    80003dbc:	4585                	li	a1,1
    80003dbe:	6c88                	ld	a0,24(s1)
    80003dc0:	fffff097          	auipc	ra,0xfffff
    80003dc4:	294080e7          	jalr	660(ra) # 80003054 <readi>
    80003dc8:	892a                	mv	s2,a0
    80003dca:	00a05563          	blez	a0,80003dd4 <fileread+0x56>
      f->off += r;
    80003dce:	509c                	lw	a5,32(s1)
    80003dd0:	9fa9                	addw	a5,a5,a0
    80003dd2:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003dd4:	6c88                	ld	a0,24(s1)
    80003dd6:	fffff097          	auipc	ra,0xfffff
    80003dda:	08c080e7          	jalr	140(ra) # 80002e62 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003dde:	854a                	mv	a0,s2
    80003de0:	70a2                	ld	ra,40(sp)
    80003de2:	7402                	ld	s0,32(sp)
    80003de4:	64e2                	ld	s1,24(sp)
    80003de6:	6942                	ld	s2,16(sp)
    80003de8:	69a2                	ld	s3,8(sp)
    80003dea:	6145                	addi	sp,sp,48
    80003dec:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003dee:	6908                	ld	a0,16(a0)
    80003df0:	00000097          	auipc	ra,0x0
    80003df4:	3c0080e7          	jalr	960(ra) # 800041b0 <piperead>
    80003df8:	892a                	mv	s2,a0
    80003dfa:	b7d5                	j	80003dde <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003dfc:	02451783          	lh	a5,36(a0)
    80003e00:	03079693          	slli	a3,a5,0x30
    80003e04:	92c1                	srli	a3,a3,0x30
    80003e06:	4725                	li	a4,9
    80003e08:	02d76863          	bltu	a4,a3,80003e38 <fileread+0xba>
    80003e0c:	0792                	slli	a5,a5,0x4
    80003e0e:	00235717          	auipc	a4,0x235
    80003e12:	2d270713          	addi	a4,a4,722 # 802390e0 <devsw>
    80003e16:	97ba                	add	a5,a5,a4
    80003e18:	639c                	ld	a5,0(a5)
    80003e1a:	c38d                	beqz	a5,80003e3c <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003e1c:	4505                	li	a0,1
    80003e1e:	9782                	jalr	a5
    80003e20:	892a                	mv	s2,a0
    80003e22:	bf75                	j	80003dde <fileread+0x60>
    panic("fileread");
    80003e24:	00005517          	auipc	a0,0x5
    80003e28:	80c50513          	addi	a0,a0,-2036 # 80008630 <syscalls+0x258>
    80003e2c:	00002097          	auipc	ra,0x2
    80003e30:	fe4080e7          	jalr	-28(ra) # 80005e10 <panic>
    return -1;
    80003e34:	597d                	li	s2,-1
    80003e36:	b765                	j	80003dde <fileread+0x60>
      return -1;
    80003e38:	597d                	li	s2,-1
    80003e3a:	b755                	j	80003dde <fileread+0x60>
    80003e3c:	597d                	li	s2,-1
    80003e3e:	b745                	j	80003dde <fileread+0x60>

0000000080003e40 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003e40:	715d                	addi	sp,sp,-80
    80003e42:	e486                	sd	ra,72(sp)
    80003e44:	e0a2                	sd	s0,64(sp)
    80003e46:	fc26                	sd	s1,56(sp)
    80003e48:	f84a                	sd	s2,48(sp)
    80003e4a:	f44e                	sd	s3,40(sp)
    80003e4c:	f052                	sd	s4,32(sp)
    80003e4e:	ec56                	sd	s5,24(sp)
    80003e50:	e85a                	sd	s6,16(sp)
    80003e52:	e45e                	sd	s7,8(sp)
    80003e54:	e062                	sd	s8,0(sp)
    80003e56:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003e58:	00954783          	lbu	a5,9(a0)
    80003e5c:	10078663          	beqz	a5,80003f68 <filewrite+0x128>
    80003e60:	892a                	mv	s2,a0
    80003e62:	8b2e                	mv	s6,a1
    80003e64:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003e66:	411c                	lw	a5,0(a0)
    80003e68:	4705                	li	a4,1
    80003e6a:	02e78263          	beq	a5,a4,80003e8e <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003e6e:	470d                	li	a4,3
    80003e70:	02e78663          	beq	a5,a4,80003e9c <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003e74:	4709                	li	a4,2
    80003e76:	0ee79163          	bne	a5,a4,80003f58 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003e7a:	0ac05d63          	blez	a2,80003f34 <filewrite+0xf4>
    int i = 0;
    80003e7e:	4981                	li	s3,0
    80003e80:	6b85                	lui	s7,0x1
    80003e82:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003e86:	6c05                	lui	s8,0x1
    80003e88:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003e8c:	a861                	j	80003f24 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003e8e:	6908                	ld	a0,16(a0)
    80003e90:	00000097          	auipc	ra,0x0
    80003e94:	22e080e7          	jalr	558(ra) # 800040be <pipewrite>
    80003e98:	8a2a                	mv	s4,a0
    80003e9a:	a045                	j	80003f3a <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003e9c:	02451783          	lh	a5,36(a0)
    80003ea0:	03079693          	slli	a3,a5,0x30
    80003ea4:	92c1                	srli	a3,a3,0x30
    80003ea6:	4725                	li	a4,9
    80003ea8:	0cd76263          	bltu	a4,a3,80003f6c <filewrite+0x12c>
    80003eac:	0792                	slli	a5,a5,0x4
    80003eae:	00235717          	auipc	a4,0x235
    80003eb2:	23270713          	addi	a4,a4,562 # 802390e0 <devsw>
    80003eb6:	97ba                	add	a5,a5,a4
    80003eb8:	679c                	ld	a5,8(a5)
    80003eba:	cbdd                	beqz	a5,80003f70 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003ebc:	4505                	li	a0,1
    80003ebe:	9782                	jalr	a5
    80003ec0:	8a2a                	mv	s4,a0
    80003ec2:	a8a5                	j	80003f3a <filewrite+0xfa>
    80003ec4:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003ec8:	00000097          	auipc	ra,0x0
    80003ecc:	8b4080e7          	jalr	-1868(ra) # 8000377c <begin_op>
      ilock(f->ip);
    80003ed0:	01893503          	ld	a0,24(s2)
    80003ed4:	fffff097          	auipc	ra,0xfffff
    80003ed8:	ecc080e7          	jalr	-308(ra) # 80002da0 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003edc:	8756                	mv	a4,s5
    80003ede:	02092683          	lw	a3,32(s2)
    80003ee2:	01698633          	add	a2,s3,s6
    80003ee6:	4585                	li	a1,1
    80003ee8:	01893503          	ld	a0,24(s2)
    80003eec:	fffff097          	auipc	ra,0xfffff
    80003ef0:	260080e7          	jalr	608(ra) # 8000314c <writei>
    80003ef4:	84aa                	mv	s1,a0
    80003ef6:	00a05763          	blez	a0,80003f04 <filewrite+0xc4>
        f->off += r;
    80003efa:	02092783          	lw	a5,32(s2)
    80003efe:	9fa9                	addw	a5,a5,a0
    80003f00:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003f04:	01893503          	ld	a0,24(s2)
    80003f08:	fffff097          	auipc	ra,0xfffff
    80003f0c:	f5a080e7          	jalr	-166(ra) # 80002e62 <iunlock>
      end_op();
    80003f10:	00000097          	auipc	ra,0x0
    80003f14:	8ea080e7          	jalr	-1814(ra) # 800037fa <end_op>

      if(r != n1){
    80003f18:	009a9f63          	bne	s5,s1,80003f36 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003f1c:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003f20:	0149db63          	bge	s3,s4,80003f36 <filewrite+0xf6>
      int n1 = n - i;
    80003f24:	413a04bb          	subw	s1,s4,s3
    80003f28:	0004879b          	sext.w	a5,s1
    80003f2c:	f8fbdce3          	bge	s7,a5,80003ec4 <filewrite+0x84>
    80003f30:	84e2                	mv	s1,s8
    80003f32:	bf49                	j	80003ec4 <filewrite+0x84>
    int i = 0;
    80003f34:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003f36:	013a1f63          	bne	s4,s3,80003f54 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003f3a:	8552                	mv	a0,s4
    80003f3c:	60a6                	ld	ra,72(sp)
    80003f3e:	6406                	ld	s0,64(sp)
    80003f40:	74e2                	ld	s1,56(sp)
    80003f42:	7942                	ld	s2,48(sp)
    80003f44:	79a2                	ld	s3,40(sp)
    80003f46:	7a02                	ld	s4,32(sp)
    80003f48:	6ae2                	ld	s5,24(sp)
    80003f4a:	6b42                	ld	s6,16(sp)
    80003f4c:	6ba2                	ld	s7,8(sp)
    80003f4e:	6c02                	ld	s8,0(sp)
    80003f50:	6161                	addi	sp,sp,80
    80003f52:	8082                	ret
    ret = (i == n ? n : -1);
    80003f54:	5a7d                	li	s4,-1
    80003f56:	b7d5                	j	80003f3a <filewrite+0xfa>
    panic("filewrite");
    80003f58:	00004517          	auipc	a0,0x4
    80003f5c:	6e850513          	addi	a0,a0,1768 # 80008640 <syscalls+0x268>
    80003f60:	00002097          	auipc	ra,0x2
    80003f64:	eb0080e7          	jalr	-336(ra) # 80005e10 <panic>
    return -1;
    80003f68:	5a7d                	li	s4,-1
    80003f6a:	bfc1                	j	80003f3a <filewrite+0xfa>
      return -1;
    80003f6c:	5a7d                	li	s4,-1
    80003f6e:	b7f1                	j	80003f3a <filewrite+0xfa>
    80003f70:	5a7d                	li	s4,-1
    80003f72:	b7e1                	j	80003f3a <filewrite+0xfa>

0000000080003f74 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003f74:	7179                	addi	sp,sp,-48
    80003f76:	f406                	sd	ra,40(sp)
    80003f78:	f022                	sd	s0,32(sp)
    80003f7a:	ec26                	sd	s1,24(sp)
    80003f7c:	e84a                	sd	s2,16(sp)
    80003f7e:	e44e                	sd	s3,8(sp)
    80003f80:	e052                	sd	s4,0(sp)
    80003f82:	1800                	addi	s0,sp,48
    80003f84:	84aa                	mv	s1,a0
    80003f86:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003f88:	0005b023          	sd	zero,0(a1)
    80003f8c:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003f90:	00000097          	auipc	ra,0x0
    80003f94:	bf8080e7          	jalr	-1032(ra) # 80003b88 <filealloc>
    80003f98:	e088                	sd	a0,0(s1)
    80003f9a:	c551                	beqz	a0,80004026 <pipealloc+0xb2>
    80003f9c:	00000097          	auipc	ra,0x0
    80003fa0:	bec080e7          	jalr	-1044(ra) # 80003b88 <filealloc>
    80003fa4:	00aa3023          	sd	a0,0(s4)
    80003fa8:	c92d                	beqz	a0,8000401a <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003faa:	ffffc097          	auipc	ra,0xffffc
    80003fae:	1fc080e7          	jalr	508(ra) # 800001a6 <kalloc>
    80003fb2:	892a                	mv	s2,a0
    80003fb4:	c125                	beqz	a0,80004014 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003fb6:	4985                	li	s3,1
    80003fb8:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003fbc:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003fc0:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003fc4:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003fc8:	00004597          	auipc	a1,0x4
    80003fcc:	68858593          	addi	a1,a1,1672 # 80008650 <syscalls+0x278>
    80003fd0:	00002097          	auipc	ra,0x2
    80003fd4:	2e8080e7          	jalr	744(ra) # 800062b8 <initlock>
  (*f0)->type = FD_PIPE;
    80003fd8:	609c                	ld	a5,0(s1)
    80003fda:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003fde:	609c                	ld	a5,0(s1)
    80003fe0:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003fe4:	609c                	ld	a5,0(s1)
    80003fe6:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003fea:	609c                	ld	a5,0(s1)
    80003fec:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003ff0:	000a3783          	ld	a5,0(s4)
    80003ff4:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003ff8:	000a3783          	ld	a5,0(s4)
    80003ffc:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004000:	000a3783          	ld	a5,0(s4)
    80004004:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004008:	000a3783          	ld	a5,0(s4)
    8000400c:	0127b823          	sd	s2,16(a5)
  return 0;
    80004010:	4501                	li	a0,0
    80004012:	a025                	j	8000403a <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004014:	6088                	ld	a0,0(s1)
    80004016:	e501                	bnez	a0,8000401e <pipealloc+0xaa>
    80004018:	a039                	j	80004026 <pipealloc+0xb2>
    8000401a:	6088                	ld	a0,0(s1)
    8000401c:	c51d                	beqz	a0,8000404a <pipealloc+0xd6>
    fileclose(*f0);
    8000401e:	00000097          	auipc	ra,0x0
    80004022:	c26080e7          	jalr	-986(ra) # 80003c44 <fileclose>
  if(*f1)
    80004026:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    8000402a:	557d                	li	a0,-1
  if(*f1)
    8000402c:	c799                	beqz	a5,8000403a <pipealloc+0xc6>
    fileclose(*f1);
    8000402e:	853e                	mv	a0,a5
    80004030:	00000097          	auipc	ra,0x0
    80004034:	c14080e7          	jalr	-1004(ra) # 80003c44 <fileclose>
  return -1;
    80004038:	557d                	li	a0,-1
}
    8000403a:	70a2                	ld	ra,40(sp)
    8000403c:	7402                	ld	s0,32(sp)
    8000403e:	64e2                	ld	s1,24(sp)
    80004040:	6942                	ld	s2,16(sp)
    80004042:	69a2                	ld	s3,8(sp)
    80004044:	6a02                	ld	s4,0(sp)
    80004046:	6145                	addi	sp,sp,48
    80004048:	8082                	ret
  return -1;
    8000404a:	557d                	li	a0,-1
    8000404c:	b7fd                	j	8000403a <pipealloc+0xc6>

000000008000404e <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    8000404e:	1101                	addi	sp,sp,-32
    80004050:	ec06                	sd	ra,24(sp)
    80004052:	e822                	sd	s0,16(sp)
    80004054:	e426                	sd	s1,8(sp)
    80004056:	e04a                	sd	s2,0(sp)
    80004058:	1000                	addi	s0,sp,32
    8000405a:	84aa                	mv	s1,a0
    8000405c:	892e                	mv	s2,a1
  acquire(&pi->lock);
    8000405e:	00002097          	auipc	ra,0x2
    80004062:	2ea080e7          	jalr	746(ra) # 80006348 <acquire>
  if(writable){
    80004066:	02090d63          	beqz	s2,800040a0 <pipeclose+0x52>
    pi->writeopen = 0;
    8000406a:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    8000406e:	21848513          	addi	a0,s1,536
    80004072:	ffffd097          	auipc	ra,0xffffd
    80004076:	77c080e7          	jalr	1916(ra) # 800017ee <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    8000407a:	2204b783          	ld	a5,544(s1)
    8000407e:	eb95                	bnez	a5,800040b2 <pipeclose+0x64>
    release(&pi->lock);
    80004080:	8526                	mv	a0,s1
    80004082:	00002097          	auipc	ra,0x2
    80004086:	37a080e7          	jalr	890(ra) # 800063fc <release>
    kfree((char*)pi);
    8000408a:	8526                	mv	a0,s1
    8000408c:	ffffc097          	auipc	ra,0xffffc
    80004090:	f90080e7          	jalr	-112(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80004094:	60e2                	ld	ra,24(sp)
    80004096:	6442                	ld	s0,16(sp)
    80004098:	64a2                	ld	s1,8(sp)
    8000409a:	6902                	ld	s2,0(sp)
    8000409c:	6105                	addi	sp,sp,32
    8000409e:	8082                	ret
    pi->readopen = 0;
    800040a0:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800040a4:	21c48513          	addi	a0,s1,540
    800040a8:	ffffd097          	auipc	ra,0xffffd
    800040ac:	746080e7          	jalr	1862(ra) # 800017ee <wakeup>
    800040b0:	b7e9                	j	8000407a <pipeclose+0x2c>
    release(&pi->lock);
    800040b2:	8526                	mv	a0,s1
    800040b4:	00002097          	auipc	ra,0x2
    800040b8:	348080e7          	jalr	840(ra) # 800063fc <release>
}
    800040bc:	bfe1                	j	80004094 <pipeclose+0x46>

00000000800040be <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800040be:	711d                	addi	sp,sp,-96
    800040c0:	ec86                	sd	ra,88(sp)
    800040c2:	e8a2                	sd	s0,80(sp)
    800040c4:	e4a6                	sd	s1,72(sp)
    800040c6:	e0ca                	sd	s2,64(sp)
    800040c8:	fc4e                	sd	s3,56(sp)
    800040ca:	f852                	sd	s4,48(sp)
    800040cc:	f456                	sd	s5,40(sp)
    800040ce:	f05a                	sd	s6,32(sp)
    800040d0:	ec5e                	sd	s7,24(sp)
    800040d2:	e862                	sd	s8,16(sp)
    800040d4:	1080                	addi	s0,sp,96
    800040d6:	84aa                	mv	s1,a0
    800040d8:	8aae                	mv	s5,a1
    800040da:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800040dc:	ffffd097          	auipc	ra,0xffffd
    800040e0:	ec2080e7          	jalr	-318(ra) # 80000f9e <myproc>
    800040e4:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800040e6:	8526                	mv	a0,s1
    800040e8:	00002097          	auipc	ra,0x2
    800040ec:	260080e7          	jalr	608(ra) # 80006348 <acquire>
  while(i < n){
    800040f0:	0b405363          	blez	s4,80004196 <pipewrite+0xd8>
  int i = 0;
    800040f4:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800040f6:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800040f8:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800040fc:	21c48b93          	addi	s7,s1,540
    80004100:	a089                	j	80004142 <pipewrite+0x84>
      release(&pi->lock);
    80004102:	8526                	mv	a0,s1
    80004104:	00002097          	auipc	ra,0x2
    80004108:	2f8080e7          	jalr	760(ra) # 800063fc <release>
      return -1;
    8000410c:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000410e:	854a                	mv	a0,s2
    80004110:	60e6                	ld	ra,88(sp)
    80004112:	6446                	ld	s0,80(sp)
    80004114:	64a6                	ld	s1,72(sp)
    80004116:	6906                	ld	s2,64(sp)
    80004118:	79e2                	ld	s3,56(sp)
    8000411a:	7a42                	ld	s4,48(sp)
    8000411c:	7aa2                	ld	s5,40(sp)
    8000411e:	7b02                	ld	s6,32(sp)
    80004120:	6be2                	ld	s7,24(sp)
    80004122:	6c42                	ld	s8,16(sp)
    80004124:	6125                	addi	sp,sp,96
    80004126:	8082                	ret
      wakeup(&pi->nread);
    80004128:	8562                	mv	a0,s8
    8000412a:	ffffd097          	auipc	ra,0xffffd
    8000412e:	6c4080e7          	jalr	1732(ra) # 800017ee <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004132:	85a6                	mv	a1,s1
    80004134:	855e                	mv	a0,s7
    80004136:	ffffd097          	auipc	ra,0xffffd
    8000413a:	52c080e7          	jalr	1324(ra) # 80001662 <sleep>
  while(i < n){
    8000413e:	05495d63          	bge	s2,s4,80004198 <pipewrite+0xda>
    if(pi->readopen == 0 || pr->killed){
    80004142:	2204a783          	lw	a5,544(s1)
    80004146:	dfd5                	beqz	a5,80004102 <pipewrite+0x44>
    80004148:	0289a783          	lw	a5,40(s3)
    8000414c:	fbdd                	bnez	a5,80004102 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000414e:	2184a783          	lw	a5,536(s1)
    80004152:	21c4a703          	lw	a4,540(s1)
    80004156:	2007879b          	addiw	a5,a5,512
    8000415a:	fcf707e3          	beq	a4,a5,80004128 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000415e:	4685                	li	a3,1
    80004160:	01590633          	add	a2,s2,s5
    80004164:	faf40593          	addi	a1,s0,-81
    80004168:	0509b503          	ld	a0,80(s3)
    8000416c:	ffffd097          	auipc	ra,0xffffd
    80004170:	b82080e7          	jalr	-1150(ra) # 80000cee <copyin>
    80004174:	03650263          	beq	a0,s6,80004198 <pipewrite+0xda>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004178:	21c4a783          	lw	a5,540(s1)
    8000417c:	0017871b          	addiw	a4,a5,1
    80004180:	20e4ae23          	sw	a4,540(s1)
    80004184:	1ff7f793          	andi	a5,a5,511
    80004188:	97a6                	add	a5,a5,s1
    8000418a:	faf44703          	lbu	a4,-81(s0)
    8000418e:	00e78c23          	sb	a4,24(a5)
      i++;
    80004192:	2905                	addiw	s2,s2,1
    80004194:	b76d                	j	8000413e <pipewrite+0x80>
  int i = 0;
    80004196:	4901                	li	s2,0
  wakeup(&pi->nread);
    80004198:	21848513          	addi	a0,s1,536
    8000419c:	ffffd097          	auipc	ra,0xffffd
    800041a0:	652080e7          	jalr	1618(ra) # 800017ee <wakeup>
  release(&pi->lock);
    800041a4:	8526                	mv	a0,s1
    800041a6:	00002097          	auipc	ra,0x2
    800041aa:	256080e7          	jalr	598(ra) # 800063fc <release>
  return i;
    800041ae:	b785                	j	8000410e <pipewrite+0x50>

00000000800041b0 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800041b0:	715d                	addi	sp,sp,-80
    800041b2:	e486                	sd	ra,72(sp)
    800041b4:	e0a2                	sd	s0,64(sp)
    800041b6:	fc26                	sd	s1,56(sp)
    800041b8:	f84a                	sd	s2,48(sp)
    800041ba:	f44e                	sd	s3,40(sp)
    800041bc:	f052                	sd	s4,32(sp)
    800041be:	ec56                	sd	s5,24(sp)
    800041c0:	e85a                	sd	s6,16(sp)
    800041c2:	0880                	addi	s0,sp,80
    800041c4:	84aa                	mv	s1,a0
    800041c6:	892e                	mv	s2,a1
    800041c8:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800041ca:	ffffd097          	auipc	ra,0xffffd
    800041ce:	dd4080e7          	jalr	-556(ra) # 80000f9e <myproc>
    800041d2:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800041d4:	8526                	mv	a0,s1
    800041d6:	00002097          	auipc	ra,0x2
    800041da:	172080e7          	jalr	370(ra) # 80006348 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041de:	2184a703          	lw	a4,536(s1)
    800041e2:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800041e6:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041ea:	02f71463          	bne	a4,a5,80004212 <piperead+0x62>
    800041ee:	2244a783          	lw	a5,548(s1)
    800041f2:	c385                	beqz	a5,80004212 <piperead+0x62>
    if(pr->killed){
    800041f4:	028a2783          	lw	a5,40(s4)
    800041f8:	ebc9                	bnez	a5,8000428a <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800041fa:	85a6                	mv	a1,s1
    800041fc:	854e                	mv	a0,s3
    800041fe:	ffffd097          	auipc	ra,0xffffd
    80004202:	464080e7          	jalr	1124(ra) # 80001662 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004206:	2184a703          	lw	a4,536(s1)
    8000420a:	21c4a783          	lw	a5,540(s1)
    8000420e:	fef700e3          	beq	a4,a5,800041ee <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004212:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004214:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004216:	05505463          	blez	s5,8000425e <piperead+0xae>
    if(pi->nread == pi->nwrite)
    8000421a:	2184a783          	lw	a5,536(s1)
    8000421e:	21c4a703          	lw	a4,540(s1)
    80004222:	02f70e63          	beq	a4,a5,8000425e <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004226:	0017871b          	addiw	a4,a5,1
    8000422a:	20e4ac23          	sw	a4,536(s1)
    8000422e:	1ff7f793          	andi	a5,a5,511
    80004232:	97a6                	add	a5,a5,s1
    80004234:	0187c783          	lbu	a5,24(a5)
    80004238:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000423c:	4685                	li	a3,1
    8000423e:	fbf40613          	addi	a2,s0,-65
    80004242:	85ca                	mv	a1,s2
    80004244:	050a3503          	ld	a0,80(s4)
    80004248:	ffffd097          	auipc	ra,0xffffd
    8000424c:	9ec080e7          	jalr	-1556(ra) # 80000c34 <copyout>
    80004250:	01650763          	beq	a0,s6,8000425e <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004254:	2985                	addiw	s3,s3,1
    80004256:	0905                	addi	s2,s2,1
    80004258:	fd3a91e3          	bne	s5,s3,8000421a <piperead+0x6a>
    8000425c:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000425e:	21c48513          	addi	a0,s1,540
    80004262:	ffffd097          	auipc	ra,0xffffd
    80004266:	58c080e7          	jalr	1420(ra) # 800017ee <wakeup>
  release(&pi->lock);
    8000426a:	8526                	mv	a0,s1
    8000426c:	00002097          	auipc	ra,0x2
    80004270:	190080e7          	jalr	400(ra) # 800063fc <release>
  return i;
}
    80004274:	854e                	mv	a0,s3
    80004276:	60a6                	ld	ra,72(sp)
    80004278:	6406                	ld	s0,64(sp)
    8000427a:	74e2                	ld	s1,56(sp)
    8000427c:	7942                	ld	s2,48(sp)
    8000427e:	79a2                	ld	s3,40(sp)
    80004280:	7a02                	ld	s4,32(sp)
    80004282:	6ae2                	ld	s5,24(sp)
    80004284:	6b42                	ld	s6,16(sp)
    80004286:	6161                	addi	sp,sp,80
    80004288:	8082                	ret
      release(&pi->lock);
    8000428a:	8526                	mv	a0,s1
    8000428c:	00002097          	auipc	ra,0x2
    80004290:	170080e7          	jalr	368(ra) # 800063fc <release>
      return -1;
    80004294:	59fd                	li	s3,-1
    80004296:	bff9                	j	80004274 <piperead+0xc4>

0000000080004298 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004298:	de010113          	addi	sp,sp,-544
    8000429c:	20113c23          	sd	ra,536(sp)
    800042a0:	20813823          	sd	s0,528(sp)
    800042a4:	20913423          	sd	s1,520(sp)
    800042a8:	21213023          	sd	s2,512(sp)
    800042ac:	ffce                	sd	s3,504(sp)
    800042ae:	fbd2                	sd	s4,496(sp)
    800042b0:	f7d6                	sd	s5,488(sp)
    800042b2:	f3da                	sd	s6,480(sp)
    800042b4:	efde                	sd	s7,472(sp)
    800042b6:	ebe2                	sd	s8,464(sp)
    800042b8:	e7e6                	sd	s9,456(sp)
    800042ba:	e3ea                	sd	s10,448(sp)
    800042bc:	ff6e                	sd	s11,440(sp)
    800042be:	1400                	addi	s0,sp,544
    800042c0:	892a                	mv	s2,a0
    800042c2:	dea43423          	sd	a0,-536(s0)
    800042c6:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800042ca:	ffffd097          	auipc	ra,0xffffd
    800042ce:	cd4080e7          	jalr	-812(ra) # 80000f9e <myproc>
    800042d2:	84aa                	mv	s1,a0

  begin_op();
    800042d4:	fffff097          	auipc	ra,0xfffff
    800042d8:	4a8080e7          	jalr	1192(ra) # 8000377c <begin_op>

  if((ip = namei(path)) == 0){
    800042dc:	854a                	mv	a0,s2
    800042de:	fffff097          	auipc	ra,0xfffff
    800042e2:	27e080e7          	jalr	638(ra) # 8000355c <namei>
    800042e6:	c93d                	beqz	a0,8000435c <exec+0xc4>
    800042e8:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800042ea:	fffff097          	auipc	ra,0xfffff
    800042ee:	ab6080e7          	jalr	-1354(ra) # 80002da0 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800042f2:	04000713          	li	a4,64
    800042f6:	4681                	li	a3,0
    800042f8:	e5040613          	addi	a2,s0,-432
    800042fc:	4581                	li	a1,0
    800042fe:	8556                	mv	a0,s5
    80004300:	fffff097          	auipc	ra,0xfffff
    80004304:	d54080e7          	jalr	-684(ra) # 80003054 <readi>
    80004308:	04000793          	li	a5,64
    8000430c:	00f51a63          	bne	a0,a5,80004320 <exec+0x88>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004310:	e5042703          	lw	a4,-432(s0)
    80004314:	464c47b7          	lui	a5,0x464c4
    80004318:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000431c:	04f70663          	beq	a4,a5,80004368 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004320:	8556                	mv	a0,s5
    80004322:	fffff097          	auipc	ra,0xfffff
    80004326:	ce0080e7          	jalr	-800(ra) # 80003002 <iunlockput>
    end_op();
    8000432a:	fffff097          	auipc	ra,0xfffff
    8000432e:	4d0080e7          	jalr	1232(ra) # 800037fa <end_op>
  }
  return -1;
    80004332:	557d                	li	a0,-1
}
    80004334:	21813083          	ld	ra,536(sp)
    80004338:	21013403          	ld	s0,528(sp)
    8000433c:	20813483          	ld	s1,520(sp)
    80004340:	20013903          	ld	s2,512(sp)
    80004344:	79fe                	ld	s3,504(sp)
    80004346:	7a5e                	ld	s4,496(sp)
    80004348:	7abe                	ld	s5,488(sp)
    8000434a:	7b1e                	ld	s6,480(sp)
    8000434c:	6bfe                	ld	s7,472(sp)
    8000434e:	6c5e                	ld	s8,464(sp)
    80004350:	6cbe                	ld	s9,456(sp)
    80004352:	6d1e                	ld	s10,448(sp)
    80004354:	7dfa                	ld	s11,440(sp)
    80004356:	22010113          	addi	sp,sp,544
    8000435a:	8082                	ret
    end_op();
    8000435c:	fffff097          	auipc	ra,0xfffff
    80004360:	49e080e7          	jalr	1182(ra) # 800037fa <end_op>
    return -1;
    80004364:	557d                	li	a0,-1
    80004366:	b7f9                	j	80004334 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    80004368:	8526                	mv	a0,s1
    8000436a:	ffffd097          	auipc	ra,0xffffd
    8000436e:	cf8080e7          	jalr	-776(ra) # 80001062 <proc_pagetable>
    80004372:	8b2a                	mv	s6,a0
    80004374:	d555                	beqz	a0,80004320 <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004376:	e7042783          	lw	a5,-400(s0)
    8000437a:	e8845703          	lhu	a4,-376(s0)
    8000437e:	c735                	beqz	a4,800043ea <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004380:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004382:	e0043423          	sd	zero,-504(s0)
    if((ph.vaddr % PGSIZE) != 0)
    80004386:	6a05                	lui	s4,0x1
    80004388:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    8000438c:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    80004390:	6d85                	lui	s11,0x1
    80004392:	7d7d                	lui	s10,0xfffff
    80004394:	ac1d                	j	800045ca <exec+0x332>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004396:	00004517          	auipc	a0,0x4
    8000439a:	2c250513          	addi	a0,a0,706 # 80008658 <syscalls+0x280>
    8000439e:	00002097          	auipc	ra,0x2
    800043a2:	a72080e7          	jalr	-1422(ra) # 80005e10 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800043a6:	874a                	mv	a4,s2
    800043a8:	009c86bb          	addw	a3,s9,s1
    800043ac:	4581                	li	a1,0
    800043ae:	8556                	mv	a0,s5
    800043b0:	fffff097          	auipc	ra,0xfffff
    800043b4:	ca4080e7          	jalr	-860(ra) # 80003054 <readi>
    800043b8:	2501                	sext.w	a0,a0
    800043ba:	1aa91863          	bne	s2,a0,8000456a <exec+0x2d2>
  for(i = 0; i < sz; i += PGSIZE){
    800043be:	009d84bb          	addw	s1,s11,s1
    800043c2:	013d09bb          	addw	s3,s10,s3
    800043c6:	1f74f263          	bgeu	s1,s7,800045aa <exec+0x312>
    pa = walkaddr(pagetable, va + i);
    800043ca:	02049593          	slli	a1,s1,0x20
    800043ce:	9181                	srli	a1,a1,0x20
    800043d0:	95e2                	add	a1,a1,s8
    800043d2:	855a                	mv	a0,s6
    800043d4:	ffffc097          	auipc	ra,0xffffc
    800043d8:	270080e7          	jalr	624(ra) # 80000644 <walkaddr>
    800043dc:	862a                	mv	a2,a0
    if(pa == 0)
    800043de:	dd45                	beqz	a0,80004396 <exec+0xfe>
      n = PGSIZE;
    800043e0:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    800043e2:	fd49f2e3          	bgeu	s3,s4,800043a6 <exec+0x10e>
      n = sz - i;
    800043e6:	894e                	mv	s2,s3
    800043e8:	bf7d                	j	800043a6 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800043ea:	4481                	li	s1,0
  iunlockput(ip);
    800043ec:	8556                	mv	a0,s5
    800043ee:	fffff097          	auipc	ra,0xfffff
    800043f2:	c14080e7          	jalr	-1004(ra) # 80003002 <iunlockput>
  end_op();
    800043f6:	fffff097          	auipc	ra,0xfffff
    800043fa:	404080e7          	jalr	1028(ra) # 800037fa <end_op>
  p = myproc();
    800043fe:	ffffd097          	auipc	ra,0xffffd
    80004402:	ba0080e7          	jalr	-1120(ra) # 80000f9e <myproc>
    80004406:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80004408:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    8000440c:	6785                	lui	a5,0x1
    8000440e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80004410:	97a6                	add	a5,a5,s1
    80004412:	777d                	lui	a4,0xfffff
    80004414:	8ff9                	and	a5,a5,a4
    80004416:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000441a:	6609                	lui	a2,0x2
    8000441c:	963e                	add	a2,a2,a5
    8000441e:	85be                	mv	a1,a5
    80004420:	855a                	mv	a0,s6
    80004422:	ffffc097          	auipc	ra,0xffffc
    80004426:	5d6080e7          	jalr	1494(ra) # 800009f8 <uvmalloc>
    8000442a:	8c2a                	mv	s8,a0
  ip = 0;
    8000442c:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000442e:	12050e63          	beqz	a0,8000456a <exec+0x2d2>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004432:	75f9                	lui	a1,0xffffe
    80004434:	95aa                	add	a1,a1,a0
    80004436:	855a                	mv	a0,s6
    80004438:	ffffc097          	auipc	ra,0xffffc
    8000443c:	7ca080e7          	jalr	1994(ra) # 80000c02 <uvmclear>
  stackbase = sp - PGSIZE;
    80004440:	7afd                	lui	s5,0xfffff
    80004442:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    80004444:	df043783          	ld	a5,-528(s0)
    80004448:	6388                	ld	a0,0(a5)
    8000444a:	c925                	beqz	a0,800044ba <exec+0x222>
    8000444c:	e9040993          	addi	s3,s0,-368
    80004450:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004454:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004456:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004458:	ffffc097          	auipc	ra,0xffffc
    8000445c:	fe2080e7          	jalr	-30(ra) # 8000043a <strlen>
    80004460:	0015079b          	addiw	a5,a0,1
    80004464:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004468:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    8000446c:	13596363          	bltu	s2,s5,80004592 <exec+0x2fa>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004470:	df043d83          	ld	s11,-528(s0)
    80004474:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80004478:	8552                	mv	a0,s4
    8000447a:	ffffc097          	auipc	ra,0xffffc
    8000447e:	fc0080e7          	jalr	-64(ra) # 8000043a <strlen>
    80004482:	0015069b          	addiw	a3,a0,1
    80004486:	8652                	mv	a2,s4
    80004488:	85ca                	mv	a1,s2
    8000448a:	855a                	mv	a0,s6
    8000448c:	ffffc097          	auipc	ra,0xffffc
    80004490:	7a8080e7          	jalr	1960(ra) # 80000c34 <copyout>
    80004494:	10054363          	bltz	a0,8000459a <exec+0x302>
    ustack[argc] = sp;
    80004498:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000449c:	0485                	addi	s1,s1,1
    8000449e:	008d8793          	addi	a5,s11,8
    800044a2:	def43823          	sd	a5,-528(s0)
    800044a6:	008db503          	ld	a0,8(s11)
    800044aa:	c911                	beqz	a0,800044be <exec+0x226>
    if(argc >= MAXARG)
    800044ac:	09a1                	addi	s3,s3,8
    800044ae:	fb3c95e3          	bne	s9,s3,80004458 <exec+0x1c0>
  sz = sz1;
    800044b2:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800044b6:	4a81                	li	s5,0
    800044b8:	a84d                	j	8000456a <exec+0x2d2>
  sp = sz;
    800044ba:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800044bc:	4481                	li	s1,0
  ustack[argc] = 0;
    800044be:	00349793          	slli	a5,s1,0x3
    800044c2:	f9078793          	addi	a5,a5,-112
    800044c6:	97a2                	add	a5,a5,s0
    800044c8:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800044cc:	00148693          	addi	a3,s1,1
    800044d0:	068e                	slli	a3,a3,0x3
    800044d2:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800044d6:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800044da:	01597663          	bgeu	s2,s5,800044e6 <exec+0x24e>
  sz = sz1;
    800044de:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800044e2:	4a81                	li	s5,0
    800044e4:	a059                	j	8000456a <exec+0x2d2>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800044e6:	e9040613          	addi	a2,s0,-368
    800044ea:	85ca                	mv	a1,s2
    800044ec:	855a                	mv	a0,s6
    800044ee:	ffffc097          	auipc	ra,0xffffc
    800044f2:	746080e7          	jalr	1862(ra) # 80000c34 <copyout>
    800044f6:	0a054663          	bltz	a0,800045a2 <exec+0x30a>
  p->trapframe->a1 = sp;
    800044fa:	058bb783          	ld	a5,88(s7)
    800044fe:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004502:	de843783          	ld	a5,-536(s0)
    80004506:	0007c703          	lbu	a4,0(a5)
    8000450a:	cf11                	beqz	a4,80004526 <exec+0x28e>
    8000450c:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000450e:	02f00693          	li	a3,47
    80004512:	a039                	j	80004520 <exec+0x288>
      last = s+1;
    80004514:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80004518:	0785                	addi	a5,a5,1
    8000451a:	fff7c703          	lbu	a4,-1(a5)
    8000451e:	c701                	beqz	a4,80004526 <exec+0x28e>
    if(*s == '/')
    80004520:	fed71ce3          	bne	a4,a3,80004518 <exec+0x280>
    80004524:	bfc5                	j	80004514 <exec+0x27c>
  safestrcpy(p->name, last, sizeof(p->name));
    80004526:	4641                	li	a2,16
    80004528:	de843583          	ld	a1,-536(s0)
    8000452c:	158b8513          	addi	a0,s7,344
    80004530:	ffffc097          	auipc	ra,0xffffc
    80004534:	ed8080e7          	jalr	-296(ra) # 80000408 <safestrcpy>
  oldpagetable = p->pagetable;
    80004538:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    8000453c:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    80004540:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004544:	058bb783          	ld	a5,88(s7)
    80004548:	e6843703          	ld	a4,-408(s0)
    8000454c:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000454e:	058bb783          	ld	a5,88(s7)
    80004552:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004556:	85ea                	mv	a1,s10
    80004558:	ffffd097          	auipc	ra,0xffffd
    8000455c:	ba6080e7          	jalr	-1114(ra) # 800010fe <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004560:	0004851b          	sext.w	a0,s1
    80004564:	bbc1                	j	80004334 <exec+0x9c>
    80004566:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    8000456a:	df843583          	ld	a1,-520(s0)
    8000456e:	855a                	mv	a0,s6
    80004570:	ffffd097          	auipc	ra,0xffffd
    80004574:	b8e080e7          	jalr	-1138(ra) # 800010fe <proc_freepagetable>
  if(ip){
    80004578:	da0a94e3          	bnez	s5,80004320 <exec+0x88>
  return -1;
    8000457c:	557d                	li	a0,-1
    8000457e:	bb5d                	j	80004334 <exec+0x9c>
    80004580:	de943c23          	sd	s1,-520(s0)
    80004584:	b7dd                	j	8000456a <exec+0x2d2>
    80004586:	de943c23          	sd	s1,-520(s0)
    8000458a:	b7c5                	j	8000456a <exec+0x2d2>
    8000458c:	de943c23          	sd	s1,-520(s0)
    80004590:	bfe9                	j	8000456a <exec+0x2d2>
  sz = sz1;
    80004592:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004596:	4a81                	li	s5,0
    80004598:	bfc9                	j	8000456a <exec+0x2d2>
  sz = sz1;
    8000459a:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000459e:	4a81                	li	s5,0
    800045a0:	b7e9                	j	8000456a <exec+0x2d2>
  sz = sz1;
    800045a2:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800045a6:	4a81                	li	s5,0
    800045a8:	b7c9                	j	8000456a <exec+0x2d2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800045aa:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800045ae:	e0843783          	ld	a5,-504(s0)
    800045b2:	0017869b          	addiw	a3,a5,1
    800045b6:	e0d43423          	sd	a3,-504(s0)
    800045ba:	e0043783          	ld	a5,-512(s0)
    800045be:	0387879b          	addiw	a5,a5,56
    800045c2:	e8845703          	lhu	a4,-376(s0)
    800045c6:	e2e6d3e3          	bge	a3,a4,800043ec <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800045ca:	2781                	sext.w	a5,a5
    800045cc:	e0f43023          	sd	a5,-512(s0)
    800045d0:	03800713          	li	a4,56
    800045d4:	86be                	mv	a3,a5
    800045d6:	e1840613          	addi	a2,s0,-488
    800045da:	4581                	li	a1,0
    800045dc:	8556                	mv	a0,s5
    800045de:	fffff097          	auipc	ra,0xfffff
    800045e2:	a76080e7          	jalr	-1418(ra) # 80003054 <readi>
    800045e6:	03800793          	li	a5,56
    800045ea:	f6f51ee3          	bne	a0,a5,80004566 <exec+0x2ce>
    if(ph.type != ELF_PROG_LOAD)
    800045ee:	e1842783          	lw	a5,-488(s0)
    800045f2:	4705                	li	a4,1
    800045f4:	fae79de3          	bne	a5,a4,800045ae <exec+0x316>
    if(ph.memsz < ph.filesz)
    800045f8:	e4043603          	ld	a2,-448(s0)
    800045fc:	e3843783          	ld	a5,-456(s0)
    80004600:	f8f660e3          	bltu	a2,a5,80004580 <exec+0x2e8>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004604:	e2843783          	ld	a5,-472(s0)
    80004608:	963e                	add	a2,a2,a5
    8000460a:	f6f66ee3          	bltu	a2,a5,80004586 <exec+0x2ee>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000460e:	85a6                	mv	a1,s1
    80004610:	855a                	mv	a0,s6
    80004612:	ffffc097          	auipc	ra,0xffffc
    80004616:	3e6080e7          	jalr	998(ra) # 800009f8 <uvmalloc>
    8000461a:	dea43c23          	sd	a0,-520(s0)
    8000461e:	d53d                	beqz	a0,8000458c <exec+0x2f4>
    if((ph.vaddr % PGSIZE) != 0)
    80004620:	e2843c03          	ld	s8,-472(s0)
    80004624:	de043783          	ld	a5,-544(s0)
    80004628:	00fc77b3          	and	a5,s8,a5
    8000462c:	ff9d                	bnez	a5,8000456a <exec+0x2d2>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000462e:	e2042c83          	lw	s9,-480(s0)
    80004632:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004636:	f60b8ae3          	beqz	s7,800045aa <exec+0x312>
    8000463a:	89de                	mv	s3,s7
    8000463c:	4481                	li	s1,0
    8000463e:	b371                	j	800043ca <exec+0x132>

0000000080004640 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004640:	7179                	addi	sp,sp,-48
    80004642:	f406                	sd	ra,40(sp)
    80004644:	f022                	sd	s0,32(sp)
    80004646:	ec26                	sd	s1,24(sp)
    80004648:	e84a                	sd	s2,16(sp)
    8000464a:	1800                	addi	s0,sp,48
    8000464c:	892e                	mv	s2,a1
    8000464e:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004650:	fdc40593          	addi	a1,s0,-36
    80004654:	ffffe097          	auipc	ra,0xffffe
    80004658:	bda080e7          	jalr	-1062(ra) # 8000222e <argint>
    8000465c:	04054063          	bltz	a0,8000469c <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004660:	fdc42703          	lw	a4,-36(s0)
    80004664:	47bd                	li	a5,15
    80004666:	02e7ed63          	bltu	a5,a4,800046a0 <argfd+0x60>
    8000466a:	ffffd097          	auipc	ra,0xffffd
    8000466e:	934080e7          	jalr	-1740(ra) # 80000f9e <myproc>
    80004672:	fdc42703          	lw	a4,-36(s0)
    80004676:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7fdb8dda>
    8000467a:	078e                	slli	a5,a5,0x3
    8000467c:	953e                	add	a0,a0,a5
    8000467e:	611c                	ld	a5,0(a0)
    80004680:	c395                	beqz	a5,800046a4 <argfd+0x64>
    return -1;
  if(pfd)
    80004682:	00090463          	beqz	s2,8000468a <argfd+0x4a>
    *pfd = fd;
    80004686:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000468a:	4501                	li	a0,0
  if(pf)
    8000468c:	c091                	beqz	s1,80004690 <argfd+0x50>
    *pf = f;
    8000468e:	e09c                	sd	a5,0(s1)
}
    80004690:	70a2                	ld	ra,40(sp)
    80004692:	7402                	ld	s0,32(sp)
    80004694:	64e2                	ld	s1,24(sp)
    80004696:	6942                	ld	s2,16(sp)
    80004698:	6145                	addi	sp,sp,48
    8000469a:	8082                	ret
    return -1;
    8000469c:	557d                	li	a0,-1
    8000469e:	bfcd                	j	80004690 <argfd+0x50>
    return -1;
    800046a0:	557d                	li	a0,-1
    800046a2:	b7fd                	j	80004690 <argfd+0x50>
    800046a4:	557d                	li	a0,-1
    800046a6:	b7ed                	j	80004690 <argfd+0x50>

00000000800046a8 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800046a8:	1101                	addi	sp,sp,-32
    800046aa:	ec06                	sd	ra,24(sp)
    800046ac:	e822                	sd	s0,16(sp)
    800046ae:	e426                	sd	s1,8(sp)
    800046b0:	1000                	addi	s0,sp,32
    800046b2:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800046b4:	ffffd097          	auipc	ra,0xffffd
    800046b8:	8ea080e7          	jalr	-1814(ra) # 80000f9e <myproc>
    800046bc:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800046be:	0d050793          	addi	a5,a0,208
    800046c2:	4501                	li	a0,0
    800046c4:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800046c6:	6398                	ld	a4,0(a5)
    800046c8:	cb19                	beqz	a4,800046de <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800046ca:	2505                	addiw	a0,a0,1
    800046cc:	07a1                	addi	a5,a5,8
    800046ce:	fed51ce3          	bne	a0,a3,800046c6 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800046d2:	557d                	li	a0,-1
}
    800046d4:	60e2                	ld	ra,24(sp)
    800046d6:	6442                	ld	s0,16(sp)
    800046d8:	64a2                	ld	s1,8(sp)
    800046da:	6105                	addi	sp,sp,32
    800046dc:	8082                	ret
      p->ofile[fd] = f;
    800046de:	01a50793          	addi	a5,a0,26
    800046e2:	078e                	slli	a5,a5,0x3
    800046e4:	963e                	add	a2,a2,a5
    800046e6:	e204                	sd	s1,0(a2)
      return fd;
    800046e8:	b7f5                	j	800046d4 <fdalloc+0x2c>

00000000800046ea <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800046ea:	715d                	addi	sp,sp,-80
    800046ec:	e486                	sd	ra,72(sp)
    800046ee:	e0a2                	sd	s0,64(sp)
    800046f0:	fc26                	sd	s1,56(sp)
    800046f2:	f84a                	sd	s2,48(sp)
    800046f4:	f44e                	sd	s3,40(sp)
    800046f6:	f052                	sd	s4,32(sp)
    800046f8:	ec56                	sd	s5,24(sp)
    800046fa:	0880                	addi	s0,sp,80
    800046fc:	89ae                	mv	s3,a1
    800046fe:	8ab2                	mv	s5,a2
    80004700:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004702:	fb040593          	addi	a1,s0,-80
    80004706:	fffff097          	auipc	ra,0xfffff
    8000470a:	e74080e7          	jalr	-396(ra) # 8000357a <nameiparent>
    8000470e:	892a                	mv	s2,a0
    80004710:	12050e63          	beqz	a0,8000484c <create+0x162>
    return 0;

  ilock(dp);
    80004714:	ffffe097          	auipc	ra,0xffffe
    80004718:	68c080e7          	jalr	1676(ra) # 80002da0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000471c:	4601                	li	a2,0
    8000471e:	fb040593          	addi	a1,s0,-80
    80004722:	854a                	mv	a0,s2
    80004724:	fffff097          	auipc	ra,0xfffff
    80004728:	b60080e7          	jalr	-1184(ra) # 80003284 <dirlookup>
    8000472c:	84aa                	mv	s1,a0
    8000472e:	c921                	beqz	a0,8000477e <create+0x94>
    iunlockput(dp);
    80004730:	854a                	mv	a0,s2
    80004732:	fffff097          	auipc	ra,0xfffff
    80004736:	8d0080e7          	jalr	-1840(ra) # 80003002 <iunlockput>
    ilock(ip);
    8000473a:	8526                	mv	a0,s1
    8000473c:	ffffe097          	auipc	ra,0xffffe
    80004740:	664080e7          	jalr	1636(ra) # 80002da0 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004744:	2981                	sext.w	s3,s3
    80004746:	4789                	li	a5,2
    80004748:	02f99463          	bne	s3,a5,80004770 <create+0x86>
    8000474c:	0444d783          	lhu	a5,68(s1)
    80004750:	37f9                	addiw	a5,a5,-2
    80004752:	17c2                	slli	a5,a5,0x30
    80004754:	93c1                	srli	a5,a5,0x30
    80004756:	4705                	li	a4,1
    80004758:	00f76c63          	bltu	a4,a5,80004770 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    8000475c:	8526                	mv	a0,s1
    8000475e:	60a6                	ld	ra,72(sp)
    80004760:	6406                	ld	s0,64(sp)
    80004762:	74e2                	ld	s1,56(sp)
    80004764:	7942                	ld	s2,48(sp)
    80004766:	79a2                	ld	s3,40(sp)
    80004768:	7a02                	ld	s4,32(sp)
    8000476a:	6ae2                	ld	s5,24(sp)
    8000476c:	6161                	addi	sp,sp,80
    8000476e:	8082                	ret
    iunlockput(ip);
    80004770:	8526                	mv	a0,s1
    80004772:	fffff097          	auipc	ra,0xfffff
    80004776:	890080e7          	jalr	-1904(ra) # 80003002 <iunlockput>
    return 0;
    8000477a:	4481                	li	s1,0
    8000477c:	b7c5                	j	8000475c <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    8000477e:	85ce                	mv	a1,s3
    80004780:	00092503          	lw	a0,0(s2)
    80004784:	ffffe097          	auipc	ra,0xffffe
    80004788:	482080e7          	jalr	1154(ra) # 80002c06 <ialloc>
    8000478c:	84aa                	mv	s1,a0
    8000478e:	c521                	beqz	a0,800047d6 <create+0xec>
  ilock(ip);
    80004790:	ffffe097          	auipc	ra,0xffffe
    80004794:	610080e7          	jalr	1552(ra) # 80002da0 <ilock>
  ip->major = major;
    80004798:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    8000479c:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    800047a0:	4a05                	li	s4,1
    800047a2:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    800047a6:	8526                	mv	a0,s1
    800047a8:	ffffe097          	auipc	ra,0xffffe
    800047ac:	52c080e7          	jalr	1324(ra) # 80002cd4 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800047b0:	2981                	sext.w	s3,s3
    800047b2:	03498a63          	beq	s3,s4,800047e6 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    800047b6:	40d0                	lw	a2,4(s1)
    800047b8:	fb040593          	addi	a1,s0,-80
    800047bc:	854a                	mv	a0,s2
    800047be:	fffff097          	auipc	ra,0xfffff
    800047c2:	cdc080e7          	jalr	-804(ra) # 8000349a <dirlink>
    800047c6:	06054b63          	bltz	a0,8000483c <create+0x152>
  iunlockput(dp);
    800047ca:	854a                	mv	a0,s2
    800047cc:	fffff097          	auipc	ra,0xfffff
    800047d0:	836080e7          	jalr	-1994(ra) # 80003002 <iunlockput>
  return ip;
    800047d4:	b761                	j	8000475c <create+0x72>
    panic("create: ialloc");
    800047d6:	00004517          	auipc	a0,0x4
    800047da:	ea250513          	addi	a0,a0,-350 # 80008678 <syscalls+0x2a0>
    800047de:	00001097          	auipc	ra,0x1
    800047e2:	632080e7          	jalr	1586(ra) # 80005e10 <panic>
    dp->nlink++;  // for ".."
    800047e6:	04a95783          	lhu	a5,74(s2)
    800047ea:	2785                	addiw	a5,a5,1
    800047ec:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800047f0:	854a                	mv	a0,s2
    800047f2:	ffffe097          	auipc	ra,0xffffe
    800047f6:	4e2080e7          	jalr	1250(ra) # 80002cd4 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800047fa:	40d0                	lw	a2,4(s1)
    800047fc:	00004597          	auipc	a1,0x4
    80004800:	e8c58593          	addi	a1,a1,-372 # 80008688 <syscalls+0x2b0>
    80004804:	8526                	mv	a0,s1
    80004806:	fffff097          	auipc	ra,0xfffff
    8000480a:	c94080e7          	jalr	-876(ra) # 8000349a <dirlink>
    8000480e:	00054f63          	bltz	a0,8000482c <create+0x142>
    80004812:	00492603          	lw	a2,4(s2)
    80004816:	00004597          	auipc	a1,0x4
    8000481a:	e7a58593          	addi	a1,a1,-390 # 80008690 <syscalls+0x2b8>
    8000481e:	8526                	mv	a0,s1
    80004820:	fffff097          	auipc	ra,0xfffff
    80004824:	c7a080e7          	jalr	-902(ra) # 8000349a <dirlink>
    80004828:	f80557e3          	bgez	a0,800047b6 <create+0xcc>
      panic("create dots");
    8000482c:	00004517          	auipc	a0,0x4
    80004830:	e6c50513          	addi	a0,a0,-404 # 80008698 <syscalls+0x2c0>
    80004834:	00001097          	auipc	ra,0x1
    80004838:	5dc080e7          	jalr	1500(ra) # 80005e10 <panic>
    panic("create: dirlink");
    8000483c:	00004517          	auipc	a0,0x4
    80004840:	e6c50513          	addi	a0,a0,-404 # 800086a8 <syscalls+0x2d0>
    80004844:	00001097          	auipc	ra,0x1
    80004848:	5cc080e7          	jalr	1484(ra) # 80005e10 <panic>
    return 0;
    8000484c:	84aa                	mv	s1,a0
    8000484e:	b739                	j	8000475c <create+0x72>

0000000080004850 <sys_dup>:
{
    80004850:	7179                	addi	sp,sp,-48
    80004852:	f406                	sd	ra,40(sp)
    80004854:	f022                	sd	s0,32(sp)
    80004856:	ec26                	sd	s1,24(sp)
    80004858:	e84a                	sd	s2,16(sp)
    8000485a:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000485c:	fd840613          	addi	a2,s0,-40
    80004860:	4581                	li	a1,0
    80004862:	4501                	li	a0,0
    80004864:	00000097          	auipc	ra,0x0
    80004868:	ddc080e7          	jalr	-548(ra) # 80004640 <argfd>
    return -1;
    8000486c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000486e:	02054363          	bltz	a0,80004894 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    80004872:	fd843903          	ld	s2,-40(s0)
    80004876:	854a                	mv	a0,s2
    80004878:	00000097          	auipc	ra,0x0
    8000487c:	e30080e7          	jalr	-464(ra) # 800046a8 <fdalloc>
    80004880:	84aa                	mv	s1,a0
    return -1;
    80004882:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004884:	00054863          	bltz	a0,80004894 <sys_dup+0x44>
  filedup(f);
    80004888:	854a                	mv	a0,s2
    8000488a:	fffff097          	auipc	ra,0xfffff
    8000488e:	368080e7          	jalr	872(ra) # 80003bf2 <filedup>
  return fd;
    80004892:	87a6                	mv	a5,s1
}
    80004894:	853e                	mv	a0,a5
    80004896:	70a2                	ld	ra,40(sp)
    80004898:	7402                	ld	s0,32(sp)
    8000489a:	64e2                	ld	s1,24(sp)
    8000489c:	6942                	ld	s2,16(sp)
    8000489e:	6145                	addi	sp,sp,48
    800048a0:	8082                	ret

00000000800048a2 <sys_read>:
{
    800048a2:	7179                	addi	sp,sp,-48
    800048a4:	f406                	sd	ra,40(sp)
    800048a6:	f022                	sd	s0,32(sp)
    800048a8:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048aa:	fe840613          	addi	a2,s0,-24
    800048ae:	4581                	li	a1,0
    800048b0:	4501                	li	a0,0
    800048b2:	00000097          	auipc	ra,0x0
    800048b6:	d8e080e7          	jalr	-626(ra) # 80004640 <argfd>
    return -1;
    800048ba:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048bc:	04054163          	bltz	a0,800048fe <sys_read+0x5c>
    800048c0:	fe440593          	addi	a1,s0,-28
    800048c4:	4509                	li	a0,2
    800048c6:	ffffe097          	auipc	ra,0xffffe
    800048ca:	968080e7          	jalr	-1688(ra) # 8000222e <argint>
    return -1;
    800048ce:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048d0:	02054763          	bltz	a0,800048fe <sys_read+0x5c>
    800048d4:	fd840593          	addi	a1,s0,-40
    800048d8:	4505                	li	a0,1
    800048da:	ffffe097          	auipc	ra,0xffffe
    800048de:	976080e7          	jalr	-1674(ra) # 80002250 <argaddr>
    return -1;
    800048e2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048e4:	00054d63          	bltz	a0,800048fe <sys_read+0x5c>
  return fileread(f, p, n);
    800048e8:	fe442603          	lw	a2,-28(s0)
    800048ec:	fd843583          	ld	a1,-40(s0)
    800048f0:	fe843503          	ld	a0,-24(s0)
    800048f4:	fffff097          	auipc	ra,0xfffff
    800048f8:	48a080e7          	jalr	1162(ra) # 80003d7e <fileread>
    800048fc:	87aa                	mv	a5,a0
}
    800048fe:	853e                	mv	a0,a5
    80004900:	70a2                	ld	ra,40(sp)
    80004902:	7402                	ld	s0,32(sp)
    80004904:	6145                	addi	sp,sp,48
    80004906:	8082                	ret

0000000080004908 <sys_write>:
{
    80004908:	7179                	addi	sp,sp,-48
    8000490a:	f406                	sd	ra,40(sp)
    8000490c:	f022                	sd	s0,32(sp)
    8000490e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004910:	fe840613          	addi	a2,s0,-24
    80004914:	4581                	li	a1,0
    80004916:	4501                	li	a0,0
    80004918:	00000097          	auipc	ra,0x0
    8000491c:	d28080e7          	jalr	-728(ra) # 80004640 <argfd>
    return -1;
    80004920:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004922:	04054163          	bltz	a0,80004964 <sys_write+0x5c>
    80004926:	fe440593          	addi	a1,s0,-28
    8000492a:	4509                	li	a0,2
    8000492c:	ffffe097          	auipc	ra,0xffffe
    80004930:	902080e7          	jalr	-1790(ra) # 8000222e <argint>
    return -1;
    80004934:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004936:	02054763          	bltz	a0,80004964 <sys_write+0x5c>
    8000493a:	fd840593          	addi	a1,s0,-40
    8000493e:	4505                	li	a0,1
    80004940:	ffffe097          	auipc	ra,0xffffe
    80004944:	910080e7          	jalr	-1776(ra) # 80002250 <argaddr>
    return -1;
    80004948:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000494a:	00054d63          	bltz	a0,80004964 <sys_write+0x5c>
  return filewrite(f, p, n);
    8000494e:	fe442603          	lw	a2,-28(s0)
    80004952:	fd843583          	ld	a1,-40(s0)
    80004956:	fe843503          	ld	a0,-24(s0)
    8000495a:	fffff097          	auipc	ra,0xfffff
    8000495e:	4e6080e7          	jalr	1254(ra) # 80003e40 <filewrite>
    80004962:	87aa                	mv	a5,a0
}
    80004964:	853e                	mv	a0,a5
    80004966:	70a2                	ld	ra,40(sp)
    80004968:	7402                	ld	s0,32(sp)
    8000496a:	6145                	addi	sp,sp,48
    8000496c:	8082                	ret

000000008000496e <sys_close>:
{
    8000496e:	1101                	addi	sp,sp,-32
    80004970:	ec06                	sd	ra,24(sp)
    80004972:	e822                	sd	s0,16(sp)
    80004974:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004976:	fe040613          	addi	a2,s0,-32
    8000497a:	fec40593          	addi	a1,s0,-20
    8000497e:	4501                	li	a0,0
    80004980:	00000097          	auipc	ra,0x0
    80004984:	cc0080e7          	jalr	-832(ra) # 80004640 <argfd>
    return -1;
    80004988:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000498a:	02054463          	bltz	a0,800049b2 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    8000498e:	ffffc097          	auipc	ra,0xffffc
    80004992:	610080e7          	jalr	1552(ra) # 80000f9e <myproc>
    80004996:	fec42783          	lw	a5,-20(s0)
    8000499a:	07e9                	addi	a5,a5,26
    8000499c:	078e                	slli	a5,a5,0x3
    8000499e:	953e                	add	a0,a0,a5
    800049a0:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800049a4:	fe043503          	ld	a0,-32(s0)
    800049a8:	fffff097          	auipc	ra,0xfffff
    800049ac:	29c080e7          	jalr	668(ra) # 80003c44 <fileclose>
  return 0;
    800049b0:	4781                	li	a5,0
}
    800049b2:	853e                	mv	a0,a5
    800049b4:	60e2                	ld	ra,24(sp)
    800049b6:	6442                	ld	s0,16(sp)
    800049b8:	6105                	addi	sp,sp,32
    800049ba:	8082                	ret

00000000800049bc <sys_fstat>:
{
    800049bc:	1101                	addi	sp,sp,-32
    800049be:	ec06                	sd	ra,24(sp)
    800049c0:	e822                	sd	s0,16(sp)
    800049c2:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800049c4:	fe840613          	addi	a2,s0,-24
    800049c8:	4581                	li	a1,0
    800049ca:	4501                	li	a0,0
    800049cc:	00000097          	auipc	ra,0x0
    800049d0:	c74080e7          	jalr	-908(ra) # 80004640 <argfd>
    return -1;
    800049d4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800049d6:	02054563          	bltz	a0,80004a00 <sys_fstat+0x44>
    800049da:	fe040593          	addi	a1,s0,-32
    800049de:	4505                	li	a0,1
    800049e0:	ffffe097          	auipc	ra,0xffffe
    800049e4:	870080e7          	jalr	-1936(ra) # 80002250 <argaddr>
    return -1;
    800049e8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800049ea:	00054b63          	bltz	a0,80004a00 <sys_fstat+0x44>
  return filestat(f, st);
    800049ee:	fe043583          	ld	a1,-32(s0)
    800049f2:	fe843503          	ld	a0,-24(s0)
    800049f6:	fffff097          	auipc	ra,0xfffff
    800049fa:	316080e7          	jalr	790(ra) # 80003d0c <filestat>
    800049fe:	87aa                	mv	a5,a0
}
    80004a00:	853e                	mv	a0,a5
    80004a02:	60e2                	ld	ra,24(sp)
    80004a04:	6442                	ld	s0,16(sp)
    80004a06:	6105                	addi	sp,sp,32
    80004a08:	8082                	ret

0000000080004a0a <sys_link>:
{
    80004a0a:	7169                	addi	sp,sp,-304
    80004a0c:	f606                	sd	ra,296(sp)
    80004a0e:	f222                	sd	s0,288(sp)
    80004a10:	ee26                	sd	s1,280(sp)
    80004a12:	ea4a                	sd	s2,272(sp)
    80004a14:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a16:	08000613          	li	a2,128
    80004a1a:	ed040593          	addi	a1,s0,-304
    80004a1e:	4501                	li	a0,0
    80004a20:	ffffe097          	auipc	ra,0xffffe
    80004a24:	852080e7          	jalr	-1966(ra) # 80002272 <argstr>
    return -1;
    80004a28:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a2a:	10054e63          	bltz	a0,80004b46 <sys_link+0x13c>
    80004a2e:	08000613          	li	a2,128
    80004a32:	f5040593          	addi	a1,s0,-176
    80004a36:	4505                	li	a0,1
    80004a38:	ffffe097          	auipc	ra,0xffffe
    80004a3c:	83a080e7          	jalr	-1990(ra) # 80002272 <argstr>
    return -1;
    80004a40:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a42:	10054263          	bltz	a0,80004b46 <sys_link+0x13c>
  begin_op();
    80004a46:	fffff097          	auipc	ra,0xfffff
    80004a4a:	d36080e7          	jalr	-714(ra) # 8000377c <begin_op>
  if((ip = namei(old)) == 0){
    80004a4e:	ed040513          	addi	a0,s0,-304
    80004a52:	fffff097          	auipc	ra,0xfffff
    80004a56:	b0a080e7          	jalr	-1270(ra) # 8000355c <namei>
    80004a5a:	84aa                	mv	s1,a0
    80004a5c:	c551                	beqz	a0,80004ae8 <sys_link+0xde>
  ilock(ip);
    80004a5e:	ffffe097          	auipc	ra,0xffffe
    80004a62:	342080e7          	jalr	834(ra) # 80002da0 <ilock>
  if(ip->type == T_DIR){
    80004a66:	04449703          	lh	a4,68(s1)
    80004a6a:	4785                	li	a5,1
    80004a6c:	08f70463          	beq	a4,a5,80004af4 <sys_link+0xea>
  ip->nlink++;
    80004a70:	04a4d783          	lhu	a5,74(s1)
    80004a74:	2785                	addiw	a5,a5,1
    80004a76:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a7a:	8526                	mv	a0,s1
    80004a7c:	ffffe097          	auipc	ra,0xffffe
    80004a80:	258080e7          	jalr	600(ra) # 80002cd4 <iupdate>
  iunlock(ip);
    80004a84:	8526                	mv	a0,s1
    80004a86:	ffffe097          	auipc	ra,0xffffe
    80004a8a:	3dc080e7          	jalr	988(ra) # 80002e62 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004a8e:	fd040593          	addi	a1,s0,-48
    80004a92:	f5040513          	addi	a0,s0,-176
    80004a96:	fffff097          	auipc	ra,0xfffff
    80004a9a:	ae4080e7          	jalr	-1308(ra) # 8000357a <nameiparent>
    80004a9e:	892a                	mv	s2,a0
    80004aa0:	c935                	beqz	a0,80004b14 <sys_link+0x10a>
  ilock(dp);
    80004aa2:	ffffe097          	auipc	ra,0xffffe
    80004aa6:	2fe080e7          	jalr	766(ra) # 80002da0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004aaa:	00092703          	lw	a4,0(s2)
    80004aae:	409c                	lw	a5,0(s1)
    80004ab0:	04f71d63          	bne	a4,a5,80004b0a <sys_link+0x100>
    80004ab4:	40d0                	lw	a2,4(s1)
    80004ab6:	fd040593          	addi	a1,s0,-48
    80004aba:	854a                	mv	a0,s2
    80004abc:	fffff097          	auipc	ra,0xfffff
    80004ac0:	9de080e7          	jalr	-1570(ra) # 8000349a <dirlink>
    80004ac4:	04054363          	bltz	a0,80004b0a <sys_link+0x100>
  iunlockput(dp);
    80004ac8:	854a                	mv	a0,s2
    80004aca:	ffffe097          	auipc	ra,0xffffe
    80004ace:	538080e7          	jalr	1336(ra) # 80003002 <iunlockput>
  iput(ip);
    80004ad2:	8526                	mv	a0,s1
    80004ad4:	ffffe097          	auipc	ra,0xffffe
    80004ad8:	486080e7          	jalr	1158(ra) # 80002f5a <iput>
  end_op();
    80004adc:	fffff097          	auipc	ra,0xfffff
    80004ae0:	d1e080e7          	jalr	-738(ra) # 800037fa <end_op>
  return 0;
    80004ae4:	4781                	li	a5,0
    80004ae6:	a085                	j	80004b46 <sys_link+0x13c>
    end_op();
    80004ae8:	fffff097          	auipc	ra,0xfffff
    80004aec:	d12080e7          	jalr	-750(ra) # 800037fa <end_op>
    return -1;
    80004af0:	57fd                	li	a5,-1
    80004af2:	a891                	j	80004b46 <sys_link+0x13c>
    iunlockput(ip);
    80004af4:	8526                	mv	a0,s1
    80004af6:	ffffe097          	auipc	ra,0xffffe
    80004afa:	50c080e7          	jalr	1292(ra) # 80003002 <iunlockput>
    end_op();
    80004afe:	fffff097          	auipc	ra,0xfffff
    80004b02:	cfc080e7          	jalr	-772(ra) # 800037fa <end_op>
    return -1;
    80004b06:	57fd                	li	a5,-1
    80004b08:	a83d                	j	80004b46 <sys_link+0x13c>
    iunlockput(dp);
    80004b0a:	854a                	mv	a0,s2
    80004b0c:	ffffe097          	auipc	ra,0xffffe
    80004b10:	4f6080e7          	jalr	1270(ra) # 80003002 <iunlockput>
  ilock(ip);
    80004b14:	8526                	mv	a0,s1
    80004b16:	ffffe097          	auipc	ra,0xffffe
    80004b1a:	28a080e7          	jalr	650(ra) # 80002da0 <ilock>
  ip->nlink--;
    80004b1e:	04a4d783          	lhu	a5,74(s1)
    80004b22:	37fd                	addiw	a5,a5,-1
    80004b24:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004b28:	8526                	mv	a0,s1
    80004b2a:	ffffe097          	auipc	ra,0xffffe
    80004b2e:	1aa080e7          	jalr	426(ra) # 80002cd4 <iupdate>
  iunlockput(ip);
    80004b32:	8526                	mv	a0,s1
    80004b34:	ffffe097          	auipc	ra,0xffffe
    80004b38:	4ce080e7          	jalr	1230(ra) # 80003002 <iunlockput>
  end_op();
    80004b3c:	fffff097          	auipc	ra,0xfffff
    80004b40:	cbe080e7          	jalr	-834(ra) # 800037fa <end_op>
  return -1;
    80004b44:	57fd                	li	a5,-1
}
    80004b46:	853e                	mv	a0,a5
    80004b48:	70b2                	ld	ra,296(sp)
    80004b4a:	7412                	ld	s0,288(sp)
    80004b4c:	64f2                	ld	s1,280(sp)
    80004b4e:	6952                	ld	s2,272(sp)
    80004b50:	6155                	addi	sp,sp,304
    80004b52:	8082                	ret

0000000080004b54 <sys_unlink>:
{
    80004b54:	7151                	addi	sp,sp,-240
    80004b56:	f586                	sd	ra,232(sp)
    80004b58:	f1a2                	sd	s0,224(sp)
    80004b5a:	eda6                	sd	s1,216(sp)
    80004b5c:	e9ca                	sd	s2,208(sp)
    80004b5e:	e5ce                	sd	s3,200(sp)
    80004b60:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004b62:	08000613          	li	a2,128
    80004b66:	f3040593          	addi	a1,s0,-208
    80004b6a:	4501                	li	a0,0
    80004b6c:	ffffd097          	auipc	ra,0xffffd
    80004b70:	706080e7          	jalr	1798(ra) # 80002272 <argstr>
    80004b74:	18054163          	bltz	a0,80004cf6 <sys_unlink+0x1a2>
  begin_op();
    80004b78:	fffff097          	auipc	ra,0xfffff
    80004b7c:	c04080e7          	jalr	-1020(ra) # 8000377c <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004b80:	fb040593          	addi	a1,s0,-80
    80004b84:	f3040513          	addi	a0,s0,-208
    80004b88:	fffff097          	auipc	ra,0xfffff
    80004b8c:	9f2080e7          	jalr	-1550(ra) # 8000357a <nameiparent>
    80004b90:	84aa                	mv	s1,a0
    80004b92:	c979                	beqz	a0,80004c68 <sys_unlink+0x114>
  ilock(dp);
    80004b94:	ffffe097          	auipc	ra,0xffffe
    80004b98:	20c080e7          	jalr	524(ra) # 80002da0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004b9c:	00004597          	auipc	a1,0x4
    80004ba0:	aec58593          	addi	a1,a1,-1300 # 80008688 <syscalls+0x2b0>
    80004ba4:	fb040513          	addi	a0,s0,-80
    80004ba8:	ffffe097          	auipc	ra,0xffffe
    80004bac:	6c2080e7          	jalr	1730(ra) # 8000326a <namecmp>
    80004bb0:	14050a63          	beqz	a0,80004d04 <sys_unlink+0x1b0>
    80004bb4:	00004597          	auipc	a1,0x4
    80004bb8:	adc58593          	addi	a1,a1,-1316 # 80008690 <syscalls+0x2b8>
    80004bbc:	fb040513          	addi	a0,s0,-80
    80004bc0:	ffffe097          	auipc	ra,0xffffe
    80004bc4:	6aa080e7          	jalr	1706(ra) # 8000326a <namecmp>
    80004bc8:	12050e63          	beqz	a0,80004d04 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004bcc:	f2c40613          	addi	a2,s0,-212
    80004bd0:	fb040593          	addi	a1,s0,-80
    80004bd4:	8526                	mv	a0,s1
    80004bd6:	ffffe097          	auipc	ra,0xffffe
    80004bda:	6ae080e7          	jalr	1710(ra) # 80003284 <dirlookup>
    80004bde:	892a                	mv	s2,a0
    80004be0:	12050263          	beqz	a0,80004d04 <sys_unlink+0x1b0>
  ilock(ip);
    80004be4:	ffffe097          	auipc	ra,0xffffe
    80004be8:	1bc080e7          	jalr	444(ra) # 80002da0 <ilock>
  if(ip->nlink < 1)
    80004bec:	04a91783          	lh	a5,74(s2)
    80004bf0:	08f05263          	blez	a5,80004c74 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004bf4:	04491703          	lh	a4,68(s2)
    80004bf8:	4785                	li	a5,1
    80004bfa:	08f70563          	beq	a4,a5,80004c84 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004bfe:	4641                	li	a2,16
    80004c00:	4581                	li	a1,0
    80004c02:	fc040513          	addi	a0,s0,-64
    80004c06:	ffffb097          	auipc	ra,0xffffb
    80004c0a:	6b8080e7          	jalr	1720(ra) # 800002be <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c0e:	4741                	li	a4,16
    80004c10:	f2c42683          	lw	a3,-212(s0)
    80004c14:	fc040613          	addi	a2,s0,-64
    80004c18:	4581                	li	a1,0
    80004c1a:	8526                	mv	a0,s1
    80004c1c:	ffffe097          	auipc	ra,0xffffe
    80004c20:	530080e7          	jalr	1328(ra) # 8000314c <writei>
    80004c24:	47c1                	li	a5,16
    80004c26:	0af51563          	bne	a0,a5,80004cd0 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004c2a:	04491703          	lh	a4,68(s2)
    80004c2e:	4785                	li	a5,1
    80004c30:	0af70863          	beq	a4,a5,80004ce0 <sys_unlink+0x18c>
  iunlockput(dp);
    80004c34:	8526                	mv	a0,s1
    80004c36:	ffffe097          	auipc	ra,0xffffe
    80004c3a:	3cc080e7          	jalr	972(ra) # 80003002 <iunlockput>
  ip->nlink--;
    80004c3e:	04a95783          	lhu	a5,74(s2)
    80004c42:	37fd                	addiw	a5,a5,-1
    80004c44:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004c48:	854a                	mv	a0,s2
    80004c4a:	ffffe097          	auipc	ra,0xffffe
    80004c4e:	08a080e7          	jalr	138(ra) # 80002cd4 <iupdate>
  iunlockput(ip);
    80004c52:	854a                	mv	a0,s2
    80004c54:	ffffe097          	auipc	ra,0xffffe
    80004c58:	3ae080e7          	jalr	942(ra) # 80003002 <iunlockput>
  end_op();
    80004c5c:	fffff097          	auipc	ra,0xfffff
    80004c60:	b9e080e7          	jalr	-1122(ra) # 800037fa <end_op>
  return 0;
    80004c64:	4501                	li	a0,0
    80004c66:	a84d                	j	80004d18 <sys_unlink+0x1c4>
    end_op();
    80004c68:	fffff097          	auipc	ra,0xfffff
    80004c6c:	b92080e7          	jalr	-1134(ra) # 800037fa <end_op>
    return -1;
    80004c70:	557d                	li	a0,-1
    80004c72:	a05d                	j	80004d18 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004c74:	00004517          	auipc	a0,0x4
    80004c78:	a4450513          	addi	a0,a0,-1468 # 800086b8 <syscalls+0x2e0>
    80004c7c:	00001097          	auipc	ra,0x1
    80004c80:	194080e7          	jalr	404(ra) # 80005e10 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c84:	04c92703          	lw	a4,76(s2)
    80004c88:	02000793          	li	a5,32
    80004c8c:	f6e7f9e3          	bgeu	a5,a4,80004bfe <sys_unlink+0xaa>
    80004c90:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c94:	4741                	li	a4,16
    80004c96:	86ce                	mv	a3,s3
    80004c98:	f1840613          	addi	a2,s0,-232
    80004c9c:	4581                	li	a1,0
    80004c9e:	854a                	mv	a0,s2
    80004ca0:	ffffe097          	auipc	ra,0xffffe
    80004ca4:	3b4080e7          	jalr	948(ra) # 80003054 <readi>
    80004ca8:	47c1                	li	a5,16
    80004caa:	00f51b63          	bne	a0,a5,80004cc0 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004cae:	f1845783          	lhu	a5,-232(s0)
    80004cb2:	e7a1                	bnez	a5,80004cfa <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004cb4:	29c1                	addiw	s3,s3,16
    80004cb6:	04c92783          	lw	a5,76(s2)
    80004cba:	fcf9ede3          	bltu	s3,a5,80004c94 <sys_unlink+0x140>
    80004cbe:	b781                	j	80004bfe <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004cc0:	00004517          	auipc	a0,0x4
    80004cc4:	a1050513          	addi	a0,a0,-1520 # 800086d0 <syscalls+0x2f8>
    80004cc8:	00001097          	auipc	ra,0x1
    80004ccc:	148080e7          	jalr	328(ra) # 80005e10 <panic>
    panic("unlink: writei");
    80004cd0:	00004517          	auipc	a0,0x4
    80004cd4:	a1850513          	addi	a0,a0,-1512 # 800086e8 <syscalls+0x310>
    80004cd8:	00001097          	auipc	ra,0x1
    80004cdc:	138080e7          	jalr	312(ra) # 80005e10 <panic>
    dp->nlink--;
    80004ce0:	04a4d783          	lhu	a5,74(s1)
    80004ce4:	37fd                	addiw	a5,a5,-1
    80004ce6:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004cea:	8526                	mv	a0,s1
    80004cec:	ffffe097          	auipc	ra,0xffffe
    80004cf0:	fe8080e7          	jalr	-24(ra) # 80002cd4 <iupdate>
    80004cf4:	b781                	j	80004c34 <sys_unlink+0xe0>
    return -1;
    80004cf6:	557d                	li	a0,-1
    80004cf8:	a005                	j	80004d18 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004cfa:	854a                	mv	a0,s2
    80004cfc:	ffffe097          	auipc	ra,0xffffe
    80004d00:	306080e7          	jalr	774(ra) # 80003002 <iunlockput>
  iunlockput(dp);
    80004d04:	8526                	mv	a0,s1
    80004d06:	ffffe097          	auipc	ra,0xffffe
    80004d0a:	2fc080e7          	jalr	764(ra) # 80003002 <iunlockput>
  end_op();
    80004d0e:	fffff097          	auipc	ra,0xfffff
    80004d12:	aec080e7          	jalr	-1300(ra) # 800037fa <end_op>
  return -1;
    80004d16:	557d                	li	a0,-1
}
    80004d18:	70ae                	ld	ra,232(sp)
    80004d1a:	740e                	ld	s0,224(sp)
    80004d1c:	64ee                	ld	s1,216(sp)
    80004d1e:	694e                	ld	s2,208(sp)
    80004d20:	69ae                	ld	s3,200(sp)
    80004d22:	616d                	addi	sp,sp,240
    80004d24:	8082                	ret

0000000080004d26 <sys_open>:

uint64
sys_open(void)
{
    80004d26:	7131                	addi	sp,sp,-192
    80004d28:	fd06                	sd	ra,184(sp)
    80004d2a:	f922                	sd	s0,176(sp)
    80004d2c:	f526                	sd	s1,168(sp)
    80004d2e:	f14a                	sd	s2,160(sp)
    80004d30:	ed4e                	sd	s3,152(sp)
    80004d32:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004d34:	08000613          	li	a2,128
    80004d38:	f5040593          	addi	a1,s0,-176
    80004d3c:	4501                	li	a0,0
    80004d3e:	ffffd097          	auipc	ra,0xffffd
    80004d42:	534080e7          	jalr	1332(ra) # 80002272 <argstr>
    return -1;
    80004d46:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004d48:	0c054163          	bltz	a0,80004e0a <sys_open+0xe4>
    80004d4c:	f4c40593          	addi	a1,s0,-180
    80004d50:	4505                	li	a0,1
    80004d52:	ffffd097          	auipc	ra,0xffffd
    80004d56:	4dc080e7          	jalr	1244(ra) # 8000222e <argint>
    80004d5a:	0a054863          	bltz	a0,80004e0a <sys_open+0xe4>

  begin_op();
    80004d5e:	fffff097          	auipc	ra,0xfffff
    80004d62:	a1e080e7          	jalr	-1506(ra) # 8000377c <begin_op>

  if(omode & O_CREATE){
    80004d66:	f4c42783          	lw	a5,-180(s0)
    80004d6a:	2007f793          	andi	a5,a5,512
    80004d6e:	cbdd                	beqz	a5,80004e24 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004d70:	4681                	li	a3,0
    80004d72:	4601                	li	a2,0
    80004d74:	4589                	li	a1,2
    80004d76:	f5040513          	addi	a0,s0,-176
    80004d7a:	00000097          	auipc	ra,0x0
    80004d7e:	970080e7          	jalr	-1680(ra) # 800046ea <create>
    80004d82:	892a                	mv	s2,a0
    if(ip == 0){
    80004d84:	c959                	beqz	a0,80004e1a <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004d86:	04491703          	lh	a4,68(s2)
    80004d8a:	478d                	li	a5,3
    80004d8c:	00f71763          	bne	a4,a5,80004d9a <sys_open+0x74>
    80004d90:	04695703          	lhu	a4,70(s2)
    80004d94:	47a5                	li	a5,9
    80004d96:	0ce7ec63          	bltu	a5,a4,80004e6e <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004d9a:	fffff097          	auipc	ra,0xfffff
    80004d9e:	dee080e7          	jalr	-530(ra) # 80003b88 <filealloc>
    80004da2:	89aa                	mv	s3,a0
    80004da4:	10050263          	beqz	a0,80004ea8 <sys_open+0x182>
    80004da8:	00000097          	auipc	ra,0x0
    80004dac:	900080e7          	jalr	-1792(ra) # 800046a8 <fdalloc>
    80004db0:	84aa                	mv	s1,a0
    80004db2:	0e054663          	bltz	a0,80004e9e <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004db6:	04491703          	lh	a4,68(s2)
    80004dba:	478d                	li	a5,3
    80004dbc:	0cf70463          	beq	a4,a5,80004e84 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004dc0:	4789                	li	a5,2
    80004dc2:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004dc6:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004dca:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004dce:	f4c42783          	lw	a5,-180(s0)
    80004dd2:	0017c713          	xori	a4,a5,1
    80004dd6:	8b05                	andi	a4,a4,1
    80004dd8:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004ddc:	0037f713          	andi	a4,a5,3
    80004de0:	00e03733          	snez	a4,a4
    80004de4:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004de8:	4007f793          	andi	a5,a5,1024
    80004dec:	c791                	beqz	a5,80004df8 <sys_open+0xd2>
    80004dee:	04491703          	lh	a4,68(s2)
    80004df2:	4789                	li	a5,2
    80004df4:	08f70f63          	beq	a4,a5,80004e92 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004df8:	854a                	mv	a0,s2
    80004dfa:	ffffe097          	auipc	ra,0xffffe
    80004dfe:	068080e7          	jalr	104(ra) # 80002e62 <iunlock>
  end_op();
    80004e02:	fffff097          	auipc	ra,0xfffff
    80004e06:	9f8080e7          	jalr	-1544(ra) # 800037fa <end_op>

  return fd;
}
    80004e0a:	8526                	mv	a0,s1
    80004e0c:	70ea                	ld	ra,184(sp)
    80004e0e:	744a                	ld	s0,176(sp)
    80004e10:	74aa                	ld	s1,168(sp)
    80004e12:	790a                	ld	s2,160(sp)
    80004e14:	69ea                	ld	s3,152(sp)
    80004e16:	6129                	addi	sp,sp,192
    80004e18:	8082                	ret
      end_op();
    80004e1a:	fffff097          	auipc	ra,0xfffff
    80004e1e:	9e0080e7          	jalr	-1568(ra) # 800037fa <end_op>
      return -1;
    80004e22:	b7e5                	j	80004e0a <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004e24:	f5040513          	addi	a0,s0,-176
    80004e28:	ffffe097          	auipc	ra,0xffffe
    80004e2c:	734080e7          	jalr	1844(ra) # 8000355c <namei>
    80004e30:	892a                	mv	s2,a0
    80004e32:	c905                	beqz	a0,80004e62 <sys_open+0x13c>
    ilock(ip);
    80004e34:	ffffe097          	auipc	ra,0xffffe
    80004e38:	f6c080e7          	jalr	-148(ra) # 80002da0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004e3c:	04491703          	lh	a4,68(s2)
    80004e40:	4785                	li	a5,1
    80004e42:	f4f712e3          	bne	a4,a5,80004d86 <sys_open+0x60>
    80004e46:	f4c42783          	lw	a5,-180(s0)
    80004e4a:	dba1                	beqz	a5,80004d9a <sys_open+0x74>
      iunlockput(ip);
    80004e4c:	854a                	mv	a0,s2
    80004e4e:	ffffe097          	auipc	ra,0xffffe
    80004e52:	1b4080e7          	jalr	436(ra) # 80003002 <iunlockput>
      end_op();
    80004e56:	fffff097          	auipc	ra,0xfffff
    80004e5a:	9a4080e7          	jalr	-1628(ra) # 800037fa <end_op>
      return -1;
    80004e5e:	54fd                	li	s1,-1
    80004e60:	b76d                	j	80004e0a <sys_open+0xe4>
      end_op();
    80004e62:	fffff097          	auipc	ra,0xfffff
    80004e66:	998080e7          	jalr	-1640(ra) # 800037fa <end_op>
      return -1;
    80004e6a:	54fd                	li	s1,-1
    80004e6c:	bf79                	j	80004e0a <sys_open+0xe4>
    iunlockput(ip);
    80004e6e:	854a                	mv	a0,s2
    80004e70:	ffffe097          	auipc	ra,0xffffe
    80004e74:	192080e7          	jalr	402(ra) # 80003002 <iunlockput>
    end_op();
    80004e78:	fffff097          	auipc	ra,0xfffff
    80004e7c:	982080e7          	jalr	-1662(ra) # 800037fa <end_op>
    return -1;
    80004e80:	54fd                	li	s1,-1
    80004e82:	b761                	j	80004e0a <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004e84:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004e88:	04691783          	lh	a5,70(s2)
    80004e8c:	02f99223          	sh	a5,36(s3)
    80004e90:	bf2d                	j	80004dca <sys_open+0xa4>
    itrunc(ip);
    80004e92:	854a                	mv	a0,s2
    80004e94:	ffffe097          	auipc	ra,0xffffe
    80004e98:	01a080e7          	jalr	26(ra) # 80002eae <itrunc>
    80004e9c:	bfb1                	j	80004df8 <sys_open+0xd2>
      fileclose(f);
    80004e9e:	854e                	mv	a0,s3
    80004ea0:	fffff097          	auipc	ra,0xfffff
    80004ea4:	da4080e7          	jalr	-604(ra) # 80003c44 <fileclose>
    iunlockput(ip);
    80004ea8:	854a                	mv	a0,s2
    80004eaa:	ffffe097          	auipc	ra,0xffffe
    80004eae:	158080e7          	jalr	344(ra) # 80003002 <iunlockput>
    end_op();
    80004eb2:	fffff097          	auipc	ra,0xfffff
    80004eb6:	948080e7          	jalr	-1720(ra) # 800037fa <end_op>
    return -1;
    80004eba:	54fd                	li	s1,-1
    80004ebc:	b7b9                	j	80004e0a <sys_open+0xe4>

0000000080004ebe <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004ebe:	7175                	addi	sp,sp,-144
    80004ec0:	e506                	sd	ra,136(sp)
    80004ec2:	e122                	sd	s0,128(sp)
    80004ec4:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004ec6:	fffff097          	auipc	ra,0xfffff
    80004eca:	8b6080e7          	jalr	-1866(ra) # 8000377c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004ece:	08000613          	li	a2,128
    80004ed2:	f7040593          	addi	a1,s0,-144
    80004ed6:	4501                	li	a0,0
    80004ed8:	ffffd097          	auipc	ra,0xffffd
    80004edc:	39a080e7          	jalr	922(ra) # 80002272 <argstr>
    80004ee0:	02054963          	bltz	a0,80004f12 <sys_mkdir+0x54>
    80004ee4:	4681                	li	a3,0
    80004ee6:	4601                	li	a2,0
    80004ee8:	4585                	li	a1,1
    80004eea:	f7040513          	addi	a0,s0,-144
    80004eee:	fffff097          	auipc	ra,0xfffff
    80004ef2:	7fc080e7          	jalr	2044(ra) # 800046ea <create>
    80004ef6:	cd11                	beqz	a0,80004f12 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004ef8:	ffffe097          	auipc	ra,0xffffe
    80004efc:	10a080e7          	jalr	266(ra) # 80003002 <iunlockput>
  end_op();
    80004f00:	fffff097          	auipc	ra,0xfffff
    80004f04:	8fa080e7          	jalr	-1798(ra) # 800037fa <end_op>
  return 0;
    80004f08:	4501                	li	a0,0
}
    80004f0a:	60aa                	ld	ra,136(sp)
    80004f0c:	640a                	ld	s0,128(sp)
    80004f0e:	6149                	addi	sp,sp,144
    80004f10:	8082                	ret
    end_op();
    80004f12:	fffff097          	auipc	ra,0xfffff
    80004f16:	8e8080e7          	jalr	-1816(ra) # 800037fa <end_op>
    return -1;
    80004f1a:	557d                	li	a0,-1
    80004f1c:	b7fd                	j	80004f0a <sys_mkdir+0x4c>

0000000080004f1e <sys_mknod>:

uint64
sys_mknod(void)
{
    80004f1e:	7135                	addi	sp,sp,-160
    80004f20:	ed06                	sd	ra,152(sp)
    80004f22:	e922                	sd	s0,144(sp)
    80004f24:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004f26:	fffff097          	auipc	ra,0xfffff
    80004f2a:	856080e7          	jalr	-1962(ra) # 8000377c <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f2e:	08000613          	li	a2,128
    80004f32:	f7040593          	addi	a1,s0,-144
    80004f36:	4501                	li	a0,0
    80004f38:	ffffd097          	auipc	ra,0xffffd
    80004f3c:	33a080e7          	jalr	826(ra) # 80002272 <argstr>
    80004f40:	04054a63          	bltz	a0,80004f94 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004f44:	f6c40593          	addi	a1,s0,-148
    80004f48:	4505                	li	a0,1
    80004f4a:	ffffd097          	auipc	ra,0xffffd
    80004f4e:	2e4080e7          	jalr	740(ra) # 8000222e <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f52:	04054163          	bltz	a0,80004f94 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004f56:	f6840593          	addi	a1,s0,-152
    80004f5a:	4509                	li	a0,2
    80004f5c:	ffffd097          	auipc	ra,0xffffd
    80004f60:	2d2080e7          	jalr	722(ra) # 8000222e <argint>
     argint(1, &major) < 0 ||
    80004f64:	02054863          	bltz	a0,80004f94 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004f68:	f6841683          	lh	a3,-152(s0)
    80004f6c:	f6c41603          	lh	a2,-148(s0)
    80004f70:	458d                	li	a1,3
    80004f72:	f7040513          	addi	a0,s0,-144
    80004f76:	fffff097          	auipc	ra,0xfffff
    80004f7a:	774080e7          	jalr	1908(ra) # 800046ea <create>
     argint(2, &minor) < 0 ||
    80004f7e:	c919                	beqz	a0,80004f94 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f80:	ffffe097          	auipc	ra,0xffffe
    80004f84:	082080e7          	jalr	130(ra) # 80003002 <iunlockput>
  end_op();
    80004f88:	fffff097          	auipc	ra,0xfffff
    80004f8c:	872080e7          	jalr	-1934(ra) # 800037fa <end_op>
  return 0;
    80004f90:	4501                	li	a0,0
    80004f92:	a031                	j	80004f9e <sys_mknod+0x80>
    end_op();
    80004f94:	fffff097          	auipc	ra,0xfffff
    80004f98:	866080e7          	jalr	-1946(ra) # 800037fa <end_op>
    return -1;
    80004f9c:	557d                	li	a0,-1
}
    80004f9e:	60ea                	ld	ra,152(sp)
    80004fa0:	644a                	ld	s0,144(sp)
    80004fa2:	610d                	addi	sp,sp,160
    80004fa4:	8082                	ret

0000000080004fa6 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004fa6:	7135                	addi	sp,sp,-160
    80004fa8:	ed06                	sd	ra,152(sp)
    80004faa:	e922                	sd	s0,144(sp)
    80004fac:	e526                	sd	s1,136(sp)
    80004fae:	e14a                	sd	s2,128(sp)
    80004fb0:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004fb2:	ffffc097          	auipc	ra,0xffffc
    80004fb6:	fec080e7          	jalr	-20(ra) # 80000f9e <myproc>
    80004fba:	892a                	mv	s2,a0
  
  begin_op();
    80004fbc:	ffffe097          	auipc	ra,0xffffe
    80004fc0:	7c0080e7          	jalr	1984(ra) # 8000377c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004fc4:	08000613          	li	a2,128
    80004fc8:	f6040593          	addi	a1,s0,-160
    80004fcc:	4501                	li	a0,0
    80004fce:	ffffd097          	auipc	ra,0xffffd
    80004fd2:	2a4080e7          	jalr	676(ra) # 80002272 <argstr>
    80004fd6:	04054b63          	bltz	a0,8000502c <sys_chdir+0x86>
    80004fda:	f6040513          	addi	a0,s0,-160
    80004fde:	ffffe097          	auipc	ra,0xffffe
    80004fe2:	57e080e7          	jalr	1406(ra) # 8000355c <namei>
    80004fe6:	84aa                	mv	s1,a0
    80004fe8:	c131                	beqz	a0,8000502c <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004fea:	ffffe097          	auipc	ra,0xffffe
    80004fee:	db6080e7          	jalr	-586(ra) # 80002da0 <ilock>
  if(ip->type != T_DIR){
    80004ff2:	04449703          	lh	a4,68(s1)
    80004ff6:	4785                	li	a5,1
    80004ff8:	04f71063          	bne	a4,a5,80005038 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004ffc:	8526                	mv	a0,s1
    80004ffe:	ffffe097          	auipc	ra,0xffffe
    80005002:	e64080e7          	jalr	-412(ra) # 80002e62 <iunlock>
  iput(p->cwd);
    80005006:	15093503          	ld	a0,336(s2)
    8000500a:	ffffe097          	auipc	ra,0xffffe
    8000500e:	f50080e7          	jalr	-176(ra) # 80002f5a <iput>
  end_op();
    80005012:	ffffe097          	auipc	ra,0xffffe
    80005016:	7e8080e7          	jalr	2024(ra) # 800037fa <end_op>
  p->cwd = ip;
    8000501a:	14993823          	sd	s1,336(s2)
  return 0;
    8000501e:	4501                	li	a0,0
}
    80005020:	60ea                	ld	ra,152(sp)
    80005022:	644a                	ld	s0,144(sp)
    80005024:	64aa                	ld	s1,136(sp)
    80005026:	690a                	ld	s2,128(sp)
    80005028:	610d                	addi	sp,sp,160
    8000502a:	8082                	ret
    end_op();
    8000502c:	ffffe097          	auipc	ra,0xffffe
    80005030:	7ce080e7          	jalr	1998(ra) # 800037fa <end_op>
    return -1;
    80005034:	557d                	li	a0,-1
    80005036:	b7ed                	j	80005020 <sys_chdir+0x7a>
    iunlockput(ip);
    80005038:	8526                	mv	a0,s1
    8000503a:	ffffe097          	auipc	ra,0xffffe
    8000503e:	fc8080e7          	jalr	-56(ra) # 80003002 <iunlockput>
    end_op();
    80005042:	ffffe097          	auipc	ra,0xffffe
    80005046:	7b8080e7          	jalr	1976(ra) # 800037fa <end_op>
    return -1;
    8000504a:	557d                	li	a0,-1
    8000504c:	bfd1                	j	80005020 <sys_chdir+0x7a>

000000008000504e <sys_exec>:

uint64
sys_exec(void)
{
    8000504e:	7145                	addi	sp,sp,-464
    80005050:	e786                	sd	ra,456(sp)
    80005052:	e3a2                	sd	s0,448(sp)
    80005054:	ff26                	sd	s1,440(sp)
    80005056:	fb4a                	sd	s2,432(sp)
    80005058:	f74e                	sd	s3,424(sp)
    8000505a:	f352                	sd	s4,416(sp)
    8000505c:	ef56                	sd	s5,408(sp)
    8000505e:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005060:	08000613          	li	a2,128
    80005064:	f4040593          	addi	a1,s0,-192
    80005068:	4501                	li	a0,0
    8000506a:	ffffd097          	auipc	ra,0xffffd
    8000506e:	208080e7          	jalr	520(ra) # 80002272 <argstr>
    return -1;
    80005072:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005074:	0c054b63          	bltz	a0,8000514a <sys_exec+0xfc>
    80005078:	e3840593          	addi	a1,s0,-456
    8000507c:	4505                	li	a0,1
    8000507e:	ffffd097          	auipc	ra,0xffffd
    80005082:	1d2080e7          	jalr	466(ra) # 80002250 <argaddr>
    80005086:	0c054263          	bltz	a0,8000514a <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    8000508a:	10000613          	li	a2,256
    8000508e:	4581                	li	a1,0
    80005090:	e4040513          	addi	a0,s0,-448
    80005094:	ffffb097          	auipc	ra,0xffffb
    80005098:	22a080e7          	jalr	554(ra) # 800002be <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    8000509c:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    800050a0:	89a6                	mv	s3,s1
    800050a2:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800050a4:	02000a13          	li	s4,32
    800050a8:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800050ac:	00391513          	slli	a0,s2,0x3
    800050b0:	e3040593          	addi	a1,s0,-464
    800050b4:	e3843783          	ld	a5,-456(s0)
    800050b8:	953e                	add	a0,a0,a5
    800050ba:	ffffd097          	auipc	ra,0xffffd
    800050be:	0da080e7          	jalr	218(ra) # 80002194 <fetchaddr>
    800050c2:	02054a63          	bltz	a0,800050f6 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    800050c6:	e3043783          	ld	a5,-464(s0)
    800050ca:	c3b9                	beqz	a5,80005110 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800050cc:	ffffb097          	auipc	ra,0xffffb
    800050d0:	0da080e7          	jalr	218(ra) # 800001a6 <kalloc>
    800050d4:	85aa                	mv	a1,a0
    800050d6:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800050da:	cd11                	beqz	a0,800050f6 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800050dc:	6605                	lui	a2,0x1
    800050de:	e3043503          	ld	a0,-464(s0)
    800050e2:	ffffd097          	auipc	ra,0xffffd
    800050e6:	104080e7          	jalr	260(ra) # 800021e6 <fetchstr>
    800050ea:	00054663          	bltz	a0,800050f6 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    800050ee:	0905                	addi	s2,s2,1
    800050f0:	09a1                	addi	s3,s3,8
    800050f2:	fb491be3          	bne	s2,s4,800050a8 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050f6:	f4040913          	addi	s2,s0,-192
    800050fa:	6088                	ld	a0,0(s1)
    800050fc:	c531                	beqz	a0,80005148 <sys_exec+0xfa>
    kfree(argv[i]);
    800050fe:	ffffb097          	auipc	ra,0xffffb
    80005102:	f1e080e7          	jalr	-226(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005106:	04a1                	addi	s1,s1,8
    80005108:	ff2499e3          	bne	s1,s2,800050fa <sys_exec+0xac>
  return -1;
    8000510c:	597d                	li	s2,-1
    8000510e:	a835                	j	8000514a <sys_exec+0xfc>
      argv[i] = 0;
    80005110:	0a8e                	slli	s5,s5,0x3
    80005112:	fc0a8793          	addi	a5,s5,-64 # ffffffffffffefc0 <end+0xffffffff7fdb8d80>
    80005116:	00878ab3          	add	s5,a5,s0
    8000511a:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    8000511e:	e4040593          	addi	a1,s0,-448
    80005122:	f4040513          	addi	a0,s0,-192
    80005126:	fffff097          	auipc	ra,0xfffff
    8000512a:	172080e7          	jalr	370(ra) # 80004298 <exec>
    8000512e:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005130:	f4040993          	addi	s3,s0,-192
    80005134:	6088                	ld	a0,0(s1)
    80005136:	c911                	beqz	a0,8000514a <sys_exec+0xfc>
    kfree(argv[i]);
    80005138:	ffffb097          	auipc	ra,0xffffb
    8000513c:	ee4080e7          	jalr	-284(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005140:	04a1                	addi	s1,s1,8
    80005142:	ff3499e3          	bne	s1,s3,80005134 <sys_exec+0xe6>
    80005146:	a011                	j	8000514a <sys_exec+0xfc>
  return -1;
    80005148:	597d                	li	s2,-1
}
    8000514a:	854a                	mv	a0,s2
    8000514c:	60be                	ld	ra,456(sp)
    8000514e:	641e                	ld	s0,448(sp)
    80005150:	74fa                	ld	s1,440(sp)
    80005152:	795a                	ld	s2,432(sp)
    80005154:	79ba                	ld	s3,424(sp)
    80005156:	7a1a                	ld	s4,416(sp)
    80005158:	6afa                	ld	s5,408(sp)
    8000515a:	6179                	addi	sp,sp,464
    8000515c:	8082                	ret

000000008000515e <sys_pipe>:

uint64
sys_pipe(void)
{
    8000515e:	7139                	addi	sp,sp,-64
    80005160:	fc06                	sd	ra,56(sp)
    80005162:	f822                	sd	s0,48(sp)
    80005164:	f426                	sd	s1,40(sp)
    80005166:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005168:	ffffc097          	auipc	ra,0xffffc
    8000516c:	e36080e7          	jalr	-458(ra) # 80000f9e <myproc>
    80005170:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005172:	fd840593          	addi	a1,s0,-40
    80005176:	4501                	li	a0,0
    80005178:	ffffd097          	auipc	ra,0xffffd
    8000517c:	0d8080e7          	jalr	216(ra) # 80002250 <argaddr>
    return -1;
    80005180:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005182:	0e054063          	bltz	a0,80005262 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005186:	fc840593          	addi	a1,s0,-56
    8000518a:	fd040513          	addi	a0,s0,-48
    8000518e:	fffff097          	auipc	ra,0xfffff
    80005192:	de6080e7          	jalr	-538(ra) # 80003f74 <pipealloc>
    return -1;
    80005196:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005198:	0c054563          	bltz	a0,80005262 <sys_pipe+0x104>
  fd0 = -1;
    8000519c:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800051a0:	fd043503          	ld	a0,-48(s0)
    800051a4:	fffff097          	auipc	ra,0xfffff
    800051a8:	504080e7          	jalr	1284(ra) # 800046a8 <fdalloc>
    800051ac:	fca42223          	sw	a0,-60(s0)
    800051b0:	08054c63          	bltz	a0,80005248 <sys_pipe+0xea>
    800051b4:	fc843503          	ld	a0,-56(s0)
    800051b8:	fffff097          	auipc	ra,0xfffff
    800051bc:	4f0080e7          	jalr	1264(ra) # 800046a8 <fdalloc>
    800051c0:	fca42023          	sw	a0,-64(s0)
    800051c4:	06054963          	bltz	a0,80005236 <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800051c8:	4691                	li	a3,4
    800051ca:	fc440613          	addi	a2,s0,-60
    800051ce:	fd843583          	ld	a1,-40(s0)
    800051d2:	68a8                	ld	a0,80(s1)
    800051d4:	ffffc097          	auipc	ra,0xffffc
    800051d8:	a60080e7          	jalr	-1440(ra) # 80000c34 <copyout>
    800051dc:	02054063          	bltz	a0,800051fc <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800051e0:	4691                	li	a3,4
    800051e2:	fc040613          	addi	a2,s0,-64
    800051e6:	fd843583          	ld	a1,-40(s0)
    800051ea:	0591                	addi	a1,a1,4
    800051ec:	68a8                	ld	a0,80(s1)
    800051ee:	ffffc097          	auipc	ra,0xffffc
    800051f2:	a46080e7          	jalr	-1466(ra) # 80000c34 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800051f6:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800051f8:	06055563          	bgez	a0,80005262 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    800051fc:	fc442783          	lw	a5,-60(s0)
    80005200:	07e9                	addi	a5,a5,26
    80005202:	078e                	slli	a5,a5,0x3
    80005204:	97a6                	add	a5,a5,s1
    80005206:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000520a:	fc042783          	lw	a5,-64(s0)
    8000520e:	07e9                	addi	a5,a5,26
    80005210:	078e                	slli	a5,a5,0x3
    80005212:	00f48533          	add	a0,s1,a5
    80005216:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    8000521a:	fd043503          	ld	a0,-48(s0)
    8000521e:	fffff097          	auipc	ra,0xfffff
    80005222:	a26080e7          	jalr	-1498(ra) # 80003c44 <fileclose>
    fileclose(wf);
    80005226:	fc843503          	ld	a0,-56(s0)
    8000522a:	fffff097          	auipc	ra,0xfffff
    8000522e:	a1a080e7          	jalr	-1510(ra) # 80003c44 <fileclose>
    return -1;
    80005232:	57fd                	li	a5,-1
    80005234:	a03d                	j	80005262 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005236:	fc442783          	lw	a5,-60(s0)
    8000523a:	0007c763          	bltz	a5,80005248 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    8000523e:	07e9                	addi	a5,a5,26
    80005240:	078e                	slli	a5,a5,0x3
    80005242:	97a6                	add	a5,a5,s1
    80005244:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005248:	fd043503          	ld	a0,-48(s0)
    8000524c:	fffff097          	auipc	ra,0xfffff
    80005250:	9f8080e7          	jalr	-1544(ra) # 80003c44 <fileclose>
    fileclose(wf);
    80005254:	fc843503          	ld	a0,-56(s0)
    80005258:	fffff097          	auipc	ra,0xfffff
    8000525c:	9ec080e7          	jalr	-1556(ra) # 80003c44 <fileclose>
    return -1;
    80005260:	57fd                	li	a5,-1
}
    80005262:	853e                	mv	a0,a5
    80005264:	70e2                	ld	ra,56(sp)
    80005266:	7442                	ld	s0,48(sp)
    80005268:	74a2                	ld	s1,40(sp)
    8000526a:	6121                	addi	sp,sp,64
    8000526c:	8082                	ret
	...

0000000080005270 <kernelvec>:
    80005270:	7111                	addi	sp,sp,-256
    80005272:	e006                	sd	ra,0(sp)
    80005274:	e40a                	sd	sp,8(sp)
    80005276:	e80e                	sd	gp,16(sp)
    80005278:	ec12                	sd	tp,24(sp)
    8000527a:	f016                	sd	t0,32(sp)
    8000527c:	f41a                	sd	t1,40(sp)
    8000527e:	f81e                	sd	t2,48(sp)
    80005280:	fc22                	sd	s0,56(sp)
    80005282:	e0a6                	sd	s1,64(sp)
    80005284:	e4aa                	sd	a0,72(sp)
    80005286:	e8ae                	sd	a1,80(sp)
    80005288:	ecb2                	sd	a2,88(sp)
    8000528a:	f0b6                	sd	a3,96(sp)
    8000528c:	f4ba                	sd	a4,104(sp)
    8000528e:	f8be                	sd	a5,112(sp)
    80005290:	fcc2                	sd	a6,120(sp)
    80005292:	e146                	sd	a7,128(sp)
    80005294:	e54a                	sd	s2,136(sp)
    80005296:	e94e                	sd	s3,144(sp)
    80005298:	ed52                	sd	s4,152(sp)
    8000529a:	f156                	sd	s5,160(sp)
    8000529c:	f55a                	sd	s6,168(sp)
    8000529e:	f95e                	sd	s7,176(sp)
    800052a0:	fd62                	sd	s8,184(sp)
    800052a2:	e1e6                	sd	s9,192(sp)
    800052a4:	e5ea                	sd	s10,200(sp)
    800052a6:	e9ee                	sd	s11,208(sp)
    800052a8:	edf2                	sd	t3,216(sp)
    800052aa:	f1f6                	sd	t4,224(sp)
    800052ac:	f5fa                	sd	t5,232(sp)
    800052ae:	f9fe                	sd	t6,240(sp)
    800052b0:	db1fc0ef          	jal	ra,80002060 <kerneltrap>
    800052b4:	6082                	ld	ra,0(sp)
    800052b6:	6122                	ld	sp,8(sp)
    800052b8:	61c2                	ld	gp,16(sp)
    800052ba:	7282                	ld	t0,32(sp)
    800052bc:	7322                	ld	t1,40(sp)
    800052be:	73c2                	ld	t2,48(sp)
    800052c0:	7462                	ld	s0,56(sp)
    800052c2:	6486                	ld	s1,64(sp)
    800052c4:	6526                	ld	a0,72(sp)
    800052c6:	65c6                	ld	a1,80(sp)
    800052c8:	6666                	ld	a2,88(sp)
    800052ca:	7686                	ld	a3,96(sp)
    800052cc:	7726                	ld	a4,104(sp)
    800052ce:	77c6                	ld	a5,112(sp)
    800052d0:	7866                	ld	a6,120(sp)
    800052d2:	688a                	ld	a7,128(sp)
    800052d4:	692a                	ld	s2,136(sp)
    800052d6:	69ca                	ld	s3,144(sp)
    800052d8:	6a6a                	ld	s4,152(sp)
    800052da:	7a8a                	ld	s5,160(sp)
    800052dc:	7b2a                	ld	s6,168(sp)
    800052de:	7bca                	ld	s7,176(sp)
    800052e0:	7c6a                	ld	s8,184(sp)
    800052e2:	6c8e                	ld	s9,192(sp)
    800052e4:	6d2e                	ld	s10,200(sp)
    800052e6:	6dce                	ld	s11,208(sp)
    800052e8:	6e6e                	ld	t3,216(sp)
    800052ea:	7e8e                	ld	t4,224(sp)
    800052ec:	7f2e                	ld	t5,232(sp)
    800052ee:	7fce                	ld	t6,240(sp)
    800052f0:	6111                	addi	sp,sp,256
    800052f2:	10200073          	sret
    800052f6:	00000013          	nop
    800052fa:	00000013          	nop
    800052fe:	0001                	nop

0000000080005300 <timervec>:
    80005300:	34051573          	csrrw	a0,mscratch,a0
    80005304:	e10c                	sd	a1,0(a0)
    80005306:	e510                	sd	a2,8(a0)
    80005308:	e914                	sd	a3,16(a0)
    8000530a:	6d0c                	ld	a1,24(a0)
    8000530c:	7110                	ld	a2,32(a0)
    8000530e:	6194                	ld	a3,0(a1)
    80005310:	96b2                	add	a3,a3,a2
    80005312:	e194                	sd	a3,0(a1)
    80005314:	4589                	li	a1,2
    80005316:	14459073          	csrw	sip,a1
    8000531a:	6914                	ld	a3,16(a0)
    8000531c:	6510                	ld	a2,8(a0)
    8000531e:	610c                	ld	a1,0(a0)
    80005320:	34051573          	csrrw	a0,mscratch,a0
    80005324:	30200073          	mret
	...

000000008000532a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000532a:	1141                	addi	sp,sp,-16
    8000532c:	e422                	sd	s0,8(sp)
    8000532e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005330:	0c0007b7          	lui	a5,0xc000
    80005334:	4705                	li	a4,1
    80005336:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005338:	c3d8                	sw	a4,4(a5)
}
    8000533a:	6422                	ld	s0,8(sp)
    8000533c:	0141                	addi	sp,sp,16
    8000533e:	8082                	ret

0000000080005340 <plicinithart>:

void
plicinithart(void)
{
    80005340:	1141                	addi	sp,sp,-16
    80005342:	e406                	sd	ra,8(sp)
    80005344:	e022                	sd	s0,0(sp)
    80005346:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005348:	ffffc097          	auipc	ra,0xffffc
    8000534c:	c2a080e7          	jalr	-982(ra) # 80000f72 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005350:	0085171b          	slliw	a4,a0,0x8
    80005354:	0c0027b7          	lui	a5,0xc002
    80005358:	97ba                	add	a5,a5,a4
    8000535a:	40200713          	li	a4,1026
    8000535e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005362:	00d5151b          	slliw	a0,a0,0xd
    80005366:	0c2017b7          	lui	a5,0xc201
    8000536a:	97aa                	add	a5,a5,a0
    8000536c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005370:	60a2                	ld	ra,8(sp)
    80005372:	6402                	ld	s0,0(sp)
    80005374:	0141                	addi	sp,sp,16
    80005376:	8082                	ret

0000000080005378 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005378:	1141                	addi	sp,sp,-16
    8000537a:	e406                	sd	ra,8(sp)
    8000537c:	e022                	sd	s0,0(sp)
    8000537e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005380:	ffffc097          	auipc	ra,0xffffc
    80005384:	bf2080e7          	jalr	-1038(ra) # 80000f72 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005388:	00d5151b          	slliw	a0,a0,0xd
    8000538c:	0c2017b7          	lui	a5,0xc201
    80005390:	97aa                	add	a5,a5,a0
  return irq;
}
    80005392:	43c8                	lw	a0,4(a5)
    80005394:	60a2                	ld	ra,8(sp)
    80005396:	6402                	ld	s0,0(sp)
    80005398:	0141                	addi	sp,sp,16
    8000539a:	8082                	ret

000000008000539c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000539c:	1101                	addi	sp,sp,-32
    8000539e:	ec06                	sd	ra,24(sp)
    800053a0:	e822                	sd	s0,16(sp)
    800053a2:	e426                	sd	s1,8(sp)
    800053a4:	1000                	addi	s0,sp,32
    800053a6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800053a8:	ffffc097          	auipc	ra,0xffffc
    800053ac:	bca080e7          	jalr	-1078(ra) # 80000f72 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800053b0:	00d5151b          	slliw	a0,a0,0xd
    800053b4:	0c2017b7          	lui	a5,0xc201
    800053b8:	97aa                	add	a5,a5,a0
    800053ba:	c3c4                	sw	s1,4(a5)
}
    800053bc:	60e2                	ld	ra,24(sp)
    800053be:	6442                	ld	s0,16(sp)
    800053c0:	64a2                	ld	s1,8(sp)
    800053c2:	6105                	addi	sp,sp,32
    800053c4:	8082                	ret

00000000800053c6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800053c6:	1141                	addi	sp,sp,-16
    800053c8:	e406                	sd	ra,8(sp)
    800053ca:	e022                	sd	s0,0(sp)
    800053cc:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800053ce:	479d                	li	a5,7
    800053d0:	06a7c863          	blt	a5,a0,80005440 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    800053d4:	00236717          	auipc	a4,0x236
    800053d8:	c2c70713          	addi	a4,a4,-980 # 8023b000 <disk>
    800053dc:	972a                	add	a4,a4,a0
    800053de:	6789                	lui	a5,0x2
    800053e0:	97ba                	add	a5,a5,a4
    800053e2:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800053e6:	e7ad                	bnez	a5,80005450 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800053e8:	00451793          	slli	a5,a0,0x4
    800053ec:	00238717          	auipc	a4,0x238
    800053f0:	c1470713          	addi	a4,a4,-1004 # 8023d000 <disk+0x2000>
    800053f4:	6314                	ld	a3,0(a4)
    800053f6:	96be                	add	a3,a3,a5
    800053f8:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800053fc:	6314                	ld	a3,0(a4)
    800053fe:	96be                	add	a3,a3,a5
    80005400:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005404:	6314                	ld	a3,0(a4)
    80005406:	96be                	add	a3,a3,a5
    80005408:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000540c:	6318                	ld	a4,0(a4)
    8000540e:	97ba                	add	a5,a5,a4
    80005410:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005414:	00236717          	auipc	a4,0x236
    80005418:	bec70713          	addi	a4,a4,-1044 # 8023b000 <disk>
    8000541c:	972a                	add	a4,a4,a0
    8000541e:	6789                	lui	a5,0x2
    80005420:	97ba                	add	a5,a5,a4
    80005422:	4705                	li	a4,1
    80005424:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    80005428:	00238517          	auipc	a0,0x238
    8000542c:	bf050513          	addi	a0,a0,-1040 # 8023d018 <disk+0x2018>
    80005430:	ffffc097          	auipc	ra,0xffffc
    80005434:	3be080e7          	jalr	958(ra) # 800017ee <wakeup>
}
    80005438:	60a2                	ld	ra,8(sp)
    8000543a:	6402                	ld	s0,0(sp)
    8000543c:	0141                	addi	sp,sp,16
    8000543e:	8082                	ret
    panic("free_desc 1");
    80005440:	00003517          	auipc	a0,0x3
    80005444:	2b850513          	addi	a0,a0,696 # 800086f8 <syscalls+0x320>
    80005448:	00001097          	auipc	ra,0x1
    8000544c:	9c8080e7          	jalr	-1592(ra) # 80005e10 <panic>
    panic("free_desc 2");
    80005450:	00003517          	auipc	a0,0x3
    80005454:	2b850513          	addi	a0,a0,696 # 80008708 <syscalls+0x330>
    80005458:	00001097          	auipc	ra,0x1
    8000545c:	9b8080e7          	jalr	-1608(ra) # 80005e10 <panic>

0000000080005460 <virtio_disk_init>:
{
    80005460:	1101                	addi	sp,sp,-32
    80005462:	ec06                	sd	ra,24(sp)
    80005464:	e822                	sd	s0,16(sp)
    80005466:	e426                	sd	s1,8(sp)
    80005468:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000546a:	00003597          	auipc	a1,0x3
    8000546e:	2ae58593          	addi	a1,a1,686 # 80008718 <syscalls+0x340>
    80005472:	00238517          	auipc	a0,0x238
    80005476:	cb650513          	addi	a0,a0,-842 # 8023d128 <disk+0x2128>
    8000547a:	00001097          	auipc	ra,0x1
    8000547e:	e3e080e7          	jalr	-450(ra) # 800062b8 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005482:	100017b7          	lui	a5,0x10001
    80005486:	4398                	lw	a4,0(a5)
    80005488:	2701                	sext.w	a4,a4
    8000548a:	747277b7          	lui	a5,0x74727
    8000548e:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005492:	0ef71063          	bne	a4,a5,80005572 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005496:	100017b7          	lui	a5,0x10001
    8000549a:	43dc                	lw	a5,4(a5)
    8000549c:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000549e:	4705                	li	a4,1
    800054a0:	0ce79963          	bne	a5,a4,80005572 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800054a4:	100017b7          	lui	a5,0x10001
    800054a8:	479c                	lw	a5,8(a5)
    800054aa:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800054ac:	4709                	li	a4,2
    800054ae:	0ce79263          	bne	a5,a4,80005572 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800054b2:	100017b7          	lui	a5,0x10001
    800054b6:	47d8                	lw	a4,12(a5)
    800054b8:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800054ba:	554d47b7          	lui	a5,0x554d4
    800054be:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800054c2:	0af71863          	bne	a4,a5,80005572 <virtio_disk_init+0x112>
  *R(VIRTIO_MMIO_STATUS) = status;
    800054c6:	100017b7          	lui	a5,0x10001
    800054ca:	4705                	li	a4,1
    800054cc:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800054ce:	470d                	li	a4,3
    800054d0:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800054d2:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800054d4:	c7ffe6b7          	lui	a3,0xc7ffe
    800054d8:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47db851f>
    800054dc:	8f75                	and	a4,a4,a3
    800054de:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800054e0:	472d                	li	a4,11
    800054e2:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800054e4:	473d                	li	a4,15
    800054e6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    800054e8:	6705                	lui	a4,0x1
    800054ea:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800054ec:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800054f0:	5bdc                	lw	a5,52(a5)
    800054f2:	2781                	sext.w	a5,a5
  if(max == 0)
    800054f4:	c7d9                	beqz	a5,80005582 <virtio_disk_init+0x122>
  if(max < NUM)
    800054f6:	471d                	li	a4,7
    800054f8:	08f77d63          	bgeu	a4,a5,80005592 <virtio_disk_init+0x132>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800054fc:	100014b7          	lui	s1,0x10001
    80005500:	47a1                	li	a5,8
    80005502:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005504:	6609                	lui	a2,0x2
    80005506:	4581                	li	a1,0
    80005508:	00236517          	auipc	a0,0x236
    8000550c:	af850513          	addi	a0,a0,-1288 # 8023b000 <disk>
    80005510:	ffffb097          	auipc	ra,0xffffb
    80005514:	dae080e7          	jalr	-594(ra) # 800002be <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005518:	00236717          	auipc	a4,0x236
    8000551c:	ae870713          	addi	a4,a4,-1304 # 8023b000 <disk>
    80005520:	00c75793          	srli	a5,a4,0xc
    80005524:	2781                	sext.w	a5,a5
    80005526:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    80005528:	00238797          	auipc	a5,0x238
    8000552c:	ad878793          	addi	a5,a5,-1320 # 8023d000 <disk+0x2000>
    80005530:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005532:	00236717          	auipc	a4,0x236
    80005536:	b4e70713          	addi	a4,a4,-1202 # 8023b080 <disk+0x80>
    8000553a:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    8000553c:	00237717          	auipc	a4,0x237
    80005540:	ac470713          	addi	a4,a4,-1340 # 8023c000 <disk+0x1000>
    80005544:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005546:	4705                	li	a4,1
    80005548:	00e78c23          	sb	a4,24(a5)
    8000554c:	00e78ca3          	sb	a4,25(a5)
    80005550:	00e78d23          	sb	a4,26(a5)
    80005554:	00e78da3          	sb	a4,27(a5)
    80005558:	00e78e23          	sb	a4,28(a5)
    8000555c:	00e78ea3          	sb	a4,29(a5)
    80005560:	00e78f23          	sb	a4,30(a5)
    80005564:	00e78fa3          	sb	a4,31(a5)
}
    80005568:	60e2                	ld	ra,24(sp)
    8000556a:	6442                	ld	s0,16(sp)
    8000556c:	64a2                	ld	s1,8(sp)
    8000556e:	6105                	addi	sp,sp,32
    80005570:	8082                	ret
    panic("could not find virtio disk");
    80005572:	00003517          	auipc	a0,0x3
    80005576:	1b650513          	addi	a0,a0,438 # 80008728 <syscalls+0x350>
    8000557a:	00001097          	auipc	ra,0x1
    8000557e:	896080e7          	jalr	-1898(ra) # 80005e10 <panic>
    panic("virtio disk has no queue 0");
    80005582:	00003517          	auipc	a0,0x3
    80005586:	1c650513          	addi	a0,a0,454 # 80008748 <syscalls+0x370>
    8000558a:	00001097          	auipc	ra,0x1
    8000558e:	886080e7          	jalr	-1914(ra) # 80005e10 <panic>
    panic("virtio disk max queue too short");
    80005592:	00003517          	auipc	a0,0x3
    80005596:	1d650513          	addi	a0,a0,470 # 80008768 <syscalls+0x390>
    8000559a:	00001097          	auipc	ra,0x1
    8000559e:	876080e7          	jalr	-1930(ra) # 80005e10 <panic>

00000000800055a2 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800055a2:	7119                	addi	sp,sp,-128
    800055a4:	fc86                	sd	ra,120(sp)
    800055a6:	f8a2                	sd	s0,112(sp)
    800055a8:	f4a6                	sd	s1,104(sp)
    800055aa:	f0ca                	sd	s2,96(sp)
    800055ac:	ecce                	sd	s3,88(sp)
    800055ae:	e8d2                	sd	s4,80(sp)
    800055b0:	e4d6                	sd	s5,72(sp)
    800055b2:	e0da                	sd	s6,64(sp)
    800055b4:	fc5e                	sd	s7,56(sp)
    800055b6:	f862                	sd	s8,48(sp)
    800055b8:	f466                	sd	s9,40(sp)
    800055ba:	f06a                	sd	s10,32(sp)
    800055bc:	ec6e                	sd	s11,24(sp)
    800055be:	0100                	addi	s0,sp,128
    800055c0:	8aaa                	mv	s5,a0
    800055c2:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800055c4:	00c52c83          	lw	s9,12(a0)
    800055c8:	001c9c9b          	slliw	s9,s9,0x1
    800055cc:	1c82                	slli	s9,s9,0x20
    800055ce:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800055d2:	00238517          	auipc	a0,0x238
    800055d6:	b5650513          	addi	a0,a0,-1194 # 8023d128 <disk+0x2128>
    800055da:	00001097          	auipc	ra,0x1
    800055de:	d6e080e7          	jalr	-658(ra) # 80006348 <acquire>
  for(int i = 0; i < 3; i++){
    800055e2:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800055e4:	44a1                	li	s1,8
      disk.free[i] = 0;
    800055e6:	00236c17          	auipc	s8,0x236
    800055ea:	a1ac0c13          	addi	s8,s8,-1510 # 8023b000 <disk>
    800055ee:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    800055f0:	4b0d                	li	s6,3
    800055f2:	a0ad                	j	8000565c <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    800055f4:	00fc0733          	add	a4,s8,a5
    800055f8:	975e                	add	a4,a4,s7
    800055fa:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800055fe:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005600:	0207c563          	bltz	a5,8000562a <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005604:	2905                	addiw	s2,s2,1
    80005606:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    80005608:	19690c63          	beq	s2,s6,800057a0 <virtio_disk_rw+0x1fe>
    idx[i] = alloc_desc();
    8000560c:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    8000560e:	00238717          	auipc	a4,0x238
    80005612:	a0a70713          	addi	a4,a4,-1526 # 8023d018 <disk+0x2018>
    80005616:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005618:	00074683          	lbu	a3,0(a4)
    8000561c:	fee1                	bnez	a3,800055f4 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    8000561e:	2785                	addiw	a5,a5,1
    80005620:	0705                	addi	a4,a4,1
    80005622:	fe979be3          	bne	a5,s1,80005618 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    80005626:	57fd                	li	a5,-1
    80005628:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    8000562a:	01205d63          	blez	s2,80005644 <virtio_disk_rw+0xa2>
    8000562e:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80005630:	000a2503          	lw	a0,0(s4)
    80005634:	00000097          	auipc	ra,0x0
    80005638:	d92080e7          	jalr	-622(ra) # 800053c6 <free_desc>
      for(int j = 0; j < i; j++)
    8000563c:	2d85                	addiw	s11,s11,1
    8000563e:	0a11                	addi	s4,s4,4
    80005640:	ff2d98e3          	bne	s11,s2,80005630 <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005644:	00238597          	auipc	a1,0x238
    80005648:	ae458593          	addi	a1,a1,-1308 # 8023d128 <disk+0x2128>
    8000564c:	00238517          	auipc	a0,0x238
    80005650:	9cc50513          	addi	a0,a0,-1588 # 8023d018 <disk+0x2018>
    80005654:	ffffc097          	auipc	ra,0xffffc
    80005658:	00e080e7          	jalr	14(ra) # 80001662 <sleep>
  for(int i = 0; i < 3; i++){
    8000565c:	f8040a13          	addi	s4,s0,-128
{
    80005660:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80005662:	894e                	mv	s2,s3
    80005664:	b765                	j	8000560c <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005666:	00238697          	auipc	a3,0x238
    8000566a:	99a6b683          	ld	a3,-1638(a3) # 8023d000 <disk+0x2000>
    8000566e:	96ba                	add	a3,a3,a4
    80005670:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005674:	00236817          	auipc	a6,0x236
    80005678:	98c80813          	addi	a6,a6,-1652 # 8023b000 <disk>
    8000567c:	00238697          	auipc	a3,0x238
    80005680:	98468693          	addi	a3,a3,-1660 # 8023d000 <disk+0x2000>
    80005684:	6290                	ld	a2,0(a3)
    80005686:	963a                	add	a2,a2,a4
    80005688:	00c65583          	lhu	a1,12(a2)
    8000568c:	0015e593          	ori	a1,a1,1
    80005690:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    80005694:	f8842603          	lw	a2,-120(s0)
    80005698:	628c                	ld	a1,0(a3)
    8000569a:	972e                	add	a4,a4,a1
    8000569c:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800056a0:	20050593          	addi	a1,a0,512
    800056a4:	0592                	slli	a1,a1,0x4
    800056a6:	95c2                	add	a1,a1,a6
    800056a8:	577d                	li	a4,-1
    800056aa:	02e58823          	sb	a4,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800056ae:	00461713          	slli	a4,a2,0x4
    800056b2:	6290                	ld	a2,0(a3)
    800056b4:	963a                	add	a2,a2,a4
    800056b6:	03078793          	addi	a5,a5,48
    800056ba:	97c2                	add	a5,a5,a6
    800056bc:	e21c                	sd	a5,0(a2)
  disk.desc[idx[2]].len = 1;
    800056be:	629c                	ld	a5,0(a3)
    800056c0:	97ba                	add	a5,a5,a4
    800056c2:	4605                	li	a2,1
    800056c4:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800056c6:	629c                	ld	a5,0(a3)
    800056c8:	97ba                	add	a5,a5,a4
    800056ca:	4809                	li	a6,2
    800056cc:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    800056d0:	629c                	ld	a5,0(a3)
    800056d2:	97ba                	add	a5,a5,a4
    800056d4:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800056d8:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    800056dc:	0355b423          	sd	s5,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800056e0:	6698                	ld	a4,8(a3)
    800056e2:	00275783          	lhu	a5,2(a4)
    800056e6:	8b9d                	andi	a5,a5,7
    800056e8:	0786                	slli	a5,a5,0x1
    800056ea:	973e                	add	a4,a4,a5
    800056ec:	00a71223          	sh	a0,4(a4)

  __sync_synchronize();
    800056f0:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800056f4:	6698                	ld	a4,8(a3)
    800056f6:	00275783          	lhu	a5,2(a4)
    800056fa:	2785                	addiw	a5,a5,1
    800056fc:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005700:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005704:	100017b7          	lui	a5,0x10001
    80005708:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8000570c:	004aa783          	lw	a5,4(s5)
    80005710:	02c79163          	bne	a5,a2,80005732 <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    80005714:	00238917          	auipc	s2,0x238
    80005718:	a1490913          	addi	s2,s2,-1516 # 8023d128 <disk+0x2128>
  while(b->disk == 1) {
    8000571c:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    8000571e:	85ca                	mv	a1,s2
    80005720:	8556                	mv	a0,s5
    80005722:	ffffc097          	auipc	ra,0xffffc
    80005726:	f40080e7          	jalr	-192(ra) # 80001662 <sleep>
  while(b->disk == 1) {
    8000572a:	004aa783          	lw	a5,4(s5)
    8000572e:	fe9788e3          	beq	a5,s1,8000571e <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    80005732:	f8042903          	lw	s2,-128(s0)
    80005736:	20090713          	addi	a4,s2,512
    8000573a:	0712                	slli	a4,a4,0x4
    8000573c:	00236797          	auipc	a5,0x236
    80005740:	8c478793          	addi	a5,a5,-1852 # 8023b000 <disk>
    80005744:	97ba                	add	a5,a5,a4
    80005746:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    8000574a:	00238997          	auipc	s3,0x238
    8000574e:	8b698993          	addi	s3,s3,-1866 # 8023d000 <disk+0x2000>
    80005752:	00491713          	slli	a4,s2,0x4
    80005756:	0009b783          	ld	a5,0(s3)
    8000575a:	97ba                	add	a5,a5,a4
    8000575c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005760:	854a                	mv	a0,s2
    80005762:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005766:	00000097          	auipc	ra,0x0
    8000576a:	c60080e7          	jalr	-928(ra) # 800053c6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000576e:	8885                	andi	s1,s1,1
    80005770:	f0ed                	bnez	s1,80005752 <virtio_disk_rw+0x1b0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005772:	00238517          	auipc	a0,0x238
    80005776:	9b650513          	addi	a0,a0,-1610 # 8023d128 <disk+0x2128>
    8000577a:	00001097          	auipc	ra,0x1
    8000577e:	c82080e7          	jalr	-894(ra) # 800063fc <release>
}
    80005782:	70e6                	ld	ra,120(sp)
    80005784:	7446                	ld	s0,112(sp)
    80005786:	74a6                	ld	s1,104(sp)
    80005788:	7906                	ld	s2,96(sp)
    8000578a:	69e6                	ld	s3,88(sp)
    8000578c:	6a46                	ld	s4,80(sp)
    8000578e:	6aa6                	ld	s5,72(sp)
    80005790:	6b06                	ld	s6,64(sp)
    80005792:	7be2                	ld	s7,56(sp)
    80005794:	7c42                	ld	s8,48(sp)
    80005796:	7ca2                	ld	s9,40(sp)
    80005798:	7d02                	ld	s10,32(sp)
    8000579a:	6de2                	ld	s11,24(sp)
    8000579c:	6109                	addi	sp,sp,128
    8000579e:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800057a0:	f8042503          	lw	a0,-128(s0)
    800057a4:	20050793          	addi	a5,a0,512
    800057a8:	0792                	slli	a5,a5,0x4
  if(write)
    800057aa:	00236817          	auipc	a6,0x236
    800057ae:	85680813          	addi	a6,a6,-1962 # 8023b000 <disk>
    800057b2:	00f80733          	add	a4,a6,a5
    800057b6:	01a036b3          	snez	a3,s10
    800057ba:	0ad72423          	sw	a3,168(a4)
  buf0->reserved = 0;
    800057be:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    800057c2:	0b973823          	sd	s9,176(a4)
  disk.desc[idx[0]].addr = (uint64) buf0;
    800057c6:	7679                	lui	a2,0xffffe
    800057c8:	963e                	add	a2,a2,a5
    800057ca:	00238697          	auipc	a3,0x238
    800057ce:	83668693          	addi	a3,a3,-1994 # 8023d000 <disk+0x2000>
    800057d2:	6298                	ld	a4,0(a3)
    800057d4:	9732                	add	a4,a4,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800057d6:	0a878593          	addi	a1,a5,168
    800057da:	95c2                	add	a1,a1,a6
  disk.desc[idx[0]].addr = (uint64) buf0;
    800057dc:	e30c                	sd	a1,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800057de:	6298                	ld	a4,0(a3)
    800057e0:	9732                	add	a4,a4,a2
    800057e2:	45c1                	li	a1,16
    800057e4:	c70c                	sw	a1,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800057e6:	6298                	ld	a4,0(a3)
    800057e8:	9732                	add	a4,a4,a2
    800057ea:	4585                	li	a1,1
    800057ec:	00b71623          	sh	a1,12(a4)
  disk.desc[idx[0]].next = idx[1];
    800057f0:	f8442703          	lw	a4,-124(s0)
    800057f4:	628c                	ld	a1,0(a3)
    800057f6:	962e                	add	a2,a2,a1
    800057f8:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7fdb7dce>
  disk.desc[idx[1]].addr = (uint64) b->data;
    800057fc:	0712                	slli	a4,a4,0x4
    800057fe:	6290                	ld	a2,0(a3)
    80005800:	963a                	add	a2,a2,a4
    80005802:	058a8593          	addi	a1,s5,88
    80005806:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005808:	6294                	ld	a3,0(a3)
    8000580a:	96ba                	add	a3,a3,a4
    8000580c:	40000613          	li	a2,1024
    80005810:	c690                	sw	a2,8(a3)
  if(write)
    80005812:	e40d1ae3          	bnez	s10,80005666 <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80005816:	00237697          	auipc	a3,0x237
    8000581a:	7ea6b683          	ld	a3,2026(a3) # 8023d000 <disk+0x2000>
    8000581e:	96ba                	add	a3,a3,a4
    80005820:	4609                	li	a2,2
    80005822:	00c69623          	sh	a2,12(a3)
    80005826:	b5b9                	j	80005674 <virtio_disk_rw+0xd2>

0000000080005828 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005828:	1101                	addi	sp,sp,-32
    8000582a:	ec06                	sd	ra,24(sp)
    8000582c:	e822                	sd	s0,16(sp)
    8000582e:	e426                	sd	s1,8(sp)
    80005830:	e04a                	sd	s2,0(sp)
    80005832:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005834:	00238517          	auipc	a0,0x238
    80005838:	8f450513          	addi	a0,a0,-1804 # 8023d128 <disk+0x2128>
    8000583c:	00001097          	auipc	ra,0x1
    80005840:	b0c080e7          	jalr	-1268(ra) # 80006348 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005844:	10001737          	lui	a4,0x10001
    80005848:	533c                	lw	a5,96(a4)
    8000584a:	8b8d                	andi	a5,a5,3
    8000584c:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    8000584e:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005852:	00237797          	auipc	a5,0x237
    80005856:	7ae78793          	addi	a5,a5,1966 # 8023d000 <disk+0x2000>
    8000585a:	6b94                	ld	a3,16(a5)
    8000585c:	0207d703          	lhu	a4,32(a5)
    80005860:	0026d783          	lhu	a5,2(a3)
    80005864:	06f70163          	beq	a4,a5,800058c6 <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005868:	00235917          	auipc	s2,0x235
    8000586c:	79890913          	addi	s2,s2,1944 # 8023b000 <disk>
    80005870:	00237497          	auipc	s1,0x237
    80005874:	79048493          	addi	s1,s1,1936 # 8023d000 <disk+0x2000>
    __sync_synchronize();
    80005878:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000587c:	6898                	ld	a4,16(s1)
    8000587e:	0204d783          	lhu	a5,32(s1)
    80005882:	8b9d                	andi	a5,a5,7
    80005884:	078e                	slli	a5,a5,0x3
    80005886:	97ba                	add	a5,a5,a4
    80005888:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000588a:	20078713          	addi	a4,a5,512
    8000588e:	0712                	slli	a4,a4,0x4
    80005890:	974a                	add	a4,a4,s2
    80005892:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    80005896:	e731                	bnez	a4,800058e2 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005898:	20078793          	addi	a5,a5,512
    8000589c:	0792                	slli	a5,a5,0x4
    8000589e:	97ca                	add	a5,a5,s2
    800058a0:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    800058a2:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800058a6:	ffffc097          	auipc	ra,0xffffc
    800058aa:	f48080e7          	jalr	-184(ra) # 800017ee <wakeup>

    disk.used_idx += 1;
    800058ae:	0204d783          	lhu	a5,32(s1)
    800058b2:	2785                	addiw	a5,a5,1
    800058b4:	17c2                	slli	a5,a5,0x30
    800058b6:	93c1                	srli	a5,a5,0x30
    800058b8:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800058bc:	6898                	ld	a4,16(s1)
    800058be:	00275703          	lhu	a4,2(a4)
    800058c2:	faf71be3          	bne	a4,a5,80005878 <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    800058c6:	00238517          	auipc	a0,0x238
    800058ca:	86250513          	addi	a0,a0,-1950 # 8023d128 <disk+0x2128>
    800058ce:	00001097          	auipc	ra,0x1
    800058d2:	b2e080e7          	jalr	-1234(ra) # 800063fc <release>
}
    800058d6:	60e2                	ld	ra,24(sp)
    800058d8:	6442                	ld	s0,16(sp)
    800058da:	64a2                	ld	s1,8(sp)
    800058dc:	6902                	ld	s2,0(sp)
    800058de:	6105                	addi	sp,sp,32
    800058e0:	8082                	ret
      panic("virtio_disk_intr status");
    800058e2:	00003517          	auipc	a0,0x3
    800058e6:	ea650513          	addi	a0,a0,-346 # 80008788 <syscalls+0x3b0>
    800058ea:	00000097          	auipc	ra,0x0
    800058ee:	526080e7          	jalr	1318(ra) # 80005e10 <panic>

00000000800058f2 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    800058f2:	1141                	addi	sp,sp,-16
    800058f4:	e422                	sd	s0,8(sp)
    800058f6:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800058f8:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    800058fc:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005900:	0037979b          	slliw	a5,a5,0x3
    80005904:	02004737          	lui	a4,0x2004
    80005908:	97ba                	add	a5,a5,a4
    8000590a:	0200c737          	lui	a4,0x200c
    8000590e:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005912:	000f4637          	lui	a2,0xf4
    80005916:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    8000591a:	9732                	add	a4,a4,a2
    8000591c:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    8000591e:	00259693          	slli	a3,a1,0x2
    80005922:	96ae                	add	a3,a3,a1
    80005924:	068e                	slli	a3,a3,0x3
    80005926:	00238717          	auipc	a4,0x238
    8000592a:	6da70713          	addi	a4,a4,1754 # 8023e000 <timer_scratch>
    8000592e:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005930:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005932:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005934:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005938:	00000797          	auipc	a5,0x0
    8000593c:	9c878793          	addi	a5,a5,-1592 # 80005300 <timervec>
    80005940:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005944:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005948:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000594c:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005950:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005954:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005958:	30479073          	csrw	mie,a5
}
    8000595c:	6422                	ld	s0,8(sp)
    8000595e:	0141                	addi	sp,sp,16
    80005960:	8082                	ret

0000000080005962 <start>:
{
    80005962:	1141                	addi	sp,sp,-16
    80005964:	e406                	sd	ra,8(sp)
    80005966:	e022                	sd	s0,0(sp)
    80005968:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000596a:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000596e:	7779                	lui	a4,0xffffe
    80005970:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7fdb85bf>
    80005974:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005976:	6705                	lui	a4,0x1
    80005978:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000597c:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000597e:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005982:	ffffb797          	auipc	a5,0xffffb
    80005986:	ae278793          	addi	a5,a5,-1310 # 80000464 <main>
    8000598a:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    8000598e:	4781                	li	a5,0
    80005990:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005994:	67c1                	lui	a5,0x10
    80005996:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005998:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    8000599c:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800059a0:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800059a4:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800059a8:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800059ac:	57fd                	li	a5,-1
    800059ae:	83a9                	srli	a5,a5,0xa
    800059b0:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800059b4:	47bd                	li	a5,15
    800059b6:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800059ba:	00000097          	auipc	ra,0x0
    800059be:	f38080e7          	jalr	-200(ra) # 800058f2 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800059c2:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800059c6:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    800059c8:	823e                	mv	tp,a5
  asm volatile("mret");
    800059ca:	30200073          	mret
}
    800059ce:	60a2                	ld	ra,8(sp)
    800059d0:	6402                	ld	s0,0(sp)
    800059d2:	0141                	addi	sp,sp,16
    800059d4:	8082                	ret

00000000800059d6 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800059d6:	715d                	addi	sp,sp,-80
    800059d8:	e486                	sd	ra,72(sp)
    800059da:	e0a2                	sd	s0,64(sp)
    800059dc:	fc26                	sd	s1,56(sp)
    800059de:	f84a                	sd	s2,48(sp)
    800059e0:	f44e                	sd	s3,40(sp)
    800059e2:	f052                	sd	s4,32(sp)
    800059e4:	ec56                	sd	s5,24(sp)
    800059e6:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800059e8:	04c05763          	blez	a2,80005a36 <consolewrite+0x60>
    800059ec:	8a2a                	mv	s4,a0
    800059ee:	84ae                	mv	s1,a1
    800059f0:	89b2                	mv	s3,a2
    800059f2:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800059f4:	5afd                	li	s5,-1
    800059f6:	4685                	li	a3,1
    800059f8:	8626                	mv	a2,s1
    800059fa:	85d2                	mv	a1,s4
    800059fc:	fbf40513          	addi	a0,s0,-65
    80005a00:	ffffc097          	auipc	ra,0xffffc
    80005a04:	0ba080e7          	jalr	186(ra) # 80001aba <either_copyin>
    80005a08:	01550d63          	beq	a0,s5,80005a22 <consolewrite+0x4c>
      break;
    uartputc(c);
    80005a0c:	fbf44503          	lbu	a0,-65(s0)
    80005a10:	00000097          	auipc	ra,0x0
    80005a14:	77e080e7          	jalr	1918(ra) # 8000618e <uartputc>
  for(i = 0; i < n; i++){
    80005a18:	2905                	addiw	s2,s2,1
    80005a1a:	0485                	addi	s1,s1,1
    80005a1c:	fd299de3          	bne	s3,s2,800059f6 <consolewrite+0x20>
    80005a20:	894e                	mv	s2,s3
  }

  return i;
}
    80005a22:	854a                	mv	a0,s2
    80005a24:	60a6                	ld	ra,72(sp)
    80005a26:	6406                	ld	s0,64(sp)
    80005a28:	74e2                	ld	s1,56(sp)
    80005a2a:	7942                	ld	s2,48(sp)
    80005a2c:	79a2                	ld	s3,40(sp)
    80005a2e:	7a02                	ld	s4,32(sp)
    80005a30:	6ae2                	ld	s5,24(sp)
    80005a32:	6161                	addi	sp,sp,80
    80005a34:	8082                	ret
  for(i = 0; i < n; i++){
    80005a36:	4901                	li	s2,0
    80005a38:	b7ed                	j	80005a22 <consolewrite+0x4c>

0000000080005a3a <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005a3a:	7159                	addi	sp,sp,-112
    80005a3c:	f486                	sd	ra,104(sp)
    80005a3e:	f0a2                	sd	s0,96(sp)
    80005a40:	eca6                	sd	s1,88(sp)
    80005a42:	e8ca                	sd	s2,80(sp)
    80005a44:	e4ce                	sd	s3,72(sp)
    80005a46:	e0d2                	sd	s4,64(sp)
    80005a48:	fc56                	sd	s5,56(sp)
    80005a4a:	f85a                	sd	s6,48(sp)
    80005a4c:	f45e                	sd	s7,40(sp)
    80005a4e:	f062                	sd	s8,32(sp)
    80005a50:	ec66                	sd	s9,24(sp)
    80005a52:	e86a                	sd	s10,16(sp)
    80005a54:	1880                	addi	s0,sp,112
    80005a56:	8aaa                	mv	s5,a0
    80005a58:	8a2e                	mv	s4,a1
    80005a5a:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005a5c:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005a60:	00240517          	auipc	a0,0x240
    80005a64:	6e050513          	addi	a0,a0,1760 # 80246140 <cons>
    80005a68:	00001097          	auipc	ra,0x1
    80005a6c:	8e0080e7          	jalr	-1824(ra) # 80006348 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005a70:	00240497          	auipc	s1,0x240
    80005a74:	6d048493          	addi	s1,s1,1744 # 80246140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005a78:	00240917          	auipc	s2,0x240
    80005a7c:	76090913          	addi	s2,s2,1888 # 802461d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005a80:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a82:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005a84:	4ca9                	li	s9,10
  while(n > 0){
    80005a86:	07305863          	blez	s3,80005af6 <consoleread+0xbc>
    while(cons.r == cons.w){
    80005a8a:	0984a783          	lw	a5,152(s1)
    80005a8e:	09c4a703          	lw	a4,156(s1)
    80005a92:	02f71463          	bne	a4,a5,80005aba <consoleread+0x80>
      if(myproc()->killed){
    80005a96:	ffffb097          	auipc	ra,0xffffb
    80005a9a:	508080e7          	jalr	1288(ra) # 80000f9e <myproc>
    80005a9e:	551c                	lw	a5,40(a0)
    80005aa0:	e7b5                	bnez	a5,80005b0c <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    80005aa2:	85a6                	mv	a1,s1
    80005aa4:	854a                	mv	a0,s2
    80005aa6:	ffffc097          	auipc	ra,0xffffc
    80005aaa:	bbc080e7          	jalr	-1092(ra) # 80001662 <sleep>
    while(cons.r == cons.w){
    80005aae:	0984a783          	lw	a5,152(s1)
    80005ab2:	09c4a703          	lw	a4,156(s1)
    80005ab6:	fef700e3          	beq	a4,a5,80005a96 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005aba:	0017871b          	addiw	a4,a5,1
    80005abe:	08e4ac23          	sw	a4,152(s1)
    80005ac2:	07f7f713          	andi	a4,a5,127
    80005ac6:	9726                	add	a4,a4,s1
    80005ac8:	01874703          	lbu	a4,24(a4)
    80005acc:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80005ad0:	077d0563          	beq	s10,s7,80005b3a <consoleread+0x100>
    cbuf = c;
    80005ad4:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005ad8:	4685                	li	a3,1
    80005ada:	f9f40613          	addi	a2,s0,-97
    80005ade:	85d2                	mv	a1,s4
    80005ae0:	8556                	mv	a0,s5
    80005ae2:	ffffc097          	auipc	ra,0xffffc
    80005ae6:	f82080e7          	jalr	-126(ra) # 80001a64 <either_copyout>
    80005aea:	01850663          	beq	a0,s8,80005af6 <consoleread+0xbc>
    dst++;
    80005aee:	0a05                	addi	s4,s4,1
    --n;
    80005af0:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80005af2:	f99d1ae3          	bne	s10,s9,80005a86 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005af6:	00240517          	auipc	a0,0x240
    80005afa:	64a50513          	addi	a0,a0,1610 # 80246140 <cons>
    80005afe:	00001097          	auipc	ra,0x1
    80005b02:	8fe080e7          	jalr	-1794(ra) # 800063fc <release>

  return target - n;
    80005b06:	413b053b          	subw	a0,s6,s3
    80005b0a:	a811                	j	80005b1e <consoleread+0xe4>
        release(&cons.lock);
    80005b0c:	00240517          	auipc	a0,0x240
    80005b10:	63450513          	addi	a0,a0,1588 # 80246140 <cons>
    80005b14:	00001097          	auipc	ra,0x1
    80005b18:	8e8080e7          	jalr	-1816(ra) # 800063fc <release>
        return -1;
    80005b1c:	557d                	li	a0,-1
}
    80005b1e:	70a6                	ld	ra,104(sp)
    80005b20:	7406                	ld	s0,96(sp)
    80005b22:	64e6                	ld	s1,88(sp)
    80005b24:	6946                	ld	s2,80(sp)
    80005b26:	69a6                	ld	s3,72(sp)
    80005b28:	6a06                	ld	s4,64(sp)
    80005b2a:	7ae2                	ld	s5,56(sp)
    80005b2c:	7b42                	ld	s6,48(sp)
    80005b2e:	7ba2                	ld	s7,40(sp)
    80005b30:	7c02                	ld	s8,32(sp)
    80005b32:	6ce2                	ld	s9,24(sp)
    80005b34:	6d42                	ld	s10,16(sp)
    80005b36:	6165                	addi	sp,sp,112
    80005b38:	8082                	ret
      if(n < target){
    80005b3a:	0009871b          	sext.w	a4,s3
    80005b3e:	fb677ce3          	bgeu	a4,s6,80005af6 <consoleread+0xbc>
        cons.r--;
    80005b42:	00240717          	auipc	a4,0x240
    80005b46:	68f72b23          	sw	a5,1686(a4) # 802461d8 <cons+0x98>
    80005b4a:	b775                	j	80005af6 <consoleread+0xbc>

0000000080005b4c <consputc>:
{
    80005b4c:	1141                	addi	sp,sp,-16
    80005b4e:	e406                	sd	ra,8(sp)
    80005b50:	e022                	sd	s0,0(sp)
    80005b52:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005b54:	10000793          	li	a5,256
    80005b58:	00f50a63          	beq	a0,a5,80005b6c <consputc+0x20>
    uartputc_sync(c);
    80005b5c:	00000097          	auipc	ra,0x0
    80005b60:	560080e7          	jalr	1376(ra) # 800060bc <uartputc_sync>
}
    80005b64:	60a2                	ld	ra,8(sp)
    80005b66:	6402                	ld	s0,0(sp)
    80005b68:	0141                	addi	sp,sp,16
    80005b6a:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005b6c:	4521                	li	a0,8
    80005b6e:	00000097          	auipc	ra,0x0
    80005b72:	54e080e7          	jalr	1358(ra) # 800060bc <uartputc_sync>
    80005b76:	02000513          	li	a0,32
    80005b7a:	00000097          	auipc	ra,0x0
    80005b7e:	542080e7          	jalr	1346(ra) # 800060bc <uartputc_sync>
    80005b82:	4521                	li	a0,8
    80005b84:	00000097          	auipc	ra,0x0
    80005b88:	538080e7          	jalr	1336(ra) # 800060bc <uartputc_sync>
    80005b8c:	bfe1                	j	80005b64 <consputc+0x18>

0000000080005b8e <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005b8e:	1101                	addi	sp,sp,-32
    80005b90:	ec06                	sd	ra,24(sp)
    80005b92:	e822                	sd	s0,16(sp)
    80005b94:	e426                	sd	s1,8(sp)
    80005b96:	e04a                	sd	s2,0(sp)
    80005b98:	1000                	addi	s0,sp,32
    80005b9a:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005b9c:	00240517          	auipc	a0,0x240
    80005ba0:	5a450513          	addi	a0,a0,1444 # 80246140 <cons>
    80005ba4:	00000097          	auipc	ra,0x0
    80005ba8:	7a4080e7          	jalr	1956(ra) # 80006348 <acquire>

  switch(c){
    80005bac:	47d5                	li	a5,21
    80005bae:	0af48663          	beq	s1,a5,80005c5a <consoleintr+0xcc>
    80005bb2:	0297ca63          	blt	a5,s1,80005be6 <consoleintr+0x58>
    80005bb6:	47a1                	li	a5,8
    80005bb8:	0ef48763          	beq	s1,a5,80005ca6 <consoleintr+0x118>
    80005bbc:	47c1                	li	a5,16
    80005bbe:	10f49a63          	bne	s1,a5,80005cd2 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005bc2:	ffffc097          	auipc	ra,0xffffc
    80005bc6:	f4e080e7          	jalr	-178(ra) # 80001b10 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005bca:	00240517          	auipc	a0,0x240
    80005bce:	57650513          	addi	a0,a0,1398 # 80246140 <cons>
    80005bd2:	00001097          	auipc	ra,0x1
    80005bd6:	82a080e7          	jalr	-2006(ra) # 800063fc <release>
}
    80005bda:	60e2                	ld	ra,24(sp)
    80005bdc:	6442                	ld	s0,16(sp)
    80005bde:	64a2                	ld	s1,8(sp)
    80005be0:	6902                	ld	s2,0(sp)
    80005be2:	6105                	addi	sp,sp,32
    80005be4:	8082                	ret
  switch(c){
    80005be6:	07f00793          	li	a5,127
    80005bea:	0af48e63          	beq	s1,a5,80005ca6 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005bee:	00240717          	auipc	a4,0x240
    80005bf2:	55270713          	addi	a4,a4,1362 # 80246140 <cons>
    80005bf6:	0a072783          	lw	a5,160(a4)
    80005bfa:	09872703          	lw	a4,152(a4)
    80005bfe:	9f99                	subw	a5,a5,a4
    80005c00:	07f00713          	li	a4,127
    80005c04:	fcf763e3          	bltu	a4,a5,80005bca <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005c08:	47b5                	li	a5,13
    80005c0a:	0cf48763          	beq	s1,a5,80005cd8 <consoleintr+0x14a>
      consputc(c);
    80005c0e:	8526                	mv	a0,s1
    80005c10:	00000097          	auipc	ra,0x0
    80005c14:	f3c080e7          	jalr	-196(ra) # 80005b4c <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005c18:	00240797          	auipc	a5,0x240
    80005c1c:	52878793          	addi	a5,a5,1320 # 80246140 <cons>
    80005c20:	0a07a703          	lw	a4,160(a5)
    80005c24:	0017069b          	addiw	a3,a4,1
    80005c28:	0006861b          	sext.w	a2,a3
    80005c2c:	0ad7a023          	sw	a3,160(a5)
    80005c30:	07f77713          	andi	a4,a4,127
    80005c34:	97ba                	add	a5,a5,a4
    80005c36:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005c3a:	47a9                	li	a5,10
    80005c3c:	0cf48563          	beq	s1,a5,80005d06 <consoleintr+0x178>
    80005c40:	4791                	li	a5,4
    80005c42:	0cf48263          	beq	s1,a5,80005d06 <consoleintr+0x178>
    80005c46:	00240797          	auipc	a5,0x240
    80005c4a:	5927a783          	lw	a5,1426(a5) # 802461d8 <cons+0x98>
    80005c4e:	0807879b          	addiw	a5,a5,128
    80005c52:	f6f61ce3          	bne	a2,a5,80005bca <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005c56:	863e                	mv	a2,a5
    80005c58:	a07d                	j	80005d06 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005c5a:	00240717          	auipc	a4,0x240
    80005c5e:	4e670713          	addi	a4,a4,1254 # 80246140 <cons>
    80005c62:	0a072783          	lw	a5,160(a4)
    80005c66:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005c6a:	00240497          	auipc	s1,0x240
    80005c6e:	4d648493          	addi	s1,s1,1238 # 80246140 <cons>
    while(cons.e != cons.w &&
    80005c72:	4929                	li	s2,10
    80005c74:	f4f70be3          	beq	a4,a5,80005bca <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005c78:	37fd                	addiw	a5,a5,-1
    80005c7a:	07f7f713          	andi	a4,a5,127
    80005c7e:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005c80:	01874703          	lbu	a4,24(a4)
    80005c84:	f52703e3          	beq	a4,s2,80005bca <consoleintr+0x3c>
      cons.e--;
    80005c88:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005c8c:	10000513          	li	a0,256
    80005c90:	00000097          	auipc	ra,0x0
    80005c94:	ebc080e7          	jalr	-324(ra) # 80005b4c <consputc>
    while(cons.e != cons.w &&
    80005c98:	0a04a783          	lw	a5,160(s1)
    80005c9c:	09c4a703          	lw	a4,156(s1)
    80005ca0:	fcf71ce3          	bne	a4,a5,80005c78 <consoleintr+0xea>
    80005ca4:	b71d                	j	80005bca <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005ca6:	00240717          	auipc	a4,0x240
    80005caa:	49a70713          	addi	a4,a4,1178 # 80246140 <cons>
    80005cae:	0a072783          	lw	a5,160(a4)
    80005cb2:	09c72703          	lw	a4,156(a4)
    80005cb6:	f0f70ae3          	beq	a4,a5,80005bca <consoleintr+0x3c>
      cons.e--;
    80005cba:	37fd                	addiw	a5,a5,-1
    80005cbc:	00240717          	auipc	a4,0x240
    80005cc0:	52f72223          	sw	a5,1316(a4) # 802461e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005cc4:	10000513          	li	a0,256
    80005cc8:	00000097          	auipc	ra,0x0
    80005ccc:	e84080e7          	jalr	-380(ra) # 80005b4c <consputc>
    80005cd0:	bded                	j	80005bca <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005cd2:	ee048ce3          	beqz	s1,80005bca <consoleintr+0x3c>
    80005cd6:	bf21                	j	80005bee <consoleintr+0x60>
      consputc(c);
    80005cd8:	4529                	li	a0,10
    80005cda:	00000097          	auipc	ra,0x0
    80005cde:	e72080e7          	jalr	-398(ra) # 80005b4c <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005ce2:	00240797          	auipc	a5,0x240
    80005ce6:	45e78793          	addi	a5,a5,1118 # 80246140 <cons>
    80005cea:	0a07a703          	lw	a4,160(a5)
    80005cee:	0017069b          	addiw	a3,a4,1
    80005cf2:	0006861b          	sext.w	a2,a3
    80005cf6:	0ad7a023          	sw	a3,160(a5)
    80005cfa:	07f77713          	andi	a4,a4,127
    80005cfe:	97ba                	add	a5,a5,a4
    80005d00:	4729                	li	a4,10
    80005d02:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005d06:	00240797          	auipc	a5,0x240
    80005d0a:	4cc7ab23          	sw	a2,1238(a5) # 802461dc <cons+0x9c>
        wakeup(&cons.r);
    80005d0e:	00240517          	auipc	a0,0x240
    80005d12:	4ca50513          	addi	a0,a0,1226 # 802461d8 <cons+0x98>
    80005d16:	ffffc097          	auipc	ra,0xffffc
    80005d1a:	ad8080e7          	jalr	-1320(ra) # 800017ee <wakeup>
    80005d1e:	b575                	j	80005bca <consoleintr+0x3c>

0000000080005d20 <consoleinit>:

void
consoleinit(void)
{
    80005d20:	1141                	addi	sp,sp,-16
    80005d22:	e406                	sd	ra,8(sp)
    80005d24:	e022                	sd	s0,0(sp)
    80005d26:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005d28:	00003597          	auipc	a1,0x3
    80005d2c:	a7858593          	addi	a1,a1,-1416 # 800087a0 <syscalls+0x3c8>
    80005d30:	00240517          	auipc	a0,0x240
    80005d34:	41050513          	addi	a0,a0,1040 # 80246140 <cons>
    80005d38:	00000097          	auipc	ra,0x0
    80005d3c:	580080e7          	jalr	1408(ra) # 800062b8 <initlock>

  uartinit();
    80005d40:	00000097          	auipc	ra,0x0
    80005d44:	32c080e7          	jalr	812(ra) # 8000606c <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005d48:	00233797          	auipc	a5,0x233
    80005d4c:	39878793          	addi	a5,a5,920 # 802390e0 <devsw>
    80005d50:	00000717          	auipc	a4,0x0
    80005d54:	cea70713          	addi	a4,a4,-790 # 80005a3a <consoleread>
    80005d58:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005d5a:	00000717          	auipc	a4,0x0
    80005d5e:	c7c70713          	addi	a4,a4,-900 # 800059d6 <consolewrite>
    80005d62:	ef98                	sd	a4,24(a5)
}
    80005d64:	60a2                	ld	ra,8(sp)
    80005d66:	6402                	ld	s0,0(sp)
    80005d68:	0141                	addi	sp,sp,16
    80005d6a:	8082                	ret

0000000080005d6c <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005d6c:	7179                	addi	sp,sp,-48
    80005d6e:	f406                	sd	ra,40(sp)
    80005d70:	f022                	sd	s0,32(sp)
    80005d72:	ec26                	sd	s1,24(sp)
    80005d74:	e84a                	sd	s2,16(sp)
    80005d76:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005d78:	c219                	beqz	a2,80005d7e <printint+0x12>
    80005d7a:	08054763          	bltz	a0,80005e08 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005d7e:	2501                	sext.w	a0,a0
    80005d80:	4881                	li	a7,0
    80005d82:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005d86:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005d88:	2581                	sext.w	a1,a1
    80005d8a:	00003617          	auipc	a2,0x3
    80005d8e:	a4660613          	addi	a2,a2,-1466 # 800087d0 <digits>
    80005d92:	883a                	mv	a6,a4
    80005d94:	2705                	addiw	a4,a4,1
    80005d96:	02b577bb          	remuw	a5,a0,a1
    80005d9a:	1782                	slli	a5,a5,0x20
    80005d9c:	9381                	srli	a5,a5,0x20
    80005d9e:	97b2                	add	a5,a5,a2
    80005da0:	0007c783          	lbu	a5,0(a5)
    80005da4:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005da8:	0005079b          	sext.w	a5,a0
    80005dac:	02b5553b          	divuw	a0,a0,a1
    80005db0:	0685                	addi	a3,a3,1
    80005db2:	feb7f0e3          	bgeu	a5,a1,80005d92 <printint+0x26>

  if(sign)
    80005db6:	00088c63          	beqz	a7,80005dce <printint+0x62>
    buf[i++] = '-';
    80005dba:	fe070793          	addi	a5,a4,-32
    80005dbe:	00878733          	add	a4,a5,s0
    80005dc2:	02d00793          	li	a5,45
    80005dc6:	fef70823          	sb	a5,-16(a4)
    80005dca:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005dce:	02e05763          	blez	a4,80005dfc <printint+0x90>
    80005dd2:	fd040793          	addi	a5,s0,-48
    80005dd6:	00e784b3          	add	s1,a5,a4
    80005dda:	fff78913          	addi	s2,a5,-1
    80005dde:	993a                	add	s2,s2,a4
    80005de0:	377d                	addiw	a4,a4,-1
    80005de2:	1702                	slli	a4,a4,0x20
    80005de4:	9301                	srli	a4,a4,0x20
    80005de6:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005dea:	fff4c503          	lbu	a0,-1(s1)
    80005dee:	00000097          	auipc	ra,0x0
    80005df2:	d5e080e7          	jalr	-674(ra) # 80005b4c <consputc>
  while(--i >= 0)
    80005df6:	14fd                	addi	s1,s1,-1
    80005df8:	ff2499e3          	bne	s1,s2,80005dea <printint+0x7e>
}
    80005dfc:	70a2                	ld	ra,40(sp)
    80005dfe:	7402                	ld	s0,32(sp)
    80005e00:	64e2                	ld	s1,24(sp)
    80005e02:	6942                	ld	s2,16(sp)
    80005e04:	6145                	addi	sp,sp,48
    80005e06:	8082                	ret
    x = -xx;
    80005e08:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005e0c:	4885                	li	a7,1
    x = -xx;
    80005e0e:	bf95                	j	80005d82 <printint+0x16>

0000000080005e10 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005e10:	1101                	addi	sp,sp,-32
    80005e12:	ec06                	sd	ra,24(sp)
    80005e14:	e822                	sd	s0,16(sp)
    80005e16:	e426                	sd	s1,8(sp)
    80005e18:	1000                	addi	s0,sp,32
    80005e1a:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005e1c:	00240797          	auipc	a5,0x240
    80005e20:	3e07a223          	sw	zero,996(a5) # 80246200 <pr+0x18>
  printf("panic: ");
    80005e24:	00003517          	auipc	a0,0x3
    80005e28:	98450513          	addi	a0,a0,-1660 # 800087a8 <syscalls+0x3d0>
    80005e2c:	00000097          	auipc	ra,0x0
    80005e30:	02e080e7          	jalr	46(ra) # 80005e5a <printf>
  printf(s);
    80005e34:	8526                	mv	a0,s1
    80005e36:	00000097          	auipc	ra,0x0
    80005e3a:	024080e7          	jalr	36(ra) # 80005e5a <printf>
  printf("\n");
    80005e3e:	00002517          	auipc	a0,0x2
    80005e42:	21a50513          	addi	a0,a0,538 # 80008058 <etext+0x58>
    80005e46:	00000097          	auipc	ra,0x0
    80005e4a:	014080e7          	jalr	20(ra) # 80005e5a <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005e4e:	4785                	li	a5,1
    80005e50:	00003717          	auipc	a4,0x3
    80005e54:	1cf72623          	sw	a5,460(a4) # 8000901c <panicked>
  for(;;)
    80005e58:	a001                	j	80005e58 <panic+0x48>

0000000080005e5a <printf>:
{
    80005e5a:	7131                	addi	sp,sp,-192
    80005e5c:	fc86                	sd	ra,120(sp)
    80005e5e:	f8a2                	sd	s0,112(sp)
    80005e60:	f4a6                	sd	s1,104(sp)
    80005e62:	f0ca                	sd	s2,96(sp)
    80005e64:	ecce                	sd	s3,88(sp)
    80005e66:	e8d2                	sd	s4,80(sp)
    80005e68:	e4d6                	sd	s5,72(sp)
    80005e6a:	e0da                	sd	s6,64(sp)
    80005e6c:	fc5e                	sd	s7,56(sp)
    80005e6e:	f862                	sd	s8,48(sp)
    80005e70:	f466                	sd	s9,40(sp)
    80005e72:	f06a                	sd	s10,32(sp)
    80005e74:	ec6e                	sd	s11,24(sp)
    80005e76:	0100                	addi	s0,sp,128
    80005e78:	8a2a                	mv	s4,a0
    80005e7a:	e40c                	sd	a1,8(s0)
    80005e7c:	e810                	sd	a2,16(s0)
    80005e7e:	ec14                	sd	a3,24(s0)
    80005e80:	f018                	sd	a4,32(s0)
    80005e82:	f41c                	sd	a5,40(s0)
    80005e84:	03043823          	sd	a6,48(s0)
    80005e88:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005e8c:	00240d97          	auipc	s11,0x240
    80005e90:	374dad83          	lw	s11,884(s11) # 80246200 <pr+0x18>
  if(locking)
    80005e94:	020d9b63          	bnez	s11,80005eca <printf+0x70>
  if (fmt == 0)
    80005e98:	040a0263          	beqz	s4,80005edc <printf+0x82>
  va_start(ap, fmt);
    80005e9c:	00840793          	addi	a5,s0,8
    80005ea0:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005ea4:	000a4503          	lbu	a0,0(s4)
    80005ea8:	14050f63          	beqz	a0,80006006 <printf+0x1ac>
    80005eac:	4981                	li	s3,0
    if(c != '%'){
    80005eae:	02500a93          	li	s5,37
    switch(c){
    80005eb2:	07000b93          	li	s7,112
  consputc('x');
    80005eb6:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005eb8:	00003b17          	auipc	s6,0x3
    80005ebc:	918b0b13          	addi	s6,s6,-1768 # 800087d0 <digits>
    switch(c){
    80005ec0:	07300c93          	li	s9,115
    80005ec4:	06400c13          	li	s8,100
    80005ec8:	a82d                	j	80005f02 <printf+0xa8>
    acquire(&pr.lock);
    80005eca:	00240517          	auipc	a0,0x240
    80005ece:	31e50513          	addi	a0,a0,798 # 802461e8 <pr>
    80005ed2:	00000097          	auipc	ra,0x0
    80005ed6:	476080e7          	jalr	1142(ra) # 80006348 <acquire>
    80005eda:	bf7d                	j	80005e98 <printf+0x3e>
    panic("null fmt");
    80005edc:	00003517          	auipc	a0,0x3
    80005ee0:	8dc50513          	addi	a0,a0,-1828 # 800087b8 <syscalls+0x3e0>
    80005ee4:	00000097          	auipc	ra,0x0
    80005ee8:	f2c080e7          	jalr	-212(ra) # 80005e10 <panic>
      consputc(c);
    80005eec:	00000097          	auipc	ra,0x0
    80005ef0:	c60080e7          	jalr	-928(ra) # 80005b4c <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005ef4:	2985                	addiw	s3,s3,1
    80005ef6:	013a07b3          	add	a5,s4,s3
    80005efa:	0007c503          	lbu	a0,0(a5)
    80005efe:	10050463          	beqz	a0,80006006 <printf+0x1ac>
    if(c != '%'){
    80005f02:	ff5515e3          	bne	a0,s5,80005eec <printf+0x92>
    c = fmt[++i] & 0xff;
    80005f06:	2985                	addiw	s3,s3,1
    80005f08:	013a07b3          	add	a5,s4,s3
    80005f0c:	0007c783          	lbu	a5,0(a5)
    80005f10:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005f14:	cbed                	beqz	a5,80006006 <printf+0x1ac>
    switch(c){
    80005f16:	05778a63          	beq	a5,s7,80005f6a <printf+0x110>
    80005f1a:	02fbf663          	bgeu	s7,a5,80005f46 <printf+0xec>
    80005f1e:	09978863          	beq	a5,s9,80005fae <printf+0x154>
    80005f22:	07800713          	li	a4,120
    80005f26:	0ce79563          	bne	a5,a4,80005ff0 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005f2a:	f8843783          	ld	a5,-120(s0)
    80005f2e:	00878713          	addi	a4,a5,8
    80005f32:	f8e43423          	sd	a4,-120(s0)
    80005f36:	4605                	li	a2,1
    80005f38:	85ea                	mv	a1,s10
    80005f3a:	4388                	lw	a0,0(a5)
    80005f3c:	00000097          	auipc	ra,0x0
    80005f40:	e30080e7          	jalr	-464(ra) # 80005d6c <printint>
      break;
    80005f44:	bf45                	j	80005ef4 <printf+0x9a>
    switch(c){
    80005f46:	09578f63          	beq	a5,s5,80005fe4 <printf+0x18a>
    80005f4a:	0b879363          	bne	a5,s8,80005ff0 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005f4e:	f8843783          	ld	a5,-120(s0)
    80005f52:	00878713          	addi	a4,a5,8
    80005f56:	f8e43423          	sd	a4,-120(s0)
    80005f5a:	4605                	li	a2,1
    80005f5c:	45a9                	li	a1,10
    80005f5e:	4388                	lw	a0,0(a5)
    80005f60:	00000097          	auipc	ra,0x0
    80005f64:	e0c080e7          	jalr	-500(ra) # 80005d6c <printint>
      break;
    80005f68:	b771                	j	80005ef4 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005f6a:	f8843783          	ld	a5,-120(s0)
    80005f6e:	00878713          	addi	a4,a5,8
    80005f72:	f8e43423          	sd	a4,-120(s0)
    80005f76:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005f7a:	03000513          	li	a0,48
    80005f7e:	00000097          	auipc	ra,0x0
    80005f82:	bce080e7          	jalr	-1074(ra) # 80005b4c <consputc>
  consputc('x');
    80005f86:	07800513          	li	a0,120
    80005f8a:	00000097          	auipc	ra,0x0
    80005f8e:	bc2080e7          	jalr	-1086(ra) # 80005b4c <consputc>
    80005f92:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f94:	03c95793          	srli	a5,s2,0x3c
    80005f98:	97da                	add	a5,a5,s6
    80005f9a:	0007c503          	lbu	a0,0(a5)
    80005f9e:	00000097          	auipc	ra,0x0
    80005fa2:	bae080e7          	jalr	-1106(ra) # 80005b4c <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005fa6:	0912                	slli	s2,s2,0x4
    80005fa8:	34fd                	addiw	s1,s1,-1
    80005faa:	f4ed                	bnez	s1,80005f94 <printf+0x13a>
    80005fac:	b7a1                	j	80005ef4 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005fae:	f8843783          	ld	a5,-120(s0)
    80005fb2:	00878713          	addi	a4,a5,8
    80005fb6:	f8e43423          	sd	a4,-120(s0)
    80005fba:	6384                	ld	s1,0(a5)
    80005fbc:	cc89                	beqz	s1,80005fd6 <printf+0x17c>
      for(; *s; s++)
    80005fbe:	0004c503          	lbu	a0,0(s1)
    80005fc2:	d90d                	beqz	a0,80005ef4 <printf+0x9a>
        consputc(*s);
    80005fc4:	00000097          	auipc	ra,0x0
    80005fc8:	b88080e7          	jalr	-1144(ra) # 80005b4c <consputc>
      for(; *s; s++)
    80005fcc:	0485                	addi	s1,s1,1
    80005fce:	0004c503          	lbu	a0,0(s1)
    80005fd2:	f96d                	bnez	a0,80005fc4 <printf+0x16a>
    80005fd4:	b705                	j	80005ef4 <printf+0x9a>
        s = "(null)";
    80005fd6:	00002497          	auipc	s1,0x2
    80005fda:	7da48493          	addi	s1,s1,2010 # 800087b0 <syscalls+0x3d8>
      for(; *s; s++)
    80005fde:	02800513          	li	a0,40
    80005fe2:	b7cd                	j	80005fc4 <printf+0x16a>
      consputc('%');
    80005fe4:	8556                	mv	a0,s5
    80005fe6:	00000097          	auipc	ra,0x0
    80005fea:	b66080e7          	jalr	-1178(ra) # 80005b4c <consputc>
      break;
    80005fee:	b719                	j	80005ef4 <printf+0x9a>
      consputc('%');
    80005ff0:	8556                	mv	a0,s5
    80005ff2:	00000097          	auipc	ra,0x0
    80005ff6:	b5a080e7          	jalr	-1190(ra) # 80005b4c <consputc>
      consputc(c);
    80005ffa:	8526                	mv	a0,s1
    80005ffc:	00000097          	auipc	ra,0x0
    80006000:	b50080e7          	jalr	-1200(ra) # 80005b4c <consputc>
      break;
    80006004:	bdc5                	j	80005ef4 <printf+0x9a>
  if(locking)
    80006006:	020d9163          	bnez	s11,80006028 <printf+0x1ce>
}
    8000600a:	70e6                	ld	ra,120(sp)
    8000600c:	7446                	ld	s0,112(sp)
    8000600e:	74a6                	ld	s1,104(sp)
    80006010:	7906                	ld	s2,96(sp)
    80006012:	69e6                	ld	s3,88(sp)
    80006014:	6a46                	ld	s4,80(sp)
    80006016:	6aa6                	ld	s5,72(sp)
    80006018:	6b06                	ld	s6,64(sp)
    8000601a:	7be2                	ld	s7,56(sp)
    8000601c:	7c42                	ld	s8,48(sp)
    8000601e:	7ca2                	ld	s9,40(sp)
    80006020:	7d02                	ld	s10,32(sp)
    80006022:	6de2                	ld	s11,24(sp)
    80006024:	6129                	addi	sp,sp,192
    80006026:	8082                	ret
    release(&pr.lock);
    80006028:	00240517          	auipc	a0,0x240
    8000602c:	1c050513          	addi	a0,a0,448 # 802461e8 <pr>
    80006030:	00000097          	auipc	ra,0x0
    80006034:	3cc080e7          	jalr	972(ra) # 800063fc <release>
}
    80006038:	bfc9                	j	8000600a <printf+0x1b0>

000000008000603a <printfinit>:
    ;
}

void
printfinit(void)
{
    8000603a:	1101                	addi	sp,sp,-32
    8000603c:	ec06                	sd	ra,24(sp)
    8000603e:	e822                	sd	s0,16(sp)
    80006040:	e426                	sd	s1,8(sp)
    80006042:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006044:	00240497          	auipc	s1,0x240
    80006048:	1a448493          	addi	s1,s1,420 # 802461e8 <pr>
    8000604c:	00002597          	auipc	a1,0x2
    80006050:	77c58593          	addi	a1,a1,1916 # 800087c8 <syscalls+0x3f0>
    80006054:	8526                	mv	a0,s1
    80006056:	00000097          	auipc	ra,0x0
    8000605a:	262080e7          	jalr	610(ra) # 800062b8 <initlock>
  pr.locking = 1;
    8000605e:	4785                	li	a5,1
    80006060:	cc9c                	sw	a5,24(s1)
}
    80006062:	60e2                	ld	ra,24(sp)
    80006064:	6442                	ld	s0,16(sp)
    80006066:	64a2                	ld	s1,8(sp)
    80006068:	6105                	addi	sp,sp,32
    8000606a:	8082                	ret

000000008000606c <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000606c:	1141                	addi	sp,sp,-16
    8000606e:	e406                	sd	ra,8(sp)
    80006070:	e022                	sd	s0,0(sp)
    80006072:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006074:	100007b7          	lui	a5,0x10000
    80006078:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000607c:	f8000713          	li	a4,-128
    80006080:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006084:	470d                	li	a4,3
    80006086:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    8000608a:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000608e:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006092:	469d                	li	a3,7
    80006094:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006098:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000609c:	00002597          	auipc	a1,0x2
    800060a0:	74c58593          	addi	a1,a1,1868 # 800087e8 <digits+0x18>
    800060a4:	00240517          	auipc	a0,0x240
    800060a8:	16450513          	addi	a0,a0,356 # 80246208 <uart_tx_lock>
    800060ac:	00000097          	auipc	ra,0x0
    800060b0:	20c080e7          	jalr	524(ra) # 800062b8 <initlock>
}
    800060b4:	60a2                	ld	ra,8(sp)
    800060b6:	6402                	ld	s0,0(sp)
    800060b8:	0141                	addi	sp,sp,16
    800060ba:	8082                	ret

00000000800060bc <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800060bc:	1101                	addi	sp,sp,-32
    800060be:	ec06                	sd	ra,24(sp)
    800060c0:	e822                	sd	s0,16(sp)
    800060c2:	e426                	sd	s1,8(sp)
    800060c4:	1000                	addi	s0,sp,32
    800060c6:	84aa                	mv	s1,a0
  push_off();
    800060c8:	00000097          	auipc	ra,0x0
    800060cc:	234080e7          	jalr	564(ra) # 800062fc <push_off>

  if(panicked){
    800060d0:	00003797          	auipc	a5,0x3
    800060d4:	f4c7a783          	lw	a5,-180(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800060d8:	10000737          	lui	a4,0x10000
  if(panicked){
    800060dc:	c391                	beqz	a5,800060e0 <uartputc_sync+0x24>
    for(;;)
    800060de:	a001                	j	800060de <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800060e0:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    800060e4:	0207f793          	andi	a5,a5,32
    800060e8:	dfe5                	beqz	a5,800060e0 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    800060ea:	0ff4f513          	zext.b	a0,s1
    800060ee:	100007b7          	lui	a5,0x10000
    800060f2:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    800060f6:	00000097          	auipc	ra,0x0
    800060fa:	2a6080e7          	jalr	678(ra) # 8000639c <pop_off>
}
    800060fe:	60e2                	ld	ra,24(sp)
    80006100:	6442                	ld	s0,16(sp)
    80006102:	64a2                	ld	s1,8(sp)
    80006104:	6105                	addi	sp,sp,32
    80006106:	8082                	ret

0000000080006108 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006108:	00003797          	auipc	a5,0x3
    8000610c:	f187b783          	ld	a5,-232(a5) # 80009020 <uart_tx_r>
    80006110:	00003717          	auipc	a4,0x3
    80006114:	f1873703          	ld	a4,-232(a4) # 80009028 <uart_tx_w>
    80006118:	06f70a63          	beq	a4,a5,8000618c <uartstart+0x84>
{
    8000611c:	7139                	addi	sp,sp,-64
    8000611e:	fc06                	sd	ra,56(sp)
    80006120:	f822                	sd	s0,48(sp)
    80006122:	f426                	sd	s1,40(sp)
    80006124:	f04a                	sd	s2,32(sp)
    80006126:	ec4e                	sd	s3,24(sp)
    80006128:	e852                	sd	s4,16(sp)
    8000612a:	e456                	sd	s5,8(sp)
    8000612c:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000612e:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006132:	00240a17          	auipc	s4,0x240
    80006136:	0d6a0a13          	addi	s4,s4,214 # 80246208 <uart_tx_lock>
    uart_tx_r += 1;
    8000613a:	00003497          	auipc	s1,0x3
    8000613e:	ee648493          	addi	s1,s1,-282 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80006142:	00003997          	auipc	s3,0x3
    80006146:	ee698993          	addi	s3,s3,-282 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000614a:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    8000614e:	02077713          	andi	a4,a4,32
    80006152:	c705                	beqz	a4,8000617a <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006154:	01f7f713          	andi	a4,a5,31
    80006158:	9752                	add	a4,a4,s4
    8000615a:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    8000615e:	0785                	addi	a5,a5,1
    80006160:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006162:	8526                	mv	a0,s1
    80006164:	ffffb097          	auipc	ra,0xffffb
    80006168:	68a080e7          	jalr	1674(ra) # 800017ee <wakeup>
    
    WriteReg(THR, c);
    8000616c:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006170:	609c                	ld	a5,0(s1)
    80006172:	0009b703          	ld	a4,0(s3)
    80006176:	fcf71ae3          	bne	a4,a5,8000614a <uartstart+0x42>
  }
}
    8000617a:	70e2                	ld	ra,56(sp)
    8000617c:	7442                	ld	s0,48(sp)
    8000617e:	74a2                	ld	s1,40(sp)
    80006180:	7902                	ld	s2,32(sp)
    80006182:	69e2                	ld	s3,24(sp)
    80006184:	6a42                	ld	s4,16(sp)
    80006186:	6aa2                	ld	s5,8(sp)
    80006188:	6121                	addi	sp,sp,64
    8000618a:	8082                	ret
    8000618c:	8082                	ret

000000008000618e <uartputc>:
{
    8000618e:	7179                	addi	sp,sp,-48
    80006190:	f406                	sd	ra,40(sp)
    80006192:	f022                	sd	s0,32(sp)
    80006194:	ec26                	sd	s1,24(sp)
    80006196:	e84a                	sd	s2,16(sp)
    80006198:	e44e                	sd	s3,8(sp)
    8000619a:	e052                	sd	s4,0(sp)
    8000619c:	1800                	addi	s0,sp,48
    8000619e:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800061a0:	00240517          	auipc	a0,0x240
    800061a4:	06850513          	addi	a0,a0,104 # 80246208 <uart_tx_lock>
    800061a8:	00000097          	auipc	ra,0x0
    800061ac:	1a0080e7          	jalr	416(ra) # 80006348 <acquire>
  if(panicked){
    800061b0:	00003797          	auipc	a5,0x3
    800061b4:	e6c7a783          	lw	a5,-404(a5) # 8000901c <panicked>
    800061b8:	c391                	beqz	a5,800061bc <uartputc+0x2e>
    for(;;)
    800061ba:	a001                	j	800061ba <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800061bc:	00003717          	auipc	a4,0x3
    800061c0:	e6c73703          	ld	a4,-404(a4) # 80009028 <uart_tx_w>
    800061c4:	00003797          	auipc	a5,0x3
    800061c8:	e5c7b783          	ld	a5,-420(a5) # 80009020 <uart_tx_r>
    800061cc:	02078793          	addi	a5,a5,32
    800061d0:	02e79b63          	bne	a5,a4,80006206 <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    800061d4:	00240997          	auipc	s3,0x240
    800061d8:	03498993          	addi	s3,s3,52 # 80246208 <uart_tx_lock>
    800061dc:	00003497          	auipc	s1,0x3
    800061e0:	e4448493          	addi	s1,s1,-444 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800061e4:	00003917          	auipc	s2,0x3
    800061e8:	e4490913          	addi	s2,s2,-444 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    800061ec:	85ce                	mv	a1,s3
    800061ee:	8526                	mv	a0,s1
    800061f0:	ffffb097          	auipc	ra,0xffffb
    800061f4:	472080e7          	jalr	1138(ra) # 80001662 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800061f8:	00093703          	ld	a4,0(s2)
    800061fc:	609c                	ld	a5,0(s1)
    800061fe:	02078793          	addi	a5,a5,32
    80006202:	fee785e3          	beq	a5,a4,800061ec <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006206:	00240497          	auipc	s1,0x240
    8000620a:	00248493          	addi	s1,s1,2 # 80246208 <uart_tx_lock>
    8000620e:	01f77793          	andi	a5,a4,31
    80006212:	97a6                	add	a5,a5,s1
    80006214:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    80006218:	0705                	addi	a4,a4,1
    8000621a:	00003797          	auipc	a5,0x3
    8000621e:	e0e7b723          	sd	a4,-498(a5) # 80009028 <uart_tx_w>
      uartstart();
    80006222:	00000097          	auipc	ra,0x0
    80006226:	ee6080e7          	jalr	-282(ra) # 80006108 <uartstart>
      release(&uart_tx_lock);
    8000622a:	8526                	mv	a0,s1
    8000622c:	00000097          	auipc	ra,0x0
    80006230:	1d0080e7          	jalr	464(ra) # 800063fc <release>
}
    80006234:	70a2                	ld	ra,40(sp)
    80006236:	7402                	ld	s0,32(sp)
    80006238:	64e2                	ld	s1,24(sp)
    8000623a:	6942                	ld	s2,16(sp)
    8000623c:	69a2                	ld	s3,8(sp)
    8000623e:	6a02                	ld	s4,0(sp)
    80006240:	6145                	addi	sp,sp,48
    80006242:	8082                	ret

0000000080006244 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006244:	1141                	addi	sp,sp,-16
    80006246:	e422                	sd	s0,8(sp)
    80006248:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000624a:	100007b7          	lui	a5,0x10000
    8000624e:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006252:	8b85                	andi	a5,a5,1
    80006254:	cb81                	beqz	a5,80006264 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    80006256:	100007b7          	lui	a5,0x10000
    8000625a:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000625e:	6422                	ld	s0,8(sp)
    80006260:	0141                	addi	sp,sp,16
    80006262:	8082                	ret
    return -1;
    80006264:	557d                	li	a0,-1
    80006266:	bfe5                	j	8000625e <uartgetc+0x1a>

0000000080006268 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006268:	1101                	addi	sp,sp,-32
    8000626a:	ec06                	sd	ra,24(sp)
    8000626c:	e822                	sd	s0,16(sp)
    8000626e:	e426                	sd	s1,8(sp)
    80006270:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006272:	54fd                	li	s1,-1
    80006274:	a029                	j	8000627e <uartintr+0x16>
      break;
    consoleintr(c);
    80006276:	00000097          	auipc	ra,0x0
    8000627a:	918080e7          	jalr	-1768(ra) # 80005b8e <consoleintr>
    int c = uartgetc();
    8000627e:	00000097          	auipc	ra,0x0
    80006282:	fc6080e7          	jalr	-58(ra) # 80006244 <uartgetc>
    if(c == -1)
    80006286:	fe9518e3          	bne	a0,s1,80006276 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000628a:	00240497          	auipc	s1,0x240
    8000628e:	f7e48493          	addi	s1,s1,-130 # 80246208 <uart_tx_lock>
    80006292:	8526                	mv	a0,s1
    80006294:	00000097          	auipc	ra,0x0
    80006298:	0b4080e7          	jalr	180(ra) # 80006348 <acquire>
  uartstart();
    8000629c:	00000097          	auipc	ra,0x0
    800062a0:	e6c080e7          	jalr	-404(ra) # 80006108 <uartstart>
  release(&uart_tx_lock);
    800062a4:	8526                	mv	a0,s1
    800062a6:	00000097          	auipc	ra,0x0
    800062aa:	156080e7          	jalr	342(ra) # 800063fc <release>
}
    800062ae:	60e2                	ld	ra,24(sp)
    800062b0:	6442                	ld	s0,16(sp)
    800062b2:	64a2                	ld	s1,8(sp)
    800062b4:	6105                	addi	sp,sp,32
    800062b6:	8082                	ret

00000000800062b8 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800062b8:	1141                	addi	sp,sp,-16
    800062ba:	e422                	sd	s0,8(sp)
    800062bc:	0800                	addi	s0,sp,16
  lk->name = name;
    800062be:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800062c0:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800062c4:	00053823          	sd	zero,16(a0)
}
    800062c8:	6422                	ld	s0,8(sp)
    800062ca:	0141                	addi	sp,sp,16
    800062cc:	8082                	ret

00000000800062ce <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800062ce:	411c                	lw	a5,0(a0)
    800062d0:	e399                	bnez	a5,800062d6 <holding+0x8>
    800062d2:	4501                	li	a0,0
  return r;
}
    800062d4:	8082                	ret
{
    800062d6:	1101                	addi	sp,sp,-32
    800062d8:	ec06                	sd	ra,24(sp)
    800062da:	e822                	sd	s0,16(sp)
    800062dc:	e426                	sd	s1,8(sp)
    800062de:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800062e0:	6904                	ld	s1,16(a0)
    800062e2:	ffffb097          	auipc	ra,0xffffb
    800062e6:	ca0080e7          	jalr	-864(ra) # 80000f82 <mycpu>
    800062ea:	40a48533          	sub	a0,s1,a0
    800062ee:	00153513          	seqz	a0,a0
}
    800062f2:	60e2                	ld	ra,24(sp)
    800062f4:	6442                	ld	s0,16(sp)
    800062f6:	64a2                	ld	s1,8(sp)
    800062f8:	6105                	addi	sp,sp,32
    800062fa:	8082                	ret

00000000800062fc <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800062fc:	1101                	addi	sp,sp,-32
    800062fe:	ec06                	sd	ra,24(sp)
    80006300:	e822                	sd	s0,16(sp)
    80006302:	e426                	sd	s1,8(sp)
    80006304:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006306:	100024f3          	csrr	s1,sstatus
    8000630a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000630e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006310:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006314:	ffffb097          	auipc	ra,0xffffb
    80006318:	c6e080e7          	jalr	-914(ra) # 80000f82 <mycpu>
    8000631c:	5d3c                	lw	a5,120(a0)
    8000631e:	cf89                	beqz	a5,80006338 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006320:	ffffb097          	auipc	ra,0xffffb
    80006324:	c62080e7          	jalr	-926(ra) # 80000f82 <mycpu>
    80006328:	5d3c                	lw	a5,120(a0)
    8000632a:	2785                	addiw	a5,a5,1
    8000632c:	dd3c                	sw	a5,120(a0)
}
    8000632e:	60e2                	ld	ra,24(sp)
    80006330:	6442                	ld	s0,16(sp)
    80006332:	64a2                	ld	s1,8(sp)
    80006334:	6105                	addi	sp,sp,32
    80006336:	8082                	ret
    mycpu()->intena = old;
    80006338:	ffffb097          	auipc	ra,0xffffb
    8000633c:	c4a080e7          	jalr	-950(ra) # 80000f82 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006340:	8085                	srli	s1,s1,0x1
    80006342:	8885                	andi	s1,s1,1
    80006344:	dd64                	sw	s1,124(a0)
    80006346:	bfe9                	j	80006320 <push_off+0x24>

0000000080006348 <acquire>:
{
    80006348:	1101                	addi	sp,sp,-32
    8000634a:	ec06                	sd	ra,24(sp)
    8000634c:	e822                	sd	s0,16(sp)
    8000634e:	e426                	sd	s1,8(sp)
    80006350:	1000                	addi	s0,sp,32
    80006352:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006354:	00000097          	auipc	ra,0x0
    80006358:	fa8080e7          	jalr	-88(ra) # 800062fc <push_off>
  if(holding(lk))
    8000635c:	8526                	mv	a0,s1
    8000635e:	00000097          	auipc	ra,0x0
    80006362:	f70080e7          	jalr	-144(ra) # 800062ce <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006366:	4705                	li	a4,1
  if(holding(lk))
    80006368:	e115                	bnez	a0,8000638c <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000636a:	87ba                	mv	a5,a4
    8000636c:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006370:	2781                	sext.w	a5,a5
    80006372:	ffe5                	bnez	a5,8000636a <acquire+0x22>
  __sync_synchronize();
    80006374:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006378:	ffffb097          	auipc	ra,0xffffb
    8000637c:	c0a080e7          	jalr	-1014(ra) # 80000f82 <mycpu>
    80006380:	e888                	sd	a0,16(s1)
}
    80006382:	60e2                	ld	ra,24(sp)
    80006384:	6442                	ld	s0,16(sp)
    80006386:	64a2                	ld	s1,8(sp)
    80006388:	6105                	addi	sp,sp,32
    8000638a:	8082                	ret
    panic("acquire");
    8000638c:	00002517          	auipc	a0,0x2
    80006390:	46450513          	addi	a0,a0,1124 # 800087f0 <digits+0x20>
    80006394:	00000097          	auipc	ra,0x0
    80006398:	a7c080e7          	jalr	-1412(ra) # 80005e10 <panic>

000000008000639c <pop_off>:

void
pop_off(void)
{
    8000639c:	1141                	addi	sp,sp,-16
    8000639e:	e406                	sd	ra,8(sp)
    800063a0:	e022                	sd	s0,0(sp)
    800063a2:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800063a4:	ffffb097          	auipc	ra,0xffffb
    800063a8:	bde080e7          	jalr	-1058(ra) # 80000f82 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800063ac:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800063b0:	8b89                	andi	a5,a5,2
  if(intr_get())
    800063b2:	e78d                	bnez	a5,800063dc <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800063b4:	5d3c                	lw	a5,120(a0)
    800063b6:	02f05b63          	blez	a5,800063ec <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800063ba:	37fd                	addiw	a5,a5,-1
    800063bc:	0007871b          	sext.w	a4,a5
    800063c0:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800063c2:	eb09                	bnez	a4,800063d4 <pop_off+0x38>
    800063c4:	5d7c                	lw	a5,124(a0)
    800063c6:	c799                	beqz	a5,800063d4 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800063c8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800063cc:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800063d0:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800063d4:	60a2                	ld	ra,8(sp)
    800063d6:	6402                	ld	s0,0(sp)
    800063d8:	0141                	addi	sp,sp,16
    800063da:	8082                	ret
    panic("pop_off - interruptible");
    800063dc:	00002517          	auipc	a0,0x2
    800063e0:	41c50513          	addi	a0,a0,1052 # 800087f8 <digits+0x28>
    800063e4:	00000097          	auipc	ra,0x0
    800063e8:	a2c080e7          	jalr	-1492(ra) # 80005e10 <panic>
    panic("pop_off");
    800063ec:	00002517          	auipc	a0,0x2
    800063f0:	42450513          	addi	a0,a0,1060 # 80008810 <digits+0x40>
    800063f4:	00000097          	auipc	ra,0x0
    800063f8:	a1c080e7          	jalr	-1508(ra) # 80005e10 <panic>

00000000800063fc <release>:
{
    800063fc:	1101                	addi	sp,sp,-32
    800063fe:	ec06                	sd	ra,24(sp)
    80006400:	e822                	sd	s0,16(sp)
    80006402:	e426                	sd	s1,8(sp)
    80006404:	1000                	addi	s0,sp,32
    80006406:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006408:	00000097          	auipc	ra,0x0
    8000640c:	ec6080e7          	jalr	-314(ra) # 800062ce <holding>
    80006410:	c115                	beqz	a0,80006434 <release+0x38>
  lk->cpu = 0;
    80006412:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006416:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    8000641a:	0f50000f          	fence	iorw,ow
    8000641e:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006422:	00000097          	auipc	ra,0x0
    80006426:	f7a080e7          	jalr	-134(ra) # 8000639c <pop_off>
}
    8000642a:	60e2                	ld	ra,24(sp)
    8000642c:	6442                	ld	s0,16(sp)
    8000642e:	64a2                	ld	s1,8(sp)
    80006430:	6105                	addi	sp,sp,32
    80006432:	8082                	ret
    panic("release");
    80006434:	00002517          	auipc	a0,0x2
    80006438:	3e450513          	addi	a0,a0,996 # 80008818 <digits+0x48>
    8000643c:	00000097          	auipc	ra,0x0
    80006440:	9d4080e7          	jalr	-1580(ra) # 80005e10 <panic>
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
