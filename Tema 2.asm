.data
    pozitie: .space 4
    tn: .space 4
    readable: .space 4
    n: .space 4
    m: .space 4
    nr: .space 4
    a: .space 400
    x: .space 400
    ok: .long 0
    three: .long 3
    formatScanf1: .asciz "%d %d"
    formatScanf2: .asciz "%d"
    formatPrintf: .asciz "%d "
    formatPrintfLn: .asciz "\n"
    formatNoSolution: .asciz "%d\n"
.text
.global main
poz:
    pushl %ebp
    movl %esp, %ebp
    
    movl $0, nr
    movl $-1, pozitie

    movl 8(%ebp), %ebx
    cmp $0, %ebx
    je return1
    
    xorl %ecx, %ecx 
poz_for: 
    movl 8(%ebp), %ebx
    cmp %ecx, %ebx
    je poz_cont_for
         
    movl $x, %esi 
    movl (%esi, %ebx, 4), %eax
    movl (%esi, %ecx, 4), %edx 

    cmp %eax, %edx 
    jne poz_cont

    movl %ecx, pozitie
    incl nr
poz_cont:
    incl %ecx
    jmp poz_for
poz_cont_for:
    cmp $-1, pozitie
    je return1
    
    movl 8(%ebp), %ebx
    subl pozitie, %ebx
    subl $1, %ebx  

    cmp %ebx, m
    jg return0

    cmp $2, nr
    jg return0
return1:
    movl $1, %eax
    jmp poz_exit
return0:
    movl $0, %eax 
poz_exit:
    popl %ebp

    ret
afis:  
    movl $1, ok
    xorl %ecx, %ecx   
afis_for:
    cmp %ecx, tn
    je afis_exit
    
    movl $x, %edi
    movl (%edi, %ecx, 4), %edx

    pushl %eax
    pushl %ebx
    pushl %edx
    pushl %ecx 
    pushl %edx 
    pushl $formatPrintf
    call printf 
    popl %ebx 
    popl %ebx 
    popl %ecx
    popl %edx
    popl %ebx 
    popl %eax

    incl %ecx
    jmp afis_for
afis_exit:
    pushl %eax
    pushl %ebx
    pushl %edx
    pushl %ecx 
    pushl $formatPrintfLn
    call puts
    popl %ebx 
    popl %ecx
    popl %edx
    popl %ebx 
    popl %eax

    ret
back:
    pushl %ebp
    movl %esp, %ebp 

    movl 8(%ebp), %ebx 
    
    cmp $1, ok
    je back_exit 
    
    xorl %ecx, %ecx 
    cmp tn, %ebx
    je back_afis
    
    movl $1, %ecx
    jmp back_for
back_afis:
    pushl %ecx
    pushl %eax
    pushl %edx
    pushl %ebx
    call afis
    popl %ebx
    popl %edx
    popl %eax
    popl %ecx

    jmp back_exit
back_for:
    cmp n, %ecx
    jg back_exit

    movl 8(%ebp), %ebx
    movl $a, %esi
    movl $x, %edi
    
    movl (%esi, %ebx, 4), %edx 

    cmp $0, %edx 
    jne pfix
  
    movl %ecx, (%edi, %ebx, 4) 
if_poz: 
    movl 8(%ebp), %ebx
    pushl %ecx
    pushl %edx
    pushl %ebx
    call poz 
    popl %ebx
    popl %edx
    popl %ecx

    cmp $0, %eax
    jne back_rec 
if_poz_inc: 
    incl %ecx
    jmp back_for   
back_rec:
    movl 8(%ebp), %ebx

    pushl %eax
    pushl %ecx 
    addl $1, %ebx  
    pushl %ebx 
    call back
    popl %ebx 
    popl %ecx
    popl %eax
    
    jmp if_poz_inc
pfix:
    movl 8(%ebp), %ebx
    movl $a, %esi
    movl $x, %edi

    movl (%esi, %ebx, 4), %edx
    movl %edx, (%edi, %ebx, 4) 

    jmp if_poz
back_exit: 
    popl %ebp

    ret   
main:    
    pushl $m
    pushl $n
    pushl $formatScanf1
    call scanf
    popl %ebx
    popl %ebx
    popl %ebx
 
    xorl %edx, %edx
    movl n, %eax
    mull three
    movl %eax, tn

    xorl %ecx, %ecx 
    movl $a, %edi   
for_citire:
    cmp %ecx, tn
    je cont
    
    pushl %ecx
    pushl $readable
    pushl $formatScanf2
    call scanf
    popl %ebx 
    popl %ebx 
    popl %ecx 

    movl readable, %eax
    movl %eax, (%edi, %ecx, 4)

    incl %ecx 
    jmp for_citire  
cont:  
    pushl $0
    call back
    popl %ebx 
testx: 
    cmp $0, ok
    jne et_exit
    
    decl ok

    pushl ok
    pushl $formatNoSolution
    call printf 
    popl %ebx 
    popl %ebx    
et_exit: 
    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80
