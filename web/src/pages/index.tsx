import * as React from "react"
import { HeadFC, PageProps } from "gatsby"
import { button } from "./index.module.scss"

import logo from "../images/logo.svg"
import chevronDown from "../images/chevron-down.svg"
import tyzdenneVyzvy from "../images/tyzdenne-vyzvy.png"
import diskusneForum from "../images/diskusne-forum.png"
import vzdelavanie from "../images/vzdelavanie.png"
import logoMirri from "../images/logo-mirri.svg"
import logoPoo from "../images/logo-poo.png"
import logoSda from "../images/logo-sda.png"
import footer from "../images/footer.png"

const IndexPage: React.FC<PageProps> = () => {
  return (
    <>
      <main>
        <header>
          <div>
            <img src={logo} alt="Logo" />
          </div>
          <a className={button} href="https://app.infomentor.sk">
            Prejsť do aplikácie
          </a>
          <div>
            <img src={chevronDown} alt="Scroll down" />
          </div>
        </header>

        <section data-type="tri-body">
          <h2>Ako funguje appka Infomentor?</h2>
          <div>
            <div>
              <img src={tyzdenneVyzvy} alt="Týždenné výzvy" />
              <h3>Týždenné výzvy</h3>
              <p>Pre žiakov sme pripravili testy, ktoré preskúšajú ich kritické myslenie na praktických príkladoch</p>
            </div>
            <div>
              <img src={diskusneForum} alt="Diskusné fórum" />
              <h3>Diskusné fórum</h3>
              <p>Učitelia majú možnosť v rámci triedy založiť diskusiu na aktuálne dianie, kde sa žiaci môžu vyjadriť a precvičiť si tak svoje argumentačné schopnosti</p>
            </div>
            <div>
              <img src={vzdelavanie} alt="Vzdelávanie" />
              <h3>Vzdelávanie</h3>
              <p>Učitelia aj žiaci tu môžu nájsť tipy na vzdelávacie podujatia, projekty a materiály, ktoré ich môžu posunúť ďalej</p>
            </div>
          </div>
        </section>

        <footer>
          <img src={footer} alt="Logo Slovenskej debatnej asociácie" />
        </footer>
      </main>
    </>
  )
}

export default IndexPage

export const Head: HeadFC = () => <title>Infomentor</title>
