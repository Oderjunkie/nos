	.text
	.code16
	.file	"boot.c"
	.globl	main                            # -- Begin function main
	.type	main,@function
main:                                   # @main
# %bb.0:
	pushl	%ebx
	subl	$8, %esp
	movzwl	ptr, %ebx
	movw	$516, %ax                       # imm = 0x204
	movw	$2, %cx
	#APP
	movw	$516, %ax                       # imm = 0x204
	movw	$32256, %bx                     # imm = 0x7E00
	movw	$2, %cx
	xorb	%dl, %dl
	int	$19

	#NO_APP
	calll	read
	movl	%eax, %ecx
	addl	$8, %esp
	popl	%ebx
	jmp	eval                            # TAILCALL
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.type	eval,@function                  # -- Begin function eval
eval:                                   # @eval
# %bb.0:
	pushl	%ebx
	pushl	%edi
	pushl	%esi
	subl	$16, %esp
	cmpb	$0, 4(%ecx)
	je	.LBB1_1
# %bb.5:
	movl	(%ecx), %esi
	movl	4(%esi), %ecx
	calll	eval
	andl	$0, 12(%esp)
	andl	$0, 8(%esp)
	movb	$8, %bl
	movl	(%esi), %esi
	#APP
	movl	memptr, %edi
	addb	%bl, memptr
	#NO_APP
	movl	%edi, 8(%esp)
.LBB1_6:                                # =>This Inner Loop Header: Depth=1
	movl	4(%esi), %ecx
	calll	eval
	andl	$0, 4(%edi)
	cmpl	$0, (%esi)
	je	.LBB1_8
# %bb.7:                                #   in Loop: Header=BB1_6 Depth=1
	#APP
	movl	memptr, %eax
	addb	%bl, memptr
	#NO_APP
	movl	%eax, (%edi)
	movl	%eax, %edi
	movl	(%esi), %esi
	jmp	.LBB1_6
.LBB1_8:
	andl	$0, (%edi)
	#APP
	#NO_APP
	jmp	.LBB1_9
.LBB1_1:
	movl	(%ecx), %edx
	movl	%edx, %esi
	#APP
	xorw	%ax, %ax
	repne		scasb	%es:(%di), %al
	#NO_APP
	movl	%esi, %ecx
	movl	$nil, %eax
	subl	%edx, %ecx
.LBB1_2:                                # =>This Inner Loop Header: Depth=1
	movl	4(%eax), %edi
	movl	%edx, %esi
	#APP
	rep		cmpsb	%es:(%di), (%si)

	#NO_APP
	jne	.LBB1_4
# %bb.3:                                #   in Loop: Header=BB1_2 Depth=1
	movl	(%eax), %eax
	testl	%eax, %eax
	jne	.LBB1_2
.LBB1_9:
	addl	$16, %esp
	popl	%esi
	popl	%edi
	popl	%ebx
	retl
.LBB1_4:
	movl	8(%eax), %ecx
	addl	$16, %esp
	popl	%esi
	popl	%edi
	popl	%ebx
	jmp	eval                            # TAILCALL
.Lfunc_end1:
	.size	eval, .Lfunc_end1-eval
                                        # -- End function
	.type	read,@function                  # -- Begin function read
read:                                   # @read
# %bb.0:
	pushl	%ebx
	pushl	%edi
	pushl	%esi
	movl	ptr, %esi
.LBB2_1:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_18 Depth 2
	movb	(%esi), %al
	cmpb	$10, %al
	je	.LBB2_20
# %bb.2:                                #   in Loop: Header=BB2_1 Depth=1
	cmpb	$32, %al
	je	.LBB2_20
# %bb.3:                                #   in Loop: Header=BB2_1 Depth=1
	cmpb	$59, %al
	jne	.LBB2_4
.LBB2_18:                               #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	cmpb	$10, 1(%esi)
	leal	1(%esi), %esi
	jne	.LBB2_18
# %bb.19:                               #   in Loop: Header=BB2_1 Depth=1
	movl	%esi, ptr
.LBB2_20:                               #   in Loop: Header=BB2_1 Depth=1
	incl	%esi
	movl	%esi, ptr
	jmp	.LBB2_1
.LBB2_4:
	testb	%al, %al
	je	.LBB2_22
# %bb.5:
	cmpb	$40, %al
	je	.LBB2_12
# %bb.6:
	cmpb	$41, %al
	jne	.LBB2_7
# %bb.21:
	incl	%esi
	movl	%esi, ptr
.LBB2_22:                               # %.loopexit
	xorl	%eax, %eax
	jmp	.LBB2_23
.LBB2_12:
	movb	$8, %bl
	#APP
	movl	memptr, %esi
	addb	%bl, memptr
	#NO_APP
	incl	ptr
	calll	read
	movl	%esi, %edi
	movl	%eax, 4(%esi)
.LBB2_13:                               # =>This Inner Loop Header: Depth=1
	calll	read
	testl	%eax, %eax
	je	.LBB2_15
# %bb.14:                               #   in Loop: Header=BB2_13 Depth=1
	#APP
	movl	memptr, %ecx
	addb	%bl, memptr
	#NO_APP
	movl	%ecx, (%edi)
	movl	%eax, 4(%ecx)
	movl	%ecx, %edi
	jmp	.LBB2_13
.LBB2_7:
	xorl	%ecx, %ecx
	movl	$134218497, %eax                # imm = 0x8000301
	incl	%ecx
.LBB2_8:                                # =>This Inner Loop Header: Depth=1
	movb	(%esi,%ecx), %dl
	movb	%dl, %dh
	addb	$-32, %dh
	cmpb	$27, %dh
	ja	.LBB2_9
# %bb.16:                               #   in Loop: Header=BB2_8 Depth=1
	movzbl	%dh, %edi
	btl	%edi, %eax
	jae	.LBB2_9
.LBB2_17:                               #   in Loop: Header=BB2_8 Depth=1
	incl	%ecx
	jmp	.LBB2_8
.LBB2_9:                                #   in Loop: Header=BB2_8 Depth=1
	cmpb	$10, %dl
	je	.LBB2_17
# %bb.10:                               #   in Loop: Header=BB2_8 Depth=1
	testb	%dl, %dl
	je	.LBB2_17
# %bb.11:
	leal	(%esi,%ecx), %eax
	xorl	%edx, %edx
	movl	%eax, ptr
	movl	%ecx, %eax
	incb	%al
	#APP
	movl	memptr, %edi
	addb	%al, memptr
	#NO_APP
	#APP
	rep		movsb	(%si), %es:(%di)

	#NO_APP
	movb	%dl, (%edi,%ecx)
	movb	$5, %al
	#APP
	movl	memptr, %eax
	addb	%al, memptr
	#NO_APP
	movb	%dl, 4(%eax)
	movl	%edi, (%eax)
	jmp	.LBB2_23
.LBB2_15:
	andl	$0, (%edi)
	movb	$5, %al
	#APP
	movl	memptr, %eax
	addb	%al, memptr
	#NO_APP
	movb	$1, 4(%eax)
	movl	%esi, (%eax)
.LBB2_23:
	popl	%esi
	popl	%edi
	popl	%ebx
	retl
.Lfunc_end2:
	.size	read, .Lfunc_end2-read
                                        # -- End function
	.type	ptr,@object                     # @ptr
	.data
	.p2align	2
ptr:
	.long	32256
	.size	ptr, 4

	.type	nil,@object                     # @nil
	.section	.rodata,"a",@progbits
	.p2align	2
nil:
	.long	0
	.long	.L.str
	.long	0
	.size	nil, 12

	.type	.L.str,@object                  # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.zero	1
	.size	.L.str, 1

	.type	memptr,@object                  # @memptr
	.data
	.p2align	2
memptr:
	.long	1280
	.size	memptr, 4

	.ident	"clang version 11.1.0"
	.section	".note.GNU-stack","",@progbits
