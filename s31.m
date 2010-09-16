% calls jenny
xx = dtmfdial(['2','1','5','9','0','6','9','8','3','5'],8000);
soundsc(xx,8000)
specgram(xx, 2048, 8000)