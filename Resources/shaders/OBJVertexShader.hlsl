#include "OBJShaderHeader.hlsli"

VSOutput main(float4 pos : POSITION, float3 normal : NORMAL, float2 uv : TEXCOORD)
{
	// 右、下、奥の方向を向いたライト
	float3 lightdir = float3(1, -1, 1);
	lightdir = normalize(lightdir);
	// ライトの色（白）
	float3 lightcolor = float3(1, 1, 1);
	// 環境反射光
	float3 ambient = m_ambient;
	// 拡散反射光
	float3 diffuse = dot(-lightdir, normal) * m_diffuse;
	// 視点座標
	const float3 eye = float3(0, 0, -20);
	// 光沢度
	const float shininess = 4.0f;
	// 頂点から支店への方向ベクトル
	float3 eyedir = normalize(eye - pos.xyz);
	// 反射光ベクトル
	float3 reflect = normalize(lightdir + 2 * dot(-lightdir, normal) * normal);
	// 鏡面反射光
	float3 specular = pow(saturate(dot(reflect, eyedir)), shininess) * m_specular;
	// ピクセルシェーダーに渡す値
	VSOutput output;
	output.svpos = mul(mat, pos);
	// Lamber反射の計算
	//output.color.rgb = dot(-lightdir, normal) * m_diffuse * m_ambient *lightcolor;
	////output.normal = normal;
	//output.color.a = m_alpha;
	output.uv = uv;
	// すべて加算する
	output.color.rgb = (ambient + diffuse + specular) * lightcolor;
	output.color.a = m_alpha;

	return output;
}