	.text
	.code16
	.file	"boot.c"
	.globl	main                            # -- Begin function main
	.type	main,@function
main:                                   # @main
# %bb.0:
	push %cx
	sub $8, %sp
	mov ptr, %cx
	mov $516, %ax                       # imm = 0x204
	mov $2, %bx
	#APP
	mov $516, %ax                       # imm = 0x204
	mov $32256, %cx                     # imm = 0x7E00
	mov $2, %bx
	xor %dl, %dl
	int $19

	#NO_APP
	call read
	mov %ax, %bx
	add $8, %sp
	pop %cx
	jmp	eval                            # TAILCALL
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.type	eval,@function                  # -- Begin function eval
eval:                                   # @eval
# %bb.0:
	push %cx
	push %di
	push %si
	sub $16, %sp
	cmpb $0, 4(%bx)
	je .LBB1_1
# %bb.5:
	mov (%bx), %si
	mov 4(%si), %bx
	call eval
	andw $0, 12(%esp)
	andw $0, 8(%esp)
	mov $8, %bl
	mov (%si), %si
	#APP
	mov memptr, %di
	add %bl, memptr
	#NO_APP
	mov %di, 8(%esp)
.LBB1_6:                                # =>This Inner Loop Header: Depth=1
	mov 4(%si), %bx
	call eval
	andl $0, 4(%di)
	cmpl $0, (%si)
	je .LBB1_8
# %bb.7:                                #   in Loop: Header=BB1_6 Depth=1
	#APP
	mov memptr, %ax
	add %bl, memptr
	#NO_APP
	mov %ax, (%di)
	mov %ax, %di
	mov (%si), %si
	jmp	.LBB1_6
.LBB1_8:
	andw $0, (%di)
	#APP
	#NO_APP
	jmp	.LBB1_9
.LBB1_1:
	mov (%bx), %dx
	mov %dx, %si
	#APP
	xor	%ax, %ax
	repne		scasb	%es:(%di), %al
	#NO_APP
	mov %si, %bx
	mov $nil, %ax
	sub %dx, %bx
.LBB1_2:                                # =>This Inner Loop Header: Depth=1
	mov 4(%eax), %di
	mov %dx, %si
	#APP
	rep cmpsb	%es:(%di), (%si)

	#NO_APP
	jne	.LBB1_4
# %bb.3:                                #   in Loop: Header=BB1_2 Depth=1
	mov (%eax), %eax
	test %ax, %ax
	jne .LBB1_2
.LBB1_9:
	add $16, %sp
	pop %si
	pop %di
	pop %cx
	ret
.LBB1_4:
	mov 8(%eax), %bx
	add $16, %sp
	pop %si
	pop %di
	pop %cx
	jmp	eval                            # TAILCALL
.Lfunc_end1:
	.size	eval, .Lfunc_end1-eval
                                        # -- End function
	.type	read,@function                  # -- Begin function read
read:                                   # @read
# %bb.0:
	push %cx
	push %di
	push %si
	mov ptr, %si
.LBB2_1:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_18 Depth 2
	movb	(%si), %al
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
	cmpb $10, 1(%si)
	lea 1(%si), %si
	jne	.LBB2_18
# %bb.19:                               #   in Loop: Header=BB2_1 Depth=1
	mov %si, ptr
.LBB2_20:                               #   in Loop: Header=BB2_1 Depth=1
	inc %si
	mov %si, ptr
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
	inc %si
	mov %si, ptr
.LBB2_22:                               # %.loopexit
	xor %ax, %ax
	jmp	.LBB2_23
.LBB2_12:
	mov $8, %bl
	#APP
	mov memptr, %si
	add %bl, memptr
	#NO_APP
	incw ptr
	call read
	mov %si, %di
	mov %ax, 4(%si)
.LBB2_13:                               # =>This Inner Loop Header: Depth=1
	call	read
	test	%ax, %ax
	je	.LBB2_15
# %bb.14:                               #   in Loop: Header=BB2_13 Depth=1
	#APP
	mov	memptr, %bx
	add	%bl, memptr
	#NO_APP
	mov	%bx, (%di)
	mov	%ax, 4(%bx)
	mov	%bx, %di
	jmp	.LBB2_13
.LBB2_7:
	xor %bx, %bx
	mov $134218497, %eax                # imm = 0x8000301
	inc %bx
.LBB2_8:                                # =>This Inner Loop Header: Depth=1
	mov (%bx,%si), %dl
	mov %dl, %dh
	add $-32, %dh
	cmp $27, %dh
	ja .LBB2_9
# %bb.16:                               #   in Loop: Header=BB2_8 Depth=1
	movzbw %dh, %di
	btl %edi, %eax
	jae .LBB2_9
.LBB2_17:                               #   in Loop: Header=BB2_8 Depth=1
	inc %bx
	jmp .LBB2_8
.LBB2_9:                                #   in Loop: Header=BB2_8 Depth=1
	cmpb $10, %dl
	je .LBB2_17
# %bb.10:                               #   in Loop: Header=BB2_8 Depth=1
	test %dl, %dl
	je .LBB2_17
# %bb.11:
	lea (%bx,%si), %ax
	xor %dx, %dx
	mov %ax, ptr
	mov %bx, %ax
	inc %al
	#APP
	mov memptr, %di
	add %al, memptr
	#NO_APP
	#APP
	rep movsb	%ds:(%si), %es:(%di)
	#NO_APP
	mov %dl, (%bx,%di)
	mov $5, %al
	#APP
	mov memptr, %ax
	add %al, memptr
	#NO_APP
	movb %dl, 4(%eax)
	movw %di, (%eax)
	jmp	.LBB2_23
.LBB2_15:
	andw $0, (%di)
	mov $5, %al
	#APP
	mov memptr, %ax
	add %al, memptr
	#NO_APP
	movb $1, 4(%eax)
	mov %si, (%eax)
.LBB2_23:
	pop %si
	pop %di
	pop %cx
	ret
.Lfunc_end2:
	.size	read, .Lfunc_end2-read
                                        # -- End function
	.type	ptr,@object                     # @ptr
	.data
	.p2align	2
ptr:
	.word	32256
	.size	ptr, 2

	.type	nil,@object                     # @nil
	.section	.rodata,"a",@progbits
	.p2align	2
nil:
	.word	0
	.word	.L.str
	.word	0
	.size	nil, 6

	.type	.L.str,@object                  # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.zero	1
	.size	.L.str, 1

	.type	memptr,@object                  # @memptr
	.data
	.p2align	2
memptr:
	.word	1280
	.size	memptr, 2

	.ident	"clang version 11.1.0"
	.section	".note.GNU-stack","",@progbits
