	.global _start

    .equ BUFFER, 128	//Buffer size
    .equ NODE_SIZE, 16	//Node size

    .equ R, 00          //Read
    .equ W, 0101        //Write
    .equ AT_FDCWD, -100 //Use file discriptor of local dir
    .equ RW_RW, 0644    //Read write perms

	.data

    szProgName:     .asciz "Name: Ilyas Zuhuruddin && Kasim Rashid\n" //Name of programmer
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
        ldr x1,=szMenuPrompt//Point x1 a variable
        bl get_kbd_input	//Branch and link
        ldr x0,=chLF        //Load x0 with the address of chLF
        bl putch            //Branch and link to putch

        ldr x1,=szBuffer	//Point x1 a variable
        ldrb w0, [x1]		//Load a byte
        ldrb w2,[x1,#1]		//Load a byte
        cmp x0, 0x37		//Compare
        b.eq main_loop_end	//Branch
        cmp x0, 0x31		//Compare
        b.lt menu_choice_invalid	//Branch
        cmp x0, 0x37		//Compare
        b.gt menu_choice_invalid	//Branch

        cmp x0, 0x31		//Compare
        b.eq case_1			//Branch
        cmp w2, 0x61		//Compare
        b.eq case_2_a		//Branch
        cmp w2, 0x62		//Compare
        b.eq case_2_b		//Branch
        cmp x0, 0x33		//Compare
        b.eq case_3			//Branch
        cmp x0, 0x34		//Compare
        b.eq case_4			//Branch
        cmp x0, 0x35		//Compare
        b.eq case_5			//Branch
        cmp x0, 0x36		//Compare
        b.eq case_6			//Branch

        main_loop_clear:
        ldr x0,=chLF        //Load x0 with the address of chLF
        bl putch            //Branch and link to putch
        ldr x0,=szclearPrompt//Point x0 a variable
        bl putstring		//Branch and link
        
        ldr x0,=szBuffer	//Point x0 a variable
        mov x1,#1			//Move a value into a register
        bl getstring		//Branch and link

        ldr x0,=szClearScreen	//Point x0 a variable
        bl putstring			//Branch and link

        ldr x0,=szBuffer	//Point x0 a variable
        mov x1,0x0			//Move a value into a register
        str x1,[x0]			//Store a value in a register

    b main_loop				//Branch to main_loop

    menu_choice_invalid:
    ldr x0,=szOutOfBounds	//Point x0 a variable
    bl putstring			//Branch and link
    b main_loop_clear		//Unconditional jump

    case_1:
        ldr x0,=headPtr	//Point x0 a variable
        bl traverse		//Branch and link
        b main_loop_clear	//Unconditional jump

    
    case_2:
        case_2_a:
            ldr x0,=szBuffer	//Point x0 a variable
            ldr x1,=szPrompt	//Point x1 a variable
            bl get_kbd_input	//Branch and link
            ldr x0,=szBuffer	//Point x0 a variable
            ldr x1,=szLF		//Point x1 a variable
            bl String_concat	//Branch and link
            ldr x1,=newNodePtr	//Point x1 a variable
            str x0,[x1]			//Store a value in a register
	
            ldr x0,=tailPtr		//Point x0 a variable
            ldr x1,=headPtr		//Point x1 a variable
            ldr x2,=newNodePtr	//Point x2 to a variable
            ldr x2,[x2]			//Derefrance
            bl add_node_to_list	//Branch and link
            b main_loop_clear	//Unconditional jump

        case_2_b:
            ldr x0,=szBuffer	//Point x0 a variable
            ldr x1,=szFilePromp	//Point x1 a variable
            bl get_kbd_input	//Branch and link

            mov x0,#AT_FDCWD    //File descriptor in current directory
            mov x8,#56          //Open file
            ldr x1,=szBuffer    //Name of the file
            mov x2,#R           //Create file if not exist, stdout
            mov x3,#RW_RW       //Read write perms
            svc 0               //Service call
            
            ldr x1,=iFD         //Point x1 to iFD
            strb w0,[x1]        //Store file discriptor

            ldr x0,=headPtr		//Point x0 a variable
            ldr x1,=tailPtr		//Point x1 a variable
            ldr x2,=iFD
            ldrb w2,[x2]		//Load a byte
        
            bl Read_file		//Branch and link
            b main_loop_clear	//Unconditional jump

    case_3:
        ldr x0,=szBuffer		//Point x0 a variable
        ldr x1,=szIndexPrompt	//Point x1 a variable
        bl get_kbd_input		//Branch and link

        ldr x0,=szBuffer		//Point x0 a variable
        bl ascint64				//Branch and link
        ldr x1,=szBuffer		//Point x1 a variable
        str x0,[x1]				//Store a value in a register

        ldr x0,=headPtr			//Point x0 a variable
        ldr x1,=szBuffer		//Point x1 a variable
        ldr x1,[x1]				//Derefrance
        bl delete_single_node	//Branch and link

        b main_loop_clear		//Unconditional jump

    case_4:
        ldr x0,=szBuffer		//Point x0 a variable
        ldr x1,=szIndexPrompt	//Point x1 a variable
        bl get_kbd_input		//Branch and link

        ldr x0,=szBuffer		//Point x0 a variable
        bl ascint64				//Branch and link
        ldr x1,=dbBuffer		//Point x1 a variable
        str x0,[x1]				//Store a value in a register

        ldr x0,=szBuffer		//Point x0 a variable
        ldr x1,=szPrompt		//Point x1 a variable
        bl get_kbd_input		//Branch and link
        ldr x0,=szBuffer		//Point x0 a variable
        ldr x1,=szLF			//Point x1 a variable
        bl String_concat		//Branch and link
        ldr x1,=newNodePtr		//Point x1 a variable
        str x0,[x1]				//Store a value in a register
        
        ldr x0,=headPtr			//Point x0 a variable
        ldr x1,=dbBuffer		//Point x1 a variable
        ldr x1,[x1]				//Derefrance
        ldr x2,=newNodePtr		//Point x2 to a variable
        ldr x2,[x2]				//Derefrance
        bl edit_node			//Branch and link

        b main_loop_clear		//Unconditional jump

    case_5:
        ldr x0,=szBuffer		//Point x0 a variable
        ldr x1,=szPrompt		//Point x1 a variable
        bl get_kbd_input		//Branch and link

        ldr x0,=headPtr			//Point x0 a variable
        ldr x1,=szBuffer		//Point x1 a variable
        bl String_search		//Branch and link

        b main_loop_clear		//Unconditional jump

    case_6:
            ldr x0,=szBuffer		//Point x0 a variable
            ldr x1,=szFilePromp		//Point x1 a variable
            bl get_kbd_input		//Branch and link

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
            bl Output_file		//Branch and link

        b main_loop_clear		//Unconditional jump


    main_loop_end:

    ldr x0,=headPtr		//Point x0 a variable
    bl traverse_free	//Branch and link

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
