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


// adapted from https://godotshaders.com/shader/warped-fractal-noise/
const mat2 mtx = mat2(vec2(0.80, -0.60), vec2(0.60, 0.80));

float rand(vec2 n) {
  return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
}

float noise(vec2 p) {
  vec2 ip = floor(p);
  vec2 u = fract(p);
  u = u * u * (3.0 - 2.0 * u);

  float res =
      mix(mix(rand(ip), rand(ip + vec2(1.0, 0.0)), u.x),
          mix(rand(ip + vec2(0.0, 1.0)), rand(ip + vec2(1.0, 1.0)), u.x), u.y);

  return res * res;
}

float fbm(vec2 p) {
  float time = float(u_cur_time);
  float f = 0.0;

  f += 0.500000 * noise(p + time * 0.002);
  p = mtx * p * 2.02;
  f += 0.031250 * noise(p);
  p = mtx * p * 2.01;
  f += 0.250000 * noise(p);
  p = mtx * p * 2.03;
  f += 0.125000 * noise(p);
  p = mtx * p * 2.01;
  f += 0.062500 * noise(p);
  p = mtx * p * 2.04;
  f += 0.015625 * noise(p + sin(time * 0.002));

  return f / 0.96875;
}

float pattern(in vec2 p) { return fbm(p + fbm(p + fbm(p))); }

vec4 colormap(float x) {
  vec4 color_a = vec4(1.0, 0.5, 0.7, 1.0);
  vec4 color_b = vec4(0.7, 0.8, 1.0, 1.0);
  vec4 color_c = vec4(1.0, 1.0, 1.0, 1.0);

  if (x < 0.24) {
    return mix(color_a, color_b, x / 0.24);
  } else if (x < 0.48) {
    return mix(color_b, color_c, (x - 0.24) / 0.24);
  } else {
    return mix(color_c, color_a, (x - 0.48) / 0.52);
  }
}

void noise() { gl_FragColor = colormap(pattern(f_src_pos)); }

const float threshold = 0.01;
const vec3 HIT_BOX_COLOR = vec3(0.24705882352941178, 1.0, 0);
const vec3 WALL_COLOR = vec3(1.0, 0.498039216, 0.929411765);
const vec3 HEART_COLOR = vec3(1.0, 0.0745098039, 0.0745098039);
const vec3 HEART_DARK_COLOR = vec3(0.733333333, 0.0745098039, 0.0745098039);

void main() {
  vec4 color = texture2D(u_texture, f_src_pos);
  bool is_hit_box =
      all(lessThan(abs(color.rgb - HIT_BOX_COLOR), vec3(threshold)));
  bool is_wall = all(lessThan(abs(color.rgb - WALL_COLOR), vec3(threshold)));
  bool is_heart = all(lessThan(abs(color.rgb - HEART_COLOR), vec3(threshold)));
  bool is_heart_dark =
      all(lessThan(abs(color.rgb - HEART_DARK_COLOR), vec3(threshold)));
  if (is_hit_box) {
    rainbow(0.5, 1.0, 1.0);
  } else if (is_wall) {
    noise();
  } else if (is_heart) {
    rainbow(0.5, 1.0, 0.5);
  } else if (is_heart_dark) {
    rainbow(0.5, 0.7, 0.5);
  } else {
    gl_FragColor = color;
  }
}