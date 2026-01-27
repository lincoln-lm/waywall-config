precision highp float;

varying vec2 f_src_pos;

uniform sampler2D u_texture;
uniform int u_cur_time;

vec3 hsv2rgb(vec3 c) {
  vec3 rgb = clamp(abs(mod(c.x * 6.0 + vec3(0.0, 4.0, 2.0), 6.0) - 3.0) - 1.0,
                   0.0, 1.0);
  rgb = rgb * rgb * (3.0 - 2.0 * rgb);
  return c.z * mix(vec3(1.0), rgb, c.y);
}

void rainbow() {
  float time = float(u_cur_time);
  float hue = fract((f_src_pos.x + f_src_pos.y + time * 0.002) / 1.5);

  vec3 new_color = hsv2rgb(vec3(hue, 0.5, 1.0));

  gl_FragColor = vec4(new_color, 1.0);
}

const float threshold = 0.01;
const vec3 HIT_BOX_COLOR_1 = vec3(0.24705882352941178, 1.0, 0);
void main() {
  vec4 color = texture2D(u_texture, f_src_pos);
  bool is_hit_box =
      all(lessThan(abs(color.rgb - HIT_BOX_COLOR_1), vec3(threshold)));
  if (is_hit_box) {
    rainbow();
  } else {
    gl_FragColor = color;
  }
}