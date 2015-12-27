/* As we link all SDK objects together, default irom0_0_seg (cached flash)
   region can easily overflow, so override its size. */
MEMORY
{
/*  dport0_0_seg :                        org = 0x3FF00000, len = 0x10
  dram0_0_seg :                         org = 0x3FFE8000, len = 0x14000
  iram1_0_seg :                         org = 0x40100000, len = 0x8000*/
  irom0_0_seg :                         org = 0x40240000, len = 0x7C000
}
