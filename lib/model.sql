-- aqui un poco oxidado con sql ,sql sin las maravillas de postgresql
-- Se supone que para ser elegantes photo uno seria la parte frontal y haci con los otros
-- pero somos humanos y esto lo usara humanos
-- el campo extra almacenara las rutas de la imagenes extras , ya que son extras y 
-- nos nos importan tanto su privacidad, seran separadas por ::: 
-- ahora me entero lo pocos tipos de datos que hay en sqlite
CREATE TABLE heroe(id_meta INTEGER DEFAULT 2 ,name TEXT,uuid_movil TEXT,
verificado integer DEFAULT 0,password TEXT,get_passwd integer DEFAULT 0,
foto TEXT,group_name TEXT,carnet INTEGER,new INTEGER DEFAULT 1)

CREATE TABLE estadisticas(count_persons INTEGER,date_work TEXT)

CREATE TABLE metainfo(id INTEGER PRIMARY KEY AUTOINCREMENT,group_heroe_name TEXT,ubicacion_name TEXT,
x TEXT,y TEXT,on_time_start TEXT,on_time_end TEXT)

CREATE TABLE persons(id INTEGER PRIMARY KEY AUTOINCREMENT,foto_uno TEXT,foto_dos TEXT,extra TEXT,
id_carnet INTEGER,name TEXT,domicilio TEXT,en TEXT,on_time TEXT)