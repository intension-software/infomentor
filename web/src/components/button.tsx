import * as React from "react"
import { button } from "./button.module.scss"

interface ButtonProps {
  children: React.ReactNode
  component?: "a" | "button"
  href?: string
  disabled?: boolean
  darkMode?: boolean
}

const Button: React.FC<ButtonProps> = ({ children, component = "button", href, disabled = false, darkMode = false }) => {
  if (component === "a") {
    return (
      <a type="button" href={href} className={button} aria-disabled={disabled} data-dark={darkMode}>
        {children}
      </a>
    )
  }

  return (
    <button type="button" className={button} disabled={disabled} data-dark={darkMode}>
      {children}
    </button>
  )
}

export default Button
