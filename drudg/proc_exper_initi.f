      subroutine proc_exper_initi(lufil,luscn)
      implicit none
      include 'hardware.ftni'
      integer lufil,luscn
      character*12 lname
      lname="exper_initi"

      call proc_write_define(luFil,luscn,lname)
      write(luFile,'(a)') "sched_initi"
      if(km5 .or. km5A_piggy) then
        write(lufile,'(a)')   "mk5=DTS_id?"
        write(lufile,'(a)')   "mk5=OS_rev1?"
        write(lufile,'(a)')   "mk5=OS_rev2?"
        write(lufile,'(a)')   "mk5=SS_rev1?"
        write(lufile,'(a)')   "mk5=SS_rev2?"
        write(lufile,'(a)')   "mk5=status?"
      endif
      write(lufile,'(a)') "enddef"

      return
      end
