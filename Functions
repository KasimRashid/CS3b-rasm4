	//Needs to have x0 point the head of the linked list
    .global traverse

    //Needs to have x0 point the head of the linked list
    //x0 returns the new number of nodes
    //x1 returns the new byte consumption
    .global traverse_free

    //x0 point the tail of the linked list
    //x1 point to the head of the linked list
    //x2 point to a string to add to the list
    //x0 returns the new number of nodes
    //x1 returns the new byte consumption
    .global add_node_to_list

    //x0 points to a buffer
    //x1 points to a prompt string
    .global get_kbd_input

    //x0 points to the head of the linked list
    //x1 contains the binary signed index
    //x0 returns the new number of nodes
    //x1 returns the new byte consumption
    .global delete_single_node

    //x0 points to the head of the linked list
    //x1 contains the binary signed index
    .global find_node

    //x0 points to the head of the linked list
    //x1 contains the binary signed index
    //x2 points to the new string
    .global edit_node

    //x0 points to the head of the linked list
    //x1 points to the tail of the linked list
    //x2 contains the file descriptor
    //x0 returns the new number of nodes
    //x1 returns the new byte consumption
    //Need to close file after function returns
    .global Read_file

    //x0 points to the head of the linked list
    //x1 contains the file descriptor
    .global Output_file

    .global Print_menu

    //x0 points to the head of the linked list
    //x1 points to a null terminated string to search for
    .global String_search

    .equ NODE_SIZE, 16
    .equ BUFFER, 21

	.data

    szLF:           .asciz "\n"
    szBuffer:       .skip 128
    szERROR:        .asciz "FILE READ ERROR\n"

    szdash:         .asciz "-------------------------------------------------------------------------------------------------------------\n"
    szMenu1:        .asciz "                      RASM4 TEXT EDITOR\n"
    szMenu2:        .asciz "        Data Structure Heap Memory Consumption: "
    szMenu3:        .asciz " bytes\n"
    szMenu4:        .asciz "        Number of Nodes: "
    szMenu5:        .asciz "<1> View all strings\n\n<2> Add string\n    <a> from Keyboard\n    <b> from File\n\n"
    szMenu6:        .asciz "<3> Delete string. Given an index #, delete the entire string and de-allocate memory (including the node).\n\n"
    szMenu7:        .asciz "<4> Edit string. Given an index #, replace old string w/ new string. Allocate/De-allocate as needed.\n\n"
    szMenu8:        .asciz "<5> String search. Regardless of case, return all strings that match the substring given.\n\n"
    szMenu9:        .asciz "<6> Save File (output.txt)\n\n<7> Quit\n\n"

    szBopen:        .asciz "["
    szBclose:       .asciz "] "
    szLineNum:      .asciz "Line: "
    szStrSearch1:   .asciz "Search """
    szStrSearch2:   .asciz """ ("
    szStrSearch3:   .asciz " hits in 1 file of 1 searched)\n"

    dbNewNodePtr:   .quad 0
    dbtailPtr:      .quad 0
    dbheadPtr:      .quad 0

    dbByteUseage:   .quad 0
    dbNumNodes:     .quad 0

    iFD:    .byte 0     //Store the file discriptor
    oFD:    .byte 0
    chLF:   .byte 0xa
    chSP:   .byte 0x20

    newNodePtr: .quad 0

    .text

Print_menu:
    str lr,[sp, #-16]!

    ldr x0,=szdash
    bl putstring

    ldr x0,=szMenu1
    bl putstring

    ldr x0,=szMenu2
    bl putstring
    ldr x0,=dbByteUseage
    ldr x0,[x0]
    ldr x1,=szBuffer
    bl int64asc
    ldr x0,=szBuffer
    bl putstring
    ldr x0,=szMenu3
    bl putstring

    ldr x0,=szMenu4
    bl putstring
    ldr x0,=dbNumNodes
    ldr x0,[x0]
    ldr x1,=szBuffer
    bl int64asc
    ldr x0,=szBuffer
    bl putstring
    ldr x0,=chLF
    bl putch

    ldr x0,=szMenu5
    bl putstring
    ldr x0,=szMenu6
    bl putstring
    ldr x0,=szMenu7
    bl putstring
    ldr x0,=szMenu8
    bl putstring
    ldr x0,=szMenu9
    bl putstring
    
    ldr x0,=szdash
    bl putstring

    Print_menu_exit:
    ldr lr,[sp], #16
    ret lr

    

traverse:
    stp x19, x30, [sp, #-16]!
    str x20, [sp, #-16]!
    mov x19,x0
    mov x20, 0x0

    traverse_top:
        ldr x19,[x19]
        cmp x19,0x0
        b.eq traverse_exit

        ldr x0,=szBopen
        bl putstring
        mov x0,x20
        ldr x1,=szBuffer
        bl int64asc
        ldr x0,=szBuffer
        bl putstring
        ldr x0,=szBclose
        bl putstring

        ldr x0,[x19]
        bl putstring

        add x20, x20, #1
        add x19, x19, #8
        b traverse_top

    traverse_exit:
    ldr x20, [sp], #16
    ldp x19, x30, [sp], #16
    ret lr

traverse_free:
    stp x19, x30, [sp, #-16]!
    str x20,[sp, #-16]!

    mov x19,x0
    ldr x19,[x19]
    
    traverse_free_top:
        cmp x19,0x0
        b.eq traverse_free_exit

        add x20, x19, #8
        ldr x20, [x20]

        add x20, x19, #8
        ldr x20, [x20]
        ldr x0,[x19]
        bl free

        mov x0,x19
        bl free

        mov x19, x20
        b traverse_free_top

    traverse_free_exit:
    mov x0,0x0
    mov x1,0x0

    ldr x20,[sp], #16
    ldp x19, x30, [sp], #16
    ret lr

add_node_to_list:
    stp x19, x20, [sp, #-16]!
    stp x21, x30,[sp, #-16]!
    mov x19, x0     //x19 = tail
    mov x20, x1     //x20 = head
    mov x21, x2     //x21 = string

    mov x0, x2
    bl String_length
    add x0, x0, #17
    
    ldr x1,=dbByteUseage
    ldr x2,[x1]
    add x2, x0, x2
    str x2,[x1]

    ldr x0,=dbNumNodes
    ldr x1,[x0]
    add x1, x1, #1
    str x1,[x0]

    mov x0,NODE_SIZE
    bl malloc

    ldr x1,[x20]    //Go to the head and store in x1
    cmp x1, 0x0     //Compare the head to null
    b.eq add_node_to_empty_list //If null add to the empty list

    str x21,[x0]        //Else store the string in the new node
    ldr x2,[x19]        //Derefrance the tail
    add x2, x2, #8      //Add 8 to get to the pointer
    str x0,[x2]         //Store the addr of the new node in the tail
    str x0,[x19]
    b add_node_to_list_exit

    add_node_to_empty_list:
    str x21,[x0]
    str x0,[x19]
    str x0,[x20]

    add_node_to_list_exit:
    
    ldr x0,=dbNumNodes
    ldr x0,[x0]
    ldr x1,=dbByteUseage
    ldr x1,[x1]

    ldp x21, x30,[sp], #16
    ldp x19, x20, [sp], #16
    ret lr

get_kbd_input:
    stp x21, x30,[sp, #-16]!
    
    mov x21, x0
    mov x0,x1
    bl putstring

    mov x0, x21
    mov x1, BUFFER
    bl getstring

    get_kbd_input_return:
    ldp x21, x30,[sp], #16
    ret lr

delete_single_node:
    stp x19, x20, [sp, #-16]!
    stp x21, x30,[sp, #-16]!

    mov x19,x0  //x19 = head

    ldr x2,[x19]

    cmp x2, 0x0
    b.eq delete_single_node_exit    //Check for 0 nodes
    
    add x2, x2, #8
    ldr x2,[x2]
    cmp x2, 0x0
    b.eq delete_single_node_single  //Check for 1 node

    cmp x1, 0x0
    b.eq delete_single_node_first

    bl find_node
    mov x20, x0

    ldr x0,=dbNumNodes
    ldr x1,[x0]
    sub x1, x1, #1
    str x1,[x0]

    ldr x0,[x20]
    bl String_length

    add x0, x0, #1
    ldr x1,=dbByteUseage
    ldr x2,[x1]
    sub x2, x2, x0
    str x2,[x1]

    mov x0, x20
    ldr x3, [x19]
    ldr x3, [x3, #8]
    ldr x19, [x19]
    delete_single_node_loop1:
        cmp x3, x0
        b.eq delete_single_node_loop1_end
        add x3, x3, #8
        ldr x3, [x3]

        add x19, x19, #8
        ldr x19,[x19]

        b delete_single_node_loop1

    delete_single_node_loop1_end:   //x19 = prev node, x0 = node
    mov x20, x0
    add x20, x20, #8
    ldr x20, [x20]      //x20 = next node

    add x19, x19, #8
    str x20, [x19]

    mov x21, x0
    ldr x0,[x0]
    bl free

    mov x0,x21
    bl free

    b delete_single_node_compleate

    delete_single_node_first:
    mov x20, x19
    ldr x20,[x20]       //x20 = node to be deleted
    ldr x21,[x20, #8]   //x21 = next node

    str x21, [x19]

    mov x21, x20

    ldr x0,=dbNumNodes
    ldr x1,[x0]
    sub x1, x1, #1
    str x1,[x0]

    ldr x0,[x20]
    bl String_length

    add x0, x0, #17
    ldr x1,=dbByteUseage
    ldr x2,[x1]
    sub x2, x2, x0
    str x2,[x1]
    ldr x0,[x21]
    bl free

    mov x0,x21
    bl free

    b delete_single_node_compleate

    delete_single_node_single:
    ldr x21, [x19] 
    ldr x0, [x21]
    bl free

    mov x0,x21
    bl free

    mov x1,0x0
    str x1,[x19]

    delete_single_node_compleate:

    delete_single_node_exit:

    ldr x0,=dbNumNodes
    ldr x0,[x0]
    ldr x1,=dbByteUseage
    ldr x1,[x1]
    
    ldp x21, x30,[sp], #16
    ldp x19, x20, [sp], #16
    ret lr

//x0 points to the head of the linked list
//x1 contains the binary signed index
find_node:
    stp x19, x20, [sp, #-16]!
    stp x21, x30,[sp, #-16]!

    mov x19,x0
    mov x2, 0x0

    find_node_loop:
        ldr x19,[x19]
        cmp x19,0x0
        b.eq find_node_out_of_bounds
        
        cmp x2, x1
        b.eq find_node_done 

        add x2, x2, #1
        add x19, x19, #8
        b find_node_loop

    find_node_out_of_bounds:
    mov x0,0x0
    b find_node_exit

    find_node_done:
    mov x0, x19

    find_node_exit:
    ldp x21, x30,[sp], #16
    ldp x19, x20, [sp], #16
    ret lr

edit_node:
    stp x19, x20, [sp, #-16]! 
    stp x21, x30, [sp, #-16]!  

    mov x20, x2
    bl find_node
    
    mov x21, x0
    bl String_length
    add x0, x0, #1
    ldr x1,=dbByteUseage
    ldr x2,[x1]
    sub x2, x2, x0
    str x2,[x1]

    ldr x0,[x21]
    bl free

    str x20,[x21]
    mov x0, x20
    bl String_length
    add x0, x0, #1
    ldr x1,=dbByteUseage
    ldr x2,[x1]
    add x2, x2, x0
    str x2,[x1]


    edit_node_exit:
    ldp x21, x30,[sp], #16
    ldp x19, x20, [sp], #16
    ret lr

Read_file:
    str lr, [sp, #-16]! //Push


    ldr x3,=dbheadPtr
    str x0,[x3]
    ldr x3,=dbtailPtr
    str x1,[x3]
    ldr x3,=iFD
    strb w2,[x3]

    read_file_loop:
        ldr x0,=iFD     //Point x0 iFD
        ldrb w0, [x0]   //Derefrance
        ldr x1,=szBuffer    //Point x1 to the buffer
        mov x2, 0x0

        bl getline          //Branch and link to getline
        cmp x0, 0x0         //Compare to 0
        b.eq read_file_end  //Branch if equal to the end

        ldr x0,=szBuffer
        ldr x1,=szLF
        bl String_concat

        ldr x1,=dbNewNodePtr
        str x0,[x1]

        ldr x0,=dbtailPtr
        ldr x0,[x0]
        ldr x1,=dbheadPtr
        ldr x1,[x1]
        ldr x2,=dbNewNodePtr
        ldr x2,[x2]
        bl add_node_to_list

        ldr x2,=dbNumNodes
        str x0,[x2]
        ldr x2,=dbByteUseage
        str x1,[x2]

        b read_file_loop

    read_file_end:
    ldr x0,=dbtailPtr
    ldr x0,[x0]
    //Need to change last node to have '\n'

    ldr x0,=dbNumNodes
    ldr x0,[x0]
    ldr x1,=dbByteUseage
    ldr x1,[x1]

    ldr lr, [sp], #16   //Pop
    ret lr

getchar:
    str lr, [sp, #-16]! //Push
    mov x2, #1          //Move 1 into x2
    mov x8, #63         //Do a read
    svc 0               //Service call
    ldr lr, [sp], #16   //Pop
    ret lr              //Return

getline:
    str lr, [sp, #-16]! //Push

    getline_loop:
        bl getchar      //Branch and link to getchar

        cmp w0, 0x0     //Compare x0 to 0
        b.eq EOF        //Branch if equal

        ldrb w2,[x1]    //Load a byte
        cmp w2, 0xa     //Compare to 10
        b.eq EOLINE     //Branch if equal

        add x1, x1, #1  //Add 1

        ldr x0,=iFD     //Point x0 iFD
        ldrb w0, [x0]   //Derefrance
        b getline_loop  //Branch

EOLINE:
    mov w2, 0x0         //Initialize to 0
    strb w2, [x1]       //Store a byte into x1
    b skip              //Branch

EOF:
    mov w2, 0x0         //Initialize to 0
    strb w2, [x1]       //Store a byte into x1
    b skip              //Branch

ERROR:
    mov x19, x0     //Preserve x0
    ldr x0,=szERROR //Point x0 to szERROR
    bl putstring    //Branch and link to putstring
    mov x0, x19     //Re point x0
    b skip          //Branch

skip:
    ldr lr, [sp], #16   //Pop

    ret lr              //Return

Output_file:
    stp x19, lr, [sp, #-16]!

    mov x19, x0
    ldr x2,=oFD
    strb w1,[x2]

    //While head != NULL
    output_file_loop:
        ldr x19,[x19]
        cmp x19,0x0
        b.eq output_file_return

        ldr x0, [x19]
        bl String_length
        mov x2, x0

        ldr x0,=oFD
        ldrb w0,[x0]
        mov x8, #64
        ldr x1, [x19]

        str lr,[sp,#-16]!
        svc 0
        ldr lr,[sp],#16

        add x19, x19, #8
        b output_file_loop


    output_file_return:
    ldp x19, lr, [sp], #16
    ret lr


//x0 points to the head of the linked list
//x1 points to a null terminated string to search for
String_search:
    stp x19, x20, [sp, #-16]!
    stp x21, lr, [sp, #-16]!
    stp x22, x23,[sp, #-16]!

    ldr x2,=newNodePtr
    str x0,[x2]
    mov x19, x0
    mov x20, x1
    mov x21, 0x0

    string_search_loop1:
        ldr x19,[x19]
        cmp x19,0x0
        b.eq string_search_loop2

        ldr x0,[x19]
        bl String_toUpperCase
        mov x22, x0

        mov x0, x20
        bl String_toUpperCase
        mov x23, x0

        mov x0, x22
        mov x1, x23
        bl String_indexOf_3

        cmp x0, #-1
        b.eq string_search_incriment1

        add x21, x21, #1

        string_search_incriment1:
        mov x0, x22
        bl free
        mov x0, x23
        bl free

        add x19, x19, #8
        b string_search_loop1

    string_search_loop2:
    ldr x1,=szBuffer
    mov x0, x21
    bl int64asc

    ldr x0,=szStrSearch1
    bl putstring
    mov x0,x20
    bl putstring
    ldr x0,=szStrSearch2
    bl putstring
    ldr x0,=szBuffer
    bl putstring
    ldr x0,=szStrSearch3
    bl putstring

    mov x21, 0x0
    ldr x2,=newNodePtr
    ldr x19,[x2]

    string_search_loop:
        ldr x19,[x19]
        cmp x19,0x0
        b.eq string_search_return

        ldr x0,[x19]
        bl String_toUpperCase
        mov x22, x0

        mov x0, x20
        bl String_toUpperCase
        mov x23, x0

        mov x0, x22
        mov x1, x23
        bl String_indexOf_3

        cmp x0, #-1
        b.eq string_search_incriment

        ldr x0,=szLineNum
        bl putstring
        mov x0,x21
        ldr x1,=szBuffer
        bl int64asc
        ldr x0,=szBuffer
        bl putstring
        ldr x0,=chSP
        bl putch

        ldr x0,[x19]
        bl putstring

        string_search_incriment:
        mov x0, x22
        bl free
        mov x0, x23
        bl free

        add x19, x19, #8
        add x21, x21, #1
        b string_search_loop


    string_search_return:
    ldp x22, x23,[sp], #16
    ldp x21, lr, [sp], #16
    ldp x19, x20, [sp], #16

    ret lr

    .end
