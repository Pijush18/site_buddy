class UnitConverter:
    @staticmethod
    def mm_to_m(mm: float) -> float:
        return mm / 1000.0

    @staticmethod
    def m_to_mm(m: float) -> float:
        return m * 1000.0

    @staticmethod
    def kg_to_tonne(kg: float) -> float:
        return kg / 1000.0

    @staticmethod
    def steel_weight_kg_per_m(dia_mm: float) -> float:
        """
        Calculates standard steel weight using D^2 / 162
        """
        return (dia_mm * dia_mm) / 162.2
