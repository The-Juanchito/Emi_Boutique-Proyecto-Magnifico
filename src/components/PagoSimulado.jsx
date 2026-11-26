import { useEffect, useMemo, useRef, useState } from 'react'
import { formatoCOP } from '../data/products'
import { METODOS_SIMULADOS } from '../data/pagos'

const PASOS = [
  'Conectando con la billetera…',
  'Verificando tu cuenta…',
  'Autorizando la transacción…',
  'Confirmando el pago…',
]

// Pseudo-aleatorio determinista (para no usar Math.random durante el render).
const pseudo = (seed) => {
  const x = Math.sin(seed) * 10000
  return x - Math.floor(x)
}

export default function PagoSimulado({ metodo, total, onCerrar, onPagar, alExito }) {
  const info = METODOS_SIMULADOS[metodo] || METODOS_SIMULADOS.nequi
  const [fase, setFase] = useState('form') // form | procesando | exito | error
  const [paso, setPaso] = useState(-1)
  const [numero, setNumero] = useState('')
  const [error, setError] = useState('')
  const [pedido, setPedido] = useState(null)
  const timers = useRef([])

  useEffect(() => {
    const t = timers.current
    return () => t.forEach(clearTimeout)
  }, [])

  // Partículas de confeti con posiciones pseudo-aleatorias (solo al confirmar).
  const confeti = useMemo(
    () =>
      Array.from({ length: 22 }, (_, i) => ({
        id: i,
        left: pseudo(i + 1) * 100,
        delay: pseudo(i + 11) * 0.4,
        dur: 1 + pseudo(i + 21) * 0.8,
        color: [info.acento, '#ffd200', '#5bd1a3', '#7db4ff', '#c2577d'][i % 5],
        rot: pseudo(i + 31) * 360,
      })),
    [info.acento]
  )

  const cancelar = () => {
    if (fase === 'procesando') return
    onCerrar()
  }

  const pagar = async () => {
    if (numero.replace(/\D/g, '').length < 7) {
      setError('Ingresa un número válido (mínimo 7 dígitos).')
      return
    }
    setError('')
    setFase('procesando')
    setPaso(0)

    PASOS.forEach((_, i) => {
      timers.current.push(setTimeout(() => setPaso(i), i * 620))
    })
    // Duración mínima de la animación antes de mostrar el resultado.
    const minimo = new Promise((r) => timers.current.push(setTimeout(r, PASOS.length * 620 + 350)))

    try {
      const [p] = await Promise.all([onPagar(), minimo])
      setPedido(p)
      setFase('exito')
    } catch (e) {
      setError(e?.message || 'No se pudo completar el pago simulado.')
      setFase('error')
    }
  }

  return (
    <div className="psim-overlay" onMouseDown={cancelar}>
      <div
        className="psim"
        role="dialog"
        aria-modal="true"
        aria-label={`Pago simulado con ${info.nombre}`}
        onMouseDown={(e) => e.stopPropagation()}
      >
        <div className="psim-sim-badge">
          <i className="bi bi-exclamation-diamond" /> Pago simulado · no se cobra dinero real
        </div>

        <header className="psim-head" style={{ background: info.color, color: info.texto }}>
          <span className="psim-logo">
            <i className={`bi ${info.icono}`} /> {info.logo}
          </span>
          <button type="button" className="psim-cerrar" onClick={cancelar} aria-label="Cerrar">
            <i className="bi bi-x-lg" />
          </button>
        </header>

        {fase === 'form' && (
          <div className="psim-body">
            <div className="psim-monto">
              <span>Total a pagar</span>
              <strong>{formatoCOP(total)}</strong>
            </div>

            <label className="psim-campo">
              <span>{info.campo}</span>
              <div className="psim-input">
                <i className={`bi ${info.icono}`} />
                <input
                  type="tel"
                  inputMode="numeric"
                  placeholder={info.ayuda}
                  value={numero}
                  onChange={(e) => setNumero(e.target.value)}
                  autoFocus
                />
              </div>
            </label>

            {error && <p className="psim-error"><i className="bi bi-x-circle" /> {error}</p>}

            <button
              type="button"
              className="psim-btn"
              style={{ background: info.acento, color: metodo === 'bancolombia' ? '#111' : '#fff' }}
              onClick={pagar}
            >
              <i className="bi bi-shield-lock" /> Confirmar pago simulado
            </button>
            <small className="psim-nota">
              Demostración de la tienda. Ninguna cuenta real se ve afectada.
            </small>
          </div>
        )}

        {fase === 'procesando' && (
          <div className="psim-body psim-procesando">
            <div className="psim-phone" style={{ borderColor: info.acento }}>
              <div className="psim-phone-top" style={{ background: info.color, color: info.texto }}>
                {info.logo}
              </div>
              <div className="psim-ring" style={{ borderTopColor: info.acento }} />
              <span className="psim-phone-txt">{PASOS[Math.max(0, paso)]}</span>
            </div>
            <ul className="psim-pasos">
              {PASOS.map((p, i) => (
                <li key={p} className={i < paso ? 'ok' : i === paso ? 'activo' : ''}>
                  <i className={`bi ${i < paso ? 'bi-check-circle-fill' : 'bi-circle'}`} />
                  {p}
                </li>
              ))}
            </ul>
          </div>
        )}

        {fase === 'exito' && (
          <div className="psim-body psim-exito">
            <div className="psim-confeti">
              {confeti.map((c) => (
                <span
                  key={c.id}
                  style={{
                    left: `${c.left}%`,
                    background: c.color,
                    animationDelay: `${c.delay}s`,
                    animationDuration: `${c.dur}s`,
                    transform: `rotate(${c.rot}deg)`,
                  }}
                />
              ))}
            </div>

            <svg className="psim-check" viewBox="0 0 52 52">
              <circle className="psim-check-circulo" cx="26" cy="26" r="24" />
              <path className="psim-check-tilde" d="M14 27l8 8 16-17" />
            </svg>

            <h3>¡Pago simulado exitoso!</h3>
            <p>
              Tu pedido <b>#{pedido?.pedido_id ?? ''}</b> quedó registrado por{' '}
              <b>{formatoCOP(total)}</b> con {info.nombre}.
            </p>
            {pedido?.referencia && (
              <div className="psim-ref">
                <span>Referencia</span>
                <code>{pedido.referencia}</code>
              </div>
            )}
            <div className="psim-falso">
              <i className="bi bi-emoji-smile" /> Este pago es ficticio: no se movió dinero real.
            </div>
            <button
              type="button"
              className="psim-btn"
              style={{ background: info.acento, color: metodo === 'bancolombia' ? '#111' : '#fff' }}
              onClick={() => alExito(pedido)}
            >
              Ver mi pedido
            </button>
          </div>
        )}

        {fase === 'error' && (
          <div className="psim-body psim-error-fase">
            <i className="bi bi-emoji-frown" />
            <h3>No se pudo completar</h3>
            <p>{error}</p>
            <div className="psim-acciones">
              <button type="button" className="psim-btn ghost" onClick={cancelar}>
                Cancelar
              </button>
              <button
                type="button"
                className="psim-btn"
                style={{ background: info.acento, color: metodo === 'bancolombia' ? '#111' : '#fff' }}
                onClick={() => setFase('form')}
              >
                Intentar de nuevo
              </button>
            </div>
          </div>
        )}
      </div>
    </div>
  )
}
