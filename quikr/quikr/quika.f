      PROGRAM quika
C  quick response commands     <910330.0053>
C
C QUIKR is the root for all quick-response applications
C              functions in the Field System
C
C     INPUT VARIABLES:
C         IP(1) - class number containing invocation line
C         IP(2) - branch number, encoded
C
C     OUTPUT VARIABLES:
C         IP(1) - class number, if any
C         IP(2) - number of records in class
C         IP(3) - IERR error code return
C         IP(4) - who caused the error
C
C     COMMON BLOCKS USED
      include '../include/fscom.i'
C
C 3.  LOCAL VARIABLES
      integer*4 ip(5)                     !  rmpar variables
      integer idum,fc_rte_prior
C
C 6.  PROGRAMMERS: NRV (1980), LEF (1987), LAR (1988)
C  WHO  WHEN    DESCRIPTION
C  GAG  910116  Added calls to WEH's new tape head calibration routines.
C  GAG  910124  Removed callS to LOWHI and PARTN.
C  GAG  910205  Rejoined QUIK1 and QUIK2 into this one file.
C  gag  920715  Removed feet command and inserted form4 command.
C
C     PROGRAM STRUCTURE :
C  Get RMPAR parameters, then call the subroutine whose number is in IP(2).
C
      call setup_fscom
      call read_fscom
      idum=fc_rte_prior(FS_PRIOR)
1     continue
      call wait_prog('quika',ip)
      call read_quikr
      isub = ip(2)/100
      itask = ip(2) - 100*isub
      if (isub.eq.1) then
        if (itask.eq.1) then
          call fm(ip)
        else if (itask.eq.2) then
          call form4(ip)
        endif
      else if (isub.eq.2) then
        call vc(ip,itask)
      else if (isub.eq.3) then
        call ifd(ip)
      else if (isub.eq.4) then
        if (itask.eq.1.or.itask.eq.8) then
          call ma(ip,itask)
        else if (itask.eq.2) then
          call ib(ip)
        else if (itask.eq.3) then
          call cable(ip)
        else if (itask.eq.4) then
          call wx(ip)
        else if (itask.eq.5) then
          call wakop(ip)
        else if (itask.eq.6) then
          call chk(ip)
        else if (itask.eq.7) then
          call cal(ip)
        endif
      else if (isub.eq.5) then
        if (itask.eq.1) then
          call tp(ip)
        else if (itask.eq.2) then
          call tppos(ip)
        endif
      else if (isub.eq.6) then
        if (itask.eq.1) then
          call st(ip)
        else if (itask.eq.2) then
          call et(ip)
        else if (itask.ge.3.and.itask.le.6) then
          call rwff(ip,itask)
        endif
      endif

      call write_quikr

      goto 1

      end