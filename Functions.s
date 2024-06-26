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
    .equ BUFFER, 128

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

    dbNewNodePtr:   .quad 0	// new ptr node
    dbtailPtr:      .quad 0	// tail ptr
    dbheadPtr:      .quad 0	// head ptr

    dbByteUseage:   .quad 0	// all the used bytes
    dbNumNodes:     .quad 0	// number of nodes

    iFD:    .byte 0     //Store the file descriptor
    oFD:    .byte 0	// output file discriptor 
    chLF:   .byte 0xa	// line feed 
    chSP:   .byte 0x20	// space

    newNodePtr: .quad 0	// NEW ptr node

    .text		// text

Print_menu:		// the menu 
    str lr,[sp, #-16]!	// line register data

    ldr x0,=szdash	// load x0 -> szdash
    bl putstring	// branch to putstring

    ldr x0,=szMenu1	// load x0 -> szMenu1
    bl putstring	// branch putstring

    ldr x0,=szMenu2	// load x0 -> szMenus2
    bl putstring	// branch putstring
    ldr x0,=dbByteUseage	// load x0 -> dbByteUseage
    ldr x0,[x0]		// load x0 -> x0
    ldr x1,=szBuffer	// load x1 -> szBuffer
    bl int64asc		// branch int64asc
    ldr x0,=szBuffer	// load x0 -> szBuffer
    bl putstring	// branch putstring
    ldr x0,=szMenu3	// load x0 -> szMenu3
    bl putstring	// branch putstring

    ldr x0,=szMenu4	// load x0 -> szMenu4
    bl putstring	// branch putstring
    ldr x0,=dbNumNodes	// load x0 -> dbNumNodes
    ldr x0,[x0]		// load x0 -> x0
    ldr x1,=szBuffer	// load x1 -> szBuffer
    bl int64asc		// branch int64asc
    ldr x0,=szBuffer	// load x0 -> szBuffer
    bl putstring	// branch putstring
    ldr x0,=chLF	// load x0 -> chLF
    bl putch		// branch putch

    ldr x0,=szMenu5	// load x0 -> szMenu5
    bl putstring	// branch putstring
    ldr x0,=szMenu6	// load x0 wit h szMenu6
    bl putstring	// branch putstring
    ldr x0,=szMenu7	// laod x0 -> szMenu7
    bl putstring	// branch putstring
    ldr x0,=szMenu8	// load x0 -> szMunu8
    bl putstring	// branch putstring
    ldr x0,=szMenu9	// laod x0 azMenu9
    bl putstring	// branch putstring
    
    ldr x0,=szdash	// load x0 -> szdash
    bl putstring	// branch putstring
    
    Print_menu_exit:	// print menu exit loop
    ldr lr,[sp], #16	// load lr 
    ret lr		// return 

    

traverse:		// treverse loop
    stp x19, x30, [sp, #-16]!	// push
    str x20, [sp, #-16]!	// push
    mov x19,x0		// move x19 <- x0
    mov x20, 0x0	// make x20 = null

    traverse_top:	//top of traverse top 
        ldr x19,[x19]	// load x19 -> x19
        cmp x19,0x0	// compare x19 to null
        b.eq traverse_exit	// if equal branch

        ldr x0,=szBopen		// load x0 szBopen
        bl putstring		// branch putstring
        mov x0,x20		// move x0 - x20
        ldr x1,=szBuffer	// load x1 -> szBuffer
        bl int64asc		// branch int64asc
        ldr x0,=szBuffer	// load x0 -> szBuffer
        bl putstring		// branmch to puitstring 
        ldr x0,=szBclose	// laod x0 -> zsBclose
        bl putstring		// branch -> putstring

        ldr x0,[x19]		// laod x0 -> x19
        bl putstring		// branch 0- putstring

        add x20, x20, #1	// ++x20
        add x19, x19, #8	// x19 +8
        b traverse_top		// branch to top of loop

    traverse_exit:		// exit traverse exit
    ldr x20, [sp], #16		// pop
    ldp x19, x30, [sp], #16	// pop
    ret lr			// return 

traverse_free:			// branch free
    stp x19, x30, [sp, #-16]!	// push
    str x20,[sp, #-16]!		// push 

    mov x19,x0			// move x19 - x0
    ldr x19,[x19]		// load x19 -> x19
    
    traverse_free_top:		// loop
        cmp x19,0x0		// compare x19 to null
        b.eq traverse_free_exit	// brancgh of equal

        add x20, x19, #8	// x20 = x19 +8
        ldr x20, [x20]		// derefrance x20

        add x20, x19, #8	// x20 = x19 +8
        ldr x20, [x20]		// derefrance 
        ldr x0,[x19]		// load x0 - x19
        bl free			// branch top free 

        mov x0,x19		// move x0 - x19
        bl free			// branch to free 

        mov x19, x20		// move x19 - x20
        b traverse_free_top	// branch to top

    traverse_free_exit:		// branch exit
    mov x0,0x0			// move x0 <-null
    mov x1,0x0			// move x1 -< null

    ldr x20,[sp], #16		// pop
    ldp x19, x30, [sp], #16	// pop
    ret lr			// return 

add_node_to_list:		// node add to list jump
    stp x19, x20, [sp, #-16]!	// push
    stp x21, x30,[sp, #-16]!	// push
    mov x19, x0     //x19 = tail
    mov x20, x1     //x20 = head
    mov x21, x2     //x21 = string

    mov x0, x2			//move x0 
    bl String_length		// branch to string length
    add x0, x0, #17		// x0 + 17
    
    ldr x1,=dbByteUseage	// load x1 dbByteUseage
    ldr x2,[x1]			// load x2 -x1
    add x2, x0, x2		// x2 =+x0
    str x2,[x1]			// store x2 - x1

    ldr x0,=dbNumNodes		// load x0 dbNumNodes
    ldr x1,[x0]			// load x1 - x0
    add x1, x1, #1		// ++x1
    str x1,[x0]			// store x1 with x0

    mov x0,NODE_SIZE		// move x0 - NODE_SIZE
    bl malloc			// branch malloc

    ldr x1,[x20]    //Go to the head and store in x1
    cmp x1, 0x0     //Compare the head to null
    b.eq add_node_to_empty_list //If null add to the empty list

    str x21,[x0]        //Else store the string in the new node
    ldr x2,[x19]        //Derefrance the tail
    add x2, x2, #8      //Add 8 to get to the pointer
    str x0,[x2]         //Store the addr of the new node in the tail
    str x0,[x19]	// store 
    b add_node_to_list_exit	// branch to end

    add_node_to_empty_list:	// branch if enmpty 
    str x21,[x0]		// store x21 - x0
    str x0,[x19]		// store
    str x0,[x20]		/// store

    add_node_to_list_exit:	// exit of add node to list 
    
    ldr x0,=dbNumNodes		// load x0 -> dbNumNodes
    ldr x0,[x0]			// load x0 - x0
    ldr x1,=dbByteUseage	// load x1 -> dbByteUsage
    ldr x1,[x1]			// load x1 -> x1

    ldp x21, x30,[sp], #16	// pp
    ldp x19, x20, [sp], #16	// pp
    ret lr			// return 

get_kbd_input:			// branch to KBD inputs 
    stp x21, x30,[sp, #-16]!	// push
    
    mov x21, x0			// move x21 - x0
    mov x0,x1			// move x0 - x1
    bl putstring		// branch putstring

    mov x0, x21			// move x0 - x21
    mov x1, BUFFER		// move x1 - > BUFFER
    bl getstring		// branch to getstring

    get_kbd_input_return:	// jump back
    ldp x21, x30,[sp], #16	// poop
    ret lr			// return 

delete_single_node:		// delete singal node
    stp x19, x20, [sp, #-16]!	// posh 
    stp x21, x30,[sp, #-16]!	// poshj 

    mov x19,x0  //x19 = head	// move x19 - x0 

    ldr x2,[x19]		// load x2 - x19

    cmp x2, 0x0			// compare x2 - null 
    b.eq delete_single_node_exit    //Check for 0 nodes
    
    add x2, x2, #8		// x2 += 8
    ldr x2,[x2]			// load x2 - x2 
    cmp x2, 0x0			// compare x2 to null
    b.eq delete_single_node_single  //Check for 1 node

    cmp x1, 0x0			/// compare x1 to null
    b.eq delete_single_node_first	// beaNCH IF EQUAL 

    bl find_node	 	// branch find_Node
    mov x20, x0			// move x20, x0 

    ldr x0,=dbNumNodes		// load x0 -> dbNumNodes
    ldr x1,[x0]			// load x1 - x0
    sub x1, x1, #1		// --x1
    str x1,[x0]			// store x1 - xo

    ldr x0,[x20]		// load x0 - x20
    bl String_length		// branch to string length

    add x0, x0, #1		// ++x0 
    ldr x1,=dbByteUseage	// load x1 -> dbByteUseage
    ldr x2,[x1]			// load x2  x1
    sub x2, x2, x0		// x2-= x0
    str x2,[x1]			// store x2 - x1

    mov x0, x20			// move x0 - x20 
    ldr x3, [x19]		// load x3 - x19 
    ldr x3, [x3, #8]		// laod x3, x3 +8
    ldr x19, [x19]		// deregrence 
    delete_single_node_loop1:	// hjump to delete 
        cmp x3, x0		// compere x3 x0  
        b.eq delete_single_node_loop1_end	// breanch of = to end
        add x3, x3, #8		// x3+=8
        ldr x3, [x3]		// load x3 - x3

        add x19, x19, #8	// x19+= x19+8
        ldr x19,[x19]		// derefrance x19 

        b delete_single_node_loop1	// branch to delete node 

    delete_single_node_loop1_end:   //x19 = prev node, x0 = node
    mov x20, x0			// move x10 x0 
    add x20, x20, #8		// x20 +=8
    ldr x20, [x20]      //x20 = next node

    add x19, x19, #8	// x19 +=8
    str x20, [x19]	// store x20 - x19

    mov x21, x0		// move x21 wit x0
    ldr x0,[x0]		// laod x0 - x0
    bl free		// branch to free

    mov x0,x21		// move x0 to x21
    bl free		// branch to free

    b delete_single_node_compleate	// branch to delete

    delete_single_node_first:
    mov x20, x19		//Move a value into x20

    ldr x20,[x20]       //x20 = node to be deleted
    ldr x21,[x20, #8]   //x21 = next node

    str x21, [x19]	//Store a value into a register

    mov x21, x20	//Move a value into a register

    ldr x0,=dbNumNodes	//Point x0 to a variable
    ldr x1,[x0]			//Derefrance
    sub x1, x1, #1		//Sub
    str x1,[x0]			//Store a value into a register

    ldr x0,[x20]		//Derefrance
    bl String_length	//Branch with link

    add x0, x0, #17			//Add
    ldr x1,=dbByteUseage	//Point x1 to a variable
    ldr x2,[x1]				//Derefrance
    sub x2, x2, x0			//Sub
    str x2,[x1]				//Store a value into a register
    ldr x0,[x21]			//Derefrance
    bl free					//Branch with link

    mov x0,x21		//Move a value into a register
    bl free			//Branch and link

    b delete_single_node_compleate

    delete_single_node_single:
    ldr x21, [x19] 	//Load a value into a register
    ldr x0, [x21]	//Load a value into a register
    bl free

    mov x0,x21		//Move a value into a register
    bl free

    mov x1,0x0		//Move a value into a register
    str x1,[x19]	//Store a value into a register	

    delete_single_node_compleate:

    delete_single_node_exit:

    ldr x0,=dbNumNodes	//Point x0 to a variable
    ldr x0,[x0]	//Load a value into a register
    ldr x1,=dbByteUseage//Point x1 to a variable
    ldr x1,[x1]	//Load a value into a register
    
    ldp x21, x30,[sp], #16	//Pop
    ldp x19, x20, [sp], #16	//Pop
    ret lr

//x0 points to the head of the linked list
//x1 contains the binary signed index
find_node:
    stp x19, x20, [sp, #-16]!	//Push
    stp x21, x30,[sp, #-16]!	//Push

    mov x19,x0		//Move a value into a register
    mov x2, 0x0		//Move a value into a register

    find_node_loop:
        ldr x19,[x19]	//Load a value into a register
        cmp x19,0x0		//Compare 
        b.eq find_node_out_of_bounds	//Branch
        
        cmp x2, x1			//Compare 
        b.eq find_node_done //Branch

        add x2, x2, #1		//Add
        add x19, x19, #8	//Add
        b find_node_loop	//Branch

    find_node_out_of_bounds:
    mov x0,0x0			//Move a value into a register
    b find_node_exit	//Branch

    find_node_done:
    mov x0, x19		//Move a value into a register

    find_node_exit:
    ldp x21, x30,[sp], #16	//Pop
    ldp x19, x20, [sp], #16	//Pop
    ret lr	//Return

edit_node:
    stp x19, x20, [sp, #-16]! 	//Push
    stp x21, x30, [sp, #-16]!  	//Push

    mov x20, x2		//Move a value into a register
    bl find_node	//Branch and link
    
    mov x21, x0			//Move a value into a register
    bl String_length	//Branch and link
    add x0, x0, #1		//Add
    ldr x1,=dbByteUseage//Load a value into a register
    ldr x2,[x1]			//Load a value into a register
    sub x2, x2, x0		//Subtract
    str x2,[x1]			//Store a value in a register

    ldr x0,[x21]		//Load a value into a register
    bl free				//Branch and link

    str x20,[x21]		//Store a value in a register
    mov x0, x20			//Move a value into a register
    bl String_length		//Branch and link
    add x0, x0, #1		//Add
    ldr x1,=dbByteUseage//Load a value into a register
    ldr x2,[x1]			//Load a value into a register
    add x2, x2, x0		//Add
    str x2,[x1]			//Store a value in a register


    edit_node_exit:
    ldp x21, x30,[sp], #16	//Pop
    ldp x19, x20, [sp], #16	//Pop
    ret lr	//Return

Read_file:
    str lr, [sp, #-16]! //Push


    ldr x3,=dbheadPtr	//Load a value into a register
    str x0,[x3]			//Store a value in a register
    ldr x3,=dbtailPtr	//Load a value into a register
    str x1,[x3]			//Store a value in a register
    ldr x3,=iFD			//Load a value into a register
    strb w2,[x3]		//Store a byte

    read_file_loop:
        ldr x0,=iFD     //Point x0 iFD
        ldrb w0, [x0]   //Derefrance
        ldr x1,=szBuffer //Point x1 to the buffer
        mov x2, 0x0		//Move a value into a register

        bl getline          //Branch and link to getline
        cmp x0, 0x0         //Compare to 0
        b.eq read_file_end  //Branch if equal to the end

        ldr x0,=szBuffer	//Load a value into a register
        ldr x1,=szLF		//Load a value into a register
        bl String_concat

        ldr x1,=dbNewNodePtr//Load a value into a register
        str x0,[x1]			//Store a value in a register

        ldr x0,=dbtailPtr	//Load a value into a register
        ldr x0,[x0]			//Load a value into a register
        ldr x1,=dbheadPtr	//Load a value into a register
        ldr x1,[x1]			//Load a value into a register
        ldr x2,=dbNewNodePtr//Load a value into a register
        ldr x2,[x2]			//Load a value into a register
        bl add_node_to_list//Branch and link

        ldr x2,=dbNumNodes	//Load a value into a register
        str x0,[x2]			//Store a value in a register
        ldr x2,=dbByteUseage//Load a value into a register
        str x1,[x2]			//Store a value in a register

        b read_file_loop	//Branch

    read_file_end:
    ldr x0,=dbtailPtr		//Load a value into a register
    ldr x0,[x0]				//Load a value into a register
    //Need to change last node to have '\n'

    ldr x0,=dbNumNodes		//Load a value into a register
    ldr x0,[x0]				//Load a value into a register
    ldr x1,=dbByteUseage	//Load a value into a register
    ldr x1,[x1]				//Load a value into a register

    ldr lr, [sp], #16   //Pop
    ret lr	//Return

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
    stp x19, lr, [sp, #-16]!	//Push

    mov x19, x0		//Move a value into a register
    ldr x2,=oFD		//Load a value into a register
    strb w1,[x2]	//Store a byte

    //While head != NULL
    output_file_loop:
        ldr x19,[x19]	//Load a value into a register
        cmp x19,0x0		//Compare 
        b.eq output_file_return	//Branch

        ldr x0, [x19]	//Load a value into a register
        bl String_length//Branch and link
        mov x2, x0		//Move a value into a register

        ldr x0,=oFD		//Load a value into a register
        ldrb w0,[x0]
        mov x8, #64		//Move a value into a register
        ldr x1, [x19]	//Load a value into a register

        str lr,[sp,#-16]!	//Push
        svc 0				//Service call
        ldr lr,[sp],#16		//Pop

        add x19, x19, #8	//Add
        b output_file_loop	//Branch


    output_file_return:
    ldp x19, lr, [sp], #16	//Pop
    ret lr	//Return


//x0 points to the head of the linked list
//x1 points to a null terminated string to search for
String_search:
    stp x19, x20, [sp, #-16]!	//Push
    stp x21, lr, [sp, #-16]!	//Push
    stp x22, x23,[sp, #-16]!	//Push

    ldr x2,=newNodePtr	//Load a value into a register
    str x0,[x2]			//Store a value in a register
    mov x19, x0		//Move a value into a register
    mov x20, x1		//Move a value into a register
    mov x21, 0x0	//Move a value into a register

    string_search_loop1:
        ldr x19,[x19]	//Load a value into a register
        cmp x19,0x0		//Compare 
        b.eq string_search_loop2	//Branch

        ldr x0,[x19]	//Load a value into a register
        bl String_toUpperCase	//Branch and link
        mov x22, x0		//Move a value into a register

        mov x0, x20		//Move a value into a register
        bl String_toUpperCase	//Branch and link
        mov x23, x0		//Move a value into a register

        mov x0, x22		//Move a value into a register
        mov x1, x23		//Move a value into a register
        bl String_indexOf_3	//Branch and link

        cmp x0, #-1		//Compare 
        b.eq string_search_incriment1	//Branch

        add x21, x21, #1	//Add

        string_search_incriment1:
        mov x0, x22		//Move a value into a register
        bl free			//Branch and link
        mov x0, x23		//Move a value into a register
        bl free			//Branch and link

        add x19, x19, #8	//Add
        b string_search_loop1	//Branch

    string_search_loop2:
    ldr x1,=szBuffer//Load a value into a register
    mov x0, x21		//Move a value into a register
    bl int64asc		//Branch and link

    ldr x0,=szStrSearch1	//Load a value into a register
    bl putstring			//Branch and link
    mov x0,x20				//Move a value into a register
    bl putstring			//Branch and link
    ldr x0,=szStrSearch2	//Load a value into a register
    bl putstring			//Branch and link
    ldr x0,=szBuffer		//Load a value into a register
    bl putstring			//Branch and link
    ldr x0,=szStrSearch3	//Load a value into a register
    bl putstring			//Branch and link

    mov x21, 0x0	//Move a value into a register
    ldr x2,=newNodePtr	//Load a value into a register
    ldr x19,[x2]		//Load a value into a register

    string_search_loop:
        ldr x19,[x19]	//Load a value into a register
        cmp x19,0x0		//Compare 
        b.eq string_search_return	//Branch

        ldr x0,[x19]	//Load a value into a register
        bl String_toUpperCase	//Branch and link
        mov x22, x0		//Move a value into a register

        mov x0, x20		//Move a value into a register
        bl String_toUpperCase	//Branch and link
        mov x23, x0		//Move a value into a register

        mov x0, x22		//Move a value into a register
        mov x1, x23		//Move a value into a register
        bl String_indexOf_3	//Branch and link

        cmp x0, #-1		//Compare 
        b.eq string_search_incriment	//Branch

        ldr x0,=szLineNum	//Load a value into a register
        bl putstring		//Branch and link
        mov x0,x21			//Move a value into a register
        ldr x1,=szBuffer	//Load a value into a register
        bl int64asc			//Branch and link
        ldr x0,=szBuffer	//Load a value into a register
        bl putstring		//Branch and link
        ldr x0,=chSP		//Load a value into a register
        bl putch			//Branch and link

        ldr x0,[x19]		//Load a value into a register
        bl putstring		//Branch and link

        string_search_incriment:
        mov x0, x22		//Move a value into a register
        bl free			//Branch and link
        mov x0, x23		//Move a value into a register
        bl free			//Branch and link
	
        add x19, x19, #8	//Add
        add x21, x21, #1	//Add
        b string_search_loop//Branch


    string_search_return:
    ldp x22, x23,[sp], #16	//Pop
    ldp x21, lr, [sp], #16	//Pop
    ldp x19, x20, [sp], #16	//Pop

    ret lr	//Return

    .end
