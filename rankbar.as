import flash.display.*;

var colbar: Array;
var cfg: Array;


var n: int; // 序号
var id: String; // mid
var cn: String; // 中文名
//var po: Number;
var rt: Number;
var col: Number;

var H: Number;

var format1: TextFormat;

var Icon: Sprite; // 头像容器


var alphaTar:Number=1;
var xTar:Number=0;
var scaTar:Number=1;
var rotTar:Number=0;

var recfirst:Number;

function initialize(ni: int, idi: String, cni: String, coli: Number, pofix: String, cfgi: Array, firsti:Number): void {

	cfg = cfgi;

  rank1.x = cfg[22][0];
	rank1.y = cfg[22][1];
	rec.x = cfg[24][0];
  rec.y = cfg[24][1];
  cvalue.y = cfg[41][1];
	cname.x = cfg[25][0];
	H = cfg[26][0];
	rec.height = cfg[27][0];

	rt = cfg[28][0] / 2;

	format1 = new TextFormat();
	format1.color = cfg[2][1];
	format1.size = cfg[29][0];

	this.y = Number(cfg[30][0]);
	this.alpha = 0;

	n = ni;

	cn = cni;
	cname.text = cni;
	cname.setTextFormat(format1);

  Icon = new Sprite(); // 头像容器
  addChildAt(Icon,2);

	id = clearDelimeters(idi);
	var icon: Loader = new Loader();
	icon.contentLoaderInfo.addEventListener(Event.COMPLETE, iconLoaded);
	icon.load(new URLRequest(id + pofix));


	col = coli;
  if(cfg[32][0]=="1"){
    include "colbar.as"; // 按增速变色
  }else{
    var newColorTransform: ColorTransform = rec.transform.colorTransform;
    newColorTransform.color = col;
    rec.transform.colorTransform = newColorTransform;
  }

  wat.water.y = cvalue.y + Number(cfg[119][1]);
  alphaTar = 1;
  xTar = 0;
  scaTar = 1;
  rotTar = 0;
  fanlast = 0;

  recfirst=firsti;
  if(cfg[33][0]!="0"){
    recini.x = rec.x;
    recini.y = rec.y;
    recini.height = cfg[33][0];
    recini.alpha = Number(cfg[33][1]);
  }else{
    recini.visible=false;
  }
  trace(cni+recfirst);
}



function iconLoaded(e: Event): void {

	var image: Bitmap = new Bitmap(e.target.content.bitmapData);
	image.width = 2 * rt;
	image.height = 2 * rt;
	image.x = Number(cfg[23][0]) - rt;
	image.y = Number(cfg[23][1]);
	Icon.addChildAt(image, 0);

if(cfg[31][0]=="1"){
  // Create the mask graphic
  var maskCircle: Sprite = new Sprite();
  maskCircle.graphics.beginFill(0x000000);
  maskCircle.graphics.drawEllipse(image.x, image.y, 2 * rt, 2 * rt);
  maskCircle.graphics.endFill();
  maskCircle.visible = false;
  Icon.addChild(maskCircle);

  image.mask = maskCircle; // Applies the mask
}

if(id==cfg[110][0]){
  var hi:High = new High();
  hi.width=image.width*cfg[111][0];
  hi.scaleY=hi.scaleX
  hi.x=image.x+rt;
  hi.y=image.y+rt;
  hi.alpha=cfg[112][0];
  this.addChild(hi);
}
}



var rank: int; // 要去往的排名
rank1.text = "";

var po: Number = 0;
var fan: Number = 0;
var fanlast: Number = 0;
var news: int = 60; // 最近有更新的话，给30帧高亮时间
var tarA: Number; // 最近有更新的目标alpha1，否则半透明


function update(poi: Number): void {

  po = poi;
	fan = po / cfg[36][0];
  var temp:Number = fan - fanlast;

	if(temp > Number(cfg[68][0])) {
		this.alpha = 1;
		news = cfg[69][0];
	} else if(news > Number(cfg[70][0])) {
		news--;
	}

  if(cfg[32][0]=="1"){
    temp = poi;
  }
  if(cfg[32][0]=="1"||cfg[32][0]=="2"){
    var newColorTransform: ColorTransform = rec.transform.colorTransform;
    newColorTransform.color = colbar[colfun(temp)];
    rec.transform.colorTransform = newColorTransform;
  }


	fanlast = fan;
	tarA = news / cfg[69][0];


	cvalue.text = cfg[38][0] + fan.toFixed(int(cfg[37][0])).toString() + cfg[39][0];
  if(fan>=recfirst){
    cvalue.text+="（▲ "+((fan/recfirst-1)*100).toFixed(1).toString()+"%）";
  }else{
    cvalue.text+="（▼ "+(-(fan/recfirst-1)*100).toFixed(1).toString()+"%）";
  }

	cvalue.setTextFormat(format1);

	rank1.text = (rank + 1).toString() ; //+ "."
	rank1.setTextFormat(format1);

}



function clearDelimeters(formattedString: String): String {
	return formattedString.replace(/[\u000d\u000a\u0008\u0020]+/g, "");
}

// 位置和柱长都采用“固定比例赶往目标值”算法
var targ:Number;
var targini:Number;
function updatey(i: int, scale: Number): void {

	if(cfg[53][0] == "1") { // 对数轴
		targ = Math.log(1 + fan) * scale;
    targini = Math.log(1 + recfirst) * scale;
	} else {
		targ = fan * scale;
    targini = recfirst * scale;
	}

  rec.width += (Math.abs(targ) - rec.width) / Number(cfg[8][0]);
  recini.width += (Math.abs(targini) - recini.width) / Number(cfg[8][0]);

	cvalue.x = rec.width + Number(cfg[41][0]);
	if(cvalue.x < Number(cfg[40][0])) {
		cvalue.x = Number(cfg[40][0]);
	}
	if(cvalue.x > Number(cfg[40][1])) {
		cvalue.x = Number(cfg[40][1]);
	}

  wat.water.text = cfg[118][int(rank % int(cfg[118].length))];
  wat.water.x += (xTar-wat.water.x)/Number(cfg[124][0]);
  wat.water.alpha += (alphaTar-wat.water.alpha)/Number(cfg[124][0]);
  wat.water.scaleX += (scaTar-wat.water.scaleX)/Number(cfg[124][0]);
  wat.water.scaleY = wat.water.scaleX;
  wat.water.rotation += (rotTar-wat.water.rotation)/Number(cfg[124][0]);

  if(cfg[31][1]=="R"){Icon.x = rec.x+rec.width;}
  if(cfg[25][1]=="R"){
    cname.x = rec.width - (cname.textWidth + 10) + Number(cfg[25][2]);
  }


	if(Math.abs(fan) >= Number(cfg[67][0])) {
		var dist = Math.abs(i * H - this.y);
		if(dist >= Number(cfg[10][0])) { // 变速
			this.y += (i * H - this.y) / Number(cfg[9][0]);
		} else if(dist >= Number(cfg[12][0])) { // 匀速
			if(this.y < i * H) {
				this.y += Number(cfg[11][0]);
			}
			if(this.y > i * H) {
				this.y -= Number(cfg[11][0]);
			}
		} else { // 直接抵达
			this.y = i * H;
		}

	} else {
		rank1.text = "";
		this.y += (Number(cfg[30][0]) - this.y) / Number(cfg[11][0]); // 往出生点消失
	}

	if(Math.abs(fan) <= Number(cfg[67][0]) || (this.alpha > tarA + 0.05)) {
		this.alpha -= 0.05;
	} else if(this.alpha < tarA - 0.05) {
		this.alpha += 0.05;
	}

}






var pstart: int; // 拥有用户的层号起点
var pnum: int; // 拥有用户数量



function colfun(speed: Number): int {
  if(isNaN(speed)){
    return(1)
  }
  if(speed <= 0) {
    return(0)
  }
  if(speed >= Number(cfg[32][1])) {
    return(100)
  }
  return(int(Math.pow(speed / Number(cfg[32][1]), 1 / 6) * 100))
}




function updateWater(): void {
  alphaTar = Number(cfg[120][0])+(Number(cfg[120][1])-Number(cfg[120][0]))*Math.pow(Math.random(),int(cfg[120][2]));
  if(cfg[121][1]=="0"){
    xTar = Number(cfg[121][0])+(cvalue.x + Number(cfg[119][0])-Number(cfg[121][0]))*Math.random();
    }else{
      xTar = Number(cfg[121][0])+(Number(cfg[121][1])-Number(cfg[121][0]))*Math.random();
    }

  scaTar = Number(cfg[122][0])+(Number(cfg[122][1])-Number(cfg[122][0]))*Math.random();
  rotTar = Number(cfg[123][0])+(Number(cfg[123][1])-Number(cfg[123][0]))*Math.random();
}
