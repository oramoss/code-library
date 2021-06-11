select 'alter index '||index_name||' rebuild;' from user_indexes where status='UNUSABLE';
