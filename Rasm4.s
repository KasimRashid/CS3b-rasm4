	.global _start

    .equ BUFFER, 128	//Buffer size
    .equ NODE_SIZE, 16	//Node size

    .equ R, 00          //Read
    .equ W, 0101        //Write
    .equ AT_FDCWD, -100 //Use file discriptor of local dir
    .equ RW_RW, 0644    //Read write perms

	.data

    szProgName:     .asciz "Name: Ilyas Zuhuruddin\n" //Name of programmer
    szClass:        .asciz "Class: CS 3B\n"           //Class
    szLab:          .asciz "Lab: Rasm 4\n"            //Lab number
    szDate:         .asciz "Date: 4/25/2024\n"        //Date

    szPrompt:       .asciz "Enter a string: "	//Prompt for a string
    szIndexPrompt:  .asciz "Enter an index: "	//Prompt for an index

    szLF:           .asciz "\n"					//Line feed string
    szFilePromp:    .asciz "Enter a file name: "//Prompt for a file name

    szMenuPrompt:   .asciz "Enter a menu option: "				//Prompt for a menu choice
    szOutOfBounds:  .asciz "Number needs to be between 1 - 7.\n"//Error message
    szclearPrompt:  .asciz "Press enter to continue "			//Prompt for enter
    szClearScreen:  .asciz "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"	//Clear screen lf

    szBuffer:       .skip 124	//Buffer

    headPtr:    .quad 0			//Head pointer
    tailPtr:    .quad 0			//Tail pointer
    newNodePtr: .quad 0			//New pointer
    dbIndex:    .quad 0			//Index
    dbBuffer:   .quad 0			//Quad buffer

    dbByteUseage:   .quad 0		//Byte usage
    dbNumNodes:     .quad 0		//Number of nodes

    iFD:    .byte 0     //Input file descriptor
    oFD:    .byte 0		//Output file descriptor
    chLF:   .byte 0xa   //Hex for line feed
	.text
_start:
    ldr x0,=szProgName  //Load x0 with the address of szProgName
    bl putstring        //Branch and link to putstring
    ldr x0,=szClass     //Load x0 with the address of szClass
    bl putstring        //Branch and link to putstring
    ldr x0,=szLab       //Load x0 with the address of szLab
    bl putstring        //Branch and link to putstring
    ldr x0,=szDate      //Load x0 with the address of szDate
    bl putstring        //Branch and link to putstring
    ldr x0,=chLF        //Load x0 with the address of chLF
    bl putch            //Branch and link to putch

    main_loop:	//Main loop

        bl Print_menu		//Display the menu

        ldr x0,=szBuffer	//Point x0 a variable
        ldr x1,=szMenuPrompt
        bl get_kbd_input
        ldr x0,=chLF        //Load x0 with the address of chLF
        bl putch            //Branch and link to putch

        ldr x1,=szBuffer
        ldrb w0, [x1]
        ldrb w2,[x1,#1]
        cmp x0, 0x37
        b.eq main_loop_end
        cmp x0, 0x31
        b.lt menu_choice_invalid
        cmp x0, 0x37
        b.gt menu_choice_invalid

        cmp x0, 0x31
        b.eq case_1
        cmp w2, 0x61
        b.eq case_2_a
        cmp w2, 0x62
        b.eq case_2_b
        cmp x0, 0x33
        b.eq case_3
        cmp x0, 0x34
        b.eq case_4
        cmp x0, 0x35
        b.eq case_5
        cmp x0, 0x36
        b.eq case_6

        main_loop_clear:
        ldr x0,=chLF        //Load x0 with the address of chLF
        bl putch            //Branch and link to putch
        ldr x0,=szclearPrompt//Point x0 a variable
        bl putstring
        
        ldr x0,=szBuffer	//Point x0 a variable
        mov x1,#1
        bl getstring

        ldr x0,=szClearScreen	//Point x0 a variable
        bl putstring

        ldr x0,=szBuffer	//Point x0 a variable
        mov x1,0x0
        str x1,[x0]

    b main_loop

    menu_choice_invalid:
    ldr x0,=szOutOfBounds	//Point x0 a variable
    bl putstring
    b main_loop_clear

    case_1:
        ldr x0,=headPtr	//Point x0 a variable
        bl traverse
        b main_loop_clear

    
    case_2:
        case_2_a:
            ldr x0,=szBuffer	//Point x0 a variable
            ldr x1,=szPrompt
            bl get_kbd_input
            ldr x0,=szBuffer	//Point x0 a variable
            ldr x1,=szLF
            bl String_concat
            ldr x1,=newNodePtr
            str x0,[x1]

            ldr x0,=tailPtr		//Point x0 a variable
            ldr x1,=headPtr
            ldr x2,=newNodePtr
            ldr x2,[x2]
            bl add_node_to_list
            b main_loop_clear

        case_2_b:
            ldr x0,=szBuffer	//Point x0 a variable
            ldr x1,=szFilePromp
            bl get_kbd_input

            mov x0,#AT_FDCWD    //File descriptor in current directory
            mov x8,#56          //Open file
            ldr x1,=szBuffer    //Name of the file
            mov x2,#R           //Create file if not exist, stdout
            mov x3,#RW_RW       //Read write perms
            svc 0               //Service call
            
            ldr x1,=iFD         //Point x1 to iFD
            strb w0,[x1]        //Store file discriptor

            ldr x0,=headPtr		//Point x0 a variable
            ldr x1,=tailPtr
            ldr x2,=iFD
            ldrb w2,[x2]
        
            bl Read_file
            b main_loop_clear

    case_3:
        ldr x0,=szBuffer		//Point x0 a variable
        ldr x1,=szIndexPrompt
        bl get_kbd_input

        ldr x0,=szBuffer		//Point x0 a variable
        bl ascint64
        ldr x1,=szBuffer
        str x0,[x1]

        ldr x0,=headPtr			//Point x0 a variable
        ldr x1,=szBuffer
        ldr x1,[x1]
        bl delete_single_node

        b main_loop_clear

    case_4:
        ldr x0,=szBuffer		//Point x0 a variable
        ldr x1,=szIndexPrompt
        bl get_kbd_input

        ldr x0,=szBuffer		//Point x0 a variable
        bl ascint64
        ldr x1,=
        str x0,[x1]

        ldr x0,=szBuffer		//Point x0 a variable
        ldr x1,=szPrompt
        bl get_kbd_input
        ldr x0,=szBuffer		//Point x0 a variable
        ldr x1,=szLF
        bl String_concat
        ldr x1,=newNodePtr
        str x0,[x1]
        
        ldr x0,=headPtr			//Point x0 a variable
        ldr x1,=
        ldr x1,[x1]
        ldr x2,=newNodePtr
        ldr x2,[x2]
        bl edit_node

        b main_loop_clear

    case_5:
        ldr x0,=szBuffer		//Point x0 a variable
        ldr x1,=szPrompt
        bl get_kbd_input

        ldr x0,=headPtr			//Point x0 a variable
        ldr x1,=szBuffer
        bl String_search

        b main_loop_clear

    case_6:
            ldr x0,=szBuffer		//Point x0 a variable
            ldr x1,=szFilePromp
            bl get_kbd_input

            mov x0,#AT_FDCWD    //File descriptor in current directory
            mov x8,#56          //Open file
            ldr x1,=szBuffer 	//Name of the file
            mov x2,#W           //Create file if not exist, stdout
            mov x3,#RW_RW       //Read write perms
            svc 0               //Service call
            
            ldr x1,=oFD         //Point x1 to oFD
            strb w0,[x1]        //Store file discriptor

            ldr x0,=headPtr		//Point x0 a variable
            ldr x1,=oFD         //Point x1 to oFD
            ldrb w1,[x1]        //Store file discriptor
            bl Output_file

        b main_loop_clear


    main_loop_end:

    ldr x0,=headPtr		//Point x0 a variable
    bl traverse_free

    ldr x0, =iFD        //Point x0 to iFD
    ldrb w0,[x0]        //Derefrance
    mov x8,#57          //Close file
    svc 0               //Service call

    ldr x0, =oFD        //Point x0 to iFD
    ldrb w0,[x0]        //Derefrance
    mov x8,#57          //Close file
    svc 0               //Service call

	// Setup the parameters to exit the program
	// and then call Linux to do it.
    mov X0, #0 // Use 0 return code
    mov X8, #93 // Service code 93 terminates
    svc 0 // Call Linux to terminate

    .end
