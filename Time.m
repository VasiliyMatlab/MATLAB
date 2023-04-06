function [hour,minute,second]=Time(sec)
hour=floor(sec/3600);
minute=floor((sec-hour*3600)/60);
second=sec-hour*3600-minute*60;