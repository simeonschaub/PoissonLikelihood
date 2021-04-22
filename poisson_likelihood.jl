### A Pluto.jl notebook ###
# v0.14.2

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 2265874e-5bac-47ed-8ca9-8ce7ee98f906
begin
	import Pkg
	Pkg.activate()
	Pkg.add(["Distributions", "Plots", "PlutoUI"])
end

# ╔═╡ b03c59d4-a28c-11eb-2c3c-052e0d3a259a
using Distributions, Plots, PlutoUI, Random

# ╔═╡ f6f8b6f1-f0f5-4b1a-8a28-5b8dbf377487
md"""
Zählexperiment mit $N$ Samples $x$ mit Erwartungswert $\lambda$:

$x_i \sim \operatorname{Poisson}(\lambda)$

Ziel: Bestimme Unsicherheit auf $\lambda$, gegeben durch Verteilung $P(\lambda | x)$

Satz von Bayes:

$P(\lambda | x) = \frac{P(x | \lambda) P(\lambda)}{\int \mathrm{d}\lambda' \, P(x | \lambda') P(\lambda')}$

Starte mit $\Gamma(k_0, \theta_0)$ als Verteilung für Prior $P(\lambda)$

Likelihood $P(x_i | \lambda)$ gegeben durch $\operatorname{Poisson}(\lambda)$

$P(x | \lambda) = P\Big(\sum_i x_i \Big| n \lambda \Big)$

Posterior nach $n$ Samples $x$ $P(\lambda | x)$ hat schöne analytische Lösung als:

$\Gamma\bigg(k_0 + \sum_i x_i, \frac{\theta_0}{n \theta_0 + 1}\bigg)$
"""

# ╔═╡ c074a4b9-1e09-44c3-b7c2-0a9edeadd8cf
md"""
λ $(@bind λ Slider(0.0:100.0; show_value=true))

n $(@bind n Slider(0:200; show_value=true))

k₀ $(@bind k_0 Slider(0.01:0.01:50; show_value=true))

θ₀ $(@bind θ_0 Slider(0.01:0.01:50; default=1, show_value=true))
"""

# ╔═╡ 424c7e22-2a8d-4049-b273-beac78f5769c
begin
	poisson = Poisson(λ)
	Random.seed!(1234)
	x = rand(poisson, n)
	prior = Gamma(k_0, θ_0)
	posterior = Gamma(k_0 + sum(x), θ_0 / (n * θ_0 + 1))
end;

# ╔═╡ 1d076946-4250-4125-afff-2b517a16fe47
plot([λ -> pdf(prior, λ) λ -> pdf(posterior, λ)], 0, 100;
	layout=2, size=(700, 300), label=["Prior" "Posterior"],
	color=[1 2], lw=1.5)

# ╔═╡ bd038557-b8da-4e4e-999f-71737b6d9cff
md"""
Im Limes für flachen Prior $k_0 \rightarrow 0$, $\theta_0 \rightarrow \infty$, wobei $\theta_0 \gg \frac{1}{k_0}$:

$P(\lambda | x) \approx \operatorname{pdf}\bigg(\Gamma\bigg(\sum_i x_i, \frac{1}{n}\bigg), \lambda\bigg) \propto \operatorname{pdf}\bigg(\operatorname{Poisson}(n\lambda), \sum_i x_i\bigg) = P(x | \lambda)$

Für Likelihood-Fits mache die Annahme, dass der Posterior (Verteilung für $\lambda$ nach Messung von $x$) der Likelihood mal Normalisierungskonstante entspricht.
"""

# ╔═╡ e6743cba-2f3c-48fb-bcc2-b319eaa446ef
plot([λ -> pdf(posterior, λ) λ -> pdf(Poisson(n*λ), sum(x))], 0, 100;
	layout=2, size=(700, 300), label=["Posterior" "Poisson Likelihood"],
	color=[1 2], lw=1.5)

# ╔═╡ Cell order:
# ╠═2265874e-5bac-47ed-8ca9-8ce7ee98f906
# ╠═b03c59d4-a28c-11eb-2c3c-052e0d3a259a
# ╟─f6f8b6f1-f0f5-4b1a-8a28-5b8dbf377487
# ╟─c074a4b9-1e09-44c3-b7c2-0a9edeadd8cf
# ╠═424c7e22-2a8d-4049-b273-beac78f5769c
# ╠═1d076946-4250-4125-afff-2b517a16fe47
# ╟─bd038557-b8da-4e4e-999f-71737b6d9cff
# ╠═e6743cba-2f3c-48fb-bcc2-b319eaa446ef
