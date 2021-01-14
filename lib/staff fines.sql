select ptype_code::text, sum(owed_amt) from sierra_view.patron_view
 where ptype_code in (12, 13, 14, 15, 16, 17) 
 group by ptype_code

 union select 'all', sum(owed_amt) from sierra_view.patron_view
 where ptype_code in (12, 13, 14, 15, 16, 17) ;

/*

12 - AC
13 - CV
14 - greene
15 - louisa
16 - nelson
17 - OA

*/