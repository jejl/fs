*
* Copyright (c) 2020 NVI, Inc.
*
* This file is part of VLBI Field System
* (see http://github.com/nvi-inc/fs).
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program. If not, see <http://www.gnu.org/licenses/>.
*
      program w
      integer ptr_ch
      call fcreate_version(ptr_ch('1.5'//char(0)))
      call fcreate_comment(ptr_ch(char(0)),ptr_ch('* comment'//char(0)))

C  2. $GLOBAL

      call fcreate_block(ptr_ch('GLOBAL'//char(0)))
      call fcreate_ref(ptr_ch('EXPER'//char(0)),
     &     ptr_ch('DBETST'//char(0))) 
      call fcreate_ref(ptr_ch('SCHEDULING_PARAMS'//char(0)),
     &     ptr_ch('SKED_PARAMS'//char(0))) 

      call fcreate_block(ptr_ch('EXPER'//char(0)))     
      call fcreate_comment(ptr_ch(char(0)),
     &     ptr_ch('* comment 2'//char(0)))
c
      call fcreate_block(ptr_ch('SCHED'//char(0)))     
c
      call fcreate_scan(ptr_ch('No001'//char(0)))
      call fcreate_start(ptr_ch('2005y039d16h47m53s'//char(0)))
      call fcreate_station(ptr_ch('Wf'//char(0)),
     &     ptr_ch('0'//char(0)),
     &     ptr_ch('sec'//char(0)),
     &     ptr_ch('40'//char(0)),
     &     ptr_ch('sec'//char(0)),
     &     ptr_ch('10877'//char(0)),
     &     ptr_ch('ft'//char(0)),
     &     ptr_ch('3A'//char(0)),
     &     ptr_ch('n'//char(0)))
      call fcreate_station_drive_list(ptr_ch('1'//char(0)))
      call fcreate_station_drive_list(ptr_ch(char(0)))
      call fend_scan
      call fcreate_comment(ptr_ch('t'//char(0)),
     &     ptr_ch('* comment 3'//char(0)))
c
      call fcreate_scan(ptr_ch('No002'//char(0)))
      call fcreate_start(ptr_ch('2006y039d16h47m53s'//char(0)))
      call fcreate_station(ptr_ch('Wz'//char(0)),
     &     ptr_ch('0'//char(0)),
     &     ptr_ch('sec'//char(0)),
     &     ptr_ch('40'//char(0)),
     &     ptr_ch('sec'//char(0)),
     &     ptr_ch('10877'//char(0)),
     &     ptr_ch('ft'//char(0)),
     &     ptr_ch('3A'//char(0)),
     &     ptr_ch('n'//char(0)))
      call fcreate_station_drive_list(ptr_ch('1'//char(0)))
      call fcreate_station_drive_list(ptr_ch(char(0)))
      call fend_scan
      call fcreate_comment(ptr_ch(char(0)),
     &     ptr_ch('* comment 4'//char(0)))
c
      call fcreate_block(ptr_ch('STATION'//char(0)))     
c
      call fcreate_vex(ptr_ch(char(0)))
c
      END

