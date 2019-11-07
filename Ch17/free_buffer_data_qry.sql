with  fbd as (
select runtag, case  when event in ('buffer busy waits','CPU') then event 
                  when event like 'log%' then 'Redo IO'
                  when event like 'read by other session' then 'Datafile IO'
                  when event like 'db file%' then 'Datafile IO' 
                  when event like 'enq:%' then 'Lock'
                  when event like 'latch:%' then 'Latch'
                  else 'Other' end as  category, event, ms from free_buffer_data order by ms desc ) 
select runtag,category, sum(ms) ms from fbd where runtag like 'BUFFER%'  group by runtag,category order by 3 desc 
