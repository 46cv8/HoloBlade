import sys
import traceback

import myhdl
from myhdl import *

class Error(Exception):
    pass

# Constants
NUMBER_OF_WORDS_IN_SINGLE_LINE = 40

t_state = enum(
    'INITING',
    'RESET_PULSE',
    'NEW_FRAME_PULSE',
    'IDLE'
    )

    

# Block to control timing of display updates, controls reset, frame-rate, next-line_of_data_available-rdy, next-frame-rdy
@block
def timing_controller(
    
    # Control
    fpga_clk,
    reset_all,
    
    # DC32-FIFO
    num_words_in_buffer,
    
    # Bluejay Data Interface
    line_of_data_available,
    next_frame_rdy

    ):
    
    """ 
    Ports
    I/O pins:
    --------
    Control:
    fpga_clk                 : clock to drive this module
    reset_all                : Output reset line for all other modules
    DC32-FIFO Side:
    num_words_in_buffer      : How many words of data are in the DC32-FIFO, used to determine whether or not there is an entire line of data available
    Bluejay Data Interface:
    line_of_data_available   : Flag to indicate to the bluejay FSM that there is at least a line of data available in the FIFO currently (ie: more than 40 words)
    next_frame_rdy           : This line drives frame updates in current bluejay FSM implementation
    """

    # If there are sufficient words available in the DC-FIFO, then flag this
    @always_comb
    def check_line_available():
        if(num_words_in_buffer>=NUMBER_OF_WORDS_IN_SINGLE_LINE):
            line_of_data_available.next = True
        else:
            line_of_data_available.next = False


    # State Machine to manage generation of the next_line_ready once data is available
    # TODO: Extend this later to support frame ready updates and external sync
    # Regularly re-pulse once every second
    repulse_period = 62500000 # Once a second, therefore just use our period (not not precisely 1Hz but close enough)
    # Wait 5 cycles at startup before resetting
    reset_wait_period = 5 
    # Signals for FSM
    state                 = Signal(t_state.INITING)
    state_timeout_counter = Signal(intbv(0)[32:]) 
    @always(fpga_clk.posedge)
    def run_timing():

        # Off by default
        reset_all.next = False
        next_frame_rdy.next = False   

        # Which state are we in?
        if state == t_state.INITING:
            # Automatic state to manage transitions and startup
            state.next = t_state.RESET_PULSE
            state_timeout_counter.next = reset_wait_period


        elif state == t_state.RESET_PULSE:
            # Pulse reset high for a few cycles - Assert reset for all modules
            reset_all.next = True
            # End of Blank period for end of line?
            state_timeout_counter.next = state_timeout_counter - 1
            if state_timeout_counter < reset_wait_period:
                # Move into pulse
                state.next = t_state.NEW_FRAME_PULSE

        
        elif state == t_state.NEW_FRAME_PULSE:
            # Pulse new_frame high for a single-cycle - automatic transition
            next_frame_rdy.next = True
            # Wait in IDLE for repulsing
            state_timeout_counter.next = repulse_period
            state.next = t_state.IDLE

        elif state == t_state.IDLE:
            state_timeout_counter.next = state_timeout_counter - 1
            # Ready for repulse?
            if state_timeout_counter == 1:
                # Move into pulse
                state_timeout_counter.next = reset_wait_period
                state.next = t_state.INITING



    return check_line_available, run_timing



# Generated Verilog
def timing_controller_gen_verilog():

    # Signals for Bluejay Data Module
    # Control
    fpga_clk               = Signal(False)
    reset_all              = Signal(False)
    # DC32 FIFO
    num_words_in_buffer    = Signal(intbv(0)[7:]) # FIFO Depth is 64
    # Bluejay Display
    line_of_data_available = Signal(False)
    next_frame_rdy         = Signal(False)
    
    # Control Logic between SLM and simulated USB-FIFO
    timing_controller_inst = timing_controller(
        # Control
        fpga_clk,
        reset_all,
        # DC32 FIFO
        num_words_in_buffer,
        # Bluejay Display
        line_of_data_available,
        next_frame_rdy
    )

    # Convert
    timing_controller_inst.convert(hdl='Verilog')


def main():

    timing_controller_gen_verilog()


if __name__ == '__main__':
    main()