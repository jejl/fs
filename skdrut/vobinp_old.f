      SUBROUTINE VOBINP(ivexnum,LU,IERR)

C  This routine gets all the observations from the vex file.
C
C History
C 000606 nrv Re-new. Copied from VOB1INP.

      include '../skdrincl/skparm.ftni'
      include '../skdrincl/freqs.ftni'
      include '../skdrincl/statn.ftni'
      include '../skdrincl/skobs.ftni'
C
C  INPUT:
      integer ivexnum,lu
C
C  OUTPUT:
      integer ierr ! error from this routine

C  CALLED BY: VREAD
C  CALLS:  fget_scan_station         (get station lines)
C          fvex_scan_source          (get sources in a scan)
c          newscan                   (form new scan)
C          addscan                   (add a station to a scan)
C          findscan                  (find a matching scan)
C
C  LOCAL:
      integer isor,icod,il,ip,ifeet,i,idrive
      integer idum,irec,ipnt
      integer*2 itim1(6),itim2(6)
      integer*2 lcb
      character*128 cmo,cstart,csor,cout,cunit
      integer ic1,ic2,ic11,ic12,ich,istart(5)
      double precision d,start_sec
      integer idstart,idend
      logical knew,kearl,ks2
      integer ichmv,ichmv_ch,ivgtso,ivgtmo
      integer ichcm_ch,fget_scan_station,fvex_scan_source,fvex_date,
     .fvex_field,fvex_int,fvex_double,fvex_units,ptr_ch,fvex_len

C 1. Get scans for all stations. 

        write(lu,9100) 
9100    format('VOBINP - Generating observations')
        iret = fget_scan_station(ptr_ch(cstart),len(cstart),
     .         ptr_ch(cmo),len(cmo),
     .         ptr_ch(''//char(0)),ivexnum)
C    .         ptr_ch(stndefnames(istn)),ivexnum)
        nobs_stn=0
        ierr = 1 ! station
        ks2=ichcm_ch(lstrec(1,istn),1,'S2').eq.0
        do while (iret.eq.0) ! get all scans for this station
          nobs=nobs+1
          iret = fvex_date(ptr_ch(cstart),istart,start_sec)
          ierr=2 ! date/time
          if (iret.ne.0) return
          istart(5) = start_sec ! convert to integer
          ierr = 3 ! first source name
          iret = fvex_scan_source(1,ptr_ch(csor),len(csor))
          if (iret.ne.0) return
          ierr = 4 ! source index
          if (ivgtso(csor,isor).le.0) then
            il=fvex_len(csor)
            write(lu,'("VOBINP01 - Source ",a," not found")') csor(1:il)
          endif
          ierr = 5 ! code index
            il=fvex_len(cmo)
          if (ivgtmo(cmo,icod).le.0) then
            write(lu,'("VOBINP02 - Mode ",a," not found")') cmo(1:il)
          endif
          if (nchan(istn,icod).eq.0) then ! code not defined
            write(lu,'("VOBINP03 - Mode ",a," not defined for this ",
     .      "station!!")') cmo(1:il)
            return
          endif
          ierr = 6 ! data start
          iret = fvex_field(2,ptr_ch(cout),len(cout))
          if (iret.ne.0) return
          iret = fvex_units(ptr_ch(cunit),len(cunit))
          iret = fvex_double(ptr_ch(cout),ptr_ch(cunit),d)
          if (iret.ne.0) return
          idstart = d
          ierr = 7 ! data end
          iret = fvex_field(3,ptr_ch(cout),len(cout))
          if (iret.ne.0) return
          iret = fvex_units(ptr_ch(cunit),len(cunit))
          iret = fvex_double(ptr_ch(cout),ptr_ch(cunit),d)
          if (iret.ne.0) return
          idend = d
C         Keep good data offset and duration separate
C         idur = det-dst
          ierr = 8 ! footage
          iret = fvex_field(4,ptr_ch(cout),len(cout))
          if (iret.ne.0) return
          iret = fvex_units(ptr_ch(cunit),len(cunit))
          iret = fvex_double(ptr_ch(cout),ptr_ch(cunit),d)
          if (ks2) then 
            ifeet = d ! leave as seconds
          else 
            ifeet = d*100.d0/(2.54*12.d0) ! convert mks to feet
          endif
          ierr = 9 ! pass
          iret = fvex_field(5,ptr_ch(cout),len(cout))
          if (iret.ne.0) return
          il = fvex_len(cout)
          ip=1
          do while (ip.le.npassl(istn,icod).and.cout(1:il).ne.
     .              cpassorderl(ip,istn,icod)(1:il))
            ip=ip+1
          enddo
          if (ip.gt.npassl(istn,icod)) return ! pass not found
          ierr = 10 ! pointing sector
          iret = fvex_field(6,ptr_ch(cout),len(cout))
          if (iret.ne.0) return
          il = fvex_len(cout)
          if (il.eq.0) then ! null wrap
            idum=ichmv_ch(lcb,1,'- ')
          else ! check it
            if (cout(1:il).eq.'&n') idum=ichmv_ch(lcb,1,'- ')
            if (cout(1:il).eq.'&cw') idum=ichmv_ch(lcb,1,'C ')
            if (cout(1:il).eq.'&ccw') idum=ichmv_ch(lcb,1,'W ')
          endif
          ierr = 11 ! drive number
          iret = fvex_field(7,ptr_ch(cout),len(cout))
          if (iret.ne.0) return
          iret = fvex_int(ptr_ch(cout),i) ! convert to binary
          if (i.lt.0.or.iret.ne.0) return
          idrive=i

C 3. Try to find a matching time, source
C    and mode. If there is one, add this station to the observation.
C    If there is not one, make a new observation.
     
            call findscan(isor,icod,istart,irec)
            if (irec.ne.0) then ! add this station
              call addscan(irec,istn,icod,idstart,idend,
     .        ifeet,ip,idrive,lcb,ierr)
              knew=.false.
              if (ierr.ne.0) then
                write(lu,9103) ierr,irec,istn,istart
9103            format('addscan error ',i3,' irec=',i3,' istn=',i3,
     .          'istart=',5i5)
              endif
            else ! new scan
              call newscan(istn,isor,icod,istart,idstart,
     .        idend,ifeet,ip,idrive,lcb,ierr)
              knew=.true.
              if (ierr.ne.0) write (lu,9108) ierr
9108          format('vob1inpxx - Error ',i5,' from newscan')
            endif

C  4. This next section orders the index array, iskrec, in time order.
C     If we just got a new observation, and it's not in time order,
C     bubble it up until it is.
C
C     if (nobs.ge.2.and.knew) then ! check time order
C       irec=nobs
C       Find the time field by skipping over 4 fields
C       ich=1
C       do i=1,5 ! want the 5th field 
C         CALL GTFLD(lskobs(1,iskrec(irec)),ICH,IBUF_LEN*2,IC11,IC2)
C       enddo
C       ich=1
C       do i=1,5 ! want the 5th field 
C         CALL GTFLD(lskobs(1,iskrec(irec-1)),ICH,IBUF_LEN*2,IC12,IC2)
C       enddo
C       idum= ichmv(itim1,1,lskobs(1,iskrec(irec)),ic11,11)
C       idum= ichmv(itim2,1,lskobs(1,iskrec(irec-1)),ic12,11)
C       do while (kearl(itim1,itim2).and.irec.gt.1)  !out of order
C         Swap pointers
C         ipnt = iskrec(irec-1)
C         iskrec(irec-1) = iskrec(irec)
C         iskrec(irec) = ipnt
C         Get new time fields 
C         Get time field of the now-correct last record.
C         irec = irec-1
C         idum= ichmv(itim1,1,lskobs(1,iskrec(irec)),ic12,11)
C         ich=1
C         do i=1,5 ! want the 5th field 
C           CALL GTFLD(lskobs(1,iskrec(irec)),ICH,IBUF_LEN*2,IC12,IC2)
C         enddo
C         idum= ichmv(itim2,1,lskobs(1,iskrec(irec-1)),ic12,11)
C       end do  !out of order
C     endif

C 5. Get the next station record.

          iret = fget_scan_station(ptr_ch(cstart),len(cstart),
     .           ptr_ch(cmo),len(cmo),
     .           ptr_ch(stndefnames(istn)),0)
        enddo ! get all obs for this station
      if (ierr.gt.0) ierr=0
      if (ierr.eq.0) iret=0

      return
      end