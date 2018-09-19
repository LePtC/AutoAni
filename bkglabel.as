var cfg: Array;
var val: Number;

function initialize(vali: Number, cfgi: Array): void {

  cfg = cfgi;
  val = vali;
  te.text = vali.toString() + cfg[49][0];
}

function updatex(scale: Number): void {

  if(cfg[53][0] == "1") { // 对数轴
    this.x = Math.log(1+val) * scale;
  } else {
    this.x = val * scale; // scale 相对于除之后的值来计算
  }
  if(this.x < Number(cfg[50][0]) && this.alpha > 0) {
    this.alpha -= 0.02;
  }
  if(this.x > Number(cfg[50][0]) && this.alpha < 1) {
    this.alpha += 0.02;
  }
}
