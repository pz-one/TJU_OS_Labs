
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	86013103          	ld	sp,-1952(sp) # 80008860 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	77c050ef          	jal	ra,80005792 <start>

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
    8000002c:	eba9                	bnez	a5,8000007e <kfree+0x62>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00046797          	auipc	a5,0x46
    80000034:	21078793          	addi	a5,a5,528 # 80046240 <end>
    80000038:	04f56363          	bltu	a0,a5,8000007e <kfree+0x62>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	02f57f63          	bgeu	a0,a5,8000007e <kfree+0x62>
    panic("kfree");

  // acquire(&ref_lock);
  if (page_ref[COW_INDEX(pa)] > 1)
    80000044:	800007b7          	lui	a5,0x80000
    80000048:	97aa                	add	a5,a5,a0
    8000004a:	83b1                	srli	a5,a5,0xc
    8000004c:	00279693          	slli	a3,a5,0x2
    80000050:	00009717          	auipc	a4,0x9
    80000054:	00070713          	mv	a4,a4
    80000058:	9736                	add	a4,a4,a3
    8000005a:	4318                	lw	a4,0(a4)
    8000005c:	4685                	li	a3,1
    8000005e:	02e6f863          	bgeu	a3,a4,8000008e <kfree+0x72>
  {
    page_ref[COW_INDEX(pa)]--;
    80000062:	078a                	slli	a5,a5,0x2
    80000064:	00009697          	auipc	a3,0x9
    80000068:	fec68693          	addi	a3,a3,-20 # 80009050 <page_ref>
    8000006c:	97b6                	add	a5,a5,a3
    8000006e:	377d                	addiw	a4,a4,-1 # ffffffff8000904f <end+0xfffffffefffc2e0f>
    80000070:	c398                	sw	a4,0(a5)

  acquire(&kmem.lock);
  r->next = kmem.freelist;
  kmem.freelist = r;
  release(&kmem.lock);
}
    80000072:	60e2                	ld	ra,24(sp)
    80000074:	6442                	ld	s0,16(sp)
    80000076:	64a2                	ld	s1,8(sp)
    80000078:	6902                	ld	s2,0(sp)
    8000007a:	6105                	addi	sp,sp,32
    8000007c:	8082                	ret
    panic("kfree");
    8000007e:	00008517          	auipc	a0,0x8
    80000082:	f9250513          	addi	a0,a0,-110 # 80008010 <etext+0x10>
    80000086:	00006097          	auipc	ra,0x6
    8000008a:	bba080e7          	jalr	-1094(ra) # 80005c40 <panic>
  page_ref[COW_INDEX(pa)] = 0;
    8000008e:	078a                	slli	a5,a5,0x2
    80000090:	00009717          	auipc	a4,0x9
    80000094:	fc070713          	addi	a4,a4,-64 # 80009050 <page_ref>
    80000098:	97ba                	add	a5,a5,a4
    8000009a:	0007a023          	sw	zero,0(a5) # ffffffff80000000 <end+0xfffffffefffb9dc0>
  memset(pa, 1, PGSIZE);
    8000009e:	6605                	lui	a2,0x1
    800000a0:	4585                	li	a1,1
    800000a2:	00000097          	auipc	ra,0x0
    800000a6:	1e8080e7          	jalr	488(ra) # 8000028a <memset>
  acquire(&kmem.lock);
    800000aa:	00009917          	auipc	s2,0x9
    800000ae:	f8690913          	addi	s2,s2,-122 # 80009030 <kmem>
    800000b2:	854a                	mv	a0,s2
    800000b4:	00006097          	auipc	ra,0x6
    800000b8:	0c4080e7          	jalr	196(ra) # 80006178 <acquire>
  r->next = kmem.freelist;
    800000bc:	01893783          	ld	a5,24(s2)
    800000c0:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    800000c2:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    800000c6:	854a                	mv	a0,s2
    800000c8:	00006097          	auipc	ra,0x6
    800000cc:	164080e7          	jalr	356(ra) # 8000622c <release>
    800000d0:	b74d                	j	80000072 <kfree+0x56>

00000000800000d2 <freerange>:
{
    800000d2:	7179                	addi	sp,sp,-48
    800000d4:	f406                	sd	ra,40(sp)
    800000d6:	f022                	sd	s0,32(sp)
    800000d8:	ec26                	sd	s1,24(sp)
    800000da:	e84a                	sd	s2,16(sp)
    800000dc:	e44e                	sd	s3,8(sp)
    800000de:	e052                	sd	s4,0(sp)
    800000e0:	1800                	addi	s0,sp,48
  p = (char *)PGROUNDUP((uint64)pa_start);
    800000e2:	6785                	lui	a5,0x1
    800000e4:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000e8:	00e504b3          	add	s1,a0,a4
    800000ec:	777d                	lui	a4,0xfffff
    800000ee:	8cf9                	and	s1,s1,a4
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    800000f0:	94be                	add	s1,s1,a5
    800000f2:	0095ee63          	bltu	a1,s1,8000010e <freerange+0x3c>
    800000f6:	892e                	mv	s2,a1
    kfree(p);
    800000f8:	7a7d                	lui	s4,0xfffff
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    800000fa:	6985                	lui	s3,0x1
    kfree(p);
    800000fc:	01448533          	add	a0,s1,s4
    80000100:	00000097          	auipc	ra,0x0
    80000104:	f1c080e7          	jalr	-228(ra) # 8000001c <kfree>
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000108:	94ce                	add	s1,s1,s3
    8000010a:	fe9979e3          	bgeu	s2,s1,800000fc <freerange+0x2a>
}
    8000010e:	70a2                	ld	ra,40(sp)
    80000110:	7402                	ld	s0,32(sp)
    80000112:	64e2                	ld	s1,24(sp)
    80000114:	6942                	ld	s2,16(sp)
    80000116:	69a2                	ld	s3,8(sp)
    80000118:	6a02                	ld	s4,0(sp)
    8000011a:	6145                	addi	sp,sp,48
    8000011c:	8082                	ret

000000008000011e <kinit>:
{
    8000011e:	1141                	addi	sp,sp,-16
    80000120:	e406                	sd	ra,8(sp)
    80000122:	e022                	sd	s0,0(sp)
    80000124:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000126:	00008597          	auipc	a1,0x8
    8000012a:	ef258593          	addi	a1,a1,-270 # 80008018 <etext+0x18>
    8000012e:	00009517          	auipc	a0,0x9
    80000132:	f0250513          	addi	a0,a0,-254 # 80009030 <kmem>
    80000136:	00006097          	auipc	ra,0x6
    8000013a:	fb2080e7          	jalr	-78(ra) # 800060e8 <initlock>
  freerange(end, (void *)PHYSTOP);
    8000013e:	45c5                	li	a1,17
    80000140:	05ee                	slli	a1,a1,0x1b
    80000142:	00046517          	auipc	a0,0x46
    80000146:	0fe50513          	addi	a0,a0,254 # 80046240 <end>
    8000014a:	00000097          	auipc	ra,0x0
    8000014e:	f88080e7          	jalr	-120(ra) # 800000d2 <freerange>
}
    80000152:	60a2                	ld	ra,8(sp)
    80000154:	6402                	ld	s0,0(sp)
    80000156:	0141                	addi	sp,sp,16
    80000158:	8082                	ret

000000008000015a <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    8000015a:	1101                	addi	sp,sp,-32
    8000015c:	ec06                	sd	ra,24(sp)
    8000015e:	e822                	sd	s0,16(sp)
    80000160:	e426                	sd	s1,8(sp)
    80000162:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000164:	00009497          	auipc	s1,0x9
    80000168:	ecc48493          	addi	s1,s1,-308 # 80009030 <kmem>
    8000016c:	8526                	mv	a0,s1
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	00a080e7          	jalr	10(ra) # 80006178 <acquire>
  r = kmem.freelist;
    80000176:	6c84                	ld	s1,24(s1)
  if (r)
    80000178:	c4a1                	beqz	s1,800001c0 <kalloc+0x66>
    kmem.freelist = r->next;
    8000017a:	609c                	ld	a5,0(s1)
    8000017c:	00009517          	auipc	a0,0x9
    80000180:	eb450513          	addi	a0,a0,-332 # 80009030 <kmem>
    80000184:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000186:	00006097          	auipc	ra,0x6
    8000018a:	0a6080e7          	jalr	166(ra) # 8000622c <release>

  if (r)
  {
    memset((char *)r, 5, PGSIZE); // fill with junk
    8000018e:	6605                	lui	a2,0x1
    80000190:	4595                	li	a1,5
    80000192:	8526                	mv	a0,s1
    80000194:	00000097          	auipc	ra,0x0
    80000198:	0f6080e7          	jalr	246(ra) # 8000028a <memset>
    page_ref[COW_INDEX(r)] = 1;
    8000019c:	800007b7          	lui	a5,0x80000
    800001a0:	97a6                	add	a5,a5,s1
    800001a2:	83b1                	srli	a5,a5,0xc
    800001a4:	078a                	slli	a5,a5,0x2
    800001a6:	00009717          	auipc	a4,0x9
    800001aa:	eaa70713          	addi	a4,a4,-342 # 80009050 <page_ref>
    800001ae:	97ba                	add	a5,a5,a4
    800001b0:	4705                	li	a4,1
    800001b2:	c398                	sw	a4,0(a5)
  }
  return (void *)r;
}
    800001b4:	8526                	mv	a0,s1
    800001b6:	60e2                	ld	ra,24(sp)
    800001b8:	6442                	ld	s0,16(sp)
    800001ba:	64a2                	ld	s1,8(sp)
    800001bc:	6105                	addi	sp,sp,32
    800001be:	8082                	ret
  release(&kmem.lock);
    800001c0:	00009517          	auipc	a0,0x9
    800001c4:	e7050513          	addi	a0,a0,-400 # 80009030 <kmem>
    800001c8:	00006097          	auipc	ra,0x6
    800001cc:	064080e7          	jalr	100(ra) # 8000622c <release>
  if (r)
    800001d0:	b7d5                	j	800001b4 <kalloc+0x5a>

00000000800001d2 <cow_alloc>:

int cow_alloc(pagetable_t pagetable, uint64 va)
{
    800001d2:	7139                	addi	sp,sp,-64
    800001d4:	fc06                	sd	ra,56(sp)
    800001d6:	f822                	sd	s0,48(sp)
    800001d8:	f426                	sd	s1,40(sp)
    800001da:	f04a                	sd	s2,32(sp)
    800001dc:	ec4e                	sd	s3,24(sp)
    800001de:	e852                	sd	s4,16(sp)
    800001e0:	e456                	sd	s5,8(sp)
    800001e2:	0080                	addi	s0,sp,64
  va = PGROUNDDOWN(va);
    800001e4:	77fd                	lui	a5,0xfffff
    800001e6:	00f5f4b3          	and	s1,a1,a5
  if (va >= MAXVA)
    800001ea:	57fd                	li	a5,-1
    800001ec:	83e9                	srli	a5,a5,0x1a
    800001ee:	0897e663          	bltu	a5,s1,8000027a <cow_alloc+0xa8>
    800001f2:	892a                	mv	s2,a0
    return -1;
  pte_t *pte = walk(pagetable, va, 0);
    800001f4:	4601                	li	a2,0
    800001f6:	85a6                	mv	a1,s1
    800001f8:	00000097          	auipc	ra,0x0
    800001fc:	372080e7          	jalr	882(ra) # 8000056a <walk>
  if (pte == 0)
    80000200:	cd3d                	beqz	a0,8000027e <cow_alloc+0xac>
    return -1;
  uint64 pa = PTE2PA(*pte);
    80000202:	00053a03          	ld	s4,0(a0)
    80000206:	00aa5993          	srli	s3,s4,0xa
    8000020a:	09b2                	slli	s3,s3,0xc
  if (pa == 0)
    8000020c:	06098b63          	beqz	s3,80000282 <cow_alloc+0xb0>
    return -1;
  uint64 flags = PTE_FLAGS(*pte);
  if (flags & PTE_COW)
    80000210:	100a7793          	andi	a5,s4,256
    {
      kfree((void *)mem);
      return -1;
    }
  }
  return 0;
    80000214:	4501                	li	a0,0
  if (flags & PTE_COW)
    80000216:	eb91                	bnez	a5,8000022a <cow_alloc+0x58>
}
    80000218:	70e2                	ld	ra,56(sp)
    8000021a:	7442                	ld	s0,48(sp)
    8000021c:	74a2                	ld	s1,40(sp)
    8000021e:	7902                	ld	s2,32(sp)
    80000220:	69e2                	ld	s3,24(sp)
    80000222:	6a42                	ld	s4,16(sp)
    80000224:	6aa2                	ld	s5,8(sp)
    80000226:	6121                	addi	sp,sp,64
    80000228:	8082                	ret
    uint64 mem = (uint64)kalloc();
    8000022a:	00000097          	auipc	ra,0x0
    8000022e:	f30080e7          	jalr	-208(ra) # 8000015a <kalloc>
    80000232:	8aaa                	mv	s5,a0
    if (mem == 0)
    80000234:	c929                	beqz	a0,80000286 <cow_alloc+0xb4>
    memmove((char *)mem, (char *)pa, PGSIZE);
    80000236:	6605                	lui	a2,0x1
    80000238:	85ce                	mv	a1,s3
    8000023a:	00000097          	auipc	ra,0x0
    8000023e:	0ac080e7          	jalr	172(ra) # 800002e6 <memmove>
    uvmunmap(pagetable, va, 1, 1);
    80000242:	4685                	li	a3,1
    80000244:	4605                	li	a2,1
    80000246:	85a6                	mv	a1,s1
    80000248:	854a                	mv	a0,s2
    8000024a:	00000097          	auipc	ra,0x0
    8000024e:	5ce080e7          	jalr	1486(ra) # 80000818 <uvmunmap>
    flags = (flags | PTE_W) & ~PTE_COW;
    80000252:	2fba7713          	andi	a4,s4,763
    if (mappages(pagetable, va, PGSIZE, mem, flags) != 0)
    80000256:	00476713          	ori	a4,a4,4
    8000025a:	86d6                	mv	a3,s5
    8000025c:	6605                	lui	a2,0x1
    8000025e:	85a6                	mv	a1,s1
    80000260:	854a                	mv	a0,s2
    80000262:	00000097          	auipc	ra,0x0
    80000266:	3f0080e7          	jalr	1008(ra) # 80000652 <mappages>
    8000026a:	d55d                	beqz	a0,80000218 <cow_alloc+0x46>
      kfree((void *)mem);
    8000026c:	8556                	mv	a0,s5
    8000026e:	00000097          	auipc	ra,0x0
    80000272:	dae080e7          	jalr	-594(ra) # 8000001c <kfree>
      return -1;
    80000276:	557d                	li	a0,-1
    80000278:	b745                	j	80000218 <cow_alloc+0x46>
    return -1;
    8000027a:	557d                	li	a0,-1
    8000027c:	bf71                	j	80000218 <cow_alloc+0x46>
    return -1;
    8000027e:	557d                	li	a0,-1
    80000280:	bf61                	j	80000218 <cow_alloc+0x46>
    return -1;
    80000282:	557d                	li	a0,-1
    80000284:	bf51                	j	80000218 <cow_alloc+0x46>
      return -1;
    80000286:	557d                	li	a0,-1
    80000288:	bf41                	j	80000218 <cow_alloc+0x46>

000000008000028a <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000028a:	1141                	addi	sp,sp,-16
    8000028c:	e422                	sd	s0,8(sp)
    8000028e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000290:	ca19                	beqz	a2,800002a6 <memset+0x1c>
    80000292:	87aa                	mv	a5,a0
    80000294:	1602                	slli	a2,a2,0x20
    80000296:	9201                	srli	a2,a2,0x20
    80000298:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    8000029c:	00b78023          	sb	a1,0(a5) # fffffffffffff000 <end+0xffffffff7ffb8dc0>
  for(i = 0; i < n; i++){
    800002a0:	0785                	addi	a5,a5,1
    800002a2:	fee79de3          	bne	a5,a4,8000029c <memset+0x12>
  }
  return dst;
}
    800002a6:	6422                	ld	s0,8(sp)
    800002a8:	0141                	addi	sp,sp,16
    800002aa:	8082                	ret

00000000800002ac <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800002ac:	1141                	addi	sp,sp,-16
    800002ae:	e422                	sd	s0,8(sp)
    800002b0:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800002b2:	ca05                	beqz	a2,800002e2 <memcmp+0x36>
    800002b4:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800002b8:	1682                	slli	a3,a3,0x20
    800002ba:	9281                	srli	a3,a3,0x20
    800002bc:	0685                	addi	a3,a3,1
    800002be:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800002c0:	00054783          	lbu	a5,0(a0)
    800002c4:	0005c703          	lbu	a4,0(a1)
    800002c8:	00e79863          	bne	a5,a4,800002d8 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800002cc:	0505                	addi	a0,a0,1
    800002ce:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800002d0:	fed518e3          	bne	a0,a3,800002c0 <memcmp+0x14>
  }

  return 0;
    800002d4:	4501                	li	a0,0
    800002d6:	a019                	j	800002dc <memcmp+0x30>
      return *s1 - *s2;
    800002d8:	40e7853b          	subw	a0,a5,a4
}
    800002dc:	6422                	ld	s0,8(sp)
    800002de:	0141                	addi	sp,sp,16
    800002e0:	8082                	ret
  return 0;
    800002e2:	4501                	li	a0,0
    800002e4:	bfe5                	j	800002dc <memcmp+0x30>

00000000800002e6 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800002e6:	1141                	addi	sp,sp,-16
    800002e8:	e422                	sd	s0,8(sp)
    800002ea:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800002ec:	c205                	beqz	a2,8000030c <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800002ee:	02a5e263          	bltu	a1,a0,80000312 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800002f2:	1602                	slli	a2,a2,0x20
    800002f4:	9201                	srli	a2,a2,0x20
    800002f6:	00c587b3          	add	a5,a1,a2
{
    800002fa:	872a                	mv	a4,a0
      *d++ = *s++;
    800002fc:	0585                	addi	a1,a1,1
    800002fe:	0705                	addi	a4,a4,1
    80000300:	fff5c683          	lbu	a3,-1(a1)
    80000304:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000308:	fef59ae3          	bne	a1,a5,800002fc <memmove+0x16>

  return dst;
}
    8000030c:	6422                	ld	s0,8(sp)
    8000030e:	0141                	addi	sp,sp,16
    80000310:	8082                	ret
  if(s < d && s + n > d){
    80000312:	02061693          	slli	a3,a2,0x20
    80000316:	9281                	srli	a3,a3,0x20
    80000318:	00d58733          	add	a4,a1,a3
    8000031c:	fce57be3          	bgeu	a0,a4,800002f2 <memmove+0xc>
    d += n;
    80000320:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000322:	fff6079b          	addiw	a5,a2,-1
    80000326:	1782                	slli	a5,a5,0x20
    80000328:	9381                	srli	a5,a5,0x20
    8000032a:	fff7c793          	not	a5,a5
    8000032e:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000330:	177d                	addi	a4,a4,-1
    80000332:	16fd                	addi	a3,a3,-1
    80000334:	00074603          	lbu	a2,0(a4)
    80000338:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000033c:	fee79ae3          	bne	a5,a4,80000330 <memmove+0x4a>
    80000340:	b7f1                	j	8000030c <memmove+0x26>

0000000080000342 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000342:	1141                	addi	sp,sp,-16
    80000344:	e406                	sd	ra,8(sp)
    80000346:	e022                	sd	s0,0(sp)
    80000348:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000034a:	00000097          	auipc	ra,0x0
    8000034e:	f9c080e7          	jalr	-100(ra) # 800002e6 <memmove>
}
    80000352:	60a2                	ld	ra,8(sp)
    80000354:	6402                	ld	s0,0(sp)
    80000356:	0141                	addi	sp,sp,16
    80000358:	8082                	ret

000000008000035a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000035a:	1141                	addi	sp,sp,-16
    8000035c:	e422                	sd	s0,8(sp)
    8000035e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000360:	ce11                	beqz	a2,8000037c <strncmp+0x22>
    80000362:	00054783          	lbu	a5,0(a0)
    80000366:	cf89                	beqz	a5,80000380 <strncmp+0x26>
    80000368:	0005c703          	lbu	a4,0(a1)
    8000036c:	00f71a63          	bne	a4,a5,80000380 <strncmp+0x26>
    n--, p++, q++;
    80000370:	367d                	addiw	a2,a2,-1
    80000372:	0505                	addi	a0,a0,1
    80000374:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000376:	f675                	bnez	a2,80000362 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000378:	4501                	li	a0,0
    8000037a:	a809                	j	8000038c <strncmp+0x32>
    8000037c:	4501                	li	a0,0
    8000037e:	a039                	j	8000038c <strncmp+0x32>
  if(n == 0)
    80000380:	ca09                	beqz	a2,80000392 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000382:	00054503          	lbu	a0,0(a0)
    80000386:	0005c783          	lbu	a5,0(a1)
    8000038a:	9d1d                	subw	a0,a0,a5
}
    8000038c:	6422                	ld	s0,8(sp)
    8000038e:	0141                	addi	sp,sp,16
    80000390:	8082                	ret
    return 0;
    80000392:	4501                	li	a0,0
    80000394:	bfe5                	j	8000038c <strncmp+0x32>

0000000080000396 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000396:	1141                	addi	sp,sp,-16
    80000398:	e422                	sd	s0,8(sp)
    8000039a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    8000039c:	872a                	mv	a4,a0
    8000039e:	8832                	mv	a6,a2
    800003a0:	367d                	addiw	a2,a2,-1
    800003a2:	01005963          	blez	a6,800003b4 <strncpy+0x1e>
    800003a6:	0705                	addi	a4,a4,1
    800003a8:	0005c783          	lbu	a5,0(a1)
    800003ac:	fef70fa3          	sb	a5,-1(a4)
    800003b0:	0585                	addi	a1,a1,1
    800003b2:	f7f5                	bnez	a5,8000039e <strncpy+0x8>
    ;
  while(n-- > 0)
    800003b4:	86ba                	mv	a3,a4
    800003b6:	00c05c63          	blez	a2,800003ce <strncpy+0x38>
    *s++ = 0;
    800003ba:	0685                	addi	a3,a3,1
    800003bc:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800003c0:	40d707bb          	subw	a5,a4,a3
    800003c4:	37fd                	addiw	a5,a5,-1
    800003c6:	010787bb          	addw	a5,a5,a6
    800003ca:	fef048e3          	bgtz	a5,800003ba <strncpy+0x24>
  return os;
}
    800003ce:	6422                	ld	s0,8(sp)
    800003d0:	0141                	addi	sp,sp,16
    800003d2:	8082                	ret

00000000800003d4 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800003d4:	1141                	addi	sp,sp,-16
    800003d6:	e422                	sd	s0,8(sp)
    800003d8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800003da:	02c05363          	blez	a2,80000400 <safestrcpy+0x2c>
    800003de:	fff6069b          	addiw	a3,a2,-1
    800003e2:	1682                	slli	a3,a3,0x20
    800003e4:	9281                	srli	a3,a3,0x20
    800003e6:	96ae                	add	a3,a3,a1
    800003e8:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800003ea:	00d58963          	beq	a1,a3,800003fc <safestrcpy+0x28>
    800003ee:	0585                	addi	a1,a1,1
    800003f0:	0785                	addi	a5,a5,1
    800003f2:	fff5c703          	lbu	a4,-1(a1)
    800003f6:	fee78fa3          	sb	a4,-1(a5)
    800003fa:	fb65                	bnez	a4,800003ea <safestrcpy+0x16>
    ;
  *s = 0;
    800003fc:	00078023          	sb	zero,0(a5)
  return os;
}
    80000400:	6422                	ld	s0,8(sp)
    80000402:	0141                	addi	sp,sp,16
    80000404:	8082                	ret

0000000080000406 <strlen>:

int
strlen(const char *s)
{
    80000406:	1141                	addi	sp,sp,-16
    80000408:	e422                	sd	s0,8(sp)
    8000040a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    8000040c:	00054783          	lbu	a5,0(a0)
    80000410:	cf91                	beqz	a5,8000042c <strlen+0x26>
    80000412:	0505                	addi	a0,a0,1
    80000414:	87aa                	mv	a5,a0
    80000416:	4685                	li	a3,1
    80000418:	9e89                	subw	a3,a3,a0
    8000041a:	00f6853b          	addw	a0,a3,a5
    8000041e:	0785                	addi	a5,a5,1
    80000420:	fff7c703          	lbu	a4,-1(a5)
    80000424:	fb7d                	bnez	a4,8000041a <strlen+0x14>
    ;
  return n;
}
    80000426:	6422                	ld	s0,8(sp)
    80000428:	0141                	addi	sp,sp,16
    8000042a:	8082                	ret
  for(n = 0; s[n]; n++)
    8000042c:	4501                	li	a0,0
    8000042e:	bfe5                	j	80000426 <strlen+0x20>

0000000080000430 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000430:	1141                	addi	sp,sp,-16
    80000432:	e406                	sd	ra,8(sp)
    80000434:	e022                	sd	s0,0(sp)
    80000436:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000438:	00001097          	auipc	ra,0x1
    8000043c:	b1c080e7          	jalr	-1252(ra) # 80000f54 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000440:	00009717          	auipc	a4,0x9
    80000444:	bc070713          	addi	a4,a4,-1088 # 80009000 <started>
  if(cpuid() == 0){
    80000448:	c139                	beqz	a0,8000048e <main+0x5e>
    while(started == 0)
    8000044a:	431c                	lw	a5,0(a4)
    8000044c:	2781                	sext.w	a5,a5
    8000044e:	dff5                	beqz	a5,8000044a <main+0x1a>
      ;
    __sync_synchronize();
    80000450:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000454:	00001097          	auipc	ra,0x1
    80000458:	b00080e7          	jalr	-1280(ra) # 80000f54 <cpuid>
    8000045c:	85aa                	mv	a1,a0
    8000045e:	00008517          	auipc	a0,0x8
    80000462:	bda50513          	addi	a0,a0,-1062 # 80008038 <etext+0x38>
    80000466:	00006097          	auipc	ra,0x6
    8000046a:	824080e7          	jalr	-2012(ra) # 80005c8a <printf>
    kvminithart();    // turn on paging
    8000046e:	00000097          	auipc	ra,0x0
    80000472:	0d8080e7          	jalr	216(ra) # 80000546 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000476:	00001097          	auipc	ra,0x1
    8000047a:	760080e7          	jalr	1888(ra) # 80001bd6 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000047e:	00005097          	auipc	ra,0x5
    80000482:	cf2080e7          	jalr	-782(ra) # 80005170 <plicinithart>
  }

  scheduler();        
    80000486:	00001097          	auipc	ra,0x1
    8000048a:	00c080e7          	jalr	12(ra) # 80001492 <scheduler>
    consoleinit();
    8000048e:	00005097          	auipc	ra,0x5
    80000492:	6c2080e7          	jalr	1730(ra) # 80005b50 <consoleinit>
    printfinit();
    80000496:	00006097          	auipc	ra,0x6
    8000049a:	9d4080e7          	jalr	-1580(ra) # 80005e6a <printfinit>
    printf("\n");
    8000049e:	00008517          	auipc	a0,0x8
    800004a2:	baa50513          	addi	a0,a0,-1110 # 80008048 <etext+0x48>
    800004a6:	00005097          	auipc	ra,0x5
    800004aa:	7e4080e7          	jalr	2020(ra) # 80005c8a <printf>
    printf("xv6 kernel is booting\n");
    800004ae:	00008517          	auipc	a0,0x8
    800004b2:	b7250513          	addi	a0,a0,-1166 # 80008020 <etext+0x20>
    800004b6:	00005097          	auipc	ra,0x5
    800004ba:	7d4080e7          	jalr	2004(ra) # 80005c8a <printf>
    printf("\n");
    800004be:	00008517          	auipc	a0,0x8
    800004c2:	b8a50513          	addi	a0,a0,-1142 # 80008048 <etext+0x48>
    800004c6:	00005097          	auipc	ra,0x5
    800004ca:	7c4080e7          	jalr	1988(ra) # 80005c8a <printf>
    kinit();         // physical page allocator
    800004ce:	00000097          	auipc	ra,0x0
    800004d2:	c50080e7          	jalr	-944(ra) # 8000011e <kinit>
    kvminit();       // create kernel page table
    800004d6:	00000097          	auipc	ra,0x0
    800004da:	322080e7          	jalr	802(ra) # 800007f8 <kvminit>
    kvminithart();   // turn on paging
    800004de:	00000097          	auipc	ra,0x0
    800004e2:	068080e7          	jalr	104(ra) # 80000546 <kvminithart>
    procinit();      // process table
    800004e6:	00001097          	auipc	ra,0x1
    800004ea:	9be080e7          	jalr	-1602(ra) # 80000ea4 <procinit>
    trapinit();      // trap vectors
    800004ee:	00001097          	auipc	ra,0x1
    800004f2:	6c0080e7          	jalr	1728(ra) # 80001bae <trapinit>
    trapinithart();  // install kernel trap vector
    800004f6:	00001097          	auipc	ra,0x1
    800004fa:	6e0080e7          	jalr	1760(ra) # 80001bd6 <trapinithart>
    plicinit();      // set up interrupt controller
    800004fe:	00005097          	auipc	ra,0x5
    80000502:	c5c080e7          	jalr	-932(ra) # 8000515a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000506:	00005097          	auipc	ra,0x5
    8000050a:	c6a080e7          	jalr	-918(ra) # 80005170 <plicinithart>
    binit();         // buffer cache
    8000050e:	00002097          	auipc	ra,0x2
    80000512:	e30080e7          	jalr	-464(ra) # 8000233e <binit>
    iinit();         // inode table
    80000516:	00002097          	auipc	ra,0x2
    8000051a:	4be080e7          	jalr	1214(ra) # 800029d4 <iinit>
    fileinit();      // file table
    8000051e:	00003097          	auipc	ra,0x3
    80000522:	470080e7          	jalr	1136(ra) # 8000398e <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000526:	00005097          	auipc	ra,0x5
    8000052a:	d6a080e7          	jalr	-662(ra) # 80005290 <virtio_disk_init>
    userinit();      // first user process
    8000052e:	00001097          	auipc	ra,0x1
    80000532:	d2a080e7          	jalr	-726(ra) # 80001258 <userinit>
    __sync_synchronize();
    80000536:	0ff0000f          	fence
    started = 1;
    8000053a:	4785                	li	a5,1
    8000053c:	00009717          	auipc	a4,0x9
    80000540:	acf72223          	sw	a5,-1340(a4) # 80009000 <started>
    80000544:	b789                	j	80000486 <main+0x56>

0000000080000546 <kvminithart>:
}

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void kvminithart()
{
    80000546:	1141                	addi	sp,sp,-16
    80000548:	e422                	sd	s0,8(sp)
    8000054a:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    8000054c:	00009797          	auipc	a5,0x9
    80000550:	abc7b783          	ld	a5,-1348(a5) # 80009008 <kernel_pagetable>
    80000554:	83b1                	srli	a5,a5,0xc
    80000556:	577d                	li	a4,-1
    80000558:	177e                	slli	a4,a4,0x3f
    8000055a:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    8000055c:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000560:	12000073          	sfence.vma
  sfence_vma();
}
    80000564:	6422                	ld	s0,8(sp)
    80000566:	0141                	addi	sp,sp,16
    80000568:	8082                	ret

000000008000056a <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000056a:	7139                	addi	sp,sp,-64
    8000056c:	fc06                	sd	ra,56(sp)
    8000056e:	f822                	sd	s0,48(sp)
    80000570:	f426                	sd	s1,40(sp)
    80000572:	f04a                	sd	s2,32(sp)
    80000574:	ec4e                	sd	s3,24(sp)
    80000576:	e852                	sd	s4,16(sp)
    80000578:	e456                	sd	s5,8(sp)
    8000057a:	e05a                	sd	s6,0(sp)
    8000057c:	0080                	addi	s0,sp,64
    8000057e:	84aa                	mv	s1,a0
    80000580:	89ae                	mv	s3,a1
    80000582:	8ab2                	mv	s5,a2
  if (va >= MAXVA)
    80000584:	57fd                	li	a5,-1
    80000586:	83e9                	srli	a5,a5,0x1a
    80000588:	4a79                	li	s4,30
    panic("walk");

  for (int level = 2; level > 0; level--)
    8000058a:	4b31                	li	s6,12
  if (va >= MAXVA)
    8000058c:	04b7f263          	bgeu	a5,a1,800005d0 <walk+0x66>
    panic("walk");
    80000590:	00008517          	auipc	a0,0x8
    80000594:	ac050513          	addi	a0,a0,-1344 # 80008050 <etext+0x50>
    80000598:	00005097          	auipc	ra,0x5
    8000059c:	6a8080e7          	jalr	1704(ra) # 80005c40 <panic>
    {
      pagetable = (pagetable_t)PTE2PA(*pte);
    }
    else
    {
      if (!alloc || (pagetable = (pde_t *)kalloc()) == 0)
    800005a0:	060a8663          	beqz	s5,8000060c <walk+0xa2>
    800005a4:	00000097          	auipc	ra,0x0
    800005a8:	bb6080e7          	jalr	-1098(ra) # 8000015a <kalloc>
    800005ac:	84aa                	mv	s1,a0
    800005ae:	c529                	beqz	a0,800005f8 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800005b0:	6605                	lui	a2,0x1
    800005b2:	4581                	li	a1,0
    800005b4:	00000097          	auipc	ra,0x0
    800005b8:	cd6080e7          	jalr	-810(ra) # 8000028a <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800005bc:	00c4d793          	srli	a5,s1,0xc
    800005c0:	07aa                	slli	a5,a5,0xa
    800005c2:	0017e793          	ori	a5,a5,1
    800005c6:	00f93023          	sd	a5,0(s2)
  for (int level = 2; level > 0; level--)
    800005ca:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffb8db7>
    800005cc:	036a0063          	beq	s4,s6,800005ec <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800005d0:	0149d933          	srl	s2,s3,s4
    800005d4:	1ff97913          	andi	s2,s2,511
    800005d8:	090e                	slli	s2,s2,0x3
    800005da:	9926                	add	s2,s2,s1
    if (*pte & PTE_V)
    800005dc:	00093483          	ld	s1,0(s2)
    800005e0:	0014f793          	andi	a5,s1,1
    800005e4:	dfd5                	beqz	a5,800005a0 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800005e6:	80a9                	srli	s1,s1,0xa
    800005e8:	04b2                	slli	s1,s1,0xc
    800005ea:	b7c5                	j	800005ca <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800005ec:	00c9d513          	srli	a0,s3,0xc
    800005f0:	1ff57513          	andi	a0,a0,511
    800005f4:	050e                	slli	a0,a0,0x3
    800005f6:	9526                	add	a0,a0,s1
}
    800005f8:	70e2                	ld	ra,56(sp)
    800005fa:	7442                	ld	s0,48(sp)
    800005fc:	74a2                	ld	s1,40(sp)
    800005fe:	7902                	ld	s2,32(sp)
    80000600:	69e2                	ld	s3,24(sp)
    80000602:	6a42                	ld	s4,16(sp)
    80000604:	6aa2                	ld	s5,8(sp)
    80000606:	6b02                	ld	s6,0(sp)
    80000608:	6121                	addi	sp,sp,64
    8000060a:	8082                	ret
        return 0;
    8000060c:	4501                	li	a0,0
    8000060e:	b7ed                	j	800005f8 <walk+0x8e>

0000000080000610 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if (va >= MAXVA)
    80000610:	57fd                	li	a5,-1
    80000612:	83e9                	srli	a5,a5,0x1a
    80000614:	00b7f463          	bgeu	a5,a1,8000061c <walkaddr+0xc>
    return 0;
    80000618:	4501                	li	a0,0
    return 0;
  if ((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000061a:	8082                	ret
{
    8000061c:	1141                	addi	sp,sp,-16
    8000061e:	e406                	sd	ra,8(sp)
    80000620:	e022                	sd	s0,0(sp)
    80000622:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000624:	4601                	li	a2,0
    80000626:	00000097          	auipc	ra,0x0
    8000062a:	f44080e7          	jalr	-188(ra) # 8000056a <walk>
  if (pte == 0)
    8000062e:	c105                	beqz	a0,8000064e <walkaddr+0x3e>
  if ((*pte & PTE_V) == 0)
    80000630:	611c                	ld	a5,0(a0)
  if ((*pte & PTE_U) == 0)
    80000632:	0117f693          	andi	a3,a5,17
    80000636:	4745                	li	a4,17
    return 0;
    80000638:	4501                	li	a0,0
  if ((*pte & PTE_U) == 0)
    8000063a:	00e68663          	beq	a3,a4,80000646 <walkaddr+0x36>
}
    8000063e:	60a2                	ld	ra,8(sp)
    80000640:	6402                	ld	s0,0(sp)
    80000642:	0141                	addi	sp,sp,16
    80000644:	8082                	ret
  pa = PTE2PA(*pte);
    80000646:	83a9                	srli	a5,a5,0xa
    80000648:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000064c:	bfcd                	j	8000063e <walkaddr+0x2e>
    return 0;
    8000064e:	4501                	li	a0,0
    80000650:	b7fd                	j	8000063e <walkaddr+0x2e>

0000000080000652 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000652:	715d                	addi	sp,sp,-80
    80000654:	e486                	sd	ra,72(sp)
    80000656:	e0a2                	sd	s0,64(sp)
    80000658:	fc26                	sd	s1,56(sp)
    8000065a:	f84a                	sd	s2,48(sp)
    8000065c:	f44e                	sd	s3,40(sp)
    8000065e:	f052                	sd	s4,32(sp)
    80000660:	ec56                	sd	s5,24(sp)
    80000662:	e85a                	sd	s6,16(sp)
    80000664:	e45e                	sd	s7,8(sp)
    80000666:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if (size == 0)
    80000668:	c639                	beqz	a2,800006b6 <mappages+0x64>
    8000066a:	8aaa                	mv	s5,a0
    8000066c:	8b3a                	mv	s6,a4
    panic("mappages: size");

  a = PGROUNDDOWN(va);
    8000066e:	777d                	lui	a4,0xfffff
    80000670:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80000674:	fff58993          	addi	s3,a1,-1
    80000678:	99b2                	add	s3,s3,a2
    8000067a:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    8000067e:	893e                	mv	s2,a5
    80000680:	40f68a33          	sub	s4,a3,a5
    if (*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if (a == last)
      break;
    a += PGSIZE;
    80000684:	6b85                	lui	s7,0x1
    80000686:	012a04b3          	add	s1,s4,s2
    if ((pte = walk(pagetable, a, 1)) == 0)
    8000068a:	4605                	li	a2,1
    8000068c:	85ca                	mv	a1,s2
    8000068e:	8556                	mv	a0,s5
    80000690:	00000097          	auipc	ra,0x0
    80000694:	eda080e7          	jalr	-294(ra) # 8000056a <walk>
    80000698:	cd1d                	beqz	a0,800006d6 <mappages+0x84>
    if (*pte & PTE_V)
    8000069a:	611c                	ld	a5,0(a0)
    8000069c:	8b85                	andi	a5,a5,1
    8000069e:	e785                	bnez	a5,800006c6 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800006a0:	80b1                	srli	s1,s1,0xc
    800006a2:	04aa                	slli	s1,s1,0xa
    800006a4:	0164e4b3          	or	s1,s1,s6
    800006a8:	0014e493          	ori	s1,s1,1
    800006ac:	e104                	sd	s1,0(a0)
    if (a == last)
    800006ae:	05390063          	beq	s2,s3,800006ee <mappages+0x9c>
    a += PGSIZE;
    800006b2:	995e                	add	s2,s2,s7
    if ((pte = walk(pagetable, a, 1)) == 0)
    800006b4:	bfc9                	j	80000686 <mappages+0x34>
    panic("mappages: size");
    800006b6:	00008517          	auipc	a0,0x8
    800006ba:	9a250513          	addi	a0,a0,-1630 # 80008058 <etext+0x58>
    800006be:	00005097          	auipc	ra,0x5
    800006c2:	582080e7          	jalr	1410(ra) # 80005c40 <panic>
      panic("mappages: remap");
    800006c6:	00008517          	auipc	a0,0x8
    800006ca:	9a250513          	addi	a0,a0,-1630 # 80008068 <etext+0x68>
    800006ce:	00005097          	auipc	ra,0x5
    800006d2:	572080e7          	jalr	1394(ra) # 80005c40 <panic>
      return -1;
    800006d6:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800006d8:	60a6                	ld	ra,72(sp)
    800006da:	6406                	ld	s0,64(sp)
    800006dc:	74e2                	ld	s1,56(sp)
    800006de:	7942                	ld	s2,48(sp)
    800006e0:	79a2                	ld	s3,40(sp)
    800006e2:	7a02                	ld	s4,32(sp)
    800006e4:	6ae2                	ld	s5,24(sp)
    800006e6:	6b42                	ld	s6,16(sp)
    800006e8:	6ba2                	ld	s7,8(sp)
    800006ea:	6161                	addi	sp,sp,80
    800006ec:	8082                	ret
  return 0;
    800006ee:	4501                	li	a0,0
    800006f0:	b7e5                	j	800006d8 <mappages+0x86>

00000000800006f2 <kvmmap>:
{
    800006f2:	1141                	addi	sp,sp,-16
    800006f4:	e406                	sd	ra,8(sp)
    800006f6:	e022                	sd	s0,0(sp)
    800006f8:	0800                	addi	s0,sp,16
    800006fa:	87b6                	mv	a5,a3
  if (mappages(kpgtbl, va, sz, pa, perm) != 0)
    800006fc:	86b2                	mv	a3,a2
    800006fe:	863e                	mv	a2,a5
    80000700:	00000097          	auipc	ra,0x0
    80000704:	f52080e7          	jalr	-174(ra) # 80000652 <mappages>
    80000708:	e509                	bnez	a0,80000712 <kvmmap+0x20>
}
    8000070a:	60a2                	ld	ra,8(sp)
    8000070c:	6402                	ld	s0,0(sp)
    8000070e:	0141                	addi	sp,sp,16
    80000710:	8082                	ret
    panic("kvmmap");
    80000712:	00008517          	auipc	a0,0x8
    80000716:	96650513          	addi	a0,a0,-1690 # 80008078 <etext+0x78>
    8000071a:	00005097          	auipc	ra,0x5
    8000071e:	526080e7          	jalr	1318(ra) # 80005c40 <panic>

0000000080000722 <kvmmake>:
{
    80000722:	1101                	addi	sp,sp,-32
    80000724:	ec06                	sd	ra,24(sp)
    80000726:	e822                	sd	s0,16(sp)
    80000728:	e426                	sd	s1,8(sp)
    8000072a:	e04a                	sd	s2,0(sp)
    8000072c:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t)kalloc();
    8000072e:	00000097          	auipc	ra,0x0
    80000732:	a2c080e7          	jalr	-1492(ra) # 8000015a <kalloc>
    80000736:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000738:	6605                	lui	a2,0x1
    8000073a:	4581                	li	a1,0
    8000073c:	00000097          	auipc	ra,0x0
    80000740:	b4e080e7          	jalr	-1202(ra) # 8000028a <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000744:	4719                	li	a4,6
    80000746:	6685                	lui	a3,0x1
    80000748:	10000637          	lui	a2,0x10000
    8000074c:	100005b7          	lui	a1,0x10000
    80000750:	8526                	mv	a0,s1
    80000752:	00000097          	auipc	ra,0x0
    80000756:	fa0080e7          	jalr	-96(ra) # 800006f2 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000075a:	4719                	li	a4,6
    8000075c:	6685                	lui	a3,0x1
    8000075e:	10001637          	lui	a2,0x10001
    80000762:	100015b7          	lui	a1,0x10001
    80000766:	8526                	mv	a0,s1
    80000768:	00000097          	auipc	ra,0x0
    8000076c:	f8a080e7          	jalr	-118(ra) # 800006f2 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000770:	4719                	li	a4,6
    80000772:	004006b7          	lui	a3,0x400
    80000776:	0c000637          	lui	a2,0xc000
    8000077a:	0c0005b7          	lui	a1,0xc000
    8000077e:	8526                	mv	a0,s1
    80000780:	00000097          	auipc	ra,0x0
    80000784:	f72080e7          	jalr	-142(ra) # 800006f2 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext - KERNBASE, PTE_R | PTE_X);
    80000788:	00008917          	auipc	s2,0x8
    8000078c:	87890913          	addi	s2,s2,-1928 # 80008000 <etext>
    80000790:	4729                	li	a4,10
    80000792:	80008697          	auipc	a3,0x80008
    80000796:	86e68693          	addi	a3,a3,-1938 # 8000 <_entry-0x7fff8000>
    8000079a:	4605                	li	a2,1
    8000079c:	067e                	slli	a2,a2,0x1f
    8000079e:	85b2                	mv	a1,a2
    800007a0:	8526                	mv	a0,s1
    800007a2:	00000097          	auipc	ra,0x0
    800007a6:	f50080e7          	jalr	-176(ra) # 800006f2 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP - (uint64)etext, PTE_R | PTE_W);
    800007aa:	4719                	li	a4,6
    800007ac:	46c5                	li	a3,17
    800007ae:	06ee                	slli	a3,a3,0x1b
    800007b0:	412686b3          	sub	a3,a3,s2
    800007b4:	864a                	mv	a2,s2
    800007b6:	85ca                	mv	a1,s2
    800007b8:	8526                	mv	a0,s1
    800007ba:	00000097          	auipc	ra,0x0
    800007be:	f38080e7          	jalr	-200(ra) # 800006f2 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800007c2:	4729                	li	a4,10
    800007c4:	6685                	lui	a3,0x1
    800007c6:	00007617          	auipc	a2,0x7
    800007ca:	83a60613          	addi	a2,a2,-1990 # 80007000 <_trampoline>
    800007ce:	040005b7          	lui	a1,0x4000
    800007d2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800007d4:	05b2                	slli	a1,a1,0xc
    800007d6:	8526                	mv	a0,s1
    800007d8:	00000097          	auipc	ra,0x0
    800007dc:	f1a080e7          	jalr	-230(ra) # 800006f2 <kvmmap>
  proc_mapstacks(kpgtbl);
    800007e0:	8526                	mv	a0,s1
    800007e2:	00000097          	auipc	ra,0x0
    800007e6:	62c080e7          	jalr	1580(ra) # 80000e0e <proc_mapstacks>
}
    800007ea:	8526                	mv	a0,s1
    800007ec:	60e2                	ld	ra,24(sp)
    800007ee:	6442                	ld	s0,16(sp)
    800007f0:	64a2                	ld	s1,8(sp)
    800007f2:	6902                	ld	s2,0(sp)
    800007f4:	6105                	addi	sp,sp,32
    800007f6:	8082                	ret

00000000800007f8 <kvminit>:
{
    800007f8:	1141                	addi	sp,sp,-16
    800007fa:	e406                	sd	ra,8(sp)
    800007fc:	e022                	sd	s0,0(sp)
    800007fe:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000800:	00000097          	auipc	ra,0x0
    80000804:	f22080e7          	jalr	-222(ra) # 80000722 <kvmmake>
    80000808:	00009797          	auipc	a5,0x9
    8000080c:	80a7b023          	sd	a0,-2048(a5) # 80009008 <kernel_pagetable>
}
    80000810:	60a2                	ld	ra,8(sp)
    80000812:	6402                	ld	s0,0(sp)
    80000814:	0141                	addi	sp,sp,16
    80000816:	8082                	ret

0000000080000818 <uvmunmap>:

// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000818:	715d                	addi	sp,sp,-80
    8000081a:	e486                	sd	ra,72(sp)
    8000081c:	e0a2                	sd	s0,64(sp)
    8000081e:	fc26                	sd	s1,56(sp)
    80000820:	f84a                	sd	s2,48(sp)
    80000822:	f44e                	sd	s3,40(sp)
    80000824:	f052                	sd	s4,32(sp)
    80000826:	ec56                	sd	s5,24(sp)
    80000828:	e85a                	sd	s6,16(sp)
    8000082a:	e45e                	sd	s7,8(sp)
    8000082c:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if ((va % PGSIZE) != 0)
    8000082e:	03459793          	slli	a5,a1,0x34
    80000832:	e795                	bnez	a5,8000085e <uvmunmap+0x46>
    80000834:	8a2a                	mv	s4,a0
    80000836:	892e                	mv	s2,a1
    80000838:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
    8000083a:	0632                	slli	a2,a2,0xc
    8000083c:	00b609b3          	add	s3,a2,a1
  {
    if ((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if ((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if (PTE_FLAGS(*pte) == PTE_V)
    80000840:	4b85                	li	s7,1
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
    80000842:	6b05                	lui	s6,0x1
    80000844:	0735e263          	bltu	a1,s3,800008a8 <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void *)pa);
    }
    *pte = 0;
  }
}
    80000848:	60a6                	ld	ra,72(sp)
    8000084a:	6406                	ld	s0,64(sp)
    8000084c:	74e2                	ld	s1,56(sp)
    8000084e:	7942                	ld	s2,48(sp)
    80000850:	79a2                	ld	s3,40(sp)
    80000852:	7a02                	ld	s4,32(sp)
    80000854:	6ae2                	ld	s5,24(sp)
    80000856:	6b42                	ld	s6,16(sp)
    80000858:	6ba2                	ld	s7,8(sp)
    8000085a:	6161                	addi	sp,sp,80
    8000085c:	8082                	ret
    panic("uvmunmap: not aligned");
    8000085e:	00008517          	auipc	a0,0x8
    80000862:	82250513          	addi	a0,a0,-2014 # 80008080 <etext+0x80>
    80000866:	00005097          	auipc	ra,0x5
    8000086a:	3da080e7          	jalr	986(ra) # 80005c40 <panic>
      panic("uvmunmap: walk");
    8000086e:	00008517          	auipc	a0,0x8
    80000872:	82a50513          	addi	a0,a0,-2006 # 80008098 <etext+0x98>
    80000876:	00005097          	auipc	ra,0x5
    8000087a:	3ca080e7          	jalr	970(ra) # 80005c40 <panic>
      panic("uvmunmap: not mapped");
    8000087e:	00008517          	auipc	a0,0x8
    80000882:	82a50513          	addi	a0,a0,-2006 # 800080a8 <etext+0xa8>
    80000886:	00005097          	auipc	ra,0x5
    8000088a:	3ba080e7          	jalr	954(ra) # 80005c40 <panic>
      panic("uvmunmap: not a leaf");
    8000088e:	00008517          	auipc	a0,0x8
    80000892:	83250513          	addi	a0,a0,-1998 # 800080c0 <etext+0xc0>
    80000896:	00005097          	auipc	ra,0x5
    8000089a:	3aa080e7          	jalr	938(ra) # 80005c40 <panic>
    *pte = 0;
    8000089e:	0004b023          	sd	zero,0(s1)
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
    800008a2:	995a                	add	s2,s2,s6
    800008a4:	fb3972e3          	bgeu	s2,s3,80000848 <uvmunmap+0x30>
    if ((pte = walk(pagetable, a, 0)) == 0)
    800008a8:	4601                	li	a2,0
    800008aa:	85ca                	mv	a1,s2
    800008ac:	8552                	mv	a0,s4
    800008ae:	00000097          	auipc	ra,0x0
    800008b2:	cbc080e7          	jalr	-836(ra) # 8000056a <walk>
    800008b6:	84aa                	mv	s1,a0
    800008b8:	d95d                	beqz	a0,8000086e <uvmunmap+0x56>
    if ((*pte & PTE_V) == 0)
    800008ba:	6108                	ld	a0,0(a0)
    800008bc:	00157793          	andi	a5,a0,1
    800008c0:	dfdd                	beqz	a5,8000087e <uvmunmap+0x66>
    if (PTE_FLAGS(*pte) == PTE_V)
    800008c2:	3ff57793          	andi	a5,a0,1023
    800008c6:	fd7784e3          	beq	a5,s7,8000088e <uvmunmap+0x76>
    if (do_free)
    800008ca:	fc0a8ae3          	beqz	s5,8000089e <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    800008ce:	8129                	srli	a0,a0,0xa
      kfree((void *)pa);
    800008d0:	0532                	slli	a0,a0,0xc
    800008d2:	fffff097          	auipc	ra,0xfffff
    800008d6:	74a080e7          	jalr	1866(ra) # 8000001c <kfree>
    800008da:	b7d1                	j	8000089e <uvmunmap+0x86>

00000000800008dc <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800008dc:	1101                	addi	sp,sp,-32
    800008de:	ec06                	sd	ra,24(sp)
    800008e0:	e822                	sd	s0,16(sp)
    800008e2:	e426                	sd	s1,8(sp)
    800008e4:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t)kalloc();
    800008e6:	00000097          	auipc	ra,0x0
    800008ea:	874080e7          	jalr	-1932(ra) # 8000015a <kalloc>
    800008ee:	84aa                	mv	s1,a0
  if (pagetable == 0)
    800008f0:	c519                	beqz	a0,800008fe <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800008f2:	6605                	lui	a2,0x1
    800008f4:	4581                	li	a1,0
    800008f6:	00000097          	auipc	ra,0x0
    800008fa:	994080e7          	jalr	-1644(ra) # 8000028a <memset>
  return pagetable;
}
    800008fe:	8526                	mv	a0,s1
    80000900:	60e2                	ld	ra,24(sp)
    80000902:	6442                	ld	s0,16(sp)
    80000904:	64a2                	ld	s1,8(sp)
    80000906:	6105                	addi	sp,sp,32
    80000908:	8082                	ret

000000008000090a <uvminit>:

// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    8000090a:	7179                	addi	sp,sp,-48
    8000090c:	f406                	sd	ra,40(sp)
    8000090e:	f022                	sd	s0,32(sp)
    80000910:	ec26                	sd	s1,24(sp)
    80000912:	e84a                	sd	s2,16(sp)
    80000914:	e44e                	sd	s3,8(sp)
    80000916:	e052                	sd	s4,0(sp)
    80000918:	1800                	addi	s0,sp,48
  char *mem;

  if (sz >= PGSIZE)
    8000091a:	6785                	lui	a5,0x1
    8000091c:	04f67863          	bgeu	a2,a5,8000096c <uvminit+0x62>
    80000920:	8a2a                	mv	s4,a0
    80000922:	89ae                	mv	s3,a1
    80000924:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80000926:	00000097          	auipc	ra,0x0
    8000092a:	834080e7          	jalr	-1996(ra) # 8000015a <kalloc>
    8000092e:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000930:	6605                	lui	a2,0x1
    80000932:	4581                	li	a1,0
    80000934:	00000097          	auipc	ra,0x0
    80000938:	956080e7          	jalr	-1706(ra) # 8000028a <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W | PTE_R | PTE_X | PTE_U);
    8000093c:	4779                	li	a4,30
    8000093e:	86ca                	mv	a3,s2
    80000940:	6605                	lui	a2,0x1
    80000942:	4581                	li	a1,0
    80000944:	8552                	mv	a0,s4
    80000946:	00000097          	auipc	ra,0x0
    8000094a:	d0c080e7          	jalr	-756(ra) # 80000652 <mappages>
  memmove(mem, src, sz);
    8000094e:	8626                	mv	a2,s1
    80000950:	85ce                	mv	a1,s3
    80000952:	854a                	mv	a0,s2
    80000954:	00000097          	auipc	ra,0x0
    80000958:	992080e7          	jalr	-1646(ra) # 800002e6 <memmove>
}
    8000095c:	70a2                	ld	ra,40(sp)
    8000095e:	7402                	ld	s0,32(sp)
    80000960:	64e2                	ld	s1,24(sp)
    80000962:	6942                	ld	s2,16(sp)
    80000964:	69a2                	ld	s3,8(sp)
    80000966:	6a02                	ld	s4,0(sp)
    80000968:	6145                	addi	sp,sp,48
    8000096a:	8082                	ret
    panic("inituvm: more than a page");
    8000096c:	00007517          	auipc	a0,0x7
    80000970:	76c50513          	addi	a0,a0,1900 # 800080d8 <etext+0xd8>
    80000974:	00005097          	auipc	ra,0x5
    80000978:	2cc080e7          	jalr	716(ra) # 80005c40 <panic>

000000008000097c <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000097c:	1101                	addi	sp,sp,-32
    8000097e:	ec06                	sd	ra,24(sp)
    80000980:	e822                	sd	s0,16(sp)
    80000982:	e426                	sd	s1,8(sp)
    80000984:	1000                	addi	s0,sp,32
  if (newsz >= oldsz)
    return oldsz;
    80000986:	84ae                	mv	s1,a1
  if (newsz >= oldsz)
    80000988:	00b67d63          	bgeu	a2,a1,800009a2 <uvmdealloc+0x26>
    8000098c:	84b2                	mv	s1,a2

  if (PGROUNDUP(newsz) < PGROUNDUP(oldsz))
    8000098e:	6785                	lui	a5,0x1
    80000990:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000992:	00f60733          	add	a4,a2,a5
    80000996:	76fd                	lui	a3,0xfffff
    80000998:	8f75                	and	a4,a4,a3
    8000099a:	97ae                	add	a5,a5,a1
    8000099c:	8ff5                	and	a5,a5,a3
    8000099e:	00f76863          	bltu	a4,a5,800009ae <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800009a2:	8526                	mv	a0,s1
    800009a4:	60e2                	ld	ra,24(sp)
    800009a6:	6442                	ld	s0,16(sp)
    800009a8:	64a2                	ld	s1,8(sp)
    800009aa:	6105                	addi	sp,sp,32
    800009ac:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800009ae:	8f99                	sub	a5,a5,a4
    800009b0:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800009b2:	4685                	li	a3,1
    800009b4:	0007861b          	sext.w	a2,a5
    800009b8:	85ba                	mv	a1,a4
    800009ba:	00000097          	auipc	ra,0x0
    800009be:	e5e080e7          	jalr	-418(ra) # 80000818 <uvmunmap>
    800009c2:	b7c5                	j	800009a2 <uvmdealloc+0x26>

00000000800009c4 <uvmalloc>:
  if (newsz < oldsz)
    800009c4:	0ab66163          	bltu	a2,a1,80000a66 <uvmalloc+0xa2>
{
    800009c8:	7139                	addi	sp,sp,-64
    800009ca:	fc06                	sd	ra,56(sp)
    800009cc:	f822                	sd	s0,48(sp)
    800009ce:	f426                	sd	s1,40(sp)
    800009d0:	f04a                	sd	s2,32(sp)
    800009d2:	ec4e                	sd	s3,24(sp)
    800009d4:	e852                	sd	s4,16(sp)
    800009d6:	e456                	sd	s5,8(sp)
    800009d8:	0080                	addi	s0,sp,64
    800009da:	8aaa                	mv	s5,a0
    800009dc:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800009de:	6785                	lui	a5,0x1
    800009e0:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800009e2:	95be                	add	a1,a1,a5
    800009e4:	77fd                	lui	a5,0xfffff
    800009e6:	00f5f9b3          	and	s3,a1,a5
  for (a = oldsz; a < newsz; a += PGSIZE)
    800009ea:	08c9f063          	bgeu	s3,a2,80000a6a <uvmalloc+0xa6>
    800009ee:	894e                	mv	s2,s3
    mem = kalloc();
    800009f0:	fffff097          	auipc	ra,0xfffff
    800009f4:	76a080e7          	jalr	1898(ra) # 8000015a <kalloc>
    800009f8:	84aa                	mv	s1,a0
    if (mem == 0)
    800009fa:	c51d                	beqz	a0,80000a28 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800009fc:	6605                	lui	a2,0x1
    800009fe:	4581                	li	a1,0
    80000a00:	00000097          	auipc	ra,0x0
    80000a04:	88a080e7          	jalr	-1910(ra) # 8000028a <memset>
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W | PTE_X | PTE_R | PTE_U) != 0)
    80000a08:	4779                	li	a4,30
    80000a0a:	86a6                	mv	a3,s1
    80000a0c:	6605                	lui	a2,0x1
    80000a0e:	85ca                	mv	a1,s2
    80000a10:	8556                	mv	a0,s5
    80000a12:	00000097          	auipc	ra,0x0
    80000a16:	c40080e7          	jalr	-960(ra) # 80000652 <mappages>
    80000a1a:	e905                	bnez	a0,80000a4a <uvmalloc+0x86>
  for (a = oldsz; a < newsz; a += PGSIZE)
    80000a1c:	6785                	lui	a5,0x1
    80000a1e:	993e                	add	s2,s2,a5
    80000a20:	fd4968e3          	bltu	s2,s4,800009f0 <uvmalloc+0x2c>
  return newsz;
    80000a24:	8552                	mv	a0,s4
    80000a26:	a809                	j	80000a38 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80000a28:	864e                	mv	a2,s3
    80000a2a:	85ca                	mv	a1,s2
    80000a2c:	8556                	mv	a0,s5
    80000a2e:	00000097          	auipc	ra,0x0
    80000a32:	f4e080e7          	jalr	-178(ra) # 8000097c <uvmdealloc>
      return 0;
    80000a36:	4501                	li	a0,0
}
    80000a38:	70e2                	ld	ra,56(sp)
    80000a3a:	7442                	ld	s0,48(sp)
    80000a3c:	74a2                	ld	s1,40(sp)
    80000a3e:	7902                	ld	s2,32(sp)
    80000a40:	69e2                	ld	s3,24(sp)
    80000a42:	6a42                	ld	s4,16(sp)
    80000a44:	6aa2                	ld	s5,8(sp)
    80000a46:	6121                	addi	sp,sp,64
    80000a48:	8082                	ret
      kfree(mem);
    80000a4a:	8526                	mv	a0,s1
    80000a4c:	fffff097          	auipc	ra,0xfffff
    80000a50:	5d0080e7          	jalr	1488(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000a54:	864e                	mv	a2,s3
    80000a56:	85ca                	mv	a1,s2
    80000a58:	8556                	mv	a0,s5
    80000a5a:	00000097          	auipc	ra,0x0
    80000a5e:	f22080e7          	jalr	-222(ra) # 8000097c <uvmdealloc>
      return 0;
    80000a62:	4501                	li	a0,0
    80000a64:	bfd1                	j	80000a38 <uvmalloc+0x74>
    return oldsz;
    80000a66:	852e                	mv	a0,a1
}
    80000a68:	8082                	ret
  return newsz;
    80000a6a:	8532                	mv	a0,a2
    80000a6c:	b7f1                	j	80000a38 <uvmalloc+0x74>

0000000080000a6e <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void freewalk(pagetable_t pagetable)
{
    80000a6e:	7179                	addi	sp,sp,-48
    80000a70:	f406                	sd	ra,40(sp)
    80000a72:	f022                	sd	s0,32(sp)
    80000a74:	ec26                	sd	s1,24(sp)
    80000a76:	e84a                	sd	s2,16(sp)
    80000a78:	e44e                	sd	s3,8(sp)
    80000a7a:	e052                	sd	s4,0(sp)
    80000a7c:	1800                	addi	s0,sp,48
    80000a7e:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for (int i = 0; i < 512; i++)
    80000a80:	84aa                	mv	s1,a0
    80000a82:	6905                	lui	s2,0x1
    80000a84:	992a                	add	s2,s2,a0
  {
    pte_t pte = pagetable[i];
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0)
    80000a86:	4985                	li	s3,1
    80000a88:	a829                	j	80000aa2 <freewalk+0x34>
    {
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000a8a:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000a8c:	00c79513          	slli	a0,a5,0xc
    80000a90:	00000097          	auipc	ra,0x0
    80000a94:	fde080e7          	jalr	-34(ra) # 80000a6e <freewalk>
      pagetable[i] = 0;
    80000a98:	0004b023          	sd	zero,0(s1)
  for (int i = 0; i < 512; i++)
    80000a9c:	04a1                	addi	s1,s1,8
    80000a9e:	03248163          	beq	s1,s2,80000ac0 <freewalk+0x52>
    pte_t pte = pagetable[i];
    80000aa2:	609c                	ld	a5,0(s1)
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0)
    80000aa4:	00f7f713          	andi	a4,a5,15
    80000aa8:	ff3701e3          	beq	a4,s3,80000a8a <freewalk+0x1c>
    }
    else if (pte & PTE_V)
    80000aac:	8b85                	andi	a5,a5,1
    80000aae:	d7fd                	beqz	a5,80000a9c <freewalk+0x2e>
    {
      panic("freewalk: leaf");
    80000ab0:	00007517          	auipc	a0,0x7
    80000ab4:	64850513          	addi	a0,a0,1608 # 800080f8 <etext+0xf8>
    80000ab8:	00005097          	auipc	ra,0x5
    80000abc:	188080e7          	jalr	392(ra) # 80005c40 <panic>
    }
  }
  kfree((void *)pagetable);
    80000ac0:	8552                	mv	a0,s4
    80000ac2:	fffff097          	auipc	ra,0xfffff
    80000ac6:	55a080e7          	jalr	1370(ra) # 8000001c <kfree>
}
    80000aca:	70a2                	ld	ra,40(sp)
    80000acc:	7402                	ld	s0,32(sp)
    80000ace:	64e2                	ld	s1,24(sp)
    80000ad0:	6942                	ld	s2,16(sp)
    80000ad2:	69a2                	ld	s3,8(sp)
    80000ad4:	6a02                	ld	s4,0(sp)
    80000ad6:	6145                	addi	sp,sp,48
    80000ad8:	8082                	ret

0000000080000ada <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000ada:	1101                	addi	sp,sp,-32
    80000adc:	ec06                	sd	ra,24(sp)
    80000ade:	e822                	sd	s0,16(sp)
    80000ae0:	e426                	sd	s1,8(sp)
    80000ae2:	1000                	addi	s0,sp,32
    80000ae4:	84aa                	mv	s1,a0
  if (sz > 0)
    80000ae6:	e999                	bnez	a1,80000afc <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
  freewalk(pagetable);
    80000ae8:	8526                	mv	a0,s1
    80000aea:	00000097          	auipc	ra,0x0
    80000aee:	f84080e7          	jalr	-124(ra) # 80000a6e <freewalk>
}
    80000af2:	60e2                	ld	ra,24(sp)
    80000af4:	6442                	ld	s0,16(sp)
    80000af6:	64a2                	ld	s1,8(sp)
    80000af8:	6105                	addi	sp,sp,32
    80000afa:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    80000afc:	6785                	lui	a5,0x1
    80000afe:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000b00:	95be                	add	a1,a1,a5
    80000b02:	4685                	li	a3,1
    80000b04:	00c5d613          	srli	a2,a1,0xc
    80000b08:	4581                	li	a1,0
    80000b0a:	00000097          	auipc	ra,0x0
    80000b0e:	d0e080e7          	jalr	-754(ra) # 80000818 <uvmunmap>
    80000b12:	bfd9                	j	80000ae8 <uvmfree+0xe>

0000000080000b14 <uvmcopy>:
{
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  // char *mem;
  for (i = 0; i < sz; i += PGSIZE)
    80000b14:	c669                	beqz	a2,80000bde <uvmcopy+0xca>
{
    80000b16:	715d                	addi	sp,sp,-80
    80000b18:	e486                	sd	ra,72(sp)
    80000b1a:	e0a2                	sd	s0,64(sp)
    80000b1c:	fc26                	sd	s1,56(sp)
    80000b1e:	f84a                	sd	s2,48(sp)
    80000b20:	f44e                	sd	s3,40(sp)
    80000b22:	f052                	sd	s4,32(sp)
    80000b24:	ec56                	sd	s5,24(sp)
    80000b26:	e85a                	sd	s6,16(sp)
    80000b28:	e45e                	sd	s7,8(sp)
    80000b2a:	0880                	addi	s0,sp,80
    80000b2c:	8aaa                	mv	s5,a0
    80000b2e:	8a2e                	mv	s4,a1
    80000b30:	89b2                	mv	s3,a2
  for (i = 0; i < sz; i += PGSIZE)
    80000b32:	4901                	li	s2,0
    {
      // kfree(mem);
      goto err;
    }
    // acquire(&ref_lock);
    page_ref[COW_INDEX(pa)]++;
    80000b34:	80000bb7          	lui	s7,0x80000
    80000b38:	00008b17          	auipc	s6,0x8
    80000b3c:	518b0b13          	addi	s6,s6,1304 # 80009050 <page_ref>
    if ((pte = walk(old, i, 0)) == 0)
    80000b40:	4601                	li	a2,0
    80000b42:	85ca                	mv	a1,s2
    80000b44:	8556                	mv	a0,s5
    80000b46:	00000097          	auipc	ra,0x0
    80000b4a:	a24080e7          	jalr	-1500(ra) # 8000056a <walk>
    80000b4e:	c139                	beqz	a0,80000b94 <uvmcopy+0x80>
    if ((*pte & PTE_V) == 0)
    80000b50:	6118                	ld	a4,0(a0)
    80000b52:	00177793          	andi	a5,a4,1
    80000b56:	c7b9                	beqz	a5,80000ba4 <uvmcopy+0x90>
    pa = PTE2PA(*pte);
    80000b58:	00a75493          	srli	s1,a4,0xa
    80000b5c:	04b2                	slli	s1,s1,0xc
    *pte = (*pte & ~PTE_W) | PTE_COW;
    80000b5e:	efb77713          	andi	a4,a4,-261
    80000b62:	10076713          	ori	a4,a4,256
    80000b66:	e118                	sd	a4,0(a0)
    if (mappages(new, i, PGSIZE, pa, flags) != 0)
    80000b68:	3fb77713          	andi	a4,a4,1019
    80000b6c:	86a6                	mv	a3,s1
    80000b6e:	6605                	lui	a2,0x1
    80000b70:	85ca                	mv	a1,s2
    80000b72:	8552                	mv	a0,s4
    80000b74:	00000097          	auipc	ra,0x0
    80000b78:	ade080e7          	jalr	-1314(ra) # 80000652 <mappages>
    80000b7c:	ed05                	bnez	a0,80000bb4 <uvmcopy+0xa0>
    page_ref[COW_INDEX(pa)]++;
    80000b7e:	94de                	add	s1,s1,s7
    80000b80:	80a9                	srli	s1,s1,0xa
    80000b82:	94da                	add	s1,s1,s6
    80000b84:	409c                	lw	a5,0(s1)
    80000b86:	2785                	addiw	a5,a5,1
    80000b88:	c09c                	sw	a5,0(s1)
  for (i = 0; i < sz; i += PGSIZE)
    80000b8a:	6785                	lui	a5,0x1
    80000b8c:	993e                	add	s2,s2,a5
    80000b8e:	fb3969e3          	bltu	s2,s3,80000b40 <uvmcopy+0x2c>
    80000b92:	a81d                	j	80000bc8 <uvmcopy+0xb4>
      panic("uvmcopy: pte should exist");
    80000b94:	00007517          	auipc	a0,0x7
    80000b98:	57450513          	addi	a0,a0,1396 # 80008108 <etext+0x108>
    80000b9c:	00005097          	auipc	ra,0x5
    80000ba0:	0a4080e7          	jalr	164(ra) # 80005c40 <panic>
      panic("uvmcopy: page not present");
    80000ba4:	00007517          	auipc	a0,0x7
    80000ba8:	58450513          	addi	a0,a0,1412 # 80008128 <etext+0x128>
    80000bac:	00005097          	auipc	ra,0x5
    80000bb0:	094080e7          	jalr	148(ra) # 80005c40 <panic>
    // release(&ref_lock);
  }
  return 0;
err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000bb4:	4685                	li	a3,1
    80000bb6:	00c95613          	srli	a2,s2,0xc
    80000bba:	4581                	li	a1,0
    80000bbc:	8552                	mv	a0,s4
    80000bbe:	00000097          	auipc	ra,0x0
    80000bc2:	c5a080e7          	jalr	-934(ra) # 80000818 <uvmunmap>
  return -1;
    80000bc6:	557d                	li	a0,-1
}
    80000bc8:	60a6                	ld	ra,72(sp)
    80000bca:	6406                	ld	s0,64(sp)
    80000bcc:	74e2                	ld	s1,56(sp)
    80000bce:	7942                	ld	s2,48(sp)
    80000bd0:	79a2                	ld	s3,40(sp)
    80000bd2:	7a02                	ld	s4,32(sp)
    80000bd4:	6ae2                	ld	s5,24(sp)
    80000bd6:	6b42                	ld	s6,16(sp)
    80000bd8:	6ba2                	ld	s7,8(sp)
    80000bda:	6161                	addi	sp,sp,80
    80000bdc:	8082                	ret
  return 0;
    80000bde:	4501                	li	a0,0
}
    80000be0:	8082                	ret

0000000080000be2 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void uvmclear(pagetable_t pagetable, uint64 va)
{
    80000be2:	1141                	addi	sp,sp,-16
    80000be4:	e406                	sd	ra,8(sp)
    80000be6:	e022                	sd	s0,0(sp)
    80000be8:	0800                	addi	s0,sp,16
  pte_t *pte;

  pte = walk(pagetable, va, 0);
    80000bea:	4601                	li	a2,0
    80000bec:	00000097          	auipc	ra,0x0
    80000bf0:	97e080e7          	jalr	-1666(ra) # 8000056a <walk>
  if (pte == 0)
    80000bf4:	c901                	beqz	a0,80000c04 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000bf6:	611c                	ld	a5,0(a0)
    80000bf8:	9bbd                	andi	a5,a5,-17
    80000bfa:	e11c                	sd	a5,0(a0)
}
    80000bfc:	60a2                	ld	ra,8(sp)
    80000bfe:	6402                	ld	s0,0(sp)
    80000c00:	0141                	addi	sp,sp,16
    80000c02:	8082                	ret
    panic("uvmclear");
    80000c04:	00007517          	auipc	a0,0x7
    80000c08:	54450513          	addi	a0,a0,1348 # 80008148 <etext+0x148>
    80000c0c:	00005097          	auipc	ra,0x5
    80000c10:	034080e7          	jalr	52(ra) # 80005c40 <panic>

0000000080000c14 <copyout>:

// Copy from kernel to user.
// Copy len bytes from src to virtual address dstva in a given page table.
// Return 0 on success, -1 on error.
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
    80000c14:	711d                	addi	sp,sp,-96
    80000c16:	ec86                	sd	ra,88(sp)
    80000c18:	e8a2                	sd	s0,80(sp)
    80000c1a:	e4a6                	sd	s1,72(sp)
    80000c1c:	e0ca                	sd	s2,64(sp)
    80000c1e:	fc4e                	sd	s3,56(sp)
    80000c20:	f852                	sd	s4,48(sp)
    80000c22:	f456                	sd	s5,40(sp)
    80000c24:	f05a                	sd	s6,32(sp)
    80000c26:	ec5e                	sd	s7,24(sp)
    80000c28:	e862                	sd	s8,16(sp)
    80000c2a:	e466                	sd	s9,8(sp)
    80000c2c:	e06a                	sd	s10,0(sp)
    80000c2e:	1080                	addi	s0,sp,96
  uint64 n, va0, pa0;
  pte_t *pte;

  while (len > 0)
    80000c30:	cab5                	beqz	a3,80000ca4 <copyout+0x90>
    80000c32:	8b2a                	mv	s6,a0
    80000c34:	89ae                	mv	s3,a1
    80000c36:	8bb2                	mv	s7,a2
    80000c38:	8ab6                	mv	s5,a3
  {
    va0 = PGROUNDDOWN(dstva);
    80000c3a:	7cfd                	lui	s9,0xfffff
    if (cow_alloc(pagetable, va0) != 0)
      return -1;
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000c3c:	6c05                	lui	s8,0x1
    80000c3e:	a815                	j	80000c72 <copyout+0x5e>
    if (n > len)
      n = len;
    pte = walk(pagetable, va0, 0);
    80000c40:	4601                	li	a2,0
    80000c42:	85ca                	mv	a1,s2
    80000c44:	855a                	mv	a0,s6
    80000c46:	00000097          	auipc	ra,0x0
    80000c4a:	924080e7          	jalr	-1756(ra) # 8000056a <walk>
    if (pte == 0)
    80000c4e:	cd3d                	beqz	a0,80000ccc <copyout+0xb8>
      return -1;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000c50:	41298533          	sub	a0,s3,s2
    80000c54:	0004861b          	sext.w	a2,s1
    80000c58:	85de                	mv	a1,s7
    80000c5a:	9552                	add	a0,a0,s4
    80000c5c:	fffff097          	auipc	ra,0xfffff
    80000c60:	68a080e7          	jalr	1674(ra) # 800002e6 <memmove>

    len -= n;
    80000c64:	409a8ab3          	sub	s5,s5,s1
    src += n;
    80000c68:	9ba6                	add	s7,s7,s1
    dstva = va0 + PGSIZE;
    80000c6a:	018909b3          	add	s3,s2,s8
  while (len > 0)
    80000c6e:	020a8e63          	beqz	s5,80000caa <copyout+0x96>
    va0 = PGROUNDDOWN(dstva);
    80000c72:	0199f933          	and	s2,s3,s9
    if (cow_alloc(pagetable, va0) != 0)
    80000c76:	85ca                	mv	a1,s2
    80000c78:	855a                	mv	a0,s6
    80000c7a:	fffff097          	auipc	ra,0xfffff
    80000c7e:	558080e7          	jalr	1368(ra) # 800001d2 <cow_alloc>
    80000c82:	8d2a                	mv	s10,a0
    80000c84:	e115                	bnez	a0,80000ca8 <copyout+0x94>
    pa0 = walkaddr(pagetable, va0);
    80000c86:	85ca                	mv	a1,s2
    80000c88:	855a                	mv	a0,s6
    80000c8a:	00000097          	auipc	ra,0x0
    80000c8e:	986080e7          	jalr	-1658(ra) # 80000610 <walkaddr>
    80000c92:	8a2a                	mv	s4,a0
    if (pa0 == 0)
    80000c94:	c915                	beqz	a0,80000cc8 <copyout+0xb4>
    n = PGSIZE - (dstva - va0);
    80000c96:	413904b3          	sub	s1,s2,s3
    80000c9a:	94e2                	add	s1,s1,s8
    80000c9c:	fa9af2e3          	bgeu	s5,s1,80000c40 <copyout+0x2c>
    80000ca0:	84d6                	mv	s1,s5
    80000ca2:	bf79                	j	80000c40 <copyout+0x2c>
  }
  return 0;
    80000ca4:	4d01                	li	s10,0
    80000ca6:	a011                	j	80000caa <copyout+0x96>
      return -1;
    80000ca8:	5d7d                	li	s10,-1
}
    80000caa:	856a                	mv	a0,s10
    80000cac:	60e6                	ld	ra,88(sp)
    80000cae:	6446                	ld	s0,80(sp)
    80000cb0:	64a6                	ld	s1,72(sp)
    80000cb2:	6906                	ld	s2,64(sp)
    80000cb4:	79e2                	ld	s3,56(sp)
    80000cb6:	7a42                	ld	s4,48(sp)
    80000cb8:	7aa2                	ld	s5,40(sp)
    80000cba:	7b02                	ld	s6,32(sp)
    80000cbc:	6be2                	ld	s7,24(sp)
    80000cbe:	6c42                	ld	s8,16(sp)
    80000cc0:	6ca2                	ld	s9,8(sp)
    80000cc2:	6d02                	ld	s10,0(sp)
    80000cc4:	6125                	addi	sp,sp,96
    80000cc6:	8082                	ret
      return -1;
    80000cc8:	5d7d                	li	s10,-1
    80000cca:	b7c5                	j	80000caa <copyout+0x96>
      return -1;
    80000ccc:	5d7d                	li	s10,-1
    80000cce:	bff1                	j	80000caa <copyout+0x96>

0000000080000cd0 <copyin>:
// Return 0 on success, -1 on error.
int copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while (len > 0)
    80000cd0:	caa5                	beqz	a3,80000d40 <copyin+0x70>
{
    80000cd2:	715d                	addi	sp,sp,-80
    80000cd4:	e486                	sd	ra,72(sp)
    80000cd6:	e0a2                	sd	s0,64(sp)
    80000cd8:	fc26                	sd	s1,56(sp)
    80000cda:	f84a                	sd	s2,48(sp)
    80000cdc:	f44e                	sd	s3,40(sp)
    80000cde:	f052                	sd	s4,32(sp)
    80000ce0:	ec56                	sd	s5,24(sp)
    80000ce2:	e85a                	sd	s6,16(sp)
    80000ce4:	e45e                	sd	s7,8(sp)
    80000ce6:	e062                	sd	s8,0(sp)
    80000ce8:	0880                	addi	s0,sp,80
    80000cea:	8b2a                	mv	s6,a0
    80000cec:	8a2e                	mv	s4,a1
    80000cee:	8c32                	mv	s8,a2
    80000cf0:	89b6                	mv	s3,a3
  {
    va0 = PGROUNDDOWN(srcva);
    80000cf2:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000cf4:	6a85                	lui	s5,0x1
    80000cf6:	a01d                	j	80000d1c <copyin+0x4c>
    if (n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000cf8:	018505b3          	add	a1,a0,s8
    80000cfc:	0004861b          	sext.w	a2,s1
    80000d00:	412585b3          	sub	a1,a1,s2
    80000d04:	8552                	mv	a0,s4
    80000d06:	fffff097          	auipc	ra,0xfffff
    80000d0a:	5e0080e7          	jalr	1504(ra) # 800002e6 <memmove>

    len -= n;
    80000d0e:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000d12:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000d14:	01590c33          	add	s8,s2,s5
  while (len > 0)
    80000d18:	02098263          	beqz	s3,80000d3c <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000d1c:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000d20:	85ca                	mv	a1,s2
    80000d22:	855a                	mv	a0,s6
    80000d24:	00000097          	auipc	ra,0x0
    80000d28:	8ec080e7          	jalr	-1812(ra) # 80000610 <walkaddr>
    if (pa0 == 0)
    80000d2c:	cd01                	beqz	a0,80000d44 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000d2e:	418904b3          	sub	s1,s2,s8
    80000d32:	94d6                	add	s1,s1,s5
    80000d34:	fc99f2e3          	bgeu	s3,s1,80000cf8 <copyin+0x28>
    80000d38:	84ce                	mv	s1,s3
    80000d3a:	bf7d                	j	80000cf8 <copyin+0x28>
  }
  return 0;
    80000d3c:	4501                	li	a0,0
    80000d3e:	a021                	j	80000d46 <copyin+0x76>
    80000d40:	4501                	li	a0,0
}
    80000d42:	8082                	ret
      return -1;
    80000d44:	557d                	li	a0,-1
}
    80000d46:	60a6                	ld	ra,72(sp)
    80000d48:	6406                	ld	s0,64(sp)
    80000d4a:	74e2                	ld	s1,56(sp)
    80000d4c:	7942                	ld	s2,48(sp)
    80000d4e:	79a2                	ld	s3,40(sp)
    80000d50:	7a02                	ld	s4,32(sp)
    80000d52:	6ae2                	ld	s5,24(sp)
    80000d54:	6b42                	ld	s6,16(sp)
    80000d56:	6ba2                	ld	s7,8(sp)
    80000d58:	6c02                	ld	s8,0(sp)
    80000d5a:	6161                	addi	sp,sp,80
    80000d5c:	8082                	ret

0000000080000d5e <copyinstr>:
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while (got_null == 0 && max > 0)
    80000d5e:	c2dd                	beqz	a3,80000e04 <copyinstr+0xa6>
{
    80000d60:	715d                	addi	sp,sp,-80
    80000d62:	e486                	sd	ra,72(sp)
    80000d64:	e0a2                	sd	s0,64(sp)
    80000d66:	fc26                	sd	s1,56(sp)
    80000d68:	f84a                	sd	s2,48(sp)
    80000d6a:	f44e                	sd	s3,40(sp)
    80000d6c:	f052                	sd	s4,32(sp)
    80000d6e:	ec56                	sd	s5,24(sp)
    80000d70:	e85a                	sd	s6,16(sp)
    80000d72:	e45e                	sd	s7,8(sp)
    80000d74:	0880                	addi	s0,sp,80
    80000d76:	8a2a                	mv	s4,a0
    80000d78:	8b2e                	mv	s6,a1
    80000d7a:	8bb2                	mv	s7,a2
    80000d7c:	84b6                	mv	s1,a3
  {
    va0 = PGROUNDDOWN(srcva);
    80000d7e:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000d80:	6985                	lui	s3,0x1
    80000d82:	a02d                	j	80000dac <copyinstr+0x4e>
    char *p = (char *)(pa0 + (srcva - va0));
    while (n > 0)
    {
      if (*p == '\0')
      {
        *dst = '\0';
    80000d84:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000d88:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if (got_null)
    80000d8a:	37fd                	addiw	a5,a5,-1
    80000d8c:	0007851b          	sext.w	a0,a5
  }
  else
  {
    return -1;
  }
}
    80000d90:	60a6                	ld	ra,72(sp)
    80000d92:	6406                	ld	s0,64(sp)
    80000d94:	74e2                	ld	s1,56(sp)
    80000d96:	7942                	ld	s2,48(sp)
    80000d98:	79a2                	ld	s3,40(sp)
    80000d9a:	7a02                	ld	s4,32(sp)
    80000d9c:	6ae2                	ld	s5,24(sp)
    80000d9e:	6b42                	ld	s6,16(sp)
    80000da0:	6ba2                	ld	s7,8(sp)
    80000da2:	6161                	addi	sp,sp,80
    80000da4:	8082                	ret
    srcva = va0 + PGSIZE;
    80000da6:	01390bb3          	add	s7,s2,s3
  while (got_null == 0 && max > 0)
    80000daa:	c8a9                	beqz	s1,80000dfc <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80000dac:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000db0:	85ca                	mv	a1,s2
    80000db2:	8552                	mv	a0,s4
    80000db4:	00000097          	auipc	ra,0x0
    80000db8:	85c080e7          	jalr	-1956(ra) # 80000610 <walkaddr>
    if (pa0 == 0)
    80000dbc:	c131                	beqz	a0,80000e00 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000dbe:	417906b3          	sub	a3,s2,s7
    80000dc2:	96ce                	add	a3,a3,s3
    80000dc4:	00d4f363          	bgeu	s1,a3,80000dca <copyinstr+0x6c>
    80000dc8:	86a6                	mv	a3,s1
    char *p = (char *)(pa0 + (srcva - va0));
    80000dca:	955e                	add	a0,a0,s7
    80000dcc:	41250533          	sub	a0,a0,s2
    while (n > 0)
    80000dd0:	daf9                	beqz	a3,80000da6 <copyinstr+0x48>
    80000dd2:	87da                	mv	a5,s6
      if (*p == '\0')
    80000dd4:	41650633          	sub	a2,a0,s6
    80000dd8:	fff48593          	addi	a1,s1,-1
    80000ddc:	95da                	add	a1,a1,s6
    while (n > 0)
    80000dde:	96da                	add	a3,a3,s6
      if (*p == '\0')
    80000de0:	00f60733          	add	a4,a2,a5
    80000de4:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffb8dc0>
    80000de8:	df51                	beqz	a4,80000d84 <copyinstr+0x26>
        *dst = *p;
    80000dea:	00e78023          	sb	a4,0(a5)
      --max;
    80000dee:	40f584b3          	sub	s1,a1,a5
      dst++;
    80000df2:	0785                	addi	a5,a5,1
    while (n > 0)
    80000df4:	fed796e3          	bne	a5,a3,80000de0 <copyinstr+0x82>
      dst++;
    80000df8:	8b3e                	mv	s6,a5
    80000dfa:	b775                	j	80000da6 <copyinstr+0x48>
    80000dfc:	4781                	li	a5,0
    80000dfe:	b771                	j	80000d8a <copyinstr+0x2c>
      return -1;
    80000e00:	557d                	li	a0,-1
    80000e02:	b779                	j	80000d90 <copyinstr+0x32>
  int got_null = 0;
    80000e04:	4781                	li	a5,0
  if (got_null)
    80000e06:	37fd                	addiw	a5,a5,-1
    80000e08:	0007851b          	sext.w	a0,a5
}
    80000e0c:	8082                	ret

0000000080000e0e <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000e0e:	7139                	addi	sp,sp,-64
    80000e10:	fc06                	sd	ra,56(sp)
    80000e12:	f822                	sd	s0,48(sp)
    80000e14:	f426                	sd	s1,40(sp)
    80000e16:	f04a                	sd	s2,32(sp)
    80000e18:	ec4e                	sd	s3,24(sp)
    80000e1a:	e852                	sd	s4,16(sp)
    80000e1c:	e456                	sd	s5,8(sp)
    80000e1e:	e05a                	sd	s6,0(sp)
    80000e20:	0080                	addi	s0,sp,64
    80000e22:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e24:	00028497          	auipc	s1,0x28
    80000e28:	65c48493          	addi	s1,s1,1628 # 80029480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000e2c:	8b26                	mv	s6,s1
    80000e2e:	00007a97          	auipc	s5,0x7
    80000e32:	1d2a8a93          	addi	s5,s5,466 # 80008000 <etext>
    80000e36:	04000937          	lui	s2,0x4000
    80000e3a:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000e3c:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e3e:	0002ea17          	auipc	s4,0x2e
    80000e42:	042a0a13          	addi	s4,s4,66 # 8002ee80 <tickslock>
    char *pa = kalloc();
    80000e46:	fffff097          	auipc	ra,0xfffff
    80000e4a:	314080e7          	jalr	788(ra) # 8000015a <kalloc>
    80000e4e:	862a                	mv	a2,a0
    if(pa == 0)
    80000e50:	c131                	beqz	a0,80000e94 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000e52:	416485b3          	sub	a1,s1,s6
    80000e56:	858d                	srai	a1,a1,0x3
    80000e58:	000ab783          	ld	a5,0(s5)
    80000e5c:	02f585b3          	mul	a1,a1,a5
    80000e60:	2585                	addiw	a1,a1,1
    80000e62:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000e66:	4719                	li	a4,6
    80000e68:	6685                	lui	a3,0x1
    80000e6a:	40b905b3          	sub	a1,s2,a1
    80000e6e:	854e                	mv	a0,s3
    80000e70:	00000097          	auipc	ra,0x0
    80000e74:	882080e7          	jalr	-1918(ra) # 800006f2 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e78:	16848493          	addi	s1,s1,360
    80000e7c:	fd4495e3          	bne	s1,s4,80000e46 <proc_mapstacks+0x38>
  }
}
    80000e80:	70e2                	ld	ra,56(sp)
    80000e82:	7442                	ld	s0,48(sp)
    80000e84:	74a2                	ld	s1,40(sp)
    80000e86:	7902                	ld	s2,32(sp)
    80000e88:	69e2                	ld	s3,24(sp)
    80000e8a:	6a42                	ld	s4,16(sp)
    80000e8c:	6aa2                	ld	s5,8(sp)
    80000e8e:	6b02                	ld	s6,0(sp)
    80000e90:	6121                	addi	sp,sp,64
    80000e92:	8082                	ret
      panic("kalloc");
    80000e94:	00007517          	auipc	a0,0x7
    80000e98:	2c450513          	addi	a0,a0,708 # 80008158 <etext+0x158>
    80000e9c:	00005097          	auipc	ra,0x5
    80000ea0:	da4080e7          	jalr	-604(ra) # 80005c40 <panic>

0000000080000ea4 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000ea4:	7139                	addi	sp,sp,-64
    80000ea6:	fc06                	sd	ra,56(sp)
    80000ea8:	f822                	sd	s0,48(sp)
    80000eaa:	f426                	sd	s1,40(sp)
    80000eac:	f04a                	sd	s2,32(sp)
    80000eae:	ec4e                	sd	s3,24(sp)
    80000eb0:	e852                	sd	s4,16(sp)
    80000eb2:	e456                	sd	s5,8(sp)
    80000eb4:	e05a                	sd	s6,0(sp)
    80000eb6:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000eb8:	00007597          	auipc	a1,0x7
    80000ebc:	2a858593          	addi	a1,a1,680 # 80008160 <etext+0x160>
    80000ec0:	00028517          	auipc	a0,0x28
    80000ec4:	19050513          	addi	a0,a0,400 # 80029050 <pid_lock>
    80000ec8:	00005097          	auipc	ra,0x5
    80000ecc:	220080e7          	jalr	544(ra) # 800060e8 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000ed0:	00007597          	auipc	a1,0x7
    80000ed4:	29858593          	addi	a1,a1,664 # 80008168 <etext+0x168>
    80000ed8:	00028517          	auipc	a0,0x28
    80000edc:	19050513          	addi	a0,a0,400 # 80029068 <wait_lock>
    80000ee0:	00005097          	auipc	ra,0x5
    80000ee4:	208080e7          	jalr	520(ra) # 800060e8 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ee8:	00028497          	auipc	s1,0x28
    80000eec:	59848493          	addi	s1,s1,1432 # 80029480 <proc>
      initlock(&p->lock, "proc");
    80000ef0:	00007b17          	auipc	s6,0x7
    80000ef4:	288b0b13          	addi	s6,s6,648 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000ef8:	8aa6                	mv	s5,s1
    80000efa:	00007a17          	auipc	s4,0x7
    80000efe:	106a0a13          	addi	s4,s4,262 # 80008000 <etext>
    80000f02:	04000937          	lui	s2,0x4000
    80000f06:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000f08:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f0a:	0002e997          	auipc	s3,0x2e
    80000f0e:	f7698993          	addi	s3,s3,-138 # 8002ee80 <tickslock>
      initlock(&p->lock, "proc");
    80000f12:	85da                	mv	a1,s6
    80000f14:	8526                	mv	a0,s1
    80000f16:	00005097          	auipc	ra,0x5
    80000f1a:	1d2080e7          	jalr	466(ra) # 800060e8 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000f1e:	415487b3          	sub	a5,s1,s5
    80000f22:	878d                	srai	a5,a5,0x3
    80000f24:	000a3703          	ld	a4,0(s4)
    80000f28:	02e787b3          	mul	a5,a5,a4
    80000f2c:	2785                	addiw	a5,a5,1
    80000f2e:	00d7979b          	slliw	a5,a5,0xd
    80000f32:	40f907b3          	sub	a5,s2,a5
    80000f36:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f38:	16848493          	addi	s1,s1,360
    80000f3c:	fd349be3          	bne	s1,s3,80000f12 <procinit+0x6e>
  }
}
    80000f40:	70e2                	ld	ra,56(sp)
    80000f42:	7442                	ld	s0,48(sp)
    80000f44:	74a2                	ld	s1,40(sp)
    80000f46:	7902                	ld	s2,32(sp)
    80000f48:	69e2                	ld	s3,24(sp)
    80000f4a:	6a42                	ld	s4,16(sp)
    80000f4c:	6aa2                	ld	s5,8(sp)
    80000f4e:	6b02                	ld	s6,0(sp)
    80000f50:	6121                	addi	sp,sp,64
    80000f52:	8082                	ret

0000000080000f54 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000f54:	1141                	addi	sp,sp,-16
    80000f56:	e422                	sd	s0,8(sp)
    80000f58:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000f5a:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000f5c:	2501                	sext.w	a0,a0
    80000f5e:	6422                	ld	s0,8(sp)
    80000f60:	0141                	addi	sp,sp,16
    80000f62:	8082                	ret

0000000080000f64 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000f64:	1141                	addi	sp,sp,-16
    80000f66:	e422                	sd	s0,8(sp)
    80000f68:	0800                	addi	s0,sp,16
    80000f6a:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000f6c:	2781                	sext.w	a5,a5
    80000f6e:	079e                	slli	a5,a5,0x7
  return c;
}
    80000f70:	00028517          	auipc	a0,0x28
    80000f74:	11050513          	addi	a0,a0,272 # 80029080 <cpus>
    80000f78:	953e                	add	a0,a0,a5
    80000f7a:	6422                	ld	s0,8(sp)
    80000f7c:	0141                	addi	sp,sp,16
    80000f7e:	8082                	ret

0000000080000f80 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000f80:	1101                	addi	sp,sp,-32
    80000f82:	ec06                	sd	ra,24(sp)
    80000f84:	e822                	sd	s0,16(sp)
    80000f86:	e426                	sd	s1,8(sp)
    80000f88:	1000                	addi	s0,sp,32
  push_off();
    80000f8a:	00005097          	auipc	ra,0x5
    80000f8e:	1a2080e7          	jalr	418(ra) # 8000612c <push_off>
    80000f92:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000f94:	2781                	sext.w	a5,a5
    80000f96:	079e                	slli	a5,a5,0x7
    80000f98:	00028717          	auipc	a4,0x28
    80000f9c:	0b870713          	addi	a4,a4,184 # 80029050 <pid_lock>
    80000fa0:	97ba                	add	a5,a5,a4
    80000fa2:	7b84                	ld	s1,48(a5)
  pop_off();
    80000fa4:	00005097          	auipc	ra,0x5
    80000fa8:	228080e7          	jalr	552(ra) # 800061cc <pop_off>
  return p;
}
    80000fac:	8526                	mv	a0,s1
    80000fae:	60e2                	ld	ra,24(sp)
    80000fb0:	6442                	ld	s0,16(sp)
    80000fb2:	64a2                	ld	s1,8(sp)
    80000fb4:	6105                	addi	sp,sp,32
    80000fb6:	8082                	ret

0000000080000fb8 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000fb8:	1141                	addi	sp,sp,-16
    80000fba:	e406                	sd	ra,8(sp)
    80000fbc:	e022                	sd	s0,0(sp)
    80000fbe:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000fc0:	00000097          	auipc	ra,0x0
    80000fc4:	fc0080e7          	jalr	-64(ra) # 80000f80 <myproc>
    80000fc8:	00005097          	auipc	ra,0x5
    80000fcc:	264080e7          	jalr	612(ra) # 8000622c <release>

  if (first) {
    80000fd0:	00008797          	auipc	a5,0x8
    80000fd4:	8407a783          	lw	a5,-1984(a5) # 80008810 <first.1>
    80000fd8:	eb89                	bnez	a5,80000fea <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000fda:	00001097          	auipc	ra,0x1
    80000fde:	c14080e7          	jalr	-1004(ra) # 80001bee <usertrapret>
}
    80000fe2:	60a2                	ld	ra,8(sp)
    80000fe4:	6402                	ld	s0,0(sp)
    80000fe6:	0141                	addi	sp,sp,16
    80000fe8:	8082                	ret
    first = 0;
    80000fea:	00008797          	auipc	a5,0x8
    80000fee:	8207a323          	sw	zero,-2010(a5) # 80008810 <first.1>
    fsinit(ROOTDEV);
    80000ff2:	4505                	li	a0,1
    80000ff4:	00002097          	auipc	ra,0x2
    80000ff8:	960080e7          	jalr	-1696(ra) # 80002954 <fsinit>
    80000ffc:	bff9                	j	80000fda <forkret+0x22>

0000000080000ffe <allocpid>:
allocpid() {
    80000ffe:	1101                	addi	sp,sp,-32
    80001000:	ec06                	sd	ra,24(sp)
    80001002:	e822                	sd	s0,16(sp)
    80001004:	e426                	sd	s1,8(sp)
    80001006:	e04a                	sd	s2,0(sp)
    80001008:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    8000100a:	00028917          	auipc	s2,0x28
    8000100e:	04690913          	addi	s2,s2,70 # 80029050 <pid_lock>
    80001012:	854a                	mv	a0,s2
    80001014:	00005097          	auipc	ra,0x5
    80001018:	164080e7          	jalr	356(ra) # 80006178 <acquire>
  pid = nextpid;
    8000101c:	00007797          	auipc	a5,0x7
    80001020:	7f878793          	addi	a5,a5,2040 # 80008814 <nextpid>
    80001024:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001026:	0014871b          	addiw	a4,s1,1
    8000102a:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    8000102c:	854a                	mv	a0,s2
    8000102e:	00005097          	auipc	ra,0x5
    80001032:	1fe080e7          	jalr	510(ra) # 8000622c <release>
}
    80001036:	8526                	mv	a0,s1
    80001038:	60e2                	ld	ra,24(sp)
    8000103a:	6442                	ld	s0,16(sp)
    8000103c:	64a2                	ld	s1,8(sp)
    8000103e:	6902                	ld	s2,0(sp)
    80001040:	6105                	addi	sp,sp,32
    80001042:	8082                	ret

0000000080001044 <proc_pagetable>:
{
    80001044:	1101                	addi	sp,sp,-32
    80001046:	ec06                	sd	ra,24(sp)
    80001048:	e822                	sd	s0,16(sp)
    8000104a:	e426                	sd	s1,8(sp)
    8000104c:	e04a                	sd	s2,0(sp)
    8000104e:	1000                	addi	s0,sp,32
    80001050:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001052:	00000097          	auipc	ra,0x0
    80001056:	88a080e7          	jalr	-1910(ra) # 800008dc <uvmcreate>
    8000105a:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000105c:	c121                	beqz	a0,8000109c <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    8000105e:	4729                	li	a4,10
    80001060:	00006697          	auipc	a3,0x6
    80001064:	fa068693          	addi	a3,a3,-96 # 80007000 <_trampoline>
    80001068:	6605                	lui	a2,0x1
    8000106a:	040005b7          	lui	a1,0x4000
    8000106e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001070:	05b2                	slli	a1,a1,0xc
    80001072:	fffff097          	auipc	ra,0xfffff
    80001076:	5e0080e7          	jalr	1504(ra) # 80000652 <mappages>
    8000107a:	02054863          	bltz	a0,800010aa <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    8000107e:	4719                	li	a4,6
    80001080:	05893683          	ld	a3,88(s2)
    80001084:	6605                	lui	a2,0x1
    80001086:	020005b7          	lui	a1,0x2000
    8000108a:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    8000108c:	05b6                	slli	a1,a1,0xd
    8000108e:	8526                	mv	a0,s1
    80001090:	fffff097          	auipc	ra,0xfffff
    80001094:	5c2080e7          	jalr	1474(ra) # 80000652 <mappages>
    80001098:	02054163          	bltz	a0,800010ba <proc_pagetable+0x76>
}
    8000109c:	8526                	mv	a0,s1
    8000109e:	60e2                	ld	ra,24(sp)
    800010a0:	6442                	ld	s0,16(sp)
    800010a2:	64a2                	ld	s1,8(sp)
    800010a4:	6902                	ld	s2,0(sp)
    800010a6:	6105                	addi	sp,sp,32
    800010a8:	8082                	ret
    uvmfree(pagetable, 0);
    800010aa:	4581                	li	a1,0
    800010ac:	8526                	mv	a0,s1
    800010ae:	00000097          	auipc	ra,0x0
    800010b2:	a2c080e7          	jalr	-1492(ra) # 80000ada <uvmfree>
    return 0;
    800010b6:	4481                	li	s1,0
    800010b8:	b7d5                	j	8000109c <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010ba:	4681                	li	a3,0
    800010bc:	4605                	li	a2,1
    800010be:	040005b7          	lui	a1,0x4000
    800010c2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800010c4:	05b2                	slli	a1,a1,0xc
    800010c6:	8526                	mv	a0,s1
    800010c8:	fffff097          	auipc	ra,0xfffff
    800010cc:	750080e7          	jalr	1872(ra) # 80000818 <uvmunmap>
    uvmfree(pagetable, 0);
    800010d0:	4581                	li	a1,0
    800010d2:	8526                	mv	a0,s1
    800010d4:	00000097          	auipc	ra,0x0
    800010d8:	a06080e7          	jalr	-1530(ra) # 80000ada <uvmfree>
    return 0;
    800010dc:	4481                	li	s1,0
    800010de:	bf7d                	j	8000109c <proc_pagetable+0x58>

00000000800010e0 <proc_freepagetable>:
{
    800010e0:	1101                	addi	sp,sp,-32
    800010e2:	ec06                	sd	ra,24(sp)
    800010e4:	e822                	sd	s0,16(sp)
    800010e6:	e426                	sd	s1,8(sp)
    800010e8:	e04a                	sd	s2,0(sp)
    800010ea:	1000                	addi	s0,sp,32
    800010ec:	84aa                	mv	s1,a0
    800010ee:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010f0:	4681                	li	a3,0
    800010f2:	4605                	li	a2,1
    800010f4:	040005b7          	lui	a1,0x4000
    800010f8:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800010fa:	05b2                	slli	a1,a1,0xc
    800010fc:	fffff097          	auipc	ra,0xfffff
    80001100:	71c080e7          	jalr	1820(ra) # 80000818 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001104:	4681                	li	a3,0
    80001106:	4605                	li	a2,1
    80001108:	020005b7          	lui	a1,0x2000
    8000110c:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    8000110e:	05b6                	slli	a1,a1,0xd
    80001110:	8526                	mv	a0,s1
    80001112:	fffff097          	auipc	ra,0xfffff
    80001116:	706080e7          	jalr	1798(ra) # 80000818 <uvmunmap>
  uvmfree(pagetable, sz);
    8000111a:	85ca                	mv	a1,s2
    8000111c:	8526                	mv	a0,s1
    8000111e:	00000097          	auipc	ra,0x0
    80001122:	9bc080e7          	jalr	-1604(ra) # 80000ada <uvmfree>
}
    80001126:	60e2                	ld	ra,24(sp)
    80001128:	6442                	ld	s0,16(sp)
    8000112a:	64a2                	ld	s1,8(sp)
    8000112c:	6902                	ld	s2,0(sp)
    8000112e:	6105                	addi	sp,sp,32
    80001130:	8082                	ret

0000000080001132 <freeproc>:
{
    80001132:	1101                	addi	sp,sp,-32
    80001134:	ec06                	sd	ra,24(sp)
    80001136:	e822                	sd	s0,16(sp)
    80001138:	e426                	sd	s1,8(sp)
    8000113a:	1000                	addi	s0,sp,32
    8000113c:	84aa                	mv	s1,a0
  if(p->trapframe)
    8000113e:	6d28                	ld	a0,88(a0)
    80001140:	c509                	beqz	a0,8000114a <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001142:	fffff097          	auipc	ra,0xfffff
    80001146:	eda080e7          	jalr	-294(ra) # 8000001c <kfree>
  p->trapframe = 0;
    8000114a:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    8000114e:	68a8                	ld	a0,80(s1)
    80001150:	c511                	beqz	a0,8000115c <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001152:	64ac                	ld	a1,72(s1)
    80001154:	00000097          	auipc	ra,0x0
    80001158:	f8c080e7          	jalr	-116(ra) # 800010e0 <proc_freepagetable>
  p->pagetable = 0;
    8000115c:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001160:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001164:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001168:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    8000116c:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001170:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001174:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001178:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    8000117c:	0004ac23          	sw	zero,24(s1)
}
    80001180:	60e2                	ld	ra,24(sp)
    80001182:	6442                	ld	s0,16(sp)
    80001184:	64a2                	ld	s1,8(sp)
    80001186:	6105                	addi	sp,sp,32
    80001188:	8082                	ret

000000008000118a <allocproc>:
{
    8000118a:	1101                	addi	sp,sp,-32
    8000118c:	ec06                	sd	ra,24(sp)
    8000118e:	e822                	sd	s0,16(sp)
    80001190:	e426                	sd	s1,8(sp)
    80001192:	e04a                	sd	s2,0(sp)
    80001194:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001196:	00028497          	auipc	s1,0x28
    8000119a:	2ea48493          	addi	s1,s1,746 # 80029480 <proc>
    8000119e:	0002e917          	auipc	s2,0x2e
    800011a2:	ce290913          	addi	s2,s2,-798 # 8002ee80 <tickslock>
    acquire(&p->lock);
    800011a6:	8526                	mv	a0,s1
    800011a8:	00005097          	auipc	ra,0x5
    800011ac:	fd0080e7          	jalr	-48(ra) # 80006178 <acquire>
    if(p->state == UNUSED) {
    800011b0:	4c9c                	lw	a5,24(s1)
    800011b2:	cf81                	beqz	a5,800011ca <allocproc+0x40>
      release(&p->lock);
    800011b4:	8526                	mv	a0,s1
    800011b6:	00005097          	auipc	ra,0x5
    800011ba:	076080e7          	jalr	118(ra) # 8000622c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800011be:	16848493          	addi	s1,s1,360
    800011c2:	ff2492e3          	bne	s1,s2,800011a6 <allocproc+0x1c>
  return 0;
    800011c6:	4481                	li	s1,0
    800011c8:	a889                	j	8000121a <allocproc+0x90>
  p->pid = allocpid();
    800011ca:	00000097          	auipc	ra,0x0
    800011ce:	e34080e7          	jalr	-460(ra) # 80000ffe <allocpid>
    800011d2:	d888                	sw	a0,48(s1)
  p->state = USED;
    800011d4:	4785                	li	a5,1
    800011d6:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800011d8:	fffff097          	auipc	ra,0xfffff
    800011dc:	f82080e7          	jalr	-126(ra) # 8000015a <kalloc>
    800011e0:	892a                	mv	s2,a0
    800011e2:	eca8                	sd	a0,88(s1)
    800011e4:	c131                	beqz	a0,80001228 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800011e6:	8526                	mv	a0,s1
    800011e8:	00000097          	auipc	ra,0x0
    800011ec:	e5c080e7          	jalr	-420(ra) # 80001044 <proc_pagetable>
    800011f0:	892a                	mv	s2,a0
    800011f2:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800011f4:	c531                	beqz	a0,80001240 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800011f6:	07000613          	li	a2,112
    800011fa:	4581                	li	a1,0
    800011fc:	06048513          	addi	a0,s1,96
    80001200:	fffff097          	auipc	ra,0xfffff
    80001204:	08a080e7          	jalr	138(ra) # 8000028a <memset>
  p->context.ra = (uint64)forkret;
    80001208:	00000797          	auipc	a5,0x0
    8000120c:	db078793          	addi	a5,a5,-592 # 80000fb8 <forkret>
    80001210:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001212:	60bc                	ld	a5,64(s1)
    80001214:	6705                	lui	a4,0x1
    80001216:	97ba                	add	a5,a5,a4
    80001218:	f4bc                	sd	a5,104(s1)
}
    8000121a:	8526                	mv	a0,s1
    8000121c:	60e2                	ld	ra,24(sp)
    8000121e:	6442                	ld	s0,16(sp)
    80001220:	64a2                	ld	s1,8(sp)
    80001222:	6902                	ld	s2,0(sp)
    80001224:	6105                	addi	sp,sp,32
    80001226:	8082                	ret
    freeproc(p);
    80001228:	8526                	mv	a0,s1
    8000122a:	00000097          	auipc	ra,0x0
    8000122e:	f08080e7          	jalr	-248(ra) # 80001132 <freeproc>
    release(&p->lock);
    80001232:	8526                	mv	a0,s1
    80001234:	00005097          	auipc	ra,0x5
    80001238:	ff8080e7          	jalr	-8(ra) # 8000622c <release>
    return 0;
    8000123c:	84ca                	mv	s1,s2
    8000123e:	bff1                	j	8000121a <allocproc+0x90>
    freeproc(p);
    80001240:	8526                	mv	a0,s1
    80001242:	00000097          	auipc	ra,0x0
    80001246:	ef0080e7          	jalr	-272(ra) # 80001132 <freeproc>
    release(&p->lock);
    8000124a:	8526                	mv	a0,s1
    8000124c:	00005097          	auipc	ra,0x5
    80001250:	fe0080e7          	jalr	-32(ra) # 8000622c <release>
    return 0;
    80001254:	84ca                	mv	s1,s2
    80001256:	b7d1                	j	8000121a <allocproc+0x90>

0000000080001258 <userinit>:
{
    80001258:	1101                	addi	sp,sp,-32
    8000125a:	ec06                	sd	ra,24(sp)
    8000125c:	e822                	sd	s0,16(sp)
    8000125e:	e426                	sd	s1,8(sp)
    80001260:	1000                	addi	s0,sp,32
  p = allocproc();
    80001262:	00000097          	auipc	ra,0x0
    80001266:	f28080e7          	jalr	-216(ra) # 8000118a <allocproc>
    8000126a:	84aa                	mv	s1,a0
  initproc = p;
    8000126c:	00008797          	auipc	a5,0x8
    80001270:	daa7b223          	sd	a0,-604(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001274:	03400613          	li	a2,52
    80001278:	00007597          	auipc	a1,0x7
    8000127c:	5a858593          	addi	a1,a1,1448 # 80008820 <initcode>
    80001280:	6928                	ld	a0,80(a0)
    80001282:	fffff097          	auipc	ra,0xfffff
    80001286:	688080e7          	jalr	1672(ra) # 8000090a <uvminit>
  p->sz = PGSIZE;
    8000128a:	6785                	lui	a5,0x1
    8000128c:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    8000128e:	6cb8                	ld	a4,88(s1)
    80001290:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001294:	6cb8                	ld	a4,88(s1)
    80001296:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001298:	4641                	li	a2,16
    8000129a:	00007597          	auipc	a1,0x7
    8000129e:	ee658593          	addi	a1,a1,-282 # 80008180 <etext+0x180>
    800012a2:	15848513          	addi	a0,s1,344
    800012a6:	fffff097          	auipc	ra,0xfffff
    800012aa:	12e080e7          	jalr	302(ra) # 800003d4 <safestrcpy>
  p->cwd = namei("/");
    800012ae:	00007517          	auipc	a0,0x7
    800012b2:	ee250513          	addi	a0,a0,-286 # 80008190 <etext+0x190>
    800012b6:	00002097          	auipc	ra,0x2
    800012ba:	0d4080e7          	jalr	212(ra) # 8000338a <namei>
    800012be:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800012c2:	478d                	li	a5,3
    800012c4:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800012c6:	8526                	mv	a0,s1
    800012c8:	00005097          	auipc	ra,0x5
    800012cc:	f64080e7          	jalr	-156(ra) # 8000622c <release>
}
    800012d0:	60e2                	ld	ra,24(sp)
    800012d2:	6442                	ld	s0,16(sp)
    800012d4:	64a2                	ld	s1,8(sp)
    800012d6:	6105                	addi	sp,sp,32
    800012d8:	8082                	ret

00000000800012da <growproc>:
{
    800012da:	1101                	addi	sp,sp,-32
    800012dc:	ec06                	sd	ra,24(sp)
    800012de:	e822                	sd	s0,16(sp)
    800012e0:	e426                	sd	s1,8(sp)
    800012e2:	e04a                	sd	s2,0(sp)
    800012e4:	1000                	addi	s0,sp,32
    800012e6:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800012e8:	00000097          	auipc	ra,0x0
    800012ec:	c98080e7          	jalr	-872(ra) # 80000f80 <myproc>
    800012f0:	892a                	mv	s2,a0
  sz = p->sz;
    800012f2:	652c                	ld	a1,72(a0)
    800012f4:	0005879b          	sext.w	a5,a1
  if(n > 0){
    800012f8:	00904f63          	bgtz	s1,80001316 <growproc+0x3c>
  } else if(n < 0){
    800012fc:	0204cd63          	bltz	s1,80001336 <growproc+0x5c>
  p->sz = sz;
    80001300:	1782                	slli	a5,a5,0x20
    80001302:	9381                	srli	a5,a5,0x20
    80001304:	04f93423          	sd	a5,72(s2)
  return 0;
    80001308:	4501                	li	a0,0
}
    8000130a:	60e2                	ld	ra,24(sp)
    8000130c:	6442                	ld	s0,16(sp)
    8000130e:	64a2                	ld	s1,8(sp)
    80001310:	6902                	ld	s2,0(sp)
    80001312:	6105                	addi	sp,sp,32
    80001314:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001316:	00f4863b          	addw	a2,s1,a5
    8000131a:	1602                	slli	a2,a2,0x20
    8000131c:	9201                	srli	a2,a2,0x20
    8000131e:	1582                	slli	a1,a1,0x20
    80001320:	9181                	srli	a1,a1,0x20
    80001322:	6928                	ld	a0,80(a0)
    80001324:	fffff097          	auipc	ra,0xfffff
    80001328:	6a0080e7          	jalr	1696(ra) # 800009c4 <uvmalloc>
    8000132c:	0005079b          	sext.w	a5,a0
    80001330:	fbe1                	bnez	a5,80001300 <growproc+0x26>
      return -1;
    80001332:	557d                	li	a0,-1
    80001334:	bfd9                	j	8000130a <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001336:	00f4863b          	addw	a2,s1,a5
    8000133a:	1602                	slli	a2,a2,0x20
    8000133c:	9201                	srli	a2,a2,0x20
    8000133e:	1582                	slli	a1,a1,0x20
    80001340:	9181                	srli	a1,a1,0x20
    80001342:	6928                	ld	a0,80(a0)
    80001344:	fffff097          	auipc	ra,0xfffff
    80001348:	638080e7          	jalr	1592(ra) # 8000097c <uvmdealloc>
    8000134c:	0005079b          	sext.w	a5,a0
    80001350:	bf45                	j	80001300 <growproc+0x26>

0000000080001352 <fork>:
{
    80001352:	7139                	addi	sp,sp,-64
    80001354:	fc06                	sd	ra,56(sp)
    80001356:	f822                	sd	s0,48(sp)
    80001358:	f426                	sd	s1,40(sp)
    8000135a:	f04a                	sd	s2,32(sp)
    8000135c:	ec4e                	sd	s3,24(sp)
    8000135e:	e852                	sd	s4,16(sp)
    80001360:	e456                	sd	s5,8(sp)
    80001362:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001364:	00000097          	auipc	ra,0x0
    80001368:	c1c080e7          	jalr	-996(ra) # 80000f80 <myproc>
    8000136c:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    8000136e:	00000097          	auipc	ra,0x0
    80001372:	e1c080e7          	jalr	-484(ra) # 8000118a <allocproc>
    80001376:	10050c63          	beqz	a0,8000148e <fork+0x13c>
    8000137a:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000137c:	048ab603          	ld	a2,72(s5)
    80001380:	692c                	ld	a1,80(a0)
    80001382:	050ab503          	ld	a0,80(s5)
    80001386:	fffff097          	auipc	ra,0xfffff
    8000138a:	78e080e7          	jalr	1934(ra) # 80000b14 <uvmcopy>
    8000138e:	04054863          	bltz	a0,800013de <fork+0x8c>
  np->sz = p->sz;
    80001392:	048ab783          	ld	a5,72(s5)
    80001396:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    8000139a:	058ab683          	ld	a3,88(s5)
    8000139e:	87b6                	mv	a5,a3
    800013a0:	058a3703          	ld	a4,88(s4)
    800013a4:	12068693          	addi	a3,a3,288
    800013a8:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800013ac:	6788                	ld	a0,8(a5)
    800013ae:	6b8c                	ld	a1,16(a5)
    800013b0:	6f90                	ld	a2,24(a5)
    800013b2:	01073023          	sd	a6,0(a4)
    800013b6:	e708                	sd	a0,8(a4)
    800013b8:	eb0c                	sd	a1,16(a4)
    800013ba:	ef10                	sd	a2,24(a4)
    800013bc:	02078793          	addi	a5,a5,32
    800013c0:	02070713          	addi	a4,a4,32
    800013c4:	fed792e3          	bne	a5,a3,800013a8 <fork+0x56>
  np->trapframe->a0 = 0;
    800013c8:	058a3783          	ld	a5,88(s4)
    800013cc:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800013d0:	0d0a8493          	addi	s1,s5,208
    800013d4:	0d0a0913          	addi	s2,s4,208
    800013d8:	150a8993          	addi	s3,s5,336
    800013dc:	a00d                	j	800013fe <fork+0xac>
    freeproc(np);
    800013de:	8552                	mv	a0,s4
    800013e0:	00000097          	auipc	ra,0x0
    800013e4:	d52080e7          	jalr	-686(ra) # 80001132 <freeproc>
    release(&np->lock);
    800013e8:	8552                	mv	a0,s4
    800013ea:	00005097          	auipc	ra,0x5
    800013ee:	e42080e7          	jalr	-446(ra) # 8000622c <release>
    return -1;
    800013f2:	597d                	li	s2,-1
    800013f4:	a059                	j	8000147a <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    800013f6:	04a1                	addi	s1,s1,8
    800013f8:	0921                	addi	s2,s2,8
    800013fa:	01348b63          	beq	s1,s3,80001410 <fork+0xbe>
    if(p->ofile[i])
    800013fe:	6088                	ld	a0,0(s1)
    80001400:	d97d                	beqz	a0,800013f6 <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001402:	00002097          	auipc	ra,0x2
    80001406:	61e080e7          	jalr	1566(ra) # 80003a20 <filedup>
    8000140a:	00a93023          	sd	a0,0(s2)
    8000140e:	b7e5                	j	800013f6 <fork+0xa4>
  np->cwd = idup(p->cwd);
    80001410:	150ab503          	ld	a0,336(s5)
    80001414:	00001097          	auipc	ra,0x1
    80001418:	77c080e7          	jalr	1916(ra) # 80002b90 <idup>
    8000141c:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001420:	4641                	li	a2,16
    80001422:	158a8593          	addi	a1,s5,344
    80001426:	158a0513          	addi	a0,s4,344
    8000142a:	fffff097          	auipc	ra,0xfffff
    8000142e:	faa080e7          	jalr	-86(ra) # 800003d4 <safestrcpy>
  pid = np->pid;
    80001432:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001436:	8552                	mv	a0,s4
    80001438:	00005097          	auipc	ra,0x5
    8000143c:	df4080e7          	jalr	-524(ra) # 8000622c <release>
  acquire(&wait_lock);
    80001440:	00028497          	auipc	s1,0x28
    80001444:	c2848493          	addi	s1,s1,-984 # 80029068 <wait_lock>
    80001448:	8526                	mv	a0,s1
    8000144a:	00005097          	auipc	ra,0x5
    8000144e:	d2e080e7          	jalr	-722(ra) # 80006178 <acquire>
  np->parent = p;
    80001452:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001456:	8526                	mv	a0,s1
    80001458:	00005097          	auipc	ra,0x5
    8000145c:	dd4080e7          	jalr	-556(ra) # 8000622c <release>
  acquire(&np->lock);
    80001460:	8552                	mv	a0,s4
    80001462:	00005097          	auipc	ra,0x5
    80001466:	d16080e7          	jalr	-746(ra) # 80006178 <acquire>
  np->state = RUNNABLE;
    8000146a:	478d                	li	a5,3
    8000146c:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001470:	8552                	mv	a0,s4
    80001472:	00005097          	auipc	ra,0x5
    80001476:	dba080e7          	jalr	-582(ra) # 8000622c <release>
}
    8000147a:	854a                	mv	a0,s2
    8000147c:	70e2                	ld	ra,56(sp)
    8000147e:	7442                	ld	s0,48(sp)
    80001480:	74a2                	ld	s1,40(sp)
    80001482:	7902                	ld	s2,32(sp)
    80001484:	69e2                	ld	s3,24(sp)
    80001486:	6a42                	ld	s4,16(sp)
    80001488:	6aa2                	ld	s5,8(sp)
    8000148a:	6121                	addi	sp,sp,64
    8000148c:	8082                	ret
    return -1;
    8000148e:	597d                	li	s2,-1
    80001490:	b7ed                	j	8000147a <fork+0x128>

0000000080001492 <scheduler>:
{
    80001492:	7139                	addi	sp,sp,-64
    80001494:	fc06                	sd	ra,56(sp)
    80001496:	f822                	sd	s0,48(sp)
    80001498:	f426                	sd	s1,40(sp)
    8000149a:	f04a                	sd	s2,32(sp)
    8000149c:	ec4e                	sd	s3,24(sp)
    8000149e:	e852                	sd	s4,16(sp)
    800014a0:	e456                	sd	s5,8(sp)
    800014a2:	e05a                	sd	s6,0(sp)
    800014a4:	0080                	addi	s0,sp,64
    800014a6:	8792                	mv	a5,tp
  int id = r_tp();
    800014a8:	2781                	sext.w	a5,a5
  c->proc = 0;
    800014aa:	00779a93          	slli	s5,a5,0x7
    800014ae:	00028717          	auipc	a4,0x28
    800014b2:	ba270713          	addi	a4,a4,-1118 # 80029050 <pid_lock>
    800014b6:	9756                	add	a4,a4,s5
    800014b8:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800014bc:	00028717          	auipc	a4,0x28
    800014c0:	bcc70713          	addi	a4,a4,-1076 # 80029088 <cpus+0x8>
    800014c4:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800014c6:	498d                	li	s3,3
        p->state = RUNNING;
    800014c8:	4b11                	li	s6,4
        c->proc = p;
    800014ca:	079e                	slli	a5,a5,0x7
    800014cc:	00028a17          	auipc	s4,0x28
    800014d0:	b84a0a13          	addi	s4,s4,-1148 # 80029050 <pid_lock>
    800014d4:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800014d6:	0002e917          	auipc	s2,0x2e
    800014da:	9aa90913          	addi	s2,s2,-1622 # 8002ee80 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800014de:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800014e2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800014e6:	10079073          	csrw	sstatus,a5
    800014ea:	00028497          	auipc	s1,0x28
    800014ee:	f9648493          	addi	s1,s1,-106 # 80029480 <proc>
    800014f2:	a811                	j	80001506 <scheduler+0x74>
      release(&p->lock);
    800014f4:	8526                	mv	a0,s1
    800014f6:	00005097          	auipc	ra,0x5
    800014fa:	d36080e7          	jalr	-714(ra) # 8000622c <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800014fe:	16848493          	addi	s1,s1,360
    80001502:	fd248ee3          	beq	s1,s2,800014de <scheduler+0x4c>
      acquire(&p->lock);
    80001506:	8526                	mv	a0,s1
    80001508:	00005097          	auipc	ra,0x5
    8000150c:	c70080e7          	jalr	-912(ra) # 80006178 <acquire>
      if(p->state == RUNNABLE) {
    80001510:	4c9c                	lw	a5,24(s1)
    80001512:	ff3791e3          	bne	a5,s3,800014f4 <scheduler+0x62>
        p->state = RUNNING;
    80001516:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    8000151a:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000151e:	06048593          	addi	a1,s1,96
    80001522:	8556                	mv	a0,s5
    80001524:	00000097          	auipc	ra,0x0
    80001528:	620080e7          	jalr	1568(ra) # 80001b44 <swtch>
        c->proc = 0;
    8000152c:	020a3823          	sd	zero,48(s4)
    80001530:	b7d1                	j	800014f4 <scheduler+0x62>

0000000080001532 <sched>:
{
    80001532:	7179                	addi	sp,sp,-48
    80001534:	f406                	sd	ra,40(sp)
    80001536:	f022                	sd	s0,32(sp)
    80001538:	ec26                	sd	s1,24(sp)
    8000153a:	e84a                	sd	s2,16(sp)
    8000153c:	e44e                	sd	s3,8(sp)
    8000153e:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001540:	00000097          	auipc	ra,0x0
    80001544:	a40080e7          	jalr	-1472(ra) # 80000f80 <myproc>
    80001548:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000154a:	00005097          	auipc	ra,0x5
    8000154e:	bb4080e7          	jalr	-1100(ra) # 800060fe <holding>
    80001552:	c93d                	beqz	a0,800015c8 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001554:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001556:	2781                	sext.w	a5,a5
    80001558:	079e                	slli	a5,a5,0x7
    8000155a:	00028717          	auipc	a4,0x28
    8000155e:	af670713          	addi	a4,a4,-1290 # 80029050 <pid_lock>
    80001562:	97ba                	add	a5,a5,a4
    80001564:	0a87a703          	lw	a4,168(a5)
    80001568:	4785                	li	a5,1
    8000156a:	06f71763          	bne	a4,a5,800015d8 <sched+0xa6>
  if(p->state == RUNNING)
    8000156e:	4c98                	lw	a4,24(s1)
    80001570:	4791                	li	a5,4
    80001572:	06f70b63          	beq	a4,a5,800015e8 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001576:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000157a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000157c:	efb5                	bnez	a5,800015f8 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000157e:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001580:	00028917          	auipc	s2,0x28
    80001584:	ad090913          	addi	s2,s2,-1328 # 80029050 <pid_lock>
    80001588:	2781                	sext.w	a5,a5
    8000158a:	079e                	slli	a5,a5,0x7
    8000158c:	97ca                	add	a5,a5,s2
    8000158e:	0ac7a983          	lw	s3,172(a5)
    80001592:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001594:	2781                	sext.w	a5,a5
    80001596:	079e                	slli	a5,a5,0x7
    80001598:	00028597          	auipc	a1,0x28
    8000159c:	af058593          	addi	a1,a1,-1296 # 80029088 <cpus+0x8>
    800015a0:	95be                	add	a1,a1,a5
    800015a2:	06048513          	addi	a0,s1,96
    800015a6:	00000097          	auipc	ra,0x0
    800015aa:	59e080e7          	jalr	1438(ra) # 80001b44 <swtch>
    800015ae:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800015b0:	2781                	sext.w	a5,a5
    800015b2:	079e                	slli	a5,a5,0x7
    800015b4:	993e                	add	s2,s2,a5
    800015b6:	0b392623          	sw	s3,172(s2)
}
    800015ba:	70a2                	ld	ra,40(sp)
    800015bc:	7402                	ld	s0,32(sp)
    800015be:	64e2                	ld	s1,24(sp)
    800015c0:	6942                	ld	s2,16(sp)
    800015c2:	69a2                	ld	s3,8(sp)
    800015c4:	6145                	addi	sp,sp,48
    800015c6:	8082                	ret
    panic("sched p->lock");
    800015c8:	00007517          	auipc	a0,0x7
    800015cc:	bd050513          	addi	a0,a0,-1072 # 80008198 <etext+0x198>
    800015d0:	00004097          	auipc	ra,0x4
    800015d4:	670080e7          	jalr	1648(ra) # 80005c40 <panic>
    panic("sched locks");
    800015d8:	00007517          	auipc	a0,0x7
    800015dc:	bd050513          	addi	a0,a0,-1072 # 800081a8 <etext+0x1a8>
    800015e0:	00004097          	auipc	ra,0x4
    800015e4:	660080e7          	jalr	1632(ra) # 80005c40 <panic>
    panic("sched running");
    800015e8:	00007517          	auipc	a0,0x7
    800015ec:	bd050513          	addi	a0,a0,-1072 # 800081b8 <etext+0x1b8>
    800015f0:	00004097          	auipc	ra,0x4
    800015f4:	650080e7          	jalr	1616(ra) # 80005c40 <panic>
    panic("sched interruptible");
    800015f8:	00007517          	auipc	a0,0x7
    800015fc:	bd050513          	addi	a0,a0,-1072 # 800081c8 <etext+0x1c8>
    80001600:	00004097          	auipc	ra,0x4
    80001604:	640080e7          	jalr	1600(ra) # 80005c40 <panic>

0000000080001608 <yield>:
{
    80001608:	1101                	addi	sp,sp,-32
    8000160a:	ec06                	sd	ra,24(sp)
    8000160c:	e822                	sd	s0,16(sp)
    8000160e:	e426                	sd	s1,8(sp)
    80001610:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001612:	00000097          	auipc	ra,0x0
    80001616:	96e080e7          	jalr	-1682(ra) # 80000f80 <myproc>
    8000161a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000161c:	00005097          	auipc	ra,0x5
    80001620:	b5c080e7          	jalr	-1188(ra) # 80006178 <acquire>
  p->state = RUNNABLE;
    80001624:	478d                	li	a5,3
    80001626:	cc9c                	sw	a5,24(s1)
  sched();
    80001628:	00000097          	auipc	ra,0x0
    8000162c:	f0a080e7          	jalr	-246(ra) # 80001532 <sched>
  release(&p->lock);
    80001630:	8526                	mv	a0,s1
    80001632:	00005097          	auipc	ra,0x5
    80001636:	bfa080e7          	jalr	-1030(ra) # 8000622c <release>
}
    8000163a:	60e2                	ld	ra,24(sp)
    8000163c:	6442                	ld	s0,16(sp)
    8000163e:	64a2                	ld	s1,8(sp)
    80001640:	6105                	addi	sp,sp,32
    80001642:	8082                	ret

0000000080001644 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001644:	7179                	addi	sp,sp,-48
    80001646:	f406                	sd	ra,40(sp)
    80001648:	f022                	sd	s0,32(sp)
    8000164a:	ec26                	sd	s1,24(sp)
    8000164c:	e84a                	sd	s2,16(sp)
    8000164e:	e44e                	sd	s3,8(sp)
    80001650:	1800                	addi	s0,sp,48
    80001652:	89aa                	mv	s3,a0
    80001654:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001656:	00000097          	auipc	ra,0x0
    8000165a:	92a080e7          	jalr	-1750(ra) # 80000f80 <myproc>
    8000165e:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001660:	00005097          	auipc	ra,0x5
    80001664:	b18080e7          	jalr	-1256(ra) # 80006178 <acquire>
  release(lk);
    80001668:	854a                	mv	a0,s2
    8000166a:	00005097          	auipc	ra,0x5
    8000166e:	bc2080e7          	jalr	-1086(ra) # 8000622c <release>

  // Go to sleep.
  p->chan = chan;
    80001672:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001676:	4789                	li	a5,2
    80001678:	cc9c                	sw	a5,24(s1)

  sched();
    8000167a:	00000097          	auipc	ra,0x0
    8000167e:	eb8080e7          	jalr	-328(ra) # 80001532 <sched>

  // Tidy up.
  p->chan = 0;
    80001682:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001686:	8526                	mv	a0,s1
    80001688:	00005097          	auipc	ra,0x5
    8000168c:	ba4080e7          	jalr	-1116(ra) # 8000622c <release>
  acquire(lk);
    80001690:	854a                	mv	a0,s2
    80001692:	00005097          	auipc	ra,0x5
    80001696:	ae6080e7          	jalr	-1306(ra) # 80006178 <acquire>
}
    8000169a:	70a2                	ld	ra,40(sp)
    8000169c:	7402                	ld	s0,32(sp)
    8000169e:	64e2                	ld	s1,24(sp)
    800016a0:	6942                	ld	s2,16(sp)
    800016a2:	69a2                	ld	s3,8(sp)
    800016a4:	6145                	addi	sp,sp,48
    800016a6:	8082                	ret

00000000800016a8 <wait>:
{
    800016a8:	715d                	addi	sp,sp,-80
    800016aa:	e486                	sd	ra,72(sp)
    800016ac:	e0a2                	sd	s0,64(sp)
    800016ae:	fc26                	sd	s1,56(sp)
    800016b0:	f84a                	sd	s2,48(sp)
    800016b2:	f44e                	sd	s3,40(sp)
    800016b4:	f052                	sd	s4,32(sp)
    800016b6:	ec56                	sd	s5,24(sp)
    800016b8:	e85a                	sd	s6,16(sp)
    800016ba:	e45e                	sd	s7,8(sp)
    800016bc:	e062                	sd	s8,0(sp)
    800016be:	0880                	addi	s0,sp,80
    800016c0:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800016c2:	00000097          	auipc	ra,0x0
    800016c6:	8be080e7          	jalr	-1858(ra) # 80000f80 <myproc>
    800016ca:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800016cc:	00028517          	auipc	a0,0x28
    800016d0:	99c50513          	addi	a0,a0,-1636 # 80029068 <wait_lock>
    800016d4:	00005097          	auipc	ra,0x5
    800016d8:	aa4080e7          	jalr	-1372(ra) # 80006178 <acquire>
    havekids = 0;
    800016dc:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800016de:	4a15                	li	s4,5
        havekids = 1;
    800016e0:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    800016e2:	0002d997          	auipc	s3,0x2d
    800016e6:	79e98993          	addi	s3,s3,1950 # 8002ee80 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016ea:	00028c17          	auipc	s8,0x28
    800016ee:	97ec0c13          	addi	s8,s8,-1666 # 80029068 <wait_lock>
    havekids = 0;
    800016f2:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800016f4:	00028497          	auipc	s1,0x28
    800016f8:	d8c48493          	addi	s1,s1,-628 # 80029480 <proc>
    800016fc:	a0bd                	j	8000176a <wait+0xc2>
          pid = np->pid;
    800016fe:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80001702:	000b0e63          	beqz	s6,8000171e <wait+0x76>
    80001706:	4691                	li	a3,4
    80001708:	02c48613          	addi	a2,s1,44
    8000170c:	85da                	mv	a1,s6
    8000170e:	05093503          	ld	a0,80(s2)
    80001712:	fffff097          	auipc	ra,0xfffff
    80001716:	502080e7          	jalr	1282(ra) # 80000c14 <copyout>
    8000171a:	02054563          	bltz	a0,80001744 <wait+0x9c>
          freeproc(np);
    8000171e:	8526                	mv	a0,s1
    80001720:	00000097          	auipc	ra,0x0
    80001724:	a12080e7          	jalr	-1518(ra) # 80001132 <freeproc>
          release(&np->lock);
    80001728:	8526                	mv	a0,s1
    8000172a:	00005097          	auipc	ra,0x5
    8000172e:	b02080e7          	jalr	-1278(ra) # 8000622c <release>
          release(&wait_lock);
    80001732:	00028517          	auipc	a0,0x28
    80001736:	93650513          	addi	a0,a0,-1738 # 80029068 <wait_lock>
    8000173a:	00005097          	auipc	ra,0x5
    8000173e:	af2080e7          	jalr	-1294(ra) # 8000622c <release>
          return pid;
    80001742:	a09d                	j	800017a8 <wait+0x100>
            release(&np->lock);
    80001744:	8526                	mv	a0,s1
    80001746:	00005097          	auipc	ra,0x5
    8000174a:	ae6080e7          	jalr	-1306(ra) # 8000622c <release>
            release(&wait_lock);
    8000174e:	00028517          	auipc	a0,0x28
    80001752:	91a50513          	addi	a0,a0,-1766 # 80029068 <wait_lock>
    80001756:	00005097          	auipc	ra,0x5
    8000175a:	ad6080e7          	jalr	-1322(ra) # 8000622c <release>
            return -1;
    8000175e:	59fd                	li	s3,-1
    80001760:	a0a1                	j	800017a8 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    80001762:	16848493          	addi	s1,s1,360
    80001766:	03348463          	beq	s1,s3,8000178e <wait+0xe6>
      if(np->parent == p){
    8000176a:	7c9c                	ld	a5,56(s1)
    8000176c:	ff279be3          	bne	a5,s2,80001762 <wait+0xba>
        acquire(&np->lock);
    80001770:	8526                	mv	a0,s1
    80001772:	00005097          	auipc	ra,0x5
    80001776:	a06080e7          	jalr	-1530(ra) # 80006178 <acquire>
        if(np->state == ZOMBIE){
    8000177a:	4c9c                	lw	a5,24(s1)
    8000177c:	f94781e3          	beq	a5,s4,800016fe <wait+0x56>
        release(&np->lock);
    80001780:	8526                	mv	a0,s1
    80001782:	00005097          	auipc	ra,0x5
    80001786:	aaa080e7          	jalr	-1366(ra) # 8000622c <release>
        havekids = 1;
    8000178a:	8756                	mv	a4,s5
    8000178c:	bfd9                	j	80001762 <wait+0xba>
    if(!havekids || p->killed){
    8000178e:	c701                	beqz	a4,80001796 <wait+0xee>
    80001790:	02892783          	lw	a5,40(s2)
    80001794:	c79d                	beqz	a5,800017c2 <wait+0x11a>
      release(&wait_lock);
    80001796:	00028517          	auipc	a0,0x28
    8000179a:	8d250513          	addi	a0,a0,-1838 # 80029068 <wait_lock>
    8000179e:	00005097          	auipc	ra,0x5
    800017a2:	a8e080e7          	jalr	-1394(ra) # 8000622c <release>
      return -1;
    800017a6:	59fd                	li	s3,-1
}
    800017a8:	854e                	mv	a0,s3
    800017aa:	60a6                	ld	ra,72(sp)
    800017ac:	6406                	ld	s0,64(sp)
    800017ae:	74e2                	ld	s1,56(sp)
    800017b0:	7942                	ld	s2,48(sp)
    800017b2:	79a2                	ld	s3,40(sp)
    800017b4:	7a02                	ld	s4,32(sp)
    800017b6:	6ae2                	ld	s5,24(sp)
    800017b8:	6b42                	ld	s6,16(sp)
    800017ba:	6ba2                	ld	s7,8(sp)
    800017bc:	6c02                	ld	s8,0(sp)
    800017be:	6161                	addi	sp,sp,80
    800017c0:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800017c2:	85e2                	mv	a1,s8
    800017c4:	854a                	mv	a0,s2
    800017c6:	00000097          	auipc	ra,0x0
    800017ca:	e7e080e7          	jalr	-386(ra) # 80001644 <sleep>
    havekids = 0;
    800017ce:	b715                	j	800016f2 <wait+0x4a>

00000000800017d0 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800017d0:	7139                	addi	sp,sp,-64
    800017d2:	fc06                	sd	ra,56(sp)
    800017d4:	f822                	sd	s0,48(sp)
    800017d6:	f426                	sd	s1,40(sp)
    800017d8:	f04a                	sd	s2,32(sp)
    800017da:	ec4e                	sd	s3,24(sp)
    800017dc:	e852                	sd	s4,16(sp)
    800017de:	e456                	sd	s5,8(sp)
    800017e0:	0080                	addi	s0,sp,64
    800017e2:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800017e4:	00028497          	auipc	s1,0x28
    800017e8:	c9c48493          	addi	s1,s1,-868 # 80029480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800017ec:	4989                	li	s3,2
        p->state = RUNNABLE;
    800017ee:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800017f0:	0002d917          	auipc	s2,0x2d
    800017f4:	69090913          	addi	s2,s2,1680 # 8002ee80 <tickslock>
    800017f8:	a811                	j	8000180c <wakeup+0x3c>
      }
      release(&p->lock);
    800017fa:	8526                	mv	a0,s1
    800017fc:	00005097          	auipc	ra,0x5
    80001800:	a30080e7          	jalr	-1488(ra) # 8000622c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001804:	16848493          	addi	s1,s1,360
    80001808:	03248663          	beq	s1,s2,80001834 <wakeup+0x64>
    if(p != myproc()){
    8000180c:	fffff097          	auipc	ra,0xfffff
    80001810:	774080e7          	jalr	1908(ra) # 80000f80 <myproc>
    80001814:	fea488e3          	beq	s1,a0,80001804 <wakeup+0x34>
      acquire(&p->lock);
    80001818:	8526                	mv	a0,s1
    8000181a:	00005097          	auipc	ra,0x5
    8000181e:	95e080e7          	jalr	-1698(ra) # 80006178 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001822:	4c9c                	lw	a5,24(s1)
    80001824:	fd379be3          	bne	a5,s3,800017fa <wakeup+0x2a>
    80001828:	709c                	ld	a5,32(s1)
    8000182a:	fd4798e3          	bne	a5,s4,800017fa <wakeup+0x2a>
        p->state = RUNNABLE;
    8000182e:	0154ac23          	sw	s5,24(s1)
    80001832:	b7e1                	j	800017fa <wakeup+0x2a>
    }
  }
}
    80001834:	70e2                	ld	ra,56(sp)
    80001836:	7442                	ld	s0,48(sp)
    80001838:	74a2                	ld	s1,40(sp)
    8000183a:	7902                	ld	s2,32(sp)
    8000183c:	69e2                	ld	s3,24(sp)
    8000183e:	6a42                	ld	s4,16(sp)
    80001840:	6aa2                	ld	s5,8(sp)
    80001842:	6121                	addi	sp,sp,64
    80001844:	8082                	ret

0000000080001846 <reparent>:
{
    80001846:	7179                	addi	sp,sp,-48
    80001848:	f406                	sd	ra,40(sp)
    8000184a:	f022                	sd	s0,32(sp)
    8000184c:	ec26                	sd	s1,24(sp)
    8000184e:	e84a                	sd	s2,16(sp)
    80001850:	e44e                	sd	s3,8(sp)
    80001852:	e052                	sd	s4,0(sp)
    80001854:	1800                	addi	s0,sp,48
    80001856:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001858:	00028497          	auipc	s1,0x28
    8000185c:	c2848493          	addi	s1,s1,-984 # 80029480 <proc>
      pp->parent = initproc;
    80001860:	00007a17          	auipc	s4,0x7
    80001864:	7b0a0a13          	addi	s4,s4,1968 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001868:	0002d997          	auipc	s3,0x2d
    8000186c:	61898993          	addi	s3,s3,1560 # 8002ee80 <tickslock>
    80001870:	a029                	j	8000187a <reparent+0x34>
    80001872:	16848493          	addi	s1,s1,360
    80001876:	01348d63          	beq	s1,s3,80001890 <reparent+0x4a>
    if(pp->parent == p){
    8000187a:	7c9c                	ld	a5,56(s1)
    8000187c:	ff279be3          	bne	a5,s2,80001872 <reparent+0x2c>
      pp->parent = initproc;
    80001880:	000a3503          	ld	a0,0(s4)
    80001884:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001886:	00000097          	auipc	ra,0x0
    8000188a:	f4a080e7          	jalr	-182(ra) # 800017d0 <wakeup>
    8000188e:	b7d5                	j	80001872 <reparent+0x2c>
}
    80001890:	70a2                	ld	ra,40(sp)
    80001892:	7402                	ld	s0,32(sp)
    80001894:	64e2                	ld	s1,24(sp)
    80001896:	6942                	ld	s2,16(sp)
    80001898:	69a2                	ld	s3,8(sp)
    8000189a:	6a02                	ld	s4,0(sp)
    8000189c:	6145                	addi	sp,sp,48
    8000189e:	8082                	ret

00000000800018a0 <exit>:
{
    800018a0:	7179                	addi	sp,sp,-48
    800018a2:	f406                	sd	ra,40(sp)
    800018a4:	f022                	sd	s0,32(sp)
    800018a6:	ec26                	sd	s1,24(sp)
    800018a8:	e84a                	sd	s2,16(sp)
    800018aa:	e44e                	sd	s3,8(sp)
    800018ac:	e052                	sd	s4,0(sp)
    800018ae:	1800                	addi	s0,sp,48
    800018b0:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800018b2:	fffff097          	auipc	ra,0xfffff
    800018b6:	6ce080e7          	jalr	1742(ra) # 80000f80 <myproc>
    800018ba:	89aa                	mv	s3,a0
  if(p == initproc)
    800018bc:	00007797          	auipc	a5,0x7
    800018c0:	7547b783          	ld	a5,1876(a5) # 80009010 <initproc>
    800018c4:	0d050493          	addi	s1,a0,208
    800018c8:	15050913          	addi	s2,a0,336
    800018cc:	02a79363          	bne	a5,a0,800018f2 <exit+0x52>
    panic("init exiting");
    800018d0:	00007517          	auipc	a0,0x7
    800018d4:	91050513          	addi	a0,a0,-1776 # 800081e0 <etext+0x1e0>
    800018d8:	00004097          	auipc	ra,0x4
    800018dc:	368080e7          	jalr	872(ra) # 80005c40 <panic>
      fileclose(f);
    800018e0:	00002097          	auipc	ra,0x2
    800018e4:	192080e7          	jalr	402(ra) # 80003a72 <fileclose>
      p->ofile[fd] = 0;
    800018e8:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800018ec:	04a1                	addi	s1,s1,8
    800018ee:	01248563          	beq	s1,s2,800018f8 <exit+0x58>
    if(p->ofile[fd]){
    800018f2:	6088                	ld	a0,0(s1)
    800018f4:	f575                	bnez	a0,800018e0 <exit+0x40>
    800018f6:	bfdd                	j	800018ec <exit+0x4c>
  begin_op();
    800018f8:	00002097          	auipc	ra,0x2
    800018fc:	cb2080e7          	jalr	-846(ra) # 800035aa <begin_op>
  iput(p->cwd);
    80001900:	1509b503          	ld	a0,336(s3)
    80001904:	00001097          	auipc	ra,0x1
    80001908:	484080e7          	jalr	1156(ra) # 80002d88 <iput>
  end_op();
    8000190c:	00002097          	auipc	ra,0x2
    80001910:	d1c080e7          	jalr	-740(ra) # 80003628 <end_op>
  p->cwd = 0;
    80001914:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001918:	00027497          	auipc	s1,0x27
    8000191c:	75048493          	addi	s1,s1,1872 # 80029068 <wait_lock>
    80001920:	8526                	mv	a0,s1
    80001922:	00005097          	auipc	ra,0x5
    80001926:	856080e7          	jalr	-1962(ra) # 80006178 <acquire>
  reparent(p);
    8000192a:	854e                	mv	a0,s3
    8000192c:	00000097          	auipc	ra,0x0
    80001930:	f1a080e7          	jalr	-230(ra) # 80001846 <reparent>
  wakeup(p->parent);
    80001934:	0389b503          	ld	a0,56(s3)
    80001938:	00000097          	auipc	ra,0x0
    8000193c:	e98080e7          	jalr	-360(ra) # 800017d0 <wakeup>
  acquire(&p->lock);
    80001940:	854e                	mv	a0,s3
    80001942:	00005097          	auipc	ra,0x5
    80001946:	836080e7          	jalr	-1994(ra) # 80006178 <acquire>
  p->xstate = status;
    8000194a:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000194e:	4795                	li	a5,5
    80001950:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001954:	8526                	mv	a0,s1
    80001956:	00005097          	auipc	ra,0x5
    8000195a:	8d6080e7          	jalr	-1834(ra) # 8000622c <release>
  sched();
    8000195e:	00000097          	auipc	ra,0x0
    80001962:	bd4080e7          	jalr	-1068(ra) # 80001532 <sched>
  panic("zombie exit");
    80001966:	00007517          	auipc	a0,0x7
    8000196a:	88a50513          	addi	a0,a0,-1910 # 800081f0 <etext+0x1f0>
    8000196e:	00004097          	auipc	ra,0x4
    80001972:	2d2080e7          	jalr	722(ra) # 80005c40 <panic>

0000000080001976 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001976:	7179                	addi	sp,sp,-48
    80001978:	f406                	sd	ra,40(sp)
    8000197a:	f022                	sd	s0,32(sp)
    8000197c:	ec26                	sd	s1,24(sp)
    8000197e:	e84a                	sd	s2,16(sp)
    80001980:	e44e                	sd	s3,8(sp)
    80001982:	1800                	addi	s0,sp,48
    80001984:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001986:	00028497          	auipc	s1,0x28
    8000198a:	afa48493          	addi	s1,s1,-1286 # 80029480 <proc>
    8000198e:	0002d997          	auipc	s3,0x2d
    80001992:	4f298993          	addi	s3,s3,1266 # 8002ee80 <tickslock>
    acquire(&p->lock);
    80001996:	8526                	mv	a0,s1
    80001998:	00004097          	auipc	ra,0x4
    8000199c:	7e0080e7          	jalr	2016(ra) # 80006178 <acquire>
    if(p->pid == pid){
    800019a0:	589c                	lw	a5,48(s1)
    800019a2:	01278d63          	beq	a5,s2,800019bc <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800019a6:	8526                	mv	a0,s1
    800019a8:	00005097          	auipc	ra,0x5
    800019ac:	884080e7          	jalr	-1916(ra) # 8000622c <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800019b0:	16848493          	addi	s1,s1,360
    800019b4:	ff3491e3          	bne	s1,s3,80001996 <kill+0x20>
  }
  return -1;
    800019b8:	557d                	li	a0,-1
    800019ba:	a829                	j	800019d4 <kill+0x5e>
      p->killed = 1;
    800019bc:	4785                	li	a5,1
    800019be:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800019c0:	4c98                	lw	a4,24(s1)
    800019c2:	4789                	li	a5,2
    800019c4:	00f70f63          	beq	a4,a5,800019e2 <kill+0x6c>
      release(&p->lock);
    800019c8:	8526                	mv	a0,s1
    800019ca:	00005097          	auipc	ra,0x5
    800019ce:	862080e7          	jalr	-1950(ra) # 8000622c <release>
      return 0;
    800019d2:	4501                	li	a0,0
}
    800019d4:	70a2                	ld	ra,40(sp)
    800019d6:	7402                	ld	s0,32(sp)
    800019d8:	64e2                	ld	s1,24(sp)
    800019da:	6942                	ld	s2,16(sp)
    800019dc:	69a2                	ld	s3,8(sp)
    800019de:	6145                	addi	sp,sp,48
    800019e0:	8082                	ret
        p->state = RUNNABLE;
    800019e2:	478d                	li	a5,3
    800019e4:	cc9c                	sw	a5,24(s1)
    800019e6:	b7cd                	j	800019c8 <kill+0x52>

00000000800019e8 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800019e8:	7179                	addi	sp,sp,-48
    800019ea:	f406                	sd	ra,40(sp)
    800019ec:	f022                	sd	s0,32(sp)
    800019ee:	ec26                	sd	s1,24(sp)
    800019f0:	e84a                	sd	s2,16(sp)
    800019f2:	e44e                	sd	s3,8(sp)
    800019f4:	e052                	sd	s4,0(sp)
    800019f6:	1800                	addi	s0,sp,48
    800019f8:	84aa                	mv	s1,a0
    800019fa:	892e                	mv	s2,a1
    800019fc:	89b2                	mv	s3,a2
    800019fe:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a00:	fffff097          	auipc	ra,0xfffff
    80001a04:	580080e7          	jalr	1408(ra) # 80000f80 <myproc>
  if(user_dst){
    80001a08:	c08d                	beqz	s1,80001a2a <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001a0a:	86d2                	mv	a3,s4
    80001a0c:	864e                	mv	a2,s3
    80001a0e:	85ca                	mv	a1,s2
    80001a10:	6928                	ld	a0,80(a0)
    80001a12:	fffff097          	auipc	ra,0xfffff
    80001a16:	202080e7          	jalr	514(ra) # 80000c14 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001a1a:	70a2                	ld	ra,40(sp)
    80001a1c:	7402                	ld	s0,32(sp)
    80001a1e:	64e2                	ld	s1,24(sp)
    80001a20:	6942                	ld	s2,16(sp)
    80001a22:	69a2                	ld	s3,8(sp)
    80001a24:	6a02                	ld	s4,0(sp)
    80001a26:	6145                	addi	sp,sp,48
    80001a28:	8082                	ret
    memmove((char *)dst, src, len);
    80001a2a:	000a061b          	sext.w	a2,s4
    80001a2e:	85ce                	mv	a1,s3
    80001a30:	854a                	mv	a0,s2
    80001a32:	fffff097          	auipc	ra,0xfffff
    80001a36:	8b4080e7          	jalr	-1868(ra) # 800002e6 <memmove>
    return 0;
    80001a3a:	8526                	mv	a0,s1
    80001a3c:	bff9                	j	80001a1a <either_copyout+0x32>

0000000080001a3e <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001a3e:	7179                	addi	sp,sp,-48
    80001a40:	f406                	sd	ra,40(sp)
    80001a42:	f022                	sd	s0,32(sp)
    80001a44:	ec26                	sd	s1,24(sp)
    80001a46:	e84a                	sd	s2,16(sp)
    80001a48:	e44e                	sd	s3,8(sp)
    80001a4a:	e052                	sd	s4,0(sp)
    80001a4c:	1800                	addi	s0,sp,48
    80001a4e:	892a                	mv	s2,a0
    80001a50:	84ae                	mv	s1,a1
    80001a52:	89b2                	mv	s3,a2
    80001a54:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a56:	fffff097          	auipc	ra,0xfffff
    80001a5a:	52a080e7          	jalr	1322(ra) # 80000f80 <myproc>
  if(user_src){
    80001a5e:	c08d                	beqz	s1,80001a80 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001a60:	86d2                	mv	a3,s4
    80001a62:	864e                	mv	a2,s3
    80001a64:	85ca                	mv	a1,s2
    80001a66:	6928                	ld	a0,80(a0)
    80001a68:	fffff097          	auipc	ra,0xfffff
    80001a6c:	268080e7          	jalr	616(ra) # 80000cd0 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001a70:	70a2                	ld	ra,40(sp)
    80001a72:	7402                	ld	s0,32(sp)
    80001a74:	64e2                	ld	s1,24(sp)
    80001a76:	6942                	ld	s2,16(sp)
    80001a78:	69a2                	ld	s3,8(sp)
    80001a7a:	6a02                	ld	s4,0(sp)
    80001a7c:	6145                	addi	sp,sp,48
    80001a7e:	8082                	ret
    memmove(dst, (char*)src, len);
    80001a80:	000a061b          	sext.w	a2,s4
    80001a84:	85ce                	mv	a1,s3
    80001a86:	854a                	mv	a0,s2
    80001a88:	fffff097          	auipc	ra,0xfffff
    80001a8c:	85e080e7          	jalr	-1954(ra) # 800002e6 <memmove>
    return 0;
    80001a90:	8526                	mv	a0,s1
    80001a92:	bff9                	j	80001a70 <either_copyin+0x32>

0000000080001a94 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001a94:	715d                	addi	sp,sp,-80
    80001a96:	e486                	sd	ra,72(sp)
    80001a98:	e0a2                	sd	s0,64(sp)
    80001a9a:	fc26                	sd	s1,56(sp)
    80001a9c:	f84a                	sd	s2,48(sp)
    80001a9e:	f44e                	sd	s3,40(sp)
    80001aa0:	f052                	sd	s4,32(sp)
    80001aa2:	ec56                	sd	s5,24(sp)
    80001aa4:	e85a                	sd	s6,16(sp)
    80001aa6:	e45e                	sd	s7,8(sp)
    80001aa8:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001aaa:	00006517          	auipc	a0,0x6
    80001aae:	59e50513          	addi	a0,a0,1438 # 80008048 <etext+0x48>
    80001ab2:	00004097          	auipc	ra,0x4
    80001ab6:	1d8080e7          	jalr	472(ra) # 80005c8a <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001aba:	00028497          	auipc	s1,0x28
    80001abe:	b1e48493          	addi	s1,s1,-1250 # 800295d8 <proc+0x158>
    80001ac2:	0002d917          	auipc	s2,0x2d
    80001ac6:	51690913          	addi	s2,s2,1302 # 8002efd8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001aca:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001acc:	00006997          	auipc	s3,0x6
    80001ad0:	73498993          	addi	s3,s3,1844 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    80001ad4:	00006a97          	auipc	s5,0x6
    80001ad8:	734a8a93          	addi	s5,s5,1844 # 80008208 <etext+0x208>
    printf("\n");
    80001adc:	00006a17          	auipc	s4,0x6
    80001ae0:	56ca0a13          	addi	s4,s4,1388 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001ae4:	00006b97          	auipc	s7,0x6
    80001ae8:	75cb8b93          	addi	s7,s7,1884 # 80008240 <states.0>
    80001aec:	a00d                	j	80001b0e <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001aee:	ed86a583          	lw	a1,-296(a3)
    80001af2:	8556                	mv	a0,s5
    80001af4:	00004097          	auipc	ra,0x4
    80001af8:	196080e7          	jalr	406(ra) # 80005c8a <printf>
    printf("\n");
    80001afc:	8552                	mv	a0,s4
    80001afe:	00004097          	auipc	ra,0x4
    80001b02:	18c080e7          	jalr	396(ra) # 80005c8a <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b06:	16848493          	addi	s1,s1,360
    80001b0a:	03248263          	beq	s1,s2,80001b2e <procdump+0x9a>
    if(p->state == UNUSED)
    80001b0e:	86a6                	mv	a3,s1
    80001b10:	ec04a783          	lw	a5,-320(s1)
    80001b14:	dbed                	beqz	a5,80001b06 <procdump+0x72>
      state = "???";
    80001b16:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b18:	fcfb6be3          	bltu	s6,a5,80001aee <procdump+0x5a>
    80001b1c:	02079713          	slli	a4,a5,0x20
    80001b20:	01d75793          	srli	a5,a4,0x1d
    80001b24:	97de                	add	a5,a5,s7
    80001b26:	6390                	ld	a2,0(a5)
    80001b28:	f279                	bnez	a2,80001aee <procdump+0x5a>
      state = "???";
    80001b2a:	864e                	mv	a2,s3
    80001b2c:	b7c9                	j	80001aee <procdump+0x5a>
  }
}
    80001b2e:	60a6                	ld	ra,72(sp)
    80001b30:	6406                	ld	s0,64(sp)
    80001b32:	74e2                	ld	s1,56(sp)
    80001b34:	7942                	ld	s2,48(sp)
    80001b36:	79a2                	ld	s3,40(sp)
    80001b38:	7a02                	ld	s4,32(sp)
    80001b3a:	6ae2                	ld	s5,24(sp)
    80001b3c:	6b42                	ld	s6,16(sp)
    80001b3e:	6ba2                	ld	s7,8(sp)
    80001b40:	6161                	addi	sp,sp,80
    80001b42:	8082                	ret

0000000080001b44 <swtch>:
    80001b44:	00153023          	sd	ra,0(a0)
    80001b48:	00253423          	sd	sp,8(a0)
    80001b4c:	e900                	sd	s0,16(a0)
    80001b4e:	ed04                	sd	s1,24(a0)
    80001b50:	03253023          	sd	s2,32(a0)
    80001b54:	03353423          	sd	s3,40(a0)
    80001b58:	03453823          	sd	s4,48(a0)
    80001b5c:	03553c23          	sd	s5,56(a0)
    80001b60:	05653023          	sd	s6,64(a0)
    80001b64:	05753423          	sd	s7,72(a0)
    80001b68:	05853823          	sd	s8,80(a0)
    80001b6c:	05953c23          	sd	s9,88(a0)
    80001b70:	07a53023          	sd	s10,96(a0)
    80001b74:	07b53423          	sd	s11,104(a0)
    80001b78:	0005b083          	ld	ra,0(a1)
    80001b7c:	0085b103          	ld	sp,8(a1)
    80001b80:	6980                	ld	s0,16(a1)
    80001b82:	6d84                	ld	s1,24(a1)
    80001b84:	0205b903          	ld	s2,32(a1)
    80001b88:	0285b983          	ld	s3,40(a1)
    80001b8c:	0305ba03          	ld	s4,48(a1)
    80001b90:	0385ba83          	ld	s5,56(a1)
    80001b94:	0405bb03          	ld	s6,64(a1)
    80001b98:	0485bb83          	ld	s7,72(a1)
    80001b9c:	0505bc03          	ld	s8,80(a1)
    80001ba0:	0585bc83          	ld	s9,88(a1)
    80001ba4:	0605bd03          	ld	s10,96(a1)
    80001ba8:	0685bd83          	ld	s11,104(a1)
    80001bac:	8082                	ret

0000000080001bae <trapinit>:
void kernelvec();

extern int devintr();

void trapinit(void)
{
    80001bae:	1141                	addi	sp,sp,-16
    80001bb0:	e406                	sd	ra,8(sp)
    80001bb2:	e022                	sd	s0,0(sp)
    80001bb4:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001bb6:	00006597          	auipc	a1,0x6
    80001bba:	6ba58593          	addi	a1,a1,1722 # 80008270 <states.0+0x30>
    80001bbe:	0002d517          	auipc	a0,0x2d
    80001bc2:	2c250513          	addi	a0,a0,706 # 8002ee80 <tickslock>
    80001bc6:	00004097          	auipc	ra,0x4
    80001bca:	522080e7          	jalr	1314(ra) # 800060e8 <initlock>
}
    80001bce:	60a2                	ld	ra,8(sp)
    80001bd0:	6402                	ld	s0,0(sp)
    80001bd2:	0141                	addi	sp,sp,16
    80001bd4:	8082                	ret

0000000080001bd6 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void)
{
    80001bd6:	1141                	addi	sp,sp,-16
    80001bd8:	e422                	sd	s0,8(sp)
    80001bda:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001bdc:	00003797          	auipc	a5,0x3
    80001be0:	4c478793          	addi	a5,a5,1220 # 800050a0 <kernelvec>
    80001be4:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001be8:	6422                	ld	s0,8(sp)
    80001bea:	0141                	addi	sp,sp,16
    80001bec:	8082                	ret

0000000080001bee <usertrapret>:

//
// return to user space
//
void usertrapret(void)
{
    80001bee:	1141                	addi	sp,sp,-16
    80001bf0:	e406                	sd	ra,8(sp)
    80001bf2:	e022                	sd	s0,0(sp)
    80001bf4:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001bf6:	fffff097          	auipc	ra,0xfffff
    80001bfa:	38a080e7          	jalr	906(ra) # 80000f80 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bfe:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001c02:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c04:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001c08:	00005697          	auipc	a3,0x5
    80001c0c:	3f868693          	addi	a3,a3,1016 # 80007000 <_trampoline>
    80001c10:	00005717          	auipc	a4,0x5
    80001c14:	3f070713          	addi	a4,a4,1008 # 80007000 <_trampoline>
    80001c18:	8f15                	sub	a4,a4,a3
    80001c1a:	040007b7          	lui	a5,0x4000
    80001c1e:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001c20:	07b2                	slli	a5,a5,0xc
    80001c22:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c24:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001c28:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001c2a:	18002673          	csrr	a2,satp
    80001c2e:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001c30:	6d30                	ld	a2,88(a0)
    80001c32:	6138                	ld	a4,64(a0)
    80001c34:	6585                	lui	a1,0x1
    80001c36:	972e                	add	a4,a4,a1
    80001c38:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001c3a:	6d38                	ld	a4,88(a0)
    80001c3c:	00000617          	auipc	a2,0x0
    80001c40:	13860613          	addi	a2,a2,312 # 80001d74 <usertrap>
    80001c44:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80001c46:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001c48:	8612                	mv	a2,tp
    80001c4a:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c4c:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001c50:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001c54:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c58:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001c5c:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001c5e:	6f18                	ld	a4,24(a4)
    80001c60:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001c64:	692c                	ld	a1,80(a0)
    80001c66:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001c68:	00005717          	auipc	a4,0x5
    80001c6c:	42870713          	addi	a4,a4,1064 # 80007090 <userret>
    80001c70:	8f15                	sub	a4,a4,a3
    80001c72:	97ba                	add	a5,a5,a4
  ((void (*)(uint64, uint64))fn)(TRAPFRAME, satp);
    80001c74:	577d                	li	a4,-1
    80001c76:	177e                	slli	a4,a4,0x3f
    80001c78:	8dd9                	or	a1,a1,a4
    80001c7a:	02000537          	lui	a0,0x2000
    80001c7e:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001c80:	0536                	slli	a0,a0,0xd
    80001c82:	9782                	jalr	a5
}
    80001c84:	60a2                	ld	ra,8(sp)
    80001c86:	6402                	ld	s0,0(sp)
    80001c88:	0141                	addi	sp,sp,16
    80001c8a:	8082                	ret

0000000080001c8c <clockintr>:
  w_sepc(sepc);
  w_sstatus(sstatus);
}

void clockintr()
{
    80001c8c:	1101                	addi	sp,sp,-32
    80001c8e:	ec06                	sd	ra,24(sp)
    80001c90:	e822                	sd	s0,16(sp)
    80001c92:	e426                	sd	s1,8(sp)
    80001c94:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001c96:	0002d497          	auipc	s1,0x2d
    80001c9a:	1ea48493          	addi	s1,s1,490 # 8002ee80 <tickslock>
    80001c9e:	8526                	mv	a0,s1
    80001ca0:	00004097          	auipc	ra,0x4
    80001ca4:	4d8080e7          	jalr	1240(ra) # 80006178 <acquire>
  ticks++;
    80001ca8:	00007517          	auipc	a0,0x7
    80001cac:	37050513          	addi	a0,a0,880 # 80009018 <ticks>
    80001cb0:	411c                	lw	a5,0(a0)
    80001cb2:	2785                	addiw	a5,a5,1
    80001cb4:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001cb6:	00000097          	auipc	ra,0x0
    80001cba:	b1a080e7          	jalr	-1254(ra) # 800017d0 <wakeup>
  release(&tickslock);
    80001cbe:	8526                	mv	a0,s1
    80001cc0:	00004097          	auipc	ra,0x4
    80001cc4:	56c080e7          	jalr	1388(ra) # 8000622c <release>
}
    80001cc8:	60e2                	ld	ra,24(sp)
    80001cca:	6442                	ld	s0,16(sp)
    80001ccc:	64a2                	ld	s1,8(sp)
    80001cce:	6105                	addi	sp,sp,32
    80001cd0:	8082                	ret

0000000080001cd2 <devintr>:
// and handle it.
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int devintr()
{
    80001cd2:	1101                	addi	sp,sp,-32
    80001cd4:	ec06                	sd	ra,24(sp)
    80001cd6:	e822                	sd	s0,16(sp)
    80001cd8:	e426                	sd	s1,8(sp)
    80001cda:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cdc:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if ((scause & 0x8000000000000000L) &&
    80001ce0:	00074d63          	bltz	a4,80001cfa <devintr+0x28>
    if (irq)
      plic_complete(irq);

    return 1;
  }
  else if (scause == 0x8000000000000001L)
    80001ce4:	57fd                	li	a5,-1
    80001ce6:	17fe                	slli	a5,a5,0x3f
    80001ce8:	0785                	addi	a5,a5,1

    return 2;
  }
  else
  {
    return 0;
    80001cea:	4501                	li	a0,0
  else if (scause == 0x8000000000000001L)
    80001cec:	06f70363          	beq	a4,a5,80001d52 <devintr+0x80>
  }
}
    80001cf0:	60e2                	ld	ra,24(sp)
    80001cf2:	6442                	ld	s0,16(sp)
    80001cf4:	64a2                	ld	s1,8(sp)
    80001cf6:	6105                	addi	sp,sp,32
    80001cf8:	8082                	ret
      (scause & 0xff) == 9)
    80001cfa:	0ff77793          	zext.b	a5,a4
  if ((scause & 0x8000000000000000L) &&
    80001cfe:	46a5                	li	a3,9
    80001d00:	fed792e3          	bne	a5,a3,80001ce4 <devintr+0x12>
    int irq = plic_claim();
    80001d04:	00003097          	auipc	ra,0x3
    80001d08:	4a4080e7          	jalr	1188(ra) # 800051a8 <plic_claim>
    80001d0c:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ)
    80001d0e:	47a9                	li	a5,10
    80001d10:	02f50763          	beq	a0,a5,80001d3e <devintr+0x6c>
    else if (irq == VIRTIO0_IRQ)
    80001d14:	4785                	li	a5,1
    80001d16:	02f50963          	beq	a0,a5,80001d48 <devintr+0x76>
    return 1;
    80001d1a:	4505                	li	a0,1
    else if (irq)
    80001d1c:	d8f1                	beqz	s1,80001cf0 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001d1e:	85a6                	mv	a1,s1
    80001d20:	00006517          	auipc	a0,0x6
    80001d24:	55850513          	addi	a0,a0,1368 # 80008278 <states.0+0x38>
    80001d28:	00004097          	auipc	ra,0x4
    80001d2c:	f62080e7          	jalr	-158(ra) # 80005c8a <printf>
      plic_complete(irq);
    80001d30:	8526                	mv	a0,s1
    80001d32:	00003097          	auipc	ra,0x3
    80001d36:	49a080e7          	jalr	1178(ra) # 800051cc <plic_complete>
    return 1;
    80001d3a:	4505                	li	a0,1
    80001d3c:	bf55                	j	80001cf0 <devintr+0x1e>
      uartintr();
    80001d3e:	00004097          	auipc	ra,0x4
    80001d42:	35a080e7          	jalr	858(ra) # 80006098 <uartintr>
    80001d46:	b7ed                	j	80001d30 <devintr+0x5e>
      virtio_disk_intr();
    80001d48:	00004097          	auipc	ra,0x4
    80001d4c:	910080e7          	jalr	-1776(ra) # 80005658 <virtio_disk_intr>
    80001d50:	b7c5                	j	80001d30 <devintr+0x5e>
    if (cpuid() == 0)
    80001d52:	fffff097          	auipc	ra,0xfffff
    80001d56:	202080e7          	jalr	514(ra) # 80000f54 <cpuid>
    80001d5a:	c901                	beqz	a0,80001d6a <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001d5c:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001d60:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001d62:	14479073          	csrw	sip,a5
    return 2;
    80001d66:	4509                	li	a0,2
    80001d68:	b761                	j	80001cf0 <devintr+0x1e>
      clockintr();
    80001d6a:	00000097          	auipc	ra,0x0
    80001d6e:	f22080e7          	jalr	-222(ra) # 80001c8c <clockintr>
    80001d72:	b7ed                	j	80001d5c <devintr+0x8a>

0000000080001d74 <usertrap>:
{
    80001d74:	1101                	addi	sp,sp,-32
    80001d76:	ec06                	sd	ra,24(sp)
    80001d78:	e822                	sd	s0,16(sp)
    80001d7a:	e426                	sd	s1,8(sp)
    80001d7c:	e04a                	sd	s2,0(sp)
    80001d7e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d80:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0)
    80001d84:	1007f793          	andi	a5,a5,256
    80001d88:	e7a5                	bnez	a5,80001df0 <usertrap+0x7c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d8a:	00003797          	auipc	a5,0x3
    80001d8e:	31678793          	addi	a5,a5,790 # 800050a0 <kernelvec>
    80001d92:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001d96:	fffff097          	auipc	ra,0xfffff
    80001d9a:	1ea080e7          	jalr	490(ra) # 80000f80 <myproc>
    80001d9e:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001da0:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001da2:	14102773          	csrr	a4,sepc
    80001da6:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001da8:	14202773          	csrr	a4,scause
  if (r_scause() == 8)
    80001dac:	47a1                	li	a5,8
    80001dae:	04f70963          	beq	a4,a5,80001e00 <usertrap+0x8c>
    80001db2:	14202773          	csrr	a4,scause
  else if (r_scause() == 15)
    80001db6:	47bd                	li	a5,15
    80001db8:	08f71563          	bne	a4,a5,80001e42 <usertrap+0xce>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001dbc:	143025f3          	csrr	a1,stval
    if (va >= p->sz)
    80001dc0:	653c                	ld	a5,72(a0)
    80001dc2:	06f5e963          	bltu	a1,a5,80001e34 <usertrap+0xc0>
      p->killed = 1;
    80001dc6:	4785                	li	a5,1
    80001dc8:	d49c                	sw	a5,40(s1)
    80001dca:	4901                	li	s2,0
    exit(-1);
    80001dcc:	557d                	li	a0,-1
    80001dce:	00000097          	auipc	ra,0x0
    80001dd2:	ad2080e7          	jalr	-1326(ra) # 800018a0 <exit>
  if (which_dev == 2)
    80001dd6:	4789                	li	a5,2
    80001dd8:	0af90663          	beq	s2,a5,80001e84 <usertrap+0x110>
  usertrapret();
    80001ddc:	00000097          	auipc	ra,0x0
    80001de0:	e12080e7          	jalr	-494(ra) # 80001bee <usertrapret>
}
    80001de4:	60e2                	ld	ra,24(sp)
    80001de6:	6442                	ld	s0,16(sp)
    80001de8:	64a2                	ld	s1,8(sp)
    80001dea:	6902                	ld	s2,0(sp)
    80001dec:	6105                	addi	sp,sp,32
    80001dee:	8082                	ret
    panic("usertrap: not from user mode");
    80001df0:	00006517          	auipc	a0,0x6
    80001df4:	4a850513          	addi	a0,a0,1192 # 80008298 <states.0+0x58>
    80001df8:	00004097          	auipc	ra,0x4
    80001dfc:	e48080e7          	jalr	-440(ra) # 80005c40 <panic>
    if (p->killed)
    80001e00:	551c                	lw	a5,40(a0)
    80001e02:	e39d                	bnez	a5,80001e28 <usertrap+0xb4>
    p->trapframe->epc += 4;
    80001e04:	6cb8                	ld	a4,88(s1)
    80001e06:	6f1c                	ld	a5,24(a4)
    80001e08:	0791                	addi	a5,a5,4
    80001e0a:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e0c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001e10:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e14:	10079073          	csrw	sstatus,a5
    syscall();
    80001e18:	00000097          	auipc	ra,0x0
    80001e1c:	2b8080e7          	jalr	696(ra) # 800020d0 <syscall>
  if (p->killed)
    80001e20:	549c                	lw	a5,40(s1)
    80001e22:	dfcd                	beqz	a5,80001ddc <usertrap+0x68>
    80001e24:	4901                	li	s2,0
    80001e26:	b75d                	j	80001dcc <usertrap+0x58>
      exit(-1);
    80001e28:	557d                	li	a0,-1
    80001e2a:	00000097          	auipc	ra,0x0
    80001e2e:	a76080e7          	jalr	-1418(ra) # 800018a0 <exit>
    80001e32:	bfc9                	j	80001e04 <usertrap+0x90>
    else if (cow_alloc(p->pagetable, va) != 0)
    80001e34:	6928                	ld	a0,80(a0)
    80001e36:	ffffe097          	auipc	ra,0xffffe
    80001e3a:	39c080e7          	jalr	924(ra) # 800001d2 <cow_alloc>
    80001e3e:	f541                	bnez	a0,80001dc6 <usertrap+0x52>
    80001e40:	b7c5                	j	80001e20 <usertrap+0xac>
  else if ((which_dev = devintr()) != 0)
    80001e42:	00000097          	auipc	ra,0x0
    80001e46:	e90080e7          	jalr	-368(ra) # 80001cd2 <devintr>
    80001e4a:	892a                	mv	s2,a0
    80001e4c:	c501                	beqz	a0,80001e54 <usertrap+0xe0>
  if (p->killed)
    80001e4e:	549c                	lw	a5,40(s1)
    80001e50:	d3d9                	beqz	a5,80001dd6 <usertrap+0x62>
    80001e52:	bfad                	j	80001dcc <usertrap+0x58>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e54:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001e58:	5890                	lw	a2,48(s1)
    80001e5a:	00006517          	auipc	a0,0x6
    80001e5e:	45e50513          	addi	a0,a0,1118 # 800082b8 <states.0+0x78>
    80001e62:	00004097          	auipc	ra,0x4
    80001e66:	e28080e7          	jalr	-472(ra) # 80005c8a <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e6a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e6e:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e72:	00006517          	auipc	a0,0x6
    80001e76:	47650513          	addi	a0,a0,1142 # 800082e8 <states.0+0xa8>
    80001e7a:	00004097          	auipc	ra,0x4
    80001e7e:	e10080e7          	jalr	-496(ra) # 80005c8a <printf>
    p->killed = 1;
    80001e82:	b791                	j	80001dc6 <usertrap+0x52>
    yield();
    80001e84:	fffff097          	auipc	ra,0xfffff
    80001e88:	784080e7          	jalr	1924(ra) # 80001608 <yield>
    80001e8c:	bf81                	j	80001ddc <usertrap+0x68>

0000000080001e8e <kerneltrap>:
{
    80001e8e:	7179                	addi	sp,sp,-48
    80001e90:	f406                	sd	ra,40(sp)
    80001e92:	f022                	sd	s0,32(sp)
    80001e94:	ec26                	sd	s1,24(sp)
    80001e96:	e84a                	sd	s2,16(sp)
    80001e98:	e44e                	sd	s3,8(sp)
    80001e9a:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e9c:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ea0:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ea4:	142029f3          	csrr	s3,scause
  if ((sstatus & SSTATUS_SPP) == 0)
    80001ea8:	1004f793          	andi	a5,s1,256
    80001eac:	cb85                	beqz	a5,80001edc <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001eae:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001eb2:	8b89                	andi	a5,a5,2
  if (intr_get() != 0)
    80001eb4:	ef85                	bnez	a5,80001eec <kerneltrap+0x5e>
  if ((which_dev = devintr()) == 0)
    80001eb6:	00000097          	auipc	ra,0x0
    80001eba:	e1c080e7          	jalr	-484(ra) # 80001cd2 <devintr>
    80001ebe:	cd1d                	beqz	a0,80001efc <kerneltrap+0x6e>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001ec0:	4789                	li	a5,2
    80001ec2:	06f50a63          	beq	a0,a5,80001f36 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001ec6:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001eca:	10049073          	csrw	sstatus,s1
}
    80001ece:	70a2                	ld	ra,40(sp)
    80001ed0:	7402                	ld	s0,32(sp)
    80001ed2:	64e2                	ld	s1,24(sp)
    80001ed4:	6942                	ld	s2,16(sp)
    80001ed6:	69a2                	ld	s3,8(sp)
    80001ed8:	6145                	addi	sp,sp,48
    80001eda:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001edc:	00006517          	auipc	a0,0x6
    80001ee0:	42c50513          	addi	a0,a0,1068 # 80008308 <states.0+0xc8>
    80001ee4:	00004097          	auipc	ra,0x4
    80001ee8:	d5c080e7          	jalr	-676(ra) # 80005c40 <panic>
    panic("kerneltrap: interrupts enabled");
    80001eec:	00006517          	auipc	a0,0x6
    80001ef0:	44450513          	addi	a0,a0,1092 # 80008330 <states.0+0xf0>
    80001ef4:	00004097          	auipc	ra,0x4
    80001ef8:	d4c080e7          	jalr	-692(ra) # 80005c40 <panic>
    printf("scause %p\n", scause);
    80001efc:	85ce                	mv	a1,s3
    80001efe:	00006517          	auipc	a0,0x6
    80001f02:	45250513          	addi	a0,a0,1106 # 80008350 <states.0+0x110>
    80001f06:	00004097          	auipc	ra,0x4
    80001f0a:	d84080e7          	jalr	-636(ra) # 80005c8a <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f0e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f12:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f16:	00006517          	auipc	a0,0x6
    80001f1a:	44a50513          	addi	a0,a0,1098 # 80008360 <states.0+0x120>
    80001f1e:	00004097          	auipc	ra,0x4
    80001f22:	d6c080e7          	jalr	-660(ra) # 80005c8a <printf>
    panic("kerneltrap");
    80001f26:	00006517          	auipc	a0,0x6
    80001f2a:	45250513          	addi	a0,a0,1106 # 80008378 <states.0+0x138>
    80001f2e:	00004097          	auipc	ra,0x4
    80001f32:	d12080e7          	jalr	-750(ra) # 80005c40 <panic>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f36:	fffff097          	auipc	ra,0xfffff
    80001f3a:	04a080e7          	jalr	74(ra) # 80000f80 <myproc>
    80001f3e:	d541                	beqz	a0,80001ec6 <kerneltrap+0x38>
    80001f40:	fffff097          	auipc	ra,0xfffff
    80001f44:	040080e7          	jalr	64(ra) # 80000f80 <myproc>
    80001f48:	4d18                	lw	a4,24(a0)
    80001f4a:	4791                	li	a5,4
    80001f4c:	f6f71de3          	bne	a4,a5,80001ec6 <kerneltrap+0x38>
    yield();
    80001f50:	fffff097          	auipc	ra,0xfffff
    80001f54:	6b8080e7          	jalr	1720(ra) # 80001608 <yield>
    80001f58:	b7bd                	j	80001ec6 <kerneltrap+0x38>

0000000080001f5a <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001f5a:	1101                	addi	sp,sp,-32
    80001f5c:	ec06                	sd	ra,24(sp)
    80001f5e:	e822                	sd	s0,16(sp)
    80001f60:	e426                	sd	s1,8(sp)
    80001f62:	1000                	addi	s0,sp,32
    80001f64:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001f66:	fffff097          	auipc	ra,0xfffff
    80001f6a:	01a080e7          	jalr	26(ra) # 80000f80 <myproc>
  switch (n) {
    80001f6e:	4795                	li	a5,5
    80001f70:	0497e163          	bltu	a5,s1,80001fb2 <argraw+0x58>
    80001f74:	048a                	slli	s1,s1,0x2
    80001f76:	00006717          	auipc	a4,0x6
    80001f7a:	43a70713          	addi	a4,a4,1082 # 800083b0 <states.0+0x170>
    80001f7e:	94ba                	add	s1,s1,a4
    80001f80:	409c                	lw	a5,0(s1)
    80001f82:	97ba                	add	a5,a5,a4
    80001f84:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001f86:	6d3c                	ld	a5,88(a0)
    80001f88:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001f8a:	60e2                	ld	ra,24(sp)
    80001f8c:	6442                	ld	s0,16(sp)
    80001f8e:	64a2                	ld	s1,8(sp)
    80001f90:	6105                	addi	sp,sp,32
    80001f92:	8082                	ret
    return p->trapframe->a1;
    80001f94:	6d3c                	ld	a5,88(a0)
    80001f96:	7fa8                	ld	a0,120(a5)
    80001f98:	bfcd                	j	80001f8a <argraw+0x30>
    return p->trapframe->a2;
    80001f9a:	6d3c                	ld	a5,88(a0)
    80001f9c:	63c8                	ld	a0,128(a5)
    80001f9e:	b7f5                	j	80001f8a <argraw+0x30>
    return p->trapframe->a3;
    80001fa0:	6d3c                	ld	a5,88(a0)
    80001fa2:	67c8                	ld	a0,136(a5)
    80001fa4:	b7dd                	j	80001f8a <argraw+0x30>
    return p->trapframe->a4;
    80001fa6:	6d3c                	ld	a5,88(a0)
    80001fa8:	6bc8                	ld	a0,144(a5)
    80001faa:	b7c5                	j	80001f8a <argraw+0x30>
    return p->trapframe->a5;
    80001fac:	6d3c                	ld	a5,88(a0)
    80001fae:	6fc8                	ld	a0,152(a5)
    80001fb0:	bfe9                	j	80001f8a <argraw+0x30>
  panic("argraw");
    80001fb2:	00006517          	auipc	a0,0x6
    80001fb6:	3d650513          	addi	a0,a0,982 # 80008388 <states.0+0x148>
    80001fba:	00004097          	auipc	ra,0x4
    80001fbe:	c86080e7          	jalr	-890(ra) # 80005c40 <panic>

0000000080001fc2 <fetchaddr>:
{
    80001fc2:	1101                	addi	sp,sp,-32
    80001fc4:	ec06                	sd	ra,24(sp)
    80001fc6:	e822                	sd	s0,16(sp)
    80001fc8:	e426                	sd	s1,8(sp)
    80001fca:	e04a                	sd	s2,0(sp)
    80001fcc:	1000                	addi	s0,sp,32
    80001fce:	84aa                	mv	s1,a0
    80001fd0:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001fd2:	fffff097          	auipc	ra,0xfffff
    80001fd6:	fae080e7          	jalr	-82(ra) # 80000f80 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001fda:	653c                	ld	a5,72(a0)
    80001fdc:	02f4f863          	bgeu	s1,a5,8000200c <fetchaddr+0x4a>
    80001fe0:	00848713          	addi	a4,s1,8
    80001fe4:	02e7e663          	bltu	a5,a4,80002010 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001fe8:	46a1                	li	a3,8
    80001fea:	8626                	mv	a2,s1
    80001fec:	85ca                	mv	a1,s2
    80001fee:	6928                	ld	a0,80(a0)
    80001ff0:	fffff097          	auipc	ra,0xfffff
    80001ff4:	ce0080e7          	jalr	-800(ra) # 80000cd0 <copyin>
    80001ff8:	00a03533          	snez	a0,a0
    80001ffc:	40a00533          	neg	a0,a0
}
    80002000:	60e2                	ld	ra,24(sp)
    80002002:	6442                	ld	s0,16(sp)
    80002004:	64a2                	ld	s1,8(sp)
    80002006:	6902                	ld	s2,0(sp)
    80002008:	6105                	addi	sp,sp,32
    8000200a:	8082                	ret
    return -1;
    8000200c:	557d                	li	a0,-1
    8000200e:	bfcd                	j	80002000 <fetchaddr+0x3e>
    80002010:	557d                	li	a0,-1
    80002012:	b7fd                	j	80002000 <fetchaddr+0x3e>

0000000080002014 <fetchstr>:
{
    80002014:	7179                	addi	sp,sp,-48
    80002016:	f406                	sd	ra,40(sp)
    80002018:	f022                	sd	s0,32(sp)
    8000201a:	ec26                	sd	s1,24(sp)
    8000201c:	e84a                	sd	s2,16(sp)
    8000201e:	e44e                	sd	s3,8(sp)
    80002020:	1800                	addi	s0,sp,48
    80002022:	892a                	mv	s2,a0
    80002024:	84ae                	mv	s1,a1
    80002026:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002028:	fffff097          	auipc	ra,0xfffff
    8000202c:	f58080e7          	jalr	-168(ra) # 80000f80 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002030:	86ce                	mv	a3,s3
    80002032:	864a                	mv	a2,s2
    80002034:	85a6                	mv	a1,s1
    80002036:	6928                	ld	a0,80(a0)
    80002038:	fffff097          	auipc	ra,0xfffff
    8000203c:	d26080e7          	jalr	-730(ra) # 80000d5e <copyinstr>
  if(err < 0)
    80002040:	00054763          	bltz	a0,8000204e <fetchstr+0x3a>
  return strlen(buf);
    80002044:	8526                	mv	a0,s1
    80002046:	ffffe097          	auipc	ra,0xffffe
    8000204a:	3c0080e7          	jalr	960(ra) # 80000406 <strlen>
}
    8000204e:	70a2                	ld	ra,40(sp)
    80002050:	7402                	ld	s0,32(sp)
    80002052:	64e2                	ld	s1,24(sp)
    80002054:	6942                	ld	s2,16(sp)
    80002056:	69a2                	ld	s3,8(sp)
    80002058:	6145                	addi	sp,sp,48
    8000205a:	8082                	ret

000000008000205c <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    8000205c:	1101                	addi	sp,sp,-32
    8000205e:	ec06                	sd	ra,24(sp)
    80002060:	e822                	sd	s0,16(sp)
    80002062:	e426                	sd	s1,8(sp)
    80002064:	1000                	addi	s0,sp,32
    80002066:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002068:	00000097          	auipc	ra,0x0
    8000206c:	ef2080e7          	jalr	-270(ra) # 80001f5a <argraw>
    80002070:	c088                	sw	a0,0(s1)
  return 0;
}
    80002072:	4501                	li	a0,0
    80002074:	60e2                	ld	ra,24(sp)
    80002076:	6442                	ld	s0,16(sp)
    80002078:	64a2                	ld	s1,8(sp)
    8000207a:	6105                	addi	sp,sp,32
    8000207c:	8082                	ret

000000008000207e <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    8000207e:	1101                	addi	sp,sp,-32
    80002080:	ec06                	sd	ra,24(sp)
    80002082:	e822                	sd	s0,16(sp)
    80002084:	e426                	sd	s1,8(sp)
    80002086:	1000                	addi	s0,sp,32
    80002088:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000208a:	00000097          	auipc	ra,0x0
    8000208e:	ed0080e7          	jalr	-304(ra) # 80001f5a <argraw>
    80002092:	e088                	sd	a0,0(s1)
  return 0;
}
    80002094:	4501                	li	a0,0
    80002096:	60e2                	ld	ra,24(sp)
    80002098:	6442                	ld	s0,16(sp)
    8000209a:	64a2                	ld	s1,8(sp)
    8000209c:	6105                	addi	sp,sp,32
    8000209e:	8082                	ret

00000000800020a0 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800020a0:	1101                	addi	sp,sp,-32
    800020a2:	ec06                	sd	ra,24(sp)
    800020a4:	e822                	sd	s0,16(sp)
    800020a6:	e426                	sd	s1,8(sp)
    800020a8:	e04a                	sd	s2,0(sp)
    800020aa:	1000                	addi	s0,sp,32
    800020ac:	84ae                	mv	s1,a1
    800020ae:	8932                	mv	s2,a2
  *ip = argraw(n);
    800020b0:	00000097          	auipc	ra,0x0
    800020b4:	eaa080e7          	jalr	-342(ra) # 80001f5a <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    800020b8:	864a                	mv	a2,s2
    800020ba:	85a6                	mv	a1,s1
    800020bc:	00000097          	auipc	ra,0x0
    800020c0:	f58080e7          	jalr	-168(ra) # 80002014 <fetchstr>
}
    800020c4:	60e2                	ld	ra,24(sp)
    800020c6:	6442                	ld	s0,16(sp)
    800020c8:	64a2                	ld	s1,8(sp)
    800020ca:	6902                	ld	s2,0(sp)
    800020cc:	6105                	addi	sp,sp,32
    800020ce:	8082                	ret

00000000800020d0 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    800020d0:	1101                	addi	sp,sp,-32
    800020d2:	ec06                	sd	ra,24(sp)
    800020d4:	e822                	sd	s0,16(sp)
    800020d6:	e426                	sd	s1,8(sp)
    800020d8:	e04a                	sd	s2,0(sp)
    800020da:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800020dc:	fffff097          	auipc	ra,0xfffff
    800020e0:	ea4080e7          	jalr	-348(ra) # 80000f80 <myproc>
    800020e4:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800020e6:	05853903          	ld	s2,88(a0)
    800020ea:	0a893783          	ld	a5,168(s2)
    800020ee:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800020f2:	37fd                	addiw	a5,a5,-1
    800020f4:	4751                	li	a4,20
    800020f6:	00f76f63          	bltu	a4,a5,80002114 <syscall+0x44>
    800020fa:	00369713          	slli	a4,a3,0x3
    800020fe:	00006797          	auipc	a5,0x6
    80002102:	2ca78793          	addi	a5,a5,714 # 800083c8 <syscalls>
    80002106:	97ba                	add	a5,a5,a4
    80002108:	639c                	ld	a5,0(a5)
    8000210a:	c789                	beqz	a5,80002114 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    8000210c:	9782                	jalr	a5
    8000210e:	06a93823          	sd	a0,112(s2)
    80002112:	a839                	j	80002130 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002114:	15848613          	addi	a2,s1,344
    80002118:	588c                	lw	a1,48(s1)
    8000211a:	00006517          	auipc	a0,0x6
    8000211e:	27650513          	addi	a0,a0,630 # 80008390 <states.0+0x150>
    80002122:	00004097          	auipc	ra,0x4
    80002126:	b68080e7          	jalr	-1176(ra) # 80005c8a <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000212a:	6cbc                	ld	a5,88(s1)
    8000212c:	577d                	li	a4,-1
    8000212e:	fbb8                	sd	a4,112(a5)
  }
}
    80002130:	60e2                	ld	ra,24(sp)
    80002132:	6442                	ld	s0,16(sp)
    80002134:	64a2                	ld	s1,8(sp)
    80002136:	6902                	ld	s2,0(sp)
    80002138:	6105                	addi	sp,sp,32
    8000213a:	8082                	ret

000000008000213c <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000213c:	1101                	addi	sp,sp,-32
    8000213e:	ec06                	sd	ra,24(sp)
    80002140:	e822                	sd	s0,16(sp)
    80002142:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002144:	fec40593          	addi	a1,s0,-20
    80002148:	4501                	li	a0,0
    8000214a:	00000097          	auipc	ra,0x0
    8000214e:	f12080e7          	jalr	-238(ra) # 8000205c <argint>
    return -1;
    80002152:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002154:	00054963          	bltz	a0,80002166 <sys_exit+0x2a>
  exit(n);
    80002158:	fec42503          	lw	a0,-20(s0)
    8000215c:	fffff097          	auipc	ra,0xfffff
    80002160:	744080e7          	jalr	1860(ra) # 800018a0 <exit>
  return 0;  // not reached
    80002164:	4781                	li	a5,0
}
    80002166:	853e                	mv	a0,a5
    80002168:	60e2                	ld	ra,24(sp)
    8000216a:	6442                	ld	s0,16(sp)
    8000216c:	6105                	addi	sp,sp,32
    8000216e:	8082                	ret

0000000080002170 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002170:	1141                	addi	sp,sp,-16
    80002172:	e406                	sd	ra,8(sp)
    80002174:	e022                	sd	s0,0(sp)
    80002176:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002178:	fffff097          	auipc	ra,0xfffff
    8000217c:	e08080e7          	jalr	-504(ra) # 80000f80 <myproc>
}
    80002180:	5908                	lw	a0,48(a0)
    80002182:	60a2                	ld	ra,8(sp)
    80002184:	6402                	ld	s0,0(sp)
    80002186:	0141                	addi	sp,sp,16
    80002188:	8082                	ret

000000008000218a <sys_fork>:

uint64
sys_fork(void)
{
    8000218a:	1141                	addi	sp,sp,-16
    8000218c:	e406                	sd	ra,8(sp)
    8000218e:	e022                	sd	s0,0(sp)
    80002190:	0800                	addi	s0,sp,16
  return fork();
    80002192:	fffff097          	auipc	ra,0xfffff
    80002196:	1c0080e7          	jalr	448(ra) # 80001352 <fork>
}
    8000219a:	60a2                	ld	ra,8(sp)
    8000219c:	6402                	ld	s0,0(sp)
    8000219e:	0141                	addi	sp,sp,16
    800021a0:	8082                	ret

00000000800021a2 <sys_wait>:

uint64
sys_wait(void)
{
    800021a2:	1101                	addi	sp,sp,-32
    800021a4:	ec06                	sd	ra,24(sp)
    800021a6:	e822                	sd	s0,16(sp)
    800021a8:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    800021aa:	fe840593          	addi	a1,s0,-24
    800021ae:	4501                	li	a0,0
    800021b0:	00000097          	auipc	ra,0x0
    800021b4:	ece080e7          	jalr	-306(ra) # 8000207e <argaddr>
    800021b8:	87aa                	mv	a5,a0
    return -1;
    800021ba:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    800021bc:	0007c863          	bltz	a5,800021cc <sys_wait+0x2a>
  return wait(p);
    800021c0:	fe843503          	ld	a0,-24(s0)
    800021c4:	fffff097          	auipc	ra,0xfffff
    800021c8:	4e4080e7          	jalr	1252(ra) # 800016a8 <wait>
}
    800021cc:	60e2                	ld	ra,24(sp)
    800021ce:	6442                	ld	s0,16(sp)
    800021d0:	6105                	addi	sp,sp,32
    800021d2:	8082                	ret

00000000800021d4 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800021d4:	7179                	addi	sp,sp,-48
    800021d6:	f406                	sd	ra,40(sp)
    800021d8:	f022                	sd	s0,32(sp)
    800021da:	ec26                	sd	s1,24(sp)
    800021dc:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    800021de:	fdc40593          	addi	a1,s0,-36
    800021e2:	4501                	li	a0,0
    800021e4:	00000097          	auipc	ra,0x0
    800021e8:	e78080e7          	jalr	-392(ra) # 8000205c <argint>
    800021ec:	87aa                	mv	a5,a0
    return -1;
    800021ee:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    800021f0:	0207c063          	bltz	a5,80002210 <sys_sbrk+0x3c>
  addr = myproc()->sz;
    800021f4:	fffff097          	auipc	ra,0xfffff
    800021f8:	d8c080e7          	jalr	-628(ra) # 80000f80 <myproc>
    800021fc:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    800021fe:	fdc42503          	lw	a0,-36(s0)
    80002202:	fffff097          	auipc	ra,0xfffff
    80002206:	0d8080e7          	jalr	216(ra) # 800012da <growproc>
    8000220a:	00054863          	bltz	a0,8000221a <sys_sbrk+0x46>
    return -1;
  return addr;
    8000220e:	8526                	mv	a0,s1
}
    80002210:	70a2                	ld	ra,40(sp)
    80002212:	7402                	ld	s0,32(sp)
    80002214:	64e2                	ld	s1,24(sp)
    80002216:	6145                	addi	sp,sp,48
    80002218:	8082                	ret
    return -1;
    8000221a:	557d                	li	a0,-1
    8000221c:	bfd5                	j	80002210 <sys_sbrk+0x3c>

000000008000221e <sys_sleep>:

uint64
sys_sleep(void)
{
    8000221e:	7139                	addi	sp,sp,-64
    80002220:	fc06                	sd	ra,56(sp)
    80002222:	f822                	sd	s0,48(sp)
    80002224:	f426                	sd	s1,40(sp)
    80002226:	f04a                	sd	s2,32(sp)
    80002228:	ec4e                	sd	s3,24(sp)
    8000222a:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    8000222c:	fcc40593          	addi	a1,s0,-52
    80002230:	4501                	li	a0,0
    80002232:	00000097          	auipc	ra,0x0
    80002236:	e2a080e7          	jalr	-470(ra) # 8000205c <argint>
    return -1;
    8000223a:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    8000223c:	06054563          	bltz	a0,800022a6 <sys_sleep+0x88>
  acquire(&tickslock);
    80002240:	0002d517          	auipc	a0,0x2d
    80002244:	c4050513          	addi	a0,a0,-960 # 8002ee80 <tickslock>
    80002248:	00004097          	auipc	ra,0x4
    8000224c:	f30080e7          	jalr	-208(ra) # 80006178 <acquire>
  ticks0 = ticks;
    80002250:	00007917          	auipc	s2,0x7
    80002254:	dc892903          	lw	s2,-568(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    80002258:	fcc42783          	lw	a5,-52(s0)
    8000225c:	cf85                	beqz	a5,80002294 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000225e:	0002d997          	auipc	s3,0x2d
    80002262:	c2298993          	addi	s3,s3,-990 # 8002ee80 <tickslock>
    80002266:	00007497          	auipc	s1,0x7
    8000226a:	db248493          	addi	s1,s1,-590 # 80009018 <ticks>
    if(myproc()->killed){
    8000226e:	fffff097          	auipc	ra,0xfffff
    80002272:	d12080e7          	jalr	-750(ra) # 80000f80 <myproc>
    80002276:	551c                	lw	a5,40(a0)
    80002278:	ef9d                	bnez	a5,800022b6 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    8000227a:	85ce                	mv	a1,s3
    8000227c:	8526                	mv	a0,s1
    8000227e:	fffff097          	auipc	ra,0xfffff
    80002282:	3c6080e7          	jalr	966(ra) # 80001644 <sleep>
  while(ticks - ticks0 < n){
    80002286:	409c                	lw	a5,0(s1)
    80002288:	412787bb          	subw	a5,a5,s2
    8000228c:	fcc42703          	lw	a4,-52(s0)
    80002290:	fce7efe3          	bltu	a5,a4,8000226e <sys_sleep+0x50>
  }
  release(&tickslock);
    80002294:	0002d517          	auipc	a0,0x2d
    80002298:	bec50513          	addi	a0,a0,-1044 # 8002ee80 <tickslock>
    8000229c:	00004097          	auipc	ra,0x4
    800022a0:	f90080e7          	jalr	-112(ra) # 8000622c <release>
  return 0;
    800022a4:	4781                	li	a5,0
}
    800022a6:	853e                	mv	a0,a5
    800022a8:	70e2                	ld	ra,56(sp)
    800022aa:	7442                	ld	s0,48(sp)
    800022ac:	74a2                	ld	s1,40(sp)
    800022ae:	7902                	ld	s2,32(sp)
    800022b0:	69e2                	ld	s3,24(sp)
    800022b2:	6121                	addi	sp,sp,64
    800022b4:	8082                	ret
      release(&tickslock);
    800022b6:	0002d517          	auipc	a0,0x2d
    800022ba:	bca50513          	addi	a0,a0,-1078 # 8002ee80 <tickslock>
    800022be:	00004097          	auipc	ra,0x4
    800022c2:	f6e080e7          	jalr	-146(ra) # 8000622c <release>
      return -1;
    800022c6:	57fd                	li	a5,-1
    800022c8:	bff9                	j	800022a6 <sys_sleep+0x88>

00000000800022ca <sys_kill>:

uint64
sys_kill(void)
{
    800022ca:	1101                	addi	sp,sp,-32
    800022cc:	ec06                	sd	ra,24(sp)
    800022ce:	e822                	sd	s0,16(sp)
    800022d0:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    800022d2:	fec40593          	addi	a1,s0,-20
    800022d6:	4501                	li	a0,0
    800022d8:	00000097          	auipc	ra,0x0
    800022dc:	d84080e7          	jalr	-636(ra) # 8000205c <argint>
    800022e0:	87aa                	mv	a5,a0
    return -1;
    800022e2:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    800022e4:	0007c863          	bltz	a5,800022f4 <sys_kill+0x2a>
  return kill(pid);
    800022e8:	fec42503          	lw	a0,-20(s0)
    800022ec:	fffff097          	auipc	ra,0xfffff
    800022f0:	68a080e7          	jalr	1674(ra) # 80001976 <kill>
}
    800022f4:	60e2                	ld	ra,24(sp)
    800022f6:	6442                	ld	s0,16(sp)
    800022f8:	6105                	addi	sp,sp,32
    800022fa:	8082                	ret

00000000800022fc <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800022fc:	1101                	addi	sp,sp,-32
    800022fe:	ec06                	sd	ra,24(sp)
    80002300:	e822                	sd	s0,16(sp)
    80002302:	e426                	sd	s1,8(sp)
    80002304:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002306:	0002d517          	auipc	a0,0x2d
    8000230a:	b7a50513          	addi	a0,a0,-1158 # 8002ee80 <tickslock>
    8000230e:	00004097          	auipc	ra,0x4
    80002312:	e6a080e7          	jalr	-406(ra) # 80006178 <acquire>
  xticks = ticks;
    80002316:	00007497          	auipc	s1,0x7
    8000231a:	d024a483          	lw	s1,-766(s1) # 80009018 <ticks>
  release(&tickslock);
    8000231e:	0002d517          	auipc	a0,0x2d
    80002322:	b6250513          	addi	a0,a0,-1182 # 8002ee80 <tickslock>
    80002326:	00004097          	auipc	ra,0x4
    8000232a:	f06080e7          	jalr	-250(ra) # 8000622c <release>
  return xticks;
}
    8000232e:	02049513          	slli	a0,s1,0x20
    80002332:	9101                	srli	a0,a0,0x20
    80002334:	60e2                	ld	ra,24(sp)
    80002336:	6442                	ld	s0,16(sp)
    80002338:	64a2                	ld	s1,8(sp)
    8000233a:	6105                	addi	sp,sp,32
    8000233c:	8082                	ret

000000008000233e <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000233e:	7179                	addi	sp,sp,-48
    80002340:	f406                	sd	ra,40(sp)
    80002342:	f022                	sd	s0,32(sp)
    80002344:	ec26                	sd	s1,24(sp)
    80002346:	e84a                	sd	s2,16(sp)
    80002348:	e44e                	sd	s3,8(sp)
    8000234a:	e052                	sd	s4,0(sp)
    8000234c:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000234e:	00006597          	auipc	a1,0x6
    80002352:	12a58593          	addi	a1,a1,298 # 80008478 <syscalls+0xb0>
    80002356:	0002d517          	auipc	a0,0x2d
    8000235a:	b4250513          	addi	a0,a0,-1214 # 8002ee98 <bcache>
    8000235e:	00004097          	auipc	ra,0x4
    80002362:	d8a080e7          	jalr	-630(ra) # 800060e8 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002366:	00035797          	auipc	a5,0x35
    8000236a:	b3278793          	addi	a5,a5,-1230 # 80036e98 <bcache+0x8000>
    8000236e:	00035717          	auipc	a4,0x35
    80002372:	d9270713          	addi	a4,a4,-622 # 80037100 <bcache+0x8268>
    80002376:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000237a:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000237e:	0002d497          	auipc	s1,0x2d
    80002382:	b3248493          	addi	s1,s1,-1230 # 8002eeb0 <bcache+0x18>
    b->next = bcache.head.next;
    80002386:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002388:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000238a:	00006a17          	auipc	s4,0x6
    8000238e:	0f6a0a13          	addi	s4,s4,246 # 80008480 <syscalls+0xb8>
    b->next = bcache.head.next;
    80002392:	2b893783          	ld	a5,696(s2)
    80002396:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002398:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000239c:	85d2                	mv	a1,s4
    8000239e:	01048513          	addi	a0,s1,16
    800023a2:	00001097          	auipc	ra,0x1
    800023a6:	4c2080e7          	jalr	1218(ra) # 80003864 <initsleeplock>
    bcache.head.next->prev = b;
    800023aa:	2b893783          	ld	a5,696(s2)
    800023ae:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800023b0:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023b4:	45848493          	addi	s1,s1,1112
    800023b8:	fd349de3          	bne	s1,s3,80002392 <binit+0x54>
  }
}
    800023bc:	70a2                	ld	ra,40(sp)
    800023be:	7402                	ld	s0,32(sp)
    800023c0:	64e2                	ld	s1,24(sp)
    800023c2:	6942                	ld	s2,16(sp)
    800023c4:	69a2                	ld	s3,8(sp)
    800023c6:	6a02                	ld	s4,0(sp)
    800023c8:	6145                	addi	sp,sp,48
    800023ca:	8082                	ret

00000000800023cc <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800023cc:	7179                	addi	sp,sp,-48
    800023ce:	f406                	sd	ra,40(sp)
    800023d0:	f022                	sd	s0,32(sp)
    800023d2:	ec26                	sd	s1,24(sp)
    800023d4:	e84a                	sd	s2,16(sp)
    800023d6:	e44e                	sd	s3,8(sp)
    800023d8:	1800                	addi	s0,sp,48
    800023da:	892a                	mv	s2,a0
    800023dc:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800023de:	0002d517          	auipc	a0,0x2d
    800023e2:	aba50513          	addi	a0,a0,-1350 # 8002ee98 <bcache>
    800023e6:	00004097          	auipc	ra,0x4
    800023ea:	d92080e7          	jalr	-622(ra) # 80006178 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800023ee:	00035497          	auipc	s1,0x35
    800023f2:	d624b483          	ld	s1,-670(s1) # 80037150 <bcache+0x82b8>
    800023f6:	00035797          	auipc	a5,0x35
    800023fa:	d0a78793          	addi	a5,a5,-758 # 80037100 <bcache+0x8268>
    800023fe:	02f48f63          	beq	s1,a5,8000243c <bread+0x70>
    80002402:	873e                	mv	a4,a5
    80002404:	a021                	j	8000240c <bread+0x40>
    80002406:	68a4                	ld	s1,80(s1)
    80002408:	02e48a63          	beq	s1,a4,8000243c <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000240c:	449c                	lw	a5,8(s1)
    8000240e:	ff279ce3          	bne	a5,s2,80002406 <bread+0x3a>
    80002412:	44dc                	lw	a5,12(s1)
    80002414:	ff3799e3          	bne	a5,s3,80002406 <bread+0x3a>
      b->refcnt++;
    80002418:	40bc                	lw	a5,64(s1)
    8000241a:	2785                	addiw	a5,a5,1
    8000241c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000241e:	0002d517          	auipc	a0,0x2d
    80002422:	a7a50513          	addi	a0,a0,-1414 # 8002ee98 <bcache>
    80002426:	00004097          	auipc	ra,0x4
    8000242a:	e06080e7          	jalr	-506(ra) # 8000622c <release>
      acquiresleep(&b->lock);
    8000242e:	01048513          	addi	a0,s1,16
    80002432:	00001097          	auipc	ra,0x1
    80002436:	46c080e7          	jalr	1132(ra) # 8000389e <acquiresleep>
      return b;
    8000243a:	a8b9                	j	80002498 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000243c:	00035497          	auipc	s1,0x35
    80002440:	d0c4b483          	ld	s1,-756(s1) # 80037148 <bcache+0x82b0>
    80002444:	00035797          	auipc	a5,0x35
    80002448:	cbc78793          	addi	a5,a5,-836 # 80037100 <bcache+0x8268>
    8000244c:	00f48863          	beq	s1,a5,8000245c <bread+0x90>
    80002450:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002452:	40bc                	lw	a5,64(s1)
    80002454:	cf81                	beqz	a5,8000246c <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002456:	64a4                	ld	s1,72(s1)
    80002458:	fee49de3          	bne	s1,a4,80002452 <bread+0x86>
  panic("bget: no buffers");
    8000245c:	00006517          	auipc	a0,0x6
    80002460:	02c50513          	addi	a0,a0,44 # 80008488 <syscalls+0xc0>
    80002464:	00003097          	auipc	ra,0x3
    80002468:	7dc080e7          	jalr	2012(ra) # 80005c40 <panic>
      b->dev = dev;
    8000246c:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002470:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002474:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002478:	4785                	li	a5,1
    8000247a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000247c:	0002d517          	auipc	a0,0x2d
    80002480:	a1c50513          	addi	a0,a0,-1508 # 8002ee98 <bcache>
    80002484:	00004097          	auipc	ra,0x4
    80002488:	da8080e7          	jalr	-600(ra) # 8000622c <release>
      acquiresleep(&b->lock);
    8000248c:	01048513          	addi	a0,s1,16
    80002490:	00001097          	auipc	ra,0x1
    80002494:	40e080e7          	jalr	1038(ra) # 8000389e <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002498:	409c                	lw	a5,0(s1)
    8000249a:	cb89                	beqz	a5,800024ac <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000249c:	8526                	mv	a0,s1
    8000249e:	70a2                	ld	ra,40(sp)
    800024a0:	7402                	ld	s0,32(sp)
    800024a2:	64e2                	ld	s1,24(sp)
    800024a4:	6942                	ld	s2,16(sp)
    800024a6:	69a2                	ld	s3,8(sp)
    800024a8:	6145                	addi	sp,sp,48
    800024aa:	8082                	ret
    virtio_disk_rw(b, 0);
    800024ac:	4581                	li	a1,0
    800024ae:	8526                	mv	a0,s1
    800024b0:	00003097          	auipc	ra,0x3
    800024b4:	f22080e7          	jalr	-222(ra) # 800053d2 <virtio_disk_rw>
    b->valid = 1;
    800024b8:	4785                	li	a5,1
    800024ba:	c09c                	sw	a5,0(s1)
  return b;
    800024bc:	b7c5                	j	8000249c <bread+0xd0>

00000000800024be <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800024be:	1101                	addi	sp,sp,-32
    800024c0:	ec06                	sd	ra,24(sp)
    800024c2:	e822                	sd	s0,16(sp)
    800024c4:	e426                	sd	s1,8(sp)
    800024c6:	1000                	addi	s0,sp,32
    800024c8:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024ca:	0541                	addi	a0,a0,16
    800024cc:	00001097          	auipc	ra,0x1
    800024d0:	46c080e7          	jalr	1132(ra) # 80003938 <holdingsleep>
    800024d4:	cd01                	beqz	a0,800024ec <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800024d6:	4585                	li	a1,1
    800024d8:	8526                	mv	a0,s1
    800024da:	00003097          	auipc	ra,0x3
    800024de:	ef8080e7          	jalr	-264(ra) # 800053d2 <virtio_disk_rw>
}
    800024e2:	60e2                	ld	ra,24(sp)
    800024e4:	6442                	ld	s0,16(sp)
    800024e6:	64a2                	ld	s1,8(sp)
    800024e8:	6105                	addi	sp,sp,32
    800024ea:	8082                	ret
    panic("bwrite");
    800024ec:	00006517          	auipc	a0,0x6
    800024f0:	fb450513          	addi	a0,a0,-76 # 800084a0 <syscalls+0xd8>
    800024f4:	00003097          	auipc	ra,0x3
    800024f8:	74c080e7          	jalr	1868(ra) # 80005c40 <panic>

00000000800024fc <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800024fc:	1101                	addi	sp,sp,-32
    800024fe:	ec06                	sd	ra,24(sp)
    80002500:	e822                	sd	s0,16(sp)
    80002502:	e426                	sd	s1,8(sp)
    80002504:	e04a                	sd	s2,0(sp)
    80002506:	1000                	addi	s0,sp,32
    80002508:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000250a:	01050913          	addi	s2,a0,16
    8000250e:	854a                	mv	a0,s2
    80002510:	00001097          	auipc	ra,0x1
    80002514:	428080e7          	jalr	1064(ra) # 80003938 <holdingsleep>
    80002518:	c92d                	beqz	a0,8000258a <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    8000251a:	854a                	mv	a0,s2
    8000251c:	00001097          	auipc	ra,0x1
    80002520:	3d8080e7          	jalr	984(ra) # 800038f4 <releasesleep>

  acquire(&bcache.lock);
    80002524:	0002d517          	auipc	a0,0x2d
    80002528:	97450513          	addi	a0,a0,-1676 # 8002ee98 <bcache>
    8000252c:	00004097          	auipc	ra,0x4
    80002530:	c4c080e7          	jalr	-948(ra) # 80006178 <acquire>
  b->refcnt--;
    80002534:	40bc                	lw	a5,64(s1)
    80002536:	37fd                	addiw	a5,a5,-1
    80002538:	0007871b          	sext.w	a4,a5
    8000253c:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000253e:	eb05                	bnez	a4,8000256e <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002540:	68bc                	ld	a5,80(s1)
    80002542:	64b8                	ld	a4,72(s1)
    80002544:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002546:	64bc                	ld	a5,72(s1)
    80002548:	68b8                	ld	a4,80(s1)
    8000254a:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000254c:	00035797          	auipc	a5,0x35
    80002550:	94c78793          	addi	a5,a5,-1716 # 80036e98 <bcache+0x8000>
    80002554:	2b87b703          	ld	a4,696(a5)
    80002558:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000255a:	00035717          	auipc	a4,0x35
    8000255e:	ba670713          	addi	a4,a4,-1114 # 80037100 <bcache+0x8268>
    80002562:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002564:	2b87b703          	ld	a4,696(a5)
    80002568:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000256a:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000256e:	0002d517          	auipc	a0,0x2d
    80002572:	92a50513          	addi	a0,a0,-1750 # 8002ee98 <bcache>
    80002576:	00004097          	auipc	ra,0x4
    8000257a:	cb6080e7          	jalr	-842(ra) # 8000622c <release>
}
    8000257e:	60e2                	ld	ra,24(sp)
    80002580:	6442                	ld	s0,16(sp)
    80002582:	64a2                	ld	s1,8(sp)
    80002584:	6902                	ld	s2,0(sp)
    80002586:	6105                	addi	sp,sp,32
    80002588:	8082                	ret
    panic("brelse");
    8000258a:	00006517          	auipc	a0,0x6
    8000258e:	f1e50513          	addi	a0,a0,-226 # 800084a8 <syscalls+0xe0>
    80002592:	00003097          	auipc	ra,0x3
    80002596:	6ae080e7          	jalr	1710(ra) # 80005c40 <panic>

000000008000259a <bpin>:

void
bpin(struct buf *b) {
    8000259a:	1101                	addi	sp,sp,-32
    8000259c:	ec06                	sd	ra,24(sp)
    8000259e:	e822                	sd	s0,16(sp)
    800025a0:	e426                	sd	s1,8(sp)
    800025a2:	1000                	addi	s0,sp,32
    800025a4:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025a6:	0002d517          	auipc	a0,0x2d
    800025aa:	8f250513          	addi	a0,a0,-1806 # 8002ee98 <bcache>
    800025ae:	00004097          	auipc	ra,0x4
    800025b2:	bca080e7          	jalr	-1078(ra) # 80006178 <acquire>
  b->refcnt++;
    800025b6:	40bc                	lw	a5,64(s1)
    800025b8:	2785                	addiw	a5,a5,1
    800025ba:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025bc:	0002d517          	auipc	a0,0x2d
    800025c0:	8dc50513          	addi	a0,a0,-1828 # 8002ee98 <bcache>
    800025c4:	00004097          	auipc	ra,0x4
    800025c8:	c68080e7          	jalr	-920(ra) # 8000622c <release>
}
    800025cc:	60e2                	ld	ra,24(sp)
    800025ce:	6442                	ld	s0,16(sp)
    800025d0:	64a2                	ld	s1,8(sp)
    800025d2:	6105                	addi	sp,sp,32
    800025d4:	8082                	ret

00000000800025d6 <bunpin>:

void
bunpin(struct buf *b) {
    800025d6:	1101                	addi	sp,sp,-32
    800025d8:	ec06                	sd	ra,24(sp)
    800025da:	e822                	sd	s0,16(sp)
    800025dc:	e426                	sd	s1,8(sp)
    800025de:	1000                	addi	s0,sp,32
    800025e0:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025e2:	0002d517          	auipc	a0,0x2d
    800025e6:	8b650513          	addi	a0,a0,-1866 # 8002ee98 <bcache>
    800025ea:	00004097          	auipc	ra,0x4
    800025ee:	b8e080e7          	jalr	-1138(ra) # 80006178 <acquire>
  b->refcnt--;
    800025f2:	40bc                	lw	a5,64(s1)
    800025f4:	37fd                	addiw	a5,a5,-1
    800025f6:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025f8:	0002d517          	auipc	a0,0x2d
    800025fc:	8a050513          	addi	a0,a0,-1888 # 8002ee98 <bcache>
    80002600:	00004097          	auipc	ra,0x4
    80002604:	c2c080e7          	jalr	-980(ra) # 8000622c <release>
}
    80002608:	60e2                	ld	ra,24(sp)
    8000260a:	6442                	ld	s0,16(sp)
    8000260c:	64a2                	ld	s1,8(sp)
    8000260e:	6105                	addi	sp,sp,32
    80002610:	8082                	ret

0000000080002612 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002612:	1101                	addi	sp,sp,-32
    80002614:	ec06                	sd	ra,24(sp)
    80002616:	e822                	sd	s0,16(sp)
    80002618:	e426                	sd	s1,8(sp)
    8000261a:	e04a                	sd	s2,0(sp)
    8000261c:	1000                	addi	s0,sp,32
    8000261e:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002620:	00d5d59b          	srliw	a1,a1,0xd
    80002624:	00035797          	auipc	a5,0x35
    80002628:	f507a783          	lw	a5,-176(a5) # 80037574 <sb+0x1c>
    8000262c:	9dbd                	addw	a1,a1,a5
    8000262e:	00000097          	auipc	ra,0x0
    80002632:	d9e080e7          	jalr	-610(ra) # 800023cc <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002636:	0074f713          	andi	a4,s1,7
    8000263a:	4785                	li	a5,1
    8000263c:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002640:	14ce                	slli	s1,s1,0x33
    80002642:	90d9                	srli	s1,s1,0x36
    80002644:	00950733          	add	a4,a0,s1
    80002648:	05874703          	lbu	a4,88(a4)
    8000264c:	00e7f6b3          	and	a3,a5,a4
    80002650:	c69d                	beqz	a3,8000267e <bfree+0x6c>
    80002652:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002654:	94aa                	add	s1,s1,a0
    80002656:	fff7c793          	not	a5,a5
    8000265a:	8f7d                	and	a4,a4,a5
    8000265c:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002660:	00001097          	auipc	ra,0x1
    80002664:	120080e7          	jalr	288(ra) # 80003780 <log_write>
  brelse(bp);
    80002668:	854a                	mv	a0,s2
    8000266a:	00000097          	auipc	ra,0x0
    8000266e:	e92080e7          	jalr	-366(ra) # 800024fc <brelse>
}
    80002672:	60e2                	ld	ra,24(sp)
    80002674:	6442                	ld	s0,16(sp)
    80002676:	64a2                	ld	s1,8(sp)
    80002678:	6902                	ld	s2,0(sp)
    8000267a:	6105                	addi	sp,sp,32
    8000267c:	8082                	ret
    panic("freeing free block");
    8000267e:	00006517          	auipc	a0,0x6
    80002682:	e3250513          	addi	a0,a0,-462 # 800084b0 <syscalls+0xe8>
    80002686:	00003097          	auipc	ra,0x3
    8000268a:	5ba080e7          	jalr	1466(ra) # 80005c40 <panic>

000000008000268e <balloc>:
{
    8000268e:	711d                	addi	sp,sp,-96
    80002690:	ec86                	sd	ra,88(sp)
    80002692:	e8a2                	sd	s0,80(sp)
    80002694:	e4a6                	sd	s1,72(sp)
    80002696:	e0ca                	sd	s2,64(sp)
    80002698:	fc4e                	sd	s3,56(sp)
    8000269a:	f852                	sd	s4,48(sp)
    8000269c:	f456                	sd	s5,40(sp)
    8000269e:	f05a                	sd	s6,32(sp)
    800026a0:	ec5e                	sd	s7,24(sp)
    800026a2:	e862                	sd	s8,16(sp)
    800026a4:	e466                	sd	s9,8(sp)
    800026a6:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800026a8:	00035797          	auipc	a5,0x35
    800026ac:	eb47a783          	lw	a5,-332(a5) # 8003755c <sb+0x4>
    800026b0:	cbc1                	beqz	a5,80002740 <balloc+0xb2>
    800026b2:	8baa                	mv	s7,a0
    800026b4:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800026b6:	00035b17          	auipc	s6,0x35
    800026ba:	ea2b0b13          	addi	s6,s6,-350 # 80037558 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026be:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800026c0:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026c2:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800026c4:	6c89                	lui	s9,0x2
    800026c6:	a831                	j	800026e2 <balloc+0x54>
    brelse(bp);
    800026c8:	854a                	mv	a0,s2
    800026ca:	00000097          	auipc	ra,0x0
    800026ce:	e32080e7          	jalr	-462(ra) # 800024fc <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800026d2:	015c87bb          	addw	a5,s9,s5
    800026d6:	00078a9b          	sext.w	s5,a5
    800026da:	004b2703          	lw	a4,4(s6)
    800026de:	06eaf163          	bgeu	s5,a4,80002740 <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    800026e2:	41fad79b          	sraiw	a5,s5,0x1f
    800026e6:	0137d79b          	srliw	a5,a5,0x13
    800026ea:	015787bb          	addw	a5,a5,s5
    800026ee:	40d7d79b          	sraiw	a5,a5,0xd
    800026f2:	01cb2583          	lw	a1,28(s6)
    800026f6:	9dbd                	addw	a1,a1,a5
    800026f8:	855e                	mv	a0,s7
    800026fa:	00000097          	auipc	ra,0x0
    800026fe:	cd2080e7          	jalr	-814(ra) # 800023cc <bread>
    80002702:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002704:	004b2503          	lw	a0,4(s6)
    80002708:	000a849b          	sext.w	s1,s5
    8000270c:	8762                	mv	a4,s8
    8000270e:	faa4fde3          	bgeu	s1,a0,800026c8 <balloc+0x3a>
      m = 1 << (bi % 8);
    80002712:	00777693          	andi	a3,a4,7
    80002716:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000271a:	41f7579b          	sraiw	a5,a4,0x1f
    8000271e:	01d7d79b          	srliw	a5,a5,0x1d
    80002722:	9fb9                	addw	a5,a5,a4
    80002724:	4037d79b          	sraiw	a5,a5,0x3
    80002728:	00f90633          	add	a2,s2,a5
    8000272c:	05864603          	lbu	a2,88(a2)
    80002730:	00c6f5b3          	and	a1,a3,a2
    80002734:	cd91                	beqz	a1,80002750 <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002736:	2705                	addiw	a4,a4,1
    80002738:	2485                	addiw	s1,s1,1
    8000273a:	fd471ae3          	bne	a4,s4,8000270e <balloc+0x80>
    8000273e:	b769                	j	800026c8 <balloc+0x3a>
  panic("balloc: out of blocks");
    80002740:	00006517          	auipc	a0,0x6
    80002744:	d8850513          	addi	a0,a0,-632 # 800084c8 <syscalls+0x100>
    80002748:	00003097          	auipc	ra,0x3
    8000274c:	4f8080e7          	jalr	1272(ra) # 80005c40 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002750:	97ca                	add	a5,a5,s2
    80002752:	8e55                	or	a2,a2,a3
    80002754:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002758:	854a                	mv	a0,s2
    8000275a:	00001097          	auipc	ra,0x1
    8000275e:	026080e7          	jalr	38(ra) # 80003780 <log_write>
        brelse(bp);
    80002762:	854a                	mv	a0,s2
    80002764:	00000097          	auipc	ra,0x0
    80002768:	d98080e7          	jalr	-616(ra) # 800024fc <brelse>
  bp = bread(dev, bno);
    8000276c:	85a6                	mv	a1,s1
    8000276e:	855e                	mv	a0,s7
    80002770:	00000097          	auipc	ra,0x0
    80002774:	c5c080e7          	jalr	-932(ra) # 800023cc <bread>
    80002778:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000277a:	40000613          	li	a2,1024
    8000277e:	4581                	li	a1,0
    80002780:	05850513          	addi	a0,a0,88
    80002784:	ffffe097          	auipc	ra,0xffffe
    80002788:	b06080e7          	jalr	-1274(ra) # 8000028a <memset>
  log_write(bp);
    8000278c:	854a                	mv	a0,s2
    8000278e:	00001097          	auipc	ra,0x1
    80002792:	ff2080e7          	jalr	-14(ra) # 80003780 <log_write>
  brelse(bp);
    80002796:	854a                	mv	a0,s2
    80002798:	00000097          	auipc	ra,0x0
    8000279c:	d64080e7          	jalr	-668(ra) # 800024fc <brelse>
}
    800027a0:	8526                	mv	a0,s1
    800027a2:	60e6                	ld	ra,88(sp)
    800027a4:	6446                	ld	s0,80(sp)
    800027a6:	64a6                	ld	s1,72(sp)
    800027a8:	6906                	ld	s2,64(sp)
    800027aa:	79e2                	ld	s3,56(sp)
    800027ac:	7a42                	ld	s4,48(sp)
    800027ae:	7aa2                	ld	s5,40(sp)
    800027b0:	7b02                	ld	s6,32(sp)
    800027b2:	6be2                	ld	s7,24(sp)
    800027b4:	6c42                	ld	s8,16(sp)
    800027b6:	6ca2                	ld	s9,8(sp)
    800027b8:	6125                	addi	sp,sp,96
    800027ba:	8082                	ret

00000000800027bc <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800027bc:	7179                	addi	sp,sp,-48
    800027be:	f406                	sd	ra,40(sp)
    800027c0:	f022                	sd	s0,32(sp)
    800027c2:	ec26                	sd	s1,24(sp)
    800027c4:	e84a                	sd	s2,16(sp)
    800027c6:	e44e                	sd	s3,8(sp)
    800027c8:	e052                	sd	s4,0(sp)
    800027ca:	1800                	addi	s0,sp,48
    800027cc:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800027ce:	47ad                	li	a5,11
    800027d0:	04b7fe63          	bgeu	a5,a1,8000282c <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800027d4:	ff45849b          	addiw	s1,a1,-12
    800027d8:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800027dc:	0ff00793          	li	a5,255
    800027e0:	0ae7e463          	bltu	a5,a4,80002888 <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800027e4:	08052583          	lw	a1,128(a0)
    800027e8:	c5b5                	beqz	a1,80002854 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800027ea:	00092503          	lw	a0,0(s2)
    800027ee:	00000097          	auipc	ra,0x0
    800027f2:	bde080e7          	jalr	-1058(ra) # 800023cc <bread>
    800027f6:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800027f8:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800027fc:	02049713          	slli	a4,s1,0x20
    80002800:	01e75593          	srli	a1,a4,0x1e
    80002804:	00b784b3          	add	s1,a5,a1
    80002808:	0004a983          	lw	s3,0(s1)
    8000280c:	04098e63          	beqz	s3,80002868 <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80002810:	8552                	mv	a0,s4
    80002812:	00000097          	auipc	ra,0x0
    80002816:	cea080e7          	jalr	-790(ra) # 800024fc <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000281a:	854e                	mv	a0,s3
    8000281c:	70a2                	ld	ra,40(sp)
    8000281e:	7402                	ld	s0,32(sp)
    80002820:	64e2                	ld	s1,24(sp)
    80002822:	6942                	ld	s2,16(sp)
    80002824:	69a2                	ld	s3,8(sp)
    80002826:	6a02                	ld	s4,0(sp)
    80002828:	6145                	addi	sp,sp,48
    8000282a:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    8000282c:	02059793          	slli	a5,a1,0x20
    80002830:	01e7d593          	srli	a1,a5,0x1e
    80002834:	00b504b3          	add	s1,a0,a1
    80002838:	0504a983          	lw	s3,80(s1)
    8000283c:	fc099fe3          	bnez	s3,8000281a <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002840:	4108                	lw	a0,0(a0)
    80002842:	00000097          	auipc	ra,0x0
    80002846:	e4c080e7          	jalr	-436(ra) # 8000268e <balloc>
    8000284a:	0005099b          	sext.w	s3,a0
    8000284e:	0534a823          	sw	s3,80(s1)
    80002852:	b7e1                	j	8000281a <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002854:	4108                	lw	a0,0(a0)
    80002856:	00000097          	auipc	ra,0x0
    8000285a:	e38080e7          	jalr	-456(ra) # 8000268e <balloc>
    8000285e:	0005059b          	sext.w	a1,a0
    80002862:	08b92023          	sw	a1,128(s2)
    80002866:	b751                	j	800027ea <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002868:	00092503          	lw	a0,0(s2)
    8000286c:	00000097          	auipc	ra,0x0
    80002870:	e22080e7          	jalr	-478(ra) # 8000268e <balloc>
    80002874:	0005099b          	sext.w	s3,a0
    80002878:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    8000287c:	8552                	mv	a0,s4
    8000287e:	00001097          	auipc	ra,0x1
    80002882:	f02080e7          	jalr	-254(ra) # 80003780 <log_write>
    80002886:	b769                	j	80002810 <bmap+0x54>
  panic("bmap: out of range");
    80002888:	00006517          	auipc	a0,0x6
    8000288c:	c5850513          	addi	a0,a0,-936 # 800084e0 <syscalls+0x118>
    80002890:	00003097          	auipc	ra,0x3
    80002894:	3b0080e7          	jalr	944(ra) # 80005c40 <panic>

0000000080002898 <iget>:
{
    80002898:	7179                	addi	sp,sp,-48
    8000289a:	f406                	sd	ra,40(sp)
    8000289c:	f022                	sd	s0,32(sp)
    8000289e:	ec26                	sd	s1,24(sp)
    800028a0:	e84a                	sd	s2,16(sp)
    800028a2:	e44e                	sd	s3,8(sp)
    800028a4:	e052                	sd	s4,0(sp)
    800028a6:	1800                	addi	s0,sp,48
    800028a8:	89aa                	mv	s3,a0
    800028aa:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800028ac:	00035517          	auipc	a0,0x35
    800028b0:	ccc50513          	addi	a0,a0,-820 # 80037578 <itable>
    800028b4:	00004097          	auipc	ra,0x4
    800028b8:	8c4080e7          	jalr	-1852(ra) # 80006178 <acquire>
  empty = 0;
    800028bc:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028be:	00035497          	auipc	s1,0x35
    800028c2:	cd248493          	addi	s1,s1,-814 # 80037590 <itable+0x18>
    800028c6:	00036697          	auipc	a3,0x36
    800028ca:	75a68693          	addi	a3,a3,1882 # 80039020 <log>
    800028ce:	a039                	j	800028dc <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028d0:	02090b63          	beqz	s2,80002906 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028d4:	08848493          	addi	s1,s1,136
    800028d8:	02d48a63          	beq	s1,a3,8000290c <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800028dc:	449c                	lw	a5,8(s1)
    800028de:	fef059e3          	blez	a5,800028d0 <iget+0x38>
    800028e2:	4098                	lw	a4,0(s1)
    800028e4:	ff3716e3          	bne	a4,s3,800028d0 <iget+0x38>
    800028e8:	40d8                	lw	a4,4(s1)
    800028ea:	ff4713e3          	bne	a4,s4,800028d0 <iget+0x38>
      ip->ref++;
    800028ee:	2785                	addiw	a5,a5,1
    800028f0:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800028f2:	00035517          	auipc	a0,0x35
    800028f6:	c8650513          	addi	a0,a0,-890 # 80037578 <itable>
    800028fa:	00004097          	auipc	ra,0x4
    800028fe:	932080e7          	jalr	-1742(ra) # 8000622c <release>
      return ip;
    80002902:	8926                	mv	s2,s1
    80002904:	a03d                	j	80002932 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002906:	f7f9                	bnez	a5,800028d4 <iget+0x3c>
    80002908:	8926                	mv	s2,s1
    8000290a:	b7e9                	j	800028d4 <iget+0x3c>
  if(empty == 0)
    8000290c:	02090c63          	beqz	s2,80002944 <iget+0xac>
  ip->dev = dev;
    80002910:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002914:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002918:	4785                	li	a5,1
    8000291a:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000291e:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002922:	00035517          	auipc	a0,0x35
    80002926:	c5650513          	addi	a0,a0,-938 # 80037578 <itable>
    8000292a:	00004097          	auipc	ra,0x4
    8000292e:	902080e7          	jalr	-1790(ra) # 8000622c <release>
}
    80002932:	854a                	mv	a0,s2
    80002934:	70a2                	ld	ra,40(sp)
    80002936:	7402                	ld	s0,32(sp)
    80002938:	64e2                	ld	s1,24(sp)
    8000293a:	6942                	ld	s2,16(sp)
    8000293c:	69a2                	ld	s3,8(sp)
    8000293e:	6a02                	ld	s4,0(sp)
    80002940:	6145                	addi	sp,sp,48
    80002942:	8082                	ret
    panic("iget: no inodes");
    80002944:	00006517          	auipc	a0,0x6
    80002948:	bb450513          	addi	a0,a0,-1100 # 800084f8 <syscalls+0x130>
    8000294c:	00003097          	auipc	ra,0x3
    80002950:	2f4080e7          	jalr	756(ra) # 80005c40 <panic>

0000000080002954 <fsinit>:
fsinit(int dev) {
    80002954:	7179                	addi	sp,sp,-48
    80002956:	f406                	sd	ra,40(sp)
    80002958:	f022                	sd	s0,32(sp)
    8000295a:	ec26                	sd	s1,24(sp)
    8000295c:	e84a                	sd	s2,16(sp)
    8000295e:	e44e                	sd	s3,8(sp)
    80002960:	1800                	addi	s0,sp,48
    80002962:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002964:	4585                	li	a1,1
    80002966:	00000097          	auipc	ra,0x0
    8000296a:	a66080e7          	jalr	-1434(ra) # 800023cc <bread>
    8000296e:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002970:	00035997          	auipc	s3,0x35
    80002974:	be898993          	addi	s3,s3,-1048 # 80037558 <sb>
    80002978:	02000613          	li	a2,32
    8000297c:	05850593          	addi	a1,a0,88
    80002980:	854e                	mv	a0,s3
    80002982:	ffffe097          	auipc	ra,0xffffe
    80002986:	964080e7          	jalr	-1692(ra) # 800002e6 <memmove>
  brelse(bp);
    8000298a:	8526                	mv	a0,s1
    8000298c:	00000097          	auipc	ra,0x0
    80002990:	b70080e7          	jalr	-1168(ra) # 800024fc <brelse>
  if(sb.magic != FSMAGIC)
    80002994:	0009a703          	lw	a4,0(s3)
    80002998:	102037b7          	lui	a5,0x10203
    8000299c:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800029a0:	02f71263          	bne	a4,a5,800029c4 <fsinit+0x70>
  initlog(dev, &sb);
    800029a4:	00035597          	auipc	a1,0x35
    800029a8:	bb458593          	addi	a1,a1,-1100 # 80037558 <sb>
    800029ac:	854a                	mv	a0,s2
    800029ae:	00001097          	auipc	ra,0x1
    800029b2:	b56080e7          	jalr	-1194(ra) # 80003504 <initlog>
}
    800029b6:	70a2                	ld	ra,40(sp)
    800029b8:	7402                	ld	s0,32(sp)
    800029ba:	64e2                	ld	s1,24(sp)
    800029bc:	6942                	ld	s2,16(sp)
    800029be:	69a2                	ld	s3,8(sp)
    800029c0:	6145                	addi	sp,sp,48
    800029c2:	8082                	ret
    panic("invalid file system");
    800029c4:	00006517          	auipc	a0,0x6
    800029c8:	b4450513          	addi	a0,a0,-1212 # 80008508 <syscalls+0x140>
    800029cc:	00003097          	auipc	ra,0x3
    800029d0:	274080e7          	jalr	628(ra) # 80005c40 <panic>

00000000800029d4 <iinit>:
{
    800029d4:	7179                	addi	sp,sp,-48
    800029d6:	f406                	sd	ra,40(sp)
    800029d8:	f022                	sd	s0,32(sp)
    800029da:	ec26                	sd	s1,24(sp)
    800029dc:	e84a                	sd	s2,16(sp)
    800029de:	e44e                	sd	s3,8(sp)
    800029e0:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800029e2:	00006597          	auipc	a1,0x6
    800029e6:	b3e58593          	addi	a1,a1,-1218 # 80008520 <syscalls+0x158>
    800029ea:	00035517          	auipc	a0,0x35
    800029ee:	b8e50513          	addi	a0,a0,-1138 # 80037578 <itable>
    800029f2:	00003097          	auipc	ra,0x3
    800029f6:	6f6080e7          	jalr	1782(ra) # 800060e8 <initlock>
  for(i = 0; i < NINODE; i++) {
    800029fa:	00035497          	auipc	s1,0x35
    800029fe:	ba648493          	addi	s1,s1,-1114 # 800375a0 <itable+0x28>
    80002a02:	00036997          	auipc	s3,0x36
    80002a06:	62e98993          	addi	s3,s3,1582 # 80039030 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002a0a:	00006917          	auipc	s2,0x6
    80002a0e:	b1e90913          	addi	s2,s2,-1250 # 80008528 <syscalls+0x160>
    80002a12:	85ca                	mv	a1,s2
    80002a14:	8526                	mv	a0,s1
    80002a16:	00001097          	auipc	ra,0x1
    80002a1a:	e4e080e7          	jalr	-434(ra) # 80003864 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002a1e:	08848493          	addi	s1,s1,136
    80002a22:	ff3498e3          	bne	s1,s3,80002a12 <iinit+0x3e>
}
    80002a26:	70a2                	ld	ra,40(sp)
    80002a28:	7402                	ld	s0,32(sp)
    80002a2a:	64e2                	ld	s1,24(sp)
    80002a2c:	6942                	ld	s2,16(sp)
    80002a2e:	69a2                	ld	s3,8(sp)
    80002a30:	6145                	addi	sp,sp,48
    80002a32:	8082                	ret

0000000080002a34 <ialloc>:
{
    80002a34:	715d                	addi	sp,sp,-80
    80002a36:	e486                	sd	ra,72(sp)
    80002a38:	e0a2                	sd	s0,64(sp)
    80002a3a:	fc26                	sd	s1,56(sp)
    80002a3c:	f84a                	sd	s2,48(sp)
    80002a3e:	f44e                	sd	s3,40(sp)
    80002a40:	f052                	sd	s4,32(sp)
    80002a42:	ec56                	sd	s5,24(sp)
    80002a44:	e85a                	sd	s6,16(sp)
    80002a46:	e45e                	sd	s7,8(sp)
    80002a48:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a4a:	00035717          	auipc	a4,0x35
    80002a4e:	b1a72703          	lw	a4,-1254(a4) # 80037564 <sb+0xc>
    80002a52:	4785                	li	a5,1
    80002a54:	04e7fa63          	bgeu	a5,a4,80002aa8 <ialloc+0x74>
    80002a58:	8aaa                	mv	s5,a0
    80002a5a:	8bae                	mv	s7,a1
    80002a5c:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002a5e:	00035a17          	auipc	s4,0x35
    80002a62:	afaa0a13          	addi	s4,s4,-1286 # 80037558 <sb>
    80002a66:	00048b1b          	sext.w	s6,s1
    80002a6a:	0044d593          	srli	a1,s1,0x4
    80002a6e:	018a2783          	lw	a5,24(s4)
    80002a72:	9dbd                	addw	a1,a1,a5
    80002a74:	8556                	mv	a0,s5
    80002a76:	00000097          	auipc	ra,0x0
    80002a7a:	956080e7          	jalr	-1706(ra) # 800023cc <bread>
    80002a7e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002a80:	05850993          	addi	s3,a0,88
    80002a84:	00f4f793          	andi	a5,s1,15
    80002a88:	079a                	slli	a5,a5,0x6
    80002a8a:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002a8c:	00099783          	lh	a5,0(s3)
    80002a90:	c785                	beqz	a5,80002ab8 <ialloc+0x84>
    brelse(bp);
    80002a92:	00000097          	auipc	ra,0x0
    80002a96:	a6a080e7          	jalr	-1430(ra) # 800024fc <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a9a:	0485                	addi	s1,s1,1
    80002a9c:	00ca2703          	lw	a4,12(s4)
    80002aa0:	0004879b          	sext.w	a5,s1
    80002aa4:	fce7e1e3          	bltu	a5,a4,80002a66 <ialloc+0x32>
  panic("ialloc: no inodes");
    80002aa8:	00006517          	auipc	a0,0x6
    80002aac:	a8850513          	addi	a0,a0,-1400 # 80008530 <syscalls+0x168>
    80002ab0:	00003097          	auipc	ra,0x3
    80002ab4:	190080e7          	jalr	400(ra) # 80005c40 <panic>
      memset(dip, 0, sizeof(*dip));
    80002ab8:	04000613          	li	a2,64
    80002abc:	4581                	li	a1,0
    80002abe:	854e                	mv	a0,s3
    80002ac0:	ffffd097          	auipc	ra,0xffffd
    80002ac4:	7ca080e7          	jalr	1994(ra) # 8000028a <memset>
      dip->type = type;
    80002ac8:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002acc:	854a                	mv	a0,s2
    80002ace:	00001097          	auipc	ra,0x1
    80002ad2:	cb2080e7          	jalr	-846(ra) # 80003780 <log_write>
      brelse(bp);
    80002ad6:	854a                	mv	a0,s2
    80002ad8:	00000097          	auipc	ra,0x0
    80002adc:	a24080e7          	jalr	-1500(ra) # 800024fc <brelse>
      return iget(dev, inum);
    80002ae0:	85da                	mv	a1,s6
    80002ae2:	8556                	mv	a0,s5
    80002ae4:	00000097          	auipc	ra,0x0
    80002ae8:	db4080e7          	jalr	-588(ra) # 80002898 <iget>
}
    80002aec:	60a6                	ld	ra,72(sp)
    80002aee:	6406                	ld	s0,64(sp)
    80002af0:	74e2                	ld	s1,56(sp)
    80002af2:	7942                	ld	s2,48(sp)
    80002af4:	79a2                	ld	s3,40(sp)
    80002af6:	7a02                	ld	s4,32(sp)
    80002af8:	6ae2                	ld	s5,24(sp)
    80002afa:	6b42                	ld	s6,16(sp)
    80002afc:	6ba2                	ld	s7,8(sp)
    80002afe:	6161                	addi	sp,sp,80
    80002b00:	8082                	ret

0000000080002b02 <iupdate>:
{
    80002b02:	1101                	addi	sp,sp,-32
    80002b04:	ec06                	sd	ra,24(sp)
    80002b06:	e822                	sd	s0,16(sp)
    80002b08:	e426                	sd	s1,8(sp)
    80002b0a:	e04a                	sd	s2,0(sp)
    80002b0c:	1000                	addi	s0,sp,32
    80002b0e:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b10:	415c                	lw	a5,4(a0)
    80002b12:	0047d79b          	srliw	a5,a5,0x4
    80002b16:	00035597          	auipc	a1,0x35
    80002b1a:	a5a5a583          	lw	a1,-1446(a1) # 80037570 <sb+0x18>
    80002b1e:	9dbd                	addw	a1,a1,a5
    80002b20:	4108                	lw	a0,0(a0)
    80002b22:	00000097          	auipc	ra,0x0
    80002b26:	8aa080e7          	jalr	-1878(ra) # 800023cc <bread>
    80002b2a:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b2c:	05850793          	addi	a5,a0,88
    80002b30:	40d8                	lw	a4,4(s1)
    80002b32:	8b3d                	andi	a4,a4,15
    80002b34:	071a                	slli	a4,a4,0x6
    80002b36:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002b38:	04449703          	lh	a4,68(s1)
    80002b3c:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002b40:	04649703          	lh	a4,70(s1)
    80002b44:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002b48:	04849703          	lh	a4,72(s1)
    80002b4c:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002b50:	04a49703          	lh	a4,74(s1)
    80002b54:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002b58:	44f8                	lw	a4,76(s1)
    80002b5a:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002b5c:	03400613          	li	a2,52
    80002b60:	05048593          	addi	a1,s1,80
    80002b64:	00c78513          	addi	a0,a5,12
    80002b68:	ffffd097          	auipc	ra,0xffffd
    80002b6c:	77e080e7          	jalr	1918(ra) # 800002e6 <memmove>
  log_write(bp);
    80002b70:	854a                	mv	a0,s2
    80002b72:	00001097          	auipc	ra,0x1
    80002b76:	c0e080e7          	jalr	-1010(ra) # 80003780 <log_write>
  brelse(bp);
    80002b7a:	854a                	mv	a0,s2
    80002b7c:	00000097          	auipc	ra,0x0
    80002b80:	980080e7          	jalr	-1664(ra) # 800024fc <brelse>
}
    80002b84:	60e2                	ld	ra,24(sp)
    80002b86:	6442                	ld	s0,16(sp)
    80002b88:	64a2                	ld	s1,8(sp)
    80002b8a:	6902                	ld	s2,0(sp)
    80002b8c:	6105                	addi	sp,sp,32
    80002b8e:	8082                	ret

0000000080002b90 <idup>:
{
    80002b90:	1101                	addi	sp,sp,-32
    80002b92:	ec06                	sd	ra,24(sp)
    80002b94:	e822                	sd	s0,16(sp)
    80002b96:	e426                	sd	s1,8(sp)
    80002b98:	1000                	addi	s0,sp,32
    80002b9a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002b9c:	00035517          	auipc	a0,0x35
    80002ba0:	9dc50513          	addi	a0,a0,-1572 # 80037578 <itable>
    80002ba4:	00003097          	auipc	ra,0x3
    80002ba8:	5d4080e7          	jalr	1492(ra) # 80006178 <acquire>
  ip->ref++;
    80002bac:	449c                	lw	a5,8(s1)
    80002bae:	2785                	addiw	a5,a5,1
    80002bb0:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002bb2:	00035517          	auipc	a0,0x35
    80002bb6:	9c650513          	addi	a0,a0,-1594 # 80037578 <itable>
    80002bba:	00003097          	auipc	ra,0x3
    80002bbe:	672080e7          	jalr	1650(ra) # 8000622c <release>
}
    80002bc2:	8526                	mv	a0,s1
    80002bc4:	60e2                	ld	ra,24(sp)
    80002bc6:	6442                	ld	s0,16(sp)
    80002bc8:	64a2                	ld	s1,8(sp)
    80002bca:	6105                	addi	sp,sp,32
    80002bcc:	8082                	ret

0000000080002bce <ilock>:
{
    80002bce:	1101                	addi	sp,sp,-32
    80002bd0:	ec06                	sd	ra,24(sp)
    80002bd2:	e822                	sd	s0,16(sp)
    80002bd4:	e426                	sd	s1,8(sp)
    80002bd6:	e04a                	sd	s2,0(sp)
    80002bd8:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002bda:	c115                	beqz	a0,80002bfe <ilock+0x30>
    80002bdc:	84aa                	mv	s1,a0
    80002bde:	451c                	lw	a5,8(a0)
    80002be0:	00f05f63          	blez	a5,80002bfe <ilock+0x30>
  acquiresleep(&ip->lock);
    80002be4:	0541                	addi	a0,a0,16
    80002be6:	00001097          	auipc	ra,0x1
    80002bea:	cb8080e7          	jalr	-840(ra) # 8000389e <acquiresleep>
  if(ip->valid == 0){
    80002bee:	40bc                	lw	a5,64(s1)
    80002bf0:	cf99                	beqz	a5,80002c0e <ilock+0x40>
}
    80002bf2:	60e2                	ld	ra,24(sp)
    80002bf4:	6442                	ld	s0,16(sp)
    80002bf6:	64a2                	ld	s1,8(sp)
    80002bf8:	6902                	ld	s2,0(sp)
    80002bfa:	6105                	addi	sp,sp,32
    80002bfc:	8082                	ret
    panic("ilock");
    80002bfe:	00006517          	auipc	a0,0x6
    80002c02:	94a50513          	addi	a0,a0,-1718 # 80008548 <syscalls+0x180>
    80002c06:	00003097          	auipc	ra,0x3
    80002c0a:	03a080e7          	jalr	58(ra) # 80005c40 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c0e:	40dc                	lw	a5,4(s1)
    80002c10:	0047d79b          	srliw	a5,a5,0x4
    80002c14:	00035597          	auipc	a1,0x35
    80002c18:	95c5a583          	lw	a1,-1700(a1) # 80037570 <sb+0x18>
    80002c1c:	9dbd                	addw	a1,a1,a5
    80002c1e:	4088                	lw	a0,0(s1)
    80002c20:	fffff097          	auipc	ra,0xfffff
    80002c24:	7ac080e7          	jalr	1964(ra) # 800023cc <bread>
    80002c28:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c2a:	05850593          	addi	a1,a0,88
    80002c2e:	40dc                	lw	a5,4(s1)
    80002c30:	8bbd                	andi	a5,a5,15
    80002c32:	079a                	slli	a5,a5,0x6
    80002c34:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002c36:	00059783          	lh	a5,0(a1)
    80002c3a:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c3e:	00259783          	lh	a5,2(a1)
    80002c42:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c46:	00459783          	lh	a5,4(a1)
    80002c4a:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002c4e:	00659783          	lh	a5,6(a1)
    80002c52:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002c56:	459c                	lw	a5,8(a1)
    80002c58:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002c5a:	03400613          	li	a2,52
    80002c5e:	05b1                	addi	a1,a1,12
    80002c60:	05048513          	addi	a0,s1,80
    80002c64:	ffffd097          	auipc	ra,0xffffd
    80002c68:	682080e7          	jalr	1666(ra) # 800002e6 <memmove>
    brelse(bp);
    80002c6c:	854a                	mv	a0,s2
    80002c6e:	00000097          	auipc	ra,0x0
    80002c72:	88e080e7          	jalr	-1906(ra) # 800024fc <brelse>
    ip->valid = 1;
    80002c76:	4785                	li	a5,1
    80002c78:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002c7a:	04449783          	lh	a5,68(s1)
    80002c7e:	fbb5                	bnez	a5,80002bf2 <ilock+0x24>
      panic("ilock: no type");
    80002c80:	00006517          	auipc	a0,0x6
    80002c84:	8d050513          	addi	a0,a0,-1840 # 80008550 <syscalls+0x188>
    80002c88:	00003097          	auipc	ra,0x3
    80002c8c:	fb8080e7          	jalr	-72(ra) # 80005c40 <panic>

0000000080002c90 <iunlock>:
{
    80002c90:	1101                	addi	sp,sp,-32
    80002c92:	ec06                	sd	ra,24(sp)
    80002c94:	e822                	sd	s0,16(sp)
    80002c96:	e426                	sd	s1,8(sp)
    80002c98:	e04a                	sd	s2,0(sp)
    80002c9a:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002c9c:	c905                	beqz	a0,80002ccc <iunlock+0x3c>
    80002c9e:	84aa                	mv	s1,a0
    80002ca0:	01050913          	addi	s2,a0,16
    80002ca4:	854a                	mv	a0,s2
    80002ca6:	00001097          	auipc	ra,0x1
    80002caa:	c92080e7          	jalr	-878(ra) # 80003938 <holdingsleep>
    80002cae:	cd19                	beqz	a0,80002ccc <iunlock+0x3c>
    80002cb0:	449c                	lw	a5,8(s1)
    80002cb2:	00f05d63          	blez	a5,80002ccc <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002cb6:	854a                	mv	a0,s2
    80002cb8:	00001097          	auipc	ra,0x1
    80002cbc:	c3c080e7          	jalr	-964(ra) # 800038f4 <releasesleep>
}
    80002cc0:	60e2                	ld	ra,24(sp)
    80002cc2:	6442                	ld	s0,16(sp)
    80002cc4:	64a2                	ld	s1,8(sp)
    80002cc6:	6902                	ld	s2,0(sp)
    80002cc8:	6105                	addi	sp,sp,32
    80002cca:	8082                	ret
    panic("iunlock");
    80002ccc:	00006517          	auipc	a0,0x6
    80002cd0:	89450513          	addi	a0,a0,-1900 # 80008560 <syscalls+0x198>
    80002cd4:	00003097          	auipc	ra,0x3
    80002cd8:	f6c080e7          	jalr	-148(ra) # 80005c40 <panic>

0000000080002cdc <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002cdc:	7179                	addi	sp,sp,-48
    80002cde:	f406                	sd	ra,40(sp)
    80002ce0:	f022                	sd	s0,32(sp)
    80002ce2:	ec26                	sd	s1,24(sp)
    80002ce4:	e84a                	sd	s2,16(sp)
    80002ce6:	e44e                	sd	s3,8(sp)
    80002ce8:	e052                	sd	s4,0(sp)
    80002cea:	1800                	addi	s0,sp,48
    80002cec:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002cee:	05050493          	addi	s1,a0,80
    80002cf2:	08050913          	addi	s2,a0,128
    80002cf6:	a021                	j	80002cfe <itrunc+0x22>
    80002cf8:	0491                	addi	s1,s1,4
    80002cfa:	01248d63          	beq	s1,s2,80002d14 <itrunc+0x38>
    if(ip->addrs[i]){
    80002cfe:	408c                	lw	a1,0(s1)
    80002d00:	dde5                	beqz	a1,80002cf8 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002d02:	0009a503          	lw	a0,0(s3)
    80002d06:	00000097          	auipc	ra,0x0
    80002d0a:	90c080e7          	jalr	-1780(ra) # 80002612 <bfree>
      ip->addrs[i] = 0;
    80002d0e:	0004a023          	sw	zero,0(s1)
    80002d12:	b7dd                	j	80002cf8 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002d14:	0809a583          	lw	a1,128(s3)
    80002d18:	e185                	bnez	a1,80002d38 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002d1a:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002d1e:	854e                	mv	a0,s3
    80002d20:	00000097          	auipc	ra,0x0
    80002d24:	de2080e7          	jalr	-542(ra) # 80002b02 <iupdate>
}
    80002d28:	70a2                	ld	ra,40(sp)
    80002d2a:	7402                	ld	s0,32(sp)
    80002d2c:	64e2                	ld	s1,24(sp)
    80002d2e:	6942                	ld	s2,16(sp)
    80002d30:	69a2                	ld	s3,8(sp)
    80002d32:	6a02                	ld	s4,0(sp)
    80002d34:	6145                	addi	sp,sp,48
    80002d36:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d38:	0009a503          	lw	a0,0(s3)
    80002d3c:	fffff097          	auipc	ra,0xfffff
    80002d40:	690080e7          	jalr	1680(ra) # 800023cc <bread>
    80002d44:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002d46:	05850493          	addi	s1,a0,88
    80002d4a:	45850913          	addi	s2,a0,1112
    80002d4e:	a021                	j	80002d56 <itrunc+0x7a>
    80002d50:	0491                	addi	s1,s1,4
    80002d52:	01248b63          	beq	s1,s2,80002d68 <itrunc+0x8c>
      if(a[j])
    80002d56:	408c                	lw	a1,0(s1)
    80002d58:	dde5                	beqz	a1,80002d50 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002d5a:	0009a503          	lw	a0,0(s3)
    80002d5e:	00000097          	auipc	ra,0x0
    80002d62:	8b4080e7          	jalr	-1868(ra) # 80002612 <bfree>
    80002d66:	b7ed                	j	80002d50 <itrunc+0x74>
    brelse(bp);
    80002d68:	8552                	mv	a0,s4
    80002d6a:	fffff097          	auipc	ra,0xfffff
    80002d6e:	792080e7          	jalr	1938(ra) # 800024fc <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002d72:	0809a583          	lw	a1,128(s3)
    80002d76:	0009a503          	lw	a0,0(s3)
    80002d7a:	00000097          	auipc	ra,0x0
    80002d7e:	898080e7          	jalr	-1896(ra) # 80002612 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002d82:	0809a023          	sw	zero,128(s3)
    80002d86:	bf51                	j	80002d1a <itrunc+0x3e>

0000000080002d88 <iput>:
{
    80002d88:	1101                	addi	sp,sp,-32
    80002d8a:	ec06                	sd	ra,24(sp)
    80002d8c:	e822                	sd	s0,16(sp)
    80002d8e:	e426                	sd	s1,8(sp)
    80002d90:	e04a                	sd	s2,0(sp)
    80002d92:	1000                	addi	s0,sp,32
    80002d94:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d96:	00034517          	auipc	a0,0x34
    80002d9a:	7e250513          	addi	a0,a0,2018 # 80037578 <itable>
    80002d9e:	00003097          	auipc	ra,0x3
    80002da2:	3da080e7          	jalr	986(ra) # 80006178 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002da6:	4498                	lw	a4,8(s1)
    80002da8:	4785                	li	a5,1
    80002daa:	02f70363          	beq	a4,a5,80002dd0 <iput+0x48>
  ip->ref--;
    80002dae:	449c                	lw	a5,8(s1)
    80002db0:	37fd                	addiw	a5,a5,-1
    80002db2:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002db4:	00034517          	auipc	a0,0x34
    80002db8:	7c450513          	addi	a0,a0,1988 # 80037578 <itable>
    80002dbc:	00003097          	auipc	ra,0x3
    80002dc0:	470080e7          	jalr	1136(ra) # 8000622c <release>
}
    80002dc4:	60e2                	ld	ra,24(sp)
    80002dc6:	6442                	ld	s0,16(sp)
    80002dc8:	64a2                	ld	s1,8(sp)
    80002dca:	6902                	ld	s2,0(sp)
    80002dcc:	6105                	addi	sp,sp,32
    80002dce:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002dd0:	40bc                	lw	a5,64(s1)
    80002dd2:	dff1                	beqz	a5,80002dae <iput+0x26>
    80002dd4:	04a49783          	lh	a5,74(s1)
    80002dd8:	fbf9                	bnez	a5,80002dae <iput+0x26>
    acquiresleep(&ip->lock);
    80002dda:	01048913          	addi	s2,s1,16
    80002dde:	854a                	mv	a0,s2
    80002de0:	00001097          	auipc	ra,0x1
    80002de4:	abe080e7          	jalr	-1346(ra) # 8000389e <acquiresleep>
    release(&itable.lock);
    80002de8:	00034517          	auipc	a0,0x34
    80002dec:	79050513          	addi	a0,a0,1936 # 80037578 <itable>
    80002df0:	00003097          	auipc	ra,0x3
    80002df4:	43c080e7          	jalr	1084(ra) # 8000622c <release>
    itrunc(ip);
    80002df8:	8526                	mv	a0,s1
    80002dfa:	00000097          	auipc	ra,0x0
    80002dfe:	ee2080e7          	jalr	-286(ra) # 80002cdc <itrunc>
    ip->type = 0;
    80002e02:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002e06:	8526                	mv	a0,s1
    80002e08:	00000097          	auipc	ra,0x0
    80002e0c:	cfa080e7          	jalr	-774(ra) # 80002b02 <iupdate>
    ip->valid = 0;
    80002e10:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e14:	854a                	mv	a0,s2
    80002e16:	00001097          	auipc	ra,0x1
    80002e1a:	ade080e7          	jalr	-1314(ra) # 800038f4 <releasesleep>
    acquire(&itable.lock);
    80002e1e:	00034517          	auipc	a0,0x34
    80002e22:	75a50513          	addi	a0,a0,1882 # 80037578 <itable>
    80002e26:	00003097          	auipc	ra,0x3
    80002e2a:	352080e7          	jalr	850(ra) # 80006178 <acquire>
    80002e2e:	b741                	j	80002dae <iput+0x26>

0000000080002e30 <iunlockput>:
{
    80002e30:	1101                	addi	sp,sp,-32
    80002e32:	ec06                	sd	ra,24(sp)
    80002e34:	e822                	sd	s0,16(sp)
    80002e36:	e426                	sd	s1,8(sp)
    80002e38:	1000                	addi	s0,sp,32
    80002e3a:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e3c:	00000097          	auipc	ra,0x0
    80002e40:	e54080e7          	jalr	-428(ra) # 80002c90 <iunlock>
  iput(ip);
    80002e44:	8526                	mv	a0,s1
    80002e46:	00000097          	auipc	ra,0x0
    80002e4a:	f42080e7          	jalr	-190(ra) # 80002d88 <iput>
}
    80002e4e:	60e2                	ld	ra,24(sp)
    80002e50:	6442                	ld	s0,16(sp)
    80002e52:	64a2                	ld	s1,8(sp)
    80002e54:	6105                	addi	sp,sp,32
    80002e56:	8082                	ret

0000000080002e58 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002e58:	1141                	addi	sp,sp,-16
    80002e5a:	e422                	sd	s0,8(sp)
    80002e5c:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002e5e:	411c                	lw	a5,0(a0)
    80002e60:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002e62:	415c                	lw	a5,4(a0)
    80002e64:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002e66:	04451783          	lh	a5,68(a0)
    80002e6a:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002e6e:	04a51783          	lh	a5,74(a0)
    80002e72:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002e76:	04c56783          	lwu	a5,76(a0)
    80002e7a:	e99c                	sd	a5,16(a1)
}
    80002e7c:	6422                	ld	s0,8(sp)
    80002e7e:	0141                	addi	sp,sp,16
    80002e80:	8082                	ret

0000000080002e82 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e82:	457c                	lw	a5,76(a0)
    80002e84:	0ed7e963          	bltu	a5,a3,80002f76 <readi+0xf4>
{
    80002e88:	7159                	addi	sp,sp,-112
    80002e8a:	f486                	sd	ra,104(sp)
    80002e8c:	f0a2                	sd	s0,96(sp)
    80002e8e:	eca6                	sd	s1,88(sp)
    80002e90:	e8ca                	sd	s2,80(sp)
    80002e92:	e4ce                	sd	s3,72(sp)
    80002e94:	e0d2                	sd	s4,64(sp)
    80002e96:	fc56                	sd	s5,56(sp)
    80002e98:	f85a                	sd	s6,48(sp)
    80002e9a:	f45e                	sd	s7,40(sp)
    80002e9c:	f062                	sd	s8,32(sp)
    80002e9e:	ec66                	sd	s9,24(sp)
    80002ea0:	e86a                	sd	s10,16(sp)
    80002ea2:	e46e                	sd	s11,8(sp)
    80002ea4:	1880                	addi	s0,sp,112
    80002ea6:	8baa                	mv	s7,a0
    80002ea8:	8c2e                	mv	s8,a1
    80002eaa:	8ab2                	mv	s5,a2
    80002eac:	84b6                	mv	s1,a3
    80002eae:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002eb0:	9f35                	addw	a4,a4,a3
    return 0;
    80002eb2:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002eb4:	0ad76063          	bltu	a4,a3,80002f54 <readi+0xd2>
  if(off + n > ip->size)
    80002eb8:	00e7f463          	bgeu	a5,a4,80002ec0 <readi+0x3e>
    n = ip->size - off;
    80002ebc:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ec0:	0a0b0963          	beqz	s6,80002f72 <readi+0xf0>
    80002ec4:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ec6:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002eca:	5cfd                	li	s9,-1
    80002ecc:	a82d                	j	80002f06 <readi+0x84>
    80002ece:	020a1d93          	slli	s11,s4,0x20
    80002ed2:	020ddd93          	srli	s11,s11,0x20
    80002ed6:	05890613          	addi	a2,s2,88
    80002eda:	86ee                	mv	a3,s11
    80002edc:	963a                	add	a2,a2,a4
    80002ede:	85d6                	mv	a1,s5
    80002ee0:	8562                	mv	a0,s8
    80002ee2:	fffff097          	auipc	ra,0xfffff
    80002ee6:	b06080e7          	jalr	-1274(ra) # 800019e8 <either_copyout>
    80002eea:	05950d63          	beq	a0,s9,80002f44 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002eee:	854a                	mv	a0,s2
    80002ef0:	fffff097          	auipc	ra,0xfffff
    80002ef4:	60c080e7          	jalr	1548(ra) # 800024fc <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ef8:	013a09bb          	addw	s3,s4,s3
    80002efc:	009a04bb          	addw	s1,s4,s1
    80002f00:	9aee                	add	s5,s5,s11
    80002f02:	0569f763          	bgeu	s3,s6,80002f50 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002f06:	000ba903          	lw	s2,0(s7)
    80002f0a:	00a4d59b          	srliw	a1,s1,0xa
    80002f0e:	855e                	mv	a0,s7
    80002f10:	00000097          	auipc	ra,0x0
    80002f14:	8ac080e7          	jalr	-1876(ra) # 800027bc <bmap>
    80002f18:	0005059b          	sext.w	a1,a0
    80002f1c:	854a                	mv	a0,s2
    80002f1e:	fffff097          	auipc	ra,0xfffff
    80002f22:	4ae080e7          	jalr	1198(ra) # 800023cc <bread>
    80002f26:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f28:	3ff4f713          	andi	a4,s1,1023
    80002f2c:	40ed07bb          	subw	a5,s10,a4
    80002f30:	413b06bb          	subw	a3,s6,s3
    80002f34:	8a3e                	mv	s4,a5
    80002f36:	2781                	sext.w	a5,a5
    80002f38:	0006861b          	sext.w	a2,a3
    80002f3c:	f8f679e3          	bgeu	a2,a5,80002ece <readi+0x4c>
    80002f40:	8a36                	mv	s4,a3
    80002f42:	b771                	j	80002ece <readi+0x4c>
      brelse(bp);
    80002f44:	854a                	mv	a0,s2
    80002f46:	fffff097          	auipc	ra,0xfffff
    80002f4a:	5b6080e7          	jalr	1462(ra) # 800024fc <brelse>
      tot = -1;
    80002f4e:	59fd                	li	s3,-1
  }
  return tot;
    80002f50:	0009851b          	sext.w	a0,s3
}
    80002f54:	70a6                	ld	ra,104(sp)
    80002f56:	7406                	ld	s0,96(sp)
    80002f58:	64e6                	ld	s1,88(sp)
    80002f5a:	6946                	ld	s2,80(sp)
    80002f5c:	69a6                	ld	s3,72(sp)
    80002f5e:	6a06                	ld	s4,64(sp)
    80002f60:	7ae2                	ld	s5,56(sp)
    80002f62:	7b42                	ld	s6,48(sp)
    80002f64:	7ba2                	ld	s7,40(sp)
    80002f66:	7c02                	ld	s8,32(sp)
    80002f68:	6ce2                	ld	s9,24(sp)
    80002f6a:	6d42                	ld	s10,16(sp)
    80002f6c:	6da2                	ld	s11,8(sp)
    80002f6e:	6165                	addi	sp,sp,112
    80002f70:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f72:	89da                	mv	s3,s6
    80002f74:	bff1                	j	80002f50 <readi+0xce>
    return 0;
    80002f76:	4501                	li	a0,0
}
    80002f78:	8082                	ret

0000000080002f7a <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f7a:	457c                	lw	a5,76(a0)
    80002f7c:	10d7e863          	bltu	a5,a3,8000308c <writei+0x112>
{
    80002f80:	7159                	addi	sp,sp,-112
    80002f82:	f486                	sd	ra,104(sp)
    80002f84:	f0a2                	sd	s0,96(sp)
    80002f86:	eca6                	sd	s1,88(sp)
    80002f88:	e8ca                	sd	s2,80(sp)
    80002f8a:	e4ce                	sd	s3,72(sp)
    80002f8c:	e0d2                	sd	s4,64(sp)
    80002f8e:	fc56                	sd	s5,56(sp)
    80002f90:	f85a                	sd	s6,48(sp)
    80002f92:	f45e                	sd	s7,40(sp)
    80002f94:	f062                	sd	s8,32(sp)
    80002f96:	ec66                	sd	s9,24(sp)
    80002f98:	e86a                	sd	s10,16(sp)
    80002f9a:	e46e                	sd	s11,8(sp)
    80002f9c:	1880                	addi	s0,sp,112
    80002f9e:	8b2a                	mv	s6,a0
    80002fa0:	8c2e                	mv	s8,a1
    80002fa2:	8ab2                	mv	s5,a2
    80002fa4:	8936                	mv	s2,a3
    80002fa6:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80002fa8:	00e687bb          	addw	a5,a3,a4
    80002fac:	0ed7e263          	bltu	a5,a3,80003090 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002fb0:	00043737          	lui	a4,0x43
    80002fb4:	0ef76063          	bltu	a4,a5,80003094 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fb8:	0c0b8863          	beqz	s7,80003088 <writei+0x10e>
    80002fbc:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fbe:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002fc2:	5cfd                	li	s9,-1
    80002fc4:	a091                	j	80003008 <writei+0x8e>
    80002fc6:	02099d93          	slli	s11,s3,0x20
    80002fca:	020ddd93          	srli	s11,s11,0x20
    80002fce:	05848513          	addi	a0,s1,88
    80002fd2:	86ee                	mv	a3,s11
    80002fd4:	8656                	mv	a2,s5
    80002fd6:	85e2                	mv	a1,s8
    80002fd8:	953a                	add	a0,a0,a4
    80002fda:	fffff097          	auipc	ra,0xfffff
    80002fde:	a64080e7          	jalr	-1436(ra) # 80001a3e <either_copyin>
    80002fe2:	07950263          	beq	a0,s9,80003046 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002fe6:	8526                	mv	a0,s1
    80002fe8:	00000097          	auipc	ra,0x0
    80002fec:	798080e7          	jalr	1944(ra) # 80003780 <log_write>
    brelse(bp);
    80002ff0:	8526                	mv	a0,s1
    80002ff2:	fffff097          	auipc	ra,0xfffff
    80002ff6:	50a080e7          	jalr	1290(ra) # 800024fc <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002ffa:	01498a3b          	addw	s4,s3,s4
    80002ffe:	0129893b          	addw	s2,s3,s2
    80003002:	9aee                	add	s5,s5,s11
    80003004:	057a7663          	bgeu	s4,s7,80003050 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003008:	000b2483          	lw	s1,0(s6)
    8000300c:	00a9559b          	srliw	a1,s2,0xa
    80003010:	855a                	mv	a0,s6
    80003012:	fffff097          	auipc	ra,0xfffff
    80003016:	7aa080e7          	jalr	1962(ra) # 800027bc <bmap>
    8000301a:	0005059b          	sext.w	a1,a0
    8000301e:	8526                	mv	a0,s1
    80003020:	fffff097          	auipc	ra,0xfffff
    80003024:	3ac080e7          	jalr	940(ra) # 800023cc <bread>
    80003028:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000302a:	3ff97713          	andi	a4,s2,1023
    8000302e:	40ed07bb          	subw	a5,s10,a4
    80003032:	414b86bb          	subw	a3,s7,s4
    80003036:	89be                	mv	s3,a5
    80003038:	2781                	sext.w	a5,a5
    8000303a:	0006861b          	sext.w	a2,a3
    8000303e:	f8f674e3          	bgeu	a2,a5,80002fc6 <writei+0x4c>
    80003042:	89b6                	mv	s3,a3
    80003044:	b749                	j	80002fc6 <writei+0x4c>
      brelse(bp);
    80003046:	8526                	mv	a0,s1
    80003048:	fffff097          	auipc	ra,0xfffff
    8000304c:	4b4080e7          	jalr	1204(ra) # 800024fc <brelse>
  }

  if(off > ip->size)
    80003050:	04cb2783          	lw	a5,76(s6)
    80003054:	0127f463          	bgeu	a5,s2,8000305c <writei+0xe2>
    ip->size = off;
    80003058:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000305c:	855a                	mv	a0,s6
    8000305e:	00000097          	auipc	ra,0x0
    80003062:	aa4080e7          	jalr	-1372(ra) # 80002b02 <iupdate>

  return tot;
    80003066:	000a051b          	sext.w	a0,s4
}
    8000306a:	70a6                	ld	ra,104(sp)
    8000306c:	7406                	ld	s0,96(sp)
    8000306e:	64e6                	ld	s1,88(sp)
    80003070:	6946                	ld	s2,80(sp)
    80003072:	69a6                	ld	s3,72(sp)
    80003074:	6a06                	ld	s4,64(sp)
    80003076:	7ae2                	ld	s5,56(sp)
    80003078:	7b42                	ld	s6,48(sp)
    8000307a:	7ba2                	ld	s7,40(sp)
    8000307c:	7c02                	ld	s8,32(sp)
    8000307e:	6ce2                	ld	s9,24(sp)
    80003080:	6d42                	ld	s10,16(sp)
    80003082:	6da2                	ld	s11,8(sp)
    80003084:	6165                	addi	sp,sp,112
    80003086:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003088:	8a5e                	mv	s4,s7
    8000308a:	bfc9                	j	8000305c <writei+0xe2>
    return -1;
    8000308c:	557d                	li	a0,-1
}
    8000308e:	8082                	ret
    return -1;
    80003090:	557d                	li	a0,-1
    80003092:	bfe1                	j	8000306a <writei+0xf0>
    return -1;
    80003094:	557d                	li	a0,-1
    80003096:	bfd1                	j	8000306a <writei+0xf0>

0000000080003098 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003098:	1141                	addi	sp,sp,-16
    8000309a:	e406                	sd	ra,8(sp)
    8000309c:	e022                	sd	s0,0(sp)
    8000309e:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800030a0:	4639                	li	a2,14
    800030a2:	ffffd097          	auipc	ra,0xffffd
    800030a6:	2b8080e7          	jalr	696(ra) # 8000035a <strncmp>
}
    800030aa:	60a2                	ld	ra,8(sp)
    800030ac:	6402                	ld	s0,0(sp)
    800030ae:	0141                	addi	sp,sp,16
    800030b0:	8082                	ret

00000000800030b2 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800030b2:	7139                	addi	sp,sp,-64
    800030b4:	fc06                	sd	ra,56(sp)
    800030b6:	f822                	sd	s0,48(sp)
    800030b8:	f426                	sd	s1,40(sp)
    800030ba:	f04a                	sd	s2,32(sp)
    800030bc:	ec4e                	sd	s3,24(sp)
    800030be:	e852                	sd	s4,16(sp)
    800030c0:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800030c2:	04451703          	lh	a4,68(a0)
    800030c6:	4785                	li	a5,1
    800030c8:	00f71a63          	bne	a4,a5,800030dc <dirlookup+0x2a>
    800030cc:	892a                	mv	s2,a0
    800030ce:	89ae                	mv	s3,a1
    800030d0:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800030d2:	457c                	lw	a5,76(a0)
    800030d4:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800030d6:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030d8:	e79d                	bnez	a5,80003106 <dirlookup+0x54>
    800030da:	a8a5                	j	80003152 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800030dc:	00005517          	auipc	a0,0x5
    800030e0:	48c50513          	addi	a0,a0,1164 # 80008568 <syscalls+0x1a0>
    800030e4:	00003097          	auipc	ra,0x3
    800030e8:	b5c080e7          	jalr	-1188(ra) # 80005c40 <panic>
      panic("dirlookup read");
    800030ec:	00005517          	auipc	a0,0x5
    800030f0:	49450513          	addi	a0,a0,1172 # 80008580 <syscalls+0x1b8>
    800030f4:	00003097          	auipc	ra,0x3
    800030f8:	b4c080e7          	jalr	-1204(ra) # 80005c40 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030fc:	24c1                	addiw	s1,s1,16
    800030fe:	04c92783          	lw	a5,76(s2)
    80003102:	04f4f763          	bgeu	s1,a5,80003150 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003106:	4741                	li	a4,16
    80003108:	86a6                	mv	a3,s1
    8000310a:	fc040613          	addi	a2,s0,-64
    8000310e:	4581                	li	a1,0
    80003110:	854a                	mv	a0,s2
    80003112:	00000097          	auipc	ra,0x0
    80003116:	d70080e7          	jalr	-656(ra) # 80002e82 <readi>
    8000311a:	47c1                	li	a5,16
    8000311c:	fcf518e3          	bne	a0,a5,800030ec <dirlookup+0x3a>
    if(de.inum == 0)
    80003120:	fc045783          	lhu	a5,-64(s0)
    80003124:	dfe1                	beqz	a5,800030fc <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003126:	fc240593          	addi	a1,s0,-62
    8000312a:	854e                	mv	a0,s3
    8000312c:	00000097          	auipc	ra,0x0
    80003130:	f6c080e7          	jalr	-148(ra) # 80003098 <namecmp>
    80003134:	f561                	bnez	a0,800030fc <dirlookup+0x4a>
      if(poff)
    80003136:	000a0463          	beqz	s4,8000313e <dirlookup+0x8c>
        *poff = off;
    8000313a:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000313e:	fc045583          	lhu	a1,-64(s0)
    80003142:	00092503          	lw	a0,0(s2)
    80003146:	fffff097          	auipc	ra,0xfffff
    8000314a:	752080e7          	jalr	1874(ra) # 80002898 <iget>
    8000314e:	a011                	j	80003152 <dirlookup+0xa0>
  return 0;
    80003150:	4501                	li	a0,0
}
    80003152:	70e2                	ld	ra,56(sp)
    80003154:	7442                	ld	s0,48(sp)
    80003156:	74a2                	ld	s1,40(sp)
    80003158:	7902                	ld	s2,32(sp)
    8000315a:	69e2                	ld	s3,24(sp)
    8000315c:	6a42                	ld	s4,16(sp)
    8000315e:	6121                	addi	sp,sp,64
    80003160:	8082                	ret

0000000080003162 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003162:	711d                	addi	sp,sp,-96
    80003164:	ec86                	sd	ra,88(sp)
    80003166:	e8a2                	sd	s0,80(sp)
    80003168:	e4a6                	sd	s1,72(sp)
    8000316a:	e0ca                	sd	s2,64(sp)
    8000316c:	fc4e                	sd	s3,56(sp)
    8000316e:	f852                	sd	s4,48(sp)
    80003170:	f456                	sd	s5,40(sp)
    80003172:	f05a                	sd	s6,32(sp)
    80003174:	ec5e                	sd	s7,24(sp)
    80003176:	e862                	sd	s8,16(sp)
    80003178:	e466                	sd	s9,8(sp)
    8000317a:	e06a                	sd	s10,0(sp)
    8000317c:	1080                	addi	s0,sp,96
    8000317e:	84aa                	mv	s1,a0
    80003180:	8b2e                	mv	s6,a1
    80003182:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003184:	00054703          	lbu	a4,0(a0)
    80003188:	02f00793          	li	a5,47
    8000318c:	02f70363          	beq	a4,a5,800031b2 <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003190:	ffffe097          	auipc	ra,0xffffe
    80003194:	df0080e7          	jalr	-528(ra) # 80000f80 <myproc>
    80003198:	15053503          	ld	a0,336(a0)
    8000319c:	00000097          	auipc	ra,0x0
    800031a0:	9f4080e7          	jalr	-1548(ra) # 80002b90 <idup>
    800031a4:	8a2a                	mv	s4,a0
  while(*path == '/')
    800031a6:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800031aa:	4cb5                	li	s9,13
  len = path - s;
    800031ac:	4b81                	li	s7,0

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800031ae:	4c05                	li	s8,1
    800031b0:	a87d                	j	8000326e <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    800031b2:	4585                	li	a1,1
    800031b4:	4505                	li	a0,1
    800031b6:	fffff097          	auipc	ra,0xfffff
    800031ba:	6e2080e7          	jalr	1762(ra) # 80002898 <iget>
    800031be:	8a2a                	mv	s4,a0
    800031c0:	b7dd                	j	800031a6 <namex+0x44>
      iunlockput(ip);
    800031c2:	8552                	mv	a0,s4
    800031c4:	00000097          	auipc	ra,0x0
    800031c8:	c6c080e7          	jalr	-916(ra) # 80002e30 <iunlockput>
      return 0;
    800031cc:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800031ce:	8552                	mv	a0,s4
    800031d0:	60e6                	ld	ra,88(sp)
    800031d2:	6446                	ld	s0,80(sp)
    800031d4:	64a6                	ld	s1,72(sp)
    800031d6:	6906                	ld	s2,64(sp)
    800031d8:	79e2                	ld	s3,56(sp)
    800031da:	7a42                	ld	s4,48(sp)
    800031dc:	7aa2                	ld	s5,40(sp)
    800031de:	7b02                	ld	s6,32(sp)
    800031e0:	6be2                	ld	s7,24(sp)
    800031e2:	6c42                	ld	s8,16(sp)
    800031e4:	6ca2                	ld	s9,8(sp)
    800031e6:	6d02                	ld	s10,0(sp)
    800031e8:	6125                	addi	sp,sp,96
    800031ea:	8082                	ret
      iunlock(ip);
    800031ec:	8552                	mv	a0,s4
    800031ee:	00000097          	auipc	ra,0x0
    800031f2:	aa2080e7          	jalr	-1374(ra) # 80002c90 <iunlock>
      return ip;
    800031f6:	bfe1                	j	800031ce <namex+0x6c>
      iunlockput(ip);
    800031f8:	8552                	mv	a0,s4
    800031fa:	00000097          	auipc	ra,0x0
    800031fe:	c36080e7          	jalr	-970(ra) # 80002e30 <iunlockput>
      return 0;
    80003202:	8a4e                	mv	s4,s3
    80003204:	b7e9                	j	800031ce <namex+0x6c>
  len = path - s;
    80003206:	40998633          	sub	a2,s3,s1
    8000320a:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    8000320e:	09acd863          	bge	s9,s10,8000329e <namex+0x13c>
    memmove(name, s, DIRSIZ);
    80003212:	4639                	li	a2,14
    80003214:	85a6                	mv	a1,s1
    80003216:	8556                	mv	a0,s5
    80003218:	ffffd097          	auipc	ra,0xffffd
    8000321c:	0ce080e7          	jalr	206(ra) # 800002e6 <memmove>
    80003220:	84ce                	mv	s1,s3
  while(*path == '/')
    80003222:	0004c783          	lbu	a5,0(s1)
    80003226:	01279763          	bne	a5,s2,80003234 <namex+0xd2>
    path++;
    8000322a:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000322c:	0004c783          	lbu	a5,0(s1)
    80003230:	ff278de3          	beq	a5,s2,8000322a <namex+0xc8>
    ilock(ip);
    80003234:	8552                	mv	a0,s4
    80003236:	00000097          	auipc	ra,0x0
    8000323a:	998080e7          	jalr	-1640(ra) # 80002bce <ilock>
    if(ip->type != T_DIR){
    8000323e:	044a1783          	lh	a5,68(s4)
    80003242:	f98790e3          	bne	a5,s8,800031c2 <namex+0x60>
    if(nameiparent && *path == '\0'){
    80003246:	000b0563          	beqz	s6,80003250 <namex+0xee>
    8000324a:	0004c783          	lbu	a5,0(s1)
    8000324e:	dfd9                	beqz	a5,800031ec <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003250:	865e                	mv	a2,s7
    80003252:	85d6                	mv	a1,s5
    80003254:	8552                	mv	a0,s4
    80003256:	00000097          	auipc	ra,0x0
    8000325a:	e5c080e7          	jalr	-420(ra) # 800030b2 <dirlookup>
    8000325e:	89aa                	mv	s3,a0
    80003260:	dd41                	beqz	a0,800031f8 <namex+0x96>
    iunlockput(ip);
    80003262:	8552                	mv	a0,s4
    80003264:	00000097          	auipc	ra,0x0
    80003268:	bcc080e7          	jalr	-1076(ra) # 80002e30 <iunlockput>
    ip = next;
    8000326c:	8a4e                	mv	s4,s3
  while(*path == '/')
    8000326e:	0004c783          	lbu	a5,0(s1)
    80003272:	01279763          	bne	a5,s2,80003280 <namex+0x11e>
    path++;
    80003276:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003278:	0004c783          	lbu	a5,0(s1)
    8000327c:	ff278de3          	beq	a5,s2,80003276 <namex+0x114>
  if(*path == 0)
    80003280:	cb9d                	beqz	a5,800032b6 <namex+0x154>
  while(*path != '/' && *path != 0)
    80003282:	0004c783          	lbu	a5,0(s1)
    80003286:	89a6                	mv	s3,s1
  len = path - s;
    80003288:	8d5e                	mv	s10,s7
    8000328a:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    8000328c:	01278963          	beq	a5,s2,8000329e <namex+0x13c>
    80003290:	dbbd                	beqz	a5,80003206 <namex+0xa4>
    path++;
    80003292:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003294:	0009c783          	lbu	a5,0(s3)
    80003298:	ff279ce3          	bne	a5,s2,80003290 <namex+0x12e>
    8000329c:	b7ad                	j	80003206 <namex+0xa4>
    memmove(name, s, len);
    8000329e:	2601                	sext.w	a2,a2
    800032a0:	85a6                	mv	a1,s1
    800032a2:	8556                	mv	a0,s5
    800032a4:	ffffd097          	auipc	ra,0xffffd
    800032a8:	042080e7          	jalr	66(ra) # 800002e6 <memmove>
    name[len] = 0;
    800032ac:	9d56                	add	s10,s10,s5
    800032ae:	000d0023          	sb	zero,0(s10)
    800032b2:	84ce                	mv	s1,s3
    800032b4:	b7bd                	j	80003222 <namex+0xc0>
  if(nameiparent){
    800032b6:	f00b0ce3          	beqz	s6,800031ce <namex+0x6c>
    iput(ip);
    800032ba:	8552                	mv	a0,s4
    800032bc:	00000097          	auipc	ra,0x0
    800032c0:	acc080e7          	jalr	-1332(ra) # 80002d88 <iput>
    return 0;
    800032c4:	4a01                	li	s4,0
    800032c6:	b721                	j	800031ce <namex+0x6c>

00000000800032c8 <dirlink>:
{
    800032c8:	7139                	addi	sp,sp,-64
    800032ca:	fc06                	sd	ra,56(sp)
    800032cc:	f822                	sd	s0,48(sp)
    800032ce:	f426                	sd	s1,40(sp)
    800032d0:	f04a                	sd	s2,32(sp)
    800032d2:	ec4e                	sd	s3,24(sp)
    800032d4:	e852                	sd	s4,16(sp)
    800032d6:	0080                	addi	s0,sp,64
    800032d8:	892a                	mv	s2,a0
    800032da:	8a2e                	mv	s4,a1
    800032dc:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800032de:	4601                	li	a2,0
    800032e0:	00000097          	auipc	ra,0x0
    800032e4:	dd2080e7          	jalr	-558(ra) # 800030b2 <dirlookup>
    800032e8:	e93d                	bnez	a0,8000335e <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032ea:	04c92483          	lw	s1,76(s2)
    800032ee:	c49d                	beqz	s1,8000331c <dirlink+0x54>
    800032f0:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032f2:	4741                	li	a4,16
    800032f4:	86a6                	mv	a3,s1
    800032f6:	fc040613          	addi	a2,s0,-64
    800032fa:	4581                	li	a1,0
    800032fc:	854a                	mv	a0,s2
    800032fe:	00000097          	auipc	ra,0x0
    80003302:	b84080e7          	jalr	-1148(ra) # 80002e82 <readi>
    80003306:	47c1                	li	a5,16
    80003308:	06f51163          	bne	a0,a5,8000336a <dirlink+0xa2>
    if(de.inum == 0)
    8000330c:	fc045783          	lhu	a5,-64(s0)
    80003310:	c791                	beqz	a5,8000331c <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003312:	24c1                	addiw	s1,s1,16
    80003314:	04c92783          	lw	a5,76(s2)
    80003318:	fcf4ede3          	bltu	s1,a5,800032f2 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000331c:	4639                	li	a2,14
    8000331e:	85d2                	mv	a1,s4
    80003320:	fc240513          	addi	a0,s0,-62
    80003324:	ffffd097          	auipc	ra,0xffffd
    80003328:	072080e7          	jalr	114(ra) # 80000396 <strncpy>
  de.inum = inum;
    8000332c:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003330:	4741                	li	a4,16
    80003332:	86a6                	mv	a3,s1
    80003334:	fc040613          	addi	a2,s0,-64
    80003338:	4581                	li	a1,0
    8000333a:	854a                	mv	a0,s2
    8000333c:	00000097          	auipc	ra,0x0
    80003340:	c3e080e7          	jalr	-962(ra) # 80002f7a <writei>
    80003344:	872a                	mv	a4,a0
    80003346:	47c1                	li	a5,16
  return 0;
    80003348:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000334a:	02f71863          	bne	a4,a5,8000337a <dirlink+0xb2>
}
    8000334e:	70e2                	ld	ra,56(sp)
    80003350:	7442                	ld	s0,48(sp)
    80003352:	74a2                	ld	s1,40(sp)
    80003354:	7902                	ld	s2,32(sp)
    80003356:	69e2                	ld	s3,24(sp)
    80003358:	6a42                	ld	s4,16(sp)
    8000335a:	6121                	addi	sp,sp,64
    8000335c:	8082                	ret
    iput(ip);
    8000335e:	00000097          	auipc	ra,0x0
    80003362:	a2a080e7          	jalr	-1494(ra) # 80002d88 <iput>
    return -1;
    80003366:	557d                	li	a0,-1
    80003368:	b7dd                	j	8000334e <dirlink+0x86>
      panic("dirlink read");
    8000336a:	00005517          	auipc	a0,0x5
    8000336e:	22650513          	addi	a0,a0,550 # 80008590 <syscalls+0x1c8>
    80003372:	00003097          	auipc	ra,0x3
    80003376:	8ce080e7          	jalr	-1842(ra) # 80005c40 <panic>
    panic("dirlink");
    8000337a:	00005517          	auipc	a0,0x5
    8000337e:	32650513          	addi	a0,a0,806 # 800086a0 <syscalls+0x2d8>
    80003382:	00003097          	auipc	ra,0x3
    80003386:	8be080e7          	jalr	-1858(ra) # 80005c40 <panic>

000000008000338a <namei>:

struct inode*
namei(char *path)
{
    8000338a:	1101                	addi	sp,sp,-32
    8000338c:	ec06                	sd	ra,24(sp)
    8000338e:	e822                	sd	s0,16(sp)
    80003390:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003392:	fe040613          	addi	a2,s0,-32
    80003396:	4581                	li	a1,0
    80003398:	00000097          	auipc	ra,0x0
    8000339c:	dca080e7          	jalr	-566(ra) # 80003162 <namex>
}
    800033a0:	60e2                	ld	ra,24(sp)
    800033a2:	6442                	ld	s0,16(sp)
    800033a4:	6105                	addi	sp,sp,32
    800033a6:	8082                	ret

00000000800033a8 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800033a8:	1141                	addi	sp,sp,-16
    800033aa:	e406                	sd	ra,8(sp)
    800033ac:	e022                	sd	s0,0(sp)
    800033ae:	0800                	addi	s0,sp,16
    800033b0:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800033b2:	4585                	li	a1,1
    800033b4:	00000097          	auipc	ra,0x0
    800033b8:	dae080e7          	jalr	-594(ra) # 80003162 <namex>
}
    800033bc:	60a2                	ld	ra,8(sp)
    800033be:	6402                	ld	s0,0(sp)
    800033c0:	0141                	addi	sp,sp,16
    800033c2:	8082                	ret

00000000800033c4 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800033c4:	1101                	addi	sp,sp,-32
    800033c6:	ec06                	sd	ra,24(sp)
    800033c8:	e822                	sd	s0,16(sp)
    800033ca:	e426                	sd	s1,8(sp)
    800033cc:	e04a                	sd	s2,0(sp)
    800033ce:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800033d0:	00036917          	auipc	s2,0x36
    800033d4:	c5090913          	addi	s2,s2,-944 # 80039020 <log>
    800033d8:	01892583          	lw	a1,24(s2)
    800033dc:	02892503          	lw	a0,40(s2)
    800033e0:	fffff097          	auipc	ra,0xfffff
    800033e4:	fec080e7          	jalr	-20(ra) # 800023cc <bread>
    800033e8:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800033ea:	02c92683          	lw	a3,44(s2)
    800033ee:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800033f0:	02d05863          	blez	a3,80003420 <write_head+0x5c>
    800033f4:	00036797          	auipc	a5,0x36
    800033f8:	c5c78793          	addi	a5,a5,-932 # 80039050 <log+0x30>
    800033fc:	05c50713          	addi	a4,a0,92
    80003400:	36fd                	addiw	a3,a3,-1
    80003402:	02069613          	slli	a2,a3,0x20
    80003406:	01e65693          	srli	a3,a2,0x1e
    8000340a:	00036617          	auipc	a2,0x36
    8000340e:	c4a60613          	addi	a2,a2,-950 # 80039054 <log+0x34>
    80003412:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003414:	4390                	lw	a2,0(a5)
    80003416:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003418:	0791                	addi	a5,a5,4
    8000341a:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    8000341c:	fed79ce3          	bne	a5,a3,80003414 <write_head+0x50>
  }
  bwrite(buf);
    80003420:	8526                	mv	a0,s1
    80003422:	fffff097          	auipc	ra,0xfffff
    80003426:	09c080e7          	jalr	156(ra) # 800024be <bwrite>
  brelse(buf);
    8000342a:	8526                	mv	a0,s1
    8000342c:	fffff097          	auipc	ra,0xfffff
    80003430:	0d0080e7          	jalr	208(ra) # 800024fc <brelse>
}
    80003434:	60e2                	ld	ra,24(sp)
    80003436:	6442                	ld	s0,16(sp)
    80003438:	64a2                	ld	s1,8(sp)
    8000343a:	6902                	ld	s2,0(sp)
    8000343c:	6105                	addi	sp,sp,32
    8000343e:	8082                	ret

0000000080003440 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003440:	00036797          	auipc	a5,0x36
    80003444:	c0c7a783          	lw	a5,-1012(a5) # 8003904c <log+0x2c>
    80003448:	0af05d63          	blez	a5,80003502 <install_trans+0xc2>
{
    8000344c:	7139                	addi	sp,sp,-64
    8000344e:	fc06                	sd	ra,56(sp)
    80003450:	f822                	sd	s0,48(sp)
    80003452:	f426                	sd	s1,40(sp)
    80003454:	f04a                	sd	s2,32(sp)
    80003456:	ec4e                	sd	s3,24(sp)
    80003458:	e852                	sd	s4,16(sp)
    8000345a:	e456                	sd	s5,8(sp)
    8000345c:	e05a                	sd	s6,0(sp)
    8000345e:	0080                	addi	s0,sp,64
    80003460:	8b2a                	mv	s6,a0
    80003462:	00036a97          	auipc	s5,0x36
    80003466:	beea8a93          	addi	s5,s5,-1042 # 80039050 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000346a:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000346c:	00036997          	auipc	s3,0x36
    80003470:	bb498993          	addi	s3,s3,-1100 # 80039020 <log>
    80003474:	a00d                	j	80003496 <install_trans+0x56>
    brelse(lbuf);
    80003476:	854a                	mv	a0,s2
    80003478:	fffff097          	auipc	ra,0xfffff
    8000347c:	084080e7          	jalr	132(ra) # 800024fc <brelse>
    brelse(dbuf);
    80003480:	8526                	mv	a0,s1
    80003482:	fffff097          	auipc	ra,0xfffff
    80003486:	07a080e7          	jalr	122(ra) # 800024fc <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000348a:	2a05                	addiw	s4,s4,1
    8000348c:	0a91                	addi	s5,s5,4
    8000348e:	02c9a783          	lw	a5,44(s3)
    80003492:	04fa5e63          	bge	s4,a5,800034ee <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003496:	0189a583          	lw	a1,24(s3)
    8000349a:	014585bb          	addw	a1,a1,s4
    8000349e:	2585                	addiw	a1,a1,1
    800034a0:	0289a503          	lw	a0,40(s3)
    800034a4:	fffff097          	auipc	ra,0xfffff
    800034a8:	f28080e7          	jalr	-216(ra) # 800023cc <bread>
    800034ac:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800034ae:	000aa583          	lw	a1,0(s5)
    800034b2:	0289a503          	lw	a0,40(s3)
    800034b6:	fffff097          	auipc	ra,0xfffff
    800034ba:	f16080e7          	jalr	-234(ra) # 800023cc <bread>
    800034be:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800034c0:	40000613          	li	a2,1024
    800034c4:	05890593          	addi	a1,s2,88
    800034c8:	05850513          	addi	a0,a0,88
    800034cc:	ffffd097          	auipc	ra,0xffffd
    800034d0:	e1a080e7          	jalr	-486(ra) # 800002e6 <memmove>
    bwrite(dbuf);  // write dst to disk
    800034d4:	8526                	mv	a0,s1
    800034d6:	fffff097          	auipc	ra,0xfffff
    800034da:	fe8080e7          	jalr	-24(ra) # 800024be <bwrite>
    if(recovering == 0)
    800034de:	f80b1ce3          	bnez	s6,80003476 <install_trans+0x36>
      bunpin(dbuf);
    800034e2:	8526                	mv	a0,s1
    800034e4:	fffff097          	auipc	ra,0xfffff
    800034e8:	0f2080e7          	jalr	242(ra) # 800025d6 <bunpin>
    800034ec:	b769                	j	80003476 <install_trans+0x36>
}
    800034ee:	70e2                	ld	ra,56(sp)
    800034f0:	7442                	ld	s0,48(sp)
    800034f2:	74a2                	ld	s1,40(sp)
    800034f4:	7902                	ld	s2,32(sp)
    800034f6:	69e2                	ld	s3,24(sp)
    800034f8:	6a42                	ld	s4,16(sp)
    800034fa:	6aa2                	ld	s5,8(sp)
    800034fc:	6b02                	ld	s6,0(sp)
    800034fe:	6121                	addi	sp,sp,64
    80003500:	8082                	ret
    80003502:	8082                	ret

0000000080003504 <initlog>:
{
    80003504:	7179                	addi	sp,sp,-48
    80003506:	f406                	sd	ra,40(sp)
    80003508:	f022                	sd	s0,32(sp)
    8000350a:	ec26                	sd	s1,24(sp)
    8000350c:	e84a                	sd	s2,16(sp)
    8000350e:	e44e                	sd	s3,8(sp)
    80003510:	1800                	addi	s0,sp,48
    80003512:	892a                	mv	s2,a0
    80003514:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003516:	00036497          	auipc	s1,0x36
    8000351a:	b0a48493          	addi	s1,s1,-1270 # 80039020 <log>
    8000351e:	00005597          	auipc	a1,0x5
    80003522:	08258593          	addi	a1,a1,130 # 800085a0 <syscalls+0x1d8>
    80003526:	8526                	mv	a0,s1
    80003528:	00003097          	auipc	ra,0x3
    8000352c:	bc0080e7          	jalr	-1088(ra) # 800060e8 <initlock>
  log.start = sb->logstart;
    80003530:	0149a583          	lw	a1,20(s3)
    80003534:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003536:	0109a783          	lw	a5,16(s3)
    8000353a:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000353c:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003540:	854a                	mv	a0,s2
    80003542:	fffff097          	auipc	ra,0xfffff
    80003546:	e8a080e7          	jalr	-374(ra) # 800023cc <bread>
  log.lh.n = lh->n;
    8000354a:	4d34                	lw	a3,88(a0)
    8000354c:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000354e:	02d05663          	blez	a3,8000357a <initlog+0x76>
    80003552:	05c50793          	addi	a5,a0,92
    80003556:	00036717          	auipc	a4,0x36
    8000355a:	afa70713          	addi	a4,a4,-1286 # 80039050 <log+0x30>
    8000355e:	36fd                	addiw	a3,a3,-1
    80003560:	02069613          	slli	a2,a3,0x20
    80003564:	01e65693          	srli	a3,a2,0x1e
    80003568:	06050613          	addi	a2,a0,96
    8000356c:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    8000356e:	4390                	lw	a2,0(a5)
    80003570:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003572:	0791                	addi	a5,a5,4
    80003574:	0711                	addi	a4,a4,4
    80003576:	fed79ce3          	bne	a5,a3,8000356e <initlog+0x6a>
  brelse(buf);
    8000357a:	fffff097          	auipc	ra,0xfffff
    8000357e:	f82080e7          	jalr	-126(ra) # 800024fc <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003582:	4505                	li	a0,1
    80003584:	00000097          	auipc	ra,0x0
    80003588:	ebc080e7          	jalr	-324(ra) # 80003440 <install_trans>
  log.lh.n = 0;
    8000358c:	00036797          	auipc	a5,0x36
    80003590:	ac07a023          	sw	zero,-1344(a5) # 8003904c <log+0x2c>
  write_head(); // clear the log
    80003594:	00000097          	auipc	ra,0x0
    80003598:	e30080e7          	jalr	-464(ra) # 800033c4 <write_head>
}
    8000359c:	70a2                	ld	ra,40(sp)
    8000359e:	7402                	ld	s0,32(sp)
    800035a0:	64e2                	ld	s1,24(sp)
    800035a2:	6942                	ld	s2,16(sp)
    800035a4:	69a2                	ld	s3,8(sp)
    800035a6:	6145                	addi	sp,sp,48
    800035a8:	8082                	ret

00000000800035aa <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800035aa:	1101                	addi	sp,sp,-32
    800035ac:	ec06                	sd	ra,24(sp)
    800035ae:	e822                	sd	s0,16(sp)
    800035b0:	e426                	sd	s1,8(sp)
    800035b2:	e04a                	sd	s2,0(sp)
    800035b4:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800035b6:	00036517          	auipc	a0,0x36
    800035ba:	a6a50513          	addi	a0,a0,-1430 # 80039020 <log>
    800035be:	00003097          	auipc	ra,0x3
    800035c2:	bba080e7          	jalr	-1094(ra) # 80006178 <acquire>
  while(1){
    if(log.committing){
    800035c6:	00036497          	auipc	s1,0x36
    800035ca:	a5a48493          	addi	s1,s1,-1446 # 80039020 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035ce:	4979                	li	s2,30
    800035d0:	a039                	j	800035de <begin_op+0x34>
      sleep(&log, &log.lock);
    800035d2:	85a6                	mv	a1,s1
    800035d4:	8526                	mv	a0,s1
    800035d6:	ffffe097          	auipc	ra,0xffffe
    800035da:	06e080e7          	jalr	110(ra) # 80001644 <sleep>
    if(log.committing){
    800035de:	50dc                	lw	a5,36(s1)
    800035e0:	fbed                	bnez	a5,800035d2 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035e2:	5098                	lw	a4,32(s1)
    800035e4:	2705                	addiw	a4,a4,1
    800035e6:	0007069b          	sext.w	a3,a4
    800035ea:	0027179b          	slliw	a5,a4,0x2
    800035ee:	9fb9                	addw	a5,a5,a4
    800035f0:	0017979b          	slliw	a5,a5,0x1
    800035f4:	54d8                	lw	a4,44(s1)
    800035f6:	9fb9                	addw	a5,a5,a4
    800035f8:	00f95963          	bge	s2,a5,8000360a <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800035fc:	85a6                	mv	a1,s1
    800035fe:	8526                	mv	a0,s1
    80003600:	ffffe097          	auipc	ra,0xffffe
    80003604:	044080e7          	jalr	68(ra) # 80001644 <sleep>
    80003608:	bfd9                	j	800035de <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000360a:	00036517          	auipc	a0,0x36
    8000360e:	a1650513          	addi	a0,a0,-1514 # 80039020 <log>
    80003612:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003614:	00003097          	auipc	ra,0x3
    80003618:	c18080e7          	jalr	-1000(ra) # 8000622c <release>
      break;
    }
  }
}
    8000361c:	60e2                	ld	ra,24(sp)
    8000361e:	6442                	ld	s0,16(sp)
    80003620:	64a2                	ld	s1,8(sp)
    80003622:	6902                	ld	s2,0(sp)
    80003624:	6105                	addi	sp,sp,32
    80003626:	8082                	ret

0000000080003628 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003628:	7139                	addi	sp,sp,-64
    8000362a:	fc06                	sd	ra,56(sp)
    8000362c:	f822                	sd	s0,48(sp)
    8000362e:	f426                	sd	s1,40(sp)
    80003630:	f04a                	sd	s2,32(sp)
    80003632:	ec4e                	sd	s3,24(sp)
    80003634:	e852                	sd	s4,16(sp)
    80003636:	e456                	sd	s5,8(sp)
    80003638:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000363a:	00036497          	auipc	s1,0x36
    8000363e:	9e648493          	addi	s1,s1,-1562 # 80039020 <log>
    80003642:	8526                	mv	a0,s1
    80003644:	00003097          	auipc	ra,0x3
    80003648:	b34080e7          	jalr	-1228(ra) # 80006178 <acquire>
  log.outstanding -= 1;
    8000364c:	509c                	lw	a5,32(s1)
    8000364e:	37fd                	addiw	a5,a5,-1
    80003650:	0007891b          	sext.w	s2,a5
    80003654:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003656:	50dc                	lw	a5,36(s1)
    80003658:	e7b9                	bnez	a5,800036a6 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000365a:	04091e63          	bnez	s2,800036b6 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    8000365e:	00036497          	auipc	s1,0x36
    80003662:	9c248493          	addi	s1,s1,-1598 # 80039020 <log>
    80003666:	4785                	li	a5,1
    80003668:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000366a:	8526                	mv	a0,s1
    8000366c:	00003097          	auipc	ra,0x3
    80003670:	bc0080e7          	jalr	-1088(ra) # 8000622c <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003674:	54dc                	lw	a5,44(s1)
    80003676:	06f04763          	bgtz	a5,800036e4 <end_op+0xbc>
    acquire(&log.lock);
    8000367a:	00036497          	auipc	s1,0x36
    8000367e:	9a648493          	addi	s1,s1,-1626 # 80039020 <log>
    80003682:	8526                	mv	a0,s1
    80003684:	00003097          	auipc	ra,0x3
    80003688:	af4080e7          	jalr	-1292(ra) # 80006178 <acquire>
    log.committing = 0;
    8000368c:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003690:	8526                	mv	a0,s1
    80003692:	ffffe097          	auipc	ra,0xffffe
    80003696:	13e080e7          	jalr	318(ra) # 800017d0 <wakeup>
    release(&log.lock);
    8000369a:	8526                	mv	a0,s1
    8000369c:	00003097          	auipc	ra,0x3
    800036a0:	b90080e7          	jalr	-1136(ra) # 8000622c <release>
}
    800036a4:	a03d                	j	800036d2 <end_op+0xaa>
    panic("log.committing");
    800036a6:	00005517          	auipc	a0,0x5
    800036aa:	f0250513          	addi	a0,a0,-254 # 800085a8 <syscalls+0x1e0>
    800036ae:	00002097          	auipc	ra,0x2
    800036b2:	592080e7          	jalr	1426(ra) # 80005c40 <panic>
    wakeup(&log);
    800036b6:	00036497          	auipc	s1,0x36
    800036ba:	96a48493          	addi	s1,s1,-1686 # 80039020 <log>
    800036be:	8526                	mv	a0,s1
    800036c0:	ffffe097          	auipc	ra,0xffffe
    800036c4:	110080e7          	jalr	272(ra) # 800017d0 <wakeup>
  release(&log.lock);
    800036c8:	8526                	mv	a0,s1
    800036ca:	00003097          	auipc	ra,0x3
    800036ce:	b62080e7          	jalr	-1182(ra) # 8000622c <release>
}
    800036d2:	70e2                	ld	ra,56(sp)
    800036d4:	7442                	ld	s0,48(sp)
    800036d6:	74a2                	ld	s1,40(sp)
    800036d8:	7902                	ld	s2,32(sp)
    800036da:	69e2                	ld	s3,24(sp)
    800036dc:	6a42                	ld	s4,16(sp)
    800036de:	6aa2                	ld	s5,8(sp)
    800036e0:	6121                	addi	sp,sp,64
    800036e2:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800036e4:	00036a97          	auipc	s5,0x36
    800036e8:	96ca8a93          	addi	s5,s5,-1684 # 80039050 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800036ec:	00036a17          	auipc	s4,0x36
    800036f0:	934a0a13          	addi	s4,s4,-1740 # 80039020 <log>
    800036f4:	018a2583          	lw	a1,24(s4)
    800036f8:	012585bb          	addw	a1,a1,s2
    800036fc:	2585                	addiw	a1,a1,1
    800036fe:	028a2503          	lw	a0,40(s4)
    80003702:	fffff097          	auipc	ra,0xfffff
    80003706:	cca080e7          	jalr	-822(ra) # 800023cc <bread>
    8000370a:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000370c:	000aa583          	lw	a1,0(s5)
    80003710:	028a2503          	lw	a0,40(s4)
    80003714:	fffff097          	auipc	ra,0xfffff
    80003718:	cb8080e7          	jalr	-840(ra) # 800023cc <bread>
    8000371c:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000371e:	40000613          	li	a2,1024
    80003722:	05850593          	addi	a1,a0,88
    80003726:	05848513          	addi	a0,s1,88
    8000372a:	ffffd097          	auipc	ra,0xffffd
    8000372e:	bbc080e7          	jalr	-1092(ra) # 800002e6 <memmove>
    bwrite(to);  // write the log
    80003732:	8526                	mv	a0,s1
    80003734:	fffff097          	auipc	ra,0xfffff
    80003738:	d8a080e7          	jalr	-630(ra) # 800024be <bwrite>
    brelse(from);
    8000373c:	854e                	mv	a0,s3
    8000373e:	fffff097          	auipc	ra,0xfffff
    80003742:	dbe080e7          	jalr	-578(ra) # 800024fc <brelse>
    brelse(to);
    80003746:	8526                	mv	a0,s1
    80003748:	fffff097          	auipc	ra,0xfffff
    8000374c:	db4080e7          	jalr	-588(ra) # 800024fc <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003750:	2905                	addiw	s2,s2,1
    80003752:	0a91                	addi	s5,s5,4
    80003754:	02ca2783          	lw	a5,44(s4)
    80003758:	f8f94ee3          	blt	s2,a5,800036f4 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000375c:	00000097          	auipc	ra,0x0
    80003760:	c68080e7          	jalr	-920(ra) # 800033c4 <write_head>
    install_trans(0); // Now install writes to home locations
    80003764:	4501                	li	a0,0
    80003766:	00000097          	auipc	ra,0x0
    8000376a:	cda080e7          	jalr	-806(ra) # 80003440 <install_trans>
    log.lh.n = 0;
    8000376e:	00036797          	auipc	a5,0x36
    80003772:	8c07af23          	sw	zero,-1826(a5) # 8003904c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003776:	00000097          	auipc	ra,0x0
    8000377a:	c4e080e7          	jalr	-946(ra) # 800033c4 <write_head>
    8000377e:	bdf5                	j	8000367a <end_op+0x52>

0000000080003780 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003780:	1101                	addi	sp,sp,-32
    80003782:	ec06                	sd	ra,24(sp)
    80003784:	e822                	sd	s0,16(sp)
    80003786:	e426                	sd	s1,8(sp)
    80003788:	e04a                	sd	s2,0(sp)
    8000378a:	1000                	addi	s0,sp,32
    8000378c:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000378e:	00036917          	auipc	s2,0x36
    80003792:	89290913          	addi	s2,s2,-1902 # 80039020 <log>
    80003796:	854a                	mv	a0,s2
    80003798:	00003097          	auipc	ra,0x3
    8000379c:	9e0080e7          	jalr	-1568(ra) # 80006178 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800037a0:	02c92603          	lw	a2,44(s2)
    800037a4:	47f5                	li	a5,29
    800037a6:	06c7c563          	blt	a5,a2,80003810 <log_write+0x90>
    800037aa:	00036797          	auipc	a5,0x36
    800037ae:	8927a783          	lw	a5,-1902(a5) # 8003903c <log+0x1c>
    800037b2:	37fd                	addiw	a5,a5,-1
    800037b4:	04f65e63          	bge	a2,a5,80003810 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800037b8:	00036797          	auipc	a5,0x36
    800037bc:	8887a783          	lw	a5,-1912(a5) # 80039040 <log+0x20>
    800037c0:	06f05063          	blez	a5,80003820 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800037c4:	4781                	li	a5,0
    800037c6:	06c05563          	blez	a2,80003830 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037ca:	44cc                	lw	a1,12(s1)
    800037cc:	00036717          	auipc	a4,0x36
    800037d0:	88470713          	addi	a4,a4,-1916 # 80039050 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800037d4:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037d6:	4314                	lw	a3,0(a4)
    800037d8:	04b68c63          	beq	a3,a1,80003830 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800037dc:	2785                	addiw	a5,a5,1
    800037de:	0711                	addi	a4,a4,4
    800037e0:	fef61be3          	bne	a2,a5,800037d6 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800037e4:	0621                	addi	a2,a2,8
    800037e6:	060a                	slli	a2,a2,0x2
    800037e8:	00036797          	auipc	a5,0x36
    800037ec:	83878793          	addi	a5,a5,-1992 # 80039020 <log>
    800037f0:	97b2                	add	a5,a5,a2
    800037f2:	44d8                	lw	a4,12(s1)
    800037f4:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800037f6:	8526                	mv	a0,s1
    800037f8:	fffff097          	auipc	ra,0xfffff
    800037fc:	da2080e7          	jalr	-606(ra) # 8000259a <bpin>
    log.lh.n++;
    80003800:	00036717          	auipc	a4,0x36
    80003804:	82070713          	addi	a4,a4,-2016 # 80039020 <log>
    80003808:	575c                	lw	a5,44(a4)
    8000380a:	2785                	addiw	a5,a5,1
    8000380c:	d75c                	sw	a5,44(a4)
    8000380e:	a82d                	j	80003848 <log_write+0xc8>
    panic("too big a transaction");
    80003810:	00005517          	auipc	a0,0x5
    80003814:	da850513          	addi	a0,a0,-600 # 800085b8 <syscalls+0x1f0>
    80003818:	00002097          	auipc	ra,0x2
    8000381c:	428080e7          	jalr	1064(ra) # 80005c40 <panic>
    panic("log_write outside of trans");
    80003820:	00005517          	auipc	a0,0x5
    80003824:	db050513          	addi	a0,a0,-592 # 800085d0 <syscalls+0x208>
    80003828:	00002097          	auipc	ra,0x2
    8000382c:	418080e7          	jalr	1048(ra) # 80005c40 <panic>
  log.lh.block[i] = b->blockno;
    80003830:	00878693          	addi	a3,a5,8
    80003834:	068a                	slli	a3,a3,0x2
    80003836:	00035717          	auipc	a4,0x35
    8000383a:	7ea70713          	addi	a4,a4,2026 # 80039020 <log>
    8000383e:	9736                	add	a4,a4,a3
    80003840:	44d4                	lw	a3,12(s1)
    80003842:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003844:	faf609e3          	beq	a2,a5,800037f6 <log_write+0x76>
  }
  release(&log.lock);
    80003848:	00035517          	auipc	a0,0x35
    8000384c:	7d850513          	addi	a0,a0,2008 # 80039020 <log>
    80003850:	00003097          	auipc	ra,0x3
    80003854:	9dc080e7          	jalr	-1572(ra) # 8000622c <release>
}
    80003858:	60e2                	ld	ra,24(sp)
    8000385a:	6442                	ld	s0,16(sp)
    8000385c:	64a2                	ld	s1,8(sp)
    8000385e:	6902                	ld	s2,0(sp)
    80003860:	6105                	addi	sp,sp,32
    80003862:	8082                	ret

0000000080003864 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003864:	1101                	addi	sp,sp,-32
    80003866:	ec06                	sd	ra,24(sp)
    80003868:	e822                	sd	s0,16(sp)
    8000386a:	e426                	sd	s1,8(sp)
    8000386c:	e04a                	sd	s2,0(sp)
    8000386e:	1000                	addi	s0,sp,32
    80003870:	84aa                	mv	s1,a0
    80003872:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003874:	00005597          	auipc	a1,0x5
    80003878:	d7c58593          	addi	a1,a1,-644 # 800085f0 <syscalls+0x228>
    8000387c:	0521                	addi	a0,a0,8
    8000387e:	00003097          	auipc	ra,0x3
    80003882:	86a080e7          	jalr	-1942(ra) # 800060e8 <initlock>
  lk->name = name;
    80003886:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000388a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000388e:	0204a423          	sw	zero,40(s1)
}
    80003892:	60e2                	ld	ra,24(sp)
    80003894:	6442                	ld	s0,16(sp)
    80003896:	64a2                	ld	s1,8(sp)
    80003898:	6902                	ld	s2,0(sp)
    8000389a:	6105                	addi	sp,sp,32
    8000389c:	8082                	ret

000000008000389e <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000389e:	1101                	addi	sp,sp,-32
    800038a0:	ec06                	sd	ra,24(sp)
    800038a2:	e822                	sd	s0,16(sp)
    800038a4:	e426                	sd	s1,8(sp)
    800038a6:	e04a                	sd	s2,0(sp)
    800038a8:	1000                	addi	s0,sp,32
    800038aa:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038ac:	00850913          	addi	s2,a0,8
    800038b0:	854a                	mv	a0,s2
    800038b2:	00003097          	auipc	ra,0x3
    800038b6:	8c6080e7          	jalr	-1850(ra) # 80006178 <acquire>
  while (lk->locked) {
    800038ba:	409c                	lw	a5,0(s1)
    800038bc:	cb89                	beqz	a5,800038ce <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800038be:	85ca                	mv	a1,s2
    800038c0:	8526                	mv	a0,s1
    800038c2:	ffffe097          	auipc	ra,0xffffe
    800038c6:	d82080e7          	jalr	-638(ra) # 80001644 <sleep>
  while (lk->locked) {
    800038ca:	409c                	lw	a5,0(s1)
    800038cc:	fbed                	bnez	a5,800038be <acquiresleep+0x20>
  }
  lk->locked = 1;
    800038ce:	4785                	li	a5,1
    800038d0:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800038d2:	ffffd097          	auipc	ra,0xffffd
    800038d6:	6ae080e7          	jalr	1710(ra) # 80000f80 <myproc>
    800038da:	591c                	lw	a5,48(a0)
    800038dc:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800038de:	854a                	mv	a0,s2
    800038e0:	00003097          	auipc	ra,0x3
    800038e4:	94c080e7          	jalr	-1716(ra) # 8000622c <release>
}
    800038e8:	60e2                	ld	ra,24(sp)
    800038ea:	6442                	ld	s0,16(sp)
    800038ec:	64a2                	ld	s1,8(sp)
    800038ee:	6902                	ld	s2,0(sp)
    800038f0:	6105                	addi	sp,sp,32
    800038f2:	8082                	ret

00000000800038f4 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800038f4:	1101                	addi	sp,sp,-32
    800038f6:	ec06                	sd	ra,24(sp)
    800038f8:	e822                	sd	s0,16(sp)
    800038fa:	e426                	sd	s1,8(sp)
    800038fc:	e04a                	sd	s2,0(sp)
    800038fe:	1000                	addi	s0,sp,32
    80003900:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003902:	00850913          	addi	s2,a0,8
    80003906:	854a                	mv	a0,s2
    80003908:	00003097          	auipc	ra,0x3
    8000390c:	870080e7          	jalr	-1936(ra) # 80006178 <acquire>
  lk->locked = 0;
    80003910:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003914:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003918:	8526                	mv	a0,s1
    8000391a:	ffffe097          	auipc	ra,0xffffe
    8000391e:	eb6080e7          	jalr	-330(ra) # 800017d0 <wakeup>
  release(&lk->lk);
    80003922:	854a                	mv	a0,s2
    80003924:	00003097          	auipc	ra,0x3
    80003928:	908080e7          	jalr	-1784(ra) # 8000622c <release>
}
    8000392c:	60e2                	ld	ra,24(sp)
    8000392e:	6442                	ld	s0,16(sp)
    80003930:	64a2                	ld	s1,8(sp)
    80003932:	6902                	ld	s2,0(sp)
    80003934:	6105                	addi	sp,sp,32
    80003936:	8082                	ret

0000000080003938 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003938:	7179                	addi	sp,sp,-48
    8000393a:	f406                	sd	ra,40(sp)
    8000393c:	f022                	sd	s0,32(sp)
    8000393e:	ec26                	sd	s1,24(sp)
    80003940:	e84a                	sd	s2,16(sp)
    80003942:	e44e                	sd	s3,8(sp)
    80003944:	1800                	addi	s0,sp,48
    80003946:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003948:	00850913          	addi	s2,a0,8
    8000394c:	854a                	mv	a0,s2
    8000394e:	00003097          	auipc	ra,0x3
    80003952:	82a080e7          	jalr	-2006(ra) # 80006178 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003956:	409c                	lw	a5,0(s1)
    80003958:	ef99                	bnez	a5,80003976 <holdingsleep+0x3e>
    8000395a:	4481                	li	s1,0
  release(&lk->lk);
    8000395c:	854a                	mv	a0,s2
    8000395e:	00003097          	auipc	ra,0x3
    80003962:	8ce080e7          	jalr	-1842(ra) # 8000622c <release>
  return r;
}
    80003966:	8526                	mv	a0,s1
    80003968:	70a2                	ld	ra,40(sp)
    8000396a:	7402                	ld	s0,32(sp)
    8000396c:	64e2                	ld	s1,24(sp)
    8000396e:	6942                	ld	s2,16(sp)
    80003970:	69a2                	ld	s3,8(sp)
    80003972:	6145                	addi	sp,sp,48
    80003974:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003976:	0284a983          	lw	s3,40(s1)
    8000397a:	ffffd097          	auipc	ra,0xffffd
    8000397e:	606080e7          	jalr	1542(ra) # 80000f80 <myproc>
    80003982:	5904                	lw	s1,48(a0)
    80003984:	413484b3          	sub	s1,s1,s3
    80003988:	0014b493          	seqz	s1,s1
    8000398c:	bfc1                	j	8000395c <holdingsleep+0x24>

000000008000398e <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000398e:	1141                	addi	sp,sp,-16
    80003990:	e406                	sd	ra,8(sp)
    80003992:	e022                	sd	s0,0(sp)
    80003994:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003996:	00005597          	auipc	a1,0x5
    8000399a:	c6a58593          	addi	a1,a1,-918 # 80008600 <syscalls+0x238>
    8000399e:	00035517          	auipc	a0,0x35
    800039a2:	7ca50513          	addi	a0,a0,1994 # 80039168 <ftable>
    800039a6:	00002097          	auipc	ra,0x2
    800039aa:	742080e7          	jalr	1858(ra) # 800060e8 <initlock>
}
    800039ae:	60a2                	ld	ra,8(sp)
    800039b0:	6402                	ld	s0,0(sp)
    800039b2:	0141                	addi	sp,sp,16
    800039b4:	8082                	ret

00000000800039b6 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800039b6:	1101                	addi	sp,sp,-32
    800039b8:	ec06                	sd	ra,24(sp)
    800039ba:	e822                	sd	s0,16(sp)
    800039bc:	e426                	sd	s1,8(sp)
    800039be:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800039c0:	00035517          	auipc	a0,0x35
    800039c4:	7a850513          	addi	a0,a0,1960 # 80039168 <ftable>
    800039c8:	00002097          	auipc	ra,0x2
    800039cc:	7b0080e7          	jalr	1968(ra) # 80006178 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039d0:	00035497          	auipc	s1,0x35
    800039d4:	7b048493          	addi	s1,s1,1968 # 80039180 <ftable+0x18>
    800039d8:	00036717          	auipc	a4,0x36
    800039dc:	74870713          	addi	a4,a4,1864 # 8003a120 <ftable+0xfb8>
    if(f->ref == 0){
    800039e0:	40dc                	lw	a5,4(s1)
    800039e2:	cf99                	beqz	a5,80003a00 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039e4:	02848493          	addi	s1,s1,40
    800039e8:	fee49ce3          	bne	s1,a4,800039e0 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800039ec:	00035517          	auipc	a0,0x35
    800039f0:	77c50513          	addi	a0,a0,1916 # 80039168 <ftable>
    800039f4:	00003097          	auipc	ra,0x3
    800039f8:	838080e7          	jalr	-1992(ra) # 8000622c <release>
  return 0;
    800039fc:	4481                	li	s1,0
    800039fe:	a819                	j	80003a14 <filealloc+0x5e>
      f->ref = 1;
    80003a00:	4785                	li	a5,1
    80003a02:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003a04:	00035517          	auipc	a0,0x35
    80003a08:	76450513          	addi	a0,a0,1892 # 80039168 <ftable>
    80003a0c:	00003097          	auipc	ra,0x3
    80003a10:	820080e7          	jalr	-2016(ra) # 8000622c <release>
}
    80003a14:	8526                	mv	a0,s1
    80003a16:	60e2                	ld	ra,24(sp)
    80003a18:	6442                	ld	s0,16(sp)
    80003a1a:	64a2                	ld	s1,8(sp)
    80003a1c:	6105                	addi	sp,sp,32
    80003a1e:	8082                	ret

0000000080003a20 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003a20:	1101                	addi	sp,sp,-32
    80003a22:	ec06                	sd	ra,24(sp)
    80003a24:	e822                	sd	s0,16(sp)
    80003a26:	e426                	sd	s1,8(sp)
    80003a28:	1000                	addi	s0,sp,32
    80003a2a:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a2c:	00035517          	auipc	a0,0x35
    80003a30:	73c50513          	addi	a0,a0,1852 # 80039168 <ftable>
    80003a34:	00002097          	auipc	ra,0x2
    80003a38:	744080e7          	jalr	1860(ra) # 80006178 <acquire>
  if(f->ref < 1)
    80003a3c:	40dc                	lw	a5,4(s1)
    80003a3e:	02f05263          	blez	a5,80003a62 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a42:	2785                	addiw	a5,a5,1
    80003a44:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a46:	00035517          	auipc	a0,0x35
    80003a4a:	72250513          	addi	a0,a0,1826 # 80039168 <ftable>
    80003a4e:	00002097          	auipc	ra,0x2
    80003a52:	7de080e7          	jalr	2014(ra) # 8000622c <release>
  return f;
}
    80003a56:	8526                	mv	a0,s1
    80003a58:	60e2                	ld	ra,24(sp)
    80003a5a:	6442                	ld	s0,16(sp)
    80003a5c:	64a2                	ld	s1,8(sp)
    80003a5e:	6105                	addi	sp,sp,32
    80003a60:	8082                	ret
    panic("filedup");
    80003a62:	00005517          	auipc	a0,0x5
    80003a66:	ba650513          	addi	a0,a0,-1114 # 80008608 <syscalls+0x240>
    80003a6a:	00002097          	auipc	ra,0x2
    80003a6e:	1d6080e7          	jalr	470(ra) # 80005c40 <panic>

0000000080003a72 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003a72:	7139                	addi	sp,sp,-64
    80003a74:	fc06                	sd	ra,56(sp)
    80003a76:	f822                	sd	s0,48(sp)
    80003a78:	f426                	sd	s1,40(sp)
    80003a7a:	f04a                	sd	s2,32(sp)
    80003a7c:	ec4e                	sd	s3,24(sp)
    80003a7e:	e852                	sd	s4,16(sp)
    80003a80:	e456                	sd	s5,8(sp)
    80003a82:	0080                	addi	s0,sp,64
    80003a84:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003a86:	00035517          	auipc	a0,0x35
    80003a8a:	6e250513          	addi	a0,a0,1762 # 80039168 <ftable>
    80003a8e:	00002097          	auipc	ra,0x2
    80003a92:	6ea080e7          	jalr	1770(ra) # 80006178 <acquire>
  if(f->ref < 1)
    80003a96:	40dc                	lw	a5,4(s1)
    80003a98:	06f05163          	blez	a5,80003afa <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003a9c:	37fd                	addiw	a5,a5,-1
    80003a9e:	0007871b          	sext.w	a4,a5
    80003aa2:	c0dc                	sw	a5,4(s1)
    80003aa4:	06e04363          	bgtz	a4,80003b0a <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003aa8:	0004a903          	lw	s2,0(s1)
    80003aac:	0094ca83          	lbu	s5,9(s1)
    80003ab0:	0104ba03          	ld	s4,16(s1)
    80003ab4:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003ab8:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003abc:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003ac0:	00035517          	auipc	a0,0x35
    80003ac4:	6a850513          	addi	a0,a0,1704 # 80039168 <ftable>
    80003ac8:	00002097          	auipc	ra,0x2
    80003acc:	764080e7          	jalr	1892(ra) # 8000622c <release>

  if(ff.type == FD_PIPE){
    80003ad0:	4785                	li	a5,1
    80003ad2:	04f90d63          	beq	s2,a5,80003b2c <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003ad6:	3979                	addiw	s2,s2,-2
    80003ad8:	4785                	li	a5,1
    80003ada:	0527e063          	bltu	a5,s2,80003b1a <fileclose+0xa8>
    begin_op();
    80003ade:	00000097          	auipc	ra,0x0
    80003ae2:	acc080e7          	jalr	-1332(ra) # 800035aa <begin_op>
    iput(ff.ip);
    80003ae6:	854e                	mv	a0,s3
    80003ae8:	fffff097          	auipc	ra,0xfffff
    80003aec:	2a0080e7          	jalr	672(ra) # 80002d88 <iput>
    end_op();
    80003af0:	00000097          	auipc	ra,0x0
    80003af4:	b38080e7          	jalr	-1224(ra) # 80003628 <end_op>
    80003af8:	a00d                	j	80003b1a <fileclose+0xa8>
    panic("fileclose");
    80003afa:	00005517          	auipc	a0,0x5
    80003afe:	b1650513          	addi	a0,a0,-1258 # 80008610 <syscalls+0x248>
    80003b02:	00002097          	auipc	ra,0x2
    80003b06:	13e080e7          	jalr	318(ra) # 80005c40 <panic>
    release(&ftable.lock);
    80003b0a:	00035517          	auipc	a0,0x35
    80003b0e:	65e50513          	addi	a0,a0,1630 # 80039168 <ftable>
    80003b12:	00002097          	auipc	ra,0x2
    80003b16:	71a080e7          	jalr	1818(ra) # 8000622c <release>
  }
}
    80003b1a:	70e2                	ld	ra,56(sp)
    80003b1c:	7442                	ld	s0,48(sp)
    80003b1e:	74a2                	ld	s1,40(sp)
    80003b20:	7902                	ld	s2,32(sp)
    80003b22:	69e2                	ld	s3,24(sp)
    80003b24:	6a42                	ld	s4,16(sp)
    80003b26:	6aa2                	ld	s5,8(sp)
    80003b28:	6121                	addi	sp,sp,64
    80003b2a:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b2c:	85d6                	mv	a1,s5
    80003b2e:	8552                	mv	a0,s4
    80003b30:	00000097          	auipc	ra,0x0
    80003b34:	34c080e7          	jalr	844(ra) # 80003e7c <pipeclose>
    80003b38:	b7cd                	j	80003b1a <fileclose+0xa8>

0000000080003b3a <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003b3a:	715d                	addi	sp,sp,-80
    80003b3c:	e486                	sd	ra,72(sp)
    80003b3e:	e0a2                	sd	s0,64(sp)
    80003b40:	fc26                	sd	s1,56(sp)
    80003b42:	f84a                	sd	s2,48(sp)
    80003b44:	f44e                	sd	s3,40(sp)
    80003b46:	0880                	addi	s0,sp,80
    80003b48:	84aa                	mv	s1,a0
    80003b4a:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b4c:	ffffd097          	auipc	ra,0xffffd
    80003b50:	434080e7          	jalr	1076(ra) # 80000f80 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003b54:	409c                	lw	a5,0(s1)
    80003b56:	37f9                	addiw	a5,a5,-2
    80003b58:	4705                	li	a4,1
    80003b5a:	04f76763          	bltu	a4,a5,80003ba8 <filestat+0x6e>
    80003b5e:	892a                	mv	s2,a0
    ilock(f->ip);
    80003b60:	6c88                	ld	a0,24(s1)
    80003b62:	fffff097          	auipc	ra,0xfffff
    80003b66:	06c080e7          	jalr	108(ra) # 80002bce <ilock>
    stati(f->ip, &st);
    80003b6a:	fb840593          	addi	a1,s0,-72
    80003b6e:	6c88                	ld	a0,24(s1)
    80003b70:	fffff097          	auipc	ra,0xfffff
    80003b74:	2e8080e7          	jalr	744(ra) # 80002e58 <stati>
    iunlock(f->ip);
    80003b78:	6c88                	ld	a0,24(s1)
    80003b7a:	fffff097          	auipc	ra,0xfffff
    80003b7e:	116080e7          	jalr	278(ra) # 80002c90 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003b82:	46e1                	li	a3,24
    80003b84:	fb840613          	addi	a2,s0,-72
    80003b88:	85ce                	mv	a1,s3
    80003b8a:	05093503          	ld	a0,80(s2)
    80003b8e:	ffffd097          	auipc	ra,0xffffd
    80003b92:	086080e7          	jalr	134(ra) # 80000c14 <copyout>
    80003b96:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003b9a:	60a6                	ld	ra,72(sp)
    80003b9c:	6406                	ld	s0,64(sp)
    80003b9e:	74e2                	ld	s1,56(sp)
    80003ba0:	7942                	ld	s2,48(sp)
    80003ba2:	79a2                	ld	s3,40(sp)
    80003ba4:	6161                	addi	sp,sp,80
    80003ba6:	8082                	ret
  return -1;
    80003ba8:	557d                	li	a0,-1
    80003baa:	bfc5                	j	80003b9a <filestat+0x60>

0000000080003bac <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003bac:	7179                	addi	sp,sp,-48
    80003bae:	f406                	sd	ra,40(sp)
    80003bb0:	f022                	sd	s0,32(sp)
    80003bb2:	ec26                	sd	s1,24(sp)
    80003bb4:	e84a                	sd	s2,16(sp)
    80003bb6:	e44e                	sd	s3,8(sp)
    80003bb8:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003bba:	00854783          	lbu	a5,8(a0)
    80003bbe:	c3d5                	beqz	a5,80003c62 <fileread+0xb6>
    80003bc0:	84aa                	mv	s1,a0
    80003bc2:	89ae                	mv	s3,a1
    80003bc4:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003bc6:	411c                	lw	a5,0(a0)
    80003bc8:	4705                	li	a4,1
    80003bca:	04e78963          	beq	a5,a4,80003c1c <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003bce:	470d                	li	a4,3
    80003bd0:	04e78d63          	beq	a5,a4,80003c2a <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003bd4:	4709                	li	a4,2
    80003bd6:	06e79e63          	bne	a5,a4,80003c52 <fileread+0xa6>
    ilock(f->ip);
    80003bda:	6d08                	ld	a0,24(a0)
    80003bdc:	fffff097          	auipc	ra,0xfffff
    80003be0:	ff2080e7          	jalr	-14(ra) # 80002bce <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003be4:	874a                	mv	a4,s2
    80003be6:	5094                	lw	a3,32(s1)
    80003be8:	864e                	mv	a2,s3
    80003bea:	4585                	li	a1,1
    80003bec:	6c88                	ld	a0,24(s1)
    80003bee:	fffff097          	auipc	ra,0xfffff
    80003bf2:	294080e7          	jalr	660(ra) # 80002e82 <readi>
    80003bf6:	892a                	mv	s2,a0
    80003bf8:	00a05563          	blez	a0,80003c02 <fileread+0x56>
      f->off += r;
    80003bfc:	509c                	lw	a5,32(s1)
    80003bfe:	9fa9                	addw	a5,a5,a0
    80003c00:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003c02:	6c88                	ld	a0,24(s1)
    80003c04:	fffff097          	auipc	ra,0xfffff
    80003c08:	08c080e7          	jalr	140(ra) # 80002c90 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003c0c:	854a                	mv	a0,s2
    80003c0e:	70a2                	ld	ra,40(sp)
    80003c10:	7402                	ld	s0,32(sp)
    80003c12:	64e2                	ld	s1,24(sp)
    80003c14:	6942                	ld	s2,16(sp)
    80003c16:	69a2                	ld	s3,8(sp)
    80003c18:	6145                	addi	sp,sp,48
    80003c1a:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c1c:	6908                	ld	a0,16(a0)
    80003c1e:	00000097          	auipc	ra,0x0
    80003c22:	3c0080e7          	jalr	960(ra) # 80003fde <piperead>
    80003c26:	892a                	mv	s2,a0
    80003c28:	b7d5                	j	80003c0c <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003c2a:	02451783          	lh	a5,36(a0)
    80003c2e:	03079693          	slli	a3,a5,0x30
    80003c32:	92c1                	srli	a3,a3,0x30
    80003c34:	4725                	li	a4,9
    80003c36:	02d76863          	bltu	a4,a3,80003c66 <fileread+0xba>
    80003c3a:	0792                	slli	a5,a5,0x4
    80003c3c:	00035717          	auipc	a4,0x35
    80003c40:	48c70713          	addi	a4,a4,1164 # 800390c8 <devsw>
    80003c44:	97ba                	add	a5,a5,a4
    80003c46:	639c                	ld	a5,0(a5)
    80003c48:	c38d                	beqz	a5,80003c6a <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003c4a:	4505                	li	a0,1
    80003c4c:	9782                	jalr	a5
    80003c4e:	892a                	mv	s2,a0
    80003c50:	bf75                	j	80003c0c <fileread+0x60>
    panic("fileread");
    80003c52:	00005517          	auipc	a0,0x5
    80003c56:	9ce50513          	addi	a0,a0,-1586 # 80008620 <syscalls+0x258>
    80003c5a:	00002097          	auipc	ra,0x2
    80003c5e:	fe6080e7          	jalr	-26(ra) # 80005c40 <panic>
    return -1;
    80003c62:	597d                	li	s2,-1
    80003c64:	b765                	j	80003c0c <fileread+0x60>
      return -1;
    80003c66:	597d                	li	s2,-1
    80003c68:	b755                	j	80003c0c <fileread+0x60>
    80003c6a:	597d                	li	s2,-1
    80003c6c:	b745                	j	80003c0c <fileread+0x60>

0000000080003c6e <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003c6e:	715d                	addi	sp,sp,-80
    80003c70:	e486                	sd	ra,72(sp)
    80003c72:	e0a2                	sd	s0,64(sp)
    80003c74:	fc26                	sd	s1,56(sp)
    80003c76:	f84a                	sd	s2,48(sp)
    80003c78:	f44e                	sd	s3,40(sp)
    80003c7a:	f052                	sd	s4,32(sp)
    80003c7c:	ec56                	sd	s5,24(sp)
    80003c7e:	e85a                	sd	s6,16(sp)
    80003c80:	e45e                	sd	s7,8(sp)
    80003c82:	e062                	sd	s8,0(sp)
    80003c84:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003c86:	00954783          	lbu	a5,9(a0)
    80003c8a:	10078663          	beqz	a5,80003d96 <filewrite+0x128>
    80003c8e:	892a                	mv	s2,a0
    80003c90:	8b2e                	mv	s6,a1
    80003c92:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c94:	411c                	lw	a5,0(a0)
    80003c96:	4705                	li	a4,1
    80003c98:	02e78263          	beq	a5,a4,80003cbc <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c9c:	470d                	li	a4,3
    80003c9e:	02e78663          	beq	a5,a4,80003cca <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003ca2:	4709                	li	a4,2
    80003ca4:	0ee79163          	bne	a5,a4,80003d86 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003ca8:	0ac05d63          	blez	a2,80003d62 <filewrite+0xf4>
    int i = 0;
    80003cac:	4981                	li	s3,0
    80003cae:	6b85                	lui	s7,0x1
    80003cb0:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003cb4:	6c05                	lui	s8,0x1
    80003cb6:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003cba:	a861                	j	80003d52 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003cbc:	6908                	ld	a0,16(a0)
    80003cbe:	00000097          	auipc	ra,0x0
    80003cc2:	22e080e7          	jalr	558(ra) # 80003eec <pipewrite>
    80003cc6:	8a2a                	mv	s4,a0
    80003cc8:	a045                	j	80003d68 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003cca:	02451783          	lh	a5,36(a0)
    80003cce:	03079693          	slli	a3,a5,0x30
    80003cd2:	92c1                	srli	a3,a3,0x30
    80003cd4:	4725                	li	a4,9
    80003cd6:	0cd76263          	bltu	a4,a3,80003d9a <filewrite+0x12c>
    80003cda:	0792                	slli	a5,a5,0x4
    80003cdc:	00035717          	auipc	a4,0x35
    80003ce0:	3ec70713          	addi	a4,a4,1004 # 800390c8 <devsw>
    80003ce4:	97ba                	add	a5,a5,a4
    80003ce6:	679c                	ld	a5,8(a5)
    80003ce8:	cbdd                	beqz	a5,80003d9e <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003cea:	4505                	li	a0,1
    80003cec:	9782                	jalr	a5
    80003cee:	8a2a                	mv	s4,a0
    80003cf0:	a8a5                	j	80003d68 <filewrite+0xfa>
    80003cf2:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003cf6:	00000097          	auipc	ra,0x0
    80003cfa:	8b4080e7          	jalr	-1868(ra) # 800035aa <begin_op>
      ilock(f->ip);
    80003cfe:	01893503          	ld	a0,24(s2)
    80003d02:	fffff097          	auipc	ra,0xfffff
    80003d06:	ecc080e7          	jalr	-308(ra) # 80002bce <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d0a:	8756                	mv	a4,s5
    80003d0c:	02092683          	lw	a3,32(s2)
    80003d10:	01698633          	add	a2,s3,s6
    80003d14:	4585                	li	a1,1
    80003d16:	01893503          	ld	a0,24(s2)
    80003d1a:	fffff097          	auipc	ra,0xfffff
    80003d1e:	260080e7          	jalr	608(ra) # 80002f7a <writei>
    80003d22:	84aa                	mv	s1,a0
    80003d24:	00a05763          	blez	a0,80003d32 <filewrite+0xc4>
        f->off += r;
    80003d28:	02092783          	lw	a5,32(s2)
    80003d2c:	9fa9                	addw	a5,a5,a0
    80003d2e:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003d32:	01893503          	ld	a0,24(s2)
    80003d36:	fffff097          	auipc	ra,0xfffff
    80003d3a:	f5a080e7          	jalr	-166(ra) # 80002c90 <iunlock>
      end_op();
    80003d3e:	00000097          	auipc	ra,0x0
    80003d42:	8ea080e7          	jalr	-1814(ra) # 80003628 <end_op>

      if(r != n1){
    80003d46:	009a9f63          	bne	s5,s1,80003d64 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003d4a:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003d4e:	0149db63          	bge	s3,s4,80003d64 <filewrite+0xf6>
      int n1 = n - i;
    80003d52:	413a04bb          	subw	s1,s4,s3
    80003d56:	0004879b          	sext.w	a5,s1
    80003d5a:	f8fbdce3          	bge	s7,a5,80003cf2 <filewrite+0x84>
    80003d5e:	84e2                	mv	s1,s8
    80003d60:	bf49                	j	80003cf2 <filewrite+0x84>
    int i = 0;
    80003d62:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003d64:	013a1f63          	bne	s4,s3,80003d82 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003d68:	8552                	mv	a0,s4
    80003d6a:	60a6                	ld	ra,72(sp)
    80003d6c:	6406                	ld	s0,64(sp)
    80003d6e:	74e2                	ld	s1,56(sp)
    80003d70:	7942                	ld	s2,48(sp)
    80003d72:	79a2                	ld	s3,40(sp)
    80003d74:	7a02                	ld	s4,32(sp)
    80003d76:	6ae2                	ld	s5,24(sp)
    80003d78:	6b42                	ld	s6,16(sp)
    80003d7a:	6ba2                	ld	s7,8(sp)
    80003d7c:	6c02                	ld	s8,0(sp)
    80003d7e:	6161                	addi	sp,sp,80
    80003d80:	8082                	ret
    ret = (i == n ? n : -1);
    80003d82:	5a7d                	li	s4,-1
    80003d84:	b7d5                	j	80003d68 <filewrite+0xfa>
    panic("filewrite");
    80003d86:	00005517          	auipc	a0,0x5
    80003d8a:	8aa50513          	addi	a0,a0,-1878 # 80008630 <syscalls+0x268>
    80003d8e:	00002097          	auipc	ra,0x2
    80003d92:	eb2080e7          	jalr	-334(ra) # 80005c40 <panic>
    return -1;
    80003d96:	5a7d                	li	s4,-1
    80003d98:	bfc1                	j	80003d68 <filewrite+0xfa>
      return -1;
    80003d9a:	5a7d                	li	s4,-1
    80003d9c:	b7f1                	j	80003d68 <filewrite+0xfa>
    80003d9e:	5a7d                	li	s4,-1
    80003da0:	b7e1                	j	80003d68 <filewrite+0xfa>

0000000080003da2 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003da2:	7179                	addi	sp,sp,-48
    80003da4:	f406                	sd	ra,40(sp)
    80003da6:	f022                	sd	s0,32(sp)
    80003da8:	ec26                	sd	s1,24(sp)
    80003daa:	e84a                	sd	s2,16(sp)
    80003dac:	e44e                	sd	s3,8(sp)
    80003dae:	e052                	sd	s4,0(sp)
    80003db0:	1800                	addi	s0,sp,48
    80003db2:	84aa                	mv	s1,a0
    80003db4:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003db6:	0005b023          	sd	zero,0(a1)
    80003dba:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003dbe:	00000097          	auipc	ra,0x0
    80003dc2:	bf8080e7          	jalr	-1032(ra) # 800039b6 <filealloc>
    80003dc6:	e088                	sd	a0,0(s1)
    80003dc8:	c551                	beqz	a0,80003e54 <pipealloc+0xb2>
    80003dca:	00000097          	auipc	ra,0x0
    80003dce:	bec080e7          	jalr	-1044(ra) # 800039b6 <filealloc>
    80003dd2:	00aa3023          	sd	a0,0(s4)
    80003dd6:	c92d                	beqz	a0,80003e48 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003dd8:	ffffc097          	auipc	ra,0xffffc
    80003ddc:	382080e7          	jalr	898(ra) # 8000015a <kalloc>
    80003de0:	892a                	mv	s2,a0
    80003de2:	c125                	beqz	a0,80003e42 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003de4:	4985                	li	s3,1
    80003de6:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003dea:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003dee:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003df2:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003df6:	00005597          	auipc	a1,0x5
    80003dfa:	84a58593          	addi	a1,a1,-1974 # 80008640 <syscalls+0x278>
    80003dfe:	00002097          	auipc	ra,0x2
    80003e02:	2ea080e7          	jalr	746(ra) # 800060e8 <initlock>
  (*f0)->type = FD_PIPE;
    80003e06:	609c                	ld	a5,0(s1)
    80003e08:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e0c:	609c                	ld	a5,0(s1)
    80003e0e:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e12:	609c                	ld	a5,0(s1)
    80003e14:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e18:	609c                	ld	a5,0(s1)
    80003e1a:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003e1e:	000a3783          	ld	a5,0(s4)
    80003e22:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003e26:	000a3783          	ld	a5,0(s4)
    80003e2a:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003e2e:	000a3783          	ld	a5,0(s4)
    80003e32:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e36:	000a3783          	ld	a5,0(s4)
    80003e3a:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e3e:	4501                	li	a0,0
    80003e40:	a025                	j	80003e68 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003e42:	6088                	ld	a0,0(s1)
    80003e44:	e501                	bnez	a0,80003e4c <pipealloc+0xaa>
    80003e46:	a039                	j	80003e54 <pipealloc+0xb2>
    80003e48:	6088                	ld	a0,0(s1)
    80003e4a:	c51d                	beqz	a0,80003e78 <pipealloc+0xd6>
    fileclose(*f0);
    80003e4c:	00000097          	auipc	ra,0x0
    80003e50:	c26080e7          	jalr	-986(ra) # 80003a72 <fileclose>
  if(*f1)
    80003e54:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003e58:	557d                	li	a0,-1
  if(*f1)
    80003e5a:	c799                	beqz	a5,80003e68 <pipealloc+0xc6>
    fileclose(*f1);
    80003e5c:	853e                	mv	a0,a5
    80003e5e:	00000097          	auipc	ra,0x0
    80003e62:	c14080e7          	jalr	-1004(ra) # 80003a72 <fileclose>
  return -1;
    80003e66:	557d                	li	a0,-1
}
    80003e68:	70a2                	ld	ra,40(sp)
    80003e6a:	7402                	ld	s0,32(sp)
    80003e6c:	64e2                	ld	s1,24(sp)
    80003e6e:	6942                	ld	s2,16(sp)
    80003e70:	69a2                	ld	s3,8(sp)
    80003e72:	6a02                	ld	s4,0(sp)
    80003e74:	6145                	addi	sp,sp,48
    80003e76:	8082                	ret
  return -1;
    80003e78:	557d                	li	a0,-1
    80003e7a:	b7fd                	j	80003e68 <pipealloc+0xc6>

0000000080003e7c <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003e7c:	1101                	addi	sp,sp,-32
    80003e7e:	ec06                	sd	ra,24(sp)
    80003e80:	e822                	sd	s0,16(sp)
    80003e82:	e426                	sd	s1,8(sp)
    80003e84:	e04a                	sd	s2,0(sp)
    80003e86:	1000                	addi	s0,sp,32
    80003e88:	84aa                	mv	s1,a0
    80003e8a:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003e8c:	00002097          	auipc	ra,0x2
    80003e90:	2ec080e7          	jalr	748(ra) # 80006178 <acquire>
  if(writable){
    80003e94:	02090d63          	beqz	s2,80003ece <pipeclose+0x52>
    pi->writeopen = 0;
    80003e98:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003e9c:	21848513          	addi	a0,s1,536
    80003ea0:	ffffe097          	auipc	ra,0xffffe
    80003ea4:	930080e7          	jalr	-1744(ra) # 800017d0 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003ea8:	2204b783          	ld	a5,544(s1)
    80003eac:	eb95                	bnez	a5,80003ee0 <pipeclose+0x64>
    release(&pi->lock);
    80003eae:	8526                	mv	a0,s1
    80003eb0:	00002097          	auipc	ra,0x2
    80003eb4:	37c080e7          	jalr	892(ra) # 8000622c <release>
    kfree((char*)pi);
    80003eb8:	8526                	mv	a0,s1
    80003eba:	ffffc097          	auipc	ra,0xffffc
    80003ebe:	162080e7          	jalr	354(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003ec2:	60e2                	ld	ra,24(sp)
    80003ec4:	6442                	ld	s0,16(sp)
    80003ec6:	64a2                	ld	s1,8(sp)
    80003ec8:	6902                	ld	s2,0(sp)
    80003eca:	6105                	addi	sp,sp,32
    80003ecc:	8082                	ret
    pi->readopen = 0;
    80003ece:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003ed2:	21c48513          	addi	a0,s1,540
    80003ed6:	ffffe097          	auipc	ra,0xffffe
    80003eda:	8fa080e7          	jalr	-1798(ra) # 800017d0 <wakeup>
    80003ede:	b7e9                	j	80003ea8 <pipeclose+0x2c>
    release(&pi->lock);
    80003ee0:	8526                	mv	a0,s1
    80003ee2:	00002097          	auipc	ra,0x2
    80003ee6:	34a080e7          	jalr	842(ra) # 8000622c <release>
}
    80003eea:	bfe1                	j	80003ec2 <pipeclose+0x46>

0000000080003eec <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003eec:	711d                	addi	sp,sp,-96
    80003eee:	ec86                	sd	ra,88(sp)
    80003ef0:	e8a2                	sd	s0,80(sp)
    80003ef2:	e4a6                	sd	s1,72(sp)
    80003ef4:	e0ca                	sd	s2,64(sp)
    80003ef6:	fc4e                	sd	s3,56(sp)
    80003ef8:	f852                	sd	s4,48(sp)
    80003efa:	f456                	sd	s5,40(sp)
    80003efc:	f05a                	sd	s6,32(sp)
    80003efe:	ec5e                	sd	s7,24(sp)
    80003f00:	e862                	sd	s8,16(sp)
    80003f02:	1080                	addi	s0,sp,96
    80003f04:	84aa                	mv	s1,a0
    80003f06:	8aae                	mv	s5,a1
    80003f08:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003f0a:	ffffd097          	auipc	ra,0xffffd
    80003f0e:	076080e7          	jalr	118(ra) # 80000f80 <myproc>
    80003f12:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003f14:	8526                	mv	a0,s1
    80003f16:	00002097          	auipc	ra,0x2
    80003f1a:	262080e7          	jalr	610(ra) # 80006178 <acquire>
  while(i < n){
    80003f1e:	0b405363          	blez	s4,80003fc4 <pipewrite+0xd8>
  int i = 0;
    80003f22:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f24:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003f26:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003f2a:	21c48b93          	addi	s7,s1,540
    80003f2e:	a089                	j	80003f70 <pipewrite+0x84>
      release(&pi->lock);
    80003f30:	8526                	mv	a0,s1
    80003f32:	00002097          	auipc	ra,0x2
    80003f36:	2fa080e7          	jalr	762(ra) # 8000622c <release>
      return -1;
    80003f3a:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f3c:	854a                	mv	a0,s2
    80003f3e:	60e6                	ld	ra,88(sp)
    80003f40:	6446                	ld	s0,80(sp)
    80003f42:	64a6                	ld	s1,72(sp)
    80003f44:	6906                	ld	s2,64(sp)
    80003f46:	79e2                	ld	s3,56(sp)
    80003f48:	7a42                	ld	s4,48(sp)
    80003f4a:	7aa2                	ld	s5,40(sp)
    80003f4c:	7b02                	ld	s6,32(sp)
    80003f4e:	6be2                	ld	s7,24(sp)
    80003f50:	6c42                	ld	s8,16(sp)
    80003f52:	6125                	addi	sp,sp,96
    80003f54:	8082                	ret
      wakeup(&pi->nread);
    80003f56:	8562                	mv	a0,s8
    80003f58:	ffffe097          	auipc	ra,0xffffe
    80003f5c:	878080e7          	jalr	-1928(ra) # 800017d0 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003f60:	85a6                	mv	a1,s1
    80003f62:	855e                	mv	a0,s7
    80003f64:	ffffd097          	auipc	ra,0xffffd
    80003f68:	6e0080e7          	jalr	1760(ra) # 80001644 <sleep>
  while(i < n){
    80003f6c:	05495d63          	bge	s2,s4,80003fc6 <pipewrite+0xda>
    if(pi->readopen == 0 || pr->killed){
    80003f70:	2204a783          	lw	a5,544(s1)
    80003f74:	dfd5                	beqz	a5,80003f30 <pipewrite+0x44>
    80003f76:	0289a783          	lw	a5,40(s3)
    80003f7a:	fbdd                	bnez	a5,80003f30 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003f7c:	2184a783          	lw	a5,536(s1)
    80003f80:	21c4a703          	lw	a4,540(s1)
    80003f84:	2007879b          	addiw	a5,a5,512
    80003f88:	fcf707e3          	beq	a4,a5,80003f56 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f8c:	4685                	li	a3,1
    80003f8e:	01590633          	add	a2,s2,s5
    80003f92:	faf40593          	addi	a1,s0,-81
    80003f96:	0509b503          	ld	a0,80(s3)
    80003f9a:	ffffd097          	auipc	ra,0xffffd
    80003f9e:	d36080e7          	jalr	-714(ra) # 80000cd0 <copyin>
    80003fa2:	03650263          	beq	a0,s6,80003fc6 <pipewrite+0xda>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003fa6:	21c4a783          	lw	a5,540(s1)
    80003faa:	0017871b          	addiw	a4,a5,1
    80003fae:	20e4ae23          	sw	a4,540(s1)
    80003fb2:	1ff7f793          	andi	a5,a5,511
    80003fb6:	97a6                	add	a5,a5,s1
    80003fb8:	faf44703          	lbu	a4,-81(s0)
    80003fbc:	00e78c23          	sb	a4,24(a5)
      i++;
    80003fc0:	2905                	addiw	s2,s2,1
    80003fc2:	b76d                	j	80003f6c <pipewrite+0x80>
  int i = 0;
    80003fc4:	4901                	li	s2,0
  wakeup(&pi->nread);
    80003fc6:	21848513          	addi	a0,s1,536
    80003fca:	ffffe097          	auipc	ra,0xffffe
    80003fce:	806080e7          	jalr	-2042(ra) # 800017d0 <wakeup>
  release(&pi->lock);
    80003fd2:	8526                	mv	a0,s1
    80003fd4:	00002097          	auipc	ra,0x2
    80003fd8:	258080e7          	jalr	600(ra) # 8000622c <release>
  return i;
    80003fdc:	b785                	j	80003f3c <pipewrite+0x50>

0000000080003fde <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003fde:	715d                	addi	sp,sp,-80
    80003fe0:	e486                	sd	ra,72(sp)
    80003fe2:	e0a2                	sd	s0,64(sp)
    80003fe4:	fc26                	sd	s1,56(sp)
    80003fe6:	f84a                	sd	s2,48(sp)
    80003fe8:	f44e                	sd	s3,40(sp)
    80003fea:	f052                	sd	s4,32(sp)
    80003fec:	ec56                	sd	s5,24(sp)
    80003fee:	e85a                	sd	s6,16(sp)
    80003ff0:	0880                	addi	s0,sp,80
    80003ff2:	84aa                	mv	s1,a0
    80003ff4:	892e                	mv	s2,a1
    80003ff6:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003ff8:	ffffd097          	auipc	ra,0xffffd
    80003ffc:	f88080e7          	jalr	-120(ra) # 80000f80 <myproc>
    80004000:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004002:	8526                	mv	a0,s1
    80004004:	00002097          	auipc	ra,0x2
    80004008:	174080e7          	jalr	372(ra) # 80006178 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000400c:	2184a703          	lw	a4,536(s1)
    80004010:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004014:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004018:	02f71463          	bne	a4,a5,80004040 <piperead+0x62>
    8000401c:	2244a783          	lw	a5,548(s1)
    80004020:	c385                	beqz	a5,80004040 <piperead+0x62>
    if(pr->killed){
    80004022:	028a2783          	lw	a5,40(s4)
    80004026:	ebc9                	bnez	a5,800040b8 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004028:	85a6                	mv	a1,s1
    8000402a:	854e                	mv	a0,s3
    8000402c:	ffffd097          	auipc	ra,0xffffd
    80004030:	618080e7          	jalr	1560(ra) # 80001644 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004034:	2184a703          	lw	a4,536(s1)
    80004038:	21c4a783          	lw	a5,540(s1)
    8000403c:	fef700e3          	beq	a4,a5,8000401c <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004040:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004042:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004044:	05505463          	blez	s5,8000408c <piperead+0xae>
    if(pi->nread == pi->nwrite)
    80004048:	2184a783          	lw	a5,536(s1)
    8000404c:	21c4a703          	lw	a4,540(s1)
    80004050:	02f70e63          	beq	a4,a5,8000408c <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004054:	0017871b          	addiw	a4,a5,1
    80004058:	20e4ac23          	sw	a4,536(s1)
    8000405c:	1ff7f793          	andi	a5,a5,511
    80004060:	97a6                	add	a5,a5,s1
    80004062:	0187c783          	lbu	a5,24(a5)
    80004066:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000406a:	4685                	li	a3,1
    8000406c:	fbf40613          	addi	a2,s0,-65
    80004070:	85ca                	mv	a1,s2
    80004072:	050a3503          	ld	a0,80(s4)
    80004076:	ffffd097          	auipc	ra,0xffffd
    8000407a:	b9e080e7          	jalr	-1122(ra) # 80000c14 <copyout>
    8000407e:	01650763          	beq	a0,s6,8000408c <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004082:	2985                	addiw	s3,s3,1
    80004084:	0905                	addi	s2,s2,1
    80004086:	fd3a91e3          	bne	s5,s3,80004048 <piperead+0x6a>
    8000408a:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000408c:	21c48513          	addi	a0,s1,540
    80004090:	ffffd097          	auipc	ra,0xffffd
    80004094:	740080e7          	jalr	1856(ra) # 800017d0 <wakeup>
  release(&pi->lock);
    80004098:	8526                	mv	a0,s1
    8000409a:	00002097          	auipc	ra,0x2
    8000409e:	192080e7          	jalr	402(ra) # 8000622c <release>
  return i;
}
    800040a2:	854e                	mv	a0,s3
    800040a4:	60a6                	ld	ra,72(sp)
    800040a6:	6406                	ld	s0,64(sp)
    800040a8:	74e2                	ld	s1,56(sp)
    800040aa:	7942                	ld	s2,48(sp)
    800040ac:	79a2                	ld	s3,40(sp)
    800040ae:	7a02                	ld	s4,32(sp)
    800040b0:	6ae2                	ld	s5,24(sp)
    800040b2:	6b42                	ld	s6,16(sp)
    800040b4:	6161                	addi	sp,sp,80
    800040b6:	8082                	ret
      release(&pi->lock);
    800040b8:	8526                	mv	a0,s1
    800040ba:	00002097          	auipc	ra,0x2
    800040be:	172080e7          	jalr	370(ra) # 8000622c <release>
      return -1;
    800040c2:	59fd                	li	s3,-1
    800040c4:	bff9                	j	800040a2 <piperead+0xc4>

00000000800040c6 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800040c6:	de010113          	addi	sp,sp,-544
    800040ca:	20113c23          	sd	ra,536(sp)
    800040ce:	20813823          	sd	s0,528(sp)
    800040d2:	20913423          	sd	s1,520(sp)
    800040d6:	21213023          	sd	s2,512(sp)
    800040da:	ffce                	sd	s3,504(sp)
    800040dc:	fbd2                	sd	s4,496(sp)
    800040de:	f7d6                	sd	s5,488(sp)
    800040e0:	f3da                	sd	s6,480(sp)
    800040e2:	efde                	sd	s7,472(sp)
    800040e4:	ebe2                	sd	s8,464(sp)
    800040e6:	e7e6                	sd	s9,456(sp)
    800040e8:	e3ea                	sd	s10,448(sp)
    800040ea:	ff6e                	sd	s11,440(sp)
    800040ec:	1400                	addi	s0,sp,544
    800040ee:	892a                	mv	s2,a0
    800040f0:	dea43423          	sd	a0,-536(s0)
    800040f4:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800040f8:	ffffd097          	auipc	ra,0xffffd
    800040fc:	e88080e7          	jalr	-376(ra) # 80000f80 <myproc>
    80004100:	84aa                	mv	s1,a0

  begin_op();
    80004102:	fffff097          	auipc	ra,0xfffff
    80004106:	4a8080e7          	jalr	1192(ra) # 800035aa <begin_op>

  if((ip = namei(path)) == 0){
    8000410a:	854a                	mv	a0,s2
    8000410c:	fffff097          	auipc	ra,0xfffff
    80004110:	27e080e7          	jalr	638(ra) # 8000338a <namei>
    80004114:	c93d                	beqz	a0,8000418a <exec+0xc4>
    80004116:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004118:	fffff097          	auipc	ra,0xfffff
    8000411c:	ab6080e7          	jalr	-1354(ra) # 80002bce <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004120:	04000713          	li	a4,64
    80004124:	4681                	li	a3,0
    80004126:	e5040613          	addi	a2,s0,-432
    8000412a:	4581                	li	a1,0
    8000412c:	8556                	mv	a0,s5
    8000412e:	fffff097          	auipc	ra,0xfffff
    80004132:	d54080e7          	jalr	-684(ra) # 80002e82 <readi>
    80004136:	04000793          	li	a5,64
    8000413a:	00f51a63          	bne	a0,a5,8000414e <exec+0x88>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    8000413e:	e5042703          	lw	a4,-432(s0)
    80004142:	464c47b7          	lui	a5,0x464c4
    80004146:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000414a:	04f70663          	beq	a4,a5,80004196 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000414e:	8556                	mv	a0,s5
    80004150:	fffff097          	auipc	ra,0xfffff
    80004154:	ce0080e7          	jalr	-800(ra) # 80002e30 <iunlockput>
    end_op();
    80004158:	fffff097          	auipc	ra,0xfffff
    8000415c:	4d0080e7          	jalr	1232(ra) # 80003628 <end_op>
  }
  return -1;
    80004160:	557d                	li	a0,-1
}
    80004162:	21813083          	ld	ra,536(sp)
    80004166:	21013403          	ld	s0,528(sp)
    8000416a:	20813483          	ld	s1,520(sp)
    8000416e:	20013903          	ld	s2,512(sp)
    80004172:	79fe                	ld	s3,504(sp)
    80004174:	7a5e                	ld	s4,496(sp)
    80004176:	7abe                	ld	s5,488(sp)
    80004178:	7b1e                	ld	s6,480(sp)
    8000417a:	6bfe                	ld	s7,472(sp)
    8000417c:	6c5e                	ld	s8,464(sp)
    8000417e:	6cbe                	ld	s9,456(sp)
    80004180:	6d1e                	ld	s10,448(sp)
    80004182:	7dfa                	ld	s11,440(sp)
    80004184:	22010113          	addi	sp,sp,544
    80004188:	8082                	ret
    end_op();
    8000418a:	fffff097          	auipc	ra,0xfffff
    8000418e:	49e080e7          	jalr	1182(ra) # 80003628 <end_op>
    return -1;
    80004192:	557d                	li	a0,-1
    80004194:	b7f9                	j	80004162 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    80004196:	8526                	mv	a0,s1
    80004198:	ffffd097          	auipc	ra,0xffffd
    8000419c:	eac080e7          	jalr	-340(ra) # 80001044 <proc_pagetable>
    800041a0:	8b2a                	mv	s6,a0
    800041a2:	d555                	beqz	a0,8000414e <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041a4:	e7042783          	lw	a5,-400(s0)
    800041a8:	e8845703          	lhu	a4,-376(s0)
    800041ac:	c735                	beqz	a4,80004218 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800041ae:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041b0:	e0043423          	sd	zero,-504(s0)
    if((ph.vaddr % PGSIZE) != 0)
    800041b4:	6a05                	lui	s4,0x1
    800041b6:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    800041ba:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    800041be:	6d85                	lui	s11,0x1
    800041c0:	7d7d                	lui	s10,0xfffff
    800041c2:	ac1d                	j	800043f8 <exec+0x332>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800041c4:	00004517          	auipc	a0,0x4
    800041c8:	48450513          	addi	a0,a0,1156 # 80008648 <syscalls+0x280>
    800041cc:	00002097          	auipc	ra,0x2
    800041d0:	a74080e7          	jalr	-1420(ra) # 80005c40 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800041d4:	874a                	mv	a4,s2
    800041d6:	009c86bb          	addw	a3,s9,s1
    800041da:	4581                	li	a1,0
    800041dc:	8556                	mv	a0,s5
    800041de:	fffff097          	auipc	ra,0xfffff
    800041e2:	ca4080e7          	jalr	-860(ra) # 80002e82 <readi>
    800041e6:	2501                	sext.w	a0,a0
    800041e8:	1aa91863          	bne	s2,a0,80004398 <exec+0x2d2>
  for(i = 0; i < sz; i += PGSIZE){
    800041ec:	009d84bb          	addw	s1,s11,s1
    800041f0:	013d09bb          	addw	s3,s10,s3
    800041f4:	1f74f263          	bgeu	s1,s7,800043d8 <exec+0x312>
    pa = walkaddr(pagetable, va + i);
    800041f8:	02049593          	slli	a1,s1,0x20
    800041fc:	9181                	srli	a1,a1,0x20
    800041fe:	95e2                	add	a1,a1,s8
    80004200:	855a                	mv	a0,s6
    80004202:	ffffc097          	auipc	ra,0xffffc
    80004206:	40e080e7          	jalr	1038(ra) # 80000610 <walkaddr>
    8000420a:	862a                	mv	a2,a0
    if(pa == 0)
    8000420c:	dd45                	beqz	a0,800041c4 <exec+0xfe>
      n = PGSIZE;
    8000420e:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    80004210:	fd49f2e3          	bgeu	s3,s4,800041d4 <exec+0x10e>
      n = sz - i;
    80004214:	894e                	mv	s2,s3
    80004216:	bf7d                	j	800041d4 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004218:	4481                	li	s1,0
  iunlockput(ip);
    8000421a:	8556                	mv	a0,s5
    8000421c:	fffff097          	auipc	ra,0xfffff
    80004220:	c14080e7          	jalr	-1004(ra) # 80002e30 <iunlockput>
  end_op();
    80004224:	fffff097          	auipc	ra,0xfffff
    80004228:	404080e7          	jalr	1028(ra) # 80003628 <end_op>
  p = myproc();
    8000422c:	ffffd097          	auipc	ra,0xffffd
    80004230:	d54080e7          	jalr	-684(ra) # 80000f80 <myproc>
    80004234:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80004236:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    8000423a:	6785                	lui	a5,0x1
    8000423c:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000423e:	97a6                	add	a5,a5,s1
    80004240:	777d                	lui	a4,0xfffff
    80004242:	8ff9                	and	a5,a5,a4
    80004244:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004248:	6609                	lui	a2,0x2
    8000424a:	963e                	add	a2,a2,a5
    8000424c:	85be                	mv	a1,a5
    8000424e:	855a                	mv	a0,s6
    80004250:	ffffc097          	auipc	ra,0xffffc
    80004254:	774080e7          	jalr	1908(ra) # 800009c4 <uvmalloc>
    80004258:	8c2a                	mv	s8,a0
  ip = 0;
    8000425a:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000425c:	12050e63          	beqz	a0,80004398 <exec+0x2d2>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004260:	75f9                	lui	a1,0xffffe
    80004262:	95aa                	add	a1,a1,a0
    80004264:	855a                	mv	a0,s6
    80004266:	ffffd097          	auipc	ra,0xffffd
    8000426a:	97c080e7          	jalr	-1668(ra) # 80000be2 <uvmclear>
  stackbase = sp - PGSIZE;
    8000426e:	7afd                	lui	s5,0xfffff
    80004270:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    80004272:	df043783          	ld	a5,-528(s0)
    80004276:	6388                	ld	a0,0(a5)
    80004278:	c925                	beqz	a0,800042e8 <exec+0x222>
    8000427a:	e9040993          	addi	s3,s0,-368
    8000427e:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004282:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004284:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004286:	ffffc097          	auipc	ra,0xffffc
    8000428a:	180080e7          	jalr	384(ra) # 80000406 <strlen>
    8000428e:	0015079b          	addiw	a5,a0,1
    80004292:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004296:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    8000429a:	13596363          	bltu	s2,s5,800043c0 <exec+0x2fa>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000429e:	df043d83          	ld	s11,-528(s0)
    800042a2:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    800042a6:	8552                	mv	a0,s4
    800042a8:	ffffc097          	auipc	ra,0xffffc
    800042ac:	15e080e7          	jalr	350(ra) # 80000406 <strlen>
    800042b0:	0015069b          	addiw	a3,a0,1
    800042b4:	8652                	mv	a2,s4
    800042b6:	85ca                	mv	a1,s2
    800042b8:	855a                	mv	a0,s6
    800042ba:	ffffd097          	auipc	ra,0xffffd
    800042be:	95a080e7          	jalr	-1702(ra) # 80000c14 <copyout>
    800042c2:	10054363          	bltz	a0,800043c8 <exec+0x302>
    ustack[argc] = sp;
    800042c6:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800042ca:	0485                	addi	s1,s1,1
    800042cc:	008d8793          	addi	a5,s11,8
    800042d0:	def43823          	sd	a5,-528(s0)
    800042d4:	008db503          	ld	a0,8(s11)
    800042d8:	c911                	beqz	a0,800042ec <exec+0x226>
    if(argc >= MAXARG)
    800042da:	09a1                	addi	s3,s3,8
    800042dc:	fb3c95e3          	bne	s9,s3,80004286 <exec+0x1c0>
  sz = sz1;
    800042e0:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800042e4:	4a81                	li	s5,0
    800042e6:	a84d                	j	80004398 <exec+0x2d2>
  sp = sz;
    800042e8:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800042ea:	4481                	li	s1,0
  ustack[argc] = 0;
    800042ec:	00349793          	slli	a5,s1,0x3
    800042f0:	f9078793          	addi	a5,a5,-112
    800042f4:	97a2                	add	a5,a5,s0
    800042f6:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800042fa:	00148693          	addi	a3,s1,1
    800042fe:	068e                	slli	a3,a3,0x3
    80004300:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004304:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004308:	01597663          	bgeu	s2,s5,80004314 <exec+0x24e>
  sz = sz1;
    8000430c:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004310:	4a81                	li	s5,0
    80004312:	a059                	j	80004398 <exec+0x2d2>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004314:	e9040613          	addi	a2,s0,-368
    80004318:	85ca                	mv	a1,s2
    8000431a:	855a                	mv	a0,s6
    8000431c:	ffffd097          	auipc	ra,0xffffd
    80004320:	8f8080e7          	jalr	-1800(ra) # 80000c14 <copyout>
    80004324:	0a054663          	bltz	a0,800043d0 <exec+0x30a>
  p->trapframe->a1 = sp;
    80004328:	058bb783          	ld	a5,88(s7)
    8000432c:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004330:	de843783          	ld	a5,-536(s0)
    80004334:	0007c703          	lbu	a4,0(a5)
    80004338:	cf11                	beqz	a4,80004354 <exec+0x28e>
    8000433a:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000433c:	02f00693          	li	a3,47
    80004340:	a039                	j	8000434e <exec+0x288>
      last = s+1;
    80004342:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80004346:	0785                	addi	a5,a5,1
    80004348:	fff7c703          	lbu	a4,-1(a5)
    8000434c:	c701                	beqz	a4,80004354 <exec+0x28e>
    if(*s == '/')
    8000434e:	fed71ce3          	bne	a4,a3,80004346 <exec+0x280>
    80004352:	bfc5                	j	80004342 <exec+0x27c>
  safestrcpy(p->name, last, sizeof(p->name));
    80004354:	4641                	li	a2,16
    80004356:	de843583          	ld	a1,-536(s0)
    8000435a:	158b8513          	addi	a0,s7,344
    8000435e:	ffffc097          	auipc	ra,0xffffc
    80004362:	076080e7          	jalr	118(ra) # 800003d4 <safestrcpy>
  oldpagetable = p->pagetable;
    80004366:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    8000436a:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    8000436e:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004372:	058bb783          	ld	a5,88(s7)
    80004376:	e6843703          	ld	a4,-408(s0)
    8000437a:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000437c:	058bb783          	ld	a5,88(s7)
    80004380:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004384:	85ea                	mv	a1,s10
    80004386:	ffffd097          	auipc	ra,0xffffd
    8000438a:	d5a080e7          	jalr	-678(ra) # 800010e0 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000438e:	0004851b          	sext.w	a0,s1
    80004392:	bbc1                	j	80004162 <exec+0x9c>
    80004394:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    80004398:	df843583          	ld	a1,-520(s0)
    8000439c:	855a                	mv	a0,s6
    8000439e:	ffffd097          	auipc	ra,0xffffd
    800043a2:	d42080e7          	jalr	-702(ra) # 800010e0 <proc_freepagetable>
  if(ip){
    800043a6:	da0a94e3          	bnez	s5,8000414e <exec+0x88>
  return -1;
    800043aa:	557d                	li	a0,-1
    800043ac:	bb5d                	j	80004162 <exec+0x9c>
    800043ae:	de943c23          	sd	s1,-520(s0)
    800043b2:	b7dd                	j	80004398 <exec+0x2d2>
    800043b4:	de943c23          	sd	s1,-520(s0)
    800043b8:	b7c5                	j	80004398 <exec+0x2d2>
    800043ba:	de943c23          	sd	s1,-520(s0)
    800043be:	bfe9                	j	80004398 <exec+0x2d2>
  sz = sz1;
    800043c0:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800043c4:	4a81                	li	s5,0
    800043c6:	bfc9                	j	80004398 <exec+0x2d2>
  sz = sz1;
    800043c8:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800043cc:	4a81                	li	s5,0
    800043ce:	b7e9                	j	80004398 <exec+0x2d2>
  sz = sz1;
    800043d0:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800043d4:	4a81                	li	s5,0
    800043d6:	b7c9                	j	80004398 <exec+0x2d2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800043d8:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043dc:	e0843783          	ld	a5,-504(s0)
    800043e0:	0017869b          	addiw	a3,a5,1
    800043e4:	e0d43423          	sd	a3,-504(s0)
    800043e8:	e0043783          	ld	a5,-512(s0)
    800043ec:	0387879b          	addiw	a5,a5,56
    800043f0:	e8845703          	lhu	a4,-376(s0)
    800043f4:	e2e6d3e3          	bge	a3,a4,8000421a <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800043f8:	2781                	sext.w	a5,a5
    800043fa:	e0f43023          	sd	a5,-512(s0)
    800043fe:	03800713          	li	a4,56
    80004402:	86be                	mv	a3,a5
    80004404:	e1840613          	addi	a2,s0,-488
    80004408:	4581                	li	a1,0
    8000440a:	8556                	mv	a0,s5
    8000440c:	fffff097          	auipc	ra,0xfffff
    80004410:	a76080e7          	jalr	-1418(ra) # 80002e82 <readi>
    80004414:	03800793          	li	a5,56
    80004418:	f6f51ee3          	bne	a0,a5,80004394 <exec+0x2ce>
    if(ph.type != ELF_PROG_LOAD)
    8000441c:	e1842783          	lw	a5,-488(s0)
    80004420:	4705                	li	a4,1
    80004422:	fae79de3          	bne	a5,a4,800043dc <exec+0x316>
    if(ph.memsz < ph.filesz)
    80004426:	e4043603          	ld	a2,-448(s0)
    8000442a:	e3843783          	ld	a5,-456(s0)
    8000442e:	f8f660e3          	bltu	a2,a5,800043ae <exec+0x2e8>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004432:	e2843783          	ld	a5,-472(s0)
    80004436:	963e                	add	a2,a2,a5
    80004438:	f6f66ee3          	bltu	a2,a5,800043b4 <exec+0x2ee>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000443c:	85a6                	mv	a1,s1
    8000443e:	855a                	mv	a0,s6
    80004440:	ffffc097          	auipc	ra,0xffffc
    80004444:	584080e7          	jalr	1412(ra) # 800009c4 <uvmalloc>
    80004448:	dea43c23          	sd	a0,-520(s0)
    8000444c:	d53d                	beqz	a0,800043ba <exec+0x2f4>
    if((ph.vaddr % PGSIZE) != 0)
    8000444e:	e2843c03          	ld	s8,-472(s0)
    80004452:	de043783          	ld	a5,-544(s0)
    80004456:	00fc77b3          	and	a5,s8,a5
    8000445a:	ff9d                	bnez	a5,80004398 <exec+0x2d2>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000445c:	e2042c83          	lw	s9,-480(s0)
    80004460:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004464:	f60b8ae3          	beqz	s7,800043d8 <exec+0x312>
    80004468:	89de                	mv	s3,s7
    8000446a:	4481                	li	s1,0
    8000446c:	b371                	j	800041f8 <exec+0x132>

000000008000446e <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000446e:	7179                	addi	sp,sp,-48
    80004470:	f406                	sd	ra,40(sp)
    80004472:	f022                	sd	s0,32(sp)
    80004474:	ec26                	sd	s1,24(sp)
    80004476:	e84a                	sd	s2,16(sp)
    80004478:	1800                	addi	s0,sp,48
    8000447a:	892e                	mv	s2,a1
    8000447c:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    8000447e:	fdc40593          	addi	a1,s0,-36
    80004482:	ffffe097          	auipc	ra,0xffffe
    80004486:	bda080e7          	jalr	-1062(ra) # 8000205c <argint>
    8000448a:	04054063          	bltz	a0,800044ca <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000448e:	fdc42703          	lw	a4,-36(s0)
    80004492:	47bd                	li	a5,15
    80004494:	02e7ed63          	bltu	a5,a4,800044ce <argfd+0x60>
    80004498:	ffffd097          	auipc	ra,0xffffd
    8000449c:	ae8080e7          	jalr	-1304(ra) # 80000f80 <myproc>
    800044a0:	fdc42703          	lw	a4,-36(s0)
    800044a4:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7ffb8dda>
    800044a8:	078e                	slli	a5,a5,0x3
    800044aa:	953e                	add	a0,a0,a5
    800044ac:	611c                	ld	a5,0(a0)
    800044ae:	c395                	beqz	a5,800044d2 <argfd+0x64>
    return -1;
  if(pfd)
    800044b0:	00090463          	beqz	s2,800044b8 <argfd+0x4a>
    *pfd = fd;
    800044b4:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800044b8:	4501                	li	a0,0
  if(pf)
    800044ba:	c091                	beqz	s1,800044be <argfd+0x50>
    *pf = f;
    800044bc:	e09c                	sd	a5,0(s1)
}
    800044be:	70a2                	ld	ra,40(sp)
    800044c0:	7402                	ld	s0,32(sp)
    800044c2:	64e2                	ld	s1,24(sp)
    800044c4:	6942                	ld	s2,16(sp)
    800044c6:	6145                	addi	sp,sp,48
    800044c8:	8082                	ret
    return -1;
    800044ca:	557d                	li	a0,-1
    800044cc:	bfcd                	j	800044be <argfd+0x50>
    return -1;
    800044ce:	557d                	li	a0,-1
    800044d0:	b7fd                	j	800044be <argfd+0x50>
    800044d2:	557d                	li	a0,-1
    800044d4:	b7ed                	j	800044be <argfd+0x50>

00000000800044d6 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800044d6:	1101                	addi	sp,sp,-32
    800044d8:	ec06                	sd	ra,24(sp)
    800044da:	e822                	sd	s0,16(sp)
    800044dc:	e426                	sd	s1,8(sp)
    800044de:	1000                	addi	s0,sp,32
    800044e0:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800044e2:	ffffd097          	auipc	ra,0xffffd
    800044e6:	a9e080e7          	jalr	-1378(ra) # 80000f80 <myproc>
    800044ea:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800044ec:	0d050793          	addi	a5,a0,208
    800044f0:	4501                	li	a0,0
    800044f2:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800044f4:	6398                	ld	a4,0(a5)
    800044f6:	cb19                	beqz	a4,8000450c <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800044f8:	2505                	addiw	a0,a0,1
    800044fa:	07a1                	addi	a5,a5,8
    800044fc:	fed51ce3          	bne	a0,a3,800044f4 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004500:	557d                	li	a0,-1
}
    80004502:	60e2                	ld	ra,24(sp)
    80004504:	6442                	ld	s0,16(sp)
    80004506:	64a2                	ld	s1,8(sp)
    80004508:	6105                	addi	sp,sp,32
    8000450a:	8082                	ret
      p->ofile[fd] = f;
    8000450c:	01a50793          	addi	a5,a0,26
    80004510:	078e                	slli	a5,a5,0x3
    80004512:	963e                	add	a2,a2,a5
    80004514:	e204                	sd	s1,0(a2)
      return fd;
    80004516:	b7f5                	j	80004502 <fdalloc+0x2c>

0000000080004518 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004518:	715d                	addi	sp,sp,-80
    8000451a:	e486                	sd	ra,72(sp)
    8000451c:	e0a2                	sd	s0,64(sp)
    8000451e:	fc26                	sd	s1,56(sp)
    80004520:	f84a                	sd	s2,48(sp)
    80004522:	f44e                	sd	s3,40(sp)
    80004524:	f052                	sd	s4,32(sp)
    80004526:	ec56                	sd	s5,24(sp)
    80004528:	0880                	addi	s0,sp,80
    8000452a:	89ae                	mv	s3,a1
    8000452c:	8ab2                	mv	s5,a2
    8000452e:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004530:	fb040593          	addi	a1,s0,-80
    80004534:	fffff097          	auipc	ra,0xfffff
    80004538:	e74080e7          	jalr	-396(ra) # 800033a8 <nameiparent>
    8000453c:	892a                	mv	s2,a0
    8000453e:	12050e63          	beqz	a0,8000467a <create+0x162>
    return 0;

  ilock(dp);
    80004542:	ffffe097          	auipc	ra,0xffffe
    80004546:	68c080e7          	jalr	1676(ra) # 80002bce <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000454a:	4601                	li	a2,0
    8000454c:	fb040593          	addi	a1,s0,-80
    80004550:	854a                	mv	a0,s2
    80004552:	fffff097          	auipc	ra,0xfffff
    80004556:	b60080e7          	jalr	-1184(ra) # 800030b2 <dirlookup>
    8000455a:	84aa                	mv	s1,a0
    8000455c:	c921                	beqz	a0,800045ac <create+0x94>
    iunlockput(dp);
    8000455e:	854a                	mv	a0,s2
    80004560:	fffff097          	auipc	ra,0xfffff
    80004564:	8d0080e7          	jalr	-1840(ra) # 80002e30 <iunlockput>
    ilock(ip);
    80004568:	8526                	mv	a0,s1
    8000456a:	ffffe097          	auipc	ra,0xffffe
    8000456e:	664080e7          	jalr	1636(ra) # 80002bce <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004572:	2981                	sext.w	s3,s3
    80004574:	4789                	li	a5,2
    80004576:	02f99463          	bne	s3,a5,8000459e <create+0x86>
    8000457a:	0444d783          	lhu	a5,68(s1)
    8000457e:	37f9                	addiw	a5,a5,-2
    80004580:	17c2                	slli	a5,a5,0x30
    80004582:	93c1                	srli	a5,a5,0x30
    80004584:	4705                	li	a4,1
    80004586:	00f76c63          	bltu	a4,a5,8000459e <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    8000458a:	8526                	mv	a0,s1
    8000458c:	60a6                	ld	ra,72(sp)
    8000458e:	6406                	ld	s0,64(sp)
    80004590:	74e2                	ld	s1,56(sp)
    80004592:	7942                	ld	s2,48(sp)
    80004594:	79a2                	ld	s3,40(sp)
    80004596:	7a02                	ld	s4,32(sp)
    80004598:	6ae2                	ld	s5,24(sp)
    8000459a:	6161                	addi	sp,sp,80
    8000459c:	8082                	ret
    iunlockput(ip);
    8000459e:	8526                	mv	a0,s1
    800045a0:	fffff097          	auipc	ra,0xfffff
    800045a4:	890080e7          	jalr	-1904(ra) # 80002e30 <iunlockput>
    return 0;
    800045a8:	4481                	li	s1,0
    800045aa:	b7c5                	j	8000458a <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    800045ac:	85ce                	mv	a1,s3
    800045ae:	00092503          	lw	a0,0(s2)
    800045b2:	ffffe097          	auipc	ra,0xffffe
    800045b6:	482080e7          	jalr	1154(ra) # 80002a34 <ialloc>
    800045ba:	84aa                	mv	s1,a0
    800045bc:	c521                	beqz	a0,80004604 <create+0xec>
  ilock(ip);
    800045be:	ffffe097          	auipc	ra,0xffffe
    800045c2:	610080e7          	jalr	1552(ra) # 80002bce <ilock>
  ip->major = major;
    800045c6:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    800045ca:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    800045ce:	4a05                	li	s4,1
    800045d0:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    800045d4:	8526                	mv	a0,s1
    800045d6:	ffffe097          	auipc	ra,0xffffe
    800045da:	52c080e7          	jalr	1324(ra) # 80002b02 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800045de:	2981                	sext.w	s3,s3
    800045e0:	03498a63          	beq	s3,s4,80004614 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    800045e4:	40d0                	lw	a2,4(s1)
    800045e6:	fb040593          	addi	a1,s0,-80
    800045ea:	854a                	mv	a0,s2
    800045ec:	fffff097          	auipc	ra,0xfffff
    800045f0:	cdc080e7          	jalr	-804(ra) # 800032c8 <dirlink>
    800045f4:	06054b63          	bltz	a0,8000466a <create+0x152>
  iunlockput(dp);
    800045f8:	854a                	mv	a0,s2
    800045fa:	fffff097          	auipc	ra,0xfffff
    800045fe:	836080e7          	jalr	-1994(ra) # 80002e30 <iunlockput>
  return ip;
    80004602:	b761                	j	8000458a <create+0x72>
    panic("create: ialloc");
    80004604:	00004517          	auipc	a0,0x4
    80004608:	06450513          	addi	a0,a0,100 # 80008668 <syscalls+0x2a0>
    8000460c:	00001097          	auipc	ra,0x1
    80004610:	634080e7          	jalr	1588(ra) # 80005c40 <panic>
    dp->nlink++;  // for ".."
    80004614:	04a95783          	lhu	a5,74(s2)
    80004618:	2785                	addiw	a5,a5,1
    8000461a:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    8000461e:	854a                	mv	a0,s2
    80004620:	ffffe097          	auipc	ra,0xffffe
    80004624:	4e2080e7          	jalr	1250(ra) # 80002b02 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004628:	40d0                	lw	a2,4(s1)
    8000462a:	00004597          	auipc	a1,0x4
    8000462e:	04e58593          	addi	a1,a1,78 # 80008678 <syscalls+0x2b0>
    80004632:	8526                	mv	a0,s1
    80004634:	fffff097          	auipc	ra,0xfffff
    80004638:	c94080e7          	jalr	-876(ra) # 800032c8 <dirlink>
    8000463c:	00054f63          	bltz	a0,8000465a <create+0x142>
    80004640:	00492603          	lw	a2,4(s2)
    80004644:	00004597          	auipc	a1,0x4
    80004648:	03c58593          	addi	a1,a1,60 # 80008680 <syscalls+0x2b8>
    8000464c:	8526                	mv	a0,s1
    8000464e:	fffff097          	auipc	ra,0xfffff
    80004652:	c7a080e7          	jalr	-902(ra) # 800032c8 <dirlink>
    80004656:	f80557e3          	bgez	a0,800045e4 <create+0xcc>
      panic("create dots");
    8000465a:	00004517          	auipc	a0,0x4
    8000465e:	02e50513          	addi	a0,a0,46 # 80008688 <syscalls+0x2c0>
    80004662:	00001097          	auipc	ra,0x1
    80004666:	5de080e7          	jalr	1502(ra) # 80005c40 <panic>
    panic("create: dirlink");
    8000466a:	00004517          	auipc	a0,0x4
    8000466e:	02e50513          	addi	a0,a0,46 # 80008698 <syscalls+0x2d0>
    80004672:	00001097          	auipc	ra,0x1
    80004676:	5ce080e7          	jalr	1486(ra) # 80005c40 <panic>
    return 0;
    8000467a:	84aa                	mv	s1,a0
    8000467c:	b739                	j	8000458a <create+0x72>

000000008000467e <sys_dup>:
{
    8000467e:	7179                	addi	sp,sp,-48
    80004680:	f406                	sd	ra,40(sp)
    80004682:	f022                	sd	s0,32(sp)
    80004684:	ec26                	sd	s1,24(sp)
    80004686:	e84a                	sd	s2,16(sp)
    80004688:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000468a:	fd840613          	addi	a2,s0,-40
    8000468e:	4581                	li	a1,0
    80004690:	4501                	li	a0,0
    80004692:	00000097          	auipc	ra,0x0
    80004696:	ddc080e7          	jalr	-548(ra) # 8000446e <argfd>
    return -1;
    8000469a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000469c:	02054363          	bltz	a0,800046c2 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    800046a0:	fd843903          	ld	s2,-40(s0)
    800046a4:	854a                	mv	a0,s2
    800046a6:	00000097          	auipc	ra,0x0
    800046aa:	e30080e7          	jalr	-464(ra) # 800044d6 <fdalloc>
    800046ae:	84aa                	mv	s1,a0
    return -1;
    800046b0:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800046b2:	00054863          	bltz	a0,800046c2 <sys_dup+0x44>
  filedup(f);
    800046b6:	854a                	mv	a0,s2
    800046b8:	fffff097          	auipc	ra,0xfffff
    800046bc:	368080e7          	jalr	872(ra) # 80003a20 <filedup>
  return fd;
    800046c0:	87a6                	mv	a5,s1
}
    800046c2:	853e                	mv	a0,a5
    800046c4:	70a2                	ld	ra,40(sp)
    800046c6:	7402                	ld	s0,32(sp)
    800046c8:	64e2                	ld	s1,24(sp)
    800046ca:	6942                	ld	s2,16(sp)
    800046cc:	6145                	addi	sp,sp,48
    800046ce:	8082                	ret

00000000800046d0 <sys_read>:
{
    800046d0:	7179                	addi	sp,sp,-48
    800046d2:	f406                	sd	ra,40(sp)
    800046d4:	f022                	sd	s0,32(sp)
    800046d6:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046d8:	fe840613          	addi	a2,s0,-24
    800046dc:	4581                	li	a1,0
    800046de:	4501                	li	a0,0
    800046e0:	00000097          	auipc	ra,0x0
    800046e4:	d8e080e7          	jalr	-626(ra) # 8000446e <argfd>
    return -1;
    800046e8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046ea:	04054163          	bltz	a0,8000472c <sys_read+0x5c>
    800046ee:	fe440593          	addi	a1,s0,-28
    800046f2:	4509                	li	a0,2
    800046f4:	ffffe097          	auipc	ra,0xffffe
    800046f8:	968080e7          	jalr	-1688(ra) # 8000205c <argint>
    return -1;
    800046fc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046fe:	02054763          	bltz	a0,8000472c <sys_read+0x5c>
    80004702:	fd840593          	addi	a1,s0,-40
    80004706:	4505                	li	a0,1
    80004708:	ffffe097          	auipc	ra,0xffffe
    8000470c:	976080e7          	jalr	-1674(ra) # 8000207e <argaddr>
    return -1;
    80004710:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004712:	00054d63          	bltz	a0,8000472c <sys_read+0x5c>
  return fileread(f, p, n);
    80004716:	fe442603          	lw	a2,-28(s0)
    8000471a:	fd843583          	ld	a1,-40(s0)
    8000471e:	fe843503          	ld	a0,-24(s0)
    80004722:	fffff097          	auipc	ra,0xfffff
    80004726:	48a080e7          	jalr	1162(ra) # 80003bac <fileread>
    8000472a:	87aa                	mv	a5,a0
}
    8000472c:	853e                	mv	a0,a5
    8000472e:	70a2                	ld	ra,40(sp)
    80004730:	7402                	ld	s0,32(sp)
    80004732:	6145                	addi	sp,sp,48
    80004734:	8082                	ret

0000000080004736 <sys_write>:
{
    80004736:	7179                	addi	sp,sp,-48
    80004738:	f406                	sd	ra,40(sp)
    8000473a:	f022                	sd	s0,32(sp)
    8000473c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000473e:	fe840613          	addi	a2,s0,-24
    80004742:	4581                	li	a1,0
    80004744:	4501                	li	a0,0
    80004746:	00000097          	auipc	ra,0x0
    8000474a:	d28080e7          	jalr	-728(ra) # 8000446e <argfd>
    return -1;
    8000474e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004750:	04054163          	bltz	a0,80004792 <sys_write+0x5c>
    80004754:	fe440593          	addi	a1,s0,-28
    80004758:	4509                	li	a0,2
    8000475a:	ffffe097          	auipc	ra,0xffffe
    8000475e:	902080e7          	jalr	-1790(ra) # 8000205c <argint>
    return -1;
    80004762:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004764:	02054763          	bltz	a0,80004792 <sys_write+0x5c>
    80004768:	fd840593          	addi	a1,s0,-40
    8000476c:	4505                	li	a0,1
    8000476e:	ffffe097          	auipc	ra,0xffffe
    80004772:	910080e7          	jalr	-1776(ra) # 8000207e <argaddr>
    return -1;
    80004776:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004778:	00054d63          	bltz	a0,80004792 <sys_write+0x5c>
  return filewrite(f, p, n);
    8000477c:	fe442603          	lw	a2,-28(s0)
    80004780:	fd843583          	ld	a1,-40(s0)
    80004784:	fe843503          	ld	a0,-24(s0)
    80004788:	fffff097          	auipc	ra,0xfffff
    8000478c:	4e6080e7          	jalr	1254(ra) # 80003c6e <filewrite>
    80004790:	87aa                	mv	a5,a0
}
    80004792:	853e                	mv	a0,a5
    80004794:	70a2                	ld	ra,40(sp)
    80004796:	7402                	ld	s0,32(sp)
    80004798:	6145                	addi	sp,sp,48
    8000479a:	8082                	ret

000000008000479c <sys_close>:
{
    8000479c:	1101                	addi	sp,sp,-32
    8000479e:	ec06                	sd	ra,24(sp)
    800047a0:	e822                	sd	s0,16(sp)
    800047a2:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800047a4:	fe040613          	addi	a2,s0,-32
    800047a8:	fec40593          	addi	a1,s0,-20
    800047ac:	4501                	li	a0,0
    800047ae:	00000097          	auipc	ra,0x0
    800047b2:	cc0080e7          	jalr	-832(ra) # 8000446e <argfd>
    return -1;
    800047b6:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800047b8:	02054463          	bltz	a0,800047e0 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800047bc:	ffffc097          	auipc	ra,0xffffc
    800047c0:	7c4080e7          	jalr	1988(ra) # 80000f80 <myproc>
    800047c4:	fec42783          	lw	a5,-20(s0)
    800047c8:	07e9                	addi	a5,a5,26
    800047ca:	078e                	slli	a5,a5,0x3
    800047cc:	953e                	add	a0,a0,a5
    800047ce:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800047d2:	fe043503          	ld	a0,-32(s0)
    800047d6:	fffff097          	auipc	ra,0xfffff
    800047da:	29c080e7          	jalr	668(ra) # 80003a72 <fileclose>
  return 0;
    800047de:	4781                	li	a5,0
}
    800047e0:	853e                	mv	a0,a5
    800047e2:	60e2                	ld	ra,24(sp)
    800047e4:	6442                	ld	s0,16(sp)
    800047e6:	6105                	addi	sp,sp,32
    800047e8:	8082                	ret

00000000800047ea <sys_fstat>:
{
    800047ea:	1101                	addi	sp,sp,-32
    800047ec:	ec06                	sd	ra,24(sp)
    800047ee:	e822                	sd	s0,16(sp)
    800047f0:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047f2:	fe840613          	addi	a2,s0,-24
    800047f6:	4581                	li	a1,0
    800047f8:	4501                	li	a0,0
    800047fa:	00000097          	auipc	ra,0x0
    800047fe:	c74080e7          	jalr	-908(ra) # 8000446e <argfd>
    return -1;
    80004802:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004804:	02054563          	bltz	a0,8000482e <sys_fstat+0x44>
    80004808:	fe040593          	addi	a1,s0,-32
    8000480c:	4505                	li	a0,1
    8000480e:	ffffe097          	auipc	ra,0xffffe
    80004812:	870080e7          	jalr	-1936(ra) # 8000207e <argaddr>
    return -1;
    80004816:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004818:	00054b63          	bltz	a0,8000482e <sys_fstat+0x44>
  return filestat(f, st);
    8000481c:	fe043583          	ld	a1,-32(s0)
    80004820:	fe843503          	ld	a0,-24(s0)
    80004824:	fffff097          	auipc	ra,0xfffff
    80004828:	316080e7          	jalr	790(ra) # 80003b3a <filestat>
    8000482c:	87aa                	mv	a5,a0
}
    8000482e:	853e                	mv	a0,a5
    80004830:	60e2                	ld	ra,24(sp)
    80004832:	6442                	ld	s0,16(sp)
    80004834:	6105                	addi	sp,sp,32
    80004836:	8082                	ret

0000000080004838 <sys_link>:
{
    80004838:	7169                	addi	sp,sp,-304
    8000483a:	f606                	sd	ra,296(sp)
    8000483c:	f222                	sd	s0,288(sp)
    8000483e:	ee26                	sd	s1,280(sp)
    80004840:	ea4a                	sd	s2,272(sp)
    80004842:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004844:	08000613          	li	a2,128
    80004848:	ed040593          	addi	a1,s0,-304
    8000484c:	4501                	li	a0,0
    8000484e:	ffffe097          	auipc	ra,0xffffe
    80004852:	852080e7          	jalr	-1966(ra) # 800020a0 <argstr>
    return -1;
    80004856:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004858:	10054e63          	bltz	a0,80004974 <sys_link+0x13c>
    8000485c:	08000613          	li	a2,128
    80004860:	f5040593          	addi	a1,s0,-176
    80004864:	4505                	li	a0,1
    80004866:	ffffe097          	auipc	ra,0xffffe
    8000486a:	83a080e7          	jalr	-1990(ra) # 800020a0 <argstr>
    return -1;
    8000486e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004870:	10054263          	bltz	a0,80004974 <sys_link+0x13c>
  begin_op();
    80004874:	fffff097          	auipc	ra,0xfffff
    80004878:	d36080e7          	jalr	-714(ra) # 800035aa <begin_op>
  if((ip = namei(old)) == 0){
    8000487c:	ed040513          	addi	a0,s0,-304
    80004880:	fffff097          	auipc	ra,0xfffff
    80004884:	b0a080e7          	jalr	-1270(ra) # 8000338a <namei>
    80004888:	84aa                	mv	s1,a0
    8000488a:	c551                	beqz	a0,80004916 <sys_link+0xde>
  ilock(ip);
    8000488c:	ffffe097          	auipc	ra,0xffffe
    80004890:	342080e7          	jalr	834(ra) # 80002bce <ilock>
  if(ip->type == T_DIR){
    80004894:	04449703          	lh	a4,68(s1)
    80004898:	4785                	li	a5,1
    8000489a:	08f70463          	beq	a4,a5,80004922 <sys_link+0xea>
  ip->nlink++;
    8000489e:	04a4d783          	lhu	a5,74(s1)
    800048a2:	2785                	addiw	a5,a5,1
    800048a4:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800048a8:	8526                	mv	a0,s1
    800048aa:	ffffe097          	auipc	ra,0xffffe
    800048ae:	258080e7          	jalr	600(ra) # 80002b02 <iupdate>
  iunlock(ip);
    800048b2:	8526                	mv	a0,s1
    800048b4:	ffffe097          	auipc	ra,0xffffe
    800048b8:	3dc080e7          	jalr	988(ra) # 80002c90 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800048bc:	fd040593          	addi	a1,s0,-48
    800048c0:	f5040513          	addi	a0,s0,-176
    800048c4:	fffff097          	auipc	ra,0xfffff
    800048c8:	ae4080e7          	jalr	-1308(ra) # 800033a8 <nameiparent>
    800048cc:	892a                	mv	s2,a0
    800048ce:	c935                	beqz	a0,80004942 <sys_link+0x10a>
  ilock(dp);
    800048d0:	ffffe097          	auipc	ra,0xffffe
    800048d4:	2fe080e7          	jalr	766(ra) # 80002bce <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800048d8:	00092703          	lw	a4,0(s2)
    800048dc:	409c                	lw	a5,0(s1)
    800048de:	04f71d63          	bne	a4,a5,80004938 <sys_link+0x100>
    800048e2:	40d0                	lw	a2,4(s1)
    800048e4:	fd040593          	addi	a1,s0,-48
    800048e8:	854a                	mv	a0,s2
    800048ea:	fffff097          	auipc	ra,0xfffff
    800048ee:	9de080e7          	jalr	-1570(ra) # 800032c8 <dirlink>
    800048f2:	04054363          	bltz	a0,80004938 <sys_link+0x100>
  iunlockput(dp);
    800048f6:	854a                	mv	a0,s2
    800048f8:	ffffe097          	auipc	ra,0xffffe
    800048fc:	538080e7          	jalr	1336(ra) # 80002e30 <iunlockput>
  iput(ip);
    80004900:	8526                	mv	a0,s1
    80004902:	ffffe097          	auipc	ra,0xffffe
    80004906:	486080e7          	jalr	1158(ra) # 80002d88 <iput>
  end_op();
    8000490a:	fffff097          	auipc	ra,0xfffff
    8000490e:	d1e080e7          	jalr	-738(ra) # 80003628 <end_op>
  return 0;
    80004912:	4781                	li	a5,0
    80004914:	a085                	j	80004974 <sys_link+0x13c>
    end_op();
    80004916:	fffff097          	auipc	ra,0xfffff
    8000491a:	d12080e7          	jalr	-750(ra) # 80003628 <end_op>
    return -1;
    8000491e:	57fd                	li	a5,-1
    80004920:	a891                	j	80004974 <sys_link+0x13c>
    iunlockput(ip);
    80004922:	8526                	mv	a0,s1
    80004924:	ffffe097          	auipc	ra,0xffffe
    80004928:	50c080e7          	jalr	1292(ra) # 80002e30 <iunlockput>
    end_op();
    8000492c:	fffff097          	auipc	ra,0xfffff
    80004930:	cfc080e7          	jalr	-772(ra) # 80003628 <end_op>
    return -1;
    80004934:	57fd                	li	a5,-1
    80004936:	a83d                	j	80004974 <sys_link+0x13c>
    iunlockput(dp);
    80004938:	854a                	mv	a0,s2
    8000493a:	ffffe097          	auipc	ra,0xffffe
    8000493e:	4f6080e7          	jalr	1270(ra) # 80002e30 <iunlockput>
  ilock(ip);
    80004942:	8526                	mv	a0,s1
    80004944:	ffffe097          	auipc	ra,0xffffe
    80004948:	28a080e7          	jalr	650(ra) # 80002bce <ilock>
  ip->nlink--;
    8000494c:	04a4d783          	lhu	a5,74(s1)
    80004950:	37fd                	addiw	a5,a5,-1
    80004952:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004956:	8526                	mv	a0,s1
    80004958:	ffffe097          	auipc	ra,0xffffe
    8000495c:	1aa080e7          	jalr	426(ra) # 80002b02 <iupdate>
  iunlockput(ip);
    80004960:	8526                	mv	a0,s1
    80004962:	ffffe097          	auipc	ra,0xffffe
    80004966:	4ce080e7          	jalr	1230(ra) # 80002e30 <iunlockput>
  end_op();
    8000496a:	fffff097          	auipc	ra,0xfffff
    8000496e:	cbe080e7          	jalr	-834(ra) # 80003628 <end_op>
  return -1;
    80004972:	57fd                	li	a5,-1
}
    80004974:	853e                	mv	a0,a5
    80004976:	70b2                	ld	ra,296(sp)
    80004978:	7412                	ld	s0,288(sp)
    8000497a:	64f2                	ld	s1,280(sp)
    8000497c:	6952                	ld	s2,272(sp)
    8000497e:	6155                	addi	sp,sp,304
    80004980:	8082                	ret

0000000080004982 <sys_unlink>:
{
    80004982:	7151                	addi	sp,sp,-240
    80004984:	f586                	sd	ra,232(sp)
    80004986:	f1a2                	sd	s0,224(sp)
    80004988:	eda6                	sd	s1,216(sp)
    8000498a:	e9ca                	sd	s2,208(sp)
    8000498c:	e5ce                	sd	s3,200(sp)
    8000498e:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004990:	08000613          	li	a2,128
    80004994:	f3040593          	addi	a1,s0,-208
    80004998:	4501                	li	a0,0
    8000499a:	ffffd097          	auipc	ra,0xffffd
    8000499e:	706080e7          	jalr	1798(ra) # 800020a0 <argstr>
    800049a2:	18054163          	bltz	a0,80004b24 <sys_unlink+0x1a2>
  begin_op();
    800049a6:	fffff097          	auipc	ra,0xfffff
    800049aa:	c04080e7          	jalr	-1020(ra) # 800035aa <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800049ae:	fb040593          	addi	a1,s0,-80
    800049b2:	f3040513          	addi	a0,s0,-208
    800049b6:	fffff097          	auipc	ra,0xfffff
    800049ba:	9f2080e7          	jalr	-1550(ra) # 800033a8 <nameiparent>
    800049be:	84aa                	mv	s1,a0
    800049c0:	c979                	beqz	a0,80004a96 <sys_unlink+0x114>
  ilock(dp);
    800049c2:	ffffe097          	auipc	ra,0xffffe
    800049c6:	20c080e7          	jalr	524(ra) # 80002bce <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800049ca:	00004597          	auipc	a1,0x4
    800049ce:	cae58593          	addi	a1,a1,-850 # 80008678 <syscalls+0x2b0>
    800049d2:	fb040513          	addi	a0,s0,-80
    800049d6:	ffffe097          	auipc	ra,0xffffe
    800049da:	6c2080e7          	jalr	1730(ra) # 80003098 <namecmp>
    800049de:	14050a63          	beqz	a0,80004b32 <sys_unlink+0x1b0>
    800049e2:	00004597          	auipc	a1,0x4
    800049e6:	c9e58593          	addi	a1,a1,-866 # 80008680 <syscalls+0x2b8>
    800049ea:	fb040513          	addi	a0,s0,-80
    800049ee:	ffffe097          	auipc	ra,0xffffe
    800049f2:	6aa080e7          	jalr	1706(ra) # 80003098 <namecmp>
    800049f6:	12050e63          	beqz	a0,80004b32 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    800049fa:	f2c40613          	addi	a2,s0,-212
    800049fe:	fb040593          	addi	a1,s0,-80
    80004a02:	8526                	mv	a0,s1
    80004a04:	ffffe097          	auipc	ra,0xffffe
    80004a08:	6ae080e7          	jalr	1710(ra) # 800030b2 <dirlookup>
    80004a0c:	892a                	mv	s2,a0
    80004a0e:	12050263          	beqz	a0,80004b32 <sys_unlink+0x1b0>
  ilock(ip);
    80004a12:	ffffe097          	auipc	ra,0xffffe
    80004a16:	1bc080e7          	jalr	444(ra) # 80002bce <ilock>
  if(ip->nlink < 1)
    80004a1a:	04a91783          	lh	a5,74(s2)
    80004a1e:	08f05263          	blez	a5,80004aa2 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004a22:	04491703          	lh	a4,68(s2)
    80004a26:	4785                	li	a5,1
    80004a28:	08f70563          	beq	a4,a5,80004ab2 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004a2c:	4641                	li	a2,16
    80004a2e:	4581                	li	a1,0
    80004a30:	fc040513          	addi	a0,s0,-64
    80004a34:	ffffc097          	auipc	ra,0xffffc
    80004a38:	856080e7          	jalr	-1962(ra) # 8000028a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a3c:	4741                	li	a4,16
    80004a3e:	f2c42683          	lw	a3,-212(s0)
    80004a42:	fc040613          	addi	a2,s0,-64
    80004a46:	4581                	li	a1,0
    80004a48:	8526                	mv	a0,s1
    80004a4a:	ffffe097          	auipc	ra,0xffffe
    80004a4e:	530080e7          	jalr	1328(ra) # 80002f7a <writei>
    80004a52:	47c1                	li	a5,16
    80004a54:	0af51563          	bne	a0,a5,80004afe <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004a58:	04491703          	lh	a4,68(s2)
    80004a5c:	4785                	li	a5,1
    80004a5e:	0af70863          	beq	a4,a5,80004b0e <sys_unlink+0x18c>
  iunlockput(dp);
    80004a62:	8526                	mv	a0,s1
    80004a64:	ffffe097          	auipc	ra,0xffffe
    80004a68:	3cc080e7          	jalr	972(ra) # 80002e30 <iunlockput>
  ip->nlink--;
    80004a6c:	04a95783          	lhu	a5,74(s2)
    80004a70:	37fd                	addiw	a5,a5,-1
    80004a72:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004a76:	854a                	mv	a0,s2
    80004a78:	ffffe097          	auipc	ra,0xffffe
    80004a7c:	08a080e7          	jalr	138(ra) # 80002b02 <iupdate>
  iunlockput(ip);
    80004a80:	854a                	mv	a0,s2
    80004a82:	ffffe097          	auipc	ra,0xffffe
    80004a86:	3ae080e7          	jalr	942(ra) # 80002e30 <iunlockput>
  end_op();
    80004a8a:	fffff097          	auipc	ra,0xfffff
    80004a8e:	b9e080e7          	jalr	-1122(ra) # 80003628 <end_op>
  return 0;
    80004a92:	4501                	li	a0,0
    80004a94:	a84d                	j	80004b46 <sys_unlink+0x1c4>
    end_op();
    80004a96:	fffff097          	auipc	ra,0xfffff
    80004a9a:	b92080e7          	jalr	-1134(ra) # 80003628 <end_op>
    return -1;
    80004a9e:	557d                	li	a0,-1
    80004aa0:	a05d                	j	80004b46 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004aa2:	00004517          	auipc	a0,0x4
    80004aa6:	c0650513          	addi	a0,a0,-1018 # 800086a8 <syscalls+0x2e0>
    80004aaa:	00001097          	auipc	ra,0x1
    80004aae:	196080e7          	jalr	406(ra) # 80005c40 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004ab2:	04c92703          	lw	a4,76(s2)
    80004ab6:	02000793          	li	a5,32
    80004aba:	f6e7f9e3          	bgeu	a5,a4,80004a2c <sys_unlink+0xaa>
    80004abe:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004ac2:	4741                	li	a4,16
    80004ac4:	86ce                	mv	a3,s3
    80004ac6:	f1840613          	addi	a2,s0,-232
    80004aca:	4581                	li	a1,0
    80004acc:	854a                	mv	a0,s2
    80004ace:	ffffe097          	auipc	ra,0xffffe
    80004ad2:	3b4080e7          	jalr	948(ra) # 80002e82 <readi>
    80004ad6:	47c1                	li	a5,16
    80004ad8:	00f51b63          	bne	a0,a5,80004aee <sys_unlink+0x16c>
    if(de.inum != 0)
    80004adc:	f1845783          	lhu	a5,-232(s0)
    80004ae0:	e7a1                	bnez	a5,80004b28 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004ae2:	29c1                	addiw	s3,s3,16
    80004ae4:	04c92783          	lw	a5,76(s2)
    80004ae8:	fcf9ede3          	bltu	s3,a5,80004ac2 <sys_unlink+0x140>
    80004aec:	b781                	j	80004a2c <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004aee:	00004517          	auipc	a0,0x4
    80004af2:	bd250513          	addi	a0,a0,-1070 # 800086c0 <syscalls+0x2f8>
    80004af6:	00001097          	auipc	ra,0x1
    80004afa:	14a080e7          	jalr	330(ra) # 80005c40 <panic>
    panic("unlink: writei");
    80004afe:	00004517          	auipc	a0,0x4
    80004b02:	bda50513          	addi	a0,a0,-1062 # 800086d8 <syscalls+0x310>
    80004b06:	00001097          	auipc	ra,0x1
    80004b0a:	13a080e7          	jalr	314(ra) # 80005c40 <panic>
    dp->nlink--;
    80004b0e:	04a4d783          	lhu	a5,74(s1)
    80004b12:	37fd                	addiw	a5,a5,-1
    80004b14:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004b18:	8526                	mv	a0,s1
    80004b1a:	ffffe097          	auipc	ra,0xffffe
    80004b1e:	fe8080e7          	jalr	-24(ra) # 80002b02 <iupdate>
    80004b22:	b781                	j	80004a62 <sys_unlink+0xe0>
    return -1;
    80004b24:	557d                	li	a0,-1
    80004b26:	a005                	j	80004b46 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004b28:	854a                	mv	a0,s2
    80004b2a:	ffffe097          	auipc	ra,0xffffe
    80004b2e:	306080e7          	jalr	774(ra) # 80002e30 <iunlockput>
  iunlockput(dp);
    80004b32:	8526                	mv	a0,s1
    80004b34:	ffffe097          	auipc	ra,0xffffe
    80004b38:	2fc080e7          	jalr	764(ra) # 80002e30 <iunlockput>
  end_op();
    80004b3c:	fffff097          	auipc	ra,0xfffff
    80004b40:	aec080e7          	jalr	-1300(ra) # 80003628 <end_op>
  return -1;
    80004b44:	557d                	li	a0,-1
}
    80004b46:	70ae                	ld	ra,232(sp)
    80004b48:	740e                	ld	s0,224(sp)
    80004b4a:	64ee                	ld	s1,216(sp)
    80004b4c:	694e                	ld	s2,208(sp)
    80004b4e:	69ae                	ld	s3,200(sp)
    80004b50:	616d                	addi	sp,sp,240
    80004b52:	8082                	ret

0000000080004b54 <sys_open>:

uint64
sys_open(void)
{
    80004b54:	7131                	addi	sp,sp,-192
    80004b56:	fd06                	sd	ra,184(sp)
    80004b58:	f922                	sd	s0,176(sp)
    80004b5a:	f526                	sd	s1,168(sp)
    80004b5c:	f14a                	sd	s2,160(sp)
    80004b5e:	ed4e                	sd	s3,152(sp)
    80004b60:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b62:	08000613          	li	a2,128
    80004b66:	f5040593          	addi	a1,s0,-176
    80004b6a:	4501                	li	a0,0
    80004b6c:	ffffd097          	auipc	ra,0xffffd
    80004b70:	534080e7          	jalr	1332(ra) # 800020a0 <argstr>
    return -1;
    80004b74:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b76:	0c054163          	bltz	a0,80004c38 <sys_open+0xe4>
    80004b7a:	f4c40593          	addi	a1,s0,-180
    80004b7e:	4505                	li	a0,1
    80004b80:	ffffd097          	auipc	ra,0xffffd
    80004b84:	4dc080e7          	jalr	1244(ra) # 8000205c <argint>
    80004b88:	0a054863          	bltz	a0,80004c38 <sys_open+0xe4>

  begin_op();
    80004b8c:	fffff097          	auipc	ra,0xfffff
    80004b90:	a1e080e7          	jalr	-1506(ra) # 800035aa <begin_op>

  if(omode & O_CREATE){
    80004b94:	f4c42783          	lw	a5,-180(s0)
    80004b98:	2007f793          	andi	a5,a5,512
    80004b9c:	cbdd                	beqz	a5,80004c52 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004b9e:	4681                	li	a3,0
    80004ba0:	4601                	li	a2,0
    80004ba2:	4589                	li	a1,2
    80004ba4:	f5040513          	addi	a0,s0,-176
    80004ba8:	00000097          	auipc	ra,0x0
    80004bac:	970080e7          	jalr	-1680(ra) # 80004518 <create>
    80004bb0:	892a                	mv	s2,a0
    if(ip == 0){
    80004bb2:	c959                	beqz	a0,80004c48 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004bb4:	04491703          	lh	a4,68(s2)
    80004bb8:	478d                	li	a5,3
    80004bba:	00f71763          	bne	a4,a5,80004bc8 <sys_open+0x74>
    80004bbe:	04695703          	lhu	a4,70(s2)
    80004bc2:	47a5                	li	a5,9
    80004bc4:	0ce7ec63          	bltu	a5,a4,80004c9c <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004bc8:	fffff097          	auipc	ra,0xfffff
    80004bcc:	dee080e7          	jalr	-530(ra) # 800039b6 <filealloc>
    80004bd0:	89aa                	mv	s3,a0
    80004bd2:	10050263          	beqz	a0,80004cd6 <sys_open+0x182>
    80004bd6:	00000097          	auipc	ra,0x0
    80004bda:	900080e7          	jalr	-1792(ra) # 800044d6 <fdalloc>
    80004bde:	84aa                	mv	s1,a0
    80004be0:	0e054663          	bltz	a0,80004ccc <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004be4:	04491703          	lh	a4,68(s2)
    80004be8:	478d                	li	a5,3
    80004bea:	0cf70463          	beq	a4,a5,80004cb2 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004bee:	4789                	li	a5,2
    80004bf0:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004bf4:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004bf8:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004bfc:	f4c42783          	lw	a5,-180(s0)
    80004c00:	0017c713          	xori	a4,a5,1
    80004c04:	8b05                	andi	a4,a4,1
    80004c06:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004c0a:	0037f713          	andi	a4,a5,3
    80004c0e:	00e03733          	snez	a4,a4
    80004c12:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004c16:	4007f793          	andi	a5,a5,1024
    80004c1a:	c791                	beqz	a5,80004c26 <sys_open+0xd2>
    80004c1c:	04491703          	lh	a4,68(s2)
    80004c20:	4789                	li	a5,2
    80004c22:	08f70f63          	beq	a4,a5,80004cc0 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004c26:	854a                	mv	a0,s2
    80004c28:	ffffe097          	auipc	ra,0xffffe
    80004c2c:	068080e7          	jalr	104(ra) # 80002c90 <iunlock>
  end_op();
    80004c30:	fffff097          	auipc	ra,0xfffff
    80004c34:	9f8080e7          	jalr	-1544(ra) # 80003628 <end_op>

  return fd;
}
    80004c38:	8526                	mv	a0,s1
    80004c3a:	70ea                	ld	ra,184(sp)
    80004c3c:	744a                	ld	s0,176(sp)
    80004c3e:	74aa                	ld	s1,168(sp)
    80004c40:	790a                	ld	s2,160(sp)
    80004c42:	69ea                	ld	s3,152(sp)
    80004c44:	6129                	addi	sp,sp,192
    80004c46:	8082                	ret
      end_op();
    80004c48:	fffff097          	auipc	ra,0xfffff
    80004c4c:	9e0080e7          	jalr	-1568(ra) # 80003628 <end_op>
      return -1;
    80004c50:	b7e5                	j	80004c38 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004c52:	f5040513          	addi	a0,s0,-176
    80004c56:	ffffe097          	auipc	ra,0xffffe
    80004c5a:	734080e7          	jalr	1844(ra) # 8000338a <namei>
    80004c5e:	892a                	mv	s2,a0
    80004c60:	c905                	beqz	a0,80004c90 <sys_open+0x13c>
    ilock(ip);
    80004c62:	ffffe097          	auipc	ra,0xffffe
    80004c66:	f6c080e7          	jalr	-148(ra) # 80002bce <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004c6a:	04491703          	lh	a4,68(s2)
    80004c6e:	4785                	li	a5,1
    80004c70:	f4f712e3          	bne	a4,a5,80004bb4 <sys_open+0x60>
    80004c74:	f4c42783          	lw	a5,-180(s0)
    80004c78:	dba1                	beqz	a5,80004bc8 <sys_open+0x74>
      iunlockput(ip);
    80004c7a:	854a                	mv	a0,s2
    80004c7c:	ffffe097          	auipc	ra,0xffffe
    80004c80:	1b4080e7          	jalr	436(ra) # 80002e30 <iunlockput>
      end_op();
    80004c84:	fffff097          	auipc	ra,0xfffff
    80004c88:	9a4080e7          	jalr	-1628(ra) # 80003628 <end_op>
      return -1;
    80004c8c:	54fd                	li	s1,-1
    80004c8e:	b76d                	j	80004c38 <sys_open+0xe4>
      end_op();
    80004c90:	fffff097          	auipc	ra,0xfffff
    80004c94:	998080e7          	jalr	-1640(ra) # 80003628 <end_op>
      return -1;
    80004c98:	54fd                	li	s1,-1
    80004c9a:	bf79                	j	80004c38 <sys_open+0xe4>
    iunlockput(ip);
    80004c9c:	854a                	mv	a0,s2
    80004c9e:	ffffe097          	auipc	ra,0xffffe
    80004ca2:	192080e7          	jalr	402(ra) # 80002e30 <iunlockput>
    end_op();
    80004ca6:	fffff097          	auipc	ra,0xfffff
    80004caa:	982080e7          	jalr	-1662(ra) # 80003628 <end_op>
    return -1;
    80004cae:	54fd                	li	s1,-1
    80004cb0:	b761                	j	80004c38 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004cb2:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004cb6:	04691783          	lh	a5,70(s2)
    80004cba:	02f99223          	sh	a5,36(s3)
    80004cbe:	bf2d                	j	80004bf8 <sys_open+0xa4>
    itrunc(ip);
    80004cc0:	854a                	mv	a0,s2
    80004cc2:	ffffe097          	auipc	ra,0xffffe
    80004cc6:	01a080e7          	jalr	26(ra) # 80002cdc <itrunc>
    80004cca:	bfb1                	j	80004c26 <sys_open+0xd2>
      fileclose(f);
    80004ccc:	854e                	mv	a0,s3
    80004cce:	fffff097          	auipc	ra,0xfffff
    80004cd2:	da4080e7          	jalr	-604(ra) # 80003a72 <fileclose>
    iunlockput(ip);
    80004cd6:	854a                	mv	a0,s2
    80004cd8:	ffffe097          	auipc	ra,0xffffe
    80004cdc:	158080e7          	jalr	344(ra) # 80002e30 <iunlockput>
    end_op();
    80004ce0:	fffff097          	auipc	ra,0xfffff
    80004ce4:	948080e7          	jalr	-1720(ra) # 80003628 <end_op>
    return -1;
    80004ce8:	54fd                	li	s1,-1
    80004cea:	b7b9                	j	80004c38 <sys_open+0xe4>

0000000080004cec <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004cec:	7175                	addi	sp,sp,-144
    80004cee:	e506                	sd	ra,136(sp)
    80004cf0:	e122                	sd	s0,128(sp)
    80004cf2:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004cf4:	fffff097          	auipc	ra,0xfffff
    80004cf8:	8b6080e7          	jalr	-1866(ra) # 800035aa <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004cfc:	08000613          	li	a2,128
    80004d00:	f7040593          	addi	a1,s0,-144
    80004d04:	4501                	li	a0,0
    80004d06:	ffffd097          	auipc	ra,0xffffd
    80004d0a:	39a080e7          	jalr	922(ra) # 800020a0 <argstr>
    80004d0e:	02054963          	bltz	a0,80004d40 <sys_mkdir+0x54>
    80004d12:	4681                	li	a3,0
    80004d14:	4601                	li	a2,0
    80004d16:	4585                	li	a1,1
    80004d18:	f7040513          	addi	a0,s0,-144
    80004d1c:	fffff097          	auipc	ra,0xfffff
    80004d20:	7fc080e7          	jalr	2044(ra) # 80004518 <create>
    80004d24:	cd11                	beqz	a0,80004d40 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d26:	ffffe097          	auipc	ra,0xffffe
    80004d2a:	10a080e7          	jalr	266(ra) # 80002e30 <iunlockput>
  end_op();
    80004d2e:	fffff097          	auipc	ra,0xfffff
    80004d32:	8fa080e7          	jalr	-1798(ra) # 80003628 <end_op>
  return 0;
    80004d36:	4501                	li	a0,0
}
    80004d38:	60aa                	ld	ra,136(sp)
    80004d3a:	640a                	ld	s0,128(sp)
    80004d3c:	6149                	addi	sp,sp,144
    80004d3e:	8082                	ret
    end_op();
    80004d40:	fffff097          	auipc	ra,0xfffff
    80004d44:	8e8080e7          	jalr	-1816(ra) # 80003628 <end_op>
    return -1;
    80004d48:	557d                	li	a0,-1
    80004d4a:	b7fd                	j	80004d38 <sys_mkdir+0x4c>

0000000080004d4c <sys_mknod>:

uint64
sys_mknod(void)
{
    80004d4c:	7135                	addi	sp,sp,-160
    80004d4e:	ed06                	sd	ra,152(sp)
    80004d50:	e922                	sd	s0,144(sp)
    80004d52:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004d54:	fffff097          	auipc	ra,0xfffff
    80004d58:	856080e7          	jalr	-1962(ra) # 800035aa <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d5c:	08000613          	li	a2,128
    80004d60:	f7040593          	addi	a1,s0,-144
    80004d64:	4501                	li	a0,0
    80004d66:	ffffd097          	auipc	ra,0xffffd
    80004d6a:	33a080e7          	jalr	826(ra) # 800020a0 <argstr>
    80004d6e:	04054a63          	bltz	a0,80004dc2 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004d72:	f6c40593          	addi	a1,s0,-148
    80004d76:	4505                	li	a0,1
    80004d78:	ffffd097          	auipc	ra,0xffffd
    80004d7c:	2e4080e7          	jalr	740(ra) # 8000205c <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d80:	04054163          	bltz	a0,80004dc2 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004d84:	f6840593          	addi	a1,s0,-152
    80004d88:	4509                	li	a0,2
    80004d8a:	ffffd097          	auipc	ra,0xffffd
    80004d8e:	2d2080e7          	jalr	722(ra) # 8000205c <argint>
     argint(1, &major) < 0 ||
    80004d92:	02054863          	bltz	a0,80004dc2 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004d96:	f6841683          	lh	a3,-152(s0)
    80004d9a:	f6c41603          	lh	a2,-148(s0)
    80004d9e:	458d                	li	a1,3
    80004da0:	f7040513          	addi	a0,s0,-144
    80004da4:	fffff097          	auipc	ra,0xfffff
    80004da8:	774080e7          	jalr	1908(ra) # 80004518 <create>
     argint(2, &minor) < 0 ||
    80004dac:	c919                	beqz	a0,80004dc2 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004dae:	ffffe097          	auipc	ra,0xffffe
    80004db2:	082080e7          	jalr	130(ra) # 80002e30 <iunlockput>
  end_op();
    80004db6:	fffff097          	auipc	ra,0xfffff
    80004dba:	872080e7          	jalr	-1934(ra) # 80003628 <end_op>
  return 0;
    80004dbe:	4501                	li	a0,0
    80004dc0:	a031                	j	80004dcc <sys_mknod+0x80>
    end_op();
    80004dc2:	fffff097          	auipc	ra,0xfffff
    80004dc6:	866080e7          	jalr	-1946(ra) # 80003628 <end_op>
    return -1;
    80004dca:	557d                	li	a0,-1
}
    80004dcc:	60ea                	ld	ra,152(sp)
    80004dce:	644a                	ld	s0,144(sp)
    80004dd0:	610d                	addi	sp,sp,160
    80004dd2:	8082                	ret

0000000080004dd4 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004dd4:	7135                	addi	sp,sp,-160
    80004dd6:	ed06                	sd	ra,152(sp)
    80004dd8:	e922                	sd	s0,144(sp)
    80004dda:	e526                	sd	s1,136(sp)
    80004ddc:	e14a                	sd	s2,128(sp)
    80004dde:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004de0:	ffffc097          	auipc	ra,0xffffc
    80004de4:	1a0080e7          	jalr	416(ra) # 80000f80 <myproc>
    80004de8:	892a                	mv	s2,a0
  
  begin_op();
    80004dea:	ffffe097          	auipc	ra,0xffffe
    80004dee:	7c0080e7          	jalr	1984(ra) # 800035aa <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004df2:	08000613          	li	a2,128
    80004df6:	f6040593          	addi	a1,s0,-160
    80004dfa:	4501                	li	a0,0
    80004dfc:	ffffd097          	auipc	ra,0xffffd
    80004e00:	2a4080e7          	jalr	676(ra) # 800020a0 <argstr>
    80004e04:	04054b63          	bltz	a0,80004e5a <sys_chdir+0x86>
    80004e08:	f6040513          	addi	a0,s0,-160
    80004e0c:	ffffe097          	auipc	ra,0xffffe
    80004e10:	57e080e7          	jalr	1406(ra) # 8000338a <namei>
    80004e14:	84aa                	mv	s1,a0
    80004e16:	c131                	beqz	a0,80004e5a <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004e18:	ffffe097          	auipc	ra,0xffffe
    80004e1c:	db6080e7          	jalr	-586(ra) # 80002bce <ilock>
  if(ip->type != T_DIR){
    80004e20:	04449703          	lh	a4,68(s1)
    80004e24:	4785                	li	a5,1
    80004e26:	04f71063          	bne	a4,a5,80004e66 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004e2a:	8526                	mv	a0,s1
    80004e2c:	ffffe097          	auipc	ra,0xffffe
    80004e30:	e64080e7          	jalr	-412(ra) # 80002c90 <iunlock>
  iput(p->cwd);
    80004e34:	15093503          	ld	a0,336(s2)
    80004e38:	ffffe097          	auipc	ra,0xffffe
    80004e3c:	f50080e7          	jalr	-176(ra) # 80002d88 <iput>
  end_op();
    80004e40:	ffffe097          	auipc	ra,0xffffe
    80004e44:	7e8080e7          	jalr	2024(ra) # 80003628 <end_op>
  p->cwd = ip;
    80004e48:	14993823          	sd	s1,336(s2)
  return 0;
    80004e4c:	4501                	li	a0,0
}
    80004e4e:	60ea                	ld	ra,152(sp)
    80004e50:	644a                	ld	s0,144(sp)
    80004e52:	64aa                	ld	s1,136(sp)
    80004e54:	690a                	ld	s2,128(sp)
    80004e56:	610d                	addi	sp,sp,160
    80004e58:	8082                	ret
    end_op();
    80004e5a:	ffffe097          	auipc	ra,0xffffe
    80004e5e:	7ce080e7          	jalr	1998(ra) # 80003628 <end_op>
    return -1;
    80004e62:	557d                	li	a0,-1
    80004e64:	b7ed                	j	80004e4e <sys_chdir+0x7a>
    iunlockput(ip);
    80004e66:	8526                	mv	a0,s1
    80004e68:	ffffe097          	auipc	ra,0xffffe
    80004e6c:	fc8080e7          	jalr	-56(ra) # 80002e30 <iunlockput>
    end_op();
    80004e70:	ffffe097          	auipc	ra,0xffffe
    80004e74:	7b8080e7          	jalr	1976(ra) # 80003628 <end_op>
    return -1;
    80004e78:	557d                	li	a0,-1
    80004e7a:	bfd1                	j	80004e4e <sys_chdir+0x7a>

0000000080004e7c <sys_exec>:

uint64
sys_exec(void)
{
    80004e7c:	7145                	addi	sp,sp,-464
    80004e7e:	e786                	sd	ra,456(sp)
    80004e80:	e3a2                	sd	s0,448(sp)
    80004e82:	ff26                	sd	s1,440(sp)
    80004e84:	fb4a                	sd	s2,432(sp)
    80004e86:	f74e                	sd	s3,424(sp)
    80004e88:	f352                	sd	s4,416(sp)
    80004e8a:	ef56                	sd	s5,408(sp)
    80004e8c:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004e8e:	08000613          	li	a2,128
    80004e92:	f4040593          	addi	a1,s0,-192
    80004e96:	4501                	li	a0,0
    80004e98:	ffffd097          	auipc	ra,0xffffd
    80004e9c:	208080e7          	jalr	520(ra) # 800020a0 <argstr>
    return -1;
    80004ea0:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004ea2:	0c054b63          	bltz	a0,80004f78 <sys_exec+0xfc>
    80004ea6:	e3840593          	addi	a1,s0,-456
    80004eaa:	4505                	li	a0,1
    80004eac:	ffffd097          	auipc	ra,0xffffd
    80004eb0:	1d2080e7          	jalr	466(ra) # 8000207e <argaddr>
    80004eb4:	0c054263          	bltz	a0,80004f78 <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    80004eb8:	10000613          	li	a2,256
    80004ebc:	4581                	li	a1,0
    80004ebe:	e4040513          	addi	a0,s0,-448
    80004ec2:	ffffb097          	auipc	ra,0xffffb
    80004ec6:	3c8080e7          	jalr	968(ra) # 8000028a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004eca:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004ece:	89a6                	mv	s3,s1
    80004ed0:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004ed2:	02000a13          	li	s4,32
    80004ed6:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004eda:	00391513          	slli	a0,s2,0x3
    80004ede:	e3040593          	addi	a1,s0,-464
    80004ee2:	e3843783          	ld	a5,-456(s0)
    80004ee6:	953e                	add	a0,a0,a5
    80004ee8:	ffffd097          	auipc	ra,0xffffd
    80004eec:	0da080e7          	jalr	218(ra) # 80001fc2 <fetchaddr>
    80004ef0:	02054a63          	bltz	a0,80004f24 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80004ef4:	e3043783          	ld	a5,-464(s0)
    80004ef8:	c3b9                	beqz	a5,80004f3e <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004efa:	ffffb097          	auipc	ra,0xffffb
    80004efe:	260080e7          	jalr	608(ra) # 8000015a <kalloc>
    80004f02:	85aa                	mv	a1,a0
    80004f04:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004f08:	cd11                	beqz	a0,80004f24 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004f0a:	6605                	lui	a2,0x1
    80004f0c:	e3043503          	ld	a0,-464(s0)
    80004f10:	ffffd097          	auipc	ra,0xffffd
    80004f14:	104080e7          	jalr	260(ra) # 80002014 <fetchstr>
    80004f18:	00054663          	bltz	a0,80004f24 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80004f1c:	0905                	addi	s2,s2,1
    80004f1e:	09a1                	addi	s3,s3,8
    80004f20:	fb491be3          	bne	s2,s4,80004ed6 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f24:	f4040913          	addi	s2,s0,-192
    80004f28:	6088                	ld	a0,0(s1)
    80004f2a:	c531                	beqz	a0,80004f76 <sys_exec+0xfa>
    kfree(argv[i]);
    80004f2c:	ffffb097          	auipc	ra,0xffffb
    80004f30:	0f0080e7          	jalr	240(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f34:	04a1                	addi	s1,s1,8
    80004f36:	ff2499e3          	bne	s1,s2,80004f28 <sys_exec+0xac>
  return -1;
    80004f3a:	597d                	li	s2,-1
    80004f3c:	a835                	j	80004f78 <sys_exec+0xfc>
      argv[i] = 0;
    80004f3e:	0a8e                	slli	s5,s5,0x3
    80004f40:	fc0a8793          	addi	a5,s5,-64 # ffffffffffffefc0 <end+0xffffffff7ffb8d80>
    80004f44:	00878ab3          	add	s5,a5,s0
    80004f48:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004f4c:	e4040593          	addi	a1,s0,-448
    80004f50:	f4040513          	addi	a0,s0,-192
    80004f54:	fffff097          	auipc	ra,0xfffff
    80004f58:	172080e7          	jalr	370(ra) # 800040c6 <exec>
    80004f5c:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f5e:	f4040993          	addi	s3,s0,-192
    80004f62:	6088                	ld	a0,0(s1)
    80004f64:	c911                	beqz	a0,80004f78 <sys_exec+0xfc>
    kfree(argv[i]);
    80004f66:	ffffb097          	auipc	ra,0xffffb
    80004f6a:	0b6080e7          	jalr	182(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f6e:	04a1                	addi	s1,s1,8
    80004f70:	ff3499e3          	bne	s1,s3,80004f62 <sys_exec+0xe6>
    80004f74:	a011                	j	80004f78 <sys_exec+0xfc>
  return -1;
    80004f76:	597d                	li	s2,-1
}
    80004f78:	854a                	mv	a0,s2
    80004f7a:	60be                	ld	ra,456(sp)
    80004f7c:	641e                	ld	s0,448(sp)
    80004f7e:	74fa                	ld	s1,440(sp)
    80004f80:	795a                	ld	s2,432(sp)
    80004f82:	79ba                	ld	s3,424(sp)
    80004f84:	7a1a                	ld	s4,416(sp)
    80004f86:	6afa                	ld	s5,408(sp)
    80004f88:	6179                	addi	sp,sp,464
    80004f8a:	8082                	ret

0000000080004f8c <sys_pipe>:

uint64
sys_pipe(void)
{
    80004f8c:	7139                	addi	sp,sp,-64
    80004f8e:	fc06                	sd	ra,56(sp)
    80004f90:	f822                	sd	s0,48(sp)
    80004f92:	f426                	sd	s1,40(sp)
    80004f94:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004f96:	ffffc097          	auipc	ra,0xffffc
    80004f9a:	fea080e7          	jalr	-22(ra) # 80000f80 <myproc>
    80004f9e:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80004fa0:	fd840593          	addi	a1,s0,-40
    80004fa4:	4501                	li	a0,0
    80004fa6:	ffffd097          	auipc	ra,0xffffd
    80004faa:	0d8080e7          	jalr	216(ra) # 8000207e <argaddr>
    return -1;
    80004fae:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80004fb0:	0e054063          	bltz	a0,80005090 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80004fb4:	fc840593          	addi	a1,s0,-56
    80004fb8:	fd040513          	addi	a0,s0,-48
    80004fbc:	fffff097          	auipc	ra,0xfffff
    80004fc0:	de6080e7          	jalr	-538(ra) # 80003da2 <pipealloc>
    return -1;
    80004fc4:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004fc6:	0c054563          	bltz	a0,80005090 <sys_pipe+0x104>
  fd0 = -1;
    80004fca:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004fce:	fd043503          	ld	a0,-48(s0)
    80004fd2:	fffff097          	auipc	ra,0xfffff
    80004fd6:	504080e7          	jalr	1284(ra) # 800044d6 <fdalloc>
    80004fda:	fca42223          	sw	a0,-60(s0)
    80004fde:	08054c63          	bltz	a0,80005076 <sys_pipe+0xea>
    80004fe2:	fc843503          	ld	a0,-56(s0)
    80004fe6:	fffff097          	auipc	ra,0xfffff
    80004fea:	4f0080e7          	jalr	1264(ra) # 800044d6 <fdalloc>
    80004fee:	fca42023          	sw	a0,-64(s0)
    80004ff2:	06054963          	bltz	a0,80005064 <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004ff6:	4691                	li	a3,4
    80004ff8:	fc440613          	addi	a2,s0,-60
    80004ffc:	fd843583          	ld	a1,-40(s0)
    80005000:	68a8                	ld	a0,80(s1)
    80005002:	ffffc097          	auipc	ra,0xffffc
    80005006:	c12080e7          	jalr	-1006(ra) # 80000c14 <copyout>
    8000500a:	02054063          	bltz	a0,8000502a <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000500e:	4691                	li	a3,4
    80005010:	fc040613          	addi	a2,s0,-64
    80005014:	fd843583          	ld	a1,-40(s0)
    80005018:	0591                	addi	a1,a1,4
    8000501a:	68a8                	ld	a0,80(s1)
    8000501c:	ffffc097          	auipc	ra,0xffffc
    80005020:	bf8080e7          	jalr	-1032(ra) # 80000c14 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005024:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005026:	06055563          	bgez	a0,80005090 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    8000502a:	fc442783          	lw	a5,-60(s0)
    8000502e:	07e9                	addi	a5,a5,26
    80005030:	078e                	slli	a5,a5,0x3
    80005032:	97a6                	add	a5,a5,s1
    80005034:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005038:	fc042783          	lw	a5,-64(s0)
    8000503c:	07e9                	addi	a5,a5,26
    8000503e:	078e                	slli	a5,a5,0x3
    80005040:	00f48533          	add	a0,s1,a5
    80005044:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005048:	fd043503          	ld	a0,-48(s0)
    8000504c:	fffff097          	auipc	ra,0xfffff
    80005050:	a26080e7          	jalr	-1498(ra) # 80003a72 <fileclose>
    fileclose(wf);
    80005054:	fc843503          	ld	a0,-56(s0)
    80005058:	fffff097          	auipc	ra,0xfffff
    8000505c:	a1a080e7          	jalr	-1510(ra) # 80003a72 <fileclose>
    return -1;
    80005060:	57fd                	li	a5,-1
    80005062:	a03d                	j	80005090 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005064:	fc442783          	lw	a5,-60(s0)
    80005068:	0007c763          	bltz	a5,80005076 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    8000506c:	07e9                	addi	a5,a5,26
    8000506e:	078e                	slli	a5,a5,0x3
    80005070:	97a6                	add	a5,a5,s1
    80005072:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005076:	fd043503          	ld	a0,-48(s0)
    8000507a:	fffff097          	auipc	ra,0xfffff
    8000507e:	9f8080e7          	jalr	-1544(ra) # 80003a72 <fileclose>
    fileclose(wf);
    80005082:	fc843503          	ld	a0,-56(s0)
    80005086:	fffff097          	auipc	ra,0xfffff
    8000508a:	9ec080e7          	jalr	-1556(ra) # 80003a72 <fileclose>
    return -1;
    8000508e:	57fd                	li	a5,-1
}
    80005090:	853e                	mv	a0,a5
    80005092:	70e2                	ld	ra,56(sp)
    80005094:	7442                	ld	s0,48(sp)
    80005096:	74a2                	ld	s1,40(sp)
    80005098:	6121                	addi	sp,sp,64
    8000509a:	8082                	ret
    8000509c:	0000                	unimp
	...

00000000800050a0 <kernelvec>:
    800050a0:	7111                	addi	sp,sp,-256
    800050a2:	e006                	sd	ra,0(sp)
    800050a4:	e40a                	sd	sp,8(sp)
    800050a6:	e80e                	sd	gp,16(sp)
    800050a8:	ec12                	sd	tp,24(sp)
    800050aa:	f016                	sd	t0,32(sp)
    800050ac:	f41a                	sd	t1,40(sp)
    800050ae:	f81e                	sd	t2,48(sp)
    800050b0:	fc22                	sd	s0,56(sp)
    800050b2:	e0a6                	sd	s1,64(sp)
    800050b4:	e4aa                	sd	a0,72(sp)
    800050b6:	e8ae                	sd	a1,80(sp)
    800050b8:	ecb2                	sd	a2,88(sp)
    800050ba:	f0b6                	sd	a3,96(sp)
    800050bc:	f4ba                	sd	a4,104(sp)
    800050be:	f8be                	sd	a5,112(sp)
    800050c0:	fcc2                	sd	a6,120(sp)
    800050c2:	e146                	sd	a7,128(sp)
    800050c4:	e54a                	sd	s2,136(sp)
    800050c6:	e94e                	sd	s3,144(sp)
    800050c8:	ed52                	sd	s4,152(sp)
    800050ca:	f156                	sd	s5,160(sp)
    800050cc:	f55a                	sd	s6,168(sp)
    800050ce:	f95e                	sd	s7,176(sp)
    800050d0:	fd62                	sd	s8,184(sp)
    800050d2:	e1e6                	sd	s9,192(sp)
    800050d4:	e5ea                	sd	s10,200(sp)
    800050d6:	e9ee                	sd	s11,208(sp)
    800050d8:	edf2                	sd	t3,216(sp)
    800050da:	f1f6                	sd	t4,224(sp)
    800050dc:	f5fa                	sd	t5,232(sp)
    800050de:	f9fe                	sd	t6,240(sp)
    800050e0:	daffc0ef          	jal	ra,80001e8e <kerneltrap>
    800050e4:	6082                	ld	ra,0(sp)
    800050e6:	6122                	ld	sp,8(sp)
    800050e8:	61c2                	ld	gp,16(sp)
    800050ea:	7282                	ld	t0,32(sp)
    800050ec:	7322                	ld	t1,40(sp)
    800050ee:	73c2                	ld	t2,48(sp)
    800050f0:	7462                	ld	s0,56(sp)
    800050f2:	6486                	ld	s1,64(sp)
    800050f4:	6526                	ld	a0,72(sp)
    800050f6:	65c6                	ld	a1,80(sp)
    800050f8:	6666                	ld	a2,88(sp)
    800050fa:	7686                	ld	a3,96(sp)
    800050fc:	7726                	ld	a4,104(sp)
    800050fe:	77c6                	ld	a5,112(sp)
    80005100:	7866                	ld	a6,120(sp)
    80005102:	688a                	ld	a7,128(sp)
    80005104:	692a                	ld	s2,136(sp)
    80005106:	69ca                	ld	s3,144(sp)
    80005108:	6a6a                	ld	s4,152(sp)
    8000510a:	7a8a                	ld	s5,160(sp)
    8000510c:	7b2a                	ld	s6,168(sp)
    8000510e:	7bca                	ld	s7,176(sp)
    80005110:	7c6a                	ld	s8,184(sp)
    80005112:	6c8e                	ld	s9,192(sp)
    80005114:	6d2e                	ld	s10,200(sp)
    80005116:	6dce                	ld	s11,208(sp)
    80005118:	6e6e                	ld	t3,216(sp)
    8000511a:	7e8e                	ld	t4,224(sp)
    8000511c:	7f2e                	ld	t5,232(sp)
    8000511e:	7fce                	ld	t6,240(sp)
    80005120:	6111                	addi	sp,sp,256
    80005122:	10200073          	sret
    80005126:	00000013          	nop
    8000512a:	00000013          	nop
    8000512e:	0001                	nop

0000000080005130 <timervec>:
    80005130:	34051573          	csrrw	a0,mscratch,a0
    80005134:	e10c                	sd	a1,0(a0)
    80005136:	e510                	sd	a2,8(a0)
    80005138:	e914                	sd	a3,16(a0)
    8000513a:	6d0c                	ld	a1,24(a0)
    8000513c:	7110                	ld	a2,32(a0)
    8000513e:	6194                	ld	a3,0(a1)
    80005140:	96b2                	add	a3,a3,a2
    80005142:	e194                	sd	a3,0(a1)
    80005144:	4589                	li	a1,2
    80005146:	14459073          	csrw	sip,a1
    8000514a:	6914                	ld	a3,16(a0)
    8000514c:	6510                	ld	a2,8(a0)
    8000514e:	610c                	ld	a1,0(a0)
    80005150:	34051573          	csrrw	a0,mscratch,a0
    80005154:	30200073          	mret
	...

000000008000515a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000515a:	1141                	addi	sp,sp,-16
    8000515c:	e422                	sd	s0,8(sp)
    8000515e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005160:	0c0007b7          	lui	a5,0xc000
    80005164:	4705                	li	a4,1
    80005166:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005168:	c3d8                	sw	a4,4(a5)
}
    8000516a:	6422                	ld	s0,8(sp)
    8000516c:	0141                	addi	sp,sp,16
    8000516e:	8082                	ret

0000000080005170 <plicinithart>:

void
plicinithart(void)
{
    80005170:	1141                	addi	sp,sp,-16
    80005172:	e406                	sd	ra,8(sp)
    80005174:	e022                	sd	s0,0(sp)
    80005176:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005178:	ffffc097          	auipc	ra,0xffffc
    8000517c:	ddc080e7          	jalr	-548(ra) # 80000f54 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005180:	0085171b          	slliw	a4,a0,0x8
    80005184:	0c0027b7          	lui	a5,0xc002
    80005188:	97ba                	add	a5,a5,a4
    8000518a:	40200713          	li	a4,1026
    8000518e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005192:	00d5151b          	slliw	a0,a0,0xd
    80005196:	0c2017b7          	lui	a5,0xc201
    8000519a:	97aa                	add	a5,a5,a0
    8000519c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800051a0:	60a2                	ld	ra,8(sp)
    800051a2:	6402                	ld	s0,0(sp)
    800051a4:	0141                	addi	sp,sp,16
    800051a6:	8082                	ret

00000000800051a8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800051a8:	1141                	addi	sp,sp,-16
    800051aa:	e406                	sd	ra,8(sp)
    800051ac:	e022                	sd	s0,0(sp)
    800051ae:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800051b0:	ffffc097          	auipc	ra,0xffffc
    800051b4:	da4080e7          	jalr	-604(ra) # 80000f54 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800051b8:	00d5151b          	slliw	a0,a0,0xd
    800051bc:	0c2017b7          	lui	a5,0xc201
    800051c0:	97aa                	add	a5,a5,a0
  return irq;
}
    800051c2:	43c8                	lw	a0,4(a5)
    800051c4:	60a2                	ld	ra,8(sp)
    800051c6:	6402                	ld	s0,0(sp)
    800051c8:	0141                	addi	sp,sp,16
    800051ca:	8082                	ret

00000000800051cc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800051cc:	1101                	addi	sp,sp,-32
    800051ce:	ec06                	sd	ra,24(sp)
    800051d0:	e822                	sd	s0,16(sp)
    800051d2:	e426                	sd	s1,8(sp)
    800051d4:	1000                	addi	s0,sp,32
    800051d6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800051d8:	ffffc097          	auipc	ra,0xffffc
    800051dc:	d7c080e7          	jalr	-644(ra) # 80000f54 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800051e0:	00d5151b          	slliw	a0,a0,0xd
    800051e4:	0c2017b7          	lui	a5,0xc201
    800051e8:	97aa                	add	a5,a5,a0
    800051ea:	c3c4                	sw	s1,4(a5)
}
    800051ec:	60e2                	ld	ra,24(sp)
    800051ee:	6442                	ld	s0,16(sp)
    800051f0:	64a2                	ld	s1,8(sp)
    800051f2:	6105                	addi	sp,sp,32
    800051f4:	8082                	ret

00000000800051f6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800051f6:	1141                	addi	sp,sp,-16
    800051f8:	e406                	sd	ra,8(sp)
    800051fa:	e022                	sd	s0,0(sp)
    800051fc:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800051fe:	479d                	li	a5,7
    80005200:	06a7c863          	blt	a5,a0,80005270 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    80005204:	00036717          	auipc	a4,0x36
    80005208:	dfc70713          	addi	a4,a4,-516 # 8003b000 <disk>
    8000520c:	972a                	add	a4,a4,a0
    8000520e:	6789                	lui	a5,0x2
    80005210:	97ba                	add	a5,a5,a4
    80005212:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005216:	e7ad                	bnez	a5,80005280 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005218:	00451793          	slli	a5,a0,0x4
    8000521c:	00038717          	auipc	a4,0x38
    80005220:	de470713          	addi	a4,a4,-540 # 8003d000 <disk+0x2000>
    80005224:	6314                	ld	a3,0(a4)
    80005226:	96be                	add	a3,a3,a5
    80005228:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    8000522c:	6314                	ld	a3,0(a4)
    8000522e:	96be                	add	a3,a3,a5
    80005230:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005234:	6314                	ld	a3,0(a4)
    80005236:	96be                	add	a3,a3,a5
    80005238:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000523c:	6318                	ld	a4,0(a4)
    8000523e:	97ba                	add	a5,a5,a4
    80005240:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005244:	00036717          	auipc	a4,0x36
    80005248:	dbc70713          	addi	a4,a4,-580 # 8003b000 <disk>
    8000524c:	972a                	add	a4,a4,a0
    8000524e:	6789                	lui	a5,0x2
    80005250:	97ba                	add	a5,a5,a4
    80005252:	4705                	li	a4,1
    80005254:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    80005258:	00038517          	auipc	a0,0x38
    8000525c:	dc050513          	addi	a0,a0,-576 # 8003d018 <disk+0x2018>
    80005260:	ffffc097          	auipc	ra,0xffffc
    80005264:	570080e7          	jalr	1392(ra) # 800017d0 <wakeup>
}
    80005268:	60a2                	ld	ra,8(sp)
    8000526a:	6402                	ld	s0,0(sp)
    8000526c:	0141                	addi	sp,sp,16
    8000526e:	8082                	ret
    panic("free_desc 1");
    80005270:	00003517          	auipc	a0,0x3
    80005274:	47850513          	addi	a0,a0,1144 # 800086e8 <syscalls+0x320>
    80005278:	00001097          	auipc	ra,0x1
    8000527c:	9c8080e7          	jalr	-1592(ra) # 80005c40 <panic>
    panic("free_desc 2");
    80005280:	00003517          	auipc	a0,0x3
    80005284:	47850513          	addi	a0,a0,1144 # 800086f8 <syscalls+0x330>
    80005288:	00001097          	auipc	ra,0x1
    8000528c:	9b8080e7          	jalr	-1608(ra) # 80005c40 <panic>

0000000080005290 <virtio_disk_init>:
{
    80005290:	1101                	addi	sp,sp,-32
    80005292:	ec06                	sd	ra,24(sp)
    80005294:	e822                	sd	s0,16(sp)
    80005296:	e426                	sd	s1,8(sp)
    80005298:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000529a:	00003597          	auipc	a1,0x3
    8000529e:	46e58593          	addi	a1,a1,1134 # 80008708 <syscalls+0x340>
    800052a2:	00038517          	auipc	a0,0x38
    800052a6:	e8650513          	addi	a0,a0,-378 # 8003d128 <disk+0x2128>
    800052aa:	00001097          	auipc	ra,0x1
    800052ae:	e3e080e7          	jalr	-450(ra) # 800060e8 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052b2:	100017b7          	lui	a5,0x10001
    800052b6:	4398                	lw	a4,0(a5)
    800052b8:	2701                	sext.w	a4,a4
    800052ba:	747277b7          	lui	a5,0x74727
    800052be:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800052c2:	0ef71063          	bne	a4,a5,800053a2 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800052c6:	100017b7          	lui	a5,0x10001
    800052ca:	43dc                	lw	a5,4(a5)
    800052cc:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052ce:	4705                	li	a4,1
    800052d0:	0ce79963          	bne	a5,a4,800053a2 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052d4:	100017b7          	lui	a5,0x10001
    800052d8:	479c                	lw	a5,8(a5)
    800052da:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800052dc:	4709                	li	a4,2
    800052de:	0ce79263          	bne	a5,a4,800053a2 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800052e2:	100017b7          	lui	a5,0x10001
    800052e6:	47d8                	lw	a4,12(a5)
    800052e8:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052ea:	554d47b7          	lui	a5,0x554d4
    800052ee:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800052f2:	0af71863          	bne	a4,a5,800053a2 <virtio_disk_init+0x112>
  *R(VIRTIO_MMIO_STATUS) = status;
    800052f6:	100017b7          	lui	a5,0x10001
    800052fa:	4705                	li	a4,1
    800052fc:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052fe:	470d                	li	a4,3
    80005300:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005302:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005304:	c7ffe6b7          	lui	a3,0xc7ffe
    80005308:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fb851f>
    8000530c:	8f75                	and	a4,a4,a3
    8000530e:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005310:	472d                	li	a4,11
    80005312:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005314:	473d                	li	a4,15
    80005316:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005318:	6705                	lui	a4,0x1
    8000531a:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000531c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005320:	5bdc                	lw	a5,52(a5)
    80005322:	2781                	sext.w	a5,a5
  if(max == 0)
    80005324:	c7d9                	beqz	a5,800053b2 <virtio_disk_init+0x122>
  if(max < NUM)
    80005326:	471d                	li	a4,7
    80005328:	08f77d63          	bgeu	a4,a5,800053c2 <virtio_disk_init+0x132>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000532c:	100014b7          	lui	s1,0x10001
    80005330:	47a1                	li	a5,8
    80005332:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005334:	6609                	lui	a2,0x2
    80005336:	4581                	li	a1,0
    80005338:	00036517          	auipc	a0,0x36
    8000533c:	cc850513          	addi	a0,a0,-824 # 8003b000 <disk>
    80005340:	ffffb097          	auipc	ra,0xffffb
    80005344:	f4a080e7          	jalr	-182(ra) # 8000028a <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005348:	00036717          	auipc	a4,0x36
    8000534c:	cb870713          	addi	a4,a4,-840 # 8003b000 <disk>
    80005350:	00c75793          	srli	a5,a4,0xc
    80005354:	2781                	sext.w	a5,a5
    80005356:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    80005358:	00038797          	auipc	a5,0x38
    8000535c:	ca878793          	addi	a5,a5,-856 # 8003d000 <disk+0x2000>
    80005360:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005362:	00036717          	auipc	a4,0x36
    80005366:	d1e70713          	addi	a4,a4,-738 # 8003b080 <disk+0x80>
    8000536a:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    8000536c:	00037717          	auipc	a4,0x37
    80005370:	c9470713          	addi	a4,a4,-876 # 8003c000 <disk+0x1000>
    80005374:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005376:	4705                	li	a4,1
    80005378:	00e78c23          	sb	a4,24(a5)
    8000537c:	00e78ca3          	sb	a4,25(a5)
    80005380:	00e78d23          	sb	a4,26(a5)
    80005384:	00e78da3          	sb	a4,27(a5)
    80005388:	00e78e23          	sb	a4,28(a5)
    8000538c:	00e78ea3          	sb	a4,29(a5)
    80005390:	00e78f23          	sb	a4,30(a5)
    80005394:	00e78fa3          	sb	a4,31(a5)
}
    80005398:	60e2                	ld	ra,24(sp)
    8000539a:	6442                	ld	s0,16(sp)
    8000539c:	64a2                	ld	s1,8(sp)
    8000539e:	6105                	addi	sp,sp,32
    800053a0:	8082                	ret
    panic("could not find virtio disk");
    800053a2:	00003517          	auipc	a0,0x3
    800053a6:	37650513          	addi	a0,a0,886 # 80008718 <syscalls+0x350>
    800053aa:	00001097          	auipc	ra,0x1
    800053ae:	896080e7          	jalr	-1898(ra) # 80005c40 <panic>
    panic("virtio disk has no queue 0");
    800053b2:	00003517          	auipc	a0,0x3
    800053b6:	38650513          	addi	a0,a0,902 # 80008738 <syscalls+0x370>
    800053ba:	00001097          	auipc	ra,0x1
    800053be:	886080e7          	jalr	-1914(ra) # 80005c40 <panic>
    panic("virtio disk max queue too short");
    800053c2:	00003517          	auipc	a0,0x3
    800053c6:	39650513          	addi	a0,a0,918 # 80008758 <syscalls+0x390>
    800053ca:	00001097          	auipc	ra,0x1
    800053ce:	876080e7          	jalr	-1930(ra) # 80005c40 <panic>

00000000800053d2 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800053d2:	7119                	addi	sp,sp,-128
    800053d4:	fc86                	sd	ra,120(sp)
    800053d6:	f8a2                	sd	s0,112(sp)
    800053d8:	f4a6                	sd	s1,104(sp)
    800053da:	f0ca                	sd	s2,96(sp)
    800053dc:	ecce                	sd	s3,88(sp)
    800053de:	e8d2                	sd	s4,80(sp)
    800053e0:	e4d6                	sd	s5,72(sp)
    800053e2:	e0da                	sd	s6,64(sp)
    800053e4:	fc5e                	sd	s7,56(sp)
    800053e6:	f862                	sd	s8,48(sp)
    800053e8:	f466                	sd	s9,40(sp)
    800053ea:	f06a                	sd	s10,32(sp)
    800053ec:	ec6e                	sd	s11,24(sp)
    800053ee:	0100                	addi	s0,sp,128
    800053f0:	8aaa                	mv	s5,a0
    800053f2:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800053f4:	00c52c83          	lw	s9,12(a0)
    800053f8:	001c9c9b          	slliw	s9,s9,0x1
    800053fc:	1c82                	slli	s9,s9,0x20
    800053fe:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005402:	00038517          	auipc	a0,0x38
    80005406:	d2650513          	addi	a0,a0,-730 # 8003d128 <disk+0x2128>
    8000540a:	00001097          	auipc	ra,0x1
    8000540e:	d6e080e7          	jalr	-658(ra) # 80006178 <acquire>
  for(int i = 0; i < 3; i++){
    80005412:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005414:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005416:	00036c17          	auipc	s8,0x36
    8000541a:	beac0c13          	addi	s8,s8,-1046 # 8003b000 <disk>
    8000541e:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    80005420:	4b0d                	li	s6,3
    80005422:	a0ad                	j	8000548c <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    80005424:	00fc0733          	add	a4,s8,a5
    80005428:	975e                	add	a4,a4,s7
    8000542a:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    8000542e:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005430:	0207c563          	bltz	a5,8000545a <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005434:	2905                	addiw	s2,s2,1
    80005436:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    80005438:	19690c63          	beq	s2,s6,800055d0 <virtio_disk_rw+0x1fe>
    idx[i] = alloc_desc();
    8000543c:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    8000543e:	00038717          	auipc	a4,0x38
    80005442:	bda70713          	addi	a4,a4,-1062 # 8003d018 <disk+0x2018>
    80005446:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005448:	00074683          	lbu	a3,0(a4)
    8000544c:	fee1                	bnez	a3,80005424 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    8000544e:	2785                	addiw	a5,a5,1
    80005450:	0705                	addi	a4,a4,1
    80005452:	fe979be3          	bne	a5,s1,80005448 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    80005456:	57fd                	li	a5,-1
    80005458:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    8000545a:	01205d63          	blez	s2,80005474 <virtio_disk_rw+0xa2>
    8000545e:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80005460:	000a2503          	lw	a0,0(s4)
    80005464:	00000097          	auipc	ra,0x0
    80005468:	d92080e7          	jalr	-622(ra) # 800051f6 <free_desc>
      for(int j = 0; j < i; j++)
    8000546c:	2d85                	addiw	s11,s11,1
    8000546e:	0a11                	addi	s4,s4,4
    80005470:	ff2d98e3          	bne	s11,s2,80005460 <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005474:	00038597          	auipc	a1,0x38
    80005478:	cb458593          	addi	a1,a1,-844 # 8003d128 <disk+0x2128>
    8000547c:	00038517          	auipc	a0,0x38
    80005480:	b9c50513          	addi	a0,a0,-1124 # 8003d018 <disk+0x2018>
    80005484:	ffffc097          	auipc	ra,0xffffc
    80005488:	1c0080e7          	jalr	448(ra) # 80001644 <sleep>
  for(int i = 0; i < 3; i++){
    8000548c:	f8040a13          	addi	s4,s0,-128
{
    80005490:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80005492:	894e                	mv	s2,s3
    80005494:	b765                	j	8000543c <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005496:	00038697          	auipc	a3,0x38
    8000549a:	b6a6b683          	ld	a3,-1174(a3) # 8003d000 <disk+0x2000>
    8000549e:	96ba                	add	a3,a3,a4
    800054a0:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800054a4:	00036817          	auipc	a6,0x36
    800054a8:	b5c80813          	addi	a6,a6,-1188 # 8003b000 <disk>
    800054ac:	00038697          	auipc	a3,0x38
    800054b0:	b5468693          	addi	a3,a3,-1196 # 8003d000 <disk+0x2000>
    800054b4:	6290                	ld	a2,0(a3)
    800054b6:	963a                	add	a2,a2,a4
    800054b8:	00c65583          	lhu	a1,12(a2)
    800054bc:	0015e593          	ori	a1,a1,1
    800054c0:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    800054c4:	f8842603          	lw	a2,-120(s0)
    800054c8:	628c                	ld	a1,0(a3)
    800054ca:	972e                	add	a4,a4,a1
    800054cc:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800054d0:	20050593          	addi	a1,a0,512
    800054d4:	0592                	slli	a1,a1,0x4
    800054d6:	95c2                	add	a1,a1,a6
    800054d8:	577d                	li	a4,-1
    800054da:	02e58823          	sb	a4,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800054de:	00461713          	slli	a4,a2,0x4
    800054e2:	6290                	ld	a2,0(a3)
    800054e4:	963a                	add	a2,a2,a4
    800054e6:	03078793          	addi	a5,a5,48
    800054ea:	97c2                	add	a5,a5,a6
    800054ec:	e21c                	sd	a5,0(a2)
  disk.desc[idx[2]].len = 1;
    800054ee:	629c                	ld	a5,0(a3)
    800054f0:	97ba                	add	a5,a5,a4
    800054f2:	4605                	li	a2,1
    800054f4:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800054f6:	629c                	ld	a5,0(a3)
    800054f8:	97ba                	add	a5,a5,a4
    800054fa:	4809                	li	a6,2
    800054fc:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005500:	629c                	ld	a5,0(a3)
    80005502:	97ba                	add	a5,a5,a4
    80005504:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005508:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    8000550c:	0355b423          	sd	s5,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005510:	6698                	ld	a4,8(a3)
    80005512:	00275783          	lhu	a5,2(a4)
    80005516:	8b9d                	andi	a5,a5,7
    80005518:	0786                	slli	a5,a5,0x1
    8000551a:	973e                	add	a4,a4,a5
    8000551c:	00a71223          	sh	a0,4(a4)

  __sync_synchronize();
    80005520:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005524:	6698                	ld	a4,8(a3)
    80005526:	00275783          	lhu	a5,2(a4)
    8000552a:	2785                	addiw	a5,a5,1
    8000552c:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005530:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005534:	100017b7          	lui	a5,0x10001
    80005538:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8000553c:	004aa783          	lw	a5,4(s5)
    80005540:	02c79163          	bne	a5,a2,80005562 <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    80005544:	00038917          	auipc	s2,0x38
    80005548:	be490913          	addi	s2,s2,-1052 # 8003d128 <disk+0x2128>
  while(b->disk == 1) {
    8000554c:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    8000554e:	85ca                	mv	a1,s2
    80005550:	8556                	mv	a0,s5
    80005552:	ffffc097          	auipc	ra,0xffffc
    80005556:	0f2080e7          	jalr	242(ra) # 80001644 <sleep>
  while(b->disk == 1) {
    8000555a:	004aa783          	lw	a5,4(s5)
    8000555e:	fe9788e3          	beq	a5,s1,8000554e <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    80005562:	f8042903          	lw	s2,-128(s0)
    80005566:	20090713          	addi	a4,s2,512
    8000556a:	0712                	slli	a4,a4,0x4
    8000556c:	00036797          	auipc	a5,0x36
    80005570:	a9478793          	addi	a5,a5,-1388 # 8003b000 <disk>
    80005574:	97ba                	add	a5,a5,a4
    80005576:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    8000557a:	00038997          	auipc	s3,0x38
    8000557e:	a8698993          	addi	s3,s3,-1402 # 8003d000 <disk+0x2000>
    80005582:	00491713          	slli	a4,s2,0x4
    80005586:	0009b783          	ld	a5,0(s3)
    8000558a:	97ba                	add	a5,a5,a4
    8000558c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005590:	854a                	mv	a0,s2
    80005592:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005596:	00000097          	auipc	ra,0x0
    8000559a:	c60080e7          	jalr	-928(ra) # 800051f6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000559e:	8885                	andi	s1,s1,1
    800055a0:	f0ed                	bnez	s1,80005582 <virtio_disk_rw+0x1b0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800055a2:	00038517          	auipc	a0,0x38
    800055a6:	b8650513          	addi	a0,a0,-1146 # 8003d128 <disk+0x2128>
    800055aa:	00001097          	auipc	ra,0x1
    800055ae:	c82080e7          	jalr	-894(ra) # 8000622c <release>
}
    800055b2:	70e6                	ld	ra,120(sp)
    800055b4:	7446                	ld	s0,112(sp)
    800055b6:	74a6                	ld	s1,104(sp)
    800055b8:	7906                	ld	s2,96(sp)
    800055ba:	69e6                	ld	s3,88(sp)
    800055bc:	6a46                	ld	s4,80(sp)
    800055be:	6aa6                	ld	s5,72(sp)
    800055c0:	6b06                	ld	s6,64(sp)
    800055c2:	7be2                	ld	s7,56(sp)
    800055c4:	7c42                	ld	s8,48(sp)
    800055c6:	7ca2                	ld	s9,40(sp)
    800055c8:	7d02                	ld	s10,32(sp)
    800055ca:	6de2                	ld	s11,24(sp)
    800055cc:	6109                	addi	sp,sp,128
    800055ce:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800055d0:	f8042503          	lw	a0,-128(s0)
    800055d4:	20050793          	addi	a5,a0,512
    800055d8:	0792                	slli	a5,a5,0x4
  if(write)
    800055da:	00036817          	auipc	a6,0x36
    800055de:	a2680813          	addi	a6,a6,-1498 # 8003b000 <disk>
    800055e2:	00f80733          	add	a4,a6,a5
    800055e6:	01a036b3          	snez	a3,s10
    800055ea:	0ad72423          	sw	a3,168(a4)
  buf0->reserved = 0;
    800055ee:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    800055f2:	0b973823          	sd	s9,176(a4)
  disk.desc[idx[0]].addr = (uint64) buf0;
    800055f6:	7679                	lui	a2,0xffffe
    800055f8:	963e                	add	a2,a2,a5
    800055fa:	00038697          	auipc	a3,0x38
    800055fe:	a0668693          	addi	a3,a3,-1530 # 8003d000 <disk+0x2000>
    80005602:	6298                	ld	a4,0(a3)
    80005604:	9732                	add	a4,a4,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005606:	0a878593          	addi	a1,a5,168
    8000560a:	95c2                	add	a1,a1,a6
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000560c:	e30c                	sd	a1,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000560e:	6298                	ld	a4,0(a3)
    80005610:	9732                	add	a4,a4,a2
    80005612:	45c1                	li	a1,16
    80005614:	c70c                	sw	a1,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005616:	6298                	ld	a4,0(a3)
    80005618:	9732                	add	a4,a4,a2
    8000561a:	4585                	li	a1,1
    8000561c:	00b71623          	sh	a1,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005620:	f8442703          	lw	a4,-124(s0)
    80005624:	628c                	ld	a1,0(a3)
    80005626:	962e                	add	a2,a2,a1
    80005628:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffb7dce>
  disk.desc[idx[1]].addr = (uint64) b->data;
    8000562c:	0712                	slli	a4,a4,0x4
    8000562e:	6290                	ld	a2,0(a3)
    80005630:	963a                	add	a2,a2,a4
    80005632:	058a8593          	addi	a1,s5,88
    80005636:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005638:	6294                	ld	a3,0(a3)
    8000563a:	96ba                	add	a3,a3,a4
    8000563c:	40000613          	li	a2,1024
    80005640:	c690                	sw	a2,8(a3)
  if(write)
    80005642:	e40d1ae3          	bnez	s10,80005496 <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80005646:	00038697          	auipc	a3,0x38
    8000564a:	9ba6b683          	ld	a3,-1606(a3) # 8003d000 <disk+0x2000>
    8000564e:	96ba                	add	a3,a3,a4
    80005650:	4609                	li	a2,2
    80005652:	00c69623          	sh	a2,12(a3)
    80005656:	b5b9                	j	800054a4 <virtio_disk_rw+0xd2>

0000000080005658 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005658:	1101                	addi	sp,sp,-32
    8000565a:	ec06                	sd	ra,24(sp)
    8000565c:	e822                	sd	s0,16(sp)
    8000565e:	e426                	sd	s1,8(sp)
    80005660:	e04a                	sd	s2,0(sp)
    80005662:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005664:	00038517          	auipc	a0,0x38
    80005668:	ac450513          	addi	a0,a0,-1340 # 8003d128 <disk+0x2128>
    8000566c:	00001097          	auipc	ra,0x1
    80005670:	b0c080e7          	jalr	-1268(ra) # 80006178 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005674:	10001737          	lui	a4,0x10001
    80005678:	533c                	lw	a5,96(a4)
    8000567a:	8b8d                	andi	a5,a5,3
    8000567c:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    8000567e:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005682:	00038797          	auipc	a5,0x38
    80005686:	97e78793          	addi	a5,a5,-1666 # 8003d000 <disk+0x2000>
    8000568a:	6b94                	ld	a3,16(a5)
    8000568c:	0207d703          	lhu	a4,32(a5)
    80005690:	0026d783          	lhu	a5,2(a3)
    80005694:	06f70163          	beq	a4,a5,800056f6 <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005698:	00036917          	auipc	s2,0x36
    8000569c:	96890913          	addi	s2,s2,-1688 # 8003b000 <disk>
    800056a0:	00038497          	auipc	s1,0x38
    800056a4:	96048493          	addi	s1,s1,-1696 # 8003d000 <disk+0x2000>
    __sync_synchronize();
    800056a8:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800056ac:	6898                	ld	a4,16(s1)
    800056ae:	0204d783          	lhu	a5,32(s1)
    800056b2:	8b9d                	andi	a5,a5,7
    800056b4:	078e                	slli	a5,a5,0x3
    800056b6:	97ba                	add	a5,a5,a4
    800056b8:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800056ba:	20078713          	addi	a4,a5,512
    800056be:	0712                	slli	a4,a4,0x4
    800056c0:	974a                	add	a4,a4,s2
    800056c2:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    800056c6:	e731                	bnez	a4,80005712 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800056c8:	20078793          	addi	a5,a5,512
    800056cc:	0792                	slli	a5,a5,0x4
    800056ce:	97ca                	add	a5,a5,s2
    800056d0:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    800056d2:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800056d6:	ffffc097          	auipc	ra,0xffffc
    800056da:	0fa080e7          	jalr	250(ra) # 800017d0 <wakeup>

    disk.used_idx += 1;
    800056de:	0204d783          	lhu	a5,32(s1)
    800056e2:	2785                	addiw	a5,a5,1
    800056e4:	17c2                	slli	a5,a5,0x30
    800056e6:	93c1                	srli	a5,a5,0x30
    800056e8:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800056ec:	6898                	ld	a4,16(s1)
    800056ee:	00275703          	lhu	a4,2(a4)
    800056f2:	faf71be3          	bne	a4,a5,800056a8 <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    800056f6:	00038517          	auipc	a0,0x38
    800056fa:	a3250513          	addi	a0,a0,-1486 # 8003d128 <disk+0x2128>
    800056fe:	00001097          	auipc	ra,0x1
    80005702:	b2e080e7          	jalr	-1234(ra) # 8000622c <release>
}
    80005706:	60e2                	ld	ra,24(sp)
    80005708:	6442                	ld	s0,16(sp)
    8000570a:	64a2                	ld	s1,8(sp)
    8000570c:	6902                	ld	s2,0(sp)
    8000570e:	6105                	addi	sp,sp,32
    80005710:	8082                	ret
      panic("virtio_disk_intr status");
    80005712:	00003517          	auipc	a0,0x3
    80005716:	06650513          	addi	a0,a0,102 # 80008778 <syscalls+0x3b0>
    8000571a:	00000097          	auipc	ra,0x0
    8000571e:	526080e7          	jalr	1318(ra) # 80005c40 <panic>

0000000080005722 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005722:	1141                	addi	sp,sp,-16
    80005724:	e422                	sd	s0,8(sp)
    80005726:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005728:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    8000572c:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005730:	0037979b          	slliw	a5,a5,0x3
    80005734:	02004737          	lui	a4,0x2004
    80005738:	97ba                	add	a5,a5,a4
    8000573a:	0200c737          	lui	a4,0x200c
    8000573e:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005742:	000f4637          	lui	a2,0xf4
    80005746:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    8000574a:	9732                	add	a4,a4,a2
    8000574c:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    8000574e:	00259693          	slli	a3,a1,0x2
    80005752:	96ae                	add	a3,a3,a1
    80005754:	068e                	slli	a3,a3,0x3
    80005756:	00039717          	auipc	a4,0x39
    8000575a:	8aa70713          	addi	a4,a4,-1878 # 8003e000 <timer_scratch>
    8000575e:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005760:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005762:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005764:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005768:	00000797          	auipc	a5,0x0
    8000576c:	9c878793          	addi	a5,a5,-1592 # 80005130 <timervec>
    80005770:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005774:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005778:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000577c:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005780:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005784:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005788:	30479073          	csrw	mie,a5
}
    8000578c:	6422                	ld	s0,8(sp)
    8000578e:	0141                	addi	sp,sp,16
    80005790:	8082                	ret

0000000080005792 <start>:
{
    80005792:	1141                	addi	sp,sp,-16
    80005794:	e406                	sd	ra,8(sp)
    80005796:	e022                	sd	s0,0(sp)
    80005798:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000579a:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000579e:	7779                	lui	a4,0xffffe
    800057a0:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffb85bf>
    800057a4:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800057a6:	6705                	lui	a4,0x1
    800057a8:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800057ac:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800057ae:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800057b2:	ffffb797          	auipc	a5,0xffffb
    800057b6:	c7e78793          	addi	a5,a5,-898 # 80000430 <main>
    800057ba:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800057be:	4781                	li	a5,0
    800057c0:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800057c4:	67c1                	lui	a5,0x10
    800057c6:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800057c8:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800057cc:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800057d0:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800057d4:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800057d8:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800057dc:	57fd                	li	a5,-1
    800057de:	83a9                	srli	a5,a5,0xa
    800057e0:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800057e4:	47bd                	li	a5,15
    800057e6:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800057ea:	00000097          	auipc	ra,0x0
    800057ee:	f38080e7          	jalr	-200(ra) # 80005722 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800057f2:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800057f6:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    800057f8:	823e                	mv	tp,a5
  asm volatile("mret");
    800057fa:	30200073          	mret
}
    800057fe:	60a2                	ld	ra,8(sp)
    80005800:	6402                	ld	s0,0(sp)
    80005802:	0141                	addi	sp,sp,16
    80005804:	8082                	ret

0000000080005806 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005806:	715d                	addi	sp,sp,-80
    80005808:	e486                	sd	ra,72(sp)
    8000580a:	e0a2                	sd	s0,64(sp)
    8000580c:	fc26                	sd	s1,56(sp)
    8000580e:	f84a                	sd	s2,48(sp)
    80005810:	f44e                	sd	s3,40(sp)
    80005812:	f052                	sd	s4,32(sp)
    80005814:	ec56                	sd	s5,24(sp)
    80005816:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005818:	04c05763          	blez	a2,80005866 <consolewrite+0x60>
    8000581c:	8a2a                	mv	s4,a0
    8000581e:	84ae                	mv	s1,a1
    80005820:	89b2                	mv	s3,a2
    80005822:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005824:	5afd                	li	s5,-1
    80005826:	4685                	li	a3,1
    80005828:	8626                	mv	a2,s1
    8000582a:	85d2                	mv	a1,s4
    8000582c:	fbf40513          	addi	a0,s0,-65
    80005830:	ffffc097          	auipc	ra,0xffffc
    80005834:	20e080e7          	jalr	526(ra) # 80001a3e <either_copyin>
    80005838:	01550d63          	beq	a0,s5,80005852 <consolewrite+0x4c>
      break;
    uartputc(c);
    8000583c:	fbf44503          	lbu	a0,-65(s0)
    80005840:	00000097          	auipc	ra,0x0
    80005844:	77e080e7          	jalr	1918(ra) # 80005fbe <uartputc>
  for(i = 0; i < n; i++){
    80005848:	2905                	addiw	s2,s2,1
    8000584a:	0485                	addi	s1,s1,1
    8000584c:	fd299de3          	bne	s3,s2,80005826 <consolewrite+0x20>
    80005850:	894e                	mv	s2,s3
  }

  return i;
}
    80005852:	854a                	mv	a0,s2
    80005854:	60a6                	ld	ra,72(sp)
    80005856:	6406                	ld	s0,64(sp)
    80005858:	74e2                	ld	s1,56(sp)
    8000585a:	7942                	ld	s2,48(sp)
    8000585c:	79a2                	ld	s3,40(sp)
    8000585e:	7a02                	ld	s4,32(sp)
    80005860:	6ae2                	ld	s5,24(sp)
    80005862:	6161                	addi	sp,sp,80
    80005864:	8082                	ret
  for(i = 0; i < n; i++){
    80005866:	4901                	li	s2,0
    80005868:	b7ed                	j	80005852 <consolewrite+0x4c>

000000008000586a <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000586a:	7159                	addi	sp,sp,-112
    8000586c:	f486                	sd	ra,104(sp)
    8000586e:	f0a2                	sd	s0,96(sp)
    80005870:	eca6                	sd	s1,88(sp)
    80005872:	e8ca                	sd	s2,80(sp)
    80005874:	e4ce                	sd	s3,72(sp)
    80005876:	e0d2                	sd	s4,64(sp)
    80005878:	fc56                	sd	s5,56(sp)
    8000587a:	f85a                	sd	s6,48(sp)
    8000587c:	f45e                	sd	s7,40(sp)
    8000587e:	f062                	sd	s8,32(sp)
    80005880:	ec66                	sd	s9,24(sp)
    80005882:	e86a                	sd	s10,16(sp)
    80005884:	1880                	addi	s0,sp,112
    80005886:	8aaa                	mv	s5,a0
    80005888:	8a2e                	mv	s4,a1
    8000588a:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    8000588c:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005890:	00041517          	auipc	a0,0x41
    80005894:	8b050513          	addi	a0,a0,-1872 # 80046140 <cons>
    80005898:	00001097          	auipc	ra,0x1
    8000589c:	8e0080e7          	jalr	-1824(ra) # 80006178 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800058a0:	00041497          	auipc	s1,0x41
    800058a4:	8a048493          	addi	s1,s1,-1888 # 80046140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800058a8:	00041917          	auipc	s2,0x41
    800058ac:	93090913          	addi	s2,s2,-1744 # 800461d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    800058b0:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800058b2:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800058b4:	4ca9                	li	s9,10
  while(n > 0){
    800058b6:	07305863          	blez	s3,80005926 <consoleread+0xbc>
    while(cons.r == cons.w){
    800058ba:	0984a783          	lw	a5,152(s1)
    800058be:	09c4a703          	lw	a4,156(s1)
    800058c2:	02f71463          	bne	a4,a5,800058ea <consoleread+0x80>
      if(myproc()->killed){
    800058c6:	ffffb097          	auipc	ra,0xffffb
    800058ca:	6ba080e7          	jalr	1722(ra) # 80000f80 <myproc>
    800058ce:	551c                	lw	a5,40(a0)
    800058d0:	e7b5                	bnez	a5,8000593c <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    800058d2:	85a6                	mv	a1,s1
    800058d4:	854a                	mv	a0,s2
    800058d6:	ffffc097          	auipc	ra,0xffffc
    800058da:	d6e080e7          	jalr	-658(ra) # 80001644 <sleep>
    while(cons.r == cons.w){
    800058de:	0984a783          	lw	a5,152(s1)
    800058e2:	09c4a703          	lw	a4,156(s1)
    800058e6:	fef700e3          	beq	a4,a5,800058c6 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF];
    800058ea:	0017871b          	addiw	a4,a5,1
    800058ee:	08e4ac23          	sw	a4,152(s1)
    800058f2:	07f7f713          	andi	a4,a5,127
    800058f6:	9726                	add	a4,a4,s1
    800058f8:	01874703          	lbu	a4,24(a4)
    800058fc:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80005900:	077d0563          	beq	s10,s7,8000596a <consoleread+0x100>
    cbuf = c;
    80005904:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005908:	4685                	li	a3,1
    8000590a:	f9f40613          	addi	a2,s0,-97
    8000590e:	85d2                	mv	a1,s4
    80005910:	8556                	mv	a0,s5
    80005912:	ffffc097          	auipc	ra,0xffffc
    80005916:	0d6080e7          	jalr	214(ra) # 800019e8 <either_copyout>
    8000591a:	01850663          	beq	a0,s8,80005926 <consoleread+0xbc>
    dst++;
    8000591e:	0a05                	addi	s4,s4,1
    --n;
    80005920:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80005922:	f99d1ae3          	bne	s10,s9,800058b6 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005926:	00041517          	auipc	a0,0x41
    8000592a:	81a50513          	addi	a0,a0,-2022 # 80046140 <cons>
    8000592e:	00001097          	auipc	ra,0x1
    80005932:	8fe080e7          	jalr	-1794(ra) # 8000622c <release>

  return target - n;
    80005936:	413b053b          	subw	a0,s6,s3
    8000593a:	a811                	j	8000594e <consoleread+0xe4>
        release(&cons.lock);
    8000593c:	00041517          	auipc	a0,0x41
    80005940:	80450513          	addi	a0,a0,-2044 # 80046140 <cons>
    80005944:	00001097          	auipc	ra,0x1
    80005948:	8e8080e7          	jalr	-1816(ra) # 8000622c <release>
        return -1;
    8000594c:	557d                	li	a0,-1
}
    8000594e:	70a6                	ld	ra,104(sp)
    80005950:	7406                	ld	s0,96(sp)
    80005952:	64e6                	ld	s1,88(sp)
    80005954:	6946                	ld	s2,80(sp)
    80005956:	69a6                	ld	s3,72(sp)
    80005958:	6a06                	ld	s4,64(sp)
    8000595a:	7ae2                	ld	s5,56(sp)
    8000595c:	7b42                	ld	s6,48(sp)
    8000595e:	7ba2                	ld	s7,40(sp)
    80005960:	7c02                	ld	s8,32(sp)
    80005962:	6ce2                	ld	s9,24(sp)
    80005964:	6d42                	ld	s10,16(sp)
    80005966:	6165                	addi	sp,sp,112
    80005968:	8082                	ret
      if(n < target){
    8000596a:	0009871b          	sext.w	a4,s3
    8000596e:	fb677ce3          	bgeu	a4,s6,80005926 <consoleread+0xbc>
        cons.r--;
    80005972:	00041717          	auipc	a4,0x41
    80005976:	86f72323          	sw	a5,-1946(a4) # 800461d8 <cons+0x98>
    8000597a:	b775                	j	80005926 <consoleread+0xbc>

000000008000597c <consputc>:
{
    8000597c:	1141                	addi	sp,sp,-16
    8000597e:	e406                	sd	ra,8(sp)
    80005980:	e022                	sd	s0,0(sp)
    80005982:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005984:	10000793          	li	a5,256
    80005988:	00f50a63          	beq	a0,a5,8000599c <consputc+0x20>
    uartputc_sync(c);
    8000598c:	00000097          	auipc	ra,0x0
    80005990:	560080e7          	jalr	1376(ra) # 80005eec <uartputc_sync>
}
    80005994:	60a2                	ld	ra,8(sp)
    80005996:	6402                	ld	s0,0(sp)
    80005998:	0141                	addi	sp,sp,16
    8000599a:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    8000599c:	4521                	li	a0,8
    8000599e:	00000097          	auipc	ra,0x0
    800059a2:	54e080e7          	jalr	1358(ra) # 80005eec <uartputc_sync>
    800059a6:	02000513          	li	a0,32
    800059aa:	00000097          	auipc	ra,0x0
    800059ae:	542080e7          	jalr	1346(ra) # 80005eec <uartputc_sync>
    800059b2:	4521                	li	a0,8
    800059b4:	00000097          	auipc	ra,0x0
    800059b8:	538080e7          	jalr	1336(ra) # 80005eec <uartputc_sync>
    800059bc:	bfe1                	j	80005994 <consputc+0x18>

00000000800059be <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800059be:	1101                	addi	sp,sp,-32
    800059c0:	ec06                	sd	ra,24(sp)
    800059c2:	e822                	sd	s0,16(sp)
    800059c4:	e426                	sd	s1,8(sp)
    800059c6:	e04a                	sd	s2,0(sp)
    800059c8:	1000                	addi	s0,sp,32
    800059ca:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800059cc:	00040517          	auipc	a0,0x40
    800059d0:	77450513          	addi	a0,a0,1908 # 80046140 <cons>
    800059d4:	00000097          	auipc	ra,0x0
    800059d8:	7a4080e7          	jalr	1956(ra) # 80006178 <acquire>

  switch(c){
    800059dc:	47d5                	li	a5,21
    800059de:	0af48663          	beq	s1,a5,80005a8a <consoleintr+0xcc>
    800059e2:	0297ca63          	blt	a5,s1,80005a16 <consoleintr+0x58>
    800059e6:	47a1                	li	a5,8
    800059e8:	0ef48763          	beq	s1,a5,80005ad6 <consoleintr+0x118>
    800059ec:	47c1                	li	a5,16
    800059ee:	10f49a63          	bne	s1,a5,80005b02 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800059f2:	ffffc097          	auipc	ra,0xffffc
    800059f6:	0a2080e7          	jalr	162(ra) # 80001a94 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800059fa:	00040517          	auipc	a0,0x40
    800059fe:	74650513          	addi	a0,a0,1862 # 80046140 <cons>
    80005a02:	00001097          	auipc	ra,0x1
    80005a06:	82a080e7          	jalr	-2006(ra) # 8000622c <release>
}
    80005a0a:	60e2                	ld	ra,24(sp)
    80005a0c:	6442                	ld	s0,16(sp)
    80005a0e:	64a2                	ld	s1,8(sp)
    80005a10:	6902                	ld	s2,0(sp)
    80005a12:	6105                	addi	sp,sp,32
    80005a14:	8082                	ret
  switch(c){
    80005a16:	07f00793          	li	a5,127
    80005a1a:	0af48e63          	beq	s1,a5,80005ad6 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005a1e:	00040717          	auipc	a4,0x40
    80005a22:	72270713          	addi	a4,a4,1826 # 80046140 <cons>
    80005a26:	0a072783          	lw	a5,160(a4)
    80005a2a:	09872703          	lw	a4,152(a4)
    80005a2e:	9f99                	subw	a5,a5,a4
    80005a30:	07f00713          	li	a4,127
    80005a34:	fcf763e3          	bltu	a4,a5,800059fa <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005a38:	47b5                	li	a5,13
    80005a3a:	0cf48763          	beq	s1,a5,80005b08 <consoleintr+0x14a>
      consputc(c);
    80005a3e:	8526                	mv	a0,s1
    80005a40:	00000097          	auipc	ra,0x0
    80005a44:	f3c080e7          	jalr	-196(ra) # 8000597c <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005a48:	00040797          	auipc	a5,0x40
    80005a4c:	6f878793          	addi	a5,a5,1784 # 80046140 <cons>
    80005a50:	0a07a703          	lw	a4,160(a5)
    80005a54:	0017069b          	addiw	a3,a4,1
    80005a58:	0006861b          	sext.w	a2,a3
    80005a5c:	0ad7a023          	sw	a3,160(a5)
    80005a60:	07f77713          	andi	a4,a4,127
    80005a64:	97ba                	add	a5,a5,a4
    80005a66:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005a6a:	47a9                	li	a5,10
    80005a6c:	0cf48563          	beq	s1,a5,80005b36 <consoleintr+0x178>
    80005a70:	4791                	li	a5,4
    80005a72:	0cf48263          	beq	s1,a5,80005b36 <consoleintr+0x178>
    80005a76:	00040797          	auipc	a5,0x40
    80005a7a:	7627a783          	lw	a5,1890(a5) # 800461d8 <cons+0x98>
    80005a7e:	0807879b          	addiw	a5,a5,128
    80005a82:	f6f61ce3          	bne	a2,a5,800059fa <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005a86:	863e                	mv	a2,a5
    80005a88:	a07d                	j	80005b36 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005a8a:	00040717          	auipc	a4,0x40
    80005a8e:	6b670713          	addi	a4,a4,1718 # 80046140 <cons>
    80005a92:	0a072783          	lw	a5,160(a4)
    80005a96:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005a9a:	00040497          	auipc	s1,0x40
    80005a9e:	6a648493          	addi	s1,s1,1702 # 80046140 <cons>
    while(cons.e != cons.w &&
    80005aa2:	4929                	li	s2,10
    80005aa4:	f4f70be3          	beq	a4,a5,800059fa <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005aa8:	37fd                	addiw	a5,a5,-1
    80005aaa:	07f7f713          	andi	a4,a5,127
    80005aae:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005ab0:	01874703          	lbu	a4,24(a4)
    80005ab4:	f52703e3          	beq	a4,s2,800059fa <consoleintr+0x3c>
      cons.e--;
    80005ab8:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005abc:	10000513          	li	a0,256
    80005ac0:	00000097          	auipc	ra,0x0
    80005ac4:	ebc080e7          	jalr	-324(ra) # 8000597c <consputc>
    while(cons.e != cons.w &&
    80005ac8:	0a04a783          	lw	a5,160(s1)
    80005acc:	09c4a703          	lw	a4,156(s1)
    80005ad0:	fcf71ce3          	bne	a4,a5,80005aa8 <consoleintr+0xea>
    80005ad4:	b71d                	j	800059fa <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005ad6:	00040717          	auipc	a4,0x40
    80005ada:	66a70713          	addi	a4,a4,1642 # 80046140 <cons>
    80005ade:	0a072783          	lw	a5,160(a4)
    80005ae2:	09c72703          	lw	a4,156(a4)
    80005ae6:	f0f70ae3          	beq	a4,a5,800059fa <consoleintr+0x3c>
      cons.e--;
    80005aea:	37fd                	addiw	a5,a5,-1
    80005aec:	00040717          	auipc	a4,0x40
    80005af0:	6ef72a23          	sw	a5,1780(a4) # 800461e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005af4:	10000513          	li	a0,256
    80005af8:	00000097          	auipc	ra,0x0
    80005afc:	e84080e7          	jalr	-380(ra) # 8000597c <consputc>
    80005b00:	bded                	j	800059fa <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005b02:	ee048ce3          	beqz	s1,800059fa <consoleintr+0x3c>
    80005b06:	bf21                	j	80005a1e <consoleintr+0x60>
      consputc(c);
    80005b08:	4529                	li	a0,10
    80005b0a:	00000097          	auipc	ra,0x0
    80005b0e:	e72080e7          	jalr	-398(ra) # 8000597c <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005b12:	00040797          	auipc	a5,0x40
    80005b16:	62e78793          	addi	a5,a5,1582 # 80046140 <cons>
    80005b1a:	0a07a703          	lw	a4,160(a5)
    80005b1e:	0017069b          	addiw	a3,a4,1
    80005b22:	0006861b          	sext.w	a2,a3
    80005b26:	0ad7a023          	sw	a3,160(a5)
    80005b2a:	07f77713          	andi	a4,a4,127
    80005b2e:	97ba                	add	a5,a5,a4
    80005b30:	4729                	li	a4,10
    80005b32:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005b36:	00040797          	auipc	a5,0x40
    80005b3a:	6ac7a323          	sw	a2,1702(a5) # 800461dc <cons+0x9c>
        wakeup(&cons.r);
    80005b3e:	00040517          	auipc	a0,0x40
    80005b42:	69a50513          	addi	a0,a0,1690 # 800461d8 <cons+0x98>
    80005b46:	ffffc097          	auipc	ra,0xffffc
    80005b4a:	c8a080e7          	jalr	-886(ra) # 800017d0 <wakeup>
    80005b4e:	b575                	j	800059fa <consoleintr+0x3c>

0000000080005b50 <consoleinit>:

void
consoleinit(void)
{
    80005b50:	1141                	addi	sp,sp,-16
    80005b52:	e406                	sd	ra,8(sp)
    80005b54:	e022                	sd	s0,0(sp)
    80005b56:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005b58:	00003597          	auipc	a1,0x3
    80005b5c:	c3858593          	addi	a1,a1,-968 # 80008790 <syscalls+0x3c8>
    80005b60:	00040517          	auipc	a0,0x40
    80005b64:	5e050513          	addi	a0,a0,1504 # 80046140 <cons>
    80005b68:	00000097          	auipc	ra,0x0
    80005b6c:	580080e7          	jalr	1408(ra) # 800060e8 <initlock>

  uartinit();
    80005b70:	00000097          	auipc	ra,0x0
    80005b74:	32c080e7          	jalr	812(ra) # 80005e9c <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005b78:	00033797          	auipc	a5,0x33
    80005b7c:	55078793          	addi	a5,a5,1360 # 800390c8 <devsw>
    80005b80:	00000717          	auipc	a4,0x0
    80005b84:	cea70713          	addi	a4,a4,-790 # 8000586a <consoleread>
    80005b88:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005b8a:	00000717          	auipc	a4,0x0
    80005b8e:	c7c70713          	addi	a4,a4,-900 # 80005806 <consolewrite>
    80005b92:	ef98                	sd	a4,24(a5)
}
    80005b94:	60a2                	ld	ra,8(sp)
    80005b96:	6402                	ld	s0,0(sp)
    80005b98:	0141                	addi	sp,sp,16
    80005b9a:	8082                	ret

0000000080005b9c <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005b9c:	7179                	addi	sp,sp,-48
    80005b9e:	f406                	sd	ra,40(sp)
    80005ba0:	f022                	sd	s0,32(sp)
    80005ba2:	ec26                	sd	s1,24(sp)
    80005ba4:	e84a                	sd	s2,16(sp)
    80005ba6:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005ba8:	c219                	beqz	a2,80005bae <printint+0x12>
    80005baa:	08054763          	bltz	a0,80005c38 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005bae:	2501                	sext.w	a0,a0
    80005bb0:	4881                	li	a7,0
    80005bb2:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005bb6:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005bb8:	2581                	sext.w	a1,a1
    80005bba:	00003617          	auipc	a2,0x3
    80005bbe:	c0660613          	addi	a2,a2,-1018 # 800087c0 <digits>
    80005bc2:	883a                	mv	a6,a4
    80005bc4:	2705                	addiw	a4,a4,1
    80005bc6:	02b577bb          	remuw	a5,a0,a1
    80005bca:	1782                	slli	a5,a5,0x20
    80005bcc:	9381                	srli	a5,a5,0x20
    80005bce:	97b2                	add	a5,a5,a2
    80005bd0:	0007c783          	lbu	a5,0(a5)
    80005bd4:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005bd8:	0005079b          	sext.w	a5,a0
    80005bdc:	02b5553b          	divuw	a0,a0,a1
    80005be0:	0685                	addi	a3,a3,1
    80005be2:	feb7f0e3          	bgeu	a5,a1,80005bc2 <printint+0x26>

  if(sign)
    80005be6:	00088c63          	beqz	a7,80005bfe <printint+0x62>
    buf[i++] = '-';
    80005bea:	fe070793          	addi	a5,a4,-32
    80005bee:	00878733          	add	a4,a5,s0
    80005bf2:	02d00793          	li	a5,45
    80005bf6:	fef70823          	sb	a5,-16(a4)
    80005bfa:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005bfe:	02e05763          	blez	a4,80005c2c <printint+0x90>
    80005c02:	fd040793          	addi	a5,s0,-48
    80005c06:	00e784b3          	add	s1,a5,a4
    80005c0a:	fff78913          	addi	s2,a5,-1
    80005c0e:	993a                	add	s2,s2,a4
    80005c10:	377d                	addiw	a4,a4,-1
    80005c12:	1702                	slli	a4,a4,0x20
    80005c14:	9301                	srli	a4,a4,0x20
    80005c16:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005c1a:	fff4c503          	lbu	a0,-1(s1)
    80005c1e:	00000097          	auipc	ra,0x0
    80005c22:	d5e080e7          	jalr	-674(ra) # 8000597c <consputc>
  while(--i >= 0)
    80005c26:	14fd                	addi	s1,s1,-1
    80005c28:	ff2499e3          	bne	s1,s2,80005c1a <printint+0x7e>
}
    80005c2c:	70a2                	ld	ra,40(sp)
    80005c2e:	7402                	ld	s0,32(sp)
    80005c30:	64e2                	ld	s1,24(sp)
    80005c32:	6942                	ld	s2,16(sp)
    80005c34:	6145                	addi	sp,sp,48
    80005c36:	8082                	ret
    x = -xx;
    80005c38:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005c3c:	4885                	li	a7,1
    x = -xx;
    80005c3e:	bf95                	j	80005bb2 <printint+0x16>

0000000080005c40 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005c40:	1101                	addi	sp,sp,-32
    80005c42:	ec06                	sd	ra,24(sp)
    80005c44:	e822                	sd	s0,16(sp)
    80005c46:	e426                	sd	s1,8(sp)
    80005c48:	1000                	addi	s0,sp,32
    80005c4a:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005c4c:	00040797          	auipc	a5,0x40
    80005c50:	5a07aa23          	sw	zero,1460(a5) # 80046200 <pr+0x18>
  printf("panic: ");
    80005c54:	00003517          	auipc	a0,0x3
    80005c58:	b4450513          	addi	a0,a0,-1212 # 80008798 <syscalls+0x3d0>
    80005c5c:	00000097          	auipc	ra,0x0
    80005c60:	02e080e7          	jalr	46(ra) # 80005c8a <printf>
  printf(s);
    80005c64:	8526                	mv	a0,s1
    80005c66:	00000097          	auipc	ra,0x0
    80005c6a:	024080e7          	jalr	36(ra) # 80005c8a <printf>
  printf("\n");
    80005c6e:	00002517          	auipc	a0,0x2
    80005c72:	3da50513          	addi	a0,a0,986 # 80008048 <etext+0x48>
    80005c76:	00000097          	auipc	ra,0x0
    80005c7a:	014080e7          	jalr	20(ra) # 80005c8a <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005c7e:	4785                	li	a5,1
    80005c80:	00003717          	auipc	a4,0x3
    80005c84:	38f72e23          	sw	a5,924(a4) # 8000901c <panicked>
  for(;;)
    80005c88:	a001                	j	80005c88 <panic+0x48>

0000000080005c8a <printf>:
{
    80005c8a:	7131                	addi	sp,sp,-192
    80005c8c:	fc86                	sd	ra,120(sp)
    80005c8e:	f8a2                	sd	s0,112(sp)
    80005c90:	f4a6                	sd	s1,104(sp)
    80005c92:	f0ca                	sd	s2,96(sp)
    80005c94:	ecce                	sd	s3,88(sp)
    80005c96:	e8d2                	sd	s4,80(sp)
    80005c98:	e4d6                	sd	s5,72(sp)
    80005c9a:	e0da                	sd	s6,64(sp)
    80005c9c:	fc5e                	sd	s7,56(sp)
    80005c9e:	f862                	sd	s8,48(sp)
    80005ca0:	f466                	sd	s9,40(sp)
    80005ca2:	f06a                	sd	s10,32(sp)
    80005ca4:	ec6e                	sd	s11,24(sp)
    80005ca6:	0100                	addi	s0,sp,128
    80005ca8:	8a2a                	mv	s4,a0
    80005caa:	e40c                	sd	a1,8(s0)
    80005cac:	e810                	sd	a2,16(s0)
    80005cae:	ec14                	sd	a3,24(s0)
    80005cb0:	f018                	sd	a4,32(s0)
    80005cb2:	f41c                	sd	a5,40(s0)
    80005cb4:	03043823          	sd	a6,48(s0)
    80005cb8:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005cbc:	00040d97          	auipc	s11,0x40
    80005cc0:	544dad83          	lw	s11,1348(s11) # 80046200 <pr+0x18>
  if(locking)
    80005cc4:	020d9b63          	bnez	s11,80005cfa <printf+0x70>
  if (fmt == 0)
    80005cc8:	040a0263          	beqz	s4,80005d0c <printf+0x82>
  va_start(ap, fmt);
    80005ccc:	00840793          	addi	a5,s0,8
    80005cd0:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005cd4:	000a4503          	lbu	a0,0(s4)
    80005cd8:	14050f63          	beqz	a0,80005e36 <printf+0x1ac>
    80005cdc:	4981                	li	s3,0
    if(c != '%'){
    80005cde:	02500a93          	li	s5,37
    switch(c){
    80005ce2:	07000b93          	li	s7,112
  consputc('x');
    80005ce6:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005ce8:	00003b17          	auipc	s6,0x3
    80005cec:	ad8b0b13          	addi	s6,s6,-1320 # 800087c0 <digits>
    switch(c){
    80005cf0:	07300c93          	li	s9,115
    80005cf4:	06400c13          	li	s8,100
    80005cf8:	a82d                	j	80005d32 <printf+0xa8>
    acquire(&pr.lock);
    80005cfa:	00040517          	auipc	a0,0x40
    80005cfe:	4ee50513          	addi	a0,a0,1262 # 800461e8 <pr>
    80005d02:	00000097          	auipc	ra,0x0
    80005d06:	476080e7          	jalr	1142(ra) # 80006178 <acquire>
    80005d0a:	bf7d                	j	80005cc8 <printf+0x3e>
    panic("null fmt");
    80005d0c:	00003517          	auipc	a0,0x3
    80005d10:	a9c50513          	addi	a0,a0,-1380 # 800087a8 <syscalls+0x3e0>
    80005d14:	00000097          	auipc	ra,0x0
    80005d18:	f2c080e7          	jalr	-212(ra) # 80005c40 <panic>
      consputc(c);
    80005d1c:	00000097          	auipc	ra,0x0
    80005d20:	c60080e7          	jalr	-928(ra) # 8000597c <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d24:	2985                	addiw	s3,s3,1
    80005d26:	013a07b3          	add	a5,s4,s3
    80005d2a:	0007c503          	lbu	a0,0(a5)
    80005d2e:	10050463          	beqz	a0,80005e36 <printf+0x1ac>
    if(c != '%'){
    80005d32:	ff5515e3          	bne	a0,s5,80005d1c <printf+0x92>
    c = fmt[++i] & 0xff;
    80005d36:	2985                	addiw	s3,s3,1
    80005d38:	013a07b3          	add	a5,s4,s3
    80005d3c:	0007c783          	lbu	a5,0(a5)
    80005d40:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005d44:	cbed                	beqz	a5,80005e36 <printf+0x1ac>
    switch(c){
    80005d46:	05778a63          	beq	a5,s7,80005d9a <printf+0x110>
    80005d4a:	02fbf663          	bgeu	s7,a5,80005d76 <printf+0xec>
    80005d4e:	09978863          	beq	a5,s9,80005dde <printf+0x154>
    80005d52:	07800713          	li	a4,120
    80005d56:	0ce79563          	bne	a5,a4,80005e20 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005d5a:	f8843783          	ld	a5,-120(s0)
    80005d5e:	00878713          	addi	a4,a5,8
    80005d62:	f8e43423          	sd	a4,-120(s0)
    80005d66:	4605                	li	a2,1
    80005d68:	85ea                	mv	a1,s10
    80005d6a:	4388                	lw	a0,0(a5)
    80005d6c:	00000097          	auipc	ra,0x0
    80005d70:	e30080e7          	jalr	-464(ra) # 80005b9c <printint>
      break;
    80005d74:	bf45                	j	80005d24 <printf+0x9a>
    switch(c){
    80005d76:	09578f63          	beq	a5,s5,80005e14 <printf+0x18a>
    80005d7a:	0b879363          	bne	a5,s8,80005e20 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005d7e:	f8843783          	ld	a5,-120(s0)
    80005d82:	00878713          	addi	a4,a5,8
    80005d86:	f8e43423          	sd	a4,-120(s0)
    80005d8a:	4605                	li	a2,1
    80005d8c:	45a9                	li	a1,10
    80005d8e:	4388                	lw	a0,0(a5)
    80005d90:	00000097          	auipc	ra,0x0
    80005d94:	e0c080e7          	jalr	-500(ra) # 80005b9c <printint>
      break;
    80005d98:	b771                	j	80005d24 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005d9a:	f8843783          	ld	a5,-120(s0)
    80005d9e:	00878713          	addi	a4,a5,8
    80005da2:	f8e43423          	sd	a4,-120(s0)
    80005da6:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005daa:	03000513          	li	a0,48
    80005dae:	00000097          	auipc	ra,0x0
    80005db2:	bce080e7          	jalr	-1074(ra) # 8000597c <consputc>
  consputc('x');
    80005db6:	07800513          	li	a0,120
    80005dba:	00000097          	auipc	ra,0x0
    80005dbe:	bc2080e7          	jalr	-1086(ra) # 8000597c <consputc>
    80005dc2:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005dc4:	03c95793          	srli	a5,s2,0x3c
    80005dc8:	97da                	add	a5,a5,s6
    80005dca:	0007c503          	lbu	a0,0(a5)
    80005dce:	00000097          	auipc	ra,0x0
    80005dd2:	bae080e7          	jalr	-1106(ra) # 8000597c <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005dd6:	0912                	slli	s2,s2,0x4
    80005dd8:	34fd                	addiw	s1,s1,-1
    80005dda:	f4ed                	bnez	s1,80005dc4 <printf+0x13a>
    80005ddc:	b7a1                	j	80005d24 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005dde:	f8843783          	ld	a5,-120(s0)
    80005de2:	00878713          	addi	a4,a5,8
    80005de6:	f8e43423          	sd	a4,-120(s0)
    80005dea:	6384                	ld	s1,0(a5)
    80005dec:	cc89                	beqz	s1,80005e06 <printf+0x17c>
      for(; *s; s++)
    80005dee:	0004c503          	lbu	a0,0(s1)
    80005df2:	d90d                	beqz	a0,80005d24 <printf+0x9a>
        consputc(*s);
    80005df4:	00000097          	auipc	ra,0x0
    80005df8:	b88080e7          	jalr	-1144(ra) # 8000597c <consputc>
      for(; *s; s++)
    80005dfc:	0485                	addi	s1,s1,1
    80005dfe:	0004c503          	lbu	a0,0(s1)
    80005e02:	f96d                	bnez	a0,80005df4 <printf+0x16a>
    80005e04:	b705                	j	80005d24 <printf+0x9a>
        s = "(null)";
    80005e06:	00003497          	auipc	s1,0x3
    80005e0a:	99a48493          	addi	s1,s1,-1638 # 800087a0 <syscalls+0x3d8>
      for(; *s; s++)
    80005e0e:	02800513          	li	a0,40
    80005e12:	b7cd                	j	80005df4 <printf+0x16a>
      consputc('%');
    80005e14:	8556                	mv	a0,s5
    80005e16:	00000097          	auipc	ra,0x0
    80005e1a:	b66080e7          	jalr	-1178(ra) # 8000597c <consputc>
      break;
    80005e1e:	b719                	j	80005d24 <printf+0x9a>
      consputc('%');
    80005e20:	8556                	mv	a0,s5
    80005e22:	00000097          	auipc	ra,0x0
    80005e26:	b5a080e7          	jalr	-1190(ra) # 8000597c <consputc>
      consputc(c);
    80005e2a:	8526                	mv	a0,s1
    80005e2c:	00000097          	auipc	ra,0x0
    80005e30:	b50080e7          	jalr	-1200(ra) # 8000597c <consputc>
      break;
    80005e34:	bdc5                	j	80005d24 <printf+0x9a>
  if(locking)
    80005e36:	020d9163          	bnez	s11,80005e58 <printf+0x1ce>
}
    80005e3a:	70e6                	ld	ra,120(sp)
    80005e3c:	7446                	ld	s0,112(sp)
    80005e3e:	74a6                	ld	s1,104(sp)
    80005e40:	7906                	ld	s2,96(sp)
    80005e42:	69e6                	ld	s3,88(sp)
    80005e44:	6a46                	ld	s4,80(sp)
    80005e46:	6aa6                	ld	s5,72(sp)
    80005e48:	6b06                	ld	s6,64(sp)
    80005e4a:	7be2                	ld	s7,56(sp)
    80005e4c:	7c42                	ld	s8,48(sp)
    80005e4e:	7ca2                	ld	s9,40(sp)
    80005e50:	7d02                	ld	s10,32(sp)
    80005e52:	6de2                	ld	s11,24(sp)
    80005e54:	6129                	addi	sp,sp,192
    80005e56:	8082                	ret
    release(&pr.lock);
    80005e58:	00040517          	auipc	a0,0x40
    80005e5c:	39050513          	addi	a0,a0,912 # 800461e8 <pr>
    80005e60:	00000097          	auipc	ra,0x0
    80005e64:	3cc080e7          	jalr	972(ra) # 8000622c <release>
}
    80005e68:	bfc9                	j	80005e3a <printf+0x1b0>

0000000080005e6a <printfinit>:
    ;
}

void
printfinit(void)
{
    80005e6a:	1101                	addi	sp,sp,-32
    80005e6c:	ec06                	sd	ra,24(sp)
    80005e6e:	e822                	sd	s0,16(sp)
    80005e70:	e426                	sd	s1,8(sp)
    80005e72:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005e74:	00040497          	auipc	s1,0x40
    80005e78:	37448493          	addi	s1,s1,884 # 800461e8 <pr>
    80005e7c:	00003597          	auipc	a1,0x3
    80005e80:	93c58593          	addi	a1,a1,-1732 # 800087b8 <syscalls+0x3f0>
    80005e84:	8526                	mv	a0,s1
    80005e86:	00000097          	auipc	ra,0x0
    80005e8a:	262080e7          	jalr	610(ra) # 800060e8 <initlock>
  pr.locking = 1;
    80005e8e:	4785                	li	a5,1
    80005e90:	cc9c                	sw	a5,24(s1)
}
    80005e92:	60e2                	ld	ra,24(sp)
    80005e94:	6442                	ld	s0,16(sp)
    80005e96:	64a2                	ld	s1,8(sp)
    80005e98:	6105                	addi	sp,sp,32
    80005e9a:	8082                	ret

0000000080005e9c <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005e9c:	1141                	addi	sp,sp,-16
    80005e9e:	e406                	sd	ra,8(sp)
    80005ea0:	e022                	sd	s0,0(sp)
    80005ea2:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005ea4:	100007b7          	lui	a5,0x10000
    80005ea8:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005eac:	f8000713          	li	a4,-128
    80005eb0:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005eb4:	470d                	li	a4,3
    80005eb6:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005eba:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005ebe:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005ec2:	469d                	li	a3,7
    80005ec4:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005ec8:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005ecc:	00003597          	auipc	a1,0x3
    80005ed0:	90c58593          	addi	a1,a1,-1780 # 800087d8 <digits+0x18>
    80005ed4:	00040517          	auipc	a0,0x40
    80005ed8:	33450513          	addi	a0,a0,820 # 80046208 <uart_tx_lock>
    80005edc:	00000097          	auipc	ra,0x0
    80005ee0:	20c080e7          	jalr	524(ra) # 800060e8 <initlock>
}
    80005ee4:	60a2                	ld	ra,8(sp)
    80005ee6:	6402                	ld	s0,0(sp)
    80005ee8:	0141                	addi	sp,sp,16
    80005eea:	8082                	ret

0000000080005eec <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005eec:	1101                	addi	sp,sp,-32
    80005eee:	ec06                	sd	ra,24(sp)
    80005ef0:	e822                	sd	s0,16(sp)
    80005ef2:	e426                	sd	s1,8(sp)
    80005ef4:	1000                	addi	s0,sp,32
    80005ef6:	84aa                	mv	s1,a0
  push_off();
    80005ef8:	00000097          	auipc	ra,0x0
    80005efc:	234080e7          	jalr	564(ra) # 8000612c <push_off>

  if(panicked){
    80005f00:	00003797          	auipc	a5,0x3
    80005f04:	11c7a783          	lw	a5,284(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f08:	10000737          	lui	a4,0x10000
  if(panicked){
    80005f0c:	c391                	beqz	a5,80005f10 <uartputc_sync+0x24>
    for(;;)
    80005f0e:	a001                	j	80005f0e <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f10:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005f14:	0207f793          	andi	a5,a5,32
    80005f18:	dfe5                	beqz	a5,80005f10 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005f1a:	0ff4f513          	zext.b	a0,s1
    80005f1e:	100007b7          	lui	a5,0x10000
    80005f22:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005f26:	00000097          	auipc	ra,0x0
    80005f2a:	2a6080e7          	jalr	678(ra) # 800061cc <pop_off>
}
    80005f2e:	60e2                	ld	ra,24(sp)
    80005f30:	6442                	ld	s0,16(sp)
    80005f32:	64a2                	ld	s1,8(sp)
    80005f34:	6105                	addi	sp,sp,32
    80005f36:	8082                	ret

0000000080005f38 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005f38:	00003797          	auipc	a5,0x3
    80005f3c:	0e87b783          	ld	a5,232(a5) # 80009020 <uart_tx_r>
    80005f40:	00003717          	auipc	a4,0x3
    80005f44:	0e873703          	ld	a4,232(a4) # 80009028 <uart_tx_w>
    80005f48:	06f70a63          	beq	a4,a5,80005fbc <uartstart+0x84>
{
    80005f4c:	7139                	addi	sp,sp,-64
    80005f4e:	fc06                	sd	ra,56(sp)
    80005f50:	f822                	sd	s0,48(sp)
    80005f52:	f426                	sd	s1,40(sp)
    80005f54:	f04a                	sd	s2,32(sp)
    80005f56:	ec4e                	sd	s3,24(sp)
    80005f58:	e852                	sd	s4,16(sp)
    80005f5a:	e456                	sd	s5,8(sp)
    80005f5c:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005f5e:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005f62:	00040a17          	auipc	s4,0x40
    80005f66:	2a6a0a13          	addi	s4,s4,678 # 80046208 <uart_tx_lock>
    uart_tx_r += 1;
    80005f6a:	00003497          	auipc	s1,0x3
    80005f6e:	0b648493          	addi	s1,s1,182 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005f72:	00003997          	auipc	s3,0x3
    80005f76:	0b698993          	addi	s3,s3,182 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005f7a:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005f7e:	02077713          	andi	a4,a4,32
    80005f82:	c705                	beqz	a4,80005faa <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005f84:	01f7f713          	andi	a4,a5,31
    80005f88:	9752                	add	a4,a4,s4
    80005f8a:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80005f8e:	0785                	addi	a5,a5,1
    80005f90:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80005f92:	8526                	mv	a0,s1
    80005f94:	ffffc097          	auipc	ra,0xffffc
    80005f98:	83c080e7          	jalr	-1988(ra) # 800017d0 <wakeup>
    
    WriteReg(THR, c);
    80005f9c:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80005fa0:	609c                	ld	a5,0(s1)
    80005fa2:	0009b703          	ld	a4,0(s3)
    80005fa6:	fcf71ae3          	bne	a4,a5,80005f7a <uartstart+0x42>
  }
}
    80005faa:	70e2                	ld	ra,56(sp)
    80005fac:	7442                	ld	s0,48(sp)
    80005fae:	74a2                	ld	s1,40(sp)
    80005fb0:	7902                	ld	s2,32(sp)
    80005fb2:	69e2                	ld	s3,24(sp)
    80005fb4:	6a42                	ld	s4,16(sp)
    80005fb6:	6aa2                	ld	s5,8(sp)
    80005fb8:	6121                	addi	sp,sp,64
    80005fba:	8082                	ret
    80005fbc:	8082                	ret

0000000080005fbe <uartputc>:
{
    80005fbe:	7179                	addi	sp,sp,-48
    80005fc0:	f406                	sd	ra,40(sp)
    80005fc2:	f022                	sd	s0,32(sp)
    80005fc4:	ec26                	sd	s1,24(sp)
    80005fc6:	e84a                	sd	s2,16(sp)
    80005fc8:	e44e                	sd	s3,8(sp)
    80005fca:	e052                	sd	s4,0(sp)
    80005fcc:	1800                	addi	s0,sp,48
    80005fce:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80005fd0:	00040517          	auipc	a0,0x40
    80005fd4:	23850513          	addi	a0,a0,568 # 80046208 <uart_tx_lock>
    80005fd8:	00000097          	auipc	ra,0x0
    80005fdc:	1a0080e7          	jalr	416(ra) # 80006178 <acquire>
  if(panicked){
    80005fe0:	00003797          	auipc	a5,0x3
    80005fe4:	03c7a783          	lw	a5,60(a5) # 8000901c <panicked>
    80005fe8:	c391                	beqz	a5,80005fec <uartputc+0x2e>
    for(;;)
    80005fea:	a001                	j	80005fea <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005fec:	00003717          	auipc	a4,0x3
    80005ff0:	03c73703          	ld	a4,60(a4) # 80009028 <uart_tx_w>
    80005ff4:	00003797          	auipc	a5,0x3
    80005ff8:	02c7b783          	ld	a5,44(a5) # 80009020 <uart_tx_r>
    80005ffc:	02078793          	addi	a5,a5,32
    80006000:	02e79b63          	bne	a5,a4,80006036 <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006004:	00040997          	auipc	s3,0x40
    80006008:	20498993          	addi	s3,s3,516 # 80046208 <uart_tx_lock>
    8000600c:	00003497          	auipc	s1,0x3
    80006010:	01448493          	addi	s1,s1,20 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006014:	00003917          	auipc	s2,0x3
    80006018:	01490913          	addi	s2,s2,20 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000601c:	85ce                	mv	a1,s3
    8000601e:	8526                	mv	a0,s1
    80006020:	ffffb097          	auipc	ra,0xffffb
    80006024:	624080e7          	jalr	1572(ra) # 80001644 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006028:	00093703          	ld	a4,0(s2)
    8000602c:	609c                	ld	a5,0(s1)
    8000602e:	02078793          	addi	a5,a5,32
    80006032:	fee785e3          	beq	a5,a4,8000601c <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006036:	00040497          	auipc	s1,0x40
    8000603a:	1d248493          	addi	s1,s1,466 # 80046208 <uart_tx_lock>
    8000603e:	01f77793          	andi	a5,a4,31
    80006042:	97a6                	add	a5,a5,s1
    80006044:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    80006048:	0705                	addi	a4,a4,1
    8000604a:	00003797          	auipc	a5,0x3
    8000604e:	fce7bf23          	sd	a4,-34(a5) # 80009028 <uart_tx_w>
      uartstart();
    80006052:	00000097          	auipc	ra,0x0
    80006056:	ee6080e7          	jalr	-282(ra) # 80005f38 <uartstart>
      release(&uart_tx_lock);
    8000605a:	8526                	mv	a0,s1
    8000605c:	00000097          	auipc	ra,0x0
    80006060:	1d0080e7          	jalr	464(ra) # 8000622c <release>
}
    80006064:	70a2                	ld	ra,40(sp)
    80006066:	7402                	ld	s0,32(sp)
    80006068:	64e2                	ld	s1,24(sp)
    8000606a:	6942                	ld	s2,16(sp)
    8000606c:	69a2                	ld	s3,8(sp)
    8000606e:	6a02                	ld	s4,0(sp)
    80006070:	6145                	addi	sp,sp,48
    80006072:	8082                	ret

0000000080006074 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006074:	1141                	addi	sp,sp,-16
    80006076:	e422                	sd	s0,8(sp)
    80006078:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000607a:	100007b7          	lui	a5,0x10000
    8000607e:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006082:	8b85                	andi	a5,a5,1
    80006084:	cb81                	beqz	a5,80006094 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    80006086:	100007b7          	lui	a5,0x10000
    8000608a:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000608e:	6422                	ld	s0,8(sp)
    80006090:	0141                	addi	sp,sp,16
    80006092:	8082                	ret
    return -1;
    80006094:	557d                	li	a0,-1
    80006096:	bfe5                	j	8000608e <uartgetc+0x1a>

0000000080006098 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006098:	1101                	addi	sp,sp,-32
    8000609a:	ec06                	sd	ra,24(sp)
    8000609c:	e822                	sd	s0,16(sp)
    8000609e:	e426                	sd	s1,8(sp)
    800060a0:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800060a2:	54fd                	li	s1,-1
    800060a4:	a029                	j	800060ae <uartintr+0x16>
      break;
    consoleintr(c);
    800060a6:	00000097          	auipc	ra,0x0
    800060aa:	918080e7          	jalr	-1768(ra) # 800059be <consoleintr>
    int c = uartgetc();
    800060ae:	00000097          	auipc	ra,0x0
    800060b2:	fc6080e7          	jalr	-58(ra) # 80006074 <uartgetc>
    if(c == -1)
    800060b6:	fe9518e3          	bne	a0,s1,800060a6 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800060ba:	00040497          	auipc	s1,0x40
    800060be:	14e48493          	addi	s1,s1,334 # 80046208 <uart_tx_lock>
    800060c2:	8526                	mv	a0,s1
    800060c4:	00000097          	auipc	ra,0x0
    800060c8:	0b4080e7          	jalr	180(ra) # 80006178 <acquire>
  uartstart();
    800060cc:	00000097          	auipc	ra,0x0
    800060d0:	e6c080e7          	jalr	-404(ra) # 80005f38 <uartstart>
  release(&uart_tx_lock);
    800060d4:	8526                	mv	a0,s1
    800060d6:	00000097          	auipc	ra,0x0
    800060da:	156080e7          	jalr	342(ra) # 8000622c <release>
}
    800060de:	60e2                	ld	ra,24(sp)
    800060e0:	6442                	ld	s0,16(sp)
    800060e2:	64a2                	ld	s1,8(sp)
    800060e4:	6105                	addi	sp,sp,32
    800060e6:	8082                	ret

00000000800060e8 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800060e8:	1141                	addi	sp,sp,-16
    800060ea:	e422                	sd	s0,8(sp)
    800060ec:	0800                	addi	s0,sp,16
  lk->name = name;
    800060ee:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800060f0:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800060f4:	00053823          	sd	zero,16(a0)
}
    800060f8:	6422                	ld	s0,8(sp)
    800060fa:	0141                	addi	sp,sp,16
    800060fc:	8082                	ret

00000000800060fe <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800060fe:	411c                	lw	a5,0(a0)
    80006100:	e399                	bnez	a5,80006106 <holding+0x8>
    80006102:	4501                	li	a0,0
  return r;
}
    80006104:	8082                	ret
{
    80006106:	1101                	addi	sp,sp,-32
    80006108:	ec06                	sd	ra,24(sp)
    8000610a:	e822                	sd	s0,16(sp)
    8000610c:	e426                	sd	s1,8(sp)
    8000610e:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006110:	6904                	ld	s1,16(a0)
    80006112:	ffffb097          	auipc	ra,0xffffb
    80006116:	e52080e7          	jalr	-430(ra) # 80000f64 <mycpu>
    8000611a:	40a48533          	sub	a0,s1,a0
    8000611e:	00153513          	seqz	a0,a0
}
    80006122:	60e2                	ld	ra,24(sp)
    80006124:	6442                	ld	s0,16(sp)
    80006126:	64a2                	ld	s1,8(sp)
    80006128:	6105                	addi	sp,sp,32
    8000612a:	8082                	ret

000000008000612c <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    8000612c:	1101                	addi	sp,sp,-32
    8000612e:	ec06                	sd	ra,24(sp)
    80006130:	e822                	sd	s0,16(sp)
    80006132:	e426                	sd	s1,8(sp)
    80006134:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006136:	100024f3          	csrr	s1,sstatus
    8000613a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000613e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006140:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006144:	ffffb097          	auipc	ra,0xffffb
    80006148:	e20080e7          	jalr	-480(ra) # 80000f64 <mycpu>
    8000614c:	5d3c                	lw	a5,120(a0)
    8000614e:	cf89                	beqz	a5,80006168 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006150:	ffffb097          	auipc	ra,0xffffb
    80006154:	e14080e7          	jalr	-492(ra) # 80000f64 <mycpu>
    80006158:	5d3c                	lw	a5,120(a0)
    8000615a:	2785                	addiw	a5,a5,1
    8000615c:	dd3c                	sw	a5,120(a0)
}
    8000615e:	60e2                	ld	ra,24(sp)
    80006160:	6442                	ld	s0,16(sp)
    80006162:	64a2                	ld	s1,8(sp)
    80006164:	6105                	addi	sp,sp,32
    80006166:	8082                	ret
    mycpu()->intena = old;
    80006168:	ffffb097          	auipc	ra,0xffffb
    8000616c:	dfc080e7          	jalr	-516(ra) # 80000f64 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006170:	8085                	srli	s1,s1,0x1
    80006172:	8885                	andi	s1,s1,1
    80006174:	dd64                	sw	s1,124(a0)
    80006176:	bfe9                	j	80006150 <push_off+0x24>

0000000080006178 <acquire>:
{
    80006178:	1101                	addi	sp,sp,-32
    8000617a:	ec06                	sd	ra,24(sp)
    8000617c:	e822                	sd	s0,16(sp)
    8000617e:	e426                	sd	s1,8(sp)
    80006180:	1000                	addi	s0,sp,32
    80006182:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006184:	00000097          	auipc	ra,0x0
    80006188:	fa8080e7          	jalr	-88(ra) # 8000612c <push_off>
  if(holding(lk))
    8000618c:	8526                	mv	a0,s1
    8000618e:	00000097          	auipc	ra,0x0
    80006192:	f70080e7          	jalr	-144(ra) # 800060fe <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006196:	4705                	li	a4,1
  if(holding(lk))
    80006198:	e115                	bnez	a0,800061bc <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000619a:	87ba                	mv	a5,a4
    8000619c:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800061a0:	2781                	sext.w	a5,a5
    800061a2:	ffe5                	bnez	a5,8000619a <acquire+0x22>
  __sync_synchronize();
    800061a4:	0ff0000f          	fence
  lk->cpu = mycpu();
    800061a8:	ffffb097          	auipc	ra,0xffffb
    800061ac:	dbc080e7          	jalr	-580(ra) # 80000f64 <mycpu>
    800061b0:	e888                	sd	a0,16(s1)
}
    800061b2:	60e2                	ld	ra,24(sp)
    800061b4:	6442                	ld	s0,16(sp)
    800061b6:	64a2                	ld	s1,8(sp)
    800061b8:	6105                	addi	sp,sp,32
    800061ba:	8082                	ret
    panic("acquire");
    800061bc:	00002517          	auipc	a0,0x2
    800061c0:	62450513          	addi	a0,a0,1572 # 800087e0 <digits+0x20>
    800061c4:	00000097          	auipc	ra,0x0
    800061c8:	a7c080e7          	jalr	-1412(ra) # 80005c40 <panic>

00000000800061cc <pop_off>:

void
pop_off(void)
{
    800061cc:	1141                	addi	sp,sp,-16
    800061ce:	e406                	sd	ra,8(sp)
    800061d0:	e022                	sd	s0,0(sp)
    800061d2:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800061d4:	ffffb097          	auipc	ra,0xffffb
    800061d8:	d90080e7          	jalr	-624(ra) # 80000f64 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800061dc:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800061e0:	8b89                	andi	a5,a5,2
  if(intr_get())
    800061e2:	e78d                	bnez	a5,8000620c <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800061e4:	5d3c                	lw	a5,120(a0)
    800061e6:	02f05b63          	blez	a5,8000621c <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800061ea:	37fd                	addiw	a5,a5,-1
    800061ec:	0007871b          	sext.w	a4,a5
    800061f0:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800061f2:	eb09                	bnez	a4,80006204 <pop_off+0x38>
    800061f4:	5d7c                	lw	a5,124(a0)
    800061f6:	c799                	beqz	a5,80006204 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800061f8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800061fc:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006200:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006204:	60a2                	ld	ra,8(sp)
    80006206:	6402                	ld	s0,0(sp)
    80006208:	0141                	addi	sp,sp,16
    8000620a:	8082                	ret
    panic("pop_off - interruptible");
    8000620c:	00002517          	auipc	a0,0x2
    80006210:	5dc50513          	addi	a0,a0,1500 # 800087e8 <digits+0x28>
    80006214:	00000097          	auipc	ra,0x0
    80006218:	a2c080e7          	jalr	-1492(ra) # 80005c40 <panic>
    panic("pop_off");
    8000621c:	00002517          	auipc	a0,0x2
    80006220:	5e450513          	addi	a0,a0,1508 # 80008800 <digits+0x40>
    80006224:	00000097          	auipc	ra,0x0
    80006228:	a1c080e7          	jalr	-1508(ra) # 80005c40 <panic>

000000008000622c <release>:
{
    8000622c:	1101                	addi	sp,sp,-32
    8000622e:	ec06                	sd	ra,24(sp)
    80006230:	e822                	sd	s0,16(sp)
    80006232:	e426                	sd	s1,8(sp)
    80006234:	1000                	addi	s0,sp,32
    80006236:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006238:	00000097          	auipc	ra,0x0
    8000623c:	ec6080e7          	jalr	-314(ra) # 800060fe <holding>
    80006240:	c115                	beqz	a0,80006264 <release+0x38>
  lk->cpu = 0;
    80006242:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006246:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    8000624a:	0f50000f          	fence	iorw,ow
    8000624e:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006252:	00000097          	auipc	ra,0x0
    80006256:	f7a080e7          	jalr	-134(ra) # 800061cc <pop_off>
}
    8000625a:	60e2                	ld	ra,24(sp)
    8000625c:	6442                	ld	s0,16(sp)
    8000625e:	64a2                	ld	s1,8(sp)
    80006260:	6105                	addi	sp,sp,32
    80006262:	8082                	ret
    panic("release");
    80006264:	00002517          	auipc	a0,0x2
    80006268:	5a450513          	addi	a0,a0,1444 # 80008808 <digits+0x48>
    8000626c:	00000097          	auipc	ra,0x0
    80006270:	9d4080e7          	jalr	-1580(ra) # 80005c40 <panic>
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
