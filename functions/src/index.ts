import * as functions from "firebase-functions";
import * as admin from "firebase-admin";


admin.initializeApp(functions.config().firebase);

// Start writing Firebase Functions
// https://firebase.google.com/docs/functions/typescript

export const onNewOrder =
functions.firestore.document("/orders/{orderId}").
    onCreate(async (snapshot, context) => {
      const orderId = context.params.orderId;


      const querySnapshot = await admin.firestore().collection("admins").get();

      const admins = querySnapshot.docs.map((doc) => doc.id);

      let adminsTokens: string [] = [];
      for (let i = 0; i < admins.length; i++) {
        const tokensAdmin: string[] = await getDeviceTokens(admins[i]);
        adminsTokens = adminsTokens.concat(tokensAdmin);
      }

      await sendPushFCM(
          adminsTokens,
          "Novo Pedido",
          "Nova venda realizada. Pedido: " + orderId
      );
    });
/**
 * It returns tokens
 * @param {String} uid
 */
async function getDeviceTokens(uid: string) {
  const querySnapshot = await
  admin.firestore().collection("users").doc(uid).collection("tokens").get();

  const tokens = querySnapshot.docs.map((doc) => doc.id);

  return tokens;
}
/**
 * It returns notifications
 * @param {String} tokens
 * @param {String} title
 * @param {String} message
 */
async function sendPushFCM(tokens: string[], title: string, message: string) {
  if (tokens.length > 0) {
    const payload = {
      notification: {
        title: title,
        body: message,
        click_action: "FLUTTER_NOTIFICATION_CLICK",
      },
    };
    return admin.messaging().sendToDevice(tokens, payload);
  }
  return;
}

const orderStatus = new Map([
  [0, "Cancelado"],
  [1, "Em Preparação"],
  [2, "Em Transporte"],
  [3, "Entregue"],
]);

export const onOrderStatusChanged =
functions.firestore.document("/orders/{orderId}").
    onUpdate(async (snapshot, context) => {
      const beforeStatus = snapshot.before.data().status;
      const afterStatus = snapshot.after.data().status;

      if (beforeStatus !== afterStatus) {
        const tokensUser = await getDeviceTokens(snapshot.after.data().user);

        await sendPushFCM(
            tokensUser,
            "Pedido: " + context.params.orderId,
            "Status atualizado para: " + orderStatus.get(afterStatus),
        );
      }
    });
