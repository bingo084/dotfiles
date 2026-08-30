return {
	transparent = "rgba(0, 0, 0, 0)",
<* for name, value in colors *>
	{{name}} = {
		[10] = "{{value.default.rgba | set_alpha: 0.1}}",
		[20] = "{{value.default.rgba | set_alpha: 0.2}}",
		[30] = "{{value.default.rgba | set_alpha: 0.3}}",
		[40] = "{{value.default.rgba | set_alpha: 0.4}}",
		[50] = "{{value.default.rgba | set_alpha: 0.5}}",
		[60] = "{{value.default.rgba | set_alpha: 0.6}}",
		[70] = "{{value.default.rgba | set_alpha: 0.7}}",
		[80] = "{{value.default.rgba | set_alpha: 0.8}}",
		[90] = "{{value.default.rgba | set_alpha: 0.9}}",
		[100] = "{{value.default.rgba | set_alpha: 1.0}}",
	},
<* endfor *>
}
