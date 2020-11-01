import 'package:saborissimo/data/model/Meal.dart';
import 'package:saborissimo/data/model/Menu.dart';

class MenuDataService {
  static final Menu menu = Menu(
    [
      Meal.withType(
        1,
        "Pozole",
        "El pozole es un caldo con granos de maíz, y dependiendo de la región puede ser blanco, verde o rojo. Sin embargo, al menos existen unas 20 variedades de pozole.",
        "https://dam.cocinafacil.com.mx/wp-content/uploads/2018/08/pozole-rojo.jpg",
        "ENTRANCE",
      ),
      Meal.withType(
        2,
        "Mole",
        "El mole es una salsa que acompaña el pollo o al guajolote. El más popular es el mole poblano, que proviene de Puebla como su nombre lo indica. En cada estado del país este platillo se prepara de distintas formas.",
        "https://i.ytimg.com/vi/0k2sTg6cOGA/maxresdefault.jpg",
        "ENTRANCE",
      ),
    ],
    [
      Meal.withType(
        3,
        "Cochinita pibil",
        "Este platillo proviene del estado de Yucatán y se prepara con carne de cerdo deshebrada adobada en achiote y se acompaña con salsa morada con chile habanero picado.",
        "https://dam.cocinafacil.com.mx/wp-content/uploads/2018/11/cochinita-pibil-ingredientes.jpg",
        "MIDDLE",
      ),
      Meal.withType(
        4,
        "Chiles en nogada",
        "La receta de los chiles en nogada está pensada con base de un chile poblano y de relleno puede ser carne de cerdo o res, acompañado jitomate, cebolla, ajo, frutas de estación, nueces, almendras, piñones y diversas especias.",
        "https://sifu.unileversolutions.com/image/es-MX/recipe-topvisual/2/1260-709/chile-en-nogada-50420119.jpg",
        "MIDDLE",
      ),
    ],
    [
      Meal.withType(
        3,
        "Cochinita pibil",
        "Este platillo proviene del estado de Yucatán y se prepara con carne de cerdo deshebrada adobada en achiote y se acompaña con salsa morada con chile habanero picado.",
        "https://dam.cocinafacil.com.mx/wp-content/uploads/2018/11/cochinita-pibil-ingredientes.jpg",
        "MIDDLE",
      ),
      Meal.withType(
        5,
        "Enchiladas",
        "La preparación de las enchiladas está hecha a base de tortilla frita y se rellenan de pollo, se cubren con salsa, ya sea roja o verde, y se acompañan con cebolla, crema y queso.",
        "https://www.mexicoenmicocina.com/wp-content/uploads/2013/11/Enchiladas-rojas-2.jpg",
        "STEW",
      ),
    ],
    [
      Meal.withType(
        6,
        "Jericallas",
        "Antes de comenzar a cocinar debes saber que éste es un postre típico originario de la ciudad de Guadalajara. Está hecho a base de leche, huevos, vainilla, canela y azúcar. Hacerlo es muy sencillo, así que valdrá la pena el tiempo que inviertas.",
        "https://dam.cocinafacil.com.mx/wp-content/uploads/2014/05/jericalla.jpg",
        "DESSERT",
      ),
      Meal.withType(
        7,
        "Capirotada",
        "La capirotada es un platillo hecho con rebanadas de bolillo o pan tostado, como tú lo prefieras. Para su preparación también se requieren pasas, nueces, piloncillo y queso rallado. Este postre es un platillo popular en los estados del norte del país como Coahuila, Sonora y Nuevo León. Su éxito se extiende incluso a Nuevo México en Estados Unidos.",
        "https://dam.cocinafacil.com.mx/wp-content/uploads/2014/10/capirotada.jpg",
        "DESSERT",
      ),
      Meal.withType(
        8,
        "Arroz con leche",
        "El arroz con leche es un postre hecho con canela, vainilla, leche y por supuesto arroz. Esta receta es considerada un platillo típico de varias regiones del mundo, no es exclusiva de México, sin embargo forma parte importante de la gastronomía mexicana.",
        "https://dam.cocinafacil.com.mx/wp-content/uploads/2017/11/arroz-con-leche-.jpg",
        "DESSERT",
      ),
    ],
    [
      Meal.withType(
        9,
        "Agua de horchata",
        "El agua de horchata se prepara en México con arroz, rajas de canela, leche, azúcar blanca y esencia de vainilla. Algunas recetas llevan coco, almendras, semilla de morro y leche condensada, para hacerla más dulce.",
        "https://tipsparatuviaje.com/wp-content/uploads/2019/05/Agua-de-horchata.jpg",
        "DRINK",
      ),
    ],
  );
}
