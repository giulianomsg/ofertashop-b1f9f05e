import productHeadphones from "@/assets/product-headphones.jpg";
import productSmartwatch from "@/assets/product-smartwatch.jpg";
import productSpeaker from "@/assets/product-speaker.jpg";
import productKeyboard from "@/assets/product-keyboard.jpg";
import productBackpack from "@/assets/product-backpack.jpg";
import productCharger from "@/assets/product-charger.jpg";

export interface Product {
  id: string;
  title: string;
  price: number;
  originalPrice?: number;
  discount?: number;
  rating: number;
  reviewCount: number;
  image: string;
  badge?: "verified" | "hot" | "new";
  store: string;
  category: string;
  description: string;
  affiliateUrl: string;
  clicks: number;
}

export const products: Product[] = [
  {
    id: "1",
    title: "Fone Bluetooth Premium NC-700",
    price: 249.90,
    originalPrice: 499.90,
    discount: 50,
    rating: 4.8,
    reviewCount: 1243,
    image: productHeadphones,
    badge: "hot",
    store: "TechStore",
    category: "Eletrônicos",
    description: "Fone de ouvido sem fio com cancelamento de ruído ativo, bateria de 20h e som Hi-Fi premium. Conforto excepcional para uso prolongado.",
    affiliateUrl: "#",
    clicks: 8420,
  },
  {
    id: "2",
    title: "Smartwatch Ultra Fit Pro",
    price: 399.00,
    originalPrice: 599.00,
    discount: 33,
    rating: 4.6,
    reviewCount: 876,
    image: productSmartwatch,
    badge: "verified",
    store: "WearTech",
    category: "Wearables",
    description: "Smartwatch com monitor cardíaco, GPS integrado, tela AMOLED e resistência à água 5ATM. Perfeito para esportistas.",
    affiliateUrl: "#",
    clicks: 5630,
  },
  {
    id: "3",
    title: "Caixa de Som Portátil SoundMax",
    price: 179.90,
    originalPrice: 299.90,
    discount: 40,
    rating: 4.5,
    reviewCount: 2105,
    image: productSpeaker,
    badge: "verified",
    store: "AudioShop",
    category: "Áudio",
    description: "Som 360° com graves profundos, à prova d'água IPX7, 24h de bateria. Ideal para festas e aventuras ao ar livre.",
    affiliateUrl: "#",
    clicks: 12300,
  },
  {
    id: "4",
    title: "Teclado Mecânico RGB Gamer Pro",
    price: 329.00,
    originalPrice: 449.00,
    discount: 27,
    rating: 4.7,
    reviewCount: 654,
    image: productKeyboard,
    badge: "new",
    store: "GameZone",
    category: "Periféricos",
    description: "Switches mecânicos hot-swap, iluminação RGB por tecla, anti-ghosting NKRO. O teclado definitivo para gamers.",
    affiliateUrl: "#",
    clicks: 3210,
  },
  {
    id: "5",
    title: "Mochila Laptop Urban Shield",
    price: 189.90,
    originalPrice: 259.90,
    discount: 27,
    rating: 4.4,
    reviewCount: 432,
    image: productBackpack,
    store: "UrbanGear",
    category: "Acessórios",
    description: "Compartimento acolchoado para laptop 15.6\", impermeável, porta USB externa. Design moderno para o dia a dia.",
    affiliateUrl: "#",
    clicks: 2100,
  },
  {
    id: "6",
    title: "Carregador Wireless Turbo 15W",
    price: 89.90,
    originalPrice: 149.90,
    discount: 40,
    rating: 4.3,
    reviewCount: 1876,
    image: productCharger,
    badge: "hot",
    store: "PowerUp",
    category: "Acessórios",
    description: "Carregamento rápido 15W, compatível com Qi, design ultrafino com LED indicador. Carregue sem fios com estilo.",
    affiliateUrl: "#",
    clicks: 9870,
  },
];

export const categories = [
  "Todos",
  "Eletrônicos",
  "Wearables",
  "Áudio",
  "Periféricos",
  "Acessórios",
  "Casa & Decoração",
  "Esportes",
];
