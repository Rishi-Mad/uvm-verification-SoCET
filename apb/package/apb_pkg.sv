

package apb_pkg;

    typedef enum logic [1:0] {
        APB_ILLEGAL = 2'b00,
        APB_WO = 2'b01,
        APB_RO = 2'b10,
        APB_RW = 2'b11
    } APBAccessControl;
    
    typedef enum logic [1:0] {
        IDLE,
        ACCESS,
        ERROR
    } APBState;

endpackage
