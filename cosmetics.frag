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

void rainbow(float saturation, float value, float speed) {
  float time = float(u_cur_time) * speed;
  float hue = fract((f_src_pos.x + f_src_pos.y + time * 0.002) / 1.5);

  vec3 new_color = hsv2rgb(vec3(hue, saturation, value));

  gl_FragColor = vec4(new_color, 1.0);
}

const float threshold = 0.01;
const vec3 HIT_BOX_COLOR = vec3(0.24705882352941178, 1.0, 0);
const vec3 HEART_COLOR = vec3(1.0, 0.0745098039, 0.0745098039);
const vec3 HEART_DARK_COLOR = vec3(0.733333333, 0.0745098039, 0.0745098039);

void main() {
  vec4 color = texture2D(u_texture, f_src_pos);
  bool is_hit_box =
      all(lessThan(abs(color.rgb - HIT_BOX_COLOR), vec3(threshold)));
  bool is_heart = all(lessThan(abs(color.rgb - HEART_COLOR), vec3(threshold)));
  bool is_heart_dark =
      all(lessThan(abs(color.rgb - HEART_DARK_COLOR), vec3(threshold)));
  if (is_hit_box) {
    rainbow(0.5, 1.0, 1.0);
  } else if (is_heart) {
    rainbow(0.5, 1.0, 0.5);
  } else if (is_heart_dark) {
    rainbow(0.5, 0.7, 0.5);
  } else {
    gl_FragColor = color;
  }
}