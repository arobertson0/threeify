precision highp float;

varying vec3 v_viewSurfacePosition;
varying vec3 v_viewSurfaceNormal;
varying vec2 v_uv0;

uniform vec3 pointLightViewPosition;
uniform vec3 pointLightColor;
uniform float pointLightRange;

uniform float     specularAnisotropicFlowModulator;
uniform sampler2D specularAnisotropicFlowMap;

#pragma include <brdfs/common>
#pragma include <lighting/punctual>
#pragma include <brdfs/diffuse/lambert>
#pragma include <brdfs/specular/ggx>
#pragma include <brdfs/specular/anisotropy>
#pragma include <color/spaces/srgb>

void main() {

  vec3 albedo = vec3( 1.0 );
  vec3 specular = vec3( 1.0 );
  float specularRoughness = 0.25;
  vec2 specularAnisotropicFlow = specularAnisotropicFlowModulator * decodeAnisotropyFlowMap( texture2D( specularAnisotropicFlowMap, v_uv0 ) );
  vec3 F0 = ( specular * specular ) * 0.16;

  Surface surface;
  surface.position = v_viewSurfacePosition;
  surface.normal = normalize( v_viewSurfaceNormal );
  surface.viewDirection = normalize( -v_viewSurfacePosition );

  uvToTangentFrame( surface, v_uv0 );
  rotateTangentFrame( surface, normalize( specularAnisotropicFlow ) );

  PunctualLight punctualLight;
  punctualLight.position = pointLightViewPosition;
  punctualLight.color = pointLightColor;
  punctualLight.range = pointLightRange;

  DirectIllumination directIllumination;
  pointLightToDirectIllumination( surface, punctualLight, directIllumination );

  specularAnisotropicBentNormal( surface, length( specularAnisotropicFlow ), specularRoughness );

  vec3 outputColor = vec3(0.0);
  outputColor += BRDF_Specular_GGX( directIllumination, surface, F0, specularRoughness );
  outputColor += BRDF_Diffuse_Lambert( directIllumination, surface, albedo );

  gl_FragColor.rgb = linearTosRGB( outputColor );
  gl_FragColor.a = 1.0;

}
