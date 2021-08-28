import consumer from "./consumer"

// // turbolinks の読み込みが終わった後にidを取得しないと，エラーが出ます。
// document.addEventListener('turbolinks:load', () => {

//   // js.erb 内で使用できるように変数を定義しておく
//   window.chatContainer = document.getElementById('chat-container')

//   // 以下のプログラムが他のページで動作しないようにしておく
//   if (chatContainer === null) {
//       return
//   }

//   // consumer.subscriptions.create("RoomChannel", {
//   consumer.subscriptions.create({ channel: "RoomChannel", room: $('#chats').data('room_id')}, {  
//       connected() {
//       },

//       disconnected() {
//       },

//       received(data) {
//           // サーバー側から受け取ったHTMLを一番最後に加える
//           // chatContainer.insertAdjacentHTML('beforeend', data['chat'])
//           return $('#chats').append(data['chat']);
//       }
//   })
// })



// turbolinks の読み込みが終わった後にidを取得しないと，エラーが出ます。
// document.addEventListener('turbolinks:load', () => {
    $(function() {
      const chatChannel = consumer.subscriptions.create({ channel: 'RoomChannel', room: $('#chats').data('room_id')}, {
        connected() {
          // Called when the subscription is ready for use on the server
        },

        disconnected() {
          // Called when the subscription has been terminated by the server
        },

        received: function(data) {
          //画面を開いているのがチャット送信者だった場合
          if (data["current_user"] === data["send_user"]){
          // if (data["isCurrent_user"] === true){
          var sentence=`<div class="mycomment">${data['create_time']} <p>${data['chat']}</p></div>`;
          // var sentence = data['chat'];
          
          //画面を開いているのがチャット受信者だった場合
          } else{
            var sentence=`<div class='fukidasi'><div class='faceicon'>
            <img src='/assets/profile.png' alt='管理人'></div>
            <div class='chatting'><div class='says'><p>${data['chat']}</p>
            </div> ${data['create_time']}</div></div>`;
          }
          
          return $('#chats').append(sentence);

          // var sentence=`<div class="mycomment">${data["chat"]}</div>`;
          // return $('#chats').append(sentence);
        },

        // speak: function(chat) {
        //   return this.perform('speak', {
        //     chat: chat
        //   });
        // }

        speak: function(chat) {
          const current_user_id = $('#current_user_id').val();
          const partner_id = $("#partner_id").val();
          // console.log(partner_id)
          return this.perform('speak', {chat: chat, current_user_id: current_user_id, partner_id: partner_id});
        }
      });

      // EnterKeyで送信
      // $(document).on('keypress',function(e){
      //   if (e.keyCode === 13) {
      //     chatChannel.speak(e.target.value);
      //     e.target.value = '';
      //     return e.preventDefault();
      //   }
      // });

      // 送信ボタンで送信
      const messageButton = $("#chat-send-button")
      const messageContent = $("#chat-sentence")

      messageButton.on("click",function(e){
        var sentence=$("#chat-sentence").val();
        chatChannel.speak(sentence);
        messageContent.val(""); //フォームを空に
        messageButton.prop('disabled', true); // ボタンを無効化
        e.preventDefault();
        $('html, body').animate({
          scrollTop: $(document).height()
        },500);
        return false;
      });

      // 自動スクロール(下)
      $(".room-main-header").on("click",function(){
        $('html, body').animate({
            scrollTop: $(document).height()
          },500);
          return false;
      });

      // // ボタンを無効化
      // $(':input[type="submit"]').prop('disabled', true);
      // // フォームが空欄でなければ、ボタンを有効化     
      // $('input[type="text"]').keyup(function() {
      //    if($(this).val() != '') {
      //       $(':input[type="submit"]').prop('disabled', false);
      //    } else {
      //       $(':input[type="submit"]').prop('disabled', true);           
      //    }
      // });

      // // ボタンを無効化
      // $('#chat-send-button').prop('disabled', true);
      // // フォームが空欄でなければ、ボタンを有効化     
      // $('#chat-sentence').keyup(function() {
      //    if($(this).val() != '') {
      //       $('#chat-send-button').prop('disabled', false);
      //    } else {
      //       $('#chat-send-button').prop('disabled', true);           
      //    }
      // });

      // ボタンを無効化
      messageButton.prop('disabled', true);
      // フォームが空欄でなければ、ボタンを有効化     
      messageContent.keyup(function() {
         if($(this).val() != '') {
            messageButton.prop('disabled', false);
         } else {
            messageButton.prop('disabled', true);           
         }
      });


      // 行数自動変更

      // $(document).on('keypress',function(e){
      //   if (e.keyCode === 13) {
      //     if ($('#chat-sentence').children().length < 10) {
      //       $('#chat-sentence').append('<input type="text">');
      //     }
      //   }
      // });

      // // フォームの最大行数を決定
      // const maxLineCount = 10

      // // 入力メッセージの行数を調べる関数
      // const getLineCount = () => {
      //     return (messageContent.value + '\n').match(/\r?\n/g).length;
      // }

      // let lineCount = getLineCount()
      // let newLineCount

      // const changeLineCheck = () => {
      //     // 現在の入力行数を取得（ただし，最大の行数は maxLineCount とする）
      //     newLineCount = Math.min(getLineCount(), maxLineCount)
      //     // 以前の入力行数と異なる場合は変更する
      //     if (lineCount !== newLineCount) {
      //         changeLineCount(newLineCount)
      //     }
      // }

      
  
    });

// });