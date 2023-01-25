 /* Find the model number , speed and hard drive capacity for all the PCs with prices below $500. */ 
 /* Result set: model , speed , hd. */
select pc.model
     , pc.speed
     , pc.hd
  from pc
 where price < 500