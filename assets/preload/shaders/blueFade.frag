#pragma header

// Value from (0, 1)
uniform float fadeAmt;

// fade the image to blue as it fades to black

void main()
{
  vec4 tex = flixel_texture2D(bitmap, openfl_TextureCoordv);

  vec4 finalColor = mix(vec4(vec4(0.0, 0.0, tex.b, tex.a) * fadeAmt), vec4(tex * fadeAmt), fadeAmt);

  // Output to screen
  gl_FragColor = finalColor;
}