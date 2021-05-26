//プレビュー機能
if (document.URL.match( /new/ ) || document.URL.match( /check/ ) || document.URL.match( /edit/ )) {
  document.addEventListener('DOMContentLoaded', function(){
    console.log("test");
    const ImageList = document.getElementById('image-list');

    const createImageHTML = (blob) => {
       // 画像を表示するためのdiv要素を生成
      // const imageElement = document.createElement('div');
      const imageElement = document.createElement('div', { is: "image-list2" });

      // 表示する画像を生成
      // const blobImage = document.createElement('img');
      const blobImage = document.createElement('img', { is: "profile-image" });
      // Blob内で大きさを指定
      blobImage.width = 150;
      blobImage.height = 150;
      // blobImage.position = "absolute";
      // blobImage.left = 300 + "px";
      // blobImage.top =  300 + "px";


      blobImage.setAttribute('src', blob);

      // 生成したHTMLの要素をブラウザに表示させる
      imageElement.appendChild(blobImage);
      ImageList.appendChild(imageElement);
    };

    document.getElementById('item-image').addEventListener('change', function(e){
      // 画像が表示されている場合のみ、すでに存在している画像を削除する
      // const imageContent = document.querySelector('img');
      const imageContent = document.querySelector('img');
      if (imageContent){
        imageContent.remove();
      }

      const file = e.target.files[0];
      const blob = window.URL.createObjectURL(file);

      createImageHTML(blob);
    });
  });
}