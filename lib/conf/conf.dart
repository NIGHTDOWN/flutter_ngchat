//api地址
const apiurl='http://192.168.6.6/api/';
//数据库结构
const datatable=[
  'CREATE TABLE "msglist" ("id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,"msgid" integer,"chatid" integer,"comeid" integer,"sendtime" integer,"readflag" integer NOT NULL DEFAULT 0,"content" text,"type" integer, "resid" integer,"url" text,"murl" text,"size" integer,"length" integer)',
'CREATE TABLE "chatlist" ("id" INTEGER NOT NULL,"chatid" INTEGER NOT NULL,"uid" INTEGER NOT NULL,"uid2" integer NOT NULL,"name" TEXT,"lock" integer NOT NULL DEFAULT 0,"username" TEXT,"headimg" TEXT,"num" INTEGER NOT NULL, "msgtime" integer NOT NULL,"msg" TEXT,PRIMARY KEY ("id"));'
                ];